From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 21/21] m68k: amiga - GVP Series II SCSI zorro_driver conversion
Date: Sun,  4 Apr 2010 11:00:51 +0200
Message-ID: <1270371651-2584-22-git-send-email-geert@linux-m68k.org>
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
 <1270371651-2584-21-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-21-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |  296 ++++++++++++++++++++++++++------------------------
 drivers/scsi/gvp11.h |    7 -
 2 files changed, 155 insertions(+), 148 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 8167b79..6a89afc 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -1,25 +1,19 @@
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
 #include "gvp11.h"
 
-#include <linux/stat.h>
-
 
 #define CHECK_WD33C93
 
@@ -168,7 +162,40 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int __init check_wd33c93(struct gvp11_scsiregs *regs)
+static int gvp11_bus_reset(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *instance = cmd->device->host;
+
+	/* FIXME perform bus-specific reset */
+
+	/* FIXME 2: shouldn't we no-op this function (return
+	   FAILED), and fall back to host reset function,
+	   wd33c93_host_reset ? */
+
+	spin_lock_irq(instance->host_lock);
+	wd33c93_host_reset(cmd);
+	spin_unlock_irq(instance->host_lock);
+
+	return SUCCESS;
+}
+
+static struct scsi_host_template gvp11_scsi_template = {
+	.module			= THIS_MODULE,
+	.name			= "GVP Series II SCSI",
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "GVP11",
+	.queuecommand		= wd33c93_queuecommand,
+	.eh_abort_handler	= wd33c93_abort,
+	.eh_bus_reset_handler	= gvp11_bus_reset,
+	.eh_host_reset_handler	= wd33c93_host_reset,
+	.can_queue		= CAN_QUEUE,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= CMD_PER_LUN,
+	.use_clustering		= DISABLE_CLUSTERING
+};
+
+static int __devinit check_wd33c93(struct gvp11_scsiregs *regs)
 {
 #ifdef CHECK_WD33C93
 	volatile unsigned char *sasr_3393, *scmd_3393;
@@ -248,163 +275,150 @@ static int __init check_wd33c93(struct gvp11_scsiregs *regs)
 	return 0;
 }
 
-int __init gvp11_detect(struct scsi_host_template *tpnt)
+static int __devinit gvp11_probe(struct zorro_dev *z,
+				 const struct zorro_device_id *ent)
 {
-	static unsigned char called = 0;
 	struct Scsi_Host *instance;
 	unsigned long address;
+	int error;
 	unsigned int epc;
-	struct zorro_dev *z = NULL;
 	unsigned int default_dma_xfer_mask;
 	struct WD33C93_hostdata *hdata;
 	struct gvp11_scsiregs *regs;
 	wd33c93_regs wdregs;
-	int num_gvp11 = 0;
-
-	if (!MACH_IS_AMIGA || called)
-		return 0;
-	called = 1;
-
-	tpnt->proc_name = "GVP11";
-	tpnt->proc_info = &wd33c93_proc_info;
-
-	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-		/*
-		 * This should (hopefully) be the correct way to identify
-		 * all the different GVP SCSI controllers (except for the
-		 * SERIES I though).
-		 */
-
-		if (z->id == ZORRO_PROD_GVP_COMBO_030_R3_SCSI ||
-		    z->id == ZORRO_PROD_GVP_SERIES_II)
-			default_dma_xfer_mask = ~0x00ffffff;
-		else if (z->id == ZORRO_PROD_GVP_GFORCE_030_SCSI ||
-			 z->id == ZORRO_PROD_GVP_A530_SCSI ||
-			 z->id == ZORRO_PROD_GVP_COMBO_030_R4_SCSI)
-			default_dma_xfer_mask = ~0x01ffffff;
-		else if (z->id == ZORRO_PROD_GVP_A1291 ||
-			 z->id == ZORRO_PROD_GVP_GFORCE_040_SCSI_1)
-			default_dma_xfer_mask = ~0x07ffffff;
-		else
-			continue;
-
-		/*
-		 * Rumors state that some GVP ram boards use the same product
-		 * code as the SCSI controllers. Therefore if the board-size
-		 * is not 64KB we asume it is a ram board and bail out.
-		 */
-		if (z->resource.end - z->resource.start != 0xffff)
-			continue;
-
-		address = z->resource.start;
-		if (!request_mem_region(address, 256, "wd33c93"))
-			continue;
-
-		regs = (struct gvp11_scsiregs *)(ZTWO_VADDR(address));
-		if (check_wd33c93(regs))
-			goto release;
-
-		instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
-		if (instance == NULL)
-			goto release;
-		instance->base = ZTWO_VADDR(address);
-		instance->irq = IRQ_AMIGA_PORTS;
-		instance->unique_id = z->slotaddr;
-
-		hdata = shost_priv(instance);
-		if (gvp11_xfer_mask)
-			hdata->dma_xfer_mask = gvp11_xfer_mask;
-		else
-			hdata->dma_xfer_mask = default_dma_xfer_mask;
-
-		regs->secret2 = 1;
-		regs->secret1 = 0;
-		regs->secret3 = 15;
-		while (regs->CNTR & GVP11_DMAC_BUSY)
-			;
-		regs->CNTR = 0;
-
-		regs->BANK = 0;
-
-		epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
-
-		/*
-		 * Check for 14MHz SCSI clock
-		 */
-		wdregs.SASR = &regs->SASR;
-		wdregs.SCMD = &regs->SCMD;
-		hdata->no_sync = 0xff;
-		hdata->fast = 0;
-		hdata->dma_mode = CTRL_DMA;
-		wd33c93_init(instance, wdregs, dma_setup, dma_stop,
-			     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
-						     : WD33C93_FS_12_15);
-
-		if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED,
-				"GVP11 SCSI", instance))
-			goto unregister;
-		regs->CNTR = GVP11_DMAC_INT_ENABLE;
-		num_gvp11++;
-		continue;
-
-unregister:
-		scsi_unregister(instance);
-release:
-		release_mem_region(address, 256);
+
+	default_dma_xfer_mask = ent->driver_data;
+
+	/*
+	 * Rumors state that some GVP ram boards use the same product
+	 * code as the SCSI controllers. Therefore if the board-size
+	 * is not 64KB we asume it is a ram board and bail out.
+	 */
+	if (zorro_resource_len(z) != 0x10000)
+		return -ENODEV;
+
+	address = z->resource.start;
+	if (!request_mem_region(address, 256, "wd33c93"))
+		return -EBUSY;
+
+	regs = (struct gvp11_scsiregs *)(ZTWO_VADDR(address));
+
+	error = check_wd33c93(regs);
+	if (error)
+		goto fail_check_or_alloc;
+
+	instance = scsi_host_alloc(&gvp11_scsi_template,
+				   sizeof(struct WD33C93_hostdata));
+	if (!instance) {
+		error = -ENOMEM;
+		goto fail_check_or_alloc;
 	}
 
-	return num_gvp11;
-}
+	instance->base = (unsigned long)regs;
+	instance->irq = IRQ_AMIGA_PORTS;
+	instance->unique_id = z->slotaddr;
 
-static int gvp11_bus_reset(struct scsi_cmnd *cmd)
-{
-	/* FIXME perform bus-specific reset */
+	regs->secret2 = 1;
+	regs->secret1 = 0;
+	regs->secret3 = 15;
+	while (regs->CNTR & GVP11_DMAC_BUSY)
+		;
+	regs->CNTR = 0;
+	regs->BANK = 0;
 
-	/* FIXME 2: shouldn't we no-op this function (return
-	   FAILED), and fall back to host reset function,
-	   wd33c93_host_reset ? */
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	hdata = shost_priv(instance);
+	if (gvp11_xfer_mask)
+		hdata->dma_xfer_mask = gvp11_xfer_mask;
+	else
+		hdata->dma_xfer_mask = default_dma_xfer_mask;
 
-	return SUCCESS;
-}
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
 
