From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 3/4] scsi: ufs: Fix device and host reset methods
Date: Thu, 13 Jun 2013 20:00:59 +0530
Message-ID: <1371133860-17574-4-git-send-email-sthumma@codeaurora.org>
References: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As of now SCSI initiated error handling is broken because,
the reset APIs don't try to bring back the device initialized and
ready for further transfers.

In case of timeouts, the scsi error handler takes care of handling aborts
and resets. Improve the error handling in such scenario by resetting the
device and host and re-initializing them in proper manner.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  446 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h |    2 +
 2 files changed, 391 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d576df2..e368bb0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -73,9 +73,15 @@ enum {
 
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
+	UFSHCD_EH_HOST_RESET_PENDING = (1 << 0),
+	UFSHCD_EH_DEVICE_RESET_PENDING = (1 << 1),
 };
 
 /* Interrupt configuration options */
@@ -91,6 +97,22 @@ enum {
 	INT_AGGR_CONFIG,
 };
 
+#define ufshcd_set_device_reset_pending(h) \
+	(h->eh_flags |= UFSHCD_EH_DEVICE_RESET_PENDING)
+#define ufshcd_set_host_reset_pending(h) \
+	(h->eh_flags |= UFSHCD_EH_HOST_RESET_PENDING)
+#define ufshcd_device_reset_pending(h) \
+	(h->eh_flags & UFSHCD_EH_DEVICE_RESET_PENDING)
+#define ufshcd_host_reset_pending(h) \
+	(h->eh_flags & UFSHCD_EH_HOST_RESET_PENDING)
+#define ufshcd_clear_device_reset_pending(h) \
+	(h->eh_flags &= ~UFSHCD_EH_DEVICE_RESET_PENDING)
+#define ufshcd_clear_host_reset_pending(h) \
+	(h->eh_flags &= ~UFSHCD_EH_HOST_RESET_PENDING)
+
+static void ufshcd_tmc_handler(struct ufs_hba *hba);
+static void ufshcd_async_scan(void *data, async_cookie_t cookie);
+
 /*
  * ufshcd_wait_for_register - wait for register value to change
  * @hba - per-adapter interface
@@ -879,9 +901,22 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	tag = cmd->request->tag;
 
-	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+	switch (hba->ufshcd_state) {
+	case UFSHCD_STATE_OPERATIONAL:
+		break;
+	case UFSHCD_STATE_RESET:
 		err = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
+	case UFSHCD_STATE_ERROR:
+		set_host_byte(cmd, DID_ERROR);
+		cmd->scsi_done(cmd);
+		goto out;
+	default:
+		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
+				__func__, hba->ufshcd_state);
+		set_host_byte(cmd, DID_BAD_TARGET);
+		cmd->scsi_done(cmd);
+		break;
 	}
 
 	lrbp = &hba->lrb[tag];
@@ -1538,8 +1573,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		scsi_unblock_requests(hba->host);
 
-	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-
 out:
 	return err;
 }
@@ -2229,6 +2262,106 @@ out:
 }
 
 /**
+ * ufshcd_utrl_is_rsr_enabled - check if run-stop register is enabled
+ * @hba: per-adapter instance
+ */
+static bool ufshcd_utrl_is_rsr_enabled(struct ufs_hba *hba)
+{
+	return ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_RUN_STOP) & 0x1;
+}
+
+/**
+ * ufshcd_utmrl_is_rsr_enabled - check if run-stop register is enabled
+ * @hba: per-adapter instance
+ */
+static bool ufshcd_utmrl_is_rsr_enabled(struct ufs_hba *hba)
+{
+	return ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_RUN_STOP) & 0x1;
+}
+
+/**
+ * ufshcd_complete_pending_tasks - complete outstanding tasks
+ * @hba: per adapter instance
+ *
+ * Abort in-progress task management commands and wakeup
+ * waiting threads.
+ *
+ * Returns non-zero error value when failed to clear all the commands.
+ */
+static int ufshcd_complete_pending_tasks(struct ufs_hba *hba)
+{
+	u32 reg;
+	int err = 0;
+	unsigned long flags;
+
+	if (!hba->outstanding_tasks)
+		goto out;
+
+	/* Clear UTMRL only when run-stop is enabled */
+	if (ufshcd_utmrl_is_rsr_enabled(hba))
+		ufshcd_writel(hba, ~hba->outstanding_tasks,
+				REG_UTP_TASK_REQ_LIST_CLEAR);
+
+	/* poll for max. 1 sec to clear door bell register by h/w */
+	reg = ufshcd_wait_for_register(hba,
+			REG_UTP_TASK_REQ_DOOR_BELL,
+			hba->outstanding_tasks, 0, 1000, 1000);
+	if (reg & hba->outstanding_tasks)
+		err = -ETIMEDOUT;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* complete commands that were cleared out */
+	ufshcd_tmc_handler(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	if (err)
+		dev_err(hba->dev, "%s: failed, still pending = 0x%.8x\n",
+				__func__, reg);
+	return err;
+}
+
+/**
+ * ufshcd_complete_pending_reqs - complete outstanding requests
+ * @hba: per adapter instance
+ *
+ * Abort in-progress transfer request commands and return them to SCSI.
+ *
+ * Returns non-zero error value when failed to clear all the commands.
+ */
+static int ufshcd_complete_pending_reqs(struct ufs_hba *hba)
+{
+	u32 reg;
+	int err = 0;
+	unsigned long flags;
+
+	/* check if we completed all of them */
+	if (!hba->outstanding_reqs)
+		goto out;
+
+	/* Clear UTRL only when run-stop is enabled */
+	if (ufshcd_utrl_is_rsr_enabled(hba))
+		ufshcd_writel(hba, ~hba->outstanding_reqs,
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+
+	/* poll for max. 1 sec to clear door bell register by h/w */
+	reg = ufshcd_wait_for_register(hba,
+			REG_UTP_TRANSFER_REQ_DOOR_BELL,
+			hba->outstanding_reqs, 0, 1000, 1000);
+	if (reg & hba->outstanding_reqs)
+		err = -ETIMEDOUT;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* complete commands that were cleared out */
+	ufshcd_transfer_req_compl(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	if (err)
+		dev_err(hba->dev, "%s: failed, still pending = 0x%.8x\n",
+				__func__, reg);
+	return err;
+}
+
+/**
  * ufshcd_fatal_err_handler - handle fatal errors
  * @hba: per adapter instance
  */
@@ -2424,78 +2557,154 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 }
 
 /**
- * ufshcd_device_reset - reset device and abort all the pending commands
- * @cmd: SCSI command pointer
+ * ufshcd_dme_end_point_reset - Notify device Unipro to perform reset
+ * @hba: per adapter instance
  *
- * Returns SUCCESS/FAILED
+ * UIC_CMD_DME_END_PT_RST resets the UFS device completely, the UFS flags,
+ * attributes and descriptors are reset to default state. Callers are
+ * expected to initialize the whole device again after this.
+ *
+ * Returns zero on success, non-zero on failure
  */
-static int ufshcd_device_reset(struct scsi_cmnd *cmd)
+static int ufshcd_dme_end_point_reset(struct ufs_hba *hba)
 {
-	struct Scsi_Host *host;
-	struct ufs_hba *hba;
-	unsigned int tag;
-	u32 pos;
-	int err;
-	u8 resp;
-	struct ufshcd_lrb *lrbp;
+	struct uic_command uic_cmd = {0};
+	int ret;
 
-	host = cmd->device->host;
-	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	uic_cmd.command = UIC_CMD_DME_END_PT_RST;
 
-	lrbp = &hba->lrb[tag];
-	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
-			UFS_LOGICAL_RESET, &resp);
-	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		err = FAILED;
-		goto out;
-	} else {
-		err = SUCCESS;
-	}
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
 
-	for (pos = 0; pos < SCSI_CMD_QUEUE_SIZE; pos++) {
-		if (test_bit(pos, &hba->outstanding_reqs) &&
-		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
+	return ret;
+}
 
-			/* clear the respective UTRLCLR register bit */
-			ufshcd_utrl_clear(hba, pos);
+/**
+ * ufshcd_dme_reset - Local UniPro reset
+ * @hba: per adapter instance
+ *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_dme_reset(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
 
-			clear_bit(pos, &hba->outstanding_reqs);
+	uic_cmd.command = UIC_CMD_DME_RESET;
 
-			if (hba->lrb[pos].cmd) {
-				scsi_dma_unmap(hba->lrb[pos].cmd);
-				hba->lrb[pos].cmd->result =
-						DID_ABORT << 16;
-				hba->lrb[pos].cmd->scsi_done(cmd);
-				hba->lrb[pos].cmd = NULL;
-			}
-		}
-	} /* end of for */
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
 
-	/* complete internal command */
-	if (hba->i_cmd.dev_cmd_complete)
-		complete(hba->i_cmd.dev_cmd_complete);
+	return ret;
+
+}
+
+/**
+ * ufshcd_dme_enable - Local UniPro DME Enable
+ * @hba: per adapter instance
+ *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_dme_enable(struct ufs_hba *hba)
+{
+	struct uic_command uic_cmd = {0};
+	int ret;
+	uic_cmd.command = UIC_CMD_DME_ENABLE;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
+
+	return ret;
 
+}
+
+/**
+ * ufshcd_device_reset_and_restore - reset and restore device
+ * @hba: per-adapter instance
+ *
+ * Note that the device reset issues DME_END_POINT_RESET which
+ * may reset entire device and restore device attributes to
+ * default state.
+ *
+ * Returns zero on success, non-zero on failure
+ */
+static int ufshcd_device_reset_and_restore(struct ufs_hba *hba)
+{
+	int err = 0;
+	u32 reg;
+
+	err = ufshcd_dme_end_point_reset(hba);
+	if (err)
+		goto out;
+	/* restore communication with the device */
+	err = ufshcd_dme_reset(hba);
+	if (err)
+		goto out;
+
+	err = ufshcd_dme_enable(hba);
+	if (err)
+		goto out;
+
+	err = ufshcd_dme_link_startup(hba);
+	if (err)
+		goto out;
+
+	/* check if link is up and device is detected */
+	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
+	if (!ufshcd_is_device_present(reg)) {
+		dev_err(hba->dev, "Device not present\n");
+		err = -ENXIO;
+		goto out;
+	}
+
+	ufshcd_clear_device_reset_pending(hba);
 out:
+	dev_dbg(hba->dev, "%s: done err = %d\n", __func__, err);
 	return err;
 }
 
 /**
- * ufshcd_host_reset - Main reset function registered with scsi layer
- * @cmd: SCSI command pointer
+ * ufshcd_host_reset_and_restore - reset and restore host controller
+ * @hba: per-adapter instance
  *
- * Returns SUCCESS/FAILED
+ * Note that host controller reset may issue DME_RESET to
+ * local and remote (device) Uni-Pro stack and the attributes
+ * are reset to default state.
+ *
+ * Returns zero on success, non-zero on failure
  */
-static int ufshcd_host_reset(struct scsi_cmnd *cmd)
+static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 {
-	struct ufs_hba *hba;
+	int err;
+	async_cookie_t cookie;
+	unsigned long flags;
 
-	hba = shost_priv(cmd->device->host);
+	/* Reset the host controller */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_hba_stop(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		return SUCCESS;
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
+	else
+		ufshcd_clear_host_reset_pending(hba);
 
-	return ufshcd_do_reset(hba);
+	dev_dbg(hba->dev, "%s: done err = %d\n", __func__, err);
+	return err;
 }
 
 /**
@@ -2592,6 +2801,124 @@ out:
 }
 
 /**
+ * ufshcd_reset_and_restore - resets device or host or both
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
+
+	if (ufshcd_device_reset_pending(hba) &&
+			!ufshcd_host_reset_pending(hba)) {
+		err = ufshcd_device_reset_and_restore(hba);
+		if (err) {
+			ufshcd_clear_device_reset_pending(hba);
+			ufshcd_set_host_reset_pending(hba);
+		}
+	}
+
+	if (ufshcd_host_reset_pending(hba))
+		err = ufshcd_host_reset_and_restore(hba);
+
+	/*
+	 * Due to reset the door-bell might be cleared, clear
+	 * outstanding requests in s/w here.
+	 */
+	ufshcd_complete_pending_reqs(hba);
+	ufshcd_complete_pending_tasks(hba);
+
+	return err;
+}
+
+/**
+ * ufshcd_eh_device_reset_handler - device reset handler registered to
+ *                                    scsi layer.
+ * @cmd - SCSI command pointer
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
+{
+	struct ufs_hba *hba;
+	int err;
+	unsigned long flags;
+
+	hba = shost_priv(cmd->device->host);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
+		dev_warn(hba->dev, "%s: reset in progress\n", __func__);
+		err = SUCCESS;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_device_reset_pending(hba);
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
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
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
+	struct ufs_hba *hba;
+	int err;
+	unsigned long flags;
+
+	hba = shost_priv(cmd->device->host);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
+		dev_warn(hba->dev, "%s: reset in progress\n", __func__);
+		err = SUCCESS;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_host_reset_pending(hba);
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
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+out:
+	return err;
+}
+
+/**
  * ufshcd_async_scan - asynchronous execution for link startup
  * @data: data pointer to pass to this function
  * @cookie: cookie data
@@ -2613,7 +2940,12 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
-	scsi_scan_host(hba->host);
+	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+
+	/* If we are in error handling context no need to scan the host */
+	if (!(ufshcd_device_reset_pending(hba) ||
+			ufshcd_host_reset_pending(hba)))
+		scsi_scan_host(hba->host);
 out:
 	return;
 }
@@ -2626,8 +2958,8 @@ static struct scsi_host_template ufshcd_driver_template = {
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
index 8ca08fe..963aadd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -176,6 +176,7 @@ struct ufs_internal_cmd {
  * @tm_tag_wq: wait queue for free task management slots
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
+ * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @feh_workq: Work queue for fatal controller error handling
@@ -219,6 +220,7 @@ struct ufs_hba {
 	unsigned long tm_condition;
 
 	u32 ufshcd_state;
+	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
