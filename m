From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/7] bfa: update bfa driver to version 2.1.2.1 part 5
Date: Thu, 19 Nov 2009 16:15:19 -0800
Message-ID: <1258676119-18249-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:26604 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbZKTAPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 19:15:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/fabric.c     |  294 ++++++++++++++++-----------------
 drivers/scsi/bfa/fcbuild.c    |  124 ++++++--------
 drivers/scsi/bfa/fcbuild.h    |  299 ++++++++++++++++++++--------------
 drivers/scsi/bfa/fcpim.c      |  182 +++++++++------------
 drivers/scsi/bfa/fcs_fabric.h |   52 +++---
 drivers/scsi/bfa/fcs_fcpim.h  |    8 +-
 drivers/scsi/bfa/fcs_fcptm.h  |   22 ++--
 drivers/scsi/bfa/fcs_lport.h  |   38 ++--
 drivers/scsi/bfa/fcs_port.h   |    3 +-
 drivers/scsi/bfa/fcs_rport.h  |   21 +--
 drivers/scsi/bfa/fcs_uf.h     |    3 +-
 drivers/scsi/bfa/fcs_vport.h  |    9 -
 drivers/scsi/bfa/fdmi.c       |  364 +++++++++++++++++++++++------------------
 drivers/scsi/bfa/loop.c       |   23 ++--
 drivers/scsi/bfa/lport_api.c  |   54 ++++---
 15 files changed, 763 insertions(+), 733 deletions(-)

diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index a4b5dd4..a1a213f 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -33,35 +33,36 @@
 
 BFA_TRC_FILE(FCS, FABRIC);
 
-#define BFA_FCS_FABRIC_RETRY_DELAY	(2000)	/* Milliseconds */
+#define BFA_FCS_FABRIC_RETRY_DELAY		(2000)	/* Milliseconds */
 #define BFA_FCS_FABRIC_CLEANUP_DELAY	(10000)	/* Milliseconds */
 
-#define bfa_fcs_fabric_set_opertype(__fabric) do {             \
-	if (bfa_pport_get_topology((__fabric)->fcs->bfa)       \
-				== BFA_PPORT_TOPOLOGY_P2P)     \
-		(__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;  \
-	else                                                   \
-		(__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT; \
-} while (0)
+#define bfa_fcs_fabric_set_opertype(__fabric) do {			\
+		if (bfa_fcport_get_topology((__fabric)->fcs->bfa)	\
+		    == BFA_PPORT_TOPOLOGY_P2P)				\
+			(__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;	\
+		else							\
+			(__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT;	\
+	} while (0)
 
 /*
  * forward declarations
  */
-static void     bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_delay(void *cbarg);
-static void     bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_delete_comp(void *cbarg);
-static void     bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_delay(void *cbarg);
+static void	bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_delete_comp(void *cbarg);
+static void	bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric,
 					  struct fchs_s *fchs, u16 len);
-static void     bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
 					     struct fchs_s *fchs, u16 len);
-static void     bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric);
-static void     bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
+static void	bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric);
+static void	bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
 					     struct bfa_fcxp_s *fcxp,
-					     void *cbarg, bfa_status_t status,
+					     void *cbarg,
+					     bfa_status_t status,
 					     u32 rsp_len,
 					     u32 resid_len,
 					     struct fchs_s *rspfchs);
@@ -73,54 +74,51 @@ static void     bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
  * Fabric state machine events
  */
 enum bfa_fcs_fabric_event {
-	BFA_FCS_FABRIC_SM_CREATE = 1,	/*  fabric create from driver */
-	BFA_FCS_FABRIC_SM_DELETE = 2,	/*  fabric delete from driver */
-	BFA_FCS_FABRIC_SM_LINK_DOWN = 3,	/*  link down from port */
-	BFA_FCS_FABRIC_SM_LINK_UP = 4,	/*  link up from port */
-	BFA_FCS_FABRIC_SM_CONT_OP = 5,	/*  continue op from flogi/auth */
-	BFA_FCS_FABRIC_SM_RETRY_OP = 6,	/*  continue op from flogi/auth */
-	BFA_FCS_FABRIC_SM_NO_FABRIC = 7,	/*  no fabric from flogi/auth
-						 */
-	BFA_FCS_FABRIC_SM_PERF_EVFP = 8,	/*  perform EVFP from
-						 *flogi/auth */
-	BFA_FCS_FABRIC_SM_ISOLATE = 9,	/*  isolate from EVFP processing */
-	BFA_FCS_FABRIC_SM_NO_TAGGING = 10,/*  no VFT tagging from EVFP */
-	BFA_FCS_FABRIC_SM_DELAYED = 11,	/*  timeout delay event */
-	BFA_FCS_FABRIC_SM_AUTH_FAILED = 12,	/*  authentication failed */
-	BFA_FCS_FABRIC_SM_AUTH_SUCCESS = 13,	/*  authentication successful
-						 */
-	BFA_FCS_FABRIC_SM_DELCOMP = 14,	/*  all vports deleted event */
-	BFA_FCS_FABRIC_SM_LOOPBACK = 15,	/*  Received our own FLOGI */
-	BFA_FCS_FABRIC_SM_START = 16,	/*  fabric delete from driver */
+	BFA_FCS_FABRIC_SM_CREATE	= 1,  /*  fabric create from driver */
+	BFA_FCS_FABRIC_SM_DELETE	= 2,  /*  fabric delete from driver */
+	BFA_FCS_FABRIC_SM_LINK_DOWN	= 3,  /*  link down from port */
+	BFA_FCS_FABRIC_SM_LINK_UP	= 4,  /*  link up from port */
+	BFA_FCS_FABRIC_SM_CONT_OP	= 5,  /*  continue op from flogi/auth*/
+	BFA_FCS_FABRIC_SM_RETRY_OP	= 6,  /*  continue op from flogi/auth*/
+	BFA_FCS_FABRIC_SM_NO_FABRIC	= 7,  /*  no fabric from flogi/auth */
+	BFA_FCS_FABRIC_SM_PERF_EVFP	= 8, /*  perform EVFP from flogi/auth*/
+	BFA_FCS_FABRIC_SM_ISOLATE	= 9, /*  isolate from EVFP processing*/
+	BFA_FCS_FABRIC_SM_NO_TAGGING	= 10, /*  no VFT tagging from EVFP */
+	BFA_FCS_FABRIC_SM_DELAYED	= 11, /*  timeout delay event */
+	BFA_FCS_FABRIC_SM_AUTH_FAILED	= 12, /*  authentication failed */
+	BFA_FCS_FABRIC_SM_AUTH_SUCCESS	= 13, /*  authentication successful */
+	BFA_FCS_FABRIC_SM_DELCOMP	= 14, /*  all vports deleted event */
+	BFA_FCS_FABRIC_SM_LOOPBACK	= 15, /*  Received our own FLOGI */
+	BFA_FCS_FABRIC_SM_START		= 16, /*  fabric delete from driver */
 };
 
-static void     bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
 					 enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
 					  enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_linkdown(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_linkdown(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 					enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
 					      enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 				       enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
 					      enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 					 enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
 				       enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
 					    enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-static void     bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
+static void	bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
 /**
  *   Beginning state before fabric creation.
@@ -136,8 +134,7 @@ bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
 	case BFA_FCS_FABRIC_SM_CREATE:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_created);
 		bfa_fcs_fabric_init(fabric);
-		bfa_fcs_lport_init(&fabric->bport, fabric->fcs, FC_VF_ID_NULL,
-				   &fabric->bport.port_cfg, NULL);
+		bfa_fcs_lport_init(&fabric->bport, &fabric->bport.port_cfg);
 		break;
 
 	case BFA_FCS_FABRIC_SM_LINK_UP:
@@ -161,7 +158,7 @@ bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
 
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_START:
-		if (bfa_pport_is_linkup(fabric->fcs->bfa)) {
+		if (bfa_fcport_is_linkup(fabric->fcs->bfa)) {
 			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi);
 			bfa_fcs_fabric_login(fabric);
 		} else
@@ -225,7 +222,8 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_CONT_OP:
 
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa,
+					  fabric->bb_credit);
 		fabric->fab_type = BFA_FCS_FABRIC_SWITCHED;
 
 		if (fabric->auth_reqd && fabric->is_auth) {
@@ -252,7 +250,8 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_NO_FABRIC:
 		fabric->fab_type = BFA_FCS_FABRIC_N2N;
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa,
+					  fabric->bb_credit);
 		bfa_fcs_fabric_notify_online(fabric);
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_nofabric);
 		break;
@@ -308,7 +307,7 @@ bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
  */
 static void
 bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
-		       enum bfa_fcs_fabric_event event)
+			enum bfa_fcs_fabric_event event)
 {
 	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
 	bfa_trc(fabric->fcs, event);
@@ -419,7 +418,8 @@ bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_NO_FABRIC:
 		bfa_trc(fabric->fcs, fabric->bb_credit);
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa,
+					  fabric->bb_credit);
 		break;
 
 	default:
@@ -467,7 +467,7 @@ bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
  */
 static void
 bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
-		       enum bfa_fcs_fabric_event event)
+			enum bfa_fcs_fabric_event event)
 {
 	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
 	bfa_trc(fabric->fcs, event);
@@ -563,32 +563,24 @@ void
 bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
-	struct bfa_adapter_attr_s adapter_attr;
-	struct bfa_fcs_driver_info_s *driver_info = &fabric->fcs->driver_info;
+    char            model[BFA_ADAPTER_MODEL_NAME_LEN] = {0};
+	struct bfa_fcs_driver_info_s  *driver_info = &fabric->fcs->driver_info;
 
-	bfa_os_memset((void *)&adapter_attr, 0,
-		      sizeof(struct bfa_adapter_attr_s));
-	bfa_ioc_get_adapter_attr(&fabric->fcs->bfa->ioc, &adapter_attr);
+    bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
-	/*
-	 * Model name/number
-	 */
-	strncpy((char *)&port_cfg->sym_name, adapter_attr.model,
+	/* Model name/number */
+	strncpy((char *)&port_cfg->sym_name, model,
 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
 
-	/*
-	 * Driver Version
-	 */
+	/* Driver Version */
 	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
 		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
 
-	/*
-	 * Host machine name
-	 */
+	/* Host machine name */
 	strncat((char *)&port_cfg->sym_name,
 		(char *)driver_info->host_machine_name,
 		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
@@ -602,7 +594,8 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	 */
 	if (driver_info->host_os_patch[0] == '\0') {
 		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_name, BFA_FCS_OS_STR_LEN);
+			(char *)driver_info->host_os_name,
+			BFA_FCS_OS_STR_LEN);
 		strncat((char *)&port_cfg->sym_name,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
@@ -614,17 +607,13 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
 
-		/*
-		 * Append host OS Patch Info
-		 */
+		/* Append host OS Patch Info */
 		strncat((char *)&port_cfg->sym_name,
 			(char *)driver_info->host_os_patch,
 			BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ);
 	}
 
-	/*
-	 * null terminate
-	 */
+	/* null terminate */
 	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
 }
 
@@ -645,9 +634,7 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 		break;
 
 	case BFA_STATUS_INVALID_MAC:
-		/*
-		 * Only for CNA
-		 */
+		/* Only for CNA */
 		fabric->stats.flogi_acc_err++;
 		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_RETRY_OP);
 
@@ -685,7 +672,7 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 	bfa_trc(fabric->fcs, fabric->bb_credit);
 
 	if (!bfa_lps_is_brcd_fabric(fabric->lps))
-		fabric->fabric_name = bfa_lps_get_peer_nwwn(fabric->lps);
+		fabric->fabric_name =  bfa_lps_get_peer_nwwn(fabric->lps);
 
 	/*
 	 * Check port type. It should be 1 = F-port.
@@ -708,21 +695,20 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 	bfa_trc(fabric->fcs, fabric->is_npiv);
 	bfa_trc(fabric->fcs, fabric->is_auth);
 }
-
 /**
- * 		Allocate and send FLOGI.
+ *		Allocate and send FLOGI.
  */
 static void
 bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric)
 {
-	struct bfa_s   *bfa = fabric->fcs->bfa;
-	struct bfa_port_cfg_s *pcfg = &fabric->bport.port_cfg;
-	u8         alpa = 0;
+	struct bfa_s		*bfa = fabric->fcs->bfa;
+	struct bfa_port_cfg_s	*pcfg = &fabric->bport.port_cfg;
+	u8			alpa = 0;
 
-	if (bfa_pport_get_topology(bfa) == BFA_PPORT_TOPOLOGY_LOOP)
-		alpa = bfa_pport_get_myalpa(bfa);
+	if (bfa_fcport_get_topology(bfa) == BFA_PPORT_TOPOLOGY_LOOP)
+		alpa = bfa_fcport_get_myalpa(bfa);
 
-	bfa_lps_flogi(fabric->lps, fabric, alpa, bfa_pport_get_maxfrsize(bfa),
+	bfa_lps_flogi(fabric->lps, fabric, alpa, bfa_fcport_get_maxfrsize(bfa),
 		      pcfg->pwwn, pcfg->nwwn, fabric->auth_reqd);
 
 	fabric->stats.flogi_sent++;
@@ -732,7 +718,7 @@ static void
 bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_fcs_vport_s *vport;
-	struct list_head *qe, *qen;
+	struct list_head	      *qe, *qen;
 
 	bfa_trc(fabric->fcs, fabric->fabric_name);
 
@@ -745,7 +731,7 @@ bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric)
 	bfa_fcs_port_online(&fabric->bport);
 
 	list_for_each_safe(qe, qen, &fabric->vport_q) {
-		vport = (struct bfa_fcs_vport_s *)qe;
+		vport = (struct bfa_fcs_vport_s *) qe;
 		bfa_fcs_vport_online(vport);
 	}
 }
