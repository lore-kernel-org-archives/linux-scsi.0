From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 06/18] lpfc: NVME Initiator: Base modifications Part D
Date: Mon, 06 Feb 2017 15:08:55 -0800
Message-ID: <58990207.1rRnbm+/98nTIi97%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36683 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbdBFXJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:02 -0500
Received: by mail-wr0-f196.google.com with SMTP id k90so3991290wrc.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:01 -0800 (PST)
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

This patch by itself will not result in a compilable driver. All parts
A..F must be applied to create a compilable driver.

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
 Note: this was patch 5 in the V1 patches
 Address review items:
  Refactored a lot of queue create routines, deletion routines, etc
 Sync with max_hw_queues/io_channel/io_channel_irqs change

 drivers/scsi/lpfc/lpfc_init.c | 1366 +++++++++++++++++++++--------------------
 1 file changed, 700 insertions(+), 666 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 516542a..ea720bc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7483,10 +7483,67 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	/* Get CQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
 	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
+	return 0;
+}
+
+static int
+lpfc_alloc_nvme_wq_cq(struct lpfc_hba *phba, int wqidx)
+{
+	struct lpfc_queue *qdesc;
+	int cnt;
+
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					    phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0508 Failed allocate fast-path NVME CQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.nvme_cq[wqidx] = qdesc;
 
+	cnt = LPFC_NVME_WQSIZE;
+	qdesc = lpfc_sli4_queue_alloc(phba, LPFC_WQE128_SIZE, cnt);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0509 Failed allocate fast-path NVME WQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.nvme_wq[wqidx] = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+	return 0;
+}
+
+static int
+lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
+{
+	struct lpfc_queue *qdesc;
+	uint32_t wqesize;
+
+	/* Create Fast Path FCP CQs */
+	qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					phba->sli4_hba.cq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0499 Failed allocate fast-path FCP CQ (%d)\n", wqidx);
+		return 1;
+	}
+	phba->sli4_hba.fcp_cq[wqidx] = qdesc;
+
+	/* Create Fast Path FCP WQs */
+	wqesize = (phba->fcp_embed_io) ?
+				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
+	qdesc = lpfc_sli4_queue_alloc(phba, wqesize, phba->sli4_hba.wq_ecount);
+	if (!qdesc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0503 Failed allocate fast-path FCP WQ (%d)\n",
+				wqidx);
+		return 1;
+	}
+	phba->sli4_hba.fcp_wq[wqidx] = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
 	return 0;
-out_error:
-	return -ENOMEM;
 }
 
 /**
@@ -7507,13 +7564,14 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	uint32_t wqesize;
-	int idx;
+	int idx, io_channel;
 
 	/*
 	 * Create HBA Record arrays.
+	 * Both NVME and FCP will share that same vectors / EQs
 	 */
-	if (!phba->cfg_fcp_io_channel)
+	io_channel = phba->io_channel_irqs;
+	if (!io_channel)
 		return -ERANGE;
 
 	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
@@ -7522,9 +7580,14 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	phba->sli4_hba.wq_ecount = LPFC_WQE_DEF_COUNT;
 	phba->sli4_hba.rq_esize = LPFC_RQE_SIZE;
 	phba->sli4_hba.rq_ecount = LPFC_RQE_DEF_COUNT;
+	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
+	phba->sli4_hba.eq_ecount = LPFC_EQE_DEF_COUNT;
+	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
+	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
 
