From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 5/8] scsi: ufs: don't suspend clock scaling during clock gating
Date: Fri,  3 Feb 2017 16:57:39 -0800
Message-ID: <1486169859-22854-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Currently we are suspending clock scaling during clock gating which doesn't
allow us to have clock gating timeout lower than clock scaling polling
window. If clock gating timeout is smaller than the clock scaling polling
window then we will mostly suspend the clock scaling before clock scaling
polling window expires and we might get stuck in same state (scaled down
or scaled up) for quite a long time. And for this reason, we have clock
gating timeout (150ms) greater than clock scaling polling window (100ms).

We would like to have aggressive clock gating timeout even lower than the
clock scaling polling window hence this change is decoupling the clock
scaling suspend/resume from clock gate/ungate. We will not suspend the
clock scaling as part of clock gating instead clock scaling context will
schedule scaling suspend work if there are no more pending transfer
requests.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 185 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |  31 +++++++-
 2 files changed, 171 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 056e912..4f6ba24 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -248,6 +248,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
+static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba);
 static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
@@ -1135,6 +1136,9 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
 
+	/* let's not get into low power until clock scaling is completed */
+	ufshcd_hold(hba, false);
+
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
 		return ret;
@@ -1166,16 +1170,51 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 
 out:
 	ufshcd_clock_scaling_unprepare(hba);
+	ufshcd_release(hba);
 	return ret;
 }
 
+static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+					   clk_scaling.suspend_work);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		return;
+	}
+	hba->clk_scaling.is_suspended = true;
+	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+
+	__ufshcd_suspend_clkscaling(hba);
+}
+
+static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+					   clk_scaling.resume_work);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	if (!hba->clk_scaling.is_suspended) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		return;
+	}
+	hba->clk_scaling.is_suspended = false;
+	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+
+	devfreq_resume_device(hba->devfreq);
+}
+
 static int ufshcd_devfreq_target(struct device *dev,
 				unsigned long *freq, u32 flags)
 {
 	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	ktime_t start;
-	bool scale_up, release_clk_hold = false;
+	bool scale_up, sched_clk_scaling_suspend_work = false;
 	unsigned long irq_flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
@@ -1186,50 +1225,35 @@ static int ufshcd_devfreq_target(struct device *dev,
 		return -EINVAL;
 	}
 
-	scale_up = (*freq == UINT_MAX) ? true : false;
-	if (!ufshcd_is_devfreq_scaling_required(hba, scale_up))
-		return 0; /* no state change required */
-
 	spin_lock_irqsave(hba->host->host_lock, irq_flags);
 	if (ufshcd_eh_in_progress(hba)) {
 		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 		return 0;
 	}
 
-	if (ufshcd_is_clkgating_allowed(hba)) {
-		if (cancel_delayed_work(&hba->clk_gating.gate_work) ||
-		    (hba->clk_gating.state == CLKS_ON)) {
-			/* hold the vote until the scaling work is completed */
-			hba->clk_gating.active_reqs++;
-			release_clk_hold = true;
-			if (hba->clk_gating.state != CLKS_ON) {
-				hba->clk_gating.state = CLKS_ON;
-				trace_ufshcd_clk_gating(dev_name(hba->dev),
-						hba->clk_gating.state);
-			}
-		} else {
-			/*
-			 * Clock gating work seems to be running in parallel
-			 * hence skip scaling work to avoid deadlock between
-			 * current scaling work and gating work.
-			 */
-			spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-			return 0;
-		}
+	if (!hba->clk_scaling.active_reqs)
+		sched_clk_scaling_suspend_work = true;
+
+	scale_up = (*freq == UINT_MAX) ? true : false;
+	if (!ufshcd_is_devfreq_scaling_required(hba, scale_up)) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		ret = 0;
+		goto out; /* no state change required */
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
 	start = ktime_get();
-
 	ret = ufshcd_devfreq_scale(hba, scale_up);
 
-	if (release_clk_hold)
-		ufshcd_release(hba);
-
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 		(scale_up ? "up" : "down"),
 		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
+out:
+	if (sched_clk_scaling_suspend_work)
+		queue_work(hba->clk_scaling.workq,
+			   &hba->clk_scaling.suspend_work);
+
 	return ret;
 }
 
@@ -1278,19 +1302,52 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
 
+static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
+{
+	unsigned long flags;
+
+	devfreq_suspend_device(hba->devfreq);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->clk_scaling.window_start_t = 0;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
 
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
+	unsigned long flags;
+	bool suspend = false;
+
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	devfreq_suspend_device(hba->devfreq);
-	hba->clk_scaling.window_start_t = 0;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (!hba->clk_scaling.is_suspended) {
+		suspend = true;
+		hba->clk_scaling.is_suspended = true;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (suspend)
+		__ufshcd_suspend_clkscaling(hba);
 }
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 {
-	devfreq_resume_device(hba->devfreq);
+	unsigned long flags;
+	bool resume = false;
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->clk_scaling.is_suspended) {
+		resume = true;
+		hba->clk_scaling.is_suspended = false;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (resume)
+		devfreq_resume_device(hba->devfreq);
 }
 
 static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
@@ -1318,6 +1375,11 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
 
+	cancel_work_sync(&hba->clk_scaling.suspend_work);
+	cancel_work_sync(&hba->clk_scaling.resume_work);
+
+	hba->clk_scaling.is_allowed = value;
+
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
 	} else {
@@ -1327,7 +1389,6 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
 					__func__, err);
 	}
-	hba->clk_scaling.is_allowed = value;
 
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
@@ -1379,8 +1440,6 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	if (hba->clk_scaling.is_allowed)
-		ufshcd_resume_clkscaling(hba);
 	scsi_unblock_requests(hba->host);
 }
 
