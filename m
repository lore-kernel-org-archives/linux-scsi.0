From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 09/23] scsi: hisi_sas: add skeleton v3 hw driver
Date: Wed, 31 May 2017 22:33:01 +0800
Message-ID: <1496241195-217678-10-git-send-email-john.garry@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Add skeleton driver for v3 hw in hisi_sas_v3_hw.c

File hisi_sas_v3_hw.c will serve 2 purposes:
- probing and initialisation of the controller based on pci device
- hw layer for v3-based controllers

The controller design is quite similar to v2 hw in hip07.

However key differences include:
-All v2 hw bugs are fixed (hopefully), so workarounds are not
required
-support for device deregistration
-some interrupt modifications
-configurable max device support

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/Kconfig          | 10 +++++++-
 drivers/scsi/hisi_sas/Makefile         |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 47 ++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 975dbf0..a5ca080 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -6,4 +6,12 @@ config SCSI_HISI_SAS
 	select BLK_DEV_INTEGRITY
 	depends on ATA
 	help
-		This driver supports HiSilicon's SAS HBA
+		This driver supports HiSilicon's SAS HBA, including support based
+		on platform device
+
+config SCSI_HISI_SAS_PCI
+	tristate "HiSilicon SAS on PCI bus"
+	depends on SCSI_HISI_SAS
+	depends on PCI
+	help
+		This driver supports HiSilicon's SAS HBA based on PCI device
diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index c6d3a1b..24623f2 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o hisi_sas_v2_hw.o
+obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+= hisi_sas_v3_hw.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
new file mode 100644
index 0000000..cf72577
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2017 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include "hisi_sas.h"
+#define DRV_NAME "hisi_sas_v3_hw"
+
+static int
+hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return 0;
+}
+
+static void hisi_sas_v3_remove(struct pci_dev *pdev)
+{
+}
+
+enum {
+	/* instances of the controller */
+	hip08,
+};
+
+static const struct pci_device_id sas_v3_pci_table[] = {
+	{ PCI_VDEVICE(HUAWEI, 0xa230), hip08 },
+	{}
+};
+
+static struct pci_driver sas_v3_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= sas_v3_pci_table,
+	.probe		= hisi_sas_v3_probe,
+	.remove		= hisi_sas_v3_remove,
+};
+
+module_pci_driver(sas_v3_pci_driver);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS controller v3 hw driver based on pci device");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1
