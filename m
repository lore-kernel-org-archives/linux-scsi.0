From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v6 3/3] scsi: ufs: add trace events and dump prints for debug
Date: Thu, 12 Mar 2015 14:27:41 +0200
Message-ID: <1426163262-22014-4-git-send-email-gbroner@codeaurora.org>
References: <1426163262-22014-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426163262-22014-1-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Add trace events to driver to allow monitoring and profilig
of activities such as PM suspend/resume, hibernate enter/exit,
clock gating and clock scaling up/down.
In addition, add UFS host controller register dumps to provide
detailed information in case of errors to assist in analysis
of issues.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Lee Susman <lsusman@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c |  53 +++++
 drivers/scsi/ufs/ufshcd.c   | 511 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h   |  49 ++++-
 drivers/scsi/ufs/ufshci.h   |   1 +
 include/trace/events/ufs.h  | 213 ++++++++++++++++++
 5 files changed, 790 insertions(+), 37 deletions(-)
 create mode 100644 include/trace/events/ufs.h

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9217af9..9fe675d 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -30,6 +30,14 @@ static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
 		const char *speed_mode);
 static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
 
+static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int len,
+		char *prefix)
+{
+	print_hex_dump(KERN_ERR, prefix,
+			len > 4 ? DUMP_PREFIX_OFFSET : DUMP_PREFIX_NONE,
+			16, 4, hba->mmio_base + offset, len * 4, false);
+}
+
 static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
 {
 	int err = 0;
@@ -983,6 +991,50 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
 				dev_req_params->hs_rate);
 }
 
+static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba)
+{
+	u32 reg;
+
+	ufs_qcom_dump_regs(hba, UFS_UFS_DBG_RD_REG_OCSC, 44,
+			"UFS_UFS_DBG_RD_REG_OCSC ");
+
+	reg = ufshcd_readl(hba, REG_UFS_CFG1);
+	reg |= UFS_BIT(17);
+	ufshcd_writel(hba, reg, REG_UFS_CFG1);
+
+	ufs_qcom_dump_regs(hba, UFS_UFS_DBG_RD_EDTL_RAM, 32,
+			"UFS_UFS_DBG_RD_EDTL_RAM ");
+	ufs_qcom_dump_regs(hba, UFS_UFS_DBG_RD_DESC_RAM, 128,
+			"UFS_UFS_DBG_RD_DESC_RAM ");
+	ufs_qcom_dump_regs(hba, UFS_UFS_DBG_RD_PRDT_RAM, 64,
+			"UFS_UFS_DBG_RD_PRDT_RAM ");
+
+	ufshcd_writel(hba, (reg & ~UFS_BIT(17)), REG_UFS_CFG1);
+
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_UAWM, 4,
+			"UFS_DBG_RD_REG_UAWM ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_UARM, 4,
+			"UFS_DBG_RD_REG_UARM ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_TXUC, 48,
+			"UFS_DBG_RD_REG_TXUC ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_RXUC, 27,
+			"UFS_DBG_RD_REG_RXUC ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_DFC, 19,
+			"UFS_DBG_RD_REG_DFC ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_TRLUT, 34,
+			"UFS_DBG_RD_REG_TRLUT ");
+	ufs_qcom_dump_regs(hba, UFS_DBG_RD_REG_TMRLUT, 9,
+			"UFS_DBG_RD_REG_TMRLUT ");
+}
+
+static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
+{
+	ufs_qcom_dump_regs(hba, REG_UFS_SYS1CLK_1US, 5,
+			"REG_UFS_SYS1CLK_1US ");
+
+	ufs_qcom_print_hw_debug_reg_all(hba);
+}
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1000,5 +1052,6 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
+	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 };
 EXPORT_SYMBOL(ufs_hba_qcom_vops);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7697cc6..3ae0b3f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -45,6 +45,9 @@
 #include "unipro.h"
 #include "ufs-debugfs.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ufs.h>
+
 #ifdef CONFIG_DEBUG_FS
 
 static void ufshcd_update_error_stats(struct ufs_hba *hba, int type)
@@ -145,6 +148,8 @@ static inline ufshcd_update_error_stats(struct ufs_hba *hba, int type)
 			_ret = ufshcd_disable_vreg(_dev, _vreg);        \
 		_ret;                                                   \
 	})
+#define ufshcd_hex_dump(prefix_str, buf, len) \
+print_hex_dump(KERN_ERR, prefix_str, DUMP_PREFIX_OFFSET, 16, 4, buf, len, false)
 
 static u32 ufs_query_desc_max_size[] = {
 	QUERY_DESC_DEVICE_MAX_SIZE,
@@ -272,6 +277,151 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 	}
 }
 
