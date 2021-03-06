#' Pool Pearson correlation coefficients
#'
#' @param rVec A vector of correlation coefficients
#' @param N The number of imputations
#' @return A vector of pooled r's
#'
#' @export pool.r
pool.r <- function (rVec, N)
{
   if ((m <- length(rVec)) < 2)
    stop("At least two imputations are needed for pooling.\n")

  r <- matrix(NA,
              nrow = m,
              ncol = 3,
              dimnames = list(seq_len(m), c("r", "Z", "se")))

  r[,"r"] <- rVec
  r[,"Z"] <- atanh(rVec)
  r[,"se"] <- 1/(N - 3)

  poolObj <- mice::pool.scalar(Q=r[,"Z"], U=r[,"se"], n=N)

  zPool <- poolObj$qbar

  table <- tanh(zPool)

  # Component t is the total variance of the pooled estimated, formula (3.1.5) Rubin (1987)
  table[2] <- tanh( zPool - 1.96 * sqrt(poolObj$t) )
  table[3] <- tanh( zPool + 1.96 * sqrt(poolObj$t) )
  table[4] <- poolObj$fmi

  names(table) <- c("rPool","lo95", "hi95", "fmi")

  return(table)
}
