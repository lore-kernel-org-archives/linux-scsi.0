From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/3] lpfc 8.3.16: FCoE Discovery and Failover Fixes
Date: Wed, 4 Aug 2010 16:11:39 -0400
Message-ID: <1280952719.32588.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:22863 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934419Ab0HDUMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 16:12:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FCoE Discovery and Failover Fixes

- Add support for re-reg'ing changed VPI w/o unregister VPI
- Copy WWN and state from old nodelist when target DID change.
- Clean up old nodelist rport and put the nodelist when target DID change.
- Clear the VFI_REGISTERED flag when UNREG_VFI completes.
- Made both checks of port_state against LPFC_FLOGI and LPFC_FDISC
  non-inclusive for ignoring CVL events.
- Added logic to stop retrying of the ongoing PLOGI and FDISC if
  transitioned back to the FCF rediscovery state in reaction to CVL.
- Removed the dependency of scanning of all the available FCF table
  entries for bulding round-robin bitmap.
- Use the lpfc_sli4_fcf_rr_read_fcf_rec() in responding to
  individual New FCF found event.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 lpfc_hbadisc.c |   15 ++++++++--
 lpfc_hw.h      |    6 ++--
 lpfc_init.c    |   79 +++++++++++++++++++++++++++++++++++----------------------
 lpfc_mbox.c    |    8 +++++
 lpfc_sli.c     |    7 +----
 6 files changed, 144 insertions(+), 47 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-08-04 10:53:27.000000000 -0400
@@ -600,6 +600,14 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			spin_unlock_irq(shost->host_lock);
 		}
+	} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
+		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
+			/*
+			 * Driver needs to re-reg VPI in order for f/w
+			 * to update the MAC address.
+			 */
+			lpfc_register_new_vport(phba, vport, ndlp);
+			return 0;
 	}
 
 	if (phba->sli_rev < LPFC_SLI_REV4) {
@@ -801,9 +809,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		    (irsp->un.ulpWord[4] != IOERR_SLI_ABORTED)) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
 					"2611 FLOGI failed on registered "
-					"FCF record fcf_index:%d, trying "
-					"to perform round robin failover\n",
-					phba->fcf.current_rec.fcf_indx);
+					"FCF record fcf_index(%d), status: "
+					"x%x/x%x, tmo:x%x, trying to perform "
+					"round robin failover\n",
+					phba->fcf.current_rec.fcf_indx,
+					irsp->ulpStatus, irsp->un.ulpWord[4],
+					irsp->ulpTimeout);
 			fcf_index = lpfc_sli4_fcf_rr_next_index_get(phba);
 			if (fcf_index == LPFC_FCOE_FCF_NEXT_NONE) {
 				/*
@@ -841,6 +852,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 			}
 		}
 
+		/* FLOGI failure */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				"2858 FLOGI failure Status:x%x/x%x TMO:x%x\n",
+				irsp->ulpStatus, irsp->un.ulpWord[4],
+				irsp->ulpTimeout);
+
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
@@ -1291,6 +1308,8 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t rc, keepDID = 0;
+	int  put_node;
+	int  put_rport;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
 	 * by WWPN.  Just return the ndlp that was given to us.
@@ -1379,6 +1398,28 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 		/* Two ndlps cannot have the same did */
 		ndlp->nlp_DID = keepDID;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		/* Since we are swapping the ndlp passed in with the new one
+		 * and the did has already been swapped, copy over the
+		 * state and names.
+		 */
+		memcpy(&new_ndlp->nlp_portname, &ndlp->nlp_portname,
+			sizeof(struct lpfc_name));
+		memcpy(&new_ndlp->nlp_nodename, &ndlp->nlp_nodename,
+			sizeof(struct lpfc_name));
+		new_ndlp->nlp_state = ndlp->nlp_state;
+		/* Fix up the rport accordingly */
+		rport = ndlp->rport;
+		if (rport) {
+			rdata = rport->dd_data;
+			put_node = rdata->pnode != NULL;
+			put_rport = ndlp->rport != NULL;
+			rdata->pnode = NULL;
+			ndlp->rport = NULL;
+			if (put_node)
+				lpfc_nlp_put(ndlp);
+			if (put_rport)
+				put_device(&rport->dev);
+		}
 	}
 	return new_ndlp;
 }
