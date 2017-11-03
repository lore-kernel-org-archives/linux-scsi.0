From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: lpfc_els: use swap macro in lpfc_plogi_confirm_nport
Date: Fri, 3 Nov 2017 11:42:21 -0500
Message-ID: <20171103164221.GA14017@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Make use of the swap macro and remove unnecessary variable keep_nlp_flag.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b14f7c5..1b745fe 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1525,7 +1525,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
+	uint32_t rc, keepDID = 0;
 	uint16_t keep_nlp_state;
 	struct lpfc_nvme_rport *keep_nrport = NULL;
 	int  put_node;
@@ -1616,9 +1616,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		       phba->cfg_rrq_xri_bitmap_sz);
 
 	spin_lock_irq(shost->host_lock);
-	keep_nlp_flag = new_ndlp->nlp_flag;
-	new_ndlp->nlp_flag = ndlp->nlp_flag;
-	ndlp->nlp_flag = keep_nlp_flag;
+	swap(new_ndlp->nlp_flag, ndlp->nlp_flag);
 	spin_unlock_irq(shost->host_lock);
 
 	/* Set nlp_states accordingly */
-- 
2.7.4
