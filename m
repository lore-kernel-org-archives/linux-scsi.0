From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 6/6] scsi: ufs: Improve UFS fatal error handling
Date: Mon, 26 May 2014 10:59:15 +0530
Message-ID: <1401082155-23184-7-git-send-email-sthumma@codeaurora.org>
References: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Error handling in UFS driver is broken and resets the host controller
for fatal errors without re-initialization. Correct the fatal error
handling sequence according to UFS Host Controller Interface (HCI)
v1.1 specification.

o Processed requests which are completed w/wo error are reported to
  SCSI layer and any pending commands that are not started are aborted
  in the controller and re-queued into scsi mid-layer queue.

o Upon determining fatal error condition the host controller may hang
  forever until a reset is applied. Block SCSI layer for sending new
  requests and apply reset in a separate error handling work.

o SCSI is informed about the expected Unit-Attention exception from the
  device for the immediate command after a reset so that the SCSI layer
  take necessary steps to establish communication with the device.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 229 ++++++++++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h |  10 +-
 2 files changed, 149 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5462310..0c28772 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -84,6 +84,14 @@ enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
 };
 
+/* UFSHCD UIC layer error flags */
+enum {
+	UFSHCD_UIC_DL_PA_INIT_ERROR = (1 << 0), /* Data link layer error */
+	UFSHCD_UIC_NL_ERROR = (1 << 1), /* Network layer error */
+	UFSHCD_UIC_TL_ERROR = (1 << 2), /* Transport Layer error */
+	UFSHCD_UIC_DME_ERROR = (1 << 3), /* DME error */
+};
+
 /* Interrupt configuration options */
 enum {
 	UFSHCD_INT_DISABLE,
@@ -100,6 +108,8 @@ enum {
 
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
+static int ufshcd_reset_and_restore(struct ufs_hba *hba);
+static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -1735,9 +1745,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 		goto out;
 	}
 
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		scsi_unblock_requests(hba->host);
-
 out:
 	return err;
 }
@@ -1863,66 +1870,6 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_do_reset - reset the host controller
- * @hba: per adapter instance
- *
- * Returns SUCCESS/FAILED
- */
-static int ufshcd_do_reset(struct ufs_hba *hba)
-{
-	struct ufshcd_lrb *lrbp;
-	unsigned long flags;
-	int tag;
-
-	/* block commands from midlayer */
-	scsi_block_requests(hba->host);
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
-
-	/* send controller to reset state */
-	ufshcd_hba_stop(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	/* abort outstanding commands */
-	for (tag = 0; tag < hba->nutrs; tag++) {
-		if (test_bit(tag, &hba->outstanding_reqs)) {
-			lrbp = &hba->lrb[tag];
-			if (lrbp->cmd) {
-				scsi_dma_unmap(lrbp->cmd);
-				lrbp->cmd->result = DID_RESET << 16;
-				lrbp->cmd->scsi_done(lrbp->cmd);
-				lrbp->cmd = NULL;
-				clear_bit_unlock(tag, &hba->lrb_in_use);
-			}
-		}
-	}
-
-	/* complete device management command */
-	if (hba->dev_cmd.complete)
-		complete(hba->dev_cmd.complete);
-
-	/* clear outstanding request/task bit maps */
-	hba->outstanding_reqs = 0;
-	hba->outstanding_tasks = 0;
-
-	/* Host controller enable */
-	if (ufshcd_hba_enable(hba)) {
-		dev_err(hba->dev,
-			"Reset: Controller initialization failed\n");
-		return FAILED;
-	}
-
-	if (ufshcd_link_startup(hba)) {
-		dev_err(hba->dev,
-			"Reset: Link start-up failed\n");
-		return FAILED;
-	}
-
-	return SUCCESS;
-}
-
-/**
  * ufshcd_slave_alloc - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
  *
@@ -1939,6 +1886,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	sdev->use_10_for_ms = 1;
 	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
 
+	/* allow SCSI layer to restart the device in case of errors */
+	sdev->allow_restart = 1;
+
 	/*
 	 * Inform SCSI Midlayer that the LUN queue depth is same as the
 	 * controller queue depth. If a LUN queue depth is less than the
@@ -2134,6 +2084,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_ABORTED:
 		result |= DID_ABORT << 16;
 		break;
+	case OCS_INVALID_COMMAND_STATUS:
+		result |= DID_REQUEUE << 16;
+		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
 	case OCS_MISMATCH_DATA_BUF_SIZE:
@@ -2451,45 +2404,145 @@ out:
 }
 
 /**
- * ufshcd_fatal_err_handler - handle fatal errors
- * @hba: per adapter instance
+ * ufshcd_err_handler - handle UFS errors that require s/w attention
+ * @work: pointer to work structure
  */
-static void ufshcd_fatal_err_handler(struct work_struct *work)
+static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
-	hba = container_of(work, struct ufs_hba, feh_workq);
+	unsigned long flags;
+	u32 err_xfer = 0;
+	u32 err_tm = 0;
+	int err = 0;
+	int tag;
+
+	hba = container_of(work, struct ufs_hba, eh_work);
 
 	pm_runtime_get_sync(hba->dev);
-	/* check if reset is already in progress */
-	if (hba->ufshcd_state != UFSHCD_STATE_RESET)
-		ufshcd_do_reset(hba);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_eh_in_progress(hba);
+
+	/* Complete requests that have door-bell cleared by h/w */
+	ufshcd_transfer_req_compl(hba);
+	ufshcd_tmc_handler(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* Clear pending transfer requests */
+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs)
+		if (ufshcd_clear_cmd(hba, tag))
+			err_xfer |= 1 << tag;
+
+	/* Clear pending task management requests */
+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs)
+		if (ufshcd_clear_tm_cmd(hba, tag))
+			err_tm |= 1 << tag;
+
+	/* Complete the requests that are cleared by s/w */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_transfer_req_compl(hba);
+	ufshcd_tmc_handler(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* Fatal errors need reset */
+	if (err_xfer || err_tm || (hba->saved_err & INT_FATAL_ERRORS) ||
+			((hba->saved_err & UIC_ERROR) &&
+			 (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR))) {
+		err = ufshcd_reset_and_restore(hba);
+		if (err) {
+			dev_err(hba->dev, "%s: reset and restore failed\n",
+					__func__);
+			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		}
+		/*
+		 * Inform scsi mid-layer that we did reset and allow to handle
+		 * Unit Attention properly.
+		 */
+		scsi_report_bus_reset(hba->host, 0);
+		hba->saved_err = 0;
+		hba->saved_uic_err = 0;
+	}
+	ufshcd_clear_eh_in_progress(hba);
+
+out:
+	scsi_unblock_requests(hba->host);
 	pm_runtime_put_sync(hba->dev);
 }
 
 /**
- * ufshcd_err_handler - Check for fatal errors
- * @work: pointer to a work queue structure
+ * ufshcd_update_uic_error - check and set fatal UIC error flags.
+ * @hba: per-adapter instance
  */