@@ -754,7 +740,7 @@ static void
 bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_fcs_vport_s *vport;
-	struct list_head *qe, *qen;
+	struct list_head	      *qe, *qen;
 
 	bfa_trc(fabric->fcs, fabric->fabric_name);
 	fabric->stats.fabric_offlines++;
@@ -763,7 +749,7 @@ bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric)
 	 * notify offline event first to vports and then base port.
 	 */
 	list_for_each_safe(qe, qen, &fabric->vport_q) {
-		vport = (struct bfa_fcs_vport_s *)qe;
+		vport = (struct bfa_fcs_vport_s *) qe;
 		bfa_fcs_vport_offline(vport);
 	}
 
@@ -788,10 +774,10 @@ static void
 bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_fcs_vport_s *vport;
-	struct list_head *qe, *qen;
+	struct list_head	      *qe, *qen;
 
 	list_for_each_safe(qe, qen, &fabric->vport_q) {
-		vport = (struct bfa_fcs_vport_s *)qe;
+		vport = (struct bfa_fcs_vport_s *) qe;
 		bfa_fcs_vport_delete(vport);
 	}
 
@@ -814,10 +800,10 @@ bfa_fcs_fabric_delete_comp(void *cbarg)
  */
 
 /**
- *   Module initialization
+ * Attach time initialization.
  */
 void
-bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_fabric_s *fabric;
 
@@ -834,14 +820,20 @@ bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 	bfa_assert(fabric->lps);
 
 	/**
-	 * Initialize fabric delete completion handler. Fabric deletion is complete
-	 * when the last vport delete is complete.
+	 * Initialize fabric delete completion handler. Fabric deletion is
+	 * complete when the last vport delete is complete.
 	 */
 	bfa_wc_init(&fabric->wc, bfa_fcs_fabric_delete_comp, fabric);
-	bfa_wc_up(&fabric->wc);	/* For the base port */
+	bfa_wc_up(&fabric->wc); /* For the base port */
 
 	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
-	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CREATE);
+	bfa_fcs_lport_attach(&fabric->bport, fabric->fcs, FC_VF_ID_NULL, NULL);
+}
+
+void
+bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
+{
+	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
 	bfa_trc(fcs, 0);
 }
 
@@ -890,6 +882,12 @@ bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric)
 	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_loopback);
 }
 
+bfa_boolean_t
+bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric)
+{
+	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_auth_failed);
+}
+
 enum bfa_pport_type
 bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric)
 {
@@ -964,6 +962,7 @@ bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric)
 	bfa_wc_down(&fabric->wc);
 }
 
+
 /**
  *    Check if fabric is online.
  *
@@ -977,11 +976,13 @@ bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
 	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online);
 }
 
-
+/**
+ *	brief
+ *
+ */
 bfa_status_t
 bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf, struct bfa_fcs_s *fcs,
-		     struct bfa_port_cfg_s *port_cfg,
-		     struct bfad_vf_s *vf_drv)
+		     struct bfa_port_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
 {
 	bfa_sm_set_state(vf, bfa_fcs_fabric_sm_uninit);
 	return BFA_STATUS_OK;
@@ -994,10 +995,10 @@ struct bfa_fcs_vport_s *
 bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
 {
 	struct bfa_fcs_vport_s *vport;
-	struct list_head *qe;
+	struct list_head	      *qe;
 
 	list_for_each(qe, &fabric->vport_q) {
-		vport = (struct bfa_fcs_vport_s *)qe;
+		vport = (struct bfa_fcs_vport_s *) qe;
 		if (bfa_fcs_port_get_pwwn(&vport->lport) == pwwn)
 			return vport;
 	}
@@ -1010,7 +1011,7 @@ bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
  *
  *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
  *
-*    @return : 1 or more.
+ *   @return : 1 or more.
  */
 u16
 bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
@@ -1019,15 +1020,15 @@ bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
 }
 
 /**
- * 		Unsolicited frame receive handling.
+ *		Unsolicited frame receive handling.
  */
 void
 bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
-		       u16 len)
+					u16 len)
 {
-	u32        pid = fchs->d_id;
+	u32	pid = fchs->d_id;
 	struct bfa_fcs_vport_s *vport;
-	struct list_head *qe;
+	struct list_head	      *qe;
 	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
 	struct fc_logi_s     *flogi = (struct fc_logi_s *) els_cmd;
 
@@ -1075,7 +1076,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	 * look for a matching local port ID
 	 */
 	list_for_each(qe, &fabric->vport_q) {
-		vport = (struct bfa_fcs_vport_s *)qe;
+		vport = (struct bfa_fcs_vport_s *) qe;
 		if (vport->lport.pid == pid) {
 			bfa_fcs_port_uf_recv(&vport->lport, fchs, len);
 			return;
@@ -1086,7 +1087,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 }
 
 /**
- * 		Unsolicited frames to be processed by fabric.
+ *		Unsolicited frames to be processed by fabric.
  */
 static void
 bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
@@ -1110,11 +1111,11 @@ bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 }
 
 /**
- * 	Process	incoming FLOGI
+ *	Process	incoming FLOGI
  */
 static void
 bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
-			struct fchs_s *fchs, u16 len)
+				struct fchs_s *fchs, u16 len)
 {
 	struct fc_logi_s     *flogi = (struct fc_logi_s *) (fchs + 1);
 	struct bfa_fcs_port_s *bport = &fabric->bport;
@@ -1150,10 +1151,10 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_port_cfg_s *pcfg = &fabric->bport.port_cfg;
 	struct bfa_fcs_port_n2n_s *n2n_port = &fabric->bport.port_topo.pn2n;
-	struct bfa_s   *bfa = fabric->fcs->bfa;
+	struct bfa_s	  *bfa = fabric->fcs->bfa;
 	struct bfa_fcxp_s *fcxp;
-	u16        reqlen;
-	struct fchs_s          fchs;
+	u16	reqlen;
+	struct fchs_s		fchs;
 
 	fcxp = bfa_fcs_fcxp_alloc(fabric->fcs);
 	/**
@@ -1165,15 +1166,16 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 	reqlen = fc_flogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 				    bfa_os_hton3b(FC_FABRIC_PORT),
 				    n2n_port->reply_oxid, pcfg->pwwn,
-				    pcfg->nwwn, bfa_pport_get_maxfrsize(bfa),
-				    bfa_pport_get_rx_bbcredit(bfa));
+				    pcfg->nwwn,
+				    bfa_fcport_get_maxfrsize(bfa),
+				    bfa_fcport_get_rx_bbcredit(bfa));
 
 	bfa_fcxp_send(fcxp, NULL, fabric->vf_id, bfa_lps_get_tag(fabric->lps),
-			BFA_FALSE, FC_CLASS_3, reqlen, &fchs,
-			bfa_fcs_fabric_flogiacc_comp, fabric,
-			FC_MAX_PDUSZ, 0); /* Timeout 0 indicates no
-					   * response expected
-					   */
+		      BFA_FALSE, FC_CLASS_3,
+		      reqlen, &fchs, bfa_fcs_fabric_flogiacc_comp, fabric,
+		      FC_MAX_PDUSZ, 0);	/* Timeout 0 indicates no
+					 * response expected
+					 */
 }
 
 /**
@@ -1214,24 +1216,17 @@ static void
 bfa_fcs_fabric_aen_post(struct bfa_fcs_port_s *port,
 			enum bfa_port_aen_event event)
 {
-	union bfa_aen_data_u aen_data;
+	union bfa_aen_data_u  aen_data;
 	struct bfa_log_mod_s *logmod = port->fcs->logm;
-	wwn_t           pwwn = bfa_fcs_port_get_pwwn(port);
-	wwn_t           fwwn = bfa_fcs_port_get_fabric_name(port);
-	char            pwwn_ptr[BFA_STRING_32];
-	char            fwwn_ptr[BFA_STRING_32];
+	wwn_t pwwn = bfa_fcs_port_get_pwwn(port);
+	wwn_t fwwn = bfa_fcs_port_get_fabric_name(port);
+	char  pwwn_ptr[BFA_STRING_32];
+	char  fwwn_ptr[BFA_STRING_32];
 
 	wwn2str(pwwn_ptr, pwwn);
 	wwn2str(fwwn_ptr, fwwn);
-
-	switch (event) {
-	case BFA_PORT_AEN_FABRIC_NAME_CHANGE:
-		bfa_log(logmod, BFA_AEN_PORT_FABRIC_NAME_CHANGE, pwwn_ptr,
-			fwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, event),
+			pwwn_ptr, fwwn_ptr);
 
 	aen_data.port.pwwn = pwwn;
 	aen_data.port.fwwn = fwwn;
@@ -1246,7 +1241,7 @@ bfa_fcs_fabric_aen_post(struct bfa_fcs_port_s *port,
  */
 void
 bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
-			       wwn_t fabric_name)
+				wwn_t fabric_name)
 {
 	bfa_trc(fabric->fcs, fabric_name);
 
@@ -1258,15 +1253,12 @@ bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 		fabric->fabric_name = fabric_name;
 	} else {
 		fabric->fabric_name = fabric_name;
-		/*
-		 * Generate a Event
-		 */
+		/* Generate a Event */
 		bfa_fcs_fabric_aen_post(&fabric->bport,
-					BFA_PORT_AEN_FABRIC_NAME_CHANGE);
+				BFA_PORT_AEN_FABRIC_NAME_CHANGE);
 	}
 
 }
-
 /**
  * Not used by FCS.
  */
diff --git a/drivers/scsi/bfa/fcbuild.c b/drivers/scsi/bfa/fcbuild.c
index fee5456..078b4d4 100644
--- a/drivers/scsi/bfa/fcbuild.c
+++ b/drivers/scsi/bfa/fcbuild.c
@@ -24,10 +24,10 @@
 /*
  * static build functions
  */
-static void fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id);
-static void fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id);
+static void     fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+				 u16 ox_id);
+static void     fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+				 u16 ox_id);
 static struct fchs_s   fc_els_req_tmpl;
 static struct fchs_s   fc_els_rsp_tmpl;
 static struct fchs_s   fc_bls_req_tmpl;
@@ -123,7 +123,7 @@ fcbuild_init(void)
 	rrq_tmpl.els_cmd.els_code = FC_ELS_RRQ;
 
 	/*
-	 * fcp_fchs_tmpl
+	 * fcp_struct fchs_smpl
 	 */
 	fcp_fchs_tmpl.routing = FC_RTG_FC4_DEV_DATA;
 	fcp_fchs_tmpl.cat_info = FC_CAT_UNSOLICIT_CMD;
