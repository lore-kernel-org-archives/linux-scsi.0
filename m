From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/9] lpfc 8.2.3 : Miscellaneous Small Fixes - part 1
Date: Sat, 27 Oct 2007 13:37:33 -0400
Message-ID: <1193506653.8770.20.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46342 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbXJ0Rh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:29 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbSYn021365
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Small Fixes - part 1
- Fix typo kmzlloc -> kzalloc
- Fix discovery ndlp use after free panic
- Fix link event causing flood of 0108 messages
- Relieve some mbox congestion on link up with 100 vports
- Fix broken vport parameters
- Prevent lock recursion in logo_reglogin_issue
- Split uses of error variable in lpfc_pci_probe_one into retval and error
- Remove completion code related to dev_loss_tmo
- Remove unused LPFC_MAX_HBQ #define
- Don't compare pointers to 0 for sparse
- Make 2 functions static for sparse
- Fix default rpi cleanup code causing rogue ndlps to remain on the NPR list
- Remove annoying ELS messages when driver is unloaded
- Fix Cannot issue Register Fabric login problems on link up
- Remove LPFC_EVT_DEV_LOSS_DELAY
- Fix FC port swap test leads to device going offline
- Fix vport CT flags to only be set when accepted
- Add code to handle signals during vport_create
- Fix too many retries in FC-AL mode
- Pull lpfc_port_link_failure out of lpfc_linkdown_port

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:37:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:45:06.000000000 -0400
@@ -2363,13 +2363,67 @@ struct fc_function_template lpfc_transpo
 	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
 	.terminate_rport_io = lpfc_terminate_rport_io,
 
-	/* Vport fields are filled in at runtime based on enable_npiv */
-	.vport_create = NULL,
-	.vport_delete = NULL,
-	.vport_disable = NULL,
 	.dd_fcvport_size = sizeof(struct lpfc_vport *),
 };
 
+struct fc_function_template lpfc_vport_transport_functions = {
+	/* fixed attributes the driver supports */
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+
+	/* dynamic attributes the driver supports */
+	.get_host_port_id = lpfc_get_host_port_id,
+	.show_host_port_id = 1,
+
+	.get_host_port_type = lpfc_get_host_port_type,
+	.show_host_port_type = 1,
+
+	.get_host_port_state = lpfc_get_host_port_state,
+	.show_host_port_state = 1,
+
+	/* active_fc4s is shown but doesn't change (thus no get function) */
+	.show_host_active_fc4s = 1,
+
+	.get_host_speed = lpfc_get_host_speed,
+	.show_host_speed = 1,
+
+	.get_host_fabric_name = lpfc_get_host_fabric_name,
+	.show_host_fabric_name = 1,
+
+	/*
+	 * The LPFC driver treats linkdown handling as target loss events
+	 * so there are no sysfs handlers for link_down_tmo.
+	 */
+
+	.get_fc_host_stats = lpfc_get_stats,
+	.reset_fc_host_stats = lpfc_reset_stats,
+
+	.dd_fcrport_size = sizeof(struct lpfc_rport_data),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+
+	.get_starget_port_id  = lpfc_get_starget_port_id,
+	.show_starget_port_id = 1,
+
+	.get_starget_node_name = lpfc_get_starget_node_name,
+	.show_starget_node_name = 1,
+
+	.get_starget_port_name = lpfc_get_starget_port_name,
+	.show_starget_port_name = 1,
+
+	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
+	.terminate_rport_io = lpfc_terminate_rport_io,
+
+	.vport_disable = lpfc_vport_disable,
+};
+
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:37:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:45:06.000000000 -0400
@@ -68,6 +68,7 @@ int lpfc_check_sli_ndlp(struct lpfc_hba 
 void lpfc_nlp_init(struct lpfc_vport *, struct lpfc_nodelist *, uint32_t);
 struct lpfc_nodelist *lpfc_nlp_get(struct lpfc_nodelist *);
 int  lpfc_nlp_put(struct lpfc_nodelist *);
+int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_vport *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_vport *);
 void lpfc_disc_start(struct lpfc_vport *);
@@ -260,6 +261,7 @@ extern struct class_device_attribute *lp
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
+extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
 extern int lpfc_enable_npiv;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-10-27 10:37:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-10-27 10:45:18.000000000 -0400
