From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 08/17] scsi: ufs: make error handling bit faster
Date: Tue,  8 Mar 2016 14:35:59 +0200
Message-ID: <1457440568-13084-9-git-send-email-ygardi@codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

UFS driver's error handler forcefully tries to clear all the pending
requests. For each pending request in the queue, it waits 1 sec for it
to get cleared. If we have multiple requests in the queue then it's
possible that we might end up waiting for those many seconds before
resetting the host. But note that resetting host would any way clear
all the pending requests from the hardware. Hence this change skips
the forceful clear of the pending requests if we are anyway going to
reset the host (for fatal errors).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 155 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 112 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 987cf27..dc096f1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -133,9 +133,11 @@ enum {
 /* UFSHCD UIC layer error flags */
 enum {
 	UFSHCD_UIC_DL_PA_INIT_ERROR = (1 << 0), /* Data link layer error */
-	UFSHCD_UIC_NL_ERROR = (1 << 1), /* Network layer error */
-	UFSHCD_UIC_TL_ERROR = (1 << 2), /* Transport Layer error */
-	UFSHCD_UIC_DME_ERROR = (1 << 3), /* DME error */
+	UFSHCD_UIC_DL_NAC_RECEIVED_ERROR = (1 << 1), /* Data link layer error */
+	UFSHCD_UIC_DL_TCx_REPLAY_ERROR = (1 << 2), /* Data link layer error */
+	UFSHCD_UIC_NL_ERROR = (1 << 3), /* Network layer error */
+	UFSHCD_UIC_TL_ERROR = (1 << 4), /* Transport Layer error */
+	UFSHCD_UIC_DME_ERROR = (1 << 5), /* DME error */
 };
 
 /* Interrupt configuration options */
@@ -3465,31 +3467,18 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 }
 
 /**
- * ufshcd_transfer_req_compl - handle SCSI and query command completion
+ * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
+ * @completed_reqs: requests to complete
  */
-static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
+					unsigned long completed_reqs)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
-	unsigned long completed_reqs;
-	u32 tr_doorbell;
 	int result;
 	int index;
 
-	/* Resetting interrupt aggregation counters first and reading the
-	 * DOOR_BELL afterward allows us to handle all the completed requests.
-	 * In order to prevent other interrupts starvation the DB is read once
-	 * after reset. The down side of this solution is the possibility of
-	 * false interrupt if device completes another request after resetting
-	 * aggregation and before reading the DB.
-	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
-		ufshcd_reset_intr_aggr(hba);
-
-	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
@@ -3519,6 +3508,31 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_transfer_req_compl - handle SCSI and query command completion
+ * @hba: per adapter instance
+ */
+static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
+{
+	unsigned long completed_reqs;
+	u32 tr_doorbell;
+
+	/* Resetting interrupt aggregation counters first and reading the
+	 * DOOR_BELL afterward allows us to handle all the completed requests.
+	 * In order to prevent other interrupts starvation the DB is read once
+	 * after reset. The down side of this solution is the possibility of
+	 * false interrupt if device completes another request after resetting
+	 * aggregation and before reading the DB.
+	 */
+	if (ufshcd_is_intr_aggr_allowed(hba))
+		ufshcd_reset_intr_aggr(hba);
+
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+
+	__ufshcd_transfer_req_compl(hba, completed_reqs);
+}
+
+/**
  * ufshcd_disable_ee - disable exception event
  * @hba: per-adapter instance
  * @mask: exception event to disable
@@ -3773,6 +3787,13 @@ out:
 	return;
 }
 
+/* Complete requests that have door-bell cleared */
+static void ufshcd_complete_requests(struct ufs_hba *hba)
+{
+	ufshcd_transfer_req_compl(hba);
+	ufshcd_tmc_handler(hba);
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -3785,6 +3806,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	u32 err_tm = 0;
 	int err = 0;
 	int tag;
+	bool needs_reset = false;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -3792,40 +3814,75 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		goto out;
-	}
 
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 	ufshcd_set_eh_in_progress(hba);
 
 	/* Complete requests that have door-bell cleared by h/w */
-	ufshcd_transfer_req_compl(hba);
-	ufshcd_tmc_handler(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_complete_requests(hba);
+	if ((hba->saved_err & INT_FATAL_ERRORS) ||
+	    ((hba->saved_err & UIC_ERROR) &&
+	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
+				   UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
+				   UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
+		needs_reset = true;
 
+	/*
+	 * if host reset is required then skip clearing the pending
+	 * transfers forcefully because they will automatically get
+	 * cleared after link startup.
+	 */
+	if (needs_reset)
+		goto skip_pending_xfer_clear;
+
+	/* release lock as clear command might sleep */
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Clear pending transfer requests */
-	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs)
-		if (ufshcd_clear_cmd(hba, tag))
-			err_xfer |= 1 << tag;
+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
+		if (ufshcd_clear_cmd(hba, tag)) {
+			err_xfer = true;
+			goto lock_skip_pending_xfer_clear;
+		}
+	}
 
 	/* Clear pending task management requests */
-	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs)
-		if (ufshcd_clear_tm_cmd(hba, tag))
-			err_tm |= 1 << tag;
+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
+		if (ufshcd_clear_tm_cmd(hba, tag)) {
+			err_tm = true;
+			goto lock_skip_pending_xfer_clear;
+		}
+	}
 
-	/* Complete the requests that are cleared by s/w */
+lock_skip_pending_xfer_clear:
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_transfer_req_compl(hba);
-	ufshcd_tmc_handler(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	/* Complete the requests that are cleared by s/w */
+	ufshcd_complete_requests(hba);
+
+	if (err_xfer || err_tm)
+		needs_reset = true;
+
+skip_pending_xfer_clear:
 	/* Fatal errors need reset */
-	if (err_xfer || err_tm || (hba->saved_err & INT_FATAL_ERRORS) ||
-			((hba->saved_err & UIC_ERROR) &&
-			 (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR))) {
+	if (needs_reset) {
+		unsigned long max_doorbells = (1UL << hba->nutrs) - 1;
+
+		/*
+		 * ufshcd_reset_and_restore() does the link reinitialization
+		 * which will need atleast one empty doorbell slot to send the
+		 * device management commands (NOP and query commands).
+		 * If there is no slot empty at this moment then free up last
+		 * slot forcefully.
+		 */
+		if (hba->outstanding_reqs == max_doorbells)
+			__ufshcd_transfer_req_compl(hba,
+						    (1UL << (hba->nutrs - 1)));
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		if (err) {
 			dev_err(hba->dev, "%s: reset and restore failed\n",
 					__func__);
@@ -3839,9 +3896,18 @@ static void ufshcd_err_handler(struct work_struct *work)
 		hba->saved_err = 0;
 		hba->saved_uic_err = 0;
 	}
+
+	if (!needs_reset) {
+		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		if (hba->saved_err || hba->saved_uic_err)
+			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
+			    __func__, hba->saved_err, hba->saved_uic_err);
+	}
+
 	ufshcd_clear_eh_in_progress(hba);
 
 out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	scsi_unblock_requests(hba->host);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
@@ -3896,15 +3962,18 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
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
 			schedule_work(&hba->eh_work);
 		}
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
