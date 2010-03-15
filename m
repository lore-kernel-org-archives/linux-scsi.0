From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.11: SLI4 Improvements
Date: Mon, 15 Mar 2010 11:25:07 -0400
Message-ID: <1268666708.31367.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57388 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965164Ab0COPZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

SLI4 Improvements

- Correct all SLI4 code to work on big endian systems.
- Move read of sli4 params earlier so returned values are used correctly.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    4 ++-
 lpfc_hw4.h     |    7 +++++
 lpfc_init.c    |   76 ++++++++++++++++++++++++++++-----------------------------
 lpfc_sli.c     |   37 +++++++++++++++------------
 4 files changed, 69 insertions(+), 55 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-15 10:30:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-15 10:31:09.000000000 -0400
@@ -1621,7 +1621,9 @@ lpfc_sli4_fcf_rec_mbox_parse(struct lpfc
 	new_fcf_record = (struct fcf_record *)(virt_addr +
 			  sizeof(struct lpfc_mbx_read_fcf_tbl));
 	lpfc_sli_pcimem_bcopy(new_fcf_record, new_fcf_record,
-			      sizeof(struct fcf_record));
+				offsetof(struct fcf_record, vlan_bitmap));
+	new_fcf_record->word137 = le32_to_cpu(new_fcf_record->word137);
+	new_fcf_record->word138 = le32_to_cpu(new_fcf_record->word138);
 
 	return new_fcf_record;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-03-15 10:31:09.000000000 -0400
@@ -41,8 +41,14 @@
  * Or clear that bit field:
  *	bf_set(example_bit_field, &t1, 0);
  */
