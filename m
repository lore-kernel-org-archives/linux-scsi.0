From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RESEND V4 15/17] scsi: ufs: Add support for clock scaling using devfreq framework
Date: Tue, 23 Sep 2014 10:31:37 +0300
Message-ID: <1411457499-8074-16-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40453 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaIWHcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 03:32:39 -0400
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sahitya Tummala <stummala@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sahitya Tummala <stummala@codeaurora.org>

The clocks for UFS device will be managed by generic DVFS (Dynamic
Voltage and Frequency Scaling) framework within kernel. This devfreq
framework works with different governors to scale the clocks. By default,
UFS devices uses simple_ondemand governor which scales the clocks up if
the load is more than upthreshold and scales down if the load is less than
downthreshold.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index f07f901..6e07b2a 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -35,6 +35,8 @@
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller Driver Core"
 	depends on SCSI && SCSI_DMA
+	select PM_DEVFREQ
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b6043a6..70c1f5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -38,6 +38,7 @@
  */
 
 #include <linux/async.h>
+#include <linux/devfreq.h>
 
 #include "ufshcd.h"
 #include "unipro.h"
@@ -545,6 +546,8 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
+	if (ufshcd_is_clkscaling_enabled(hba))
+		devfreq_resume_device(hba->devfreq);
 	scsi_unblock_requests(hba->host);
 }
 
@@ -561,10 +564,10 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 
 	if (!ufshcd_is_clkgating_allowed(hba))
 		goto out;
-start:
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
 
+start:
 	switch (hba->clk_gating.state) {
 	case CLKS_ON:
 		break;
@@ -596,6 +599,7 @@ start:
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		flush_work(&hba->clk_gating.ungate_work);
 		/* Make sure state is CLKS_ON before returning */
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		goto start;
 	default:
 		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
@@ -636,6 +640,11 @@ static void ufshcd_gate_work(struct work_struct *work)
 		ufshcd_set_link_hibern8(hba);
 	}
 
+	if (ufshcd_is_clkscaling_enabled(hba)) {
+		devfreq_suspend_device(hba->devfreq);
+		hba->clk_scaling.window_start_t = 0;
+	}
+
 	if (!ufshcd_is_link_active(hba))
 		ufshcd_setup_clocks(hba, false);
 	else
@@ -737,6 +746,32 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
 }
 
+/* Must be called with host lock acquired */
+static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkscaling_enabled(hba))
+		return;
+
+	if (!hba->clk_scaling.is_busy_started) {
+		hba->clk_scaling.busy_start_t = ktime_get();
+		hba->clk_scaling.is_busy_started = true;
+	}
+}
+
+static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
+{
+	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+
+	if (!ufshcd_is_clkscaling_enabled(hba))
+		return;
+
+	if (!hba->outstanding_reqs && scaling->is_busy_started) {
+		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
+					scaling->busy_start_t));
+		scaling->busy_start_t = ktime_set(0, 0);
+		scaling->is_busy_started = false;
+	}
+}
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
@@ -745,6 +780,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
+	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 }
@@ -3041,6 +3077,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	/* clear corresponding bits of completed commands */
 	hba->outstanding_reqs ^= completed_reqs;
 
+	ufshcd_clk_scaling_update_busy(hba);
+
 	/* we might have free'd some tags above */
 	wake_up(&hba->dev_cmd.tag_wq);
 }
@@ -4083,6 +4121,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (!hba->is_init_prefetch)
 		hba->is_init_prefetch = true;
 
+	/* Resume devfreq after UFS device is detected */
+	if (ufshcd_is_clkscaling_enabled(hba))
+		devfreq_resume_device(hba->devfreq);
+
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
@@ -4404,6 +4446,7 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 					clki->max_freq, ret);
 				goto out;
 			}
+			clki->curr_freq = clki->max_freq;
 		}
 		dev_dbg(dev, "%s: clk: %s, rate: %lu\n", __func__,
 				clki->name, clk_get_rate(clki->clk));
