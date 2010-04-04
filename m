From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/21] m68k/scsi: gvp11 - Use shost_priv() and kill ugly HDATA() macro
Date: Sun,  4 Apr 2010 11:00:37 +0200
Message-ID: <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |   93 ++++++++++++++++++++++++-------------------------
 1 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 6ec7520..b370591 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -22,7 +22,6 @@
 
 
 #define DMA(ptr)	((gvp11_scsiregs *)((ptr)->base))
-#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static irqreturn_t gvp11_intr(int irq, void *_instance)
 {
@@ -49,70 +48,66 @@ void gvp11_setup(char *str, int *ints)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
+	struct Scsi_Host *instance = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
 	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 	int bank_mask;
 	static int scsi_alloc_out_of_range = 0;
 
 	/* use bounce buffer if the physical address is bad */
-	if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
-		HDATA(cmd->device->host)->dma_bounce_len =
-			(cmd->SCp.this_residual + 511) & ~0x1ff;
+	if (addr & hdata->dma_xfer_mask) {
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
 
 		if (!scsi_alloc_out_of_range) {
-			HDATA(cmd->device->host)->dma_bounce_buffer =
-				kmalloc(HDATA(cmd->device->host)->dma_bounce_len,
-					GFP_KERNEL);
-			HDATA(cmd->device->host)->dma_buffer_pool =
-				BUF_SCSI_ALLOCED;
+			hdata->dma_bounce_buffer =
+				kmalloc(hdata->dma_bounce_len, GFP_KERNEL);
+			hdata->dma_buffer_pool = BUF_SCSI_ALLOCED;
 		}
 
 		if (scsi_alloc_out_of_range ||
-		    !HDATA(cmd->device->host)->dma_bounce_buffer) {
-			HDATA(cmd->device->host)->dma_bounce_buffer =
-				amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
+		    !hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_buffer =
+				amiga_chip_alloc(hdata->dma_bounce_len,
 						 "GVP II SCSI Bounce Buffer");
 
-			if (!HDATA(cmd->device->host)->dma_bounce_buffer) {
-				HDATA(cmd->device->host)->dma_bounce_len = 0;
+			if (!hdata->dma_bounce_buffer) {
+				hdata->dma_bounce_len = 0;
 				return 1;
 			}
 
-			HDATA(cmd->device->host)->dma_buffer_pool =
-				BUF_CHIP_ALLOCED;
+			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
 		/* check if the address of the bounce buffer is OK */
-		addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
 
-		if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
+		if (addr & hdata->dma_xfer_mask) {
 			/* fall back to Chip RAM if address out of range */
-			if (HDATA(cmd->device->host)->dma_buffer_pool ==
-			    BUF_SCSI_ALLOCED) {
-				kfree(HDATA(cmd->device->host)->dma_bounce_buffer);
+			if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED) {
+				kfree(hdata->dma_bounce_buffer);
 				scsi_alloc_out_of_range = 1;
 			} else {
-				amiga_chip_free(HDATA(cmd->device->host)->dma_bounce_buffer);
+				amiga_chip_free(hdata->dma_bounce_buffer);
 			}
 
-			HDATA(cmd->device->host)->dma_bounce_buffer =
-				amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
+			hdata->dma_bounce_buffer =
+				amiga_chip_alloc(hdata->dma_bounce_len,
 						 "GVP II SCSI Bounce Buffer");
 
-			if (!HDATA(cmd->device->host)->dma_bounce_buffer) {
-				HDATA(cmd->device->host)->dma_bounce_len = 0;
+			if (!hdata->dma_bounce_buffer) {
+				hdata->dma_bounce_len = 0;
 				return 1;
 			}
 
-			addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
-			HDATA(cmd->device->host)->dma_buffer_pool =
-				BUF_CHIP_ALLOCED;
+			addr = virt_to_bus(hdata->dma_bounce_buffer);
+			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
 		}
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(HDATA(cmd->device->host)->dma_bounce_buffer,
-			       cmd->SCp.ptr, cmd->SCp.this_residual);
+			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			       cmd->SCp.this_residual);
 		}
 	}
 
@@ -120,7 +115,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	if (!dir_in)
 		cntr |= GVP11_DMAC_DIR_WRITE;
 
-	HDATA(cmd->device->host)->dma_dir = dir_in;
+	hdata->dma_dir = dir_in;
 	DMA(cmd->device->host)->CNTR = cntr;
 
 	/* setup DMA *physical* address */
@@ -134,7 +129,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cache_push(addr, cmd->SCp.this_residual);
 	}
 
-	if ((bank_mask = (~HDATA(cmd->device->host)->dma_xfer_mask >> 18) & 0x01c0))
+	bank_mask = (~hdata->dma_xfer_mask >> 18) & 0x01c0;
+	if (bank_mask)
 		DMA(cmd->device->host)->BANK = bank_mask & (addr >> 18);
 
 	/* start DMA */
@@ -147,25 +143,26 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+
 	/* stop DMA */
 	DMA(instance)->SP_DMA = 1;
 	/* remove write bit from CONTROL bits */
 	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && HDATA(instance)->dma_bounce_buffer) {
-		if (HDATA(instance)->dma_dir && SCpnt)
-			memcpy(SCpnt->SCp.ptr,
-			       HDATA(instance)->dma_bounce_buffer,
+	if (status && hdata->dma_bounce_buffer) {
+		if (hdata->dma_dir && SCpnt)
+			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
 			       SCpnt->SCp.this_residual);
 
-		if (HDATA(instance)->dma_buffer_pool == BUF_SCSI_ALLOCED)
-			kfree(HDATA(instance)->dma_bounce_buffer);
+		if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED)
+			kfree(hdata->dma_bounce_buffer);
 		else
-			amiga_chip_free(HDATA(instance)->dma_bounce_buffer);
+			amiga_chip_free(hdata->dma_bounce_buffer);
 
-		HDATA(instance)->dma_bounce_buffer = NULL;
-		HDATA(instance)->dma_bounce_len = 0;
+		hdata->dma_bounce_buffer = NULL;
+		hdata->dma_bounce_len = 0;
 	}
 }
 
