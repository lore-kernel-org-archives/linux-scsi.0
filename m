From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/14] lpfc: Fix ABORTs WQ selection in terminate_rport_io
Date: Mon, 20 Apr 2015 09:56:28 -0400
Message-ID: <5535058c.qedhvDUQw+w7AJhS%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:30920 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbbDTN5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix ABORTs WQ selection in terminate_rport_io

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 56f7368..41d3370 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8792,30 +8792,40 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	return 0;
 }
 
+/**
+ * lpfc_sli_calc_ring - Calculates which ring to use
+ * @phba: Pointer to HBA context object.
+ * @ring_number: Initial ring
+ * @piocb: Pointer to command iocb.
+ *
+ * For SLI4, FCP IO can deferred to one fo many WQs, based on
+ * fcp_wqidx, thus we need to calculate the corresponding ring.
+ * Since ABORTS must go on the same WQ of the command they are
+ * aborting, we use command's fcp_wqidx.
+ */
 int
 lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb)
 {
-	uint32_t idx;
-
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
-			/*
-			 * fcp_wqidx should already be setup based on what
-			 * completion queue we want to use.
-			 */
 			if (!(phba->cfg_fof) ||
 			    (!(piocb->iocb_flag & LPFC_IO_FOF))) {
 				if (unlikely(!phba->sli4_hba.fcp_wq))
 					return LPFC_HBA_ERROR;
-				idx = lpfc_sli4_scmd_to_wqidx_distr(phba);
-				piocb->fcp_wqidx = idx;
-				ring_number = MAX_SLI3_CONFIGURED_RINGS + idx;
+				/*
+				 * for abort iocb fcp_wqidx should already
+				 * be setup based on what work queue we used.
+				 */
+				if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
+					piocb->fcp_wqidx =
+					    lpfc_sli4_scmd_to_wqidx_distr(phba);
+				ring_number = MAX_SLI3_CONFIGURED_RINGS +
+						piocb->fcp_wqidx;
 			} else {
 				if (unlikely(!phba->sli4_hba.oas_wq))
 					return LPFC_HBA_ERROR;
-				idx = 0;
-				piocb->fcp_wqidx = idx;
+				piocb->fcp_wqidx = 0;
 				ring_number =  LPFC_FCP_OAS_RING;
 			}
 		}
-- 
1.7.11.7

