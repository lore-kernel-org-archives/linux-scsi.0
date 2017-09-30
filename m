From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 09/21] lpfc: Fix FCP hba_wqidx assignment
Date: Fri, 29 Sep 2017 17:34:35 -0700
Message-ID: <20170930003447.10747-10-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, stable@vger.kernel.org, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

From: Dick Kennedy <dick.kennedy@broadcom.com>

The driver is encountering  oops in lpfc_sli_calc_ring.

The driver is setting hba_wqidx for FCP based on the
policy in use for NVME. The two may not be the same.
Change to set the wqidx based on the FCP policy.

Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a69332f0abcd..e50f1c1e484d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9396,10 +9396,13 @@ lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 			 * for abort iocb hba_wqidx should already
 			 * be setup based on what work queue we used.
 			 */
-			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
+			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 				piocb->hba_wqidx =
 					lpfc_sli4_scmd_to_wqidx_distr(phba,
 							      piocb->context1);
+				piocb->hba_wqidx = piocb->hba_wqidx %
+					phba->cfg_fcp_io_channel;
+			}
 			return phba->sli4_hba.fcp_wq[piocb->hba_wqidx]->pring;
 		} else {
 			if (unlikely(!phba->sli4_hba.oas_wq))
-- 
2.13.1
