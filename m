From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 05/17] lpfc: NVME Initiator: Base modifications Part D
Date: Tue, 17 Jan 2017 17:20:48 -0800
Message-ID: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34939 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdARBUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:20:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id d140so265430wmd.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:20:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part D of parts A..F.

Part D is the 2nd half of the mods to lpfc_init.c. This is the location
of most of changes for the following:
- sli3 ring vs sli4 wq splits
- buffer pools are allocated/freed
- sgl pools allocated/freed
- adapter resources split up
- queue config decided and enacted
- receive buffer management

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1088 +++++++++++++++++++++++------------------
 1 file changed, 616 insertions(+), 472 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ca54beb..ea12eca 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7876,14 +7876,14 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 {
-	int idx;
+	int idx, numwq;
 
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
 
 	if (phba->sli4_hba.hba_eq != NULL) {
 		/* Release HBA event queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+		for (idx = 0; idx < phba->io_channel; idx++) {
 			if (phba->sli4_hba.hba_eq[idx] != NULL) {
 				lpfc_sli4_queue_free(
 					phba->sli4_hba.hba_eq[idx]);
@@ -7907,9 +7907,22 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_cq = NULL;
 	}
 
+	if (phba->sli4_hba.nvme_cq != NULL) {
+		/* Release NVME completion queue */
+		for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++) {
+			if (phba->sli4_hba.nvme_cq[idx] != NULL) {
+				lpfc_sli4_queue_free(
+					phba->sli4_hba.nvme_cq[idx]);
+				phba->sli4_hba.nvme_cq[idx] = NULL;
+			}
+		}
+		kfree(phba->sli4_hba.nvme_cq);
+		phba->sli4_hba.nvme_cq = NULL;
+	}
+
 	if (phba->sli4_hba.fcp_wq != NULL) {
 		/* Release FCP work queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+		for (idx = 0; idx < phba->cfg_fcp_max_hw_queue; idx++) {
 			if (phba->sli4_hba.fcp_wq[idx] != NULL) {
 				lpfc_sli4_queue_free(
 					phba->sli4_hba.fcp_wq[idx]);
@@ -7920,12 +7933,32 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_wq = NULL;
 	}
 
+	if (phba->sli4_hba.nvme_wq != NULL) {
+		/* Release NVME work queue */
+		numwq = phba->cfg_nvme_max_hw_queue;
+		for (idx = 0; idx < numwq; idx++) {
+			if (phba->sli4_hba.nvme_wq[idx] != NULL) {
+				lpfc_sli4_queue_free(
+					phba->sli4_hba.nvme_wq[idx]);
+				phba->sli4_hba.nvme_wq[idx] = NULL;
+			}
+		}
+		kfree(phba->sli4_hba.nvme_wq);
+		phba->sli4_hba.nvme_wq = NULL;
+	}
+
 	/* Release FCP CQ mapping array */
 	if (phba->sli4_hba.fcp_cq_map != NULL) {
 		kfree(phba->sli4_hba.fcp_cq_map);
 		phba->sli4_hba.fcp_cq_map = NULL;
 	}
 
+	/* Release NVME CQ mapping array */
+	if (phba->sli4_hba.nvme_cq_map != NULL) {
+		kfree(phba->sli4_hba.nvme_cq_map);
+		phba->sli4_hba.nvme_cq_map = NULL;
+	}
+
 	/* Release mailbox command work queue */
 	if (phba->sli4_hba.mbx_wq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
@@ -7938,6 +7971,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.els_wq = NULL;
 	}
 
+	/* Release ELS work queue */
+	if (phba->sli4_hba.nvmels_wq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmels_wq);
+		phba->sli4_hba.nvmels_wq = NULL;
+	}
+
 	/* Release unsolicited receive queue */
 	if (phba->sli4_hba.hdr_rq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
@@ -7954,15 +7993,83 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.els_cq = NULL;
 	}
 
+	/* Release NVME LS complete queue */
+	if (phba->sli4_hba.nvmels_cq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmels_cq);
+		phba->sli4_hba.nvmels_cq = NULL;
+	}
+
 	/* Release mailbox command complete queue */
 	if (phba->sli4_hba.mbx_cq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
 		phba->sli4_hba.mbx_cq = NULL;
 	}
 
+	/* Everything on this list has been freed */
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
+
 	return;
 }
 
+int
+lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+		    struct lpfc_queue *drq, int count)
+{
+	int rc, i;
+	struct lpfc_rqe hrqe;
+	struct lpfc_rqe drqe;
+	struct lpfc_rqb *rqbp;
+	struct rqb_dmabuf *rqb_buffer;
+	LIST_HEAD(rqb_buf_list);
+
+	rqbp = hrq->rqbp;
+	for (i = 0; i < count; i++) {
+		rqb_buffer = (rqbp->rqb_alloc_buffer)(phba);
+		if (!rqb_buffer)
+			break;
+		rqb_buffer->hrq = hrq;
+		rqb_buffer->drq = drq;
+		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
+	}
+	while (!list_empty(&rqb_buf_list)) {
+		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
+				 hbuf.list);
+
+		hrqe.address_lo = putPaddrLow(rqb_buffer->hbuf.phys);
+		hrqe.address_hi = putPaddrHigh(rqb_buffer->hbuf.phys);
+		drqe.address_lo = putPaddrLow(rqb_buffer->dbuf.phys);
+		drqe.address_hi = putPaddrHigh(rqb_buffer->dbuf.phys);
+		rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
+		if (rc < 0) {
+			(rqbp->rqb_free_buffer)(phba, rqb_buffer);
+		} else {
+			list_add_tail(&rqb_buffer->hbuf.list,
+				      &rqbp->rqb_buffer_list);
+			rqbp->buffer_count++;
+		}
+	}
+	return 1;
+}
+
+int
+lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *rq)
+{
+	struct lpfc_rqb *rqbp;
+	struct lpfc_dmabuf *h_buf;
+	struct rqb_dmabuf *rqb_buffer;
+
+	rqbp = rq->rqbp;
+	while (!list_empty(&rqbp->rqb_buffer_list)) {
+		list_remove_head(&rqbp->rqb_buffer_list, h_buf,
+				 struct lpfc_dmabuf, list);
+
+		rqb_buffer = container_of(h_buf, struct rqb_dmabuf, hbuf);
+		(rqbp->rqb_free_buffer)(phba, rqb_buffer);
+		rqbp->buffer_count--;
+	}
+	return 1;
+}
+
 /**
  * lpfc_sli4_queue_setup - Set up all the SLI4 queues
  * @phba: pointer to lpfc hba data structure.
@@ -7978,15 +8085,15 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 int
 lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
-	int rc = -ENOMEM;
-	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
-	int fcp_cq_index = 0;
+	struct lpfc_queue *wcq;
+	int hba_eqidx, fcp_cqidx, nvme_cqidx;
+	int fcp_wqidx, nvme_wqidx;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t length;
+	uint32_t length, io_channel, numwq;
+	int rc = -ENOMEM;
 
 	/* Check for dual-ULP support */
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -8036,120 +8143,248 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	/*
 	 * Set up HBA Event Queues (EQs)
 	 */