@@ -458,7 +458,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 			    ((lpfc_find_vport_by_did(phba, Did) == NULL) ||
 			     vport->cfg_peer_port_login)) {
 				if ((vport->port_type != LPFC_NPIV_PORT) ||
-				    (!vport->ct_flags & FC_CT_RFF_ID) ||
+				    (!(vport->ct_flags & FC_CT_RFF_ID)) ||
 				    (!vport->cfg_restrict_login)) {
 					ndlp = lpfc_setup_disc_node(vport, Did);
 					if (ndlp) {
@@ -854,8 +854,16 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS)
-		vport->ct_flags |= FC_CT_RFT_ID;
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		struct lpfc_dmabuf *outp;
+		struct lpfc_sli_ct_request *CTrsp;
+
+		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		if (CTrsp->CommandResponse.bits.CmdRsp ==
+		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
+			vport->ct_flags |= FC_CT_RFT_ID;
+	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
@@ -867,8 +875,16 @@ lpfc_cmpl_ct_cmd_rnn_id(struct lpfc_hba 
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS)
-		vport->ct_flags |= FC_CT_RNN_ID;
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		struct lpfc_dmabuf *outp;
+		struct lpfc_sli_ct_request *CTrsp;
+
+		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		if (CTrsp->CommandResponse.bits.CmdRsp ==
+		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
+			vport->ct_flags |= FC_CT_RNN_ID;
+	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
@@ -880,8 +896,16 @@ lpfc_cmpl_ct_cmd_rspn_id(struct lpfc_hba
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS)
-		vport->ct_flags |= FC_CT_RSPN_ID;
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		struct lpfc_dmabuf *outp;
+		struct lpfc_sli_ct_request *CTrsp;
+
+		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		if (CTrsp->CommandResponse.bits.CmdRsp ==
+		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
+			vport->ct_flags |= FC_CT_RSPN_ID;
+	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
@@ -893,8 +917,16 @@ lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS)
-		vport->ct_flags |= FC_CT_RSNN_NN;
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		struct lpfc_dmabuf *outp;
+		struct lpfc_sli_ct_request *CTrsp;
+
+		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		if (CTrsp->CommandResponse.bits.CmdRsp ==
+		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
+			vport->ct_flags |= FC_CT_RSNN_NN;
+	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
@@ -918,8 +950,16 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba 
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS)
-		vport->ct_flags |= FC_CT_RFF_ID;
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		struct lpfc_dmabuf *outp;
+		struct lpfc_sli_ct_request *CTrsp;
+
+		outp = (struct lpfc_dmabuf *) cmdiocb->context2;
+		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
+		if (CTrsp->CommandResponse.bits.CmdRsp ==
+		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC))
+			vport->ct_flags |= FC_CT_RFF_ID;
+	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-10-27 10:45:18.000000000 -0400
@@ -36,7 +36,6 @@ enum lpfc_work_type {
 	LPFC_EVT_WARM_START,
 	LPFC_EVT_KILL,
 	LPFC_EVT_ELS_RETRY,
-	LPFC_EVT_DEV_LOSS_DELAY,
 	LPFC_EVT_DEV_LOSS,
 };
 
@@ -104,6 +103,7 @@ struct lpfc_nodelist {
 #define NLP_RM_DFLT_RPI    0x4000000	/* need to remove leftover dflt RPI */
 #define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
+#define NLP_DELAYED_RM     0x20000000   /* Defer UNUSED List removal */
 
 /* There are 4 different double linked lists nodelist entries can reside on.
  * The Port Login (PLOGI) list and Address Discovery (ADISC) list are used
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 10:45:18.000000000 -0400
@@ -109,9 +109,10 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	if (((pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL)) == 0) ||
-	    ((pcmd->virt = lpfc_mbuf_alloc(phba,
-					   MEM_PRI, &(pcmd->phys))) == 0)) {
+	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (pcmd)
+		pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pcmd->phys);
+	if (!pcmd || !pcmd->virt) {
 		kfree(pcmd);
 
 		lpfc_sli_release_iocbq(phba, elsiocb);
@@ -126,7 +127,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		if (prsp)
 			prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						     &prsp->phys);
-		if (prsp == 0 || prsp->virt == 0) {
+		if (!prsp || !prsp->virt) {
 			kfree(prsp);
 			lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
 			kfree(pcmd);
@@ -143,7 +144,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 	if (pbuflist)
 		pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						 &pbuflist->phys);
-	if (pbuflist == 0 || pbuflist->virt == 0) {
+	if (!pbuflist || !pbuflist->virt) {
 		lpfc_sli_release_iocbq(phba, elsiocb);
 		lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
 		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
@@ -234,15 +235,20 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 	struct lpfc_nodelist *ndlp;
 	struct serv_parm *sp;
 	int rc;
+	int err = 0;
 
 	sp = &phba->fc_fabparam;
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
-	if (!ndlp)
+	if (!ndlp) {
+		err = 1;
 		goto fail;
+	}
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
+	if (!mbox) {
+		err = 2;
 		goto fail;
+	}
 
 	vport->port_state = LPFC_FABRIC_CFG_LINK;
 	lpfc_config_link(phba, mbox);
@@ -250,24 +256,32 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 	mbox->vport = vport;
 
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		err = 3;
 		goto fail_free_mbox;
+	}
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
+	if (!mbox) {
+		err = 4;
 		goto fail;
+	}
 	rc = lpfc_reg_login(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox,
 			    0);
-	if (rc)
+	if (rc) {
+		err = 5;
 		goto fail_free_mbox;
+	}
 
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_fabric_reg_login;
 	mbox->vport = vport;
 	mbox->context2 = lpfc_nlp_get(ndlp);
 
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		err = 6;
 		goto fail_issue_reg_login;
+	}
 
 	return 0;
 
@@ -282,7 +296,7 @@ fail_free_mbox:
 fail:
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-		"0249 Cannot issue Register Fabric login\n");
+		"0249 Cannot issue Register Fabric login: Err %d\n", err);
 	return -ENXIO;
 }
 
@@ -684,6 +698,9 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 
+	vport->port_state = LPFC_FLOGI;
+	lpfc_set_disctmo(vport);
+
 	/* First look for the Fabric ndlp */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp) {
@@ -694,6 +711,12 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 	} else {
 		lpfc_dequeue_node(vport, ndlp);
+
+		/* If we go thru this path, Fabric_DID ndlp is in the process
+		 * of being removed. We need to bump the reference count by 1
+		 * so it stays around all through this link up period.
+		 */
+		lpfc_nlp_get(ndlp);
 	}
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
 		lpfc_nlp_put(ndlp);
@@ -932,6 +955,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	struct lpfc_hba  *phba = vport->phba;
 	struct serv_parm *sp;
 	IOCB_t *icmd;
+	struct lpfc_nodelist *ndlp;
 	struct lpfc_iocbq *elsiocb;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
@@ -942,8 +966,11 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
+	ndlp = lpfc_findnode_did(vport, did);
+	/* If ndlp if not NULL, we will bump the reference count on it */
+
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
-	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, NULL, did,
+	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
 				     ELS_CMD_PLOGI);
 	if (!elsiocb)
 		return 1;
@@ -1412,6 +1439,13 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];
 
+	spin_lock_irq(shost->host_lock);
+	if (ndlp->nlp_flag & NLP_LOGO_SND) {
+		spin_unlock_irq(shost->host_lock);
+		return 0;
+	}
+	spin_unlock_irq(shost->host_lock);
+
 	cmdsize = (2 * sizeof(uint32_t)) + sizeof(struct lpfc_name);
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_LOGO);
@@ -1758,6 +1792,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	uint32_t *elscmd;
 	struct ls_rjt stat;
 	int retry = 0, maxretry = lpfc_max_els_tries, delay = 0;
