From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 13/21] m68k/scsi: mvme147 - Kill static global mvme147_host
Date: Sun,  4 Apr 2010 11:00:43 +0200
Message-ID: <1270371651-2584-14-git-send-email-geert@linux-m68k.org>
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
 <1270371651-2584-13-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-13-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/mvme147.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 716d178..1b6195b 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -16,12 +16,12 @@
 #include <linux/stat.h>
 
 
-static struct Scsi_Host *mvme147_host = NULL;
-
-static irqreturn_t mvme147_intr(int irq, void *dummy)
+static irqreturn_t mvme147_intr(int irq, void *data)
 {
+	struct Scsi_Host *instance = data;
+
 	if (irq == MVME147_IRQ_SCSI_PORT)
-		wd33c93_intr(mvme147_host);
+		wd33c93_intr(instance);
 	else
 		m147_pcc->dma_intr = 0x89;	/* Ack and enable ints */
 	return IRQ_HANDLED;
@@ -29,7 +29,8 @@ static irqreturn_t mvme147_intr(int irq, void *dummy)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-	struct WD33C93_hostdata *hdata = shost_priv(mvme147_host);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
 	unsigned char flags = 0x01;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -66,6 +67,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 int mvme147_detect(struct scsi_host_template *tpnt)
 {
 	static unsigned char called = 0;
+	struct Scsi_Host *instance;
 	wd33c93_regs regs;
 	struct WD33C93_hostdata *hdata;
 
@@ -76,25 +78,25 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 	tpnt->proc_name = "MVME147";
 	tpnt->proc_info = &wd33c93_proc_info;
 
-	mvme147_host = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
-	if (!mvme147_host)
+	instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+	if (!instance)
 		goto err_out;
 
-	mvme147_host->base = 0xfffe4000;
-	mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
+	instance->base = 0xfffe4000;
+	instance->irq = MVME147_IRQ_SCSI_PORT;
 	regs.SASR = (volatile unsigned char *)0xfffe4000;
 	regs.SCMD = (volatile unsigned char *)0xfffe4001;
-	hdata = shost_priv(mvme147_host);
+	hdata = shost_priv(instance);
 	hdata->no_sync = 0xff;
 	hdata->fast = 0;
 	hdata->dma_mode = CTRL_DMA;
-	wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
+	wd33c93_init(instance, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 
 	if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0,
-			"MVME147 SCSI PORT", mvme147_intr))
+			"MVME147 SCSI PORT", instance))
 		goto err_unregister;
 	if (request_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr, 0,
-			"MVME147 SCSI DMA", mvme147_intr))
+			"MVME147 SCSI DMA", instance))
 		goto err_free_irq;
 #if 0	/* Disabled; causes problems booting */
 	m147_pcc->scsi_interrupt = 0x10;	/* Assert SCSI bus reset */
@@ -113,7 +115,7 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 err_free_irq:
 	free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
 err_unregister:
-	scsi_unregister(mvme147_host);
+	scsi_unregister(instance);
 err_out:
 	return 0;
 }
-- 
1.6.0.4
