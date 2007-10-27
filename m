From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/9] lpfc 8.2.3 : FC Discovery Fixes
Date: Sat, 27 Oct 2007 13:37:43 -0400
Message-ID: <1193506663.8770.22.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46356 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXJ0Rhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:38 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbbCG021378
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


FC Discovery Fixes:
- Fix up lpfc_drop_node() vs lpfc_nlp_not_used() usage
- Clear ADISC flag when unregistering RPI and REMOVE ndlps if in recovery.
- Fix usage of UNUSED list and ndlps
- Fix PLOGI race conditions
- Reset link if NameServer PLOGI errors occur
- Synchronize GID_FT queries with PLOGI receptions

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:45:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 13:07:36.000000000 -0400
@@ -45,6 +45,7 @@ void lpfc_init_link(struct lpfc_hba *, L
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove);
 int lpfc_linkdown(struct lpfc_hba *);
+void lpfc_port_link_failure(struct lpfc_vport *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void lpfc_mbx_cmpl_clear_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -74,6 +75,7 @@ void lpfc_disc_list_loopmap(struct lpfc_
 void lpfc_disc_start(struct lpfc_vport *);
 void lpfc_disc_flush_list(struct lpfc_vport *);
 void lpfc_cleanup_discovery_resources(struct lpfc_vport *);
+void lpfc_cleanup(struct lpfc_vport *);
 void lpfc_disc_timeout(unsigned long);
 
 struct lpfc_nodelist *__lpfc_findnode_rpi(struct lpfc_vport *, uint16_t);
@@ -91,6 +93,8 @@ void lpfc_do_scr_ns_plogi(struct lpfc_hb
 int lpfc_check_sparm(struct lpfc_vport *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t);
 int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
+void lpfc_more_plogi(struct lpfc_vport *);
+void lpfc_end_rscn(struct lpfc_vport *);
 int lpfc_els_chk_latt(struct lpfc_vport *);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
 int lpfc_initial_flogi(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-10-27 10:45:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-10-27 13:06:59.000000000 -0400
@@ -103,7 +103,6 @@ struct lpfc_nodelist {
 #define NLP_RM_DFLT_RPI    0x4000000	/* need to remove leftover dflt RPI */
 #define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
-#define NLP_DELAYED_RM     0x20000000   /* Defer UNUSED List removal */
 
 /* There are 4 different double linked lists nodelist entries can reside on.
  * The Port Login (PLOGI) list and Address Discovery (ADISC) list are used
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 10:45:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 13:07:36.000000000 -0400
@@ -575,8 +575,13 @@ flogifail:
 
 		/* Start discovery */
 		lpfc_disc_start(vport);
+	} else if (((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
+			((irsp->un.ulpWord[4] != IOERR_SLI_ABORTED) &&
+			(irsp->un.ulpWord[4] != IOERR_SLI_DOWN))) &&
+			(phba->link_state != LPFC_CLEAR_LA)) {
+		/* If FLOGI failed enable link interrupt. */
+		lpfc_issue_clear_la(phba, vport);
 	}
-
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 }
@@ -711,13 +716,8 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 	} else {
 		lpfc_dequeue_node(vport, ndlp);
-
-		/* If we go thru this path, Fabric_DID ndlp is in the process
-		 * of being removed. We need to bump the reference count by 1
-		 * so it stays around all through this link up period.
-		 */
-		lpfc_nlp_get(ndlp);
 	}
+
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
 		lpfc_nlp_put(ndlp);
 	}
@@ -746,7 +746,8 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 	}
 	return 1;
 }
-static void
+
+void
 lpfc_more_plogi(struct lpfc_vport *vport)
 {
 	int sentplogi;
@@ -813,8 +814,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
 
 	/* Move this back to NPR state */
-	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0)
+	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0) {
+		/* The new_ndlp is replacing ndlp totally, so we need
+		 * to put ndlp on UNUSED list and try to free it.
+		 */
 		lpfc_drop_node(vport, ndlp);
+	}
 	else {
 		lpfc_unreg_rpi(vport, ndlp);
 		ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
@@ -823,6 +828,27 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	return new_ndlp;
 }
 
