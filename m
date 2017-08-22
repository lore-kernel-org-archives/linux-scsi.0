From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: lpfc: remove useless code in
 lpfc_sli4_bsg_link_diag_test
Date: Tue, 22 Aug 2017 15:53:53 -0500
Message-ID: <20170822205353.GA17794@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Remove variable assignments. The value stored in local variable _rc_ is
overwritten at line 2448:rc = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
before it can be used.

Addresses-Coverity-ID: 1226935
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This issue was detected by Coverity and it was tested by compilation only.
Notice that this code has been there since 2011.

 drivers/scsi/lpfc/lpfc_bsg.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index a1686c2..fe9e1c0 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2384,20 +2384,17 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 		goto job_error;
 
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!pmboxq) {
-		rc = -ENOMEM;
+	if (!pmboxq)
 		goto link_diag_test_exit;
-	}
 
 	req_len = (sizeof(struct lpfc_mbx_set_link_diag_state) -
 		   sizeof(struct lpfc_sli4_cfg_mhdr));
 	alloc_len = lpfc_sli4_config(phba, pmboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
 				     LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_STATE,
 				     req_len, LPFC_SLI4_MBX_EMBED);
-	if (alloc_len != req_len) {
-		rc = -ENOMEM;
+	if (alloc_len != req_len)
 		goto link_diag_test_exit;
-	}
+
 	run_link_diag_test = &pmboxq->u.mqe.un.link_diag_test;
 	bf_set(lpfc_mbx_run_diag_test_link_num, &run_link_diag_test->u.req,
 	       phba->sli4_hba.lnk_info.lnk_no);
-- 
2.5.0
