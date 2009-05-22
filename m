From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 13/17] lpfc 8.3.2 : Addition of SLI4 Interface - FCOE
	Discovery support
Date: Fri, 22 May 2009 14:52:59 -0400
Message-ID: <1243018379.7729.63.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42204 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbZEVSxB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:53:01 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIr3gr029926
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:53:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - FCOE Discovery support

SLI4 supports both FC and FCOE, with some extended topology objects.
This patch adss support for the objects, and updates the disovery
engines for their use.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c      |   32 -
 lpfc_crtn.h      |    3 
 lpfc_els.c       |  179 ++++++++-
 lpfc_hbadisc.c   | 1055 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_nportdisc.c |   34 +
 lpfc_sli.c       |  517 ++++++++++++++++++++++++++
 6 files changed, 1756 insertions(+), 64 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 13:18:52.000000000 -0400
@@ -2924,6 +2924,14 @@ LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 
 */
 LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
 
+/*
+# lpfc_enable_fip: When set, FIP is required to start discovery. If not
+# set, the driver will add an FCF record manually if the port has no
+# FCF records available and start discovery.
+# Value range is [0,1]. Default value is 1 (enabled)
+*/
+LPFC_ATTR_RW(enable_fip, 0, 0, 1, "Enable FIP Discovery");
+
 
 /*
 # lpfc_prot_mask: i
@@ -2990,6 +2998,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fip,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
 	&dev_attr_lpfc_ack0,
@@ -3042,6 +3051,7 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_lun_queue_depth,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fip,
 	&dev_attr_lpfc_hba_queue_depth,
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_restrict_login,
@@ -4167,26 +4177,10 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_prot_sg_seg_cnt_init(phba, lpfc_prot_sg_seg_cnt);
-	/*
-	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
-	 * used to create the sg_dma_buf_pool must be dynamically calculated.
-	 * 2 segments are added since the IOCB needs a command and response bde.
-	 */
-	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
-			sizeof(struct fcp_rsp) +
-			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct ulp_bde64));
-
-	if (phba->cfg_enable_bg) {
-		phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SEG_CNT;
-		phba->cfg_sg_dma_buf_size +=
-			phba->cfg_prot_sg_seg_cnt * sizeof(struct ulp_bde64);
-	}
-
-	/* Also reinitialize the host templates with new values. */
-	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
+	lpfc_enable_fip_init(phba, lpfc_enable_fip);
+	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
+
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-05-22 13:18:52.000000000 -0400
@@ -23,6 +23,8 @@ typedef int (*node_filter)(struct lpfc_n
 struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 void lpfc_dump_wakeup_param(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_dump_static_vport(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
+int lpfc_dump_fcoe_param(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
@@ -108,6 +110,7 @@ int lpfc_issue_els_adisc(struct lpfc_vpo
 int lpfc_issue_els_logo(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_npiv_logo(struct lpfc_vport *, struct lpfc_nodelist *);
 int lpfc_issue_els_scr(struct lpfc_vport *, uint32_t, uint8_t);
+int lpfc_issue_fabric_reglogin(struct lpfc_vport *);
 int lpfc_els_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
 int lpfc_ct_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
 int lpfc_els_rsp_acc(struct lpfc_vport *, uint32_t, struct lpfc_iocbq *,
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:18:52.000000000 -0400
@@ -388,6 +388,75 @@ fail:
 }
 
 /**
+ * lpfc_issue_reg_vfi - Register VFI for this vport's fabric login
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This routine issues a REG_VFI mailbox for the vfi, vpi, fcfi triplet for
+ * the @vport. This mailbox command is necessary for FCoE only.
+ *
+ * Return code
+ *   0 - successfully issued REG_VFI for @vport
+ *   A failure code otherwise.
+ **/
+static int
+lpfc_issue_reg_vfi(struct lpfc_vport *vport)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_nodelist *ndlp;
+	struct serv_parm *sp;
+	struct lpfc_dmabuf *dmabuf;
+	int rc = 0;
+
+	sp = &phba->fc_fabparam;
+	ndlp = lpfc_findnode_did(vport, Fabric_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		rc = -ENODEV;
+		goto fail;
+	}
+
+	dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!dmabuf) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+	dmabuf->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &dmabuf->phys);
+	if (!dmabuf->virt) {
+		rc = -ENOMEM;
+		goto fail_free_dmabuf;
+	}
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		rc = -ENOMEM;
+		goto fail_free_coherent;
+	}
+	vport->port_state = LPFC_FABRIC_CFG_LINK;
+	memcpy(dmabuf->virt, &phba->fc_fabparam, sizeof(vport->fc_sparam));
+	lpfc_reg_vfi(mboxq, vport, dmabuf->phys);
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_reg_vfi;
+	mboxq->vport = vport;
+	mboxq->context1 = dmabuf;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		rc = -ENXIO;
+		goto fail_free_mbox;
+	}
+	return 0;
+
+fail_free_mbox:
+	mempool_free(mboxq, phba->mbox_mem_pool);
+fail_free_coherent:
+	lpfc_mbuf_free(phba, dmabuf->virt, dmabuf->phys);
+fail_free_dmabuf:
+	kfree(dmabuf);
+fail:
+	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+		"0289 Issue Register VFI failed: Err %d\n", rc);
+	return rc;
+}
+
+/**
  * lpfc_cmpl_els_flogi_fabric - Completion function for flogi to a fabric port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -499,17 +568,24 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		}
 	}
 
-	lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
-
-	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED &&
-	    vport->fc_flag & FC_VPORT_NEEDS_REG_VPI) {
-		lpfc_register_new_vport(phba, vport, ndlp);
-		return 0;
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
+		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED &&
+		    vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
+			lpfc_register_new_vport(phba, vport, ndlp);
+		else
+			lpfc_issue_fabric_reglogin(vport);
+	} else {
+		ndlp->nlp_type |= NLP_FABRIC;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+		if (vport->vfi_state & LPFC_VFI_REGISTERED) {
+			lpfc_start_fdiscs(phba);
+			lpfc_do_scr_ns_plogi(phba, vport);
+		} else
+			lpfc_issue_reg_vfi(vport);
 	}
-	lpfc_issue_fabric_reglogin(vport);
 	return 0;
 }
-
 /**
  * lpfc_cmpl_els_flogi_nport - Completion function for flogi to an N_Port
  * @vport: pointer to a host virtual N_Port data structure.
@@ -817,9 +893,14 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
-	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
+	if  (phba->sli_rev == LPFC_SLI_REV4) {
+		elsiocb->iocb.ulpCt_h = ((SLI4_CT_FCFI >> 1) & 1);
+		elsiocb->iocb.ulpCt_l = (SLI4_CT_FCFI & 1);
+		/* FLOGI needs to be 3 for WQE FCFI */
+		/* Set the fcfi to the fcfi we registered with */
+		elsiocb->iocb.ulpContext = phba->fcf.fcfi;
+	} else if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 		sp->cmn.request_multiple_Nport = 1;
-
 		/* For FLOGI, Let FLOGI rsp set the NPortID for VPI 0 */
 		icmd->ulpCt_h = 1;
 		icmd->ulpCt_l = 0;
@@ -932,6 +1013,8 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 		if (!ndlp)
 			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
+		/* Set the node type */
+		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
@@ -1604,7 +1687,8 @@ lpfc_adisc_done(struct lpfc_vport *vport
 	 * and continue discovery.
 	 */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
-	    !(vport->fc_flag & FC_RSCN_MODE)) {
+	    !(vport->fc_flag & FC_RSCN_MODE) &&
+	    (phba->sli_rev < LPFC_SLI_REV4)) {
 		lpfc_issue_reg_vpi(phba, vport);
 		return;
 	}
@@ -2937,6 +3021,14 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 
+	/*
+	 * This routine is used to register and unregister in previous SLI
+	 * modes.
+	 */
+	if ((pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) &&
+	    (phba->sli_rev == LPFC_SLI_REV4))
+		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
+
 	pmb->context1 = NULL;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
@@ -3816,7 +3908,9 @@ lpfc_rscn_payload_check(struct lpfc_vpor
 			payload_len -= sizeof(uint32_t);
 			switch (rscn_did.un.b.resv & RSCN_ADDRESS_FORMAT_MASK) {
 			case RSCN_ADDRESS_FORMAT_PORT:
-				if (ns_did.un.word == rscn_did.un.word)
+				if ((ns_did.un.b.domain == rscn_did.un.b.domain)
+				    && (ns_did.un.b.area == rscn_did.un.b.area)
+				    && (ns_did.un.b.id == rscn_did.un.b.id))
 					goto return_did_out;
 				break;
 			case RSCN_ADDRESS_FORMAT_AREA:
@@ -4857,7 +4951,10 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 		} else {
 			/* FAN verified - skip FLOGI */
 			vport->fc_myDID = vport->fc_prevDID;
-			lpfc_issue_fabric_reglogin(vport);
+			if (phba->sli_rev < LPFC_SLI_REV4)
+				lpfc_issue_fabric_reglogin(vport);
+			else
+				lpfc_issue_reg_vfi(vport);
 		}
 	}
 	return 0;
