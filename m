From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 3/8] scsi: ufs: add load based scaling of UFS gear
Date: Fri,  3 Feb 2017 16:57:02 -0800
Message-ID: <1486169822-22775-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

UFS driver's load based clock scaling feature scales down the ufs related
clocks in order to allow low power modes of chipsets. UniPro 1.6 supports
maximum gear up to HS-G3 (High Speed Gear3) and some of the chipsets
low power modes may not be allowed in HS-G3 hence this change adds support
to scale gear between HS-G3 and HS-G1 based on same existing load based
clock scaling logic.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 594 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   9 +
 2 files changed, 428 insertions(+), 175 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 64d619a..e75e50d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -867,6 +867,396 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
 		return false;
 }
 
+static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
+{
+	int ret = 0;
+	struct ufs_clk_info *clki;
+	struct list_head *head = &hba->clk_list_head;
+	ktime_t start = ktime_get();
+	bool clk_state_changed = false;
+
+	if (!head || list_empty(head))
+		goto out;
+
+	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
+	if (ret)
+		return ret;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk)) {
+			if (scale_up && clki->max_freq) {
+				if (clki->curr_freq == clki->max_freq)
+					continue;
+
+				clk_state_changed = true;
+				ret = clk_set_rate(clki->clk, clki->max_freq);
+				if (ret) {
+					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
+						__func__, clki->name,
+						clki->max_freq, ret);
+					break;
+				}
+				trace_ufshcd_clk_scaling(dev_name(hba->dev),
+						"scaled up", clki->name,
+						clki->curr_freq,
+						clki->max_freq);
+
+				clki->curr_freq = clki->max_freq;
+
+			} else if (!scale_up && clki->min_freq) {
+				if (clki->curr_freq == clki->min_freq)
+					continue;
+
+				clk_state_changed = true;
+				ret = clk_set_rate(clki->clk, clki->min_freq);
+				if (ret) {
+					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
+						__func__, clki->name,
+						clki->min_freq, ret);
+					break;
+				}
+				trace_ufshcd_clk_scaling(dev_name(hba->dev),
+						"scaled down", clki->name,
+						clki->curr_freq,
+						clki->min_freq);
+				clki->curr_freq = clki->min_freq;
+			}
+		}
+		dev_dbg(hba->dev, "%s: clk: %s, rate: %lu\n", __func__,
+				clki->name, clk_get_rate(clki->clk));
+	}
+
+	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
+
+out:
+	if (clk_state_changed)
+		trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
+			(scale_up ? "up" : "down"),
+			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
+	return ret;
+}
+
+/**
+ * ufshcd_is_devfreq_scaling_required - check if scaling is required or not
+ * @hba: per adapter instance
+ * @scale_up: True if scaling up and false if scaling down
+ *
+ * Returns true if scaling is required, false otherwise.
+ */
+static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
+					       bool scale_up)
+{
+	struct ufs_clk_info *clki;
+	struct list_head *head = &hba->clk_list_head;
+
+	if (!head || list_empty(head))
+		return false;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk)) {
+			if (scale_up && clki->max_freq) {
+				if (clki->curr_freq == clki->max_freq)
+					continue;
+				return true;
+			} else if (!scale_up && clki->min_freq) {
+				if (clki->curr_freq == clki->min_freq)
+					continue;
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
+					u64 wait_timeout_us)
+{
+	unsigned long flags;
+	int ret = 0;
+	u32 tm_doorbell;
+	u32 tr_doorbell;
+	bool timeout = false, do_last_check = false;
+	ktime_t start;
+
+	ufshcd_hold(hba, false);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * Wait for all the outstanding tasks/transfer requests.
+	 * Verify by checking the doorbell registers are clear.
+	 */
+	start = ktime_get();
+	do {
+		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		if (!tm_doorbell && !tr_doorbell) {
+			timeout = false;
+			break;
+		} else if (do_last_check) {
+			break;
+		}
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		schedule();
+		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
+		    wait_timeout_us) {
+			timeout = true;
+			/*
+			 * We might have scheduled out for long time so make
+			 * sure to check if doorbells are cleared by this time
+			 * or not.
+			 */
+			do_last_check = true;
+		}
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	} while (tm_doorbell || tr_doorbell);
+
+	if (timeout) {
+		dev_err(hba->dev,
+			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
+			__func__, tm_doorbell, tr_doorbell);
+		ret = -EBUSY;
+	}
+out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_release(hba);
+	return ret;
+}
+
+/**
+ * ufshcd_scale_gear - scale up/down UFS gear
+ * @hba: per adapter instance
+ * @scale_up: True for scaling up gear and false for scaling down
+ *
+ * Returns 0 for success,
+ * Returns -EBUSY if scaling can't happen at this time
+ * Returns non-zero for any other errors
+ */
+static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
+{
+	#define UFS_MIN_GEAR_TO_SCALE_DOWN	UFS_HS_G1
+	int ret = 0;
+	struct ufs_pa_layer_attr new_pwr_info;
+
+	if (scale_up) {
+		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info.info,
+		       sizeof(struct ufs_pa_layer_attr));
+	} else {
+		memcpy(&new_pwr_info, &hba->pwr_info,
+		       sizeof(struct ufs_pa_layer_attr));
+
+		if (hba->pwr_info.gear_tx > UFS_MIN_GEAR_TO_SCALE_DOWN
+		    || hba->pwr_info.gear_rx > UFS_MIN_GEAR_TO_SCALE_DOWN) {
+			/* save the current power mode */
+			memcpy(&hba->clk_scaling.saved_pwr_info.info,
+				&hba->pwr_info,
+				sizeof(struct ufs_pa_layer_attr));
+
+			/* scale down gear */
+			new_pwr_info.gear_tx = UFS_MIN_GEAR_TO_SCALE_DOWN;
+			new_pwr_info.gear_rx = UFS_MIN_GEAR_TO_SCALE_DOWN;
+		}
+	}
+
+	/* check if the power mode needs to be changed or not? */
+	ret = ufshcd_change_power_mode(hba, &new_pwr_info);
+
+	if (ret)
+		dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx %d), new gear: (tx %d rx %d)",
+			__func__, ret,
+			hba->pwr_info.gear_tx, hba->pwr_info.gear_rx,
+			new_pwr_info.gear_tx, new_pwr_info.gear_rx);
+
+	return ret;
+}
+
+static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
+{
+	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
+	int ret = 0;
+	/*
+	 * make sure that there are no outstanding requests when
+	 * clock scaling is in progress
+	 */
+	scsi_block_requests(hba->host);
+	down_write(&hba->clk_scaling_lock);
+	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+		ret = -EBUSY;
+		up_write(&hba->clk_scaling_lock);
+		scsi_unblock_requests(hba->host);
+	}
+
+	return ret;
+}
+
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+	scsi_unblock_requests(hba->host);
+}
+
+/**
+ * ufshcd_devfreq_scale - scale up/down UFS clocks and gear
+ * @hba: per adapter instance
+ * @scale_up: True for scaling up and false for scalin down
+ *
+ * Returns 0 for success,
+ * Returns -EBUSY if scaling can't happen at this time
+ * Returns non-zero for any other errors
+ */
+static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
+{
+	int ret = 0;
+
+	ret = ufshcd_clock_scaling_prepare(hba);
+	if (ret)
+		return ret;
+
+	/* scale down the gear before scaling down clocks */
+	if (!scale_up) {
+		ret = ufshcd_scale_gear(hba, false);
+		if (ret)
+			goto out;
+	}
+
+	ret = ufshcd_scale_clks(hba, scale_up);
+	if (ret) {
+		if (!scale_up)
+			ufshcd_scale_gear(hba, true);
+		goto out;
+	}
+
+	/* scale up the gear after scaling up clocks */
+	if (scale_up) {
+		ret = ufshcd_scale_gear(hba, true);
+		if (ret) {
+			ufshcd_scale_clks(hba, false);
+			goto out;
+		}
+	}
+
+	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
+
+out:
+	ufshcd_clock_scaling_unprepare(hba);
+	return ret;
+}
+
+static int ufshcd_devfreq_target(struct device *dev,
+				unsigned long *freq, u32 flags)
+{
+	int ret = 0;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	ktime_t start;
+	bool scale_up, release_clk_hold = false;
+	unsigned long irq_flags;
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return -EINVAL;
+
+	if ((*freq > 0) && (*freq < UINT_MAX)) {
+		dev_err(hba->dev, "%s: invalid freq = %lu\n", __func__, *freq);
+		return -EINVAL;
+	}
+
+	scale_up = (*freq == UINT_MAX) ? true : false;
+	if (!ufshcd_is_devfreq_scaling_required(hba, scale_up))
+		return 0; /* no state change required */
+
+	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	if (ufshcd_eh_in_progress(hba)) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		return 0;
+	}
+
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		if (cancel_delayed_work(&hba->clk_gating.gate_work) ||
+		    (hba->clk_gating.state == CLKS_ON)) {
+			/* hold the vote until the scaling work is completed */
+			hba->clk_gating.active_reqs++;
+			release_clk_hold = true;
+			if (hba->clk_gating.state != CLKS_ON) {
+				hba->clk_gating.state = CLKS_ON;
+				trace_ufshcd_clk_gating(dev_name(hba->dev),
+						hba->clk_gating.state);
+			}
+		} else {
+			/*
+			 * Clock gating work seems to be running in parallel
+			 * hence skip scaling work to avoid deadlock between
+			 * current scaling work and gating work.
+			 */
+			spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+
+	start = ktime_get();
+
+	ret = ufshcd_devfreq_scale(hba, scale_up);
+
+	if (release_clk_hold)
+		ufshcd_release(hba);
+
+	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
+		(scale_up ? "up" : "down"),
+		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
+
+	return ret;
+}
+
+
+static int ufshcd_devfreq_get_dev_status(struct device *dev,
+		struct devfreq_dev_status *stat)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+	unsigned long flags;
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return -EINVAL;
+
+	memset(stat, 0, sizeof(*stat));
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (!scaling->window_start_t)
+		goto start_window;
+
+	if (scaling->is_busy_started)
+		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
+					scaling->busy_start_t));
+
+	stat->total_time = jiffies_to_usecs((long)jiffies -
+				(long)scaling->window_start_t);
+	stat->busy_time = scaling->tot_busy_t;
+start_window:
+	scaling->window_start_t = jiffies;
+	scaling->tot_busy_t = 0;
+
+	if (hba->outstanding_reqs) {
+		scaling->busy_start_t = ktime_get();
+		scaling->is_busy_started = true;
+	} else {
+		scaling->busy_start_t = 0;
+		scaling->is_busy_started = false;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return 0;
+}
+
+static struct devfreq_dev_profile ufs_devfreq_profile = {
+	.polling_ms	= 100,
+	.target		= ufshcd_devfreq_target,
+	.get_dev_status	= ufshcd_devfreq_get_dev_status,
+};
+
+
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_clkscaling_supported(hba))
@@ -910,7 +1300,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		ufshcd_resume_clkscaling(hba);
 	} else {
 		ufshcd_suspend_clkscaling(hba);
-		err = ufshcd_scale_clks(hba, true);
+		err = ufshcd_devfreq_scale(hba, true);
 		if (err)
 			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
 					__func__, err);
