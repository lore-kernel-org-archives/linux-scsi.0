From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/9] lpfc 8.2.3 : Remove flawed MBX_STOP_IOCB logic
Date: Sat, 27 Oct 2007 13:37:25 -0400
Message-ID: <1193506645.8770.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46333 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbXJ0RhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:20 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbJkI021357
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove flawed MBX_STOP_IOCB logic

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 10:38:49.000000000 -0400
@@ -249,7 +249,7 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	mbox->vport = vport;
 
-	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT | MBX_STOP_IOCB);
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto fail_free_mbox;
 
@@ -265,7 +265,7 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 	mbox->vport = vport;
 	mbox->context2 = lpfc_nlp_get(ndlp);
 
-	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT | MBX_STOP_IOCB);
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto fail_issue_reg_login;
 
@@ -429,8 +429,7 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vp
 
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->vport = vport;
-		rc = lpfc_sli_issue_mbox(phba, mbox,
-					 MBX_NOWAIT | MBX_STOP_IOCB);
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 			goto fail;
@@ -2150,8 +2149,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 				lpfc_nlp_set_state(vport, ndlp,
 					   NLP_STE_REG_LOGIN_ISSUE);
 			}
-			if (lpfc_sli_issue_mbox(phba, mbox,
-						(MBX_NOWAIT | MBX_STOP_IOCB))
+			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 			    != MBX_NOT_FINISHED) {
 				goto out;
 			}