@@ -5540,11 +5637,10 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 dropit:
 	if (vport && !(vport->load_flag & FC_UNLOADING))
-		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
-			"(%d):0111 Dropping received ELS cmd "
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+			"0111 Dropping received ELS cmd "
 			"Data: x%x x%x x%x\n",
-			vport->vpi, icmd->ulpStatus,
-			icmd->un.ulpWord[4], icmd->ulpTimeout);
+			icmd->ulpStatus, icmd->un.ulpWord[4], icmd->ulpTimeout);
 	phba->fc_stat.elsRcvDrop++;
 }
 
@@ -5620,10 +5716,9 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 	     icmd->ulpCommand == CMD_IOCB_RCV_SEQ64_CX)) {
 		if (icmd->unsli3.rcvsli3.vpi == 0xffff)
 			vport = phba->pport;
-		else {
-			uint16_t vpi = icmd->unsli3.rcvsli3.vpi;
-			vport = lpfc_find_vport_by_vpid(phba, vpi);
-		}
+		else
+			vport = lpfc_find_vport_by_vpid(phba,
+				icmd->unsli3.rcvsli3.vpi - phba->vpi_base);
 	}
 	/* If there are no BDEs associated
 	 * with this IOCB, there is nothing to do.
@@ -5792,7 +5887,10 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 
 	} else {
 		if (vport == phba->pport)
-			lpfc_issue_fabric_reglogin(vport);
+			if (phba->sli_rev < LPFC_SLI_REV4)
+				lpfc_issue_fabric_reglogin(vport);
+			else
+				lpfc_issue_reg_vfi(vport);
 		else
 			lpfc_do_scr_ns_plogi(phba, vport);
 	}
@@ -5824,7 +5922,7 @@ lpfc_register_new_vport(struct lpfc_hba 
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
-		lpfc_reg_vpi(phba, vport->vpi, vport->fc_myDID, mbox);
+		lpfc_reg_vpi(vport, mbox);
 		mbox->vport = vport;
 		mbox->context2 = lpfc_nlp_get(ndlp);
 		mbox->mbox_cmpl = lpfc_cmpl_reg_new_vport;
@@ -6496,3 +6594,38 @@ void lpfc_fabric_abort_hba(struct lpfc_h
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
 }
+
+/**
+ * lpfc_sli4_els_xri_aborted - Slow-path process of els xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the els xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 slow-path
+ * ELS aborted xri.
+ **/
+void
+lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
+			  struct sli4_wcqe_xri_aborted *axri)
+{
+	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
+	unsigned long iflag = 0;
+
+	spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock, iflag);
+	list_for_each_entry_safe(sglq_entry, sglq_next,
+			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
+		if (sglq_entry->sli4_xritag == xri) {
+			list_del(&sglq_entry->list);
+			spin_unlock_irqrestore(
+					&phba->sli4_hba.abts_sgl_list_lock,
+					 iflag);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+
+			list_add_tail(&sglq_entry->list,
+				&phba->sli4_hba.lpfc_sgl_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&phba->sli4_hba.abts_sgl_list_lock, iflag);
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:18:52.000000000 -0400
@@ -275,6 +275,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
+
+	lpfc_unregister_unused_fcf(phba);
 }
 
 /**
@@ -297,10 +299,11 @@ lpfc_alloc_fast_evt(struct lpfc_hba *phb
 
 	ret = kzalloc(sizeof(struct lpfc_fast_path_event),
 			GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		atomic_inc(&phba->fast_event_count);
-	INIT_LIST_HEAD(&ret->work_evt.evt_listp);
-	ret->work_evt.evt = LPFC_EVT_FASTPATH_MGMT_EVT;
+		INIT_LIST_HEAD(&ret->work_evt.evt_listp);
+		ret->work_evt.evt = LPFC_EVT_FASTPATH_MGMT_EVT;
+	}
 	return ret;
 }
 
@@ -741,6 +744,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	if (phba->link_state == LPFC_LINK_DOWN)
 		return 0;
 	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_DISCOVERED);
 	if (phba->link_state > LPFC_LINK_DOWN) {
 		phba->link_state = LPFC_LINK_DOWN;
 		phba->pport->fc_flag &= ~FC_LBIT;
@@ -748,7 +752,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			/* Issue a LINK DOWN event to all nodes */
 			lpfc_linkdown_port(vports[i]);
 		}
@@ -858,10 +862,11 @@ lpfc_linkup(struct lpfc_hba *phba)
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 			lpfc_linkup_port(vports[i]);
 	lpfc_destroy_vport_work_array(phba, vports);
-	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
+	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
+	    (phba->sli_rev < LPFC_SLI_REV4))
 		lpfc_issue_clear_la(phba, phba->pport);
 
 	return 0;
@@ -984,9 +989,592 @@ out:
 }
 
 static void
+lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_vport *vport = mboxq->vport;
+	unsigned long flags;
+
+	if (mboxq->u.mb.mbxStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
+			 "2017 REG_FCFI mbxStatus error x%x "
+			 "HBA state x%x\n",
+			 mboxq->u.mb.mbxStatus, vport->port_state);
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return;
+	}
+
+	/* Start FCoE discovery by sending a FLOGI. */
+	phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi, &mboxq->u.mqe.un.reg_fcfi);
+	/* Set the FCFI registered flag */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	phba->fcf.fcf_flag |= FCF_REGISTERED;
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+	if (vport->port_state != LPFC_FLOGI) {
+		spin_lock_irqsave(&phba->hbalock, flags);
+		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		lpfc_initial_flogi(vport);
+	}
+
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return;
+}
+
+/**
+ * lpfc_fab_name_match - Check if the fcf fabric name match.
+ * @fab_name: pointer to fabric name.
+ * @new_fcf_record: pointer to fcf record.
+ *
+ * This routine compare the fcf record's fabric name with provided
+ * fabric name. If the fabric name are identical this function
+ * returns 1 else return 0.
+ **/
+static uint32_t
+lpfc_fab_name_match(uint8_t *fab_name, struct fcf_record *new_fcf_record)
+{
+	if ((fab_name[0] ==
+		bf_get(lpfc_fcf_record_fab_name_0, new_fcf_record)) &&
+	    (fab_name[1] ==
+		bf_get(lpfc_fcf_record_fab_name_1, new_fcf_record)) &&
+	    (fab_name[2] ==
+		bf_get(lpfc_fcf_record_fab_name_2, new_fcf_record)) &&
+	    (fab_name[3] ==
+		bf_get(lpfc_fcf_record_fab_name_3, new_fcf_record)) &&
+	    (fab_name[4] ==
+		bf_get(lpfc_fcf_record_fab_name_4, new_fcf_record)) &&
+	    (fab_name[5] ==
+		bf_get(lpfc_fcf_record_fab_name_5, new_fcf_record)) &&
+	    (fab_name[6] ==
+		bf_get(lpfc_fcf_record_fab_name_6, new_fcf_record)) &&
+	    (fab_name[7] ==
+		bf_get(lpfc_fcf_record_fab_name_7, new_fcf_record)))
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * lpfc_mac_addr_match - Check if the fcf mac address match.
+ * @phba: pointer to lpfc hba data structure.
+ * @new_fcf_record: pointer to fcf record.
+ *
+ * This routine compare the fcf record's mac address with HBA's
+ * FCF mac address. If the mac addresses are identical this function
+ * returns 1 else return 0.
+ **/
+static uint32_t
+lpfc_mac_addr_match(struct lpfc_hba *phba, struct fcf_record *new_fcf_record)
+{
+	if ((phba->fcf.mac_addr[0] ==
+		bf_get(lpfc_fcf_record_mac_0, new_fcf_record)) &&
+	    (phba->fcf.mac_addr[1] ==
+		bf_get(lpfc_fcf_record_mac_1, new_fcf_record)) &&
+	    (phba->fcf.mac_addr[2] ==
+		bf_get(lpfc_fcf_record_mac_2, new_fcf_record)) &&
+	    (phba->fcf.mac_addr[3] ==
+		bf_get(lpfc_fcf_record_mac_3, new_fcf_record)) &&
+	    (phba->fcf.mac_addr[4] ==
+		bf_get(lpfc_fcf_record_mac_4, new_fcf_record)) &&
+	    (phba->fcf.mac_addr[5] ==
+		bf_get(lpfc_fcf_record_mac_5, new_fcf_record)))
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * lpfc_copy_fcf_record - Copy fcf information to lpfc_hba.
+ * @phba: pointer to lpfc hba data structure.
+ * @new_fcf_record: pointer to fcf record.
+ *
+ * This routine copies the FCF information from the FCF
+ * record to lpfc_hba data structure.
+ **/
+static void
+lpfc_copy_fcf_record(struct lpfc_hba *phba, struct fcf_record *new_fcf_record)
+{
+	phba->fcf.fabric_name[0] =
+		bf_get(lpfc_fcf_record_fab_name_0, new_fcf_record);
+	phba->fcf.fabric_name[1] =
+		bf_get(lpfc_fcf_record_fab_name_1, new_fcf_record);
+	phba->fcf.fabric_name[2] =
+		bf_get(lpfc_fcf_record_fab_name_2, new_fcf_record);
+	phba->fcf.fabric_name[3] =
+		bf_get(lpfc_fcf_record_fab_name_3, new_fcf_record);
+	phba->fcf.fabric_name[4] =
+		bf_get(lpfc_fcf_record_fab_name_4, new_fcf_record);
+	phba->fcf.fabric_name[5] =
+		bf_get(lpfc_fcf_record_fab_name_5, new_fcf_record);
+	phba->fcf.fabric_name[6] =
+		bf_get(lpfc_fcf_record_fab_name_6, new_fcf_record);
+	phba->fcf.fabric_name[7] =
+		bf_get(lpfc_fcf_record_fab_name_7, new_fcf_record);
+	phba->fcf.mac_addr[0] =
+		bf_get(lpfc_fcf_record_mac_0, new_fcf_record);
+	phba->fcf.mac_addr[1] =
+		bf_get(lpfc_fcf_record_mac_1, new_fcf_record);
+	phba->fcf.mac_addr[2] =
+		bf_get(lpfc_fcf_record_mac_2, new_fcf_record);
+	phba->fcf.mac_addr[3] =
+		bf_get(lpfc_fcf_record_mac_3, new_fcf_record);
+	phba->fcf.mac_addr[4] =
+		bf_get(lpfc_fcf_record_mac_4, new_fcf_record);
+	phba->fcf.mac_addr[5] =
+		bf_get(lpfc_fcf_record_mac_5, new_fcf_record);
+	phba->fcf.fcf_indx = bf_get(lpfc_fcf_record_fcf_index, new_fcf_record);
+	phba->fcf.priority = new_fcf_record->fip_priority;
+}
+
+/**
+ * lpfc_register_fcf - Register the FCF with hba.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine issues a register fcfi mailbox command to register
+ * the fcf with HBA.
+ **/
+static void
+lpfc_register_fcf(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *fcf_mbxq;
+	int rc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&phba->hbalock, flags);
+
+	/* If the FCF is not availabe do nothing. */
+	if (!(phba->fcf.fcf_flag & FCF_AVAILABLE)) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return;
+	}
+
+	/* The FCF is already registered, start discovery */
+	if (phba->fcf.fcf_flag & FCF_REGISTERED) {
+		phba->fcf.fcf_flag |= (FCF_DISCOVERED | FCF_IN_USE);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		if (phba->pport->port_state != LPFC_FLOGI)
+			lpfc_initial_flogi(phba->pport);
+		return;
+	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	fcf_mbxq = mempool_alloc(phba->mbox_mem_pool,
+		GFP_KERNEL);
+	if (!fcf_mbxq)
+		return;
+
+	lpfc_reg_fcfi(phba, fcf_mbxq);
+	fcf_mbxq->vport = phba->pport;
+	fcf_mbxq->mbox_cmpl = lpfc_mbx_cmpl_reg_fcfi;
+	rc = lpfc_sli_issue_mbox(phba, fcf_mbxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED)
+		mempool_free(fcf_mbxq, phba->mbox_mem_pool);
+
+	return;
+}
+
+/**
+ * lpfc_match_fcf_conn_list - Check if the FCF record can be used for discovery.
+ * @phba: pointer to lpfc hba data structure.
+ * @new_fcf_record: pointer to fcf record.
+ * @boot_flag: Indicates if this record used by boot bios.
+ * @addr_mode: The address mode to be used by this FCF
+ *
+ * This routine compare the fcf record with connect list obtained from the
+ * config region to decide if this FCF can be used for SAN discovery. It returns
+ * 1 if this record can be used for SAN discovery else return zero. If this FCF
+ * record can be used for SAN discovery, the boot_flag will indicate if this FCF
+ * is used by boot bios and addr_mode will indicate the addressing mode to be
+ * used for this FCF when the function returns.
+ * If the FCF record need to be used with a particular vlan id, the vlan is
+ * set in the vlan_id on return of the function. If not VLAN tagging need to
+ * be used with the FCF vlan_id will be set to 0xFFFF;
+ **/
+static int
+lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
+			struct fcf_record *new_fcf_record,
+			uint32_t *boot_flag, uint32_t *addr_mode,
+			uint16_t *vlan_id)
+{
+	struct lpfc_fcf_conn_entry *conn_entry;
+
+	if (!phba->cfg_enable_fip) {
+		*boot_flag = 0;
+		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
+				new_fcf_record);
+		if (phba->valid_vlan)
+			*vlan_id = phba->vlan_id;
+		else
+			*vlan_id = 0xFFFF;
+		return 1;
+	}
+
+	/*
+	 * If there are no FCF connection table entry, driver connect to all
+	 * FCFs.
+	 */
+	if (list_empty(&phba->fcf_conn_rec_list)) {
+		*boot_flag = 0;
+		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
+			new_fcf_record);
+		*vlan_id = 0xFFFF;
+		return 1;
+	}
+
+	list_for_each_entry(conn_entry, &phba->fcf_conn_rec_list, list) {
+		if (!(conn_entry->conn_rec.flags & FCFCNCT_VALID))
+			continue;
+
+		if ((conn_entry->conn_rec.flags & FCFCNCT_FBNM_VALID) &&
+			!lpfc_fab_name_match(conn_entry->conn_rec.fabric_name,
+				new_fcf_record))
+			continue;
+
+		if (conn_entry->conn_rec.flags & FCFCNCT_VLAN_VALID) {
+			/*
+			 * If the vlan bit map does not have the bit set for the
+			 * vlan id to be used, then it is not a match.
+			 */
+			if (!(new_fcf_record->vlan_bitmap
+				[conn_entry->conn_rec.vlan_tag / 8] &
+				(1 << (conn_entry->conn_rec.vlan_tag % 8))))
+				continue;
+		}
+
+		/*
+		 * Check if the connection record specifies a required
+		 * addressing mode.
+		 */
+		if ((conn_entry->conn_rec.flags & FCFCNCT_AM_VALID) &&
+			!(conn_entry->conn_rec.flags & FCFCNCT_AM_PREFERRED)) {
+
+			/*
+			 * If SPMA required but FCF not support this continue.
+			 */
+			if ((conn_entry->conn_rec.flags & FCFCNCT_AM_SPMA) &&
+				!(bf_get(lpfc_fcf_record_mac_addr_prov,
+					new_fcf_record) & LPFC_FCF_SPMA))
+				continue;
+
+			/*
+			 * If FPMA required but FCF not support this continue.
+			 */
+			if (!(conn_entry->conn_rec.flags & FCFCNCT_AM_SPMA) &&
+				!(bf_get(lpfc_fcf_record_mac_addr_prov,
+				new_fcf_record) & LPFC_FCF_FPMA))
+				continue;
+		}
+
+		/*
+		 * This fcf record matches filtering criteria.
+		 */
+		if (conn_entry->conn_rec.flags & FCFCNCT_BOOT)
+			*boot_flag = 1;
+		else
+			*boot_flag = 0;
+
+		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
+				new_fcf_record);
+		/*
+		 * If the user specified a required address mode, assign that
+		 * address mode
+		 */
+		if ((conn_entry->conn_rec.flags & FCFCNCT_AM_VALID) &&
+			(!(conn_entry->conn_rec.flags & FCFCNCT_AM_PREFERRED)))
+			*addr_mode = (conn_entry->conn_rec.flags &
+				FCFCNCT_AM_SPMA) ?
+				LPFC_FCF_SPMA : LPFC_FCF_FPMA;
+		/*
+		 * If the user specified a prefered address mode, use the
+		 * addr mode only if FCF support the addr_mode.
+		 */
+		else if ((conn_entry->conn_rec.flags & FCFCNCT_AM_VALID) &&
+			(conn_entry->conn_rec.flags & FCFCNCT_AM_PREFERRED) &&
+			(conn_entry->conn_rec.flags & FCFCNCT_AM_SPMA) &&
+			(*addr_mode & LPFC_FCF_SPMA))
+				*addr_mode = LPFC_FCF_SPMA;
+		else if ((conn_entry->conn_rec.flags & FCFCNCT_AM_VALID) &&
+			(conn_entry->conn_rec.flags & FCFCNCT_AM_PREFERRED) &&
+			!(conn_entry->conn_rec.flags & FCFCNCT_AM_SPMA) &&
+			(*addr_mode & LPFC_FCF_FPMA))
+				*addr_mode = LPFC_FCF_FPMA;
+		/*
+		 * If user did not specify any addressing mode, use FPMA if
+		 * possible else use SPMA.
+		 */
+		else if (*addr_mode & LPFC_FCF_FPMA)
+			*addr_mode = LPFC_FCF_FPMA;
+
+		if (conn_entry->conn_rec.flags & FCFCNCT_VLAN_VALID)
+			*vlan_id = conn_entry->conn_rec.vlan_tag;
+		else
+			*vlan_id = 0xFFFF;
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * lpfc_mbx_cmpl_read_fcf_record - Completion handler for read_fcf mbox.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox object.
+ *
+ * This function iterate through all the fcf records available in
+ * HBA and choose the optimal FCF record for discovery. After finding
+ * the FCF for discovery it register the FCF record and kick start
+ * discovery.
+ * If FCF_IN_USE flag is set in currently used FCF, the routine try to
+ * use a FCF record which match fabric name and mac address of the
+ * currently used FCF record.
+ * If the driver support only one FCF, it will try to use the FCF record
+ * used by BOOT_BIOS.
+ */
+void
+lpfc_mbx_cmpl_read_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	void *virt_addr;
+	dma_addr_t phys_addr;
+	uint8_t *bytep;
+	struct lpfc_mbx_sge sge;
+	struct lpfc_mbx_read_fcf_tbl *read_fcf;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+	struct fcf_record *new_fcf_record;
+	int rc;
+	uint32_t boot_flag, addr_mode;
+	uint32_t next_fcf_index;
+	unsigned long flags;
+	uint16_t vlan_id;
+
+	/* Get the first SGE entry from the non-embedded DMA memory. This
+	 * routine only uses a single SGE.
+	 */
+	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
+	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
+	if (unlikely(!mboxq->sge_array)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2524 Failed to get the non-embedded SGE "
+				"virtual address\n");
+		goto out;
+	}
+	virt_addr = mboxq->sge_array->addr[0];
+
+	shdr = (union lpfc_sli4_cfg_shdr *)virt_addr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+				 &shdr->response);
+	/*
+	 * The FCF Record was read and there is no reason for the driver
+	 * to maintain the FCF record data or memory. Instead, just need
+	 * to book keeping the FCFIs can be used.
+	 */
+	if (shdr_status || shdr_add_status) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2521 READ_FCF_RECORD mailbox failed "
+				"with status x%x add_status x%x, mbx\n",
+				shdr_status, shdr_add_status);
+		goto out;
+	}
+	/* Interpreting the returned information of FCF records */
+	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
+	lpfc_sli_pcimem_bcopy(read_fcf, read_fcf,
+			      sizeof(struct lpfc_mbx_read_fcf_tbl));
+	next_fcf_index = bf_get(lpfc_mbx_read_fcf_tbl_nxt_vindx, read_fcf);
+
+	new_fcf_record = (struct fcf_record *)(virt_addr +
+			  sizeof(struct lpfc_mbx_read_fcf_tbl));
+	lpfc_sli_pcimem_bcopy(new_fcf_record, new_fcf_record,
+			      sizeof(struct fcf_record));
+	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
+
+	rc = lpfc_match_fcf_conn_list(phba, new_fcf_record,
+				      &boot_flag, &addr_mode,
+					&vlan_id);
+	/*
+	 * If the fcf record does not match with connect list entries
+	 * read the next entry.
+	 */
+	if (!rc)
+		goto read_next_fcf;
+	/*
+	 * If this is not the first FCF discovery of the HBA, use last
+	 * FCF record for the discovery.
+	 */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (phba->fcf.fcf_flag & FCF_IN_USE) {
+		if (lpfc_fab_name_match(phba->fcf.fabric_name,
+			new_fcf_record) &&
+		    lpfc_mac_addr_match(phba, new_fcf_record)) {
+			phba->fcf.fcf_flag |= FCF_AVAILABLE;
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			goto out;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		goto read_next_fcf;
+	}
+	if (phba->fcf.fcf_flag & FCF_AVAILABLE) {
+		/*
+		 * If the current FCF record does not have boot flag
+		 * set and new fcf record has boot flag set, use the
+		 * new fcf record.
+		 */
+		if (boot_flag && !(phba->fcf.fcf_flag & FCF_BOOT_ENABLE)) {
+			/* Use this FCF record */
+			lpfc_copy_fcf_record(phba, new_fcf_record);
+			phba->fcf.addr_mode = addr_mode;
+			phba->fcf.fcf_flag |= FCF_BOOT_ENABLE;
+			if (vlan_id != 0xFFFF) {
+				phba->fcf.fcf_flag |= FCF_VALID_VLAN;
+				phba->fcf.vlan_id = vlan_id;
+			}
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			goto read_next_fcf;
+		}
+		/*
+		 * If the current FCF record has boot flag set and the
+		 * new FCF record does not have boot flag, read the next
+		 * FCF record.
+		 */
+		if (!boot_flag && (phba->fcf.fcf_flag & FCF_BOOT_ENABLE)) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			goto read_next_fcf;
+		}
+		/*
+		 * If there is a record with lower priority value for
+		 * the current FCF, use that record.
+		 */
+		if (lpfc_fab_name_match(phba->fcf.fabric_name, new_fcf_record)
+			&& (new_fcf_record->fip_priority <
+				phba->fcf.priority)) {
+			/* Use this FCF record */
+			lpfc_copy_fcf_record(phba, new_fcf_record);
+			phba->fcf.addr_mode = addr_mode;
+			if (vlan_id != 0xFFFF) {
+				phba->fcf.fcf_flag |= FCF_VALID_VLAN;
+				phba->fcf.vlan_id = vlan_id;
+			}
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			goto read_next_fcf;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		goto read_next_fcf;
+	}
+	/*
+	 * This is the first available FCF record, use this
+	 * record.
+	 */
+	lpfc_copy_fcf_record(phba, new_fcf_record);
+	phba->fcf.addr_mode = addr_mode;
+	if (boot_flag)
+		phba->fcf.fcf_flag |= FCF_BOOT_ENABLE;
+	phba->fcf.fcf_flag |= FCF_AVAILABLE;
+	if (vlan_id != 0xFFFF) {
+		phba->fcf.fcf_flag |= FCF_VALID_VLAN;
+		phba->fcf.vlan_id = vlan_id;
+	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+	goto read_next_fcf;
+
+read_next_fcf:
+	lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	if (next_fcf_index == LPFC_FCOE_FCF_NEXT_NONE || next_fcf_index == 0)
+		lpfc_register_fcf(phba);
+	else
+		lpfc_sli4_read_fcf_record(phba, next_fcf_index);
+	return;
+
+out:
+	lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	lpfc_register_fcf(phba);
+
+	return;
+}
+
+/**
+ * lpfc_start_fdiscs - send fdiscs for each vports on this port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This function loops through the list of vports on the @phba and issues an
+ * FDISC if possible.
+ */
+void
+lpfc_start_fdiscs(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	int i;
+
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
+				continue;
+			/* There are no vpi for this vport */
+			if (vports[i]->vpi > phba->max_vpi) {
+				lpfc_vport_set_state(vports[i],
+						     FC_VPORT_FAILED);
+				continue;
+			}
+			if (phba->fc_topology == TOPOLOGY_LOOP) {
+				lpfc_vport_set_state(vports[i],
+						     FC_VPORT_LINKDOWN);
+				continue;
+			}
+			if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
+				lpfc_initial_fdisc(vports[i]);
+			else {
+				lpfc_vport_set_state(vports[i],
+						     FC_VPORT_NO_FABRIC_SUPP);
+				lpfc_printf_vlog(vports[i], KERN_ERR,
+						 LOG_ELS,
+						 "0259 No NPIV "
+						 "Fabric support\n");
+			}
+		}
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
+void
+lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_dmabuf *dmabuf = mboxq->context1;
+	struct lpfc_vport *vport = mboxq->vport;
+
+	if (mboxq->u.mb.mbxStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
+			 "2018 REG_VFI mbxStatus error x%x "
+			 "HBA state x%x\n",
+			 mboxq->u.mb.mbxStatus, vport->port_state);
+		if (phba->fc_topology == TOPOLOGY_LOOP) {
+			/* FLOGI failed, use loop map to make discovery list */
+			lpfc_disc_list_loopmap(vport);
+			/* Start discovery */
+			lpfc_disc_start(vport);
+			goto fail_free_mem;
+		}
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+		goto fail_free_mem;
+	}
+	/* Mark the vport has registered with its VFI */
+	vport->vfi_state |= LPFC_VFI_REGISTERED;
+
+	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
+		lpfc_start_fdiscs(phba);
+		lpfc_do_scr_ns_plogi(phba, vport);
+	}
+
+fail_free_mem:
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	lpfc_mbuf_free(phba, dmabuf->virt, dmabuf->phys);
+	kfree(dmabuf);
+	return;
+}
+
+static void
 lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) pmb->context1;
 	struct lpfc_vport  *vport = pmb->vport;
 
