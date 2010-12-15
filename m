From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/5] lpfc 8.3.20: Updates to FC discovery commands
Date: Wed, 15 Dec 2010 17:58:10 -0500
Message-ID: <1292453904.32478.28.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15493 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520Ab0LOW7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 17:59:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Updated commands used for ELS to utilize VPI
Allocate RPI at node creation time and pass in ELS commnads.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c       |   16 +++++++++++-----
 lpfc_crtn.h      |    2 +-
 lpfc_disc.h      |    2 +-
 lpfc_els.c       |   19 ++++++++-----------
 lpfc_hbadisc.c   |   40 +++++++++++++++++++---------------------
 lpfc_mbox.c      |   12 ++++--------
 lpfc_nportdisc.c |   16 +++++-----------
 lpfc_sli.c       |   13 -------------
 lpfc_sli4.h      |    1 -
 9 files changed, 49 insertions(+), 72 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-12-15 13:03:21.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-12-15 13:04:49.000000000 -0500
@@ -1619,7 +1619,7 @@ job_error:
  * This function obtains a remote port login id so the diag loopback test
  * can send and receive its own unsolicited CT command.
  **/
-static int lpfcdiag_loop_self_reg(struct lpfc_hba *phba, uint16_t * rpi)
+static int lpfcdiag_loop_self_reg(struct lpfc_hba *phba, uint16_t *rpi)
 {
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_dmabuf *dmabuff;
@@ -1629,10 +1629,14 @@ static int lpfcdiag_loop_self_reg(struct
 	if (!mbox)
 		return -ENOMEM;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		*rpi = lpfc_sli4_alloc_rpi(phba);
 	status = lpfc_reg_rpi(phba, 0, phba->pport->fc_myDID,
-				(uint8_t *)&phba->pport->fc_sparam, mbox, 0);
+			      (uint8_t *)&phba->pport->fc_sparam, mbox, *rpi);
 	if (status) {
 		mempool_free(mbox, phba->mbox_mem_pool);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_free_rpi(phba, *rpi);
 		return -ENOMEM;
 	}
 
@@ -1646,6 +1650,8 @@ static int lpfcdiag_loop_self_reg(struct
 		kfree(dmabuff);
 		if (status != MBX_TIMEOUT)
 			mempool_free(mbox, phba->mbox_mem_pool);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_free_rpi(phba, *rpi);
 		return -ENODEV;
 	}
 
@@ -1682,8 +1688,9 @@ static int lpfcdiag_loop_self_unreg(stru
 			mempool_free(mbox, phba->mbox_mem_pool);
 		return -EIO;
 	}
-
 	mempool_free(mbox, phba->mbox_mem_pool);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_free_rpi(phba, rpi);
 	return 0;
 }
 
@@ -2080,7 +2087,7 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 	uint32_t size;
 	uint32_t full_size;
 	size_t segment_len = 0, segment_offset = 0, current_offset = 0;
-	uint16_t rpi;
+	uint16_t rpi = 0;
 	struct lpfc_iocbq *cmdiocbq, *rspiocbq;
 	IOCB_t *cmd, *rsp;
 	struct lpfc_sli_ct_request *ctreq;
@@ -2167,7 +2174,6 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 	sg_copy_to_buffer(job->request_payload.sg_list,
 				job->request_payload.sg_cnt,
 				ptr, size);
-
 	rc = lpfcdiag_loop_self_reg(phba, &rpi);
 	if (rc)
 		goto loopback_test_exit;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-12-15 13:04:49.000000000 -0500