+#ifdef CONFIG_TRACEPOINTS
+static void ufshcd_add_command_trace(struct ufs_hba *hba,
+		unsigned int tag, const char *str)
+{
+	sector_t lba = -1;
+	u8 opcode = 0;
+	u32 intr, doorbell;
+	struct ufshcd_lrb *lrbp;
+	int transfer_len = -1;
+
+	lrbp = &hba->lrb[tag];
+
+	if (lrbp->cmd) { /* data phase exists */
+		opcode = (u8)(*lrbp->cmd->cmnd);
+		if ((opcode == READ_10) || (opcode == WRITE_10)) {
+			/*
+			 * Currently we only fully trace read(10) and write(10)
+			 * commands
+			 */
+			if (lrbp->cmd->request && lrbp->cmd->request->bio)
+				lba =
+				 lrbp->cmd->request->bio->bi_iter.bi_sector;
+			transfer_len = be32_to_cpu(
+				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		}
+	}
+
+	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	trace_ufshcd_command(dev_name(hba->dev), str, tag,
+				doorbell, transfer_len, intr, lba, opcode);
+}
+
+static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
+					unsigned int tag, const char *str)
+{
+	if (trace_ufshcd_command_enabled())
+		ufshcd_add_command_trace(hba, tag, str);
+}
+#else
+static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
+					unsigned int tag, const char *str)
+{
+}
+#endif
+
+static void ufshcd_print_uic_err_hist(struct ufs_hba *hba,
+		struct ufs_uic_err_reg_hist *err_hist, char *err_name)
+{
+	int i;
+
+	for (i = 0; i < UIC_ERR_REG_HIST_LENGTH; i++) {
+		int p = (i + err_hist->pos - 1) % UIC_ERR_REG_HIST_LENGTH;
+
+		if (err_hist->reg[p] == 0)
+			continue;
+		dev_err(hba->dev, "%s[%d] = 0x%x at %lld us", err_name, i,
+			err_hist->reg[p], ktime_to_us(err_hist->tstamp[p]));
+	}
+}
+
+static void ufshcd_print_host_regs(struct ufs_hba *hba)
+{
+	/*
+	 * hex_dump reads its data without the readl macro. This might
+	 * cause inconsistency issues on some platform, as the printed
+	 * values may be from cache and not the most recent value.
+	 * To know whether you are looking at an un-cached version verify
+	 * that IORESOURCE_MEM flag is on when xxx_get_resource() is invoked
+	 * during platform/pci probe function.
+	 */
+	ufshcd_hex_dump("host regs: ", hba->mmio_base, UFSHCI_REG_SPACE_SIZE);
+	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 0x%x",
+		hba->ufs_version, hba->capabilities);
+	dev_err(hba->dev,
+		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x",
+		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
+	dev_err(hba->dev,
+		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d",
+		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
+		hba->ufs_stats.hibern8_exit_cnt);
+
+	ufshcd_print_uic_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
+	ufshcd_print_uic_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
+	ufshcd_print_uic_err_hist(hba, &hba->ufs_stats.nl_err, "nl_err");
+	ufshcd_print_uic_err_hist(hba, &hba->ufs_stats.tl_err, "tl_err");
+	ufshcd_print_uic_err_hist(hba, &hba->ufs_stats.dme_err, "dme_err");
+
+	if (hba->vops && hba->vops->dbg_register_dump)
+		hba->vops->dbg_register_dump(hba);
+}
+
+static
+void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
+{
+	struct ufshcd_lrb *lrbp;
+	int prdt_length;
+	int tag;
+
+	for_each_set_bit(tag, &bitmap, hba->nutrs) {
+		lrbp = &hba->lrb[tag];
+
+		dev_err(hba->dev, "UPIU[%d] - issue time %lld us",
+				tag, ktime_to_us(lrbp->issue_time_stamp));
+		dev_err(hba->dev, "UPIU[%d] - Transfer Request Descriptor",
+				tag);
+		ufshcd_hex_dump("UPIU TRD: ", lrbp->utr_descriptor_ptr,
+				sizeof(struct utp_transfer_req_desc));
+		dev_err(hba->dev, "UPIU[%d] - Request UPIU", tag);
+		ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
+				sizeof(struct utp_upiu_req));
+		dev_err(hba->dev, "UPIU[%d] - Response UPIU", tag);
+		ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
+				sizeof(struct utp_upiu_rsp));
+		prdt_length =
+			le16_to_cpu(lrbp->utr_descriptor_ptr->prd_table_length);
+		dev_err(hba->dev, "UPIU[%d] - PRDT - %d entries", tag,
+			prdt_length);
+		if (pr_prdt)
+			ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
+				sizeof(struct ufshcd_sg_entry) * prdt_length);
+	}
+}
+
+static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
+{
+	struct utp_task_req_desc *tmrdp;
+	int tag;
+
+	for_each_set_bit(tag, &bitmap, hba->nutmrs) {
+		tmrdp = &hba->utmrdl_base_addr[tag];
+		dev_err(hba->dev, "TM[%d] - Task Management Header", tag);
+		ufshcd_hex_dump("TM TRD: ", &tmrdp->header,
+				sizeof(struct request_desc_header));
+		dev_err(hba->dev, "TM[%d] - Task Management Request UPIU",
+				tag);
+		ufshcd_hex_dump("TM REQ: ", tmrdp->task_req_upiu,
+				sizeof(struct utp_upiu_req));
+		dev_err(hba->dev, "TM[%d] - Task Management Response UPIU",
+				tag);
+		ufshcd_hex_dump("TM RSP: ", tmrdp->task_rsp_upiu,
+				sizeof(struct utp_task_req_desc));
+	}
+}
+
 /*
  * ufshcd_wait_for_register - wait for register value to change
  * @hba - per-adapter interface
@@ -573,6 +723,40 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
 }
 
+static const char *ufschd_uic_link_state_to_string(
+			enum uic_link_state state)
+{
+	switch (state) {
+	case UIC_LINK_OFF_STATE:	return "OFF";
+	case UIC_LINK_ACTIVE_STATE:	return "ACTIVE";
+	case UIC_LINK_HIBERN8_STATE:	return "HIBERN8";
+	default:			return "UNKNOWN";
+	}
+}
+
+static const char *ufschd_ufs_dev_pwr_mode_to_string(
+			enum ufs_dev_pwr_mode state)
+{
+	switch (state) {
+	case UFS_ACTIVE_PWR_MODE:	return "ACTIVE";
+	case UFS_SLEEP_PWR_MODE:	return "SLEEP";
+	case UFS_POWERDOWN_PWR_MODE:	return "POWERDOWN";
+	default:			return "UNKNOWN";
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
@@ -634,6 +818,9 @@ start:
 	case REQ_CLKS_OFF:
 		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
 			break;
 		}
 		/*
@@ -644,6 +831,9 @@ start:
 	case CLKS_OFF:
 		scsi_block_requests(hba->host);
 		hba->clk_gating.state = REQ_CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+			ufschd_clk_gating_state_to_string(
+				hba->clk_gating.state));
 		schedule_work(&hba->clk_gating.ungate_work);
 		/*
 		 * fall through to check if we should wait for this
@@ -680,6 +870,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->clk_gating.is_suspended) {
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
 		goto rel_lock;
 	}
 
@@ -695,6 +888,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		if (ufshcd_uic_hibern8_enter(hba)) {
 			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+					ufschd_clk_gating_state_to_string(
+						hba->clk_gating.state));
 			goto out;
 		}
 		ufshcd_set_link_hibern8(hba);
@@ -721,9 +917,12 @@ static void ufshcd_gate_work(struct work_struct *work)
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
@@ -745,6 +944,9 @@ static void __ufshcd_release(struct ufs_hba *hba)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev),
+			ufschd_clk_gating_state_to_string(
+				hba->clk_gating.state));
 	schedule_delayed_work(&hba->clk_gating.gate_work,
 			msecs_to_jiffies(hba->clk_gating.delay_ms));
 }
@@ -842,9 +1044,11 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
+	hba->lrb[task_tag].issue_time_stamp = ktime_get();
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	ufshcd_cond_add_cmd_trace(hba, task_tag, "send");
 	ufshcd_update_tag_stats(hba, task_tag);
 }
 
@@ -1466,6 +1670,7 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	int resp;
 	int err = 0;
 
+	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
 
 	switch (resp) {
@@ -1518,6 +1723,8 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 
 	if (!time_left) {
 		err = -ETIMEDOUT;
+		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
+			__func__, lrbp->task_tag);
 		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
 			/* sucessfully cleared the command, retry if needed */
 			err = -EAGAIN;