+void
+lpfc_end_rscn(struct lpfc_vport *vport)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	if (vport->fc_flag & FC_RSCN_MODE) {
+		/*
+		 * Check to see if more RSCNs came in while we were
+		 * processing this one.
+		 */
+		if (vport->fc_rscn_id_cnt ||
+		    (vport->fc_flag & FC_RSCN_DISCOVERY) != 0)
+			lpfc_els_handle_rscn(vport);
+		else {
+			spin_lock_irq(shost->host_lock);
+			vport->fc_flag &= ~FC_RSCN_MODE;
+			spin_unlock_irq(shost->host_lock);
+		}
+	}
+}
+
 static void
 lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    struct lpfc_iocbq *rspiocb)
@@ -893,13 +919,6 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			goto out;
 		}
 		/* PLOGI failed */
-		if (ndlp->nlp_DID == NameServer_DID) {
-			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-					 "0250 Nameserver login error: "
-					 "0x%x / 0x%x\n",
-					 irsp->ulpStatus, irsp->un.ulpWord[4]);
-		}
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp)) {
 			rc = NLP_STE_FREED_NODE;
@@ -927,20 +946,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			spin_unlock_irq(shost->host_lock);
 
 			lpfc_can_disctmo(vport);
-			if (vport->fc_flag & FC_RSCN_MODE) {
-				/*
-				 * Check to see if more RSCNs came in while
-				 * we were processing this one.
-				 */
-				if ((vport->fc_rscn_id_cnt == 0) &&
-				    (!(vport->fc_flag & FC_RSCN_DISCOVERY))) {
-					spin_lock_irq(shost->host_lock);
-					vport->fc_flag &= ~FC_RSCN_MODE;
-					spin_unlock_irq(shost->host_lock);
-				} else {
-					lpfc_els_handle_rscn(vport);
-				}
-			}
+			lpfc_end_rscn(vport);
 		}
 	}
 
@@ -1160,8 +1166,6 @@ lpfc_more_adisc(struct lpfc_vport *vport
 static void
 lpfc_rscn_disc(struct lpfc_vport *vport)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
 	lpfc_can_disctmo(vport);
 
 	/* RSCN discovery */
@@ -1170,19 +1174,7 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
 		if (lpfc_els_disc_plogi(vport))
 			return;
 
-	if (vport->fc_flag & FC_RSCN_MODE) {
-		/* Check to see if more RSCNs came in while we were
-		 * processing this one.
-		 */
-		if ((vport->fc_rscn_id_cnt == 0) &&
-		    (!(vport->fc_flag & FC_RSCN_DISCOVERY))) {
-			spin_lock_irq(shost->host_lock);
-			vport->fc_flag &= ~FC_RSCN_MODE;
-			spin_unlock_irq(shost->host_lock);
-		} else {
-			lpfc_els_handle_rscn(vport);
-		}
-	}
+	lpfc_end_rscn(vport);
 }
 
 static void
@@ -1632,27 +1624,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	return 0;
 }
 
-static void
-lpfc_end_rscn(struct lpfc_vport *vport)
-{
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
-	if (vport->fc_flag & FC_RSCN_MODE) {
-		/*
-		 * Check to see if more RSCNs came in while we were
-		 * processing this one.
-		 */
-		if (vport->fc_rscn_id_cnt ||
-		    (vport->fc_flag & FC_RSCN_DISCOVERY) != 0)
-			lpfc_els_handle_rscn(vport);
-		else {
-			spin_lock_irq(shost->host_lock);
-			vport->fc_flag &= ~FC_RSCN_MODE;
-			spin_unlock_irq(shost->host_lock);
-		}
-	}
-}
-
 void
 lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 {
@@ -2069,6 +2040,32 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 }
 
 int
+lpfc_els_free_data(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr1)
+{
+	struct lpfc_dmabuf *buf_ptr;
+
+	/* Free the response before processing the command.  */
+	if (!list_empty(&buf_ptr1->list)) {
+		list_remove_head(&buf_ptr1->list, buf_ptr,
+				 struct lpfc_dmabuf,
+				 list);
+		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
+		kfree(buf_ptr);
+	}
+	lpfc_mbuf_free(phba, buf_ptr1->virt, buf_ptr1->phys);
+	kfree(buf_ptr1);
+	return 0;
+}
+
+int
+lpfc_els_free_bpl(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr)
+{
+	lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
+	kfree(buf_ptr);
+	return 0;
+}
+
+int
 lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
