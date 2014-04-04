From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/11] lpfc 10.2.8000.0: Fix locking for postbufq when freeing
Date: Fri, 4 Apr 2014 13:51:44 -0400
Message-ID: <1396633904.1924.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:41579 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaDDRvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:51:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix locking for postbufq when freeing


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:20.116308496 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-04-03 10:24:21.152308548 -0400
@@ -836,19 +836,28 @@ lpfc_hba_free_post_buf(struct lpfc_hba *
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *mp, *next_mp;
+	LIST_HEAD(buflist);
+	int count;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
 		lpfc_sli_hbqbuf_free_all(phba);
 	else {
 		/* Cleanup preposted buffers on the ELS ring */
-		spin_lock_irq(&phba->hbalock);
 		pring = &psli->ring[LPFC_ELS_RING];
-		list_for_each_entry_safe(mp, next_mp, &pring->postbufq, list) {
+		spin_lock_irq(&phba->hbalock);
+		list_splice_init(&pring->postbufq, &buflist);
+		spin_unlock_irq(&phba->hbalock);
+
+		count = 0;
+		list_for_each_entry_safe(mp, next_mp, &buflist, list) {
 			list_del(&mp->list);
-			pring->postbufq_cnt--;
+			count++;
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 		}
+
+		spin_lock_irq(&phba->hbalock);
+		pring->postbufq_cnt -= count;
 		spin_unlock_irq(&phba->hbalock);
 	}
 }