-	phba->sli4_hba.hba_eq =  kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
+	phba->sli4_hba.hba_eq =  kcalloc(io_channel,
+					sizeof(struct lpfc_queue *),
+					GFP_KERNEL);
 	if (!phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2576 Failed allocate memory for "
@@ -7532,44 +7595,83 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 
-	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2577 Failed allocate memory for fast-path "
-				"CQ record array\n");
-		goto out_error;
+	if (phba->cfg_fcp_io_channel) {
+		phba->sli4_hba.fcp_cq = kcalloc(phba->cfg_fcp_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2577 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
+		phba->sli4_hba.fcp_wq = kcalloc(phba->cfg_fcp_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2578 Failed allocate memory for "
+					"fast-path FCP WQ record array\n");
+			goto out_error;
+		}
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a FCP fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.fcp_cq_map = kcalloc(phba->cfg_fcp_io_channel,
+							sizeof(uint16_t),
+							GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2545 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
-	phba->sli4_hba.fcp_wq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2578 Failed allocate memory for fast-path "
-				"WQ record array\n");
-		goto out_error;
-	}
+	if (phba->cfg_nvme_io_channel) {
+		phba->sli4_hba.nvme_cq = kcalloc(phba->cfg_nvme_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6077 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
 
-	/*
-	 * Since the first EQ can have multiple CQs associated with it,
-	 * this array is used to quickly see if we have a FCP fast-path
-	 * CQ match.
-	 */
-	phba->sli4_hba.fcp_cq_map = kzalloc((sizeof(uint16_t) *
-					 phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq_map) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2545 Failed allocate memory for fast-path "
-				"CQ map\n");
-		goto out_error;
+
+		phba->sli4_hba.nvme_wq = kcalloc(phba->cfg_nvme_io_channel,
+						sizeof(struct lpfc_queue *),
+						GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2581 Failed allocate memory for "
+					"fast-path NVME WQ record array\n");
+			goto out_error;
+		}
+
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a NVME fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.nvme_cq_map = kcalloc(phba->cfg_nvme_io_channel,
+							sizeof(uint16_t),
+							GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6078 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
-	/*
-	 * Create HBA Event Queues (EQs).  The cfg_fcp_io_channel specifies
-	 * how many EQs to create.
-	 */
-	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
 
+	/* Create HBA Event Queues (EQs) */
+	for (idx = 0; idx < io_channel; idx++) {
 		/* Create EQs */
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
 					      phba->sli4_hba.eq_ecount);
@@ -7579,32 +7681,17 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 		}
 		phba->sli4_hba.hba_eq[idx] = qdesc;
+	}
 
-		/* Create Fast Path FCP CQs */
-		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
-					      phba->sli4_hba.cq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0499 Failed allocate fast-path FCP "
-					"CQ (%d)\n", idx);
-			goto out_error;
-		}
-		phba->sli4_hba.fcp_cq[idx] = qdesc;
+	/* FCP and NVME io channels are not required to be balanced */
 
-		/* Create Fast Path FCP WQs */
-		wqesize = (phba->fcp_embed_io) ?
-				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
-		qdesc = lpfc_sli4_queue_alloc(phba, wqesize,
-						phba->sli4_hba.wq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0503 Failed allocate fast-path FCP "
-					"WQ (%d)\n", idx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		if (lpfc_alloc_fcp_wq_cq(phba, idx))
 			goto out_error;
-		}
-		phba->sli4_hba.fcp_wq[idx] = qdesc;
-	}
 
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		if (lpfc_alloc_nvme_wq_cq(phba, idx))
+			goto out_error;
 
 	/*
 	 * Create Slow Path Completion Queues (CQs)
@@ -7659,6 +7746,30 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 	phba->sli4_hba.els_wq = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Create NVME LS Complete Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					      phba->sli4_hba.cq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6079 Failed allocate NVME LS CQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_cq = qdesc;
+
+		/* Create NVME LS Work Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+					      phba->sli4_hba.wq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6080 Failed allocate NVME LS WQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+	}
 
 	/*
 	 * Create Receive Queue (RQ)
@@ -7694,6 +7805,39 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	return -ENOMEM;
 }
 
+static inline void
+__lpfc_sli4_release_queue(struct lpfc_queue **qp)
+{
+	if (*qp != NULL) {
+		lpfc_sli4_queue_free(*qp);
+		*qp = NULL;
+	}
+}
+
+static inline void
+lpfc_sli4_release_queues(struct lpfc_queue ***qs, int max)
+{
+	int idx;
+
+	if (*qs == NULL)
+		return;
+
+	for (idx = 0; idx < max; idx++)
+		__lpfc_sli4_release_queue(&(*qs)[idx]);
+
+	kfree(*qs);
+	*qs = NULL;
+}
+
+static inline void
+lpfc_sli4_release_queue_map(uint16_t **qmap)
+{
+	if (*qmap != NULL) {
+		kfree(*qmap);
+		*qmap = NULL;
+	}
+}
+
 /**
  * lpfc_sli4_queue_destroy - Destroy all the SLI4 queues
  * @phba: pointer to lpfc hba data structure.
@@ -7709,91 +7853,188 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 {
-	int idx;
-
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
 
-	if (phba->sli4_hba.hba_eq != NULL) {
-		/* Release HBA event queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.hba_eq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.hba_eq[idx]);
-				phba->sli4_hba.hba_eq[idx] = NULL;
-			}
-		}
-		kfree(phba->sli4_hba.hba_eq);
-		phba->sli4_hba.hba_eq = NULL;
-	}
+	/* Release HBA eqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.hba_eq, phba->io_channel_irqs);
 
-	if (phba->sli4_hba.fcp_cq != NULL) {
-		/* Release FCP completion queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.fcp_cq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_cq[idx]);
-				phba->sli4_hba.fcp_cq[idx] = NULL;
-			}
-		}
-		kfree(phba->sli4_hba.fcp_cq);
-		phba->sli4_hba.fcp_cq = NULL;
-	}
+	/* Release FCP cqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_cq,
+					phba->cfg_fcp_io_channel);
 
-	if (phba->sli4_hba.fcp_wq != NULL) {
-		/* Release FCP work queue */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-			if (phba->sli4_hba.fcp_wq[idx] != NULL) {
-				lpfc_sli4_queue_free(
-					phba->sli4_hba.fcp_wq[idx]);
-				phba->sli4_hba.fcp_wq[idx] = NULL;
-			}
-		}
-		kfree(phba->sli4_hba.fcp_wq);
-		phba->sli4_hba.fcp_wq = NULL;
-	}
+	/* Release FCP wqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_wq,
+					phba->cfg_fcp_io_channel);
 
 	/* Release FCP CQ mapping array */
