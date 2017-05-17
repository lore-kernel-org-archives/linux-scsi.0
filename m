From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/22] scsi: hisi_sas: add bare v3 hw driver
Date: Wed, 17 May 2017 18:49:43 +0800
Message-ID: <1495018197-120535-9-git-send-email-john.garry@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Add new file hisi_sas_v3_hw.c for hip08 support.

The controller design is quite similar to v2 hw in hip07.

However key differences include:
-All v2 hw bugs are fixed (hopefully), so workarounds are not
required
-support for device deregistration
-some interrupt modifications
-configurable max device support

Not yet supported:
- controller reset

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/Makefile         |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 57 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index 3a036a8..54774a4 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o hisi_sas_v2_hw.o
 obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+= hisi_sas_pci_init.o
+obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+= hisi_sas_v3_hw.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
new file mode 100644
index 0000000..80707f6
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -0,0 +1,57 @@
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
+static const struct hisi_sas_hw hisi_sas_v3_hw = {
+};
+
+enum {
+	/* instances of the controller */
+	hip08,
+};
+
+static const struct hisi_sas_pci_hw hisi_sas_pci_hw_info[] = {
+	[hip08] = {8, 16, &hisi_sas_v3_hw},
+};
+
+static const struct pci_device_id sas_v3_pci_table[] = {
+	{ PCI_VDEVICE(HUAWEI, 0xa230), hip08},
+	{}
+};
+
+static int
+hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	const struct hisi_sas_pci_hw *hw;
+
+	hw = &hisi_sas_pci_hw_info[ent->driver_data];
+	return hisi_sas_pci_probe(pdev, hw);
+}
+
+static void hisi_sas_v3_remove(struct pci_dev *pdev)
+{
+	hisi_sas_pci_remove(pdev);
+}
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
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS controller v3 hw driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1
