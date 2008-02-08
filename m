From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/6] lpfc 8.2.5 : Correct ndlp referencing issues
Date: Fri, 08 Feb 2008 18:49:26 -0500
Message-ID: <1202514566.20924.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44661 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYBHXtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:49:32 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18NnEIt018509
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:49:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct ndlp referencing issues:
- Fix ndlp kref issues due to race conditions between threads
- Fix cancel els delay retry event which missed an ndlp reference count


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    2 
 lpfc_attr.c      |    5 
 lpfc_crtn.h      |    6 -
 lpfc_ct.c        |   39 +++++--
 lpfc_disc.h      |   33 +++++-
 lpfc_els.c       |  237 +++++++++++++++++++++++++++++++-------------
 lpfc_hbadisc.c   |  296 +++++++++++++++++++++++++++++++++++++++++++++++--------
 lpfc_init.c      |   41 +++++++
 lpfc_nportdisc.c |   39 +++++--
 lpfc_scsi.c      |    4 
 lpfc_vport.c     |   70 +++++++++++--
 11 files changed, 630 insertions(+), 142 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-02-08 18:10:08.000000000 -0500
@@ -1191,7 +1191,7 @@ lpfc_update_rport_devloss_tmo(struct lpf
 	shost = lpfc_shost_from_vport(vport);
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp)
-		if (ndlp->rport)
+		if (NLP_CHK_NODE_ACT(ndlp) && ndlp->rport)
 			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
 	spin_unlock_irq(shost->host_lock);
 }
@@ -2384,7 +2384,8 @@ lpfc_get_node_by_target(struct scsi_targ
 	spin_lock_irq(shost->host_lock);
 	/* Search for this, mapped, target ID */
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
+		if (NLP_CHK_NODE_ACT(ndlp) &&
+		    ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
 		    starget->id == ndlp->nlp_sid) {
 			spin_unlock_irq(shost->host_lock);
 			return ndlp;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -53,7 +53,11 @@ void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
+void lpfc_disable_node(struct lpfc_vport *, struct lpfc_nodelist *);
+struct lpfc_nodelist *lpfc_enable_node(struct lpfc_vport *,
+					struct lpfc_nodelist *, int);
 void lpfc_nlp_set_state(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_drop_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_set_disctmo(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -294,7 +294,7 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	/* Save for completion so we can release these resources */
 	geniocb->context1 = (uint8_t *) inp;
 	geniocb->context2 = (uint8_t *) outp;
-	geniocb->context_un.ndlp = ndlp;
+	geniocb->context_un.ndlp = lpfc_nlp_get(ndlp);
 
 	/* Fill in payload, bp points to frame payload */
 	icmd->ulpCommand = CMD_GEN_REQUEST64_CR;
@@ -489,8 +489,10 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 						 */
 						ndlp = lpfc_findnode_did(vport,
 							Did);
-						if (ndlp && (ndlp->nlp_type &
-							NLP_FCP_TARGET))
+						if (ndlp &&
+						    NLP_CHK_NODE_ACT(ndlp)
+						    && (ndlp->nlp_type &
+						     NLP_FCP_TARGET))
 							lpfc_setup_disc_node
 								(vport, Did);
 						else if (lpfc_ns_cmd(vport,
@@ -1064,7 +1066,8 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 	int rc = 0;
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (ndlp == NULL || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)
+	    || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) {
 		rc=1;
 		goto ns_cmd_exit;
 	}
@@ -1213,8 +1216,9 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
 		break;
 	}
-	lpfc_nlp_get(ndlp);
-
+	/* The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
+	 * to hold ndlp reference for the corresponding callback function.
+	 */
 	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, retry)) {
 		/* On success, The cmpl function will free the buffers */
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
@@ -1222,9 +1226,13 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 			cmdcode, ndlp->nlp_DID, 0);
 		return 0;
 	}
-
 	rc=6;
+
+	/* Decrement ndlp reference count to release ndlp reference held
+	 * for the failed command's callback function.
+	 */
 	lpfc_nlp_put(ndlp);
+
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 ns_cmd_free_bmp:
 	kfree(bmp);
@@ -1271,6 +1279,9 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *p
 	}
 
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		goto fail_out;
+
 	if (fdmi_rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
 		/* FDMI rsp failed */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -1294,6 +1305,8 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *p
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RHBA);
 		break;
 	}
+
+fail_out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	return;
 }
@@ -1650,12 +1663,18 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
 	cmpl = lpfc_cmpl_ct_cmd_fdmi;
-	lpfc_nlp_get(ndlp);
 
+	/* The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
+	 * to hold ndlp reference for the corresponding callback function.
+	 */
 	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, FC_MAX_NS_RSP, 0))
 		return 0;
 
+	/* Decrement ndlp reference count to release ndlp reference held
+	 * for the failed command's callback function.
+	 */
 	lpfc_nlp_put(ndlp);
+
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 fdmi_cmd_free_bmp:
 	kfree(bmp);