@@ -2880,6 +2921,17 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		retry = 0;
 
 	if (retry) {
+		if ((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_FDISC)) {
+			/* Stop retrying PLOGI and FDISC if in FCF discovery */
+			if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+						 "2849 Stop retry ELS command "
+						 "x%x to remote NPORT x%x, "
+						 "Data: x%x x%x\n", cmd, did,
+						 cmdiocb->retry, delay);
+				return 0;
+			}
+		}
 
 		/* Retry ELS command <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -6076,8 +6128,12 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 
 	if (mb->mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
-				 "0915 Register VPI failed: 0x%x\n",
-				 mb->mbxStatus);
+				"0915 Register VPI failed : Status: x%x"
+				" upd bit: x%x \n", mb->mbxStatus,
+				 mb->un.varRegVpi.upd);
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+			mb->un.varRegVpi.upd)
+			goto mbox_err_exit ;
 
 		switch (mb->mbxStatus) {
 		case 0x11:	/* unsupported feature */
@@ -6142,7 +6198,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 		} else
 			lpfc_do_scr_ns_plogi(phba, vport);
 	}
-
+mbox_err_exit:
 	/* Now, we decrement the ndlp reference count held for this
 	 * callback function
 	 */
@@ -6387,6 +6443,14 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		else
 			vport->fc_flag |= FC_LOGO_RCVD_DID_CHNG;
 		spin_unlock_irq(shost->host_lock);
+	} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
+		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
+		/*
+		 * Driver needs to re-reg VPI in order for f/w
+		 * to update the MAC address.
+		 */
+		lpfc_register_new_vport(phba, vport, ndlp);
+		return ;
 	}
 
 	if (vport->fc_flag & FC_VPORT_NEEDS_INIT_VPI)
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-08-04 10:53:27.000000000 -0400
@@ -1852,8 +1852,7 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 				__lpfc_sli4_stop_fcf_redisc_wait_timer(phba);
 			else if (phba->fcf.fcf_flag & FCF_REDISC_FOV)
 				/* If in fast failover, mark it's completed */
-				phba->fcf.fcf_flag &= ~(FCF_REDISC_FOV |
-							FCF_DISCOVERY);
+				phba->fcf.fcf_flag &= ~FCF_REDISC_FOV;
 			spin_unlock_irq(&phba->hbalock);
 			lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
 					"2836 The new FCF record (x%x) "
@@ -2651,7 +2650,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		spin_unlock_irq(&phba->hbalock);
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2778 Start FCF table scan at linkup\n");
-
 		rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba,
 						     LPFC_FCOE_FCF_GET_FIRST);
 		if (rc) {
@@ -2660,6 +2658,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 			spin_unlock_irq(&phba->hbalock);
 			goto out;
 		}
+		/* Reset FCF roundrobin bmask for new discovery */
+		memset(phba->fcf.fcf_rr_bmask, 0,
+		       sizeof(*phba->fcf.fcf_rr_bmask));
 	}
 
 	return;
@@ -5097,6 +5098,7 @@ static void
 lpfc_unregister_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport = mboxq->vport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if (mboxq->u.mb.mbxStatus) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
@@ -5104,6 +5106,9 @@ lpfc_unregister_vfi_cmpl(struct lpfc_hba
 			"HBA state x%x\n",
 			mboxq->u.mb.mbxStatus, vport->port_state);
 	}
+	spin_lock_irq(shost->host_lock);
+	phba->pport->fc_flag &= ~FC_VFI_REGISTERED;
+	spin_unlock_irq(shost->host_lock);
 	mempool_free(mboxq, phba->mbox_mem_pool);
 	return;
 }
@@ -5285,6 +5290,10 @@ lpfc_unregister_fcf_rescan(struct lpfc_h
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag |= FCF_INIT_DISC;
 	spin_unlock_irq(&phba->hbalock);
+
+	/* Reset FCF roundrobin bmask for new discovery */
+	memset(phba->fcf.fcf_rr_bmask, 0, sizeof(*phba->fcf.fcf_rr_bmask));
+
 	rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba, LPFC_FCOE_FCF_GET_FIRST);
 
 	if (rc) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-08-04 10:52:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-08-04 10:53:18.000000000 -0400
