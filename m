From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 5/6] scsi: ufs: Fix device and host reset methods
Date: Mon, 26 May 2014 10:59:14 +0530
Message-ID: <1401082155-23184-6-git-send-email-sthumma@codeaurora.org>
References: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As of now SCSI initiated error handling is broken because,
the reset APIs don't try to bring back the device initialized and
ready for further transfers.

In case of timeouts, the scsi error handler takes care of handling aborts
and resets. Improve the error handling in such scenario by resetting the
device and host and re-initializing them in proper manner.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 240 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |   2 +
 2 files changed, 189 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52f66e4..5462310 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -74,9 +74,14 @@ enum {
 
 /* UFSHCD states */
 enum {
-	UFSHCD_STATE_OPERATIONAL,
 	UFSHCD_STATE_RESET,
 	UFSHCD_STATE_ERROR,
+	UFSHCD_STATE_OPERATIONAL,
+};
+
+/* UFSHCD error handling flags */
+enum {
+	UFSHCD_EH_IN_PROGRESS = (1 << 0),
 };
 
 /* Interrupt configuration options */
@@ -86,6 +91,16 @@ enum {
 	UFSHCD_INT_CLEAR,
 };
 
+#define ufshcd_set_eh_in_progress(h) \
+	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS)
+#define ufshcd_eh_in_progress(h) \
+	(h->eh_flags & UFSHCD_EH_IN_PROGRESS)
+#define ufshcd_clear_eh_in_progress(h) \
+	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
+
+static void ufshcd_tmc_handler(struct ufs_hba *hba);
+static void ufshcd_async_scan(void *data, async_cookie_t cookie);
+
 /*
  * ufshcd_wait_for_register - wait for register value to change
  * @hba - per-adapter interface
@@ -856,10 +871,25 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	tag = cmd->request->tag;
 
-	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	switch (hba->ufshcd_state) {
+	case UFSHCD_STATE_OPERATIONAL:
+		break;
+	case UFSHCD_STATE_RESET:
 		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
+		goto out_unlock;
+	case UFSHCD_STATE_ERROR:
+		set_host_byte(cmd, DID_ERROR);
+		cmd->scsi_done(cmd);
+		goto out_unlock;
+	default:
+		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
+				__func__, hba->ufshcd_state);
+		set_host_byte(cmd, DID_BAD_TARGET);
+		cmd->scsi_done(cmd);
+		goto out_unlock;
 	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* acquire the tag to make sure device cmds don't use it */
 	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) {
@@ -896,6 +926,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
+out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
 	return err;
@@ -1707,8 +1738,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		scsi_unblock_requests(hba->host);
 
-	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-
 out:
 	return err;
 }
@@ -2455,8 +2484,12 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
 	}
 	return;
 fatal_eh:
-	hba->ufshcd_state = UFSHCD_STATE_ERROR;
-	schedule_work(&hba->feh_workq);
+	/* handle fatal errors only when link is functional */
+	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
+		/* block commands at driver layer until error is handled */
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		schedule_work(&hba->feh_workq);
+	}
 }
 
 /**
@@ -2621,12 +2654,13 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 }
 
 /**
- * ufshcd_device_reset - reset device and abort all the pending commands
+ * ufshcd_eh_device_reset_handler - device reset handler registered to
+ *                                    scsi layer.
  * @cmd: SCSI command pointer
  *
  * Returns SUCCESS/FAILED
  */
-static int ufshcd_device_reset(struct scsi_cmnd *cmd)
+static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
@@ -2635,6 +2669,7 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
 	int err;
 	u8 resp = 0xF;
 	struct ufshcd_lrb *lrbp;
+	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
@@ -2643,55 +2678,33 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
 	lrbp = &hba->lrb[tag];
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		err = FAILED;
+		if (!err)
+			err = resp;
 		goto out;
-	} else {
-		err = SUCCESS;
 	}
 
-	for (pos = 0; pos < hba->nutrs; pos++) {
-		if (test_bit(pos, &hba->outstanding_reqs) &&
-		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
-
-			/* clear the respective UTRLCLR register bit */
-			ufshcd_utrl_clear(hba, pos);
-
-			clear_bit(pos, &hba->outstanding_reqs);
-
-			if (hba->lrb[pos].cmd) {
-				scsi_dma_unmap(hba->lrb[pos].cmd);
-				hba->lrb[pos].cmd->result =
-					DID_ABORT << 16;
-				hba->lrb[pos].cmd->scsi_done(cmd);
-				hba->lrb[pos].cmd = NULL;
-				clear_bit_unlock(pos, &hba->lrb_in_use);
-				wake_up(&hba->dev_cmd.tag_wq);
-			}
+	/* clear the commands that were pending for corresponding LUN */
+	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
+		if (hba->lrb[pos].lun == lrbp->lun) {
+			err = ufshcd_clear_cmd(hba, pos);
+			if (err)
+				break;
 		}
-	} /* end of for */
+	}
+	spin_lock_irqsave(host->host_lock, flags);
+	ufshcd_transfer_req_compl(hba);
+	spin_unlock_irqrestore(host->host_lock, flags);
 out:
