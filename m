From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix a sleep-in-atomic-context bug in lpfc_unreg_rpi()
Date: Sat, 15 Sep 2018 11:41:50 +0800
Message-ID: <20180915034150.6652-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep in an interrupt handler.
The function call path (from bottom to top) in Linux-4.17 is:

[FUNC] mempool_alloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_hbadisc.c, 4738:
	 mempool_alloc in lpfc_unreg_rpi
drivers/scsi/lpfc/lpfc_els.c, 2825: 
	lpfc_unreg_rpi in lpfc_issue_els_logo
drivers/scsi/lpfc/lpfc_els.c, 9488: 
	lpfc_issue_els_logo in lpfc_sli_abts_recover_port
drivers/scsi/lpfc/lpfc_sli.c, 9806: 
	lpfc_sli_abts_recover_port in lpfc_sli_abts_err_handler
drivers/scsi/lpfc/lpfc_sli.c, 9914: 
	lpfc_sli_abts_err_handler in lpfc_sli_async_event_handler
drivers/scsi/lpfc/lpfc_sli.c, 2755:
	[FUNC_PTR]lpfc_sli_async_event_handler in lpfc_sli_process_unsol_iocb
drivers/scsi/lpfc/lpfc_sli.c, 3359: 
	lpfc_sli_process_unsol_iocb in lpfc_sli_handle_fast_ring_event
drivers/scsi/lpfc/lpfc_sli.c, 12383: 
	lpfc_sli_handle_fast_ring_event in lpfc_sli_fp_intr_handler 
	(interrupt handler)

Note that [FUNC_PTR] means a function pointer call is used.

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index eb71877f12f8..b10122e13d02 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4730,7 +4730,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					 "did x%x\n",
 					 ndlp->nlp_rpi, ndlp->nlp_flag,
 					 ndlp->nlp_DID);
-		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
 		if (mbox) {
 			/* SLI4 ports require the physical rpi value. */
 			rpi = ndlp->nlp_rpi;
-- 
2.17.0
