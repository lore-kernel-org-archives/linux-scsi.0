From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.21: FC Discovery changes
Date: Wed, 16 Feb 2011 12:39:44 -0500
Message-ID: <1297877984.1492.26.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7549 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753698Ab1BPRkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:40:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FC Discovery changes

- Treat received PLOGI while logged in as a relogin (unregister and reregister).
- Added a timer to delay Nport discovery when clean bit is cleared and Fabric
  portname/nodename/FCID is changed.
- Invalidate Port's DID when receiving PLOGI from p2p port with CONFIG_PORT
  mailbox command.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    5 ++
 lpfc_attr.c      |   21 +++++++++
 lpfc_crtn.h      |    3 +
 lpfc_ct.c        |   49 ++++++++++++++++++++++
 lpfc_els.c       |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_hbadisc.c   |    7 +++
 lpfc_hw.h        |    6 ++
 lpfc_init.c      |    6 ++
 lpfc_nportdisc.c |   11 +++--
 9 files changed, 219 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-02-16 11:23:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-02-16 11:32:37.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -3365,6 +3365,25 @@ unsigned char lpfc_prot_guard = SHOST_DI
 module_param(lpfc_prot_guard, byte, 0);
 MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
 
+/*
+ * Delay initial NPort discovery when Clean Address bit is cleared in
+ * FLOGI/FDISC accept and FCID/Fabric name/Fabric portname is changed.
+ * This parameter can have value 0 or 1.
+ * When this parameter is set to 0, no delay is added to the initial
+ * discovery.
+ * When this parameter is set to non-zero value, initial Nport discovery is
+ * delayed by ra_tov seconds when Clean Address bit is cleared in FLOGI/FDISC
+ * accept and FCID/Fabric name/Fabric portname is changed.
+ * Driver always delay Nport discovery for subsequent FLOGI/FDISC completion
+ * when Clean Address bit is cleared in FLOGI/FDISC
+ * accept and FCID/Fabric name/Fabric portname is changed.
+ * Default value is 0.
+ */
+int lpfc_delay_discovery;
+module_param(lpfc_delay_discovery, int, 0);
+MODULE_PARM_DESC(lpfc_delay_discovery,
+	"Delay NPort discovery when Clean Address bit is cleared. "
+	"Allowed values: 0,1.");
 
 /*
  * lpfc_sg_seg_cnt - Initial Maximum DMA Segment Count
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-16 11:32:37.000000000 -0500
@@ -167,6 +167,8 @@ int lpfc_ns_cmd(struct lpfc_vport *, int
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_fdmi_tmo(unsigned long);
 void lpfc_fdmi_timeout_handler(struct lpfc_vport *);
+void lpfc_delayed_disc_tmo(unsigned long);
+void lpfc_delayed_disc_timeout_handler(struct lpfc_vport *);
 
 int lpfc_config_port_prep(struct lpfc_hba *);
 int lpfc_config_port_post(struct lpfc_hba *);
@@ -341,6 +343,7 @@ extern struct fc_function_template lpfc_
 extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
 extern int lpfc_enable_npiv;
+extern int lpfc_delay_discovery;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2011-02-16 11:32:37.000000000 -0500
@@ -1738,6 +1738,55 @@ fdmi_cmd_exit:
 	return 1;
 }
 
+/**
+ * lpfc_delayed_disc_tmo - Timeout handler for delayed discovery timer.
+ * @ptr - Context object of the timer.
+ *
+ * This function set the WORKER_DELAYED_DISC_TMO flag and wake up
+ * the worker thread.
+ **/
+void
+lpfc_delayed_disc_tmo(unsigned long ptr)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)ptr;
+	struct lpfc_hba   *phba = vport->phba;
+	uint32_t tmo_posted;
+	unsigned long iflag;
+
+	spin_lock_irqsave(&vport->work_port_lock, iflag);
+	tmo_posted = vport->work_port_events & WORKER_DELAYED_DISC_TMO;
+	if (!tmo_posted)
+		vport->work_port_events |= WORKER_DELAYED_DISC_TMO;
+	spin_unlock_irqrestore(&vport->work_port_lock, iflag);
+
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
+	return;
+}
+
+/**
+ * lpfc_delayed_disc_timeout_handler - Function called by worker thread to
+ *      handle delayed discovery.
+ * @vport: pointer to a host virtual N_Port data structure.
+ *
+ * This function start nport discovery of the vport.
+ **/
+void
+lpfc_delayed_disc_timeout_handler(struct lpfc_vport *vport)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	spin_lock_irq(shost->host_lock);
+	if (!(vport->fc_flag & FC_DISC_DELAYED)) {
+		spin_unlock_irq(shost->host_lock);
+		return;
+	}
+	vport->fc_flag &= ~FC_DISC_DELAYED;
+	spin_unlock_irq(shost->host_lock);
+
+	lpfc_do_scr_ns_plogi(vport->phba, vport);
+}
+
 void
 lpfc_fdmi_tmo(unsigned long ptr)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-02-16 11:32:37.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -485,6 +485,59 @@ fail:
 }
 
 /**
+ * lpfc_check_clean_addr_bit - Check whether assigned FCID is clean.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @sp: pointer to service parameter data structure.
+ *
+ * This routine is called from FLOGI/FDISC completion handler functions.
+ * lpfc_check_clean_addr_bit return 1 when FCID/Fabric portname/ Fabric
+ * node nodename is changed in the completion service parameter else return
+ * 0. This function also set flag in the vport data structure to delay
+ * NP_Port discovery after the FLOGI/FDISC completion if Clean address bit
+ * in FLOGI/FDISC response is cleared and FCID/Fabric portname/ Fabric
+ * node nodename is changed in the completion service parameter.
+ *
+ * Return code
+ *   0 - FCID and Fabric Nodename and Fabric portname is not changed.
+ *   1 - FCID or Fabric Nodename or Fabric portname is changed.
+ *
+ **/
+static uint8_t
+lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
+		struct serv_parm *sp)
+{
+	uint8_t fabric_param_changed = 0;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	if ((vport->fc_prevDID != vport->fc_myDID) ||
+		memcmp(&vport->fabric_portname, &sp->portName,
+			sizeof(struct lpfc_name)) ||
+		memcmp(&vport->fabric_nodename, &sp->nodeName,
+			sizeof(struct lpfc_name)))
+		fabric_param_changed = 1;
+
+	/*
+	 * Word 1 Bit 31 in common service parameter is overloaded.
+	 * Word 1 Bit 31 in FLOGI request is multiple NPort request
+	 * Word 1 Bit 31 in FLOGI response is clean address bit
+	 *
+	 * If fabric parameter is changed and clean address bit is
+	 * cleared delay nport discovery if
+	 * - vport->fc_prevDID != 0 (not initial discovery) OR
+	 * - lpfc_delay_discovery module parameter is set.
+	 */
+	if (fabric_param_changed && !sp->cmn.clean_address_bit &&
+	    (vport->fc_prevDID || lpfc_delay_discovery)) {
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= FC_DISC_DELAYED;
+		spin_unlock_irq(shost->host_lock);
+	}
+
+	return fabric_param_changed;
+}
+
+
+/**
  * lpfc_cmpl_els_flogi_fabric - Completion function for flogi to a fabric port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -512,6 +565,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *np;
 	struct lpfc_nodelist *next_np;
+	uint8_t fabric_param_changed;
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_FABRIC;
@@ -544,6 +598,12 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe = ((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) |
 				sp->cmn.bbRcvSizeLsb;
+
+	fabric_param_changed = lpfc_check_clean_addr_bit(vport, sp);
+	memcpy(&vport->fabric_portname, &sp->portName,
+			sizeof(struct lpfc_name));
+	memcpy(&vport->fabric_nodename, &sp->nodeName,
+			sizeof(struct lpfc_name));
 	memcpy(&phba->fc_fabparam, sp, sizeof(struct serv_parm));
 
 	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
@@ -565,7 +625,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		}
 	}
 
-	if ((vport->fc_prevDID != vport->fc_myDID) &&
+	if (fabric_param_changed &&
 		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
 
 		/* If our NportID changed, we need to ensure all
@@ -2203,6 +2263,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_sli *psli;
+	struct lpfcMboxq *mbox;
 
 	psli = &phba->sli;
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
@@ -2260,6 +2321,21 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 					NLP_EVT_CMPL_LOGO);
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
+	/* If we are in pt2pt mode, we could rcv new S_ID on PLOGI */
+	if ((vport->fc_flag & FC_PT2PT) &&
+		!(vport->fc_flag & FC_PT2PT_PLOGI)) {
+		phba->pport->fc_myDID = 0;
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (mbox) {
+			lpfc_config_link(phba, mbox);
+			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+			mbox->vport = vport;
+			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) ==
+				MBX_NOT_FINISHED) {
+				mempool_free(mbox, phba->mbox_mem_pool);
+			}
+		}
+	}
 	return;
 }
 