@@ -1037,13 +1625,13 @@ static void
 lpfc_mbx_process_link_up(struct lpfc_hba *phba, READ_LA_VAR *la)
 {
 	struct lpfc_vport *vport = phba->pport;
-	LPFC_MBOXQ_t *sparam_mbox, *cfglink_mbox;
+	LPFC_MBOXQ_t *sparam_mbox, *cfglink_mbox = NULL;
 	int i;
 	struct lpfc_dmabuf *mp;
 	int rc;
+	struct fcf_record *fcf_record;
 
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 
 	spin_lock_irq(&phba->hbalock);
 	switch (la->UlnkSpeed) {
@@ -1140,22 +1728,66 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			kfree(mp);
 			mempool_free(sparam_mbox, phba->mbox_mem_pool);
-			if (cfglink_mbox)
-				mempool_free(cfglink_mbox, phba->mbox_mem_pool);
 			goto out;
 		}
 	}
 
-	if (cfglink_mbox) {
+	if (!(phba->hba_flag & HBA_FCOE_SUPPORT)) {
+		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!cfglink_mbox)
+			goto out;
 		vport->port_state = LPFC_LOCAL_CFG_LINK;
 		lpfc_config_link(phba, cfglink_mbox);
 		cfglink_mbox->vport = vport;
 		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
 		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
-		if (rc != MBX_NOT_FINISHED)
-			return;
-		mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+			goto out;
+		}
+	} else {
+		/*
+		 * Add the driver's default FCF record at FCF index 0 now. This
+		 * is phase 1 implementation that support FCF index 0 and driver
+		 * defaults.
+		 */
+		if (phba->cfg_enable_fip == 0) {
+			fcf_record = kzalloc(sizeof(struct fcf_record),
+					GFP_KERNEL);
+			if (unlikely(!fcf_record)) {
+				lpfc_printf_log(phba, KERN_ERR,
+					LOG_MBOX | LOG_SLI,
+					"2554 Could not allocate memmory for "
+					"fcf record\n");
+				rc = -ENODEV;
+				goto out;
+			}
+
+			lpfc_sli4_build_dflt_fcf_record(phba, fcf_record,
+						LPFC_FCOE_FCF_DEF_INDEX);
+			rc = lpfc_sli4_add_fcf_record(phba, fcf_record);
+			if (unlikely(rc)) {
+				lpfc_printf_log(phba, KERN_ERR,
+					LOG_MBOX | LOG_SLI,
+					"2013 Could not manually add FCF "
+					"record 0, status %d\n", rc);
+				rc = -ENODEV;
+				kfree(fcf_record);
+				goto out;
+			}
+			kfree(fcf_record);
+		}
+		/*
+		 * The driver is expected to do FIP/FCF. Call the port
+		 * and get the FCF Table.
+		 */
+		rc = lpfc_sli4_read_fcf_record(phba,
+					LPFC_FCOE_FCF_GET_FIRST);
+		if (rc)
+			goto out;
 	}