@@ -3022,8 +3020,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 			mbox->mb.un.varInitLnk.lipsr_AL_PA = 0;
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			mbox->vport = vport;
-			rc = lpfc_sli_issue_mbox
-				(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
+			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 			lpfc_set_loopback_flag(phba);
 			if (rc == MBX_NOT_FINISHED) {
 				mempool_free(mbox, phba->mbox_mem_pool);
@@ -3223,8 +3220,8 @@ lpfc_els_rcv_rps(struct lpfc_vport *vpor
 			mbox->context2 = lpfc_nlp_get(ndlp);
 			mbox->vport = vport;
 			mbox->mbox_cmpl = lpfc_els_rsp_rps_acc;
-			if (lpfc_sli_issue_mbox (phba, mbox,
-			    (MBX_NOWAIT | MBX_STOP_IOCB)) != MBX_NOT_FINISHED)
+			if (lpfc_sli_issue_mbox (phba, mbox, MBX_NOWAIT)
+				!= MBX_NOT_FINISHED)
 				/* Mbox completion will send ELS Response */
 				return 0;
 
@@ -4162,8 +4159,7 @@ lpfc_register_new_vport(struct lpfc_hba 
 		mbox->vport = vport;
 		mbox->context2 = lpfc_nlp_get(ndlp);
 		mbox->mbox_cmpl = lpfc_cmpl_reg_new_vport;
-		if (lpfc_sli_issue_mbox(phba, mbox,
-					MBX_NOWAIT | MBX_STOP_IOCB)
+		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 		    == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 			vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 10:38:49.000000000 -0400
@@ -412,7 +412,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 	status >>= (4*LPFC_ELS_RING);
 	if ((status & HA_RXMASK)
 		|| (pring->flag & LPFC_DEFERRED_RING_EVENT)) {
-		if (pring->flag & LPFC_STOP_IOCB_MASK) {
+		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 		} else {
 			lpfc_sli_handle_slow_ring_event(phba, pring,
@@ -629,7 +629,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		lpfc_unreg_did(phba, 0xffff, 0xffffffff, mb);
 		mb->vport = vport;
 		mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		if (lpfc_sli_issue_mbox(phba, mb, (MBX_NOWAIT | MBX_STOP_IOCB))
+		if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
 		    == MBX_NOT_FINISHED) {
 			mempool_free(mb, phba->mbox_mem_pool);
 		}
@@ -643,8 +643,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 			lpfc_config_link(phba, mb);
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			mb->vport = vport;
-			if (lpfc_sli_issue_mbox(phba, mb,
-						(MBX_NOWAIT | MBX_STOP_IOCB))
+			if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
 			    == MBX_NOT_FINISHED) {
 				mempool_free(mb, phba->mbox_mem_pool);
 			}
@@ -1022,8 +1021,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		lpfc_read_sparam(phba, sparam_mbox, 0);
 		sparam_mbox->vport = vport;
 		sparam_mbox->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
-		rc = lpfc_sli_issue_mbox(phba, sparam_mbox,
-				    (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, sparam_mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			mp = (struct lpfc_dmabuf *) sparam_mbox->context1;
 			lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -1040,8 +1038,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		lpfc_config_link(phba, cfglink_mbox);
 		cfglink_mbox->vport = vport;
 		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox,
-				    (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
 		if (rc != MBX_NOT_FINISHED)
 			return;
 		mempool_free(cfglink_mbox, phba->mbox_mem_pool);
@@ -1219,7 +1216,7 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vp
 	lpfc_unreg_vpi(phba, vport->vpi, mbox);
 	mbox->vport = vport;
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_unreg_vpi;
-	rc = lpfc_sli_issue_mbox(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
 				 "1800 Could not issue unreg_vpi\n");
@@ -1868,8 +1865,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 			lpfc_unreg_login(phba, vport->vpi, ndlp->nlp_rpi, mbox);
 			mbox->vport = vport;
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			rc = lpfc_sli_issue_mbox(phba, mbox,
-						 (MBX_NOWAIT | MBX_STOP_IOCB));
+			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 			if (rc == MBX_NOT_FINISHED)
 				mempool_free(mbox, phba->mbox_mem_pool);
 		}
@@ -1892,8 +1888,7 @@ lpfc_unreg_all_rpis(struct lpfc_vport *v
 		lpfc_unreg_login(phba, vport->vpi, 0xffff, mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, mbox,
-					 (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
@@ -1912,8 +1907,7 @@ lpfc_unreg_default_rpis(struct lpfc_vpor
 		lpfc_unreg_did(phba, vport->vpi, 0xffffffff, mbox);
 		mbox->vport = vport;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, mbox,
-					 (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
 					 "1815 Could not issue "
@@ -2220,8 +2214,7 @@ lpfc_issue_clear_la(struct lpfc_hba *phb
 		lpfc_clear_la(phba, mbox);
 		mbox->mbox_cmpl = lpfc_mbx_cmpl_clear_la;
 		mbox->vport = vport;
-		rc = lpfc_sli_issue_mbox(phba, mbox, (MBX_NOWAIT |
-						      MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 			lpfc_disc_flush_list(vport);
@@ -2244,8 +2237,7 @@ lpfc_issue_reg_vpi(struct lpfc_hba *phba
 		lpfc_reg_vpi(phba, vport->vpi, vport->fc_myDID, regvpimbox);
 		regvpimbox->mbox_cmpl = lpfc_mbx_cmpl_reg_vpi;
 		regvpimbox->vport = vport;
-		if (lpfc_sli_issue_mbox(phba, regvpimbox,
-					(MBX_NOWAIT | MBX_STOP_IOCB))
+		if (lpfc_sli_issue_mbox(phba, regvpimbox, MBX_NOWAIT)
 					== MBX_NOT_FINISHED) {
 			mempool_free(regvpimbox, phba->mbox_mem_pool);
 		}
@@ -2608,8 +2600,7 @@ lpfc_disc_timeout_handler(struct lpfc_vp
 		initlinkmbox->mb.un.varInitLnk.lipsr_AL_PA = 0;
 		initlinkmbox->vport = vport;
 		initlinkmbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, initlinkmbox,
-					 (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, initlinkmbox, MBX_NOWAIT);
 		lpfc_set_loopback_flag(phba);
 		if (rc == MBX_NOT_FINISHED)
 			mempool_free(initlinkmbox, phba->mbox_mem_pool);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:37:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:38:49.000000000 -0400
@@ -355,7 +355,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 
 	phba->link_state = LPFC_LINK_DOWN;
 
-	/* Only process IOCBs on ring 0 till hba_state is READY */
+	/* Only process IOCBs on ELS ring till hba_state is READY */
 	if (psli->ring[psli->extra_ring].cmdringaddr)
 		psli->ring[psli->extra_ring].flag |= LPFC_STOP_IOCB_EVENT;
 	if (psli->ring[psli->fcp_ring].cmdringaddr)
@@ -777,7 +777,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	lpfc_read_la(phba, pmb, mp);
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_la;
 	pmb->vport = vport;
-	rc = lpfc_sli_issue_mbox (phba, pmb, (MBX_NOWAIT | MBX_STOP_IOCB));
+	rc = lpfc_sli_issue_mbox (phba, pmb, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED)
 		goto lpfc_handle_latt_free_mbuf;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 10:38:49.000000000 -0400
@@ -343,8 +343,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 		lpfc_config_link(phba, mbox);
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->vport = vport;
-		rc = lpfc_sli_issue_mbox
-			(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
 		if (rc == MBX_NOT_FINISHED) {
 			mempool_free(mbox, phba->mbox_mem_pool);
 			goto out;
@@ -828,8 +827,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 		}
 		mbox->context2 = lpfc_nlp_get(ndlp);
 		mbox->vport = vport;
-		if (lpfc_sli_issue_mbox(phba, mbox,
-					(MBX_NOWAIT | MBX_STOP_IOCB))
+		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
 		    != MBX_NOT_FINISHED) {
 			lpfc_nlp_set_state(vport, ndlp,
 					   NLP_STE_REG_LOGIN_ISSUE);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:38:49.000000000 -0400
@@ -474,8 +474,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba *ph
 	if (pring->txq_cnt &&
 	    lpfc_is_link_up(phba) &&
 	    (pring->ringno != phba->sli.fcp_ring ||
-	     phba->sli.sli_flag & LPFC_PROCESS_LA) &&
-	    !(pring->flag & LPFC_STOP_IOCB_MBX)) {
+	     phba->sli.sli_flag & LPFC_PROCESS_LA)) {
 
 		while ((iocb = lpfc_sli_next_iocb_slot(phba, pring)) &&
 		       (nextiocb = lpfc_sli_ringtx_get(phba, pring)))
@@ -490,31 +489,6 @@ lpfc_sli_resume_iocb(struct lpfc_hba *ph
 	return;
 }
 
-/* lpfc_sli_turn_on_ring is only called by lpfc_sli_handle_mb_event below */
-static void
-lpfc_sli_turn_on_ring(struct lpfc_hba *phba, int ringno)
-{
-	struct lpfc_pgp *pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[ringno] :
-		&phba->slim2p->mbx.us.s2.port[ringno];
-	unsigned long iflags;
-
-	/* If the ring is active, flag it */
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	if (phba->sli.ring[ringno].cmdringaddr) {
-		if (phba->sli.ring[ringno].flag & LPFC_STOP_IOCB_MBX) {
-			phba->sli.ring[ringno].flag &= ~LPFC_STOP_IOCB_MBX;
-			/*
-			 * Force update of the local copy of cmdGetInx
-			 */
-			phba->sli.ring[ringno].local_getidx
-				= le32_to_cpu(pgp->cmdGetInx);
-			lpfc_sli_resume_iocb(phba, &phba->sli.ring[ringno]);
-		}
-	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-}
-
 struct lpfc_hbq_entry *
 lpfc_sli_next_hbq_slot(struct lpfc_hba *phba, uint32_t hbqno)
 {
@@ -2590,21 +2564,6 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			return MBX_NOT_FINISHED;
 		}
 
-		/* Handle STOP IOCB processing flag. This is only meaningful
-		 * if we are not polling for mbox completion.
-		 */
-		if (flag & MBX_STOP_IOCB) {
-			flag &= ~MBX_STOP_IOCB;
-			/* Now flag each ring */
-			for (i = 0; i < psli->num_rings; i++) {
-				/* If the ring is active, flag it */
-				if (psli->ring[i].cmdringaddr) {
-					psli->ring[i].flag |=
-					    LPFC_STOP_IOCB_MBX;
-				}
-			}
-		}
-
 		/* Another mailbox command is still being processed, queue this
 		 * command to be processed later.
 		 */
@@ -2639,23 +2598,6 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 		return MBX_BUSY;
 	}
 
-	/* Handle STOP IOCB processing flag. This is only meaningful
-	 * if we are not polling for mbox completion.
-	 */
-	if (flag & MBX_STOP_IOCB) {
-		flag &= ~MBX_STOP_IOCB;
-		if (flag == MBX_NOWAIT) {
-			/* Now flag each ring */
-			for (i = 0; i < psli->num_rings; i++) {
-				/* If the ring is active, flag it */
-				if (psli->ring[i].cmdringaddr) {
-					psli->ring[i].flag |=
-					    LPFC_STOP_IOCB_MBX;
-				}
-			}
-		}
-	}
-
 	psli->sli_flag |= LPFC_SLI_MBOX_ACTIVE;
 
 	/* If we are not polling, we MUST be in SLI2 mode */
@@ -2898,9 +2840,9 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 
 	/*
 	 * Check to see if we are blocking IOCB processing because of a
-	 * outstanding mbox command.
+	 * outstanding event.
 	 */
-	if (unlikely(pring->flag & LPFC_STOP_IOCB_MBX))
+	if (unlikely(pring->flag & LPFC_STOP_IOCB_EVENT))
 		goto iocb_busy;
 
 	if (unlikely(phba->link_state == LPFC_LINK_DOWN)) {
@@ -3847,7 +3789,6 @@ lpfc_intr_handler(int irq, void *dev_id)
 	uint32_t ha_copy;
 	uint32_t work_ha_copy;
 	unsigned long status;
-	int i;
 	uint32_t control;
 
 	MAILBOX_t *mbox, *pmbox;
@@ -4066,10 +4007,6 @@ send_current_mbox:
 					lpfc_mbox_cmpl_put(phba, pmb);
 					goto send_next_mbox;
 				}
-			} else {
-				/* Turn on IOCB processing */
-				for (i = 0; i < phba->sli.num_rings; i++)
-					lpfc_sli_turn_on_ring(phba, i);
 			}
 
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-10-27 10:38:49.000000000 -0400
@@ -92,8 +92,6 @@ typedef struct lpfcMboxq {
 #define MBX_POLL        1	/* poll mailbox till command done, then
 				   return */
 #define MBX_NOWAIT      2	/* issue command then return immediately */
-#define MBX_STOP_IOCB   4	/* Stop iocb processing till mbox cmds
-				   complete */
 
 #define LPFC_MAX_RING_MASK  4	/* max num of rctl/type masks allowed per
 				   ring */
@@ -129,9 +127,7 @@ struct lpfc_sli_ring {
 	uint16_t flag;		/* ring flags */
 #define LPFC_DEFERRED_RING_EVENT 0x001	/* Deferred processing a ring event */
 #define LPFC_CALL_RING_AVAILABLE 0x002	/* indicates cmd was full */
-#define LPFC_STOP_IOCB_MBX       0x010	/* Stop processing IOCB cmds mbox */
 #define LPFC_STOP_IOCB_EVENT     0x020	/* Stop processing IOCB cmds event */
-#define LPFC_STOP_IOCB_MASK      0x030	/* Stop processing IOCB cmds mask */
 	uint16_t abtsiotag;	/* tracks next iotag to use for ABTS */
 
 	uint32_t local_getidx;   /* last available cmd index (from cmdGetInx) */