@@ -2080,22 +2077,12 @@ lpfc_els_free_iocb(struct lpfc_hba *phba
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
 	if (elsiocb->context2) {
 		buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
-		/* Free the response before processing the command.  */
-		if (!list_empty(&buf_ptr1->list)) {
-			list_remove_head(&buf_ptr1->list, buf_ptr,
-					 struct lpfc_dmabuf,
-					 list);
-			lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
-			kfree(buf_ptr);
-		}
-		lpfc_mbuf_free(phba, buf_ptr1->virt, buf_ptr1->phys);
-		kfree(buf_ptr1);
+		lpfc_els_free_data(phba, buf_ptr1);
 	}
 
 	if (elsiocb->context3) {
 		buf_ptr = (struct lpfc_dmabuf *) elsiocb->context3;
-		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
-		kfree(buf_ptr);
+		lpfc_els_free_bpl(phba, buf_ptr);
 	}
 	lpfc_sli_release_iocbq(phba, elsiocb);
 	return 0;
@@ -2119,15 +2106,15 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 			 "Data: x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	switch (ndlp->nlp_state) {
-	case NLP_STE_UNUSED_NODE:	/* node is just allocated */
-		lpfc_drop_node(vport, ndlp);
-		break;
-	case NLP_STE_NPR_NODE:		/* NPort Recovery mode */
-		lpfc_unreg_rpi(vport, ndlp);
-		break;
-	default:
-		break;
+
+	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
+		/* NPort Recovery mode or node is just allocated */
+		if (!lpfc_nlp_not_used(ndlp)) {
+			/* If the ndlp is being used by another discovery
+			 * thread, just unregister the RPI.
+			 */
+			lpfc_unreg_rpi(vport, ndlp);
+		}
 	}
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
@@ -2160,15 +2147,27 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = ndlp ? ndlp->vport : NULL;
 	struct Scsi_Host  *shost = vport ? lpfc_shost_from_vport(vport) : NULL;
-	IOCB_t *irsp;
+	IOCB_t  *irsp;
+	uint8_t *pcmd;
 	LPFC_MBOXQ_t *mbox = NULL;
 	struct lpfc_dmabuf *mp = NULL;
+	uint32_t ls_rjt = 0;
 
 	irsp = &rspiocb->iocb;
 
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
 
+	/* First determine if this is a LS_RJT cmpl */
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
+	if (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT) {
+		/* A LS_RJT associated with Default RPI cleanup
+		 * has its own seperate code path.
+		 */
+		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
+			ls_rjt = 1;
+	}
+
 	/* Check to see if link went down during discovery */
 	if (!ndlp || lpfc_els_chk_latt(vport)) {
 		if (mbox) {
@@ -2247,7 +2246,16 @@ out:
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
 		spin_unlock_irq(shost->host_lock);
+
+		/* If the node is not being used by another discovery thread,
+		 * and we are sending a reject, we are done with it.
+		 * Release driver reference count here and free associated
+		 * resources.
+		 */
+		if (ls_rjt)
+			lpfc_nlp_not_used(ndlp);
 	}
+
 	lpfc_els_free_iocb(phba, cmdiocb);
 	return;
 }
@@ -2418,18 +2426,6 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
 
-	/* If the node is in the UNUSED state, and we are sending
-	 * a reject, we are done with it.  Release driver reference
-	 * count here.  The outstanding els will release its reference on
-	 * completion, as long as the ndlp stays in the UNUSED list,
-	 * and the node can be freed then.
-	 */
-	if ((ndlp->nlp_state == NLP_STE_UNUSED_NODE) &&
-		!(ndlp->nlp_flag & NLP_DELAYED_RM)) {
-		ndlp->nlp_flag |= NLP_DELAYED_RM;
-		lpfc_nlp_put(ndlp);
-	}
-
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -2715,7 +2711,10 @@ lpfc_els_disc_plogi(struct lpfc_vport *v
 			}
 		}
 	}
