From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 2/4] fdomain: Resurrect driver (PCI support)
Date: Mon, 22 Apr 2019 19:33:21 +0200
Message-ID: <20190422173323.15365-3-linux@zary.sk>
References: <20190422173323.15365-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190422173323.15365-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Future Domain TMC-3260/AHA-2920A PCI card support.

Tested on Adaptec AHA-2920A PCI card.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/Kconfig       | 17 ++++++++++++
 drivers/scsi/Makefile      |  1 +
 drivers/scsi/fdomain_pci.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)
 create mode 100644 drivers/scsi/fdomain_pci.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3d6b1f47cbb5..f9d058a07e2a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -667,6 +667,23 @@ config SCSI_FDOMAIN
 	tristate
 	depends on SCSI
 
+config SCSI_FDOMAIN_PCI
+	tristate "Future Domain TMC-3260/AHA-2920A PCI SCSI support"
+	depends on PCI && SCSI
+	select SCSI_FDOMAIN
+	help
+	  This is support for Future Domain's PCI SCSI host adapters (TMC-3260)
+	  and other adapters with PCI bus based on the Future Domain chipsets
+	  (Adaptec AHA-2920A).
+
+	  NOTE: Newer Adaptec AHA-2920C boards use the Adaptec AIC-7850 chip
+	  and should use the aic7xxx driver ("Adaptec AIC7xxx chipset SCSI
+	  controller support"). This Future Domain driver works with the older
+	  Adaptec AHA-2920A boards with a Future Domain chip on them.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain_pci.
+
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b8fbc6d2de54..f6cc4fbe6957 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_SCSI_PM8001)	+= pm8001/
 obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_FDOMAIN)	+= fdomain.o
+obj-$(CONFIG_SCSI_FDOMAIN_PCI)	+= fdomain_pci.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
diff --git a/drivers/scsi/fdomain_pci.c b/drivers/scsi/fdomain_pci.c
new file mode 100644
index 000000000000..381a7157c078
--- /dev/null
+++ b/drivers/scsi/fdomain_pci.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include "fdomain.h"
+
+static int fdomain_pci_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *d)
+{
+	int err;
+	struct Scsi_Host *sh;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto fail;
+
+	err = pci_request_regions(pdev, "fdomain_pci");
+	if (err)
+		goto disable_device;
+
+	err = -ENODEV;
+	if (pci_resource_len(pdev, 0) == 0)
+		goto release_region;
+
+	sh = fdomain_create(pci_resource_start(pdev, 0), pdev->irq, 7, 0, NULL,
+			    &pdev->dev);
+	if (!sh)
+		goto release_region;
+
+	pci_set_drvdata(pdev, sh);
+	return 0;
+
+release_region:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+fail:
+	return err;
+}
+
+static void fdomain_pci_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *sh = pci_get_drvdata(pdev);
+
+	fdomain_destroy(sh);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id fdomain_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, fdomain_pci_table);
+
+static struct pci_driver fdomain_pci_driver = {
+	.name		= "fdomain_pci",
+	.id_table	= fdomain_pci_table,
+	.probe		= fdomain_pci_probe,
+	.remove		= fdomain_pci_remove,
+	.driver.pm	= FDOMAIN_PM_OPS,
+};
+
+module_pci_driver(fdomain_pci_driver);
+
+MODULE_AUTHOR("Ondrej Zary, Rickard E. Faith");
+MODULE_DESCRIPTION("Future Domain TMC-3260 PCI SCSI driver");
+MODULE_LICENSE("GPL");
-- 
Ondrej Zary
