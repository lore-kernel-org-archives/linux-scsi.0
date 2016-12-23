From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 10/12] scsi: ufs: add time profiling support
Date: Thu, 22 Dec 2016 18:41:48 -0800
Message-ID: <1482460912-6329-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Sahitya Tummala <stummala@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds the profiling support for some of the time critical
operations like hibern8 enter/exit, clock gating & clock scaling.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c  | 24 ++++++++++++++++++++++++
 include/trace/events/ufs.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2d3ca18..36d239d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3021,11 +3021,14 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret;
 	struct uic_command uic_cmd = {0};
+	ktime_t start = ktime_get();
 
 	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
+			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
@@ -3061,11 +3064,15 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
+	ktime_t start = ktime_get();
 
 	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "exit",
+			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
+
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
@@ -5950,6 +5957,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
 	unsigned long flags;
+	ktime_t start = ktime_get();
+	bool clk_state_changed = false;
 
 	if (!head || list_empty(head))
 		goto out;
@@ -5963,6 +5972,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
 				continue;
 
+			clk_state_changed = on ^ clki->enabled;
 			if (on && !clki->enabled) {
 				ret = clk_prepare_enable(clki->clk);
 				if (ret) {
@@ -5997,6 +6007,10 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
 
+	if (clk_state_changed)
+		trace_ufshcd_profile_clk_gating(dev_name(hba->dev),
+			(on ? "on" : "off"),
+			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
 
@@ -6996,6 +7010,8 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
+	ktime_t start = ktime_get();
+	bool clk_state_changed = false;
 
 	if (!head || list_empty(head))
 		goto out;
@@ -7009,6 +7025,8 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 			if (scale_up && clki->max_freq) {
 				if (clki->curr_freq == clki->max_freq)
 					continue;
+
+				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->max_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -7026,6 +7044,8 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 			} else if (!scale_up && clki->min_freq) {
 				if (clki->curr_freq == clki->min_freq)
 					continue;
+
+				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->min_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -7047,6 +7067,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
 
 out:
+	if (clk_state_changed)
+		trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
+			(scale_up ? "up" : "down"),
+			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
 
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 57743b6..e9634df 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -123,6 +123,46 @@
 		__get_str(dev_name), __get_str(state))
 );
 
+DECLARE_EVENT_CLASS(ufshcd_profiling_template,
+	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
+		 int err),
+
+	TP_ARGS(dev_name, profile_info, time_us, err),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(profile_info, profile_info)
+		__field(s64, time_us)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(profile_info, profile_info);
+		__entry->time_us = time_us;
+		__entry->err = err;
+	),
+
+	TP_printk("%s: %s: took %lld usecs, err %d",
+		__get_str(dev_name), __get_str(profile_info),
+		__entry->time_us, __entry->err)
+);
+
+DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_hibern8,
+	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
+		 int err),
+	TP_ARGS(dev_name, profile_info, time_us, err));
+
+DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_gating,
+	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
+		 int err),
+	TP_ARGS(dev_name, profile_info, time_us, err));
+
+DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_scaling,
+	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
+		 int err),
+	TP_ARGS(dev_name, profile_info, time_us, err));
+
 DECLARE_EVENT_CLASS(ufshcd_template,
 	TP_PROTO(const char *dev_name, int err, s64 usecs,
 		 int dev_state, int link_state),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