@@ -1698,7 +1717,7 @@ lpfc_fdmi_timeout_handler(struct lpfc_vp
 	struct lpfc_nodelist *ndlp;
 
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
-	if (ndlp) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 		if (init_utsname()->nodename[0] != '\0')
 			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
 		else
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -73,6 +73,12 @@ struct lpfc_nodelist {
 	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 
+	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
+#define NLP_USG_NODE_ACT_BIT	0x1	/* Indicate ndlp is actively used */
+#define NLP_USG_IACT_REQ_BIT	0x2	/* Request to inactivate ndlp */
+#define NLP_USG_FREE_REQ_BIT	0x4	/* Request to invoke ndlp memory free */
+#define NLP_USG_FREE_ACK_BIT	0x8	/* Indicate ndlp memory free invoked */
+
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
 	struct fc_rport *rport;			/* Corresponding FC transport
 						   port structure */
@@ -105,6 +111,31 @@ struct lpfc_nodelist {
 #define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
 
+/* ndlp usage management macros */
+#define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
+						& NLP_USG_NODE_ACT_BIT) \
+					&& \
+					!((ndlp)->nlp_usg_map \
+						& NLP_USG_FREE_ACK_BIT))
+#define NLP_SET_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
+						|= NLP_USG_NODE_ACT_BIT)
+#define NLP_INT_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
+						= NLP_USG_NODE_ACT_BIT)
+#define NLP_CLR_NODE_ACT(ndlp)		((ndlp)->nlp_usg_map \
+						&= ~NLP_USG_NODE_ACT_BIT)
+#define NLP_CHK_IACT_REQ(ndlp)          ((ndlp)->nlp_usg_map \
+						& NLP_USG_IACT_REQ_BIT)
+#define NLP_SET_IACT_REQ(ndlp)          ((ndlp)->nlp_usg_map \
+						|= NLP_USG_IACT_REQ_BIT)
+#define NLP_CHK_FREE_REQ(ndlp)		((ndlp)->nlp_usg_map \
+						& NLP_USG_FREE_REQ_BIT)
+#define NLP_SET_FREE_REQ(ndlp)		((ndlp)->nlp_usg_map \
+						|= NLP_USG_FREE_REQ_BIT)
+#define NLP_CHK_FREE_ACK(ndlp)		((ndlp)->nlp_usg_map \
+						& NLP_USG_FREE_ACK_BIT)
+#define NLP_SET_FREE_ACK(ndlp)		((ndlp)->nlp_usg_map \
+						|= NLP_USG_FREE_ACK_BIT)
+
 /* There are 4 different double linked lists nodelist entries can reside on.
  * The Port Login (PLOGI) list and Address Discovery (ADISC) list are used
  * when Link Up discovery or Registered State Change Notification (RSCN)
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-02-08 18:10:20.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -113,6 +113,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 
 	if (elsiocb == NULL)
 		return NULL;
+
 	icmd = &elsiocb->iocb;
 
 	/* fill in BDEs for command */
@@ -134,9 +135,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		if (!prsp || !prsp->virt)
 			goto els_iocb_free_prsp_exit;
 		INIT_LIST_HEAD(&prsp->list);
-	} else {
+	} else
 		prsp = NULL;
-	}
 
 	/* Allocate buffer for Buffer ptr list */
 	pbuflist = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
@@ -246,7 +246,7 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 
 	sp = &phba->fc_fabparam;
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (!ndlp) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		err = 1;
 		goto fail;
 	}
@@ -282,6 +282,9 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_fabric_reg_login;
 	mbox->vport = vport;
+	/* increment the reference count on ndlp to hold reference
+	 * for the callback routine.
+	 */
 	mbox->context2 = lpfc_nlp_get(ndlp);
 
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
@@ -293,6 +296,9 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 	return 0;
 
 fail_issue_reg_login:
+	/* decrement the reference count on ndlp just incremented
+	 * for the failed mbox command.
+	 */
 	lpfc_nlp_put(ndlp);
 	mp = (struct lpfc_dmabuf *) mbox->context1;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -381,6 +387,8 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		 */
 		list_for_each_entry_safe(np, next_np,
 					&vport->fc_nodes, nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
 			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 				   !(np->nlp_flag & NLP_NPR_ADISC))
 				continue;
@@ -456,6 +464,9 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vp
 			mempool_free(mbox, phba->mbox_mem_pool);
 			goto fail;
 		}
+		/* Decrement ndlp reference count indicating that ndlp can be
+		 * safely released when other references to it are done.
+		 */
 		lpfc_nlp_put(ndlp);
 
 		ndlp = lpfc_findnode_did(vport, PT2PT_RemoteID);
@@ -467,22 +478,29 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vp
 			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
 			if (!ndlp)
 				goto fail;
-
 			lpfc_nlp_init(vport, ndlp, PT2PT_RemoteID);
+		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+			ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_UNUSED_NODE);
+			if(!ndlp)
+				goto fail;
 		}
 
 		memcpy(&ndlp->nlp_portname, &sp->portName,
 		       sizeof(struct lpfc_name));
 		memcpy(&ndlp->nlp_nodename, &sp->nodeName,
 		       sizeof(struct lpfc_name));
+		/* Set state will put ndlp onto node list if not already done */
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
-	} else {
-		/* This side will wait for the PLOGI */
+	} else
+		/* This side will wait for the PLOGI, decrement ndlp reference
+		 * count indicating that ndlp can be released when other
+		 * references to it are done.
+		 */
 		lpfc_nlp_put(ndlp);
-	}
 
 	/* If we are pt2pt with another NPort, force NPIV off! */
 	phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
@@ -728,16 +746,21 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 		if (!ndlp)
 			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
-	} else {
-		lpfc_dequeue_node(vport, ndlp);
+		/* Put ndlp onto node list */
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		/* re-setup ndlp without removing from node list */
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			return 0;
 	}
 
-	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
+	if (lpfc_issue_els_flogi(vport, ndlp, 0))
 		/* This decrement of reference count to node shall kick off
 		 * the release of the node.
 		 */
 		lpfc_nlp_put(ndlp);
-	}
+
 	return 1;
 }
 
@@ -755,9 +778,15 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 		if (!ndlp)
 			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
-	} else {
-		lpfc_dequeue_node(vport, ndlp);
+		/* Put ndlp onto node list */
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		/* re-setup ndlp without removing from node list */
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			return 0;
 	}
+
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
 		/* decrement node reference count to trigger the release of
 		 * the node.
@@ -816,7 +845,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	 */
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
-	if (new_ndlp == ndlp)
+	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
 		return ndlp;
 
 	if (!new_ndlp) {
@@ -827,8 +856,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		new_ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
 		if (!new_ndlp)
 			return ndlp;
-
 		lpfc_nlp_init(vport, new_ndlp, ndlp->nlp_DID);
+	} else if (!NLP_CHK_NODE_ACT(new_ndlp)) {
+		new_ndlp = lpfc_enable_node(vport, new_ndlp,
+						NLP_STE_UNUSED_NODE);
+		if (!new_ndlp)
+			return ndlp;
 	}
 
 	lpfc_unreg_rpi(vport, new_ndlp);
