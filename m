From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 13/17] lpfc: NVME Target: Merge into FC discovery
Date: Tue, 17 Jan 2017 17:20:56 -0800
Message-ID: <587ec2f8.5mEXNd/HV7Rc1N2O%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36542 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdARBwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:52:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id r126so377640wmr.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:52:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Target: Merge into FC discovery

Adds NVME PRLI handling and Nameserver registrations for NVME

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        |  8 +++++++-
 drivers/scsi/lpfc/lpfc_els.c       | 34 ++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 27 +++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c | 35 ++++++++++++++++++++++++++++++++---
 4 files changed, 92 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 6aba862..d52b8bc 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1433,7 +1433,13 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
 		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
 		    (context == FC_TYPE_NVME)) {
-			lpfc_nvme_update_localport(vport);
+			if ((vport == phba->pport) && phba->nvmet_support) {
+				CtReq->un.rff.fbits = (FC4_FEATURE_TARGET |
+					FC4_FEATURE_NVME_DISC);
+				/* todo: update targetport attributes */
+			} else {
+				lpfc_nvme_update_localport(vport);
+			}
 			CtReq->un.rff.type_code = context;
 
 		} else if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6d2b163..d40fcc8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2214,7 +2214,13 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    !phba->nvmet_support)
 			bf_set(prli_fba, npr_nvme, 1);
 
-		bf_set(prli_init, npr_nvme, 1);
+		if (phba->nvmet_support) {
+			bf_set(prli_tgt, npr_nvme, 1);
+			bf_set(prli_disc, npr_nvme, 1);
+
+		} else {
+			bf_set(prli_init, npr_nvme, 1);
+		}
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
 		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
@@ -2626,8 +2632,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		phba->pport->fc_myDID = 0;
 
 		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))
-			lpfc_nvme_update_localport(phba->pport);
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+			if (!phba->nvmet_support)
+				lpfc_nvme_update_localport(phba->pport);
+			/* todo: tgt: update targetport attributes */
+		}
 
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
@@ -4408,7 +4417,22 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
 		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
 		bf_set(prli_acc_rsp_code, npr_nvme, PRLI_REQ_EXECUTED);
-		bf_set(prli_init, npr_nvme, 1);
+		if (phba->nvmet_support) {
+			bf_set(prli_tgt, npr_nvme, 1);
+			bf_set(prli_disc, npr_nvme, 1);
+			if (phba->cfg_nvme_enable_fb) {
+				bf_set(prli_fba, npr_nvme, 1);
+
+				/* TBD.  Target mode needs to post buffers
+				 * that support the configured first burst
+				 * byte size.
+				 */
+				bf_set(prli_fb_sz, npr_nvme,
+				       phba->cfg_nvmet_fb_size);
+			}
+		} else {
+			bf_set(prli_init, npr_nvme, 1);
+		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 				 "6015 NVME issue PRLI ACC word1 x%08x "
@@ -5827,6 +5851,8 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
+		if (vport->phba->nvmet_support)
+			continue;
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 291a4cb..cc4462b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -913,8 +913,11 @@ lpfc_linkdown(struct lpfc_hba *phba)
 			vports[i]->fc_myDID = 0;
 
 			if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-			    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))
-				lpfc_nvme_update_localport(vports[i]);
+			    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+				if (!phba->nvmet_support)
+					lpfc_nvme_update_localport(vports[i]);
+				/* todo: tgt: update targetport attributes */
+			}
 		}
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -3588,8 +3591,11 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		vport->fc_myDID = 0;
 
 		if ((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME))
-			lpfc_nvme_update_localport(vport);
+		    (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+			if (!phba->nvmet_support)
+				lpfc_nvme_update_localport(vport);
+			/* todo: update targetport attributes */
+		}
 		goto out;
 	}
 
@@ -4180,6 +4186,11 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 */
 				vport->phba->nport_event_cnt++;
 				lpfc_nvme_register_port(vport, ndlp);
+			} else {
+				/* Just take an NDLP ref count since the
+				 * target does not register rports.
+				 */
+				lpfc_nlp_get(ndlp);
 			}
 		}
 	}
@@ -5099,6 +5110,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			return NULL;
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5107,6 +5120,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
 		if (!ndlp)
 			return NULL;
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5126,6 +5141,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			if (vport->phba->nvmet_support)
+				return ndlp;
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
@@ -5141,6 +5158,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		    ndlp->nlp_flag & NLP_RCV_PLOGI)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8aa12ba..b84d8f1 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -758,6 +758,14 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		if (npr->Retry)
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
+
+		/* If this driver is in nvme target mode, set the ndlp's fc4
+		 * type to NVME provided the PRLI response claims NVME FC4
+		 * type.  Target mode does not issue gft_id so doesn't get
+		 * the fc4 type set until now.
+		 */
+		if ((phba->nvmet_support) && (npr->prliType == PRLI_NVME_TYPE))
+			ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 	}
 	if (rport) {
 		/* We need to update the rport role values */
@@ -1530,8 +1538,17 @@ lpfc_rcv_prli_reglogin_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
-	/* Initiator mode. */
-	lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+	if (vport->phba->nvmet_support) {
+		/* NVME Target mode.  Handle and respond to the PRLI and
+		 * transition to UNMAPPED.
+		 */
+		lpfc_rcv_prli(vport, ndlp, cmdiocb);
+		lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+	} else {
+		/* Initiator mode. */
+		lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+	}
 
 	return ndlp->nlp_state;
 }
@@ -1693,7 +1710,12 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else {
-		/* Only Fabric ports should transition */
+		if ((vport->fc_flag & FC_PT2PT) && phba->nvmet_support)
+			phba->targetport->port_id = vport->fc_myDID;
+
+		/* Only Fabric ports should transition. NVME target
+		 * must complete PRLI.
+		 */
 		if (ndlp->nlp_type & NLP_FABRIC) {
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
@@ -1739,6 +1761,13 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
 
+	/* If we are a target we won't immediately transition into PRLI,
+	 * so if REG_LOGIN already completed we don't need to ignore it.
+	 */
+	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
+	    vport->phba->nvmet_support)
+		ndlp->nlp_flag |= NLP_IGNR_REG_CMPL;
+
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_disc_set_adisc(vport, ndlp);
-- 
2.5.0

