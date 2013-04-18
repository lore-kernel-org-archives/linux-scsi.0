From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/22] lpfc 8.3.39: Fixed bad book keeping in posting els
 sgls to port
Date: Wed, 17 Apr 2013 20:18:29 -0400
Message-ID: <1366244309.1513.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24326 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DRASc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:18:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed bad book keeping in posting els sgls to port


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:39.379041174 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:45.706041318 -0400
@@ -5999,7 +5999,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, post_cnt = 0, num_posted = 0, block_cnt = 0;
+	int status, total_cnt, post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
 	LIST_HEAD(prep_sgl_list);
 	LIST_HEAD(blck_sgl_list);
@@ -6011,6 +6011,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &allc_sgl_list);
 	spin_unlock_irq(&phba->hbalock);
 
+	total_cnt = phba->sli4_hba.els_xri_cnt;
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
 				 &allc_sgl_list, list) {
 		list_del_init(&sglq_entry->list);
@@ -6062,9 +6063,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 						sglq_entry->sli4_xritag);
 					list_add_tail(&sglq_entry->list,
 						      &free_sgl_list);
-					spin_lock_irq(&phba->hbalock);
-					phba->sli4_hba.els_xri_cnt--;
-					spin_unlock_irq(&phba->hbalock);
+					total_cnt--;
 				}
 			}
 		}
@@ -6092,9 +6091,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 					(sglq_entry_first->sli4_xritag +
 					 post_cnt - 1));
 			list_splice_init(&blck_sgl_list, &free_sgl_list);
-			spin_lock_irq(&phba->hbalock);
-			phba->sli4_hba.els_xri_cnt -= post_cnt;
-			spin_unlock_irq(&phba->hbalock);
+			total_cnt -= post_cnt;
 		}
 
 		/* don't reset xirtag due to hole in xri block */
@@ -6104,6 +6101,8 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 		/* reset els sgl post count for next round of posting */
 		post_cnt = 0;
 	}
+	/* update the number of XRIs posted for ELS */
+	phba->sli4_hba.els_xri_cnt = total_cnt;
 
 	/* free the els sgls failed to post */
 	lpfc_free_sgl_list(phba, &free_sgl_list);



