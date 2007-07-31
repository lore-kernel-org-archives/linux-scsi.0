From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/8] lpfc 8.2.2 : Fix locking around HBA's port_list
Date: Tue, 31 Jul 2007 21:27:12 +0000 (UTC)
Message-ID: <1186067391.14374.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50130 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762075AbXGaV0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:54 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnig028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:51 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:09:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix locking around HBA's port_list
  Cleans up a lot of bad behaviors that have been in this area a while

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 06:42:36.000000000 -0400
@@ -1060,19 +1060,24 @@ lpfc_nodev_tmo_init(struct lpfc_hba *phb
 static void
 lpfc_update_rport_devloss_tmo(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport;
+	struct lpfc_vport **vports;
 	struct Scsi_Host  *shost;
 	struct lpfc_nodelist  *ndlp;
+	int i;
 
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		shost = lpfc_shost_from_vport(vport);
-		spin_lock_irq(shost->host_lock);
-		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp)
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(shost->host_lock);
+			list_for_each_entry(ndlp, &vports[i]->fc_nodes,
+					    nlp_listp)
 			if (ndlp->rport)
 				ndlp->rport->dev_loss_tmo =
-					phba->cfg_devloss_tmo;
-		spin_unlock_irq(shost->host_lock);
-	}
+						phba->cfg_devloss_tmo;
+			spin_unlock_irq(shost->host_lock);
+		}
+	lpfc_destroy_vport_work_array(vports);
 }
 
 static int
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 06:42:36.000000000 -0400
@@ -40,6 +40,7 @@ void lpfc_reg_vpi(struct lpfc_hba *, uin
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 
+struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove);
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -117,6 +118,7 @@ void lpfc_els_unsol_event(struct lpfc_hb
 int lpfc_els_handle_rscn(struct lpfc_vport *);
 void lpfc_els_flush_rscn(struct lpfc_vport *);
 int lpfc_rscn_payload_check(struct lpfc_vport *, uint32_t);
+void lpfc_els_flush_all_cmd(struct lpfc_hba *);
 void lpfc_els_flush_cmd(struct lpfc_vport *);
 int lpfc_els_disc_adisc(struct lpfc_vport *);
 int lpfc_els_disc_plogi(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 06:42:36.000000000 -0400
@@ -390,17 +390,19 @@ lpfc_ct_cmd(struct lpfc_vport *vport, st
 	return 0;
 }
 
-static struct lpfc_vport *
+struct lpfc_vport *
 lpfc_find_vport_by_did(struct lpfc_hba *phba, uint32_t did) {
-
 	struct lpfc_vport *vport_curr;
+	unsigned long flags;
 
+	spin_lock_irqsave(&phba->hbalock, flags);
 	list_for_each_entry(vport_curr, &phba->port_list, listentry) {
-		if ((vport_curr->fc_myDID) &&
-			(vport_curr->fc_myDID == did))
+		if ((vport_curr->fc_myDID) && (vport_curr->fc_myDID == did)) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return vport_curr;
+		}
 	}
-
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 	return NULL;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 06:42:36.000000000 -0400
@@ -2800,7 +2800,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
-	struct lpfc_vport *next_vport;
 	uint32_t *lp, *datap;
 	IOCB_t *icmd;
 	uint32_t payload_len, length, nportid, *cmd;
@@ -2850,13 +2849,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 			nportid = ((be32_to_cpu(nportid)) & Mask_DID);
 			i -= sizeof(uint32_t);
 			rscn_id++;
-			list_for_each_entry(next_vport, &phba->port_list,
-				listentry) {
-				if (nportid == next_vport->fc_myDID) {
-					hba_id++;
-					break;
-				}
-			}
+			if (lpfc_find_vport_by_did(phba, nportid))
+				hba_id++;
 		}
 		if (rscn_id == hba_id) {
 			/* ALL NPortIDs in RSCN are on HBA */
@@ -3740,6 +3734,50 @@ lpfc_els_flush_cmd(struct lpfc_vport *vp
 	return;
 }
 
+void
+lpfc_els_flush_all_cmd(struct lpfc_hba  *phba)
+{
+	LIST_HEAD(completions);
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_iocbq *tmp_iocb, *piocb;
+	IOCB_t *cmd = NULL;
+
+	lpfc_fabric_abort_hba(phba);
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txq, list) {
+		cmd = &piocb->iocb;
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC)
+			continue;
+		/* Do not flush out the QUE_RING and ABORT/CLOSE iocbs */
+		if (cmd->ulpCommand == CMD_QUE_RING_BUF_CN ||
+		    cmd->ulpCommand == CMD_QUE_RING_BUF64_CN ||
+		    cmd->ulpCommand == CMD_CLOSE_XRI_CN ||
+		    cmd->ulpCommand == CMD_ABORT_XRI_CN)
+			continue;
+		list_move_tail(&piocb->list, &completions);
+		pring->txq_cnt--;
+	}
+	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC)
+			continue;
+		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
+	}
+	spin_unlock_irq(&phba->hbalock);
+	while (!list_empty(&completions)) {
+		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
+		cmd = &piocb->iocb;
+		list_del_init(&piocb->list);
+		if (!piocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, piocb);
+		else {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
+		}
+	}
+	return;
+}
+
 static void
 lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