-	if (phba->sli4_hba.fcp_cq_map != NULL) {
-		kfree(phba->sli4_hba.fcp_cq_map);
-		phba->sli4_hba.fcp_cq_map = NULL;
-	}
+	lpfc_sli4_release_queue_map(&phba->sli4_hba.fcp_cq_map);
+
+	/* Release NVME cqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvme_cq,
+					phba->cfg_nvme_io_channel);
+
+	/* Release NVME wqs */
+	lpfc_sli4_release_queues(&phba->sli4_hba.nvme_wq,
+					phba->cfg_nvme_io_channel);
+
+	/* Release NVME CQ mapping array */
+	lpfc_sli4_release_queue_map(&phba->sli4_hba.nvme_cq_map);
 
 	/* Release mailbox command work queue */
-	if (phba->sli4_hba.mbx_wq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.mbx_wq);
-		phba->sli4_hba.mbx_wq = NULL;
-	}
+	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_wq);
 
 	/* Release ELS work queue */
-	if (phba->sli4_hba.els_wq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.els_wq);
-		phba->sli4_hba.els_wq = NULL;
-	}
+	__lpfc_sli4_release_queue(&phba->sli4_hba.els_wq);
+
+	/* Release ELS work queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.nvmels_wq);
 
 	/* Release unsolicited receive queue */
-	if (phba->sli4_hba.hdr_rq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
-		phba->sli4_hba.hdr_rq = NULL;
+	__lpfc_sli4_release_queue(&phba->sli4_hba.hdr_rq);
+	__lpfc_sli4_release_queue(&phba->sli4_hba.dat_rq);
+
+	/* Release ELS complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.els_cq);
+
+	/* Release NVME LS complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.nvmels_cq);
+
+	/* Release mailbox command complete queue */
+	__lpfc_sli4_release_queue(&phba->sli4_hba.mbx_cq);
+
+	/* Everything on this list has been freed */
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
+}
+
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
 	}
-	if (phba->sli4_hba.dat_rq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.dat_rq);
-		phba->sli4_hba.dat_rq = NULL;
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
 	}
+	return 1;
+}
 
-	/* Release ELS complete queue */
-	if (phba->sli4_hba.els_cq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.els_cq);
-		phba->sli4_hba.els_cq = NULL;
+static int
+lpfc_create_wq_cq(struct lpfc_hba *phba, struct lpfc_queue *eq,
+	struct lpfc_queue *cq, struct lpfc_queue *wq, uint16_t *cq_map,
+	int qidx, uint32_t qtype)
+{
+	struct lpfc_sli_ring *pring;
+	int rc;
+
+	if (!eq || !cq || !wq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"6085 Fast-path %s (%d) not allocated\n",
+			((eq) ? ((cq) ? "WQ" : "CQ") : "EQ"), qidx);
+		return -ENOMEM;
 	}
 
-	/* Release mailbox command complete queue */
-	if (phba->sli4_hba.mbx_cq != NULL) {
-		lpfc_sli4_queue_free(phba->sli4_hba.mbx_cq);
-		phba->sli4_hba.mbx_cq = NULL;
+	/* create the Cq first */
+	rc = lpfc_cq_create(phba, cq, eq,
+			(qtype == LPFC_MBOX) ? LPFC_MCQ : LPFC_WCQ, qtype);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"6086 Failed setup of CQ (%d), rc = 0x%x\n",
+			qidx, (uint32_t)rc);
+		return rc;
 	}
 
