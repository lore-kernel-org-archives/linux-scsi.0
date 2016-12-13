From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 02/12] scsi: ufs: add tracing support
Date: Mon, 12 Dec 2016 16:52:42 -0800
Message-ID: <1481590366-32191-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Gilad Broner <gbroner@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This change adds the ftrace support for following:
1. UFS initialization time
2. Clock gating states
3. Clock scaling states
4. Power management APIs latency
5. BKOPs enable/disable

Usage:
	echo 1 > /sys/kernel/debug/tracing/events/ufs/enable
	cat /sys/kernel/debug/tracing/trace_pipe

Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c  | 133 ++++++++++++++++++++++++++++++++++++----
 include/trace/events/ufs.h | 149 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+), 12 deletions(-)
 create mode 100644 include/trace/events/ufs.h

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8ff6a18..86bf409 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -45,6 +45,9 @@
 #include "ufs_quirks.h"
 #include "unipro.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ufs.h>
+
 #define UFSHCD_REQ_SENSE_SIZE	18
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
@@ -721,6 +724,40 @@ static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 		devfreq_resume_device(hba->devfreq);
 }
 
+static const char *ufschd_uic_link_state_to_string(
+			enum uic_link_state state)
+{
+	switch (state) {
+	case UIC_LINK_OFF_STATE:	return "UIC_LINK_OFF_STATE";
+	case UIC_LINK_ACTIVE_STATE:	return "UIC_LINK_ACTIVE_STATE";
+	case UIC_LINK_HIBERN8_STATE:	return "UIC_LINK_HIBERN8_STATE";
+	default:			return "UNKNOWN_STATE";
+	}
+}
+
+static const char *ufschd_ufs_dev_pwr_mode_to_string(
+			enum ufs_dev_pwr_mode state)
+{
+	switch (state) {
+	case UFS_ACTIVE_PWR_MODE:	return "UFS_ACTIVE_PWR_MODE";
+	case UFS_SLEEP_PWR_MODE:	return "UFS_SLEEP_PWR_MODE";
+	case UFS_POWERDOWN_PWR_MODE:	return "UFS_POWERDOWN_PWR_MODE";
+	default:			return "UNKNOWN_STATE";
+	}
+}
+
+static const char *ufschd_clk_gating_state_to_string(
+			enum clk_gating_state state)
+{
+	switch (state) {
+	case CLKS_OFF:		return "CLKS_OFF";
+	case CLKS_ON:		return "CLKS_ON";
+	case REQ_CLKS_OFF:	return "REQ_CLKS_OFF";
+	case REQ_CLKS_ON:	return "REQ_CLKS_ON";
+	default:		return "UNKNOWN_STATE";
+	}
+}
+
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
@@ -801,6 +838,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	case REQ_CLKS_OFF:
 		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
 			break;
 		}
 		/*
@@ -811,6 +851,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	case CLKS_OFF:
 		scsi_block_requests(hba->host);
 		hba->clk_gating.state = REQ_CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+			ufschd_clk_gating_state_to_string(
+				hba->clk_gating.state));
 		schedule_work(&hba->clk_gating.ungate_work);
 		/*
 		 * fall through to check if we should wait for this
@@ -855,6 +898,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (hba->clk_gating.is_suspended ||
 		(hba->clk_gating.state == REQ_CLKS_ON)) {
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
 		goto rel_lock;
 	}
 
@@ -870,6 +916,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		if (ufshcd_uic_hibern8_enter(hba)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+					ufschd_clk_gating_state_to_string(
+						hba->clk_gating.state));
 			goto out;
 		}
 		ufshcd_set_link_hibern8(hba);
@@ -893,9 +942,12 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * new requests arriving before the current cancel work is done.
 	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.state == REQ_CLKS_OFF)
+	if (hba->clk_gating.state == REQ_CLKS_OFF) {
 		hba->clk_gating.state = CLKS_OFF;
-
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
+	}
 rel_lock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
@@ -918,6 +970,9 @@ static void __ufshcd_release(struct ufs_hba *hba)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev),
+			ufschd_clk_gating_state_to_string(
+				hba->clk_gating.state));
 	schedule_delayed_work(&hba->clk_gating.gate_work,
 			msecs_to_jiffies(hba->clk_gating.delay_ms));
 }
@@ -3932,6 +3987,7 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = true;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Enabled");
 
 	/* No need of URGENT_BKOPS exception from the device */
 	err = ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
@@ -3982,6 +4038,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = false;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
 out:
 	return err;
 }
@@ -5377,6 +5434,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
 	int ret;
+	ktime_t start = ktime_get();
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
@@ -5468,6 +5526,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		ufshcd_hba_exit(hba);
 	}
 
+	trace_ufshcd_init(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_uic_link_state_to_string(hba->uic_link_state),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode));
 	return ret;
 }
 
@@ -5817,11 +5879,15 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (on) {
+	} else if (!ret && on) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
+
 	return ret;
 }
 
@@ -6304,6 +6370,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		__ufshcd_setup_clocks(hba, false, true);
 
 	hba->clk_gating.state = CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev),
+		ufschd_clk_gating_state_to_string(hba->clk_gating.state));
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller transaction expected till resume.
@@ -6436,6 +6504,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 int ufshcd_system_suspend(struct ufs_hba *hba)
 {
 	int ret = 0;
+	ktime_t start = ktime_get();
 
 	if (!hba || !hba->is_powered)
 		return 0;
@@ -6462,6 +6531,10 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 	ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
 out:
+	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_uic_link_state_to_string(hba->uic_link_state),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode));
 	if (!ret)
 		hba->is_sys_suspended = true;
 	return ret;
