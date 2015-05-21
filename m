From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 12/15] lpfc: Fix rport leak.
Date: Thu, 21 May 2015 13:55:28 -0400
Message-ID: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34597 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964800AbbEURzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:33 -0400
Received: by qkgx75 with SMTP id x75so61585421qkg.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:32 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id u10sm1625296qgd.14.2015.05.21.10.55.31
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix rport leak.

Correct locking and refcounting in tracking our rports

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_disc.h    |   4 +-
 drivers/scsi/lpfc/lpfc_els.c     |  12 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 145 +++++++++++++++++++--------------------
 3 files changed, 79 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 6977027..361f5b3 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -79,7 +79,6 @@ struct lpfc_nodelist {
 	struct lpfc_name nlp_portname;
 	struct lpfc_name nlp_nodename;
 	uint32_t         nlp_flag;		/* entry flags */
-	uint32_t         nlp_add_flag;		/* additional flags */
 	uint32_t         nlp_DID;		/* FC D_ID of entry */
 	uint32_t         nlp_last_elscmd;	/* Last ELS cmd sent */
 	uint16_t         nlp_type;
@@ -147,6 +146,7 @@ struct lpfc_node_rrq {
 #define NLP_LOGO_ACC       0x00100000	/* Process LOGO after ACC completes */
 #define NLP_TGT_NO_SCSIID  0x00200000	/* good PRLI but no binding for scsid */
 #define NLP_ISSUE_LOGO     0x00400000	/* waiting to issue a LOGO */
+#define NLP_IN_DEV_LOSS    0x00800000	/* devloss in progress */
 #define NLP_ACC_REGLOGIN   0x01000000	/* Issue Reg Login after successful
 					   ACC */
 #define NLP_NPR_ADISC      0x02000000	/* Issue ADISC when dq'ed from
@@ -158,8 +158,6 @@ struct lpfc_node_rrq {
 #define NLP_FIRSTBURST     0x40000000	/* Target supports FirstBurst */
 #define NLP_RPI_REGISTERED 0x80000000	/* nlp_rpi is valid */
 
-/* Defines for nlp_add_flag (uint32) */
-#define NLP_IN_DEV_LOSS  0x00000001	/* Dev Loss processing in progress */
 
 /* ndlp usage management macros */
 #define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4d3d931..011c8d8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1624,8 +1624,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		if (rport) {
 			rdata = rport->dd_data;
 			if (rdata->pnode == ndlp) {
-				lpfc_nlp_put(ndlp);
+				/* break the link before dropping the ref */
 				ndlp->rport = NULL;
+				lpfc_nlp_put(ndlp);
 				rdata->pnode = lpfc_nlp_get(new_ndlp);
 				new_ndlp->rport = rport;
 			}
@@ -3674,6 +3675,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * Remove the ndlp reference if it's a fabric node that has
 	 * sent us an unsolicted LOGO.
 	 */
+	/* FIXME: this one frees ndlp before breaking rport link */
 	if (ndlp->nlp_type & NLP_FABRIC)
 		lpfc_nlp_put(ndlp);
 
@@ -7351,8 +7353,13 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 * Do not process any unsolicited ELS commands
 	 * if the ndlp is in DEV_LOSS
 	 */
-	if (ndlp->nlp_add_flag & NLP_IN_DEV_LOSS)
+	shost = lpfc_shost_from_vport(vport);
+	spin_lock_irq(shost->host_lock);
+	if (ndlp->nlp_flag & NLP_IN_DEV_LOSS) {
+		spin_unlock_irq(shost->host_lock);
 		goto dropit;
+	}
+	spin_unlock_irq(shost->host_lock);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->vport = vport;
@@ -7396,7 +7403,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
-		shost = lpfc_shost_from_vport(vport);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			if (!(phba->pport->fc_flag & FC_PT2PT) ||
 				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0dfa566..88af258 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -106,6 +106,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist * ndlp;
 	struct lpfc_vport *vport;
+	struct Scsi_Host *shost;
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	int  put_node;
@@ -146,49 +147,32 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
-	if (ndlp->nlp_type & NLP_FABRIC) {
-
-		/* If the WWPN of the rport and ndlp don't match, ignore it */
-		if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
-				"6789 rport name %lx != node port name %lx",
-				(unsigned long)rport->port_name,
-				(unsigned long)wwn_to_u64(
-						ndlp->nlp_portname.u.wwn));
-			put_node = rdata->pnode != NULL;
-			put_rport = ndlp->rport != NULL;
-			rdata->pnode = NULL;
-			ndlp->rport = NULL;
-			if (put_node)
-				lpfc_nlp_put(ndlp);
-			if (put_rport)
-				put_device(&rport->dev);
-			return;
-		}
-
-		put_node = rdata->pnode != NULL;
-		put_rport = ndlp->rport != NULL;
-		rdata->pnode = NULL;
-		ndlp->rport = NULL;
-		if (put_node)
-			lpfc_nlp_put(ndlp);
-		if (put_rport)
-			put_device(&rport->dev);
-		return;
-	}
+	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				"6789 rport name %llx != node port name %llx",
+				rport->port_name,
+				wwn_to_u64(ndlp->nlp_portname.u.wwn));
 
 	evtp = &ndlp->dev_loss_evt;
 
-	if (!list_empty(&evtp->evt_listp))
+	if (!list_empty(&evtp->evt_listp)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				"6790 rport name %llx dev_loss_evt pending",
+				rport->port_name);
 		return;
+	}
 
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	ndlp->nlp_add_flag |= NLP_IN_DEV_LOSS;
+	shost = lpfc_shost_from_vport(vport);
+	spin_lock_irq(shost->host_lock);
+	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
+	spin_unlock_irq(shost->host_lock);
 