@@ -4009,11 +4047,16 @@ static struct lpfc_vport *
 lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 {
 	struct lpfc_vport *vport;
+	unsigned long flags;
 
+	spin_lock_irqsave(&phba->hbalock, flags);
 	list_for_each_entry(vport, &phba->port_list, listentry) {
-		if (vport->vpi == vpi)
+		if (vport->vpi == vpi) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return vport;
+		}
 	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 	return NULL;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 06:42:36.000000000 -0400
@@ -528,10 +528,11 @@ struct lpfc_hba {
 	struct fc_host_statistics link_stats;
 
 	struct list_head port_list;
-	struct lpfc_vport *pport; /* physical lpfc_vport pointer */
-	uint16_t max_vpi;	/* Maximum virtual nports */
-#define LPFC_MAX_VPI 100  /* Max number of VPorts supported */
-	unsigned long *vpi_bmask; /* vpi allocation table */
+	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
+	uint16_t max_vpi;		/* Maximum virtual nports */
+#define LPFC_MAX_VPI 100		/* Max number of VPI supported */
+#define LPFC_MAX_VPORTS (LPFC_MAX_VPI+1)/* Max number of VPorts supported */
+	unsigned long *vpi_bmask;	/* vpi allocation table */
 
 	/* Data structure used by fabric iocb scheduler */
 	struct list_head fabric_iocb_list;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 06:42:36.000000000 -0400
@@ -349,7 +349,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 {
 	struct lpfc_sli_ring *pring;
 	uint32_t ha_copy, status, control, work_port_events;
-	struct lpfc_vport *vport;
+	struct lpfc_vport **vports;
+	int i;
 
 	spin_lock_irq(&phba->hbalock);
 	ha_copy = phba->work_ha;
@@ -364,48 +365,31 @@ lpfc_work_done(struct lpfc_hba *phba)
 
 	if (ha_copy & HA_LATT)
 		lpfc_handle_latt(phba);
-
-	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-
-		if (!scsi_host_get(shost)) {
-			continue;
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			work_port_events = vports[i]->work_port_events;
+			if (work_port_events & WORKER_DISC_TMO)
+				lpfc_disc_timeout_handler(vports[i]);
+			if (work_port_events & WORKER_ELS_TMO)
+				lpfc_els_timeout_handler(vports[i]);
+			if (work_port_events & WORKER_HB_TMO)
+				lpfc_hb_timeout_handler(phba);
+			if (work_port_events & WORKER_MBOX_TMO)
+				lpfc_mbox_timeout_handler(phba);
+			if (work_port_events & WORKER_FABRIC_BLOCK_TMO)
+				lpfc_unblock_fabric_iocbs(phba);
+			if (work_port_events & WORKER_FDMI_TMO)
+				lpfc_fdmi_timeout_handler(vports[i]);
+			if (work_port_events & WORKER_RAMP_DOWN_QUEUE)
+				lpfc_ramp_down_queue_handler(phba);
+			if (work_port_events & WORKER_RAMP_UP_QUEUE)
+				lpfc_ramp_up_queue_handler(phba);
+			spin_lock_irq(&vports[i]->work_port_lock);
+			vports[i]->work_port_events &= ~work_port_events;
+			spin_unlock_irq(&vports[i]->work_port_lock);
 		}
-		spin_unlock_irq(&phba->hbalock);
-		work_port_events = vport->work_port_events;
-
-		if (work_port_events & WORKER_DISC_TMO)
-			lpfc_disc_timeout_handler(vport);
-
-		if (work_port_events & WORKER_ELS_TMO)
-			lpfc_els_timeout_handler(vport);
-
-		if (work_port_events & WORKER_HB_TMO)
-			lpfc_hb_timeout_handler(phba);
-
-		if (work_port_events & WORKER_MBOX_TMO)
-			lpfc_mbox_timeout_handler(phba);
-
-		if (work_port_events & WORKER_FABRIC_BLOCK_TMO)
-			lpfc_unblock_fabric_iocbs(phba);
-
-		if (work_port_events & WORKER_FDMI_TMO)
-			lpfc_fdmi_timeout_handler(vport);
-
-		if (work_port_events & WORKER_RAMP_DOWN_QUEUE)
-			lpfc_ramp_down_queue_handler(phba);
-
-		if (work_port_events & WORKER_RAMP_UP_QUEUE)
-			lpfc_ramp_up_queue_handler(phba);
-
-		spin_lock_irq(&vport->work_port_lock);
-		vport->work_port_events &= ~work_port_events;
-		spin_unlock_irq(&vport->work_port_lock);
-		scsi_host_put(shost);
-		spin_lock_irq(&phba->hbalock);
-	}
-	spin_unlock_irq(&phba->hbalock);
+	lpfc_destroy_vport_work_array(vports);
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
@@ -448,32 +432,22 @@ static int
 check_work_wait_done(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport;
-	struct lpfc_sli_ring *pring;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	int rc = 0;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry(vport, &phba->port_list, listentry) {
 		if (vport->work_port_events) {
 			rc = 1;
-			goto exit;
+			break;
 		}
 	}
-
-	if (phba->work_ha || (!list_empty(&phba->work_list)) ||
-	    kthread_should_stop()) {
-		rc = 1;
-		goto exit;
-	}
-
-	pring = &phba->sli.ring[LPFC_ELS_RING];
-	if (pring->flag & LPFC_DEFERRED_RING_EVENT)
+	if (rc || phba->work_ha || (!list_empty(&phba->work_list)) ||
+	    kthread_should_stop() || pring->flag & LPFC_DEFERRED_RING_EVENT) {
 		rc = 1;
-exit:
-	if (rc)
 		phba->work_found++;
-	else
+	} else
 		phba->work_found = 0;
-
 	spin_unlock_irq(&phba->hbalock);
 	return rc;
 }
@@ -601,7 +575,6 @@ lpfc_linkdown_port(struct lpfc_vport *vp
 
 	/* free any ndlp's on unused list */
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp)
-				/* free any ndlp's in unused state */
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			lpfc_drop_node(vport, ndlp);
 
@@ -614,8 +587,9 @@ lpfc_linkdown(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_vport *port_iterator;
+	struct lpfc_vport **vports;
 	LPFC_MBOXQ_t          *mb;
+	int i;
 
 	if (phba->link_state == LPFC_LINK_DOWN) {
 		return 0;
@@ -626,13 +600,13 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		phba->pport->fc_flag &= ~FC_LBIT;
 	}
 	spin_unlock_irq(&phba->hbalock);
-
-	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-
-				/* Issue a LINK DOWN event to all nodes */
-		lpfc_linkdown_port(port_iterator);
-	}
-
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			/* Issue a LINK DOWN event to all nodes */
+			lpfc_linkdown_port(vports[i]);
+		}
+	lpfc_destroy_vport_work_array(vports);
 	/* Clean up any firmware default rpi's */
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mb) {
@@ -733,7 +707,8 @@ lpfc_linkup_port(struct lpfc_vport *vpor
 static int
 lpfc_linkup(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport;
+	struct lpfc_vport **vports;
+	int i;
 
 	phba->link_state = LPFC_LINK_UP;
 
@@ -741,9 +716,11 @@ lpfc_linkup(struct lpfc_hba *phba)
 	clear_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags);
 	del_timer_sync(&phba->fabric_block_timer);
 
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		lpfc_linkup_port(vport);
-	}
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+			lpfc_linkup_port(vports[i]);
+	lpfc_destroy_vport_work_array(vports);
 	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
 		lpfc_issue_clear_la(phba, phba->pport);
 
@@ -1298,15 +1275,15 @@ void
 lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
-	struct lpfc_vport *next_vport;
 	MAILBOX_t *mb = &pmb->mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp;
-	ndlp = (struct lpfc_nodelist *) pmb->context2;
+	struct lpfc_vport **vports;
+	int i;
 
+	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
-
 	if (mb->mbxStatus) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
@@ -1337,21 +1314,27 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	lpfc_nlp_put(ndlp);	/* Drop the reference from the mbox */
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
-		list_for_each_entry(next_vport, &phba->port_list, listentry) {
-			if (next_vport->port_type == LPFC_PHYSICAL_PORT)
-				continue;
-
-			if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
-				lpfc_initial_fdisc(next_vport);
-			else if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
-				lpfc_vport_set_state(vport,
-						     FC_VPORT_NO_FABRIC_SUPP);
-				lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
-						"%d (%d):0259 No NPIV Fabric "
-						"support\n",
-						phba->brd_no, vport->vpi);
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports != NULL)
+			for(i = 0;
+			    i < LPFC_MAX_VPORTS && vports[i] != NULL;
+			    i++) {
+				if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
+					continue;
+				if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
+					lpfc_initial_fdisc(vports[i]);
+				else if (phba->sli3_options &
+						LPFC_SLI3_NPIV_ENABLED) {
+					lpfc_vport_set_state(vports[i],
+						FC_VPORT_NO_FABRIC_SUPP);
+					lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+							"%d (%d):0259 No NPIV "
+							"Fabric support\n",
+							phba->brd_no,
+							vports[i]->vpi);
+				}
 			}