-	return;
+	if (qtype != LPFC_MBOX) {
+		/* Setup nvme_cq_map for fast lookup */
+		if (cq_map)
+			*cq_map = cq->queue_id;
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"6087 CQ setup: cq[%d]-id=%d, parent eq[%d]-id=%d\n",
+			qidx, cq->queue_id, qidx, eq->queue_id);
+
+		/* create the wq */
+		rc = lpfc_wq_create(phba, wq, cq, qtype);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6123 Fail setup fastpath WQ (%d), rc = 0x%x\n",
+				qidx, (uint32_t)rc);
+			/* no need to tear down cq - caller will do so */
+			return rc;
+		}
+
+		/* Bind this CQ/WQ to the NVME ring */
+		pring = wq->pring;
+		pring->sli.sli4.wqp = (void *)wq;
+		cq->pring = pring;
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2593 WQ setup: wq[%d]-id=%d assoc=%d, cq[%d]-id=%d\n",
+			qidx, wq->queue_id, wq->assoc_qid, qidx, cq->queue_id);
+	} else {
+		rc = lpfc_mq_create(phba, wq, cq, LPFC_MBOX);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0539 Failed setup of slow-path MQ: "
+				"rc = 0x%x\n", rc);
+			/* no need to tear down cq - caller will do so */
+			return rc;
+		}
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
+			phba->sli4_hba.mbx_wq->queue_id,
+			phba->sli4_hba.mbx_cq->queue_id);
+	}
+
+	return 0;
 }
 
 /**
@@ -7811,15 +8052,12 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 int
 lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring;
-	int rc = -ENOMEM;
-	int fcp_eqidx, fcp_cqidx, fcp_wqidx;
-	int fcp_cq_index = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	LPFC_MBOXQ_t *mboxq;
-	uint32_t length;
+	int qidx;
+	uint32_t length, io_channel;
+	int rc = -ENOMEM;
 
 	/* Check for dual-ULP support */
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -7869,220 +8107,173 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	/*
 	 * Set up HBA Event Queues (EQs)
 	 */
+	io_channel = phba->io_channel_irqs;
 
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
+	for (qidx = 0; qidx < io_channel; qidx++) {
+		if (!phba->sli4_hba.hba_eq[qidx]) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0522 Fast-path EQ (%d) not "
-					"allocated\n", fcp_eqidx);
+					"allocated\n", qidx);
 			rc = -ENOMEM;
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
-		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[fcp_eqidx],
-			 (phba->cfg_fcp_imax / phba->cfg_fcp_io_channel));
+		rc = lpfc_eq_create(phba, phba->sli4_hba.hba_eq[qidx],
+						phba->cfg_fcp_imax);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0523 Failed setup of fast-path EQ "
-					"(%d), rc = 0x%x\n", fcp_eqidx,
+					"(%d), rc = 0x%x\n", qidx,
 					(uint32_t)rc);
-			goto out_destroy_hba_eq;
+			goto out_destroy;
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2584 HBA EQ setup: "
-				"queue[%d]-id=%d\n", fcp_eqidx,
-				phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id);
+				"2584 HBA EQ setup: queue[%d]-id=%d\n",
+				qidx, phba->sli4_hba.hba_eq[qidx]->queue_id);
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
+	if (phba->cfg_nvme_io_channel) {
+		if (!phba->sli4_hba.nvme_cq || !phba->sli4_hba.nvme_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0526 Fast-path FCP CQ (%d) not "
-					"allocated\n", fcp_cqidx);
+				"6084 Fast-path NVME %s array not allocated\n",
+				(phba->sli4_hba.nvme_cq) ? "CQ" : "WQ");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_cq;
-		}
-		rc = lpfc_cq_create(phba, phba->sli4_hba.fcp_cq[fcp_cqidx],
-			phba->sli4_hba.hba_eq[fcp_cqidx], LPFC_WCQ, LPFC_FCP);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0527 Failed setup of fast-path FCP "
-					"CQ (%d), rc = 0x%x\n", fcp_cqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_cq;
+			goto out_destroy;
 		}
 
