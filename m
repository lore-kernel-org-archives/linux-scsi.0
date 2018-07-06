From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 5/9] scsi: ufs: add support for hibern8 on idle
Date: Fri,  6 Jul 2018 18:00:32 +0530
Message-ID: <f82685d8b9392281adf9121064ecdf2c55026447.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

In order to save power we should put the UFS link into hibern8 as soon as
UFS link is idle and power measurement of active usecases (like audio/video
playback/recording) show that putting UFS link in hibern8 @ 10ms of idle
(if not earlier) would save significant power.

Our current available solution is to do hibern8 with clock gating @idle
timeout of 150ms. As clock gating has huge latencies (7ms each in enter and
exit), we cannot bring down the idle timeout to <=10ms without degrading
UFS throughput. Hence this change has added support to enter into hibern8
with another idle timer.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c  | 372 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h  |  39 +++++
 include/trace/events/ufs.h |  20 +++
 3 files changed, 397 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e950204..8a56ef6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -246,6 +246,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
+static void ufshcd_hold_all(struct ufs_hba *hba);
+static void ufshcd_release_all(struct ufs_hba *hba);
 static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
 {
 	return tag >= 0 && tag < hba->nutrs;
@@ -853,6 +855,18 @@ static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
 		? false : true;
 }
 
+static const char *ufshcd_hibern8_on_idle_state_to_string(
+			enum ufshcd_hibern8_on_idle_state state)
+{
+	switch (state) {
+	case HIBERN8_ENTERED:		return "HIBERN8_ENTERED";
+	case HIBERN8_EXITED:		return "HIBERN8_EXITED";
+	case REQ_HIBERN8_ENTER:		return "REQ_HIBERN8_ENTER";
+	case REQ_HIBERN8_EXIT:		return "REQ_HIBERN8_EXIT";
+	default:			return "UNKNOWN_STATE";
+	}
+}
+
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba)
 {
 	/* HCI version 1.0 and 1.1 supports UniPro 1.41 */
@@ -993,7 +1007,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	bool timeout = false, do_last_check = false;
 	ktime_t start;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
@@ -1038,7 +1052,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	}
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return ret;
 }
 
@@ -1601,8 +1615,16 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	if (ufshcd_is_hibern8_on_idle_allowed(hba))
+		/*
+		 * Hibern8 enter work (on Idle) needs clocks to be ON hence
+		 * make sure that it is flushed before turning off the clocks.
+		 */
+		flush_delayed_work(&hba->hibern8_on_idle.enter_work);
+
 	/* put the link into hibern8 mode before turning off clocks */
