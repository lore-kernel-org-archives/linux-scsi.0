From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] m68k/scsi: gvp11 - Do not use legacy Scsi_Host.base
Date: Mon,  3 May 2010 21:28:20 +0200
Message-ID: <1272914900-11907-3-git-send-email-geert@linux-m68k.org>
References: <1272914900-11907-1-git-send-email-geert@linux-m68k.org>
 <1272914900-11907-2-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1272914900-11907-2-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |  105 ++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 4507a16..2ce26eb 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -18,11 +18,16 @@
 
 #define CHECK_WD33C93
 
+struct gvp11_hostdata {
+	struct WD33C93_hostdata wh;
+	struct gvp11_scsiregs *regs;
+};
+
 static irqreturn_t gvp11_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
-	unsigned int status = regs->CNTR;
+	struct gvp11_hostdata *hdata = shost_priv(instance);
+	unsigned int status = hdata->regs->CNTR;
 	unsigned long flags;
 
 	if (!(status & GVP11_DMAC_INT_PENDING))
@@ -44,65 +49,66 @@ void gvp11_setup(char *str, int *ints)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
+	struct gvp11_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct gvp11_scsiregs *regs = hdata->regs;
 	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 	int bank_mask;
 	static int scsi_alloc_out_of_range = 0;
 
 	/* use bounce buffer if the physical address is bad */
