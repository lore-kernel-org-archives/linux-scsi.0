From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 08/21] m68k/scsi: mvme147 - Use shost_priv() and kill ugly HDATA() macro
Date: Sun,  4 Apr 2010 11:00:38 +0200
Message-ID: <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/mvme147.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index b236d72..716d178 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -16,8 +16,6 @@
 #include <linux/stat.h>
 
 
-#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
-
 static struct Scsi_Host *mvme147_host = NULL;
 
 static irqreturn_t mvme147_intr(int irq, void *dummy)
@@ -31,6 +29,7 @@ static irqreturn_t mvme147_intr(int irq, void *dummy)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
+	struct WD33C93_hostdata *hdata = shost_priv(mvme147_host);
 	unsigned char flags = 0x01;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -39,7 +38,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		flags |= 0x04;
 
 	/* remember direction */
-	HDATA(mvme147_host)->dma_dir = dir_in;
+	hdata->dma_dir = dir_in;
 
 	if (dir_in) {
 		/* invalidate any cache */
@@ -68,6 +67,7 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 {
 	static unsigned char called = 0;
 	wd33c93_regs regs;
+	struct WD33C93_hostdata *hdata;
 
 	if (!MACH_IS_MVME147 || called)
 		return 0;
@@ -84,9 +84,10 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 	mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
 	regs.SASR = (volatile unsigned char *)0xfffe4000;
 	regs.SCMD = (volatile unsigned char *)0xfffe4001;
-	HDATA(mvme147_host)->no_sync = 0xff;
-	HDATA(mvme147_host)->fast = 0;
-	HDATA(mvme147_host)->dma_mode = CTRL_DMA;
+	hdata = shost_priv(mvme147_host);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
 	wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 
 	if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0,
-- 
1.6.0.4