@@ -6477,6 +6550,9 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 int ufshcd_system_resume(struct ufs_hba *hba)
 {
+	int ret = 0;
+	ktime_t start = ktime_get();
+
 	if (!hba)
 		return -EINVAL;
 
@@ -6485,9 +6561,15 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 		 * Let the runtime resume take care of resuming
 		 * if runtime suspended.
 		 */
-		return 0;
-
-	return ufshcd_resume(hba, UFS_SYSTEM_PM);
+		goto out;
+	else
+		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
+out:
+	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_uic_link_state_to_string(hba->uic_link_state),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
 
@@ -6501,13 +6583,22 @@ int ufshcd_system_resume(struct ufs_hba *hba)
  */
 int ufshcd_runtime_suspend(struct ufs_hba *hba)
 {
+	int ret = 0;
+	ktime_t start = ktime_get();
+
 	if (!hba)
 		return -EINVAL;
 
 	if (!hba->is_powered)
-		return 0;
-
-	return ufshcd_suspend(hba, UFS_RUNTIME_PM);
+		goto out;
+	else
+		ret = ufshcd_suspend(hba, UFS_RUNTIME_PM);
+out:
+	trace_ufshcd_runtime_suspend(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_uic_link_state_to_string(hba->uic_link_state),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_suspend);
 
@@ -6534,13 +6625,22 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
  */
 int ufshcd_runtime_resume(struct ufs_hba *hba)
 {
+	int ret = 0;
+	ktime_t start = ktime_get();
+
 	if (!hba)
 		return -EINVAL;
 
 	if (!hba->is_powered)
-		return 0;
-
-	return ufshcd_resume(hba, UFS_RUNTIME_PM);
+		goto out;
+	else
+		ret = ufshcd_resume(hba, UFS_RUNTIME_PM);
+out:
+	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_uic_link_state_to_string(hba->uic_link_state),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
@@ -6684,6 +6784,11 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 						clki->max_freq, ret);
 					break;
 				}
+				trace_ufshcd_clk_scaling(dev_name(hba->dev),
+						"scaled up", clki->name,
+						clki->curr_freq,
+						clki->max_freq);
+
 				clki->curr_freq = clki->max_freq;
 
 			} else if (!scale_up && clki->min_freq) {
@@ -6696,6 +6801,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 						clki->min_freq, ret);
 					break;
 				}
+				trace_ufshcd_clk_scaling(dev_name(hba->dev),
+						"scaled down", clki->name,
+						clki->curr_freq,
+						clki->min_freq);
 				clki->curr_freq = clki->min_freq;
 			}
 		}
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
new file mode 100644
index 0000000..7b3d9e1
--- /dev/null
+++ b/include/trace/events/ufs.h
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ufs
+
+#if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_UFS_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ufshcd_clk_gating,
+
+	TP_PROTO(const char *dev_name, const char *state),
+
+	TP_ARGS(dev_name, state),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(state, state)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(state, state);
+	),
+
+	TP_printk("%s: gating state changed to %s",
+		__get_str(dev_name), __get_str(state))
+);
+
+TRACE_EVENT(ufshcd_clk_scaling,
+
+	TP_PROTO(const char *dev_name, const char *state, const char *clk,
+		u32 prev_state, u32 curr_state),
+
+	TP_ARGS(dev_name, state, clk, prev_state, curr_state),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(state, state)
+		__string(clk, clk)
+		__field(u32, prev_state)
+		__field(u32, curr_state)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(state, state);
+		__assign_str(clk, clk);
+		__entry->prev_state = prev_state;
+		__entry->curr_state = curr_state;
+	),
+
+	TP_printk("%s: %s %s from %u to %u Hz",
+		__get_str(dev_name), __get_str(state), __get_str(clk),
+		__entry->prev_state, __entry->curr_state)
+);
+
+TRACE_EVENT(ufshcd_auto_bkops_state,
+
+	TP_PROTO(const char *dev_name, const char *state),
+
+	TP_ARGS(dev_name, state),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(state, state)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(state, state);
+	),
+
+	TP_printk("%s: auto bkops - %s",
+		__get_str(dev_name), __get_str(state))
+);
+
+DECLARE_EVENT_CLASS(ufshcd_template,
+	TP_PROTO(const char *dev_name, int err, s64 usecs,
+		 const char *dev_state, const char *link_state),
+
+	TP_ARGS(dev_name, err, usecs, dev_state, link_state),
+
+	TP_STRUCT__entry(
+		__field(s64, usecs)
+		__field(int, err)
+		__string(dev_name, dev_name)
+		__string(dev_state, dev_state)
+		__string(link_state, link_state)
+	),
+
+	TP_fast_assign(
+		__entry->usecs = usecs;
+		__entry->err = err;
+		__assign_str(dev_name, dev_name);
+		__assign_str(dev_state, dev_state);
+		__assign_str(link_state, link_state);
+	),
+
+	TP_printk(
+		"%s: took %lld usecs, dev_state: %s, link_state: %s, err %d",
+		__get_str(dev_name),
+		__entry->usecs,
+		__get_str(dev_state),
+		__get_str(link_state),
+		__entry->err
+	)
+);
+
+DEFINE_EVENT(ufshcd_template, ufshcd_system_suspend,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      const char *dev_state, const char *link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_system_resume,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      const char *dev_state, const char *link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_runtime_suspend,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      const char *dev_state, const char *link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_runtime_resume,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      const char *dev_state, const char *link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_init,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      const char *dev_state, const char *link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