+	if (!err) {
+		err = SUCCESS;
+	} else {
+		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
+		err = FAILED;
+	}
 	return err;
 }
 
 /**
- * ufshcd_host_reset - Main reset function registered with scsi layer
- * @cmd: SCSI command pointer
- *
- * Returns SUCCESS/FAILED
- */
-static int ufshcd_host_reset(struct scsi_cmnd *cmd)
-{
-	struct ufs_hba *hba;
-
-	hba = shost_priv(cmd->device->host);
-
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		return SUCCESS;
-
-	return ufshcd_do_reset(hba);
-}
-
-/**
  * ufshcd_abort - abort a specific command
  * @cmd: SCSI command pointer
  *
@@ -2789,6 +2802,122 @@ out:
 }
 
 /**
+ * ufshcd_host_reset_and_restore - reset and restore host controller
+ * @hba: per-adapter instance
+ *
+ * Note that host controller reset may issue DME_RESET to
+ * local and remote (device) Uni-Pro stack and the attributes
+ * are reset to default state.
+ *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
+{
+	int err;
+	async_cookie_t cookie;
+	unsigned long flags;
+
+	/* Reset the host controller */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_hba_stop(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_hba_enable(hba);
+	if (err)
+		goto out;
+
+	/* Establish the link again and restore the device */
+	cookie = async_schedule(ufshcd_async_scan, hba);
+	/* wait for async scan to be completed */
+	async_synchronize_cookie(++cookie);
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+		err = -EIO;
+out:
+	if (err)
+		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
+
+	return err;
+}
+
+/**
+ * ufshcd_reset_and_restore - reset and re-initialize host/device
+ * @hba: per-adapter instance
+ *
+ * Reset and recover device, host and re-establish link. This
+ * is helpful to recover the communication in fatal error conditions.
+ *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_reset_and_restore(struct ufs_hba *hba)
+{
+	int err = 0;
+	unsigned long flags;
+
+	err = ufshcd_host_reset_and_restore(hba);
+
+	/*
+	 * After reset the door-bell might be cleared, complete
+	 * outstanding requests in s/w here.
+	 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_transfer_req_compl(hba);
+	ufshcd_tmc_handler(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return err;
+}
+
+/**
+ * ufshcd_eh_host_reset_handler - host reset handler registered to scsi layer
+ * @cmd - SCSI command pointer
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
+{
+	int err;
+	unsigned long flags;
+	struct ufs_hba *hba;
+
+	hba = shost_priv(cmd->device->host);
+
+	/*
+	 * Check if there is any race with fatal error handling.
+	 * If so, wait for it to complete. Even though fatal error
+	 * handling does reset and restore in some cases, don't assume
+	 * anything out of it. We are just avoiding race here.
+	 */
+	do {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (!(work_pending(&hba->feh_workq) ||
+				hba->ufshcd_state == UFSHCD_STATE_RESET))
+			break;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
+		flush_work(&hba->feh_workq);
+	} while (1);
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_eh_in_progress(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_reset_and_restore(hba);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (!err) {
+		err = SUCCESS;
+		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	} else {
+		err = FAILED;
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+	}
+	ufshcd_clear_eh_in_progress(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return err;
+}
+
+/**
  * ufshcd_async_scan - asynchronous execution for link startup
  * @data: data pointer to pass to this function
  * @cookie: cookie data
@@ -2813,8 +2942,13 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		goto out;
 
 	ufshcd_force_reset_auto_bkops(hba);
-	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
+	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+
+	/* If we are in error handling context no need to scan the host */
+	if (!ufshcd_eh_in_progress(hba)) {
+		scsi_scan_host(hba->host);
+		pm_runtime_put_sync(hba->dev);
+	}
 out:
 	return;
 }
@@ -2827,8 +2961,8 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.eh_abort_handler	= ufshcd_abort,
-	.eh_device_reset_handler = ufshcd_device_reset,
-	.eh_host_reset_handler	= ufshcd_host_reset,
+	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
+	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 84d09d1..48c7d9b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -180,6 +180,7 @@ struct ufs_dev_cmd {
  * @pwr_done: completion for power mode change
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
+ * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @feh_workq: Work queue for fatal controller error handling
@@ -227,6 +228,7 @@ struct ufs_hba {
 	struct completion *pwr_done;
 
 	u32 ufshcd_state;
+	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
