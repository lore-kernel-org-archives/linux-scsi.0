From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 3/5] 53c700 scsi: m68k MVME16x NCR53C710 SCSI
Date: Sun, 17 Jun 2007 14:47:07 +0200
Message-ID: <20070617125030.281210045@mail.of.borg>
References: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:36102 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXFQMvy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2007 08:51:54 -0400
Received: from hoboe1bl1.telenet-ops.be (hoboe1bl1.telenet-ops.be [195.130.137.72])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id 9042F9DD7D
	for <linux-scsi@vger.kernel.org>; Sun, 17 Jun 2007 14:51:53 +0200 (CEST)
Content-Disposition: inline; filename=m68k-53c700-mvme16x.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

New driver for the MVME16x NCR53C710 SCSI controller, using the 53c700 SCSI
core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig        |    6 -
 drivers/scsi/Makefile       |    1 
 drivers/scsi/mvme16x_scsi.c |  158 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 3 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1008,7 +1008,7 @@ config SCSI_STEX
 
 config 53C700_BE_BUS
 	bool
-	depends on BVME6000_SCSI
+	depends on MVME16x_SCSI || BVME6000_SCSI
 	default y
 
 config SCSI_SYM53C8XX_2
@@ -1716,8 +1716,8 @@ config MVME147_SCSI
 	  single-board computer.
 
 config MVME16x_SCSI
-	bool "NCR53C710 SCSI driver for MVME16x"
-	depends on MVME16x && SCSI && BROKEN
+	tristate "NCR53C710 SCSI driver for MVME16x"
+	depends on MVME16x && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_ATARI_SCSI)	+= atari_scsi.o
 obj-$(CONFIG_MAC_SCSI)		+= mac_scsi.o
 obj-$(CONFIG_SCSI_MAC_ESP)	+= mac_esp.o	NCR53C9x.o
 obj-$(CONFIG_SUN3_SCSI)		+= sun3_scsi.o  sun3_scsi_vme.o
+obj-$(CONFIG_MVME16x_SCSI)	+= 53c700.o	mvme16x_scsi.o
 obj-$(CONFIG_BVME6000_SCSI)	+= 53c700.o	bvme6000_scsi.o
 obj-$(CONFIG_SCSI_SIM710)	+= 53c700.o	sim710.o
 obj-$(CONFIG_SCSI_ADVANSYS)	+= advansys.o
--- /dev/null
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -0,0 +1,158 @@
+/*
+ * Detection routine for the NCR53c710 based MVME16x SCSI Controllers for Linux.
+ *
+ * Based on work by Alan Hourihane
+ *
+ * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
+ */
+
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/mvme16xhw.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("MVME16x NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+static struct scsi_host_template mvme16x_scsi_driver_template = {
+	.name			= "MVME16x NCR53c710 SCSI",
+	.proc_name		= "MVME16x",
+	.this_id		= 7,
+	.module			= THIS_MODULE,
+};
+
+static struct platform_device *mvme16x_scsi_device;
+
+static __devinit int
+mvme16x_probe(struct device *dev)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!MACH_IS_MVME16x)
+		goto out;
+
+	if (mvme16x_config & MVME16x_CONFIG_NO_SCSICHIP) {
+		printk(KERN_INFO "mvme16x-scsi: detection disabled, "
+				 "SCSI chip not present\n");
+		goto out;
+	}
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "mvme16x-scsi: "
+				"Failed to allocate host data\n");
+		goto out;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)0xfff47000UL;
+	hostdata->clock = 50;	/* XXX - depends on the CPU clock! */
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+	hostdata->ctest7_extra = CTEST7_TT1;
+
+	/* and register the chip */
+	host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "mvme16x-scsi: No host detected; "
+				"board configuration problem?\n");
+		goto out_free;
+	}
+	host->this_id = 7;
+	host->base = 0xfff47000UL;
+	host->irq = MVME16x_IRQ_SCSI;
+	if (request_irq(host->irq, NCR_700_intr, 0, "mvme16x-scsi", host)) {
+		printk(KERN_ERR "mvme16x-scsi: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	/* Enable scsi chip ints */
+	{
+		volatile unsigned long v;
+
+		/* Enable scsi interrupts at level 4 in PCCchip2 */
+		v = in_be32(0xfff4202c);
+		v = (v & ~0xff) | 0x10 | 4;
+		out_be32(0xfff4202c, v);
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
+ out:
+	return -ENODEV;
+}
+
+static __devexit int
+mvme16x_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+
+	/* Disable scsi chip ints */
+	{
+		volatile unsigned long v;
+
+		v = in_be32(0xfff4202c);
+		v &= ~0x10;
+		out_be32(0xfff4202c, v);
+	}
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+
+	return 0;
+}
+
+static struct device_driver mvme16x_scsi_driver = {
+	.name	= "mvme16x-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= mvme16x_probe,
+	.remove	= __devexit_p(mvme16x_device_remove),
+};
+
+static int __init mvme16x_scsi_init(void)
+{
+	int err;
+
+	err = driver_register(&mvme16x_scsi_driver);
+	if (err)
+		return err;
+
+	mvme16x_scsi_device = platform_device_register_simple("mvme16x-scsi",
+							      -1, NULL, 0);
+	if (IS_ERR(mvme16x_scsi_device)) {
+		driver_unregister(&mvme16x_scsi_driver);
+		return PTR_ERR(mvme16x_scsi_device);
+	}
+
+	return 0;
+}
+
+static void __exit mvme16x_scsi_exit(void)
+{
+	platform_device_unregister(mvme16x_scsi_device);
+	driver_unregister(&mvme16x_scsi_driver);
+}
+
+module_init(mvme16x_scsi_init);
+module_exit(mvme16x_scsi_exit);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