-		}
+		lpfc_destroy_vport_work_array(vports);
 		lpfc_do_scr_ns_plogi(phba, vport);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 06:42:37.000000000 -0400
@@ -437,16 +437,18 @@ lpfc_config_port_post(struct lpfc_hba *p
 int
 lpfc_hba_down_prep(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_vport **vports;
+	int i;
 
 	/* Disable interrupts */
 	writel(0, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		lpfc_cleanup_discovery_resources(vport);
-	}
-
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+			lpfc_cleanup_discovery_resources(vports[i]);
+	lpfc_destroy_vport_work_array(vports);
 	return 0;
 }
 
@@ -615,9 +617,10 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_sli   *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
-	struct lpfc_vport *port_iterator;
+	struct lpfc_vport **vports;
 	uint32_t event_data;
 	struct Scsi_Host  *shost;
+	int i;
 
 	/* If the pci channel is offline, ignore possible errors,
 	 * since we cannot communicate with the pci card anyway. */
@@ -632,14 +635,17 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 				"Data: x%x x%x x%x\n",
 				phba->brd_no, phba->work_hs,
 				phba->work_status[0], phba->work_status[1]);
-		list_for_each_entry(port_iterator, &phba->port_list,
-				    listentry) {
-			shost = lpfc_shost_from_vport(port_iterator);
-
-			spin_lock_irq(shost->host_lock);
-			port_iterator->fc_flag |= FC_ESTABLISH_LINK;
-			spin_unlock_irq(shost->host_lock);
-		}
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports != NULL)
+			for(i = 0;
+			    i < LPFC_MAX_VPORTS && vports[i] != NULL;
+			    i++){
+				shost = lpfc_shost_from_vport(vports[i]);
+				spin_lock_irq(shost->host_lock);
+				vports[i]->fc_flag |= FC_ESTABLISH_LINK;
+				spin_unlock_irq(shost->host_lock);
+			}
+		lpfc_destroy_vport_work_array(vports);
 		spin_lock_irq(&phba->hbalock);
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		spin_unlock_irq(&phba->hbalock);
@@ -708,7 +714,6 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_sli   *psli = &phba->sli;
-	struct lpfc_vport *port_iterator;
 	LPFC_MBOXQ_t *pmb;
 	volatile uint32_t control;
 	struct lpfc_dmabuf *mp;