+
+	return;
 out:
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
@@ -1186,6 +1818,7 @@ lpfc_mbx_issue_link_down(struct lpfc_hba
 {
 	lpfc_linkdown(phba);
 	lpfc_enable_la(phba);
+	lpfc_unregister_unused_fcf(phba);
 	/* turn on Link Attention interrupts - no CLEAR_LA needed */
 }
 
@@ -3330,3 +3963,395 @@ lpfc_nlp_not_used(struct lpfc_nodelist *
 			return 1;
 	return 0;
 }
+
+/**
+ * lpfc_fcf_inuse - Check if FCF can be unregistered.
+ * @phba: Pointer to hba context object.
+ *
+ * This function iterate through all FC nodes associated
+ * will all vports to check if there is any node with
+ * fc_rports associated with it. If there is an fc_rport
+ * associated with the node, then the node is either in
+ * discovered state or its devloss_timer is pending.
+ */
+static int
+lpfc_fcf_inuse(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	int i, ret = 0;
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host  *shost;
+
+	vports = lpfc_create_vport_work_array(phba);
+
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+		shost = lpfc_shost_from_vport(vports[i]);
+		spin_lock_irq(shost->host_lock);
+		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
+			if (NLP_CHK_NODE_ACT(ndlp) && ndlp->rport &&
+			  (ndlp->rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
+				ret = 1;
+				spin_unlock_irq(shost->host_lock);
+				goto out;
+			}
+		}
+		spin_unlock_irq(shost->host_lock);
+	}
+out:
+	lpfc_destroy_vport_work_array(phba, vports);
+	return ret;
+}
+
+/**
+ * lpfc_unregister_vfi_cmpl - Completion handler for unreg vfi.
+ * @phba: Pointer to hba context object.
+ * @mboxq: Pointer to mailbox object.
+ *
+ * This function frees memory associated with the mailbox command.
+ */
+static void
+lpfc_unregister_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_vport *vport = mboxq->vport;
+
+	if (mboxq->u.mb.mbxStatus) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2555 UNREG_VFI mbxStatus error x%x "
+			"HBA state x%x\n",
+			mboxq->u.mb.mbxStatus, vport->port_state);
+	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return;
+}
+
+/**
+ * lpfc_unregister_fcfi_cmpl - Completion handler for unreg fcfi.
+ * @phba: Pointer to hba context object.
+ * @mboxq: Pointer to mailbox object.
+ *
+ * This function frees memory associated with the mailbox command.
+ */
+static void
+lpfc_unregister_fcfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_vport *vport = mboxq->vport;
+
+	if (mboxq->u.mb.mbxStatus) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2550 UNREG_FCFI mbxStatus error x%x "
+			"HBA state x%x\n",
+			mboxq->u.mb.mbxStatus, vport->port_state);
+	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return;
+}
+
+/**
+ * lpfc_unregister_unused_fcf - Unregister FCF if all devices are disconnected.
+ * @phba: Pointer to hba context object.
+ *
+ * This function check if there are any connected remote port for the FCF and
+ * if all the devices are disconnected, this function unregister FCFI.
+ * This function also tries to use another FCF for discovery.
+ */
+void
+lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc;
+	struct lpfc_vport **vports;
+	int i;
+
+	spin_lock_irq(&phba->hbalock);
+	/*
+	 * If HBA is not running in FIP mode or
+	 * If HBA does not support FCoE or
+	 * If FCF is not registered.
+	 * do nothing.
+	 */
+	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
+		!(phba->fcf.fcf_flag & FCF_REGISTERED) ||
+		(phba->cfg_enable_fip == 0)) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	if (lpfc_fcf_inuse(phba))
+		return;
+
+
+	/* Unregister VPIs */
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports &&
+		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			lpfc_mbx_unreg_vpi(vports[i]);
+			vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			vports[i]->vfi_state &= ~LPFC_VFI_REGISTERED;
+		}
+	lpfc_destroy_vport_work_array(phba, vports);
+
+	/* Unregister VFI */
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2556 UNREG_VFI mbox allocation failed"
+			"HBA state x%x\n",
+			phba->pport->port_state);
+		return;
+	}
+
+	lpfc_unreg_vfi(mbox, phba->pport->vfi);
+	mbox->vport = phba->pport;
+	mbox->mbox_cmpl = lpfc_unregister_vfi_cmpl;
+
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2557 UNREG_VFI issue mbox failed rc x%x "
+			"HBA state x%x\n",
+			rc, phba->pport->port_state);
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return;
+	}
+
+	/* Unregister FCF */
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2551 UNREG_FCFI mbox allocation failed"
+			"HBA state x%x\n",
+			phba->pport->port_state);
+		return;
+	}
+
+	lpfc_unreg_fcfi(mbox, phba->fcf.fcfi);
+	mbox->vport = phba->pport;
+	mbox->mbox_cmpl = lpfc_unregister_fcfi_cmpl;
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2552 UNREG_FCFI issue mbox failed rc x%x "
+			"HBA state x%x\n",
+			rc, phba->pport->port_state);
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return;
+	}
+
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_REGISTERED |
+		FCF_DISCOVERED | FCF_BOOT_ENABLE | FCF_IN_USE |
+		FCF_VALID_VLAN);
+	spin_unlock_irq(&phba->hbalock);
+
+	/*
+	 * If driver is not unloading, check if there is any other
+	 * FCF record that can be used for discovery.
+	 */
+	if ((phba->pport->load_flag & FC_UNLOADING) ||
+		(phba->link_state < LPFC_LINK_UP))
+		return;
+
+	rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
+
+	if (rc)
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
+			"2553 lpfc_unregister_unused_fcf failed to read FCF"
+			" record HBA state x%x\n",
+			phba->pport->port_state);
+}
+
+/**
+ * lpfc_read_fcf_conn_tbl - Create driver FCF connection table.
+ * @phba: Pointer to hba context object.
+ * @buff: Buffer containing the FCF connection table as in the config
+ *         region.
+ * This function create driver data structure for the FCF connection
+ * record table read from config region 23.
+ */
+static void
+lpfc_read_fcf_conn_tbl(struct lpfc_hba *phba,
+	uint8_t *buff)
+{
+	struct lpfc_fcf_conn_entry *conn_entry, *next_conn_entry;
+	struct lpfc_fcf_conn_hdr *conn_hdr;
+	struct lpfc_fcf_conn_rec *conn_rec;
+	uint32_t record_count;
+	int i;
+
+	/* Free the current connect table */
+	list_for_each_entry_safe(conn_entry, next_conn_entry,
+		&phba->fcf_conn_rec_list, list)
+		kfree(conn_entry);
+
+	conn_hdr = (struct lpfc_fcf_conn_hdr *) buff;
+	record_count = conn_hdr->length * sizeof(uint32_t)/
+		sizeof(struct lpfc_fcf_conn_rec);
+
+	conn_rec = (struct lpfc_fcf_conn_rec *)
+		(buff + sizeof(struct lpfc_fcf_conn_hdr));
+
+	for (i = 0; i < record_count; i++) {
+		if (!(conn_rec[i].flags & FCFCNCT_VALID))
+			continue;
+		conn_entry = kzalloc(sizeof(struct lpfc_fcf_conn_entry),
+			GFP_KERNEL);
+		if (!conn_entry) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2566 Failed to allocate connection"
+				" table entry\n");
+			return;
+		}
+
+		memcpy(&conn_entry->conn_rec, &conn_rec[i],
+			sizeof(struct lpfc_fcf_conn_rec));
+		conn_entry->conn_rec.vlan_tag =
+			le16_to_cpu(conn_entry->conn_rec.vlan_tag) & 0xFFF;
+		conn_entry->conn_rec.flags =
+			le16_to_cpu(conn_entry->conn_rec.flags);
+		list_add_tail(&conn_entry->list,
+			&phba->fcf_conn_rec_list);
+	}
+}
+
+/**
+ * lpfc_read_fcoe_param - Read FCoe parameters from conf region..
+ * @phba: Pointer to hba context object.
+ * @buff: Buffer containing the FCoE parameter data structure.
+ *
+ *  This function update driver data structure with config
+ *  parameters read from config region 23.
+ */
+static void
+lpfc_read_fcoe_param(struct lpfc_hba *phba,
+			uint8_t *buff)
+{
+	struct lpfc_fip_param_hdr *fcoe_param_hdr;
+	struct lpfc_fcoe_params *fcoe_param;
+
+	fcoe_param_hdr = (struct lpfc_fip_param_hdr *)
+		buff;
+	fcoe_param = (struct lpfc_fcoe_params *)
+		buff + sizeof(struct lpfc_fip_param_hdr);
+
+	if ((fcoe_param_hdr->parm_version != FIPP_VERSION) ||
+		(fcoe_param_hdr->length != FCOE_PARAM_LENGTH))
+		return;
+
+	if (bf_get(lpfc_fip_param_hdr_fipp_mode, fcoe_param_hdr) ==
+			FIPP_MODE_ON)
+		phba->cfg_enable_fip = 1;
+
+	if (bf_get(lpfc_fip_param_hdr_fipp_mode, fcoe_param_hdr) ==
+		FIPP_MODE_OFF)
+		phba->cfg_enable_fip = 0;
+
+	if (fcoe_param_hdr->parm_flags & FIPP_VLAN_VALID) {
+		phba->valid_vlan = 1;
+		phba->vlan_id = le16_to_cpu(fcoe_param->vlan_tag) &
+			0xFFF;
+	}
+
+	phba->fc_map[0] = fcoe_param->fc_map[0];
+	phba->fc_map[1] = fcoe_param->fc_map[1];
+	phba->fc_map[2] = fcoe_param->fc_map[2];
+	return;
+}
+
+/**
+ * lpfc_get_rec_conf23 - Get a record type in config region data.
+ * @buff: Buffer containing config region 23 data.
+ * @size: Size of the data buffer.
+ * @rec_type: Record type to be searched.
+ *
+ * This function searches config region data to find the begining
+ * of the record specified by record_type. If record found, this
+ * function return pointer to the record else return NULL.
+ */
+static uint8_t *
+lpfc_get_rec_conf23(uint8_t *buff, uint32_t size, uint8_t rec_type)
+{
+	uint32_t offset = 0, rec_length;
+
+	if ((buff[0] == LPFC_REGION23_LAST_REC) ||
+		(size < sizeof(uint32_t)))
+		return NULL;
+
+	rec_length = buff[offset + 1];
+
+	/*
+	 * One TLV record has one word header and number of data words
+	 * specified in the rec_length field of the record header.
+	 */
+	while ((offset + rec_length * sizeof(uint32_t) + sizeof(uint32_t))
+		<= size) {
+		if (buff[offset] == rec_type)
+			return &buff[offset];
+
+		if (buff[offset] == LPFC_REGION23_LAST_REC)
+			return NULL;
+
+		offset += rec_length * sizeof(uint32_t) + sizeof(uint32_t);
+		rec_length = buff[offset + 1];
+	}
+	return NULL;
+}
+
+/**
+ * lpfc_parse_fcoe_conf - Parse FCoE config data read from config region 23.
+ * @phba: Pointer to lpfc_hba data structure.
+ * @buff: Buffer containing config region 23 data.
+ * @size: Size of the data buffer.
+ *
+ * This fuction parse the FCoE config parameters in config region 23 and
+ * populate driver data structure with the parameters.
+ */
+void
+lpfc_parse_fcoe_conf(struct lpfc_hba *phba,
+		uint8_t *buff,
+		uint32_t size)
+{
+	uint32_t offset = 0, rec_length;
+	uint8_t *rec_ptr;
+
+	/*
+	 * If data size is less than 2 words signature and version cannot be
+	 * verified.
+	 */
+	if (size < 2*sizeof(uint32_t))
+		return;
+
+	/* Check the region signature first */
+	if (memcmp(buff, LPFC_REGION23_SIGNATURE, 4)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2567 Config region 23 has bad signature\n");
+		return;
+	}
+
+	offset += 4;
+
+	/* Check the data structure version */
+	if (buff[offset] != LPFC_REGION23_VERSION) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2568 Config region 23 has bad version\n");
+		return;
+	}
+	offset += 4;
+
+	rec_length = buff[offset + 1];
+
+	/* Read FCoE param record */
+	rec_ptr = lpfc_get_rec_conf23(&buff[offset],
+			size - offset, FCOE_PARAM_TYPE);
+	if (rec_ptr)
+		lpfc_read_fcoe_param(phba, rec_ptr);
+
+	/* Read FCF connection table */
+	rec_ptr = lpfc_get_rec_conf23(&buff[offset],
+		size - offset, FCOE_CONN_TBL_TYPE);
+	if (rec_ptr)
+		lpfc_read_fcf_conn_tbl(phba, rec_ptr);
+
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-05-22 13:18:52.000000000 -0400
@@ -363,7 +363,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	if (!mbox)
 		goto out;
 