-	if (addr & hdata->dma_xfer_mask) {
-		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+	if (addr & wh->dma_xfer_mask) {
+		wh->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
 
 		if (!scsi_alloc_out_of_range) {
-			hdata->dma_bounce_buffer =
-				kmalloc(hdata->dma_bounce_len, GFP_KERNEL);
-			hdata->dma_buffer_pool = BUF_SCSI_ALLOCED;
+			wh->dma_bounce_buffer =
+				kmalloc(wh->dma_bounce_len, GFP_KERNEL);
+			wh->dma_buffer_pool = BUF_SCSI_ALLOCED;
 		}
 
 		if (scsi_alloc_out_of_range ||
-		    !hdata->dma_bounce_buffer) {
-			hdata->dma_bounce_buffer =
-				amiga_chip_alloc(hdata->dma_bounce_len,
+		    !wh->dma_bounce_buffer) {
+			wh->dma_bounce_buffer =
+				amiga_chip_alloc(wh->dma_bounce_len,
 						 "GVP II SCSI Bounce Buffer");
 
-			if (!hdata->dma_bounce_buffer) {
-				hdata->dma_bounce_len = 0;
+			if (!wh->dma_bounce_buffer) {
+				wh->dma_bounce_len = 0;
 				return 1;
 			}
 
-			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
+			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
 		/* check if the address of the bounce buffer is OK */
-		addr = virt_to_bus(hdata->dma_bounce_buffer);
+		addr = virt_to_bus(wh->dma_bounce_buffer);
 
-		if (addr & hdata->dma_xfer_mask) {
+		if (addr & wh->dma_xfer_mask) {
 			/* fall back to Chip RAM if address out of range */
-			if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED) {
-				kfree(hdata->dma_bounce_buffer);
+			if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED) {
+				kfree(wh->dma_bounce_buffer);
 				scsi_alloc_out_of_range = 1;
 			} else {
-				amiga_chip_free(hdata->dma_bounce_buffer);
+				amiga_chip_free(wh->dma_bounce_buffer);
 			}
 
-			hdata->dma_bounce_buffer =
-				amiga_chip_alloc(hdata->dma_bounce_len,
+			wh->dma_bounce_buffer =
+				amiga_chip_alloc(wh->dma_bounce_len,
 						 "GVP II SCSI Bounce Buffer");
 
-			if (!hdata->dma_bounce_buffer) {
-				hdata->dma_bounce_len = 0;
+			if (!wh->dma_bounce_buffer) {
+				wh->dma_bounce_len = 0;
 				return 1;
 			}
 
-			addr = virt_to_bus(hdata->dma_bounce_buffer);
-			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
+			addr = virt_to_bus(wh->dma_bounce_buffer);
+			wh->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
 			       cmd->SCp.this_residual);
 		}
 	}
@@ -111,7 +117,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	if (!dir_in)
 		cntr |= GVP11_DMAC_DIR_WRITE;
 
-	hdata->dma_dir = dir_in;
+	wh->dma_dir = dir_in;
 	regs->CNTR = cntr;
 
 	/* setup DMA *physical* address */
@@ -125,7 +131,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cache_push(addr, cmd->SCp.this_residual);
 	}
 
-	bank_mask = (~hdata->dma_xfer_mask >> 18) & 0x01c0;
+	bank_mask = (~wh->dma_xfer_mask >> 18) & 0x01c0;
 	if (bank_mask)
 		regs->BANK = bank_mask & (addr >> 18);
 
@@ -139,8 +145,9 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	struct gvp11_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct gvp11_scsiregs *regs = hdata->regs;
 
 	/* stop DMA */
 	regs->SP_DMA = 1;
@@ -148,18 +155,18 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	regs->CNTR = GVP11_DMAC_INT_ENABLE;
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && hdata->dma_bounce_buffer) {
-		if (hdata->dma_dir && SCpnt)
-			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
+	if (status && wh->dma_bounce_buffer) {
+		if (wh->dma_dir && SCpnt)
+			memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
 			       SCpnt->SCp.this_residual);
 
-		if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED)
-			kfree(hdata->dma_bounce_buffer);
+		if (wh->dma_buffer_pool == BUF_SCSI_ALLOCED)
+			kfree(wh->dma_bounce_buffer);
 		else
-			amiga_chip_free(hdata->dma_bounce_buffer);
+			amiga_chip_free(wh->dma_bounce_buffer);
 
-		hdata->dma_bounce_buffer = NULL;
-		hdata->dma_bounce_len = 0;
+		wh->dma_bounce_buffer = NULL;
+		wh->dma_bounce_len = 0;
 	}
 }
 
@@ -284,7 +291,7 @@ static int __devinit gvp11_probe(struct zorro_dev *z,
 	int error;
 	unsigned int epc;
 	unsigned int default_dma_xfer_mask;
-	struct WD33C93_hostdata *hdata;
+	struct gvp11_hostdata *hdata;
 	struct gvp11_scsiregs *regs;
 	wd33c93_regs wdregs;
 
@@ -309,13 +316,12 @@ static int __devinit gvp11_probe(struct zorro_dev *z,
 		goto fail_check_or_alloc;
 
 	instance = scsi_host_alloc(&gvp11_scsi_template,
-				   sizeof(struct WD33C93_hostdata));
+				   sizeof(struct gvp11_hostdata));
 	if (!instance) {
 		error = -ENOMEM;
 		goto fail_check_or_alloc;
 	}
 
-	instance->base = (unsigned long)regs;
 	instance->irq = IRQ_AMIGA_PORTS;
 	instance->unique_id = z->slotaddr;
 
@@ -332,13 +338,14 @@ static int __devinit gvp11_probe(struct zorro_dev *z,
 
 	hdata = shost_priv(instance);
 	if (gvp11_xfer_mask)
-		hdata->dma_xfer_mask = gvp11_xfer_mask;
+		hdata->wh.dma_xfer_mask = gvp11_xfer_mask;
 	else
-		hdata->dma_xfer_mask = default_dma_xfer_mask;
+		hdata->wh.dma_xfer_mask = default_dma_xfer_mask;
 
-	hdata->no_sync = 0xff;
-	hdata->fast = 0;
-	hdata->dma_mode = CTRL_DMA;
+	hdata->wh.no_sync = 0xff;
+	hdata->wh.fast = 0;
+	hdata->wh.dma_mode = CTRL_DMA;
+	hdata->regs = regs;
 
 	/*
 	 * Check for 14MHz SCSI clock
@@ -375,9 +382,9 @@ fail_check_or_alloc:
 static void __devexit gvp11_remove(struct zorro_dev *z)
 {
 	struct Scsi_Host *instance = zorro_get_drvdata(z);
-	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
+	struct gvp11_hostdata *hdata = shost_priv(instance);
 
-	regs->CNTR = 0;
+	hdata->regs->CNTR = 0;
 	scsi_remove_host(instance);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 	scsi_host_put(instance);
-- 
1.6.0.4