@@ -729,8 +734,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	rc = -EIO;
 
 	/* Cleanup any outstanding ELS commands */
-	list_for_each_entry(port_iterator, &phba->port_list, listentry)
-		lpfc_els_flush_cmd(port_iterator);
+	lpfc_els_flush_all_cmd(phba);
 
 	psli->slistat.link_event++;
 	lpfc_read_la(phba, pmb, mp);
@@ -1313,22 +1317,26 @@ static void
 lpfc_establish_link_tmo(unsigned long ptr)
 {
 	struct lpfc_hba   *phba = (struct lpfc_hba *) ptr;
-	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_vport **vports;
 	unsigned long iflag;
+	int i;
 
 	/* Re-establishing Link, timer expired */
 	lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 			"%d:1300 Re-establishing Link, timer expired "
 			"Data: x%x x%x\n",
-			phba->brd_no, vport->fc_flag,
-			vport->port_state);
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
-		spin_lock_irqsave(shost->host_lock, iflag);
-		vport->fc_flag &= ~FC_ESTABLISH_LINK;
-		spin_unlock_irqrestore(shost->host_lock, iflag);
-	}
+			phba->brd_no,  phba->pport->fc_flag,
+			phba->pport->port_state);
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			struct Scsi_Host *shost;
+			shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irqsave(shost->host_lock, iflag);
+			vports[i]->fc_flag &= ~FC_ESTABLISH_LINK;
+			spin_unlock_irqrestore(shost->host_lock, iflag);
+		}
+	lpfc_destroy_vport_work_array(vports);
 }
 
 void
@@ -1343,12 +1351,16 @@ lpfc_stop_vport_timers(struct lpfc_vport
 static void
 lpfc_stop_phba_timers(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport;
+	struct lpfc_vport **vports;
+	int i;
 
 	del_timer_sync(&phba->fcp_poll_timer);
 	del_timer_sync(&phba->fc_estabtmo);
-	list_for_each_entry(vport, &phba->port_list, listentry)
-		lpfc_stop_vport_timers(vport);
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+			lpfc_stop_vport_timers(vports[i]);
+	lpfc_destroy_vport_work_array(vports);
 	del_timer_sync(&phba->sli.mbox_tmo);
 	del_timer_sync(&phba->fabric_block_timer);
 	phba->hb_outstanding = 0;
@@ -1360,6 +1372,8 @@ int
 lpfc_online(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_vport **vports;
+	int i;
 
 	if (!phba)
 		return 0;
@@ -1383,14 +1397,18 @@ lpfc_online(struct lpfc_hba *phba)
 		return 1;
 	}
 
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~FC_OFFLINE_MODE;
-		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
-			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-		spin_unlock_irq(shost->host_lock);
-	}
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			struct Scsi_Host *shost;
+			shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(shost->host_lock);
+			vports[i]->fc_flag &= ~FC_OFFLINE_MODE;
+			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
+				vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
+		}
+		lpfc_destroy_vport_work_array(vports);
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
@@ -1440,39 +1458,35 @@ lpfc_offline_prep(struct lpfc_hba * phba
 void
 lpfc_offline(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_vport *port_iterator;
+	struct Scsi_Host  *shost;
+	struct lpfc_vport **vports;
+	int i;
 
-	if (vport->fc_flag & FC_OFFLINE_MODE)
+	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
 		return;
 
 	/* stop all timers associated with this hba */
 	lpfc_stop_phba_timers(phba);
-	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-		port_iterator->work_port_events = 0;
-	}
-
 	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 		       "%d:0460 Bring Adapter offline\n",
 		       phba->brd_no);
