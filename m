From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 15/21] lpfc: Fix relative offset error on large nvmet target ios
Date: Wed,  2 Aug 2017 16:36:42 -0700
Message-ID: <20170802233648.4573-16-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34539 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdHBXiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:14 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so6121485qki.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:14 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

if the nvmet_fc transport breaks an io into multiple sequences,
the driver will improperly set the relative offset on the 2nd through
N sequences.

Correct by properly formatting the hw cmd so the relative offset is
picked up from the hw cmd.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index cd6c93a17760..40fa5dd72bfa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -559,7 +559,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		/* lpfc_nvmet_xmt_fcp_release() will recycle the context */
 	} else {
 		ctxp->entry_cnt++;
-		start_clean = offsetof(struct lpfc_iocbq, wqe);
+		start_clean = offsetof(struct lpfc_iocbq, iocb_flag);
 		memset(((char *)cmdwqe) + start_clean, 0,
 		       (sizeof(struct lpfc_iocbq) - start_clean));
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -1024,7 +1024,6 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 		/* Word 7 */
 		bf_set(wqe_ct, &wqe->generic.wqe_com, SLI4_CT_RPI);
 		bf_set(wqe_class, &wqe->generic.wqe_com, CLASS3);
-		bf_set(wqe_pu, &wqe->generic.wqe_com, 1);
 		/* Word 10 */
 		bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
 		bf_set(wqe_ebde_cnt, &wqe->generic.wqe_com, 0);
@@ -1974,6 +1973,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		       nvmewqe->sli4_xritag);
 
 		/* Word 7 */
+		bf_set(wqe_pu, &wqe->fcp_tsend.wqe_com, 1);
 		bf_set(wqe_cmnd, &wqe->fcp_tsend.wqe_com, CMD_FCP_TSEND64_WQE);
 
 		/* Word 8 */
@@ -2082,6 +2082,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		       nvmewqe->sli4_xritag);
 
 		/* Word 7 */
+		bf_set(wqe_pu, &wqe->fcp_treceive.wqe_com, 1);
 		bf_set(wqe_ar, &wqe->fcp_treceive.wqe_com, 0);
 		bf_set(wqe_cmnd, &wqe->fcp_treceive.wqe_com,
 		       CMD_FCP_TRECEIVE64_WQE);
@@ -2165,6 +2166,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		       nvmewqe->sli4_xritag);
 
 		/* Word 7 */
+		bf_set(wqe_pu, &wqe->fcp_trsp.wqe_com, 0);
 		bf_set(wqe_ag, &wqe->fcp_trsp.wqe_com, 1);
 		bf_set(wqe_cmnd, &wqe->fcp_trsp.wqe_com, CMD_FCP_TRSP64_WQE);
 
-- 
2.13.1
