From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/21] lpfc 8.3.30: Fixed the system panic during EEH
 recovery
Date: Thu, 1 Mar 2012 22:36:29 -0500
Message-ID: <1330659391.18500.37.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38856 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121Ab2CBDgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:36:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed the system panic during EEH recovery


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:43.000000000 -0500
@@ -7252,11 +7252,13 @@ lpfc_sli4_post_async_mbox(struct lpfc_hb
 
 out_not_finished:
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	mboxq->u.mb.mbxStatus = MBX_NOT_FINISHED;
-	__lpfc_mbox_cmpl_put(phba, mboxq);
-	/* Release the token */
-	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-	phba->sli.mbox_active = NULL;
+	if (phba->sli.mbox_active) {
+		mboxq->u.mb.mbxStatus = MBX_NOT_FINISHED;
+		__lpfc_mbox_cmpl_put(phba, mboxq);
+		/* Release the token */
+		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		phba->sli.mbox_active = NULL;
+	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	return MBX_NOT_FINISHED;
@@ -9818,12 +9820,11 @@ lpfc_sli_mbox_sys_shutdown(struct lpfc_h
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
+
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
-	spin_unlock_irq(&phba->hbalock);
 
 	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
-		spin_lock_irq(&phba->hbalock);
 		/* Determine how long we might wait for the active mailbox
 		 * command to be gracefully completed by firmware.
 		 */
@@ -9842,7 +9843,9 @@ lpfc_sli_mbox_sys_shutdown(struct lpfc_h
 				 */
 				break;
 		}
-	}
+	} else
+		spin_unlock_irq(&phba->hbalock);
+
 	lpfc_sli_mbox_sys_flush(phba);
 }
 



