From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: PATCH: SNI RM 53c710 driver
Date: Mon, 25 Dec 2006 21:32:04 +0100
Message-ID: <20061225203204.GB3293@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:32802 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbWLYV75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Dec 2006 16:59:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This patch adds a SCSI driver for the onboard 53c710 chip of some
SNI RM machines.

Thomas.

=46rom ec2d61072027892d67a34d261bd39b32bacd1e64 Mon Sep 17 00:00:00 200=
1
=46rom: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Mon, 25 Dec 2006 21:04:17 +0100
Subject: [PATCH] Support for onboard SCSI controller on older SNI RM ma=
chines

---
 drivers/scsi/Kconfig      |    9 +++
 drivers/scsi/Makefile     |    1 +
 drivers/scsi/sni_53c710.c |  159 +++++++++++++++++++++++++++++++++++++=
++++++++
 3 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 60f5827..9417042 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -973,6 +973,15 @@ config SCSI_LASI700
 	  many PA-RISC workstations & servers.  If you do not know whether yo=
u
 	  have a Lasi chip, it is safe to say "Y" here.
=20
+config SCSI_SNI_53C710
+	tristate "SNI RM SCSI support for 53c710"
+	depends on SNI_RM && SCSI
+	select SCSI_SPI_ATTRS
+	select 53C700_LE_ON_BE
+	help
+	  This is a driver for the onboard SCSI controller found in older
+	  SNI RM workstations & servers.=20
+
 config 53C700_LE_ON_BE
 	bool
 	depends on SCSI_LASI700
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index bd7c988..79ecf4e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -124,6 +124,7 @@ obj-$(CONFIG_JAZZ_ESP)		+=3D NCR53C9x.o	ja
 obj-$(CONFIG_SUN3X_ESP)		+=3D NCR53C9x.o	sun3x_esp.o
 obj-$(CONFIG_SCSI_FCAL)		+=3D fcal.o
 obj-$(CONFIG_SCSI_LASI700)	+=3D 53c700.o lasi700.o
+obj-$(CONFIG_SCSI_SNI_53C710)	+=3D 53c700.o sni_53c710.o
 obj-$(CONFIG_SCSI_NSP32)	+=3D nsp32.o
 obj-$(CONFIG_SCSI_IPR)		+=3D ipr.o
 obj-$(CONFIG_SCSI_SRP)		+=3D libsrp.o
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
new file mode 100644
index 0000000..163fd44
--- /dev/null
+++ b/drivers/scsi/sni_53c710.c
@@ -0,0 +1,159 @@
+/* -*- mode: c; c-basic-offset: 8 -*- */
+
+/* SNI RM driver
+ *
+ * Copyright (C) 2001 by James.Bottomley@HansenPartnership.com
+**--------------------------------------------------------------------=
---------
+** =20
+**  This program is free software; you can redistribute it and/or modi=
fy
+**  it under the terms of the GNU General Public License as published =
by
+**  the Free Software Foundation; either version 2 of the License, or
+**  (at your option) any later version.
+**
+**  This program is distributed in the hope that it will be useful,
+**  but WITHOUT ANY WARRANTY; without even the implied warranty of
+**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+**  GNU General Public License for more details.
+**
+**  You should have received a copy of the GNU General Public License
+**  along with this program; if not, write to the Free Software
+**  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+**
+**--------------------------------------------------------------------=
---------
+ */
+
+/*
+ * Based on lasi700.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/stat.h>
+#include <linux/mm.h>
+#include <linux/blkdev.h>
+#include <linux/sched.h>
+#include <linux/ioport.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/irq.h>
+#include <asm/delay.h>
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Thomas Bogend=F6rfer");
+MODULE_DESCRIPTION("SNI RM 53c710 SCSI Driver");
+MODULE_LICENSE("GPL");
+
+#define SNIRM710_CLOCK	32
+
+static struct scsi_host_template snirm710_template =3D {
+	.name		=3D "SNI RM SCSI 53c710",
+	.proc_name	=3D "snirm_53c710",
+	.this_id	=3D 7,
+	.module		=3D THIS_MODULE,
+};
+
+static int __init snirm710_probe(struct platform_device *dev)
+{
+	unsigned long base;
+	struct NCR_700_Host_Parameters *hostdata;
+	struct Scsi_Host *host;
+	struct  resource *res;
+
+	res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	base =3D res->start;
+	hostdata =3D kzalloc(sizeof(*hostdata), GFP_KERNEL);
+	if (!hostdata) {
+		printk(KERN_ERR "%s: Failed to allocate host data\n",
+		       dev->dev.bus_id);
+		return -ENOMEM;
+	}
+
+	hostdata->dev =3D &dev->dev;
+	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
+	hostdata->base =3D ioremap_nocache(CPHYSADDR(base), 0x100);
+	hostdata->differential =3D 0;
+
+	hostdata->clock =3D SNIRM710_CLOCK;
+	hostdata->force_le_on_be =3D 1;
+	hostdata->chip710 =3D 1;
+	hostdata->burst_length =3D 4;
+
+	host =3D NCR_700_detect(&snirm710_template, hostdata, &dev->dev);
+	if (!host)
+		goto out_kfree;
+	host->this_id =3D 7;
+	host->base =3D base;
+	host->irq =3D platform_get_irq(dev, 0);
+	if(request_irq(host->irq, NCR_700_intr, SA_SHIRQ, "snirm710", host)) =
{
+		printk(KERN_ERR "snirm710: request_irq failed!\n");
+		goto out_put_host;
+	}
+
+	dev_set_drvdata(&dev->dev, host);
+	scsi_scan_host(host);
+
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_kfree:
+	iounmap(hostdata->base);
+	kfree(hostdata);
+	return -ENODEV;
+}
+
+static int __exit snirm710_driver_remove(struct platform_device *dev)
+{
+	struct Scsi_Host *host =3D dev_get_drvdata(&dev->dev);
+	struct NCR_700_Host_Parameters *hostdata =3D=20
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	free_irq(host->irq, host);
+	iounmap(hostdata->base);
+	kfree(hostdata);
+
+	return 0;
+}
+
+static struct platform_driver snirm710_driver =3D {
+	.probe	=3D snirm710_probe,
+	.remove	=3D __devexit_p(snirm710_driver_remove),
+	.driver	=3D {
+		.name	=3D "snirm_53c710",
+	},
+};
+
+static int __init snirm710_init(void)
+{
+	int err;
+=09
+	if ((err =3D platform_driver_register(&snirm710_driver))) {
+		printk(KERN_ERR "Driver registration failed\n");
+		return err;
+	}
+	return 0;
+}
+
+static void __exit snirm710_exit(void)
+{
+	platform_driver_unregister(&snirm710_driver);
+}
+
+module_init(snirm710_init);
+module_exit(snirm710_exit);
--=20
1.4.3.2

--=20
Crap can work. Given enough thrust pigs will fly, but it's not necessar=
y a
good idea.                                                [ RFC1925, 2.=
3 ]
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
