From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH] fdomain: Add PCMCIA support
Date: Mon, 27 May 2019 22:19:47 +0200
Message-ID: <20190527201947.6475-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add PCMCIA card support to Future Domain SCSI driver.

Tested with IBM SCSI PCMCIA Adapter 40G1890.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/fdomain.c           |  7 ++-
 drivers/scsi/pcmcia/Kconfig      | 10 +++++
 drivers/scsi/pcmcia/Makefile     |  1 +
 drivers/scsi/pcmcia/fdomain_cs.c | 95 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/pcmcia/fdomain_cs.c

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 297ccc799436..b5e66971b6d9 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -510,6 +510,7 @@ struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
 	static const char * const chip_names[] = {
 		"Unknown", "TMC-1800", "TMC-18C50", "TMC-18C30"
 	};
+	unsigned long irq_flags = 0;
 
 	chip = fdomain_identify(base);
 	if (!chip)
@@ -541,8 +542,10 @@ struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
 	fd->chip = chip;
 	INIT_WORK(&fd->work, fdomain_work);
 
-	if (request_irq(irq, fdomain_irq, dev_is_pci(dev) ? IRQF_SHARED : 0,
-			  "fdomain", fd))
+	if (dev_is_pci(dev) || !strcmp(dev->bus->name, "pcmcia"))
+		irq_flags = IRQF_SHARED;
+
+	if (request_irq(irq, fdomain_irq, irq_flags, "fdomain", fd))
 		goto fail_put;
 
 	shost_printk(KERN_INFO, sh, "%s chip at 0x%x irq %d SCSI ID %d\n",
diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 2d435f105b16..169d93f90a30 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -19,6 +19,16 @@ config PCMCIA_AHA152X
 	  To compile this driver as a module, choose M here: the
 	  module will be called aha152x_cs.
 
+config PCMCIA_FDOMAIN
+	tristate "Future Domain PCMCIA support"
+	select SCSI_FDOMAIN
+	help
+	  Say Y here if you intend to attach this type of PCMCIA SCSI host
+	  adapter to your computer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain_cs.
+
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
 	depends on !64BIT
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index a5a24dd44e7e..02f5b44a2685 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -4,6 +4,7 @@ ccflags-y		:= -I $(srctree)/drivers/scsi
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
+obj-$(CONFIG_PCMCIA_FDOMAIN)	+= fdomain_cs.o
 obj-$(CONFIG_PCMCIA_AHA152X)	+= aha152x_cs.o
 obj-$(CONFIG_PCMCIA_NINJA_SCSI)	+= nsp_cs.o
 obj-$(CONFIG_PCMCIA_SYM53C500)	+= sym53c500_cs.o
diff --git a/drivers/scsi/pcmcia/fdomain_cs.c b/drivers/scsi/pcmcia/fdomain_cs.c
new file mode 100644
index 000000000000..e42acf314d06
--- /dev/null
+++ b/drivers/scsi/pcmcia/fdomain_cs.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MPL-1.1)
+/*
+ * Driver for Future Domain-compatible PCMCIA SCSI cards
+ * Copyright 2019 Ondrej Zary
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_host.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+#include "fdomain.h"
+
+MODULE_AUTHOR("Ondrej Zary, David Hinds");
+MODULE_DESCRIPTION("Future Domain PCMCIA SCSI driver");
+MODULE_LICENSE("Dual MPL/GPL");
+
+static int fdomain_config_check(struct pcmcia_device *p_dev, void *priv_data)
+{
+	p_dev->io_lines = 10;
+	p_dev->resource[0]->end = FDOMAIN_REGION_SIZE;
+	p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
+	p_dev->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
+	return pcmcia_request_io(p_dev);
+}
+
+static int fdomain_probe(struct pcmcia_device *link)
+{
+	int ret;
+	struct Scsi_Host *sh;
+
+	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
+	link->config_regs = PRESENT_OPTION;
+
+	ret = pcmcia_loop_config(link, fdomain_config_check, NULL);
+	if (ret)
+		return ret;
+
+	ret = pcmcia_enable_device(link);
+	if (ret)
+		goto fail_disable;
+
+	if (!request_region(link->resource[0]->start, FDOMAIN_REGION_SIZE,
+			    "fdomain_cs"))
+		goto fail_disable;
+
+	sh = fdomain_create(link->resource[0]->start, link->irq, 7, &link->dev);
+	if (!sh) {
+		dev_err(&link->dev, "Controller initialization failed");
+		ret = -ENODEV;
+		goto fail_release;
+	}
+
+	link->priv = sh;
+
+	return 0;
+
+fail_release:
+	release_region(link->resource[0]->start, FDOMAIN_REGION_SIZE);
+fail_disable:
+	pcmcia_disable_device(link);
+	return ret;
+}
+
+static void fdomain_remove(struct pcmcia_device *link)
+{
+	fdomain_destroy(link->priv);
+	release_region(link->resource[0]->start, FDOMAIN_REGION_SIZE);
+	pcmcia_disable_device(link);
+}
+
+static const struct pcmcia_device_id fdomain_ids[] = {
+	PCMCIA_DEVICE_PROD_ID12("IBM Corp.", "SCSI PCMCIA Card", 0xe3736c88,
+				0x859cad20),
+	PCMCIA_DEVICE_PROD_ID1("SCSI PCMCIA Adapter Card", 0x8dacb57e),
+	PCMCIA_DEVICE_PROD_ID12(" SIMPLE TECHNOLOGY Corporation",
+				"SCSI PCMCIA Credit Card Controller",
+				0x182bdafe, 0xc80d106f),
+	PCMCIA_DEVICE_NULL,
+};
+MODULE_DEVICE_TABLE(pcmcia, fdomain_ids);
+
+static struct pcmcia_driver fdomain_cs_driver = {
+	.owner		= THIS_MODULE,
+	.name		= "fdomain_cs",
+	.probe		= fdomain_probe,
+	.remove		= fdomain_remove,
+	.id_table       = fdomain_ids,
+};
+
+module_pcmcia_driver(fdomain_cs_driver);
-- 
Ondrej Zary
