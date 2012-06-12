From: James Smart <james.smart@emulex.com>
Subject: [PATCH 02/10] lpfc 8.3.32: Correct Smatch Error in lpfc_sli.c
Date: Tue, 12 Jun 2012 13:54:11 -0400
Message-ID: <1339523651.2162.2.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17641 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540Ab2FLRyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch corrects the issue caught vi Smatch and reported by Dan Carpenter: 
http://marc.info/?l=linux-scsi&m=133693516103343&w=2

Resolve null pointer check ordering that were odd


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 10:38:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 11:40:44.000000000 -0400
@@ -15863,24 +15863,18 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		spin_lock_irqsave(&phba->hbalock, iflags);
 
 		piocbq = lpfc_sli_ringtx_get(phba, pring);
+		if (!piocbq) {
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2823 txq empty and txq_cnt is %d\n ",
+				pring->txq_cnt);
+			break;
+		}
 		sglq = __lpfc_sli_get_sglq(phba, piocbq);
 		if (!sglq) {
 			__lpfc_sli_ringtx_put(phba, pring, piocbq);
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			break;
-		} else {
-			if (!piocbq) {
-				/* The txq_cnt out of sync. This should
-				 * never happen
-				 */
-				sglq = __lpfc_clear_active_sglq(phba,
-						 sglq->sli4_lxritag);
-				spin_unlock_irqrestore(&phba->hbalock, iflags);
-				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"2823 txq empty and txq_cnt is %d\n ",
-					pring->txq_cnt);
-				break;
-			}
 		}
 
 		/* The xri and iocb resources secured,



