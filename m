From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/11] lpfc 8.3.38: Fixed circular locking dependency and
 inconsistent lock state issues
Date: Fri, 1 Mar 2013 16:37:44 -0500
Message-ID: <1362173864.8283.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41693 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3CAVjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:39:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed circular locking dependency and inconsistent lock state issues


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   18 ++++++++++--------
 lpfc_init.c    |    8 ++++----
 lpfc_scsi.c    |    4 ++--
 lpfc_sli.c     |    8 ++++----
 4 files changed, 20 insertions(+), 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:27.368047576 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-02-27 08:17:28.588047603 -0500
@@ -2990,6 +2990,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	struct lpfc_dmabuf *mp;
 	int rc;
 	struct fcf_record *fcf_record;
+	uint32_t fc_flags = 0;
 
 	spin_lock_irq(&phba->hbalock);
 	switch (bf_get(lpfc_mbx_read_top_link_spd, la)) {
@@ -3021,11 +3022,8 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 				"1309 Link Up Event npiv not supported in loop "
 				"topology\n");
 				/* Get Loop Map information */
-		if (bf_get(lpfc_mbx_read_top_il, la)) {
-			spin_lock(shost->host_lock);
-			vport->fc_flag |= FC_LBIT;
-			spin_unlock(shost->host_lock);
-		}
+		if (bf_get(lpfc_mbx_read_top_il, la))
+			fc_flags |= FC_LBIT;
 
 		vport->fc_myDID = bf_get(lpfc_mbx_read_top_alpa_granted, la);
 		i = la->lilpBde64.tus.f.bdeSize;
@@ -3074,12 +3072,16 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 				phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
 		}
 		vport->fc_myDID = phba->fc_pref_DID;
-		spin_lock(shost->host_lock);
-		vport->fc_flag |= FC_LBIT;
-		spin_unlock(shost->host_lock);
+		fc_flags |= FC_LBIT;
 	}
 	spin_unlock_irq(&phba->hbalock);
 
+	if (fc_flags) {
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= fc_flags;
+		spin_unlock_irq(shost->host_lock);
+	}
+
 	lpfc_linkup(phba);
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!sparam_mbox)
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-02-27 08:17:24.780047516 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-02-27 08:17:28.601047603 -0500
@@ -2914,9 +2914,9 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 			sglq_entry->state = SGL_FREED;
 			list_add_tail(&sglq_entry->list, &els_sgl_list);
 		}
-		spin_lock(&phba->hbalock);
+		spin_lock_irq(&phba->hbalock);
 		list_splice_init(&els_sgl_list, &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irq(&phba->hbalock);
 	} else if (els_xri_cnt < phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl shrinked */
 		xri_cnt = phba->sli4_hba.els_xri_cnt - els_xri_cnt;
@@ -3014,9 +3014,9 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 		psb->cur_iocbq.sli4_lxritag = lxri;
 		psb->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 	}
-	spin_lock(&phba->scsi_buf_list_lock);
+	spin_lock_irq(&phba->scsi_buf_list_lock);
 	list_splice_init(&scsi_sgl_list, &phba->lpfc_scsi_buf_list);
-	spin_unlock(&phba->scsi_buf_list_lock);
+	spin_unlock_irq(&phba->scsi_buf_list_lock);
 
 	return 0;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-02-27 08:17:19.717047400 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-02-27 08:17:28.609047603 -0500
@@ -885,9 +885,9 @@ lpfc_sli4_repost_scsi_sgl_list(struct lp
 	int num_posted, rc = 0;
 
 	/* get all SCSI buffers need to repost to a local list */
-	spin_lock(&phba->scsi_buf_list_lock);
+	spin_lock_irq(&phba->scsi_buf_list_lock);
 	list_splice_init(&phba->lpfc_scsi_buf_list, &post_sblist);
-	spin_unlock(&phba->scsi_buf_list_lock);
+	spin_unlock_irq(&phba->scsi_buf_list_lock);
 
 	/* post the list of scsi buffer sgls to port if available */
 	if (!list_empty(&post_sblist)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:26.100047546 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:28.626047603 -0500
@@ -5999,9 +5999,9 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 	LIST_HEAD(post_sgl_list);
 	LIST_HEAD(free_sgl_list);
 
-	spin_lock(&phba->hbalock);
+	spin_lock_irq(&phba->hbalock);
 	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &allc_sgl_list);
-	spin_unlock(&phba->hbalock);
+	spin_unlock_irq(&phba->hbalock);
 
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
 				 &allc_sgl_list, list) {
@@ -6102,10 +6102,10 @@ lpfc_sli4_repost_els_sgl_list(struct lpf
 
 	/* push els sgls posted to the availble list */
 	if (!list_empty(&post_sgl_list)) {
-		spin_lock(&phba->hbalock);
+		spin_lock_irq(&phba->hbalock);
 		list_splice_init(&post_sgl_list,
 				 &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irq(&phba->hbalock);
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"3161 Failure to post els sgl to port.\n");