@@ -40,7 +40,7 @@ int lpfc_read_sparam(struct lpfc_hba *, 
 void lpfc_read_config(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_reg_rpi(struct lpfc_hba *, uint16_t, uint32_t, uint8_t *,
-		 LPFC_MBOXQ_t *, uint32_t);
+		 LPFC_MBOXQ_t *, uint16_t);
 void lpfc_set_var(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_unreg_login(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_unreg_did(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2010-12-15 13:04:49.000000000 -0500
@@ -153,7 +153,7 @@ struct lpfc_node_rrq {
 #define NLP_NODEV_REMOVE   0x08000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
 #define NLP_SC_REQ         0x20000000	/* Target requires authentication */
-#define NLP_RPI_VALID      0x80000000	/* nlp_rpi is valid */
+#define NLP_RPI_REGISTERED 0x80000000	/* nlp_rpi is valid */
 
 /* ndlp usage management macros */
 #define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-12-15 13:04:49.000000000 -0500
@@ -375,7 +375,8 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 		err = 4;
 		goto fail;
 	}
-	rc = lpfc_reg_rpi(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox, 0);
+	rc = lpfc_reg_rpi(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox,
+			  ndlp->nlp_rpi);
 	if (rc) {
 		err = 5;
 		goto fail_free_mbox;
@@ -1023,7 +1024,9 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
-	if  (phba->sli_rev == LPFC_SLI_REV4) {
+	if  ((phba->sli_rev == LPFC_SLI_REV4) &&
+	     (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	      LPFC_SLI_INTF_IF_TYPE_0)) {
 		elsiocb->iocb.ulpCt_h = ((SLI4_CT_FCFI >> 1) & 1);
 		elsiocb->iocb.ulpCt_l = (SLI4_CT_FCFI & 1);
 		/* FLOGI needs to be 3 for WQE FCFI */
@@ -3318,14 +3321,6 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 
-	/*
-	 * This routine is used to register and unregister in previous SLI
-	 * modes.
-	 */
-	if ((pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) &&
-	    (phba->sli_rev == LPFC_SLI_REV4))
-		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
-
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
 
@@ -7090,7 +7085,9 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 	icmd->un.elsreq64.myID = 0;
 	icmd->un.elsreq64.fl = 1;
 
-	if  (phba->sli_rev == LPFC_SLI_REV4) {
+	if  ((phba->sli_rev == LPFC_SLI_REV4) &&
+	     (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	      LPFC_SLI_INTF_IF_TYPE_0)) {
 		/* FDISC needs to be 1 for WQE VPI */
 		elsiocb->iocb.ulpCt_h = (SLI4_CT_VPI >> 1) & 1;
 		elsiocb->iocb.ulpCt_l = SLI4_CT_VPI & 1 ;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-12-15 13:04:49.000000000 -0500
@@ -3102,8 +3102,8 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 	if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
 		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 
-	if (ndlp->nlp_flag &  NLP_IGNR_REG_CMPL ||
-		ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
+	if (ndlp->nlp_flag & NLP_IGNR_REG_CMPL ||
+	    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
 		/* We rcvd a rscn after issuing this
 		 * mbox reg login, we may have cycled
 		 * back through the state and be
@@ -3115,10 +3115,6 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
 		spin_unlock_irq(shost->host_lock);
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			lpfc_sli4_free_rpi(phba,
-				pmb->u.mb.un.varRegLogin.rpi);
-
 	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, pmb,
@@ -3428,7 +3424,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	ndlp->nlp_flag |= NLP_RPI_VALID;
+	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
@@ -3502,7 +3498,7 @@ out:
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	ndlp->nlp_flag |= NLP_RPI_VALID;
+	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
@@ -3835,6 +3831,8 @@ lpfc_initialize_node(struct lpfc_vport *
 	NLP_INT_NODE_ACT(ndlp);
 	atomic_set(&ndlp->cmd_pending, 0);
 	ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
 }
 
 struct lpfc_nodelist *
@@ -4048,7 +4046,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 	 * by firmware with a no rpi error.
 	 */
 	psli = &phba->sli;
-	if (ndlp->nlp_flag & NLP_RPI_VALID) {
+	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 		/* Now process each ring */
 		for (i = 0; i < psli->num_rings; i++) {
 			pring = &psli->ring[i];
@@ -4096,7 +4094,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	LPFC_MBOXQ_t    *mbox;
 	int rc;
 
-	if (ndlp->nlp_flag & NLP_RPI_VALID) {
+	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
 			lpfc_unreg_login(phba, vport->vpi, ndlp->nlp_rpi, mbox);
@@ -4108,8 +4106,9 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 		}
 		lpfc_no_rpi(phba, ndlp);
 
-		ndlp->nlp_rpi = 0;
-		ndlp->nlp_flag &= ~NLP_RPI_VALID;
+		if (phba->sli_rev != LPFC_SLI_REV4)
+			ndlp->nlp_rpi = 0;
+		ndlp->nlp_flag &= ~NLP_RPI_REGISTERED;
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		return 1;
 	}
@@ -4141,7 +4140,7 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phb
 		shost = lpfc_shost_from_vport(vports[i]);
 		spin_lock_irq(shost->host_lock);
 		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
-			if (ndlp->nlp_flag & NLP_RPI_VALID) {
+			if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
 				/* The mempool_alloc might sleep */
 				spin_unlock_irq(shost->host_lock);
 				lpfc_unreg_rpi(vports[i], ndlp);
@@ -4270,9 +4269,6 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 				kfree(mp);
 			}
 			list_del(&mb->list);
-			if (phba->sli_rev == LPFC_SLI_REV4)
-				lpfc_sli4_free_rpi(phba,
-					 mb->u.mb.un.varRegLogin.rpi);
 			mempool_free(mb, phba->mbox_mem_pool);
 			/* We shall not invoke the lpfc_nlp_put to decrement
 			 * the ndlp reference count as we are in the process
@@ -4314,15 +4310,15 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if ((ndlp->nlp_flag & NLP_DEFER_RM) &&
-		!(ndlp->nlp_flag & NLP_REG_LOGIN_SEND) &&
-	    !(ndlp->nlp_flag & NLP_RPI_VALID)) {
+	    !(ndlp->nlp_flag & NLP_REG_LOGIN_SEND) &&
+	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
 		 */
 		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
 			!= NULL) {
 			rc = lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
-			    (uint8_t *) &vport->fc_sparam, mbox, 0);
+			    (uint8_t *) &vport->fc_sparam, mbox, ndlp->nlp_rpi);
 			if (rc) {
 				mempool_free(mbox, phba->mbox_mem_pool);
 			}
@@ -5060,7 +5056,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	pmb->context2 = NULL;
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	ndlp->nlp_flag |= NLP_RPI_VALID;
+	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
@@ -5184,6 +5180,8 @@ lpfc_nlp_release(struct kref *kref)
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	NLP_CLR_NODE_ACT(ndlp);
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 
 	/* free ndlp memory for final ndlp release */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
@@ -5354,7 +5352,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 					"logged in\n",
 					ndlp->nlp_rpi, ndlp->nlp_DID,
 					ndlp->nlp_flag);
-				if (ndlp->nlp_flag & NLP_RPI_VALID)
+				if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
 					ret = 1;
 			}
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-12-15 13:04:49.000000000 -0500
@@ -710,7 +710,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
  * @did: remote port identifier.
  * @param: pointer to memory holding the server parameters.
  * @pmb: pointer to the driver internal queue element for mailbox command.
- * @flag: action flag to be passed back for the complete function.
+ * @rpi: the rpi to use in the registration (usually only used for SLI4.
  *
  * The registration login mailbox command is used to register an N_Port or
  * F_Port login. This registration allows the HBA to cache the remote N_Port
@@ -729,7 +729,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phb
  **/
 int
 lpfc_reg_rpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
-	       uint8_t *param, LPFC_MBOXQ_t *pmb, uint32_t flag)
+	     uint8_t *param, LPFC_MBOXQ_t *pmb, uint16_t rpi)
 {
 	MAILBOX_t *mb = &pmb->u.mb;
 	uint8_t *sparam;
@@ -739,17 +739,13 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
 
 	mb->un.varRegLogin.rpi = 0;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		mb->un.varRegLogin.rpi = lpfc_sli4_alloc_rpi(phba);
+		mb->un.varRegLogin.rpi = rpi;
 		if (mb->un.varRegLogin.rpi == LPFC_RPI_ALLOC_ERROR)
 			return 1;
 	}
-
 	mb->un.varRegLogin.vpi = vpi + phba->vpi_base;
 	mb->un.varRegLogin.did = did;
-	mb->un.varWords[30] = flag;	/* Set flag to issue action on cmpl */
-
 	mb->mbxOwner = OWN_HOST;
-
 	/* Get a buffer to hold NPorts Service Parameters */
 	mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
 	if (mp)
@@ -760,7 +756,7 @@ lpfc_reg_rpi(struct lpfc_hba *phba, uint
 		/* REG_LOGIN: no buffers */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
 				"0302 REG_LOGIN: no buffers, VPI:%d DID:x%x, "
-				"flag x%x\n", vpi, did, flag);
+				"rpi x%x\n", vpi, did, rpi);
 		return (1);
 	}
 	INIT_LIST_HEAD(&mp->list);
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-12-15 13:04:49.000000000 -0500
@@ -386,7 +386,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 		goto out;
 
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
-			    (uint8_t *) sp, mbox, 0);
+			    (uint8_t *) sp, mbox, ndlp->nlp_rpi);
 	if (rc) {
 		mempool_free(mbox, phba->mbox_mem_pool);
 		goto out;
@@ -632,7 +632,7 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
-	if (!(ndlp->nlp_flag & NLP_RPI_VALID)) {
+	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		return 0;
 	}
@@ -968,7 +968,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 	lpfc_unreg_rpi(vport, ndlp);
 
 	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
-			   (uint8_t *) sp, mbox, 0) == 0) {
+			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) == 0) {
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_ns_reg_login;
@@ -1338,12 +1338,6 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
-			if (phba->sli_rev == LPFC_SLI_REV4) {
-				spin_unlock_irq(&phba->hbalock);
-				lpfc_sli4_free_rpi(phba,
-					mb->u.mb.un.varRegLogin.rpi);
-				spin_lock_irq(&phba->hbalock);
-			}
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -1426,7 +1420,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	ndlp->nlp_flag |= NLP_RPI_VALID;
+	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
@@ -2027,7 +2021,7 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 
 	if (!mb->mbxStatus) {
 		ndlp->nlp_rpi = mb->un.varWords[0];
-		ndlp->nlp_flag |= NLP_RPI_VALID;
+		ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	} else {
 		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
 			lpfc_drop_node(vport, ndlp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-15 13:04:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-15 13:04:49.000000000 -0500
@@ -551,7 +551,6 @@ int lpfc_sli4_post_all_rpi_hdrs(struct l
 struct lpfc_rpi_hdr *lpfc_sli4_create_rpi_hdr(struct lpfc_hba *);
 void lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *);
 int lpfc_sli4_alloc_rpi(struct lpfc_hba *);
-void __lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_free_rpi(struct lpfc_hba *, int);
 void lpfc_sli4_remove_rpis(struct lpfc_hba *);
 void lpfc_sli4_async_event_proc(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:04:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:04:49.000000000 -0500
@@ -2116,11 +2116,6 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 		kfree(mp);
 	}
 
-	if ((pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) &&
-	    (phba->sli_rev == LPFC_SLI_REV4) &&
-	    (pmb->u.mb.un.varUnregLogin.rsvd1 == 0x0))
-		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
-
 	/*
 	 * If a REG_LOGIN succeeded  after node is destroyed or node
 	 * is in re-discovery driver need to cleanup the RPI.
@@ -6426,11 +6421,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(els_req64_vf, &wqe->els_req, 0);
 		/* And a VFID for word 12 */
 		bf_set(els_req64_vfid, &wqe->els_req, 0);
-		/*
-		 * Set ct field to 3, indicates that the context_tag field
-		 * contains the FCFI and remote N_Port_ID is
-		 * in word 5.
-		 */
 		ct = ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l);
 		bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 		       iocbq->iocb.ulpContext);
@@ -13372,9 +13362,6 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	while (!list_empty(&mbox_cmd_list)) {
 		list_remove_head(&mbox_cmd_list, mb, LPFC_MBOXQ_t, list);
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-			if (phba->sli_rev == LPFC_SLI_REV4)
-				__lpfc_sli4_free_rpi(phba,
-						mb->u.mb.un.varRegLogin.rpi);
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);


