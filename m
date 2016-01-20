From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] lpfc: Remove redundant code block in lpfc_scsi_cmd_iocb_cmpl
Date: Wed, 20 Jan 2016 16:08:40 +0100
Message-ID: <1453302520-10499-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This removes a redundant code block that will either be executed if the
ENABLE_FCP_RING_POLLING flag is set in phba->cfg_poll or not. The code is just
duplicated in both cases, hence we unify it again.

This probably is a left over from some sort of refactoring.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 152b3c8..3bd0be6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4139,23 +4139,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
 	cmd->scsi_done(cmd);
 
-	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_lock_irqsave(&phba->hbalock, flags);
-		lpfc_cmd->pCmd = NULL;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-
-		/*
-		 * If there is a thread waiting for command completion
-		 * wake up the thread.
-		 */
-		spin_lock_irqsave(shost->host_lock, flags);
-		if (lpfc_cmd->waitq)
-			wake_up(lpfc_cmd->waitq);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		lpfc_release_scsi_buf(phba, lpfc_cmd);
-		return;
-	}
-
 	spin_lock_irqsave(&phba->hbalock, flags);
 	lpfc_cmd->pCmd = NULL;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-- 
2.7.0
