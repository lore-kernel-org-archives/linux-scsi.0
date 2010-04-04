From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 14/21] m68k/scsi: a3000 - Kill static global a3000_host
Date: Sun,  4 Apr 2010 11:00:44 +0200
Message-ID: <1270371651-2584-15-git-send-email-geert@linux-m68k.org>
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
 <1270371651-2584-14-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-14-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 296b58b..008a999 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -21,22 +21,21 @@
 #include <linux/stat.h>
 
 
-static struct Scsi_Host *a3000_host = NULL;
-
 static int a3000_release(struct Scsi_Host *instance);
 
-static irqreturn_t a3000_intr(int irq, void *dummy)
+static irqreturn_t a3000_intr(int irq, void *data)
 {
-	a3000_scsiregs *regs = (a3000_scsiregs *)(a3000_host->base);
+	struct Scsi_Host *instance = data;
+	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
 	unsigned int status = regs->ISTR;
 	unsigned long flags;
 
 	if (!(status & ISTR_INT_P))
 		return IRQ_NONE;
 	if (status & ISTR_INTS) {
-		spin_lock_irqsave(a3000_host->host_lock, flags);
-		wd33c93_intr(a3000_host);
-		spin_unlock_irqrestore(a3000_host->host_lock, flags);
+		spin_lock_irqsave(instance->host_lock, flags);
+		wd33c93_intr(instance);
+		spin_unlock_irqrestore(instance->host_lock, flags);
 		return IRQ_HANDLED;
 	}
 	printk("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
@@ -45,8 +44,9 @@ static irqreturn_t a3000_intr(int irq, void *dummy)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-	struct WD33C93_hostdata *hdata = shost_priv(a3000_host);
-	a3000_scsiregs *regs = (a3000_scsiregs *)(a3000_host->base);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -163,6 +163,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 
 static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
+	struct Scsi_Host *instance;
 	wd33c93_regs wdregs;
 	a3000_scsiregs *regs;
 	struct WD33C93_hostdata *hdata;
@@ -175,31 +176,30 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
 	tpnt->proc_name = "A3000";
 	tpnt->proc_info = &wd33c93_proc_info;
 
-	a3000_host = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
-	if (a3000_host == NULL)
+	instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+	if (instance == NULL)
 		goto fail_register;
 
-	a3000_host->base = ZTWO_VADDR(0xDD0000);
-	a3000_host->irq = IRQ_AMIGA_PORTS;
-	regs = (a3000_scsiregs *)(a3000_host->base);
+	instance->base = ZTWO_VADDR(0xDD0000);
+	instance->irq = IRQ_AMIGA_PORTS;
+	regs = (a3000_scsiregs *)(instance->base);
 	regs->DAWR = DAWR_A3000;
 	wdregs.SASR = &regs->SASR;
 	wdregs.SCMD = &regs->SCMD;
-	hdata = shost_priv(a3000_host);
+	hdata = shost_priv(instance);
 	hdata->no_sync = 0xff;
 	hdata->fast = 0;
 	hdata->dma_mode = CTRL_DMA;
-	wd33c93_init(a3000_host, wdregs, dma_setup, dma_stop,
-		     WD33C93_FS_12_15);
+	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_12_15);
 	if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
-			a3000_intr))
+			instance))
 		goto fail_irq;
 	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
 	return 1;
 
 fail_irq:
-	scsi_unregister(a3000_host);
+	scsi_unregister(instance);
 fail_register:
 	release_mem_region(0xDD0000, 256);
 	return 0;
-- 
1.6.0.4