+	io_channel = phba->io_channel;
 
 	/* Set up HBA event queue */
-	if (phba->cfg_fcp_io_channel && !phba->sli4_hba.hba_eq) {
+	if (io_channel && !phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3147 Fast-path EQs not allocated\n");
 		rc = -ENOMEM;
 		goto out_error;
 	}
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel; fcp_eqidx++) {
-		if (!phba->sli4_hba.hba_eq[fcp_eqidx]) {
+	for (hba_eqidx = 0; hba_eqidx < io_channel; hba_eqidx++) {
+		if (!phba->sli4_hba.hba_eq[hba_eqidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0522 Fast-path EQ (%d) not "
-					"allocated\n", fcp_eqidx);
+					"allocated\n", hba_eqidx);
 			rc = -ENOMEM;
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
-		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[fcp_eqidx],
-			 (phba->cfg_fcp_imax / phba->cfg_fcp_io_channel));
+		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[hba_eqidx],
+			 (phba->cfg_fcp_imax / io_channel));
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0523 Failed setup of fast-path EQ "
-					"(%d), rc = 0x%x\n", fcp_eqidx,
+					"(%d), rc = 0x%x\n", hba_eqidx,
 					(uint32_t)rc);
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2584 HBA EQ setup: "
-				"queue[%d]-id=%d\n", fcp_eqidx,
-				phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id);
+				"2584 HBA EQ setup: queue[%d]-id=%d\n",
+				hba_eqidx,
+				phba->sli4_hba.hba_eq[hba_eqidx]->queue_id);
 	}
 
-	/* Set up fast-path FCP Response Complete Queue */
-	if (!phba->sli4_hba.fcp_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3148 Fast-path FCP CQ array not "
-				"allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_hba_eq;
-	}
-
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++) {
-		if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
+	nvme_cqidx = 0;
+	nvme_wqidx = 0;
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up fast-path NVME Response Complete Queue */
+		if (!phba->sli4_hba.nvme_cq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0526 Fast-path FCP CQ (%d) not "
-					"allocated\n", fcp_cqidx);
+					"6084 Fast-path NVME CQ array not "
+					"allocated\n");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_cq;
+			goto out_destroy;
 		}
-		rc = lpfc_cq_create(phba, phba->sli4_hba.fcp_cq[fcp_cqidx],
-			phba->sli4_hba.hba_eq[fcp_cqidx], LPFC_WCQ, LPFC_FCP);
-		if (rc) {
+
+		for (nvme_cqidx = 0; nvme_cqidx < phba->cfg_nvme_io_channel;
+		     nvme_cqidx++) {
+			if (!phba->sli4_hba.nvme_cq[nvme_cqidx]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6085 Fast-path NVME CQ (%d) "
+						"not allocated\n", nvme_cqidx);
+				rc = -ENOMEM;
+				goto out_destroy;
+			}
+			rc = lpfc_cq_create(
+				phba, phba->sli4_hba.nvme_cq[nvme_cqidx],
+				phba->sli4_hba.hba_eq[nvme_cqidx],
+				LPFC_WCQ, LPFC_NVME);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6086 Failed setup of NVME CQ "
+						"(%d), rc = 0x%x\n", nvme_cqidx,
+						(uint32_t)rc);
+				goto out_destroy;
+			}
+
+			/* Setup nvme_cq_map for fast lookup */
+			phba->sli4_hba.nvme_cq_map[nvme_cqidx] =
+				phba->sli4_hba.nvme_cq[nvme_cqidx]->queue_id;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"6087 NVME CQ setup: cq[%d]-id=%d, "
+					"parent seq[%d]-id=%d\n",
+					nvme_cqidx,
+					phba->sli4_hba.nvme_cq[
+							nvme_cqidx]->queue_id,
+					nvme_cqidx,
+					phba->sli4_hba.hba_eq[
+							nvme_cqidx]->queue_id);
+		}
+
+		/* Set up fast-path NVME Work Queue */
+		if (!phba->sli4_hba.nvme_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0527 Failed setup of fast-path FCP "
-					"CQ (%d), rc = 0x%x\n", fcp_cqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_cq;
+					"6124 Fast-path NVME WQ array not "
+					"allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
 		}
 
-		/* Setup fcp_cq_map for fast lookup */
-		phba->sli4_hba.fcp_cq_map[fcp_cqidx] =
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id;
+		numwq = phba->cfg_nvme_max_hw_queue;
 
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2588 FCP CQ setup: cq[%d]-id=%d, "
-				"parent seq[%d]-id=%d\n",
-				fcp_cqidx,
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id,
-				fcp_cqidx,
-				phba->sli4_hba.hba_eq[fcp_cqidx]->queue_id);
-	}
+		nvme_cqidx = 0;
+		for (nvme_wqidx = 0; nvme_wqidx < numwq; nvme_wqidx++) {
+			if (!phba->sli4_hba.nvme_wq[nvme_wqidx]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6122 Fast-path FCP WQ (%d) "
+						"not allocated\n", nvme_wqidx);
+				rc = -ENOMEM;
+				goto out_destroy;
+			}
+			wcq = phba->sli4_hba.nvme_cq[nvme_cqidx];
 
