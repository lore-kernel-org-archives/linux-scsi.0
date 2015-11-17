From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 03/32] scsi: hisi_sas: add initial bare main driver
Date: Wed, 18 Nov 2015 00:50:30 +0800
Message-ID: <1447779059-136143-4-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:37298 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbbKQQgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 11:36:44 -0500
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com

This patch adds the initial bare main driver for the
HiSilicon SAS HBA. This only introduces the changes to
build and load the main driver module.

The complete driver consists of the core main module and
also a module platform driver for driving the hw.

The HBA is a platform device.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/scsi/Kconfig                  |  1 +
 drivers/scsi/Makefile                 |  1 +
 drivers/scsi/hisi_sas/Kconfig         |  6 +++++
 drivers/scsi/hisi_sas/Makefile        |  1 +
 drivers/scsi/hisi_sas/hisi_sas.h      | 26 +++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 43 +++++++++++++++++++++++++++++++++++
 6 files changed, 78 insertions(+)
 create mode 100644 drivers/scsi/hisi_sas/Kconfig
 create mode 100644 drivers/scsi/hisi_sas/Makefile
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5f692ae..37dce23 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -473,6 +473,7 @@ config SCSI_AACRAID
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
+source "drivers/scsi/hisi_sas/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"
 
 config SCSI_MVUMI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index c14bca4..862ab4e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -157,6 +157,7 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
 obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
+obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
 
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
new file mode 100644
index 0000000..37a0c71
--- /dev/null
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -0,0 +1,6 @@
+config SCSI_HISI_SAS
+	tristate "HiSilicon SAS"
+	select SCSI_SAS_LIBSAS
+	select BLK_DEV_INTEGRITY
+	help
+		This driver supports HiSilicon's SAS HBA
diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
new file mode 100644
index 0000000..d86b05e
--- /dev/null
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
new file mode 100644
index 0000000..a5cec22
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -0,0 +1,26 @@
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
+#ifndef _HISI_SAS_H_
+#define _HISI_SAS_H_
+
+#include <linux/dmapool.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <scsi/libsas.h>
+
+#define DRV_VERSION "v1.0"
+
+#endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
new file mode 100644
index 0000000..7201363
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -0,0 +1,43 @@
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
+#define DRV_NAME "hisi_sas"
+
+static struct scsi_transport_template *hisi_sas_stt;
+
+static struct sas_domain_function_template hisi_sas_transport_ops = {
+};
+
+static __init int hisi_sas_init(void)
+{
+	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
+
+	hisi_sas_stt = sas_domain_attach_transport(&hisi_sas_transport_ops);
+	if (!hisi_sas_stt)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static __exit void hisi_sas_exit(void)
+{
+	sas_release_transport(hisi_sas_stt);
+}
+
+module_init(hisi_sas_init);
+module_exit(hisi_sas_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS controller driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1

