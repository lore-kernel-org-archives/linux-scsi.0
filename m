From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 12/16] scsi: ufs: Add support for clock gating
Date: Wed, 10 Sep 2014 14:54:19 +0300
Message-ID: <1410350063-23267-13-git-send-email-draviv@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44004 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaIJLzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 07:55:06 -0400
In-Reply-To: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sahitya Tummala <stummala@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sahitya Tummala <stummala@codeaurora.org>

The UFS controller clocks can be gated after certain period of
inactivity, which is typically less than runtime suspend timeout.
In addition to clocks the link will also be put into Hibern8 mode
to save more power.

The clock gating can be turned on by enabling the capability
UFSHCD_CAP_CLK_GATING. To enable entering into Hibern8 mode as part of
clock gating, set the capability UFSHCD_CAP_HIBERN8_WITH_CLK_GATING.

The tracing events for clock gating can be enabled through debugfs as:
echo 1 > /sys/kernel/debug/tracing/events/ufs/ufshcd_clk_gating/enable
cat /sys/kernel/debug/tracing/trace_pipe

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bfa9a75..c762a6a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -177,6 +177,11 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
+static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
+				 bool skip_ref_clk);
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
+static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
+static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode);
@@ -498,6 +503,231 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
 }
 
+static void ufshcd_ungate_work(struct work_struct *work)
+{
+	int ret;
+	unsigned long flags;
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+			clk_gating.ungate_work);
+
+	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->clk_gating.state == CLKS_ON) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto unblock_reqs;
+	}
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_setup_clocks(hba, true);
+
+	/* Exit from hibern8 */
+	if (ufshcd_can_hibern8_during_gating(hba)) {
+		/* Prevent gating in this path */
+		hba->clk_gating.is_suspended = true;
+		if (ufshcd_is_link_hibern8(hba)) {
+			ret = ufshcd_uic_hibern8_exit(hba);
+			if (ret)
+				dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+					__func__, ret);
+			else
+				ufshcd_set_link_active(hba);
+		}
+		hba->clk_gating.is_suspended = false;
+	}
+unblock_reqs:
+	scsi_unblock_requests(hba->host);
+}
+
+/**
+ * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_release.
+ * Also, exit from hibern8 mode and set the link as active.
+ * @hba: per adapter instance
+ * @async: This indicates whether caller should ungate clocks asynchronously.
+ */
+int ufshcd_hold(struct ufs_hba *hba, bool async)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!ufshcd_is_clkgating_allowed(hba))
+		goto out;
+start:
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->clk_gating.active_reqs++;
+
+	switch (hba->clk_gating.state) {
+	case CLKS_ON:
+		break;
+	case REQ_CLKS_OFF:
+		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
+			hba->clk_gating.state = CLKS_ON;
+			break;
+		}
+		/*
+		 * If we here, it means gating work is either done or
+		 * currently running. Hence, fall through to cancel gating
+		 * work and to enable clocks.
+		 */
+	case CLKS_OFF:
+		scsi_block_requests(hba->host);
+		hba->clk_gating.state = REQ_CLKS_ON;
+		schedule_work(&hba->clk_gating.ungate_work);
+		/*
+		 * fall through to check if we should wait for this
+		 * work to be done or not.
+		 */
+	case REQ_CLKS_ON:
+		if (async) {
+			rc = -EAGAIN;
+			hba->clk_gating.active_reqs--;
+			break;
+		} else {
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			flush_work(&hba->clk_gating.ungate_work);
+			/* Make sure state is CLKS_ON before returning */
+			goto start;
+		}
+	default:
+		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
+				__func__, hba->clk_gating.state);
+		break;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return rc;
+}
+
+static void ufshcd_gate_work(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+			clk_gating.gate_work.work);
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->clk_gating.is_suspended) {
+		hba->clk_gating.state = CLKS_ON;
+		goto rel_lock;
+	}
+
+	if (hba->clk_gating.active_reqs
+		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
+		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| hba->active_uic_cmd || hba->uic_async_done)
+		goto rel_lock;
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* put the link into hibern8 mode before turning off clocks */
+	if (ufshcd_can_hibern8_during_gating(hba)) {
+		if (ufshcd_uic_hibern8_enter(hba)) {
+			hba->clk_gating.state = CLKS_ON;
+			goto out;
+		}
+		ufshcd_set_link_hibern8(hba);
+	}
+
+	if (!ufshcd_is_link_active(hba))
+		ufshcd_setup_clocks(hba, false);
+	else
+		/* If link is active, device ref_clk can't be switched off */
+		__ufshcd_setup_clocks(hba, false, true);
+
+	/*
+	 * In case you are here to cancel this work the gating state
+	 * would be marked as REQ_CLKS_ON. In this case keep the state
+	 * as REQ_CLKS_ON which would anyway imply that clocks are off
+	 * and a request to turn them on is pending. By doing this way,
+	 * we keep the state machine in tact and this would ultimately
+	 * prevent from doing cancel work multiple times when there are
+	 * new requests arriving before the current cancel work is done.
+	 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->clk_gating.state == REQ_CLKS_OFF) {
+		hba->clk_gating.state = CLKS_OFF;
+	}
+rel_lock:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return;
+}
+
+/* host lock must be held before calling this variant */
+static void __ufshcd_release(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkgating_allowed(hba))
+		return;
+
+	hba->clk_gating.active_reqs--;
+
+	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
+		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
+		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| hba->active_uic_cmd || hba->uic_async_done)
+		return;
+
+	hba->clk_gating.state = REQ_CLKS_OFF;
+	schedule_delayed_work(&hba->clk_gating.gate_work,
+			msecs_to_jiffies(hba->clk_gating.delay_ms));
+}
+
+void ufshcd_release(struct ufs_hba *hba)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	__ufshcd_release(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
+
+static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", hba->clk_gating.delay_ms);
+}
+
+static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long flags, value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->clk_gating.delay_ms = value;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return count;
+}
+
+static void ufshcd_init_clk_gating(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkgating_allowed(hba))
+		return;
+
+	hba->clk_gating.delay_ms = 150;
+	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
+	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
+
+	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
+	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
+	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
+	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
+	hba->clk_gating.delay_attr.attr.mode = S_IRUGO | S_IWUSR;
+	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
+		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
+}
+
+static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkgating_allowed(hba))
+		return;
+	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
+}
+
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
@@ -699,10 +929,12 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	int ret;
 
