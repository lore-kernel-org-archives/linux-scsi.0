From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/14] m68k: amiga - A3000 SCSI platform device conversion
Date: Fri, 23 Apr 2010 10:00:28 +0200
Message-ID: <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:50397 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0DWIAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 04:00:42 -0400
In-Reply-To: <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
---
 arch/m68k/amiga/platform.c |   11 +++
 drivers/scsi/a3000.c       |  164 +++++++++++++++++++++++++++-----------------
 2 files changed, 111 insertions(+), 64 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 38f18bf..df1fae3 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -58,6 +58,13 @@ subsys_initcall(amiga_init_bus);
 #endif /* CONFIG_ZORRO */
 
 
+static const struct resource a3000_scsi_resource __initconst = {
+	.start	= 0xdd0000,
+	.end	= 0xdd00ff,
+	.flags	= IORESOURCE_MEM,
+};
+
+
 static int __init amiga_init_devices(void)
 {
 	if (!MACH_IS_AMIGA)
@@ -77,6 +84,10 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_FLOPPY))
 		platform_device_register_simple("amiga-floppy", -1, NULL, 0);
 
+	if (AMIGAHW_PRESENT(A3000_SCSI))
+		platform_device_register_simple("amiga-a3000-scsi", -1,
+						&a3000_scsi_resource, 1);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 79a4a3c..7f09d89 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -1,28 +1,21 @@
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/blkdev.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
-#include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
-#include <asm/irq.h>
 
 #include "scsi.h"
-#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "a3000.h"
 
-#include <linux/stat.h>
-
-
-static int a3000_release(struct Scsi_Host *instance);
 
 static irqreturn_t a3000_intr(int irq, void *data)
 {
@@ -39,7 +32,7 @@ static irqreturn_t a3000_intr(int irq, void *data)
 		spin_unlock_irqrestore(instance->host_lock, flags);
 		return IRQ_HANDLED;
 	}
-	printk("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
+	pr_warning("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
 	return IRQ_NONE;
 }
 
@@ -162,93 +155,136 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int __init a3000_detect(struct scsi_host_template *tpnt)
+static int a3000_bus_reset(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *instance = cmd->device->host;
+
+	/* FIXME perform bus-specific reset */
+
+	/* FIXME 2: kill this entire function, which should
+	   cause mid-layer to call wd33c93_host_reset anyway? */
+
+	spin_lock_irq(instance->host_lock);
+	wd33c93_host_reset(cmd);
+	spin_unlock_irq(instance->host_lock);
+
+	return SUCCESS;
+}
+
+static struct scsi_host_template amiga_a3000_scsi_template = {
+	.module			= THIS_MODULE,
+	.name			= "Amiga 3000 built-in SCSI",
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "A3000",
+	.queuecommand		= wd33c93_queuecommand,
+	.eh_abort_handler	= wd33c93_abort,
+	.eh_bus_reset_handler	= a3000_bus_reset,
+	.eh_host_reset_handler	= wd33c93_host_reset,
+	.can_queue		= CAN_QUEUE,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= CMD_PER_LUN,
+	.use_clustering		= ENABLE_CLUSTERING
+};
+
+static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	struct Scsi_Host *instance;
-	wd33c93_regs wdregs;
+	int error;
 	struct a3000_scsiregs *regs;
+	wd33c93_regs wdregs;
 	struct WD33C93_hostdata *hdata;
 
-	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
-		return 0;
-	if (!request_mem_region(0xDD0000, 256, "wd33c93"))
-		return 0;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 
-	tpnt->proc_name = "A3000";
-	tpnt->proc_info = &wd33c93_proc_info;
+	if (!request_mem_region(res->start, resource_size(res), "wd33c93"))
+		return -EBUSY;
 
-	instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
-	if (instance == NULL)
-		goto fail_register;
+	instance = scsi_host_alloc(&amiga_a3000_scsi_template,
+				   sizeof(struct WD33C93_hostdata));
+	if (!instance) {
+		error = -ENOMEM;
+		goto fail_alloc;
+	}
 
-	instance->base = ZTWO_VADDR(0xDD0000);
+	instance->base = ZTWO_VADDR(res->start);
 	instance->irq = IRQ_AMIGA_PORTS;
+
 	regs = (struct a3000_scsiregs *)(instance->base);
 	regs->DAWR = DAWR_A3000;
+
 	wdregs.SASR = &regs->SASR;
 	wdregs.SCMD = &regs->SCMD;
+
 	hdata = shost_priv(instance);
 	hdata->no_sync = 0xff;
 	hdata->fast = 0;
 	hdata->dma_mode = CTRL_DMA;
+
 	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_12_15);
-	if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
-			instance))
+	error = request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED,
+			    "A3000 SCSI", instance);
+	if (error)
 		goto fail_irq;
+
 	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
-	return 1;
+	error = scsi_add_host(instance, NULL);
+	if (error)
+		goto fail_host;
 
-fail_irq:
-	scsi_unregister(instance);
-fail_register:
-	release_mem_region(0xDD0000, 256);
+	platform_set_drvdata(pdev, instance);
+
+	scsi_scan_host(instance);
 	return 0;
+
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, instance);
+fail_irq:
+	scsi_host_put(instance);
+fail_alloc:
+	release_mem_region(res->start, resource_size(res));
+	return error;
 }
 
-static int a3000_bus_reset(struct scsi_cmnd *cmd)
+static int __exit amiga_a3000_scsi_remove(struct platform_device *pdev)
 {
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this entire function, which should
-	   cause mid-layer to call wd33c93_host_reset anyway? */
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	struct Scsi_Host *instance = platform_get_drvdata(pdev);
+	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	return SUCCESS;
+	regs->CNTR = 0;
+	scsi_remove_host(instance);
+	free_irq(IRQ_AMIGA_PORTS, instance);
+	scsi_host_put(instance);
+	release_mem_region(res->start, resource_size(res));
+	return 0;
 }
 
-#define HOSTS_C
-
-static struct scsi_host_template driver_template = {
-	.proc_name		= "A3000",
-	.name			= "Amiga 3000 built-in SCSI",
-	.detect			= a3000_detect,
-	.release		= a3000_release,
-	.queuecommand		= wd33c93_queuecommand,
-	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= a3000_bus_reset,
-	.eh_host_reset_handler	= wd33c93_host_reset,
-	.can_queue		= CAN_QUEUE,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= CMD_PER_LUN,
-	.use_clustering		= ENABLE_CLUSTERING
+static struct platform_driver amiga_a3000_scsi_driver = {
+	.remove = __exit_p(amiga_a3000_scsi_remove),
+	.driver   = {
+		.name	= "amiga-a3000-scsi",
+		.owner	= THIS_MODULE,
+	},
 };
 
-
-#include "scsi_module.c"
-
-static int a3000_release(struct Scsi_Host *instance)
+static int __init amiga_a3000_scsi_init(void)
 {
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	return platform_driver_probe(&amiga_a3000_scsi_driver,
+				     amiga_a3000_scsi_probe);
+}
+module_init(amiga_a3000_scsi_init);
 
-	regs->CNTR = 0;
-	release_mem_region(0xDD0000, 256);
-	free_irq(IRQ_AMIGA_PORTS, a3000_intr);
-	return 1;
+static void __exit amiga_a3000_scsi_exit(void)
+{
+	platform_driver_unregister(&amiga_a3000_scsi_driver);
 }
+module_exit(amiga_a3000_scsi_exit);
 
+MODULE_DESCRIPTION("Amiga 3000 built-in SCSI");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-a3000-scsi");
-- 
1.6.0.4

