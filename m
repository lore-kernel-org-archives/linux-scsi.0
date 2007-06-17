From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 2/5] 53c700 scsi: m68k BVME6000 NCR53C710 SCSI
Date: Sun, 17 Jun 2007 14:47:06 +0200
Message-ID: <20070617125030.075271747@mail.of.borg>
References: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:36105 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759919AbXFQMvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2007 08:51:55 -0400
Received: from agave.telenet-ops.be (agave.telenet-ops.be [195.130.137.77])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id 219BA9DEA1
	for <linux-scsi@vger.kernel.org>; Sun, 17 Jun 2007 14:51:54 +0200 (CEST)
Content-Disposition: inline; filename=m68k-53c700-bvme6000.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

New driver for the BVME6000 NCR53C710 SCSI controller, using the 53c700 SCSI
core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig         |    6 -
 drivers/scsi/Makefile        |    1 
 drivers/scsi/bvme6000_scsi.c |  135 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+), 3 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1008,7 +1008,7 @@ config SCSI_STEX
 
 config 53C700_BE_BUS
 	bool
-	depends on M68K
+	depends on BVME6000_SCSI
 	default y
 
 config SCSI_SYM53C8XX_2
@@ -1725,8 +1725,8 @@ config MVME16x_SCSI
 	  will want to say Y to this question.
 
 config BVME6000_SCSI
-	bool "NCR53C710 SCSI driver for BVME6000"
-	depends on BVME6000 && SCSI && BROKEN
+	tristate "NCR53C710 SCSI driver for BVME6000"
+	depends on BVME6000 && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_ATARI_SCSI)	+= atari_scsi.o
 obj-$(CONFIG_MAC_SCSI)		+= mac_scsi.o
 obj-$(CONFIG_SCSI_MAC_ESP)	+= mac_esp.o	NCR53C9x.o
 obj-$(CONFIG_SUN3_SCSI)		+= sun3_scsi.o  sun3_scsi_vme.o
+obj-$(CONFIG_BVME6000_SCSI)	+= 53c700.o	bvme6000_scsi.o
 obj-$(CONFIG_SCSI_SIM710)	+= 53c700.o	sim710.o
 obj-$(CONFIG_SCSI_ADVANSYS)	+= advansys.o
 obj-$(CONFIG_SCSI_PSI240I)	+= psi240i.o
--- /dev/null
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -0,0 +1,135 @@
+/*
+ * Detection routine for the NCR53c710 based BVME6000 SCSI Controllers for Linux.
+ *
+ * Based on work by Alan Hourihane and Kars de Jong
+ *
+ * Rewritten to use 53c700.c by Richard Hirst <richard@sleepie.demon.co.uk>
+ */
+
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/bvme6000hw.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Richard Hirst <richard@sleepie.demon.co.uk>");
+MODULE_DESCRIPTION("BVME6000 NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+static struct scsi_host_template bvme6000_scsi_driver_template = {
+	.name			= "BVME6000 NCR53c710 SCSI",
+	.proc_name		= "BVME6000",
+	.this_id		= 7,
+	.module			= THIS_MODULE,
+};
+
+static struct platform_device *bvme6000_scsi_device;
+
+static __devinit int
+bvme6000_probe(struct device *dev)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!MACH_IS_BVME6000)
+		goto out;
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "bvme6000-scsi: "
+				"Failed to allocate host data\n");
+		goto out;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;
+	hostdata->clock = 40;	/* XXX - depends on the CPU clock! */
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+	hostdata->ctest7_extra = CTEST7_TT1;
+
+	/* and register the chip */
+	host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev);
+	if (!host) {
+		printk(KERN_ERR "bvme6000-scsi: No host detected; "
+				"board configuration problem?\n");
+		goto out_free;
+	}
+	host->base = BVME_NCR53C710_BASE;
+	host->this_id = 7;
+	host->irq = BVME_IRQ_SCSI;
+	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0, "bvme6000-scsi",
+			host)) {
+		printk(KERN_ERR "bvme6000-scsi: request_irq failed\n");
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
+ out:
+	return -ENODEV;
+}
+
+static __devexit int
+bvme6000_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+
+	return 0;
+}
+
+static struct device_driver bvme6000_scsi_driver = {
+	.name	= "bvme6000-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= bvme6000_probe,
+	.remove	= __devexit_p(bvme6000_device_remove),
+};
+
+static int __init bvme6000_scsi_init(void)
+{
+	int err;
+
+	err = driver_register(&bvme6000_scsi_driver);
+	if (err) {
+		return err;
+
+	bvme6000_scsi_device = platform_device_register_simple("bvme6000-scsi",
+							       -1, NULL, 0);
+	if (IS_ERR(bvme6000_scsi_device)) {
+		driver_unregister(&bvme6000_scsi_driver);
+		return PTR_ERR(bvme6000_scsi_device);
+	}
+
+	return 0;
+}
+
+static void __exit bvme6000_scsi_exit(void)
+{
+	platform_device_unregister(bvme6000_scsi_device);
+	driver_unregister(&bvme6000_scsi_driver);
+}
+
+module_init(bvme6000_scsi_init);
+module_exit(bvme6000_scsi_exit);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

