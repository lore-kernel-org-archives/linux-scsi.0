From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 17/32] scsi: hisi_sas: add v1 hw module init
Date: Mon, 16 Nov 2015 21:06:03 +0800
Message-ID: <1447679178-220222-18-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Add module init code for v1 hw.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
index 3749c46..72533ca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -269,5 +269,8 @@ union hisi_sas_command_table {
 	struct hisi_sas_command_table_smp smp;
 	struct hisi_sas_command_table_stp stp;
 };
+extern int hisi_sas_probe(struct platform_device *pdev,
+			  const struct hisi_sas_hw *ops);
+extern int hisi_sas_remove(struct platform_device *pdev);
 
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
new file mode 100644
index 0000000..e9aebce
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
+	{ .compatible = "hisilicon,hip05-sas-v1",},
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
+MODULE_AUTHOR("John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>");
+MODULE_DESCRIPTION("HISILICON SAS controller v1 hw driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