-	if (sentplogi == 0) {
+	if (sentplogi) {
+		lpfc_set_disctmo(vport);
+	}
+	else {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_NLP_MORE;
 		spin_unlock_irq(shost->host_lock);
@@ -3533,6 +3532,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 					 * other NLP_FABRIC logins
 					 */
 					lpfc_drop_node(vport, ndlp);
+
 				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 					/* Fail outstanding I/O now since this
 					 * device is marked for PLOGI
@@ -3781,6 +3781,7 @@ static void
 lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
 {
+	struct Scsi_Host  *shost;
 	struct lpfc_nodelist *ndlp;
 	struct ls_rjt stat;
 	uint32_t *payload;
@@ -3826,6 +3827,14 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			ndlp->nlp_type |= NLP_FABRIC;
 		}
 	}
+	else {
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+			/* This is simular to the new node path */
+			lpfc_nlp_get(ndlp);
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+			newnode = 1;
+		}
+	}
 
 	phba->fc_stat.elsRcvFrame++;
 	if (elsiocb->context1)
@@ -3853,6 +3862,12 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			rjt_err = LSRJT_UNABLE_TPC;
 			break;
 		}
+
+		shost = lpfc_shost_from_vport(vport);
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag &= ~NLP_TARGET_REMOVE;
+		spin_unlock_irq(shost->host_lock);
+
 		lpfc_disc_state_machine(vport, ndlp, elsiocb,
 					NLP_EVT_RCV_PLOGI);
 
@@ -3864,7 +3879,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvFLOGI++;
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_LOGO:
@@ -3894,7 +3909,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	case ELS_CMD_RSCN:
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_ADISC:
@@ -3966,7 +3981,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvLIRR++;
 		lpfc_els_rcv_lirr(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RPS:
@@ -3976,7 +3991,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRPS++;
 		lpfc_els_rcv_rps(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RPL:
@@ -3986,7 +4001,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRPL++;
 		lpfc_els_rcv_rpl(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_RNID:
@@ -3996,7 +4011,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		phba->fc_stat.elsRcvRNID++;
 		lpfc_els_rcv_rnid(vport, elsiocb, ndlp);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	default:
@@ -4011,7 +4026,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0115 Unknown ELS command x%x "
 				 "received from NPORT x%x\n", cmd, did);
-		if (newnode && (!(ndlp->nlp_flag & NLP_DELAYED_RM)))
+		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 10:45:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 13:06:59.000000000 -0400
@@ -157,6 +157,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
 	uint8_t *name;
+	int  put_node;
+	int  put_rport;
 	int warn_on = 0;
 
 	rport = ndlp->rport;
@@ -178,9 +180,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		return;
 
 	if (ndlp->nlp_type & NLP_FABRIC) {
-		int  put_node;
-		int  put_rport;
-
 		/* We will clean up these Nodes in linkup */
 		put_node = rdata->pnode != NULL;
 		put_rport = ndlp->rport != NULL;
@@ -222,23 +221,20 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
+	put_node = rdata->pnode != NULL;
+	put_rport = ndlp->rport != NULL;
+	rdata->pnode = NULL;
+	ndlp->rport = NULL;
+	if (put_node)
+		lpfc_nlp_put(ndlp);
+	if (put_rport)
+		put_device(&rport->dev);
+
 	if (!(vport->load_flag & FC_UNLOADING) &&
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))
+	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)) {
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
-	else {
-		int  put_node;
-		int  put_rport;
-
-		put_node = rdata->pnode != NULL;
-		put_rport = ndlp->rport != NULL;
-		rdata->pnode = NULL;
-		ndlp->rport = NULL;
-		if (put_node)
-			lpfc_nlp_put(ndlp);
-		if (put_rport)
-			put_device(&rport->dev);
 	}
 }
 
@@ -546,11 +542,9 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 	}
 }
 
