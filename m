From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/8] lpfc 8.3.8: BugFixes: Discovery relates changes
Date: Tue, 26 Jan 2010 23:08:03 -0500
Message-ID: <1264565303.2972.2.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39133 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042Ab0A0EIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:08:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Discovery relates changes:
- Separated VPI_REGISTERED state of physical port into VFI_REGISTERED and
  VPI_REGISTERED state so that driver can unregister physical port VPI
  independent of VFI.
- Add code to unregister, re-init and re-register physical port VPI
  when physical port NportID change.
- Add code to unregister and re-register VPI of a vport when its Nport
  ID change.
- Add code in FDISC completion path to re-start FLOGI discovery when
  a FDISC complete with LOGIN_REQUIRED reason code.
- Fix a memory leak in lpfc_init_vpi_cmpl
- Add code to start a timer for vport to retry FDISC when CVL is received
  by a vport or physical port. If all Nports receive CVLs, then all timers
  are cancelled and a logical link level discovery will be started after
  one second.
- Flush ELS commands after killing all delayed ELS commands.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    3 +
 lpfc_crtn.h      |    5 ++
 lpfc_els.c       |  129 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lpfc_hbadisc.c   |   36 ++++++++++++++-
 lpfc_init.c      |   44 +++++++++++++++++-
 lpfc_nportdisc.c |    2 
 lpfc_sli.c       |   62 ++++++++++++++++++++++++++
 lpfc_vport.c     |    2 
 8 files changed, 265 insertions(+), 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-01-22 21:24:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-01-22 21:25:35.000000000 -0500
