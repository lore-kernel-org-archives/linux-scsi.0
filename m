From: jsmart2021@gmail.com
Subject: [PATCH v3 11/22] Fix driver unload/reload operation.
Date: Fri, 21 Apr 2017 16:04:55 -0700
Message-ID: <20170421230506.925-12-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34884 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426483AbdDUXF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:26 -0400
Received: by mail-oi0-f67.google.com with SMTP id m34so14689606oik.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:25 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

There are couple of different load/unload issues fixed with this patch.
One of the issues was reported by Junichi Nomura, a patch was submitted
by Johannes Thumsrhirn which did fix one of the problems but the fix in
this patch separates the pring free from the queue free and does not set
the parameter passed in to NULL.

issues:
(1) driver could not be unloaded and reloaded without some Oops or
 Panic occurring.
(2) The driver was panicking because of a corruption in the Memory
Manager when the iocb list was getting allocated.

Root cause for the memory corruption was a double free of the Work Queue
ring pointer memory - Freed once in the lpfc_sli4_queue_free when the CQ
was destroyed and again in lpfc_sli4_queue_free when the WQ was destroyed.

The pring free and the queue free were separated, the pring free was moved
to the wq destroy routine because it a better fit logically to delete the
ring with the wq.

The checkpatch flagged several alignmenet issues that were also corrected
with this patch.

The mboxq was never initialed correctly before it was used by the driver
this patch corrects that issue.

Reported-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 46 +++++++++++++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  7 ++++++-
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b56da01..cca7f81 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5815,6 +5815,12 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_vfi_blk_list);
 	INIT_LIST_HEAD(&phba->lpfc_vpi_blk_list);
 
+	/* Initialize mboxq lists. If the early init routines fail
+	 * these lists need to be correctly initialized.
+	 */
+	INIT_LIST_HEAD(&phba->sli.mboxq);
+	INIT_LIST_HEAD(&phba->sli.mboxq_cmpl);
+
 	/* initialize optic_state to 0xFF */
 	phba->sli4_hba.lnk_info.optic_state = 0xff;
 
@@ -5880,6 +5886,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					"READ_NV, mbxStatus x%x\n",
 					bf_get(lpfc_mqe_command, &mboxq->u.mqe),
 					bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+			mempool_free(mboxq, phba->mbox_mem_pool);
 			rc = -EIO;
 			goto out_free_bsmbx;
 		}
@@ -7805,7 +7812,7 @@ lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
 
 	/* Create Fast Path FCP WQs */
 	wqesize = (phba->fcp_embed_io) ?
-				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
+		LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
 	qdesc = lpfc_sli4_queue_alloc(phba, wqesize, phba->sli4_hba.wq_ecount);
 	if (!qdesc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -7836,7 +7843,7 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	int idx, io_channel, max;
+	int idx, io_channel;
 
 	/*
 	 * Create HBA Record arrays.
@@ -7997,15 +8004,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		if (lpfc_alloc_nvme_wq_cq(phba, idx))
 			goto out_error;
 
-	/* allocate MRQ CQs */
-	max = phba->cfg_nvme_io_channel;
-	if (max < phba->cfg_nvmet_mrq)
-		max = phba->cfg_nvmet_mrq;
-
-	for (idx = 0; idx < max; idx++)
-		if (lpfc_alloc_nvme_wq_cq(phba, idx))
-			goto out_error;
-
 	if (phba->nvmet_support) {
 		for (idx = 0; idx < phba->cfg_nvmet_mrq; idx++) {
 			qdesc = lpfc_sli4_queue_alloc(phba,
@@ -8227,11 +8225,11 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 
 	/* Release FCP cqs */
 	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_cq,
-					phba->cfg_fcp_io_channel);
+				 phba->cfg_fcp_io_channel);
 
 	/* Release FCP wqs */
 	lpfc_sli4_release_queues(&phba->sli4_hba.fcp_wq,
-					phba->cfg_fcp_io_channel);
+				 phba->cfg_fcp_io_channel);
 
 	/* Release FCP CQ mapping array */
 	lpfc_sli4_release_queue_map(&phba->sli4_hba.fcp_cq_map);
@@ -8577,15 +8575,15 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0528 %s not allocated\n",
 				phba->sli4_hba.mbx_cq ?
-						"Mailbox WQ" : "Mailbox CQ");
+				"Mailbox WQ" : "Mailbox CQ");
 		rc = -ENOMEM;
 		goto out_destroy;
 	}
 
 	rc = lpfc_create_wq_cq(phba, phba->sli4_hba.hba_eq[0],
-					phba->sli4_hba.mbx_cq,
-					phba->sli4_hba.mbx_wq,
-					NULL, 0, LPFC_MBOX);
+			       phba->sli4_hba.mbx_cq,
+			       phba->sli4_hba.mbx_wq,
+			       NULL, 0, LPFC_MBOX);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0529 Failed setup of mailbox WQ/CQ: rc = 0x%x\n",
@@ -10054,9 +10052,14 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Stop kthread signal shall trigger work_done one more time */
 	kthread_stop(phba->worker_thread);
 
+	/* Unset the queues shared with the hardware then release all
+	 * allocated resources.
+	 */
+	lpfc_sli4_queue_unset(phba);
+	lpfc_sli4_queue_destroy(phba);
+
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
-	lpfc_sli4_queue_destroy(phba);
 
 	/* Stop the SLI4 device port */
 	phba->pport->work_port_events = 0;
@@ -10312,6 +10315,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 	}
 
 	/* Initialize and populate the iocb list per host */
+
 	error = lpfc_init_iocb_list(phba, LPFC_IOCB_LIST_CNT);
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -11092,7 +11096,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	}
 
 	/* Initialize and populate the iocb list per host */
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2821 initialize iocb list %d.\n",
 			phba->cfg_iocb_cnt*1024);
@@ -11183,7 +11186,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if ((phba->nvmet_support == 0) &&
 	    (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
 		/* Create NVME binding with nvme_fc_transport. This
-		 * ensures the vport is initialized.
+		 * ensures the vport is initialized.  If the localport
+		 * create fails, it should not unload the driver to
+		 * support field issues.
 		 */
 		error = lpfc_nvme_create_localport(vport);
 		if (error) {
@@ -11191,7 +11196,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 					"6004 NVME registration failed, "
 					"error x%x\n",
 					error);
-			goto out_disable_intr;
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7087c55..d606944 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13758,7 +13758,10 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 		lpfc_free_rq_buffer(queue->phba, queue);
 		kfree(queue->rqbp);
 	}
-	kfree(queue->pring);
+
+	if (!list_empty(&queue->wq_list))
+		list_del(&queue->wq_list);
+
 	kfree(queue);
 	return;
 }
@@ -15561,6 +15564,8 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 	}
 	/* Remove wq from any list */
 	list_del_init(&wq->list);
+	kfree(wq->pring);
+	wq->pring = NULL;
 	mempool_free(mbox, wq->phba->mbox_mem_pool);
 	return status;
 }
-- 
2.9.3