-static void
+void
 lpfc_port_link_failure(struct lpfc_vport *vport)
 {
-	struct lpfc_nodelist *ndlp, *next_ndlp;
-
 	/* Cleanup any outstanding RSCN activity */
 	lpfc_els_flush_rscn(vport);
 
@@ -559,11 +553,6 @@ lpfc_port_link_failure(struct lpfc_vport
 
 	lpfc_cleanup_rpis(vport, 0);
 
-	/* free any ndlp's on unused list */
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp)
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
-			lpfc_drop_node(vport, ndlp);
-
 	/* Turn off discovery timer if its running */
 	lpfc_can_disctmo(vport);
 }
@@ -670,7 +659,6 @@ static void
 lpfc_linkup_port(struct lpfc_vport *vport)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp, *next_ndlp;
 	struct lpfc_hba  *phba = vport->phba;
 
 	if ((vport->load_flag & FC_UNLOADING) != 0)
@@ -697,11 +685,6 @@ lpfc_linkup_port(struct lpfc_vport *vpor
 	if (vport->fc_flag & FC_LBIT)
 		lpfc_linkup_cleanup_nodes(vport);
 
-				/* free any ndlp's in unused state */
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
-				 nlp_listp)
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
-			lpfc_drop_node(vport, ndlp);
 }
 
 static int
@@ -1345,7 +1328,9 @@ out:
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
-		lpfc_drop_node(vport, ndlp);
+
+		/* If no other thread is using the ndlp, free it */
+		lpfc_nlp_not_used(ndlp);
 
 		if (phba->fc_topology == TOPOLOGY_LOOP) {
 			/*
@@ -1605,16 +1590,6 @@ lpfc_nlp_set_state(struct lpfc_vport *vp
 		ndlp->nlp_type &= ~NLP_FC_NODE;
 	}
 
-	if ((old_state == NLP_STE_UNUSED_NODE) &&
-	    (state != NLP_STE_UNUSED_NODE) &&
-	    (ndlp->nlp_flag & NLP_DELAYED_RM)) {
-		/* We are using the ndlp after all, so reverse
-		 * the delayed removal of it.
-		 */
-		ndlp->nlp_flag &= ~NLP_DELAYED_RM;
-		lpfc_nlp_get(ndlp);
-	}
-
 	if (list_empty(&ndlp->nlp_listp)) {
 		spin_lock_irq(shost->host_lock);
 		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
@@ -1646,9 +1621,16 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 void
 lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+	/*
+	 * Use of lpfc_drop_node and UNUSED list. lpfc_drop_node should
+	 * be used if we wish to issue the "last" lpfc_nlp_put() to remove
+	 * the ndlp from the vport.  The ndlp resides on the UNUSED list
+	 * until ALL other outstanding threads have completed. Thus, if a
+	 * ndlp is on the UNUSED list already, we should never do another
+	 * lpfc_drop_node() on it.
+	 */
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
-	if (!(ndlp->nlp_flag & NLP_DELAYED_RM))
-		lpfc_nlp_put(ndlp);
+	lpfc_nlp_put(ndlp);
 	return;
 }
 
@@ -2116,6 +2098,12 @@ lpfc_setup_disc_node(struct lpfc_vport *
 	}
 	if (vport->fc_flag & FC_RSCN_MODE) {
 		if (lpfc_rscn_payload_check(vport, did)) {
+			/* If we've already recieved a PLOGI from this NPort
+			 * we don't need to try to discover it again.
+			 */
+			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
+				return NULL;
+
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
@@ -2128,8 +2116,13 @@ lpfc_setup_disc_node(struct lpfc_vport *
 		} else
 			ndlp = NULL;
 	} else {
+		/* If we've already recieved a PLOGI from this NPort,
+		 * or we are already in the process of discovery on it,
+		 * we don't need to try to discover it again.
+		 */
 		if (ndlp->nlp_state == NLP_STE_ADISC_ISSUE ||
-		    ndlp->nlp_state == NLP_STE_PLOGI_ISSUE)
+		    ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
+		    ndlp->nlp_flag & NLP_RCV_PLOGI)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		spin_lock_irq(shost->host_lock);
@@ -2497,6 +2490,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 			if (ndlp->nlp_type & NLP_FABRIC) {
 				/* Clean up the ndlp on Fabric connections */
 				lpfc_drop_node(vport, ndlp);
+
 			} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
 				/* Fail outstanding IO now since device
 				 * is marked for PLOGI.
@@ -2515,7 +2509,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		/* Initial FLOGI timeout */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "0222 Initial %s timeout\n",
-				 vport->vpi ? "FLOGI" : "FDISC");
+				 vport->vpi ? "FDISC" : "FLOGI");
 
 		/* Assume no Fabric and go on with discovery.
 		 * Check for outstanding ELS FLOGI to abort.
@@ -2537,10 +2531,10 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		/* Next look for NameServer ndlp */
 		ndlp = lpfc_findnode_did(vport, NameServer_DID);
 		if (ndlp)
