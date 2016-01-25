From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RESEND PATCH v2 07/23] hisi_sas: add bare v2 hw driver
Date: Tue, 26 Jan 2016 02:47:07 +0800
Message-ID: <1453747643-61875-8-git-send-email-john.garry@huawei.com>
References: <1453747643-61875-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453747643-61875-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Just add enough to build and init the module.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
+MODULE_AUTHOR("John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>");
+MODULE_DESCRIPTION("HISILICON SAS controller v2 hw driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