-static void ufshcd_err_handler(struct ufs_hba *hba)
+static void ufshcd_update_uic_error(struct ufs_hba *hba)
 {
 	u32 reg;
 
+	/* PA_INIT_ERROR is fatal and needs UIC reset */
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
+	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+		hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
+
+	/* UIC NL/TL/DME errors needs software retry */
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
+	if (reg)
+		hba->uic_error |= UFSHCD_UIC_NL_ERROR;
+
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_TRANSPORT_LAYER);
+	if (reg)
+		hba->uic_error |= UFSHCD_UIC_TL_ERROR;
+
+	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
+	if (reg)
+		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+
+	dev_dbg(hba->dev, "%s: UIC error flags = 0x%08x\n",
+			__func__, hba->uic_error);
+}
+
+/**
+ * ufshcd_check_errors - Check for errors that need s/w attention
+ * @hba: per-adapter instance
+ */
+static void ufshcd_check_errors(struct ufs_hba *hba)
+{
+	bool queue_eh_work = false;
+
 	if (hba->errors & INT_FATAL_ERRORS)
-		goto fatal_eh;
+		queue_eh_work = true;
 
 	if (hba->errors & UIC_ERROR) {
-		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
-		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
-			goto fatal_eh;
+		hba->uic_error = 0;
+		ufshcd_update_uic_error(hba);
+		if (hba->uic_error)
+			queue_eh_work = true;
 	}
-	return;
-fatal_eh:
-	/* handle fatal errors only when link is functional */
-	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
-		/* block commands at driver layer until error is handled */
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-		schedule_work(&hba->feh_workq);
+
+	if (queue_eh_work) {
+		/* handle fatal errors only when link is functional */
+		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
+			/* block commands from scsi mid-layer */
+			scsi_block_requests(hba->host);
+
+			/* transfer error masks to sticky bits */
+			hba->saved_err |= hba->errors;
+			hba->saved_uic_err |= hba->uic_error;
+
+			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+			schedule_work(&hba->eh_work);
+		}
 	}
+	/*
+	 * if (!queue_eh_work) -
+	 * Other errors are either non-fatal where host recovers
+	 * itself without s/w intervention or errors that will be
+	 * handled by the SCSI core layer.
+	 */
 }
 
 /**
@@ -2514,7 +2567,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	hba->errors = UFSHCD_ERROR_MASK & intr_status;
 	if (hba->errors)
-		ufshcd_err_handler(hba);
+		ufshcd_check_errors(hba);
 
 	if (intr_status & UFSHCD_UIC_MASK)
 		ufshcd_uic_cmd_compl(hba, intr_status);
@@ -2889,12 +2942,12 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	 */
 	do {
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (!(work_pending(&hba->feh_workq) ||
+		if (!(work_pending(&hba->eh_work) ||
 				hba->ufshcd_state == UFSHCD_STATE_RESET))
 			break;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
-		flush_work(&hba->feh_workq);
+		flush_work(&hba->eh_work);
 	} while (1);
 
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
@@ -3130,7 +3183,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	init_waitqueue_head(&hba->tm_tag_wq);
 
 	/* Initialize work queues */
-	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
+	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
 	/* Initialize UIC command mutex */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 48c7d9b..acf318e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -183,9 +183,12 @@ struct ufs_dev_cmd {
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
- * @feh_workq: Work queue for fatal controller error handling
+ * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
+ * @uic_error: UFS interconnect layer error status
+ * @saved_err: sticky error mask
+ * @saved_uic_err: sticky UIC error mask
  * @dev_cmd: ufs device management command information
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  */
@@ -233,11 +236,14 @@ struct ufs_hba {
 	u16 ee_ctrl_mask;
 
 	/* Work Queues */
-	struct work_struct feh_workq;
+	struct work_struct eh_work;
 	struct work_struct eeh_work;
 
 	/* HBA Errors */
 	u32 errors;
+	u32 uic_error;
+	u32 saved_err;
+	u32 saved_uic_err;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
