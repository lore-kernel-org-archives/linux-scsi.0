From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/9] lpfc 8.2.3 : NPIV bug fixes
Date: Sat, 27 Oct 2007 13:37:17 -0400
Message-ID: <1193506637.8770.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46314 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXJ0RhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:12 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbAjv021352
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


NPIV bug fixes:
- Remove vport params on physical hba when npiv is disabled
- Implement new DA_ID CT command to remove vport information from
  the switch after delete. Some switches didn't clean this up unless
  the physical link dropped.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:37:26.000000000 -0400
@@ -1113,7 +1113,13 @@ MODULE_PARM_DESC(lpfc_sli_mode, "SLI mod
 		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
 		 " 3 - select SLI-3");
 
-LPFC_ATTR_R(enable_npiv, 0, 0, 1, "Enable NPIV functionality");
+int lpfc_enable_npiv = 0;
+module_param(lpfc_enable_npiv, int, 0);
+MODULE_PARM_DESC(lpfc_enable_npiv, "Enable NPIV functionality");
+lpfc_param_show(enable_npiv);
+lpfc_param_init(enable_npiv, 0, 0, 1);
+static CLASS_DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO,
+			 lpfc_enable_npiv_show, NULL);
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
@@ -1259,6 +1265,13 @@ LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0,
 		       "Verbose logging bit-mask");
 
 /*
+# lpfc_enable_da_id: This turns on the DA_ID CT command that deregisters
+# objects that have been registered with the nameserver after login.
+*/
+LPFC_VPORT_ATTR_R(enable_da_id, 0, 0, 1,
+		  "Deregister nameserver objects before LOGO");
+
+/*
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per FCP LUN. Value range is [1,128]. Default value is 30.
 */
@@ -1564,6 +1577,7 @@ struct class_device_attribute *lpfc_vpor
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
 	&class_device_attr_npiv_info,
+	&class_device_attr_lpfc_enable_da_id,
 	NULL,
 };
 
@@ -2349,69 +2363,13 @@ struct fc_function_template lpfc_transpo
 	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
 	.terminate_rport_io = lpfc_terminate_rport_io,
 
-	.vport_create = lpfc_vport_create,
-	.vport_delete = lpfc_vport_delete,
+	/* Vport fields are filled in at runtime based on enable_npiv */
+	.vport_create = NULL,
+	.vport_delete = NULL,
+	.vport_disable = NULL,
 	.dd_fcvport_size = sizeof(struct lpfc_vport *),
 };
 