@@ -839,6 +872,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 
+	/* Set state will put new_ndlp on to node list if not already done */
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
 
 	/* Move this back to NPR state */
@@ -912,7 +946,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 		irsp->un.elsreq64.remoteID);
 
 	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
-	if (!ndlp) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0136 PLOGI completes to NPort x%x "
 				 "with no ndlp. Data: x%x x%x x%x\n",
@@ -962,12 +996,11 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 		}
 		/* PLOGI failed */
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp)) {
+		if (lpfc_error_lost_link(irsp))
 			rc = NLP_STE_FREED_NODE;
-		} else {
+		else
 			rc = lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						     NLP_EVT_CMPL_PLOGI);
-		}
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -1015,8 +1048,10 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	ndlp = lpfc_findnode_did(vport, did);
-	/* If ndlp if not NULL, we will bump the reference count on it */
+	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
+		ndlp = NULL;
 
+	/* If ndlp is not NULL, we will bump the reference count on it */
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
 				     ELS_CMD_PLOGI);
@@ -1097,18 +1132,15 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
 		}
 		/* PRLI failed */
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp)) {
+		if (lpfc_error_lost_link(irsp))
 			goto out;
-		} else {
+		else
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
-		}
-	} else {
+	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_PRLI);
-	}
-
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -1275,15 +1307,13 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
 		}
 		/* ADISC failed */
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp)) {
+		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_ADISC);
-		}
-	} else {
+	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
-	}
 
 	if (disc && vport->num_disc_nodes) {
 		/* Check to see if there are more ADISCs to be sent */
@@ -1443,14 +1473,12 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 		else
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_LOGO);
-	} else {
+	} else
 		/* Good status, call state machine.
 		 * This will unregister the rpi if needed.
 		 */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_LOGO);
-	}
-
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -1556,11 +1584,19 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof(uint32_t) + sizeof(SCR));
-	ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
-	if (!ndlp)
-		return 1;
 
-	lpfc_nlp_init(vport, ndlp, nportid);
+	ndlp = lpfc_findnode_did(vport, nportid);
+	if (!ndlp) {
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp)
+			return 1;
+		lpfc_nlp_init(vport, ndlp, nportid);
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			return 1;
+	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_SCR);
@@ -1623,11 +1659,19 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof(uint32_t) + sizeof(FARP));
-	ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
-	if (!ndlp)
-		return 1;
 
-	lpfc_nlp_init(vport, ndlp, nportid);
+	ndlp = lpfc_findnode_did(vport, nportid);
+	if (!ndlp) {
+		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		if (!ndlp)
+			return 1;
+		lpfc_nlp_init(vport, ndlp, nportid);
+		lpfc_enqueue_node(vport, ndlp);
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			return 1;
+	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RNID);
@@ -1657,7 +1701,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	memcpy(&fp->RportName, &vport->fc_portname, sizeof(struct lpfc_name));
 	memcpy(&fp->RnodeName, &vport->fc_nodename, sizeof(struct lpfc_name));
 	ondlp = lpfc_findnode_did(vport, nportid);
