From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: lpfc: prevent potential null pointer dereference
Date: Tue, 23 May 2017 10:09:28 -0500
Message-ID: <20170523150928.GA24570@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Null check at line 966: if (ndlp) {,  implies that ndlp might be NULL.
Functions lpfc_nlp_set_state() and lpfc_issue_els_prli() dereference
pointer ndlp. Include these function calls inside the IF block that
tests pointer ndlp.

Addresses-Coverity-ID: 1401856
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c7962da..ecb174b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -978,9 +978,10 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 ndlp, did, ndlp->nlp_fc4_type,
 					 FC_TYPE_FCP, FC_TYPE_NVME);
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
+			lpfc_issue_els_prli(vport, ndlp, 0);
 		}
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "3065 GFT_ID failed x%08x\n", irsp->ulpStatus);
-- 
2.5.0