@@ -923,6 +1313,17 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	return count;
 }
 
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
+
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
@@ -1820,6 +2221,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
+	if (!down_read_trylock(&hba->clk_scaling_lock))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -1899,6 +2303,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
+	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -2088,6 +2493,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	struct completion wait;
 	unsigned long flags;
 
+	down_read(&hba->clk_scaling_lock);
+
 	/*
 	 * Get free slot, sleep if slots are unavailable.
 	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2116,6 +2523,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 out_put_tag:
 	ufshcd_put_dev_cmd_tag(hba, tag);
 	wake_up(&hba->dev_cmd.tag_wq);
+	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -3330,8 +3738,6 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			sizeof(struct ufs_pa_layer_attr));
 	}
 
-	ufshcd_print_pwr_info(hba);
-
 	return ret;
 }
 
@@ -3353,6 +3759,8 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
+	if (!ret)
+		ufshcd_print_pwr_info(hba);
 
 	return ret;
 }
@@ -5187,6 +5595,9 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba, false);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	/* scale up clocks to max frequency before full reinitialization */
+	ufshcd_scale_clks(hba, true);
+
 	err = ufshcd_hba_enable(hba);
 	if (err)
 		goto out;
@@ -5822,6 +6233,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	/* Resume devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
+		memcpy(&hba->clk_scaling.saved_pwr_info.info, &hba->pwr_info,
+		       sizeof(struct ufs_pa_layer_attr));
+		hba->clk_scaling.saved_pwr_info.is_valid = true;
 		ufshcd_resume_clkscaling(hba);
 		hba->clk_scaling.is_allowed = true;
 	}
@@ -7200,178 +7614,6 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 }
 EXPORT_SYMBOL(ufshcd_alloc_host);
 
-static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
-{
-	int ret = 0;
-	struct ufs_clk_info *clki;
-	struct list_head *head = &hba->clk_list_head;
-	ktime_t start = ktime_get();
-	bool clk_state_changed = false;
-
-	if (!head || list_empty(head))
-		goto out;
-
-	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
-	if (ret)
-		return ret;
-
-	list_for_each_entry(clki, head, list) {
-		if (!IS_ERR_OR_NULL(clki->clk)) {
-			if (scale_up && clki->max_freq) {
-				if (clki->curr_freq == clki->max_freq)
-					continue;
-
-				clk_state_changed = true;
-				ret = clk_set_rate(clki->clk, clki->max_freq);
-				if (ret) {
-					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
-						__func__, clki->name,
-						clki->max_freq, ret);
-					break;
-				}
-				trace_ufshcd_clk_scaling(dev_name(hba->dev),
-						"scaled up", clki->name,
-						clki->curr_freq,
-						clki->max_freq);
-
-				clki->curr_freq = clki->max_freq;
-
-			} else if (!scale_up && clki->min_freq) {
-				if (clki->curr_freq == clki->min_freq)
-					continue;
-
-				clk_state_changed = true;
-				ret = clk_set_rate(clki->clk, clki->min_freq);
-				if (ret) {
-					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
-						__func__, clki->name,
-						clki->min_freq, ret);
-					break;
-				}
-				trace_ufshcd_clk_scaling(dev_name(hba->dev),
-						"scaled down", clki->name,
-						clki->curr_freq,
-						clki->min_freq);
-				clki->curr_freq = clki->min_freq;
-			}
-		}
-		dev_dbg(hba->dev, "%s: clk: %s, rate: %lu\n", __func__,
-				clki->name, clk_get_rate(clki->clk));
-	}
-
-	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
-
-out:
-	if (clk_state_changed)
-		trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
-			(scale_up ? "up" : "down"),
-			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
-	return ret;
-}
-
-static int ufshcd_devfreq_target(struct device *dev,
-				unsigned long *freq, u32 flags)
-{
-	int err = 0;
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-	bool release_clk_hold = false;
-	unsigned long irq_flags;
-
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return -EINVAL;
-
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return 0;
-	}
-
-	if (ufshcd_is_clkgating_allowed(hba) &&
-	    (hba->clk_gating.state != CLKS_ON)) {
-		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
-			/* hold the vote until the scaling work is completed */
-			hba->clk_gating.active_reqs++;
-			release_clk_hold = true;
-			hba->clk_gating.state = CLKS_ON;
-		} else {
-			/*
-			 * Clock gating work seems to be running in parallel
-			 * hence skip scaling work to avoid deadlock between
-			 * current scaling work and gating work.
-			 */
-			spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-			return 0;
-		}
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-
-	if (*freq == UINT_MAX)
-		err = ufshcd_scale_clks(hba, true);
-	else if (*freq == 0)
-		err = ufshcd_scale_clks(hba, false);
-
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (release_clk_hold)
-		__ufshcd_release(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-
-	return err;
-}
-
-static int ufshcd_devfreq_get_dev_status(struct device *dev,
-		struct devfreq_dev_status *stat)
-{
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
-	unsigned long flags;
-
-	if (!ufshcd_is_clkscaling_supported(hba))
-		return -EINVAL;
-
-	memset(stat, 0, sizeof(*stat));
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (!scaling->window_start_t)
-		goto start_window;
-
-	if (scaling->is_busy_started)
-		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
-					scaling->busy_start_t));
-
-	stat->total_time = jiffies_to_usecs((long)jiffies -
-				(long)scaling->window_start_t);
-	stat->busy_time = scaling->tot_busy_t;
-start_window:
-	scaling->window_start_t = jiffies;
-	scaling->tot_busy_t = 0;
-
-	if (hba->outstanding_reqs) {
-		scaling->busy_start_t = ktime_get();
-		scaling->is_busy_started = true;
-	} else {
-		scaling->busy_start_t = 0;
-		scaling->is_busy_started = false;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	return 0;
-}
-
-static struct devfreq_dev_profile ufs_devfreq_profile = {
-	.polling_ms	= 100,
-	.target		= ufshcd_devfreq_target,
-	.get_dev_status	= ufshcd_devfreq_get_dev_status,
-};
-static void ufshcd_clkscaling_init_sysfs(struct ufs_hba *hba)
-{
-	hba->clk_scaling.enable_attr.show = ufshcd_clkscale_enable_show;
-	hba->clk_scaling.enable_attr.store = ufshcd_clkscale_enable_store;
-	sysfs_attr_init(&hba->clk_scaling.enable_attr.attr);
-	hba->clk_scaling.enable_attr.attr.name = "clkscale_enable";
-	hba->clk_scaling.enable_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_scaling.enable_attr))
-		dev_err(hba->dev, "Failed to create sysfs for clkscale_enable\n");
-}
-
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -7455,6 +7697,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for device management commands */
 	mutex_init(&hba->dev_cmd.lock);
 
+	init_rwsem(&hba->clk_scaling_lock);
+
 	/* Initialize device management tag acquire wait queue */
 	init_waitqueue_head(&hba->dev_cmd.tag_wq);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b7ce129..4da2bbd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -45,6 +45,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/rwsem.h>
 #include <linux/workqueue.h>
 #include <linux/errno.h>
 #include <linux/types.h>
@@ -351,6 +352,11 @@ struct ufs_clk_gating {
 	int active_reqs;
 };
 
+struct ufs_saved_pwr_info {
+	struct ufs_pa_layer_attr info;
+	bool is_valid;
+};
+
 struct ufs_clk_scaling {
 	ktime_t  busy_start_t;
 	bool is_busy_started;
@@ -358,6 +364,7 @@ struct ufs_clk_scaling {
 	unsigned long window_start_t;
 	struct device_attribute enable_attr;
 	bool is_allowed;
+	struct ufs_saved_pwr_info saved_pwr_info;
 };
 
 /**
@@ -634,6 +641,8 @@ struct ufs_hba {
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
+
+	struct rw_semaphore clk_scaling_lock;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
