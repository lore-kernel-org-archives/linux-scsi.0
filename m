From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.12: Fix discovery issues
Date: Tue, 6 Apr 2010 15:06:30 -0400
Message-ID: <1270580810.28785.4.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16052 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757084Ab0DFTHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 15:07:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add code to prevent unreg_vpi mailbox command from failing.
- Add code to reset the HBA if unreg_vpi mailbox fails with busy status.
- Remove code that was clearing the nlp_type stored during rport discovery.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h      |    1 
 lpfc_disc.h      |    1 
 lpfc_els.c       |    2 +
 lpfc_hbadisc.c   |   15 ++++++++++++--
 lpfc_init.c      |   20 ++++++++++++++++---
 lpfc_nportdisc.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_sli.c       |   15 ++++++++++++++
 7 files changed, 105 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-04-06 12:58:58.000000000 -0400
@@ -65,6 +65,7 @@ void lpfc_mbx_cmpl_read_la(struct lpfc_h
 void lpfc_init_vpi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_cancel_all_vport_retry_delay_timer(struct lpfc_hba *);
 void lpfc_retry_pport_discovery(struct lpfc_hba *);
+void lpfc_release_rpi(struct lpfc_hba *, struct lpfc_vport *, uint16_t);
 
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2010-04-06 12:58:58.000000000 -0400
@@ -38,6 +38,7 @@ enum lpfc_work_type {
 	LPFC_EVT_ELS_RETRY,
 	LPFC_EVT_DEV_LOSS,
 	LPFC_EVT_FASTPATH_MGMT_EVT,
+	LPFC_EVT_RESET_HBA,
 };
 
 /* structure used to queue event to the discovery tasklet */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-04-06 12:58:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-04-06 12:58:58.000000000 -0400
@@ -583,6 +583,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			spin_unlock_irq(shost->host_lock);
 			lpfc_unreg_rpi(vport, np);
 		}
+		lpfc_cleanup_pending_mbox(vport);
 		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 			lpfc_mbx_unreg_vpi(vport);
 			spin_lock_irq(shost->host_lock);
@@ -6315,6 +6316,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 			spin_unlock_irq(shost->host_lock);
 			lpfc_unreg_rpi(vport, np);
 		}
+		lpfc_cleanup_pending_mbox(vport);
 		lpfc_mbx_unreg_vpi(vport);
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-04-06 12:58:58.000000000 -0400
@@ -474,6 +474,10 @@ lpfc_work_list_done(struct lpfc_hba *phb
 			lpfc_send_fastpath_evt(phba, evtp);
 			free_evt = 0;
 			break;
+		case LPFC_EVT_RESET_HBA:
+			if (!(phba->pport->load_flag & FC_UNLOADING))
+				lpfc_reset_hba(phba);
+			break;
 		}
 		if (free_evt)
 			kfree(evtp);
@@ -2736,11 +2740,18 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
 	switch (mb->mbxStatus) {
 	case 0x0011:
 	case 0x0020:
-	case 0x9700:
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 				 "0911 cmpl_unreg_vpi, mb status = 0x%x\n",
 				 mb->mbxStatus);
 		break;
+	/* If VPI is busy, reset the HBA */
+	case 0x9700:
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+			"2798 Unreg_vpi failed vpi 0x%x, mb status = 0x%x\n",
+			vport->vpi, mb->mbxStatus);
+		if (!(phba->pport->load_flag & FC_UNLOADING))
+			lpfc_workq_post_event(phba, NULL, NULL,
+				LPFC_EVT_RESET_HBA);
 	}
 	spin_lock_irq(shost->host_lock);
 	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
