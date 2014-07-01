From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 1/3] scsi: ufs: read door bell register after clearing interrupt aggregation
Date: Tue,  1 Jul 2014 12:22:37 +0300
Message-ID: <1404206559-21445-2-git-send-email-draviv@codeaurora.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39321 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbaGAJXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 05:23:02 -0400
In-Reply-To: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

In interrupt context, after reading and comparing the UTRLDBR to
hba->outstanding_request and before resetting the interrupt aggregation,
there might be completion of another transfer request (TR). Such TRs might
get stuck, pending, until the next interrupt is generated (if any).
Changing the sequence of resetting the interrupt aggregation first and
then reading UTRLDBR status, will assure that completed TRs won't get
stuck pending.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 67 ++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b103e95..b533ff8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2231,47 +2231,42 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	u32 tr_doorbell;
 	int result;
 	int index;
-	bool int_aggr_reset = false;
+
+	/* Resetting interrupt aggregation counters first and reading the
+	 * DOOR_BELL afterward allows us to handle all the completed requests.
+	 * In order to prevent other interrupts starvation the DB is read once
+	 * after reset. The down side of this solution is the possibility of
+	 * false interrupt if device completes another request after resetting
+	 * aggregation and before reading the DB.
+	 */
+	ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
 
-	for (index = 0; index < hba->nutrs; index++) {
-		if (test_bit(index, &completed_reqs)) {
-			lrbp = &hba->lrb[index];
-			cmd = lrbp->cmd;
-			/*
-			 * Don't skip resetting interrupt aggregation counters
-			 * if a regular command is present.
-			 */
-			int_aggr_reset |= !lrbp->intr_cmd;
-
-			if (cmd) {
-				result = ufshcd_transfer_rsp_status(hba, lrbp);
-				scsi_dma_unmap(cmd);
-				cmd->result = result;
-				/* Mark completed command as NULL in LRB */
-				lrbp->cmd = NULL;
-				clear_bit_unlock(index, &hba->lrb_in_use);
-				/* Do not touch lrbp after scsi done */
-				cmd->scsi_done(cmd);
-			} else if (lrbp->command_type ==
-					UTP_CMD_TYPE_DEV_MANAGE) {
-				if (hba->dev_cmd.complete)
-					complete(hba->dev_cmd.complete);
-			}
-		} /* end of if */
-	} /* end of for */
+	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
+		lrbp = &hba->lrb[index];
+		cmd = lrbp->cmd;
+		if (cmd) {
+			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			scsi_dma_unmap(cmd);
+			cmd->result = result;
+			/* Mark completed command as NULL in LRB */
+			lrbp->cmd = NULL;
+			clear_bit_unlock(index, &hba->lrb_in_use);
+			/* Do not touch lrbp after scsi done */
+			cmd->scsi_done(cmd);
+		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
+			if (hba->dev_cmd.complete)
+				complete(hba->dev_cmd.complete);
+		}
+	}
 
 	/* clear corresponding bits of completed commands */
 	hba->outstanding_reqs ^= completed_reqs;
 
 	/* we might have free'd some tags above */
 	wake_up(&hba->dev_cmd.tag_wq);
-
-	/* Reset interrupt aggregation counters */
-	if (int_aggr_reset)
-		ufshcd_reset_intr_aggr(hba);
 }
 
 /**
@@ -2876,6 +2871,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	int poll_cnt;
 	u8 resp = 0xF;
 	struct ufshcd_lrb *lrbp;
+	u32 reg;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
@@ -2885,6 +2881,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	if (!(test_bit(tag, &hba->outstanding_reqs)))
 		goto out;
 
+	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	if (!(reg & (1 << tag))) {
+		dev_err(hba->dev,
+		"%s: cmd was completed, but without a notifying intr, tag = %d",
+		__func__, tag);
+	}
+
 	lrbp = &hba->lrb[tag];
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
@@ -2893,8 +2896,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 			/* cmd pending in the device */
 			break;
 		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
-			u32 reg;
-
 			/*
 			 * cmd not pending in the device, check if it is
 			 * in transition.
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

