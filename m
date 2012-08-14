From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/12] lpfc 8.3.34: Correct lock handling to eliminate reset
 escalation on I/O abort
Date: Tue, 14 Aug 2012 14:26:28 -0400
Message-ID: <1344968788.4432.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24950 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2HNS0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct lock handling to eliminate reset escalation on I/O abort


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.431924247 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.657924240 -0400
@@ -3829,12 +3829,15 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		spin_lock_irq(&phba->hbalock);
+		lpfc_cmd->pCmd = NULL;
+		spin_unlock_irq(&phba->hbalock);
+
 		/*
 		 * If there is a thread waiting for command completion
 		 * wake up the thread.
 		 */
 		spin_lock_irqsave(shost->host_lock, flags);
-		lpfc_cmd->pCmd = NULL;
 		if (lpfc_cmd->waitq)
 			wake_up(lpfc_cmd->waitq);
 		spin_unlock_irqrestore(shost->host_lock, flags);
@@ -3868,12 +3871,15 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 		}
 	}
 
+	spin_lock_irq(&phba->hbalock);
+	lpfc_cmd->pCmd = NULL;
+	spin_unlock_irq(&phba->hbalock);
+
 	/*
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
 	 */
 	spin_lock_irqsave(shost->host_lock, flags);
-	lpfc_cmd->pCmd = NULL;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -4409,7 +4415,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	}
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
-	if (!lpfc_cmd) {
+	if (!lpfc_cmd || !lpfc_cmd->pCmd) {
 		spin_unlock_irq(&phba->hbalock);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "



