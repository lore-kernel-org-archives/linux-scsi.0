From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/17] lpfc 8.3.40: Fixed list corruption when lpfc_drain_tx
 runs.
Date: Fri, 31 May 2013 17:04:19 -0400
Message-ID: <1370034259.17258.29.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21373 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3EaVKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:10:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed list corruption when lpfc_drain_tx runs.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:16.738057604 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:19.924057676 -0400
@@ -16286,7 +16286,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	union lpfc_wqe wqe;
 	int txq_cnt = 0;
 
-	spin_lock_irqsave(&phba->hbalock, iflags);
+	spin_lock_irqsave(&pring->ring_lock, iflags);
 	list_for_each_entry(piocbq, &pring->txq, list) {
 		txq_cnt++;
 	}
@@ -16294,14 +16294,14 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	if (txq_cnt > pring->txq_max)
 		pring->txq_max = txq_cnt;
 
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
 	while (!list_empty(&pring->txq)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
+		spin_lock_irqsave(&pring->ring_lock, iflags);
 
 		piocbq = lpfc_sli_ringtx_get(phba, pring);
 		if (!piocbq) {
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2823 txq empty and txq_cnt is %d\n ",
 				txq_cnt);
@@ -16310,7 +16310,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		sglq = __lpfc_sli_get_sglq(phba, piocbq);
 		if (!sglq) {
 			__lpfc_sli_ringtx_put(phba, pring, piocbq);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
 			break;
 		}
 		txq_cnt--;
@@ -16338,7 +16338,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
 		}
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
 
 	/* Cancel all the IOCBs that cannot be issued */



