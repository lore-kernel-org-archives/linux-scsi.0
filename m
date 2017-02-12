From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 12/16] lpfc: NVME Target: Merge into FC discovery
Date: Sun, 12 Feb 2017 13:52:36 -0800
Message-ID: <58a0d924.WAYUSKz7ndFiR9lM%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35747 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdBLVwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:39 -0500
Received: by mail-oi0-f68.google.com with SMTP id x84so5873630oix.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:39 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Target: Merge into FC discovery

Adds NVME PRLI handling and Nameserver registrations for NVME

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        |  8 +++-
 drivers/scsi/lpfc/lpfc_els.c       | 61 ++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 27 ++++++++++++--
 drivers/scsi/lpfc/lpfc_hw.h        | 10 ++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 75 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 167 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 2c051369..d576da4 100644
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
index cc1c03a..2de5cbe 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2001,11 +2001,21 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 		sp->cmn.fcphHigh = FC_PH3;
 
 	sp->cmn.valid_vendor_ver_level = 0;
+	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PLOGI:     did:x%x",
 		did, 0, 0);
 
+	/* If our firmware supports this feature, convey that
+	 * information to the target using the vendor specific field.
+	 */
+	if (phba->sli.sli_flag & LPFC_SLI_SUPPRESS_RSP) {
+		sp->cmn.valid_vendor_ver_level = 1;
+		sp->un.vv.vid = cpu_to_be32(LPFC_VV_EMLX_ID);
+		sp->un.vv.flags = cpu_to_be32(LPFC_VV_SUPPRESS_RSP);
+	}
+
 	phba->fc_stat.elsXmitPLOGI++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_plogi;
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
@@ -2207,7 +2217,13 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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
@@ -2619,8 +2635,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4072,10 +4091,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			       sizeof(struct lpfc_name));
 			memcpy(&sp->nodeName, &vport->fc_sparam.nodeName,
 			       sizeof(struct lpfc_name));
-		} else
+		} else {
 			memcpy(pcmd, &vport->fc_sparam,
 			       sizeof(struct serv_parm));
 
+			sp->cmn.valid_vendor_ver_level = 0;
+			memset(sp->un.vendorVersion, 0,
+			       sizeof(sp->un.vendorVersion));
+
+			/* If our firmware supports this feature, convey that
+			 * info to the target using the vendor specific field.
+			 */
+			if (phba->sli.sli_flag & LPFC_SLI_SUPPRESS_RSP) {
+				sp->cmn.valid_vendor_ver_level = 1;
+				sp->un.vv.vid = cpu_to_be32(LPFC_VV_EMLX_ID);
+				sp->un.vv.flags =
+					cpu_to_be32(LPFC_VV_SUPPRESS_RSP);
+			}
+		}
+
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 			"Issue ACC FLOGI/PLOGI: did:x%x flg:x%x",
 			ndlp->nlp_DID, ndlp->nlp_flag, 0);
@@ -4395,7 +4429,22 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
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
@@ -5813,6 +5862,8 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
+		if (vport->phba->nvmet_support)
+			continue;
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e7f99c8..fc1564b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -910,8 +910,11 @@ lpfc_linkdown(struct lpfc_hba *phba)
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
@@ -3583,8 +3586,11 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
 
@@ -4175,6 +4181,11 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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
@@ -5096,6 +5107,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			return NULL;
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5104,6 +5117,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
 		if (!ndlp)
 			return NULL;
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5123,6 +5138,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			if (vport->phba->nvmet_support)
+				return ndlp;
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
@@ -5138,6 +5155,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		    ndlp->nlp_flag & NLP_RCV_PLOGI)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->nvmet_support)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 883e6d2..c2221377 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -515,7 +515,15 @@ struct serv_parm {	/* Structure is in Big Endian format */
 	struct class_parms cls2;
 	struct class_parms cls3;
 	struct class_parms cls4;
-	uint8_t vendorVersion[16];
+	union {
+		uint8_t vendorVersion[16];
+		struct {
+			uint32_t vid;
+#define LPFC_VV_EMLX_ID	0x454d4c58	/* EMLX */
+			uint32_t flags;
+#define LPFC_VV_SUPPRESS_RSP	1
+		} vv;
+	} un;
 };
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 470f958..0716818 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -288,6 +288,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t ed_tov;
 	LPFC_MBOXQ_t *mbox;
 	struct ls_rjt stat;