@@ -2291,7 +2291,8 @@ typedef struct {
 typedef struct {
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t rsvd1;
-	uint32_t rsvd2:8;
+	uint32_t rsvd2:7;
+	uint32_t upd:1;
 	uint32_t sid:24;
 	uint32_t wwn[2];
 	uint32_t rsvd5;
@@ -2300,7 +2301,8 @@ typedef struct {
 #else	/*  __LITTLE_ENDIAN */
 	uint32_t rsvd1;
 	uint32_t sid:24;
-	uint32_t rsvd2:8;
+	uint32_t upd:1;
+	uint32_t rsvd2:7;
 	uint32_t wwn[2];
 	uint32_t rsvd5;
 	uint16_t vpi;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-08-04 10:52:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-08-04 10:53:27.000000000 -0400
@@ -3300,10 +3300,10 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_
 		if (!ndlp)
 			return 0;
 	}
-	if (phba->pport->port_state <= LPFC_FLOGI)
+	if (phba->pport->port_state < LPFC_FLOGI)
 		return NULL;
 	/* If virtual link is not yet instantiated ignore CVL */
-	if (vport->port_state <= LPFC_FDISC)
+	if ((vport != phba->pport) && (vport->port_state < LPFC_FDISC))
 		return NULL;
 	shost = lpfc_shost_from_vport(vport);
 	if (!shost)
@@ -3376,21 +3376,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 					"evt_tag:x%x, fcf_index:x%x\n",
 					acqe_fcoe->event_tag,
 					acqe_fcoe->index);
-		/* If the FCF discovery is in progress, do nothing. */
-		spin_lock_irq(&phba->hbalock);
-		if (phba->hba_flag & FCF_DISC_INPROGRESS) {
-			spin_unlock_irq(&phba->hbalock);
-			break;
-		}
-		/* If fast FCF failover rescan event is pending, do nothing */
-		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
-			spin_unlock_irq(&phba->hbalock);
-			break;
-		}
-		spin_unlock_irq(&phba->hbalock);
-
-		if ((phba->fcf.fcf_flag & FCF_DISCOVERY) &&
-		    !(phba->fcf.fcf_flag & FCF_REDISC_FOV)) {
+		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
 			/*
 			 * During period of FCF discovery, read the FCF
 			 * table record indexed by the event to update
@@ -3404,13 +3390,26 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 					acqe_fcoe->index);
 			rc = lpfc_sli4_read_fcf_rec(phba, acqe_fcoe->index);
 		}
-		/* If the FCF has been in discovered state, do nothing. */
+
+		/* If the FCF discovery is in progress, do nothing. */
 		spin_lock_irq(&phba->hbalock);
+		if (phba->hba_flag & FCF_DISC_INPROGRESS) {
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+		/* If fast FCF failover rescan event is pending, do nothing */
+		if (phba->fcf.fcf_flag & FCF_REDISC_EVT) {
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+
+		/* If the FCF has been in discovered state, do nothing. */
 		if (phba->fcf.fcf_flag & FCF_SCAN_DONE) {
 			spin_unlock_irq(&phba->hbalock);
 			break;
 		}
 		spin_unlock_irq(&phba->hbalock);
+
 		/* Otherwise, scan the entire FCF table and re-discover SAN */
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2770 Start FCF table scan due to new FCF "
@@ -3436,13 +3435,9 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			"2549 FCF disconnected from network index 0x%x"
 			" tag 0x%x\n", acqe_fcoe->index,
 			acqe_fcoe->event_tag);
-		/* If the event is not for currently used fcf do nothing */
-		if (phba->fcf.current_rec.fcf_indx != acqe_fcoe->index)
-			break;
-		/* We request port to rediscover the entire FCF table for
-		 * a fast recovery from case that the current FCF record
-		 * is no longer valid if we are not in the middle of FCF
-		 * failover process already.
+		/*
+		 * If we are in the middle of FCF failover process, clear
+		 * the corresponding FCF bit in the roundrobin bitmap.
 		 */
 		spin_lock_irq(&phba->hbalock);
 		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
@@ -3451,9 +3446,23 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fcoe->index);
 			break;
 		}
