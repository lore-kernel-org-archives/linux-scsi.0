From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v2 04/12] scsi: ufs: Add sysfs node to dynamically control clock gating
Date: Tue, 13 Dec 2016 11:49:45 -0800
Message-ID: <1481658586-31891-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

Provide an option to enable/disable clock gating during runtime.
Write 1 or 0 to "clkgate_enable" sysfs node to enable/disable
clock gating.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |  4 ++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4cf66a..ccf54c1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1011,6 +1011,41 @@ static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
 	return count;
 }
 
+static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_gating.is_enabled);
+}
+
+static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long flags;
+	u32 value;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	value = !!value;
+	if (value == hba->clk_gating.is_enabled)
+		goto out;
+
+	if (value) {
+		ufshcd_release(hba);
+	} else {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->clk_gating.active_reqs++;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
+
+	hba->clk_gating.is_enabled = value;
+out:
+	return count;
+}
+
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_clkgating_allowed(hba))
@@ -1020,13 +1055,23 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
+	hba->clk_gating.is_enabled = true;
+
 	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
 	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
 	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
 	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
-	hba->clk_gating.delay_attr.attr.mode = S_IRUGO | S_IWUSR;
+	hba->clk_gating.delay_attr.attr.mode = 0644;
 	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
 		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
+
+	hba->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
+	hba->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
+	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
+	hba->clk_gating.enable_attr.attr.name = "clkgate_enable";
+	hba->clk_gating.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
+		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
 }
 
 static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
@@ -1034,6 +1079,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
+	device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
 	cancel_work_sync(&hba->clk_gating.ungate_work);
 	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 08cd26e..0882ba6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -320,6 +320,8 @@ enum clk_gating_state {
  * @is_suspended: clk gating is suspended when set to 1 which can be used
  * during suspend/resume
  * @delay_attr: sysfs attribute to control delay_attr
+ * @enable_attr: sysfs attribute to enable/disable clock gating
+ * @is_enabled: Indicates the current status of clock gating
  * @active_reqs: number of requests that are pending and should be waited for
  * completion before gating clocks.
  */
@@ -330,6 +332,8 @@ struct ufs_clk_gating {
 	unsigned long delay_ms;
 	bool is_suspended;
 	struct device_attribute delay_attr;
+	struct device_attribute enable_attr;
+	bool is_enabled;
 	int active_reqs;
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