@@ -4800,6 +4843,15 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 disable_clks:
 	/*
+	 * The clock scaling needs access to controller registers. Hence, Wait
+	 * for pending clock scaling work to be done before clocks are
+	 * turned off.
+	 */
+	if (ufshcd_is_clkscaling_enabled(hba)) {
+		devfreq_suspend_device(hba->devfreq);
+		hba->clk_scaling.window_start_t = 0;
+	}
+	/*
 	 * Call vendor specific suspend callback. As these callbacks may access
 	 * vendor specific host controller register space call them before the
 	 * host clocks are ON.
@@ -4921,6 +4973,9 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_disable_auto_bkops(hba);
 	hba->clk_gating.is_suspended = false;
 
+	if (ufshcd_is_clkscaling_enabled(hba))
+		devfreq_resume_device(hba->devfreq);
+
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
 	goto out;
@@ -5103,6 +5158,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	scsi_host_put(hba->host);
 
 	ufshcd_exit_clk_gating(hba);
+	if (ufshcd_is_clkscaling_enabled(hba))
+		devfreq_remove_device(hba->devfreq);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
@@ -5159,6 +5216,112 @@ out_error:
 }
 EXPORT_SYMBOL(ufshcd_alloc_host);
 
+static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
+{
+	int ret = 0;
+	struct ufs_clk_info *clki;
+	struct list_head *head = &hba->clk_list_head;
+
+	if (!head || list_empty(head))
+		goto out;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk)) {
+			if (scale_up && clki->max_freq) {
+				if (clki->curr_freq == clki->max_freq)
+					continue;
+				ret = clk_set_rate(clki->clk, clki->max_freq);
+				if (ret) {
+					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
+						__func__, clki->name,
+						clki->max_freq, ret);
+					break;
+				}
+				clki->curr_freq = clki->max_freq;
+
+			} else if (!scale_up && clki->min_freq) {
+				if (clki->curr_freq == clki->min_freq)
+					continue;
+				ret = clk_set_rate(clki->clk, clki->min_freq);
+				if (ret) {
+					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
+						__func__, clki->name,
+						clki->min_freq, ret);
+					break;
+				}
+				clki->curr_freq = clki->min_freq;
+			}
+		}
+		dev_dbg(hba->dev, "%s: clk: %s, rate: %lu\n", __func__,
+				clki->name, clk_get_rate(clki->clk));
+	}
+	if (hba->vops->clk_scale_notify)
+		hba->vops->clk_scale_notify(hba);
+out:
+	return ret;
+}
+
+static int ufshcd_devfreq_target(struct device *dev,
+				unsigned long *freq, u32 flags)
+{
+	int err = 0;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!ufshcd_is_clkscaling_enabled(hba))
+		return -EINVAL;
+
+	if (*freq == UINT_MAX)
+		err = ufshcd_scale_clks(hba, true);
+	else if (*freq == 0)
+		err = ufshcd_scale_clks(hba, false);
+
+	return err;
+}
+
+static int ufshcd_devfreq_get_dev_status(struct device *dev,
+		struct devfreq_dev_status *stat)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+	unsigned long flags;
+
+	if (!ufshcd_is_clkscaling_enabled(hba))
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
+		scaling->busy_start_t = ktime_set(0, 0);
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
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -5268,6 +5431,19 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
+	if (ufshcd_is_clkscaling_enabled(hba)) {
+		hba->devfreq = devfreq_add_device(dev, &ufs_devfreq_profile,
+						   "simple_ondemand", NULL);
+		if (IS_ERR(hba->devfreq)) {
+			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
+					PTR_ERR(hba->devfreq));
+			goto out_remove_scsi_host;
+		}
+		/* Suspend devfreq until the UFS device is detected */
+		devfreq_suspend_device(hba->devfreq);
+		hba->clk_scaling.window_start_t = 0;
+	}
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2caa27e..d5699d0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -210,6 +210,7 @@ struct ufs_dev_cmd {
  * @name: clock name
  * @max_freq: maximum frequency supported by the clock
  * @min_freq: min frequency that can be used for clock scaling
+ * @curr_freq: indicates the current frequency that it is set to
  * @enabled: variable to check against multiple enable/disable
  */
 struct ufs_clk_info {
@@ -218,6 +219,7 @@ struct ufs_clk_info {
 	const char *name;
 	u32 max_freq;
 	u32 min_freq;
+	u32 curr_freq;
 	bool enabled;
 };
 
@@ -244,6 +246,7 @@ struct ufs_pwr_mode_info {
  * @name: variant name
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
+ * @clk_scale_notify: notifies that clks are scaled up/down
  * @setup_clocks: called before touching any of the controller registers
  * @setup_regulators: called before accessing the host controller
  * @hce_enable_notify: called before and after HCE enable bit is set to allow
@@ -260,6 +263,7 @@ struct ufs_hba_variant_ops {
 	const char *name;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
+	void    (*clk_scale_notify)(struct ufs_hba *);
 	int     (*setup_clocks)(struct ufs_hba *, bool);
 	int     (*setup_regulators)(struct ufs_hba *, bool);
 	int     (*hce_enable_notify)(struct ufs_hba *, bool);
@@ -303,6 +307,13 @@ struct ufs_clk_gating {
 	int active_reqs;
 };
 
+struct ufs_clk_scaling {
+	ktime_t  busy_start_t;
+	bool is_busy_started;
+	unsigned long  tot_busy_t;
+	unsigned long window_start_t;
+};
+
 /**
  * struct ufs_init_prefetch - contains data that is pre-fetched once during
  * initialization
@@ -453,6 +464,11 @@ struct ufs_hba {
 #define UFSHCD_CAP_CLK_GATING	(1 << 0)
 	/* Allow hiberb8 with clk gating */
 #define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
+	/* Allow dynamic clk scaling */
+#define UFSHCD_CAP_CLK_SCALING	(1 << 2)
+
+	struct devfreq *devfreq;
+	struct ufs_clk_scaling clk_scaling;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -464,6 +480,10 @@ static inline bool ufshcd_can_hibern8_during_gating(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
 }
+static inline int ufshcd_is_clkscaling_enabled(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_CLK_SCALING;
+}
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

