From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 04/15] lpfc: Fix nvmet RQ resource needs for large block writes.
Date: Wed, 10 May 2017 12:07:02 -0700
Message-ID: <20170510190713.30171-5-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35007 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753885AbdEJTH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:29 -0400
Received: by mail-qk0-f193.google.com with SMTP id k74so723670qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:28 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Large block writes to the nvme target were failing because
the default number of RQs posted was insufficient.

Expand the NVMET RQs to 2048 RQEs and ensure a minimun of 2048
RQEs are posted, no matter how many MRQs are configured.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c  |  4 ++--
 drivers/scsi/lpfc/lpfc_init.c  | 20 +++++++++++++++-----
 drivers/scsi/lpfc/lpfc_nvmet.c |  2 +-
 drivers/scsi/lpfc/lpfc_nvmet.h |  1 +
 drivers/scsi/lpfc/lpfc_sli.c   | 18 ++++++++++--------
 drivers/scsi/lpfc/lpfc_sli4.h  |  1 +
 6 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 41ec7451689b..ee4d9be95960 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -60,9 +60,9 @@
 #define LPFC_MIN_DEVLOSS_TMO	1
 #define LPFC_MAX_DEVLOSS_TMO	255
 
-#define LPFC_DEF_MRQ_POST	256
+#define LPFC_DEF_MRQ_POST	512
 #define LPFC_MIN_MRQ_POST	32
-#define LPFC_MAX_MRQ_POST	512
+#define LPFC_MAX_MRQ_POST	2048
 
 /*
  * Write key size should be multiple of 4. If write key is changed
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b1b181a756dc..66e3cc40d64e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3390,6 +3390,11 @@ lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
 	 */
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
 	nvmet_xri_cnt = phba->cfg_nvmet_mrq * phba->cfg_nvmet_mrq_post;
+
+	/* Ensure we at least meet the minimun for the system */
+	if (nvmet_xri_cnt < LPFC_NVMET_RQE_DEF_COUNT)
+		nvmet_xri_cnt = LPFC_NVMET_RQE_DEF_COUNT;
+
 	tot_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
 	if (nvmet_xri_cnt > tot_cnt) {
 		phba->cfg_nvmet_mrq_post = tot_cnt / phba->cfg_nvmet_mrq;
@@ -8158,7 +8163,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			/* Create NVMET Receive Queue for header */
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.rq_esize,
-						      phba->sli4_hba.rq_ecount);
+						      LPFC_NVMET_RQE_DEF_COUNT);
 			if (!qdesc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"3146 Failed allocate "
@@ -8180,7 +8185,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			/* Create NVMET Receive Queue for data */
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.rq_esize,
-						      phba->sli4_hba.rq_ecount);
+						      LPFC_NVMET_RQE_DEF_COUNT);
 			if (!qdesc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"3156 Failed allocate "
@@ -11096,7 +11101,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error, cnt;
+	int error, cnt, num;
 	uint32_t cfg_mode, intr_mode;
 
 	/* Allocate memory for HBA structure */
@@ -11131,8 +11136,13 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	}
 
 	cnt = phba->cfg_iocb_cnt * 1024;
-	if (phba->nvmet_support)
-		cnt += phba->cfg_nvmet_mrq_post * phba->cfg_nvmet_mrq;
+	if (phba->nvmet_support) {
+		/* Ensure we at least meet the minimun for the system */
+		num = (phba->cfg_nvmet_mrq_post * phba->cfg_nvmet_mrq);
+		if (num < LPFC_NVMET_RQE_DEF_COUNT)
+			num = LPFC_NVMET_RQE_DEF_COUNT;
+		cnt += num;
+	}
 
 	/* Initialize and populate the iocb list per host */
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index bb12e2c9fbf4..dfa7296499cf 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -614,9 +614,9 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmeio_data(phba, "NVMET FCP CMND: xri x%x op x%x len x%x\n",
 			 ctxp->oxid, rsp->op, rsp->rsplen);
 