+	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
+	ufshcd_release(hba);
 	return ret;
 }
 
@@ -1018,6 +1250,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+	err = ufshcd_hold(hba, true);
+	if (err) {
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		clear_bit_unlock(tag, &hba->lrb_in_use);
+		goto out;
+	}
+	WARN_ON(hba->clk_gating.state != CLKS_ON);
+
 	lrbp = &hba->lrb[tag];
 
 	WARN_ON(lrbp->cmd);
@@ -1293,6 +1533,7 @@ static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
+	ufshcd_hold(hba, false);
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
@@ -1336,6 +1577,7 @@ static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -1359,6 +1601,7 @@ static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
+	ufshcd_hold(hba, false);
 	if (!attr_val) {
 		dev_err(hba->dev, "%s: attribute value required for opcode 0x%x\n",
 				__func__, opcode);
@@ -1398,6 +1641,7 @@ static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -1425,6 +1669,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 
 	BUG_ON(!hba);
 
+	ufshcd_hold(hba, false);
 	if (!desc_buf) {
 		dev_err(hba->dev, "%s: descriptor buffer required for opcode 0x%x\n",
 				__func__, opcode);
@@ -1474,6 +1719,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -1888,6 +2134,7 @@ out:
 	hba->uic_async_done = NULL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
+
 	return ret;
 }
 
@@ -1902,12 +2149,16 @@ out:
 static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
 	struct uic_command uic_cmd = {0};
+	int ret;
 
 	uic_cmd.command = UIC_CMD_DME_SET;
 	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
 	uic_cmd.argument3 = mode;
-
-	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ufshcd_hold(hba, false);
+	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ufshcd_release(hba);
+out:
+	return ret;
 }
 
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
@@ -2306,6 +2557,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	int err = 0;
 	int retries;
 
+	ufshcd_hold(hba, false);
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
@@ -2317,6 +2569,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
 	}
 	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
