From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 05/12] scsi: ufs: Add sysfs node to dynamically control clock scaling
Date: Thu, 22 Dec 2016 18:40:50 -0800
Message-ID: <1482460850-6131-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

Provide an option to enable/disable clock scaling during runtime.
Write 1/0 to "clkscale_enable" sysfs node to enable/disable clock
scaling.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 95 +++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/ufs/ufshcd.h |  4 +-
 2 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2ed82c2..5932936 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -230,6 +230,9 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
+static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
+static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
+static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode);
@@ -713,16 +716,58 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
 
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
-	if (ufshcd_is_clkscaling_enabled(hba)) {
-		devfreq_suspend_device(hba->devfreq);
-		hba->clk_scaling.window_start_t = 0;
-	}
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	devfreq_suspend_device(hba->devfreq);
+	hba->clk_scaling.window_start_t = 0;
 }
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 {
-	if (ufshcd_is_clkscaling_enabled(hba))
-		devfreq_resume_device(hba->devfreq);
+	devfreq_resume_device(hba->devfreq);
+}
+
+static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_allowed);
+}
+
+static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int err;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	value = !!value;
+	if (value == hba->clk_scaling.is_allowed)
+		goto out;
+
+	pm_runtime_get_sync(hba->dev);
+	ufshcd_hold(hba, false);
+
+	if (value) {
+		ufshcd_resume_clkscaling(hba);
+	} else {
+		ufshcd_suspend_clkscaling(hba);
+		err = ufshcd_scale_clks(hba, true);
+		if (err)
+			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
+					__func__, err);
+	}
+	hba->clk_scaling.is_allowed = value;
+
+	ufshcd_release(hba);
+	pm_runtime_put_sync(hba->dev);
+out:
+	return count;
 }
 
 static void ufshcd_ungate_work(struct work_struct *work)
@@ -758,7 +803,8 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	ufshcd_resume_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
 	scsi_unblock_requests(hba->host);
 }
 
@@ -1046,7 +1092,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 /* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
-	if (!ufshcd_is_clkscaling_enabled(hba))
+	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
 	if (!hba->clk_scaling.is_busy_started) {
@@ -1059,7 +1105,7 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 {
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
 
-	if (!ufshcd_is_clkscaling_enabled(hba))
+	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
 	if (!hba->outstanding_reqs && scaling->is_busy_started) {
@@ -5526,12 +5572,15 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		pm_runtime_put_sync(hba->dev);
 	}
 
+	/* Resume devfreq after UFS device is detected */
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		ufshcd_resume_clkscaling(hba);
+		hba->clk_scaling.is_allowed = true;
+	}
+
 	if (!hba->is_init_prefetch)
 		hba->is_init_prefetch = true;
 
-	/* Resume devfreq after UFS device is detected */
-	ufshcd_resume_clkscaling(hba);
-
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
@@ -6484,7 +6533,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_urgent_bkops(hba);
 	hba->clk_gating.is_suspended = false;
 
-	ufshcd_resume_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
 
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
@@ -6702,6 +6752,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba, true);
 
 	ufshcd_exit_clk_gating(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
@@ -6835,7 +6887,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 	bool release_clk_hold = false;
 	unsigned long irq_flags;
 
-	if (!ufshcd_is_clkscaling_enabled(hba))
+	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
 	spin_lock_irqsave(hba->host->host_lock, irq_flags);
@@ -6883,7 +6935,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
 	unsigned long flags;
 
-	if (!ufshcd_is_clkscaling_enabled(hba))
+	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
 	memset(stat, 0, sizeof(*stat));
@@ -6919,6 +6971,16 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	.target		= ufshcd_devfreq_target,
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
+static void ufshcd_clkscaling_init_sysfs(struct ufs_hba *hba)
+{
+	hba->clk_scaling.enable_attr.show = ufshcd_clkscale_enable_show;
+	hba->clk_scaling.enable_attr.store = ufshcd_clkscale_enable_store;
+	sysfs_attr_init(&hba->clk_scaling.enable_attr.attr);
+	hba->clk_scaling.enable_attr.attr.name = "clkscale_enable";
+	hba->clk_scaling.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->clk_scaling.enable_attr))
+		dev_err(hba->dev, "Failed to create sysfs for clkscale_enable\n");
+}
 
 /**
  * ufshcd_init - Driver initialization routine
@@ -7045,7 +7107,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
-	if (ufshcd_is_clkscaling_enabled(hba)) {
+	if (ufshcd_is_clkscaling_supported(hba)) {
 		hba->devfreq = devm_devfreq_add_device(dev, &ufs_devfreq_profile,
 						   "simple_ondemand", NULL);
 		if (IS_ERR(hba->devfreq)) {
@@ -7056,6 +7118,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		}
 		/* Suspend devfreq until the UFS device is detected */
 		ufshcd_suspend_clkscaling(hba);
+		ufshcd_clkscaling_init_sysfs(hba);
 	}
 
 	/* Hold auto suspend until async scan completes */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0882ba6..bdd2284 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -342,6 +342,8 @@ struct ufs_clk_scaling {
 	bool is_busy_started;
 	unsigned long  tot_busy_t;
 	unsigned long window_start_t;
+	struct device_attribute enable_attr;
+	bool is_allowed;
 };
 
 /**
@@ -580,7 +582,7 @@ static inline bool ufshcd_can_hibern8_during_gating(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
 }
-static inline int ufshcd_is_clkscaling_enabled(struct ufs_hba *hba)
+static inline int ufshcd_is_clkscaling_supported(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_CLK_SCALING;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