+	uint32_t vid, flag;
 	int rc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
@@ -423,6 +424,15 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_can_disctmo(vport);
 	}
 
+	ndlp->nlp_flag &= ~NLP_SUPPRESS_RSP;
+	if ((phba->sli.sli_flag & LPFC_SLI_SUPPRESS_RSP) &&
+	    sp->cmn.valid_vendor_ver_level) {
+		vid = be32_to_cpu(sp->un.vv.vid);
+		flag = be32_to_cpu(sp->un.vv.flags);
+		if ((vid == LPFC_VV_EMLX_ID) && (flag & LPFC_VV_SUPPRESS_RSP))
+			ndlp->nlp_flag |= NLP_SUPPRESS_RSP;
+	}
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		goto out;
@@ -744,6 +754,14 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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
@@ -1041,6 +1059,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	struct lpfc_iocbq  *cmdiocb, *rspiocb;
 	struct lpfc_dmabuf *pcmd, *prsp, *mp;
 	uint32_t *lp;
+	uint32_t vid, flag;
 	IOCB_t *irsp;
 	struct serv_parm *sp;
 	uint32_t ed_tov;
@@ -1109,6 +1128,16 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 			ed_tov = (phba->fc_edtov + 999999) / 1000000;
 		}
 
+		ndlp->nlp_flag &= ~NLP_SUPPRESS_RSP;
+		if ((phba->sli.sli_flag & LPFC_SLI_SUPPRESS_RSP) &&
+		    sp->cmn.valid_vendor_ver_level) {
+			vid = be32_to_cpu(sp->un.vv.vid);
+			flag = be32_to_cpu(sp->un.vv.flags);
+			if ((vid == LPFC_VV_EMLX_ID) &&
+			    (flag & LPFC_VV_SUPPRESS_RSP))
+				ndlp->nlp_flag |= NLP_SUPPRESS_RSP;
+		}
+
 		/*
 		 * Use the larger EDTOV
 		 * RATOV = 2 * EDTOV for pt-to-pt
@@ -1504,9 +1533,37 @@ lpfc_rcv_prli_reglogin_issue(struct lpfc_vport *vport,
 			     uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
+	struct ls_rjt     stat;
 
-	/* Initiator mode. */
-	lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+	if (vport->phba->nvmet_support) {
+		/* NVME Target mode.  Handle and respond to the PRLI and
+		 * transition to UNMAPPED provided the RPI has completed
+		 * registration.
+		 */
+		if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
+			lpfc_rcv_prli(vport, ndlp, cmdiocb);
+			lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		} else {
+			/* RPI registration has not completed. Reject the PRLI
+			 * to prevent an illegal state transition when the
+			 * rpi registration does complete.
+			 */
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_NVME_DISC,
+					 "6115 NVMET ndlp rpi %d state "
+					 "unknown, state x%x flags x%08x\n",
+					 ndlp->nlp_rpi, ndlp->nlp_state,
+					 ndlp->nlp_flag);
+			memset(&stat, 0, sizeof(struct ls_rjt));
+			stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+			stat.un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
+			lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
+					    ndlp, NULL);
+		}
+	} else {
+		/* Initiator mode. */
+		lpfc_els_rsp_prli_acc(vport, cmdiocb, ndlp);
+	}
 
 	return ndlp->nlp_state;
 }
@@ -1668,7 +1725,12 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
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
@@ -1714,6 +1776,13 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
 
+	/* If we are a target we won't immediately transition into PRLI,
+	 * so if REG_LOGIN already completed we don't need to ignore it.
+	 */
+	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED) ||
+	    !vport->phba->nvmet_support)
+		ndlp->nlp_flag |= NLP_IGNR_REG_CMPL;
+
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_disc_set_adisc(vport, ndlp);
-- 
2.5.0
