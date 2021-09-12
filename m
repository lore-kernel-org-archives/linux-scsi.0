Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF199C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC5A61213
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhILNUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 09:20:52 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2737 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhILNUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 09:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631452776; x=1662988776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Gy/5SYoNmlPfKUsE+zn05ALYP6yqAuMeguugDUWCD5s=;
  b=Rm1qU26X6z/1w+DfzRnzPfegQgfjxsbZf25lf7AaC4UzA7WukZB0Ix8b
   x+EzFN8c1diqOtEgrsP0+75x3em30fN7i886+IoCfV/Qfa1v2o0f5auvK
   Drc9FABjOO875bsarM77mpCXKMDFRpuokF8P27yBy5hOUNNyiddpzvsC1
   SZ7W+wdzp7stXUXiJCa4gpfNwDfLoH9gXoG7gVU8ckBMYQph6YwzxyNzO
   xlFrsqRhZuFz2MMSRir4WlhSKm8ssSPtxU4kTYdu7bclzeH8vNV+Wg7Xa
   FILyMxut1INSqTSQnOPNDCsY8gYnsIchqqdIYdYc02kvVFC5DC/heu0Md
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,287,1624291200"; 
   d="scan'208";a="184575088"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2021 21:19:35 +0800
IronPort-SDR: T21Ja4FKMny9PiBHETduZ7Fxnt5vgs0BTJP77uabcSQAS12Vanl4UdzHCREHMWJsnxu2eG31zJ
 WPAWYcTtEudCIhBlj1NgEKMrgjac2cmlqF0VuQCD/q2H961OCoA1q11plpOsXGL0YI1/kp9pAq
 O5wI+B8HJO4B5yFtbeU04Kej4d4d5OJ96JlDSHWa1FMU3zCJFqtzYR+Hf04xRb7eR84lKtZXYQ
 R79Rl9B8EOJydHolyOf/2c6GhXMPgepDOltWFespgVeAE1LONnbka4GsDkSv/BHu+u/7mXp9FI
 cXOmwAVhw50RUIk6WdiAk1Rm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 05:54:29 -0700
IronPort-SDR: JfhkDFnia9x6LJX2usD1ZPZx/1BSo+7jOzvwxnUG1FjnON96P6d6xhOUO54x5+C9/uQtOtpmTy
 /rulrBxDu3Ld0ttxXWIUoSZL82GAXiruuYENQZ0qRIa0tdZf+uVY+ytnbmf8Lqhc1HOzt+b6uk
 MqmC6dV3OWnpmqdP7WdguK6NOJ3eNvAlQOSzyrfOBnmnuH4oy9xtJUVRq9fWJ04b4vFWQ36z52
 ie+Owid6vBQZ6+JlOESgjMBZ16TFRACIDFGhi1ax5kMo8VewYEsMljHgam3ESqFCtxxli0jqhS
 iAE=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.116])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Sep 2021 06:19:34 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification support
Date:   Sun, 12 Sep 2021 16:19:18 +0300
Message-Id: <20210912131919.12962-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210912131919.12962-1-avri.altman@wdc.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Probe the dExtendedUFSFeaturesSupport register for the device's
temperature notification support, and if supported, add a hw monitor
device.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/Kconfig     |  10 ++
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-hwmon.c | 179 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   6 ++
 drivers/scsi/ufs/ufshcd.c    |  28 ++++++
 drivers/scsi/ufs/ufshcd.h    |  18 ++++
 6 files changed, 242 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 432df76e6318..b930f29fc375 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -199,3 +199,13 @@ config SCSI_UFS_FAULT_INJECTION
 	help
 	  Enable fault injection support in the UFS driver. This makes it easier
 	  to test the UFS error handler and abort handler.
+
+config SCSI_UFS_HWMON
+	bool "UFS  Temperature Notification"
+	depends on SCSI_UFSHCD && HWMON
+	help
+	  This provides support for UFS hardware monitoring. If enabled,
+	  a hardware monitoring device will be created for the UFS device.
+
+	  If unsure, say N.
+
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index c407da9b5171..966048875b50 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -10,6 +10,7 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
 ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
 ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
+ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
new file mode 100644
index 000000000000..a50e83f645f4
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * UFS hardware monitoring support
+ * Copyright (c) 2021, Western Digital Corporation
+ */
+
+#include <linux/hwmon.h>
+
+#include "ufshcd.h"
+
+struct ufs_hwmon_data {
+	struct ufs_hba *hba;
+	u8 mask;
+};
+
+static bool ufs_temp_enabled(struct ufs_hba *hba, u8 mask)
+{
+	u32 ee_mask;
+
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			      QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask))
+		return false;
+
+	return (mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) ||
+		(mask & ee_mask & MASK_EE_TOO_LOW_TEMP);
+}
+
+static bool ufs_temp_valid(struct ufs_hba *hba, u8 mask,
+			   enum attr_idn idn, u32 value)
+{
+	return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1 &&
+		value <= 250 && ufs_temp_enabled(hba, mask)) ||
+	      (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
+	       value <= 250) ||
+	      (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
+	       value <= 80);
+}
+
+static int ufs_get_temp(struct ufs_hba *hba, u8 mask, enum attr_idn idn)
+{
+	u32 value;
+
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0,
+	    &value))
+		return 0;
+
+	if (ufs_temp_valid(hba, mask, idn, value))
+		return value - 80;
+
+	return 0;
+}
+
+static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
+			   u32 attr, int channel, long *val)
+{
+	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
+	struct ufs_hba *hba = data->hba;
+	u8 mask = data->mask;
+	int err = 0;
+	bool get_temp = true;
+
+	if (type != hwmon_temp)
+		return 0;
+
+	down(&hba->host_sem);
+
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+
+	switch (attr) {
+	case hwmon_temp_enable:
+		*val = ufs_temp_enabled(hba, mask);
+		get_temp = false;
+
+		break;
+	case hwmon_temp_max_alarm:
+		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_HIGH_TEMP_BOUND);
+
+		break;
+	case hwmon_temp_min_alarm:
+		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_LOW_TEMP_BOUND);
+
+		break;
+	case hwmon_temp_input:
+		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_CASE_ROUGH_TEMP);
+
+		break;
+	default:
+		err = -EOPNOTSUPP;
+
+		break;
+	}
+
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+
+	if (get_temp && !err && *val == 0)
+		err = -EINVAL;
+
+	return err;
+}
+
+static umode_t ufs_hwmon_is_visible(const void *_data,
+				     enum hwmon_sensor_types type,
+				     u32 attr, int channel)
+{
+	if (type != hwmon_temp)
+		return 0;
+
+	switch (attr) {
+	case hwmon_temp_enable:
+	case hwmon_temp_max_alarm:
+	case hwmon_temp_min_alarm:
+	case hwmon_temp_input:
+		return 0444;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static const struct hwmon_channel_info *ufs_hwmon_info[] = {
+	HWMON_CHANNEL_INFO(temp, HWMON_T_ENABLE | HWMON_T_INPUT |
+			    HWMON_T_MIN_ALARM | HWMON_T_MAX_ALARM),
+	NULL
+};
+
+static const struct hwmon_ops ufs_hwmon_ops = {
+	.is_visible	= ufs_hwmon_is_visible,
+	.read		= ufs_hwmon_read,
+};
+
+static const struct hwmon_chip_info ufs_hwmon_hba_info = {
+	.ops	= &ufs_hwmon_ops,
+	.info	= ufs_hwmon_info,
+};
+
+void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
+{
+	struct device *dev = hba->dev;
+	struct ufs_hwmon_data *data;
+	struct device *hwmon;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	data->hba = hba;
+	data->mask = mask;
+
+	hwmon = hwmon_device_register_with_info(dev, "ufs",
+						data, &ufs_hwmon_hba_info,
+						NULL);
+	if (IS_ERR(hwmon)) {
+		dev_warn(dev, "Failed to instantiate hwmon device\n");
+		kfree(data);
+		return;
+	}
+
+	hba->hwmon_device = hwmon;
+}
+
+void ufs_hwmon_remove(struct ufs_hba *hba)
+{
+	struct ufs_hwmon_data *data;
+
+	if (!hba->hwmon_device)
+		return;
+
+	data = dev_get_drvdata(hba->hwmon_device);
+	hwmon_device_unregister(hba->hwmon_device);
+	hba->hwmon_device = NULL;
+	kfree(data);
+}
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8c6b38b1b142..171b27be7b1d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -152,6 +152,9 @@ enum attr_idn {
 	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
 	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
 	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
+	QUERY_ATTR_IDN_CASE_ROUGH_TEMP          = 0x18,
+	QUERY_ATTR_IDN_HIGH_TEMP_BOUND          = 0x19,
+	QUERY_ATTR_IDN_LOW_TEMP_BOUND           = 0x1A,
 	QUERY_ATTR_IDN_WB_FLUSH_STATUS	        = 0x1C,
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
@@ -338,6 +341,9 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 67889d74761c..90c2e9677435 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7469,6 +7469,31 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	hba->caps &= ~UFSHCD_CAP_WB_EN;
 }
 
+static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	u32 ext_ufs_feature;
+	u8 mask = 0;
+
+	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
+	    dev_info->wspecversion < 0x300)
+		return;
+
+	ext_ufs_feature = get_unaligned_be32(desc_buf +
+					DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
+	if (ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF)
+		mask |= MASK_EE_TOO_LOW_TEMP;
+
+	if (ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF)
+		mask |= MASK_EE_TOO_HIGH_TEMP;
+
+	if (mask) {
+		ufshcd_enable_ee(hba, mask);
+		ufs_hwmon_probe(hba, mask);
+	}
+}
+
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
 {
 	struct ufs_dev_fix *f;
@@ -7564,6 +7589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_wb_probe(hba, desc_buf);
 
+	ufshcd_temp_notif_probe(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
@@ -9408,6 +9435,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	if (hba->sdev_ufs_device)
 		ufshcd_rpm_get_sync(hba);
+	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
 	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4723f27a55d1..798a408d71e5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -653,6 +653,12 @@ enum ufshcd_caps {
 	 * in order to exit DeepSleep state.
 	 */
 	UFSHCD_CAP_DEEPSLEEP				= 1 << 10,
+
+	/*
+	 * This capability allows the host controller driver to use temperature
+	 * notification if it is supported by the UFS device.
+	 */
+	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
 };
 
 struct ufs_hba_variant_params {
@@ -789,6 +795,10 @@ struct ufs_hba {
 	struct scsi_device *sdev_ufs_device;
 	struct scsi_device *sdev_rpmb;
 
+#ifdef CONFIG_SCSI_UFS_HWMON
+	struct device *hwmon_device;
+#endif
+
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
 	/* Desired UFS power management level during runtime PM */
@@ -1050,6 +1060,14 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_UFS_HWMON
+void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
+void ufs_hwmon_remove(struct ufs_hba *hba);
+#else
+static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
+static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
+#endif
+
 #ifdef CONFIG_PM
 extern int ufshcd_runtime_suspend(struct device *dev);
 extern int ufshcd_runtime_resume(struct device *dev);
-- 
2.17.1