-		/* Setup fcp_cq_map for fast lookup */
-		phba->sli4_hba.fcp_cq_map[fcp_cqidx] =
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id;
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2588 FCP CQ setup: cq[%d]-id=%d, "
-				"parent seq[%d]-id=%d\n",
-				fcp_cqidx,
-				phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id,
-				fcp_cqidx,
-				phba->sli4_hba.hba_eq[fcp_cqidx]->queue_id);
-	}
-
-	/* Set up fast-path FCP Work Queue */
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3149 Fast-path FCP WQ array not "
-				"allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_fcp_cq;
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+			rc = lpfc_create_wq_cq(phba,
+					phba->sli4_hba.hba_eq[
+						qidx % io_channel],
+					phba->sli4_hba.nvme_cq[qidx],
+					phba->sli4_hba.nvme_wq[qidx],
+					&phba->sli4_hba.nvme_cq_map[qidx],
+					qidx, LPFC_NVME);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6123 Failed to setup fastpath "
+					"NVME WQ/CQ (%d), rc = 0x%x\n",
+					qidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+		}
 	}
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++) {
-		if (!phba->sli4_hba.fcp_wq[fcp_wqidx]) {
+	if (phba->cfg_fcp_io_channel) {
+		/* Set up fast-path FCP Response Complete Queue */
+		if (!phba->sli4_hba.fcp_cq || !phba->sli4_hba.fcp_wq) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0534 Fast-path FCP WQ (%d) not "
-					"allocated\n", fcp_wqidx);
+				"3148 Fast-path FCP %s array not allocated\n",
+				phba->sli4_hba.fcp_cq ? "WQ" : "CQ");
 			rc = -ENOMEM;
-			goto out_destroy_fcp_wq;
-		}
-		rc = lpfc_wq_create(phba, phba->sli4_hba.fcp_wq[fcp_wqidx],
-				    phba->sli4_hba.fcp_cq[fcp_wqidx],
-				    LPFC_FCP);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0535 Failed setup of fast-path FCP "
-					"WQ (%d), rc = 0x%x\n", fcp_wqidx,
-					(uint32_t)rc);
-			goto out_destroy_fcp_wq;
+			goto out_destroy;
 		}
 
-		/* Bind this WQ to the next FCP ring */
-		pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + fcp_wqidx];
-		pring->sli.sli4.wqp = (void *)phba->sli4_hba.fcp_wq[fcp_wqidx];
-		phba->sli4_hba.fcp_cq[fcp_wqidx]->pring = pring;
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2591 FCP WQ setup: wq[%d]-id=%d, "
-				"parent cq[%d]-id=%d\n",
-				fcp_wqidx,
-				phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-				fcp_cq_index,
-				phba->sli4_hba.fcp_cq[fcp_wqidx]->queue_id);
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+			rc = lpfc_create_wq_cq(phba,
+					phba->sli4_hba.hba_eq[
+						qidx % io_channel],
+					phba->sli4_hba.fcp_cq[qidx],
+					phba->sli4_hba.fcp_wq[qidx],
+					&phba->sli4_hba.fcp_cq_map[qidx],
+					qidx, LPFC_FCP);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0535 Failed to setup fastpath "
+					"FCP WQ/CQ (%d), rc = 0x%x\n",
+					qidx, (uint32_t)rc);
+				goto out_destroy;
+			}
+		}
 	}
+
 	/*
-	 * Set up Complete Queues (CQs)
+	 * Set up Slow Path Complete Queues (CQs)
 	 */
 
-	/* Set up slow-path MBOX Complete Queue as the first CQ */
-	if (!phba->sli4_hba.mbx_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0528 Mailbox CQ not allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_fcp_wq;
-	}
-	rc = lpfc_cq_create(phba, phba->sli4_hba.mbx_cq,
-			phba->sli4_hba.hba_eq[0], LPFC_MCQ, LPFC_MBOX);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0529 Failed setup of slow-path mailbox CQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
-	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2585 MBX CQ setup: cq-id=%d, parent eq-id=%d\n",
-			phba->sli4_hba.mbx_cq->queue_id,
-			phba->sli4_hba.hba_eq[0]->queue_id);
+	/* Set up slow-path MBOX CQ/MQ */
 
-	/* Set up slow-path ELS Complete Queue */
-	if (!phba->sli4_hba.els_cq) {
+	if (!phba->sli4_hba.mbx_cq || !phba->sli4_hba.mbx_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0530 ELS CQ not allocated\n");
+				"0528 %s not allocated\n",
+				phba->sli4_hba.mbx_cq ?
+						"Mailbox WQ" : "Mailbox CQ");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_cq;
-	}
-	rc = lpfc_cq_create(phba, phba->sli4_hba.els_cq,
-			phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_ELS);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0531 Failed setup of slow-path ELS CQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_cq;
+		goto out_destroy;
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2586 ELS CQ setup: cq-id=%d, parent eq-id=%d\n",
-			phba->sli4_hba.els_cq->queue_id,
-			phba->sli4_hba.hba_eq[0]->queue_id);
-
-	/*
-	 * Set up all the Work Queues (WQs)
-	 */
 