-	spin_lock_irq(&phba->hbalock);
 	/* We need to hold the node by incrementing the reference
 	 * count until this queued work is done
 	 */
+	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
+
+	spin_lock_irq(&phba->hbalock);
 	if (evtp->evt_arg1) {
 		evtp->evt = LPFC_EVT_DEV_LOSS;
 		list_add_tail(&evtp->evt_listp, &phba->work_list);
@@ -216,22 +200,24 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	struct fc_rport   *rport;
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
+	struct Scsi_Host  *shost;
 	uint8_t *name;
 	int  put_node;
-	int  put_rport;
 	int warn_on = 0;
 	int fcf_inuse = 0;
 
 	rport = ndlp->rport;
+	vport = ndlp->vport;
+	shost = lpfc_shost_from_vport(vport);
 
-	if (!rport) {
-		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
+	spin_lock_irq(shost->host_lock);
+	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+	spin_unlock_irq(shost->host_lock);
+
+	if (!rport)
 		return fcf_inuse;
-	}
 
-	rdata = rport->dd_data;
 	name = (uint8_t *) &ndlp->nlp_portname;
-	vport = ndlp->vport;
 	phba  = vport->phba;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
@@ -245,6 +231,13 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			 "3182 dev_loss_tmo_handler x%06x, rport %p flg x%x\n",
 			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag);
 