-	if (ufshcd_can_hibern8_during_gating(hba)) {
+	if (ufshcd_can_hibern8_during_gating(hba) &&
+	    ufshcd_is_link_active(hba)) {
 		if (ufshcd_uic_hibern8_enter(hba)) {
 			hba->clk_gating.state = CLKS_ON;
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
@@ -1732,6 +1754,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	char wq_name[sizeof("ufs_clk_gating_00")];
 
+	hba->clk_gating.state = CLKS_ON;
+
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
@@ -1774,6 +1798,246 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
+/**
+ * ufshcd_hibern8_hold - Make sure that link is not in hibern8.
+ *
+ * @hba: per adapter instance
+ * @async: This indicates whether caller wants to exit hibern8 asynchronously.
+ *
+ * Exit from hibern8 mode and set the link as active.
+ *
+ * Return 0 on success, non-zero on failure.
+ */
+int ufshcd_hibern8_hold(struct ufs_hba *hba, bool async)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!ufshcd_is_hibern8_on_idle_allowed(hba))
+		goto out;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->hibern8_on_idle.active_reqs++;
+
+start:
+	switch (hba->hibern8_on_idle.state) {
+	case HIBERN8_EXITED:
+		break;
+	case REQ_HIBERN8_ENTER:
+		if (cancel_delayed_work(&hba->hibern8_on_idle.enter_work)) {
+			hba->hibern8_on_idle.state = HIBERN8_EXITED;
+			trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+				ufshcd_hibern8_on_idle_state_to_string(
+					hba->hibern8_on_idle.state));
+			break;
+		}
+		/*
+		 * If we here, it means Hibern8 enter work is either done or
+		 * currently running. Hence, fall through to cancel hibern8
+		 * work and exit hibern8.
+		 */
+	case HIBERN8_ENTERED:
+		scsi_block_requests(hba->host);
+		hba->hibern8_on_idle.state = REQ_HIBERN8_EXIT;
+		trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+			ufshcd_hibern8_on_idle_state_to_string(
+				hba->hibern8_on_idle.state));
+		schedule_work(&hba->hibern8_on_idle.exit_work);
+		/*
+		 * fall through to check if we should wait for this
+		 * work to be done or not.
+		 */
+	case REQ_HIBERN8_EXIT:
+		if (async) {
+			rc = -EAGAIN;
+			hba->hibern8_on_idle.active_reqs--;
+			break;
+		}
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		flush_work(&hba->hibern8_on_idle.exit_work);
+		/* Make sure state is HIBERN8_EXITED before returning */
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		goto start;
+
+	default:
+		dev_err(hba->dev, "%s: H8 is in invalid state %d\n",
+				__func__, hba->hibern8_on_idle.state);
+		break;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return rc;
+}
+
+/* host lock must be held before calling this variant */
+static void __ufshcd_hibern8_release(struct ufs_hba *hba)
+{
+	unsigned long delay_in_jiffies;
+
+	if (!ufshcd_is_hibern8_on_idle_allowed(hba))
+		return;
+
+	hba->hibern8_on_idle.active_reqs--;
+	WARN_ON(hba->hibern8_on_idle.active_reqs < 0);
+
+	if (hba->hibern8_on_idle.active_reqs
+		|| hba->hibern8_on_idle.is_suspended
+		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
+		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| hba->active_uic_cmd || hba->uic_async_done)
+		return;
+
+	hba->hibern8_on_idle.state = REQ_HIBERN8_ENTER;
+	trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+			ufshcd_hibern8_on_idle_state_to_string(
+				hba->hibern8_on_idle.state));
+	/*
+	 * Scheduling the delayed work after 1 jiffies will make the work to
+	 * get schedule any time from 0ms to 1000/HZ ms which is not desirable
+	 * for hibern8 enter work as it may impact the performance if it gets
+	 * scheduled almost immediately. Hence make sure that hibern8 enter
+	 * work gets scheduled atleast after 2 jiffies (any time between
+	 * 1000/HZ ms to 2000/HZ ms).
+	 */
+	delay_in_jiffies = msecs_to_jiffies(hba->hibern8_on_idle.delay_ms);
+	if (delay_in_jiffies == 1)
+		delay_in_jiffies++;
+
+	schedule_delayed_work(&hba->hibern8_on_idle.enter_work,
+			      delay_in_jiffies);
+}
+
+void ufshcd_hibern8_release(struct ufs_hba *hba)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	__ufshcd_hibern8_release(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
+
+static void ufshcd_hibern8_enter_work(struct work_struct *work)
+{
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+					   hibern8_on_idle.enter_work.work);
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->hibern8_on_idle.is_suspended) {
+		hba->hibern8_on_idle.state = HIBERN8_EXITED;
+		trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+				ufshcd_hibern8_on_idle_state_to_string(
+					hba->hibern8_on_idle.state));
+		goto rel_lock;
+	}
+
+	if (hba->hibern8_on_idle.active_reqs
+		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
+		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| hba->active_uic_cmd || hba->uic_async_done)
+		goto rel_lock;
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (ufshcd_is_link_active(hba) && ufshcd_uic_hibern8_enter(hba)) {
+		/* Enter failed */
+		hba->hibern8_on_idle.state = HIBERN8_EXITED;
+		trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+				ufshcd_hibern8_on_idle_state_to_string(
+					hba->hibern8_on_idle.state));
+		goto out;
+	}
+	ufshcd_set_link_hibern8(hba);
+
+	/*
+	 * In case you are here to cancel this work the hibern8_on_idle.state
+	 * would be marked as REQ_HIBERN8_EXIT. In this case keep the state
+	 * as REQ_HIBERN8_EXIT which would anyway imply that we are in hibern8
+	 * and a request to exit from it is pending. By doing this way,
+	 * we keep the state machine in tact and this would ultimately
+	 * prevent from doing cancel work multiple times when there are
+	 * new requests arriving before the current cancel work is done.
+	 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->hibern8_on_idle.state == REQ_HIBERN8_ENTER) {
+		hba->hibern8_on_idle.state = HIBERN8_ENTERED;
+		trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+				ufshcd_hibern8_on_idle_state_to_string(
+					hba->hibern8_on_idle.state));
+	}
+rel_lock:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return;
+}
+
+static void ufshcd_hibern8_exit_work(struct work_struct *work)
+{
+	int ret;
+	unsigned long flags;
+	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+					   hibern8_on_idle.exit_work);
+
+	cancel_delayed_work_sync(&hba->hibern8_on_idle.enter_work);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if ((hba->hibern8_on_idle.state == HIBERN8_EXITED)
+	     || ufshcd_is_link_active(hba)) {
+		hba->hibern8_on_idle.state = HIBERN8_EXITED;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto unblock_reqs;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* Exit from hibern8 */
+	if (ufshcd_is_link_hibern8(hba)) {
+		ret = ufshcd_uic_hibern8_exit(hba);
+		if (!ret) {
+			spin_lock_irqsave(hba->host->host_lock, flags);
+			ufshcd_set_link_active(hba);
+			hba->hibern8_on_idle.state = HIBERN8_EXITED;
+			trace_ufshcd_hibern8_on_idle(dev_name(hba->dev),
+					ufshcd_hibern8_on_idle_state_to_string(
+						hba->hibern8_on_idle.state));
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+		}
+	}
+unblock_reqs:
+	scsi_unblock_requests(hba->host);
+}
+
+static void ufshcd_init_hibern8_on_idle(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_hibern8_on_idle_allowed(hba))
+		return;
+
+	INIT_DELAYED_WORK(&hba->hibern8_on_idle.enter_work,
+			  ufshcd_hibern8_enter_work);
+	INIT_WORK(&hba->hibern8_on_idle.exit_work, ufshcd_hibern8_exit_work);
+
+	hba->hibern8_on_idle.delay_ms = 10;
+	hba->hibern8_on_idle.state = HIBERN8_EXITED;
+}
+
+static void ufshcd_exit_hibern8_on_idle(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_hibern8_on_idle_allowed(hba))
+		return;
+	/* Don't have anything to do for now */
+}
+
+static void ufshcd_hold_all(struct ufs_hba *hba)
+{
+	ufshcd_hold(hba, false);
+	ufshcd_hibern8_hold(hba, false);
+}
+
+static void ufshcd_release_all(struct ufs_hba *hba)
+{
+	ufshcd_hibern8_release(hba);
+	ufshcd_release(hba);
+}
+
 /* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
@@ -2026,7 +2290,7 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 	int ret;
 	unsigned long flags;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
@@ -2038,7 +2302,7 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 
 	mutex_unlock(&hba->uic_cmd_mutex);
 
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return ret;
 }
 
@@ -2410,7 +2674,18 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
-	WARN_ON(hba->clk_gating.state != CLKS_ON);
+	if (ufshcd_is_clkgating_allowed(hba))
+		WARN_ON(hba->clk_gating.state != CLKS_ON);
+
+	err = ufshcd_hibern8_hold(hba, true);
+	if (err) {
+		clear_bit_unlock(tag, &hba->lrb_in_use);
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		ufshcd_release(hba);
+		goto out;
+	}
+	if (ufshcd_is_hibern8_on_idle_allowed(hba))
+		WARN_ON(hba->hibern8_on_idle.state != HIBERN8_EXITED);
 
 	lrbp = &hba->lrb[tag];
 
@@ -2731,7 +3006,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
@@ -2775,7 +3050,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -2799,7 +3074,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	if (!attr_val) {
 		dev_err(hba->dev, "%s: attribute value required for opcode 0x%x\n",
 				__func__, opcode);
@@ -2839,7 +3114,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -2890,7 +3165,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	if (!desc_buf) {
 		dev_err(hba->dev, "%s: descriptor buffer required for opcode 0x%x\n",
 				__func__, opcode);
@@ -2940,7 +3215,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -3751,10 +4026,9 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	uic_cmd.command = UIC_CMD_DME_SET;
 	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
 	uic_cmd.argument3 = mode;
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
-	ufshcd_release(hba);
-
+	ufshcd_release_all(hba);
 out:
 	return ret;
 }
@@ -4368,7 +4642,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	int err = 0;
 	int retries;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
@@ -4380,7 +4654,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
 	}
 	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
@@ -4777,6 +5051,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
+			__ufshcd_hibern8_release(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
@@ -5224,7 +5499,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	hba = container_of(work, struct ufs_hba, eh_work);
 
 	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
@@ -5334,7 +5609,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	pm_runtime_put_sync(hba->dev);
 }
 
@@ -5590,7 +5865,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
 	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_req_descp = hba->utmrdl_base_addr;
@@ -5650,7 +5925,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	ufshcd_put_tm_slot(hba, free_slot);
 	wake_up(&hba->tm_tag_wq);
 
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -5763,7 +6038,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
 		return ufshcd_eh_host_reset_handler(cmd);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
@@ -5884,10 +6159,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 
 	/*
-	 * This ufshcd_release() corresponds to the original scsi cmd that got
-	 * aborted here (as we won't get any IRQ for it).
+	 * This ufshcd_release_all() corresponds to the original scsi cmd that
+	 * got aborted here (as we won't get any IRQ for it).
 	 */
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -5975,7 +6250,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	hba = shost_priv(cmd->device->host);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold_all(hba);
 	/*
 	 * Check if there is any race with fatal error handling.
 	 * If so, wait for it to complete. Even though fatal error
@@ -6010,7 +6285,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return err;
 }
 
@@ -6644,7 +6919,13 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba = (struct ufs_hba *)data;
 
+	/*
+	 * Don't allow clock gating and hibern8 enter for faster device
+	 * detection.
+	 */
+	ufshcd_hold_all(hba);
 	ufshcd_probe_hba(hba);
