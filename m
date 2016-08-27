From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
Date: Sat, 27 Aug 2016 12:30:01 +1000
Message-ID: <20160827022959.303563262@telegraphics.com.au>
References: <20160827022958.983743612@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-pio-timing
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Large PIO transfers are broken up into chunks to try to avoid disabling
local IRQs for long periods. But IRQs are still disabled for too long
and this causes SCC FIFO overruns during serial port transfers. This
patch fixes the problem by halving the PIO chunk size.

Testing with mac_scsi shows that the extra NCR5380_main() loop iterations
have negligible performance impact on SCSI transfers (about 1% slower).
On a faster system (using the dmx3191d module) transfers showed no
measurable change.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-08-27 12:29:57.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2016-08-27 12:29:58.000000000 +1000
@@ -1847,11 +1847,11 @@ static void NCR5380_information_transfer
 						/* XXX - need to source or sink data here, as appropriate */
 					}
 				} else {
-					/* Break up transfer into 3 ms chunks,
-					 * presuming 6 accesses per handshake.
+					/* Transfer a small chunk so that the
+					 * irq mode lock is not held too long.
 					 */
 					transfersize = min((unsigned long)cmd->SCp.this_residual,
-					                   hostdata->accesses_per_ms / 2);
+					                   hostdata->accesses_per_ms >> 2);
 					len = transfersize;
 					NCR5380_transfer_pio(instance, &phase, &len,
 					                     (unsigned char **)&cmd->SCp.ptr);