+	int logerr = 0;
 	uint32_t cmd = 0;
 	uint32_t did;
 
@@ -1814,6 +1849,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			break;
 
 		case IOERR_NO_RESOURCES:
+			logerr = 1; /* HBA out of resources */
 			retry = 1;
 			if (cmdiocb->retry > 100)
 				delay = 100;
@@ -1842,6 +1878,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 	case IOSTAT_NPORT_BSY:
 	case IOSTAT_FABRIC_BSY:
+		logerr = 1; /* Fabric / Remote NPort out of resources */
 		retry = 1;
 		break;
 
@@ -1922,6 +1959,15 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	if (did == FDMI_DID)
 		retry = 1;
 
+	if ((cmd == ELS_CMD_FLOGI) &&
+	    (phba->fc_topology != TOPOLOGY_LOOP)) {
+		/* FLOGI retry policy */
+		retry = 1;
+		maxretry = 48;
+		if (cmdiocb->retry >= 32)
+			delay = 1000;
+	}
+
 	if ((++cmdiocb->retry) >= maxretry) {
 		phba->fc_stat.elsRetryExceeded++;
 		retry = 0;
@@ -2005,11 +2051,20 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		}
 	}
 	/* No retry ELS command <elsCmd> to remote NPORT <did> */
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+	if (logerr) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+			 "0137 No retry ELS command x%x to remote "
+			 "NPORT x%x: Out of Resources: Error:x%x/%x\n",
+			 cmd, did, irsp->ulpStatus,
+			 irsp->un.ulpWord[4]);
+	}
+	else {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0108 No retry ELS command x%x to remote "
 			 "NPORT x%x Retried:%d Error:x%x/%x\n",
 			 cmd, did, cmdiocb->retry, irsp->ulpStatus,
 			 irsp->un.ulpWord[4]);