-			lpfc_nlp_put(ndlp);
-		/* Start discovery */
-		lpfc_disc_start(vport);
-		break;
+			lpfc_els_abort(phba, ndlp);
+
+		/* ReStart discovery */
+		goto restart_disc;
 
 	case LPFC_NS_QRY:
 	/* Check for wait for NameServer Rsp timeout */
@@ -2559,6 +2553,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		}
 		vport->fc_ns_retry = 0;
 
+restart_disc:
 		/*
 		 * Discovery is over.
 		 * set port_state to PORT_READY if SLI2.
@@ -2731,8 +2726,7 @@ __lpfc_find_node(struct lpfc_vport *vpor
 	struct lpfc_nodelist *ndlp;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state != NLP_STE_UNUSED_NODE &&
-		    filter(ndlp, param))
+		if (filter(ndlp, param))
 			return ndlp;
 	}
 	return NULL;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:45:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 13:06:59.000000000 -0400
@@ -1334,15 +1334,35 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	kfree(HashWorking);
 }
 
-static void
+void
 lpfc_cleanup(struct lpfc_vport *vport)
 {
+	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
-	/* clean up phba - lpfc specific */
-	lpfc_can_disctmo(vport);
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp)
-		lpfc_nlp_put(ndlp);
+	if (phba->link_state > LPFC_LINK_DOWN)
+		lpfc_port_link_failure(vport);
+
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_type & NLP_FABRIC)
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RECOVERY);
+		lpfc_disc_state_machine(vport, ndlp, NULL,
+					     NLP_EVT_DEVICE_RM);
+	}
+
+	/* At this point, ALL ndlp's should be gone */
+	while (!list_empty(&vport->fc_nodes)) {
+
+		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
+			nlp_listp) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+				"0233 Nodelist x%x not free: %d\n",
+				ndlp->nlp_DID,
+				atomic_read(&ndlp->kref.refcount));
+			lpfc_drop_node(vport, ndlp);
+		}
+	}
 	return;
 }
 
@@ -1463,6 +1483,8 @@ lpfc_offline_prep(struct lpfc_hba * phba
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
+	struct lpfc_vport **vports;
+	int i;
 
 	if (vport->fc_flag & FC_OFFLINE_MODE)
 		return;
@@ -1471,10 +1493,32 @@ lpfc_offline_prep(struct lpfc_hba * phba
 
 	lpfc_linkdown(phba);
 
-	/* Issue an unreg_login to all nodes */
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp)
-		if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
-			lpfc_unreg_rpi(vport, ndlp);
+	/* Issue an unreg_login to all nodes on all vports */
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL) {
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
+			struct Scsi_Host *shost;
+
+			shost =	lpfc_shost_from_vport(vports[i]);
+			list_for_each_entry_safe(ndlp, next_ndlp,
+						 &vports[i]->fc_nodes,
+						 nlp_listp) {
+				if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+					continue;
+				if (ndlp->nlp_type & NLP_FABRIC) {
+					lpfc_disc_state_machine(vports[i], ndlp,
+						NULL, NLP_EVT_DEVICE_RECOVERY);
+					lpfc_disc_state_machine(vports[i], ndlp,
+						NULL, NLP_EVT_DEVICE_RM);
+				}
+				spin_lock_irq(shost->host_lock);
+				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+				spin_unlock_irq(shost->host_lock);
+				lpfc_unreg_rpi(vports[i], ndlp);
+			}
+		}
+	}
+	lpfc_destroy_vport_work_array(vports);
 
 	lpfc_sli_flush_mbox_queue(phba);
 }