-	/* Set up fast-path FCP Work Queue */
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3149 Fast-path FCP WQ array not "
-				"allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_fcp_cq;
+			rc = lpfc_wq_create(phba,
+					    phba->sli4_hba.nvme_wq[nvme_wqidx],
+					    wcq, LPFC_NVME);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6123 Fail setup fastpath NVME "
+						"WQ (%d), rc = 0x%x\n",
+						nvme_wqidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+
+			/* Bind this CQ/WQ to the NVME ring */
+			pring = phba->sli4_hba.nvme_wq[nvme_wqidx]->pring;
+			pring->sli.sli4.wqp =
+				(void *)phba->sli4_hba.nvme_wq[nvme_wqidx];
+			wcq->pring = pring;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2593 NVME WQ setup: wq[%d]-id=%d, "
+					"parent cq[%d]-id=%d\n",
+					nvme_wqidx,
+					phba->sli4_hba.nvme_wq[nvme_wqidx]->
+					queue_id,
+					phba->sli4_hba.nvme_wq[nvme_wqidx]->
+					assoc_qid,
+					wcq->queue_id);
+
+			nvme_cqidx++;
+			if (nvme_cqidx >= phba->cfg_nvme_io_channel)
+				nvme_cqidx = 0;
+		}
 	}
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++) {
-		if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+	fcp_cqidx = 0;
+	fcp_wqidx = 0;
+	if (phba->cfg_fcp_io_channel) {
+		/* Set up fast-path FCP Response Complete Queue */
+		if (!phba->sli4_hba.fcp_cq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0534 Fast-path FCP WQ (%d) not "
-					"allocated\n", fcp_wqidx);
+					"3148 Fast-path FCP CQ array not "
+					"allocated\n");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_wq;
+			goto out_destroy;
 		}
-		rc = lpfc_wq_create(phba, phba->sli4_hba.fcp_wq[fcp_wqidx],
-				    phba->sli4_hba.fcp_cq[fcp_wqidx],
-				    LPFC_FCP);
-		if (rc) {
+
+		for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel;
+		     fcp_cqidx++) {
+			if (!phba->sli4_hba.fcp_cq[fcp_cqidx]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0526 Fast-path FCP CQ (%d) "
+						"not allocated\n", fcp_cqidx);
+				rc = -ENOMEM;
+				goto out_destroy;
+			}
+			rc = lpfc_cq_create(phba,
+					    phba->sli4_hba.fcp_cq[fcp_cqidx],
+					    phba->sli4_hba.hba_eq[fcp_cqidx],
+					    LPFC_WCQ, LPFC_FCP);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0527 Failed setup fast-path "
+						"FCP CQ (%d), rc = 0x%x\n",
+						fcp_cqidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+
+			/* Setup fcp_cq_map for fast lookup */
+			phba->sli4_hba.fcp_cq_map[fcp_cqidx] =
+				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2588 FCP CQ setup: cq[%d]-id=%d, "
+					"parent seq[%d]-id=%d\n",
+					fcp_cqidx,
+					phba->sli4_hba.fcp_cq[fcp_cqidx]->
+					queue_id,
+					fcp_cqidx,
+					phba->sli4_hba.hba_eq[fcp_cqidx]->
+					queue_id);
+		}
+
+		/* Set up fast-path FCP Work Queue */
+		if (!phba->sli4_hba.fcp_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0535 Failed setup of fast-path FCP "
-					"WQ (%d), rc = 0x%x\n", fcp_wqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_wq;
+					"3149 Fast-path FCP WQ array not "
+					"allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
 		}
 
-		/* Bind this WQ to the next FCP ring */
-		pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + fcp_wqidx];
-		pring->sli.sli4.wqp = (void *)phba->sli4_hba.fcp_wq[fcp_wqidx];
-		phba->sli4_hba.fcp_cq[fcp_wqidx]->pring = pring;
+		fcp_cqidx = 0;
+		for (fcp_wqidx = 0;
+		     fcp_wqidx < phba->cfg_fcp_max_hw_queue;
+		     fcp_wqidx++) {
+			if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0534 Fast-path FCP WQ (%d) "
+						"not allocated\n", fcp_wqidx);
+				rc = -ENOMEM;
+				goto out_destroy;
+			}
+			wcq = phba->sli4_hba.fcp_cq[fcp_cqidx];
 
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2591 FCP WQ setup: wq[%d]-id=%d, "
-				"parent cq[%d]-id=%d\n",
-				fcp_wqidx,
-				phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-				fcp_cq_index,
-				phba->sli4_hba.fcp_cq[fcp_wqidx]->queue_id);
+			rc = lpfc_wq_create(phba,
+					    phba->sli4_hba.fcp_wq[fcp_wqidx],
+					    wcq, LPFC_FCP);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0535 Failed setup fast-path "
+						"FCP WQ (%d), FCP CQ (%d), "
+						"rc = 0x%x\n",
+						fcp_wqidx, fcp_cqidx,
+						(uint32_t)rc);
+				goto out_destroy;
+			}
+
+			/* Bind this CQ/WQ to the FCP ring */
+			pring = phba->sli4_hba.fcp_wq[fcp_wqidx]->pring;
+			pring->sli.sli4.wqp =
+				(void *)phba->sli4_hba.fcp_wq[fcp_wqidx];
+			wcq->pring = pring;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2591 FCP WQ setup: wq[%d]-id=%d, "
+					"parent cq[%d]-id=%d\n",
+					fcp_wqidx,
+					phba->sli4_hba.fcp_wq[fcp_wqidx]->
+					queue_id,
+					phba->sli4_hba.fcp_wq[fcp_wqidx]->
+					assoc_qid,
+					wcq->queue_id);
+
+			fcp_cqidx++;
+			if (fcp_cqidx >= phba->cfg_fcp_io_channel)
+				fcp_cqidx = 0;
+		}
 	}
+
 	/*
-	 * Set up Complete Queues (CQs)
+	 * Set up Slow Path Complete Queues (CQs)
 	 */
 
 	/* Set up slow-path MBOX Complete Queue as the first CQ */
@@ -8157,7 +8392,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0528 Mailbox CQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_fcp_wq;
+		goto out_destroy;
 	}
 	rc = lpfc_cq_create(phba, phba->sli4_hba.mbx_cq,
 			phba->sli4_hba.hba_eq[0], LPFC_MCQ, LPFC_MBOX);
@@ -8165,7 +8400,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0529 Failed setup of slow-path mailbox CQ: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2585 MBX CQ setup: cq-id=%d, parent eq-id=%d\n",
@@ -8177,7 +8412,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0530 ELS CQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_cq;
+		goto out_destroy;
 	}
 	rc = lpfc_cq_create(phba, phba->sli4_hba.els_cq,
 			phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_ELS);
