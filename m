From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 20/21] m68k: amiga - A2091/A590 SCSI zorro_driver conversion
Date: Sun,  4 Apr 2010 11:00:50 +0200
Message-ID: <1270371651-2584-21-git-send-email-geert@linux-m68k.org>
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
 <1270371651-2584-15-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-16-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-17-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-18-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-19-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-20-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-20-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |  184 +++++++++++++++++++++++++++----------------------
 1 files changed, 101 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index ff2cdbb..b06790c 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -1,27 +1,19 @@
 #include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/zorro.h>
 
-#include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
-#include <linux/zorro.h>
-#include <asm/irq.h>
-#include <linux/spinlock.h>
 
 #include "scsi.h"
-#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "a2091.h"
 
-#include <linux/stat.h>
-
-
-static int a2091_release(struct Scsi_Host *instance);
 
 static irqreturn_t a2091_intr(int irq, void *data)
 {
@@ -146,85 +138,27 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int __init a2091_detect(struct scsi_host_template *tpnt)
-{
-	static unsigned char called = 0;
-	struct Scsi_Host *instance;
-	unsigned long address;
-	struct zorro_dev *z = NULL;
-	wd33c93_regs wdregs;
-	struct a2091_scsiregs *regs;
-	struct WD33C93_hostdata *hdata;
-	int num_a2091 = 0;
-
-	if (!MACH_IS_AMIGA || called)
-		return 0;
-	called = 1;
-
-	tpnt->proc_name = "A2091";
-	tpnt->proc_info = &wd33c93_proc_info;
-
-	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-		if (z->id != ZORRO_PROD_CBM_A590_A2091_1 &&
-		    z->id != ZORRO_PROD_CBM_A590_A2091_2)
-			continue;
-		address = z->resource.start;
-		if (!request_mem_region(address, 256, "wd33c93"))
-			continue;
-
-		instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
-		if (instance == NULL)
-			goto release;
-		instance->base = ZTWO_VADDR(address);
-		instance->irq = IRQ_AMIGA_PORTS;
-		instance->unique_id = z->slotaddr;
-		regs = (struct a2091_scsiregs *)(instance->base);
-		regs->DAWR = DAWR_A2091;
-		wdregs.SASR = &regs->SASR;
-		wdregs.SCMD = &regs->SCMD;
-		hdata = shost_priv(instance);
-		hdata->no_sync = 0xff;
-		hdata->fast = 0;
-		hdata->dma_mode = CTRL_DMA;
-		wd33c93_init(instance, wdregs, dma_setup, dma_stop,
-			     WD33C93_FS_8_10);
-		if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
-				"A2091 SCSI", instance))
-			goto unregister;
-		regs->CNTR = CNTR_PDMD | CNTR_INTEN;
-		num_a2091++;
-		continue;
-
-unregister:
-		scsi_unregister(instance);
-release:
-		release_mem_region(address, 256);
-	}
-
-	return num_a2091;
-}
-
 static int a2091_bus_reset(struct scsi_cmnd *cmd)
 {
+	struct Scsi_Host *instance = cmd->device->host;
+
 	/* FIXME perform bus-specific reset */
 
 	/* FIXME 2: kill this function, and let midlayer fall back
 	   to the same action, calling wd33c93_host_reset() */
 
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(instance->host_lock);
 	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(instance->host_lock);
 
 	return SUCCESS;
 }
 
-#define HOSTS_C
-
-static struct scsi_host_template driver_template = {
-	.proc_name		= "A2901",
+static struct scsi_host_template a2091_scsi_template = {
+	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
-	.detect			= a2091_detect,
-	.release		= a2091_release,
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "A2901",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= a2091_bus_reset,
@@ -236,19 +170,103 @@ static struct scsi_host_template driver_template = {
 	.use_clustering		= DISABLE_CLUSTERING
 };
 
+static int __devinit a2091_probe(struct zorro_dev *z,
+				 const struct zorro_device_id *ent)
+{
+	struct Scsi_Host *instance;
+	int error;
+	struct a2091_scsiregs *regs;
+	wd33c93_regs wdregs;
+	struct WD33C93_hostdata *hdata;
 
-#include "scsi_module.c"
+	if (!request_mem_region(z->resource.start, 256, "wd33c93"))
+		return -EBUSY;
 
-static int a2091_release(struct Scsi_Host *instance)
+	instance = scsi_host_alloc(&a2091_scsi_template,
+				   sizeof(struct WD33C93_hostdata));
+	if (!instance) {
+		error = -ENOMEM;
+		goto fail_alloc;
+	}
+
+	instance->base = ZTWO_VADDR(z->resource.start);
+	instance->irq = IRQ_AMIGA_PORTS;
+	instance->unique_id = z->slotaddr;
+
+	regs = (struct a2091_scsiregs *)(instance->base);
+	regs->DAWR = DAWR_A2091;
+
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
+
+	hdata = shost_priv(instance);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
+
+	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_8_10);
+	error = request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
+			    "A2091 SCSI", instance);
+	if (error)
+		goto fail_irq;
+
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	error = scsi_add_host(instance, NULL);
+	if (error)
+		goto fail_host;
+
+	zorro_set_drvdata(z, instance);
+
+	scsi_scan_host(instance);
+	return 0;
+
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, instance);
+fail_irq:
+	scsi_host_put(instance);
+fail_alloc:
+	release_mem_region(z->resource.start, 256);
+	return error;
+}
+
+static void __devexit a2091_remove(struct zorro_dev *z)
 {
-#ifdef MODULE
+	struct Scsi_Host *instance = zorro_get_drvdata(z);
 	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
 
 	regs->CNTR = 0;
-	release_mem_region(ZTWO_PADDR(instance->base), 256);
+	scsi_remove_host(instance);
 	free_irq(IRQ_AMIGA_PORTS, instance);
-#endif
-	return 1;
+	scsi_host_put(instance);
+	release_mem_region(z->resource.start, 256);
+}
+
+static struct zorro_device_id a2091_zorro_tbl[] __devinitdata = {
+	{ ZORRO_PROD_CBM_A590_A2091_1 },
+	{ ZORRO_PROD_CBM_A590_A2091_2 },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(zorro, a2091_zorro_tbl);
+
+static struct zorro_driver a2091_driver = {
+	.name		= "a2091",
+	.id_table	= a2091_zorro_tbl,
+	.probe		= a2091_probe,
+	.remove		= __devexit_p(a2091_remove),
+};
+
+static int __init a2091_init(void)
+{
+	return zorro_register_driver(&a2091_driver);
+}
+module_init(a2091_init);
+
+static void __exit a2091_exit(void)
+{
+	zorro_unregister_driver(&a2091_driver);
 }
+module_exit(a2091_exit);
 
+MODULE_DESCRIPTION("Commodore A2091/A590 SCSI");
 MODULE_LICENSE("GPL");
-- 
1.6.0.4
