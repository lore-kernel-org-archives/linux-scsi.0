From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/10] lpfc 8.2.4 : Correct abort handler logic
Date: Fri, 11 Jan 2008 01:52:42 -0500
Message-ID: <1200034362.27954.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51501 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYAKGwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:52:45 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6qhwl021634
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:52:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct Abort handler logic. It was unconditionally waiting a minimum
of 2 seconds rather than looking for abort completion.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-11-09 15:54:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-01-11 00:52:16.000000000 -0500
@@ -542,6 +542,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	int result;
 	struct scsi_device *sdev, *tmp_sdev;
 	int depth = 0;
+	unsigned long flags;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -608,6 +609,15 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		/*
+		 * If there is a thread waiting for command completion
+		 * wake up the thread.
+		 */
+		spin_lock_irqsave(sdev->host->host_lock, flags);
+		lpfc_cmd->pCmd = NULL;
+		if (lpfc_cmd->waitq)
+			wake_up(lpfc_cmd->waitq);
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
@@ -669,6 +679,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		}
 	}
 
+	/*
+	 * If there is a thread waiting for command completion
+	 * wake up the thread.
+	 */
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	lpfc_cmd->pCmd = NULL;
+	if (lpfc_cmd->waitq)
+		wake_up(lpfc_cmd->waitq);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
@@ -1018,8 +1038,13 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	IOCB_t *cmd, *icmd;
-	unsigned int loop_count = 0;
 	int ret = SUCCESS;
+#ifdef DECLARE_WAIT_QUEUE_HEAD_ONSTACK
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
+#else
+	DECLARE_WAIT_QUEUE_HEAD(waitq);
+#endif
+
 
 	lpfc_block_error_handler(cmnd);
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
@@ -1074,17 +1099,15 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_poll_fcp_ring (phba);
 
+	lpfc_cmd->waitq = &waitq;
 	/* Wait for abort to complete */
-	while (lpfc_cmd->pCmd == cmnd)
-	{
-		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
-			lpfc_sli_poll_fcp_ring (phba);
+	wait_event_timeout(waitq,
+			  (lpfc_cmd->pCmd != cmnd),
+			   (2*vport->cfg_devloss_tmo*HZ));
 
-		schedule_timeout_uninterruptible(LPFC_ABORT_WAIT * HZ);
-		if (++loop_count
-		    > (2 * vport->cfg_devloss_tmo)/LPFC_ABORT_WAIT)
-			break;
-	}
+	spin_lock_irq(shost->host_lock);
+	lpfc_cmd->waitq = NULL;
+	spin_unlock_irq(shost->host_lock);
 
 	if (lpfc_cmd->pCmd == cmnd) {
 		ret = FAILED;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2008-01-11 00:52:16.000000000 -0500
@@ -138,6 +138,7 @@ struct lpfc_scsi_buf {
 	 * Iotag is in here
 	 */
 	struct lpfc_iocbq cur_iocbq;
+	wait_queue_head_t *waitq;
 };
 
 #define LPFC_SCSI_DMA_EXT_SIZE 264


