From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 04/17] lpfc: Fix RegLogin failed error seen on Lancer FC
 during port bounce
Date: Wed, 16 Dec 2015 18:11:55 -0500
Message-ID: <5671efbb.hZSIh/wq1cqxxyH9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36549 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbLPXMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:14 -0500
Received: by mail-pf0-f180.google.com with SMTP id o64so19589382pfb.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:14 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id q67sm7012386pfi.82.2015.12.16.15.12.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix RegLogin failed error seen on Lancer FC during port bounce

Fix the statemachine and ref counting.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 14 +++++++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  8 ++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  3 +++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f6dd15b..d508378 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3779,14 +3779,17 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				lpfc_nlp_set_state(vport, ndlp,
 					   NLP_STE_REG_LOGIN_ISSUE);
 			}
+
+			ndlp->nlp_flag |= NLP_REG_LOGIN_SEND;
 			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 			    != MBX_NOT_FINISHED)
 				goto out;
-			else
-				/* Decrement the ndlp reference count we
-				 * set for this failed mailbox command.
-				 */
-				lpfc_nlp_put(ndlp);
+
+			/* Decrement the ndlp reference count we
+			 * set for this failed mailbox command.
+			 */
+			lpfc_nlp_put(ndlp);
+			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 
 			/* ELS rsp: Cannot issue reg_login for <NPortid> */
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -3843,6 +3846,7 @@ out:
 				 * the routine lpfc_els_free_iocb.
 				 */
 				cmdiocb->context1 = NULL;
+
 	}
 
 	lpfc_els_free_iocb(phba, cmdiocb);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f0777f2..b19237b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3452,10 +3452,10 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
 		spin_unlock_irq(shost->host_lock);
-	} else
-		/* Good status, call state machine */
-		lpfc_disc_state_machine(vport, ndlp, pmb,
-				NLP_EVT_CMPL_REG_LOGIN);
+	}
+
+	/* Call state machine */
+	lpfc_disc_state_machine(vport, ndlp, pmb, NLP_EVT_CMPL_REG_LOGIN);
 
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index daeda6d..9e571dd 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2325,6 +2325,9 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_vport *vport,
 		if (vport->phba->sli_rev < LPFC_SLI_REV4)
 			ndlp->nlp_rpi = mb->un.varWords[0];
 		ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+		if (ndlp->nlp_flag & NLP_LOGO_ACC) {
+			lpfc_unreg_rpi(vport, ndlp);
+		}
 	} else {
 		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
 			lpfc_drop_node(vport, ndlp);
-- 
1.7.11.7

