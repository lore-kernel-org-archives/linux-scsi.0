From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/4] scsi: ufs: Fix hardware race conditions while aborting a command
Date: Wed, 14 Aug 2013 22:40:10 +0530
Message-ID: <1376500212-29572-3-git-send-email-santoshsy@gmail.com>
References: <1376500212-29572-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38497 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095Ab3HNRLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 13:11:03 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so5720789pab.36
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2013 10:11:02 -0700 (PDT)
In-Reply-To: <1376500212-29572-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

There is a possible race condition in the hardware when the abort
command is issued to terminate the ongoing SCSI command as described
below:

- A bit in the door-bell register is set in the controller for a
  new SCSI command.
- In some rare situations, before controller get a chance to issue
  the command to the device, the software issued an abort command.
- If the device recieves abort command first then it returns success
  because the command itself is not present.
- Now if the controller commits the command to device it will be
  processed.
- Software thinks that command is aborted and proceed while still
  the device is processing it.
- The software, controller and device may go out of sync because of
  this race condition.

To avoid this, query task presence in the device before sending abort
task command so that after the abort operation, the command is guaranteed
to be non-existent in both controller and the device.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e0810a3..24c5ab3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2485,6 +2485,12 @@ static int ufshcd_host_reset(struct scsi_cmnd *cmd)
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
@@ -2493,7 +2499,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufs_hba *hba;
 	unsigned long flags;
 	unsigned int tag;
-	int err;
+	int err = 0;
+	int poll_cnt;
 	u8 resp = 0xF;
 	struct ufshcd_lrb *lrbp;
 
@@ -2501,33 +2508,59 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	/* If command is already aborted/completed, return SUCCESS */
+	if (!(test_bit(tag, &hba->outstanding_reqs)))
+		goto out;
 
-	/* check if command is still pending */
-	if (!(test_bit(tag, &hba->outstanding_reqs))) {
-		err = FAILED;
-		spin_unlock_irqrestore(host->host_lock, flags);
+	lrbp = &hba->lrb[tag];
+	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
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
+				/* sleep for max. 200us to stabilize */
+				usleep_range(100, 200);
+				continue;
+			}
+			/* command completed already */
+			goto out;
+		} else {
+			if (!err)
+				err = resp; /* service response error */
+			goto out;
+		}
+	}
+
+	if (!poll_cnt) {
+		err = -EBUSY;
 		goto out;
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 
-	lrbp = &hba->lrb[tag];
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
 			UFS_ABORT_TASK, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-		err = FAILED;
+		if (!err)
+			err = resp; /* service response error */
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
@@ -2535,6 +2568,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	clear_bit_unlock(tag, &hba->lrb_in_use);
 	wake_up(&hba->dev_cmd.tag_wq);
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
1.8.3.4

