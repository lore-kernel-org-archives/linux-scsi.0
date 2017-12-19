From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] scsi: ufs: use sysfs entry for health info
Date: Tue, 19 Dec 2017 12:02:54 -0800
Message-ID: <20171219200254.23120-2-jaegeuk@kernel.org>
References: <20171219200254.23120-1-jaegeuk@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbdLSUDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Dec 2017 15:03:08 -0500
In-Reply-To: <20171219200254.23120-1-jaegeuk@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@google.com>, Greg KH <gregkh@linuxfoundation.org>

From: Jaegeuk Kim <jaegeuk@google.com>

This patch introduces sysfs entries to show the information.

 # cat /sys/devices/soc/1da4000.ufshc/health/eol
 # cat /sys/devices/soc/1da4000.ufshc/health/length
 # cat /sys/devices/soc/1da4000.ufshc/health/lifetimeA
 # cat /sys/devices/soc/1da4000.ufshc/health/lifetimeB
 # cat /sys/devices/soc/1da4000.ufshc/health/type

struct desc_field_offset health_desc_field_name[] = {
	{"bLength",             0x00, BYTE},
	{"bDescriptorType",     0x01, BYTE},
	{"bPreEOLInfo",         0x02, BYTE},
	{"bDeviceLifeTimeEstA", 0x03, BYTE},
	{"bDeviceLifeTimeEstB", 0x04, BYTE}
};

bPreEOLInfo
 - 00h: Not defined
 - 01h: Normal
 - 02h: Warning
 - 03h: Critical

bDeviceLifeTimeEstA
 - 00h: Not defined
 - 01h:  0% ~ 10% device life time used
 - 02h: 10% ~ 20% device life time used
 - 03h: 20% ~ 30% device life time used
 - 04h: 30% ~ 40% device life time used
 - 05h: 40% ~ 50% device life time used
 - 06h: 50% ~ 60% device life time used
 - 07h: 60% ~ 70% device life time used
 - 08h: 70% ~ 80% device life time used
 - 09h: 80% ~ 90% device life time used
 - 0Ah: 90% ~ 100% device life time used
 - 0Bh: Exceeded its maximum estimated device life time

Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |  1 +
 3 files changed, 68 insertions(+), 1 deletion(-)

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
index 12ff7daebb00..6809f1786efe 100644
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
@@ -7688,14 +7697,69 @@ static const struct attribute_group ufshcd_attr_group = {
 	.attrs = ufshcd_attrs,
 };
 
+struct health_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct device *dev,
+				struct health_attr *attr, char *buf);
+	int bytes;
+};
+
+static ssize_t health_attr_show(struct device *dev,
+				struct health_attr *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int buff_len = hba->desc_size.health_desc;
+	u8 desc_buf[hba->desc_size.health_desc];
+	int err;
+
+	pm_runtime_get_sync(hba->dev);
+	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_HEALTH, 0,
+					desc_buf, buff_len);
+	pm_runtime_put_sync(hba->dev);
+	if (err)
+		return 0;
+
+	return scnprintf(buf, PAGE_SIZE, "0x%02x", desc_buf[attr->bytes]);
+}
+
+#define HEALTH_ATTR_RO(_name, _bytes)					\
+static struct health_attr ufs_health_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = 0444},		\
+	.show = health_attr_show,					\
+	.bytes = _bytes,						\
+}
+
+HEALTH_ATTR_RO(length, 0);
+HEALTH_ATTR_RO(type, 1);
+HEALTH_ATTR_RO(eol, 2);
+HEALTH_ATTR_RO(lifetimeA, 3);
+HEALTH_ATTR_RO(lifetimeB, 4);
+
+static struct attribute *ufshcd_health_attrs[] = {
+	&ufs_health_length.attr,
+	&ufs_health_type.attr,
+	&ufs_health_eol.attr,
+	&ufs_health_lifetimeA.attr,
+	&ufs_health_lifetimeB.attr,
+	NULL
+};
+
+static const struct attribute_group ufshcd_health_attr_group = {
+	.name = "health",
+	.attrs = ufshcd_health_attrs,
+};
+
 static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 {
 	if (sysfs_create_group(&hba->dev->kobj, &ufshcd_attr_group))
-		dev_err(hba->dev, "Failed to create sysfs group\n");
+		dev_err(hba->dev, "Failed to create default sysfs group\n");
+	if (sysfs_create_group(&hba->dev->kobj, &ufshcd_health_attr_group))
+		dev_err(hba->dev, "Failed to create health sysfs group\n");
 }
 
 static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
 {
+	sysfs_remove_group(&hba->dev->kobj, &ufshcd_health_attr_group);
 	sysfs_remove_group(&hba->dev->kobj, &ufshcd_attr_group);
 }
 
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
