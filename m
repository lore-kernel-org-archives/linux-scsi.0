From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 38/77] ncr5380: Remove UNSAFE macro
Date: Tue, 22 Dec 2015 12:18:16 +1100
Message-ID: <20151222011748.365505398@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-UNSAFE-macro
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Configuring core drivers using macros like this one prevents re-unifying
the core driver forks, and prevents implementing the core driver as a
library or a platform driver.

The UNSAFE macro in particular is a poor workaround for the problem of
interrupt latency. Releasing the locks complicates things because then we
would have to handle the possibility of EH handler invocation during a
PDMA transfer.

The comments say that instead of using this macro, "you're going to be
better off twiddling with transfersize". I agree. Remove this stuff.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |   15 ---------------
 drivers/scsi/dtc.c     |    2 --
 drivers/scsi/pas16.c   |    1 -
 3 files changed, 18 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:24.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:27.000000000 +1100
@@ -195,12 +195,6 @@
  *      rely on phase mismatch and EOP interrupts to determine end 
  *      of phase.
  *
- * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  You
- *          only really want to use this if you're having a problem with
- *          dropped characters during high speed communications, and even
- *          then, you're going to be better off twiddling with transfersize
- *          in the high level code.
- *
  * Defaults for these will be provided although the user may want to adjust 
  * these to allocate CPU resources to the SCSI driver or "real" code.
  * 
@@ -554,9 +548,6 @@ static void prepare_info(struct Scsi_Hos
 #ifdef PSEUDO_DMA
 	         "PSEUDO_DMA "
 #endif
-#ifdef UNSAFE
-	         "UNSAFE "
-#endif
 	         "");
 }
 
@@ -1582,9 +1573,6 @@ static int NCR5380_transfer_dma(struct S
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
-#if defined(PSEUDO_DMA) && defined(UNSAFE)
-	spin_unlock_irq(instance->host_lock);
-#endif
 	/* KLL May need eop and parity in 53c400 */
 	if (hostdata->flags & FLAG_NCR53C400)
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE |
@@ -1793,9 +1781,6 @@ static int NCR5380_transfer_dma(struct S
 	*data = d + c;
 	*count = 0;
 	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
-#if defined(PSEUDO_DMA) && defined(UNSAFE)
-	spin_lock_irq(instance->host_lock);
-#endif				/* defined(REAL_DMA_POLL) */
 	return foo;
 #endif				/* def REAL_DMA */
 }
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-12-22 12:16:07.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-12-22 12:16:27.000000000 +1100
@@ -1,7 +1,5 @@
-
 #define PSEUDO_DMA
 #define DONT_USE_INTR
-#define UNSAFE			/* Leave interrupts enabled during pseudo-dma I/O */
 #define DMA_WORKS_RIGHT
 
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-12-22 12:15:56.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-12-22 12:16:27.000000000 +1100
@@ -1,5 +1,4 @@
 #define PSEUDO_DMA
-#define UNSAFE  /* Not unsafe for PAS16 -- use it */
 
 /*
  * This driver adapted from Drew Eckhardt's Trantor T128 driver