@@ -1509,8 +1568,6 @@ static void ufshcd_gate_work(struct work_struct *work)
 		ufshcd_set_link_hibern8(hba);
 	}
 
-	ufshcd_suspend_clkscaling(hba);
-
 	if (!ufshcd_is_link_active(hba))
 		ufshcd_setup_clocks(hba, false);
 	else
@@ -1668,9 +1725,27 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 /* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
+	bool queue_resume_work = false;
+
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	if (!hba->clk_scaling.active_reqs++)
+		queue_resume_work = true;
+
+	if (!hba->clk_scaling.is_allowed || hba->pm_op_in_progress)
+		return;
+
+	if (queue_resume_work)
+		queue_work(hba->clk_scaling.workq,
+			   &hba->clk_scaling.resume_work);
+
+	if (!hba->clk_scaling.window_start_t) {
+		hba->clk_scaling.window_start_t = jiffies;
+		hba->clk_scaling.tot_busy_t = 0;
+		hba->clk_scaling.is_busy_started = false;
+	}
+
 	if (!hba->clk_scaling.is_busy_started) {
 		hba->clk_scaling.busy_start_t = ktime_get();
 		hba->clk_scaling.is_busy_started = true;
@@ -4511,6 +4586,10 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 				complete(hba->dev_cmd.complete);
 			}
 		}
+		if (ufshcd_is_clkscaling_supported(hba))
+			hba->clk_scaling.active_reqs--;
+		if (ufshcd_is_clkscaling_supported(hba))
+			hba->clk_scaling.active_reqs--;
 	}
 
 	/* clear corresponding bits of completed commands */
@@ -6785,6 +6864,10 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_suspend_clkscaling(hba);
+		if (ufshcd_is_clkscaling_supported(hba)) {
+			ufshcd_suspend_clkscaling(hba);
+			destroy_workqueue(hba->clk_scaling.workq);
+		}
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
@@ -7060,7 +7143,11 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
-	ufshcd_suspend_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed) {
+		cancel_work_sync(&hba->clk_scaling.suspend_work);
+		cancel_work_sync(&hba->clk_scaling.resume_work);
+		ufshcd_suspend_clkscaling(hba);
+	}
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
@@ -7137,7 +7224,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	goto out;
 
 set_link_active:
-	ufshcd_resume_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
 	ufshcd_vreg_set_hpm(hba);
 	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
 		ufshcd_set_link_active(hba);
@@ -7147,7 +7235,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
-	ufshcd_resume_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 out:
@@ -7245,7 +7334,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_vreg_set_lpm(hba);
 disable_irq_and_vops_clks:
 	ufshcd_disable_irq(hba);
-	ufshcd_suspend_clkscaling(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_suspend_clkscaling(hba);
 	ufshcd_setup_clocks(hba, false);
 out:
 	hba->pm_op_in_progress = 0;
@@ -7767,6 +7857,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (ufshcd_is_clkscaling_supported(hba)) {
+		char wq_name[sizeof("ufs_clkscaling_00")];
+
 		hba->devfreq = devm_devfreq_add_device(dev, &ufs_devfreq_profile,
 						   "simple_ondemand", NULL);
 		if (IS_ERR(hba->devfreq)) {
@@ -7775,6 +7867,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			err = PTR_ERR(hba->devfreq);
 			goto out_remove_scsi_host;
 		}
+		hba->clk_scaling.is_suspended = false;
+
+		INIT_WORK(&hba->clk_scaling.suspend_work,
+			  ufshcd_clk_scaling_suspend_work);
+		INIT_WORK(&hba->clk_scaling.resume_work,
+			  ufshcd_clk_scaling_resume_work);
+
+		snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clkscaling_%d",
+			 host->host_no);
+		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+
 		/* Suspend devfreq until the UFS device is detected */
 		ufshcd_suspend_clkscaling(hba);
 		ufshcd_clkscaling_init_sysfs(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4da2bbd..7630600 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -357,14 +357,37 @@ struct ufs_saved_pwr_info {
 	bool is_valid;
 };
 
+/**
+ * struct ufs_clk_scaling - UFS clock scaling related data
+ * @active_reqs: number of requests that are pending. If this is zero when
+ * devfreq ->target() function is called then schedule "suspend_work" to
+ * suspend devfreq.
+ * @tot_busy_t: Total busy time in current polling window
+ * @window_start_t: Start time (in jiffies) of the current polling window
+ * @busy_start_t: Start time of current busy period
+ * @enable_attr: sysfs attribute to enable/disable clock scaling
+ * @saved_pwr_info: UFS power mode may also be changed during scaling and this
+ * one keeps track of previous power mode.
+ * @workq: workqueue to schedule devfreq suspend/resume work
+ * @suspend_work: worker to suspend devfreq
+ * @resume_work: worker to resume devfreq
+ * @is_allowed: tracks if scaling is currently allowed or not
+ * @is_busy_started: tracks if busy period has started or not
+ * @is_suspended: tracks if devfreq is suspended or not
+ */
 struct ufs_clk_scaling {
-	ktime_t  busy_start_t;
-	bool is_busy_started;
-	unsigned long  tot_busy_t;
+	int active_reqs;
+	unsigned long tot_busy_t;
 	unsigned long window_start_t;
+	ktime_t busy_start_t;
 	struct device_attribute enable_attr;
-	bool is_allowed;
 	struct ufs_saved_pwr_info saved_pwr_info;
+	struct workqueue_struct *workq;
+	struct work_struct suspend_work;
+	struct work_struct resume_work;
+	bool is_allowed;
+	bool is_busy_started;
+	bool is_suspended;
 };
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