+		spin_unlock_irq(&phba->hbalock);
+
+		/* If the event is not for currently used fcf do nothing */
+		if (phba->fcf.current_rec.fcf_indx != acqe_fcoe->index)
+			break;
+
+		/*
+		 * Otherwise, request the port to rediscover the entire FCF
+		 * table for a fast recovery from case that the current FCF
+		 * is no longer valid as we are not in the middle of FCF
+		 * failover process already.
+		 */
+		spin_lock_irq(&phba->hbalock);
 		/* Mark the fast failover process in progress */
 		phba->fcf.fcf_flag |= FCF_DEAD_DISC;
 		spin_unlock_irq(&phba->hbalock);
+
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2771 Start FCF fast failover process due to "
 				"FCF DEAD event: evt_tag:x%x, fcf_index:x%x "
@@ -3473,12 +3482,16 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 			 * as a link down to FCF registration.
 			 */
 			lpfc_sli4_fcf_dead_failthrough(phba);
-		} else
-			/* Handling fast FCF failover to a DEAD FCF event
-			 * is considered equalivant to receiving CVL to all
-			 * vports.
+		} else {
+			/* Reset FCF roundrobin bmask for new discovery */
+			memset(phba->fcf.fcf_rr_bmask, 0,
+			       sizeof(*phba->fcf.fcf_rr_bmask));
+			/*
+			 * Handling fast FCF failover to a DEAD FCF event is
+			 * considered equalivant to receiving CVL to all vports.
 			 */
 			lpfc_sli4_perform_all_vport_cvl(phba);
+		}
 		break;
 	case LPFC_FCOE_EVENT_TYPE_CVL:
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
@@ -3553,7 +3566,13 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 				 * the current registered FCF entry.
 				 */
 				lpfc_retry_pport_discovery(phba);
-			}
+			} else
+				/*
+				 * Reset FCF roundrobin bmask for new
+				 * discovery.
+				 */
+				memset(phba->fcf.fcf_rr_bmask, 0,
+				       sizeof(*phba->fcf.fcf_rr_bmask));
 		}
 		break;
 	default:
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-08-04 10:53:18.000000000 -0400
@@ -815,9 +815,15 @@ void
 lpfc_reg_vpi(struct lpfc_vport *vport, LPFC_MBOXQ_t *pmb)
 {
 	MAILBOX_t *mb = &pmb->u.mb;
+	struct lpfc_hba *phba = vport->phba;
 
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
-
+	/*
+	 * Set the re-reg VPI bit for f/w to update the MAC address.
+	 */
+	if ((phba->sli_rev == LPFC_SLI_REV4) &&
+		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI))
+		mb->un.varRegVpi.upd = 1;
 	mb->un.varRegVpi.vpi = vport->vpi + vport->phba->vpi_base;
 	mb->un.varRegVpi.sid = vport->fc_myDID;
 	mb->un.varRegVpi.vfi = vport->vfi + vport->phba->vfi_base;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-08-04 10:52:32.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-08-04 10:53:27.000000000 -0400
@@ -12295,12 +12295,9 @@ lpfc_sli4_fcf_scan_read_fcf_rec(struct l
 		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag |= FCF_DISC_INPROGRESS;
 		spin_unlock_irq(&phba->hbalock);
-		/* Reset FCF round robin index bmask for new scan */
-		if (fcf_index == LPFC_FCOE_FCF_GET_FIRST) {
-			memset(phba->fcf.fcf_rr_bmask, 0,
-			       sizeof(*phba->fcf.fcf_rr_bmask));
+		/* Reset eligible FCF count for new scan */
+		if (fcf_index == LPFC_FCOE_FCF_GET_FIRST)
 			phba->fcf.eligible_fcf_cnt = 0;
-		}
 		error = 0;
 	}
 fail_fcf_scan:


