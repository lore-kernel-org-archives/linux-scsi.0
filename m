From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/10] lpfc 8.2.4 : Miscellaneous Discovery/ELS Fixes
Date: Fri, 11 Jan 2008 01:52:36 -0500
Message-ID: <1200034356.27954.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51497 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYAKGwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:52:41 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6qeHF021630
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:52:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Miscellaneous Discovery/ELS Fixes:
- Delay free's of ELS requests if adapter reject conditions
- Fix concurrent PLOGI vs ADISC state handling
- Add retry mechanism for GFF_ID
- Correct some illegal state transitions around RSCN timeouts
- Fix missing return in FAN handling

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-01-11 00:49:11.000000000 -0500
@@ -89,6 +89,7 @@ int lpfc_check_sparm(struct lpfc_vport *
 		     struct serv_parm *, uint32_t);
 int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_more_plogi(struct lpfc_vport *);
+void lpfc_more_adisc(struct lpfc_vport *);
 void lpfc_end_rscn(struct lpfc_vport *);
 int lpfc_els_chk_latt(struct lpfc_vport *);
 int lpfc_els_abort_flogi(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 00:49:11.000000000 -0500
@@ -426,6 +426,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 
 	lpfc_set_disctmo(vport);
 	vport->num_disc_nodes = 0;
+	vport->fc_ns_retry = 0;
 

 	list_add_tail(&head, &mp->list);
@@ -506,7 +507,17 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 						Did, vport->fc_flag,
 						vport->fc_rscn_id_cnt);
 
-						if (lpfc_ns_cmd(vport,
+						/* This NPortID was previously
+						 * a FCP target, * Don't even
+						 * bother to send GFF_ID.
+						 */
+						ndlp = lpfc_findnode_did(vport,
+							Did);
+						if (ndlp && (ndlp->nlp_type &
+							NLP_FCP_TARGET))
+							lpfc_setup_disc_node
+								(vport, Did);
+						else if (lpfc_ns_cmd(vport,
 							SLI_CTNS_GFF_ID,
 							0, Did) == 0)
 							vport->num_disc_nodes++;
@@ -554,7 +565,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	struct lpfc_dmabuf *outp;
 	struct lpfc_sli_ct_request *CTrsp;
 	struct lpfc_nodelist *ndlp;
-	int rc;
+	int rc, retry;
 
 	/* First save ndlp, before we overwrite it */
 	ndlp = cmdiocb->context_un.ndlp;
@@ -585,14 +596,35 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	if (irsp->ulpStatus) {
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
-			if ((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
-				(irsp->un.ulpWord[4] != IOERR_NO_RESOURCES))
+			retry = 1;
+			if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
+				switch (irsp->un.ulpWord[4]) {
+				case IOERR_NO_RESOURCES:
+					/* We don't increment the retry
+					 * count for this case.
+					 */
+					break;
+				case IOERR_LINK_DOWN:
+				case IOERR_SLI_ABORTED:
+				case IOERR_SLI_DOWN:
+					retry = 0;
+					break;
+				default:
+					vport->fc_ns_retry++;
+				}
+			}
+			else
 				vport->fc_ns_retry++;
-			/* CT command is being retried */
-			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
+
+			if (retry) {
+				/* CT command is being retried */
+				rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
 					 vport->fc_ns_retry, 0);
-			if (rc == 0)
-				goto out;
+				if (rc == 0) {
+					/* success */
+					goto out;
+				}
+			}
 		}
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -698,7 +730,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
 	struct lpfc_dmabuf *inp = (struct lpfc_dmabuf *) cmdiocb->context1;
 	struct lpfc_dmabuf *outp = (struct lpfc_dmabuf *) cmdiocb->context2;
 	struct lpfc_sli_ct_request *CTrsp;
-	int did;
+	int did, rc, retry;
 	uint8_t fbits;
 	struct lpfc_nodelist *ndlp;
 
@@ -729,6 +761,39 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
 		}
 	}
 	else {
+		/* Check for retry */
+		if (cmdiocb->retry < LPFC_MAX_NS_RETRY) {
+			retry = 1;
+			if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
+				switch (irsp->un.ulpWord[4]) {
+				case IOERR_NO_RESOURCES:
+					/* We don't increment the retry
+					 * count for this case.
+					 */
+					break;
+				case IOERR_LINK_DOWN:
+				case IOERR_SLI_ABORTED:
+				case IOERR_SLI_DOWN:
+					retry = 0;
+					break;
+				default:
+					cmdiocb->retry++;
+				}
+			}
+			else
+				cmdiocb->retry++;
+
+			if (retry) {
+				/* CT command is being retried */
+				rc = lpfc_ns_cmd(vport, SLI_CTNS_GFF_ID,
+					 cmdiocb->retry, did);
+				if (rc == 0) {
+					/* success */
+					lpfc_ct_free_iocb(phba, cmdiocb);
+					return;
+				}
+			}
+		}
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "0267 NameServer GFF Rsp "
 				 "x%x Error (%d %d) Data: x%x x%x\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-01-11 00:49:11.000000000 -0500
@@ -783,6 +783,8 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 {
 	struct lpfc_vport    *vport = ndlp->vport;
 	struct lpfc_nodelist *new_ndlp;
+	struct lpfc_rport_data *rdata;
+	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t rc;
@@ -819,6 +821,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	lpfc_unreg_rpi(vport, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
 	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
+
+	if (ndlp->nlp_flag & NLP_NPR_2B_DISC)
+		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
 
 	/* Move this back to NPR state */
@@ -826,6 +833,20 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		/* The new_ndlp is replacing ndlp totally, so we need
 		 * to put ndlp on UNUSED list and try to free it.
 		 */
+
+		/* Fix up the rport accordingly */
+		rport =  ndlp->rport;
+		if (rport) {
+			rdata = rport->dd_data;
+			if (rdata->pnode == ndlp) {
+				lpfc_nlp_put(ndlp);
+				ndlp->rport = NULL;
+				rdata->pnode = lpfc_nlp_get(new_ndlp);
+				new_ndlp->rport = rport;
+			}
+			new_ndlp->nlp_type = ndlp->nlp_type;
+		}
+
 		lpfc_drop_node(vport, ndlp);
 	}
 	else {
@@ -1149,7 +1170,7 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	return 0;
 }
 
-static void
+void
 lpfc_more_adisc(struct lpfc_vport *vport)
 {
 	int sentadisc;
@@ -2100,8 +2121,35 @@ lpfc_els_free_iocb(struct lpfc_hba *phba
 	}
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
 	if (elsiocb->context2) {
-		buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
-		lpfc_els_free_data(phba, buf_ptr1);
+		if (elsiocb->iocb_flag & LPFC_DELAY_MEM_FREE) {
+			/* Firmware could still be in progress of DMAing
+			 * payload, so don't free data buffer till after
+			 * a hbeat.
+			 */
+			elsiocb->iocb_flag &= ~LPFC_DELAY_MEM_FREE;
+			buf_ptr = elsiocb->context2;
+			elsiocb->context2 = NULL;
+			if (buf_ptr) {
+				buf_ptr1 = NULL;
+				spin_lock_irq(&phba->hbalock);
+				if (!list_empty(&buf_ptr->list)) {
+					list_remove_head(&buf_ptr->list,
+						buf_ptr1, struct lpfc_dmabuf,
+						list);
+					INIT_LIST_HEAD(&buf_ptr1->list);
+					list_add_tail(&buf_ptr1->list,
+						&phba->elsbuf);
+					phba->elsbuf_cnt++;
+				}
+				INIT_LIST_HEAD(&buf_ptr->list);
+				list_add_tail(&buf_ptr->list, &phba->elsbuf);
+				phba->elsbuf_cnt++;
+				spin_unlock_irq(&phba->hbalock);
+			}
+		} else {
+			buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
+			lpfc_els_free_data(phba, buf_ptr1);
+		}
 	}
 
 	if (elsiocb->context3) {
@@ -3027,6 +3075,8 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 
 	/* To process RSCN, first compare RSCN data with NameServer */
 	vport->fc_ns_retry = 0;
+	vport->num_disc_nodes = 0;
+
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
 	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		/* Good ndlp, issue CT Request to NameServer */
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-01-11 00:49:11.000000000 -0500
@@ -583,6 +583,11 @@ struct lpfc_hba {
 	atomic_t slow_ring_trc_cnt;
 #endif
 
+	/* Used for deferred freeing of ELS data buffers */
+	struct list_head elsbuf;
+	int elsbuf_cnt;
+	int elsbuf_prev_cnt;
+
 	uint8_t temp_sensor_support;
 	/* Fields used for heart beat. */
 	unsigned long last_completion_time;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-11 00:49:11.000000000 -0500
@@ -2564,6 +2564,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		}
 		if (vport->port_state != LPFC_FLOGI) {
 			lpfc_initial_flogi(vport);
+			return;
 		}
 		break;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-01-11 00:49:11.000000000 -0500
@@ -547,8 +547,10 @@ void
 lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *pmboxq;
+	struct lpfc_dmabuf *buf_ptr;
 	int retval;
 	struct lpfc_sli *psli = &phba->sli;
+	LIST_HEAD(completions);
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 		(phba->pport->load_flag & FC_UNLOADING) ||
@@ -575,6 +577,24 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	}
 	spin_unlock_irq(&phba->pport->work_port_lock);
 
+	if (phba->elsbuf_cnt &&
+		(phba->elsbuf_cnt == phba->elsbuf_prev_cnt)) {
+		spin_lock_irq(&phba->hbalock);
+		list_splice_init(&phba->elsbuf, &completions);
+		phba->elsbuf_cnt = 0;
+		phba->elsbuf_prev_cnt = 0;
+		spin_unlock_irq(&phba->hbalock);
+
+		while (!list_empty(&completions)) {
+			list_remove_head(&completions, buf_ptr,
+				struct lpfc_dmabuf, list);
+			lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
+			kfree(buf_ptr);
+		}
+	}
+	phba->elsbuf_prev_cnt = phba->elsbuf_cnt;
+
+
 	/* If there is no heart beat outstanding, issue a heartbeat command */
 	if (!phba->hb_outstanding) {
 		pmboxq = mempool_alloc(phba->mbox_mem_pool,GFP_KERNEL);
@@ -1999,6 +2019,9 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	/* Initialize list of fabric iocbs */
 	INIT_LIST_HEAD(&phba->fabric_iocb_list);
 
+	/* Initialize list to save ELS buffers */
+	INIT_LIST_HEAD(&phba->elsbuf);
+
 	vport = lpfc_create_port(phba, phba->brd_no, &phba->pcidev->dev);
 	if (!vport)
 		goto out_kthread_stop;
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-11-09 15:54:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-01-11 00:49:11.000000000 -0500
@@ -442,7 +442,27 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
-				if (vport->num_disc_nodes) {
+
+			if ((ndlp->nlp_flag & NLP_ADISC_SND) &&
+				(vport->num_disc_nodes)) {
+				/* Check to see if there are more
+				 * ADISCs to be sent
+				 */
+				lpfc_more_adisc(vport);
+
+				if ((vport->num_disc_nodes == 0) &&
+					(vport->fc_npr_cnt))
+					lpfc_els_disc_plogi(vport);
+
+				if (vport->num_disc_nodes == 0) {
+					spin_lock_irq(shost->host_lock);
+					vport->fc_flag &= ~FC_NDISC_ACTIVE;
+					spin_unlock_irq(shost->host_lock);
+					lpfc_can_disctmo(vport);
+					lpfc_end_rscn(vport);
+				}
+			}
+			else if (vport->num_disc_nodes) {
 				/* Check to see if there are more
 				 * PLOGIs to be sent
 				 */
@@ -813,6 +833,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 			    uint32_t evt)
 {
 	struct lpfc_hba    *phba = vport->phba;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_iocbq  *cmdiocb, *rspiocb;
 	struct lpfc_dmabuf *pcmd, *prsp, *mp;
 	uint32_t *lp;
@@ -930,11 +951,27 @@ out:
 				 "0261 Cannot Register NameServer login\n");
 	}
 
+	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_DEFER_RM;
+	spin_unlock_irq(shost->host_lock);
 	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
+lpfc_cmpl_logo_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+			   void *arg, uint32_t evt)
+{
+	return ndlp->nlp_state;
+}
+
+static uint32_t
+lpfc_cmpl_reglogin_plogi_issue(struct lpfc_vport *vport,
+	struct lpfc_nodelist *ndlp, void *arg, uint32_t evt)
+{
+	return ndlp->nlp_state;
+}
+
+static uint32_t
 lpfc_device_rm_plogi_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
@@ -2006,9 +2043,9 @@ static uint32_t (*lpfc_disc_action[NLP_S
 	lpfc_rcv_els_plogi_issue,	/* RCV_PRLO        */
 	lpfc_cmpl_plogi_plogi_issue,	/* CMPL_PLOGI      */
 	lpfc_disc_illegal,		/* CMPL_PRLI       */
-	lpfc_disc_illegal,		/* CMPL_LOGO       */
+	lpfc_cmpl_logo_plogi_issue,	/* CMPL_LOGO       */
 	lpfc_disc_illegal,		/* CMPL_ADISC      */
-	lpfc_disc_illegal,		/* CMPL_REG_LOGIN  */
+	lpfc_cmpl_reglogin_plogi_issue,/* CMPL_REG_LOGIN  */
 	lpfc_device_rm_plogi_issue,	/* DEVICE_RM       */
 	lpfc_device_recov_plogi_issue,	/* DEVICE_RECOVERY */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-12-17 13:51:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 00:49:11.000000000 -0500
@@ -1147,6 +1147,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 						IOSTAT_LOCAL_REJECT;
 					saveq->iocb.un.ulpWord[4] =
 						IOERR_SLI_ABORTED;
+
+					/* Firmware could still be in progress
+					 * of DMAing payload, so don't free data
+					 * buffer till after a hbeat.
+					 */
+					saveq->iocb_flag |= LPFC_DELAY_MEM_FREE;
 				}
 			}
 			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
@@ -3281,6 +3287,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	LIST_HEAD(completions);
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
+	struct lpfc_dmabuf *buf_ptr;
 	LPFC_MBOXQ_t *pmb;
 	struct lpfc_iocbq *iocb;
 	IOCB_t *cmd = NULL;
@@ -3320,6 +3327,19 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 		}
 	}
 
+	spin_lock_irqsave(&phba->hbalock, flags);
+	list_splice_init(&phba->elsbuf, &completions);
+	phba->elsbuf_cnt = 0;
+	phba->elsbuf_prev_cnt = 0;
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	while (!list_empty(&completions)) {
+		list_remove_head(&completions, buf_ptr,
+			struct lpfc_dmabuf, list);
+		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
+		kfree(buf_ptr);
+	}
+
 	/* Return any active mbox cmds */
 	del_timer_sync(&psli->mbox_tmo);
 	spin_lock_irqsave(&phba->hbalock, flags);
@@ -3490,6 +3510,12 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			pring->txcmplq_cnt--;
 			spin_unlock_irq(&phba->hbalock);
 
+			/* Firmware could still be in progress of DMAing
+			 * payload, so don't free data buffer till after
+			 * a hbeat.
+			 */
+			abort_iocb->iocb_flag |= LPFC_DELAY_MEM_FREE;
+
 			abort_iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 			abort_iocb->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
 			abort_iocb->iocb.un.ulpWord[4] = IOERR_SLI_ABORTED;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-11-09 15:54:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2008-01-11 00:49:11.000000000 -0500
@@ -44,6 +44,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_FCP		4	/* FCP command -- iocbq in scsi_buf */
 #define LPFC_DRIVER_ABORTED	8	/* driver aborted this request */
 #define LPFC_IO_FABRIC		0x10	/* Iocb send using fabric scheduler */
+#define LPFC_DELAY_MEM_FREE	0x20    /* Defer free'ing of FC data */
 
 	uint8_t abort_count;
 	uint8_t rsvd2;


