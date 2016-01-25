From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 07/23] hisi_sas: add bare v2 hw driver
Date: Tue, 26 Jan 2016 01:21:56 +0800
Message-ID: <1453742532-53092-8-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Just add enough to build and init the module.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/Makefile         |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 48 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index 3e70eae..c6d3a1b 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
-obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o
+obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o hisi_sas_v2_hw.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
new file mode 100644
index 0000000..0f7f2af
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2016 Linaro Ltd.
+ * Copyright (c) 2016 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include "hisi_sas.h"
+#define DRV_NAME "hisi_sas_v2_hw"
+
+static const struct hisi_sas_hw hisi_sas_v2_hw = {
+};
+
+static int hisi_sas_v2_probe(struct platform_device *pdev)
+{
+	return hisi_sas_probe(pdev, &hisi_sas_v2_hw);
+}
+
+static int hisi_sas_v2_remove(struct platform_device *pdev)
+{
+	return hisi_sas_remove(pdev);
+}
+
+static const struct of_device_id sas_v2_of_match[] = {
+	{ .compatible = "hisilicon,hip06-sas-v2",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, sas_v2_of_match);
+
+static struct platform_driver hisi_sas_v2_driver = {
+	.probe = hisi_sas_v2_probe,
+	.remove = hisi_sas_v2_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = sas_v2_of_match,
+	},
+};
+
+module_platform_driver(hisi_sas_v2_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS controller v2 hw driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1
