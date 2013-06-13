From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 2/4] scsi: ufs: Fix hardware race conditions while aborting a command
Date: Thu, 13 Jun 2013 20:00:58 +0530
Message-ID: <1371133860-17574-3-git-send-email-sthumma@codeaurora.org>
References: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3FMObY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 10:31:24 -0400
In-Reply-To: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

There is a possible race condition in the hardware when the abort
command is issued to terminate the ongoing SCSI command. It can happen
that when the abort command is issued, the device doesn't have the
command pending but just before the command is cleared in controller
the command is comitted to the device by h/w. In this case, the
command is still pending in the device but the host controller and
s/w assume it is aborted which can confuse the device h/w and further
operations might fail.

To avoid this, query task presence in the device before sending abort
task, task managment command so that after the abort operation, the
command is guaranteed to be non-existent in both controller and
the device.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |   71 ++++++++++++++++++++++++++++++++++----------
 1 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7d043f4..d576df2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2502,6 +2502,12 @@ static int ufshcd_host_reset(struct scsi_cmnd *cmd)
  * ufshcd_abort - abort a specific command
  * @cmd: SCSI command pointer
  *
+ * Abort the pending command in device by sending UFS_ABORT_TASK task management
+ * command, and in host controller by clearing the door-bell register. There can
+ * be race between controller sending the command to the device while abort is
+ * issued. To avoid that, first issue UFS_QUERY_TASK to check if the command is
+ * really issued and then try to abort it.
+ *
  * Returns SUCCESS/FAILED
  */
 static int ufshcd_abort(struct scsi_cmnd *cmd)
@@ -2510,7 +2516,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufs_hba *hba;
 	unsigned long flags;
 	unsigned int tag;
-	int err;
+	int err = 0;
+	int poll_cnt = 100;
 	u8 resp;
 	struct ufshcd_lrb *lrbp;
 
@@ -2518,37 +2525,69 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 
-	spin_lock_irqsave(host->host_lock, flags);
-
-	/* check if command is still pending */
-	if (!(test_bit(tag, &hba->outstanding_reqs))) {
-		err = FAILED;
-		spin_unlock_irqrestore(host->host_lock, flags);
+	/* If command is already aborted/completed, return SUCCESS */
+	if (!(test_bit(tag, &hba->outstanding_reqs)))
 		goto out;
-	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 
 	lrbp = &hba->lrb[tag];
+	for (;;) {
+		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
+				UFS_QUERY_TASK, &resp);
+		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
+			/* cmd pending in the device */
+			break;
+		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
+			u32 reg;
+
+			/*
+			 * cmd not pending in the device, check if it is
+			 * in transition.
+			 */
+			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+			if (reg & (1 << tag)) {
+				/* sleep for max. 2ms to stabilize */
+				usleep_range(1000, 2000);
+				if (poll_cnt) {
+					poll_cnt--;
+					continue;
+				}
+				err = -EBUSY;
+			}
+			/* command completed already */
+			goto out;
+		} else {
+			if (!err)
+				err = -EPERM; /* service response error */
+			goto out;
+		}
+	}
+
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 			UFS_ABORT_TASK, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		err = FAILED;
+		if (!err)
+			err = -EPERM; /* service response error */
 		goto out;
-	} else {
-		err = SUCCESS;
 	}
 
+	err = ufshcd_clear_cmd(hba, tag);
+	if (err)
+		goto out;
+
 	scsi_dma_unmap(cmd);
 
 	spin_lock_irqsave(host->host_lock, flags);
-
-	/* clear the respective UTRLCLR register bit */
-	ufshcd_utrl_clear(hba, tag);
-
 	__clear_bit(tag, &hba->outstanding_reqs);
 	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 out:
+	if (!err) {
+		err = SUCCESS;
+	} else {
+		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
+		err = FAILED;
+	}
+
 	return err;
 }
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

