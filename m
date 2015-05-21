From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 05/15] lpfc: Fix ABORTs WQ selection in
 terminate_rport_io
Date: Thu, 21 May 2015 13:55:20 -0400
Message-ID: <555e1c08.M8+xR9oQitcJPPaR%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:34455 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbbEURzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:25 -0400
Received: by qgez61 with SMTP id z61so41356894qge.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:25 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id p84sm2959835qkh.10.2015.05.21.10.55.24
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix ABORTs WQ selection in terminate_rport_io

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
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