+	ufshcd_release_all(hba);
 }
 
 static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
@@ -7439,8 +7720,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
 	 */
-	ufshcd_hold(hba, false);
+	WARN_ON(hba->hibern8_on_idle.active_reqs);
+	ufshcd_hold_all(hba);
 	hba->clk_gating.is_suspended = true;
+	hba->hibern8_on_idle.is_suspended = true;
 
 	if (hba->clk_scaling.is_allowed) {
 		cancel_work_sync(&hba->clk_scaling.suspend_work);
@@ -7493,6 +7776,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto set_dev_active;
 
+	if (ufshcd_is_link_hibern8(hba) &&
+	    ufshcd_is_hibern8_on_idle_allowed(hba))
+		hba->hibern8_on_idle.state = HIBERN8_ENTERED;
+
 	ufshcd_vreg_set_lpm(hba);
 
 disable_clks:
@@ -7511,8 +7798,11 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		/* If link is active, device ref_clk can't be switched off */
 		__ufshcd_setup_clocks(hba, false, true);
 
-	hba->clk_gating.state = CLKS_OFF;
-	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		hba->clk_gating.state = CLKS_OFF;
+		trace_ufshcd_clk_gating(dev_name(hba->dev),
+					hba->clk_gating.state);
+	}
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller transaction expected till resume.
@@ -7534,10 +7824,11 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
+	hba->hibern8_on_idle.is_suspended = false;
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 out:
 	hba->pm_op_in_progress = 0;
 	return ret;
