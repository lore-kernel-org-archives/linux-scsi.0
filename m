From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 09/21] m68k/scsi: a3000 - Use shost_priv() and kill ugly HDATA() macro
Date: Sun,  4 Apr 2010 11:00:39 +0200
Message-ID: <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   53 ++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index b27458e..44087a0 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -22,7 +22,6 @@
 
 
 #define DMA(ptr)	((a3000_scsiregs *)((ptr)->base))
-#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *a3000_host = NULL;
 
@@ -47,6 +46,7 @@ static irqreturn_t a3000_intr(int irq, void *dummy)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
+	struct WD33C93_hostdata *hdata = shost_priv(a3000_host);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -57,24 +57,23 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	 * buffer
 	 */
 	if (addr & A3000_XFER_MASK) {
-		HDATA(a3000_host)->dma_bounce_len =
-			(cmd->SCp.this_residual + 511) & ~0x1ff;
-		HDATA(a3000_host)->dma_bounce_buffer =
-			kmalloc(HDATA(a3000_host)->dma_bounce_len, GFP_KERNEL);
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
+						   GFP_KERNEL);
 
 		/* can't allocate memory; use PIO */
-		if (!HDATA(a3000_host)->dma_bounce_buffer) {
-			HDATA(a3000_host)->dma_bounce_len = 0;
+		if (!hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_len = 0;
 			return 1;
 		}
 
 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(HDATA(a3000_host)->dma_bounce_buffer,
-			       cmd->SCp.ptr, cmd->SCp.this_residual);
+			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			       cmd->SCp.this_residual);
 		}
 
-		addr = virt_to_bus(HDATA(a3000_host)->dma_bounce_buffer);
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
 	}
 
 	/* setup dma direction */
@@ -82,7 +81,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= CNTR_DDIR;
 
 	/* remember direction */
-	HDATA(a3000_host)->dma_dir = dir_in;
+	hdata->dma_dir = dir_in;
 
 	DMA(a3000_host)->CNTR = cntr;
 
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
 
 	DMA(instance)->CNTR = cntr;
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* flush if we were reading */
-	if (HDATA(instance)->dma_dir) {
+	if (hdata->dma_dir) {
 		DMA(instance)->FLUSH = 1;
 		mb();		/* don't allow prefetch */
 		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
@@ -142,19 +143,19 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	mb();			/* make sure CNTR is updated before next IO */
 
 	/* copy from a bounce buffer, if necessary */
-	if (status && HDATA(instance)->dma_bounce_buffer) {
+	if (status && hdata->dma_bounce_buffer) {
 		if (SCpnt) {
-			if (HDATA(instance)->dma_dir && SCpnt)
+			if (hdata->dma_dir && SCpnt)
 				memcpy(SCpnt->SCp.ptr,
-				       HDATA(instance)->dma_bounce_buffer,
+				       hdata->dma_bounce_buffer,
 				       SCpnt->SCp.this_residual);
-			kfree(HDATA(instance)->dma_bounce_buffer);
-			HDATA(instance)->dma_bounce_buffer = NULL;
-			HDATA(instance)->dma_bounce_len = 0;
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
 		} else {
-			kfree(HDATA(instance)->dma_bounce_buffer);
-			HDATA(instance)->dma_bounce_buffer = NULL;
-			HDATA(instance)->dma_bounce_len = 0;
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
 		}
 	}
 }
@@ -162,6 +163,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
 	wd33c93_regs regs;
+	struct WD33C93_hostdata *hdata;
 
 	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
 		return 0;
@@ -180,9 +182,10 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
 	DMA(a3000_host)->DAWR = DAWR_A3000;
 	regs.SASR = &(DMA(a3000_host)->SASR);
 	regs.SCMD = &(DMA(a3000_host)->SCMD);
-	HDATA(a3000_host)->no_sync = 0xff;
-	HDATA(a3000_host)->fast = 0;
-	HDATA(a3000_host)->dma_mode = CTRL_DMA;
+	hdata = shost_priv(a3000_host);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
 	wd33c93_init(a3000_host, regs, dma_setup, dma_stop, WD33C93_FS_12_15);
 	if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
 			a3000_intr))
-- 
1.6.0.4
