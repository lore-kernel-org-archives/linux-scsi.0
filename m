From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 17/32] scsi: hisi_sas: add v1 hw module init
Date: Tue, 10 Nov 2015 00:32:22 +0800
Message-ID: <1447086757-147706-18-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:13586 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbKIQTA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:19:00 -0500
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Add module init code for v1 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/Makefile         |  1 +
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 53 ++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index d86b05e..3e70eae 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
+obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 146a236..de5b4d3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -271,5 +271,8 @@ union hisi_sas_command_table {
 	struct hisi_sas_command_table_smp smp;
 	struct hisi_sas_command_table_stp stp;
 };
+extern int hisi_sas_probe(struct platform_device *pdev,
+			  const struct hisi_sas_hw *ops);
+extern int hisi_sas_remove(struct platform_device *pdev);
 
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
new file mode 100644
index 0000000..011bfe3
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2015 Linaro Ltd.
+ * Copyright (c) 2015 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include "hisi_sas.h"
+#define DRV_NAME "hisi_sas_v1_hw"
+
+
+struct hisi_sas_complete_v1_hdr {
+	__le32 data;
+};
+static const struct hisi_sas_hw hisi_sas_v1_hw = {
+	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
+};
+
+static int hisi_sas_v1_probe(struct platform_device *pdev)
+{
+	return hisi_sas_probe(pdev, &hisi_sas_v1_hw);
+}
+
+static int hisi_sas_v1_remove(struct platform_device *pdev)
+{
+	return hisi_sas_remove(pdev);
+}
+
+static const struct of_device_id sas_v1_of_match[] = {
+	{ .compatible = "hisilicon,sas-controller-v1",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, sas_v1_of_match);
+
+static struct platform_driver hisi_sas_v1_driver = {
+	.probe = hisi_sas_v1_probe,
+	.remove = hisi_sas_v1_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = sas_v1_of_match,
+	},
+};
+
+module_platform_driver(hisi_sas_v1_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS controller v1 hw driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1

