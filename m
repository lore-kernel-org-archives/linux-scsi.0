From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] m68k/scsi: a2091 - Do not use legacy Scsi_Host.base
Date: Mon,  3 May 2010 21:28:18 +0200
Message-ID: <1272914900-11907-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:49795 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab0ECT2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 15:28:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |   75 +++++++++++++++++++++++++++----------------------
 1 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index fc4fce9..1bb5d3f 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -16,11 +16,16 @@
 #include "a2091.h"
 
 
+struct a2091_hostdata {
+	struct WD33C93_hostdata wh;
+	struct a2091_scsiregs *regs;
+};
+
 static irqreturn_t a2091_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
-	unsigned int status = regs->ISTR;
+	struct a2091_hostdata *hdata = shost_priv(instance);
+	unsigned int status = hdata->regs->ISTR;
 	unsigned long flags;
 
 	if (!(status & (ISTR_INT_F | ISTR_INT_P)) || !(status & ISTR_INTS))
@@ -35,38 +40,39 @@ static irqreturn_t a2091_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
+	struct a2091_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a2091_scsiregs *regs = hdata->regs;
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
 	/* don't allow DMA if the physical address is bad */
 	if (addr & A2091_XFER_MASK) {
-		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
-		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
-						   GFP_KERNEL);
+		wh->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
+						GFP_KERNEL);
 
 		/* can't allocate memory; use PIO */
-		if (!hdata->dma_bounce_buffer) {
-			hdata->dma_bounce_len = 0;
+		if (!wh->dma_bounce_buffer) {
+			wh->dma_bounce_len = 0;
 			return 1;
 		}
 
 		/* get the physical address of the bounce buffer */
-		addr = virt_to_bus(hdata->dma_bounce_buffer);
+		addr = virt_to_bus(wh->dma_bounce_buffer);
 
 		/* the bounce buffer may not be in the first 16M of physmem */
 		if (addr & A2091_XFER_MASK) {
 			/* we could use chipmem... maybe later */
-			kfree(hdata->dma_bounce_buffer);
-			hdata->dma_bounce_buffer = NULL;
-			hdata->dma_bounce_len = 0;
+			kfree(wh->dma_bounce_buffer);
+			wh->dma_bounce_buffer = NULL;
+			wh->dma_bounce_len = 0;
 			return 1;
 		}
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
 			       cmd->SCp.this_residual);
 		}
 	}
@@ -76,7 +82,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= CNTR_DDIR;
 
 	/* remember direction */
-	hdata->dma_dir = dir_in;
+	wh->dma_dir = dir_in;
 
 	regs->CNTR = cntr;
 
@@ -100,20 +106,21 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
+	struct a2091_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a2091_scsiregs *regs = hdata->regs;
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
 
-	if (!hdata->dma_dir)
+	if (!wh->dma_dir)
 		cntr |= CNTR_DDIR;
 
 	/* disable SCSI interrupts */
 	regs->CNTR = cntr;
 
 	/* flush if we were reading */
-	if (hdata->dma_dir) {
+	if (wh->dma_dir) {
 		regs->FLUSH = 1;
 		while (!(regs->ISTR & ISTR_FE_FLG))
 			;
@@ -129,13 +136,13 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && hdata->dma_bounce_buffer) {
-		if (hdata->dma_dir)
-			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
+	if (status && wh->dma_bounce_buffer) {
+		if (wh->dma_dir)
+			memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
 			       SCpnt->SCp.this_residual);
-		kfree(hdata->dma_bounce_buffer);
-		hdata->dma_bounce_buffer = NULL;
-		hdata->dma_bounce_len = 0;
+		kfree(wh->dma_bounce_buffer);
+		wh->dma_bounce_buffer = NULL;
+		wh->dma_bounce_len = 0;
 	}
 }
 
@@ -178,32 +185,32 @@ static int __devinit a2091_probe(struct zorro_dev *z,
 	int error;
 	struct a2091_scsiregs *regs;
 	wd33c93_regs wdregs;
-	struct WD33C93_hostdata *hdata;
+	struct a2091_hostdata *hdata;
 
 	if (!request_mem_region(z->resource.start, 256, "wd33c93"))
 		return -EBUSY;
 
 	instance = scsi_host_alloc(&a2091_scsi_template,
-				   sizeof(struct WD33C93_hostdata));
+				   sizeof(struct a2091_hostdata));
 	if (!instance) {
 		error = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	instance->base = ZTWO_VADDR(z->resource.start);
 	instance->irq = IRQ_AMIGA_PORTS;
 	instance->unique_id = z->slotaddr;
 
-	regs = (struct a2091_scsiregs *)(instance->base);
+	regs = (struct a2091_scsiregs *)ZTWO_VADDR(z->resource.start);
 	regs->DAWR = DAWR_A2091;
 
 	wdregs.SASR = &regs->SASR;
 	wdregs.SCMD = &regs->SCMD;
 
 	hdata = shost_priv(instance);
-	hdata->no_sync = 0xff;
-	hdata->fast = 0;
-	hdata->dma_mode = CTRL_DMA;
+	hdata->wh.no_sync = 0xff;
+	hdata->wh.fast = 0;
+	hdata->wh.dma_mode = CTRL_DMA;
+	hdata->regs = regs;
 
 	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_8_10);
 	error = request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
@@ -234,9 +241,9 @@ fail_alloc:
 static void __devexit a2091_remove(struct zorro_dev *z)
 {
 	struct Scsi_Host *instance = zorro_get_drvdata(z);
-	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
+	struct a2091_hostdata *hdata = shost_priv(instance);
 
-	regs->CNTR = 0;
+	hdata->regs->CNTR = 0;
 	scsi_remove_host(instance);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 	scsi_host_put(instance);
-- 
1.6.0.4

