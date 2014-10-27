From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 27/36] ncr5380: Remove ENABLE_IRQ/DISABLE_IRQ macros
Date: Mon, 27 Oct 2014 16:26:34 +1100
Message-ID: <20141027052613.635436606@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-ENABLE_IRQ-DISABLE_IRQ
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

atari_NCR5380.c enables its IRQ when it is already enabled. Sun3 doesn't
use the ENABLE_IRQ/DISABLE_IRQ cruft. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |    2 --
 drivers/scsi/atari_scsi.c    |   21 ---------------------
 drivers/scsi/sun3_NCR5380.c  |    2 --
 drivers/scsi/sun3_scsi.c     |    7 -------
 4 files changed, 32 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:45.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:52.000000000 +1100
@@ -1229,7 +1229,6 @@ static irqreturn_t NCR5380_intr(int irq,
 		NCR5380_dprint(NDEBUG_INTR, instance);
 		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 			done = 0;
-			ENABLE_IRQ();
 			dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 			NCR5380_reselect(instance);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -1259,7 +1258,6 @@ static irqreturn_t NCR5380_intr(int irq,
 				dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 				NCR5380_dma_complete( instance );
 				done = 0;
-				ENABLE_IRQ();
 			} else
 #endif /* REAL_DMA */
 			{
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:49.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:52.000000000 +1100
@@ -157,23 +157,6 @@ static inline unsigned long SCSI_DMA_GET
 	return adr;
 }
 
-static inline void ENABLE_IRQ(void)
-{
-	if (IS_A_TT())
-		atari_enable_irq(IRQ_TT_MFP_SCSI);
-	else
-		atari_enable_irq(IRQ_MFP_FSCSI);
-}
-
-static inline void DISABLE_IRQ(void)
-{
-	if (IS_A_TT())
-		atari_disable_irq(IRQ_TT_MFP_SCSI);
-	else
-		atari_disable_irq(IRQ_MFP_FSCSI);
-}
-
-
 #define HOSTDATA_DMALEN		(((struct NCR5380_hostdata *) \
 				(atari_scsi_host->hostdata))->dma_len)
 
@@ -373,10 +356,6 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 	NCR5380_intr(irq, dummy);
 
-#if 0
-	/* To be sure the int is not masked */
-	atari_enable_irq(IRQ_TT_MFP_SCSI);
-#endif
 	return IRQ_HANDLED;
 }
 
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:25:36.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:25:52.000000000 +1100
@@ -1155,7 +1155,6 @@ static irqreturn_t NCR5380_intr (int irq
 	NCR5380_dprint(NDEBUG_INTR, instance);
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 	    done = 0;
-//	    ENABLE_IRQ();
 	    dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 	    NCR5380_reselect(instance);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -1188,7 +1187,6 @@ static irqreturn_t NCR5380_intr (int irq
 		dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 		NCR5380_dma_complete( instance );
 		done = 0;
-//		ENABLE_IRQ();
 	    } else
 #endif /* REAL_DMA */
 	    {
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:51.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:52.000000000 +1100
@@ -69,13 +69,6 @@
 
 extern int sun3_map_test(unsigned long, char *);
 
-#ifdef SUN3_SCSI_VME
-#define ENABLE_IRQ()
-#else
-#define	ENABLE_IRQ()	enable_irq( IRQ_SUN3_SCSI ); 
-#endif
-
-
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
 static int setup_cmd_per_lun = -1;