+	ctxp->flag |= LPFC_NVMET_IO_INP;
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, nvmewqeq);
 	if (rc == WQE_SUCCESS) {
-		ctxp->flag |= LPFC_NVMET_IO_INP;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 		if (!phba->ktime_on)
 			return 0;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 837210a3e7c8..55f2a859dc70 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -22,6 +22,7 @@
  ********************************************************************/
 
 #define LPFC_NVMET_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
+#define LPFC_NVMET_RQE_DEF_COUNT	512
 #define LPFC_NVMET_SUCCESS_LEN	12
 
 /* Used for NVME Target */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 333c5094b97d..cdf02a957690 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -479,22 +479,23 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 	if (unlikely(!hq) || unlikely(!dq))
 		return -ENOMEM;
 	put_index = hq->host_index;
-	temp_hrqe = hq->qe[hq->host_index].rqe;
+	temp_hrqe = hq->qe[put_index].rqe;
 	temp_drqe = dq->qe[dq->host_index].rqe;
 
 	if (hq->type != LPFC_HRQ || dq->type != LPFC_DRQ)
 		return -EINVAL;
-	if (hq->host_index != dq->host_index)
+	if (put_index != dq->host_index)
 		return -EINVAL;
 	/* If the host has not yet processed the next entry then we are done */
-	if (((hq->host_index + 1) % hq->entry_count) == hq->hba_index)
+	if (((put_index + 1) % hq->entry_count) == hq->hba_index)
 		return -EBUSY;
 	lpfc_sli_pcimem_bcopy(hrqe, temp_hrqe, hq->entry_size);
 	lpfc_sli_pcimem_bcopy(drqe, temp_drqe, dq->entry_size);
 
 	/* Update the host index to point to the next slot */
-	hq->host_index = ((hq->host_index + 1) % hq->entry_count);
+	hq->host_index = ((put_index + 1) % hq->entry_count);
 	dq->host_index = ((dq->host_index + 1) % dq->entry_count);
+	hq->RQ_buf_posted++;
 
 	/* Ring The Header Receive Queue Doorbell */
 	if (!(hq->host_index % hq->entry_repost)) {
@@ -512,7 +513,6 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 		} else {
 			return -EINVAL;
 		}
-		hq->RQ_buf_posted += hq->entry_repost;
 		writel(doorbell.word0, hq->db_regaddr);
 	}
 	return put_index;
@@ -6905,11 +6905,13 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			INIT_LIST_HEAD(&rqbp->rqb_buffer_list);
 			rqbp->rqb_alloc_buffer = lpfc_sli4_nvmet_alloc;
 			rqbp->rqb_free_buffer = lpfc_sli4_nvmet_free;
-			rqbp->entry_count = 256;
+			rqbp->entry_count = LPFC_NVMET_RQE_DEF_COUNT;
 			rqbp->buffer_count = 0;
 
-			/* Divide by 4 and round down to multiple of 16 */
-			rc = (phba->cfg_nvmet_mrq_post >> 2) & 0xfff8;
+			/* Divide by 8 and round down to multiple of 16 */
+			rc = (phba->cfg_nvmet_mrq_post >> 3) & 0xfff8;
+			if (rc > LPFC_QUEUE_MAX_REPOST)
+				rc = LPFC_QUEUE_MAX_REPOST;
 			phba->sli4_hba.nvmet_mrq_hdr[i]->entry_repost = rc;
 			phba->sli4_hba.nvmet_mrq_data[i]->entry_repost = rc;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 7a8cbeb6a745..710a635dfbae 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -156,6 +156,7 @@ struct lpfc_queue {
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
 #define LPFC_QUEUE_MIN_REPOST	8
+#define LPFC_QUEUE_MAX_REPOST	64
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
 	uint32_t page_count;	/* Number of pages allocated for this queue */
-- 
2.11.0