@@ -179,6 +176,7 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	unsigned int epc;
 	struct zorro_dev *z = NULL;
 	unsigned int default_dma_xfer_mask;
+	struct WD33C93_hostdata *hdata;
 	wd33c93_regs regs;
 	int num_gvp11 = 0;
 #ifdef CHECK_WD33C93
@@ -305,10 +303,11 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		instance->irq = IRQ_AMIGA_PORTS;
 		instance->unique_id = z->slotaddr;
 
+		hdata = shost_priv(instance);
 		if (gvp11_xfer_mask)
-			HDATA(instance)->dma_xfer_mask = gvp11_xfer_mask;
+			hdata->dma_xfer_mask = gvp11_xfer_mask;
 		else
-			HDATA(instance)->dma_xfer_mask = default_dma_xfer_mask;
+			hdata->dma_xfer_mask = default_dma_xfer_mask;
 
 		DMA(instance)->secret2 = 1;
 		DMA(instance)->secret1 = 0;
@@ -326,9 +325,9 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		 */
 		regs.SASR = &(DMA(instance)->SASR);
 		regs.SCMD = &(DMA(instance)->SCMD);
-		HDATA(instance)->no_sync = 0xff;
-		HDATA(instance)->fast = 0;
-		HDATA(instance)->dma_mode = CTRL_DMA;
+		hdata->no_sync = 0xff;
+		hdata->fast = 0;
+		hdata->dma_mode = CTRL_DMA;
 		wd33c93_init(instance, regs, dma_setup, dma_stop,
 			     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 						     : WD33C93_FS_12_15);
-- 
1.6.0.4