@@ -6181,6 +6257,11 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	if (vport->load_flag & FC_UNLOADING)
 		goto dropit;
 
+	/* If NPort discovery is delayed drop incoming ELS */
+	if ((vport->fc_flag & FC_DISC_DELAYED) &&
+			(cmd != ELS_CMD_PLOGI))
+		goto dropit;
+
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
@@ -6233,6 +6314,12 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
 
 		lpfc_send_els_event(vport, ndlp, payload);
+
+		/* If Nport discovery is delayed, reject PLOGIs */
+		if (vport->fc_flag & FC_DISC_DELAYED) {
+			rjt_err = LSRJT_UNABLE_TPC;
+			break;
+		}
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			if (!(phba->pport->fc_flag & FC_PT2PT) ||
 				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
@@ -6611,6 +6698,21 @@ void
 lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 {
 	struct lpfc_nodelist *ndlp, *ndlp_fdmi;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	/*
+	 * If lpfc_delay_discovery parameter is set and the clean address
+	 * bit is cleared and fc fabric parameters chenged, delay FC NPort
+	 * discovery.
+	 */
+	spin_lock_irq(shost->host_lock);
+	if (vport->fc_flag & FC_DISC_DELAYED) {
+		spin_unlock_irq(shost->host_lock);
+		mod_timer(&vport->delayed_disc_tmo,
+			jiffies + HZ * phba->fc_ratov);
+		return;
+	}
+	spin_unlock_irq(shost->host_lock);
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
 	if (!ndlp) {
@@ -6953,6 +7055,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 	struct lpfc_nodelist *next_np;
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_iocbq *piocb;
+	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
+	struct serv_parm *sp;
+	uint8_t fabric_param_changed;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0123 FDISC completes. x%x/x%x prevDID: x%x\n",
@@ -6996,7 +7101,14 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 
 	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
 	lpfc_vport_set_state(vport, FC_VPORT_ACTIVE);
-	if ((vport->fc_prevDID != vport->fc_myDID) &&
+	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
+	sp = prsp->virt + sizeof(uint32_t);
+	fabric_param_changed = lpfc_check_clean_addr_bit(vport, sp);
+	memcpy(&vport->fabric_portname, &sp->portName,
+		sizeof(struct lpfc_name));
+	memcpy(&vport->fabric_nodename, &sp->nodeName,
+		sizeof(struct lpfc_name));
+	if (fabric_param_changed &&
 		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
 		/* If our NportID changed, we need to ensure all
 		 * remaining NPORTs get unreg_login'ed so we can
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:32:37.000000000 -0500
@@ -325,6 +325,7 @@ struct lpfc_vport {
 #define FC_VPORT_CVL_RCVD	0x400000 /* VLink failed due to CVL	 */
 #define FC_VFI_REGISTERED	0x800000 /* VFI is registered */
 #define FC_FDISC_COMPLETED	0x1000000/* FDISC completed */
+#define FC_DISC_DELAYED		0x2000000/* Delay NPort discovery */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
@@ -348,6 +349,8 @@ struct lpfc_vport {
 
 	uint32_t fc_myDID;	/* fibre channel S_ID */
 	uint32_t fc_prevDID;	/* previous fibre channel S_ID */
+	struct lpfc_name fabric_portname;
+	struct lpfc_name fabric_nodename;
 
 	int32_t stopped;   /* HBA has not been restarted since last ERATT */
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
@@ -372,6 +375,7 @@ struct lpfc_vport {
 #define WORKER_DISC_TMO                0x1	/* vport: Discovery timeout */
 #define WORKER_ELS_TMO                 0x2	/* vport: ELS timeout */
 #define WORKER_FDMI_TMO                0x4	/* vport: FDMI timeout */
+#define WORKER_DELAYED_DISC_TMO        0x8	/* vport: delayed discovery */
 
 #define WORKER_MBOX_TMO                0x100	/* hba: MBOX timeout */
 #define WORKER_HB_TMO                  0x200	/* hba: Heart beat timeout */
@@ -382,6 +386,7 @@ struct lpfc_vport {
 
 	struct timer_list fc_fdmitmo;
 	struct timer_list els_tmofunc;
+	struct timer_list delayed_disc_tmo;
 
 	int unreg_vpi_cmpl;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-16 11:32:37.000000000 -0500
@@ -658,6 +658,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 				lpfc_ramp_down_queue_handler(phba);
 			if (work_port_events & WORKER_RAMP_UP_QUEUE)
 				lpfc_ramp_up_queue_handler(phba);
+			if (work_port_events & WORKER_DELAYED_DISC_TMO)
+				lpfc_delayed_disc_timeout_handler(vport);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
@@ -838,6 +840,11 @@ lpfc_linkdown_port(struct lpfc_vport *vp
 
 	lpfc_port_link_failure(vport);
 
+	/* Stop delayed Nport discovery */
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag &= ~FC_DISC_DELAYED;
+	spin_unlock_irq(shost->host_lock);
+	del_timer_sync(&vport->delayed_disc_tmo);
 }
 
 int
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-02-16 11:32:37.000000000 -0500
@@ -341,6 +341,12 @@ struct csp {
 	uint8_t bbCreditMsb;
 	uint8_t bbCreditlsb;	/* FC Word 0, byte 3 */
 
+/*
+ * Word 1 Bit 31 in common service parameter is overloaded.
+ * Word 1 Bit 31 in FLOGI request is multiple NPort request
+ * Word 1 Bit 31 in FLOGI response is clean address bit
+ */
+#define clean_address_bit request_multiple_Nport /* Word 1, bit 31 */
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint16_t request_multiple_Nport:1;	/* FC Word 1, bit 31 */
 	uint16_t randomOffset:1;	/* FC Word 1, bit 30 */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:32:37.000000000 -0500
@@ -2292,6 +2292,7 @@ lpfc_stop_vport_timers(struct lpfc_vport
 {
 	del_timer_sync(&vport->els_tmofunc);
 	del_timer_sync(&vport->fc_fdmitmo);
+	del_timer_sync(&vport->delayed_disc_tmo);
 	lpfc_can_disctmo(vport);
 	return;
 }
@@ -2733,6 +2734,11 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	init_timer(&vport->els_tmofunc);
 	vport->els_tmofunc.function = lpfc_els_timeout;
 	vport->els_tmofunc.data = (unsigned long)vport;
+
+	init_timer(&vport->delayed_disc_tmo);
+	vport->delayed_disc_tmo.function = lpfc_delayed_disc_tmo;
+	vport->delayed_disc_tmo.data = (unsigned long)vport;
+
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
 		goto out_put_shost;
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2011-02-16 11:32:37.000000000 -0500
@@ -350,7 +350,11 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 
-	/* no need to reg_login if we are already in one of these states */
+	/*
+	 * Need to unreg_login if we are already in one of these states and
+	 * change to NPR state. This will block the port until after the ACC
+	 * completes and the reg_login is issued and completed.
+	 */
 	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
@@ -359,8 +363,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
-		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
-		return 1;
+		lpfc_unreg_rpi(vport, ndlp);
+		ndlp->nlp_prev_state = ndlp->nlp_state;
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	}
 
 	if ((vport->fc_flag & FC_PT2PT) &&