@@ -1750,8 +1957,8 @@ static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
 
 	if (err) {
-		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, err = %d\n",
-				__func__, opcode, idn, err);
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
+				__func__, opcode, idn, index, err);
 		goto out_unlock;
 	}
 
@@ -1827,8 +2034,8 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
 
 	if (err) {
-		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, err = %d\n",
-				__func__, opcode, idn, err);
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
+				__func__, opcode, idn, index, err);
 		goto out_unlock;
 	}
 
@@ -1892,8 +2099,9 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 	    (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
 	     ufs_query_desc_max_size[desc_id])
 	    || (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id)) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d param_offset %d buff_len %d ret %d",
-			__func__, desc_id, param_offset, buff_len, ret);
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, param_offset %d, buff_len %d ,index %d, ret %d",
+			__func__, desc_id, param_offset, buff_len,
+			desc_index, ret);
 		if (!ret)
 			ret = -EINVAL;
 
@@ -2391,15 +2599,20 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret;
 	struct uic_command uic_cmd = {0};
+	ktime_t start = ktime_get();
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
-
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
+			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
 		ufshcd_update_error_stats(hba, UFS_ERR_HIBERN8_ENTER);
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d",
 			__func__, ret);
+	} else {
+		dev_dbg(hba->dev, "%s: Hibern8 Enter at %lld us", __func__,
+			ktime_to_us(ktime_get()));
 	}
 
 	return ret;
