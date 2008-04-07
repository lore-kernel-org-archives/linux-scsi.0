From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/4] lpfc 8.2.6 : Multiple discovery fixes
Date: Mon, 07 Apr 2008 10:15:56 -0400
Message-ID: <1207577756.28169.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33281 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYDGOP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 10:15:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m37EFuHp010274
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 07:15:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Multiple Discovery Fixes:
- Fix race on discovery due to link events coinciding with vport_delete.
- Use NLP_FABRIC state to filter out switch-based pseudo initiators that
   reuse the same WWNs.
- Correct erroneous setting of DID=0 in lpfc_matchdid()
- Correct extra reference count that was in the lookup path for the
  remoteid from an unsolicited ELS.
- Correct double-free bug in els abort path.
- Correct FDMI server discovery logic for switch that return a WWN of 0.
- Fix bugs in ndlp mgmt when a node changes address
- Correct bug that did not delete RSCNs for vports upon link transitions
- Fix "0216 Link event during NS query" error which pops up when vports
  are swapped to different switch ports.
- Add sanity checks on ndlp structures
- Fix devloss log message to dump WWN correctly
- Hold off mgmt commands that were interferring with discovery mailbox cmds
- Remove unnecessary FC_ESTABLISH_LINK logic.
- Correct some race conditions in the worker thread, resulting in devloss:
  - Clear the work_port_events field before handling the work port events
  - Clear the deferred ring event before handling a deferred ring event
  - Hold the hba lock when waking up the work thread
  - Send an acc for the rscn even when we aren't going to handle it
- Fix locking behavior that was not properly protecting the ACTIVE flag,
  thus allowing mailbox command order to shift.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    3 -
 lpfc_attr.c      |    6 ++-
 lpfc_ct.c        |   46 ++++++++-------------------
 lpfc_debugfs.c   |    2 +
 lpfc_els.c       |   85 +++++++++++++++++++++++++++++++-------------------
 lpfc_hbadisc.c   |   41 ++++++++++++------------
 lpfc_init.c      |   64 ++++++-------------------------------
 lpfc_nportdisc.c |   40 +++++++++++++----------
 lpfc_scsi.c      |   26 ++++++++-------
 lpfc_sli.c       |   93 +++++++++++++++++++++++++++++++++++--------------------
 lpfc_vport.c     |    3 +
 11 files changed, 208 insertions(+), 201 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-04-07 09:09:01.000000000 -0400
@@ -1962,7 +1962,11 @@ sysfs_mbox_read(struct kobject *kobj, st
 
 		phba->sysfs_mbox.mbox->vport = vport;
 
-		if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
+		/* Don't allow mailbox commands to be sent when blocked
+		 * or when in the middle of discovery
+		 */
+		if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO ||
+		    vport->fc_flag & FC_NDISC_ACTIVE) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return  -EAGAIN;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-04-07 09:09:00.000000000 -0400
@@ -438,7 +438,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 				    (!(vport->ct_flags & FC_CT_RFF_ID)) ||
 				    (!vport->cfg_restrict_login)) {
 					ndlp = lpfc_setup_disc_node(vport, Did);
-					if (ndlp) {
+					if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 						lpfc_debugfs_disc_trc(vport,
 						LPFC_DISC_TRC_CT,
 						"Parse GID_FTrsp: "
@@ -543,7 +543,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	struct lpfc_dmabuf *outp;
 	struct lpfc_sli_ct_request *CTrsp;
 	struct lpfc_nodelist *ndlp;
-	int rc, retry;
+	int rc;
 
 	/* First save ndlp, before we overwrite it */
 	ndlp = cmdiocb->context_un.ndlp;
@@ -563,45 +563,29 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	if (vport->load_flag & FC_UNLOADING)
 		goto out;
 
-	if (lpfc_els_chk_latt(vport) || lpfc_error_lost_link(irsp)) {
+	if (lpfc_els_chk_latt(vport)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0216 Link event during NS query\n");
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
-
+	if (lpfc_error_lost_link(irsp)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "0226 NS query failed due to link event\n");
+		goto out;
+	}
 	if (irsp->ulpStatus) {
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
-			retry = 1;
-			if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-				switch (irsp->un.ulpWord[4]) {
-				case IOERR_NO_RESOURCES:
-					/* We don't increment the retry
-					 * count for this case.
-					 */
-					break;
-				case IOERR_LINK_DOWN:
-				case IOERR_SLI_ABORTED:
-				case IOERR_SLI_DOWN:
-					retry = 0;
-					break;
-				default:
-					vport->fc_ns_retry++;
-				}
-			}
-			else
+			if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
+			    irsp->un.ulpWord[4] != IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 
-			if (retry) {
-				/* CT command is being retried */
-				rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
+			/* CT command is being retried */
+			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
 					 vport->fc_ns_retry, 0);
-				if (rc == 0) {
-					/* success */
-					goto out;
-				}
-			}
+			if (rc == 0)
+				goto out;
 		}
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -780,7 +764,7 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba 
 
 	/* This is a target port, unregistered port, or the GFF_ID failed */
 	ndlp = lpfc_setup_disc_node(vport, did);
-	if (ndlp) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0242 Process x%x GFF "
 				 "NameServer Rsp Data: x%x x%x x%x\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-04-07 09:08:24.000000000 -0400
@@ -503,6 +503,8 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
 			len +=  snprintf(buf+len, size-len, "FCP_INITIATOR ");
+		len += snprintf(buf+len, size-len, "usgmap:%x ",
+			ndlp->nlp_usg_map);
 		len += snprintf(buf+len, size-len, "refcnt:%x",
 			atomic_read(&ndlp->kref.refcount));
 		len +=  snprintf(buf+len, size-len, "\n");
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-04-07 09:09:12.000000000 -0400
@@ -719,9 +719,9 @@ lpfc_els_abort_flogi(struct lpfc_hba *ph
 		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR &&
 		    icmd->un.elsreq64.bdl.ulpIoTag32) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
-			if (ndlp && (ndlp->nlp_DID == Fabric_DID)) {
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+			    (ndlp->nlp_DID == Fabric_DID))
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
-			}
 		}
 	}
 	spin_unlock_irq(&phba->hbalock);