@@ -135,8 +135,7 @@ fcbuild_init(void)
 }
 
 static void
-fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u32 ox_id)
+fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 {
 	bfa_os_memset(fchs, 0, sizeof(struct fchs_s));
 
@@ -158,8 +157,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 }
 
 void
-fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id)
+fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
 	bfa_os_memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = (d_id);
@@ -168,8 +166,7 @@ fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 }
 
 static void
-fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id)
+fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
 	bfa_os_memcpy(fchs, &fc_els_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
@@ -199,8 +196,7 @@ fc_els_rsp_parse(struct fchs_s *fchs, int len)
 }
 
 static void
-fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id)
+fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
 	bfa_os_memcpy(fchs, &fc_bls_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
@@ -452,8 +448,8 @@ fc_prli_parse(struct fc_prli_s *prli)
 }
 
 u16
-fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id,
-			u32 s_id, u16 ox_id, wwn_t port_name)
+fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
+	      u16 ox_id, wwn_t port_name)
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
@@ -524,7 +520,7 @@ fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len, wwn_t port_name,
 
 enum fc_parse_status
 fc_adisc_parse(struct fchs_s *fchs, void *pld, u32 host_dap,
-		 wwn_t node_name, wwn_t port_name)
+		wwn_t node_name, wwn_t port_name)
 {
 	struct fc_adisc_s     *adisc = (struct fc_adisc_s *) pld;
 
@@ -548,7 +544,7 @@ fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
 		return FC_PARSE_FAILURE;
 
 	if ((bfa_os_ntohs(pdisc->class3.rxsz) <
-		 (FC_MIN_PDUSZ - sizeof(struct fchs_s)))
+			(FC_MIN_PDUSZ - sizeof(struct fchs_s)))
 	    || (pdisc->class3.rxsz == 0))
 		return FC_PARSE_FAILURE;
 
@@ -585,7 +581,7 @@ fc_abts_rsp_parse(struct fchs_s *fchs, int len)
 
 u16
 fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id,
-			 u32 s_id, u16 ox_id, u16 rrq_oxid)
+		u32 s_id, u16 ox_id, u16 rrq_oxid)
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
@@ -647,8 +643,8 @@ fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 }
 
 u16
-fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd,
-			u32 d_id, u32 s_id, u16 ox_id)
+fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd, u32 d_id,
+		u32 s_id, u16 ox_id)
 {
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 	memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
@@ -676,8 +672,7 @@ fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
 
 u16
 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			int num_pages)
+		u32 d_id, u32 s_id, u16 ox_id, int num_pages)
 {
 	int             page;
 
@@ -701,8 +696,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
 
 u16
 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			int num_pages)
+		u32 d_id, u32 s_id, u16 ox_id, int num_pages)
 {
 	int             page;
 
@@ -726,7 +720,7 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
 
 u16
 fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
-			u32 s_id, u16 ox_id, u32 data_format)
+	u32 s_id, u16 ox_id, u32 data_format)
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
@@ -740,10 +734,10 @@ fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
 
 u16
 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			u32 data_format,
-			struct fc_rnid_common_id_data_s *common_id_data,
-			struct fc_rnid_general_topology_data_s *gen_topo_data)
+		  u32 d_id, u32 s_id, u16 ox_id,
+		  u32 data_format,
+		  struct fc_rnid_common_id_data_s *common_id_data,
+		  struct fc_rnid_general_topology_data_s *gen_topo_data)
 {
 	memset(rnid_acc, 0, sizeof(struct fc_rnid_acc_s));
 
@@ -769,7 +763,7 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc,
 
 u16
 fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
-			u32 s_id, u16 ox_id)
+		u32 s_id, u16 ox_id)
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
@@ -780,9 +774,8 @@ fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
 }
 
 u16
-fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2,
-			u32 d_id, u32 s_id, u32 *pid_list,
-			u16 npids)
+fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
+		u32 s_id, u32 *pid_list, u16 npids)
 {
 	u32 dctlr_id = FC_DOMAIN_CTRLR(bfa_os_hton3b(d_id));
 	int i = 0;
@@ -797,14 +790,13 @@ fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2,
 	for (i = 0; i < npids; i++)
 		rpsc2->pid_list[i].pid = pid_list[i];
 
-	return sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) *
-			(sizeof(u32)));
+	return sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) * (sizeof(u32)));
 }
 
 u16
 fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			struct fc_rpsc_speed_info_s *oper_speed)
+		u32 d_id, u32 s_id, u16 ox_id,
+		  struct fc_rpsc_speed_info_s *oper_speed)
 {
 	memset(rpsc_acc, 0, sizeof(struct fc_rpsc_acc_s));
 
@@ -842,8 +834,7 @@ fc_logo_rsp_parse(struct fchs_s *fchs, int len)
 
 u16
 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, wwn_t port_name, wwn_t node_name,
-			u16 pdu_size)
+	u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size)
 {
 	struct fc_logi_s     *pdisc = (struct fc_logi_s *) (fchs + 1);
 
@@ -942,8 +933,8 @@ fc_prlo_rsp_parse(struct fchs_s *fchs, int len)
 
 u16
 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, int num_pages,
-			enum fc_tprlo_type tprlo_type, u32 tpr_id)
+	u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
+	u32 tpr_id)
 {
 	struct fc_tprlo_s     *tprlo = (struct fc_tprlo_s *) (fchs + 1);
 	int             page;
@@ -1014,8 +1005,7 @@ fc_rrq_rsp_parse(struct fchs_s *fchs, int len)
 
 u16
 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, u32 reason_code,
-			u32 reason_expl)
+	u16 ox_id, u32 reason_code, u32 reason_expl)
 {
 	struct fc_ba_rjt_s    *ba_rjt = (struct fc_ba_rjt_s *) (fchs + 1);
 
@@ -1064,8 +1054,7 @@ fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_gidpn_req_s *gidpn =
-			(struct fcgs_gidpn_req_s *) (cthdr + 1);
+	struct fcgs_gidpn_req_s *gidpn = (struct fcgs_gidpn_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
@@ -1125,7 +1114,7 @@ fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
 
 u16
 fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr, u8 set_br_reg,
-			u32 s_id, u16 ox_id)
+		u32 s_id, u16 ox_id)
 {
 	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
 
@@ -1142,7 +1131,7 @@ fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr, u8 set_br_reg,
 
 u16
 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn, u32 s_id,
-			u16 ox_id)
+		u16 ox_id)
 {
 	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
 	u16        payldlen;
@@ -1165,8 +1154,7 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       enum bfa_port_role roles)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rftid_req_s *rftid =
-			(struct fcgs_rftid_req_s *) (cthdr + 1);
+	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
 	u32        type_value, d_id = bfa_os_hton3b(FC_NAME_SERVER);
 	u8         index;
 
@@ -1193,12 +1181,10 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 
 u16
 fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u16 ox_id, u8 *fc4_bitmap,
-			u32 bitmap_size)
+	u16 ox_id, u8 *fc4_bitmap, u32 bitmap_size)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rftid_req_s *rftid =
-			(struct fcgs_rftid_req_s *) (cthdr + 1);
+	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
@@ -1208,7 +1194,7 @@ fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
 
 	rftid->dap = s_id;
 	bfa_os_memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
-			(bitmap_size < 32 ? bitmap_size : 32));
+(bitmap_size < 32 ? bitmap_size : 32));
 
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
@@ -1218,8 +1204,7 @@ fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       u8 fc4_type, u8 fc4_ftrs)
 {
 	struct ct_hdr_s         *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rffid_req_s *rffid =
-			(struct fcgs_rffid_req_s *) (cthdr + 1);
+	struct fcgs_rffid_req_s *rffid = (struct fcgs_rffid_req_s *)(cthdr + 1);
 	u32         d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
@@ -1241,7 +1226,7 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rspnid_req_s *rspnid =
-			(struct fcgs_rspnid_req_s *) (cthdr + 1);
+			(struct fcgs_rspnid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
@@ -1257,13 +1242,11 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 }
 
 u16
-fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u8 fc4_type)
+fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 {
 
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_gidft_req_s *gidft =
-			(struct fcgs_gidft_req_s *) (cthdr + 1);
+	struct fcgs_gidft_req_s *gidft = (struct fcgs_gidft_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1283,8 +1266,7 @@ fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       wwn_t port_name)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rpnid_req_s *rpnid =
-			(struct fcgs_rpnid_req_s *) (cthdr + 1);
+	struct fcgs_rpnid_req_s *rpnid = (struct fcgs_rpnid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1302,8 +1284,7 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       wwn_t node_name)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rnnid_req_s *rnnid =
-			(struct fcgs_rnnid_req_s *) (cthdr + 1);
+	struct fcgs_rnnid_req_s *rnnid = (struct fcgs_rnnid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1321,8 +1302,7 @@ fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       u32 cos)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rcsid_req_s *rcsid =
-			(struct fcgs_rcsid_req_s *) (cthdr + 1);
+	struct fcgs_rcsid_req_s *rcsid = (struct fcgs_rcsid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1340,8 +1320,7 @@ fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       u8 port_type)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rptid_req_s *rptid =
-			(struct fcgs_rptid_req_s *) (cthdr + 1);
+	struct fcgs_rptid_req_s *rptid = (struct fcgs_rptid_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1358,8 +1337,7 @@ u16
 fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
 {
 	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_ganxt_req_s *ganxt =
-			(struct fcgs_ganxt_req_s *) (cthdr + 1);
+	struct fcgs_ganxt_req_s *ganxt = (struct fcgs_ganxt_req_s *)(cthdr + 1);
 	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
@@ -1420,7 +1398,7 @@ fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GMAL_CMD,
-			CT_GSSUBTYPE_CFGSERVER);
+					CT_GSSUBTYPE_CFGSERVER);
 
 	bfa_os_memset(gmal, 0, sizeof(fcgs_gmal_req_t));
 	gmal->wwn = wwn;
@@ -1440,7 +1418,7 @@ fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GFN_CMD,
-			CT_GSSUBTYPE_CFGSERVER);
+					CT_GSSUBTYPE_CFGSERVER);
 
 	bfa_os_memset(gfn, 0, sizeof(fcgs_gfn_req_t));
 	gfn->wwn = wwn;
diff --git a/drivers/scsi/bfa/fcbuild.h b/drivers/scsi/bfa/fcbuild.h
index 8fa7f27..3bef787 100644
--- a/drivers/scsi/bfa/fcbuild.h
+++ b/drivers/scsi/bfa/fcbuild.h
@@ -55,7 +55,7 @@ fc_get_ctresp_pyld_len(u32 resp_len)
 /*
  * Convert bfa speed to rpsc speed value.
  */
-static inline enum bfa_pport_speed
+static inline  enum bfa_pport_speed
 fc_rpsc_operspeed_to_bfa_speed(enum fc_rpsc_op_speed_s speed)
 {
 	switch (speed) {
@@ -72,6 +72,9 @@ fc_rpsc_operspeed_to_bfa_speed(enum fc_rpsc_op_speed_s speed)
 	case RPSC_OP_SPEED_8G:
 		return BFA_PPORT_SPEED_8GBPS;
 
+	case RPSC_OP_SPEED_10G:
+		return BFA_PPORT_SPEED_10GBPS;
+
 	default:
 		return BFA_PPORT_SPEED_UNKNOWN;
 	}
@@ -97,6 +100,9 @@ fc_bfa_speed_to_rpsc_operspeed(enum bfa_pport_speed op_speed)
 	case BFA_PPORT_SPEED_8GBPS:
 		return RPSC_OP_SPEED_8G;
 
+	case BFA_PPORT_SPEED_10GBPS:
+		return RPSC_OP_SPEED_10G;
+
 	default:
 		return RPSC_OP_SPEED_NOT_EST;
 	}
@@ -125,149 +131,204 @@ struct fc_templates_s {
 	struct fc_rrq_s        rrq;
 };
 
