From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 06/12] scsi: ufs: provide sysfs attribute to select the PM level
Date: Mon, 12 Dec 2016 16:53:58 -0800
Message-ID: <1481590438-5455-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932475AbcLMAyG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 19:54:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

This patch provides the sysfs attribute to choose the power management
level for UFS runtime and system suspend.

Reviewed-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |   2 +
 2 files changed, 124 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f26a39..470ea99 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6757,6 +6757,127 @@ int ufshcd_runtime_idle(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL(ufshcd_runtime_idle);
 
+static inline ssize_t ufshcd_pm_lvl_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count,
+					   bool rpm)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long flags, value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
+		return -EINVAL;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (rpm)
+		hba->rpm_lvl = value;
+	else
+		hba->spm_lvl = value;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return count;
+}
+
+static ssize_t ufshcd_rpm_lvl_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int curr_len;
+	u8 lvl;
+
+	curr_len = snprintf(buf, PAGE_SIZE,
+			    "\nCurrent Runtime PM level [%d] => dev_state [%s] link_state [%s]\n",
+			    hba->rpm_lvl,
+			    ufschd_ufs_dev_pwr_mode_to_string(
+				ufs_pm_lvl_states[hba->rpm_lvl].dev_state),
+			    ufschd_uic_link_state_to_string(
+				ufs_pm_lvl_states[hba->rpm_lvl].link_state));
+
+	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
+			     "\nAll available Runtime PM levels info:\n");
+	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
+		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
+				     "\tRuntime PM level [%d] => dev_state [%s] link_state [%s]\n",
+				    lvl,
+				    ufschd_ufs_dev_pwr_mode_to_string(
+					ufs_pm_lvl_states[lvl].dev_state),
+				    ufschd_uic_link_state_to_string(
+					ufs_pm_lvl_states[lvl].link_state));
+
+	return curr_len;
+}
+
+static ssize_t ufshcd_rpm_lvl_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return ufshcd_pm_lvl_store(dev, attr, buf, count, true);
+}
+
+static void ufshcd_add_rpm_lvl_sysfs_nodes(struct ufs_hba *hba)
+{
+	hba->rpm_lvl_attr.show = ufshcd_rpm_lvl_show;
+	hba->rpm_lvl_attr.store = ufshcd_rpm_lvl_store;
+	sysfs_attr_init(&hba->rpm_lvl_attr.attr);
+	hba->rpm_lvl_attr.attr.name = "rpm_lvl";
+	hba->rpm_lvl_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->rpm_lvl_attr))
+		dev_err(hba->dev, "Failed to create sysfs for rpm_lvl\n");
+}
+
+static ssize_t ufshcd_spm_lvl_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int curr_len;
+	u8 lvl;
+
+	curr_len = snprintf(buf, PAGE_SIZE,
+			    "\nCurrent System PM level [%d] => dev_state [%s] link_state [%s]\n",
+			    hba->spm_lvl,
+			    ufschd_ufs_dev_pwr_mode_to_string(
+				ufs_pm_lvl_states[hba->spm_lvl].dev_state),
+			    ufschd_uic_link_state_to_string(
+				ufs_pm_lvl_states[hba->spm_lvl].link_state));
+
+	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
+			     "\nAll available System PM levels info:\n");
+	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
+		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
+				     "\tSystem PM level [%d] => dev_state [%s] link_state [%s]\n",
+				    lvl,
+				    ufschd_ufs_dev_pwr_mode_to_string(
+					ufs_pm_lvl_states[lvl].dev_state),
+				    ufschd_uic_link_state_to_string(
+					ufs_pm_lvl_states[lvl].link_state));
+
+	return curr_len;
+}
+
+static ssize_t ufshcd_spm_lvl_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return ufshcd_pm_lvl_store(dev, attr, buf, count, false);
+}
+
+static void ufshcd_add_spm_lvl_sysfs_nodes(struct ufs_hba *hba)
+{
+	hba->spm_lvl_attr.show = ufshcd_spm_lvl_show;
+	hba->spm_lvl_attr.store = ufshcd_spm_lvl_store;
+	sysfs_attr_init(&hba->spm_lvl_attr.attr);
+	hba->spm_lvl_attr.attr.name = "spm_lvl";
+	hba->spm_lvl_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->spm_lvl_attr))
+		dev_err(hba->dev, "Failed to create sysfs for spm_lvl\n");
+}
+
+static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
+{
+	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
+	ufshcd_add_spm_lvl_sysfs_nodes(hba);
+}
+
 /**
  * ufshcd_shutdown - shutdown routine
  * @hba: per adapter instance
@@ -7181,6 +7302,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_set_ufs_dev_active(hba);
 
 	async_schedule(ufshcd_async_scan, hba);
+	ufshcd_add_sysfs_nodes(hba);
 
 	return 0;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bdd2284..787323b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -435,6 +435,8 @@ struct ufs_hba {
 	enum ufs_pm_level rpm_lvl;
 	/* Desired UFS power management level during system PM */
 	enum ufs_pm_level spm_lvl;
+	struct device_attribute rpm_lvl_attr;
+	struct device_attribute spm_lvl_attr;
 	int pm_op_in_progress;
 
 	struct ufshcd_lrb *lrb;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

