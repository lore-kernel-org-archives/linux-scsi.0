From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/21] lpfc: Fix setting of EQ delay Multiplier
Date: Thu, 5 Feb 2015 14:24:00 -0500
Message-ID: <1423164240.7917.31.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:20668 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbBETYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:24:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

---
 drivers/scsi/lpfc/lpfc_init.c | 8 ++++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 9 +++------
 drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 74672e0..e01619c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7721,6 +7721,14 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			goto out_destroy_els_rq;
 		}
 	}
+
+	/*
+	 * Configure EQ delay multipier for interrupt coalescing using
+	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
+	 */
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
+			fcp_eqidx += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_fcp_eq_delay(phba, fcp_eqidx);
 	return 0;
 
 out_destroy_els_rq:
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 207a43d..303b231 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12842,7 +12842,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * fails this function will return -ENXIO.
  **/
 int
-lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint16_t startq)
+lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 {
 	struct lpfc_mbx_modify_eq_delay *eq_delay;
 	LPFC_MBOXQ_t *mbox;
@@ -12959,11 +12959,8 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 	bf_set(lpfc_eq_context_size, &eq_create->u.request.context,
 	       LPFC_EQE_SIZE);
 	bf_set(lpfc_eq_context_valid, &eq_create->u.request.context, 1);
-	/* Calculate delay multiper from maximum interrupt per second */
-	if (imax > LPFC_DMULT_CONST)
-		dmult = 0;
-	else
-		dmult = LPFC_DMULT_CONST/imax - 1;
+	/* don't setup delay multiplier using EQ_CREATE */
+	dmult = 0;
 	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context,
 	       dmult);
 	switch (eq->entry_count) {
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 22ceb2b..935b8eb 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -671,7 +671,7 @@ struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
 int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
-int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint16_t);
+int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint32_t);
 int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