-void fcbuild_init(void);
-
-u16 fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
-			u32 s_id, u16 ox_id, wwn_t port_name,
-			wwn_t node_name, u16 pdu_size, u8 set_npiv,
-			u8 set_auth, u16 local_bb_credits);
-u16 fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi,
-			u32 s_id, u16 ox_id, wwn_t port_name,
-			wwn_t node_name, u16 pdu_size);
-u16 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
-			u32 s_id, u16 ox_id, wwn_t port_name,
-			wwn_t node_name, u16 pdu_size,
-			u16 local_bb_credits);
-u16 fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
-			u32 s_id, u16 ox_id, wwn_t port_name,
-			wwn_t node_name, u16 pdu_size);
+void            fcbuild_init(void);
+
+u16        fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
+				u32 s_id, u16 ox_id, wwn_t port_name,
+				wwn_t node_name, u16 pdu_size,
+				u8 set_npiv, u8 set_auth,
+				u16 local_bb_credits);
+
+u16        fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi,
+				u32 s_id, u16 ox_id, wwn_t port_name,
+				wwn_t node_name, u16 pdu_size);
+
+u16        fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
+				   u32 s_id, u16 ox_id,
+				   wwn_t port_name, wwn_t node_name,
+				   u16 pdu_size,
+				   u16 local_bb_credits);
+
+u16        fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			       u32 s_id, u16 ox_id, wwn_t port_name,
+			       wwn_t node_name, u16 pdu_size);
+
 enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
-u16 fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
-			u16 ox_id);
+
+u16        fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
+			      u16 ox_id);
+
 enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
-u16 fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq, u32 d_id,
-			u32 s_id, u16 ox_id, u16 rrq_oxid);
+
+u16        fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u16 rrq_oxid);
 enum fc_parse_status fc_rrq_rsp_parse(struct fchs_s *buf, int len);
-u16 fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
-			u16 ox_id, u8 *name);
-u16 fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
-			u16 ox_id, enum bfa_port_role role);
-u16 fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u16 ox_id, u8 *fc4_bitmap,
-			u32 bitmap_size);
-u16 fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+
+u16        fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+				u16 ox_id, u8 *name);
+
+u16        fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			       u16 ox_id, enum bfa_port_role role);
+
+u16       fc_rftid_build_sol(struct fchs_s *fchs, void *pyld,
+				u32 s_id, u16 ox_id,
+				u8 *fc4_bitmap, u32 bitmap_size);
+
+u16	fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			u16 ox_id, u8 fc4_type, u8 fc4_ftrs);
-u16 fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u16 ox_id, wwn_t port_name);
-u16 fc_gpnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
-			u16 ox_id, u32 port_id);
-u16 fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
+
+u16        fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u16 ox_id, wwn_t port_name);
+
+u16        fc_gpnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			       u16 ox_id, u32 port_id);
+
+u16        fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 			u8 set_br_reg, u32 s_id, u16 ox_id);
-u16 fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
-			u32 s_id, u16 ox_id,
-			wwn_t port_name, wwn_t node_name, u16 pdu_size);
 
-u16 fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			wwn_t port_name, wwn_t node_name);
+u16        fc_plogi_acc_build(struct fchs_s *fchs, void *pld,
+				u32 d_id, u32 s_id,
+				u16 ox_id, wwn_t port_name,
+				wwn_t node_name, u16 pdu_size);
+
+u16        fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
+				u32 d_id, u32 s_id, u16 ox_id,
+				wwn_t port_name, wwn_t node_name);
+
 enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
-			u32 host_dap,
-			wwn_t node_name, wwn_t port_name);
+			u32 host_dap, wwn_t node_name, wwn_t port_name);
+
 enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
-			wwn_t port_name, wwn_t node_name);
-u16 fc_adisc_acc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			wwn_t port_name, wwn_t node_name);
-u16 fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt,
-			u32 d_id, u32 s_id, u16 ox_id,
-			u8 reason_code, u8 reason_code_expl);
-u16 fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd,
-			u32 d_id, u32 s_id, u16 ox_id);
-u16 fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id,
-			u32 s_id, u16 ox_id);
+				 wwn_t port_name, wwn_t node_name);
+
+u16        fc_adisc_acc_build(struct fchs_s *fchs,
+				struct fc_adisc_s *adisc, u32 d_id,
+				u32 s_id, u16 ox_id,
+				wwn_t port_name, wwn_t node_name);
+u16        fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt,
+				u32 d_id, u32 s_id, u16 ox_id,
+				u8 reason_code, u8 reason_code_expl);
+u16        fc_ls_acc_build(struct fchs_s *fchs,
+				struct fc_els_cmd_s *els_cmd,
+				u32 d_id, u32 s_id, u16 ox_id);
+u16        fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			      u32 s_id, u16 ox_id);
+
 enum fc_parse_status fc_prli_rsp_parse(struct fc_prli_s *prli, int len);
 
-u16 fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
-			u32 s_id, u16 ox_id,
-			enum bfa_port_role role);
-u16 fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
-			u32 d_id, u32 s_id, u16 ox_id,
-			u32 data_format);
-u16 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			u32 data_format,
-			struct fc_rnid_common_id_data_s *common_id_data,
-			struct fc_rnid_general_topology_data_s *
-			gen_topo_data);
-u16 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rps2c,
-			u32 d_id, u32 s_id,
-			u32 *pid_list, u16 npids);
-u16 fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
-			u32 d_id, u32 s_id, u16 ox_id);
-u16 fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			struct fc_rpsc_speed_info_s *oper_speed);
-u16 fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
-			u8 fc4_type);
-u16 fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u32 port_id, wwn_t port_name);
-u16 fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u32 port_id, wwn_t node_name);
-u16 fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u32 port_id, u32 cos);
-u16 fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u32 port_id, u8 port_type);
-u16 fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u32 port_id);
-u16 fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo,
-			u32 d_id, u32 s_id, u16 ox_id,
-			wwn_t port_name);
-u16 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
-			u32 s_id, u16 ox_id);
-u16 fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u16 cmd_code);
-u16 fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			wwn_t wwn);
-u16 fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			wwn_t wwn);
-void fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
-void fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id);
-enum fc_parse_status fc_els_rsp_parse(struct fchs_s *fchs, int len);
-enum fc_parse_status fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
-			 wwn_t port_name);
-enum fc_parse_status fc_prli_parse(struct fc_prli_s *prli);
-enum fc_parse_status fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
-			wwn_t port_name);
+u16        fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
+				  u32 s_id, u16 ox_id,
+				  enum bfa_port_role role);
+
+u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
+			      u32 d_id, u32 s_id, u16 ox_id,
+			      u32 data_format);
+
+u16        fc_rnid_acc_build(struct fchs_s *fchs,
+				struct fc_rnid_acc_s *rnid_acc, u32 d_id,
+				u32 s_id, u16 ox_id,
+				u32 data_format,
+				struct fc_rnid_common_id_data_s *common_id_data,
+			struct fc_rnid_general_topology_data_s *gen_topo_data);
+
+u16 	fc_rpsc2_build(struct fchs_s *fchs,
+				struct fc_rpsc2_cmd_s *rps2c,
+				u32 d_id, u32 s_id,
+				u32 *pid_list, u16 npids);
+u16        fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
+			      u32 d_id, u32 s_id, u16 ox_id);
+u16        fc_rpsc_acc_build(struct fchs_s *fchs,
+				struct fc_rpsc_acc_s *rpsc_acc,
+				  u32 d_id, u32 s_id, u16 ox_id,
+				  struct fc_rpsc_speed_info_s *oper_speed);
+u16        fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
+				u8 fc4_type);
+
+u16        fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u32 port_id, wwn_t port_name);
+
+u16        fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u32 port_id, wwn_t node_name);
+
+u16        fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u32 port_id, u32 cos);
+
+u16        fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u32 port_id, u8 port_type);
+
+u16        fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			       u32 port_id);
+
+u16        fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo,
+				u32 d_id, u32 s_id, u16 ox_id,
+				wwn_t port_name);
+
+u16        fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
+				  u32 s_id, u16 ox_id);
+
+u16        fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld,
+				u32 s_id, u16 cmd_code);
+u16 	fc_gmal_req_build(struct fchs_s *fchs, void *pyld,
+					u32 s_id, wwn_t wwn);
+u16 	fc_gfn_req_build(struct fchs_s *fchs, void *pyld,
+					u32 s_id, wwn_t wwn);
+
+void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
+
+void		fc_els_req_build(struct fchs_s *fchs, u32 d_id,
+				u32 s_id, u16 ox_id);
+
+enum fc_parse_status	fc_els_rsp_parse(struct fchs_s *fchs, int len);
+
+enum fc_parse_status	fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
+					wwn_t port_name);
+
+enum fc_parse_status	fc_prli_parse(struct fc_prli_s *prli);
+
+enum fc_parse_status	fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
+					wwn_t port_name);
+
 u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc,
 			u32 d_id, u32 s_id, u16 ox_id,
 			u16 rx_id);
+
 int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
+
 u16 fc_tprlo_acc_build(struct fchs_s *fchs,
-			struct fc_tprlo_acc_s *tprlo_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			int num_pages);
+			struct fc_tprlo_acc_s *tprlo_acc, u32 d_id,
+			u32 s_id, u16 ox_id, int num_pages);
+
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
-			u32 d_id, u32 s_id, u16 ox_id,
-			int num_pages);
+		u32 d_id, u32 s_id, u16 ox_id, int num_pages);
+
 u16 fc_logo_rsp_parse(struct fchs_s *fchs, int len);
+
 u16 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, wwn_t port_name, wwn_t node_name,
-			u16 pdu_size);
+		u16 ox_id, wwn_t port_name, wwn_t node_name,
+		u16 pdu_size);
+
 u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
+
 u16 fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, int num_pages);
+		u16 ox_id, int num_pages);
+
 u16 fc_prlo_rsp_parse(struct fchs_s *fchs, int len);
+
 u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, int num_pages,
-			enum fc_tprlo_type tprlo_type, u32 tpr_id);
+		u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
+		u32 tpr_id);
+
 u16 fc_tprlo_rsp_parse(struct fchs_s *fchs, int len);
+
 u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-			u16 ox_id, u32 reason_code,
-			u32 reason_expl);
+		u16 ox_id, u32 reason_code, u32 reason_expl);
+
 u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			u16 ox_id, u32 port_id);
+		u16 ox_id, u32 port_id);
+
 u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
+
 u16 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
-			u32 s_id, u16 ox_id);
+		u32 s_id, u16 ox_id);
 #endif
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 1f3c06e..76fdf49 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -36,18 +36,18 @@ BFA_TRC_FILE(FCS, FCPIM);
 /*
  * forward declarations
  */
-static void     bfa_fcs_itnim_timeout(void *arg);
-static void     bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim);
-static void     bfa_fcs_itnim_send_prli(void *itnim_cbarg,
+static void	bfa_fcs_itnim_timeout(void *arg);
+static void	bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim);
+static void	bfa_fcs_itnim_send_prli(void *itnim_cbarg,
 					struct bfa_fcxp_s *fcxp_alloced);
-static void     bfa_fcs_itnim_prli_response(void *fcsarg,
+static void	bfa_fcs_itnim_prli_response(void *fcsarg,
 					    struct bfa_fcxp_s *fcxp,
 					    void *cbarg,
 					    bfa_status_t req_status,
 					    u32 rsp_len,
 					    u32 resid_len,
 					    struct fchs_s *rsp_fchs);
-static void     bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
 				       enum bfa_itnim_aen_event event);
 
 /**
@@ -61,28 +61,28 @@ enum bfa_fcs_itnim_event {
 	BFA_FCS_ITNIM_SM_RSP_OK = 4,	/*  good response */
 	BFA_FCS_ITNIM_SM_RSP_ERROR = 5,	/*  error response */
 	BFA_FCS_ITNIM_SM_TIMEOUT = 6,	/*  delay timeout */
