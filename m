From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 14/19] lpfc: Validate adapter support for SRIU option
Date: Fri, 26 Jan 2018 11:22:34 -0800
Message-ID: <20180126192239.10727-15-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:39764 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752870AbeAZTXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:23:10 -0500
Received: by mail-qt0-f194.google.com with SMTP id f4so3955625qtj.6
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:23:09 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When using the special option to suppress the response iu, ensure
the adapter fully supports the feature by checking feature flags
from the adapter and validating the support when formatting the
WQE.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2:
  Add missing snippet that changes check logic before enabling
  suppression in lpfc_nvmet_prep_fcp_wqe()

 drivers/scsi/lpfc/lpfc_hw4.h   |  3 +++
 drivers/scsi/lpfc/lpfc_init.c  | 13 ++++++++++++-
 drivers/scsi/lpfc/lpfc_nvmet.c |  7 ++++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7c3afc3d3121..52fe28ae50fa 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3293,6 +3293,9 @@ struct lpfc_sli4_parameters {
 #define cfg_eqdr_SHIFT				8
 #define cfg_eqdr_MASK				0x00000001
 #define cfg_eqdr_WORD				word19
+#define cfg_nosr_SHIFT				9
+#define cfg_nosr_MASK				0x00000001
+#define cfg_nosr_WORD				word19
 #define LPFC_NODELAY_MAX_IO		32
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7fc2db968379..895b1da784ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10473,8 +10473,19 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
 	}
 
-	if (bf_get(cfg_xib, mbx_sli4_parameters) && phba->cfg_suppress_rsp)
+	/*
+	 * To support Suppress Response feature we must satisfy 3 conditions.
+	 * lpfc_suppress_rsp module parameter must be set (default).
+	 * In SLI4-Parameters Descriptor:
+	 * Extended Inline Buffers (XIB) must be supported.
+	 * Suppress Response IU Not Supported (SRIUNS) must NOT be supported
+	 * (double negative).
+	 */
+	if (phba->cfg_suppress_rsp && bf_get(cfg_xib, mbx_sli4_parameters) &&
+	    !(bf_get(cfg_nosr, mbx_sli4_parameters)))
 		phba->sli.sli_flag |= LPFC_SLI_SUPPRESS_RSP;
+	else
+		phba->cfg_suppress_rsp = 0;
 
 	if (bf_get(cfg_eqdr, mbx_sli4_parameters))
 		phba->sli.sli_flag |= LPFC_SLI_USE_EQDR;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 0539585d32d4..6dd8535918f6 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2290,9 +2290,10 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		if (rsp->op == NVMET_FCOP_READDATA_RSP) {
 			atomic_inc(&tgtp->xmt_fcp_read_rsp);
 			bf_set(wqe_ar, &wqe->fcp_tsend.wqe_com, 1);
-			if ((ndlp->nlp_flag & NLP_SUPPRESS_RSP) &&
-			    (rsp->rsplen == 12)) {
-				bf_set(wqe_sup, &wqe->fcp_tsend.wqe_com, 1);
+			if (rsp->rsplen == LPFC_NVMET_SUCCESS_LEN) {
+				if (ndlp->nlp_flag & NLP_SUPPRESS_RSP)
+					bf_set(wqe_sup,
+					       &wqe->fcp_tsend.wqe_com, 1);
 				bf_set(wqe_wqes, &wqe->fcp_tsend.wqe_com, 0);
 				bf_set(wqe_irsp, &wqe->fcp_tsend.wqe_com, 0);
 				bf_set(wqe_irsplen, &wqe->fcp_tsend.wqe_com, 0);
-- 
2.13.1