+	}
 	return 0;
 }
 
@@ -2089,6 +2144,12 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
 	lpfc_nlp_put(ndlp);
+
+	/* This is the end of the default RPI cleanup logic for this
+	 * ndlp. If no other discovery threads are using this ndlp.
+	 * we should free all resources associated with it.
+	 */
+	lpfc_nlp_not_used(ndlp);
 	return;
 }
 
@@ -2118,6 +2179,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
+		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
+			if (lpfc_nlp_not_used(ndlp))
+				ndlp = NULL;
 		goto out;
 	}
 
@@ -2153,15 +2217,22 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 			    != MBX_NOT_FINISHED) {
 				goto out;
 			}
-			lpfc_nlp_put(ndlp);
-			/* NOTE: we should have messages for unsuccessful
-			   reglogin */
+
+			/* ELS rsp: Cannot issue reg_login for <NPortid> */
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				"0138 ELS rsp: Cannot issue reg_login for x%x "
+				"Data: x%x x%x x%x\n",
+				ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+				ndlp->nlp_rpi);
+
+			if (lpfc_nlp_not_used(ndlp))
+				ndlp = NULL;
 		} else {
 			/* Do not drop node for lpfc_els_abort'ed ELS cmds */
 			if (!lpfc_error_lost_link(irsp) &&
 			    ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				lpfc_drop_node(vport, ndlp);
-				ndlp = NULL;
+				if (lpfc_nlp_not_used(ndlp))
+					ndlp = NULL;
 			}
 		}
 		mp = (struct lpfc_dmabuf *) mbox->context1;
@@ -2350,10 +2421,14 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	/* If the node is in the UNUSED state, and we are sending
 	 * a reject, we are done with it.  Release driver reference
 	 * count here.  The outstanding els will release its reference on
-	 * completion and the node can be freed then.
+	 * completion, as long as the ndlp stays in the UNUSED list,
+	 * and the node can be freed then.
 	 */
-	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+	if ((ndlp->nlp_state == NLP_STE_UNUSED_NODE) &&
+		!(ndlp->nlp_flag & NLP_DELAYED_RM)) {
+		ndlp->nlp_flag |= NLP_DELAYED_RM;
 		lpfc_nlp_put(ndlp);
+	}
 
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3466,8 +3541,6 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 				}
 			}
 
-			vport->port_state = LPFC_FLOGI;
-			lpfc_set_disctmo(vport);
 			lpfc_initial_flogi(vport);
 			return 0;
 		}
@@ -3747,11 +3820,11 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			goto dropit;
 
 		lpfc_nlp_init(vport, ndlp, did);
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		newnode = 1;
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK) {
 			ndlp->nlp_type |= NLP_FABRIC;
 		}
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	}
 
 	phba->fc_stat.elsRcvFrame++;
@@ -3791,8 +3864,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvFLOGI++;
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_LOGO:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3821,8 +3894,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	case ELS_CMD_RSCN:
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_ADISC:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3893,8 +3966,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvLIRR++;
 		lpfc_els_rcv_lirr(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RPS:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3903,8 +3976,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRPS++;
 		lpfc_els_rcv_rps(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RPL:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3913,8 +3986,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRPL++;
 		lpfc_els_rcv_rpl(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RNID:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3923,8 +3996,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRNID++;
 		lpfc_els_rcv_rnid(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -3938,8 +4011,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0115 Unknown ELS command x%x "
 				 "received from NPORT x%x\n", cmd, did);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
+		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+			lpfc_nlp_put(ndlp);
 		break;
 	}
 
@@ -3955,10 +4028,11 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	return;
 
 dropit:
-	lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+	if (vport && !(vport->load_flag & FC_UNLOADING))
+		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
 			"(%d):0111 Dropping received ELS cmd "
 			"Data: x%x x%x x%x\n",
-			vport ? vport->vpi : 0xffff, icmd->ulpStatus,
+			vport->vpi, icmd->ulpStatus,
 			icmd->un.ulpWord[4], icmd->ulpTimeout);
 	phba->fc_stat.elsRcvDrop++;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 10:45:18.000000000 -0400
@@ -107,7 +107,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	struct lpfc_nodelist * ndlp;
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
-	struct completion devloss_compl;
 	struct lpfc_work_evt *evtp;
 
 	rdata = rport->dd_data;
@@ -129,7 +128,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 		"rport devlosscb: sid:x%x did:x%x flg:x%x",
 		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
-	init_completion(&devloss_compl);
 	evtp = &ndlp->dev_loss_evt;
 
 	if (!list_empty(&evtp->evt_listp))
@@ -137,7 +135,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 
 	spin_lock_irq(&phba->hbalock);
 	evtp->evt_arg1  = ndlp;
-	evtp->evt_arg2  = &devloss_compl;
 	evtp->evt       = LPFC_EVT_DEV_LOSS;
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	if (phba->work_wait)
@@ -145,8 +142,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 
 	spin_unlock_irq(&phba->hbalock);
 
-	wait_for_completion(&devloss_compl);
-
 	return;
 }
 