@@ -829,7 +829,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc;
+	uint32_t rc, keepDID = 0;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
 	 * by WWPN.  Just return the ndlp that was given to us.
@@ -858,11 +858,17 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 			return ndlp;
 		lpfc_nlp_init(vport, new_ndlp, ndlp->nlp_DID);
 	} else if (!NLP_CHK_NODE_ACT(new_ndlp)) {
+		rc = memcmp(&ndlp->nlp_portname, name,
+			    sizeof(struct lpfc_name));
+		if (!rc)
+			return ndlp;
 		new_ndlp = lpfc_enable_node(vport, new_ndlp,
 						NLP_STE_UNUSED_NODE);
 		if (!new_ndlp)
 			return ndlp;
-	}
+		keepDID = new_ndlp->nlp_DID;
+	} else
+		keepDID = new_ndlp->nlp_DID;
 
 	lpfc_unreg_rpi(vport, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
@@ -893,12 +899,24 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 			}
 			new_ndlp->nlp_type = ndlp->nlp_type;
 		}
+		/* We shall actually free the ndlp with both nlp_DID and
+		 * nlp_portname fields equals 0 to avoid any ndlp on the
+		 * nodelist never to be used.
+		 */
+		if (ndlp->nlp_DID == 0) {
+			spin_lock_irq(&phba->ndlp_lock);
+			NLP_SET_FREE_REQ(ndlp);
+			spin_unlock_irq(&phba->ndlp_lock);
+		}
 
+		/* Two ndlps cannot have the same did on the nodelist */
+		ndlp->nlp_DID = keepDID;
 		lpfc_drop_node(vport, ndlp);
 	}
 	else {
 		lpfc_unreg_rpi(vport, ndlp);
-		ndlp->nlp_DID = 0; /* Two ndlps cannot have the same did */
+		/* Two ndlps cannot have the same did */
+		ndlp->nlp_DID = keepDID;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	}
 	return new_ndlp;
@@ -2091,7 +2109,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		}
 
 		phba->fc_stat.elsXmitRetry++;
