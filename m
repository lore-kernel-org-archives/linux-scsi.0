From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V4 4/4] scsi: ufs: Improve UFS fatal error handling
Date: Tue, 23 Jul 2013 12:38:42 +0530
Message-ID: <1374563322-22846-5-git-send-email-sthumma@codeaurora.org>
References: <1374563322-22846-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1374563322-22846-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Error handling in UFS driver is broken and resets the host controller
for fatal errors without re-initialization. Correct the fatal error
handling sequence according to UFS Host Controller Interface (HCI)
v1.1 specification.

o Upon determining fatal error condition the host controller may hang
  forever until a reset is applied, so just retrying the command doesn't
  work without a reset. So, the reset is applied in the driver context
  in a separate work and SCSI mid-layer isn't informed until reset is
  applied.

o Processed requests which are completed without error are reported to
  SCSI layer as successful and any pending commands that are not started
  yet or are not cause of the error are re-queued into scsi midlayer queue.
  For the command that caused error, host controller or device is reset
  and DID_ERROR is returned for command retry after applying reset.

o SCSI is informed about the expected Unit-Attention exception from the
  device for the immediate command after a reset so that the SCSI layer
  take necessary steps to establish communication with the device.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  350 +++++++++++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h |    2 +
 drivers/scsi/ufs/ufshci.h |   19 ++-
 3 files changed, 296 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1a0ceb2..82600d6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -80,6 +80,14 @@ enum {
 	UFSHCD_EH_DEVICE_RESET_PENDING = (1 << 1),
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
@@ -108,6 +116,7 @@ enum {
 
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
+static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -1527,9 +1536,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 		goto out;
 	}
 
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		scsi_unblock_requests(hba->host);
-
 out:
 	return err;
 }
@@ -1655,66 +1661,6 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
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
@@ -1731,6 +1677,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	sdev->use_10_for_ms = 1;
 	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
 
+	/* allow SCSI layer to restart the device in case of errors */
+	sdev->allow_restart = 1;
+
 	/*
 	 * Inform SCSI Midlayer that the LUN queue depth is same as the
 	 * controller queue depth. If a LUN queue depth is less than the
@@ -1934,6 +1883,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_ABORTED:
 		result |= DID_ABORT << 16;
 		break;
+	case OCS_INVALID_COMMAND_STATUS:
+		result |= DID_REQUEUE << 16;
+		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
 	case OCS_MISMATCH_DATA_BUF_SIZE:
@@ -2338,42 +2290,296 @@ out:
 	return err;
 }
 
+static void ufshcd_decide_eh_xfer_req(struct ufs_hba *hba, u32 ocs)
+{
+	switch (ocs) {
+	case OCS_SUCCESS:
+	case OCS_INVALID_COMMAND_STATUS:
+		break;
+	case OCS_MISMATCH_DATA_BUF_SIZE:
+	case OCS_MISMATCH_RESP_UPIU_SIZE:
+	case OCS_PEER_COMM_FAILURE:
+	case OCS_FATAL_ERROR:
+	case OCS_ABORTED:
+	case OCS_INVALID_CMD_TABLE_ATTR:
+	case OCS_INVALID_PRDT_ATTR:
+		ufshcd_set_host_reset_pending(hba);
+		break;
+	default:
+		dev_err(hba->dev, "%s: unknown OCS 0x%x\n",
+				__func__, ocs);
+		BUG();
+	}
+}
+
+static void ufshcd_decide_eh_task_req(struct ufs_hba *hba, u32 ocs)
+{
+	switch (ocs) {
+	case OCS_TMR_SUCCESS:
+	case OCS_TMR_INVALID_COMMAND_STATUS:
+		break;
+	case OCS_TMR_MISMATCH_REQ_SIZE:
+	case OCS_TMR_MISMATCH_RESP_SIZE:
+	case OCS_TMR_PEER_COMM_FAILURE:
+	case OCS_TMR_INVALID_ATTR:
+	case OCS_TMR_ABORTED:
+	case OCS_TMR_FATAL_ERROR:
+		ufshcd_set_host_reset_pending(hba);
+		break;
+	default:
+		dev_err(hba->dev, "%s: uknown TMR OCS 0x%x\n",
+				__func__, ocs);
+		BUG();
+	}
+}
+
 /**
- * ufshcd_fatal_err_handler - handle fatal errors
+ * ufshcd_error_autopsy_transfer_req() - reads OCS field of failed command and
+ *                          decide error handling
+ * @hba: per adapter instance
+ * @err_xfer: bit mask for transfer request errors
+ *
+ * Iterate over completed transfer requests and
+ * set error handling flags.
+ */
+static void
+ufshcd_error_autopsy_transfer_req(struct ufs_hba *hba, u32 *err_xfer)
+{
+	unsigned long completed;
+	u32 doorbell;
+	int index;
+	int ocs;
+
+	if (!err_xfer)
+		goto out;
+
+	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed = doorbell ^ (u32)hba->outstanding_reqs;
+
+	for (index = 0; index < hba->nutrs; index) {
+		if (test_bit(index, &completed)) {
+			ocs = ufshcd_get_tr_ocs(&hba->lrb[index]);
+			if ((ocs == OCS_SUCCESS) ||
+					(ocs == OCS_INVALID_COMMAND_STATUS))
+				continue;
+
+			*err_xfer |= (1 << index);
+			ufshcd_decide_eh_xfer_req(hba, ocs);
+		}
+	}
+out:
+	return;
+}
+
+/**
+ * ufshcd_error_autopsy_task_req() - reads OCS field of failed command and
+ *                          decide error handling
  * @hba: per adapter instance
+ * @err_tm: bit mask for task management errors
+ *
+ * Iterate over completed task management requests and
+ * set error handling flags.
+ */
+static void
+ufshcd_error_autopsy_task_req(struct ufs_hba *hba, u32 *err_tm)
+{
+	unsigned long completed;
+	u32 doorbell;
+	int index;
+	int ocs;
+
+	if (!err_tm)
+		goto out;
+
+	doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+	completed = doorbell ^ (u32)hba->outstanding_tasks;
+
+	for (index = 0; index < hba->nutmrs; index) {
+		if (test_bit(index, &completed)) {
+			struct utp_task_req_desc *tm_descp;
+
+			tm_descp = hba->utmrdl_base_addr;
+			ocs = ufshcd_get_tmr_ocs(&tm_descp[index]);
+			if ((ocs == OCS_TMR_SUCCESS) ||
+					(ocs == OCS_TMR_INVALID_COMMAND_STATUS))
+				continue;
+
+			*err_tm |= (1 << index);
+			ufshcd_decide_eh_task_req(hba, ocs);
+		}
+	}
+
+out:
+	return;
+}
+
+/**
+ * ufshcd_fatal_err_handler - handle fatal errors
+ * @work: pointer to work structure
  */
 static void ufshcd_fatal_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba;