-	BFA_FCS_ITNIM_SM_HCB_OFFLINE = 7,	/*  BFA online callback */
-	BFA_FCS_ITNIM_SM_HCB_ONLINE = 8,	/*  BFA offline callback */
+	BFA_FCS_ITNIM_SM_HCB_OFFLINE = 7, /*  BFA online callback */
+	BFA_FCS_ITNIM_SM_HCB_ONLINE = 8, /*  BFA offline callback */
 	BFA_FCS_ITNIM_SM_INITIATOR = 9,	/*  rport is initiator */
 	BFA_FCS_ITNIM_SM_DELETE = 10,	/*  delete event from rport */
 	BFA_FCS_ITNIM_SM_PRLO = 11,	/*  delete event from rport */
 };
 
-static void     bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
 					 enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
 					   enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 				      enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 					    enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
 					    enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
 					enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
 					     enum bfa_fcs_itnim_event event);
-static void     bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
+static void	bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
 					   enum bfa_fcs_itnim_event event);
 
 static struct bfa_sm_table_s itnim_sm_table[] = {
@@ -102,7 +102,7 @@ static struct bfa_sm_table_s itnim_sm_table[] = {
 
 static void
 bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
-			 enum bfa_fcs_itnim_event event)
+				enum bfa_fcs_itnim_event event)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_trc(itnim->fcs, event);
@@ -126,14 +126,14 @@ bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 
 }
 
 static void
 bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
-			   enum bfa_fcs_itnim_event event)
+				enum bfa_fcs_itnim_event event)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_trc(itnim->fcs, event);
@@ -161,13 +161,13 @@ bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
-		      enum bfa_fcs_itnim_event event)
+				enum bfa_fcs_itnim_event event)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_trc(itnim->fcs, event);
@@ -193,9 +193,7 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 
 	case BFA_FCS_ITNIM_SM_INITIATOR:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
-		/*
-		 * dont discard fcxp. accept will reach same state
-		 */
+		/* dont discard fcxp. accept will reach same state*/
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -205,7 +203,7 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -240,7 +238,7 @@ bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -270,13 +268,13 @@ bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
-			enum bfa_fcs_itnim_event event)
+						enum bfa_fcs_itnim_event event)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_trc(itnim->fcs, event);
@@ -298,7 +296,7 @@ bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -321,7 +319,7 @@ bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -332,7 +330,7 @@ bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
  */
 static void
 bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
-			   enum bfa_fcs_itnim_event event)
+				enum bfa_fcs_itnim_event event)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_trc(itnim->fcs, event);
@@ -354,7 +352,7 @@ bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(itnim->fcs, event);
 	}
 }
 
@@ -366,38 +364,24 @@ bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
 
 static void
 bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
-		       enum bfa_itnim_aen_event event)
+			enum bfa_itnim_aen_event event)
 {
 	struct bfa_fcs_rport_s *rport = itnim->rport;
-	union bfa_aen_data_u aen_data;
+	union bfa_aen_data_u  aen_data;
 	struct bfa_log_mod_s *logmod = rport->fcs->logm;
-	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(rport->port);
-	wwn_t           rpwwn = rport->pwwn;
-	char            lpwwn_ptr[BFA_STRING_32];
-	char            rpwwn_ptr[BFA_STRING_32];
+	wwn_t		lpwwn = bfa_fcs_port_get_pwwn(rport->port);
+	wwn_t		rpwwn = rport->pwwn;
+	char		lpwwn_ptr[BFA_STRING_32];
+	char		rpwwn_ptr[BFA_STRING_32];
 
-	/*
-	 * Don't post events for well known addresses
-	 */
+	/* Don't post events for well known addresses */
 	if (BFA_FCS_PID_IS_WKA(rport->pid))
 		return;
 
 	wwn2str(lpwwn_ptr, lpwwn);
 	wwn2str(rpwwn_ptr, rpwwn);
-
-	switch (event) {
-	case BFA_ITNIM_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_ITNIM_ONLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
-	case BFA_ITNIM_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_ITNIM_OFFLINE, rpwwn_ptr, lpwwn_ptr);
-		break;
-	case BFA_ITNIM_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_ITNIM_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, event),
+			rpwwn_ptr, lpwwn_ptr);
 
 	aen_data.itnim.vf_id = rport->port->fabric->vf_id;
 	aen_data.itnim.ppwwn =
@@ -412,9 +396,9 @@ bfa_fcs_itnim_send_prli(void *itnim_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	struct bfa_fcs_itnim_s *itnim = itnim_cbarg;
 	struct bfa_fcs_rport_s *rport = itnim->rport;
 	struct bfa_fcs_port_s *port = rport->port;
-	struct fchs_s          fchs;
+	struct fchs_s		fchs;
 	struct bfa_fcxp_s *fcxp;
-	int             len;
+	int		len;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 
@@ -427,13 +411,13 @@ bfa_fcs_itnim_send_prli(void *itnim_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	}
 	itnim->fcxp = fcxp;
 
-	len = fc_prli_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), itnim->rport->pid,
-			    bfa_fcs_port_get_fcid(port), 0);
+	len = fc_prli_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			    itnim->rport->pid, bfa_fcs_port_get_fcid(port), 0);
 
 	bfa_fcxp_send(fcxp, rport->bfa_rport, port->fabric->vf_id, port->lp_tag,
 		      BFA_FALSE, FC_CLASS_3, len, &fchs,
-		      bfa_fcs_itnim_prli_response, (void *)itnim, FC_MAX_PDUSZ,
-		      FC_RA_TOV);
+		      bfa_fcs_itnim_prli_response, (void *)itnim,
+		      FC_MAX_PDUSZ, FC_RA_TOV);
 
 	itnim->stats.prli_sent++;
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_FRMSENT);
@@ -444,7 +428,7 @@ bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			    bfa_status_t req_status, u32 rsp_len,
 			    u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cbarg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cbarg;
 	struct fc_els_cmd_s   *els_cmd;
 	struct fc_prli_s      *prli_resp;
 	struct fc_ls_rjt_s    *ls_rjt;
@@ -475,7 +459,7 @@ bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			if (prli_resp->parampage.servparams.initiator) {
 				bfa_trc(itnim->fcs, prli_resp->parampage.type);
 				itnim->rport->scsi_function =
-					BFA_RPORT_INITIATOR;
+							BFA_RPORT_INITIATOR;
 				itnim->stats.prli_rsp_acc++;
 				bfa_sm_send_event(itnim,
 						  BFA_FCS_ITNIM_SM_INITIATOR);
@@ -488,10 +472,10 @@ bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 		itnim->rport->scsi_function = BFA_RPORT_TARGET;
 
 		sparams = &prli_resp->parampage.servparams;
-		itnim->seq_rec = sparams->retry;
-		itnim->rec_support = sparams->rec_support;
+		itnim->seq_rec	     = sparams->retry;
+		itnim->rec_support   = sparams->rec_support;
 		itnim->task_retry_id = sparams->task_retry_id;
-		itnim->conf_comp = sparams->confirm;
+		itnim->conf_comp     = sparams->confirm;
 
 		itnim->stats.prli_rsp_acc++;
 		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_RSP_OK);
@@ -509,7 +493,7 @@ bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 static void
 bfa_fcs_itnim_timeout(void *arg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)arg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) arg;
 
 	itnim->stats.timeout++;
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_TIMEOUT);
@@ -529,7 +513,7 @@ bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim)
  */
 
 /**
- * 	Called by rport when a new rport is created.
+ *	Called by rport when a new rport is created.
  *
  * @param[in] rport	-  remote port.
  */
@@ -538,7 +522,7 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 {
 	struct bfa_fcs_port_s *port = rport->port;
 	struct bfa_fcs_itnim_s *itnim;
-	struct bfad_itnim_s *itnim_drv;
+	struct bfad_itnim_s   *itnim_drv;
 	struct bfa_itnim_s *bfa_itnim;
 
 	/*
@@ -560,7 +544,8 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 	/*
 	 * call BFA to create the itnim
 	 */
-	bfa_itnim = bfa_itnim_create(port->fcs->bfa, rport->bfa_rport, itnim);
+	bfa_itnim =
+		bfa_itnim_create(port->fcs->bfa, rport->bfa_rport, itnim);
 
 	if (bfa_itnim == NULL) {
 		bfa_trc(port->fcs, rport->pwwn);
@@ -569,10 +554,10 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 		return NULL;
 	}
 
-	itnim->bfa_itnim = bfa_itnim;
-	itnim->seq_rec = BFA_FALSE;
-	itnim->rec_support = BFA_FALSE;
-	itnim->conf_comp = BFA_FALSE;
+	itnim->bfa_itnim     = bfa_itnim;
+	itnim->seq_rec	     = BFA_FALSE;
+	itnim->rec_support   = BFA_FALSE;
+	itnim->conf_comp     = BFA_FALSE;
 	itnim->task_retry_id = BFA_FALSE;
 
 	/*
@@ -584,7 +569,7 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 }
 
 /**
- * 	Called by rport to delete  the instance of FCPIM.
+ *	Called by rport to delete  the instance of FCPIM.
  *
  * @param[in] rport	-  remote port.
  */
@@ -607,8 +592,8 @@ bfa_fcs_itnim_rport_online(struct bfa_fcs_itnim_s *itnim)
 		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_ONLINE);
 	} else {
 		/*
-		 * For well known addresses, we set the itnim to initiator
-		 * state
+		 * For well known addresses, we set the
+		 * itnim to initiator state
 		 */
 		itnim->stats.initiator++;
 		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_INITIATOR);
@@ -645,13 +630,12 @@ bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim)
 {
 	bfa_trc(itnim->fcs, itnim->rport->pid);
 	switch (bfa_sm_to_state(itnim_sm_table, itnim->sm)) {
-	case BFA_ITNIM_ONLINE:
-	case BFA_ITNIM_INITIATIOR:
+	case  BFA_ITNIM_ONLINE:
+	case  BFA_ITNIM_INITIATIOR:
 		return BFA_STATUS_OK;
 
 	default:
 		return BFA_STATUS_NO_FCPIM_NEXUS;
-
 	}
 }
 
@@ -661,7 +645,7 @@ bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim)
 void
 bfa_cb_itnim_online(void *cbarg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cbarg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cbarg;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_ONLINE);
@@ -673,7 +657,7 @@ bfa_cb_itnim_online(void *cbarg)
 void
 bfa_cb_itnim_offline(void *cb_arg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cb_arg;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_OFFLINE);
@@ -686,10 +670,9 @@ bfa_cb_itnim_offline(void *cb_arg)
 void
 bfa_cb_itnim_tov_begin(void *cb_arg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cb_arg;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
-	bfa_fcb_itnim_tov_begin(itnim->itnim_drv);
 }
 
 /**
@@ -698,14 +681,14 @@ bfa_cb_itnim_tov_begin(void *cb_arg)
 void
 bfa_cb_itnim_tov(void *cb_arg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cb_arg;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 	bfa_fcb_itnim_tov(itnim->itnim_drv);
 }
 
 /**
- * 		BFA notification to FCS/driver for second level error recovery.
+ *		BFA notification to FCS/driver for second level error recovery.
  *
  * Atleast one I/O request has timedout and target is unresponsive to
  * repeated abort requests. Second level error recovery should be initiated
@@ -714,7 +697,7 @@ bfa_cb_itnim_tov(void *cb_arg)
 void
 bfa_cb_itnim_sler(void *cb_arg)
 {
-	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *) cb_arg;
 
 	itnim->stats.sler++;
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
@@ -745,10 +728,10 @@ bfa_fcs_itnim_attr_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
 	if (itnim == NULL)
 		return BFA_STATUS_NO_FCPIM_NEXUS;
 
-	attr->state = bfa_sm_to_state(itnim_sm_table, itnim->sm);
-	attr->retry = itnim->seq_rec;
-	attr->rec_support = itnim->rec_support;
-	attr->conf_comp = itnim->conf_comp;
+	attr->state	    = bfa_sm_to_state(itnim_sm_table, itnim->sm);
+	attr->retry	    = itnim->seq_rec;
+	attr->rec_support   = itnim->rec_support;
+	attr->conf_comp	    = itnim->conf_comp;
 	attr->task_retry_id = itnim->task_retry_id;
 
 	return BFA_STATUS_OK;
@@ -790,7 +773,7 @@ bfa_fcs_itnim_stats_clear(struct bfa_fcs_port_s *port, wwn_t rpwwn)
 
 void
 bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
-		      u16 len)
+						u16 len)
 {
 	struct fc_els_cmd_s   *els_cmd;
 
@@ -823,21 +806,4 @@ bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim)
 {
 }
 
-/**
- *   Module initialization
- */
-void
-bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
 