+	/*
+	 * lpfc_nlp_remove if reached with dangling rport drops the
+	 * reference. To make sure that does not happen clear rport
+	 * pointer in ndlp before lpfc_nlp_put.
+	 */
+	rdata = rport->dd_data;
+
 	/* Don't defer this if we are in the process of deleting the vport
 	 * or unloading the driver. The unload will cleanup the node
 	 * appropriately we just need to cleanup the ndlp rport info here.
@@ -257,14 +250,12 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 					ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 		}
 		put_node = rdata->pnode != NULL;
-		put_rport = ndlp->rport != NULL;
 		rdata->pnode = NULL;
 		ndlp->rport = NULL;
-		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
 		if (put_node)
 			lpfc_nlp_put(ndlp);
-		if (put_rport)
-			put_device(&rport->dev);
+		put_device(&rport->dev);
+
 		return fcf_inuse;
 	}
 
@@ -276,28 +267,21 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 *name, *(name+1), *(name+2), *(name+3),
 				 *(name+4), *(name+5), *(name+6), *(name+7),
 				 ndlp->nlp_DID);
-		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
 		return fcf_inuse;
 	}
 
-	if (ndlp->nlp_type & NLP_FABRIC) {
-		/* We will clean up these Nodes in linkup */
-		put_node = rdata->pnode != NULL;
-		put_rport = ndlp->rport != NULL;
-		rdata->pnode = NULL;
-		ndlp->rport = NULL;
-		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
-		if (put_node)
-			lpfc_nlp_put(ndlp);
-		if (put_rport)
-			put_device(&rport->dev);
+	put_node = rdata->pnode != NULL;
+	rdata->pnode = NULL;
+	ndlp->rport = NULL;
+	if (put_node)
+		lpfc_nlp_put(ndlp);
+	put_device(&rport->dev);
+
+	if (ndlp->nlp_type & NLP_FABRIC)
 		return fcf_inuse;
-	}
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
-		/* flush the target */
-		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
@@ -322,16 +306,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	put_node = rdata->pnode != NULL;
-	put_rport = ndlp->rport != NULL;
-	rdata->pnode = NULL;
-	ndlp->rport = NULL;
-	ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
-	if (put_node)
-		lpfc_nlp_put(ndlp);
-	if (put_rport)
-		put_device(&rport->dev);
-
 	if (!(vport->load_flag & FC_UNLOADING) &&
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
@@ -3919,9 +3893,17 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	 * registered port, drop the reference that we took the last time we
 	 * registered the port.
 	 */
-	if (ndlp->rport && ndlp->rport->dd_data &&
-	    ((struct lpfc_rport_data *) ndlp->rport->dd_data)->pnode == ndlp)
-		lpfc_nlp_put(ndlp);
+	rport = ndlp->rport;
+	if (rport) {
+		rdata = rport->dd_data;
+		/* break the link before dropping the ref */
+		ndlp->rport = NULL;
+		if (rdata && rdata->pnode == ndlp)
+			lpfc_nlp_put(ndlp);
+		rdata->pnode = NULL;
+		/* drop reference for earlier registeration */
+		put_device(&rport->dev);
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 		"rport add:       did:x%x flg:x%x type x%x",
@@ -4762,6 +4744,7 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_rport_data *rdata;
+	struct fc_rport *rport;
 	LPFC_MBOXQ_t *mbox;
 	int rc;
 
@@ -4799,14 +4782,24 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_cleanup_node(vport, ndlp);
 
 	/*
-	 * We can get here with a non-NULL ndlp->rport because when we
-	 * unregister a rport we don't break the rport/node linkage.  So if we
-	 * do, make sure we don't leaving any dangling pointers behind.
+	 * ndlp->rport must be set to NULL before it reaches here
+	 * i.e. break rport/node link before doing lpfc_nlp_put for
+	 * registered rport and then drop the reference of rport.
 	 */
 	if (ndlp->rport) {
-		rdata = ndlp->rport->dd_data;
+		/*
+		 * extra lpfc_nlp_put dropped the reference of ndlp
+		 * for registered rport so need to cleanup rport
+		 */
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+				"0940 removed node x%p DID x%x "
+				" rport not null %p\n",
+				ndlp, ndlp->nlp_DID, ndlp->rport);
+		rport = ndlp->rport;
+		rdata = rport->dd_data;
 		rdata->pnode = NULL;
 		ndlp->rport = NULL;
+		put_device(&rport->dev);
 	}
 }
 
-- 
1.7.11.7