-	/* Set up Mailbox Command Queue */
-	if (!phba->sli4_hba.mbx_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0538 Slow-path MQ not allocated\n");
-		rc = -ENOMEM;
-		goto out_destroy_els_cq;
-	}
-	rc = lpfc_mq_create(phba, phba->sli4_hba.mbx_wq,
-			    phba->sli4_hba.mbx_cq, LPFC_MBOX);
+	rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.mbx_cq,
+					phba->sli4_hba.mbx_wq,
+					NULL, 0, LPFC_MBOX);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0539 Failed setup of slow-path MQ: "
-				"rc = 0x%x\n", rc);
-		goto out_destroy_els_cq;
+			"0529 Failed setup of mailbox WQ/CQ: rc = 0x%x\n",
+			(uint32_t)rc);
+		goto out_destroy;
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2589 MBX MQ setup: wq-id=%d, parent cq-id=%d\n",
-			phba->sli4_hba.mbx_wq->queue_id,
-			phba->sli4_hba.mbx_cq->queue_id);
 
-	/* Set up slow-path ELS Work Queue */
-	if (!phba->sli4_hba.els_wq) {
+	/* Set up slow-path ELS WQ/CQ */
+	if (!phba->sli4_hba.els_cq || !phba->sli4_hba.els_wq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0536 Slow-path ELS WQ not allocated\n");
+				"0530 ELS %s not allocated\n",
+				phba->sli4_hba.els_cq ? "WQ" : "CQ");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_wq;
+		goto out_destroy;
 	}
-	rc = lpfc_wq_create(phba, phba->sli4_hba.els_wq,
-			    phba->sli4_hba.els_cq, LPFC_ELS);
+	rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.els_cq,
+					phba->sli4_hba.els_wq,
+					NULL, 0, LPFC_ELS);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0537 Failed setup of slow-path ELS WQ: "
-				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_wq;
+			"0529 Failed setup of ELS WQ/CQ: rc = 0x%x\n",
+			(uint32_t)rc);
+		goto out_destroy;
 	}
-
-	/* Bind this WQ to the ELS ring */
-	pring = &psli->ring[LPFC_ELS_RING];
-	pring->sli.sli4.wqp = (void *)phba->sli4_hba.els_wq;
-	phba->sli4_hba.els_cq->pring = pring;
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2590 ELS WQ setup: wq-id=%d, parent cq-id=%d\n",
 			phba->sli4_hba.els_wq->queue_id,
 			phba->sli4_hba.els_cq->queue_id);
 
-	/*
-	 * Create Receive Queue (RQ)
-	 */
+	if (phba->cfg_nvme_io_channel) {
+		/* Set up NVME LS Complete Queue */
+		if (!phba->sli4_hba.nvmels_cq || !phba->sli4_hba.nvmels_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6091 LS %s not allocated\n",
+					phba->sli4_hba.nvmels_cq ? "WQ" : "CQ");
+			rc = -ENOMEM;
+			goto out_destroy;
+		}
+		rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
+					phba->sli4_hba.nvmels_cq,
+					phba->sli4_hba.nvmels_wq,
+					NULL, 0, LPFC_NVME_LS);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0529 Failed setup of NVVME LS WQ/CQ: "
+				"rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy;
+		}
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
@@ -8094,7 +8285,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_fcp_wq;
+		goto out_destroy;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -8110,7 +8301,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0549 Failed setup of FOF Queues: "
 					"rc = 0x%x\n", rc);
-			goto out_destroy_els_rq;
+			goto out_destroy;
 		}
 	}
 
@@ -8118,30 +8309,12 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	 * Configure EQ delay multipier for interrupt coalescing using
 	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-			fcp_eqidx += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, fcp_eqidx);