-struct fc_function_template lpfc_vport_transport_functions = {
-	/* fixed attributes the driver supports */
-	.show_host_node_name = 1,
-	.show_host_port_name = 1,
-	.show_host_supported_classes = 1,
-	.show_host_supported_fc4s = 1,
-	.show_host_supported_speeds = 1,
-	.show_host_maxframe_size = 1,
-
-	/* dynamic attributes the driver supports */
-	.get_host_port_id = lpfc_get_host_port_id,
-	.show_host_port_id = 1,
-
-	.get_host_port_type = lpfc_get_host_port_type,
-	.show_host_port_type = 1,
-
-	.get_host_port_state = lpfc_get_host_port_state,
-	.show_host_port_state = 1,
-
-	/* active_fc4s is shown but doesn't change (thus no get function) */
-	.show_host_active_fc4s = 1,
-
-	.get_host_speed = lpfc_get_host_speed,
-	.show_host_speed = 1,
-
-	.get_host_fabric_name = lpfc_get_host_fabric_name,
-	.show_host_fabric_name = 1,
-
-	/*
-	 * The LPFC driver treats linkdown handling as target loss events
-	 * so there are no sysfs handlers for link_down_tmo.
-	 */
-
-	.get_fc_host_stats = lpfc_get_stats,
-	.reset_fc_host_stats = lpfc_reset_stats,
-
-	.dd_fcrport_size = sizeof(struct lpfc_rport_data),
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
-
-	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
-	.show_rport_dev_loss_tmo = 1,
-
-	.get_starget_port_id  = lpfc_get_starget_port_id,
-	.show_starget_port_id = 1,
-
-	.get_starget_node_name = lpfc_get_starget_node_name,
-	.show_starget_node_name = 1,
-
-	.get_starget_port_name = lpfc_get_starget_port_name,
-	.show_starget_port_name = 1,
-
-	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
-	.terminate_rport_io = lpfc_terminate_rport_io,
-
-	.vport_disable = lpfc_vport_disable,
-};
-
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
@@ -2460,5 +2418,6 @@ lpfc_get_vport_cfgparam(struct lpfc_vpor
 	lpfc_discovery_threads_init(vport, lpfc_discovery_threads);
 	lpfc_max_luns_init(vport, lpfc_max_luns);
 	lpfc_scan_down_init(vport, lpfc_scan_down);
+	lpfc_enable_da_id_init(vport, lpfc_enable_da_id);
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 10:37:14.000000000 -0400
@@ -260,8 +260,8 @@ extern struct class_device_attribute *lp
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
-extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
+extern int lpfc_enable_npiv;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 void lpfc_terminate_rport_io(struct fc_rport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-10-27 10:37:26.000000000 -0400
@@ -458,7 +458,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 			    ((lpfc_find_vport_by_did(phba, Did) == NULL) ||
 			     vport->cfg_peer_port_login)) {
 				if ((vport->port_type != LPFC_NPIV_PORT) ||
-				    (vport->fc_flag & FC_RFF_NOT_SUPPORTED) ||
+				    (!vport->ct_flags & FC_CT_RFF_ID) ||
 				    (!vport->cfg_restrict_login)) {
 					ndlp = lpfc_setup_disc_node(vport, Did);
 					if (ndlp) {
@@ -778,8 +778,8 @@ out:
 

 static void
-lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-			struct lpfc_iocbq *rspiocb)
+lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+	     struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_dmabuf *inp;
@@ -809,7 +809,7 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
 
 	/* RFT request completes status <ulpStatus> CmdRsp <CmdRsp> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-			 "0209 RFT request completes, latt %d, "
+			 "0209 CT Request completes, latt %d, "
 			 "ulpStatus x%x CmdRsp x%x, Context x%x, Tag x%x\n",
 			 latt, irsp->ulpStatus,
 			 CTrsp->CommandResponse.bits.CmdRsp,
@@ -848,10 +848,28 @@ out:
 }
 
 static void
+lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			struct lpfc_iocbq *rspiocb)
+{
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_vport *vport = cmdiocb->vport;
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS)
+		vport->ct_flags |= FC_CT_RFT_ID;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
+	return;
+}
+
+static void
 lpfc_cmpl_ct_cmd_rnn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
 {
-	lpfc_cmpl_ct_cmd_rft_id(phba, cmdiocb, rspiocb);
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_vport *vport = cmdiocb->vport;
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS)
+		vport->ct_flags |= FC_CT_RNN_ID;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
 
@@ -859,7 +877,12 @@ static void
 lpfc_cmpl_ct_cmd_rspn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 struct lpfc_iocbq *rspiocb)
 {
-	lpfc_cmpl_ct_cmd_rft_id(phba, cmdiocb, rspiocb);
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_vport *vport = cmdiocb->vport;
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS)
+		vport->ct_flags |= FC_CT_RSPN_ID;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
 
@@ -867,7 +890,24 @@ static void
 lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 struct lpfc_iocbq *rspiocb)
 {
-	lpfc_cmpl_ct_cmd_rft_id(phba, cmdiocb, rspiocb);
+	IOCB_t *irsp = &rspiocb->iocb;
+	struct lpfc_vport *vport = cmdiocb->vport;
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS)
+		vport->ct_flags |= FC_CT_RSNN_NN;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
+	return;
+}
+
+static void
+lpfc_cmpl_ct_cmd_da_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+ struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+
+	/* even if it fails we will act as though it succeeded. */
+	vport->ct_flags = 0;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
 
@@ -878,10 +918,9 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba 
 	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_vport *vport = cmdiocb->vport;
 
-	if (irsp->ulpStatus != IOSTAT_SUCCESS)
-	    vport->fc_flag |= FC_RFF_NOT_SUPPORTED;
-
-	lpfc_cmpl_ct_cmd_rft_id(phba, cmdiocb, rspiocb);
+	if (irsp->ulpStatus == IOSTAT_SUCCESS)
+		vport->ct_flags |= FC_CT_RFF_ID;
+	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
 	return;
 }
 
@@ -1001,6 +1040,8 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		bpl->tus.f.bdeSize = RSPN_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RSNN_NN)
 		bpl->tus.f.bdeSize = RSNN_REQUEST_SZ;
+	else if (cmdcode == SLI_CTNS_DA_ID)
+		bpl->tus.f.bdeSize = DA_ID_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RFF_ID)
 		bpl->tus.f.bdeSize = RFF_REQUEST_SZ;
 	else
