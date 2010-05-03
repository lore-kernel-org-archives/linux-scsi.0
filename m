From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] m68k/scsi: a3000 - Do not use legacy Scsi_Host.base
Date: Mon,  3 May 2010 21:28:19 +0200
Message-ID: <1272914900-11907-2-git-send-email-geert@linux-m68k.org>
References: <1272914900-11907-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:51292 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab0ECT2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 15:28:22 -0400
In-Reply-To: <1272914900-11907-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   76 +++++++++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 7f09d89..d946802 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -17,11 +17,16 @@
 #include "a3000.h"
 
 
+struct a3000_hostdata {
+	struct WD33C93_hostdata wh;
+	struct a3000_scsiregs *regs;
+};
+
 static irqreturn_t a3000_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
-	unsigned int status = regs->ISTR;
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	unsigned int status = hdata->regs->ISTR;
 	unsigned long flags;
 
 	if (!(status & ISTR_INT_P))
@@ -39,8 +44,9 @@ static irqreturn_t a3000_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a3000_scsiregs *regs = hdata->regs;
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -51,23 +57,23 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	 * buffer
 	 */
 	if (addr & A3000_XFER_MASK) {
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
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
 			       cmd->SCp.this_residual);
 		}
 
-		addr = virt_to_bus(hdata->dma_bounce_buffer);
+		addr = virt_to_bus(wh->dma_bounce_buffer);
 	}
 
 	/* setup dma direction */
@@ -75,7 +81,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= CNTR_DDIR;
 
 	/* remember direction */
-	hdata->dma_dir = dir_in;
+	wh->dma_dir = dir_in;
 
 	regs->CNTR = cntr;
 
@@ -102,20 +108,21 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a3000_scsiregs *regs = hdata->regs;
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
 
-	if (!hdata->dma_dir)
+	if (!wh->dma_dir)
 		cntr |= CNTR_DDIR;
 
 	regs->CNTR = cntr;
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* flush if we were reading */
-	if (hdata->dma_dir) {
+	if (wh->dma_dir) {
 		regs->FLUSH = 1;
 		mb();		/* don't allow prefetch */
 		while (!(regs->ISTR & ISTR_FE_FLG))
@@ -138,19 +145,18 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && hdata->dma_bounce_buffer) {
+	if (status && wh->dma_bounce_buffer) {
 		if (SCpnt) {
-			if (hdata->dma_dir && SCpnt)
-				memcpy(SCpnt->SCp.ptr,
-				       hdata->dma_bounce_buffer,
+			if (wh->dma_dir && SCpnt)
+				memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
 				       SCpnt->SCp.this_residual);
-			kfree(hdata->dma_bounce_buffer);
-			hdata->dma_bounce_buffer = NULL;
-			hdata->dma_bounce_len = 0;
+			kfree(wh->dma_bounce_buffer);
+			wh->dma_bounce_buffer = NULL;
+			wh->dma_bounce_len = 0;
 		} else {
-			kfree(hdata->dma_bounce_buffer);
-			hdata->dma_bounce_buffer = NULL;
-			hdata->dma_bounce_len = 0;
+			kfree(wh->dma_bounce_buffer);
+			wh->dma_bounce_buffer = NULL;
+			wh->dma_bounce_len = 0;
 		}
 	}
 }
@@ -194,7 +200,7 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 	int error;
 	struct a3000_scsiregs *regs;
 	wd33c93_regs wdregs;
-	struct WD33C93_hostdata *hdata;
+	struct a3000_hostdata *hdata;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -204,25 +210,25 @@ static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	instance = scsi_host_alloc(&amiga_a3000_scsi_template,
-				   sizeof(struct WD33C93_hostdata));
+				   sizeof(struct a3000_hostdata));
 	if (!instance) {
 		error = -ENOMEM;
 		goto fail_alloc;
 	}
 
-	instance->base = ZTWO_VADDR(res->start);
 	instance->irq = IRQ_AMIGA_PORTS;
 
-	regs = (struct a3000_scsiregs *)(instance->base);
+	regs = (struct a3000_scsiregs *)ZTWO_VADDR(res->start);
 	regs->DAWR = DAWR_A3000;
 
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
 
 	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_12_15);
 	error = request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED,
@@ -253,10 +259,10 @@ fail_alloc:
 static int __exit amiga_a3000_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance = platform_get_drvdata(pdev);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	regs->CNTR = 0;
+	hdata->regs->CNTR = 0;
 	scsi_remove_host(instance);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 	scsi_host_put(instance);
-- 
1.6.0.4

