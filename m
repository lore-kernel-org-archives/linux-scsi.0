From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/14] lpfc: Complete scsi commands after RRQ has completed
Date: Thu,  2 Jun 2016 16:39:16 +0200
Message-ID: <1464878356-42407-15-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161059AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The lpfc driver cannot re-use xri until RRQ after aborts has
completed. With this patch the scsi command remains valid until
RRQ has completed and only then scsi_done() is called.
This will cause an extended timeout for the command under abort,
but the driver will never re-use invalid xris.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ++++++----
 drivers/scsi/lpfc/lpfc_sli.c  | 14 +++++++++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 348cae6..bbba1c2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1084,7 +1084,6 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 	psb->prot_seg_cnt = 0;
 
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
-	psb->pCmd = NULL;
 	psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
@@ -1114,13 +1113,11 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 			return;
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
-		psb->pCmd = NULL;
 		list_add_tail(&psb->list,
 			&phba->sli4_hba.lpfc_abts_scsi_buf_list);
 		spin_unlock_irqrestore(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 	} else {
-		psb->pCmd = NULL;
 		psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 		if (phba->lpfc_scsi_buf_arr)
 			clear_bit(LPFC_CMD_QUEUED, &psb->flags);
@@ -4166,8 +4163,13 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	 * release the scsi_buf before calling 'done', thereby
 	 * avoiding a race condition between aborts and scsi_done
 	 */
-	if (shost->hostt->abort_completions)
+	if (shost->hostt->abort_completions) {
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		if (test_bit(LPFC_CMD_EXCH_BUSY, &lpfc_cmd->flags) &&
+		    test_bit(LPFC_CMD_ABORTED, &lpfc_cmd->flags))
+			return;
+		lpfc_cmd->pCmd = NULL;
+	}
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
 	cmd->scsi_done(cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e5cd212..01b55c2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -662,6 +662,7 @@ lpfc_clr_rrq_active(struct lpfc_hba *phba,
 		int i;
 		struct lpfc_iocbq *iocbq;
 		struct lpfc_scsi_buf *psb;
+		struct scsi_cmnd *cmd;
 
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		for (i = 1; i <= phba->sli.last_iotag; i++) {
@@ -674,7 +675,18 @@ lpfc_clr_rrq_active(struct lpfc_hba *phba,
 
 			psb = container_of(iocbq, struct lpfc_scsi_buf,
 					   cur_iocbq);
-			clear_bit(LPFC_CMD_RRQ_ACTIVE, &psb->flags);
+			if (!test_and_clear_bit(LPFC_CMD_RRQ_ACTIVE,
+					       &psb->flags))
+				continue;
+
+			cmd = psb->pCmd;
+			if (cmd) {
+				psb->pCmd = NULL;
+				if (!cmd->result)
+					cmd->result = ScsiResult(DID_ABORT,
+							SAM_STAT_TASK_ABORTED);
+				cmd->scsi_done(cmd);
+			}
 			break;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
-- 
1.8.5.6