@@ -1034,6 +1075,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		break;
 
 	case SLI_CTNS_RFT_ID:
+		vport->ct_flags &= ~FC_CT_RFT_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFT_ID);
 		CtReq->un.rft.PortId = be32_to_cpu(vport->fc_myDID);
@@ -1042,6 +1084,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		break;
 
 	case SLI_CTNS_RNN_ID:
+		vport->ct_flags &= ~FC_CT_RNN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RNN_ID);
 		CtReq->un.rnn.PortId = be32_to_cpu(vport->fc_myDID);
@@ -1051,6 +1094,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		break;
 
 	case SLI_CTNS_RSPN_ID:
+		vport->ct_flags &= ~FC_CT_RSPN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RSPN_ID);
 		CtReq->un.rspn.PortId = be32_to_cpu(vport->fc_myDID);
@@ -1061,6 +1105,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		cmpl = lpfc_cmpl_ct_cmd_rspn_id;
 		break;
 	case SLI_CTNS_RSNN_NN:
+		vport->ct_flags &= ~FC_CT_RSNN_NN;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RSNN_NN);
 		memcpy(CtReq->un.rsnn.wwnn, &vport->fc_nodename,
@@ -1071,8 +1116,15 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 			CtReq->un.rsnn.symbname, size);
 		cmpl = lpfc_cmpl_ct_cmd_rsnn_nn;
 		break;
+	case SLI_CTNS_DA_ID:
+		/* Implement DA_ID Nameserver request */
+		CtReq->CommandResponse.bits.CmdRsp =
+			be16_to_cpu(SLI_CTNS_DA_ID);
+		CtReq->un.da_id.port_id = be32_to_cpu(vport->fc_myDID);
+		cmpl = lpfc_cmpl_ct_cmd_da_id;
+		break;
 	case SLI_CTNS_RFF_ID:
-		vport->fc_flag &= ~FC_RFF_NOT_SUPPORTED;
+		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
 		CtReq->un.rff.PortId = be32_to_cpu(vport->fc_myDID);;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-10-27 10:37:26.000000000 -0400
