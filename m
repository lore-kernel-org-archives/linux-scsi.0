From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 4/5] 53c700 scsi: Amiga 4000T NCR53c710 SCSI
Date: Sun, 17 Jun 2007 14:47:08 +0200
Message-ID: <20070617125030.484942624@mail.of.borg>
References: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astra.telenet-ops.be ([195.130.132.58]:51640 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065AbXFQMwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2007 08:52:18 -0400
Content-Disposition: inline; filename=m68k-53c700-a4000t.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

New driver for the Amiga 4000T built-in NCR53c710 SCSI controller, using the
53c700 SCSI core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig  |   14 ++++
 drivers/scsi/Makefile |    1 
 drivers/scsi/a4000t.c |  142 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 155 insertions(+), 2 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1008,7 +1008,7 @@ config SCSI_STEX
 
 config 53C700_BE_BUS
 	bool
-	depends on MVME16x_SCSI || BVME6000_SCSI
+	depends on SCSI_A4000T || MVME16x_SCSI || BVME6000_SCSI
 	default y
 
 config SCSI_SYM53C8XX_2
@@ -1615,13 +1615,23 @@ config FASTLANE_SCSI
 	  If you have the Phase5 Fastlane Z3 SCSI controller, or plan to use
 	  one in the near future, say Y to this question. Otherwise, say N.
 
+config SCSI_A4000T
+	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
+	depends on AMIGA && SCSI && EXPERIMENTAL
+	select SCSI_SPI_ATTRS
+	help
+	  If you have an Amiga 4000T and have SCSI devices connected to the
+	  built-in SCSI controller, say Y. Otherwise, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called a4000t.
+
 config SCSI_AMIGA7XX
 	bool "Amiga NCR53c710 SCSI support (EXPERIMENTAL)"
 	depends on AMIGA && SCSI && EXPERIMENTAL && BROKEN
 	help
 	  Support for various NCR53c710-based SCSI controllers on the Amiga.
 	  This includes:
-	    - the builtin SCSI controller on the Amiga 4000T,
 	    - the Amiga 4091 Zorro III SCSI-2 controller,
 	    - the MacroSystem Development's WarpEngine Amiga SCSI-2 controller
 	      (info at
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
+obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o
 obj-$(CONFIG_GVP11_SCSI)	+= gvp11.o	wd33c93.o
--- /dev/null
+++ b/drivers/scsi/a4000t.c
@@ -0,0 +1,142 @@
+/*
+ * Detection routine for the NCR53c710 based Amiga SCSI Controllers for Linux.
+ *		Amiga Technologies A4000T SCSI controller.
+ *
+ * Written 1997 by Alan Hourihane <alanh@fairlite.demon.co.uk>
+ * plus modifications of the 53c7xx.c driver to support the Amiga.
+ *
+ * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/amigaints.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("Amiga A4000T NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+
+static struct scsi_host_template a4000t_scsi_driver_template = {
+	.name		= "A4000T builtin SCSI",
+	.proc_name	= "A4000t",
+	.this_id	= 7,
+	.module		= THIS_MODULE,
+};
+
+static struct platform_device *a4000t_scsi_device;
+
+#define A4000T_SCSI_ADDR 0xdd0040
+
+static int __devinit a4000t_probe(struct device *dev)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
+		goto out;
+
+	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000,
+				"A4000T builtin SCSI"))
+		goto out;
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
+		goto out_release;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
+	hostdata->clock = 50;
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+
+	/* and register the chip */
+	host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "a4000t-scsi: No host detected; "
+				"board configuration problem?\n");
+		goto out_free;
+	}
+
+	host->this_id = 7;
+	host->base = A4000T_SCSI_ADDR;
+	host->irq = IRQ_AMIGA_PORTS;
+
+	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "a4000t-scsi",
+			host)) {
+		printk(KERN_ERR "a4000t-scsi: request_irq failed\n");
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
+	kfree(hostdata);
+ out_release:
+	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
+ out:
+	return -ENODEV;
+}
+
+static __devexit int a4000t_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+
+	scsi_remove_host(host);
+
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
+
+	return 0;
+}
+
+static struct device_driver a4000t_scsi_driver = {
+	.name	= "a4000t-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= a4000t_probe,
+	.remove	= __devexit_p(a4000t_device_remove),
+};
+
+static int __init a4000t_scsi_init(void)
+{
+	int err;
+
+	err = driver_register(&a4000t_scsi_driver);
+	if (err)
+		return err;
+
+	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi",
+			-1, NULL, 0);
+	if (IS_ERR(a4000t_scsi_device)) {
+		driver_unregister(&a4000t_scsi_driver);
+		return PTR_ERR(a4000t_scsi_device);
+	}
+
+	return err;
+}
+
+static void __exit a4000t_scsi_exit(void)
+{
+	platform_device_unregister(a4000t_scsi_device);
+	driver_unregister(&a4000t_scsi_driver);
+}
+
+module_init(a4000t_scsi_init);
+module_exit(a4000t_scsi_exit);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