@@ -260,7 +255,6 @@ lpfc_work_list_done(struct lpfc_hba *phb
 {
 	struct lpfc_work_evt  *evtp = NULL;
 	struct lpfc_nodelist  *ndlp;
-	struct lpfc_vport     *vport;
 	int free_evt;
 
 	spin_lock_irq(&phba->hbalock);
@@ -270,24 +264,6 @@ lpfc_work_list_done(struct lpfc_hba *phb
 		spin_unlock_irq(&phba->hbalock);
 		free_evt = 1;
 		switch (evtp->evt) {
-		case LPFC_EVT_DEV_LOSS_DELAY:
-			free_evt = 0; /* evt is part of ndlp */
-			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
-			vport = ndlp->vport;
-			if (!vport)
-				break;
-
-			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
-				"rport devlossdly:did:x%x flg:x%x",
-				ndlp->nlp_DID, ndlp->nlp_flag, 0);
-
-			if (!(vport->load_flag & FC_UNLOADING) &&
-			    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
-			    !(ndlp->nlp_flag & NLP_NPR_2B_DISC)) {
-				lpfc_disc_state_machine(vport, ndlp, NULL,
-					NLP_EVT_DEVICE_RM);
-			}
-			break;
 		case LPFC_EVT_ELS_RETRY:
 			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
 			lpfc_els_retry_delay_handler(ndlp);
@@ -298,7 +274,6 @@ lpfc_work_list_done(struct lpfc_hba *phb
 			lpfc_nlp_get(ndlp);
 			lpfc_dev_loss_tmo_handler(ndlp);
 			free_evt = 0;
-			complete((struct completion *)(evtp->evt_arg2));
 			lpfc_nlp_put(ndlp);
 			break;
 		case LPFC_EVT_ONLINE:
@@ -552,7 +527,9 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
 
-		if (phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN)
+		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
+			((vport->port_type == LPFC_NPIV_PORT) &&
+			(ndlp->nlp_DID == NameServer_DID)))
 			lpfc_unreg_rpi(vport, ndlp);
 
 		/* Leave Fabric nodes alone on link down */
@@ -570,16 +547,9 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 }
 
 static void
-lpfc_linkdown_port(struct lpfc_vport *vport)
+lpfc_port_link_failure(struct lpfc_vport *vport)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-
-	fc_host_post_event(shost, fc_get_event_number(), FCH_EVT_LINKDOWN, 0);
-
-	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-		"Link Down:       state:x%x rtry:x%x flg:x%x",
-		vport->port_state, vport->fc_ns_retry, vport->fc_flag);
 
 	/* Cleanup any outstanding RSCN activity */
 	lpfc_els_flush_rscn(vport);
@@ -598,6 +568,21 @@ lpfc_linkdown_port(struct lpfc_vport *vp
 	lpfc_can_disctmo(vport);
 }
 
+static void
+lpfc_linkdown_port(struct lpfc_vport *vport)
+{
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+
+	fc_host_post_event(shost, fc_get_event_number(), FCH_EVT_LINKDOWN, 0);
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
+		"Link Down:       state:x%x rtry:x%x flg:x%x",
+		vport->port_state, vport->fc_ns_retry, vport->fc_flag);
+
+	lpfc_port_link_failure(vport);
+
+}
+
 int
 lpfc_linkdown(struct lpfc_hba *phba)
 {
@@ -851,8 +836,6 @@ lpfc_mbx_cmpl_local_config_link(struct l
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
 	if (vport->port_state != LPFC_FLOGI) {
-		vport->port_state = LPFC_FLOGI;
-		lpfc_set_disctmo(vport);
 		lpfc_initial_flogi(vport);
 	}
 	return;
@@ -1622,6 +1605,16 @@ lpfc_nlp_set_state(struct lpfc_vport *vp
 		ndlp->nlp_type &= ~NLP_FC_NODE;
 	}
 
+	if ((old_state == NLP_STE_UNUSED_NODE) &&
+	    (state != NLP_STE_UNUSED_NODE) &&
+	    (ndlp->nlp_flag & NLP_DELAYED_RM)) {
+		/* We are using the ndlp after all, so reverse
+		 * the delayed removal of it.
+		 */
+		ndlp->nlp_flag &= ~NLP_DELAYED_RM;
+		lpfc_nlp_get(ndlp);
+	}
+
 	if (list_empty(&ndlp->nlp_listp)) {
 		spin_lock_irq(shost->host_lock);
 		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
@@ -1654,7 +1647,9 @@ void
 lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
-	lpfc_nlp_put(ndlp);
+	if (!(ndlp->nlp_flag & NLP_DELAYED_RM))
+		lpfc_nlp_put(ndlp);
+	return;
 }
 
 /*
@@ -1975,11 +1970,6 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	if (!list_empty(&ndlp->dev_loss_evt.evt_listp))
 		list_del_init(&ndlp->dev_loss_evt.evt_listp);
 
-	if (!list_empty(&ndlp->dev_loss_evt.evt_listp)) {
-		list_del_init(&ndlp->dev_loss_evt.evt_listp);
-		complete((struct completion *)(ndlp->dev_loss_evt.evt_arg2));
-	}
-
 	lpfc_unreg_rpi(vport, ndlp);
 
 	return 0;
@@ -2418,7 +2408,6 @@ lpfc_disc_flush_list(struct lpfc_vport *
 			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
 			    ndlp->nlp_state == NLP_STE_ADISC_ISSUE) {
 				lpfc_free_tx(phba, ndlp);
-				lpfc_nlp_put(ndlp);
 			}
 		}
 	}
@@ -2516,8 +2505,6 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 			}
 		}
 		if (vport->port_state != LPFC_FLOGI) {
-			vport->port_state = LPFC_FLOGI;
-			lpfc_set_disctmo(vport);
 			lpfc_initial_flogi(vport);
 		}
 		break;
@@ -2828,6 +2815,9 @@ lpfc_nlp_init(struct lpfc_vport *vport, 
 	return;
 }
 
+/* This routine releases all resources associated with a specifc NPort's ndlp
+ * and mempool_free's the nodelist.
+ */
 static void
 lpfc_nlp_release(struct kref *kref)
 {
@@ -2842,16 +2832,57 @@ lpfc_nlp_release(struct kref *kref)
 	mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
 }
 
+/* This routine bumps the reference count for a ndlp structure to ensure
+ * that one discovery thread won't free a ndlp while another discovery thread
+ * is using it.
+ */
 struct lpfc_nodelist *
 lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 {
-	if (ndlp)
+	if (ndlp) {
+		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
+			"node get:        did:x%x flg:x%x refcnt:x%x",
+			ndlp->nlp_DID, ndlp->nlp_flag,
+			atomic_read(&ndlp->kref.refcount));
 		kref_get(&ndlp->kref);
+	}
 	return ndlp;
 }
 
+
+/* This routine decrements the reference count for a ndlp structure. If the
+ * count goes to 0, this indicates the the associated nodelist should be freed.
+ */
 int
 lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 {
+	if (ndlp) {
+		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
+		"node put:        did:x%x flg:x%x refcnt:x%x",
+			ndlp->nlp_DID, ndlp->nlp_flag,
+			atomic_read(&ndlp->kref.refcount));
+	}
 	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
 }