@@ -8185,13 +8420,37 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0531 Failed setup of slow-path ELS CQ: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_cq;
+		goto out_destroy;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2586 ELS CQ setup: cq-id=%d, parent eq-id=%d\n",
 			phba->sli4_hba.els_cq->queue_id,
 			phba->sli4_hba.hba_eq[0]->queue_id);
 
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up NVME LS Complete Queue */
+		if (!phba->sli4_hba.nvmels_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6091 LS CQ not allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		rc = lpfc_cq_create(phba, phba->sli4_hba.nvmels_cq,
+				    phba->sli4_hba.hba_eq[0],
+				    LPFC_WCQ, LPFC_NVME_LS);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6092 Failed setup of NVME LS CQ: "
+					"rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy;
+		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"6093 NVME LS CQ setup: cq-id=%d, "
+				"parent eq-id=%d\n",
+				phba->sli4_hba.nvmels_cq->queue_id,
+				phba->sli4_hba.hba_eq[0]->queue_id);
+	}
+
 	/*
 	 * Set up all the Work Queues (WQs)
 	 */
@@ -8201,7 +8460,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0538 Slow-path MQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_els_cq;
+		goto out_destroy;
 	}
 	rc = lpfc_mq_create(phba, phba->sli4_hba.mbx_wq,
 			    phba->sli4_hba.mbx_cq, LPFC_MBOX);
@@ -8209,7 +8468,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0539 Failed setup of slow-path MQ: "
 				"rc = 0x%x\n", rc);
-		goto out_destroy_els_cq;
+		goto out_destroy;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
@@ -8221,7 +8480,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0536 Slow-path ELS WQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_wq;
+		goto out_destroy;
 	}
 	rc = lpfc_wq_create(phba, phba->sli4_hba.els_wq,
 			    phba->sli4_hba.els_cq, LPFC_ELS);
@@ -8229,11 +8488,10 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0537 Failed setup of slow-path ELS WQ: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_wq;
+		goto out_destroy;
 	}
-
-	/* Bind this WQ to the ELS ring */
-	pring = &psli->ring[LPFC_ELS_RING];
+	/* Bind this CQ/WQ to the FCP ring */
+	pring = phba->sli4_hba.els_wq->pring;
 	pring->sli.sli4.wqp = (void *)phba->sli4_hba.els_wq;
 	phba->sli4_hba.els_cq->pring = pring;
 
@@ -8242,14 +8500,39 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			phba->sli4_hba.els_wq->queue_id,
 			phba->sli4_hba.els_cq->queue_id);
 
-	/*
-	 * Create Receive Queue (RQ)
-	 */
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up NVME LS Work Queue */
+		if (!phba->sli4_hba.nvmels_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6094 NVME LS WQ not allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		rc = lpfc_wq_create(phba, phba->sli4_hba.nvmels_wq,
+				    phba->sli4_hba.nvmels_cq, LPFC_NVME_LS);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6095 Failed setup of NVME LS WQ: "
+					"rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy;
+		}
+		/* Bind this CQ/WQ to the FCP ring */
+		pring = phba->sli4_hba.nvmels_wq->pring;
+		pring->sli.sli4.wqp = (void *)phba->sli4_hba.nvmels_wq;
+		phba->sli4_hba.nvmels_cq->pring = pring;
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"6096 ELS WQ setup: wq-id=%d, "
+				"parent cq-id=%d\n",
+				phba->sli4_hba.nvmels_wq->queue_id,
+				phba->sli4_hba.nvmels_cq->queue_id);
+	}
+
 	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0540 Receive Queue not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_els_wq;
+		goto out_destroy;
 	}
 
 	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
@@ -8261,7 +8544,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -8277,7 +8560,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0549 Failed setup of FOF Queues: "
 					"rc = 0x%x\n", rc);
-			goto out_destroy_els_rq;
+			goto out_destroy;
 		}
 	}
 
@@ -8285,30 +8568,13 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	 * Configure EQ delay multipier for interrupt coalescing using
 	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-			fcp_eqidx += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, fcp_eqidx);
+	for (hba_eqidx = 0; hba_eqidx < io_channel;
+			hba_eqidx += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_hba_eq_delay(phba, hba_eqidx);
 	return 0;
 
-out_destroy_els_rq:
-	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
-out_destroy_els_wq:
-	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
-out_destroy_mbx_wq:
-	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
-out_destroy_els_cq:
-	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
-out_destroy_mbx_cq:
-	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
-out_destroy_fcp_wq:
-	for (--fcp_wqidx; fcp_wqidx >= 0; fcp_wqidx--)
-		lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_wqidx]);
-out_destroy_fcp_cq:
-	for (--fcp_cqidx; fcp_cqidx >= 0; fcp_cqidx--)
-		lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_cqidx]);
-out_destroy_hba_eq:
-	for (--fcp_eqidx; fcp_eqidx >= 0; fcp_eqidx--)
-		lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_eqidx]);
+out_destroy:
+	lpfc_sli4_queue_unset(phba);
 out_error:
 	return rc;
 }
@@ -8328,38 +8594,78 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 {
-	int fcp_qidx;
+	int qidx, io_channel, numwq;
+
+	io_channel = phba->io_channel;
 
 	/* Unset the queues created for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
 	/* Unset mailbox command work queue */
-	lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+	if (phba->sli4_hba.mbx_wq)
+		lpfc_mq_destroy(phba, phba->sli4_hba.mbx_wq);
+
+	/* Unset NVME LS work queue */
+	if (phba->sli4_hba.nvmels_wq)
+		lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
+
 	/* Unset ELS work queue */
-	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+	if (phba->sli4_hba.els_cq)
+		lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
+
 	/* Unset unsolicited receive queue */
-	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+	if (phba->sli4_hba.hdr_rq)
+		lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq,
+				phba->sli4_hba.dat_rq);
+
 	/* Unset FCP work queue */
 	if (phba->sli4_hba.fcp_wq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_qidx]);
+		for (qidx = 0; qidx < phba->cfg_fcp_max_hw_queue; qidx++)
+			if (phba->sli4_hba.fcp_wq[qidx])
+				lpfc_wq_destroy(phba,
+						phba->sli4_hba.fcp_wq[qidx]);
 	}