@@ -2409,20 +2622,55 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
+	ktime_t start = ktime_get();
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "exit",
+			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
+
 	if (ret) {
 		ufshcd_set_link_off(hba);
 		ufshcd_update_error_stats(hba, UFS_ERR_HIBERN8_EXIT);
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d",
 			__func__, ret);
 		ret = ufshcd_host_reset_and_restore(hba);
+	} else {
+		dev_dbg(hba->dev, "%s: Hibern8 Exit at %lld us", __func__,
+			ktime_to_us(ktime_get()));
+		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_get();
+		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
 	return ret;
 }
 
+/**
+ * ufshcd_print_pwr_info - print power params as saved in hba
+ * power info
+ * @hba: per-adapter instance
+ */
+static void ufshcd_print_pwr_info(struct ufs_hba *hba)
+{
+	static const char * const names[] = {
+		"INVALID MODE",
+		"FAST MODE",
+		"SLOW_MODE",
+		"INVALID MODE",
+		"FASTAUTO_MODE",
+		"SLOWAUTO_MODE",
+		"INVALID MODE",
+	};
+
+	dev_info(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+		 __func__,
+		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
+		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
+		 names[hba->pwr_info.pwr_rx],
+		 names[hba->pwr_info.pwr_tx],
+		 hba->pwr_info.hs_rate);
+}
+
  /**
  * ufshcd_init_pwr_info - setting the POR (power on reset)
  * values in hba power info
@@ -2566,6 +2814,8 @@ int ufshcd_change_power_mode(struct ufs_hba *hba,
 			sizeof(struct ufs_pa_layer_attr));
 	}
 
+	ufshcd_print_pwr_info(hba);
+
 	return ret;
 }
 
@@ -2809,6 +3059,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		/* failed to get the link up... retire */
 		goto out;
 
+	/* Mark that link is up in PWM-G1, 1-lane, SLOW-AUTO mode */
+	ufshcd_init_pwr_info(hba);
+	ufshcd_print_pwr_info(hba);
+
 	/* Include any host controller configuration via UIC commands */
 	if (hba->vops && hba->vops->link_startup_notify) {
 		ret = hba->vops->link_startup_notify(hba, POST_CHANGE);
@@ -3116,6 +3370,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	int result = 0;
 	int scsi_status;
 	int ocs;
+	bool print_prdt;
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
@@ -3123,7 +3378,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
-
+		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 		switch (result) {
 		case UPIU_TRANSACTION_RESPONSE:
 			/*
@@ -3171,10 +3426,17 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	default:
 		result |= DID_ERROR << 16;
 		dev_err(hba->dev,
-		"OCS error from controller = %x\n", ocs);
+				"OCS error from controller = %x for tag %d\n",
+				ocs, lrbp->task_tag);
+		ufshcd_print_host_regs(hba);
 		break;
 	} /* end of switch */
 
+	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs) {
+		print_prdt = (ocs == OCS_INVALID_PRDT_ATTR ||
+			ocs == OCS_MISMATCH_DATA_BUF_SIZE);
+		ufshcd_print_trs(hba, 1 << lrbp->task_tag, print_prdt);
+	}
 	return result;
 }
 