-	rc = lpfc_reg_login(phba, vport->vpi, icmd->un.rcvels.remoteID,
+	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
 			    (uint8_t *) sp, mbox, 0);
 	if (rc) {
 		mempool_free(mbox, phba->mbox_mem_pool);
@@ -497,11 +497,19 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
+	if ((ndlp->nlp_type & NLP_FABRIC) &&
+		vport->port_type == LPFC_NPIV_PORT) {
+		lpfc_linkdown_port(vport);
+		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag |= NLP_DELAY_TMO;
+		spin_unlock_irq(shost->host_lock);
 
-	if ((!(ndlp->nlp_type & NLP_FABRIC) &&
-	     ((ndlp->nlp_type & NLP_FCP_TARGET) ||
-	      !(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
-	    (ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
+		ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
+	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
+		((ndlp->nlp_type & NLP_FCP_TARGET) ||
+		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
 		/* Only try to re-login if this is NOT a Fabric Node */
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(shost->host_lock);
@@ -569,7 +577,7 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
-	if (!ndlp->nlp_rpi) {
+	if (!(ndlp->nlp_flag & NLP_RPI_VALID)) {
 		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		return 0;
 	}
@@ -859,7 +867,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 
 	lpfc_unreg_rpi(vport, ndlp);
 
-	if (lpfc_reg_login(phba, vport->vpi, irsp->un.elsreq64.remoteID,
+	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
 			   (uint8_t *) sp, mbox, 0) == 0) {
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
@@ -1070,6 +1078,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	IOCB_t *irsp;
 	ADISC *ap;
+	int rc;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
@@ -1095,6 +1104,15 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		return ndlp->nlp_state;
 	}
 
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		rc = lpfc_sli4_resume_rpi(ndlp);
+		if (rc) {
+			/* Stay in state and retry. */
+			ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
+			return ndlp->nlp_state;
+		}
+	}
+
 	if (ndlp->nlp_type & NLP_FCP_TARGET) {
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_MAPPED_NODE);
@@ -1102,6 +1120,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		ndlp->nlp_prev_state = NLP_STE_ADISC_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
+
 	return ndlp->nlp_state;
 }
 
@@ -1285,6 +1304,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
+	ndlp->nlp_flag |= NLP_RPI_VALID;
 
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:52.000000000 -0400
@@ -10929,3 +10929,520 @@ lpfc_sli4_handle_received_buffer(struct 
 	};
 	return 0;
 }
+
+/**
+ * lpfc_sli4_post_all_rpi_hdrs - Post the rpi header memory region to the port
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post rpi header templates to the
+ * HBA consistent with the SLI-4 interface spec.  This routine
+ * posts a PAGE_SIZE memory region to the port to hold up to
+ * PAGE_SIZE modulo 64 rpi context headers.
+ *
+ * This routine does not require any locks.  It's usage is expected
+ * to be driver load or reset recovery when the driver is
+ * sequential.
+ *
+ * Return codes
+ * 	0 - sucessful
+ *      EIO - The mailbox failed to complete successfully.
+ * 	When this error occurs, the driver is not guaranteed
+ *	to have any rpi regions posted to the device and
+ *	must either attempt to repost the regions or take a
+ *	fatal error.
+ **/
+int
+lpfc_sli4_post_all_rpi_hdrs(struct lpfc_hba *phba)
+{
+	struct lpfc_rpi_hdr *rpi_page;
+	uint32_t rc = 0;
+
+	/* Post all rpi memory regions to the port. */
+	list_for_each_entry(rpi_page, &phba->sli4_hba.lpfc_rpi_hdr_list, list) {
+		rc = lpfc_sli4_post_rpi_hdr(phba, rpi_page);
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2008 Error %d posting all rpi "
+					"headers\n", rc);
+			rc = -EIO;
+			break;
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * lpfc_sli4_post_rpi_hdr - Post an rpi header memory region to the port
+ * @phba: pointer to lpfc hba data structure.
+ * @rpi_page:  pointer to the rpi memory region.
+ *
+ * This routine is invoked to post a single rpi header to the
+ * HBA consistent with the SLI-4 interface spec.  This memory region
+ * maps up to 64 rpi context regions.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	ENOMEM - No available memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+int
+lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
+{
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mbx_post_hdr_tmpl *hdr_tmpl;
+	uint32_t rc = 0;
+	uint32_t mbox_tmo;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	/* The port is notified of the header region via a mailbox command. */
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2001 Unable to allocate memory for issuing "
+				"SLI_CONFIG_SPECIAL mailbox command\n");
+		return -ENOMEM;
+	}
+
+	/* Post all rpi memory regions to the port. */
+	hdr_tmpl = &mboxq->u.mqe.un.hdr_tmpl;
+	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE,
+			 sizeof(struct lpfc_mbx_post_hdr_tmpl) -
+			 sizeof(struct mbox_header), LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_post_hdr_tmpl_page_cnt,
+	       hdr_tmpl, rpi_page->page_count);
+	bf_set(lpfc_mbx_post_hdr_tmpl_rpi_offset, hdr_tmpl,
+	       rpi_page->start_rpi);
+	hdr_tmpl->rpi_paddr_lo = putPaddrLow(rpi_page->dmabuf->phys);
+	hdr_tmpl->rpi_paddr_hi = putPaddrHigh(rpi_page->dmabuf->phys);
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+	shdr = (union lpfc_sli4_cfg_shdr *) &hdr_tmpl->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2514 POST_RPI_HDR mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli4_alloc_rpi - Get an available rpi in the device's range
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post rpi header templates to the
+ * HBA consistent with the SLI-4 interface spec.  This routine
+ * posts a PAGE_SIZE memory region to the port to hold up to
+ * PAGE_SIZE modulo 64 rpi context headers.
+ *
+ * Returns
+ * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if sucessful
+ * 	LPFC_RPI_ALLOC_ERROR if no rpis are available.
+ **/
+int
+lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
+{
+	int rpi;
+	uint16_t max_rpi, rpi_base, rpi_limit;
+	uint16_t rpi_remaining;
+	struct lpfc_rpi_hdr *rpi_hdr;
+
+	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
+	rpi_base = phba->sli4_hba.max_cfg_param.rpi_base;
+	rpi_limit = phba->sli4_hba.next_rpi;
+
+	/*
+	 * The valid rpi range is not guaranteed to be zero-based.  Start
+	 * the search at the rpi_base as reported by the port.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, rpi_base);
+	if (rpi >= rpi_limit || rpi < rpi_base)
+		rpi = LPFC_RPI_ALLOC_ERROR;
+	else {
+		set_bit(rpi, phba->sli4_hba.rpi_bmask);
+		phba->sli4_hba.max_cfg_param.rpi_used++;
+		phba->sli4_hba.rpi_count++;
+	}
+
+	/*
+	 * Don't try to allocate more rpi header regions if the device limit
+	 * on available rpis max has been exhausted.
+	 */
+	if ((rpi == LPFC_RPI_ALLOC_ERROR) &&
+	    (phba->sli4_hba.rpi_count >= max_rpi)) {
+		spin_unlock_irq(&phba->hbalock);
+		return rpi;
+	}
+
+	/*
+	 * If the driver is running low on rpi resources, allocate another
+	 * page now.  Note that the next_rpi value is used because
+	 * it represents how many are actually in use whereas max_rpi notes
+	 * how many are supported max by the device.
+	 */
+	rpi_remaining = phba->sli4_hba.next_rpi - rpi_base -
+		phba->sli4_hba.rpi_count;
+	spin_unlock_irq(&phba->hbalock);
+	if (rpi_remaining < LPFC_RPI_LOW_WATER_MARK) {
+		rpi_hdr = lpfc_sli4_create_rpi_hdr(phba);
+		if (!rpi_hdr) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"2002 Error Could not grow rpi "
+					"count\n");
+		} else {
+			lpfc_sli4_post_rpi_hdr(phba, rpi_hdr);
+		}
+	}
+
+	return rpi;
+}
+
+/**
+ * lpfc_sli4_free_rpi - Release an rpi for reuse.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release an rpi to the pool of
+ * available rpis maintained by the driver.
+ **/
+void
+lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
+{
+	spin_lock_irq(&phba->hbalock);
+	clear_bit(rpi, phba->sli4_hba.rpi_bmask);
+	phba->sli4_hba.rpi_count--;
+	phba->sli4_hba.max_cfg_param.rpi_used--;
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_sli4_remove_rpis - Remove the rpi bitmask region
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to remove the memory region that
+ * provided rpi via a bitmask.
+ **/
+void
+lpfc_sli4_remove_rpis(struct lpfc_hba *phba)
+{
+	kfree(phba->sli4_hba.rpi_bmask);
+}
+
+/**
+ * lpfc_sli4_resume_rpi - Remove the rpi bitmask region
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to remove the memory region that
+ * provided rpi via a bitmask.
+ **/
+int
+lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp)
+{
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_hba *phba = ndlp->phba;
+	int rc;
+
+	/* The port is notified of the header region via a mailbox command. */
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	/* Post all rpi memory regions to the port. */
+	lpfc_resume_rpi(mboxq, ndlp);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2010 Resume RPI Mailbox failed "
+				"status %d, mbxStatus x%x\n", rc,
+				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
+ * lpfc_sli4_init_vpi - Initialize a vpi with the port
+ * @phba: pointer to lpfc hba data structure.
+ * @vpi: vpi value to activate with the port.
+ *
+ * This routine is invoked to activate a vpi with the
+ * port when the host intends to use vports with a
+ * nonzero vpi.
+ *
+ * Returns:
+ *    0 success
+ *    -Evalue otherwise
+ **/
+int
+lpfc_sli4_init_vpi(struct lpfc_hba *phba, uint16_t vpi)
+{
+	LPFC_MBOXQ_t *mboxq;
+	int rc = 0;
+	uint32_t mbox_tmo;
+
+	if (vpi == 0)
+		return -EINVAL;
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+	lpfc_init_vpi(mboxq, vpi);
+	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_INIT_VPI);
+	rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2022 INIT VPI Mailbox failed "
+				"status %d, mbxStatus x%x\n", rc,
+				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+		rc = -EIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_mbx_cmpl_add_fcf_record - add fcf mbox completion handler.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: Pointer to mailbox object.
+ *
+ * This routine is invoked to manually add a single FCF record. The caller
+ * must pass a completely initialized FCF_Record.  This routine takes
+ * care of the nonembedded mailbox operations.
+ **/
+static void
+lpfc_mbx_cmpl_add_fcf_record(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	void *virt_addr;
+	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t shdr_status, shdr_add_status;
+
+	virt_addr = mboxq->sge_array->addr[0];
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) virt_addr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+
+	if ((shdr_status || shdr_add_status) &&
+		(shdr_status != STATUS_FCF_IN_USE))
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2558 ADD_FCF_RECORD mailbox failed with "
+			"status x%x add_status x%x\n",
+			shdr_status, shdr_add_status);
+
+	lpfc_sli4_mbox_cmd_free(phba, mboxq);
+}
+
+/**
+ * lpfc_sli4_add_fcf_record - Manually add an FCF Record.
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_record:  pointer to the initialized fcf record to add.
+ *
+ * This routine is invoked to manually add a single FCF record. The caller
+ * must pass a completely initialized FCF_Record.  This routine takes
+ * care of the nonembedded mailbox operations.
+ **/
+int
+lpfc_sli4_add_fcf_record(struct lpfc_hba *phba, struct fcf_record *fcf_record)
+{
+	int rc = 0;
+	LPFC_MBOXQ_t *mboxq;
+	uint8_t *bytep;
+	void *virt_addr;
+	dma_addr_t phys_addr;
+	struct lpfc_mbx_sge sge;
+	uint32_t alloc_len, req_len;
+	uint32_t fcfindex;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2009 Failed to allocate mbox for ADD_FCF cmd\n");
+		return -ENOMEM;
+	}
+
+	req_len = sizeof(struct fcf_record) + sizeof(union lpfc_sli4_cfg_shdr) +
+		  sizeof(uint32_t);
+
+	/* Allocate DMA memory and set up the non-embedded mailbox command */
+	alloc_len = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
+				     LPFC_MBOX_OPCODE_FCOE_ADD_FCF,
+				     req_len, LPFC_SLI4_MBX_NEMBED);
+	if (alloc_len < req_len) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2523 Allocated DMA memory size (x%x) is "
+			"less than the requested DMA memory "
+			"size (x%x)\n", alloc_len, req_len);
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Get the first SGE entry from the non-embedded DMA memory.  This
+	 * routine only uses a single SGE.
+	 */
+	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
+	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
+	if (unlikely(!mboxq->sge_array)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2526 Failed to get the non-embedded SGE "
+				"virtual address\n");
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return -ENOMEM;
+	}
+	virt_addr = mboxq->sge_array->addr[0];
+	/*
+	 * Configure the FCF record for FCFI 0.  This is the driver's
+	 * hardcoded default and gets used in nonFIP mode.
+	 */
+	fcfindex = bf_get(lpfc_fcf_record_fcf_index, fcf_record);
+	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
+	lpfc_sli_pcimem_bcopy(&fcfindex, bytep, sizeof(uint32_t));
+
+	/*
+	 * Copy the fcf_index and the FCF Record Data. The data starts after
+	 * the FCoE header plus word10. The data copy needs to be endian
+	 * correct.
+	 */
+	bytep += sizeof(uint32_t);
+	lpfc_sli_pcimem_bcopy(fcf_record, bytep, sizeof(struct fcf_record));
+	mboxq->vport = phba->pport;
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_add_fcf_record;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2515 ADD_FCF_RECORD mailbox failed with "
+			"status 0x%x\n", rc);
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		rc = -EIO;
+	} else
+		rc = 0;
+
+	return rc;
+}
+
+/**
+ * lpfc_sli4_build_dflt_fcf_record - Build the driver's default FCF Record.
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_record:  pointer to the fcf record to write the default data.
+ * @fcf_index: FCF table entry index.
+ *
+ * This routine is invoked to build the driver's default FCF record.  The
+ * values used are hardcoded.  This routine handles memory initialization.
+ *
+ **/
+void
+lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *phba,
+				struct fcf_record *fcf_record,
+				uint16_t fcf_index)
+{
+	memset(fcf_record, 0, sizeof(struct fcf_record));
+	fcf_record->max_rcv_size = LPFC_FCOE_MAX_RCV_SIZE;
+	fcf_record->fka_adv_period = LPFC_FCOE_FKA_ADV_PER;
+	fcf_record->fip_priority = LPFC_FCOE_FIP_PRIORITY;
+	bf_set(lpfc_fcf_record_mac_0, fcf_record, phba->fc_map[0]);
+	bf_set(lpfc_fcf_record_mac_1, fcf_record, phba->fc_map[1]);
+	bf_set(lpfc_fcf_record_mac_2, fcf_record, phba->fc_map[2]);
+	bf_set(lpfc_fcf_record_mac_3, fcf_record, LPFC_FCOE_FCF_MAC3);
+	bf_set(lpfc_fcf_record_mac_4, fcf_record, LPFC_FCOE_FCF_MAC4);
+	bf_set(lpfc_fcf_record_mac_5, fcf_record, LPFC_FCOE_FCF_MAC5);
+	bf_set(lpfc_fcf_record_fc_map_0, fcf_record, phba->fc_map[0]);
+	bf_set(lpfc_fcf_record_fc_map_1, fcf_record, phba->fc_map[1]);
+	bf_set(lpfc_fcf_record_fc_map_2, fcf_record, phba->fc_map[2]);
+	bf_set(lpfc_fcf_record_fcf_valid, fcf_record, 1);
+	bf_set(lpfc_fcf_record_fcf_index, fcf_record, fcf_index);
+	bf_set(lpfc_fcf_record_mac_addr_prov, fcf_record,
+		LPFC_FCF_FPMA | LPFC_FCF_SPMA);
+	/* Set the VLAN bit map */
+	if (phba->valid_vlan) {
+		fcf_record->vlan_bitmap[phba->vlan_id / 8]
+			= 1 << (phba->vlan_id % 8);
+	}
+}
+
+/**
+ * lpfc_sli4_read_fcf_record - Read the driver's default FCF Record.
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_index: FCF table entry offset.
+ *
+ * This routine is invoked to read up to @fcf_num of FCF record from the
+ * device starting with the given @fcf_index.
+ **/
+int
+lpfc_sli4_read_fcf_record(struct lpfc_hba *phba, uint16_t fcf_index)
+{
+	int rc = 0, error;
+	LPFC_MBOXQ_t *mboxq;
+	void *virt_addr;
+	dma_addr_t phys_addr;
+	uint8_t *bytep;
+	struct lpfc_mbx_sge sge;
+	uint32_t alloc_len, req_len;
+	struct lpfc_mbx_read_fcf_tbl *read_fcf;
+
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2000 Failed to allocate mbox for "
+				"READ_FCF cmd\n");
+		return -ENOMEM;
+	}
+
+	req_len = sizeof(struct fcf_record) +
+		  sizeof(union lpfc_sli4_cfg_shdr) + 2 * sizeof(uint32_t);
+
+	/* Set up READ_FCF SLI4_CONFIG mailbox-ioctl command */
+	alloc_len = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_READ_FCF_TABLE, req_len,
+			 LPFC_SLI4_MBX_NEMBED);
+
+	if (alloc_len < req_len) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0291 Allocated DMA memory size (x%x) is "
+				"less than the requested DMA memory "
+				"size (x%x)\n", alloc_len, req_len);
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return -ENOMEM;
+	}
+
+	/* Get the first SGE entry from the non-embedded DMA memory. This
+	 * routine only uses a single SGE.
+	 */
+	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
+	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
+	if (unlikely(!mboxq->sge_array)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2527 Failed to get the non-embedded SGE "
+				"virtual address\n");
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		return -ENOMEM;
+	}
+	virt_addr = mboxq->sge_array->addr[0];
+	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
+
+	/* Set up command fields */
+	bf_set(lpfc_mbx_read_fcf_tbl_indx, &read_fcf->u.request, fcf_index);
+	/* Perform necessary endian conversion */
+	bytep = virt_addr + sizeof(union lpfc_sli4_cfg_shdr);
+	lpfc_sli_pcimem_bcopy(bytep, bytep, sizeof(uint32_t));
+	mboxq->vport = phba->pport;
+	mboxq->mbox_cmpl = lpfc_mbx_cmpl_read_fcf_record;
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		error = -EIO;
+	} else
+		error = 0;
+	return error;
+}