@@ -2729,6 +2982,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 			clear_bit_unlock(index, &hba->lrb_in_use);
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
+			__ufshcd_release(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
 			if (hba->dev_cmd.complete)
 				complete(hba->dev_cmd.complete);
@@ -3013,6 +3267,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	hba = container_of(work, struct ufs_hba, eh_work);
 
 	pm_runtime_get_sync(hba->dev);
+	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
@@ -3066,6 +3321,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 out:
 	scsi_unblock_requests(hba->host);
+	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 }
 
@@ -3249,6 +3505,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
 	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
+	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_req_descp = hba->utmrdl_base_addr;
@@ -3300,6 +3557,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	ufshcd_put_tm_slot(hba, free_slot);
 	wake_up(&hba->tm_tag_wq);
 
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -3382,6 +3640,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 
+	ufshcd_hold(hba, false);
 	/* If command is already aborted/completed, return SUCCESS */
 	if (!(test_bit(tag, &hba->outstanding_reqs)))
 		goto out;
@@ -3446,6 +3705,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	clear_bit_unlock(tag, &hba->lrb_in_use);
 	wake_up(&hba->dev_cmd.tag_wq);
+
 out:
 	if (!err) {
 		err = SUCCESS;
@@ -3454,6 +3714,11 @@ out:
 		err = FAILED;
 	}
 
+	/*
+	 * This ufshcd_release() corresponds to the original scsi cmd that got
+	 * aborted here (as we won't get any IRQ for it).
+	 */
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -3538,6 +3803,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	hba = shost_priv(cmd->device->host);
 
+	ufshcd_hold(hba, false);
 	/*
 	 * Check if there is any race with fatal error handling.
 	 * If so, wait for it to complete. Even though fatal error
@@ -3571,6 +3837,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_release(hba);
 	return err;
 }
 
@@ -3798,6 +4065,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
+	.max_host_blocked	= 1,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
@@ -3980,6 +4248,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
+	unsigned long flags;
 
 	if (!head || list_empty(head))
 		goto out;
@@ -4004,12 +4273,19 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 					clki->name, on ? "en" : "dis");
 		}
 	}
+
+	if (hba->vops && hba->vops->setup_clocks)
+		ret = hba->vops->setup_clocks(hba, on);
 out:
 	if (ret) {
 		list_for_each_entry(clki, head, list) {
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
+	} else if (!ret && on) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->clk_gating.state = CLKS_ON;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
 	return ret;
 }
@@ -4070,23 +4346,14 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 			goto out;
 	}
 
-	if (hba->vops->setup_clocks) {
-		err = hba->vops->setup_clocks(hba, true);
-		if (err)
-			goto out_exit;
-	}
-
 	if (hba->vops->setup_regulators) {
 		err = hba->vops->setup_regulators(hba, true);
 		if (err)
-			goto out_clks;
+			goto out_exit;
 	}
 
 	goto out;
 
-out_clks:
-	if (hba->vops->setup_clocks)
-		hba->vops->setup_clocks(hba, false);
 out_exit:
 	if (hba->vops->exit)
 		hba->vops->exit(hba);
@@ -4390,6 +4657,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
 	 */
+	ufshcd_hold(hba, false);
+	hba->clk_gating.is_suspended = true;
+
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		goto disable_clks;
@@ -4412,7 +4682,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		ret = ufshcd_bkops_ctrl(hba, BKOPS_STATUS_NON_CRITICAL);
 		if (ret)
-			goto out;
+			goto enable_gating;
 	}
 
 	if ((req_dev_pwr_mode != hba->curr_dev_pwr_mode) &&
@@ -4422,7 +4692,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_disable_auto_bkops(hba);
 		ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
 		if (ret)
-			goto out;
+			goto enable_gating;
 	}
 
 	ret = ufshcd_link_state_transition(hba, req_link_state, 1);
@@ -4455,6 +4725,7 @@ disable_clks:
 		/* If link is active, device ref_clk can't be switched off */
 		__ufshcd_setup_clocks(hba, false, true);
 
+	hba->clk_gating.state = CLKS_OFF;
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller trasanction expected till resume.
@@ -4476,6 +4747,9 @@ set_link_active:
 set_dev_active:
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
+enable_gating:
+	hba->clk_gating.is_suspended = false;
+	ufshcd_release(hba);
 out:
 	hba->pm_op_in_progress = 0;
 	return ret;
@@ -4505,12 +4779,6 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto out;
 
-	if (hba->vops && hba->vops->setup_clocks) {
-		ret = hba->vops->setup_clocks(hba, true);
-		if (ret)
-			goto disable_clks;
-	}
-
 	/* enable the host irq as host controller would be active soon */
 	ufshcd_enable_irq(hba);
 
@@ -4552,6 +4820,10 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	ufshcd_disable_auto_bkops(hba);
+	hba->clk_gating.is_suspended = false;
+
+	/* Schedule clock gating in case of no access to UFS device yet */
+	ufshcd_release(hba);
 	goto out;
 
 set_old_link_state:
@@ -4563,9 +4835,6 @@ disable_vreg:
 	ufshcd_vreg_set_lpm(hba);
 disable_irq_and_vops_clks:
 	ufshcd_disable_irq(hba);
-	if (hba->vops && hba->vops->setup_clocks)
-		ret = hba->vops->setup_clocks(hba, false);
-disable_clks:
 	ufshcd_setup_clocks(hba, false);
 out:
 	hba->pm_op_in_progress = 0;
@@ -4734,6 +5003,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 
 	scsi_host_put(hba->host);
 
+	ufshcd_exit_clk_gating(hba);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
@@ -4869,11 +5139,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize device management tag acquire wait queue */
 	init_waitqueue_head(&hba->dev_cmd.tag_wq);
 
+	ufshcd_init_clk_gating(hba);
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto out_disable;
+		goto exit_gating;
 	} else {
 		hba->is_irq_enabled = true;
 	}
@@ -4882,13 +5153,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		dev_err(hba->dev, "init shared queue failed\n");
-		goto out_disable;
+		goto exit_gating;
 	}
 
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto out_disable;
+		goto exit_gating;
 	}
 
 	/* Host controller enable */
@@ -4913,6 +5184,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
+exit_gating:
+	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
 	scsi_host_put(host);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index caebdcb..93c7c82 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -269,6 +269,38 @@ struct ufs_hba_variant_ops {
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 };
 
+/* clock gating state  */
+enum clk_gating_state {
+	CLKS_OFF,
+	CLKS_ON,
+	REQ_CLKS_OFF,
+	REQ_CLKS_ON,
+};
+
+/**
+ * struct ufs_clk_gating - UFS clock gating related info
+ * @gate_work: worker to turn off clocks after some delay as specified in
+ * delay_ms
+ * @ungate_work: worker to turn on clocks that will be used in case of
+ * interrupt context
+ * @state: the current clocks state
+ * @delay_ms: gating delay in ms
+ * @is_suspended: clk gating is suspended when set to 1 which can be used
+ * during suspend/resume
+ * @delay_attr: sysfs attribute to control delay_attr
+ * @active_reqs: number of requests that are pending and should be waited for
+ * completion before gating clocks.
+ */
+struct ufs_clk_gating {
+	struct delayed_work gate_work;
+	struct work_struct ungate_work;
+	enum clk_gating_state state;
+	unsigned long delay_ms;
+	bool is_suspended;
+	struct device_attribute delay_attr;
+	int active_reqs;
+};
+
 /**
  * struct ufs_init_prefetch - contains data that is pre-fetched once during
  * initialization
@@ -411,8 +443,25 @@ struct ufs_hba {
 
 	struct ufs_pa_layer_attr pwr_info;
 	struct ufs_pwr_mode_info max_pwr_info;
+
+	struct ufs_clk_gating clk_gating;
+	/* Control to enable/disable host capabilities */
+	u32 caps;
+	/* Allow dynamic clk gating */
+#define UFSHCD_CAP_CLK_GATING	(1 << 0)
+	/* Allow hiberb8 with clk gating */
+#define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
 };
 
+/* Returns true if clocks can be gated. Otherwise false */
+static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_CLK_GATING;
+}
+static inline bool ufshcd_can_hibern8_during_gating(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
+}
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
@@ -494,4 +543,6 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
 
+int ufshcd_hold(struct ufs_hba *hba, bool async);
+void ufshcd_release(struct ufs_hba *hba);
 #endif /* End of Header */
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