@@ -1508,7 +1552,6 @@ lpfc_offline(struct lpfc_hba *phba)
 	if (vports != NULL)
 		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
-			lpfc_cleanup(vports[i]);
 			spin_lock_irq(shost->host_lock);
 			vports[i]->work_port_events = 0;
 			vports[i]->fc_flag |= FC_OFFLINE_MODE;
@@ -2061,6 +2104,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
+	lpfc_cleanup(vport);
+
 	/*
 	 * Bring down the SLI Layer. This step disable all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
@@ -2075,7 +2120,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	spin_unlock_irq(&phba->hbalock);
 
 	lpfc_debugfs_terminate(vport);
-	lpfc_cleanup(vport);
 
 	kthread_stop(phba->worker_thread);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 10:45:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 13:07:36.000000000 -0400
@@ -406,6 +406,41 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			ndlp, mbox);
 		return 1;
 	}
+
+	/* If the remote NPort logs into us, before we can initiate
+	 * discovery to them, cleanup the NPort from discovery accordingly.
+	 */
+	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag &= ~NLP_DELAY_TMO;
+		spin_unlock_irq(shost->host_lock);
+		del_timer_sync(&ndlp->nlp_delayfunc);
+		ndlp->nlp_last_elscmd = 0;
+
+		if (!list_empty(&ndlp->els_retry_evt.evt_listp))
+			list_del_init(&ndlp->els_retry_evt.evt_listp);
+
+		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(shost->host_lock);
+				if (vport->num_disc_nodes) {
+				/* Check to see if there are more
+				 * PLOGIs to be sent
+				 */
+				lpfc_more_plogi(vport);
+
+				if (vport->num_disc_nodes == 0) {
+					spin_lock_irq(shost->host_lock);
+					vport->fc_flag &= ~FC_NDISC_ACTIVE;
+					spin_unlock_irq(shost->host_lock);
+					lpfc_can_disctmo(vport);
+					lpfc_end_rscn(vport);
+				}
+			}
+		}
+	}
+
 	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
 	return 1;
 
@@ -500,12 +535,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 		spin_unlock_irq(shost->host_lock);
 
 		ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
-		ndlp->nlp_prev_state = ndlp->nlp_state;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-	} else {
-		ndlp->nlp_prev_state = ndlp->nlp_state;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	}
+	ndlp->nlp_prev_state = ndlp->nlp_state;
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~NLP_NPR_ADISC;
@@ -593,6 +625,25 @@ lpfc_disc_illegal(struct lpfc_vport *vpo
 	return ndlp->nlp_state;
 }
 
+static uint32_t
+lpfc_cmpl_plogi_illegal(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+		  void *arg, uint32_t evt)
+{
+	/* This transition is only legal if we previously
+	 * rcv'ed a PLOGI. Since we don't want 2 discovery threads
+	 * working on the same NPortID, do nothing for this thread
+	 * to stop it.
+	 */
+	if (!(ndlp->nlp_flag & NLP_RCV_PLOGI)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+			 "0253 Illegal State Transition: node x%x "
+			 "event x%x, state x%x Data: x%x x%x\n",
+			 ndlp->nlp_DID, evt, ndlp->nlp_state, ndlp->nlp_rpi,
+			 ndlp->nlp_flag);
+	}
+	return ndlp->nlp_state;
+}
+
 /* Start of Discovery State Machine routines */
 
 static uint32_t