diff --git a/drivers/scsi/bfa/fcs_fabric.h b/drivers/scsi/bfa/fcs_fabric.h
index eee9608..e46310b 100644
--- a/drivers/scsi/bfa/fcs_fabric.h
+++ b/drivers/scsi/bfa/fcs_fabric.h
@@ -27,35 +27,39 @@
 #include <fcs/bfa_fcs_lport.h>
 
 /*
-* fcs friend functions: only between fcs modules
+ * fcs friend functions: only between fcs modules
  */
-void            bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
-void            bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
-void            bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
-					struct bfa_fcs_vport_s *vport);
-void            bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
-					struct bfa_fcs_vport_s *vport);
-int             bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric);
-struct bfa_fcs_vport_s *bfa_fcs_fabric_vport_lookup(
-			struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
-void            bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
+void bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
+void bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
+void bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
+	struct bfa_fcs_vport_s *vport);
+void bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
+	struct bfa_fcs_vport_s *vport);
+int bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric);
+struct bfa_fcs_vport_s*
+bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
+void bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
 			struct fchs_s *fchs, u16 len);
-u16        bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
-bfa_boolean_t   bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric);
+u16	bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
+bfa_boolean_t	bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric);
+bfa_boolean_t	bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric);
 enum bfa_pport_type bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric);
-void     	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
+void	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
+void	bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
 
-bfa_status_t bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf,
-			struct bfa_fcs_s *fcs, struct bfa_port_cfg_s *port_cfg,
-			struct bfad_vf_s *vf_drv);
+bfa_status_t	bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf,
+				struct bfa_fcs_s *fcs,
+				struct bfa_port_cfg_s *port_cfg,
+				struct bfad_vf_s *vf_drv);
 void bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric,
-			enum auth_status status);
+	enum auth_status status);
 
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
-			wwn_t fabric_name);
+	       wwn_t fabric_name);
+
 #endif /* __FCS_FABRIC_H__ */
diff --git a/drivers/scsi/bfa/fcs_fcpim.h b/drivers/scsi/bfa/fcs_fcpim.h
index 61e9e26..d5bc49b 100644
--- a/drivers/scsi/bfa/fcs_fcpim.h
+++ b/drivers/scsi/bfa/fcs_fcpim.h
@@ -34,11 +34,7 @@ void bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim);
 void bfa_fcs_itnim_pause(struct bfa_fcs_itnim_s *itnim);
 void bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim);
 
-/*
- * Modudle init/cleanup routines.
- */
-void bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs);
 void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
-			u16 len);
+				u16 len);
+
 #endif /* __FCS_FCPIM_H__ */
diff --git a/drivers/scsi/bfa/fcs_fcptm.h b/drivers/scsi/bfa/fcs_fcptm.h
index ffff082..ef4f6c2 100644
--- a/drivers/scsi/bfa/fcs_fcptm.h
+++ b/drivers/scsi/bfa/fcs_fcptm.h
@@ -26,20 +26,20 @@
  * Following routines are from FCPTM and will be called by rport.
  */
 struct bfa_fcs_tin_s *bfa_fcs_tin_create(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_tin_rport_offline(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_rport_online(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_delete(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_rx_prli(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
-			u16 len);
-void bfa_fcs_tin_pause(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_resume(struct bfa_fcs_tin_s *tin);
+void            bfa_fcs_tin_rport_offline(struct bfa_fcs_tin_s *tin);
+void            bfa_fcs_tin_rport_online(struct bfa_fcs_tin_s *tin);
+void            bfa_fcs_tin_delete(struct bfa_fcs_tin_s *tin);
+void            bfa_fcs_tin_rx_prli(struct bfa_fcs_tin_s *tin,
+						struct fchs_s *fchs, u16 len);
+void            bfa_fcs_tin_pause(struct bfa_fcs_tin_s *tin);
+void            bfa_fcs_tin_resume(struct bfa_fcs_tin_s *tin);
 
 /*
  * Modudle init/cleanup routines.
  */
-void bfa_fcs_fcptm_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcptm_modexit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcptm_uf_recv(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
-			u16 len);
+void            bfa_fcs_fcptm_modinit(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fcptm_modexit(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fcptm_uf_recv(struct bfa_fcs_tin_s *tin,
+						struct fchs_s *fchs, u16 len);
 
 #endif /* __FCS_FCPTM_H__ */
diff --git a/drivers/scsi/bfa/fcs_lport.h b/drivers/scsi/bfa/fcs_lport.h
index ae744ba..7dabba2 100644
--- a/drivers/scsi/bfa/fcs_lport.h
+++ b/drivers/scsi/bfa/fcs_lport.h
@@ -77,38 +77,38 @@
 /*
  * handler for unsolicied frames
  */
-void bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
-			u16 len);
+void	bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
+				     u16 len);
 
 /*
  * Following routines will be called by Fabric to indicate port
  * online/offline to vport.
  */
-void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
-			u16 vf_id, struct bfa_port_cfg_s *port_cfg,
-			struct bfa_fcs_vport_s *vport);
-void bfa_fcs_port_online(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_offline(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_delete(struct bfa_fcs_port_s *port);
-bfa_boolean_t   bfa_fcs_port_is_online(struct bfa_fcs_port_s *port);
+void bfa_fcs_lport_attach(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+			  u16 vf_id, struct bfa_fcs_vport_s *vport);
+void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport,
+			struct bfa_port_cfg_s *port_cfg);
+void            bfa_fcs_port_online(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_offline(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_delete(struct bfa_fcs_port_s *port);
 
 /*
  * Lookup rport based on PID
  */
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pid(
-			struct bfa_fcs_port_s *port, u32 pid);
+struct bfa_fcs_rport_s*
+bfa_fcs_port_get_rport_by_pid(struct bfa_fcs_port_s *port, u32 pid);
 
 /*
  * Lookup rport based on PWWN
  */
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pwwn(
-			struct bfa_fcs_port_s *port, wwn_t pwwn);
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_nwwn(
-			struct bfa_fcs_port_s *port, wwn_t nwwn);
-void bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
-			struct bfa_fcs_rport_s *rport);
-void bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
-			struct bfa_fcs_rport_s *rport);
+struct bfa_fcs_rport_s*
+bfa_fcs_port_get_rport_by_pwwn(struct bfa_fcs_port_s *port, wwn_t pwwn);
+struct bfa_fcs_rport_s*
+bfa_fcs_port_get_rport_by_nwwn(struct bfa_fcs_port_s *port, wwn_t nwwn);
+void            bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
+				       struct bfa_fcs_rport_s *rport);
+void            bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
+				       struct bfa_fcs_rport_s *rport);
 
 void bfa_fcs_port_modinit(struct bfa_fcs_s *fcs);
 void bfa_fcs_port_modexit(struct bfa_fcs_s *fcs);
diff --git a/drivers/scsi/bfa/fcs_port.h b/drivers/scsi/bfa/fcs_port.h
index abb6519..408c06a 100644
--- a/drivers/scsi/bfa/fcs_port.h
+++ b/drivers/scsi/bfa/fcs_port.h
@@ -26,7 +26,6 @@
 /*
  * fcs friend functions: only between fcs modules
  */
-void bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_pport_attach(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_PPORT_H__ */
diff --git a/drivers/scsi/bfa/fcs_rport.h b/drivers/scsi/bfa/fcs_rport.h
index f601e9d..8ab4076 100644
--- a/drivers/scsi/bfa/fcs_rport.h
+++ b/drivers/scsi/bfa/fcs_rport.h
@@ -24,34 +24,29 @@
 
 #include <fcs/bfa_fcs_rport.h>
 
-void bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs);
-
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
-			u16 len);
+				u16 len);
 void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
 
 struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_port_s *port,
-			u32 pid);
+						u32 pid);
 void bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_start(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
-			struct fc_logi_s *plogi_rsp);
+			 struct fc_logi_s *plogi_rsp);
 void bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs,
-			struct fc_logi_s *plogi);
+			struct fchs_s *rx_fchs, struct fc_logi_s *plogi);
 void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
-			struct fc_logi_s *plogi);
+			 struct fc_logi_s *plogi);
 void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
+
 void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_fcptm_offline_done(struct bfa_fcs_rport_s *rport);
 int  bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport);
-struct bfa_fcs_rport_s *bfa_fcs_rport_create_by_wwn(struct bfa_fcs_port_s *port,
-			wwn_t wwn);
-
+struct bfa_fcs_rport_s *bfa_fcs_rport_create_by_wwn(
+			struct bfa_fcs_port_s *port, wwn_t wwn);
 
 /* Rport Features */
 void  bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport);
diff --git a/drivers/scsi/bfa/fcs_uf.h b/drivers/scsi/bfa/fcs_uf.h
index 96f1bdc..f591072 100644
--- a/drivers/scsi/bfa/fcs_uf.h
+++ b/drivers/scsi/bfa/fcs_uf.h
@@ -26,7 +26,6 @@
 /*
  * fcs friend functions: only between fcs modules
  */
-void bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_UF_H__ */
diff --git a/drivers/scsi/bfa/fcs_vport.h b/drivers/scsi/bfa/fcs_vport.h
index 9e80b6a..95581ea 100644
--- a/drivers/scsi/bfa/fcs_vport.h
+++ b/drivers/scsi/bfa/fcs_vport.h
@@ -22,18 +22,9 @@
 #include <fcs/bfa_fcs_vport.h>
 #include <defs/bfa_defs_pci.h>
 
-/*
- * Modudle init/cleanup routines.
- */
-
-void bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs);
-
 void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
-u32 bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_VPORT_H__ */
-
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index df2a1e5..d1fd9d6 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -64,18 +64,18 @@ static void     bfa_fcs_port_fdmi_rpa_response(void *fcsarg,
 					       u32 resid_len,
 					       struct fchs_s *rsp_fchs);
 static void     bfa_fcs_port_fdmi_timeout(void *arg);
-static u16 bfa_fcs_port_fdmi_build_rhba_pyld(
-			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
-static u16 bfa_fcs_port_fdmi_build_rprt_pyld(
-			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
-static u16 bfa_fcs_port_fdmi_build_rpa_pyld(
-			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
-static u16 bfa_fcs_port_fdmi_build_portattr_block(
-			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
-static void bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
-			struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
-static void bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
-			struct bfa_fcs_fdmi_port_attr_s *port_attr);
+static u16 bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+						  u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_rprt_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+						  u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+						 u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_portattr_block(struct bfa_fcs_port_fdmi_s *
+						       fdmi, u8 *pyld);
+static void     bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
+				struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
+static void	bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
+				struct bfa_fcs_fdmi_port_attr_s *port_attr);
 /**
  *  fcs_fdmi_sm FCS FDMI state machine
  */
@@ -94,28 +94,46 @@ enum port_fdmi_event {
 	FDMISM_EVENT_RPA_SENT = 9,
 };
 
-static void bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void     bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void     bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
-static void     bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
-			enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
+			     enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+					enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+			  enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+				enum port_fdmi_event event);
+
+static void
+bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+				  enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+			  enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+				enum port_fdmi_event event);
+
+static void
+bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+				 enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+			 enum port_fdmi_event event);
+static void
+bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+			       enum port_fdmi_event event);
+
+static void
+bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
+			    enum port_fdmi_event event);
+
+static void
+bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
+			    enum port_fdmi_event event);
 /**
  * 		Start in offline state - awaiting MS to send start.
  */
@@ -155,7 +173,7 @@ bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -176,17 +194,17 @@ bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
 	case FDMISM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
