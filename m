From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/7] lpfc 8.3.13: FC Discovery Fixes and enhancements.
Date: Wed, 12 May 2010 09:30:43 -0400
Message-ID: <1273671063.24670.17.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16371 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923Ab0ELNbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:31:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Retry PLOGI up to 48 times when LS_RJT reason is
  "Unable to supply requested data."
- When dev loss timeout occurs do not change state if there
  is an outstanding REG_LOGIN.
- Add logic to ignore REG_LOGIN completion if discovery is
  restarted while waiting for REG_LOGIN.
- Only change state on REG_LOGIN completion if still in
  state waiting for REG_LOGIN completion.
- Only send ADISCs to FCP-2 Targets (not Initiators).

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h      |    1 +
 lpfc_disc.h      |    2 ++
 lpfc_els.c       |    9 +++++++++
 lpfc_hbadisc.c   |   35 ++++++++++++++++++++++++++++++++---
 lpfc_nportdisc.c |    7 ++++++-
 5 files changed, 50 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-05-12 09:00:35.000000000 -0400
@@ -41,6 +41,7 @@ void lpfc_read_config(struct lpfc_hba *,
 void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_reg_rpi(struct lpfc_hba *, uint16_t, uint32_t, uint8_t *,
 		 LPFC_MBOXQ_t *, uint32_t);
+void lpfc_set_var(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_unreg_login(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_unreg_did(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_reg_vpi(struct lpfc_vport *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2010-05-12 09:00:35.000000000 -0400
@@ -114,6 +114,8 @@ struct lpfc_nodelist {
 };
 
 /* Defines for nlp_flag (uint32) */
+#define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
+#define NLP_REG_LOGIN_SEND 0x00000002   /* sent reglogin to adapter */
 #define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
 #define NLP_ADISC_SND      0x00000080	/* sent ADISC request for this entry */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-05-12 09:00:35.000000000 -0400
@@ -2740,6 +2740,15 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 				retry = 1;
 				break;
 			}
+			if (stat.un.b.lsRjtRsnCodeExp ==
+			    LSEXP_CANT_GIVE_DATA) {
+				if (cmd == ELS_CMD_PLOGI) {
+					delay = 1000;
+					maxretry = 48;
+				}
+				retry = 1;
+				break;
+			}
 			if (cmd == ELS_CMD_PLOGI) {
 				delay = 1000;
 				maxretry = lpfc_max_els_tries + 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-05-12 09:00:35.000000000 -0400
@@ -275,7 +275,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	if (!(vport->load_flag & FC_UNLOADING) &&
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))
+	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
 	lpfc_unregister_unused_fcf(phba);
@@ -2715,11 +2716,35 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
 	pmb->context1 = NULL;
 
-	/* Good status, call state machine */
-	lpfc_disc_state_machine(vport, ndlp, pmb, NLP_EVT_CMPL_REG_LOGIN);
+	if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
+		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
+
+	if (ndlp->nlp_flag &  NLP_IGNR_REG_CMPL ||
+		ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
+		/* We rcvd a rscn after issuing this
+		 * mbox reg login, we may have cycled
+		 * back through the state and be
+		 * back at reg login state so this
+		 * mbox needs to be ignored becase
+		 * there is another reg login in
+		 * proccess.
+		 */
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
+		spin_unlock_irq(shost->host_lock);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_free_rpi(phba,
+				pmb->u.mb.un.varRegLogin.rpi);
+
+	} else
+		/* Good status, call state machine */
+		lpfc_disc_state_machine(vport, ndlp, pmb,
+				NLP_EVT_CMPL_REG_LOGIN);
+
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
@@ -3842,6 +3867,9 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 				kfree(mp);
 			}
 			list_del(&mb->list);
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				lpfc_sli4_free_rpi(phba,
+					 mb->u.mb.un.varRegLogin.rpi);
 			mempool_free(mb, phba->mbox_mem_pool);
 			/* We shall not invoke the lpfc_nlp_put to decrement
 			 * the ndlp reference count as we are in the process
@@ -3883,6 +3911,7 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if ((ndlp->nlp_flag & NLP_DEFER_RM) &&
+		!(ndlp->nlp_flag & NLP_REG_LOGIN_SEND) &&
 	    !(ndlp->nlp_flag & NLP_RPI_VALID)) {
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-05-12 09:00:35.000000000 -0400
@@ -626,7 +626,8 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 	if (!(vport->fc_flag & FC_PT2PT)) {
 		/* Check config parameter use-adisc or FCP-2 */
 		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
-		    ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
+		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
+		     (ndlp->nlp_type & NLP_FCP_TARGET))) {
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_ADISC;
 			spin_unlock_irq(shost->host_lock);
@@ -962,6 +963,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_fdmi_reg_login;
 			break;
 		default:
+			ndlp->nlp_flag |= NLP_REG_LOGIN_SEND;
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 		}
 		mbox->context2 = lpfc_nlp_get(ndlp);
@@ -972,6 +974,8 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 					   NLP_STE_REG_LOGIN_ISSUE);
 			return ndlp->nlp_state;
 		}
+		if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
+			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 		/* decrement node reference count to the failed mbox
 		 * command
 		 */
@@ -1458,6 +1462,7 @@ lpfc_device_recov_reglogin_issue(struct 
 	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
+	ndlp->nlp_flag |= NLP_IGNR_REG_CMPL;
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_disc_set_adisc(vport, ndlp);