@@ -44,6 +44,8 @@ int lpfc_reg_rpi(struct lpfc_hba *, uint
 void lpfc_unreg_login(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_unreg_did(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_reg_vpi(struct lpfc_vport *, LPFC_MBOXQ_t *);
+void lpfc_register_new_vport(struct lpfc_hba *, struct lpfc_vport *,
+			struct lpfc_nodelist *);
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
@@ -52,10 +54,13 @@ struct lpfc_vport *lpfc_find_vport_by_di
 void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
 void lpfc_rcv_seq_check_edtov(struct lpfc_vport *);
 void lpfc_cleanup_rpis(struct lpfc_vport *, int);
+void lpfc_cleanup_pending_mbox(struct lpfc_vport *);
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_linkdown_port(struct lpfc_vport *);
 void lpfc_port_link_failure(struct lpfc_vport *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_init_vpi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_retry_pport_discovery(struct lpfc_hba *);
 
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-01-22 21:24:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-01-22 21:25:35.000000000 -0500
@@ -50,9 +50,6 @@ static int lpfc_issue_els_fdisc(struct l
 				struct lpfc_nodelist *ndlp, uint8_t retry);
 static int lpfc_issue_fabric_iocb(struct lpfc_hba *phba,
 				  struct lpfc_iocbq *iocb);
-static void lpfc_register_new_vport(struct lpfc_hba *phba,
-				    struct lpfc_vport *vport,
-				    struct lpfc_nodelist *ndlp);
 
 static int lpfc_max_els_tries = 3;
 
@@ -604,10 +601,13 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 	} else {
 		ndlp->nlp_type |= NLP_FABRIC;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
-		if (vport->vpi_state & LPFC_VPI_REGISTERED) {
+		if ((!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) &&
+			(vport->vpi_state & LPFC_VPI_REGISTERED)) {
 			lpfc_start_fdiscs(phba);
 			lpfc_do_scr_ns_plogi(phba, vport);
-		} else
+		} else if (vport->fc_flag & FC_VFI_REGISTERED)
+			lpfc_register_new_vport(phba, vport, ndlp);
+		else
 			lpfc_issue_reg_vfi(vport);
 	}
 	return 0;
@@ -804,6 +804,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 				 irsp->ulpTimeout);
 		goto flogifail;
 	}
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
+	spin_unlock_irq(shost->host_lock);
 
 	/*
 	 * The FLogI succeeded.  Sync the data for the CPU before
@@ -2720,7 +2723,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 	if (did == FDMI_DID)
 		retry = 1;
 
-	if ((cmd == ELS_CMD_FLOGI) &&
+	if (((cmd == ELS_CMD_FLOGI) || (cmd == ELS_CMD_FDISC)) &&
 	    (phba->fc_topology != TOPOLOGY_LOOP) &&
 	    !lpfc_error_lost_link(irsp)) {
 		/* FLOGI retry policy */
@@ -5915,6 +5918,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 	MAILBOX_t *mb = &pmb->u.mb;
+	int rc;
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
@@ -5936,6 +5940,26 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			spin_unlock_irq(shost->host_lock);
 			lpfc_can_disctmo(vport);
 			break;
+		/* If reg_vpi fail with invalid VPI status, re-init VPI */
+		case 0x20:
+			spin_lock_irq(shost->host_lock);
+			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			spin_unlock_irq(shost->host_lock);
+			lpfc_init_vpi(phba, pmb, vport->vpi);
+			pmb->vport = vport;
+			pmb->mbox_cmpl = lpfc_init_vpi_cmpl;
+			rc = lpfc_sli_issue_mbox(phba, pmb,
+				MBX_NOWAIT);
+			if (rc == MBX_NOT_FINISHED) {
+				lpfc_printf_vlog(vport,
+					KERN_ERR, LOG_MBOX,
+					"2732 Failed to issue INIT_VPI"
+					" mailbox command\n");
+			} else {
+				lpfc_nlp_put(ndlp);
+				return;
+			}
+
 		default:
 			/* Try to recover from this error */
 			lpfc_mbx_unreg_vpi(vport);
@@ -5949,13 +5973,17 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 			break;
 		}
 	} else {
+		spin_lock_irq(shost->host_lock);
 		vport->vpi_state |= LPFC_VPI_REGISTERED;
-		if (vport == phba->pport)
+		spin_unlock_irq(shost->host_lock);
+		if (vport == phba->pport) {
 			if (phba->sli_rev < LPFC_SLI_REV4)
 				lpfc_issue_fabric_reglogin(vport);
-			else
-				lpfc_issue_reg_vfi(vport);
-		else
+			else {
+				lpfc_start_fdiscs(phba);
+				lpfc_do_scr_ns_plogi(phba, vport);
+			}
+		} else
 			lpfc_do_scr_ns_plogi(phba, vport);
 	}
 
@@ -5977,7 +6005,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
  * This routine registers the @vport as a new virtual port with a HBA.
  * It is done through a registering vpi mailbox command.
  **/
