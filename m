From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 12/21] m68k/scsi: a3000 - Kill ugly DMA() macro
Date: Sun,  4 Apr 2010 11:00:42 +0200
Message-ID: <1270371651-2584-13-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-12-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-12-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 44087a0..296b58b 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -21,16 +21,15 @@
 #include <linux/stat.h>
 
 
-#define DMA(ptr)	((a3000_scsiregs *)((ptr)->base))
-
 static struct Scsi_Host *a3000_host = NULL;
 
 static int a3000_release(struct Scsi_Host *instance);
 
 static irqreturn_t a3000_intr(int irq, void *dummy)
 {
+	a3000_scsiregs *regs = (a3000_scsiregs *)(a3000_host->base);
+	unsigned int status = regs->ISTR;
 	unsigned long flags;
-	unsigned int status = DMA(a3000_host)->ISTR;
 
 	if (!(status & ISTR_INT_P))
 		return IRQ_NONE;
@@ -47,6 +46,7 @@ static irqreturn_t a3000_intr(int irq, void *dummy)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct WD33C93_hostdata *hdata = shost_priv(a3000_host);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(a3000_host->base);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -83,10 +83,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* remember direction */
 	hdata->dma_dir = dir_in;
 
-	DMA(a3000_host)->CNTR = cntr;
+	regs->CNTR = cntr;
 
 	/* setup DMA *physical* address */
-	DMA(a3000_host)->ACR = addr;
+	regs->ACR = addr;
 
 	if (dir_in) {
 		/* invalidate any cache */
@@ -98,7 +98,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 
 	/* start DMA */
 	mb();			/* make sure setup is completed */
-	DMA(a3000_host)->ST_DMA = 1;
+	regs->ST_DMA = 1;
 	mb();			/* make sure DMA has started before next IO */
 
 	/* return success */
@@ -109,6 +109,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
@@ -116,14 +117,14 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	if (!hdata->dma_dir)
 		cntr |= CNTR_DDIR;
 
-	DMA(instance)->CNTR = cntr;
+	regs->CNTR = cntr;
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* flush if we were reading */
 	if (hdata->dma_dir) {
-		DMA(instance)->FLUSH = 1;
+		regs->FLUSH = 1;
 		mb();		/* don't allow prefetch */
-		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
+		while (!(regs->ISTR & ISTR_FE_FLG))
 			barrier();
 		mb();		/* no IO until FLUSH is done */
 	}
@@ -132,14 +133,14 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	/* I think that this CINT is only necessary if you are
 	 * using the terminal count features.   HM 7 Mar 1994
 	 */
-	DMA(instance)->CINT = 1;
+	regs->CINT = 1;
 
 	/* stop DMA */
-	DMA(instance)->SP_DMA = 1;
+	regs->SP_DMA = 1;
 	mb();			/* make sure DMA is stopped before next IO */
 
 	/* restore the CONTROL bits (minus the direction flag) */
-	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* copy from a bounce buffer, if necessary */
@@ -162,7 +163,8 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 
 static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
-	wd33c93_regs regs;
+	wd33c93_regs wdregs;
+	a3000_scsiregs *regs;
 	struct WD33C93_hostdata *hdata;
 
 	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
@@ -179,18 +181,20 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
 
 	a3000_host->base = ZTWO_VADDR(0xDD0000);
 	a3000_host->irq = IRQ_AMIGA_PORTS;
-	DMA(a3000_host)->DAWR = DAWR_A3000;
-	regs.SASR = &(DMA(a3000_host)->SASR);
-	regs.SCMD = &(DMA(a3000_host)->SCMD);
+	regs = (a3000_scsiregs *)(a3000_host->base);
+	regs->DAWR = DAWR_A3000;
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
 	hdata = shost_priv(a3000_host);
 	hdata->no_sync = 0xff;
 	hdata->fast = 0;
 	hdata->dma_mode = CTRL_DMA;
-	wd33c93_init(a3000_host, regs, dma_setup, dma_stop, WD33C93_FS_12_15);
+	wd33c93_init(a3000_host, wdregs, dma_setup, dma_stop,
+		     WD33C93_FS_12_15);
 	if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
 			a3000_intr))
 		goto fail_irq;
-	DMA(a3000_host)->CNTR = CNTR_PDMD | CNTR_INTEN;
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
 	return 1;
 
@@ -238,7 +242,9 @@ static struct scsi_host_template driver_template = {
 
 static int a3000_release(struct Scsi_Host *instance)
 {
-	DMA(instance)->CNTR = 0;
+	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
+
+	regs->CNTR = 0;
 	release_mem_region(0xDD0000, 256);
 	free_irq(IRQ_AMIGA_PORTS, a3000_intr);
 	return 1;
-- 
1.6.0.4