-		if (ndlp && delay) {
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp) && delay) {
 			phba->fc_stat.elsDelayRetry++;
 			ndlp->nlp_retry = cmdiocb->retry;
 
@@ -2121,7 +2139,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			lpfc_issue_els_fdisc(vport, ndlp, cmdiocb->retry);
 			return 1;
 		case ELS_CMD_PLOGI:
-			if (ndlp) {
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 				ndlp->nlp_prev_state = ndlp->nlp_state;
 				lpfc_nlp_set_state(vport, ndlp,
 						   NLP_STE_PLOGI_ISSUE);
@@ -2302,7 +2320,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
-	if (ndlp) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_nlp_put(ndlp);
 		/* This is the end of the default RPI cleanup logic for this
 		 * ndlp. If no other discovery threads are using this ndlp.
@@ -2335,7 +2353,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	 * function can have cmdiocb->contest1 (ndlp) field set to NULL.
 	 */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
-	if (ndlp && (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+	    (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
 		/* A LS_RJT associated with Default RPI cleanup has its own
 		 * seperate code path.
 		 */
@@ -2344,7 +2363,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	}
 
 	/* Check to see if link went down during discovery */
-	if (!ndlp || lpfc_els_chk_latt(vport)) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) || lpfc_els_chk_latt(vport)) {
 		if (mbox) {
 			mp = (struct lpfc_dmabuf *) mbox->context1;
 			if (mp) {
@@ -2353,7 +2372,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
-		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
+		if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+		    (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
 			if (lpfc_nlp_not_used(ndlp)) {
 				ndlp = NULL;
 				/* Indicate the node has already released,
@@ -2443,7 +2463,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 		mempool_free(mbox, phba->mbox_mem_pool);
 	}
 out:
-	if (ndlp) {
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
 		spin_unlock_irq(shost->host_lock);
@@ -3139,6 +3159,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 		/* Another thread is walking fc_rscn_id_list on this vport */
 		spin_unlock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DISCOVERY;
+		/* Send back ACC */
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 		return 0;
 	}
 	/* Indicate we are walking fc_rscn_id_list on this vport */
@@ -3928,7 +3950,7 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 		else {
 			struct lpfc_nodelist *ndlp;
 			ndlp = __lpfc_findnode_rpi(vport, cmd->ulpContext);
-			if (ndlp)
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp))
 				remote_ID = ndlp->nlp_DID;
 		}
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -4097,21 +4119,22 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		newnode = 1;
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
 			ndlp->nlp_type |= NLP_FABRIC;
-	} else {
-		if (!NLP_CHK_NODE_ACT(ndlp)) {
-			ndlp = lpfc_enable_node(vport, ndlp,
-						NLP_STE_UNUSED_NODE);
-			if (!ndlp)
-				goto dropit;
-		}
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
-			/* This is simular to the new node path */
-			ndlp = lpfc_nlp_get(ndlp);
-			if (!ndlp)
-				goto dropit;
-			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
-			newnode = 1;
-		}
+	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+		ndlp = lpfc_enable_node(vport, ndlp,
+					NLP_STE_UNUSED_NODE);
+		if (!ndlp)
+			goto dropit;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		newnode = 1;
+		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
+			ndlp->nlp_type |= NLP_FABRIC;
+	} else if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+		/* This is similar to the new node path */
+		ndlp = lpfc_nlp_get(ndlp);
+		if (!ndlp)
+			goto dropit;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		newnode = 1;
 	}
 
 	phba->fc_stat.elsRcvFrame++;
@@ -4451,7 +4474,6 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 			return;
 		}
 		lpfc_nlp_init(vport, ndlp, NameServer_DID);
-		ndlp->nlp_type |= NLP_FABRIC;
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
 		if (!ndlp) {
@@ -4465,6 +4487,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 			return;
 		}
 	}