-				       &fdmi->fcxp_wqe);
+					   &fdmi->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
-			  enum port_fdmi_event event)
+						enum port_fdmi_event event)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 
@@ -202,8 +220,9 @@ bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
 		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rhba_retry);
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
-					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
-					fdmi, BFA_FCS_RETRY_TIMEOUT);
+					    &fdmi->timer,
+					    bfa_fcs_port_fdmi_timeout, fdmi,
+					    BFA_FCS_RETRY_TIMEOUT);
 		} else {
 			/*
 			 * set state to offline
@@ -227,7 +246,7 @@ bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -255,7 +274,7 @@ bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -279,17 +298,17 @@ bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
 	case FDMISM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
-				       &fdmi->fcxp_wqe);
+					   &fdmi->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
-			  enum port_fdmi_event event)
+				enum port_fdmi_event event)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 
@@ -305,8 +324,9 @@ bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
 		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rprt_retry);
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
-					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
-					fdmi, BFA_FCS_RETRY_TIMEOUT);
+					    &fdmi->timer,
+					    bfa_fcs_port_fdmi_timeout, fdmi,
+					    BFA_FCS_RETRY_TIMEOUT);
 
 		} else {
 			/*
@@ -328,7 +348,7 @@ bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -356,7 +376,7 @@ bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -380,17 +400,17 @@ bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
 	case FDMISM_EVENT_PORT_OFFLINE:
 		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
 		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
-				       &fdmi->fcxp_wqe);
+					   &fdmi->fcxp_wqe);
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
-			 enum port_fdmi_event event)
+			enum port_fdmi_event event)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 
@@ -406,8 +426,9 @@ bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
 		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rpa_retry);
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
-					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
-					fdmi, BFA_FCS_RETRY_TIMEOUT);
+					    &fdmi->timer,
+					    bfa_fcs_port_fdmi_timeout, fdmi,
+					    BFA_FCS_RETRY_TIMEOUT);
 		} else {
 			/*
 			 * set state to offline
@@ -428,7 +449,7 @@ bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
@@ -456,13 +477,13 @@ bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
 
 static void
 bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
-			    enum port_fdmi_event event)
+				enum port_fdmi_event event)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 
@@ -475,13 +496,27 @@ bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
 		break;
 
 	default:
-		bfa_assert(0);
+		bfa_sm_fault(port->fcs, event);
 	}
 }
+/**
+ *  FDMI is disabled state.
+ */
+static void
+bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
+			     enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	/* No op State. It can only be enabled at Driver Init. */
+}
 
 
 /**
-*   RHBA : Register HBA Attributes.
+*  RHBA : Register HBA Attributes.
  */
 static void
 bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
@@ -498,7 +533,7 @@ bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
-				    bfa_fcs_port_fdmi_send_rhba, fdmi);
+					bfa_fcs_port_fdmi_send_rhba, fdmi);
 		return;
 	}
 	fdmi->fcxp = fcxp;
@@ -509,24 +544,25 @@ bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
 				   FDMI_RHBA);
 
-	attr_len = bfa_fcs_port_fdmi_build_rhba_pyld(fdmi,
-			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+	attr_len =
+		bfa_fcs_port_fdmi_build_rhba_pyld(fdmi,
+					(u8 *) ((struct ct_hdr_s *) pyld
+					       + 1));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, (len + attr_len), &fchs,
-		      bfa_fcs_port_fdmi_rhba_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, (len + attr_len), &fchs,
+			  bfa_fcs_port_fdmi_rhba_response, (void *)fdmi,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RHBA_SENT);
 }
 
 static          u16
-bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
-				  u8 *pyld)
+bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct bfa_fcs_fdmi_hba_attr_s hba_attr;	/* @todo */
-	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr = &hba_attr; /* @todo */
+	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr = &hba_attr;  /* @todo */
 	struct fdmi_rhba_s    *rhba = (struct fdmi_rhba_s *) pyld;
 	struct fdmi_attr_s    *attr;
 	u8        *curr_ptr;
@@ -572,8 +608,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MANUFACTURER);
 	attr->len = (u16) strlen(fcs_hba_attr->manufacturer);
 	memcpy(attr->value, fcs_hba_attr->manufacturer, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
@@ -588,8 +626,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_SERIALNUM);
 	attr->len = (u16) strlen(fcs_hba_attr->serial_num);
 	memcpy(attr->value, fcs_hba_attr->serial_num, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
@@ -604,8 +644,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL);
 	attr->len = (u16) strlen(fcs_hba_attr->model);
 	memcpy(attr->value, fcs_hba_attr->model, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
@@ -620,8 +662,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL_DESC);
 	attr->len = (u16) strlen(fcs_hba_attr->model_desc);
 	memcpy(attr->value, fcs_hba_attr->model_desc, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
@@ -637,14 +681,16 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_HW_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->hw_version);
 		memcpy(attr->value, fcs_hba_attr->hw_version, attr->len);
-		/* variable fields need to be 4 byte aligned */
-		attr->len = fc_roundup(attr->len, sizeof(u32));
+		attr->len = fc_roundup(attr->len, sizeof(u32));/* variable
+								* fields need
+								* to be 4 byte
+								* aligned */
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
 		attr->len =
 			bfa_os_htons(attr->len + sizeof(attr->type) +
-				     sizeof(attr->len));
+					 sizeof(attr->len));
 	}
 
 	/*
@@ -654,8 +700,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_DRIVER_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;;
 	count++;
@@ -671,14 +719,16 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_ROM_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->option_rom_ver);
 		memcpy(attr->value, fcs_hba_attr->option_rom_ver, attr->len);
-		/* variable fields need to be 4 byte aligned */
-		attr->len = fc_roundup(attr->len, sizeof(u32));
+		attr->len = fc_roundup(attr->len, sizeof(u32));/* variable
+								* fields need
+								* to be 4 byte
+								* aligned */
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
 		attr->len =
 			bfa_os_htons(attr->len + sizeof(attr->type) +
-				     sizeof(attr->len));
+					 sizeof(attr->len));
 	}
 
 	/*
@@ -688,8 +738,10 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_FW_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	/* variable fields need to be 4 byte aligned */
-	attr->len = fc_roundup(attr->len, sizeof(u32));
+	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
+							 * fields need
+							 * to be 4 byte
+							 * aligned */
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
@@ -705,14 +757,14 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_OS_NAME);
 		attr->len = (u16) strlen(fcs_hba_attr->os_name);
 		memcpy(attr->value, fcs_hba_attr->os_name, attr->len);
-		/* variable fields need to be 4 byte aligned */
+		/* variable fields need to b 4 byte aligned */
 		attr->len = fc_roundup(attr->len, sizeof(u32));
+
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
-		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
-				     sizeof(attr->len));
+		attr->len = bfa_os_htons(attr->len + sizeof(attr->type) +
+				sizeof(attr->len));
 	}
 
 	/*
@@ -731,7 +783,8 @@ bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	/*
 	 * Update size of payload
 	 */
-	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
+	len += ((sizeof(attr->type) +
+		 sizeof(attr->len)) * count);
 
 	rhba->hba_attr_blk.attr_count = bfa_os_htonl(count);
 	return len;
@@ -743,7 +796,7 @@ bfa_fcs_port_fdmi_rhba_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				u32 rsp_len, u32 resid_len,
 				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *) cbarg;
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -772,7 +825,7 @@ bfa_fcs_port_fdmi_rhba_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 }
 
 /**
-*   RPRT : Register Port
+*  RPRT : Register Port
  */
 static void
 bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
@@ -789,7 +842,7 @@ bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
-				    bfa_fcs_port_fdmi_send_rprt, fdmi);
+					bfa_fcs_port_fdmi_send_rprt, fdmi);
 		return;
 	}
 	fdmi->fcxp = fcxp;
@@ -800,13 +853,15 @@ bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
 				   FDMI_RPRT);
 
-	attr_len = bfa_fcs_port_fdmi_build_rprt_pyld(fdmi,
-			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+	attr_len =
+		bfa_fcs_port_fdmi_build_rprt_pyld(fdmi,
+					(u8 *) ((struct ct_hdr_s *) pyld
+					       + 1));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len + attr_len, &fchs,
-		      bfa_fcs_port_fdmi_rprt_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len + attr_len, &fchs,
+			  bfa_fcs_port_fdmi_rprt_response, (void *)fdmi,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPRT_SENT);
 }
@@ -823,7 +878,7 @@ bfa_fcs_port_fdmi_build_portattr_block(struct bfa_fcs_port_fdmi_s *fdmi,
 	struct fdmi_attr_s    *attr;
 	u8        *curr_ptr;
 	u16        len;
-	u8         count = 0;
+	u8		count = 0;
 
 	/*
 	 * get port attributes
@@ -901,15 +956,14 @@ bfa_fcs_port_fdmi_build_portattr_block(struct bfa_fcs_port_fdmi_s *fdmi,
 		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_DEV_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.os_device_name);
 		memcpy(attr->value, fcs_port_attr.os_device_name, attr->len);
-		/* variable fields need to be 4 byte aligned */
+		/* variable fields need to b 4 byte aligned */
 		attr->len = fc_roundup(attr->len, sizeof(u32));
+
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		++count;
-		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
-				     sizeof(attr->len));
-
+		attr->len = bfa_os_htons(attr->len + sizeof(attr->type) +
+				sizeof(attr->len));
 	}
 	/*
 	 * Host Name
@@ -919,28 +973,28 @@ bfa_fcs_port_fdmi_build_portattr_block(struct bfa_fcs_port_fdmi_s *fdmi,
 		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_HOST_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.host_name);
 		memcpy(attr->value, fcs_port_attr.host_name, attr->len);
-		/* variable fields need to be 4 byte aligned */
+		/* variable fields need to b 4 byte aligned */
 		attr->len = fc_roundup(attr->len, sizeof(u32));
+
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		++count;
-		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
-				     sizeof(attr->len));
-
+		attr->len = bfa_os_htons(attr->len + sizeof(attr->type) +
+				sizeof(attr->len));
 	}
 
 	/*
 	 * Update size of payload
 	 */
 	port_attrib->attr_count = bfa_os_htonl(count);
-	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
+	len += ((sizeof(attr->type) +
+		 sizeof(attr->len)) * count);
 	return len;
 }
 
 static          u16
 bfa_fcs_port_fdmi_build_rprt_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
-				  u8 *pyld)
+					u8 *pyld)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct fdmi_rprt_s    *rprt = (struct fdmi_rprt_s *) pyld;
@@ -950,7 +1004,7 @@ bfa_fcs_port_fdmi_build_rprt_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	rprt->port_name = bfa_fcs_port_get_pwwn(port);
 
 	len = bfa_fcs_port_fdmi_build_portattr_block(fdmi,
-			(u8 *) &rprt->port_attr_blk);
+				(u8 *) &rprt->port_attr_blk);
 
 	len += sizeof(rprt->hba_id) + sizeof(rprt->port_name);
 
@@ -963,7 +1017,7 @@ bfa_fcs_port_fdmi_rprt_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				u32 rsp_len, u32 resid_len,
 				struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *) cbarg;
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -992,7 +1046,7 @@ bfa_fcs_port_fdmi_rprt_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 }
 
 /**
-*   RPA : Register Port Attributes.
+*  RPA : Register Port Attributes.
  */
 static void
 bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
@@ -1009,7 +1063,7 @@ bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	if (!fcxp) {
 		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
-				    bfa_fcs_port_fdmi_send_rpa, fdmi);
+					bfa_fcs_port_fdmi_send_rpa, fdmi);
 		return;
 	}
 	fdmi->fcxp = fcxp;
@@ -1020,20 +1074,21 @@ bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
 				   FDMI_RPA);
 
-	attr_len = bfa_fcs_port_fdmi_build_rpa_pyld(fdmi,
-			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+	attr_len =
+		bfa_fcs_port_fdmi_build_rpa_pyld(fdmi,
+					(u8 *) ((struct ct_hdr_s *) pyld
+					      + 1));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-		      FC_CLASS_3, len + attr_len, &fchs,
-		      bfa_fcs_port_fdmi_rpa_response, (void *)fdmi,
-		      FC_MAX_PDUSZ, FC_RA_TOV);
+			  FC_CLASS_3, len + attr_len, &fchs,
+			  bfa_fcs_port_fdmi_rpa_response, (void *)fdmi,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPA_SENT);
 }
 
 static          u16
-bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
-				 u8 *pyld)
+bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct fdmi_rpa_s     *rpa = (struct fdmi_rpa_s *) pyld;
@@ -1042,7 +1097,7 @@ bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 	rpa->port_name = bfa_fcs_port_get_pwwn(port);
 
 	len = bfa_fcs_port_fdmi_build_portattr_block(fdmi,
-			(u8 *) &rpa->port_attr_blk);
+				(u8 *) &rpa->port_attr_blk);
 
 	len += sizeof(rpa->port_name);
 
@@ -1051,11 +1106,11 @@ bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
 
 static void
 bfa_fcs_port_fdmi_rpa_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-			       void *cbarg, bfa_status_t req_status,
-			       u32 rsp_len, u32 resid_len,
-			       struct fchs_s *rsp_fchs)
+				void *cbarg,
+			       bfa_status_t req_status, u32 rsp_len,
+			       u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *) cbarg;
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 	struct ct_hdr_s       *cthdr = NULL;
 
@@ -1086,7 +1141,7 @@ bfa_fcs_port_fdmi_rpa_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 static void
 bfa_fcs_port_fdmi_timeout(void *arg)
 {
-	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)arg;
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *) arg;
 
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_TIMEOUT);
 }
@@ -1096,49 +1151,35 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			 struct bfa_fcs_fdmi_hba_attr_s *hba_attr)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
-	struct bfa_fcs_driver_info_s *driver_info = &port->fcs->driver_info;
-	struct bfa_adapter_attr_s adapter_attr;
+	struct bfa_fcs_driver_info_s  *driver_info = &port->fcs->driver_info;
 
 	bfa_os_memset(hba_attr, 0, sizeof(struct bfa_fcs_fdmi_hba_attr_s));
-	bfa_os_memset(&adapter_attr, 0, sizeof(struct bfa_adapter_attr_s));
-
-	bfa_ioc_get_adapter_attr(&port->fcs->bfa->ioc, &adapter_attr);
-
-	strncpy(hba_attr->manufacturer, adapter_attr.manufacturer,
-		sizeof(adapter_attr.manufacturer));
 
-	strncpy(hba_attr->serial_num, adapter_attr.serial_num,
-		sizeof(adapter_attr.serial_num));
-
-	strncpy(hba_attr->model, adapter_attr.model, sizeof(hba_attr->model));
-
-	strncpy(hba_attr->model_desc, adapter_attr.model_descr,
-		sizeof(hba_attr->model_desc));
-
-	strncpy(hba_attr->hw_version, adapter_attr.hw_ver,
-		sizeof(hba_attr->hw_version));
+	bfa_ioc_get_adapter_manufacturer(&port->fcs->bfa->ioc,
+					hba_attr->manufacturer);
+	bfa_ioc_get_adapter_serial_num(&port->fcs->bfa->ioc, hba_attr->serial_num);
+	bfa_ioc_get_adapter_model(&port->fcs->bfa->ioc, hba_attr->model);
+	bfa_ioc_get_adapter_model(&port->fcs->bfa->ioc, hba_attr->model_desc);
+	bfa_ioc_get_pci_chip_rev(&port->fcs->bfa->ioc, hba_attr->hw_version);
+	bfa_ioc_get_adapter_optrom_ver(&port->fcs->bfa->ioc,
+					hba_attr->option_rom_ver);
+	bfa_ioc_get_adapter_fw_ver(&port->fcs->bfa->ioc, hba_attr->fw_version);
 
 	strncpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
 
-	strncpy(hba_attr->option_rom_ver, adapter_attr.optrom_ver,
-		sizeof(hba_attr->option_rom_ver));
-
-	strncpy(hba_attr->fw_version, adapter_attr.fw_ver,
-		sizeof(hba_attr->fw_version));
-
 	strncpy(hba_attr->os_name, driver_info->host_os_name,
 		sizeof(hba_attr->os_name));
 
-	/*
-	 * If there is a patch level, append it to the os name along with a
-	 * separator
+	/**
+	 * If there is a patch level, append it to
+	 * the os name along with a separator
 	 */
 	if (driver_info->host_os_patch[0] != '\0') {
 		strncat(hba_attr->os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
 		strncat(hba_attr->os_name, driver_info->host_os_patch,
-			sizeof(driver_info->host_os_patch));
+				sizeof(driver_info->host_os_patch));
 	}
 
 	hba_attr->max_ct_pyld = bfa_os_htonl(FC_MAX_PDUSZ);
@@ -1150,7 +1191,7 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
-	struct bfa_fcs_driver_info_s *driver_info = &port->fcs->driver_info;
+	struct bfa_fcs_driver_info_s  *driver_info = &port->fcs->driver_info;
 	struct bfa_pport_attr_s pport_attr;
 
 	bfa_os_memset(port_attr, 0, sizeof(struct bfa_fcs_fdmi_port_attr_s));
@@ -1158,7 +1199,7 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
 	/*
 	 * get pport attributes from hal
 	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 
 	/*
 	 * get FC4 type Bitmask
@@ -1201,7 +1242,10 @@ bfa_fcs_port_fdmi_init(struct bfa_fcs_port_ms_s *ms)
 	struct bfa_fcs_port_fdmi_s *fdmi = &ms->fdmi;
 
 	fdmi->ms = ms;
-	bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+	if (ms->port->fcs->fdmi_enabled)
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+	else
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_disabled);
 }
 
 void
diff --git a/drivers/scsi/bfa/loop.c b/drivers/scsi/bfa/loop.c
index f7c7f4f..14a3783 100644
--- a/drivers/scsi/bfa/loop.c
+++ b/drivers/scsi/bfa/loop.c
@@ -58,16 +58,17 @@ static const u8   port_loop_alpa_map[] = {
 /*
  * Local Functions
  */
-static bfa_status_t bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port,
-					u8 alpa);
-
-static void bfa_fcs_port_loop_plogi_response(void *fcsarg,
-					struct bfa_fcxp_s *fcxp,
-					void *cbarg,
-					bfa_status_t req_status,
-					u32 rsp_len,
-					u32 resid_len,
-					struct fchs_s *rsp_fchs);
+static bfa_status_t    bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port,
+					     u8 alpa);
+
+static void            bfa_fcs_port_loop_plogi_response(void *fcsarg,
+						 struct bfa_fcxp_s *fcxp,
+						 void *cbarg,
+						 bfa_status_t req_status,
+						 u32 rsp_len,
+						 u32 resid_len,
+						 struct fchs_s *rsp_fchs);
+
 /**
  *   Called by port to initializar in provate LOOP topology.
  */
@@ -162,7 +163,7 @@ bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port, u8 alpa)
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len, &fchs,
diff --git a/drivers/scsi/bfa/lport_api.c b/drivers/scsi/bfa/lport_api.c
index 1e06792..2275b5e 100644
--- a/drivers/scsi/bfa/lport_api.c
+++ b/drivers/scsi/bfa/lport_api.c
@@ -47,13 +47,16 @@ bfa_fcs_get_base_port(struct bfa_fcs_s *fcs)
 }
 
 wwn_t
-bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn, int index,
-		       int nrports, bfa_boolean_t bwwn)
+bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port,
+			wwn_t wwn,
+			int index,
+			int nrports,
+			bfa_boolean_t bwwn)
 {
-	struct list_head *qh, *qe;
+	struct list_head        *qh, *qe;
 	struct bfa_fcs_rport_s *rport = NULL;
 	int             i;
-	struct bfa_fcs_s *fcs;
+	struct bfa_fcs_s      *fcs;
 
 	if (port == NULL || nrports == 0)
 		return (wwn_t) 0;
@@ -66,7 +69,7 @@ bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn, int index,
 	qe = bfa_q_first(qh);
 
 	while ((qe != qh) && (i < nrports)) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
 			qe = bfa_q_next(qe);
 			bfa_trc(fcs, (u32) rport->pwwn);
@@ -88,6 +91,7 @@ bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn, int index,
 	}
 
 	bfa_trc(fcs, i);
+
 	if (rport)
 		return rport->pwwn;
 	else
@@ -96,12 +100,12 @@ bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn, int index,
 
 void
 bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port, wwn_t rport_wwns[],
-			int *nrports)
+				int *nrports)
 {
-	struct list_head *qh, *qe;
+	struct list_head        *qh, *qe;
 	struct bfa_fcs_rport_s *rport = NULL;
 	int             i;
-	struct bfa_fcs_s *fcs;
+	struct bfa_fcs_s      *fcs;
 
 	if (port == NULL || rport_wwns == NULL || *nrports == 0)
 		return;
@@ -114,7 +118,7 @@ bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port, wwn_t rport_wwns[],
 	qe = bfa_q_first(qh);
 
 	while ((qe != qh) && (i < *nrports)) {
-		rport = (struct bfa_fcs_rport_s *)qe;
+		rport = (struct bfa_fcs_rport_s *) qe;
 		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
 			qe = bfa_q_next(qe);
 			bfa_trc(fcs, (u32) rport->pwwn);
@@ -141,11 +145,11 @@ bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port, wwn_t rport_wwns[],
 enum bfa_pport_speed
 bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 {
-	struct list_head *qh, *qe;
+	struct list_head  *qh, *qe;
 	struct bfa_fcs_rport_s *rport = NULL;
-	struct bfa_fcs_s *fcs;
+	struct bfa_fcs_s      *fcs;
 	enum bfa_pport_speed max_speed = 0;
-	struct bfa_pport_attr_s pport_attr;
+	struct bfa_pport_attr_s  pport_attr;
 	enum bfa_pport_speed pport_speed;
 
 	if (port == NULL)
@@ -153,10 +157,8 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 
 	fcs = port->fcs;
 
-	/*
-	 * Get Physical port's current speed
-	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	/* Get Physical port's current speed */
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 	pport_speed = pport_attr.speed;
 	bfa_trc(fcs, pport_speed);
 
@@ -164,15 +166,16 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 	qe = bfa_q_first(qh);
 
 	while (qe != qh) {
-		rport = (struct bfa_fcs_rport_s *)qe;
-		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000)
-		    || (bfa_fcs_rport_get_state(rport) == BFA_RPORT_OFFLINE)) {
+		rport = (struct bfa_fcs_rport_s *) qe;
+		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000) ||
+			(bfa_fcs_rport_get_state(rport) ==
+				BFA_RPORT_OFFLINE)) {
 			qe = bfa_q_next(qe);
 			continue;
 		}
 
-		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_8GBPS)
-		    || (rport->rpf.rpsc_speed > pport_speed)) {
+		if ((rport->rpf.rpsc_speed  == BFA_PPORT_SPEED_8GBPS) ||
+			(rport->rpf.rpsc_speed > pport_speed)) {
 			max_speed = rport->rpf.rpsc_speed;
 			break;
 		} else if (rport->rpf.rpsc_speed > max_speed) {
@@ -215,7 +218,7 @@ bfa_fcs_lookup_port(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t lpwwn)
  */
 void
 bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
-		      struct bfa_port_info_s *port_info)
+				struct bfa_port_info_s *port_info)
 {
 
 	bfa_trc(port->fcs, port->fabric->fabric_name);
@@ -235,7 +238,8 @@ bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
 		port_info->port_wwn = bfa_fcs_port_get_pwwn(port);
 		port_info->node_wwn = bfa_fcs_port_get_nwwn(port);
 
-		port_info->max_vports_supp = bfa_fcs_vport_get_max(port->fcs);
+		port_info->max_vports_supp =
+			bfa_lps_get_max_vport(port->fcs->bfa);
 		port_info->num_vports_inuse =
 			bfa_fcs_fabric_vport_count(port->fabric);
 		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
@@ -259,10 +263,10 @@ bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
 
 void
 bfa_fcs_port_get_stats(struct bfa_fcs_port_s *fcs_port,
-		       struct bfa_port_stats_s *port_stats)
+				struct bfa_port_stats_s *port_stats)
 {
 	bfa_os_memcpy(port_stats, &fcs_port->stats,
-		      sizeof(struct bfa_port_stats_s));
+				sizeof(struct bfa_port_stats_s));
 	return;
 }
 
-- 
1.6.5.2