-static void
+void
 lpfc_register_new_vport(struct lpfc_hba *phba, struct lpfc_vport *vport,
 			struct lpfc_nodelist *ndlp)
 {
@@ -6018,6 +6046,78 @@ mbox_err_exit:
 }
 
 /**
+ * lpfc_retry_pport_discovery - Start timer to retry FLOGI.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine abort all pending discovery commands and
+ * start a timer to retry FLOGI for the physical port
+ * discovery.
+ **/
+void
+lpfc_retry_pport_discovery(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host  *shost;
+	int i;
+	uint32_t link_state;
+
+	/* Treat this failure as linkdown for all vports */
+	link_state = phba->link_state;
+	lpfc_linkdown(phba);
+	phba->link_state = link_state;
+
+	vports = lpfc_create_vport_work_array(phba);
+
+	if (vports) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			ndlp = lpfc_findnode_did(vports[i], Fabric_DID);
+			if (ndlp)
+				lpfc_cancel_retry_delay_tmo(vports[i], ndlp);
+			lpfc_els_flush_cmd(vports[i]);
+		}
+		lpfc_destroy_vport_work_array(phba, vports);
+	}
+
+	/* If fabric require FLOGI, then re-instantiate physical login */
+	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
+	if (!ndlp)
+		return;
+
+
+	shost = lpfc_shost_from_vport(phba->pport);
+	mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
+	spin_lock_irq(shost->host_lock);
+	ndlp->nlp_flag |= NLP_DELAY_TMO;
+	spin_unlock_irq(shost->host_lock);
+	ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
+	phba->pport->port_state = LPFC_FLOGI;
+	return;
+}
+
+/**
+ * lpfc_fabric_login_reqd - Check if FLOGI required.
+ * @phba: pointer to lpfc hba data structure.
+ * @cmdiocb: pointer to FDISC command iocb.
+ * @rspiocb: pointer to FDISC response iocb.
+ *
+ * This routine checks if a FLOGI is reguired for FDISC
+ * to succeed.
+ **/
+static int
+lpfc_fabric_login_reqd(struct lpfc_hba *phba,
+		struct lpfc_iocbq *cmdiocb,
+		struct lpfc_iocbq *rspiocb)
+{
+
+	if ((rspiocb->iocb.ulpStatus != IOSTAT_FABRIC_RJT) ||
+		(rspiocb->iocb.un.ulpWord[4] != RJT_LOGIN_REQUIRED))
+		return 0;
+	else
+		return 1;
+}
+
+/**
  * lpfc_cmpl_els_fdisc - Completion function for fdisc iocb command
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
@@ -6066,6 +6166,12 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		irsp->ulpStatus, irsp->un.ulpWord[4], vport->fc_prevDID);
 
 	if (irsp->ulpStatus) {
+
+		if (lpfc_fabric_login_reqd(phba, cmdiocb, rspiocb)) {
+			lpfc_retry_pport_discovery(phba);
+			goto out;
+		}
+
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
@@ -6076,6 +6182,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		goto fdisc_failed;
 	}
 	spin_lock_irq(shost->host_lock);
+	vport->fc_flag &= ~FC_VPORT_CVL_RCVD;
 	vport->fc_flag |= FC_FABRIC;
 	if (vport->phba->fc_topology == TOPOLOGY_LOOP)
 		vport->fc_flag |=  FC_PUBLIC_LOOP;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-01-07 08:20:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-01-22 21:25:35.000000000 -0500
@@ -315,6 +315,9 @@ struct lpfc_vport {
 #define FC_VPORT_NEEDS_REG_VPI	0x80000  /* Needs to have its vpi registered */
 #define FC_RSCN_DEFERRED	0x100000 /* A deferred RSCN being processed */
 #define FC_VPORT_NEEDS_INIT_VPI 0x200000 /* Need to INIT_VPI before FDISC */
+#define FC_VPORT_CVL_RCVD	0x400000 /* VLink failed due to CVL	 */
+#define FC_VFI_REGISTERED	0x800000 /* VFI is registered */
+#define FC_FDISC_COMPLETED	0x1000000/* FDISC completed */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-01-22 12:35:18.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-01-22 21:25:35.000000000 -0500
@@ -706,6 +706,8 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 void
 lpfc_port_link_failure(struct lpfc_vport *vport)
 {
+	lpfc_vport_set_state(vport, FC_VPORT_LINKDOWN);
+
 	/* Cleanup any outstanding received buffers */
 	lpfc_cleanup_rcv_buffers(vport);
 
@@ -1695,10 +1697,11 @@ out:
  *
  * This function handles completion of init vpi mailbox command.
  */
-static void
+void
 lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport = mboxq->vport;
+	struct lpfc_nodelist *ndlp;
 	if (mboxq->u.mb.mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR,
 				LOG_MBOX,
@@ -1712,6 +1715,20 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 	vport->fc_flag &= ~FC_VPORT_NEEDS_INIT_VPI;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* If this port is physical port or FDISC is done, do reg_vpi */
+	if ((phba->pport == vport) || (vport->port_state == LPFC_FDISC)) {
+			ndlp = lpfc_findnode_did(vport, Fabric_DID);
+			if (!ndlp)
+				lpfc_printf_vlog(vport, KERN_ERR,
+					LOG_DISCOVERY,
+					"2731 Cannot find fabric "
+					"controller node\n");
+			else
+				lpfc_register_new_vport(phba, vport, ndlp);
+			mempool_free(mboxq, phba->mbox_mem_pool);
+			return;
+	}
+
 	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
 		lpfc_initial_fdisc(vport);
 	else {
@@ -1719,6 +1736,7 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "2606 No NPIV Fabric support\n");
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 	return;
 }
 
@@ -1814,6 +1832,9 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 	}
 	/* The VPI is implicitly registered when the VFI is registered */
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
+	vport->fc_flag |= FC_VFI_REGISTERED;
+
+	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
 		lpfc_start_fdiscs(phba);
