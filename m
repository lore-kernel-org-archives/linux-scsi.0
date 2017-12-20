From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2 v3] scsi: ufs: introduce static sysfs entries
Date: Wed, 20 Dec 2017 11:16:30 -0800
Message-ID: <20171220191631.50329-1-jaegeuk@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755904AbdLTTQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 14:16:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jaegeuk Kim <jaegeuk@google.com>

This patch introduces attribute group to show existing sysfs entries.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---

Change log from v1:
 - use ATTRIBUTE_GROUPS and sysfs_create_groups()

 drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++-----------------------------
 drivers/scsi/ufs/ufshcd.h |  2 --
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011c3369082c..1e8a6a3e1f39 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7605,7 +7605,7 @@ static inline ssize_t ufshcd_pm_lvl_store(struct device *dev,
 	return count;
 }
 
-static ssize_t ufshcd_rpm_lvl_show(struct device *dev,
+static ssize_t rpm_lvl_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -7634,24 +7634,13 @@ static ssize_t ufshcd_rpm_lvl_show(struct device *dev,
 	return curr_len;
 }
 
-static ssize_t ufshcd_rpm_lvl_store(struct device *dev,
+static ssize_t rpm_lvl_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	return ufshcd_pm_lvl_store(dev, attr, buf, count, true);
 }
 
-static void ufshcd_add_rpm_lvl_sysfs_nodes(struct ufs_hba *hba)
-{
-	hba->rpm_lvl_attr.show = ufshcd_rpm_lvl_show;
-	hba->rpm_lvl_attr.store = ufshcd_rpm_lvl_store;
-	sysfs_attr_init(&hba->rpm_lvl_attr.attr);
-	hba->rpm_lvl_attr.attr.name = "rpm_lvl";
-	hba->rpm_lvl_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->rpm_lvl_attr))
-		dev_err(hba->dev, "Failed to create sysfs for rpm_lvl\n");
-}
-
-static ssize_t ufshcd_spm_lvl_show(struct device *dev,
+static ssize_t spm_lvl_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -7680,33 +7669,32 @@ static ssize_t ufshcd_spm_lvl_show(struct device *dev,
 	return curr_len;
 }
 
-static ssize_t ufshcd_spm_lvl_store(struct device *dev,
+static ssize_t spm_lvl_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	return ufshcd_pm_lvl_store(dev, attr, buf, count, false);
 }
 
-static void ufshcd_add_spm_lvl_sysfs_nodes(struct ufs_hba *hba)
-{
-	hba->spm_lvl_attr.show = ufshcd_spm_lvl_show;
-	hba->spm_lvl_attr.store = ufshcd_spm_lvl_store;
-	sysfs_attr_init(&hba->spm_lvl_attr.attr);
-	hba->spm_lvl_attr.attr.name = "spm_lvl";
-	hba->spm_lvl_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->spm_lvl_attr))
-		dev_err(hba->dev, "Failed to create sysfs for spm_lvl\n");
-}
+static DEVICE_ATTR_RW(rpm_lvl);
+static DEVICE_ATTR_RW(spm_lvl);
+
+static struct attribute *ufshcd_attrs[] = {
+	&dev_attr_rpm_lvl.attr,
+	&dev_attr_spm_lvl.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(ufshcd);
 
 static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 {
-	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
-	ufshcd_add_spm_lvl_sysfs_nodes(hba);
+	if (sysfs_create_groups(&hba->dev->kobj, ufshcd_groups))
+		dev_err(hba->dev, "Failed to create sysfs default groups\n");
 }
 
 static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
 {
-	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
-	device_remove_file(hba->dev, &hba->spm_lvl_attr);
+	sysfs_remove_groups(&hba->dev->kobj, ufshcd_groups);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1332e544da92..56e26eb15185 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -526,8 +526,6 @@ struct ufs_hba {
 	enum ufs_pm_level rpm_lvl;
 	/* Desired UFS power management level during system PM */
 	enum ufs_pm_level spm_lvl;
-	struct device_attribute rpm_lvl_attr;
-	struct device_attribute spm_lvl_attr;
 	int pm_op_in_progress;
 
 	struct ufshcd_lrb *lrb;
-- 
2.15.0.531.g2ccb3012c9-goog