+
+	/* Unset NVME work queue */
+	if (phba->sli4_hba.nvme_wq) {
+		numwq = phba->cfg_nvme_max_hw_queue;
+
+		for (qidx = 0; qidx < numwq; qidx++)
+			if (phba->sli4_hba.nvme_wq[qidx])
+				lpfc_wq_destroy(phba,
+						phba->sli4_hba.nvme_wq[qidx]);
+	}
+
 	/* Unset mailbox command complete queue */
-	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+	if (phba->sli4_hba.mbx_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
+
 	/* Unset ELS complete queue */
-	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+	if (phba->sli4_hba.els_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+
+	/* Unset NVME LS complete queue */
+	if (phba->sli4_hba.nvmels_cq)
+		lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
+
+	/* Unset NVME response complete queue */
+	if (phba->sli4_hba.nvme_cq) {
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			if (phba->sli4_hba.nvme_cq[qidx])
+				lpfc_cq_destroy(phba,
+						phba->sli4_hba.nvme_cq[qidx]);
+	}
 	/* Unset FCP response complete queue */
 	if (phba->sli4_hba.fcp_cq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			if (phba->sli4_hba.fcp_cq[qidx])
+				lpfc_cq_destroy(phba,
+						phba->sli4_hba.fcp_cq[qidx]);
 	}
 	/* Unset fast-path event queue */
 	if (phba->sli4_hba.hba_eq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_qidx]);
+		for (qidx = 0; qidx < io_channel; qidx++)
+			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[qidx]);
 	}
 }
 
@@ -9170,91 +9476,33 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_find_next_cpu - Find next available CPU that matches the phys_id
+ * lpfc_cpu_affinity_check - Check vector CPU affinity mappings
  * @phba: pointer to lpfc hba data structure.
+ * @vectors: number of msix vectors allocated.
  *
- * Find next available CPU to use for IRQ to CPU affinity.
+ * The routine will figure out the CPU affinity assignment for every
+ * MSI-X vector allocated for the HBA.  The hba_eq_hdl will be updated
+ * with a pointer to the CPU mask that defines ALL the CPUs this vector
+ * can be associated with. If the vector can be unquely associated with
+ * a single CPU, that CPU will be recorded in hba_eq_hdl[index].cpu.
+ * In addition, the CPU to IO channel mapping will be calculated
+ * and the phba->sli4_hba.cpu_map array will reflect this.
  */
-static int
-lpfc_find_next_cpu(struct lpfc_hba *phba, uint32_t phys_id)
+static void
+lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 {
 	struct lpfc_vector_map_info *cpup;
+	int index = 0;
+	int vec = 0;
 	int cpu;
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (lpfc_used_cpu[cpu] == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-
-	/*
-	 * If we get here, we have used ALL CPUs for the specific
-	 * phys_id. Now we need to clear out lpfc_used_cpu and start
-	 * reusing CPUs.
-	 */
-
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		if (lpfc_used_cpu[cpu] == phys_id)
-			lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
-	}
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-	return LPFC_VECTOR_MAP_EMPTY;
-}
-
-/**
- * lpfc_sli4_set_affinity - Set affinity for HBA IRQ vectors
- * @phba:	pointer to lpfc hba data structure.
- * @vectors:	number of HBA vectors
- *
- * Affinitize MSIX IRQ vectors to CPUs. Try to equally spread vector
- * affinization across multple physical CPUs (numa nodes).
- * In addition, this routine will assign an IO channel for each CPU
- * to use when issuing I/Os.
- */
-static int
-lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
-{
-	int i, idx, saved_chann, used_chann, cpu, phys_id;
-	int max_phys_id, min_phys_id;
-	int num_io_channel, first_cpu, chan;
-	struct lpfc_vector_map_info *cpup;
 #ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo;
 #endif
-	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
-
-	/* If there is no mapping, just return */
-	if (!phba->cfg_fcp_cpu_map)
-		return 1;
 
 	/* Init cpu_map array */
 	memset(phba->sli4_hba.cpu_map, 0xff,
 	       (sizeof(struct lpfc_vector_map_info) *
-		phba->sli4_hba.num_present_cpu));
-
-	max_phys_id = 0;
-	min_phys_id = 0xff;
-	phys_id = 0;
-	num_io_channel = 0;
-	first_cpu = LPFC_VECTOR_MAP_EMPTY;
+	       phba->sli4_hba.num_present_cpu));
 
 	/* Update CPU map with physical id and core id of each CPU */
 	cpup = phba->sli4_hba.cpu_map;
@@ -9268,187 +9516,18 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 		cpup->phys_id = 0;
 		cpup->core_id = 0;
 #endif
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3328 CPU physid %d coreid %d\n",
-				cpup->phys_id, cpup->core_id);
-
-		if (cpup->phys_id > max_phys_id)
-			max_phys_id = cpup->phys_id;
-		if (cpup->phys_id < min_phys_id)
-			min_phys_id = cpup->phys_id;
+		cpup->channel_id = index;  /* For now round robin */
+		cpup->irq = phba->sli4_hba.msix_entries[vec].vector;
+		vec++;
+		if (vec >= vectors)
+			vec = 0;
+		index++;
+		if (index >= phba->cfg_fcp_max_hw_queue)
+			index = 0;
 		cpup++;
 	}
