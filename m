From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/14] lpfc: do not wait for completion when aborting commands
Date: Thu,  2 Jun 2016 16:39:07 +0200
Message-ID: <1464878356-42407-6-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The current synchronization between lpfc_scsi_cmd_iocb_cmpl()
and lpfc_abort_handler() requires us to take two spin_locks,
which kills performance for high end setups.

Looking at it, the synchronization is done for two reasons:
- Avoiding an abort for a command which is already completed
- Waiting for the completion to finish before proceeding

However, in both cases we rely on a completion to come in
for _both_ commands, the original and the abort TMF.
So there is no need to wait for the completion of the TMF;
once the TMF is underway we will be getting a completion for
both.

So we can check if the 'abort_completions' flag is set in the
host template and do away with these synchronisation points
altogether to speed up I/O processing.

At the same time the original code is left in place so one can
select the original behaviour by simply disabling the
'abort_completions' host template flag.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 80 +++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fde5b00..fab387c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4133,23 +4133,32 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
+	/*
+	 * If the 'abort_completions' flag is set we can
+	 * release the scsi_buf before calling 'done', thereby
+	 * avoiding a race condition between aborts and scsi_done
+	 */
+	if (shost->hostt->abort_completions)
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
 	cmd->scsi_done(cmd);
 
-	spin_lock_irqsave(&phba->hbalock, flags);
-	lpfc_cmd->pCmd = NULL;
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-
-	/*
-	 * If there is a thread waiting for command completion
-	 * wake up the thread.
-	 */
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (lpfc_cmd->waitq)
-		wake_up(lpfc_cmd->waitq);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (!shost->hostt->abort_completions) {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		lpfc_cmd->pCmd = NULL;
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	lpfc_release_scsi_buf(phba, lpfc_cmd);
+		/*
+		 * If there is a thread waiting for command completion
+		 * wake up the thread.
+		 */
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (lpfc_cmd->waitq)
+			wake_up(lpfc_cmd->waitq);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+	}
 }
 
 /**
@@ -4677,7 +4686,6 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_sli_ring *pring_s4;
 	int ring_number, ret_val;
 	unsigned long flags, iflags;
-	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	status = fc_block_scsi_eh(cmnd);
 	if (status != 0 && status != SUCCESS)
@@ -4690,7 +4698,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3168 SCSI Layer abort requested I/O has been "
 			"flushed by LLD.\n");
-		return FAILED;
+		return shost->hostt->abort_completions ? SUCCESS : FAILED;
 	}
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
@@ -4700,7 +4708,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %llu\n",
 			 SUCCESS, cmnd->device->id, cmnd->device->lun);
-		return SUCCESS;
+		return shost->hostt->abort_completions ? SUCCESS : FAILED;
 	}
 
 	iocb = &lpfc_cmd->cur_iocbq;
@@ -4710,7 +4718,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3169 SCSI Layer abort requested I/O has been "
 			"cancelled by LLD.\n");
-		return FAILED;
+		return shost->hostt->abort_completions ? SUCCESS : FAILED;
 	}
 	/*
 	 * If pCmd field of the corresponding lpfc_scsi_buf structure
@@ -4802,24 +4810,28 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 wait_for_cmpl:
-	lpfc_cmd->waitq = &waitq;
-	/* Wait for abort to complete */
-	wait_event_timeout(waitq,
-			  (lpfc_cmd->pCmd != cmnd),
-			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
+	if (!shost->hostt->abort_completions) {
+		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	lpfc_cmd->waitq = NULL;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+		lpfc_cmd->waitq = &waitq;
+		/* Wait for abort to complete */
+		wait_event_timeout(waitq,
+			(lpfc_cmd->pCmd != cmnd),
+			msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
 
-	if (lpfc_cmd->pCmd == cmnd) {
-		ret = FAILED;
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "0748 abort handler timed out waiting "
-				 "for abortng I/O (xri:x%x) to complete: "
-				 "ret %#x, ID %d, LUN %llu\n",
-				 iocb->sli4_xritag, ret,
-				 cmnd->device->id, cmnd->device->lun);
+		spin_lock_irqsave(shost->host_lock, flags);
+		lpfc_cmd->waitq = NULL;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		if (lpfc_cmd->pCmd == cmnd) {
+			ret = FAILED;
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				"0748 abort handler timed out waiting "
+				"for abortng I/O (xri:x%x) to complete: "
+				"ret %#x, ID %d, LUN %llu\n",
+				iocb->sli4_xritag, ret,
+				cmnd->device->id, cmnd->device->lun);
+		}
 	}
 	goto out;
 
@@ -5927,6 +5939,7 @@ struct scsi_host_template lpfc_template = {
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
+	.abort_completions	= 1,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -5950,4 +5963,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
+	.abort_completions	= 1,
 };
-- 
1.8.5.6

