From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: Fix race on command completion
Date: Fri, 15 Jan 2016 10:48:23 +0100
Message-ID: <1452851303-89378-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbcAOJs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 04:48:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Upon command completion the lpfc driver would call ->done()
on the scsi command before taking the host lock and
releasing the command internally.
This opens up a race window there this command might be re-used
after ->done(), leading to a double completion on the same command.

This patch takes the host lock before accessing the scsi command,
and disconnect the internal command under the same lock.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4679ed4..974af28 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3908,9 +3908,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	uint32_t logit = LOG_FCP;
 
 	/* Sanity check on return of outstanding command */
-	if (!(lpfc_cmd->pCmd))
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (!(lpfc_cmd->pCmd)) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
+	}
 	cmd = lpfc_cmd->pCmd;
+	cmd->host_scribble = NULL;
+	lpfc_cmd->pCmd = NULL;
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
 	shost = cmd->device->host;
 
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
@@ -4125,10 +4132,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_lock_irqsave(&phba->hbalock, flags);
-		lpfc_cmd->pCmd = NULL;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-
 		/*
 		 * If there is a thread waiting for command completion
 		 * wake up the thread.
@@ -4141,10 +4144,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		return;
 	}
 
-	spin_lock_irqsave(&phba->hbalock, flags);
-	lpfc_cmd->pCmd = NULL;
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-
 	/*
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
-- 
1.8.5.6