@@ -7587,10 +7878,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		ret = ufshcd_uic_hibern8_exit(hba);
-		if (!ret)
+		if (!ret) {
 			ufshcd_set_link_active(hba);
-		else
+			if (ufshcd_is_hibern8_on_idle_allowed(hba))
+				hba->hibern8_on_idle.state = HIBERN8_EXITED;
+		} else {
 			goto vendor_suspend;
+		}
 	} else if (ufshcd_is_link_off(hba)) {
 		ret = ufshcd_host_reset_and_restore(hba);
 		/*
@@ -7599,6 +7893,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		if (ret || !ufshcd_is_link_active(hba))
 			goto vendor_suspend;
+		if (ufshcd_is_hibern8_on_idle_allowed(hba))
+			hba->hibern8_on_idle.state = HIBERN8_EXITED;
 	}
 
 	if (!ufshcd_is_ufs_dev_active(hba)) {
@@ -7617,12 +7913,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_urgent_bkops(hba);
 
 	hba->clk_gating.is_suspended = false;
+	hba->hibern8_on_idle.is_suspended = false;
 
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_resume_clkscaling(hba);
 
 	/* Schedule clock gating in case of no access to UFS device yet */
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
@@ -7631,6 +7928,9 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 set_old_link_state:
 	ufshcd_link_state_transition(hba, old_link_state, 0);
+	if (ufshcd_is_link_hibern8(hba) &&
+	    ufshcd_is_hibern8_on_idle_allowed(hba))
+		hba->hibern8_on_idle.state = HIBERN8_ENTERED;
 vendor_suspend:
 	ufshcd_vops_suspend(hba, pm_op);
 disable_vreg:
@@ -7640,6 +7940,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_suspend_clkscaling(hba);
 	ufshcd_setup_clocks(hba, false);
+	if (ufshcd_is_clkgating_allowed(hba))
+		hba->clk_gating.state = CLKS_OFF;
 out:
 	hba->pm_op_in_progress = 0;
 	return ret;
@@ -7842,6 +8144,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba, true);
 
 	ufshcd_exit_clk_gating(hba);
+	ufshcd_exit_hibern8_on_idle(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
 	ufshcd_hba_exit(hba);
@@ -8004,6 +8307,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	init_waitqueue_head(&hba->dev_cmd.tag_wq);
 
 	ufshcd_init_clk_gating(hba);
+	ufshcd_init_hibern8_on_idle(hba);
 
 	/*
 	 * In order to avoid any spurious interrupt immediately after
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a2e1d5c..eaccc76 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -370,6 +370,35 @@ struct ufs_saved_pwr_info {
 	bool is_valid;
 };
 
+/* Hibern8 state  */
+enum ufshcd_hibern8_on_idle_state {
+	HIBERN8_ENTERED,
+	HIBERN8_EXITED,
+	REQ_HIBERN8_ENTER,
+	REQ_HIBERN8_EXIT,
+};
+
+/**
+ * struct ufs_hibern8_on_idle - UFS Hibern8 on idle related data
+ * @enter_work: worker to put UFS link in hibern8 after some delay as
+ * specified in delay_ms
+ * @exit_work: worker to bring UFS link out of hibern8
+ * @state: the current hibern8 state
+ * @delay_ms: hibern8 enter delay in ms
+ * @is_suspended: hibern8 enter is suspended when set to 1 which can be used
+ * during suspend/resume
+ * @active_reqs: number of requests that are pending and should be waited for
+ * completion before scheduling delayed "enter_work".
+ */
+struct ufs_hibern8_on_idle {
+	struct delayed_work enter_work;
+	struct work_struct exit_work;
+	enum ufshcd_hibern8_on_idle_state state;
+	unsigned long delay_ms;
+	bool is_suspended;
+	int active_reqs;
+};
+
 /**
  * struct ufs_clk_scaling - UFS clock scaling related data
  * @active_reqs: number of requests that are pending. If this is zero when
@@ -496,6 +525,7 @@ struct ufs_stats {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @hibern8_on_idle: UFS Hibern8 on idle related data
  * @desc_size: descriptor sizes reported by device
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
@@ -670,6 +700,8 @@ struct ufs_hba {
 	struct ufs_pwr_mode_info max_pwr_info;
 
 	struct ufs_clk_gating clk_gating;
+	struct ufs_hibern8_on_idle hibern8_on_idle;
+
 	/* Control to enable/disable host capabilities */
 	u32 caps;
 	/* Allow dynamic clk gating */
@@ -686,6 +718,9 @@ struct ufs_hba {
 	 * CAUTION: Enabling this might reduce overall UFS throughput.
 	 */
 #define UFSHCD_CAP_INTR_AGGR (1 << 4)
+	/* Allow standalone Hibern8 enter on idle */
+#define UFSHCD_CAP_HIBERN8_ENTER_ON_IDLE (1 << 5)
+
 	/*
 	 * This capability allows the device auto-bkops to be always enabled
 	 * except during suspend (both runtime and suspend).
@@ -724,6 +759,10 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 }
+static inline bool ufshcd_is_hibern8_on_idle_allowed(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_HIBERN8_ENTER_ON_IDLE;
+}
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index bf6f826..66ec728 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -75,6 +75,26 @@
 		__print_symbolic(__entry->state, UFSCHD_CLK_GATING_STATES))
 );
 
+TRACE_EVENT(ufshcd_hibern8_on_idle,
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
+	TP_printk("%s: state changed to %s",
+		__get_str(dev_name), __get_str(state))
+);
+
 TRACE_EVENT(ufshcd_clk_scaling,
 
 	TP_PROTO(const char *dev_name, const char *state, const char *clk,
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