-	if (ondlp) {
+	if (ondlp && NLP_CHK_NODE_ACT(ondlp)) {
 		memcpy(&fp->OportName, &ondlp->nlp_portname,
 		       sizeof(struct lpfc_name));
 		memcpy(&fp->OnodeName, &ondlp->nlp_nodename,
@@ -1690,6 +1734,7 @@ void
 lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_work_evt *evtp;
 
 	spin_lock_irq(shost->host_lock);
 	nlp->nlp_flag &= ~NLP_DELAY_TMO;
@@ -1697,8 +1742,12 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 	del_timer_sync(&nlp->nlp_delayfunc);
 	nlp->nlp_last_elscmd = 0;
 
-	if (!list_empty(&nlp->els_retry_evt.evt_listp))
+	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
 		list_del_init(&nlp->els_retry_evt.evt_listp);
+		/* Decrement nlp reference count held for the delayed retry */
+		evtp = &nlp->els_retry_evt;
+		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
+	}
 
 	if (nlp->nlp_flag & NLP_NPR_2B_DISC) {
 		spin_lock_irq(shost->host_lock);
@@ -1842,13 +1891,14 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		cmd = *elscmd++;
 	}
 
-	if (ndlp)
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 		did = ndlp->nlp_DID;
 	else {
 		/* We should only hit this case for retrying PLOGI */
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
-		if (!ndlp && (cmd != ELS_CMD_PLOGI))
+		if ((!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		    && (cmd != ELS_CMD_PLOGI))
 			return 1;
 	}
 
@@ -2322,6 +2372,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 		if ((rspiocb->iocb.ulpStatus == 0)
 		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
 			lpfc_unreg_rpi(vport, ndlp);
+			/* Increment reference count to ndlp to hold the
+			 * reference to ndlp for the callback function.
+			 */
 			mbox->context2 = lpfc_nlp_get(ndlp);
 			mbox->vport = vport;
 			if (ndlp->nlp_flag & NLP_RM_DFLT_RPI) {
@@ -2335,9 +2388,13 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 					   NLP_STE_REG_LOGIN_ISSUE);
 			}
 			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
-			    != MBX_NOT_FINISHED) {
+			    != MBX_NOT_FINISHED)
 				goto out;
-			}
+			else
+				/* Decrement the ndlp reference count we
+				 * set for this failed mailbox command.
+				 */
+				lpfc_nlp_put(ndlp);
 
 			/* ELS rsp: Cannot issue reg_login for <NPortid> */
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -2796,6 +2853,8 @@ lpfc_els_disc_adisc(struct lpfc_vport *v
 
 	/* go thru NPR nodes and issue any remaining ELS ADISCs */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
 		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
 		    (ndlp->nlp_flag & NLP_NPR_ADISC) != 0) {
@@ -2833,6 +2892,8 @@ lpfc_els_disc_plogi(struct lpfc_vport *v
 
 	/* go thru NPR nodes and issue any remaining ELS PLOGIs */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
 		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
 		    (ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
@@ -2943,7 +3004,8 @@ lpfc_rscn_recovery_check(struct lpfc_vpo
 	 */
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE ||
+		if (!NLP_CHK_NODE_ACT(ndlp) ||
+		    ndlp->nlp_state == NLP_STE_UNUSED_NODE ||
 		    lpfc_rscn_payload_check(vport, ndlp->nlp_DID) == 0)
 			continue;
 
@@ -3145,7 +3207,8 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 	vport->num_disc_nodes = 0;
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
-	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
+	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		/* Good ndlp, issue CT Request to NameServer */
 		if (lpfc_ns_cmd(vport, SLI_CTNS_GID_FT, 0, 0) == 0)
 			/* Wait for NameServer query cmpl before we can
@@ -3155,25 +3218,35 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 		/* If login to NameServer does not exist, issue one */
 		/* Good status, issue PLOGI to NameServer */
 		ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ndlp)
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 			/* Wait for NameServer login cmpl before we can
 			   continue */
 			return 1;
 
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
-		if (!ndlp) {
-			lpfc_els_flush_rscn(vport);
-			return 0;
+		if (ndlp) {
+			ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_PLOGI_ISSUE);
+			if (!ndlp) {
+				lpfc_els_flush_rscn(vport);
+				return 0;
+			}
+			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
 		} else {
+			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+			if (!ndlp) {
+				lpfc_els_flush_rscn(vport);
+				return 0;
+			}
 			lpfc_nlp_init(vport, ndlp, NameServer_DID);
-			ndlp->nlp_type |= NLP_FABRIC;
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
-			lpfc_issue_els_plogi(vport, NameServer_DID, 0);
-			/* Wait for NameServer login cmpl before we can
-			   continue */
-			return 1;
 		}
+		ndlp->nlp_type |= NLP_FABRIC;
+		lpfc_issue_els_plogi(vport, NameServer_DID, 0);
+		/* Wait for NameServer login cmpl before we can
+		 * continue
+		 */
+		return 1;
 	}
 
 	lpfc_els_flush_rscn(vport);
@@ -3672,6 +3745,8 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vport->fc_nodes, nlp_listp) {
+				if (!NLP_CHK_NODE_ACT(ndlp))
+					continue;
 				if (ndlp->nlp_state != NLP_STE_NPR_NODE)
 					continue;
 				if (ndlp->nlp_type & NLP_FABRIC) {
@@ -3697,6 +3772,8 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 		 */
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
 			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
 				continue;
 
@@ -3936,7 +4013,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	uint32_t cmd, did, newnode, rjt_err = 0;
 	IOCB_t *icmd = &elsiocb->iocb;
 
-	if (vport == NULL || elsiocb->context2 == NULL)
+	if (!vport || !(elsiocb->context2))
 		goto dropit;
 
 	newnode = 0;
@@ -3971,14 +4048,20 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		newnode = 1;
-		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK) {
+		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
 			ndlp->nlp_type |= NLP_FABRIC;
+	} else {
+		if (!NLP_CHK_NODE_ACT(ndlp)) {
+			ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_UNUSED_NODE);
+			if (!ndlp)
+				goto dropit;
 		}
-	}
-	else {
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 			/* This is simular to the new node path */
-			lpfc_nlp_get(ndlp);
+			ndlp = lpfc_nlp_get(ndlp);
+			if (!ndlp)
+				goto dropit;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 			newnode = 1;
 		}
@@ -3987,6 +4070,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	phba->fc_stat.elsRcvFrame++;
 	if (elsiocb->context1)
 		lpfc_nlp_put(elsiocb->context1);
+
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->vport = vport;
 
@@ -4314,6 +4398,18 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 		}
 		lpfc_nlp_init(vport, ndlp, NameServer_DID);
 		ndlp->nlp_type |= NLP_FABRIC;
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
+		if (!ndlp) {
+			if (phba->fc_topology == TOPOLOGY_LOOP) {
+				lpfc_disc_start(vport);
+				return;
+			}
+			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+					"0348 NameServer login: node freed\n");
+			return;
+		}
 	}
 
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
@@ -4471,7 +4567,6 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 				 irsp->ulpStatus, irsp->un.ulpWord[4]);
 		if (vport->fc_vport->vport_state == FC_VPORT_INITIALIZING)
 			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-
 		lpfc_nlp_put(ndlp);
 		/* giving up on FDISC. Cancel discovery timer */
 		lpfc_can_disctmo(vport);
@@ -4492,8 +4587,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 			 */
 			list_for_each_entry_safe(np, next_np,
 				&vport->fc_nodes, nlp_listp) {
-				if (np->nlp_state != NLP_STE_NPR_NODE
-				   || !(np->nlp_flag & NLP_NPR_ADISC))
+				if (!NLP_CHK_NODE_ACT(ndlp) ||
+				    (np->nlp_state != NLP_STE_NPR_NODE) ||
+				    !(np->nlp_flag & NLP_NPR_ADISC))
 					continue;
 				spin_lock_irq(shost->host_lock);
 				np->nlp_flag &= ~NLP_NPR_ADISC;
@@ -4599,6 +4695,8 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
+	struct lpfc_nodelist *ndlp;
+	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
 
 	irsp = &rspiocb->iocb;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -4607,6 +4705,9 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 
 	lpfc_els_free_iocb(phba, cmdiocb);
 	vport->unreg_vpi_cmpl = VPORT_ERROR;
+
+	/* Trigger the release of the ndlp after logo */
+	lpfc_nlp_put(ndlp);
 }
 
 int
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-06 11:02:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:10:08.000000000 -0500
@@ -595,6 +595,8 @@ struct lpfc_hba {
 	unsigned long last_completion_time;
 	struct timer_list hb_tmofunc;
 	uint8_t hb_outstanding;
+	/* ndlp reference management */
+	spinlock_t ndlp_lock;
 	/*
 	 * Following bit will be set for all buffer tags which are not
 	 * associated with any HBQ.
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -272,9 +272,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	if (!(vport->load_flag & FC_UNLOADING) &&
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)) {
+	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
-	}
 }
 

@@ -566,9 +565,10 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 	int  rc;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
-
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
 			((vport->port_type == LPFC_NPIV_PORT) &&
 			(ndlp->nlp_DID == NameServer_DID)))
@@ -684,20 +684,21 @@ lpfc_linkup_cleanup_nodes(struct lpfc_vp
 	struct lpfc_nodelist *ndlp;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
-
 		if (ndlp->nlp_type & NLP_FABRIC) {
-				/* On Linkup its safe to clean up the ndlp
-				 * from Fabric connections.
-				 */
+			/* On Linkup its safe to clean up the ndlp
+			 * from Fabric connections.
+			 */
 			if (ndlp->nlp_DID != Fabric_DID)
 				lpfc_unreg_rpi(vport, ndlp);
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
-				/* Fail outstanding IO now since device is
-				 * marked for PLOGI.
-				 */
+			/* Fail outstanding IO now since device is
+			 * marked for PLOGI.
+			 */
 			lpfc_unreg_rpi(vport, ndlp);
 		}
 	}
