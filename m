From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2 v3] scsi: ufs: introduce sysfs entries exposing UFS health info
Date: Wed, 20 Dec 2017 11:16:31 -0800
Message-ID: <20171220191631.50329-2-jaegeuk@kernel.org>
References: <20171220191631.50329-1-jaegeuk@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755743AbdLTTRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 14:17:13 -0500
In-Reply-To: <20171220191631.50329-1-jaegeuk@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jaegeuk Kim <jaegeuk@google.com>

This patch adds a new sysfs group, namely health, via:

   /sys/devices/soc/X.ufshc/health/

This directory contains the below entries, each of which shows an 8-bytes
hex number representing different meanings defined by JEDEC specfication.

Users can simply read these entries to check how their underlying flash
storage is getting reached out to its end of life. For example, if
lifetimeA shows 0xb, it would be the right time to consider device swap.

 - length
   : must be 25h

 - type
   : must be 09h

 - eol
   00h: Not defined
   01h: Normal
   02h: Warning
   03h: Critical

 - lifetimeA/B
   00h: Not defined
   01h:  0% ~ 10% device life time used
   02h: 10% ~ 20% device life time used
   03h: 20% ~ 30% device life time used
   04h: 30% ~ 40% device life time used
   05h: 40% ~ 50% device life time used
   06h: 50% ~ 60% device life time used
   07h: 60% ~ 70% device life time used
   08h: 70% ~ 80% device life time used
   09h: 80% ~ 90% device life time used
   0Ah: 90% ~ 100% device life time used
   0Bh: Exceeded its maximum estimated device life time

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 Documentation/ABI/testing/sysfs-devices-soc-ufs | 25 +++++++++
 MAINTAINERS                                     |  1 +
 drivers/scsi/ufs/ufs.h                          |  2 +
 drivers/scsi/ufs/ufshcd.c                       | 68 ++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h                       |  1 +
 5 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-soc-ufs

diff --git a/Documentation/ABI/testing/sysfs-devices-soc-ufs b/Documentation/ABI/testing/sysfs-devices-soc-ufs
new file mode 100644
index 000000000000..313771a383e4
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-soc-ufs
@@ -0,0 +1,25 @@
+What:		/sys/devices/soc/X.ufshc/health
+Date:		September 2017
+contact:	Jaegeuk Kim <jaegeuk@google.com>
+Description:
+		This directory contains health information reported by UFS.
+		- length must be 25h
+		- type must be 09h
+		- eol represent
+		  00h: Not defined
+		  01h: Normal
+		  02h: Warning
+		  03h: Critical
+		- lifetimeA/B
+		  00h: Not defined
+		  01h:  0% ~ 10% device life time used
+		  02h: 10% ~ 20% device life time used
+		  03h: 20% ~ 30% device life time used
+		  04h: 30% ~ 40% device life time used
+		  05h: 40% ~ 50% device life time used
+		  06h: 50% ~ 60% device life time used
+		  07h: 60% ~ 70% device life time used
+		  08h: 70% ~ 80% device life time used
+		  09h: 80% ~ 90% device life time used
+		  0Ah: 90% ~ 100% device life time used
+		  0Bh: Exceeded its maximum estimated device life time
diff --git a/MAINTAINERS b/MAINTAINERS
index aa71ab52fd76..947034319bb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13999,6 +13999,7 @@ M:	Vinayak Holikatti <vinholikatti@gmail.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/ufs.txt
+F:	Documentation/ABI/testing/sysfs-devices-soc-ufs
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 54deeb754db5..1af541d56c7d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -154,6 +154,7 @@ enum desc_idn {
 	QUERY_DESC_IDN_RFU_1		= 0x6,
 	QUERY_DESC_IDN_GEOMETRY		= 0x7,
 	QUERY_DESC_IDN_POWER		= 0x8,
+	QUERY_DESC_IDN_HEALTH		= 0x9,
 	QUERY_DESC_IDN_MAX,
 };
 
@@ -169,6 +170,7 @@ enum ufs_desc_def_size {
 	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
 	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
 	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
+	QUERY_DESC_HEALTH_DEF_SIZE		= 0x25,
 };
 
 /* Unit descriptor parameters offsets in bytes*/
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1e8a6a3e1f39..ffec7142d7d8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2991,6 +2991,9 @@ int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
 	case QUERY_DESC_IDN_RFU_1:
 		*desc_len = 0;
 		break;
+	case QUERY_DESC_IDN_HEALTH:
+		*desc_len = hba->desc_size.health_desc;
+		break;
 	default:
 		*desc_len = 0;
 		return -EINVAL;
@@ -6298,6 +6301,11 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 		&hba->desc_size.geom_desc);
 	if (err)
 		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+
+	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
+		&hba->desc_size.health_desc);
+	if (err)
+		hba->desc_size.health_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
 static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
@@ -6308,6 +6316,7 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
 	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
 	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
 	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+	hba->desc_size.health_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
 /**
@@ -7684,7 +7693,64 @@ static struct attribute *ufshcd_attrs[] = {
 	NULL
 };
 
-ATTRIBUTE_GROUPS(ufshcd);
+static const struct attribute_group ufshcd_default_group = {
+	.attrs = ufshcd_attrs,
+};
+
+static char ufshcd_read_desc_health(struct device *dev, int byte_offset)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int buff_len = hba->desc_size.health_desc;
+	u8 desc_buf[hba->desc_size.health_desc];
+	int err;
+
+	if (byte_offset >= buff_len)
+		return 0;
+
+	pm_runtime_get_sync(hba->dev);
+	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_HEALTH, 0,
+					desc_buf, buff_len);
+	pm_runtime_put_sync(hba->dev);
+	if (err)
+		return 0;
+
+	return desc_buf[byte_offset];
+}
+
+#define HEALTH_ATTR_RO(_name, _byte_offset)				\
+static ssize_t _name##_show(struct device *_dev,			\
+			struct device_attribute *attr, char *buf)	\
+{									\
+	int ret = ufshcd_read_desc_health(_dev, _byte_offset);		\
+	return scnprintf(buf, PAGE_SIZE, "0x%02x", ret);		\
+}									\
+static DEVICE_ATTR_RO(_name);
+
+HEALTH_ATTR_RO(length, 0);
+HEALTH_ATTR_RO(type, 1);
+HEALTH_ATTR_RO(eol, 2);
+HEALTH_ATTR_RO(lifetimeA, 3);
+HEALTH_ATTR_RO(lifetimeB, 4);
+
+static struct attribute *ufshcd_health_attrs[] = {
+	&dev_attr_length.attr,
+	&dev_attr_type.attr,
+	&dev_attr_eol.attr,
+	&dev_attr_lifetimeA.attr,
+	&dev_attr_lifetimeB.attr,
+	NULL
+};
+
+static const struct attribute_group ufshcd_health_group = {
+	.name = "health",
+	.attrs = ufshcd_health_attrs,
+};
+
+static const struct attribute_group *ufshcd_groups[] = {
+	&ufshcd_default_group,
+	&ufshcd_health_group,
+	NULL,
+};
 
 static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 56e26eb15185..ba44cbcf755e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -229,6 +229,7 @@ struct ufs_desc_size {
 	int interc_desc;
 	int unit_desc;
 	int conf_desc;
+	int health_desc;
 };
 
 /**
-- 
2.15.0.531.g2ccb3012c9-goog