-
-	phys_id = min_phys_id;
-	/* Now associate the HBA vectors with specific CPUs */
-	for (idx = 0; idx < vectors; idx++) {
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = lpfc_find_next_cpu(phba, phys_id);
-		if (cpu == LPFC_VECTOR_MAP_EMPTY) {
-
-			/* Try for all phys_id's */
-			for (i = 1; i < max_phys_id; i++) {
-				phys_id++;
-				if (phys_id > max_phys_id)
-					phys_id = min_phys_id;
-				cpu = lpfc_find_next_cpu(phba, phys_id);
-				if (cpu == LPFC_VECTOR_MAP_EMPTY)
-					continue;
-				goto found;
-			}
-
-			/* Use round robin for scheduling */
-			phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_ROUND_ROBIN;
-			chan = 0;
-			cpup = phba->sli4_hba.cpu_map;
-			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-				cpup->channel_id = chan;
-				cpup++;
-				chan++;
-				if (chan >= phba->cfg_fcp_io_channel)
-					chan = 0;
-			}
-
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3329 Cannot set affinity:"
-					"Error mapping vector %d (%d)\n",
-					idx, vectors);
-			return 0;
-		}
-found:
-		cpup += cpu;
-		if (phba->cfg_fcp_cpu_map == LPFC_DRIVER_CPU_MAP)
-			lpfc_used_cpu[cpu] = phys_id;
-
-		/* Associate vector with selected CPU */
-		cpup->irq = phba->sli4_hba.msix_entries[idx].vector;
-
-		/* Associate IO channel with selected CPU */
-		cpup->channel_id = idx;
-		num_io_channel++;
-
-		if (first_cpu == LPFC_VECTOR_MAP_EMPTY)
-			first_cpu = cpu;
-
-		/* Now affinitize to the selected CPU */
-		i = irq_set_affinity_hint(phba->sli4_hba.msix_entries[idx].
-					  vector, get_cpu_mask(cpu));
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3330 Set Affinity: CPU %d channel %d "
-				"irq %d (%x)\n",
-				cpu, cpup->channel_id,
-				phba->sli4_hba.msix_entries[idx].vector, i);
-
-		/* Spread vector mapping across multple physical CPU nodes */
-		phys_id++;
-		if (phys_id > max_phys_id)
-			phys_id = min_phys_id;
-	}
-
-	/*
-	 * Finally fill in the IO channel for any remaining CPUs.
-	 * At this point, all IO channels have been assigned to a specific
-	 * MSIx vector, mapped to a specific CPU.
-	 * Base the remaining IO channel assigned, to IO channels already
-	 * assigned to other CPUs on the same phys_id.
-	 */
-	for (i = min_phys_id; i <= max_phys_id; i++) {
-		/*
-		 * If there are no io channels already mapped to
-		 * this phys_id, just round robin thru the io_channels.
-		 * Setup chann[] for round robin.
-		 */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
-			chann[idx] = idx;
-
-		saved_chann = 0;
-		used_chann = 0;
-
-		/*
-		 * First build a list of IO channels already assigned
-		 * to this phys_id before reassigning the same IO
-		 * channels to the remaining CPUs.
-		 */
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = first_cpu;
-		cpup += cpu;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu;
-		     idx++) {
-			if (cpup->phys_id == i) {
-				/*
-				 * Save any IO channels that are
-				 * already mapped to this phys_id.
-				 */
-				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
-					if (saved_chann <=
-					    LPFC_FCP_IO_CHAN_MAX) {
-						chann[saved_chann] =
-							cpup->channel_id;
-						saved_chann++;
-					}
-					goto out;
-				}
-
-				/* See if we are using round-robin */
-				if (saved_chann == 0)
-					saved_chann =
-						phba->cfg_fcp_io_channel;
-
-				/* Associate next IO channel with CPU */
-				cpup->channel_id = chann[used_chann];
-				num_io_channel++;
-				used_chann++;
-				if (used_chann == saved_chann)
-					used_chann = 0;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3331 Set IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-out:
-			cpu++;
-			if (cpu >= phba->sli4_hba.num_present_cpu) {
-				cpup = phba->sli4_hba.cpu_map;
-				cpu = 0;
-			} else {
-				cpup++;
-			}
-		}
-	}
-
-	if (phba->sli4_hba.num_online_cpu != phba->sli4_hba.num_present_cpu) {
-		cpup = phba->sli4_hba.cpu_map;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
-			if (cpup->channel_id == LPFC_VECTOR_MAP_EMPTY) {
-				cpup->channel_id = 0;
-				num_io_channel++;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3332 Assign IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-			cpup++;
-		}
-	}
-
-	/* Sanity check */
-	if (num_io_channel != phba->sli4_hba.num_present_cpu)
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3333 Set affinity mismatch:"
-				"%d chann != %d cpus: %d vectors\n",
-				num_io_channel, phba->sli4_hba.num_present_cpu,
-				vectors);
-
-	/* Enable using cpu affinity for scheduling */
-	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
-	return 1;
 }
 
-
 /**
  * lpfc_sli4_enable_msix - Enable MSI-X interrupt mode to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
@@ -9471,15 +9550,19 @@ static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
+	int io_channel;
 	unsigned int irq_flags;
 	uint32_t min_cnt;
 
+	io_channel = phba->io_channel;
+	rc = 0;
+
 	/* Set up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
+	for (index = 0; index < io_channel; index++)
 		phba->sli4_hba.msix_entries[index].entry = index;
 
 	/* Configure MSI-X capability structure */
-	vectors = phba->cfg_fcp_io_channel;
+	vectors = io_channel;
 	if (phba->cfg_fof) {
 		phba->sli4_hba.msix_entries[index].entry = index;
 		vectors++;
@@ -9496,8 +9579,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d) min 2 "
 				"max %d\n",
-				vectors, phba->cfg_fcp_io_channel);
-		rc = -1;
+				vectors, io_channel);
 		goto vec_fail_out;
 	}
 
@@ -9522,21 +9604,21 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+		atomic_set(&phba->sli4_hba.hba_eq_hdl[index].hba_eq_in_use, 1);
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		else
 			rc = request_irq(
 				phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -9548,23 +9630,29 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	if (phba->cfg_fof)
 		vectors--;
 
-	if (vectors != phba->cfg_fcp_io_channel) {
+	if (vectors != io_channel) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3238 Reducing IO channels to match number of "
 				"MSI-X vectors, requested %d got %d\n",
 				phba->cfg_fcp_io_channel, vectors);
-		phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > vectors)
+			phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_nvme_io_channel > vectors)
+			phba->cfg_nvme_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+			phba->io_channel = phba->cfg_fcp_io_channel;
+		else
+			phba->io_channel = phba->cfg_nvme_io_channel;
 	}
+	lpfc_cpu_affinity_check(phba, vectors);
 