+#define bf_get_le32(name, ptr) \
+	((le32_to_cpu((ptr)->name##_WORD) >> name##_SHIFT) & name##_MASK)
 #define bf_get(name, ptr) \
 	(((ptr)->name##_WORD >> name##_SHIFT) & name##_MASK)
+#define bf_set_le32(name, ptr, value) \
+	((ptr)->name##_WORD = cpu_to_le32(((((value) & \
+	name##_MASK) << name##_SHIFT) | (le32_to_cpu((ptr)->name##_WORD) & \
+	~(name##_MASK << name##_SHIFT)))))
 #define bf_set(name, ptr, value) \
 	((ptr)->name##_WORD = ((((value) & name##_MASK) << name##_SHIFT) | \
 		 ((ptr)->name##_WORD & ~(name##_MASK << name##_SHIFT))))
@@ -1940,6 +1946,7 @@ struct lpfc_mbx_sli4_params {
 #define rdma_MASK				0x00000001
 #define rdma_WORD				word3
 	uint32_t sge_supp_len;
+#define SLI4_PAGE_SIZE 4096
 	uint32_t word5;
 #define if_page_sz_SHIFT			0
 #define if_page_sz_MASK				0x0000ffff
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:30:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:31:09.000000000 -0400
@@ -2565,7 +2565,7 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	shost->max_cmd_len = 16;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		shost->dma_boundary =
-			phba->sli4_hba.pc_sli4_params.sge_supp_len;
+			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
 		shost->sg_tablesize = phba->cfg_sg_seg_cnt;
 	}
 
@@ -4038,6 +4038,43 @@ lpfc_sli4_driver_resource_setup(struct l
 	if (unlikely(rc))
 		goto out_free_bsmbx;
 
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						       GFP_KERNEL);
+	if (!mboxq) {
+		rc = -ENOMEM;
+		goto out_free_bsmbx;
+	}
+
+	/* Get the Supported Pages. It is always available. */
+	lpfc_supported_pages(mboxq);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		goto out_free_bsmbx;
+	}
+
+	mqe = &mboxq->u.mqe;
+	memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
+	       LPFC_MAX_SUPPORTED_PAGES);
+	for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
+		switch (pn_page[i]) {
+		case LPFC_SLI4_PARAMETERS:
+			phba->sli4_hba.pc_sli4_params.supported = 1;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Read the port's SLI4 Parameters capabilities if supported. */
+	if (phba->sli4_hba.pc_sli4_params.supported)
+		rc = lpfc_pc_sli4_params_get(phba, mboxq);
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	if (rc) {
+		rc = -EIO;
+		goto out_free_bsmbx;
+	}
 	/* Create all the SLI4 queues */
 	rc = lpfc_sli4_queue_create(phba);
 	if (rc)
@@ -4098,43 +4135,6 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_fcp_eq_hdl;
 	}
 
-	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
-						       GFP_KERNEL);
-	if (!mboxq) {
-		rc = -ENOMEM;
-		goto out_free_fcp_eq_hdl;
-	}
-
-	/* Get the Supported Pages. It is always available. */
-	lpfc_supported_pages(mboxq);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (unlikely(rc)) {
-		rc = -EIO;
-		mempool_free(mboxq, phba->mbox_mem_pool);
-		goto out_free_fcp_eq_hdl;
-	}
-
-	mqe = &mboxq->u.mqe;
-	memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
-	       LPFC_MAX_SUPPORTED_PAGES);
-	for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
-		switch (pn_page[i]) {
-		case LPFC_SLI4_PARAMETERS:
-			phba->sli4_hba.pc_sli4_params.supported = 1;
-			break;
-		default:
-			break;
-		}
-	}
-
-	/* Read the port's SLI4 Parameters capabilities if supported. */
-	if (phba->sli4_hba.pc_sli4_params.supported)
-		rc = lpfc_pc_sli4_params_get(phba, mboxq);
-	mempool_free(mboxq, phba->mbox_mem_pool);
-	if (rc) {
-		rc = -EIO;
-		goto out_free_fcp_eq_hdl;
-	}
 	return rc;
 
 out_free_fcp_eq_hdl:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-03-15 10:30:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-03-15 10:31:09.000000000 -0400
@@ -211,7 +211,7 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 	struct lpfc_eqe *eqe = q->qe[q->hba_index].eqe;
 
 	/* If the next EQE is not valid then we are done */
-	if (!bf_get(lpfc_eqe_valid, eqe))
+	if (!bf_get_le32(lpfc_eqe_valid, eqe))
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
 	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
@@ -246,7 +246,7 @@ lpfc_sli4_eq_release(struct lpfc_queue *
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
 		temp_eqe = q->qe[q->host_index].eqe;
-		bf_set(lpfc_eqe_valid, temp_eqe, 0);
+		bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -284,7 +284,7 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 	struct lpfc_cqe *cqe;
 
 	/* If the next CQE is not valid then we are done */
-	if (!bf_get(lpfc_cqe_valid, q->qe[q->hba_index].cqe))
+	if (!bf_get_le32(lpfc_cqe_valid, q->qe[q->hba_index].cqe))
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
 	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
@@ -320,7 +320,7 @@ lpfc_sli4_cq_release(struct lpfc_queue *
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
 		temp_qe = q->qe[q->host_index].cqe;
-		bf_set(lpfc_cqe_valid, temp_qe, 0);
+		bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -8982,17 +8982,17 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 	int ecount = 0;
 	uint16_t cqid;
 
-	if (bf_get(lpfc_eqe_major_code, eqe) != 0) {
+	if (bf_get_le32(lpfc_eqe_major_code, eqe) != 0) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0359 Not a valid slow-path completion "
 				"event: majorcode=x%x, minorcode=x%x\n",
-				bf_get(lpfc_eqe_major_code, eqe),
-				bf_get(lpfc_eqe_minor_code, eqe));
+				bf_get_le32(lpfc_eqe_major_code, eqe),
+				bf_get_le32(lpfc_eqe_minor_code, eqe));
 		return;
 	}
 
 	/* Get the reference to the corresponding CQ */
-	cqid = bf_get(lpfc_eqe_resource_id, eqe);
+	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
 	/* Search for completion queue pointer matching this cqid */
 	speq = phba->sli4_hba.sp_eq;
@@ -9220,12 +9220,12 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba 
 	uint16_t cqid;
 	int ecount = 0;
 
-	if (unlikely(bf_get(lpfc_eqe_major_code, eqe) != 0)) {
+	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0366 Not a valid fast-path completion "
 				"event: majorcode=x%x, minorcode=x%x\n",
-				bf_get(lpfc_eqe_major_code, eqe),
-				bf_get(lpfc_eqe_minor_code, eqe));
+				bf_get_le32(lpfc_eqe_major_code, eqe),
+				bf_get_le32(lpfc_eqe_minor_code, eqe));
 		return;
 	}
 
@@ -9238,7 +9238,7 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba 
 	}
 
 	/* Get the reference to the corresponding CQ */
-	cqid = bf_get(lpfc_eqe_resource_id, eqe);
+	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 	if (unlikely(cqid != cq->queue_id)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0368 Miss-matched fast-path completion "
@@ -9531,13 +9531,18 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *p
 	struct lpfc_dmabuf *dmabuf;
 	int x, total_qe_count;
 	void *dma_pointer;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
 

+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
+
 	queue = kzalloc(sizeof(struct lpfc_queue) +
 			(sizeof(union sli4_qe) * entry_count), GFP_KERNEL);
 	if (!queue)
 		return NULL;
-	queue->page_count = (PAGE_ALIGN(entry_size * entry_count))/PAGE_SIZE;
+	queue->page_count = (ALIGN(entry_size * entry_count,
+			hw_page_size))/hw_page_size;
 	INIT_LIST_HEAD(&queue->list);
 	INIT_LIST_HEAD(&queue->page_list);
 	INIT_LIST_HEAD(&queue->child_list);
@@ -9546,19 +9551,19 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *p
 		if (!dmabuf)
 			goto out_fail;
 		dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-						  PAGE_SIZE, &dmabuf->phys,
+						  hw_page_size, &dmabuf->phys,
 						  GFP_KERNEL);
 		if (!dmabuf->virt) {
 			kfree(dmabuf);
 			goto out_fail;
 		}
-		memset(dmabuf->virt, 0, PAGE_SIZE);
+		memset(dmabuf->virt, 0, hw_page_size);
 		dmabuf->buffer_tag = x;
 		list_add_tail(&dmabuf->list, &queue->page_list);
 		/* initialize queue's entry array */
 		dma_pointer = dmabuf->virt;
 		for (; total_qe_count < entry_count &&
-		     dma_pointer < (PAGE_SIZE + dmabuf->virt);
+		     dma_pointer < (hw_page_size + dmabuf->virt);
 		     total_qe_count++, dma_pointer += entry_size) {
 			queue->qe[total_qe_count].address = dma_pointer;
 		}