-
 	/* Bring down the SLI Layer and cleanup.  The HBA is offline
 	   now.  */
 	lpfc_sli_hba_down(phba);
 	spin_lock_irq(&phba->hbalock);
 	phba->work_ha = 0;
-	vport->fc_flag |= FC_OFFLINE_MODE;
 	spin_unlock_irq(&phba->hbalock);
-	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-		shost = lpfc_shost_from_vport(port_iterator);
-
-		lpfc_cleanup(port_iterator);
-		spin_lock_irq(shost->host_lock);
-		vport->work_port_events = 0;
-		vport->fc_flag |= FC_OFFLINE_MODE;
-		spin_unlock_irq(shost->host_lock);
-	}
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			shost = lpfc_shost_from_vport(vports[i]);
+			lpfc_cleanup(vports[i]);
+			spin_lock_irq(shost->host_lock);
+			vports[i]->work_port_events = 0;
+			vports[i]->fc_flag |= FC_OFFLINE_MODE;
+			spin_unlock_irq(shost->host_lock);
+		}
+	lpfc_destroy_vport_work_array(vports);
 }
 
 /******************************************************************************
@@ -1509,7 +1523,6 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	return 0;
 }
 
-
 struct lpfc_vport *
 lpfc_create_port(struct lpfc_hba *phba, int instance, struct fc_vport *fc_vport)
 {
@@ -1570,7 +1583,9 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	if (error)
 		goto out_put_shost;
 
+	spin_lock_irq(&phba->hbalock);
 	list_add_tail(&vport->listentry, &phba->port_list);
+	spin_unlock_irq(&phba->hbalock);
 	return vport;
 
 out_put_shost:
@@ -1991,8 +2006,10 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_vport *port_iterator;
+	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry(port_iterator, &phba->port_list, listentry)
 		port_iterator->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(&phba->hbalock);
 
 	kfree(vport->vname);
 	lpfc_free_sysfs_attr(vport);
@@ -2013,7 +2030,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
 
-
 	lpfc_debugfs_terminate(vport);
 	lpfc_cleanup(vport);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 06:42:37.000000000 -0400
@@ -119,42 +119,40 @@ lpfc_rampup_queue_depth(struct lpfc_hba 
 void
 lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport;
-	struct Scsi_Host  *host;
+	struct lpfc_vport **vports;
+	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
 	unsigned long new_queue_depth;
 	unsigned long num_rsrc_err, num_cmd_success;
+	int i;
 
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
 	num_cmd_success = atomic_read(&phba->num_cmd_success);
 
-	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		host = lpfc_shost_from_vport(vport);
-		if (!scsi_host_get(host))
-			continue;
-
-		spin_unlock_irq(&phba->hbalock);
-
-		shost_for_each_device(sdev, host) {
-			new_queue_depth = sdev->queue_depth * num_rsrc_err /
-			(num_rsrc_err + num_cmd_success);
-			if (!new_queue_depth)
-				new_queue_depth = sdev->queue_depth - 1;
-			else
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			shost = lpfc_shost_from_vport(vports[i]);
+			shost_for_each_device(sdev, shost) {
 				new_queue_depth =
-					sdev->queue_depth - new_queue_depth;
-
-			if (sdev->ordered_tags)
-				scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
-					new_queue_depth);
-			else
-				scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
-					new_queue_depth);
+					sdev->queue_depth * num_rsrc_err /
+					(num_rsrc_err + num_cmd_success);
+				if (!new_queue_depth)
+					new_queue_depth = sdev->queue_depth - 1;
+				else
+					new_queue_depth = sdev->queue_depth -
+								new_queue_depth;
+				if (sdev->ordered_tags)
+					scsi_adjust_queue_depth(sdev,
+							MSG_ORDERED_TAG,
+							new_queue_depth);
+				else
+					scsi_adjust_queue_depth(sdev,
+							MSG_SIMPLE_TAG,
+							new_queue_depth);
+			}
 		}
-		spin_lock_irq(&phba->hbalock);
-		scsi_host_put(host);
-	}
+	lpfc_destroy_vport_work_array(vports);
 	spin_unlock_irq(&phba->hbalock);
 	atomic_set(&phba->num_rsrc_err, 0);
 	atomic_set(&phba->num_cmd_success, 0);
@@ -163,29 +161,27 @@ lpfc_ramp_down_queue_handler(struct lpfc
 void
 lpfc_ramp_up_queue_handler(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport;
-	struct Scsi_Host  *host;
+	struct lpfc_vport **vports;
+	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
+	int i;
 
-	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		host = lpfc_shost_from_vport(vport);
-		if (!scsi_host_get(host))
-			continue;
-
-		spin_unlock_irq(&phba->hbalock);
-		shost_for_each_device(sdev, host) {
-			if (sdev->ordered_tags)
-				scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
-					sdev->queue_depth+1);
-			else
-				scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
-					sdev->queue_depth+1);
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			shost = lpfc_shost_from_vport(vports[i]);
+			shost_for_each_device(sdev, shost) {
+				if (sdev->ordered_tags)
+					scsi_adjust_queue_depth(sdev,
+							MSG_ORDERED_TAG,
+							sdev->queue_depth+1);
+				else
+					scsi_adjust_queue_depth(sdev,
+							MSG_SIMPLE_TAG,
+							sdev->queue_depth+1);
+			}
 		}
-		spin_lock_irq(&phba->hbalock);
-		scsi_host_put(host);
-	}
-	spin_unlock_irq(&phba->hbalock);
+	lpfc_destroy_vport_work_array(vports);
 	atomic_set(&phba->num_rsrc_err, 0);
 	atomic_set(&phba->num_cmd_success, 0);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:18:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 06:42:37.000000000 -0400
@@ -176,16 +176,21 @@ static int
 lpfc_unique_wwpn(struct lpfc_hba *phba, struct lpfc_vport *new_vport)
 {
 	struct lpfc_vport *vport;
+	unsigned long flags;
 
+	spin_lock_irqsave(&phba->hbalock, flags);
 	list_for_each_entry(vport, &phba->port_list, listentry) {
 		if (vport == new_vport)
 			continue;
 		/* If they match, return not unique */
 		if (memcmp(&vport->fc_sparam.portName,
-			&new_vport->fc_sparam.portName,
-			sizeof(struct lpfc_name)) == 0)
+			   &new_vport->fc_sparam.portName,
+			   sizeof(struct lpfc_name)) == 0) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return 0;
+		}
 	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 	return 1;
 }
 