-	if (!shost_use_blk_mq(lpfc_shost_from_vport(phba->pport)))
-		lpfc_sli4_set_affinity(phba, vectors);
 	return rc;
 
 cfg_fail_out:
 	/* free the irq already requested */
 	for (--index; index >= 0; index--) {
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 	pci_free_irq_vectors(phba->pcidev);
 
@@ -9585,13 +9673,13 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
 	int index;
 
 	/* Free up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
+	for (index = 0; index < phba->io_channel; index++) {
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 	if (phba->cfg_fof) {
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
-			 &phba->sli4_hba.fcp_eq_hdl[index]);
+			 &phba->sli4_hba.hba_eq_hdl[index]);
 	}
 	pci_free_irq_vectors(phba->pcidev);
 	return;
@@ -9644,14 +9732,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+	for (index = 0; index < phba->io_channel; index++) {
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
 	}
 
 	if (phba->cfg_fof) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
 	}
 	return 0;
 }
@@ -9669,10 +9757,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 static void
 lpfc_sli4_disable_msi(struct lpfc_hba *phba)
 {
-	int vector;
-
-	vector = pci_irq_vector(phba->pcidev, 0);
-	free_irq(vector, phba);
+	free_irq(phba->pcidev->irq, phba);
 	pci_free_irq_vectors(phba->pcidev);
 	return;
 }
@@ -9698,6 +9783,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 {
 	uint32_t intr_mode = LPFC_INTR_ERROR;
 	int retval, index, vector;
+	unsigned int irq_flags;
 
 	if (cfg_mode == 2) {
 		/* Now, try to enable MSI-X interrupt mode */
@@ -9721,9 +9807,11 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 
 	/* Fallback to INTx if both MSI-X/MSI initalization failed */
 	if (phba->intr_type == NONE) {
+		/* Tell the PCI layer to affinitize the vector. */
+		irq_flags = PCI_IRQ_LEGACY | PCI_IRQ_AFFINITY;
+
 		/* Only 1 vector. */
-		retval = pci_alloc_irq_vectors(phba->pcidev, 1, 1,
-						PCI_IRQ_LEGACY);
+		retval = pci_alloc_irq_vectors(phba->pcidev, 1, 1, irq_flags);
 		if (retval < 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"6313 Failed to Alloc INTX Vector "
@@ -9743,18 +9831,17 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			/* Indicate initialization to INTx mode */
 			phba->intr_type = INTx;
 			intr_mode = 0;
-			for (index = 0; index < phba->cfg_fcp_io_channel;
-			     index++) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+			for (index = 0; index < phba->io_channel; index++) {
+				phba->sli4_hba.hba_eq_hdl[index].idx = index;
+				phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+				atomic_set(&phba->sli4_hba.hba_eq_hdl[index].
+					hba_eq_in_use, 1);
 			}
 			if (phba->cfg_fof) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+				phba->sli4_hba.hba_eq_hdl[index].idx = index;
+				phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+				atomic_set(&phba->sli4_hba.hba_eq_hdl[index].
+					hba_eq_in_use, 1);
 			}
 		}
 	}
@@ -9773,23 +9860,19 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 static void
 lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 {
-	int vector;
-
 	/* Disable the currently initialized interrupt mode */
 	if (phba->intr_type == MSIX)
 		lpfc_sli4_disable_msix(phba);
 	else if (phba->intr_type == MSI)
 		lpfc_sli4_disable_msi(phba);
 	else if (phba->intr_type == INTx) {
-		vector = pci_irq_vector(phba->pcidev, 0);
-		free_irq(vector, phba);
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 	}
 
 	/* Reset interrupt management states */
 	phba->intr_type = NONE;
 	phba->sli.slistat.sli_intr = 0;
-
 	return;
 }
 
@@ -9843,11 +9926,24 @@ static void
 lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 {
 	int wait_time = 0;
-	int fcp_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	int nvme_xri_cmpl = 1;
+	int fcp_xri_cmpl = 1;
 	int els_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 
-	while (!fcp_xri_cmpl || !els_xri_cmpl) {
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+		fcp_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		nvme_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+
+	while (!fcp_xri_cmpl || !els_xri_cmpl || !nvme_xri_cmpl) {
 		if (wait_time > LPFC_XRI_EXCH_BUSY_WAIT_TMO) {
+			if (!nvme_xri_cmpl)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6100 NVME XRI exchange busy "
+						"wait time: %d seconds.\n",
+						wait_time/1000);
 			if (!fcp_xri_cmpl)
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"2877 FCP XRI exchange busy "
@@ -9864,8 +9960,14 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 			msleep(LPFC_XRI_EXCH_BUSY_WAIT_T1);
 			wait_time += LPFC_XRI_EXCH_BUSY_WAIT_T1;
 		}
-		fcp_xri_cmpl =
-			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+			nvme_xri_cmpl = list_empty(
+				&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+			fcp_xri_cmpl = list_empty(
+				&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+
 		els_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 	}
@@ -10079,10 +10181,35 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	sli4_params->wqsize = bf_get(cfg_wqsize, mbx_sli4_parameters);
 	sli4_params->sgl_pages_max = bf_get(cfg_sgl_page_cnt,
 					    mbx_sli4_parameters);
+	sli4_params->wqpcnt = bf_get(cfg_wqpcnt, mbx_sli4_parameters);
 	sli4_params->sgl_pp_align = bf_get(cfg_sgl_pp_align,
 					   mbx_sli4_parameters);
 	phba->sli4_hba.extents_in_use = bf_get(cfg_ext, mbx_sli4_parameters);
 	phba->sli4_hba.rpi_hdrs_in_use = bf_get(cfg_hdrr, mbx_sli4_parameters);
+	phba->nvme_support = (bf_get(cfg_nvme, mbx_sli4_parameters) &&
+			      bf_get(cfg_xib, mbx_sli4_parameters));
+
+	if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP) ||
+	    !phba->nvme_support) {
+		phba->nvme_support = 0;
+		phba->nvmet_support = 0;
+		phba->cfg_nvme_io_channel = 0;
+		phba->cfg_nvme_max_hw_queue = 0;
+		phba->io_channel = phba->cfg_fcp_io_channel;
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_NVME,
+				"6101 Disabling NVME support: "
+				"Not supported by firmware: %d %d\n",
+				bf_get(cfg_nvme, mbx_sli4_parameters),
+				bf_get(cfg_xib, mbx_sli4_parameters));
+
+		/* If firmware doesn't support NVME, just use SCSI support */
+		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+			return -ENODEV;
+		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
+	}
+
+	if (bf_get(cfg_xib, mbx_sli4_parameters) && phba->cfg_suppress_rsp)
+		phba->sli.sli_flag |= LPFC_SLI_SUPPRESS_RSP;
 
 	/* Make sure that sge_supp_len can be handled by the driver */
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
@@ -10157,14 +10284,6 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_disable_pci_dev;
 	}
 
