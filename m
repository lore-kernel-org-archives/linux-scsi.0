From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 14/20] lpfc: Fix relative offset error on large nvmet target ios
Date: Fri,  4 Aug 2017 17:47:25 -0700
Message-ID: <20170805004731.1335-15-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34936 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdHEAsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:06 -0400
Received: by mail-pg0-f65.google.com with SMTP id l64so3110323pge.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:06 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

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