@@ -604,11 +655,8 @@ lpfc_rcv_plogi_unused_node(struct lpfc_v
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	if (lpfc_rcv_plogi(vport, ndlp, cmdiocb)) {
-		ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 		return ndlp->nlp_state;
 	}
-	lpfc_drop_node(vport, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -617,7 +665,6 @@ lpfc_rcv_els_unused_node(struct lpfc_vpo
 			 void *arg, uint32_t evt)
 {
 	lpfc_issue_els_logo(vport, ndlp, 0);
-	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	return ndlp->nlp_state;
 }
 
@@ -632,7 +679,6 @@ lpfc_rcv_logo_unused_node(struct lpfc_vp
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(shost->host_lock);
 	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
-	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 
 	return ndlp->nlp_state;
 }
@@ -641,7 +687,6 @@ static uint32_t
 lpfc_cmpl_logo_unused_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	lpfc_drop_node(vport, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -649,7 +694,6 @@ static uint32_t
 lpfc_device_rm_unused_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
-	lpfc_drop_node(vport, ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -864,7 +908,7 @@ out:
 
 	/* Free this node since the driver cannot login or has the wrong
 	   sparm */
-	lpfc_drop_node(vport, ndlp);
+	lpfc_nlp_not_used(ndlp);
 	return NLP_STE_FREED_NODE;
 }
 
@@ -1195,8 +1239,8 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		 * retry discovery.
 		 */
 		if (mb->mbxStatus == MBXERR_RPI_FULL) {
-			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 			return ndlp->nlp_state;
 		}
 
@@ -1376,7 +1420,7 @@ out:
 		lpfc_issue_els_logo(vport, ndlp, 0);
 
 		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		return ndlp->nlp_state;
 	}
 
@@ -1751,7 +1795,7 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_vpo
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
-		lpfc_drop_node(vport, ndlp);
+		lpfc_nlp_not_used(ndlp);
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;
@@ -1966,7 +2010,7 @@ static uint32_t (*lpfc_disc_action[NLP_S
 	lpfc_rcv_padisc_reglogin_issue,	/* RCV_ADISC       */
 	lpfc_rcv_padisc_reglogin_issue,	/* RCV_PDISC       */
 	lpfc_rcv_prlo_reglogin_issue,	/* RCV_PRLO        */
-	lpfc_disc_illegal,		/* CMPL_PLOGI      */
+	lpfc_cmpl_plogi_illegal,	/* CMPL_PLOGI      */
 	lpfc_disc_illegal,		/* CMPL_PRLI       */
 	lpfc_disc_illegal,		/* CMPL_LOGO       */
 	lpfc_disc_illegal,		/* CMPL_ADISC      */
@@ -1980,7 +2024,7 @@ static uint32_t (*lpfc_disc_action[NLP_S
 	lpfc_rcv_padisc_prli_issue,	/* RCV_ADISC       */
 	lpfc_rcv_padisc_prli_issue,	/* RCV_PDISC       */
 	lpfc_rcv_prlo_prli_issue,	/* RCV_PRLO        */
-	lpfc_disc_illegal,		/* CMPL_PLOGI      */
+	lpfc_cmpl_plogi_illegal,	/* CMPL_PLOGI      */
 	lpfc_cmpl_prli_prli_issue,	/* CMPL_PRLI       */
 	lpfc_disc_illegal,		/* CMPL_LOGO       */
 	lpfc_disc_illegal,		/* CMPL_ADISC      */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-10-27 10:45:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-10-27 13:06:59.000000000 -0400
@@ -445,7 +445,6 @@ int
 lpfc_vport_delete(struct fc_vport *fc_vport)
 {
 	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_nodelist *next_ndlp;
 	struct Scsi_Host *shost = (struct Scsi_Host *) fc_vport->shost;
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
@@ -531,23 +530,20 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	}
 
 skip_logo:
+	lpfc_cleanup(vport);
 	lpfc_sli_host_down(vport);
 
-	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		lpfc_disc_state_machine(vport, ndlp, NULL,
-					     NLP_EVT_DEVICE_RECOVERY);
-		lpfc_disc_state_machine(vport, ndlp, NULL,
-					     NLP_EVT_DEVICE_RM);
-	}
-
 	lpfc_stop_vport_timers(vport);
 	lpfc_unreg_all_rpis(vport);
-	lpfc_unreg_default_rpis(vport);
-	/*
-	 * Completion of unreg_vpi (lpfc_mbx_cmpl_unreg_vpi) does the
-	 * scsi_host_put() to release the vport.
-	 */
-	lpfc_mbx_unreg_vpi(vport);
+
+	if (!(phba->pport->load_flag & FC_UNLOADING)) {
+		lpfc_unreg_default_rpis(vport);
+		/*
+		 * Completion of unreg_vpi (lpfc_mbx_cmpl_unreg_vpi)
+		 * does the scsi_host_put() to release the vport.
+		 */
+		lpfc_mbx_unreg_vpi(vport);
+	}
 
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;