-	/* Set up phase-1 common device driver resources */
-	error = lpfc_setup_driver_resource_phase1(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1403 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s3;
-	}
-
 	/* Set up SLI-3 specific device driver resources */
 	error = lpfc_sli_driver_resource_setup(phba);
 	if (error) {
@@ -10300,6 +10419,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	struct lpfc_vport **vports;
 	struct lpfc_hba   *phba = vport->phba;
 	int i;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
@@ -10361,7 +10481,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	lpfc_scsi_free(phba);
 	lpfc_mem_free_all(phba);
 
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(phba),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 
 	/* Free resources associated with SLI2 interface */
@@ -10374,7 +10494,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 
 	lpfc_hba_free(phba);
 
-	pci_release_mem_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 	pci_disable_device(pdev);
 }
 
@@ -10719,27 +10839,46 @@ int
 lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
 {
 	int max_xri = phba->sli4_hba.max_cfg_param.max_xri;
+	int i;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (max_xri <= 100)
-			return 10;
+			i = 10;
 		else if (max_xri <= 256)
-			return 25;
+			i = 25;
 		else if (max_xri <= 512)
-			return 50;
+			i = 50;
 		else if (max_xri <= 1024)
-			return 100;
+			i = 100;
 		else if (max_xri <= 1536)
-			return 150;
+			i = 150;
 		else if (max_xri <= 2048)
-			return 200;
+			i = 200;
 		else
-			return 250;
+			i = 250;
+
+		return i;
+
 	} else
 		return 0;
 }
 
 /**
+ * lpfc_sli4_get_iocb_cnt - Calculate the # of total IOCBs to reserve
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * returns the number of ELS/CT
+ **/
+int
+lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba)
+{
+	int max_xri = lpfc_sli4_get_els_iocb_cnt(phba);
+
+	return max_xri;
+}
+
+
+/**
  * lpfc_write_firmware - attempt to write a firmware image to the port
  * @fw: pointer to firmware image returned from request_firmware.
  * @phba: pointer to lpfc hba data structure.
@@ -10903,7 +11042,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct Scsi_Host  *shost = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
-	int adjusted_fcp_io_channel;
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -10928,14 +11066,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_disable_pci_dev;
 	}
 
-	/* Set up phase-1 common device driver resources */
-	error = lpfc_setup_driver_resource_phase1(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1411 Failed to set up driver resource.\n");
-		goto out_unset_pci_mem_s4;
-	}
-
 	/* Set up SLI-4 Specific device driver resources */
 	error = lpfc_sli4_driver_resource_setup(phba);
 	if (error) {
@@ -10991,9 +11121,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	shost = lpfc_shost_from_vport(vport); /* save shost for error cleanup */
 	/* Now, trying to enable interrupt and bring up the device */
 	cfg_mode = phba->cfg_use_msi;
-
 	/* Put device to a known state before enabling interrupt */
 	lpfc_stop_port(phba);
+
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, cfg_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
@@ -11003,11 +11133,15 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_free_sysfs_attr;
 	}
 	/* Default to single EQ for non-MSI-X */
-	if (phba->intr_type != MSIX)
-		adjusted_fcp_io_channel = 1;
-	else
-		adjusted_fcp_io_channel = phba->cfg_fcp_io_channel;
-	phba->cfg_fcp_io_channel = adjusted_fcp_io_channel;
+	if (phba->intr_type != MSIX) {
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
+			phba->cfg_fcp_io_channel = 1;
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+			phba->cfg_nvme_io_channel = 1;
+		phba->io_channel = 1;
+	}
+
+
 	/* Set up SLI-4 HBA */
 	if (lpfc_sli4_hba_setup(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -11023,6 +11157,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* todo: init: register port with nvme */
+
 	/* check for firmware upgrade or downgrade */
 	if (phba->cfg_request_firmware_upgrade)
 		lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
@@ -11094,8 +11230,11 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 
-	/* Perform cleanup on the physical port */
+	/* Perform ndlp cleanup on the physical port.  The nvme localport
+	 * is destroyed after to ensure all rports are io-disabled.
+	 */
 	lpfc_cleanup(vport);
+	/* todo: init: unregister port with nvme */
 
 	/*
 	 * Bring down the SLI Layer. This step disables all interrupts,
@@ -11113,6 +11252,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	 * buffers are released to their corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
+	lpfc_nvme_free(phba);
 
 	lpfc_sli4_driver_resource_unset(phba);
 
@@ -11758,7 +11898,7 @@ lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 int
 lpfc_fof_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
 	int rc;
 
 	rc = lpfc_eq_create(phba, phba->sli4_hba.fof_eq, LPFC_MAX_IMAX);
@@ -11777,8 +11917,11 @@ lpfc_fof_queue_setup(struct lpfc_hba *phba)
 		if (rc)
 			goto out_oas_wq;
 
-		phba->sli4_hba.oas_cq->pring = &psli->ring[LPFC_FCP_OAS_RING];
-		phba->sli4_hba.oas_ring = &psli->ring[LPFC_FCP_OAS_RING];
+		/* Bind this CQ/WQ to the NVME ring */
+		pring = phba->sli4_hba.oas_wq->pring;
+		pring->sli.sli4.wqp =
+			(void *)phba->sli4_hba.oas_wq;
+		phba->sli4_hba.oas_cq->pring = pring;
 	}
 
 	return 0;
@@ -11835,6 +11978,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 
 		phba->sli4_hba.oas_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
 
 	}
 	return 0;
@@ -11879,7 +12023,7 @@ lpfc_fof_queue_destroy(struct lpfc_hba *phba)
 
 MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
-static const struct pci_error_handlers lpfc_err_handler = {
+static struct pci_error_handlers lpfc_err_handler = {
 	.error_detected = lpfc_io_error_detected,
 	.slot_reset = lpfc_io_slot_reset,
 	.resume = lpfc_io_resume,
@@ -11901,7 +12045,7 @@ static const struct file_operations lpfc_mgmt_fop = {
 
 static struct miscdevice lpfc_mgmt_dev = {
 	.minor = MISC_DYNAMIC_MINOR,
-	.name = "lpfcmgmt",
+	.name = LPFCMGMT_NAME,
 	.fops = &lpfc_mgmt_fop,
 };
 
-- 
2.5.0