+
+/* This routine free's the specified nodelist if it is not in use
+ * by any other discovery thread. This routine returns 1 if the ndlp
+ * is not being used by anyone and has been freed. A return value of
+ * 0 indicates it is being used by another discovery thread and the
+ * refcount is left unchanged.
+ */
+int
+lpfc_nlp_not_used(struct lpfc_nodelist *ndlp)
+{
+	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
+		"node not used:   did:x%x flg:x%x refcnt:x%x",
+		ndlp->nlp_DID, ndlp->nlp_flag,
+		atomic_read(&ndlp->kref.refcount));
+
+	if (atomic_read(&ndlp->kref.refcount) == 1) {
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
+	return 0;
+}
+
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:45:06.000000000 -0400
@@ -1143,9 +1143,8 @@ lpfc_post_buffer(struct lpfc_hba *phba, 
 		/* Allocate buffer to post */
 		mp1 = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
 		if (mp1)
-		    mp1->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
-						&mp1->phys);
-		if (mp1 == 0 || mp1->virt == 0) {
+		    mp1->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &mp1->phys);
+		if (!mp1 || !mp1->virt) {
 			kfree(mp1);
 			lpfc_sli_release_iocbq(phba, iocb);
 			pring->missbufcnt = cnt;
@@ -1159,7 +1158,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, 
 			if (mp2)
 				mp2->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 							    &mp2->phys);
