From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/11] lpfc 10.2.8000.0: Fixed kernel panic in
 lpfc_abort_handler
Date: Fri, 4 Apr 2014 13:51:53 -0400
Message-ID: <1396633913.1924.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53476 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaDDRv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:51:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed kernel panic in lpfc_abort_handler


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    5 ++++-
 lpfc_scsi.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:21.152308548 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:22.340308608 -0400
@@ -4664,7 +4664,10 @@ lpfc_reset_hba(struct lpfc_hba *phba)
 		phba->link_state = LPFC_HBA_ERROR;
 		return;
 	}
-	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
+	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
+		lpfc_offline_prep(phba, LPFC_MBX_WAIT);
+	else
+		lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
 	lpfc_online(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2014-04-03 10:24:16.597308319 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2014-04-03 10:24:22.342308608 -0400
@@ -4834,6 +4834,14 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	BUG_ON(iocb->context1 != lpfc_cmd);
 
+	/* abort issued in recovery is still in progress */
+	if (iocb->iocb_flag & LPFC_DRIVER_ABORTED) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+			 "3389 SCSI Layer I/O Abort Request is pending\n");
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		goto wait_for_cmpl;
+	}
+
 	abtsiocb = __lpfc_sli_get_iocbq(phba);
 	if (abtsiocb == NULL) {
 		ret = FAILED;
@@ -4886,12 +4894,16 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
+wait_for_cmpl:
 	lpfc_cmd->waitq = &waitq;
 	/* Wait for abort to complete */
 	wait_event_timeout(waitq,
 			  (lpfc_cmd->pCmd != cmnd),
 			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
+
+	spin_lock_irqsave(shost->host_lock, flags);
 	lpfc_cmd->waitq = NULL;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (lpfc_cmd->pCmd == cmnd) {
 		ret = FAILED;



