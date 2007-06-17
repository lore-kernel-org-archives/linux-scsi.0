From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 5/5] 53c700 scsi: Amiga Zorro NCR53c710 SCSI
Date: Sun, 17 Jun 2007 14:47:09 +0200
Message-ID: <20070617125030.690412645@mail.of.borg>
References: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760256AbXFQMxE@vger.kernel.org>
Content-Disposition: inline; filename=m68k-53c700-zorro7xx.diff
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

New driver for Amiga Zorro bus NCR53c710 SCSI controllers, using the 53c700
SCSI core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig    |   16 +---
 drivers/scsi/Makefile   |    1 
 drivers/scsi/zorro7xx.c |  181 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+), 9 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1008,7 +1008,7 @@ config SCSI_STEX
 
 config 53C700_BE_BUS
 	bool
-	depends on SCSI_A4000T || MVME16x_SCSI || BVME6000_SCSI
+	depends on SCSI_A4000T || SCSI_ZORRO7XX || MVME16x_SCSI || BVME6000_SCSI
 	default y
 
 config SCSI_SYM53C8XX_2
@@ -1626,11 +1626,13 @@ config SCSI_A4000T
 	  To compile this driver as a module, choose M here: the
 	  module will be called a4000t.
 
-config SCSI_AMIGA7XX
-	bool "Amiga NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && SCSI && EXPERIMENTAL && BROKEN
+config SCSI_ZORRO7XX
+	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
+	depends on ZORRO && SCSI && EXPERIMENTAL
+	select SCSI_SPI_ATTRS
 	help
-	  Support for various NCR53c710-based SCSI controllers on the Amiga.
+	  Support for various NCR53c710-based SCSI controllers on Zorro
+	  expansion boards for the Amiga.
 	  This includes:
 	    - the Amiga 4091 Zorro III SCSI-2 controller,
 	    - the MacroSystem Development's WarpEngine Amiga SCSI-2 controller
@@ -1639,10 +1641,6 @@ config SCSI_AMIGA7XX
 	    - the SCSI controller on the Phase5 Blizzard PowerUP 603e+
 	      accelerator card for the Amiga 1200,
 	    - the SCSI controller on the GVP Turbo 040/060 accelerator.
-	  Note that all of the above SCSI controllers, except for the builtin
-	  SCSI controller on the Amiga 4000T, reside on the Zorro expansion
-	  bus, so you also have to enable Zorro bus support if you want to use
-	  them.
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
+obj-$(CONFIG_SCSI_ZORRO7XX)	+= 53c700.o	zorro7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o
 obj-$(CONFIG_GVP11_SCSI)	+= gvp11.o	wd33c93.o
--- /dev/null
+++ b/drivers/scsi/zorro7xx.c
@@ -0,0 +1,181 @@
+/*
+ * Detection routine for the NCR53c710 based Amiga SCSI Controllers for Linux.
+ *		Amiga MacroSystemUS WarpEngine SCSI controller.
+ *		Amiga Technologies/DKB A4091 SCSI controller.
+ *
+ * Written 1997 by Alan Hourihane <alanh@fairlite.demon.co.uk>
+ * plus modifications of the 53c7xx.c driver to support the Amiga.
+ *
+ * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/zorro.h>
+#include <asm/amigaints.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("Amiga Zorro NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+
+static struct scsi_host_template zorro7xx_scsi_driver_template = {
+	.proc_name	= "zorro7xx",
+	.this_id	= 7,
+	.module		= THIS_MODULE,
+};
+
+static struct zorro_driver_data {
+	const char *name;
+	unsigned long offset;
+	int absolute;	/* offset is absolute address */
+} zorro7xx_driver_data[] __devinitdata = {
+	{ .name = "PowerUP 603e+", .offset = 0xf40000, .absolute = 1 },
+	{ .name = "WarpEngine 40xx", .offset = 0x40000 },
+	{ .name = "A4091", .offset = 0x800000 },
+	{ .name = "GForce 040/060", .offset = 0x40000 },
+	{ 0 }
+};
+
+static struct zorro_device_id zorro7xx_zorro_tbl[] __devinitdata = {
+	{
+		.id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS,
+		.driver_data = (unsigned long)&zorro7xx_driver_data[0],
+	},
+	{
+		.id = ZORRO_PROD_MACROSYSTEMS_WARP_ENGINE_40xx,
+		.driver_data = (unsigned long)&zorro7xx_driver_data[1],
+	},
+	{
+		.id = ZORRO_PROD_CBM_A4091_1,
+		.driver_data = (unsigned long)&zorro7xx_driver_data[2],
+	},
+	{
+		.id = ZORRO_PROD_CBM_A4091_2,
+		.driver_data = (unsigned long)&zorro7xx_driver_data[2],
+	},
+	{
+		.id = ZORRO_PROD_GVP_GFORCE_040_060,
+		.driver_data = (unsigned long)&zorro7xx_driver_data[3],
+	},
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
+
+static int __devinit zorro7xx_init_one(struct zorro_dev *z,
+				       const struct zorro_device_id *ent)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+	struct zorro_driver_data *zdd;
+	unsigned long board, ioaddr;
+
+	board = zorro_resource_start(z);
+	zdd = (struct zorro_driver_data *)ent->driver_data;
+
+	if (zdd->absolute) {
+		ioaddr = zdd->offset;
+	} else {
+		ioaddr = board + zdd->offset;
+	}
+
+	if (!zorro_request_device(z, zdd->name)) {
+		printk(KERN_ERR "zorro7xx: cannot reserve region 0x%lx, abort\n",
+		       board);
+		return -EBUSY;
+	}
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "zorro7xx: Failed to allocate host data\n");
+		goto out_release;
+	}
+
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	if (ioaddr > 0x01000000)
+		hostdata->base = ioremap(ioaddr, zorro_resource_len(z));
+	else
+		hostdata->base = (void __iomem *)ZTWO_VADDR(ioaddr);
+
+	hostdata->clock = 50;
+	hostdata->chip710 = 1;
+
+	/* Settings for at least WarpEngine 40xx */
+	hostdata->ctest7_extra = CTEST7_TT1;
+
+	zorro7xx_scsi_driver_template.name = zdd->name;
+
+	/* and register the chip */
+	host = NCR_700_detect(&zorro7xx_scsi_driver_template, hostdata,
+			      &z->dev);
+	if (!host) {
+		printk(KERN_ERR "zorro7xx: No host detected; "
+				"board configuration problem?\n");
+		goto out_free;
+	}
+
+	host->this_id = 7;
+	host->base = ioaddr;
+	host->irq = IRQ_AMIGA_PORTS;
+
+	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "zorro7xx-scsi",
+			host)) {
+		printk(KERN_ERR "zorro7xx: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	scsi_scan_host(host);
+
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_free:
+	if (ioaddr > 0x01000000)
+		iounmap(hostdata->base);
+	kfree(hostdata);
+ out_release:
+	zorro_release_device(z);
+
+	return -ENODEV;
+}
+
+static __devexit void zorro7xx_remove_one(struct zorro_dev *z)
+{
+	struct Scsi_Host *host = dev_to_shost(&z->dev);
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+
+	scsi_remove_host(host);
+
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	zorro_release_device(z);
+}
+
+static struct zorro_driver zorro7xx_driver = {
+	.name	  = "zorro7xx-scsi",
+	.id_table = zorro7xx_zorro_tbl,
+	.probe	  = zorro7xx_init_one,
+	.remove	  = __devexit_p(zorro7xx_remove_one),
+};
+
+static int __init zorro7xx_scsi_init(void)
+{
+	return zorro_register_driver(&zorro7xx_driver);
+}
+
+static void __exit zorro7xx_scsi_exit(void)
+{
+	zorro_unregister_driver(&zorro7xx_driver);
+}
+
+module_init(zorro7xx_scsi_init);
+module_exit(zorro7xx_scsi_exit);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
