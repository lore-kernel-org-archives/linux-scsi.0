From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/21] m68k/scsi: gvp11 - Kill ugly DMA() macro
Date: Sun,  4 Apr 2010 11:00:41 +0200
Message-ID: <1270371651-2584-12-git-send-email-geert@linux-m68k.org>
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
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |   52 ++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index b370591..5f07648 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -21,15 +21,13 @@
 #include <linux/stat.h>
 
 
-#define DMA(ptr)	((gvp11_scsiregs *)((ptr)->base))
-
-static irqreturn_t gvp11_intr(int irq, void *_instance)
+static irqreturn_t gvp11_intr(int irq, void *data)
 {
+	struct Scsi_Host *instance = data;
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+	unsigned int status = regs->CNTR;
 	unsigned long flags;
-	unsigned int status;
-	struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
 
-	status = DMA(instance)->CNTR;
 	if (!(status & GVP11_DMAC_INT_PENDING))
 		return IRQ_NONE;
 
@@ -50,6 +48,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
 	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 	int bank_mask;
@@ -116,10 +115,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= GVP11_DMAC_DIR_WRITE;
 
 	hdata->dma_dir = dir_in;
-	DMA(cmd->device->host)->CNTR = cntr;
+	regs->CNTR = cntr;
 
 	/* setup DMA *physical* address */
-	DMA(cmd->device->host)->ACR = addr;
+	regs->ACR = addr;
 
 	if (dir_in) {
 		/* invalidate any cache */
@@ -131,10 +130,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 
 	bank_mask = (~hdata->dma_xfer_mask >> 18) & 0x01c0;
 	if (bank_mask)
-		DMA(cmd->device->host)->BANK = bank_mask & (addr >> 18);
+		regs->BANK = bank_mask & (addr >> 18);
 
 	/* start DMA */
-	DMA(cmd->device->host)->ST_DMA = 1;
+	regs->ST_DMA = 1;
 
 	/* return success */
 	return 0;
@@ -143,12 +142,13 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
 
 	/* stop DMA */
-	DMA(instance)->SP_DMA = 1;
+	regs->SP_DMA = 1;
 	/* remove write bit from CONTROL bits */
-	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
+	regs->CNTR = GVP11_DMAC_INT_ENABLE;
 
 	/* copy from a bounce buffer, if necessary */
 	if (status && hdata->dma_bounce_buffer) {
@@ -177,7 +177,8 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	struct zorro_dev *z = NULL;
 	unsigned int default_dma_xfer_mask;
 	struct WD33C93_hostdata *hdata;
-	wd33c93_regs regs;
+	gvp11_scsiregs *regs;
+	wd33c93_regs wdregs;
 	int num_gvp11 = 0;
 #ifdef CHECK_WD33C93
 	volatile unsigned char *sasr_3393, *scmd_3393;
@@ -309,33 +310,34 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		else
 			hdata->dma_xfer_mask = default_dma_xfer_mask;
 
-		DMA(instance)->secret2 = 1;
-		DMA(instance)->secret1 = 0;
-		DMA(instance)->secret3 = 15;
-		while (DMA(instance)->CNTR & GVP11_DMAC_BUSY)
+		regs = (gvp11_scsiregs *)(instance->base);
+		regs->secret2 = 1;
+		regs->secret1 = 0;
+		regs->secret3 = 15;
+		while (regs->CNTR & GVP11_DMAC_BUSY)
 			;
-		DMA(instance)->CNTR = 0;
+		regs->CNTR = 0;
 
-		DMA(instance)->BANK = 0;
+		regs->BANK = 0;
 
 		epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
 
 		/*
 		 * Check for 14MHz SCSI clock
 		 */
-		regs.SASR = &(DMA(instance)->SASR);
-		regs.SCMD = &(DMA(instance)->SCMD);
+		wdregs.SASR = &regs->SASR;
+		wdregs.SCMD = &regs->SCMD;
 		hdata->no_sync = 0xff;
 		hdata->fast = 0;
 		hdata->dma_mode = CTRL_DMA;
-		wd33c93_init(instance, regs, dma_setup, dma_stop,
+		wd33c93_init(instance, wdregs, dma_setup, dma_stop,
 			     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 						     : WD33C93_FS_12_15);
 
 		if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED,
 				"GVP11 SCSI", instance))
 			goto unregister;
-		DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
+		regs->CNTR = GVP11_DMAC_INT_ENABLE;
 		num_gvp11++;
 		continue;
 
@@ -390,7 +392,9 @@ static struct scsi_host_template driver_template = {
 int gvp11_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-	DMA(instance)->CNTR = 0;
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+
+	regs->CNTR = 0;
 	release_mem_region(ZTWO_PADDR(instance->base), 256);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 #endif
-- 
1.6.0.4