@@ -3226,6 +3488,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
 		if (cmd) {
+			ufshcd_cond_add_cmd_trace(hba, index, "complete");
 			ufshcd_update_tag_stats_completion(hba, cmd);
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
@@ -3237,8 +3500,11 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
-			if (hba->dev_cmd.complete)
+			if (hba->dev_cmd.complete) {
+				ufshcd_cond_add_cmd_trace(hba, index,
+						"dev_complete");
 				complete(hba->dev_cmd.complete);
+			}
 		}
 	}
 
@@ -3334,6 +3600,7 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = true;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Enabled");
 
 	/* No need of URGENT_BKOPS exception from the device */
 	err = ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
@@ -3384,6 +3651,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 	}
 
 	hba->auto_bkops_enabled = false;
+	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
 out:
 	return err;
 }
@@ -3536,6 +3804,22 @@ static void ufshcd_err_handler(struct work_struct *work)
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_transfer_req_compl(hba);
 	ufshcd_tmc_handler(hba);
+
+	/*
+	 * Dump controller state before resetting. Transfer requests state
+	 * will be dump as part of the request completion.
+	 */
+	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
+		dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x",
+			__func__, hba->saved_err, hba->saved_uic_err);
+		if (!hba->silence_err_logs) {
+			ufshcd_print_host_regs(hba);
+			ufshcd_print_pwr_info(hba);
+			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+		}
+	}
+
+
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* Clear pending transfer requests */
@@ -3584,7 +3868,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		scsi_report_bus_reset(hba->host, 0);
 		hba->saved_err = 0;
 		hba->saved_uic_err = 0;
+	} else {
+		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		if (hba->saved_err || hba->saved_uic_err)
+			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
+			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
+
+	hba->silence_err_logs = false;
 	ufshcd_clear_eh_in_progress(hba);
 
 out:
@@ -3593,6 +3884,14 @@ out:
 	pm_runtime_put_sync(hba->dev);
 }
 
+static void ufshcd_update_uic_reg_hist(struct ufs_uic_err_reg_hist *reg_hist,
+		u32 reg)
+{
+	reg_hist->reg[reg_hist->pos] = reg;
+	reg_hist->tstamp[reg_hist->pos] = ktime_get();
+	reg_hist->pos = (reg_hist->pos + 1) % UIC_ERR_REG_HIST_LENGTH;
+}
+
 /**
  * ufshcd_update_uic_error - check and set fatal UIC error flags.
  * @hba: per-adapter instance
@@ -3601,23 +3900,46 @@ static void ufshcd_update_uic_error(struct ufs_hba *hba)
 {
 	u32 reg;
 
+	/* PHY layer lane error */
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+	/* Ignore LINERESET indication, as this is not an error */
+	if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
+			(reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
+		/*
+		 * To know whether this error is fatal or not, DB timeout
+		 * must be checked but this error is handled separately.
+		 */
+		dev_dbg(hba->dev, "%s: UIC Lane error reported, reg 0x%x\n",
+				__func__, reg);
+		ufshcd_update_uic_reg_hist(&hba->ufs_stats.pa_err, reg);
+	}
+
 	/* PA_INIT_ERROR is fatal and needs UIC reset */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
+	if (reg)
+		ufshcd_update_uic_reg_hist(&hba->ufs_stats.dl_err, reg);
+
 	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
 		hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
 
 	/* UIC NL/TL/DME errors needs software retry */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
-	if (reg)
+	if (reg) {
+		ufshcd_update_uic_reg_hist(&hba->ufs_stats.nl_err, reg);
 		hba->uic_error |= UFSHCD_UIC_NL_ERROR;
+	}
 
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_TRANSPORT_LAYER);
-	if (reg)
+	if (reg) {
+		ufshcd_update_uic_reg_hist(&hba->ufs_stats.tl_err, reg);
 		hba->uic_error |= UFSHCD_UIC_TL_ERROR;
+	}
 
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
-	if (reg)
+	if (reg) {
+		ufshcd_update_uic_reg_hist(&hba->ufs_stats.dme_err, reg);
 		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+	}
 
 	dev_dbg(hba->dev, "%s: UIC error flags = 0x%08x\n",
 			__func__, hba->uic_error);
@@ -3642,16 +3964,20 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 	}
 
 	if (queue_eh_work) {
+		/*
+		 * update the transfer error masks to sticky bits, let's do this
+		 * irrespective of current ufshcd_state.
+		 */
+		hba->saved_err |= hba->errors;
+		hba->saved_uic_err |= hba->uic_error;
+
 		/* handle fatal errors only when link is functional */
 		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
 			/* block commands from scsi mid-layer */
 			scsi_block_requests(hba->host);
 
-			/* transfer error masks to sticky bits */
-			hba->saved_err |= hba->errors;
-			hba->saved_uic_err |= hba->uic_error;
-
 			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+
 			schedule_work(&hba->eh_work);
 		}
 	}
