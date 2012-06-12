From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/10] lpfc 8.3.32: drivers/scsi/lpfc/lpfc_sli.c: add
 missing jumps to mempool_free
Date: Tue, 12 Jun 2012 13:54:02 -0400
Message-ID: <1339523643.2162.1.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17641 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543Ab2FLRyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporate patch originally supplied by Julia Lawall <Julia.Lawall@lip6.fr>
http://marc.info/?l=linux-scsi&m=133572879711140&w=2

"It appears that mempool_free should be performed on these failures as on
 the other exists from the containing functions."


Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Acked-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 10:07:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-06-08 10:38:13.000000000 -0400
@@ -12228,8 +12228,10 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0361 Unsupported CQ count. (%d)\n",
 				cq->entry_count);
-		if (cq->entry_count < 256)
-			return -EINVAL;
+		if (cq->entry_count < 256) {
+			status = -EINVAL;
+			goto out;
+		}
 		/* otherwise default to smallest count (drop through) */
 	case 256:
 		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
@@ -12420,8 +12422,10 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0362 Unsupported MQ count. (%d)\n",
 				mq->entry_count);
-		if (mq->entry_count < 16)
-			return -EINVAL;
+		if (mq->entry_count < 16) {
+			status = -EINVAL;
+			goto out;
+		}
 		/* otherwise default to smallest count (drop through) */
 	case 16:
 		bf_set(lpfc_mq_context_ring_size,
@@ -12710,8 +12714,10 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"2535 Unsupported RQ count. (%d)\n",
 					hrq->entry_count);
-			if (hrq->entry_count < 512)
-				return -EINVAL;
+			if (hrq->entry_count < 512) {
+				status = -EINVAL;
+				goto out;
+			}
 			/* otherwise default to smallest count (drop through) */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
@@ -12791,8 +12797,10 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"2536 Unsupported RQ count. (%d)\n",
 					drq->entry_count);
-			if (drq->entry_count < 512)
-				return -EINVAL;
+			if (drq->entry_count < 512) {
+				status = -EINVAL;
+				goto out;
+			}
 			/* otherwise default to smallest count (drop through) */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,



