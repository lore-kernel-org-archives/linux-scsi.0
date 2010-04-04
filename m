From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 06/21] m68k/scsi: a2091 - Use shost_priv() and kill ugly HDATA() macro
Date: Sun,  4 Apr 2010 11:00:36 +0200
Message-ID: <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |   56 +++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index f09c8ba..b890b60 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -22,7 +22,6 @@
 
 
 #define DMA(ptr)	((a2091_scsiregs *)((ptr)->base))
-#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static int a2091_release(struct Scsi_Host *instance);
 
@@ -44,39 +43,39 @@ static irqreturn_t a2091_intr(int irq, void *_instance)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
+	struct Scsi_Host *instance = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-	struct Scsi_Host *instance = cmd->device->host;
 
 	/* don't allow DMA if the physical address is bad */
 	if (addr & A2091_XFER_MASK) {
-		HDATA(instance)->dma_bounce_len =
-			(cmd->SCp.this_residual + 511) & ~0x1ff;
-		HDATA(instance)->dma_bounce_buffer =
-			kmalloc(HDATA(instance)->dma_bounce_len, GFP_KERNEL);
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
+						   GFP_KERNEL);
 
 		/* can't allocate memory; use PIO */
-		if (!HDATA(instance)->dma_bounce_buffer) {
-			HDATA(instance)->dma_bounce_len = 0;
+		if (!hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_len = 0;
 			return 1;
 		}
 
 		/* get the physical address of the bounce buffer */
-		addr = virt_to_bus(HDATA(instance)->dma_bounce_buffer);
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
 
 		/* the bounce buffer may not be in the first 16M of physmem */
 		if (addr & A2091_XFER_MASK) {
 			/* we could use chipmem... maybe later */
-			kfree(HDATA(instance)->dma_bounce_buffer);
-			HDATA(instance)->dma_bounce_buffer = NULL;
-			HDATA(instance)->dma_bounce_len = 0;
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
 			return 1;
 		}
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(HDATA(instance)->dma_bounce_buffer,
-			       cmd->SCp.ptr, cmd->SCp.this_residual);
+			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			       cmd->SCp.this_residual);
 		}
 	}
 
@@ -85,7 +84,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= CNTR_DDIR;
 
 	/* remember direction */
-	HDATA(cmd->device->host)->dma_dir = dir_in;
+	hdata->dma_dir = dir_in;
 
 	DMA(cmd->device->host)->CNTR = cntr;
 
@@ -109,17 +108,19 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
 
-	if (!HDATA(instance)->dma_dir)
+	if (!hdata->dma_dir)
 		cntr |= CNTR_DDIR;
 
 	/* disable SCSI interrupts */
 	DMA(instance)->CNTR = cntr;
 
 	/* flush if we were reading */
-	if (HDATA(instance)->dma_dir) {
+	if (hdata->dma_dir) {
 		DMA(instance)->FLUSH = 1;
 		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
 			;
@@ -135,14 +136,13 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && HDATA(instance)->dma_bounce_buffer) {
-		if (HDATA(instance)->dma_dir)
-			memcpy(SCpnt->SCp.ptr,
-			       HDATA(instance)->dma_bounce_buffer,
+	if (status && hdata->dma_bounce_buffer) {
+		if (hdata->dma_dir)
+			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
 			       SCpnt->SCp.this_residual);
-		kfree(HDATA(instance)->dma_bounce_buffer);
-		HDATA(instance)->dma_bounce_buffer = NULL;
-		HDATA(instance)->dma_bounce_len = 0;
+		kfree(hdata->dma_bounce_buffer);
+		hdata->dma_bounce_buffer = NULL;
+		hdata->dma_bounce_len = 0;
 	}
 }
 
@@ -153,6 +153,7 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 	unsigned long address;
 	struct zorro_dev *z = NULL;
 	wd33c93_regs regs;
+	struct WD33C93_hostdata *hdata;
 	int num_a2091 = 0;
 
 	if (!MACH_IS_AMIGA || called)
@@ -179,9 +180,10 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 		DMA(instance)->DAWR = DAWR_A2091;
 		regs.SASR = &(DMA(instance)->SASR);
 		regs.SCMD = &(DMA(instance)->SCMD);
-		HDATA(instance)->no_sync = 0xff;
-		HDATA(instance)->fast = 0;
-		HDATA(instance)->dma_mode = CTRL_DMA;
+		hdata = shost_priv(instance);
+		hdata->no_sync = 0xff;
+		hdata->fast = 0;
+		hdata->dma_mode = CTRL_DMA;
 		wd33c93_init(instance, regs, dma_setup, dma_stop,
 			     WD33C93_FS_8_10);
 		if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
-- 
1.6.0.4