+	/*
+	 * Check for 14MHz SCSI clock
+	 */
+	epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
+	wd33c93_init(instance, wdregs, dma_setup, dma_stop,
+		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
+					     : WD33C93_FS_12_15);
 
-#define HOSTS_C
+	error = request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED,
+			    "GVP11 SCSI", instance);
+	if (error)
+		goto fail_irq;
 
-#include "gvp11.h"
+	regs->CNTR = GVP11_DMAC_INT_ENABLE;
 
-static struct scsi_host_template driver_template = {
-	.proc_name		= "GVP11",
-	.name			= "GVP Series II SCSI",
-	.detect			= gvp11_detect,
-	.release		= gvp11_release,
-	.queuecommand		= wd33c93_queuecommand,
-	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= gvp11_bus_reset,
-	.eh_host_reset_handler	= wd33c93_host_reset,
-	.can_queue		= CAN_QUEUE,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= CMD_PER_LUN,
-	.use_clustering		= DISABLE_CLUSTERING
-};
+	error = scsi_add_host(instance, NULL);
+	if (error)
+		goto fail_host;
 
+	zorro_set_drvdata(z, instance);
+	scsi_scan_host(instance);
+	return 0;
 
-#include "scsi_module.c"
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, instance);
+fail_irq:
+	scsi_host_put(instance);
+fail_check_or_alloc:
+	release_mem_region(address, 256);
+	return error;
+}
 
-int gvp11_release(struct Scsi_Host *instance)
+static void __devexit gvp11_remove(struct zorro_dev *z)
 {
-#ifdef MODULE
+	struct Scsi_Host *instance = zorro_get_drvdata(z);
 	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
 
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
+	/*
+	 * This should (hopefully) be the correct way to identify
+	 * all the different GVP SCSI controllers (except for the
+	 * SERIES I though).
+	 */
+
+static struct zorro_device_id gvp11_zorro_tbl[] __devinitdata = {
+	{ ZORRO_PROD_GVP_COMBO_030_R3_SCSI,	~0x00ffffff },
+	{ ZORRO_PROD_GVP_SERIES_II,		~0x00ffffff },
+	{ ZORRO_PROD_GVP_GFORCE_030_SCSI,	~0x01ffffff },
+	{ ZORRO_PROD_GVP_A530_SCSI,		~0x01ffffff },
+	{ ZORRO_PROD_GVP_COMBO_030_R4_SCSI,	~0x01ffffff },
+	{ ZORRO_PROD_GVP_A1291,			~0x07ffffff },
+	{ ZORRO_PROD_GVP_GFORCE_040_SCSI_1,	~0x07ffffff },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(zorro, gvp11_zorro_tbl);
+
+static struct zorro_driver gvp11_driver = {
+	.name		= "gvp11",
+	.id_table	= gvp11_zorro_tbl,
+	.probe		= gvp11_probe,
+	.remove		= __devexit_p(gvp11_remove),
+};
+
+static int __init gvp11_init(void)
+{
+	return zorro_register_driver(&gvp11_driver);
+}
+module_init(gvp11_init);
+
+static void __exit gvp11_exit(void)
+{
+	zorro_unregister_driver(&gvp11_driver);
 }
+module_exit(gvp11_exit);
 
+MODULE_DESCRIPTION("GVP Series II SCSI");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
index b27a3ee..852913c 100644
--- a/drivers/scsi/gvp11.h
+++ b/drivers/scsi/gvp11.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int gvp11_detect(struct scsi_host_template *);
-int gvp11_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN		2
 #endif
@@ -22,8 +19,6 @@ int gvp11_release(struct Scsi_Host *);
 #define CAN_QUEUE		16
 #endif
 
-#ifndef HOSTS_C
-
 /*
  * if the transfer address ANDed with this results in a non-zero
  * result, then we can't use DMA.
@@ -54,6 +49,4 @@ struct gvp11_scsiregs {
 #define GVP11_DMAC_INT_ENABLE	(1<<3)
 #define GVP11_DMAC_DIR_WRITE	(1<<4)
 
-#endif /* else def HOSTS_C */
-
 #endif /* GVP11_H */
-- 
1.6.0.4