@@ -3922,18 +4248,42 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		__func__, tag);
 	}
 
+	/* Print Transfer Request of aborted task */
+	dev_err(hba->dev, "%s: Device abort task at tag %d", __func__, tag);
+
+	/*
+	 * Print detailed info about aborted request.
+	 * As more than one request might get aborted at the same time,
+	 * print full information only for the first aborted request in order
+	 * to reduce repeated printouts. For other aborted requests only print
+	 * basic details.
+	 */
+	scsi_print_command(cmd);
+	if (!hba->req_abort_count) {
+		ufshcd_print_host_regs(hba);
+		ufshcd_print_pwr_info(hba);
+		ufshcd_print_trs(hba, 1 << tag, true);
+	} else {
+		ufshcd_print_trs(hba, 1 << tag, false);
+	}
+	hba->req_abort_count++;
+
 	lrbp = &hba->lrb[tag];
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 				UFS_QUERY_TASK, &resp);
 		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
 			/* cmd pending in the device */
+			dev_err(hba->dev, "%s: cmd pending in the device. tag = %d",
+				__func__, tag);
 			break;
 		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 			/*
 			 * cmd not pending in the device, check if it is
 			 * in transition.
 			 */
+			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.",
+				__func__, tag);
 			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 			if (reg & (1 << tag)) {
 				/* sleep for max. 200us to stabilize */
@@ -3941,8 +4291,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 				continue;
 			}
 			/* command completed already */
+			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.",
+				__func__, tag);
 			goto out;
 		} else {
+			dev_err(hba->dev,
+				"%s: no response from device. tag = %d, err %d",
+				__func__, tag, err);
 			if (!err)
 				err = resp; /* service response error */
 			goto out;
@@ -3957,14 +4312,20 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 			UFS_ABORT_TASK, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		if (!err)
+		if (!err) {
 			err = resp; /* service response error */
+			dev_err(hba->dev, "%s: issued. tag = %d, err %d",
+				__func__, tag, err);
+		}
 		goto out;
 	}
 
 	err = ufshcd_clear_cmd(hba, tag);
-	if (err)
+	if (err) {
+		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d",
+			__func__, tag, err);
 		goto out;
+	}
 
 	scsi_dma_unmap(cmd);
 
@@ -4297,6 +4658,22 @@ out:
 	return ret;
 }
 
+static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
+{
+	int err_reg_hist_size = sizeof(struct ufs_uic_err_reg_hist);
+
+	hba->ufs_stats.hibern8_exit_cnt = 0;
+	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
+
+	memset(&hba->ufs_stats.pa_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.dl_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.nl_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.tl_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.dme_err, 0, err_reg_hist_size);
+
+	hba->req_abort_count = 0;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -4306,12 +4683,17 @@ out:
 static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
 	int ret;
+	ktime_t start = ktime_get();
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
 		goto out;
 
+	/* Debug counters initialization */
+	ufshcd_clear_dbg_ufs_stats(hba);
+
 	ufshcd_init_pwr_info(hba);
+	ufshcd_print_pwr_info(hba);
 
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
@@ -4382,6 +4764,10 @@ out:
 		ufshcd_hba_exit(hba);
 	}
 
+	trace_ufshcd_init(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
+		ufschd_uic_link_state_to_string(hba->uic_link_state));
 	return ret;
 }
 
@@ -4842,6 +5228,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
 	unsigned long flags;
+	ktime_t start = ktime_get();
+	bool clk_state_changed = false;
 
 	if (!head || list_empty(head))
 		goto out;
@@ -4851,6 +5239,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
 				continue;
 
+			clk_state_changed = on ^ clki->enabled;
 			if (on && !clki->enabled) {
 				ret = clk_prepare_enable(clki->clk);
 				if (ret) {
@@ -4878,8 +5267,17 @@ out:
 	} else if (on) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.state = CLKS_ON;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+				ufschd_clk_gating_state_to_string(
+					hba->clk_gating.state));
+
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
+
+	if (clk_state_changed)
+		trace_ufshcd_profile_clk_gating(dev_name(hba->dev),
+			(on ? "on" : "off"),
+			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
 
@@ -5366,6 +5764,8 @@ disable_clks:
 		__ufshcd_setup_clocks(hba, false, true);
 
 	hba->clk_gating.state = CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev),