+	for (qidx = 0; qidx < io_channel; qidx += LPFC_MAX_EQ_DELAY)
+		lpfc_modify_hba_eq_delay(phba, qidx);
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
@@ -8161,39 +8334,66 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 void
 lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 {
-	int fcp_qidx;
+	int qidx;
 
 	/* Unset the queues created for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_destroy(phba);
+
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
-	if (phba->sli4_hba.fcp_wq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[fcp_qidx]);
+	if (phba->sli4_hba.fcp_wq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_wq_destroy(phba, phba->sli4_hba.fcp_wq[qidx]);
+
+	/* Unset NVME work queue */
+	if (phba->sli4_hba.nvme_wq) {
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_wq_destroy(phba, phba->sli4_hba.nvme_wq[qidx]);
 	}
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
+	if (phba->sli4_hba.nvme_cq)
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_cq_destroy(phba, phba->sli4_hba.nvme_cq[qidx]);
+
 	/* Unset FCP response complete queue */
-	if (phba->sli4_hba.fcp_cq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[fcp_qidx]);
-	}
+	if (phba->sli4_hba.fcp_cq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_cq_destroy(phba, phba->sli4_hba.fcp_cq[qidx]);
+
 	/* Unset fast-path event queue */
-	if (phba->sli4_hba.hba_eq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++)
-			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[fcp_qidx]);
-	}
+	if (phba->sli4_hba.hba_eq)
+		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
+			lpfc_eq_destroy(phba, phba->sli4_hba.hba_eq[qidx]);
 }
 
 /**
@@ -8903,91 +9103,33 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_find_next_cpu - Find next available CPU that matches the phys_id
+ * lpfc_cpu_affinity_check - Check vector CPU affinity mappings
  * @phba: pointer to lpfc hba data structure.
- *
- * Find next available CPU to use for IRQ to CPU affinity.
+ * @vectors: number of msix vectors allocated.
+ *
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
@@ -9001,184 +9143,16 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
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
+		cpup->irq = pci_irq_vector(phba->pcidev, vec);
+		vec++;
+		if (vec >= vectors)
+			vec = 0;
+		index++;
+		if (index >= phba->cfg_fcp_io_channel)
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
-		cpup->irq = pci_irq_vector(phba->pcidev, idx);
-
-		/* Associate IO channel with selected CPU */
-		cpup->channel_id = idx;
-		num_io_channel++;
-
-		if (first_cpu == LPFC_VECTOR_MAP_EMPTY)
-			first_cpu = cpu;
-
-		/* Now affinitize to the selected CPU */
-		i = irq_set_affinity_hint(pci_irq_vector(phba->pcidev, idx),
-					  get_cpu_mask(cpu));
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3330 Set Affinity: CPU %d channel %d "
-				"irq %d (%x)\n",
-				cpu, cpup->channel_id,
-				pci_irq_vector(phba->pcidev, idx), i);
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
 
 
@@ -9199,11 +9173,12 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	int vectors, rc, index;
 
 	/* Set up MSI-X multi-message vectors */
-	vectors = phba->cfg_fcp_io_channel;
+	vectors = phba->io_channel_irqs;
 	if (phba->cfg_fof)
 		vectors++;
 
-	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors, PCI_IRQ_MSIX);
+	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors,
+				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
@@ -9218,19 +9193,19 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-		atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].fcp_eq_in_use, 1);
+		phba->sli4_hba.hba_eq_hdl[index].idx = index;
+		phba->sli4_hba.hba_eq_hdl[index].phba = phba;
+		atomic_set(&phba->sli4_hba.hba_eq_hdl[index].hba_eq_in_use, 1);
 		if (phba->cfg_fof && (index == (vectors - 1)))
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_fof_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		else
 			rc = request_irq(pci_irq_vector(phba->pcidev, index),
 				 &lpfc_sli4_hba_intr_handler, 0,
 				 (char *)&phba->sli4_hba.handler_name[index],
-				 &phba->sli4_hba.fcp_eq_hdl[index]);
+				 &phba->sli4_hba.hba_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -9242,26 +9217,29 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	if (phba->cfg_fof)
 		vectors--;
 
-	if (vectors != phba->cfg_fcp_io_channel) {
+	if (vectors != phba->io_channel_irqs) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3238 Reducing IO channels to match number of "
 				"MSI-X vectors, requested %d got %d\n",
-				phba->cfg_fcp_io_channel, vectors);
-		phba->cfg_fcp_io_channel = vectors;
+				phba->io_channel_irqs, vectors);
+		if (phba->cfg_fcp_io_channel > vectors)
+			phba->cfg_fcp_io_channel = vectors;
+		if (phba->cfg_nvme_io_channel > vectors)
+			phba->cfg_nvme_io_channel = vectors;
+		if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+			phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+		else
+			phba->io_channel_irqs = phba->cfg_nvme_io_channel;
 	}
+	lpfc_cpu_affinity_check(phba, vectors);
 
-	if (!shost_use_blk_mq(lpfc_shost_from_vport(phba->pport)))
-		lpfc_sli4_set_affinity(phba, vectors);
 	return rc;
 
 cfg_fail_out:
 	/* free the irq already requested */
-	for (--index; index >= 0; index--) {
-		int irq = pci_irq_vector(phba->pcidev, index);
-
-		irq_set_affinity_hint(irq, NULL);
-		free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
-	}
+	for (--index; index >= 0; index--)
+		free_irq(pci_irq_vector(phba->pcidev, index),
+				&phba->sli4_hba.hba_eq_hdl[index]);
 
 	/* Unconfigure MSI-X capability structure */
 	pci_free_irq_vectors(phba->pcidev);