@@ -3232,7 +3243,6 @@ lpfc_nlp_state_cleanup(struct lpfc_vport
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if (new_state == NLP_STE_UNMAPPED_NODE) {
-		ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 		ndlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		ndlp->nlp_type |= NLP_FC_NODE;
 	}
@@ -4990,6 +5000,7 @@ lpfc_unregister_fcf_prep(struct lpfc_hba
 			ndlp = lpfc_findnode_did(vports[i], Fabric_DID);
 			if (ndlp)
 				lpfc_cancel_retry_delay_tmo(vports[i], ndlp);
+			lpfc_cleanup_pending_mbox(vports[i]);
 			lpfc_mbx_unreg_vpi(vports[i]);
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:58:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:58:58.000000000 -0400
@@ -3226,12 +3226,26 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_
 
 	if (!vport)
 		return NULL;
-	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (!ndlp)
-		return NULL;
 	phba = vport->phba;
 	if (!phba)
 		return NULL;
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (!ndlp) {
+		/* Cannot find existing Fabric ndlp, so allocate a new one */
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp)
+			return 0;
+		lpfc_nlp_init(vport, ndlp, Fabric_DID);
+		/* Set the node type */
+		ndlp->nlp_type |= NLP_FABRIC;
+		/* Put ndlp onto node list */
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		/* re-setup ndlp without removing from node list */
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			return 0;
+	}
 	if (phba->pport->port_state <= LPFC_FLOGI)
 		return NULL;
 	/* If virtual link is not yet instantiated ignore CVL */
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-04-06 12:58:58.000000000 -0400
@@ -636,11 +636,55 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 	lpfc_unreg_rpi(vport, ndlp);
 	return 0;
 }
+/**
+ * lpfc_release_rpi - Release a RPI by issueing unreg_login mailbox cmd.
+ * @phba : Pointer to lpfc_hba structure.
+ * @vport: Pointer to lpfc_vport structure.
+ * @rpi  : rpi to be release.
+ *
+ * This function will send a unreg_login mailbox command to the firmware
+ * to release a rpi.
+ **/
+void
+lpfc_release_rpi(struct lpfc_hba *phba,
+		struct lpfc_vport *vport,
+		uint16_t rpi)
+{
+	LPFC_MBOXQ_t *pmb;
+	int rc;
+
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+			GFP_KERNEL);
+	if (!pmb)
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
+			"2796 mailbox memory allocation failed \n");
+	else {
+		lpfc_unreg_login(phba, vport->vpi, rpi, pmb);
+		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED)
+			mempool_free(pmb, phba->mbox_mem_pool);
+	}
+}
 
 static uint32_t
 lpfc_disc_illegal(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		  void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba;
+	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
+	MAILBOX_t *mb;
+	uint16_t rpi;
+
+	phba = vport->phba;
+	/* Release the RPI if reglogin completing */
+	if (!(phba->pport->load_flag & FC_UNLOADING) &&
+		(evt == NLP_EVT_CMPL_REG_LOGIN) &&
+		(!pmb->u.mb.mbxStatus)) {
+		mb = &pmb->u.mb;
+		rpi = pmb->u.mb.un.varWords[0];
+		lpfc_release_rpi(phba, vport, rpi);
+	}
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 			 "0271 Illegal State Transition: node x%x "
 			 "event x%x, state x%x Data: x%x x%x\n",
@@ -976,6 +1020,18 @@ static uint32_t
 lpfc_cmpl_reglogin_plogi_issue(struct lpfc_vport *vport,
 	struct lpfc_nodelist *ndlp, void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba;
+	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
+	MAILBOX_t *mb = &pmb->u.mb;
+	uint16_t rpi;
+
+	phba = vport->phba;
+	/* Release the RPI */
+	if (!(phba->pport->load_flag & FC_UNLOADING) &&
+		!mb->mbxStatus) {
+		rpi = pmb->u.mb.un.varWords[0];
+		lpfc_release_rpi(phba, vport, rpi);
+	}
 	return ndlp->nlp_state;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:58:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:58:58.000000000 -0400
@@ -12660,6 +12660,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	struct lpfc_hba *phba = vport->phba;
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
+	struct lpfc_nodelist *ndlp;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
@@ -12676,6 +12677,11 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
 				kfree(mp);
 			}
+			ndlp = (struct lpfc_nodelist *) mb->context2;
+			if (ndlp) {
+				lpfc_nlp_put(ndlp);
+				mb->context2 = NULL;
+			}
 		}
 		list_del(&mb->list);
 		mempool_free(mb, phba->mbox_mem_pool);
@@ -12685,6 +12691,15 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) ||
 			(mb->u.mb.mbxCommand == MBX_REG_VPI))
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+			ndlp = (struct lpfc_nodelist *) mb->context2;
+			if (ndlp) {
+				lpfc_nlp_put(ndlp);
+				mb->context2 = NULL;
+			}
+			/* Unregister the RPI when mailbox complete */
+			mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
+		}
 	}
 	spin_unlock_irq(&phba->hbalock);
 }