+	ndlp->nlp_type |= NLP_FABRIC;
 
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 
@@ -4481,8 +4504,8 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 		if (ndlp_fdmi) {
 			lpfc_nlp_init(vport, ndlp_fdmi, FDMI_DID);
 			ndlp_fdmi->nlp_type |= NLP_FABRIC;
-			ndlp_fdmi->nlp_state =
-				NLP_STE_PLOGI_ISSUE;
+			lpfc_nlp_set_state(vport, ndlp_fdmi,
+				NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp_fdmi->nlp_DID,
 					     0);
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-04-07 09:09:07.000000000 -0400
@@ -268,7 +268,6 @@ struct lpfc_vport {
 #define FC_NLP_MORE             0x40	 /* More node to process in node tbl */
 #define FC_OFFLINE_MODE         0x80	 /* Interface is offline for diag */
 #define FC_FABRIC               0x100	 /* We are fabric attached */
-#define FC_ESTABLISH_LINK       0x200	 /* Reestablish Link */
 #define FC_RSCN_DISCOVERY       0x400	 /* Auth all devices after RSCN */
 #define FC_SCSI_SCAN_TMO        0x4000	 /* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
@@ -433,8 +432,6 @@ struct lpfc_hba {
 
 	uint32_t fc_eventTag;	/* event tag for link attention */
 
-
-	struct timer_list fc_estabtmo;	/* link establishment timer */
 	/* These fields used to be binfo */
 	uint32_t fc_pref_DID;	/* preferred D_ID */
 	uint8_t  fc_pref_ALPA;	/* preferred AL_PA */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-03-17 08:40:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-04-07 09:09:12.000000000 -0400
@@ -69,7 +69,7 @@ lpfc_terminate_rport_io(struct fc_rport 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
 
-	if (!ndlp) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
 			printk(KERN_ERR "Cannot find remote node"
 			" to terminate I/O Data x%x\n",
@@ -114,7 +114,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
-	if (!ndlp)
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
 		return;
 
 	vport = ndlp->vport;
@@ -243,8 +243,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	if (warn_on) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "0203 Devloss timeout on "
-				 "WWPN %x:%x:%x:%x:%x:%x:%x:%x "
-				 "NPort x%x Data: x%x x%x x%x\n",
+				 "WWPN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x "
+				 "NPort x%06x Data: x%x x%x x%x\n",
 				 *name, *(name+1), *(name+2), *(name+3),
 				 *(name+4), *(name+5), *(name+6), *(name+7),
 				 ndlp->nlp_DID, ndlp->nlp_flag,
@@ -252,8 +252,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	} else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0204 Devloss timeout on "
-				 "WWPN %x:%x:%x:%x:%x:%x:%x:%x "
-				 "NPort x%x Data: x%x x%x x%x\n",
+				 "WWPN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x "
+				 "NPort x%06x Data: x%x x%x x%x\n",
 				 *name, *(name+1), *(name+2), *(name+3),
 				 *(name+4), *(name+5), *(name+6), *(name+7),
 				 ndlp->nlp_DID, ndlp->nlp_flag,
@@ -399,7 +399,10 @@ lpfc_work_done(struct lpfc_hba *phba)
 				vport = vports[i];
 			if (vport == NULL)
 				break;
+			spin_lock_irq(&vport->work_port_lock);
 			work_port_events = vport->work_port_events;
+			vport->work_port_events &= ~work_port_events;
+			spin_unlock_irq(&vport->work_port_lock);
 			if (work_port_events & WORKER_DISC_TMO)
 				lpfc_disc_timeout_handler(vport);
 			if (work_port_events & WORKER_ELS_TMO)
@@ -416,9 +419,6 @@ lpfc_work_done(struct lpfc_hba *phba)
 				lpfc_ramp_down_queue_handler(phba);
 			if (work_port_events & WORKER_RAMP_UP_QUEUE)
 				lpfc_ramp_up_queue_handler(phba);
-			spin_lock_irq(&vport->work_port_lock);
-			vport->work_port_events &= ~work_port_events;
-			spin_unlock_irq(&vport->work_port_lock);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
@@ -430,10 +430,10 @@ lpfc_work_done(struct lpfc_hba *phba)
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 		} else {
+			pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 			lpfc_sli_handle_slow_ring_event(phba, pring,
 							(status &
 							 HA_RXMASK));
-			pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 		}
 		/*
 		 * Turn on Ring interrupts
@@ -519,7 +519,9 @@ lpfc_do_work(void *p)
 			schedule();
 		}
 	}
+	spin_lock_irq(&phba->hbalock);
 	phba->work_wait = NULL;
+	spin_unlock_irq(&phba->hbalock);
 	return 0;
 }
 
@@ -809,11 +811,9 @@ out:
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	spin_lock_irq(shost->host_lock);
-	vport->fc_flag &= ~(FC_ABORT_DISCOVERY | FC_ESTABLISH_LINK);
+	vport->fc_flag &= ~FC_ABORT_DISCOVERY;
 	spin_unlock_irq(shost->host_lock);
 
-	del_timer_sync(&phba->fc_estabtmo);
-
 	lpfc_can_disctmo(vport);
 
 	/* turn on Link Attention interrupts */
@@ -1340,10 +1340,14 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 			    i++) {
 				if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
 					continue;
+				if (phba->fc_topology == TOPOLOGY_LOOP) {
+					lpfc_vport_set_state(vports[i],
+							FC_VPORT_LINKDOWN);
+					continue;
+				}
 				if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
 					lpfc_initial_fdisc(vports[i]);
-				else if (phba->sli3_options &
-						LPFC_SLI3_NPIV_ENABLED) {
+				else {
 					lpfc_vport_set_state(vports[i],
 						FC_VPORT_NO_FABRIC_SUPP);
 					lpfc_printf_vlog(vport, KERN_ERR,
@@ -2190,10 +2194,6 @@ lpfc_matchdid(struct lpfc_vport *vport, 
 	if (did == Bcast_DID)
 		return 0;
 
-	if (ndlp->nlp_DID == 0) {
-		return 0;
-	}
-
 	/* First check for Direct match */
 	if (ndlp->nlp_DID == did)
 		return 1;
@@ -2301,7 +2301,8 @@ lpfc_setup_disc_node(struct lpfc_vport *
 		return ndlp;
 	}
 
-	if (vport->fc_flag & FC_RSCN_MODE) {
+	if ((vport->fc_flag & FC_RSCN_MODE) &&
+	    !(vport->fc_flag & FC_NDISC_ACTIVE)) {
 		if (lpfc_rscn_payload_check(vport, did)) {
 			/* If we've already recieved a PLOGI from this NPort
 			 * we don't need to try to discover it again.
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-04-07 09:09:12.000000000 -0400
@@ -559,8 +559,10 @@ lpfc_hb_timeout(unsigned long ptr)
 		phba->pport->work_port_events |= WORKER_HB_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
 
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	if (phba->work_wait)
 		wake_up(phba->work_wait);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
 
@@ -714,12 +716,10 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_sli   *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
-	struct lpfc_vport **vports;
 	uint32_t event_data;
 	unsigned long temperature;
 	struct temp_event temp_event_data;
 	struct Scsi_Host  *shost;
-	int i;
 
 	/* If the pci channel is offline, ignore possible errors,
 	 * since we cannot communicate with the pci card anyway. */
@@ -737,17 +737,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 				"Data: x%x x%x x%x\n",
 				phba->work_hs,
 				phba->work_status[0], phba->work_status[1]);
-		vports = lpfc_create_vport_work_array(phba);
-		if (vports != NULL)
-			for(i = 0;
-			    i <= phba->max_vpi && vports[i] != NULL;
-			    i++){
-				shost = lpfc_shost_from_vport(vports[i]);
-				spin_lock_irq(shost->host_lock);
-				vports[i]->fc_flag |= FC_ESTABLISH_LINK;
-				spin_unlock_irq(shost->host_lock);
-			}
-		lpfc_destroy_vport_work_array(phba, vports);
+
 		spin_lock_irq(&phba->hbalock);
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		spin_unlock_irq(&phba->hbalock);
@@ -761,7 +751,6 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 		pring = &psli->ring[psli->fcp_ring];
 		lpfc_sli_abort_iocb_ring(phba, pring);
 
-
 		/*
 		 * There was a firmware error.  Take the hba offline and then
 		 * attempt to restart it.
@@ -770,7 +759,6 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 		lpfc_offline(phba);
 		lpfc_sli_brdrestart(phba);
 		if (lpfc_online(phba) == 0) {	/* Initialize the HBA */
-			mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
 			lpfc_unblock_mgmt_io(phba);
 			return;
 		}
@@ -1454,6 +1442,13 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			NLP_SET_FREE_REQ(ndlp);
 		spin_unlock_irq(&phba->ndlp_lock);
 
+		if (vport->port_type != LPFC_PHYSICAL_PORT &&
+		    ndlp->nlp_DID == Fabric_DID) {
+			/* Just free up ndlp with Fabric_DID for vports */
+			lpfc_nlp_put(ndlp);
+			continue;
+		}
+
 		if (ndlp->nlp_type & NLP_FABRIC)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
@@ -1491,31 +1486,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 	return;
 }
 
-static void
-lpfc_establish_link_tmo(unsigned long ptr)
-{
-	struct lpfc_hba   *phba = (struct lpfc_hba *) ptr;
-	struct lpfc_vport **vports;
-	unsigned long iflag;
-	int i;
-
-	/* Re-establishing Link, timer expired */
-	lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
-			"1300 Re-establishing Link, timer expired "
-			"Data: x%x x%x\n",
-			phba->pport->fc_flag, phba->pport->port_state);
-	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
-			struct Scsi_Host *shost;
-			shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irqsave(shost->host_lock, iflag);
-			vports[i]->fc_flag &= ~FC_ESTABLISH_LINK;
-			spin_unlock_irqrestore(shost->host_lock, iflag);
-		}
-	lpfc_destroy_vport_work_array(phba, vports);
-}
-
 void
 lpfc_stop_vport_timers(struct lpfc_vport *vport)
 {
@@ -1529,7 +1499,6 @@ static void
 lpfc_stop_phba_timers(struct lpfc_hba *phba)
 {
 	del_timer_sync(&phba->fcp_poll_timer);
-	del_timer_sync(&phba->fc_estabtmo);
 	lpfc_stop_vport_timers(phba->pport);
 	del_timer_sync(&phba->sli.mbox_tmo);
 	del_timer_sync(&phba->fabric_block_timer);
@@ -2005,10 +1974,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->max_vpi = LPFC_MAX_VPI;
 
 	/* Initialize timers used by driver */
-	init_timer(&phba->fc_estabtmo);
-	phba->fc_estabtmo.function = lpfc_establish_link_tmo;
-	phba->fc_estabtmo.data = (unsigned long)phba;
-
 	init_timer(&phba->hb_tmofunc);
 	phba->hb_tmofunc.function = lpfc_hb_timeout;
 	phba->hb_tmofunc.data = (unsigned long)phba;
@@ -2416,11 +2381,6 @@ static pci_ers_result_t lpfc_io_slot_res
 
 	pci_set_master(pdev);
 
-	/* Re-establishing Link */
-	spin_lock_irq(shost->host_lock);
-	phba->pport->fc_flag |= FC_ESTABLISH_LINK;
-	spin_unlock_irq(shost->host_lock);
-
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
@@ -2445,9 +2405,7 @@ static void lpfc_io_resume(struct pci_de
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	if (lpfc_online(phba) == 0) {
-		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
-	}
+	lpfc_online(phba);
 }
 
 static struct pci_device_id lpfc_id_table[] = {
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-04-07 09:08:33.000000000 -0400
@@ -451,7 +451,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			spin_unlock_irq(shost->host_lock);
 
 			if ((ndlp->nlp_flag & NLP_ADISC_SND) &&
-				(vport->num_disc_nodes)) {
+			    (vport->num_disc_nodes)) {
 				/* Check to see if there are more
 				 * ADISCs to be sent
 				 */
@@ -469,20 +469,23 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 					lpfc_end_rscn(vport);
 				}
 			}
-			else if (vport->num_disc_nodes) {
-				/* Check to see if there are more
-				 * PLOGIs to be sent
-				 */
-				lpfc_more_plogi(vport);
-
-				if (vport->num_disc_nodes == 0) {
-					spin_lock_irq(shost->host_lock);
-					vport->fc_flag &= ~FC_NDISC_ACTIVE;
-					spin_unlock_irq(shost->host_lock);
-					lpfc_can_disctmo(vport);
-					lpfc_end_rscn(vport);
-				}
-			}
+		}
+	} else if ((ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) &&
+		   (ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
+		   (vport->num_disc_nodes)) {
+		spin_lock_irq(shost->host_lock);
+		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		spin_unlock_irq(shost->host_lock);
+		/* Check to see if there are more
+		 * PLOGIs to be sent
+		 */
+		lpfc_more_plogi(vport);
+		if (vport->num_disc_nodes == 0) {
+			spin_lock_irq(shost->host_lock);
+			vport->fc_flag &= ~FC_NDISC_ACTIVE;
+			spin_unlock_irq(shost->host_lock);
+			lpfc_can_disctmo(vport);
+			lpfc_end_rscn(vport);
 		}
 	}
 
@@ -869,8 +872,11 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
-	if (wwn_to_u64(sp->portName.u.wwn) == 0 ||
-	    wwn_to_u64(sp->nodeName.u.wwn) == 0) {
+
+	/* Some switches have FDMI servers returning 0 for WWN */
+	if ((ndlp->nlp_DID != FDMI_DID) &&
+		(wwn_to_u64(sp->portName.u.wwn) == 0 ||
+		wwn_to_u64(sp->nodeName.u.wwn) == 0)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0142 PLOGI RSP: Invalid WWN.\n");
 		goto out;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-07 09:08:31.000000000 -0400
@@ -578,14 +578,14 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == RJT_LOGIN_REQUIRED) {
 				cmd->result = ScsiResult(DID_REQUEUE, 0);
-			break;
-		} /* else: fall through */
+				break;
+			} /* else: fall through */
 		default:
 			cmd->result = ScsiResult(DID_ERROR, 0);
 			break;
 		}
 
-		if ((pnode == NULL )
+		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
 			cmd->result = ScsiResult(DID_BUS_BUSY, SAM_STAT_BUSY);
 	} else {
@@ -626,7 +626,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	if (!result)
 		lpfc_rampup_queue_depth(vport, sdev);
 
-	if (!result && pnode != NULL &&
+	if (!result && pnode && NLP_CHK_NODE_ACT(pnode) &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
 	   ((jiffies - pnode->last_q_full_time) >
@@ -654,7 +654,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	 * Check for queue full.  If the lun is reporting queue full, then
 	 * back off the lun queue depth to prevent target overloads.
 	 */
-	if (result == SAM_STAT_TASK_SET_FULL && pnode != NULL) {
+	if (result == SAM_STAT_TASK_SET_FULL && pnode &&
+	    NLP_CHK_NODE_ACT(pnode)) {
 		pnode->last_q_full_time = jiffies;
 
 		shost_for_each_device(tmp_sdev, sdev->host) {
@@ -704,6 +705,9 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	int datadir = scsi_cmnd->sc_data_direction;
 	char tag[2];
 
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+		return;
+
 	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
 	/* clear task management bits */
 	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
@@ -785,9 +789,9 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 
-	if ((ndlp == NULL) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	    ndlp->nlp_state != NLP_STE_MAPPED_NODE)
 		return 0;
-	}
 
 	piocbq = &(lpfc_cmd->cur_iocbq);
 	piocbq->vport = vport;
@@ -842,7 +846,7 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
 
-	if (!rdata->pnode)
+	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
 
 	lpfc_cmd->rdata = rdata;
@@ -959,7 +963,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
 	 */
-	if (!ndlp) {
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
 		goto out_fail_command;
 	}
@@ -1146,7 +1150,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	 * target is rediscovered or devloss timeout expires.
 	 */
 	while (1) {
-		if (!pnode)
+		if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 			goto out;
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
@@ -1162,7 +1166,7 @@ lpfc_device_reset_handler(struct scsi_cm
 				goto out;
 			}
 			pnode = rdata->pnode;
-			if (!pnode)
+			if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 				goto out;
 		}
 		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-03-17 08:40:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-04-07 09:09:15.000000000 -0400
@@ -2648,7 +2648,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	spin_unlock_irq(&phba->pport->work_port_lock);
 	spin_lock_irq(&phba->hbalock);
 	phba->link_state = LPFC_LINK_UNKNOWN;
-	phba->pport->fc_flag |= FC_ESTABLISH_LINK;
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
@@ -2669,8 +2668,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	lpfc_offline_prep(phba);
 	lpfc_offline(phba);
 	lpfc_sli_brdrestart(phba);
-	if (lpfc_online(phba) == 0)		/* Initialize the HBA */
-		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
+	lpfc_online(phba);
 	lpfc_unblock_mgmt_io(phba);
 	return;
 }
@@ -2687,28 +2685,41 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	unsigned long drvr_flag = 0;
 	volatile uint32_t word0, ldata;
 	void __iomem *to_slim;
+	int processing_queue = 0;
+
+	spin_lock_irqsave(&phba->hbalock, drvr_flag);
+	if (!pmbox) {
+		/* processing mbox queue from intr_handler */
+		processing_queue = 1;
+		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		pmbox = lpfc_mbox_get(phba);
+		if (!pmbox) {
+			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+			return MBX_SUCCESS;
+		}
+	}
 
 	if (pmbox->mbox_cmpl && pmbox->mbox_cmpl != lpfc_sli_def_mbox_cmpl &&
 		pmbox->mbox_cmpl != lpfc_sli_wake_mbox_wait) {
 		if(!pmbox->vport) {
+			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			lpfc_printf_log(phba, KERN_ERR,
 					LOG_MBOX | LOG_VPORT,
 					"1806 Mbox x%x failed. No vport\n",
 					pmbox->mb.mbxCommand);
 			dump_stack();
-			return MBX_NOT_FINISHED;
+			goto out_not_finished;
 		}
 	}
 
-
 	/* If the PCI channel is in offline state, do not post mbox. */
-	if (unlikely(pci_channel_offline(phba->pcidev)))
-		return MBX_NOT_FINISHED;
+	if (unlikely(pci_channel_offline(phba->pcidev))) {
+		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+		goto out_not_finished;
+	}
 
-	spin_lock_irqsave(&phba->hbalock, drvr_flag);
 	psli = &phba->sli;
 
-
 	mb = &pmbox->mb;
 	status = MBX_SUCCESS;
 
@@ -2717,14 +2728,14 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 		/* Mbox command <mbxCommand> cannot issue */
 		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
-		return MBX_NOT_FINISHED;
+		goto out_not_finished;
 	}
 
 	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT &&
 	    !(readl(phba->HCregaddr) & HC_MBINT_ENA)) {
 		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
-		return MBX_NOT_FINISHED;
+		goto out_not_finished;
 	}
 
 	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
@@ -2738,14 +2749,14 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 			/* Mbox command <mbxCommand> cannot issue */
 			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
-			return MBX_NOT_FINISHED;
+			goto out_not_finished;
 		}
 
 		if (!(psli->sli_flag & LPFC_SLI2_ACTIVE)) {
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			/* Mbox command <mbxCommand> cannot issue */
 			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
-			return MBX_NOT_FINISHED;
+			goto out_not_finished;
 		}
 
 		/* Another mailbox command is still being processed, queue this
@@ -2792,7 +2803,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			/* Mbox command <mbxCommand> cannot issue */
 			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
-			return MBX_NOT_FINISHED;
+			goto out_not_finished;
 		}
 		/* timeout active mbox command */
 		mod_timer(&psli->mbox_tmo, (jiffies +
@@ -2900,7 +2911,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 				psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 				spin_unlock_irqrestore(&phba->hbalock,
 						       drvr_flag);
-				return MBX_NOT_FINISHED;
+				goto out_not_finished;
 			}
 
 			/* Check if we took a mbox interrupt while we were
@@ -2967,6 +2978,13 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 	return status;
+
+out_not_finished:
+	if (processing_queue) {
+		pmbox->mb.mbxStatus = MBX_NOT_FINISHED;
+		lpfc_mbox_cmpl_put(phba, pmbox);
+	}
+	return MBX_NOT_FINISHED;
 }
 
 /*
@@ -3613,6 +3631,16 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 				irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		/*
+		 *  If the iocb is not found in Firmware queue the iocb
+		 *  might have completed already. Do not free it again.
+		 */
+		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+			(irsp->un.ulpWord[4] == IOERR_NO_XRI)) {
+			spin_unlock_irq(&phba->hbalock);
+			lpfc_sli_release_iocbq(phba, cmdiocb);
+			return;
+		}
+		/*
 		 * make sure we have the right iocbq before taking it
 		 * off the txcmplq and try to call completion routine.
 		 */
@@ -4237,10 +4265,15 @@ lpfc_intr_handler(int irq, void *dev_id)
 						pmb->context1 = mp;
 						pmb->context2 = ndlp;
 						pmb->vport = vport;
-						spin_lock(&phba->hbalock);
-						phba->sli.sli_flag &=
-							~LPFC_SLI_MBOX_ACTIVE;
-						spin_unlock(&phba->hbalock);
+						rc = lpfc_sli_issue_mbox(phba,
+								pmb,
+								MBX_NOWAIT);
+						if (rc != MBX_BUSY)
+							lpfc_printf_log(phba,
+							KERN_ERR,
+							LOG_MBOX | LOG_SLI,
+							"0306 rc should have"
+							"been MBX_BUSY");
 						goto send_current_mbox;
 					}
 				}
@@ -4253,22 +4286,16 @@ lpfc_intr_handler(int irq, void *dev_id)
 		}
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
-send_next_mbox:
-			spin_lock(&phba->hbalock);
-			phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-			pmb = lpfc_mbox_get(phba);
-			spin_unlock(&phba->hbalock);
 send_current_mbox:
 			/* Process next mailbox command if there is one */
-			if (pmb != NULL) {
-				rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-				if (rc == MBX_NOT_FINISHED) {
-					pmb->mb.mbxStatus = MBX_NOT_FINISHED;
-					lpfc_mbox_cmpl_put(phba, pmb);
-					goto send_next_mbox;
-				}
-			}
-
+			do {
+				rc = lpfc_sli_issue_mbox(phba, NULL,
+							 MBX_NOWAIT);
+			} while (rc == MBX_NOT_FINISHED);
+			if (rc != MBX_SUCCESS)
+				lpfc_printf_log(phba, KERN_ERR, LOG_MBOX |
+						LOG_SLI, "0349 rc should be "
+						"MBX_SUCCESS");
 		}
 
 		spin_lock(&phba->hbalock);
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-04-07 09:08:18.000000000 -0400
@@ -538,7 +538,8 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	/* Otherwise, we will perform fabric logo as needed */
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
 	    ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-	    phba->link_state >= LPFC_LINK_UP) {
+	    phba->link_state >= LPFC_LINK_UP &&
+	    phba->fc_topology != TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
 			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
 			if (!lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0))