@@ -272,10 +272,16 @@ struct lpfc_vport {
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	 /* NPort discovery active */
 #define FC_BYPASSED_MODE        0x20000	 /* NPort is in bypassed mode */
-#define FC_RFF_NOT_SUPPORTED    0x40000	 /* RFF_ID was rejected by switch */
 #define FC_VPORT_NEEDS_REG_VPI	0x80000  /* Needs to have its vpi registered */
 #define FC_RSCN_DEFERRED	0x100000 /* A deferred RSCN being processed */
 
+	uint32_t ct_flags;
+#define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
+#define FC_CT_RNN_ID		0x2	 /* RNN_ID accepted by switch */
+#define FC_CT_RSNN_NN		0x4	 /* RSNN_NN accepted by switch */
+#define FC_CT_RSPN_ID		0x8	 /* RSPN_ID accepted by switch */
+#define FC_CT_RFT_ID		0x10	 /* RFT_ID accepted by switch */
+
 	struct list_head fc_nodes;
 
 	/* Keep counters for the number of entries in each list. */
@@ -344,6 +350,7 @@ struct lpfc_vport {
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_max_luns;
+	uint32_t cfg_enable_da_id;
 
 	uint32_t dev_loss_tmo_changed;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 10:37:26.000000000 -0400
@@ -139,6 +139,9 @@ struct lpfc_sli_ct_request {
 			uint8_t len;
 			uint8_t symbname[255];
 		} rsnn;
+		struct da_id { /* For DA_ID requests */
+			uint32_t port_id;
+		} da_id;
 		struct rspn {	/* For RSPN_ID requests */
 			uint32_t PortId;
 			uint8_t len;
@@ -177,6 +180,8 @@ struct lpfc_sli_ct_request {
 			   sizeof(struct rnn))
 #define  RSNN_REQUEST_SZ  (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct rsnn))
+#define DA_ID_REQUEST_SZ (offsetof(struct lpfc_sli_ct_request, un) + \
+			  sizeof(struct da_id))
 #define  RSPN_REQUEST_SZ  (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct rspn))
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:33:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 10:37:14.000000000 -0400
@@ -2294,12 +2294,24 @@ lpfc_init(void)
 	printk(LPFC_MODULE_DESC "\n");
 	printk(LPFC_COPYRIGHT "\n");
 
+	if (lpfc_enable_npiv) {
+		lpfc_transport_functions.vport_create = lpfc_vport_create;
+		lpfc_transport_functions.vport_delete = lpfc_vport_delete;
+	}
 	lpfc_transport_template =
 				fc_attach_transport(&lpfc_transport_functions);
-	lpfc_vport_transport_template =
-			fc_attach_transport(&lpfc_vport_transport_functions);
-	if (!lpfc_transport_template || !lpfc_vport_transport_template)
+	if (lpfc_transport_template == NULL)
 		return -ENOMEM;
+	if (lpfc_enable_npiv) {
+		lpfc_transport_functions.vport_create = NULL;
+		lpfc_transport_functions.vport_delete = NULL;
+		lpfc_transport_functions.issue_fc_host_lip = NULL;
+		lpfc_transport_functions.vport_disable = lpfc_vport_disable;
+		lpfc_vport_transport_template =
+				fc_attach_transport(&lpfc_transport_functions);
+		if (lpfc_vport_transport_template == NULL)
+			return -ENOMEM;
+	}
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
 		fc_release_transport(lpfc_transport_template);
@@ -2314,7 +2326,8 @@ lpfc_exit(void)
 {
 	pci_unregister_driver(&lpfc_driver);
 	fc_release_transport(lpfc_transport_template);
-	fc_release_transport(lpfc_vport_transport_template);
+	if (lpfc_enable_npiv)
+		fc_release_transport(lpfc_vport_transport_template);
 }
 
 module_init(lpfc_init);
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-10-27 10:37:26.000000000 -0400
@@ -482,8 +482,18 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
 	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-		phba->link_state >= LPFC_LINK_UP) {
-
+	    phba->link_state >= LPFC_LINK_UP) {
+		if (vport->cfg_enable_da_id) {
+			timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
+			if (!lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0))
+				while (vport->ct_flags && timeout)
+					timeout = schedule_timeout(timeout);
+			else
+				lpfc_printf_log(vport->phba, KERN_WARNING,
+						LOG_VPORT,
+						"1829 CT command failed to "
+						"delete objects on fabric. \n");
+		}
 		/* First look for the Fabric ndlp */
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);
 		if (!ndlp) {


