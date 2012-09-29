From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/16] lpfc 8.3.35: Fixed kernel warning on spinlock usage
 on some distributions
Date: Sat, 29 Sep 2012 11:31:28 -0400
Message-ID: <1348932688.23909.29.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33788 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2I2PhC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:37:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed kernel warning on spinlock usage on some distributions


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-09-26 21:11:42.521154049 -0400
@@ -3829,9 +3829,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, flags);
 		lpfc_cmd->pCmd = NULL;
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 
 		/*
 		 * If there is a thread waiting for command completion
@@ -3871,9 +3871,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 		}
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, flags);
 	lpfc_cmd->pCmd = NULL;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	/*
 	 * If there is a thread waiting for command completion
@@ -4398,16 +4398,17 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	struct lpfc_scsi_buf *lpfc_cmd;
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
+	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	status = fc_block_scsi_eh(cmnd);
 	if (status != 0 && status != SUCCESS)
 		return status;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, flags);
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_FCP_IOQ_FLUSH) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3168 SCSI Layer abort requested I/O has been "
 			"flushed by LLD.\n");
@@ -4416,7 +4417,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	if (!lpfc_cmd || !lpfc_cmd->pCmd) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %d\n",
@@ -4427,7 +4428,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	iocb = &lpfc_cmd->cur_iocbq;
 	/* the command is in process of being cancelled */
 	if (!(iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3169 SCSI Layer abort requested I/O has been "
 			"cancelled by LLD.\n");
@@ -4484,7 +4485,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
 	/* no longer need the lock after this point */
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	if (lpfc_sli_issue_iocb(phba, LPFC_FCP_RING, abtsiocb, 0) ==
 	    IOCB_ERROR) {
@@ -4516,7 +4517,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	goto out;
 
 out_unlock:
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "



