From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/10] lpfc 8.2.4 : Rework misplaced reference taking on
	node structure
Date: Fri, 11 Jan 2008 01:53:27 -0500
Message-ID: <1200034407.27954.31.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51549 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYAKGxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:53:36 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6rYe5021680
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:53:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Rework misplaced reference taking on node structure 

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 01:25:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 01:30:20.000000000 -0500
@@ -561,7 +561,6 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	if (vport->load_flag & FC_UNLOADING)
 		goto out;
 
-
 	if (lpfc_els_chk_latt(vport) || lpfc_error_lost_link(irsp)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0216 Link event during NS query\n");
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-01-11 01:04:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-01-11 01:30:20.000000000 -0500
@@ -120,12 +120,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (pcmd)
 		pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pcmd->phys);
-	if (!pcmd || !pcmd->virt) {
-		kfree(pcmd);
-
-		lpfc_sli_release_iocbq(phba, elsiocb);
-		return NULL;
-	}
+	if (!pcmd || !pcmd->virt)
+		goto els_iocb_free_pcmb_exit;
 
 	INIT_LIST_HEAD(&pcmd->list);
 
@@ -135,13 +131,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		if (prsp)
 			prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						     &prsp->phys);
-		if (!prsp || !prsp->virt) {
-			kfree(prsp);
-			lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
-			kfree(pcmd);
-			lpfc_sli_release_iocbq(phba, elsiocb);
-			return NULL;
-		}
+		if (!prsp || !prsp->virt)
+			goto els_iocb_free_prsp_exit;
 		INIT_LIST_HEAD(&prsp->list);
 	} else {
 		prsp = NULL;
@@ -152,15 +143,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 	if (pbuflist)
 		pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						 &pbuflist->phys);
-	if (!pbuflist || !pbuflist->virt) {
-		lpfc_sli_release_iocbq(phba, elsiocb);
-		lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
-		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
-		kfree(pcmd);
-		kfree(prsp);
-		kfree(pbuflist);
-		return NULL;
-	}
+	if (!pbuflist || !pbuflist->virt)
+		goto els_iocb_free_pbuf_exit;
 
 	INIT_LIST_HEAD(&pbuflist->list);
 
@@ -205,7 +189,10 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		bpl->tus.w = le32_to_cpu(bpl->tus.w);
 	}
 
+	/* prevent preparing iocb with NULL ndlp reference */
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
+	if (!elsiocb->context1)
+		goto els_iocb_free_pbuf_exit;
 	elsiocb->context2 = pcmd;
 	elsiocb->context3 = pbuflist;
 	elsiocb->retry = retry;
@@ -231,8 +218,20 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 				 cmdSize);
 	}
 	return elsiocb;
-}
 
+els_iocb_free_pbuf_exit:
+	lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
+	kfree(pbuflist);
+
+els_iocb_free_prsp_exit:
+	lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
+	kfree(prsp);
+
+els_iocb_free_pcmb_exit:
+	kfree(pcmd);
+	lpfc_sli_release_iocbq(phba, elsiocb);
+	return NULL;
+}
 
 static int
 lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
@@ -513,6 +512,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
+		/* One additional decrement on node reference count to
+		 * trigger the release of the node
+		 */
 		lpfc_nlp_put(ndlp);
 		goto out;
 	}
@@ -731,6 +733,9 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 	}
 
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
+		/* This decrement of reference count to node shall kick off
+		 * the release of the node.
+		 */
 		lpfc_nlp_put(ndlp);
 	}
 	return 1;
@@ -754,7 +759,11 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 		lpfc_dequeue_node(vport, ndlp);
 	}
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
+		/* decrement node reference count to trigger the release of
+		 * the node.
+		 */
 		lpfc_nlp_put(ndlp);
+		return 0;
 	}
 	return 1;
 }
@@ -1557,6 +1566,9 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 				     ndlp->nlp_DID, ELS_CMD_SCR);
 
 	if (!elsiocb) {
+		/* This will trigger the release of the node just
+		 * allocated
+		 */
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
@@ -1578,10 +1590,17 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 	phba->fc_stat.elsXmitSCR++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+		/* The additional lpfc_nlp_put will cause the following
+		 * lpfc_els_free_iocb routine to trigger the rlease of
+		 * the node.
+		 */
 		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+	/* This will cause the callback-function lpfc_cmpl_els_cmd to
+	 * trigger the release of node.
+	 */
 	lpfc_nlp_put(ndlp);
 	return 0;
 }
@@ -1613,6 +1632,9 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RNID);
 	if (!elsiocb) {
+		/* This will trigger the release of the node just
+		 * allocated
+		 */
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
@@ -1649,10 +1671,17 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	phba->fc_stat.elsXmitFARPR++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+		/* The additional lpfc_nlp_put will cause the following
+		 * lpfc_els_free_iocb routine to trigger the release of
+		 * the node.
+		 */
 		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+	/* This will cause the callback-function lpfc_cmpl_els_cmd to
+	 * trigger the release of the node.
+	 */
 	lpfc_nlp_put(ndlp);
 	return 0;
 }
@@ -1712,7 +1741,10 @@ lpfc_els_retry_delay(unsigned long ptr)
 		return;
 	}
 
-	evtp->evt_arg1  = ndlp;
+	/* We need to hold the node by incrementing the reference
+	 * count until the queued work is done
+	 */
+	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
 	evtp->evt       = LPFC_EVT_ELS_RETRY;
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	if (phba->work_wait)
@@ -2190,6 +2222,11 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 			 * thread, just unregister the RPI.
 			 */
 			lpfc_unreg_rpi(vport, ndlp);
+		} else {
+			/* Indicate the node has already released, should
+			 * not reference to it from within lpfc_els_free_iocb.
+			 */
+			cmdiocb->context1 = NULL;
 		}
 	}
 	lpfc_els_free_iocb(phba, cmdiocb);
@@ -2208,7 +2245,6 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	mempool_free(pmb, phba->mbox_mem_pool);
 	if (ndlp) {
 		lpfc_nlp_put(ndlp);
-
 		/* This is the end of the default RPI cleanup logic for this
 		 * ndlp. If no other discovery threads are using this ndlp.
 		 * we should free all resources associated with it.
@@ -2236,11 +2272,13 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
 
-	/* First determine if this is a LS_RJT cmpl */
+	/* First determine if this is a LS_RJT cmpl. Note, this callback
+	 * function can have cmdiocb->contest1 (ndlp) field set to NULL.
+	 */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
-	if (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT) {
-		/* A LS_RJT associated with Default RPI cleanup
-		 * has its own seperate code path.
+	if (ndlp && (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
+		/* A LS_RJT associated with Default RPI cleanup has its own
+		 * seperate code path.
 		 */
 		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
 			ls_rjt = 1;
@@ -2257,8 +2295,14 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
 		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			if (lpfc_nlp_not_used(ndlp))
+			if (lpfc_nlp_not_used(ndlp)) {
 				ndlp = NULL;
+				/* Indicate the node has already released,
+				 * should not reference to it from within
+				 * the routine lpfc_els_free_iocb.
+				 */
+				cmdiocb->context1 = NULL;
+			}
 		goto out;
 	}
 
@@ -2302,14 +2346,27 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 				ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 				ndlp->nlp_rpi);
 
-			if (lpfc_nlp_not_used(ndlp))
+			if (lpfc_nlp_not_used(ndlp)) {
 				ndlp = NULL;
+				/* Indicate node has already been released,
+				 * should not reference to it from within
+				 * the routine lpfc_els_free_iocb.
+				 */
+				cmdiocb->context1 = NULL;
+			}
 		} else {
 			/* Do not drop node for lpfc_els_abort'ed ELS cmds */
 			if (!lpfc_error_lost_link(irsp) &&
 			    ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				if (lpfc_nlp_not_used(ndlp))
+				if (lpfc_nlp_not_used(ndlp)) {
 					ndlp = NULL;
+					/* Indicate node has already been
+					 * released, should not reference
+					 * to it from within the routine
+					 * lpfc_els_free_iocb.
+					 */
+					cmdiocb->context1 = NULL;
+				}
 			}
 		}
 		mp = (struct lpfc_dmabuf *) mbox->context1;
@@ -2331,7 +2388,12 @@ out:
 		 * resources.
 		 */
 		if (ls_rjt)
-			lpfc_nlp_not_used(ndlp);
+			if (lpfc_nlp_not_used(ndlp))
+				/* Indicate node has already been released,
+				 * should not reference to it from within
+				 * the routine lpfc_els_free_iocb.
+				 */
+				cmdiocb->context1 = NULL;
 	}
 
 	lpfc_els_free_iocb(phba, cmdiocb);
@@ -3292,7 +3354,10 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
 				     lpfc_max_els_tries, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
+
+	/* Decrement the ndlp reference count from previous mbox command */
 	lpfc_nlp_put(ndlp);
+
 	if (!elsiocb)
 		return;
 
@@ -3375,11 +3440,13 @@ lpfc_els_rcv_rps(struct lpfc_vport *vpor
 			mbox->context2 = lpfc_nlp_get(ndlp);
 			mbox->vport = vport;
 			mbox->mbox_cmpl = lpfc_els_rsp_rps_acc;
-			if (lpfc_sli_issue_mbox (phba, mbox, MBX_NOWAIT)
+			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 				!= MBX_NOT_FINISHED)
 				/* Mbox completion will send ELS Response */
 				return 0;
-
+			/* Decrement reference count used for the failed mbox
+			 * command.
+			 */
 			lpfc_nlp_put(ndlp);
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
@@ -4284,7 +4351,6 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
 	spin_unlock_irq(shost->host_lock);
-	lpfc_nlp_put(ndlp);
 
 	if (mb->mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
@@ -4317,6 +4383,12 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 		else
 			lpfc_do_scr_ns_plogi(phba, vport);
 	}
+
+	/* Now, we decrement the ndlp reference count held for this
+	 * callback function
+	 */
+	lpfc_nlp_put(ndlp);
+
 	mempool_free(pmb, phba->mbox_mem_pool);
 	return;
 }
@@ -4336,26 +4408,29 @@ lpfc_register_new_vport(struct lpfc_hba 
 		mbox->mbox_cmpl = lpfc_cmpl_reg_new_vport;
 		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 		    == MBX_NOT_FINISHED) {
+			/* mailbox command not success, decrement ndlp
+			 * reference count for this command
+			 */
+			lpfc_nlp_put(ndlp);
 			mempool_free(mbox, phba->mbox_mem_pool);
-			spin_lock_irq(shost->host_lock);
-			vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
-			spin_unlock_irq(shost->host_lock);
 
-			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 				"0253 Register VPI: Can't send mbox\n");
+			goto mbox_err_exit;
 		}
 	} else {
-		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 				 "0254 Register VPI: no memory\n");
-
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
-		spin_unlock_irq(shost->host_lock);
-		lpfc_nlp_put(ndlp);
+		goto mbox_err_exit;
 	}
+	return;
+
+mbox_err_exit:
+	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+	spin_unlock_irq(shost->host_lock);
+	return;
 }
 
 static void
@@ -4436,7 +4511,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		else
 			lpfc_do_scr_ns_plogi(phba, vport);
 
-		lpfc_nlp_put(ndlp); /* Free Fabric ndlp for vports */
+		/* Unconditionaly kick off releasing fabric node for vports */
+		lpfc_nlp_put(ndlp);
 	}
 
 out:
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-11 01:04:18.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-01-11 01:30:20.000000000 -0500
@@ -149,7 +149,10 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 		return;
 
 	spin_lock_irq(&phba->hbalock);
-	evtp->evt_arg1  = ndlp;
+	/* We need to hold the node by incrementing the reference
+	 * count until this queued work is done
+	 */
+	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
 	evtp->evt       = LPFC_EVT_DEV_LOSS;
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	if (phba->work_wait)
@@ -300,12 +303,18 @@ lpfc_work_list_done(struct lpfc_hba *phb
 			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
 			lpfc_els_retry_delay_handler(ndlp);
 			free_evt = 0; /* evt is part of ndlp */
+			/* decrement the node reference count held
+			 * for this queued work
+			 */
+			lpfc_nlp_put(ndlp);
 			break;
 		case LPFC_EVT_DEV_LOSS:
 			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
-			lpfc_nlp_get(ndlp);
 			lpfc_dev_loss_tmo_handler(ndlp);
 			free_evt = 0;
+			/* decrement the node reference count held for
+			 * this queued work
+			 */
 			lpfc_nlp_put(ndlp);
 			break;
 		case LPFC_EVT_ONLINE:
@@ -1176,6 +1185,9 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
+	/* decrement the node reference count held for this callback
+	 * function.
+	 */
 	lpfc_nlp_put(ndlp);
 
 	return;
@@ -1363,6 +1375,9 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 
 	if (mb->mbxStatus) {
 out:
+		/* decrement the node reference count held for this
+		 * callback function.
+		 */
 		lpfc_nlp_put(ndlp);
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
@@ -1414,6 +1429,9 @@ out:
 		goto out;
 	}
 
+	/* decrement the node reference count held for this
+	 * callback function.
+	 */
 	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
@@ -1661,13 +1679,14 @@ void
 lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	/*
-	 * Use of lpfc_drop_node and UNUSED list. lpfc_drop_node should
+	 * Use of lpfc_drop_node and UNUSED list: lpfc_drop_node should
 	 * be used if we wish to issue the "last" lpfc_nlp_put() to remove
-	 * the ndlp from the vport.  The ndlp resides on the UNUSED list
-	 * until ALL other outstanding threads have completed. Thus, if a
-	 * ndlp is on the UNUSED list already, we should never do another
-	 * lpfc_drop_node() on it.
+	 * the ndlp from the vport. The ndlp marked as UNUSED on the list
+	 * until ALL other outstanding threads have completed. We check
+	 * that the ndlp not already in the UNUSED state before we proceed.
 	 */
+	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+		return;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	lpfc_nlp_put(ndlp);
 	return;
@@ -2767,7 +2786,9 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	else
 		mod_timer(&vport->fc_fdmitmo, jiffies + HZ * 60);
 
-				/* Mailbox took a reference to the node */
+	/* decrement the node reference count held for this callback
+	 * function.
+	 */
 	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-01-11 01:30:20.000000000 -0500
@@ -922,6 +922,9 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 					   NLP_STE_REG_LOGIN_ISSUE);
 			return ndlp->nlp_state;
 		}
+		/* decrement node reference count to the failed mbox
+		 * command
+		 */
 		lpfc_nlp_put(ndlp);
 		mp = (struct lpfc_dmabuf *) mbox->context1;
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 01:25:42.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 01:30:20.000000000 -0500
@@ -2605,7 +2605,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 					"1806 Mbox x%x failed. No vport\n",
 					pmbox->mb.mbxCommand);
 			dump_stack();
-			return MBXERR_ERROR;
+			return MBX_NOT_FINISHED;
 		}
 	}
 


