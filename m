From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/19] lpfc 10.4.8000.0: Fix quarantined XRI recovery
 qualifier state in link bounce
Date: Wed, 3 Sep 2014 12:56:48 -0400
Message-ID: <1409763408.12357.11.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47639 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:56:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix quarantined XRI recovery qualifier state in link bounce

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |  1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 -
 drivers/scsi/lpfc/lpfc_sli.c     | 36 ------------------------------------
 3 files changed, 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index db5604f..00665a5 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -451,7 +451,6 @@ int lpfc_send_rrq(struct lpfc_hba *, struct lpfc_node_rrq *);
 int lpfc_set_rrq_active(struct lpfc_hba *, struct lpfc_nodelist *,
 	uint16_t, uint16_t, uint16_t);
 uint16_t lpfc_sli4_xri_inrange(struct lpfc_hba *, uint16_t);
-void lpfc_cleanup_wt_rrqs(struct lpfc_hba *);
 void lpfc_cleanup_vports_rrqs(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
 	uint32_t);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 859fffa..d178aee 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -995,7 +995,6 @@ lpfc_linkup(struct lpfc_hba *phba)
 	struct lpfc_vport **vports;
 	int i;
 
-	lpfc_cleanup_wt_rrqs(phba);
 	phba->link_state = LPFC_LINK_UP;
 
 	/* Unblock fabric iocbs if they are blocked */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8f3be2a..deb7f12 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -786,42 +786,6 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 }
 
 /**
- * lpfc_cleanup_wt_rrqs - Remove all rrq's from the active list.
- * @phba: Pointer to HBA context object.
- *
- * Remove all rrqs from the phba->active_rrq_list and free them by
- * calling __lpfc_clr_active_rrq
- *
- **/
-void
-lpfc_cleanup_wt_rrqs(struct lpfc_hba *phba)
-{
-	struct lpfc_node_rrq *rrq;
-	struct lpfc_node_rrq *nextrrq;
-	unsigned long next_time;
-	unsigned long iflags;
-	LIST_HEAD(rrq_list);
-
-	if (phba->sli_rev != LPFC_SLI_REV4)
-		return;
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	phba->hba_flag &= ~HBA_RRQ_ACTIVE;
-	next_time = jiffies + msecs_to_jiffies(1000 * (phba->fc_ratov * 2));
-	list_splice_init(&phba->active_rrq_list, &rrq_list);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-
-	list_for_each_entry_safe(rrq, nextrrq, &rrq_list, list) {
-		list_del(&rrq->list);
-		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
-	}
-	if ((!list_empty(&phba->active_rrq_list)) &&
-	    (!(phba->pport->load_flag & FC_UNLOADING)))
-
-		mod_timer(&phba->rrq_tmr, next_time);
-}
-
-
-/**
  * lpfc_test_rrq_active - Test RRQ bit in xri_bitmap.
  * @phba: Pointer to HBA context object.
  * @ndlp: Targets nodelist pointer for this exchange.
-- 
1.7.11.7




