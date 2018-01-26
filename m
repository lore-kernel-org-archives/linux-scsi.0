From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 02/19] lpfc: Increase CQ and WQ sizes for SCSI
Date: Fri, 26 Jan 2018 11:22:22 -0800
Message-ID: <20180126192239.10727-3-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38226 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeAZTW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:22:57 -0500
Received: by mail-qt0-f195.google.com with SMTP id z10so3975693qti.5
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:22:57 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Increased CQ and WQ sizes for SCSI FCP, matching those used
for NVMe development.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_init.c | 30 ++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c  |  3 ++-
 drivers/scsi/lpfc/lpfc_sli4.h |  5 +++++
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 61fb46da05d4..d042f9118e3b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -760,6 +760,7 @@ struct lpfc_hba {
 	uint8_t  mds_diags_support;
 	uint32_t initial_imax;
 	uint8_t  bbcredit_support;
+	uint8_t  enab_exp_wqcq_pages;
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 73c2f6971d2b..ef469129fb71 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3212,6 +3212,9 @@ struct lpfc_sli4_parameters {
 #define cfg_cqv_SHIFT				14
 #define cfg_cqv_MASK				0x00000003
 #define cfg_cqv_WORD				word4
+#define cfg_cqpsize_SHIFT			16
+#define cfg_cqpsize_MASK			0x000000ff
+#define cfg_cqpsize_WORD			word4
 	uint32_t word5;
 	uint32_t word6;
 #define cfg_mqv_SHIFT				14
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f539c554588c..5b96bf0d3331 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8011,9 +8011,10 @@ static int
 lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
 {
 	struct lpfc_queue *qdesc;
+	uint32_t wqesize;
 
 	/* Create Fast Path FCP CQs */
-	if (phba->fcp_embed_io)
+	if (phba->enab_exp_wqcq_pages)
 		/* Increase the CQ size when WQEs contain an embedded cdb */
 		qdesc = lpfc_sli4_queue_alloc(phba, LPFC_EXPANDED_PAGE_SIZE,
 					      phba->sli4_hba.cq_esize,
@@ -8031,15 +8032,18 @@ lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
 	phba->sli4_hba.fcp_cq[wqidx] = qdesc;
 
 	/* Create Fast Path FCP WQs */
-	if (phba->fcp_embed_io)
 		/* Increase the WQ size when WQEs contain an embedded cdb */
+	if (phba->enab_exp_wqcq_pages) {
+		wqesize = (phba->fcp_embed_io) ?
+			LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
 		qdesc = lpfc_sli4_queue_alloc(phba, LPFC_EXPANDED_PAGE_SIZE,
-					      LPFC_WQE128_SIZE,
+					      wqesize,
 					      LPFC_WQE_EXP_COUNT);
-	else
+	} else {
 		qdesc = lpfc_sli4_queue_alloc(phba, LPFC_DEFAULT_PAGE_SIZE,
 					      phba->sli4_hba.wq_esize,
 					      phba->sli4_hba.wq_ecount);
+	}
 	if (!qdesc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0503 Failed allocate fast-path FCP WQ (%d)\n",
@@ -10485,6 +10489,12 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->fcp_embed_io = 0;
 
+	if ((bf_get(cfg_cqpsize, mbx_sli4_parameters) & LPFC_CQ_16K_PAGE_SZ) &&
+	    (bf_get(cfg_wqpsize, mbx_sli4_parameters) & LPFC_WQ_16K_PAGE_SZ) &&
+	    (sli4_params->wqsize & LPFC_WQ_SZ128_SUPPORT))
+		phba->enab_exp_wqcq_pages = 1;
+	else
+		phba->enab_exp_wqcq_pages = 0;
 	/*
 	 * Check if the SLI port supports MDS Diagnostics
 	 */
@@ -12227,6 +12237,7 @@ int
 lpfc_fof_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
+	uint32_t wqesize;
 
 	/* Create FOF EQ */
 	qdesc = lpfc_sli4_queue_alloc(phba, LPFC_DEFAULT_PAGE_SIZE,
@@ -12240,7 +12251,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 	if (phba->cfg_fof) {
 
 		/* Create OAS CQ */
-		if (phba->fcp_embed_io)
+		if (phba->enab_exp_wqcq_pages)
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      LPFC_EXPANDED_PAGE_SIZE,
 						      phba->sli4_hba.cq_esize,
@@ -12256,16 +12267,19 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 		phba->sli4_hba.oas_cq = qdesc;
 
 		/* Create OAS WQ */
-		if (phba->fcp_embed_io)
+		if (phba->enab_exp_wqcq_pages) {
+			wqesize = (phba->fcp_embed_io) ?
+				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      LPFC_EXPANDED_PAGE_SIZE,
-						      LPFC_WQE128_SIZE,
+						      wqesize,
 						      LPFC_WQE_EXP_COUNT);
-		else
+		} else {
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      LPFC_DEFAULT_PAGE_SIZE,
 						      phba->sli4_hba.wq_esize,
 						      phba->sli4_hba.wq_ecount);
+		}
 		if (!qdesc)
 			goto out_error;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 149f21f53b13..d08d9b48f6b1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14910,7 +14910,8 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	bf_set(lpfc_mbox_hdr_version, &shdr->request,
 	       phba->sli4_hba.pc_sli4_params.wqv);
 
-	if (phba->sli4_hba.pc_sli4_params.wqsize & LPFC_WQ_SZ128_SUPPORT)
+	if ((phba->sli4_hba.pc_sli4_params.wqsize & LPFC_WQ_SZ128_SUPPORT) ||
+	    (wq->page_size > SLI4_PAGE_SIZE))
 		wq_create_version = LPFC_Q_CREATE_VERSION_1;
 	else
 		wq_create_version = LPFC_Q_CREATE_VERSION_0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 81fb58e59e60..a9af9980fc43 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -485,6 +485,11 @@ struct lpfc_pc_sli4_params {
 	uint8_t wqpcnt;
 };
 
+#define LPFC_CQ_4K_PAGE_SZ	0x1
+#define LPFC_CQ_16K_PAGE_SZ	0x4
+#define LPFC_WQ_4K_PAGE_SZ	0x1
+#define LPFC_WQ_16K_PAGE_SZ	0x4
+
 struct lpfc_iov {
 	uint32_t pf_number;
 	uint32_t vf_number;
-- 
2.13.1