@@ -1305,7 +1306,6 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
-		lpfc_nlp_put(ndlp);
 
 		if (phba->fc_topology == TOPOLOGY_LOOP) {
 			/* FLOGI failed, use loop map to make discovery list */
@@ -1313,6 +1313,10 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 
 			/* Start discovery */
 			lpfc_disc_start(vport);
+			/* Decrement the reference count to ndlp after the
+			 * reference to the ndlp are done.
+			 */
+			lpfc_nlp_put(ndlp);
 			return;
 		}
 
@@ -1320,6 +1324,10 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 				 "0258 Register Fabric login error: 0x%x\n",
 				 mb->mbxStatus);
+		/* Decrement the reference count to ndlp after the reference
+		 * to the ndlp are done.
+		 */
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
@@ -1327,8 +1335,6 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
-	lpfc_nlp_put(ndlp);	/* Drop the reference from the mbox */
-
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports != NULL)
@@ -1356,6 +1362,11 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* Drop the reference count from the mbox at the end after
+	 * all the current reference to the ndlp have been done.
+	 */
+	lpfc_nlp_put(ndlp);
 	return;
 }
 
@@ -1463,9 +1474,8 @@ lpfc_register_remote_port(struct lpfc_vp
 	 * registered the port.
 	 */
 	if (ndlp->rport && ndlp->rport->dd_data &&
-	    ((struct lpfc_rport_data *) ndlp->rport->dd_data)->pnode == ndlp) {
+	    ((struct lpfc_rport_data *) ndlp->rport->dd_data)->pnode == ndlp)
 		lpfc_nlp_put(ndlp);
-	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 		"rport add:       did:x%x flg:x%x type x%x",
@@ -1660,6 +1670,18 @@ lpfc_nlp_set_state(struct lpfc_vport *vp
 }
 
 void
+lpfc_enqueue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	if (list_empty(&ndlp->nlp_listp)) {
+		spin_lock_irq(shost->host_lock);
+		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
+		spin_unlock_irq(shost->host_lock);
+	}
+}
+
+void
 lpfc_dequeue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
@@ -1672,7 +1694,80 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 	list_del_init(&ndlp->nlp_listp);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
-			       NLP_STE_UNUSED_NODE);
+				NLP_STE_UNUSED_NODE);
+}
+
+void
+lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
+		lpfc_cancel_retry_delay_tmo(vport, ndlp);
+	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
+		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
+	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
+				NLP_STE_UNUSED_NODE);
+}
+
+struct lpfc_nodelist *
+lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+		 int state)
+{
+	struct lpfc_hba *phba = vport->phba;
+	uint32_t did;
+	unsigned long flags;
+
+	if (!ndlp)
+		return NULL;
+
+	spin_lock_irqsave(&phba->ndlp_lock, flags);
+	/* The ndlp should not be in memory free mode */
+	if (NLP_CHK_FREE_REQ(ndlp)) {
+		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+				"0277 lpfc_enable_node: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		return NULL;
+	}
+	/* The ndlp should not already be in active mode */
+	if (NLP_CHK_NODE_ACT(ndlp)) {
+		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+				"0278 lpfc_enable_node: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		return NULL;
+	}
+
+	/* Keep the original DID */
+	did = ndlp->nlp_DID;
+
+	/* re-initialize ndlp except of ndlp linked list pointer */
+	memset((((char *)ndlp) + sizeof (struct list_head)), 0,
+		sizeof (struct lpfc_nodelist) - sizeof (struct list_head));
+	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
+	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
+	init_timer(&ndlp->nlp_delayfunc);
+	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
+	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
+	ndlp->nlp_DID = did;
+	ndlp->vport = vport;
+	ndlp->nlp_sid = NLP_NO_SID;
+	/* ndlp management re-initialize */
+	kref_init(&ndlp->kref);
+	NLP_INT_NODE_ACT(ndlp);
+
+	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+
+	if (state != NLP_STE_UNUSED_NODE)
+		lpfc_nlp_set_state(vport, ndlp, state);
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
+		"node enable:       did:x%x",
+		ndlp->nlp_DID, 0, 0);
+	return ndlp;
 }
 
 void
@@ -1972,7 +2067,21 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 			 "Data: x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_flag,
 			 ndlp->nlp_state, ndlp->nlp_rpi);
-	lpfc_dequeue_node(vport, ndlp);
+	if (NLP_CHK_FREE_REQ(ndlp)) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+				"0280 lpfc_cleanup_node: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		lpfc_dequeue_node(vport, ndlp);
+	} else {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NODE,
+				"0281 lpfc_cleanup_node: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		lpfc_disable_node(vport, ndlp);
+	}
 
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
@@ -1994,12 +2103,16 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 			}
 			list_del(&mb->list);
 			mempool_free(mb, phba->mbox_mem_pool);
-			lpfc_nlp_put(ndlp);
+			/* We shall not invoke the lpfc_nlp_put to decrement
+			 * the ndlp reference count as we are in the process
+			 * of lpfc_nlp_release.
+			 */
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	lpfc_els_abort(phba,ndlp);
+	lpfc_els_abort(phba, ndlp);
+
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
 	spin_unlock_irq(shost->host_lock);
