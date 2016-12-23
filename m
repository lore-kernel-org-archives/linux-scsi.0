From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 02/12] scsi: ufs: add tracing support
Date: Thu, 22 Dec 2016 18:39:51 -0800
Message-ID: <1482460798-6010-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
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
Changes from v2 -> v3:
 - Used TRACE_DEFINE_ENUM to print out enums
---
 drivers/scsi/ufs/ufshcd.c  |  85 ++++++++++++++++++---
 include/trace/events/ufs.h | 185 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 258 insertions(+), 12 deletions(-)
 create mode 100644 include/trace/events/ufs.h

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fe516b2..d718cb6 100644
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
@@ -801,6 +804,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	case REQ_CLKS_OFF:
 		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+						hba->clk_gating.state);
 			break;
 		}
 		/*
@@ -811,6 +816,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	case CLKS_OFF:
 		scsi_block_requests(hba->host);
 		hba->clk_gating.state = REQ_CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
 		schedule_work(&hba->clk_gating.ungate_work);
 		/*
 		 * fall through to check if we should wait for this
@@ -855,6 +862,8 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (hba->clk_gating.is_suspended ||
 		(hba->clk_gating.state == REQ_CLKS_ON)) {
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
 		goto rel_lock;
 	}
 
@@ -870,6 +879,8 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		if (ufshcd_uic_hibern8_enter(hba)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+						hba->clk_gating.state);
 			goto out;
 		}
 		ufshcd_set_link_hibern8(hba);
@@ -893,9 +904,11 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * new requests arriving before the current cancel work is done.
 	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.state == REQ_CLKS_OFF)
+	if (hba->clk_gating.state == REQ_CLKS_OFF) {
 		hba->clk_gating.state = CLKS_OFF;
-
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
+	}
 rel_lock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
@@ -918,6 +931,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
 	schedule_delayed_work(&hba->clk_gating.gate_work,
 			msecs_to_jiffies(hba->clk_gating.delay_ms));
 }
@@ -3932,6 +3946,7 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = true;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Enabled");
 
 	/* No need of URGENT_BKOPS exception from the device */
 	err = ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
@@ -3982,6 +3997,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = false;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
 out:
 	return err;
 }
@@ -5377,6 +5393,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
 	int ret;
+	ktime_t start = ktime_get();
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
@@ -5468,6 +5485,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		ufshcd_hba_exit(hba);
 	}
 
+	trace_ufshcd_init(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		hba->uic_link_state, hba->curr_dev_pwr_mode);
 	return ret;
 }
 
@@ -5817,11 +5837,14 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (on) {
+	} else if (!ret && on) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
+
 	return ret;
 }
 
@@ -6304,6 +6327,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		__ufshcd_setup_clocks(hba, false, true);
 
 	hba->clk_gating.state = CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller transaction expected till resume.
@@ -6436,6 +6460,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 int ufshcd_system_suspend(struct ufs_hba *hba)
 {
 	int ret = 0;
+	ktime_t start = ktime_get();
 
 	if (!hba || !hba->is_powered)
 		return 0;
@@ -6462,6 +6487,9 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 	ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
 out:
+	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		hba->uic_link_state, hba->curr_dev_pwr_mode);
 	if (!ret)
 		hba->is_sys_suspended = true;
 	return ret;
@@ -6477,6 +6505,9 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 int ufshcd_system_resume(struct ufs_hba *hba)
 {
+	int ret = 0;
+	ktime_t start = ktime_get();
+
 	if (!hba)
 		return -EINVAL;
 
@@ -6485,9 +6516,14 @@ int ufshcd_system_resume(struct ufs_hba *hba)
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
+		hba->uic_link_state, hba->curr_dev_pwr_mode);
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
 
@@ -6501,13 +6537,21 @@ int ufshcd_system_resume(struct ufs_hba *hba)
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
+		hba->uic_link_state, hba->curr_dev_pwr_mode);
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_suspend);
 
@@ -6534,13 +6578,21 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
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
+		hba->uic_link_state, hba->curr_dev_pwr_mode);
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
@@ -6684,6 +6736,11 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
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
@@ -6696,6 +6753,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
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
index 0000000..57743b6
--- /dev/null
+++ b/include/trace/events/ufs.h
@@ -0,0 +1,185 @@
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
+#define UFS_LINK_STATES			\
+	EM(UIC_LINK_OFF_STATE)		\
+	EM(UIC_LINK_ACTIVE_STATE)	\
+	EMe(UIC_LINK_HIBERN8_STATE)
+
+#define UFS_PWR_MODES			\
+	EM(UFS_ACTIVE_PWR_MODE)		\
+	EM(UFS_SLEEP_PWR_MODE)		\
+	EMe(UFS_POWERDOWN_PWR_MODE)
+
+#define UFSCHD_CLK_GATING_STATES	\
+	EM(CLKS_OFF)			\
+	EM(CLKS_ON)			\
+	EM(REQ_CLKS_OFF)		\
+	EMe(REQ_CLKS_ON)
+
+/* Enums require being exported to userspace, for user tool parsing */
+#undef EM
+#undef EMe
+#define EM(a)	TRACE_DEFINE_ENUM(a);
+#define EMe(a)	TRACE_DEFINE_ENUM(a);
+
+UFS_LINK_STATES;
+UFS_PWR_MODES;
+UFSCHD_CLK_GATING_STATES;
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a)	{ a, #a },
+#define EMe(a)	{ a, #a }
+
+TRACE_EVENT(ufshcd_clk_gating,
+
+	TP_PROTO(const char *dev_name, int state),
+
+	TP_ARGS(dev_name, state),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__field(int, state)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__entry->state = state;
+	),
+
+	TP_printk("%s: gating state changed to %s",
+		__get_str(dev_name),
+		__print_symbolic(__entry->state, UFSCHD_CLK_GATING_STATES))
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
+		 int dev_state, int link_state),
+
+	TP_ARGS(dev_name, err, usecs, dev_state, link_state),
+
+	TP_STRUCT__entry(
+		__field(s64, usecs)
+		__field(int, err)
+		__string(dev_name, dev_name)
+		__field(int, dev_state)
+		__field(int, link_state)
+	),
+
+	TP_fast_assign(
+		__entry->usecs = usecs;
+		__entry->err = err;
+		__assign_str(dev_name, dev_name);
+		__entry->dev_state = dev_state;
+		__entry->link_state = link_state;
+	),
+
+	TP_printk(
+		"%s: took %lld usecs, dev_state: %s, link_state: %s, err %d",
+		__get_str(dev_name),
+		__entry->usecs,
+		__print_symbolic(__entry->dev_state, UFS_PWR_MODES),
+		__print_symbolic(__entry->link_state, UFS_LINK_STATES),
+		__entry->err
+	)
+);
+
+DEFINE_EVENT(ufshcd_template, ufshcd_system_suspend,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      int dev_state, int link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_system_resume,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      int dev_state, int link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_runtime_suspend,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      int dev_state, int link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_runtime_resume,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      int dev_state, int link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+
+DEFINE_EVENT(ufshcd_template, ufshcd_init,
+	     TP_PROTO(const char *dev_name, int err, s64 usecs,
+		      int dev_state, int link_state),
+	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
+#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
