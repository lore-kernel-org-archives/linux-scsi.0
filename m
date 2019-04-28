From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH 4/4] fdomain: Resurrect driver (PCMCIA support)
Date: Sun, 28 Apr 2019 22:06:26 +0200
Message-ID: <20190428200626.28092-5-linux@zary.sk>
References: <20190428200626.28092-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190428200626.28092-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Future Domain PCMCIA SCSI support card support.

Currently untested.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/pcmcia/Kconfig      | 10 +++++
 drivers/scsi/pcmcia/Makefile     |  1 +
 drivers/scsi/pcmcia/fdomain_cs.c | 89 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)
 create mode 100644 drivers/scsi/pcmcia/fdomain_cs.c

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
index 000000000000..eee1379ad67b
--- /dev/null
+++ b/drivers/scsi/pcmcia/fdomain_cs.c
@@ -0,0 +1,89 @@
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
+	p_dev->resource[0]->end = 0x10;
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
+		goto fail;
+
+	sh = fdomain_create(link->resource[0]->start, link->irq, 7, 0, NULL,
+			    &link->dev);
+	if (!sh) {
+		dev_err(&link->dev, "Controller initialization failed");
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	link->priv = sh;
+
+	return 0;
+
+fail:
+	pcmcia_disable_device(link);
+	return ret;
+}
+
+static void fdomain_remove(struct pcmcia_device *link)
+{
+	fdomain_destroy(link->priv);
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
