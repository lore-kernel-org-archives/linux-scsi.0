From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 8/9] lpfc: Fix to drop PLOGIs from fabric node till LOGO
 processing completes
Date: Fri, 22 May 2015 10:42:43 -0400
Message-ID: <555f4063.eNa6hhtd/lAYXugc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33274 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbbEVOmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:55 -0400
Received: by qgfa63 with SMTP id a63so9118200qgf.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:54 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id l25sm877510qkh.17.2015.05.22.07.42.53
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix to drop PLOGIs from fabric node till LOGO processing completes

The domain controller PLOGI's concurrent with prior LOGO's/unreg_rpi's
completing created a race condition where driver rpi ref count can
inadvertantly hit 0 and the rpi attempted to be freed. This error
sometimes resulted in Warning messages indicating kref.h via
lfpc_nlp_get+0x128.

Correct by dropping any new PLOGI until the prior nport state has settled.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 14 +++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 13 +++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  2 +-
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 21c4a3d..36bf58b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3668,16 +3668,6 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * At this point, the driver is done so release the IOCB
 	 */
 	lpfc_els_free_iocb(phba, cmdiocb);
-
-	/*
-	 * Remove the ndlp reference if it's a fabric node that has
-	 * sent us an unsolicted LOGO.
-	 */
-	/* FIXME: this one frees ndlp before breaking rport link */
-	if (ndlp->nlp_type & NLP_FABRIC)
-		lpfc_nlp_put(ndlp);
-
-	return;
 }
 
 /**
@@ -4022,7 +4012,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			 ndlp->nlp_rpi, vport->fc_flag);
 	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~NLP_LOGO_ACC;
+		if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED ||
+			ndlp->nlp_flag & NLP_REG_LOGIN_SEND))
+			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 		spin_unlock_irq(shost->host_lock);
 		elsiocb->iocb_cmpl = lpfc_cmpl_els_logo_acc;
 	} else {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 72a69d4..ce96d5b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4495,7 +4495,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_hba *phba = vport->phba;
 	LPFC_MBOXQ_t    *mbox;
-	int rc;
+	int rc, acc_plogi = 1;
 	uint16_t rpi;
 
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED ||
@@ -4528,14 +4528,20 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					mbox->context1 = lpfc_nlp_get(ndlp);
 					mbox->mbox_cmpl =
 						lpfc_sli4_unreg_rpi_cmpl_clr;
+					/*
+					 * accept PLOGIs after unreg_rpi_cmpl
+					 */
+					acc_plogi = 0;
 				} else
 					mbox->mbox_cmpl =
 						lpfc_sli_def_mbox_cmpl;
 			}
 
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-			if (rc == MBX_NOT_FINISHED)
+			if (rc == MBX_NOT_FINISHED) {
 				mempool_free(mbox, phba->mbox_mem_pool);
+				acc_plogi = 1;
+			}
 		}
 		lpfc_no_rpi(phba, ndlp);
 
@@ -4543,8 +4549,11 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			ndlp->nlp_rpi = 0;
 		ndlp->nlp_flag &= ~NLP_RPI_REGISTERED;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		if (acc_plogi)
+			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 		return 1;
 	}
+	ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 09de640..af3b38a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1874,7 +1874,7 @@ lpfc_rcv_logo_logo_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *)arg;
 
 	spin_lock_irq(shost->host_lock);
-	ndlp->nlp_flag &= NLP_LOGO_ACC;
+	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(shost->host_lock);
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	return ndlp->nlp_state;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 07df296..4feb931 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2249,7 +2249,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 						 vport->vpi, ndlp->nlp_rpi,
 						 ndlp->nlp_DID,
 						 ndlp->nlp_usg_map, ndlp);
-
+				ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 				lpfc_nlp_put(ndlp);
 			}
 		}
-- 
1.7.11.7