@@ -524,6 +529,36 @@ out:
 	return rc;
 }
 
-
 EXPORT_SYMBOL(lpfc_vport_create);
 EXPORT_SYMBOL(lpfc_vport_delete);
+
+struct lpfc_vport **
+lpfc_create_vport_work_array(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *port_iterator;
+	struct lpfc_vport **vports;
+	int index = 0;
+	vports = kzalloc(LPFC_MAX_VPORTS * sizeof(struct lpfc_vport *),
+			 GFP_KERNEL);
+	if (vports == NULL)
+		return NULL;
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
+		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator)))
+			continue;
+		vports[index++] = port_iterator;
+	}
+	spin_unlock_irq(&phba->hbalock);
+	return vports;
+}
+
+void
+lpfc_destroy_vport_work_array(struct lpfc_vport **vports)
+{
+	int i;
+	if (vports == NULL)
+		return;
+	for (i=0; vports[i] != NULL && i < LPFC_MAX_VPORTS; i++)
+		scsi_host_put(lpfc_shost_from_vport(vports[i]));
+	kfree(vports);
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
--- a/drivers/scsi/lpfc/lpfc_vport.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.h	2007-08-02 06:42:37.000000000 -0400
@@ -88,6 +88,8 @@ int lpfc_vport_create(struct fc_vport *,
 int lpfc_vport_delete(struct fc_vport *);
 int lpfc_vport_getinfo(struct Scsi_Host *, struct vport_info *);
 int lpfc_vport_tgt_remove(struct Scsi_Host *, uint, uint);
+struct lpfc_vport **lpfc_create_vport_work_array(struct lpfc_hba *);
+void lpfc_destroy_vport_work_array(struct lpfc_vport **);
 
 /*
  *  queuecommand  VPORT-specific return codes. Specified in  the host byte code.