@@ -2057,7 +2170,6 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 			}
 		}
 	}
-
 	lpfc_cleanup_node(vport, ndlp);
 
 	/*
@@ -2182,7 +2294,16 @@ lpfc_setup_disc_node(struct lpfc_vport *
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
 		return ndlp;
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
+		if (!ndlp)
+			return NULL;
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+		spin_unlock_irq(shost->host_lock);
+		return ndlp;
 	}
+
 	if (vport->fc_flag & FC_RSCN_MODE) {
 		if (lpfc_rscn_payload_check(vport, did)) {
 			/* If we've already recieved a PLOGI from this NPort
@@ -2485,6 +2606,8 @@ lpfc_disc_flush_list(struct lpfc_vport *
 	if (vport->fc_plogi_cnt || vport->fc_adisc_cnt) {
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
 			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
 			    ndlp->nlp_state == NLP_STE_ADISC_ISSUE) {
 				lpfc_free_tx(phba, ndlp);
@@ -2572,6 +2695,8 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		/* Start discovery by sending FLOGI, clean up old rpis */
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
 			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
 				continue;
 			if (ndlp->nlp_type & NLP_FABRIC) {
@@ -2618,7 +2743,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 				 "NameServer login\n");
 		/* Next look for NameServer ndlp */
 		ndlp = lpfc_findnode_did(vport, NameServer_DID);
-		if (ndlp)
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 			lpfc_els_abort(phba, ndlp);
 
 		/* ReStart discovery */
@@ -2897,6 +3022,7 @@ lpfc_nlp_init(struct lpfc_vport *vport, 
 	ndlp->nlp_sid = NLP_NO_SID;
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	kref_init(&ndlp->kref);
+	NLP_INT_NODE_ACT(ndlp);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
 		"node init:       did:x%x",
@@ -2911,6 +3037,8 @@ lpfc_nlp_init(struct lpfc_vport *vport, 
 static void
 lpfc_nlp_release(struct kref *kref)
 {
+	struct lpfc_hba *phba;
+	unsigned long flags;
 	struct lpfc_nodelist *ndlp = container_of(kref, struct lpfc_nodelist,
 						  kref);
 
@@ -2918,8 +3046,24 @@ lpfc_nlp_release(struct kref *kref)
 		"node release:    did:x%x flg:x%x type:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
+	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+			"0279 lpfc_nlp_release: ndlp:x%p "
+			"usgmap:x%x refcnt:%d\n",
+			(void *)ndlp, ndlp->nlp_usg_map,
+			atomic_read(&ndlp->kref.refcount));
+
+	/* remove ndlp from action. */
 	lpfc_nlp_remove(ndlp->vport, ndlp);
-	mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
+
+	/* clear the ndlp active flag for all release cases */
+	phba = ndlp->vport->phba;
+	spin_lock_irqsave(&phba->ndlp_lock, flags);
+	NLP_CLR_NODE_ACT(ndlp);
+	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+
+	/* free ndlp memory for final ndlp release */
+	if (NLP_CHK_FREE_REQ(ndlp))
+		mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
 }
 
 /* This routine bumps the reference count for a ndlp structure to ensure
@@ -2929,37 +3073,108 @@ lpfc_nlp_release(struct kref *kref)
 struct lpfc_nodelist *
 lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 {
+	struct lpfc_hba *phba;
+	unsigned long flags;
+
 	if (ndlp) {
 		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
 			"node get:        did:x%x flg:x%x refcnt:x%x",
 			ndlp->nlp_DID, ndlp->nlp_flag,
 			atomic_read(&ndlp->kref.refcount));
-		kref_get(&ndlp->kref);
+		/* The check of ndlp usage to prevent incrementing the
+		 * ndlp reference count that is in the process of being
+		 * released.
+		 */
+		phba = ndlp->vport->phba;
+		spin_lock_irqsave(&phba->ndlp_lock, flags);
+		if (!NLP_CHK_NODE_ACT(ndlp) || NLP_CHK_FREE_ACK(ndlp)) {
+			spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+			lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
+				"0276 lpfc_nlp_get: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+			return NULL;
+		} else
+			kref_get(&ndlp->kref);
+		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 	}
 	return ndlp;
 }
 
-
 /* This routine decrements the reference count for a ndlp structure. If the
- * count goes to 0, this indicates the the associated nodelist should be freed.
+ * count goes to 0, this indicates the the associated nodelist should be
+ * freed. Returning 1 indicates the ndlp resource has been released; on the
+ * other hand, returning 0 indicates the ndlp resource has not been released
+ * yet.
  */
 int
 lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 {
-	if (ndlp) {
-		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
-		"node put:        did:x%x flg:x%x refcnt:x%x",
-			ndlp->nlp_DID, ndlp->nlp_flag,
-			atomic_read(&ndlp->kref.refcount));
+	struct lpfc_hba *phba;
+	unsigned long flags;
+
+	if (!ndlp)
+		return 1;
+
+	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
+	"node put:        did:x%x flg:x%x refcnt:x%x",
+		ndlp->nlp_DID, ndlp->nlp_flag,
+		atomic_read(&ndlp->kref.refcount));
+	phba = ndlp->vport->phba;
+	spin_lock_irqsave(&phba->ndlp_lock, flags);
+	/* Check the ndlp memory free acknowledge flag to avoid the
+	 * possible race condition that kref_put got invoked again
+	 * after previous one has done ndlp memory free.
+	 */
+	if (NLP_CHK_FREE_ACK(ndlp)) {
+		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
+				"0274 lpfc_nlp_put: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		return 1;
+	}
+	/* Check the ndlp inactivate log flag to avoid the possible
+	 * race condition that kref_put got invoked again after ndlp
+	 * is already in inactivating state.
+	 */
+	if (NLP_CHK_IACT_REQ(ndlp)) {
+		spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
+				"0275 lpfc_nlp_put: ndlp:x%p "
+				"usgmap:x%x refcnt:%d\n",
+				(void *)ndlp, ndlp->nlp_usg_map,
+				atomic_read(&ndlp->kref.refcount));
+		return 1;
 	}