+	unsigned long flags;
+	u32 err_xfer = 0;
+	u32 err_tm = 0;
+	int err;
+
 	hba = container_of(work, struct ufs_hba, feh_workq);
 
 	pm_runtime_get_sync(hba->dev);
-	/* check if reset is already in progress */
-	if (hba->ufshcd_state != UFSHCD_STATE_RESET)
-		ufshcd_do_reset(hba);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
+		/* complete processed requests and exit */
+		ufshcd_transfer_req_compl(hba);
+		ufshcd_tmc_handler(hba);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		pm_runtime_put_sync(hba->dev);
+		return;
+	}
+
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_error_autopsy_transfer_req(hba, &err_xfer);
+	ufshcd_error_autopsy_task_req(hba, &err_tm);
+
+	/*
+	 * Complete successful and pending transfer requests.
+	 * DID_REQUEUE is returned for pending requests as they have
+	 * nothing to do with error'ed request and SCSI layer should
+	 * not treat them as errors and decrement retry count.
+	 */
+	hba->outstanding_reqs &= ~err_xfer;
+	ufshcd_transfer_req_compl(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_complete_pending_reqs(hba);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->outstanding_reqs |= err_xfer;
+
+	/* Complete successful and pending task requests */
+	hba->outstanding_tasks &= ~err_tm;
+	ufshcd_tmc_handler(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_complete_pending_tasks(hba);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	hba->outstanding_tasks |= err_tm;
+
+	/*
+	 * Controller may generate multiple fatal errors, handle
+	 * errors based on severity.
+	 * 1) DEVICE_FATAL_ERROR
+	 * 2) SYSTEM_BUS/CONTROLLER_FATAL_ERROR
+	 * 3) UIC_ERROR
+	 */
+	if (hba->errors & DEVICE_FATAL_ERROR) {
+		/*
+		 * Some HBAs may not clear UTRLDBR/UTMRLDBR or update
+		 * OCS field on device fatal error.
+		 */
+		ufshcd_set_host_reset_pending(hba);
+	} else if (hba->errors & (SYSTEM_BUS_FATAL_ERROR |
+				CONTROLLER_FATAL_ERROR)) {
+		/* eh flags should be set in err autopsy based on OCS values */
+		if (!hba->eh_flags)
+			WARN(1, "%s: fatal error without error handling\n",
+				dev_name(hba->dev));
+	} else if (hba->errors & UIC_ERROR) {
+		if (hba->uic_error & UFSHCD_UIC_DL_PA_INIT_ERROR) {
+			/* fatal error - reset controller */
+			ufshcd_set_host_reset_pending(hba);
+		} else if (hba->uic_error & (UFSHCD_UIC_NL_ERROR |
+					UFSHCD_UIC_TL_ERROR |
+					UFSHCD_UIC_DME_ERROR)) {
+			/* non-fatal, report error to SCSI layer */
+			if (!hba->eh_flags) {
+				spin_unlock_irqrestore(
+						hba->host->host_lock, flags);
+				ufshcd_complete_pending_reqs(hba);
+				ufshcd_complete_pending_tasks(hba);
+				spin_lock_irqsave(hba->host->host_lock, flags);
+			}
+		}
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (hba->eh_flags) {
+		err = ufshcd_reset_and_restore(hba);
+		if (err) {
+			ufshcd_clear_host_reset_pending(hba);
+			ufshcd_clear_device_reset_pending(hba);
+			dev_err(hba->dev, "%s: reset and restore failed\n",
+					__func__);
+			hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		}
+		/*
+		 * Inform scsi mid-layer that we did reset and allow to handle
+		 * Unit Attention properly.
+		 */
+		scsi_report_bus_reset(hba->host, 0);
+		hba->errors = 0;
+		hba->uic_error = 0;
+	}
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
+ * ufshcd_err_handler - Check for fatal errors
+ * @hba: per-adapter instance
+ */
+static void ufshcd_err_handler(struct ufs_hba *hba)
+{
 	if (hba->errors & INT_FATAL_ERRORS)
 		goto fatal_eh;
 
 	if (hba->errors & UIC_ERROR) {
-		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
-		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+		hba->uic_error = 0;
+		ufshcd_update_uic_error(hba);
+		if (hba->uic_error)
 			goto fatal_eh;
 	}
+	/*
+	 * Other errors are either non-fatal or completed by the
+	 * controller by updating OCS fields with success/failure.
+	 */
 	return;
+
 fatal_eh:
 	/* handle fatal errors only when link is functional */
 	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
+		/* block commands from midlayer */
+		scsi_block_requests(hba->host);
+
 		/* block commands at driver layer until error is handled */
 		hba->ufshcd_state = UFSHCD_STATE_ERROR;
 		schedule_work(&hba->feh_workq);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1e0585c..47f54a2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -185,6 +185,7 @@ struct ufs_dev_cmd {
  * @feh_workq: Work queue for fatal controller error handling
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
+ * @uic_error: UFS interconnect layer error status
  * @dev_cmd: ufs device management command information
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  */
@@ -235,6 +236,7 @@ struct ufs_hba {
 
 	/* HBA Errors */
 	u32 errors;
+	u32 uic_error;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f1e1b74..36f68ef 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -264,7 +264,7 @@ enum {
 	UTP_DEVICE_TO_HOST	= 0x04000000,
 };
 
-/* Overall command status values */
+/* Overall command status values for transfer request */
 enum {
 	OCS_SUCCESS			= 0x0,
 	OCS_INVALID_CMD_TABLE_ATTR	= 0x1,
@@ -274,8 +274,21 @@ enum {
 	OCS_PEER_COMM_FAILURE		= 0x5,
 	OCS_ABORTED			= 0x6,
 	OCS_FATAL_ERROR			= 0x7,
-	OCS_INVALID_COMMAND_STATUS	= 0x0F,
-	MASK_OCS			= 0x0F,
+	OCS_INVALID_COMMAND_STATUS	= 0xF,
+	MASK_OCS			= 0xFF,
+};
+
+/* Overall command status values for task management request */
+enum {
+	OCS_TMR_SUCCESS			= 0x0,
+	OCS_TMR_INVALID_ATTR		= 0x1,
+	OCS_TMR_MISMATCH_REQ_SIZE	= 0x2,
+	OCS_TMR_MISMATCH_RESP_SIZE	= 0x3,
+	OCS_TMR_PEER_COMM_FAILURE	= 0x4,
+	OCS_TMR_ABORTED			= 0x5,
+	OCS_TMR_FATAL_ERROR		= 0x6,
+	OCS_TMR_INVALID_COMMAND_STATUS	= 0xF,
+	MASK_OCS_TMR			= 0xFF,
 };
 
 /**
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
