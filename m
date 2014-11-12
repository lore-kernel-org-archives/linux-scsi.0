From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 27/37] ncr5380: Remove ENABLE_IRQ/DISABLE_IRQ macros
Date: Wed, 12 Nov 2014 16:12:13 +1100
Message-ID: <20141112051152.865479291@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40986 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaKLFnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:20 -0500
Content-Disposition: inline; filename=ncr5380-remove-ENABLE_IRQ-DISABLE_IRQ
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

atari_NCR5380.c enables its IRQ when it is already enabled. Sun3 doesn't
use the ENABLE_IRQ/DISABLE_IRQ cruft. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_NCR5380.c |    2 --
 drivers/scsi/atari_scsi.c    |   21 ---------------------
 drivers/scsi/sun3_NCR5380.c  |    2 --
 drivers/scsi/sun3_scsi.c     |    7 -------
 4 files changed, 32 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:25.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:31.000000000 +1100
@@ -1227,7 +1227,6 @@ static irqreturn_t NCR5380_intr(int irq,
 		NCR5380_dprint(NDEBUG_INTR, instance);
 		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 			done = 0;
-			ENABLE_IRQ();
 			dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
 			NCR5380_reselect(instance);
 			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -1257,7 +1256,6 @@ static irqreturn_t NCR5380_intr(int irq,
 				dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 				NCR5380_dma_complete( instance );
 				done = 0;
-				ENABLE_IRQ();
 			} else
 #endif /* REAL_DMA */
 			{
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:11:28.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:11:31.000000000 +1100
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
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:11:16.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:11:31.000000000 +1100
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
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:30.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:31.000000000 +1100
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