-	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
+	/* For last put, mark the ndlp usage flags to make sure no
+	 * other kref_get and kref_put on the same ndlp shall get
+	 * in between the process when the final kref_put has been
+	 * invoked on this ndlp.
+	 */
+	if (atomic_read(&ndlp->kref.refcount) == 1) {
+		/* Indicate ndlp is put to inactive state. */
+		NLP_SET_IACT_REQ(ndlp);
+		/* Acknowledge ndlp memory free has been seen. */
+		if (NLP_CHK_FREE_REQ(ndlp))
+			NLP_SET_FREE_ACK(ndlp);
+	}
+	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+	/* Note, the kref_put returns 1 when decrementing a reference
+	 * count that was 1, it invokes the release callback function,
+	 * but it still left the reference count as 1 (not actually
+	 * performs the last decrementation). Otherwise, it actually
+	 * decrements the reference count and returns 0.
+	 */
+	return kref_put(&ndlp->kref, lpfc_nlp_release);
 }
 
 /* This routine free's the specified nodelist if it is not in use
- * by any other discovery thread. This routine returns 1 if the ndlp
- * is not being used by anyone and has been freed. A return value of
- * 0 indicates it is being used by another discovery thread and the
- * refcount is left unchanged.
+ * by any other discovery thread. This routine returns 1 if the
+ * ndlp has been freed. A return value of 0 indicates the ndlp is
+ * not yet been released.
  */
 int
 lpfc_nlp_not_used(struct lpfc_nodelist *ndlp)
@@ -2968,11 +3183,8 @@ lpfc_nlp_not_used(struct lpfc_nodelist *
 		"node not used:   did:x%x flg:x%x refcnt:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag,
 		atomic_read(&ndlp->kref.refcount));
-
-	if (atomic_read(&ndlp->kref.refcount) == 1) {
-		lpfc_nlp_put(ndlp);
-		return 1;
-	}
+	if (atomic_read(&ndlp->kref.refcount) == 1)
+		if (lpfc_nlp_put(ndlp))
+			return 1;
 	return 0;
 }
-
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-06 11:02:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:10:20.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -1422,9 +1422,32 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_port_link_failure(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp)) {
+			ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_UNUSED_NODE);
+			if (!ndlp)
+				continue;
+			spin_lock_irq(&phba->ndlp_lock);
+			NLP_SET_FREE_REQ(ndlp);
+			spin_unlock_irq(&phba->ndlp_lock);
+			/* Trigger the release of the ndlp memory */
+			lpfc_nlp_put(ndlp);
+			continue;
+		}
+		spin_lock_irq(&phba->ndlp_lock);
+		if (NLP_CHK_FREE_REQ(ndlp)) {
+			/* The ndlp should not be in memory free mode already */
+			spin_unlock_irq(&phba->ndlp_lock);
+			continue;
+		} else
+			/* Indicate request for freeing ndlp memory */
+			NLP_SET_FREE_REQ(ndlp);
+		spin_unlock_irq(&phba->ndlp_lock);
+
 		if (ndlp->nlp_type & NLP_FABRIC)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
+
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					     NLP_EVT_DEVICE_RM);
 	}
@@ -1438,6 +1461,17 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		if (i++ > 3000) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				"0233 Nodelist not empty\n");
+			list_for_each_entry_safe(ndlp, next_ndlp,
+						&vport->fc_nodes, nlp_listp) {
+				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
+						LOG_NODE,
+						"0282: did:x%x ndlp:x%p "
+						"usgmap:x%x refcnt:%d\n",
+						ndlp->nlp_DID, (void *)ndlp,
+						ndlp->nlp_usg_map,
+						atomic_read(
+							&ndlp->kref.refcount));
+			}
 			break;
 		}
 