@@ -9308,14 +9286,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 		return rc;
 	}
 
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
+	for (index = 0; index < phba->io_channel_irqs; index++) {
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
@@ -9340,7 +9318,7 @@ static uint32_t
 lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 {
 	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval, index;
+	int retval, idx;
 
 	if (cfg_mode == 2) {
 		/* Preparation before conf_msi mbox cmd */
@@ -9371,21 +9349,23 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
 				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
 		if (!retval) {
+			struct lpfc_hba_eq_hdl *eqhdl;
+
 			/* Indicate initialization to INTx mode */
 			phba->intr_type = INTx;
 			intr_mode = 0;
-			for (index = 0; index < phba->cfg_fcp_io_channel;
-			     index++) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+
+			for (idx = 0; idx < phba->io_channel_irqs; idx++) {
+				eqhdl = &phba->sli4_hba.hba_eq_hdl[idx];
+				eqhdl->idx = idx;
+				eqhdl->phba = phba;
+				atomic_set(&eqhdl->hba_eq_in_use, 1);
 			}
 			if (phba->cfg_fof) {
-				phba->sli4_hba.fcp_eq_hdl[index].idx = index;
-				phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
-				atomic_set(&phba->sli4_hba.fcp_eq_hdl[index].
-					fcp_eq_in_use, 1);
+				eqhdl = &phba->sli4_hba.hba_eq_hdl[idx];
+				eqhdl->idx = idx;
+				eqhdl->phba = phba;
+				atomic_set(&eqhdl->hba_eq_in_use, 1);
 			}
 		}
 	}
@@ -9409,15 +9389,13 @@ lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 		int index;
 
 		/* Free up MSI-X multi-message vectors */
-		for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-			int irq = pci_irq_vector(phba->pcidev, index);
-
-			irq_set_affinity_hint(irq, NULL);
-			free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
-		}
+		for (index = 0; index < phba->io_channel_irqs; index++)
+			free_irq(pci_irq_vector(phba->pcidev, index),
+					&phba->sli4_hba.hba_eq_hdl[index]);
 
 		if (phba->cfg_fof)
-			free_irq(pci_irq_vector(phba->pcidev, index), phba);
+			free_irq(pci_irq_vector(phba->pcidev, index),
+					&phba->sli4_hba.hba_eq_hdl[index]);
 	} else {
 		free_irq(phba->pcidev->irq, phba);
 	}
@@ -9479,11 +9457,24 @@ static void
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
@@ -9500,8 +9491,14 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
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
@@ -9715,10 +9712,34 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
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
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
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
@@ -9793,14 +9814,6 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
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
@@ -9997,7 +10010,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	lpfc_scsi_free(phba);
 	lpfc_mem_free_all(phba);
 
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(phba),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 
 	/* Free resources associated with SLI2 interface */
@@ -10355,27 +10368,46 @@ int
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
@@ -10539,7 +10571,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct Scsi_Host  *shost = NULL;
 	int error;
 	uint32_t cfg_mode, intr_mode;
-	int adjusted_fcp_io_channel;
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -10564,14 +10595,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
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
@@ -10627,9 +10650,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
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
@@ -10639,11 +10662,15 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
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
+		phba->io_channel_irqs = 1;
+	}
+
+
 	/* Set up SLI-4 HBA */
 	if (lpfc_sli4_hba_setup(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -10659,6 +10686,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* todo: init: register port with nvme */
+
 	/* check for firmware upgrade or downgrade */
 	if (phba->cfg_request_firmware_upgrade)
 		lpfc_sli4_request_firmware_update(phba, INT_FW_UPGRADE);
@@ -10730,8 +10759,11 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
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
@@ -10749,6 +10781,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	 * buffers are released to their corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
+	lpfc_nvme_free(phba);
 
 	lpfc_sli4_driver_resource_unset(phba);
 
@@ -11394,7 +11427,7 @@ lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 int
 lpfc_fof_queue_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
 	int rc;
 
 	rc = lpfc_eq_create(phba, phba->sli4_hba.fof_eq, LPFC_MAX_IMAX);
@@ -11413,8 +11446,11 @@ lpfc_fof_queue_setup(struct lpfc_hba *phba)
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
@@ -11471,6 +11507,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 			goto out_error;
 
 		phba->sli4_hba.oas_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
 
 	}
 	return 0;
@@ -11556,7 +11593,6 @@ static struct miscdevice lpfc_mgmt_dev = {
 static int __init
 lpfc_init(void)
 {
-	int cpu;
 	int error = 0;
 
 	printk(LPFC_MODULE_DESC "\n");
@@ -11582,9 +11618,7 @@ lpfc_init(void)
 
 	/* Initialize in case vector mapping is needed */
 	lpfc_used_cpu = NULL;
-	lpfc_present_cpu = 0;
-	for_each_present_cpu(cpu)
-		lpfc_present_cpu++;
+	lpfc_present_cpu = num_present_cpus();
 
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
-- 
2.5.0
