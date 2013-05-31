From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/17] lpfc 8.3.40: Fixed issue mailbox wait routine failed
 to issue dump memory mbox command
Date: Fri, 31 May 2013 17:05:27 -0400
Message-ID: <1370034327.17258.36.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5809 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab3EaVMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:12:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed issue mailbox wait routine failed to issue dump memory mbox command


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:21.732057717 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:27.353057845 -0400
@@ -10092,12 +10092,13 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 			 uint32_t timeout)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(done_q);
+	MAILBOX_t *mb = NULL;
 	int retval;
 	unsigned long flag;
 
-	/* The caller must leave context1 empty. */
+	/* The caller might set context1 for extended buffer */
 	if (pmboxq->context1)
-		return MBX_NOT_FINISHED;
+		mb = (MAILBOX_t *)pmboxq->context1;
 
 	pmboxq->mbox_flag &= ~LPFC_MBX_WAKE;
 	/* setup wake call as IOCB callback */
@@ -10113,7 +10114,8 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 				msecs_to_jiffies(timeout * 1000));
 
 		spin_lock_irqsave(&phba->hbalock, flag);
-		pmboxq->context1 = NULL;
+		/* restore the possible extended buffer for free resource */
+		pmboxq->context1 = (uint8_t *)mb;
 		/*
 		 * if LPFC_MBX_WAKE flag is set the mailbox is completed
 		 * else do not free the resources.
@@ -10126,6 +10128,9 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flag);
+	} else {
+		/* restore the possible extended buffer for free resource */
+		pmboxq->context1 = (uint8_t *)mb;
 	}
 
 	return retval;