@@ -1586,6 +1620,8 @@ lpfc_offline_prep(struct lpfc_hba * phba
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
+				if (!NLP_CHK_NODE_ACT(ndlp))
+					continue;
 				if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 					continue;
 				if (ndlp->nlp_type & NLP_FABRIC) {
@@ -1905,6 +1941,9 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	spin_lock_init(&phba->hbalock);
 
+	/* Initialize ndlp management spinlock */
+	spin_lock_init(&phba->ndlp_lock);
+
 	phba->pcidev = pdev;
 
 	/* Assign an unused board number */
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-02-08 18:10:20.000000000 -0500
@@ -1,7 +1,7 @@
  /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -249,6 +249,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
+	struct lpfc_work_evt *evtp;
 	uint32_t *lp;
 	IOCB_t *icmd;
 	struct serv_parm *sp;
@@ -435,8 +436,14 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 		del_timer_sync(&ndlp->nlp_delayfunc);
 		ndlp->nlp_last_elscmd = 0;
 
-		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
+		if (!list_empty(&ndlp->els_retry_evt.evt_listp)) {
 			list_del_init(&ndlp->els_retry_evt.evt_listp);
+			/* Decrement ndlp reference count held for the
+			 * delayed retry
+			 */
+			evtp = &ndlp->els_retry_evt;
+			lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
+		}
 
 		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
 			spin_lock_irq(shost->host_lock);
@@ -656,7 +663,7 @@ lpfc_disc_illegal(struct lpfc_vport *vpo
 		  void *arg, uint32_t evt)
 {
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-			 "0253 Illegal State Transition: node x%x "
+			 "0271 Illegal State Transition: node x%x "
 			 "event x%x, state x%x Data: x%x x%x\n",
 			 ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
 			 ndlp->nlp_flag);
@@ -674,7 +681,7 @@ lpfc_cmpl_plogi_illegal(struct lpfc_vpor
 	 */
 	if (!(ndlp->nlp_flag & NLP_RCV_PLOGI)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-			 "0253 Illegal State Transition: node x%x "
+			 "0272 Illegal State Transition: node x%x "
 			 "event x%x, state x%x Data: x%x x%x\n",
 			 ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
 			 ndlp->nlp_flag);
@@ -2144,8 +2151,11 @@ lpfc_disc_state_machine(struct lpfc_vpor
 	uint32_t cur_state, rc;
 	uint32_t(*func) (struct lpfc_vport *, struct lpfc_nodelist *, void *,
 			 uint32_t);
+	uint32_t got_ndlp = 0;
+
+	if (lpfc_nlp_get(ndlp))
+		got_ndlp = 1;
 
-	lpfc_nlp_get(ndlp);
 	cur_state = ndlp->nlp_state;
 
 	/* DSM in event <evt> on NPort <nlp_DID> in state <cur_state> */
@@ -2162,15 +2172,24 @@ lpfc_disc_state_machine(struct lpfc_vpor
 	rc = (func) (vport, ndlp, arg, evt);
 
 	/* DSM out state <rc> on NPort <nlp_DID> */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+	if (got_ndlp) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0212 DSM out state %d on NPort x%x Data: x%x\n",
 			 rc, ndlp->nlp_DID, ndlp->nlp_flag);
 
-	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
-		 "DSM out:         ste:%d did:x%x flg:x%x",
-		rc, ndlp->nlp_DID, ndlp->nlp_flag);
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
+			"DSM out:         ste:%d did:x%x flg:x%x",
+			rc, ndlp->nlp_DID, ndlp->nlp_flag);
+		/* Decrement the ndlp reference count held for this function */
+		lpfc_nlp_put(ndlp);
+	} else {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			"0212 DSM out state %d on NPort free\n", rc);
 
-	lpfc_nlp_put(ndlp);
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
+			"DSM out:         ste:%d did:x%x flg:x%x",
+			rc, 0, 0);
+	}
 
 	return rc;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-02-06 11:02:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -1283,6 +1283,8 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		match = 0;
 		spin_lock_irq(shost->host_lock);
 		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
 			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
 			    i == ndlp->nlp_sid &&
 			    ndlp->rport) {
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-02-08 18:10:08.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -327,7 +327,8 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	 * up and ready to FDISC.
 	 */
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		if (phba->link_flag & LS_NPIV_FAB_SUPPORTED) {
 			lpfc_set_disctmo(vport);
 			lpfc_initial_fdisc(vport);
@@ -358,7 +359,8 @@ disable_vport(struct fc_vport *fc_vport)
 	long timeout;
 
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (ndlp && phba->link_state >= LPFC_LINK_UP) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
+	    && phba->link_state >= LPFC_LINK_UP) {
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
@@ -372,6 +374,8 @@ disable_vport(struct fc_vport *fc_vport)
 	 * calling lpfc_cleanup_rpis(vport, 1)
 	 */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 		lpfc_disc_state_machine(vport, ndlp, NULL,
@@ -414,7 +418,8 @@ enable_vport(struct fc_vport *fc_vport)
 	 * up and ready to FDISC.
 	 */
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
+	    && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		if (phba->link_flag & LS_NPIV_FAB_SUPPORTED) {
 			lpfc_set_disctmo(vport);
 			lpfc_initial_fdisc(vport);
@@ -498,7 +503,41 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	scsi_remove_host(lpfc_shost_from_vport(vport));
 
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
-	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
+
+	/* In case of driver unload, we shall not perform fabric logo as the
+	 * worker thread already stopped at this stage and, in this case, we
+	 * can safely skip the fabric logo.
+	 */
+	if (phba->pport->load_flag & FC_UNLOADING) {
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+		    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
+		    phba->link_state >= LPFC_LINK_UP) {
+			/* First look for the Fabric ndlp */
+			ndlp = lpfc_findnode_did(vport, Fabric_DID);
+			if (!ndlp)
+				goto skip_logo;
+			else if (!NLP_CHK_NODE_ACT(ndlp)) {
+				ndlp = lpfc_enable_node(vport, ndlp,
+							NLP_STE_UNUSED_NODE);
+				if (!ndlp)
+					goto skip_logo;
+			}
+			/* Remove ndlp from vport npld list */
+			lpfc_dequeue_node(vport, ndlp);
+
+			/* Indicate free memory when release */
+			spin_lock_irq(&phba->ndlp_lock);
+			NLP_SET_FREE_REQ(ndlp);
+			spin_unlock_irq(&phba->ndlp_lock);
+			/* Kick off release ndlp when it can be safely done */
+			lpfc_nlp_put(ndlp);
+		}
+		goto skip_logo;
+	}
+
+	/* Otherwise, we will perform fabric logo as needed */
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP) {
 		if (vport->cfg_enable_da_id) {
 			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
@@ -519,8 +558,27 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 			if (!ndlp)
 				goto skip_logo;
 			lpfc_nlp_init(vport, ndlp, Fabric_DID);
+			/* Indicate free memory when release */
+			NLP_SET_FREE_REQ(ndlp);
 		} else {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_UNUSED_NODE);
+				if (!ndlp)
+					goto skip_logo;
+
+			/* Remove ndlp from vport npld list */
 			lpfc_dequeue_node(vport, ndlp);
+			spin_lock_irq(&phba->ndlp_lock);
+			if (!NLP_CHK_FREE_REQ(ndlp))
+				/* Indicate free memory when release */
+				NLP_SET_FREE_REQ(ndlp);
+			else {
+				/* Skip this if ndlp is already in free mode */
+				spin_unlock_irq(&phba->ndlp_lock);
+				goto skip_logo;
+			}
+			spin_unlock_irq(&phba->ndlp_lock);
 		}
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
@@ -534,9 +592,9 @@ skip_logo:
 	lpfc_sli_host_down(vport);
 
 	lpfc_stop_vport_timers(vport);
-	lpfc_unreg_all_rpis(vport);
 
 	if (!(phba->pport->load_flag & FC_UNLOADING)) {
+		lpfc_unreg_all_rpis(vport);
 		lpfc_unreg_default_rpis(vport);
 		/*
 		 * Completion of unreg_vpi (lpfc_mbx_cmpl_unreg_vpi)