+		ufschd_clk_gating_state_to_string(hba->clk_gating.state));
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller trasanction expected till resume.
@@ -5512,6 +5912,7 @@ out:
 int ufshcd_system_suspend(struct ufs_hba *hba)
 {
 	int ret = 0;
+	ktime_t start = ktime_get();
 
 	if (!hba || !hba->is_powered)
 		return 0;
@@ -5541,6 +5942,10 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 	ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
 out:
+	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
+		ufschd_uic_link_state_to_string(hba->uic_link_state));
 	if (!ret)
 		hba->is_sys_suspended = true;
 	return ret;
@@ -5556,14 +5961,17 @@ EXPORT_SYMBOL(ufshcd_system_suspend);
 
 int ufshcd_system_resume(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
-		/*
-		 * Let the runtime resume take care of resuming
-		 * if runtime suspended.
-		 */
-		return 0;
+	int ret = 0;
+	ktime_t start = ktime_get();
 
-	return ufshcd_resume(hba, UFS_SYSTEM_PM);
+	if (hba && hba->is_powered && !pm_runtime_suspended(hba->dev))
+		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
+
+	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
+		ufschd_uic_link_state_to_string(hba->uic_link_state));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
 
@@ -5577,10 +5985,17 @@ EXPORT_SYMBOL(ufshcd_system_resume);
  */
 int ufshcd_runtime_suspend(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered)
-		return 0;
+	int ret = 0;
+	ktime_t start = ktime_get();
+
+	if (hba && hba->is_powered)
+		ret = ufshcd_suspend(hba, UFS_RUNTIME_PM);
 
-	return ufshcd_suspend(hba, UFS_RUNTIME_PM);
+	trace_ufshcd_runtime_suspend(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
+		ufschd_uic_link_state_to_string(hba->uic_link_state));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_suspend);
 
@@ -5607,10 +6022,17 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
  */
 int ufshcd_runtime_resume(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered)
-		return 0;
-	else
-		return ufshcd_resume(hba, UFS_RUNTIME_PM);
+	int ret = 0;
+	ktime_t start = ktime_get();
+
+	if (hba && hba->is_powered)
+		ret = ufshcd_resume(hba, UFS_RUNTIME_PM);
+
+	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
+		ktime_to_us(ktime_sub(ktime_get(), start)),
+		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
+		ufschd_uic_link_state_to_string(hba->uic_link_state));
+	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
@@ -5729,6 +6151,8 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
+	ktime_t start = ktime_get();
+	bool clk_state_changed = false;
 
 	if (!head || list_empty(head))
 		goto out;
@@ -5738,6 +6162,8 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 			if (scale_up && clki->max_freq) {
 				if (clki->curr_freq == clki->max_freq)
 					continue;
+
+				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->max_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -5745,11 +6171,17 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 						clki->max_freq, ret);
 					break;
 				}
+				trace_ufshcd_clk_scaling(dev_name(hba->dev),
+						"scaled up", clki->name,
+						clki->curr_freq,
+						clki->max_freq);
 				clki->curr_freq = clki->max_freq;
 
 			} else if (!scale_up && clki->min_freq) {
 				if (clki->curr_freq == clki->min_freq)
 					continue;
+
+				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->min_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -5757,6 +6189,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
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
@@ -5766,6 +6202,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 	if (hba->vops->clk_scale_notify)
 		hba->vops->clk_scale_notify(hba);
 out:
+	if (clk_state_changed)
+		trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
+			(scale_up ? "up" : "down"),
+			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
 
@@ -5936,6 +6376,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = ufshcd_hba_enable(hba);
 	if (err) {
 		dev_err(hba->dev, "Host controller enable failed\n");
+		ufshcd_print_host_regs(hba);
 		goto out_remove_scsi_host;
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d9b1251..d9eb2ca 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -178,6 +178,7 @@ struct ufs_pm_lvl_states {
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
+ * @issue_time_stamp: time stamp for debug purposes
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -194,6 +195,7 @@ struct ufshcd_lrb {
 	int task_tag;
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
+	ktime_t issue_time_stamp;
 };
 
 /**
@@ -223,14 +225,52 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
-#ifdef CONFIG_DEBUG_FS
+#define UIC_ERR_REG_HIST_LENGTH 8
+/**
+ * struct ufs_uic_err_reg_hist - keeps history of uic errors
+ * @pos: index to indicate cyclic buffer position
+ * @reg: cyclic buffer for registers value
+ * @tstamp: cyclic buffer for time stamp
+ */
+struct ufs_uic_err_reg_hist {
+	int pos;
+	u32 reg[UIC_ERR_REG_HIST_LENGTH];
+	ktime_t tstamp[UIC_ERR_REG_HIST_LENGTH];
+};
+
+/**
+ * struct ufs_stats - keeps usage/err statistics
+ * @enabled: enable tagstats for debugfs
+ * @tag_stats: pointer to tag statistic counters
+ * @q_depth: current amount of busy slots
+ * @err_stats: counters to keep track of various errors
+ * @hibern8_exit_cnt: Counter to keep track of number of exits,
+ *		reset this after link-startup.
+ * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
+ *		Clear after the first successful command completion.
+ * @pa_err: tracks pa-uic errors
+ * @dl_err: tracks dl-uic errors
+ * @nl_err: tracks nl-uic errors
+ * @tl_err: tracks tl-uic errors
+ * @dme_err: tracks dme errors
+ */
 struct ufs_stats {
+#ifdef CONFIG_DEBUG_FS
 	bool enabled;
 	u64 **tag_stats;
 	int q_depth;
 	int err_stats[UFS_ERR_MAX];
+#endif
+	u32 hibern8_exit_cnt;
+	ktime_t last_hibern8_exit_tstamp;
+	struct ufs_uic_err_reg_hist pa_err;
+	struct ufs_uic_err_reg_hist dl_err;
+	struct ufs_uic_err_reg_hist nl_err;
+	struct ufs_uic_err_reg_hist tl_err;
+	struct ufs_uic_err_reg_hist dme_err;
 };
 
+#ifdef CONFIG_DEBUG_FS
 struct debugfs_files {
 	struct dentry *debugfs_root;
 	struct dentry *tag_stats;
@@ -326,6 +366,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
+	void	(*dbg_register_dump)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
@@ -498,6 +539,7 @@ struct ufs_hba {
 	u32 uic_error;
 	u32 saved_err;
 	u32 saved_uic_err;
+	bool silence_err_logs;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
@@ -528,10 +570,13 @@ struct ufs_hba {
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
 	bool is_sys_suspended;
-#ifdef CONFIG_DEBUG_FS
 	struct ufs_stats ufs_stats;
+#ifdef CONFIG_DEBUG_FS
 	struct debugfs_files debugfs_files;
 #endif
+
+	/* Number of requests aborts */
+	int req_abort_count;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c8b178f..c5a0d19 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -166,6 +166,7 @@ enum {
 /* UECPA - Host UIC Error Code PHY Adapter Layer 38h */
 #define UIC_PHY_ADAPTER_LAYER_ERROR			UFS_BIT(31)
 #define UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK		0x1F
+#define UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK		0xF
 
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
new file mode 100644
index 0000000..756ceed
--- /dev/null
+++ b/include/trace/events/ufs.h
@@ -0,0 +1,213 @@
+/*
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
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
+DECLARE_EVENT_CLASS(ufshcd_state_change_template,
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
+	TP_printk("%s: state changed to %s",
+		__get_str(dev_name), __get_str(state))
+);
+
+DEFINE_EVENT(ufshcd_state_change_template, ufshcd_clk_gating,
+	TP_PROTO(const char *dev_name, const char *state),
+	TP_ARGS(dev_name, state));
+DEFINE_EVENT(ufshcd_state_change_template, ufshcd_auto_bkops_state,
+	TP_PROTO(const char *dev_name, const char *state),
+	TP_ARGS(dev_name, state));
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
+
+TRACE_EVENT(ufshcd_command,
+	TP_PROTO(const char *dev_name, const char *str, unsigned int tag,
+			u32 doorbell, int transfer_len, u32 intr, u64 lba,
+			u8 opcode),
+
+	TP_ARGS(dev_name, str, tag, doorbell, transfer_len, intr, lba, opcode),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(str, str)
+		__field(unsigned int, tag)
+		__field(u32, doorbell)
+		__field(int, transfer_len)
+		__field(u32, intr)
+		__field(u64, lba)
+		__field(u8, opcode)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(str, str);
+		__entry->tag = tag;
+		__entry->doorbell = doorbell;
+		__entry->transfer_len = transfer_len;
+		__entry->intr = intr;
+		__entry->lba = lba;
+		__entry->opcode = opcode;
+	),
+
+	TP_printk(
+		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x",
+		__get_str(str), __get_str(dev_name), __entry->tag,
+		__entry->doorbell, __entry->transfer_len,
+		__entry->intr, __entry->lba, (u32)__entry->opcode
+	)
+);
+
+#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