@@ -2333,6 +2354,7 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *p
 	}
 
 	vport->vpi_state |= LPFC_VPI_REGISTERED;
+	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
 	if (vport->fc_npr_cnt)
@@ -4462,6 +4484,7 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	int rc;
 	struct lpfc_vport **vports;
 	int i;
+	struct lpfc_nodelist *ndlp;
 
 	spin_lock_irq(&phba->hbalock);
 	/*
@@ -4489,6 +4512,10 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	if (vports &&
 		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			/* Stop FLOGI/FDISC retries */
+			ndlp = lpfc_findnode_did(vports[i], Fabric_DID);
+			if (ndlp)
+				lpfc_cancel_retry_delay_tmo(vports[i], ndlp);
 			lpfc_mbx_unreg_vpi(vports[i]);
 			spin_lock_irq(&phba->hbalock);
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
@@ -4497,6 +4524,9 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
+	/* Cleanup any outstanding ELS commands */
+	lpfc_els_flush_all_cmd(phba);
+
 	/* Unregister VFI */
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox) {
@@ -4521,6 +4551,10 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 		return;
 	}
 
+	spin_lock_irq(&phba->hbalock);
+	phba->pport->fc_flag &= ~FC_VFI_REGISTERED;
+	spin_unlock_irq(&phba->hbalock);
+
 	/* Unregister FCF */
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox) {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-01-07 08:20:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-01-22 21:25:35.000000000 -0500
@@ -2246,6 +2246,9 @@ lpfc_offline_prep(struct lpfc_hba * phba
 			if (vports[i]->load_flag & FC_UNLOADING)
 				continue;
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
+			vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			vports[i]->fc_flag &= ~FC_VFI_REGISTERED;
+
 			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
@@ -3007,6 +3010,9 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host  *shost;
 	uint32_t link_state;
+	int active_vlink_present;
+	struct lpfc_vport **vports;
+	int i;
 
 	phba->fc_eventTag = acqe_fcoe->event_tag;
 	phba->fcoe_eventtag = acqe_fcoe->event_tag;
@@ -3074,14 +3080,46 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		if (!ndlp)
 			break;
 		shost = lpfc_shost_from_vport(vport);
+		if (phba->pport->port_state <= LPFC_FLOGI)
+			break;
+		/* If virtual link is not yet instantiated ignore CVL */
+		if (vport->port_state <= LPFC_FDISC)
+			break;
+
 		lpfc_linkdown_port(vport);
-		if (vport->port_type != LPFC_NPIV_PORT) {
+		lpfc_cleanup_pending_mbox(vport);
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= FC_VPORT_CVL_RCVD;
+		spin_unlock_irq(shost->host_lock);
+		active_vlink_present = 0;
+
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports) {
+			for (i = 0; i <= phba->max_vports && vports[i] != NULL;
+					i++) {
+				if ((!(vports[i]->fc_flag &
+					FC_VPORT_CVL_RCVD)) &&
+					(vports[i]->port_state > LPFC_FDISC)) {
+					active_vlink_present = 1;
+					break;
+				}
+			}
+			lpfc_destroy_vport_work_array(phba, vports);
+		}
+
+		if (active_vlink_present) {
+			/*
+			 * If there are other active VLinks present,
+			 * re-instantiate the Vlink using FDISC.
+			 */
 			mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ);
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 			spin_unlock_irq(shost->host_lock);
-			ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
-			vport->port_state = LPFC_FLOGI;
+			ndlp->nlp_last_elscmd = ELS_CMD_FDISC;
+			vport->port_state = LPFC_FDISC;
+		} else {
+			lpfc_retry_pport_discovery(phba);
 		}
 		break;
 	default:
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-01-22 21:24:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2010-01-22 21:25:35.000000000 -0500
@@ -254,7 +254,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	int rc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
-	if (vport->port_state <= LPFC_FLOGI) {
+	if (vport->port_state <= LPFC_FDISC) {
 		/* Before responding to PLOGI, check for pt2pt mode.
 		 * If we are pt2pt, with an outstanding FLOGI, abort
 		 * the FLOGI and resend it first.
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-01-22 21:24:42.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-01-22 21:25:35.000000000 -0500
@@ -1710,6 +1710,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 	struct lpfc_dmabuf *mp;
 	uint16_t rpi, vpi;
 	int rc;
+	struct lpfc_vport  *vport = pmb->vport;
 
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
 
@@ -1738,6 +1739,18 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 			return;
 	}
 
+	/* Unreg VPI, if the REG_VPI succeed after VLink failure */
+	if ((pmb->u.mb.mbxCommand == MBX_REG_VPI) &&
+		!(phba->pport->load_flag & FC_UNLOADING) &&
+		!pmb->u.mb.mbxStatus) {
+		lpfc_unreg_vpi(phba, pmb->u.mb.un.varRegVpi.vpi, pmb);
+		pmb->vport = vport;
+		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if (rc != MBX_NOT_FINISHED)
+			return;
+	}
+
 	if (bf_get(lpfc_mqe_command, &pmb->u.mqe) == MBX_SLI4_CONFIG)
 		lpfc_sli4_mbox_cmd_free(phba, pmb);
 	else
@@ -8440,8 +8453,10 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 					wcqe->total_data_placed;
 		else
 			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
-	else
+	else {
 		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+		pIocbIn->iocb.un.genreq64.bdl.bdeSize = wcqe->total_data_placed;
+	}
 
 	/* Pick up HBA exchange busy condition */
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
@@ -12139,3 +12154,48 @@ out:
 	kfree(rgn23_data);
 	return;
 }
+
+/**
+ * lpfc_cleanup_pending_mbox - Free up vport discovery mailbox commands.
+ * @vport: pointer to vport data structure.
+ *
+ * This function iterate through the mailboxq and clean up all REG_LOGIN
+ * and REG_VPI mailbox commands associated with the vport. This function
+ * is called when driver want to restart discovery of the vport due to
+ * a Clear Virtual Link event.
+ **/
+void
+lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
+{
+	struct lpfc_hba *phba = vport->phba;
+	LPFC_MBOXQ_t *mb, *nextmb;
+	struct lpfc_dmabuf *mp;
+
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
+		if (mb->vport != vport)
+			continue;
+
+		if ((mb->u.mb.mbxCommand != MBX_REG_LOGIN64) &&
+			(mb->u.mb.mbxCommand != MBX_REG_VPI))
+			continue;
+
+		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+			mp = (struct lpfc_dmabuf *) (mb->context1);
+			if (mp) {
+				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
+		}
+		list_del(&mb->list);
+		mempool_free(mb, phba->mbox_mem_pool);
+	}
+	mb = phba->sli.mbox_active;
+	if (mb && (mb->vport == vport)) {
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) ||
+			(mb->u.mb.mbxCommand == MBX_REG_VPI))
+			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	}
+	spin_unlock_irq(&phba->hbalock);
+}
+
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-01-07 08:20:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-01-22 21:25:35.000000000 -0500
@@ -389,7 +389,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	 * by the port.
 	 */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
-	    (pport->vpi_state & LPFC_VPI_REGISTERED)) {
+		(pport->fc_flag & FC_VFI_REGISTERED)) {
 		rc = lpfc_sli4_init_vpi(phba, vpi);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,