-			if (mp2 == 0 || mp2->virt == 0) {
+			if (!mp2 || !mp2->virt) {
 				kfree(mp2);
 				lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
 				kfree(mp1);
@@ -1762,7 +1761,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	struct Scsi_Host  *shost = NULL;
 	void *ptr;
 	unsigned long bar0map_len, bar2map_len;
-	int error = -ENODEV;
+	int error = -ENODEV, retval;
 	int  i, hbq_count;
 	uint16_t iotag;
 
@@ -1878,9 +1877,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	lpfc_sli_setup(phba);
 	lpfc_sli_queue_setup(phba);
 
-	error = lpfc_mem_alloc(phba);
-	if (error)
+	retval = lpfc_mem_alloc(phba);
+	if (retval) {
+		error = retval;
 		goto out_free_hbqslimp;
+	}
 
 	/* Initialize and populate the iocb list per host.  */
 	INIT_LIST_HEAD(&phba->lpfc_iocb_list);
@@ -1946,8 +1947,8 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, shost);
 
 	if (phba->cfg_use_msi) {
-		error = pci_enable_msi(phba->pcidev);
-		if (!error)
+		retval = pci_enable_msi(phba->pcidev);
+		if (!retval)
 			phba->using_msi = 1;
 		else
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -1955,11 +1956,12 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 					"with IRQ\n");
 	}
 
-	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
+	retval = request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
 			    LPFC_DRIVER_NAME, phba);
-	if (error) {
+	if (retval) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0451 Enable interrupt handler failed\n");
+		error = retval;
 		goto out_disable_msi;
 	}
 
@@ -1969,11 +1971,15 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
 	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
 
-	if (lpfc_alloc_sysfs_attr(vport))
+	if (lpfc_alloc_sysfs_attr(vport)) {
+		error = -ENOMEM;
 		goto out_free_irq;
+	}
 
-	if (lpfc_sli_hba_setup(phba))
+	if (lpfc_sli_hba_setup(phba)) {
+		error = -ENODEV;
 		goto out_remove_device;
+	}
 
 	/*
 	 * hba setup may have changed the hba_queue_depth so we need to adjust
@@ -2303,14 +2309,12 @@ lpfc_init(void)
 	if (lpfc_transport_template == NULL)
 		return -ENOMEM;
 	if (lpfc_enable_npiv) {
-		lpfc_transport_functions.vport_create = NULL;
-		lpfc_transport_functions.vport_delete = NULL;
-		lpfc_transport_functions.issue_fc_host_lip = NULL;
-		lpfc_transport_functions.vport_disable = lpfc_vport_disable;
 		lpfc_vport_transport_template =
-				fc_attach_transport(&lpfc_transport_functions);
-		if (lpfc_vport_transport_template == NULL)
+			fc_attach_transport(&lpfc_vport_transport_functions);
+		if (lpfc_vport_transport_template == NULL) {
+			fc_release_transport(lpfc_transport_template);
 			return -ENOMEM;
+		}
 	}
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-10-27 10:45:06.000000000 -0400
@@ -288,8 +288,10 @@ lpfc_read_sparam(struct lpfc_hba *phba, 
 
 	/* Get a buffer to hold the HBAs Service Parameters */
 
-	if (((mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL)) == 0) ||
-	    ((mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys))) == 0)) {
+	mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
+	if (mp)
+		mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+	if (!mp || !mp->virt) {
 		kfree(mp);
 		mb->mbxCommand = MBX_READ_SPARM64;
 		/* READ_SPARAM: no buffers */
@@ -387,8 +389,10 @@ lpfc_reg_login(struct lpfc_hba *phba, ui
 	mb->mbxOwner = OWN_HOST;
 
 	/* Get a buffer to hold NPorts Service Parameters */
-	if (((mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL)) == NULL) ||
-	    ((mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys))) == 0)) {
+	mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
+	if (mp)
+		mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+	if (!mp || !mp->virt) {
 		kfree(mp);
 		mb->mbxCommand = MBX_REG_LOGIN64;
 		/* REG_LOGIN: no buffers */
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 10:45:06.000000000 -0400
@@ -1135,7 +1135,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
 			mp = (struct lpfc_dmabuf *) (mb->context1);
 			if (mp) {
-				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
 				kfree(mp);
 			}
 			lpfc_nlp_put(ndlp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:45:06.000000000 -0400
@@ -1914,8 +1914,8 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 			"0329 Kill HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
-	if ((pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
-						  GFP_KERNEL)) == 0)
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb)
 		return 1;
 
 	/* Disable the error attention */
@@ -2809,7 +2809,7 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba
 /*
  * Lockless version of lpfc_sli_issue_iocb.
  */
-int
+static int
 __lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
@@ -2954,7 +2954,7 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 	return 0;
 }
 
-void
+static void
 lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 	struct lpfc_sli_ring * pring, struct lpfc_iocbq * iocbq)
 {
@@ -3717,7 +3717,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	unsigned long flag;
 
 	/* The caller must leave context1 empty. */
-	if (pmboxq->context1 != 0)
+	if (pmboxq->context1)
 		return MBX_NOT_FINISHED;
 
 	/* setup wake call as IOCB callback */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-10-27 10:38:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-10-27 10:45:06.000000000 -0400
@@ -197,9 +197,6 @@ struct lpfc_hbq_init {
 	uint32_t add_count;	/* number to allocate when starved */
 } ;
 
-#define LPFC_MAX_HBQ 16
-
-
 /* Structure used to hold SLI statistical counters and info */
 struct lpfc_sli_stat {
 	uint64_t mbox_stat_err;  /* Mbox cmds completed status error */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-10-27 10:37:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-10-27 10:45:18.000000000 -0400
@@ -125,15 +125,26 @@ lpfc_vport_sparm(struct lpfc_hba *phba, 
 	pmb->vport = vport;
 	rc = lpfc_sli_issue_mbox_wait(phba, pmb, phba->fc_ratov * 2);
 	if (rc != MBX_SUCCESS) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT | LOG_VPORT,
-				 "1818 VPort failed init, mbxCmd x%x "
-				 "READ_SPARM mbxStatus x%x, rc = x%x\n",
-				 mb->mbxCommand, mb->mbxStatus, rc);
-		lpfc_mbuf_free(phba, mp->virt, mp->phys);
-		kfree(mp);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(pmb, phba->mbox_mem_pool);
-		return -EIO;
+		if (signal_pending(current)) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT | LOG_VPORT,
+					 "1830 Signal aborted mbxCmd x%x\n",
+					 mb->mbxCommand);
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmb, phba->mbox_mem_pool);
+			return -EINTR;
+		} else {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT | LOG_VPORT,
+					 "1818 VPort failed init, mbxCmd x%x "
+					 "READ_SPARM mbxStatus x%x, rc = x%x\n",
+					 mb->mbxCommand, mb->mbxStatus, rc);
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmb, phba->mbox_mem_pool);
+			return -EIO;
+		}
 	}
 
 	memcpy(&vport->fc_sparam, mp->virt, sizeof (struct serv_parm));
@@ -204,6 +215,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	int instance;
 	int vpi;
 	int rc = VPORT_ERROR;
+	int status;
 
 	if ((phba->sli_rev < 3) ||
 		!(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)) {
@@ -248,13 +260,19 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	vport->vpi = vpi;
 	lpfc_debugfs_initialize(vport);
 
-	if (lpfc_vport_sparm(phba, vport)) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
-				 "1813 Create VPORT failed. "
-				 "Cannot get sparam\n");
+	if ((status = lpfc_vport_sparm(phba, vport))) {
+		if (status == -EINTR) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+					 "1831 Create VPORT Interrupted.\n");
+			rc = VPORT_ERROR;
+		} else {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+					 "1813 Create VPORT failed. "
+					 "Cannot get sparam\n");
+			rc = VPORT_NORESOURCES;
+		}
 		lpfc_free_vpi(phba, vpi);
 		destroy_port(vport);
-		rc = VPORT_NORESOURCES;
 		goto error_out;
 	}
 


