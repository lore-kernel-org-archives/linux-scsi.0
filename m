From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 24/32] bfa: Rename pport to fcport in BFA FCS.
Date: Thu, 25 Feb 2010 17:49:29 -0800
Message-ID: <1267148969-23325-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27238 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934901Ab0BZBvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- Rename pport structures to fcport in BFA FCS, to resolve confusion
	  about the port structures in the firmware, and make sure the SG page
	  is setup correctly.
---
 drivers/scsi/bfa/bfa_fcport.c                    | 1567 +++++++++++++---------
 drivers/scsi/bfa/bfa_intr.c                      |    2 +-
 drivers/scsi/bfa/bfa_module.c                    |    4 +-
 drivers/scsi/bfa/bfa_modules_priv.h              |    2 +-
 drivers/scsi/bfa/bfa_port_priv.h                 |   17 +-
 drivers/scsi/bfa/bfa_priv.h                      |    2 +-
 drivers/scsi/bfa/bfad.c                          |    3 +-
 drivers/scsi/bfa/bfad_attr.c                     |    6 +-
 drivers/scsi/bfa/bfad_im.c                       |    2 +-
 drivers/scsi/bfa/fabric.c                        |   22 +-
 drivers/scsi/bfa/fdmi.c                          |    6 +-
 drivers/scsi/bfa/include/bfa_svc.h               |   76 +-
 drivers/scsi/bfa/include/bfi/bfi_pport.h         |    5 +
 drivers/scsi/bfa/include/cs/bfa_plog.h           |    9 +-
 drivers/scsi/bfa/include/cs/bfa_sm.h             |    8 +
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h   |    1 +
 drivers/scsi/bfa/loop.c                          |    2 +-
 drivers/scsi/bfa/lport_api.c                     |    2 +-
 drivers/scsi/bfa/ms.c                            |    2 +-
 drivers/scsi/bfa/ns.c                            |    2 +-
 drivers/scsi/bfa/rport.c                         |    8 +-
 drivers/scsi/bfa/rport_api.c                     |    2 +-
 drivers/scsi/bfa/vport.c                         |    2 +-
 24 files changed, 1014 insertions(+), 739 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 82858db..6266b5c 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -23,34 +23,40 @@
 #include <cs/bfa_plog.h>
 #include <aen/bfa_aen_port.h>
 
-BFA_TRC_FILE(HAL, PPORT);
-BFA_MODULE(pport);
+BFA_TRC_FILE(HAL, FCPORT);
+BFA_MODULE(fcport);
 
 /*
  * The port is considered disabled if corresponding physical port or IOC are
  * disabled explicitly
  */
 #define BFA_PORT_IS_DISABLED(bfa) \
-	((bfa_pport_is_disabled(bfa) == BFA_TRUE) || \
+	((bfa_fcport_is_disabled(bfa) == BFA_TRUE) || \
 	(bfa_ioc_is_disabled(&bfa->ioc) == BFA_TRUE))
 
 /*
  * forward declarations
  */
-static bfa_boolean_t bfa_pport_send_enable(struct bfa_pport_s *port);
-static bfa_boolean_t bfa_pport_send_disable(struct bfa_pport_s *port);
-static void     bfa_pport_update_linkinfo(struct bfa_pport_s *pport);
-static void     bfa_pport_reset_linkinfo(struct bfa_pport_s *pport);
-static void     bfa_pport_set_wwns(struct bfa_pport_s *port);
-static void     __bfa_cb_port_event(void *cbarg, bfa_boolean_t complete);
+static bfa_boolean_t bfa_fcport_send_enable(struct bfa_fcport_s *fcport);
+static bfa_boolean_t bfa_fcport_send_disable(struct bfa_fcport_s *fcport);
+static void     bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport);
+static void     bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport);
+static void     bfa_fcport_set_wwns(struct bfa_fcport_s *fcport);
+static void     __bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete);
+static void     bfa_fcport_callback(struct bfa_fcport_s *fcport,
+				enum bfa_pport_linkstate event);
+static void     bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln,
+				enum bfa_pport_linkstate event);
+static void     __bfa_cb_fcport_stats(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete);
+static void     bfa_fcport_stats_timeout(void *cbarg);
+static void     bfa_fcport_stats_clr_timeout(void *cbarg);
+
 static void     __bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete);
 static void     __bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete);
 static void     bfa_port_stats_timeout(void *cbarg);
 static void     bfa_port_stats_clr_timeout(void *cbarg);
-static void	bfa_pport_callback(struct bfa_pport_s *pport,
-				enum bfa_pport_linkstate event);
-static void	bfa_pport_queue_cb(struct bfa_pport_ln_s *ln,
-				enum bfa_pport_linkstate event);
+
 /**
  *  bfa_pport_private
  */
@@ -58,87 +64,86 @@ static void	bfa_pport_queue_cb(struct bfa_pport_ln_s *ln,
 /**
  * BFA port state machine events
  */
-enum bfa_pport_sm_event {
-	BFA_PPORT_SM_START = 1,	/*  start port state machine */
-	BFA_PPORT_SM_STOP = 2,	/*  stop port state machine */
-	BFA_PPORT_SM_ENABLE = 3,	/*  enable port */
-	BFA_PPORT_SM_DISABLE = 4,	/*  disable port state machine */
-	BFA_PPORT_SM_FWRSP = 5,	/*  firmware enable/disable rsp */
-	BFA_PPORT_SM_LINKUP = 6,	/*  firmware linkup event */
-	BFA_PPORT_SM_LINKDOWN = 7,	/*  firmware linkup down */
-	BFA_PPORT_SM_QRESUME = 8,	/*  CQ space available */
-	BFA_PPORT_SM_HWFAIL = 9,	/*  IOC h/w failure */
+enum bfa_fcport_sm_event {
+	BFA_FCPORT_SM_START = 1,	/*  start port state machine */
+	BFA_FCPORT_SM_STOP = 2,	/*  stop port state machine */
+	BFA_FCPORT_SM_ENABLE = 3,	/*  enable port */
+	BFA_FCPORT_SM_DISABLE = 4,	/*  disable port state machine */
+	BFA_FCPORT_SM_FWRSP = 5,	/*  firmware enable/disable rsp */
+	BFA_FCPORT_SM_LINKUP = 6,	/*  firmware linkup event */
+	BFA_FCPORT_SM_LINKDOWN = 7,	/*  firmware linkup down */
+	BFA_FCPORT_SM_QRESUME = 8,	/*  CQ space available */
+	BFA_FCPORT_SM_HWFAIL = 9,	/*  IOC h/w failure */
 };
 
 /**
  * BFA port link notification state machine events
  */
 
-enum bfa_pport_ln_sm_event {
-	BFA_PPORT_LN_SM_LINKUP         = 1,    /*  linkup event */
-	BFA_PPORT_LN_SM_LINKDOWN       = 2,    /*  linkdown event */
-	BFA_PPORT_LN_SM_NOTIFICATION   = 3     /*  done notification */
+enum bfa_fcport_ln_sm_event {
+	BFA_FCPORT_LN_SM_LINKUP         = 1,    /*  linkup event */
+	BFA_FCPORT_LN_SM_LINKDOWN       = 2,    /*  linkdown event */
+	BFA_FCPORT_LN_SM_NOTIFICATION   = 3     /*  done notification */
 };
 
-static void     bfa_pport_sm_uninit(struct bfa_pport_s *pport,
-				    enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
-					    enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_enabling(struct bfa_pport_s *pport,
-				      enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_linkdown(struct bfa_pport_s *pport,
-				      enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_linkup(struct bfa_pport_s *pport,
-				    enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_disabling(struct bfa_pport_s *pport,
-				       enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
-					     enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_disabled(struct bfa_pport_s *pport,
-				      enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_stopped(struct bfa_pport_s *pport,
-				     enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_iocdown(struct bfa_pport_s *pport,
-				     enum bfa_pport_sm_event event);
-static void     bfa_pport_sm_iocfail(struct bfa_pport_s *pport,
-				     enum bfa_pport_sm_event event);
-
-static void	bfa_pport_ln_sm_dn(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void	bfa_pport_ln_sm_dn_nf(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void	bfa_pport_ln_sm_dn_up_nf(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void     bfa_pport_ln_sm_up(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void	bfa_pport_ln_sm_up_nf(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void	bfa_pport_ln_sm_up_dn_nf(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
-static void	bfa_pport_ln_sm_up_dn_up_nf(struct bfa_pport_ln_s *ln,
-					enum bfa_pport_ln_sm_event event);
+static void     bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
+					enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_disabling_qwait(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_stopped(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_iocdown(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+static void     bfa_fcport_sm_iocfail(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+
+static void     bfa_fcport_ln_sm_dn(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_dn_nf(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_dn_up_nf(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_up(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_up_nf(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_up_dn_nf(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
+static void     bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
+					 enum bfa_fcport_ln_sm_event event);
 
 static struct bfa_sm_table_s hal_pport_sm_table[] = {
-	{BFA_SM(bfa_pport_sm_uninit), BFA_PPORT_ST_UNINIT},
-	{BFA_SM(bfa_pport_sm_enabling_qwait), BFA_PPORT_ST_ENABLING_QWAIT},
-	{BFA_SM(bfa_pport_sm_enabling), BFA_PPORT_ST_ENABLING},
-	{BFA_SM(bfa_pport_sm_linkdown), BFA_PPORT_ST_LINKDOWN},
-	{BFA_SM(bfa_pport_sm_linkup), BFA_PPORT_ST_LINKUP},
-	{BFA_SM(bfa_pport_sm_disabling_qwait),
-	 BFA_PPORT_ST_DISABLING_QWAIT},
-	{BFA_SM(bfa_pport_sm_disabling), BFA_PPORT_ST_DISABLING},
-	{BFA_SM(bfa_pport_sm_disabled), BFA_PPORT_ST_DISABLED},
-	{BFA_SM(bfa_pport_sm_stopped), BFA_PPORT_ST_STOPPED},
-	{BFA_SM(bfa_pport_sm_iocdown), BFA_PPORT_ST_IOCDOWN},
-	{BFA_SM(bfa_pport_sm_iocfail), BFA_PPORT_ST_IOCDOWN},
+	{BFA_SM(bfa_fcport_sm_uninit), BFA_PPORT_ST_UNINIT},
+	{BFA_SM(bfa_fcport_sm_enabling_qwait), BFA_PPORT_ST_ENABLING_QWAIT},
+	{BFA_SM(bfa_fcport_sm_enabling), BFA_PPORT_ST_ENABLING},
+	{BFA_SM(bfa_fcport_sm_linkdown), BFA_PPORT_ST_LINKDOWN},
+	{BFA_SM(bfa_fcport_sm_linkup), BFA_PPORT_ST_LINKUP},
+	{BFA_SM(bfa_fcport_sm_disabling_qwait), BFA_PPORT_ST_DISABLING_QWAIT},
+	{BFA_SM(bfa_fcport_sm_disabling), BFA_PPORT_ST_DISABLING},
+	{BFA_SM(bfa_fcport_sm_disabled), BFA_PPORT_ST_DISABLED},
+	{BFA_SM(bfa_fcport_sm_stopped), BFA_PPORT_ST_STOPPED},
+	{BFA_SM(bfa_fcport_sm_iocdown), BFA_PPORT_ST_IOCDOWN},
+	{BFA_SM(bfa_fcport_sm_iocfail), BFA_PPORT_ST_IOCDOWN},
 };
 
 static void
-bfa_pport_aen_post(struct bfa_pport_s *pport, enum bfa_port_aen_event event)
+bfa_fcport_aen_post(struct bfa_fcport_s *fcport, enum bfa_port_aen_event event)
 {
 	union bfa_aen_data_u aen_data;
-	struct bfa_log_mod_s *logmod = pport->bfa->logm;
-	wwn_t           pwwn = pport->pwwn;
+	struct bfa_log_mod_s *logmod = fcport->bfa->logm;
+	wwn_t           pwwn = fcport->pwwn;
 	char            pwwn_ptr[BFA_STRING_32];
 	struct bfa_ioc_attr_s ioc_attr;
 
@@ -167,28 +172,29 @@ bfa_pport_aen_post(struct bfa_pport_s *pport, enum bfa_port_aen_event event)
 		break;
 	}
 
-	bfa_ioc_get_attr(&pport->bfa->ioc, &ioc_attr);
+	bfa_ioc_get_attr(&fcport->bfa->ioc, &ioc_attr);
 	aen_data.port.ioc_type = ioc_attr.ioc_type;
 	aen_data.port.pwwn = pwwn;
 }
 
 static void
-bfa_pport_sm_uninit(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_START:
+	case BFA_FCPORT_SM_START:
 		/**
 		 * Start event after IOC is configured and BFA is started.
 		 */
-		if (bfa_pport_send_enable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		if (bfa_fcport_send_enable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling_qwait);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Port is persistently configured to be in enabled state. Do
 		 * not change state. Port enabling is done when START event is
@@ -196,389 +202,392 @@ bfa_pport_sm_uninit(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
 		 */
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
+	case BFA_FCPORT_SM_DISABLE:
 		/**
 		 * If a port is persistently configured to be disabled, the
 		 * first event will a port disable request.
 		 */
-		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabled);
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
-			    enum bfa_pport_sm_event event)
+bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
+			    enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_QRESUME:
-		bfa_sm_set_state(pport, bfa_pport_sm_enabling);
-		bfa_pport_send_enable(pport);
+	case BFA_FCPORT_SM_QRESUME:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
+		bfa_fcport_send_enable(fcport);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_reqq_wcancel(&pport->reqq_wait);
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+	case BFA_FCPORT_SM_STOP:
+		bfa_reqq_wcancel(&fcport->reqq_wait);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Already enable is in progress.
 		 */
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
+	case BFA_FCPORT_SM_DISABLE:
 		/**
 		 * Just send disable request to firmware when room becomes
 		 * available in request queue.
 		 */
-		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
-		bfa_reqq_wcancel(&pport->reqq_wait);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabled);
+		bfa_reqq_wcancel(&fcport->reqq_wait);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISABLE);
 		break;
 
-	case BFA_PPORT_SM_LINKUP:
-	case BFA_PPORT_SM_LINKDOWN:
+	case BFA_FCPORT_SM_LINKUP:
+	case BFA_FCPORT_SM_LINKDOWN:
 		/**
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_reqq_wcancel(&pport->reqq_wait);
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_reqq_wcancel(&fcport->reqq_wait);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_enabling(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_FWRSP:
-	case BFA_PPORT_SM_LINKDOWN:
-		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
+	case BFA_FCPORT_SM_FWRSP:
+	case BFA_FCPORT_SM_LINKDOWN:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkdown);
 		break;
 
-	case BFA_PPORT_SM_LINKUP:
-		bfa_pport_update_linkinfo(pport);
-		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
+	case BFA_FCPORT_SM_LINKUP:
+		bfa_fcport_update_linkinfo(fcport);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkup);
 
-		bfa_assert(pport->event_cbfn);
-		bfa_pport_callback(pport, BFA_PPORT_LINKUP);
+		bfa_assert(fcport->event_cbfn);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKUP);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Already being enabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
-		if (bfa_pport_send_disable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+	case BFA_FCPORT_SM_DISABLE:
+		if (bfa_fcport_send_disable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISABLE);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_linkdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_LINKUP:
-		bfa_pport_update_linkinfo(pport);
-		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
-		bfa_assert(pport->event_cbfn);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+	case BFA_FCPORT_SM_LINKUP:
+		bfa_fcport_update_linkinfo(fcport);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkup);
+		bfa_assert(fcport->event_cbfn);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
-		bfa_pport_callback(pport, BFA_PPORT_LINKUP);
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ONLINE);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKUP);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_ONLINE);
 		/**
 		 * If QoS is enabled and it is not online,
 		 * Send a separate event.
 		 */
-		if ((pport->cfg.qos_enabled)
-		    && (bfa_os_ntohl(pport->qos_attr.state) != BFA_QOS_ONLINE))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_QOS_NEG);
+		if ((fcport->cfg.qos_enabled)
+		    && (bfa_os_ntohl(fcport->qos_attr.state) != BFA_QOS_ONLINE))
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_QOS_NEG);
 
 		break;
 
-	case BFA_PPORT_SM_LINKDOWN:
+	case BFA_FCPORT_SM_LINKDOWN:
 		/**
 		 * Possible to get link down event.
 		 */
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Already enabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
-		if (bfa_pport_send_disable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+	case BFA_FCPORT_SM_DISABLE:
+		if (bfa_fcport_send_disable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISABLE);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_linkup(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport, enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Already enabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
-		if (bfa_pport_send_disable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+	case BFA_FCPORT_SM_DISABLE:
+		if (bfa_fcport_send_disable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_disabling_qwait);
 
-		bfa_pport_reset_linkinfo(pport);
-		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_fcport_reset_linkinfo(fcport);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_OFFLINE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISABLE);
 		break;
 
-	case BFA_PPORT_SM_LINKDOWN:
-		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
-		bfa_pport_reset_linkinfo(pport);
-		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+	case BFA_FCPORT_SM_LINKDOWN:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkdown);
+		bfa_fcport_reset_linkinfo(fcport);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
-		if (BFA_PORT_IS_DISABLED(pport->bfa))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		if (BFA_PORT_IS_DISABLED(fcport->bfa))
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_OFFLINE);
 		else
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISCONNECT);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
-		bfa_pport_reset_linkinfo(pport);
-		if (BFA_PORT_IS_DISABLED(pport->bfa))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
+		bfa_fcport_reset_linkinfo(fcport);
+		if (BFA_PORT_IS_DISABLED(fcport->bfa))
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_OFFLINE);
 		else
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISCONNECT);
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
-		bfa_pport_reset_linkinfo(pport);
-		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		if (BFA_PORT_IS_DISABLED(pport->bfa))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
+		bfa_fcport_reset_linkinfo(fcport);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKDOWN);
+		if (BFA_PORT_IS_DISABLED(fcport->bfa))
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_OFFLINE);
 		else
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+			bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISCONNECT);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
-			     enum bfa_pport_sm_event event)
+bfa_fcport_sm_disabling_qwait(struct bfa_fcport_s *fcport,
+			     enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_QRESUME:
-		bfa_sm_set_state(pport, bfa_pport_sm_disabling);
-		bfa_pport_send_disable(pport);
+	case BFA_FCPORT_SM_QRESUME:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabling);
+		bfa_fcport_send_disable(fcport);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
-		bfa_reqq_wcancel(&pport->reqq_wait);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
+		bfa_reqq_wcancel(&fcport->reqq_wait);
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
+	case BFA_FCPORT_SM_DISABLE:
 		/**
 		 * Already being disabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_LINKUP:
-	case BFA_PPORT_SM_LINKDOWN:
+	case BFA_FCPORT_SM_LINKUP:
+	case BFA_FCPORT_SM_LINKDOWN:
 		/**
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
-		bfa_reqq_wcancel(&pport->reqq_wait);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocfail);
+		bfa_reqq_wcancel(&fcport->reqq_wait);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_disabling(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_FWRSP:
-		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+	case BFA_FCPORT_SM_FWRSP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabled);
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
+	case BFA_FCPORT_SM_DISABLE:
 		/**
 		 * Already being disabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
-		if (bfa_pport_send_enable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+	case BFA_FCPORT_SM_ENABLE:
+		if (bfa_fcport_send_enable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_ENABLE);
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
 		break;
 
-	case BFA_PPORT_SM_LINKUP:
-	case BFA_PPORT_SM_LINKDOWN:
+	case BFA_FCPORT_SM_LINKUP:
+	case BFA_FCPORT_SM_LINKDOWN:
 		/**
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocfail);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_disabled(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_START:
+	case BFA_FCPORT_SM_START:
 		/**
 		 * Ignore start event for a port that is disabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_STOP:
-		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+	case BFA_FCPORT_SM_STOP:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_stopped);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
-		if (bfa_pport_send_enable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+	case BFA_FCPORT_SM_ENABLE:
+		if (bfa_fcport_send_enable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_ENABLE);
 		break;
 
-	case BFA_PPORT_SM_DISABLE:
+	case BFA_FCPORT_SM_DISABLE:
 		/**
 		 * Already disabled.
 		 */
 		break;
 
-	case BFA_PPORT_SM_HWFAIL:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+	case BFA_FCPORT_SM_HWFAIL:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocfail);
 		break;
 
 	default:
-		bfa_sm_fault(pport->bfa, event);
+		bfa_sm_fault(fcport->bfa, event);
 	}
 }
 
 static void
-bfa_pport_sm_stopped(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_stopped(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_START:
-		if (bfa_pport_send_enable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+	case BFA_FCPORT_SM_START:
+		if (bfa_fcport_send_enable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling_qwait);
 		break;
 
 	default:
@@ -593,16 +602,17 @@ bfa_pport_sm_stopped(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  * Port is enabled. IOC is down/failed.
  */
 static void
-bfa_pport_sm_iocdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_iocdown(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_START:
-		if (bfa_pport_send_enable(pport))
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+	case BFA_FCPORT_SM_START:
+		if (bfa_fcport_send_enable(fcport))
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
 		else
-			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling_qwait);
 		break;
 
 	default:
@@ -617,17 +627,18 @@ bfa_pport_sm_iocdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  * Port is disabled. IOC is down/failed.
  */
 static void
-bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_iocfail(struct bfa_fcport_s *fcport,
+			enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_START:
-		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+	case BFA_FCPORT_SM_START:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabled);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
-		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+	case BFA_FCPORT_SM_ENABLE:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_iocdown);
 		break;
 
 	default:
@@ -642,19 +653,19 @@ bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  * Link state is down
  */
 static void
-bfa_pport_ln_sm_dn(struct bfa_pport_ln_s *ln,
-		enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_dn(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKUP:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up_nf);
-		bfa_pport_queue_cb(ln, BFA_PPORT_LINKUP);
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKUP);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -662,22 +673,22 @@ bfa_pport_ln_sm_dn(struct bfa_pport_ln_s *ln,
  * Link state is waiting for down notification
  */
 static void
-bfa_pport_ln_sm_dn_nf(struct bfa_pport_ln_s *ln,
-		enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_dn_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKUP:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn_up_nf);
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_up_nf);
 		break;
 
-	case BFA_PPORT_LN_SM_NOTIFICATION:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn);
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -685,23 +696,23 @@ bfa_pport_ln_sm_dn_nf(struct bfa_pport_ln_s *ln,
  * Link state is waiting for down notification and there is a pending up
  */
 static void
-bfa_pport_ln_sm_dn_up_nf(struct bfa_pport_ln_s *ln,
-		enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_dn_up_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKDOWN:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn_nf);
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
 		break;
 
-	case BFA_PPORT_LN_SM_NOTIFICATION:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up_nf);
-		bfa_pport_queue_cb(ln, BFA_PPORT_LINKUP);
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKUP);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -709,19 +720,19 @@ bfa_pport_ln_sm_dn_up_nf(struct bfa_pport_ln_s *ln,
  * Link state is up
  */
 static void
-bfa_pport_ln_sm_up(struct bfa_pport_ln_s *ln,
-                enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_up(struct bfa_fcport_ln_s *ln,
+                enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKDOWN:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn_nf);
-		bfa_pport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -729,22 +740,22 @@ bfa_pport_ln_sm_up(struct bfa_pport_ln_s *ln,
  * Link state is waiting for up notification
  */
 static void
-bfa_pport_ln_sm_up_nf(struct bfa_pport_ln_s *ln,
-		enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_up_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKDOWN:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up_dn_nf);
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_nf);
 		break;
 
 	case BFA_FCPORT_LN_SM_NOTIFICATION:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up);
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -752,23 +763,23 @@ bfa_pport_ln_sm_up_nf(struct bfa_pport_ln_s *ln,
  * Link state is waiting for up notification and there is a pending down
  */
 static void
-bfa_pport_ln_sm_up_dn_nf(struct bfa_pport_ln_s *ln,
-		enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_up_dn_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKUP:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up_dn_up_nf);
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_up_nf);
 		break;
 
-	case BFA_PPORT_LN_SM_NOTIFICATION:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn_nf);
-		bfa_pport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -776,23 +787,23 @@ bfa_pport_ln_sm_up_dn_nf(struct bfa_pport_ln_s *ln,
  * Link state is waiting for up notification and there are pending down and up
  */
 static void
-bfa_pport_ln_sm_up_dn_up_nf(struct bfa_pport_ln_s *ln,
-			enum bfa_pport_ln_sm_event event)
+bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
+			enum bfa_fcport_ln_sm_event event)
 {
-	bfa_trc(ln->pport->bfa, event);
+	bfa_trc(ln->fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_LN_SM_LINKDOWN:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_up_dn_nf);
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_nf);
 		break;
 
-	case BFA_PPORT_LN_SM_NOTIFICATION:
-		bfa_sm_set_state(ln, bfa_pport_ln_sm_dn_up_nf);
-		bfa_pport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
 		break;
 
 	default:
-		bfa_sm_fault(ln->pport->bfa, event);
+		bfa_sm_fault(ln->fcport->bfa, event);
 	}
 }
 
@@ -801,36 +812,40 @@ bfa_pport_ln_sm_up_dn_up_nf(struct bfa_pport_ln_s *ln,
  */
 
 static void
-__bfa_cb_port_event(void *cbarg, bfa_boolean_t complete)
+__bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete)
 {
-	struct bfa_pport_ln_s *ln = cbarg;
+	struct bfa_fcport_ln_s *ln = cbarg;
 
 	if (complete)
-		ln->pport->event_cbfn(ln->pport->event_cbarg, ln->ln_event);
+		ln->fcport->event_cbfn(ln->fcport->event_cbarg, ln->ln_event);
 	else
-		bfa_sm_send_event(ln, BFA_PPORT_LN_SM_NOTIFICATION);
+		bfa_sm_send_event(ln, BFA_FCPORT_LN_SM_NOTIFICATION);
 }
 
-#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_pport_stats_u), \
+#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
+							BFA_CACHELINE_SZ))
+
+#define FCPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
 							BFA_CACHELINE_SZ))
 
 static void
-bfa_pport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
 		  u32 *dm_len)
 {
 	*dm_len += PPORT_STATS_DMA_SZ;
+	*dm_len += PPORT_STATS_DMA_SZ;
 }
 
 static void
-bfa_pport_qresume(void *cbarg)
+bfa_fcport_qresume(void *cbarg)
 {
-	struct bfa_pport_s *port = cbarg;
+	struct bfa_fcport_s *port = cbarg;
 
-	bfa_sm_send_event(port, BFA_PPORT_SM_QRESUME);
+	bfa_sm_send_event(port, BFA_FCPORT_SM_QRESUME);
 }
 
 static void
-bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
+bfa_fcport_mem_claim(struct bfa_fcport_s *fcport, struct bfa_meminfo_s *meminfo)
 {
 	u8        *dm_kva;
 	u64        dm_pa;
@@ -838,13 +853,22 @@ bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
 	dm_kva = bfa_meminfo_dma_virt(meminfo);
 	dm_pa = bfa_meminfo_dma_phys(meminfo);
 
-	pport->stats_kva = dm_kva;
-	pport->stats_pa = dm_pa;
-	pport->stats = (union bfa_pport_stats_u *)dm_kva;
+	fcport->stats_kva = dm_kva;
+	fcport->stats_pa = dm_pa;
+	fcport->stats = (union bfa_pport_stats_u *)dm_kva;
 
 	dm_kva += PPORT_STATS_DMA_SZ;
 	dm_pa += PPORT_STATS_DMA_SZ;
 
+	/* FC port stats */
+
+	fcport->fcport_stats_kva = dm_kva;
+	fcport->fcport_stats_pa = dm_pa;
+	fcport->fcport_stats = (union bfa_fcport_stats_u *) dm_kva;
+
+	dm_kva += FCPORT_STATS_DMA_SZ;
+	dm_pa += FCPORT_STATS_DMA_SZ;
+
 	bfa_meminfo_dma_virt(meminfo) = dm_kva;
 	bfa_meminfo_dma_phys(meminfo) = dm_pa;
 }
@@ -853,21 +877,21 @@ bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
  * Memory initialization.
  */
 static void
-bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		 struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
-	struct bfa_pport_cfg_s *port_cfg = &pport->cfg;
-	struct bfa_pport_ln_s *ln = &pport->ln;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_pport_cfg_s *port_cfg = &fcport->cfg;
+	struct bfa_fcport_ln_s *ln = &fcport->ln;
 
-	bfa_os_memset(pport, 0, sizeof(struct bfa_pport_s));
-	pport->bfa = bfa;
-	ln->pport = pport;
+	bfa_os_memset(fcport, 0, sizeof(struct bfa_fcport_s));
+	fcport->bfa = bfa;
+	ln->fcport = fcport;
 
-	bfa_pport_mem_claim(pport, meminfo);
+	bfa_fcport_mem_claim(fcport, meminfo);
 
-	bfa_sm_set_state(pport, bfa_pport_sm_uninit);
-	bfa_sm_set_state(ln, bfa_pport_ln_sm_dn);
+	bfa_sm_set_state(fcport, bfa_fcport_sm_uninit);
+	bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
 
 	/**
 	 * initialize and set default configuration
@@ -879,30 +903,30 @@ bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	port_cfg->trl_def_speed = BFA_PPORT_SPEED_1GBPS;
 
-	bfa_reqq_winit(&pport->reqq_wait, bfa_pport_qresume, pport);
+	bfa_reqq_winit(&fcport->reqq_wait, bfa_fcport_qresume, fcport);
 }
 
 static void
-bfa_pport_initdone(struct bfa_s *bfa)
+bfa_fcport_initdone(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	/**
 	 * Initialize port attributes from IOC hardware data.
 	 */
-	bfa_pport_set_wwns(pport);
-	if (pport->cfg.maxfrsize == 0)
-		pport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
-	pport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
-	pport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
+	bfa_fcport_set_wwns(fcport);
+	if (fcport->cfg.maxfrsize == 0)
+		fcport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
+	fcport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
+	fcport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
 
-	bfa_assert(pport->cfg.maxfrsize);
-	bfa_assert(pport->cfg.rx_bbcredit);
-	bfa_assert(pport->speed_sup);
+	bfa_assert(fcport->cfg.maxfrsize);
+	bfa_assert(fcport->cfg.rx_bbcredit);
+	bfa_assert(fcport->speed_sup);
 }
 
 static void
-bfa_pport_detach(struct bfa_s *bfa)
+bfa_fcport_detach(struct bfa_s *bfa)
 {
 }
 
@@ -910,62 +934,63 @@ bfa_pport_detach(struct bfa_s *bfa)
  * Called when IOC is ready.
  */
 static void
-bfa_pport_start(struct bfa_s *bfa)
+bfa_fcport_start(struct bfa_s *bfa)
 {
-	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_START);
+	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_START);
 }
 
 /**
  * Called before IOC is stopped.
  */
 static void
-bfa_pport_stop(struct bfa_s *bfa)
+bfa_fcport_stop(struct bfa_s *bfa)
 {
-	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_STOP);
+	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_STOP);
 }
 
 /**
  * Called when IOC failure is detected.
  */
 static void
-bfa_pport_iocdisable(struct bfa_s *bfa)
+bfa_fcport_iocdisable(struct bfa_s *bfa)
 {
-	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_HWFAIL);
+	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_HWFAIL);
 }
 
 static void
-bfa_pport_update_linkinfo(struct bfa_pport_s *pport)
+bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 {
-	struct bfi_pport_event_s *pevent = pport->event_arg.i2hmsg.event;
+	struct bfi_pport_event_s *pevent = fcport->event_arg.i2hmsg.event;
 
-	pport->speed = pevent->link_state.speed;
-	pport->topology = pevent->link_state.topology;
+	fcport->speed = pevent->link_state.speed;
+	fcport->topology = pevent->link_state.topology;
 
-	if (pport->topology == BFA_PPORT_TOPOLOGY_LOOP)
-		pport->myalpa = pevent->link_state.tl.loop_info.myalpa;
+	if (fcport->topology == BFA_PPORT_TOPOLOGY_LOOP)
+		fcport->myalpa =
+			pevent->link_state.tl.loop_info.myalpa;
 
 	/*
 	 * QoS Details
 	 */
-	bfa_os_assign(pport->qos_attr, pevent->link_state.qos_attr);
-	bfa_os_assign(pport->qos_vc_attr, pevent->link_state.qos_vc_attr);
+	bfa_os_assign(fcport->qos_attr, pevent->link_state.qos_attr);
+	bfa_os_assign(fcport->qos_vc_attr, pevent->link_state.qos_vc_attr);
 
-	bfa_trc(pport->bfa, pport->speed);
-	bfa_trc(pport->bfa, pport->topology);
+	bfa_trc(fcport->bfa, fcport->speed);
+	bfa_trc(fcport->bfa, fcport->topology);
 }
 
 static void
-bfa_pport_reset_linkinfo(struct bfa_pport_s *pport)
+bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport)
 {
-	pport->speed = BFA_PPORT_SPEED_UNKNOWN;
-	pport->topology = BFA_PPORT_TOPOLOGY_NONE;
+	fcport->speed = BFA_PPORT_SPEED_UNKNOWN;
+	fcport->topology = BFA_PPORT_TOPOLOGY_NONE;
 }
 
 /**
  * Send port enable message to firmware.
  */
 static          bfa_boolean_t
-bfa_pport_send_enable(struct bfa_pport_s *port)
+bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 {
 	struct bfi_pport_enable_req_s *m;
 
@@ -973,32 +998,34 @@ bfa_pport_send_enable(struct bfa_pport_s *port)
 	 * Increment message tag before queue check, so that responses to old
 	 * requests are discarded.
 	 */
-	port->msgtag++;
+	fcport->msgtag++;
 
 	/**
 	 * check for room in queue to send request now
 	 */
-	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 	if (!m) {
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->reqq_wait);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+							&fcport->reqq_wait);
 		return BFA_FALSE;
 	}
 
 	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_ENABLE_REQ,
-		    bfa_lpuid(port->bfa));
-	m->nwwn = port->nwwn;
-	m->pwwn = port->pwwn;
-	m->port_cfg = port->cfg;
-	m->msgtag = port->msgtag;
-	m->port_cfg.maxfrsize = bfa_os_htons(port->cfg.maxfrsize);
-	bfa_dma_be_addr_set(m->stats_dma_addr, port->stats_pa);
-	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_lo);
-	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_hi);
+		    bfa_lpuid(fcport->bfa));
+	m->nwwn = fcport->nwwn;
+	m->pwwn = fcport->pwwn;
+	m->port_cfg = fcport->cfg;
+	m->msgtag = fcport->msgtag;
+	m->port_cfg.maxfrsize = bfa_os_htons(fcport->cfg.maxfrsize);
+	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
+	bfa_dma_be_addr_set(m->fcport_stats_dma_addr, fcport->fcport_stats_pa);
+	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
+	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
 
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 	return BFA_TRUE;
 }
 
@@ -1006,7 +1033,7 @@ bfa_pport_send_enable(struct bfa_pport_s *port)
  * Send port disable message to firmware.
  */
 static          bfa_boolean_t
-bfa_pport_send_disable(struct bfa_pport_s *port)
+bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 {
 	bfi_pport_disable_req_t *m;
 
@@ -1014,63 +1041,64 @@ bfa_pport_send_disable(struct bfa_pport_s *port)
 	 * Increment message tag before queue check, so that responses to old
 	 * requests are discarded.
 	 */
-	port->msgtag++;
+	fcport->msgtag++;
 
 	/**
 	 * check for room in queue to send request now
 	 */
-	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 	if (!m) {
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->reqq_wait);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+							&fcport->reqq_wait);
 		return BFA_FALSE;
 	}
 
 	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_DISABLE_REQ,
-		    bfa_lpuid(port->bfa));
-	m->msgtag = port->msgtag;
+		    bfa_lpuid(fcport->bfa));
+	m->msgtag = fcport->msgtag;
 
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 
 	return BFA_TRUE;
 }
 
 static void
-bfa_pport_set_wwns(struct bfa_pport_s *port)
+bfa_fcport_set_wwns(struct bfa_fcport_s *fcport)
 {
-	port->pwwn = bfa_ioc_get_pwwn(&port->bfa->ioc);
-	port->nwwn = bfa_ioc_get_nwwn(&port->bfa->ioc);
+	fcport->pwwn = bfa_ioc_get_pwwn(&fcport->bfa->ioc);
+	fcport->nwwn = bfa_ioc_get_nwwn(&fcport->bfa->ioc);
 
-	bfa_trc(port->bfa, port->pwwn);
-	bfa_trc(port->bfa, port->nwwn);
+	bfa_trc(fcport->bfa, fcport->pwwn);
+	bfa_trc(fcport->bfa, fcport->nwwn);
 }
 
 static void
-bfa_port_send_txcredit(void *port_cbarg)
+bfa_fcport_send_txcredit(void *port_cbarg)
 {
 
-	struct bfa_pport_s *port = port_cbarg;
+	struct bfa_fcport_s *fcport = port_cbarg;
 	struct bfi_pport_set_svc_params_req_s *m;
 
 	/**
 	 * check for room in queue to send request now
 	 */
-	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 	if (!m) {
-		bfa_trc(port->bfa, port->cfg.tx_bbcredit);
+		bfa_trc(fcport->bfa, fcport->cfg.tx_bbcredit);
 		return;
 	}
 
 	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_SET_SVC_PARAMS_REQ,
-		    bfa_lpuid(port->bfa));
-	m->tx_bbcredit = bfa_os_htons((u16) port->cfg.tx_bbcredit);
+		    bfa_lpuid(fcport->bfa));
+	m->tx_bbcredit = bfa_os_htons((u16) fcport->cfg.tx_bbcredit);
 
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 }
 
 
@@ -1083,32 +1111,32 @@ bfa_port_send_txcredit(void *port_cbarg)
  * Firmware message handler.
  */
 void
-bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	union bfi_pport_i2h_msg_u i2hmsg;
 
 	i2hmsg.msg = msg;
-	pport->event_arg.i2hmsg = i2hmsg;
+	fcport->event_arg.i2hmsg = i2hmsg;
 
 	switch (msg->mhdr.msg_id) {
 	case BFI_PPORT_I2H_ENABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
-			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		if (fcport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
 	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
-			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		if (fcport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
 	case BFI_PPORT_I2H_EVENT:
 		switch (i2hmsg.event->link_state.linkstate) {
 		case BFA_PPORT_LINKUP:
-			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKUP);
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_LINKUP);
 			break;
 		case BFA_PPORT_LINKDOWN:
-			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKDOWN);
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_LINKDOWN);
 			break;
 		case BFA_PPORT_TRUNK_LINKDOWN:
 			/** todo: event notification */
@@ -1121,32 +1149,63 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		/*
 		 * check for timer pop before processing the rsp
 		 */
-		if (pport->stats_busy == BFA_FALSE
-		    || pport->stats_status == BFA_STATUS_ETIMER)
+		if (fcport->stats_busy == BFA_FALSE
+		    || fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
 
-		bfa_timer_stop(&pport->timer);
-		pport->stats_status = i2hmsg.getstats_rsp->status;
-		bfa_cb_queue(pport->bfa, &pport->hcb_qe, __bfa_cb_port_stats,
-			     pport);
+		bfa_timer_stop(&fcport->timer);
+		fcport->stats_status = i2hmsg.getstats_rsp->status;
+		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_port_stats,
+			     fcport);
 		break;
 	case BFI_PPORT_I2H_CLEAR_STATS_RSP:
 	case BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
-		if (pport->stats_busy == BFA_FALSE
-		    || pport->stats_status == BFA_STATUS_ETIMER)
+		if (fcport->stats_busy == BFA_FALSE
+		    || fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
 
-		bfa_timer_stop(&pport->timer);
-		pport->stats_status = BFA_STATUS_OK;
-		bfa_cb_queue(pport->bfa, &pport->hcb_qe,
-			     __bfa_cb_port_stats_clr, pport);
+		bfa_timer_stop(&fcport->timer);
+		fcport->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+			     __bfa_cb_port_stats_clr, fcport);
+		break;
+
+	case BFI_FCPORT_I2H_GET_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (fcport->stats_busy == BFA_FALSE ||
+			fcport->stats_status == BFA_STATUS_ETIMER) {
+			break;
+		}
+
+		bfa_timer_stop(&fcport->timer);
+		fcport->stats_status = i2hmsg.getstats_rsp->status;
+		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+				__bfa_cb_fcport_stats, fcport);
+		break;
+
+	case BFI_FCPORT_I2H_CLEAR_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (fcport->stats_busy == BFA_FALSE ||
+			fcport->stats_status == BFA_STATUS_ETIMER) {
+			break;
+		}
+
+		bfa_timer_stop(&fcport->timer);
+		fcport->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+				__bfa_cb_fcport_stats_clr, fcport);
 		break;
 
 	default:
 		bfa_assert(0);
+	break;
 	}
 }
 
@@ -1160,35 +1219,35 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
  * Registered callback for port events.
  */
 void
-bfa_pport_event_register(struct bfa_s *bfa,
+bfa_fcport_event_register(struct bfa_s *bfa,
 			 void (*cbfn) (void *cbarg, bfa_pport_event_t event),
 			 void *cbarg)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	pport->event_cbfn = cbfn;
-	pport->event_cbarg = cbarg;
+	fcport->event_cbfn = cbfn;
+	fcport->event_cbarg = cbarg;
 }
 
 bfa_status_t
-bfa_pport_enable(struct bfa_s *bfa)
+bfa_fcport_enable(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	if (pport->diag_busy)
+	if (fcport->diag_busy)
 		return BFA_STATUS_DIAG_BUSY;
 	else if (bfa_sm_cmp_state
-		 (BFA_PORT_MOD(bfa), bfa_pport_sm_disabling_qwait))
+		 (BFA_FCPORT_MOD(bfa), bfa_fcport_sm_disabling_qwait))
 		return BFA_STATUS_DEVBUSY;
 
-	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_ENABLE);
+	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_ENABLE);
 	return BFA_STATUS_OK;
 }
 
 bfa_status_t
-bfa_pport_disable(struct bfa_s *bfa)
+bfa_fcport_disable(struct bfa_s *bfa)
 {
-	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_DISABLE);
+	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_DISABLE);
 	return BFA_STATUS_OK;
 }
 
@@ -1196,18 +1255,18 @@ bfa_pport_disable(struct bfa_s *bfa)
  * Configure port speed.
  */
 bfa_status_t
-bfa_pport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+bfa_fcport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, speed);
 
-	if ((speed != BFA_PPORT_SPEED_AUTO) && (speed > pport->speed_sup)) {
-		bfa_trc(bfa, pport->speed_sup);
+	if ((speed != BFA_PPORT_SPEED_AUTO) && (speed > fcport->speed_sup)) {
+		bfa_trc(bfa, fcport->speed_sup);
 		return BFA_STATUS_UNSUPP_SPEED;
 	}
 
-	pport->cfg.speed = speed;
+	fcport->cfg.speed = speed;
 
 	return BFA_STATUS_OK;
 }
@@ -1216,23 +1275,23 @@ bfa_pport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
  * Get current speed.
  */
 enum bfa_pport_speed
-bfa_pport_get_speed(struct bfa_s *bfa)
+bfa_fcport_get_speed(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->speed;
+	return fcport->speed;
 }
 
 /**
  * Configure port topology.
  */
 bfa_status_t
-bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
+bfa_fcport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, topology);
-	bfa_trc(bfa, pport->cfg.topology);
+	bfa_trc(bfa, fcport->cfg.topology);
 
 	switch (topology) {
 	case BFA_PPORT_TOPOLOGY_P2P:
@@ -1244,7 +1303,7 @@ bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
 		return BFA_STATUS_EINVAL;
 	}
 
-	pport->cfg.topology = topology;
+	fcport->cfg.topology = topology;
 	return BFA_STATUS_OK;
 }
 
@@ -1252,64 +1311,64 @@ bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
  * Get current topology.
  */
 enum bfa_pport_topology
-bfa_pport_get_topology(struct bfa_s *bfa)
+bfa_fcport_get_topology(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->topology;
+	return fcport->topology;
 }
 
 bfa_status_t
-bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa)
+bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, alpa);
-	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
-	bfa_trc(bfa, pport->cfg.hardalpa);
+	bfa_trc(bfa, fcport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, fcport->cfg.hardalpa);
 
-	pport->cfg.cfg_hardalpa = BFA_TRUE;
-	pport->cfg.hardalpa = alpa;
+	fcport->cfg.cfg_hardalpa = BFA_TRUE;
+	fcport->cfg.hardalpa = alpa;
 
 	return BFA_STATUS_OK;
 }
 
 bfa_status_t
-bfa_pport_clr_hardalpa(struct bfa_s *bfa)
+bfa_fcport_clr_hardalpa(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
-	bfa_trc(bfa, pport->cfg.hardalpa);
+	bfa_trc(bfa, fcport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, fcport->cfg.hardalpa);
 
-	pport->cfg.cfg_hardalpa = BFA_FALSE;
+	fcport->cfg.cfg_hardalpa = BFA_FALSE;
 	return BFA_STATUS_OK;
 }
 
 bfa_boolean_t
-bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
+bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	*alpa = port->cfg.hardalpa;
-	return port->cfg.cfg_hardalpa;
+	*alpa = fcport->cfg.hardalpa;
+	return fcport->cfg.cfg_hardalpa;
 }
 
 u8
-bfa_pport_get_myalpa(struct bfa_s *bfa)
+bfa_fcport_get_myalpa(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->myalpa;
+	return fcport->myalpa;
 }
 
 bfa_status_t
-bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxfrsize)
+bfa_fcport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxfrsize)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, maxfrsize);
-	bfa_trc(bfa, pport->cfg.maxfrsize);
+	bfa_trc(bfa, fcport->cfg.maxfrsize);
 
 	/*
 	 * with in range
@@ -1323,41 +1382,41 @@ bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxfrsize)
 	if ((maxfrsize != FC_MAX_PDUSZ) && (maxfrsize & (maxfrsize - 1)))
 		return BFA_STATUS_INVLD_DFSZ;
 
-	pport->cfg.maxfrsize = maxfrsize;
+	fcport->cfg.maxfrsize = maxfrsize;
 	return BFA_STATUS_OK;
 }
 
 u16
-bfa_pport_get_maxfrsize(struct bfa_s *bfa)
+bfa_fcport_get_maxfrsize(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->cfg.maxfrsize;
+	return fcport->cfg.maxfrsize;
 }
 
 u32
-bfa_pport_mypid(struct bfa_s *bfa)
+bfa_fcport_mypid(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->mypid;
+	return fcport->mypid;
 }
 
 u8
-bfa_pport_get_rx_bbcredit(struct bfa_s *bfa)
+bfa_fcport_get_rx_bbcredit(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return port->cfg.rx_bbcredit;
+	return fcport->cfg.rx_bbcredit;
 }
 
 void
-bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
+bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	port->cfg.tx_bbcredit = (u8) tx_bbcredit;
-	bfa_port_send_txcredit(port);
+	fcport->cfg.tx_bbcredit = (u8) tx_bbcredit;
+	bfa_fcport_send_txcredit(fcport);
 }
 
 /**
@@ -1365,78 +1424,79 @@ bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
  */
 
 wwn_t
-bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
+bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	if (node)
-		return pport->nwwn;
+		return fcport->nwwn;
 	else
-		return pport->pwwn;
+		return fcport->pwwn;
 }
 
 void
-bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
+bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_os_memset(attr, 0, sizeof(struct bfa_pport_attr_s));
 
-	attr->nwwn = pport->nwwn;
-	attr->pwwn = pport->pwwn;
+	attr->nwwn = fcport->nwwn;
+	attr->pwwn = fcport->pwwn;
 
-	bfa_os_memcpy(&attr->pport_cfg, &pport->cfg,
+	bfa_os_memcpy(&attr->pport_cfg, &fcport->cfg,
 		      sizeof(struct bfa_pport_cfg_s));
 	/*
 	 * speed attributes
 	 */
-	attr->pport_cfg.speed = pport->cfg.speed;
-	attr->speed_supported = pport->speed_sup;
-	attr->speed = pport->speed;
+	attr->pport_cfg.speed = fcport->cfg.speed;
+	attr->speed_supported = fcport->speed_sup;
+	attr->speed = fcport->speed;
 	attr->cos_supported = FC_CLASS_3;
 
 	/*
 	 * topology attributes
 	 */
-	attr->pport_cfg.topology = pport->cfg.topology;
-	attr->topology = pport->topology;
+	attr->pport_cfg.topology = fcport->cfg.topology;
+	attr->topology = fcport->topology;
 
 	/*
 	 * beacon attributes
 	 */
-	attr->beacon = pport->beacon;
-	attr->link_e2e_beacon = pport->link_e2e_beacon;
-	attr->plog_enabled = bfa_plog_get_setting(pport->bfa->plog);
+	attr->beacon = fcport->beacon;
+	attr->link_e2e_beacon = fcport->link_e2e_beacon;
+	attr->plog_enabled = bfa_plog_get_setting(fcport->bfa->plog);
 
 	attr->pport_cfg.path_tov = bfa_fcpim_path_tov_get(bfa);
 	attr->pport_cfg.q_depth = bfa_fcpim_qdepth_get(bfa);
-	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, pport->sm);
-	if (bfa_ioc_is_disabled(&pport->bfa->ioc))
+	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, fcport->sm);
+	if (bfa_ioc_is_disabled(&fcport->bfa->ioc))
 		attr->port_state = BFA_PPORT_ST_IOCDIS;
-	else if (bfa_ioc_fw_mismatch(&pport->bfa->ioc))
+	else if (bfa_ioc_fw_mismatch(&fcport->bfa->ioc))
 		attr->port_state = BFA_PPORT_ST_FWMISMATCH;
 }
 
 static void
 bfa_port_stats_query(void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
 	bfi_pport_get_stats_req_t *msg;
 
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 
 	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_query,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait, bfa_port_stats_query,
+			       fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+				&fcport->stats_reqq_wait);
 		return;
 	}
-	port->stats_qfull = BFA_FALSE;
+	fcport->stats_qfull = BFA_FALSE;
 
 	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+		    bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 
 	return;
 }
@@ -1444,65 +1504,111 @@ bfa_port_stats_query(void *cbarg)
 static void
 bfa_port_stats_clear(void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
 	bfi_pport_clear_stats_req_t *msg;
 
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 
 	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_clear,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait, bfa_port_stats_clear,
+			       fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+					&fcport->stats_reqq_wait);
 		return;
 	}
-	port->stats_qfull = BFA_FALSE;
+	fcport->stats_qfull = BFA_FALSE;
 
 	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+		    bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 	return;
 }
 
 static void
+bfa_fcport_stats_query(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
+	bfi_pport_get_stats_req_t *msg;
+
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait,
+			bfa_fcport_stats_query, fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+			&fcport->stats_reqq_wait);
+		return;
+	}
+	fcport->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_FCPORT_H2I_GET_STATS_REQ,
+		bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
+}
+
+static void
+bfa_fcport_stats_clear(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
+	bfi_pport_clear_stats_req_t *msg;
+
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait,
+			bfa_fcport_stats_clear, fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+			&fcport->stats_reqq_wait);
+		return;
+	}
+	fcport->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_FCPORT_H2I_CLEAR_STATS_REQ,
+		bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
+}
+
+static void
 bfa_port_qos_stats_clear(void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
 	bfi_pport_clear_qos_stats_req_t *msg;
 
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
 
 	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_qos_stats_clear,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait, bfa_port_qos_stats_clear,
+			       fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+				&fcport->stats_reqq_wait);
 		return;
 	}
-	port->stats_qfull = BFA_FALSE;
+	fcport->stats_qfull = BFA_FALSE;
 
 	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_qos_stats_req_t));
 	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+		    bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 	return;
 }
 
 static void
-bfa_pport_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
+bfa_fcport_stats_swap(union bfa_fcport_stats_u *d, union bfa_fcport_stats_u *s)
 {
-	u32       *dip = (u32 *) d;
-	u32       *sip = (u32 *) s;
+	u32        *dip = (u32 *) d;
+	u32        *sip = (u32 *) s;
 	int             i;
 
-	/*
-	 * Do 64 bit fields swap first
-	 */
-	for (i = 0;
-	     i <
-	     ((sizeof(union bfa_pport_stats_u) -
-	       sizeof(struct bfa_qos_stats_s)) / sizeof(u32)); i = i + 2) {
+	/* Do 64 bit fields swap first */
+	for (i = 0; i < ((sizeof(union bfa_fcport_stats_u) -
+			sizeof(struct bfa_qos_stats_s))/sizeof(u32)); i = i + 2) {
 #ifdef __BIGENDIAN
 		dip[i] = bfa_os_ntohl(sip[i]);
 		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
@@ -1512,56 +1618,88 @@ bfa_pport_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
 #endif
 	}
 
-	/*
-	 * Now swap the 32 bit fields
-	 */
-	for (; i < (sizeof(union bfa_pport_stats_u) / sizeof(u32)); ++i)
+	/* Now swap the 32 bit fields */
+	for (; i < (sizeof(union bfa_fcport_stats_u)/sizeof(u32)); ++i)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+bfa_port_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
+{
+	u32    *dip = (u32 *) d;
+	u32    *sip = (u32 *) s;
+	int     i;
+
+	/* Do 64 bit fields swap first */
+	for (i = 0; i < (sizeof(union bfa_pport_stats_u) / sizeof(u32));
+		i = i + 2) {
+#ifdef __BIGENDIAN
 		dip[i] = bfa_os_ntohl(sip[i]);
+		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
+#else
+		dip[i] = bfa_os_ntohl(sip[i + 1]);
+		dip[i + 1] = bfa_os_ntohl(sip[i]);
+#endif
+	}
 }
 
 static void
 __bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete)
 {
-	struct bfa_pport_s *port = cbarg;
+	struct bfa_fcport_s *fcport = cbarg;
 
 	if (complete) {
-		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
 	} else {
-		port->stats_busy = BFA_FALSE;
-		port->stats_status = BFA_STATUS_OK;
+		fcport->stats_busy = BFA_FALSE;
+		fcport->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+__bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_fcport_s *fcport = cbarg;
+
+	if (complete) {
+		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
+	} else {
+		fcport->stats_busy = BFA_FALSE;
+		fcport->stats_status = BFA_STATUS_OK;
 	}
 }
 
 static void
 bfa_port_stats_clr_timeout(void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
 
-	bfa_trc(port->bfa, port->stats_qfull);
+	bfa_trc(fcport->bfa, fcport->stats_qfull);
 
-	if (port->stats_qfull) {
-		bfa_reqq_wcancel(&port->stats_reqq_wait);
-		port->stats_qfull = BFA_FALSE;
+	if (fcport->stats_qfull) {
+		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
+		fcport->stats_qfull = BFA_FALSE;
 	}
 
-	port->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats_clr, port);
+	fcport->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+				__bfa_cb_port_stats_clr, fcport);
 }
 
 static void
-bfa_pport_callback(struct bfa_pport_s *pport, enum bfa_pport_linkstate event)
+bfa_fcport_callback(struct bfa_fcport_s *fcport, enum bfa_pport_linkstate event)
 {
-	if (pport->bfa->fcs) {
-		pport->event_cbfn(pport->event_cbarg, event);
+	if (fcport->bfa->fcs) {
+		fcport->event_cbfn(fcport->event_cbarg, event);
 		return;
 	}
 
 	switch (event) {
 	case BFA_PPORT_LINKUP:
-		bfa_sm_send_event(&pport->ln, BFA_PPORT_LN_SM_LINKUP);
+		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKUP);
 		break;
 	case BFA_PPORT_LINKDOWN:
-		bfa_sm_send_event(&pport->ln, BFA_PPORT_LN_SM_LINKDOWN);
+		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKDOWN);
 		break;
 	default:
 		bfa_assert(0);
@@ -1569,41 +1707,92 @@ bfa_pport_callback(struct bfa_pport_s *pport, enum bfa_pport_linkstate event)
 }
 
 static void
-bfa_pport_queue_cb(struct bfa_pport_ln_s *ln, enum bfa_pport_linkstate event)
+bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln, enum bfa_pport_linkstate event)
 {
 	ln->ln_event = event;
-	bfa_cb_queue(ln->pport->bfa, &ln->ln_qe, __bfa_cb_port_event, ln);
+	bfa_cb_queue(ln->fcport->bfa, &ln->ln_qe, __bfa_cb_fcport_event, ln);
+}
+
+static void
+bfa_fcport_stats_clr_timeout(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
+
+	bfa_trc(fcport->bfa, fcport->stats_qfull);
+
+	if (fcport->stats_qfull) {
+		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
+		fcport->stats_qfull = BFA_FALSE;
+	}
+
+	fcport->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_fcport_stats_clr,
+			fcport);
 }
 
 static void
 __bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete)
 {
-	struct bfa_pport_s *port = cbarg;
+	struct bfa_fcport_s *fcport = cbarg;
 
 	if (complete) {
-		if (port->stats_status == BFA_STATUS_OK)
-			bfa_pport_stats_swap(port->stats_ret, port->stats);
-		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+		if (fcport->stats_status == BFA_STATUS_OK)
+			bfa_port_stats_swap(fcport->stats_ret, fcport->stats);
+		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
 	} else {
-		port->stats_busy = BFA_FALSE;
-		port->stats_status = BFA_STATUS_OK;
+		fcport->stats_busy = BFA_FALSE;
+		fcport->stats_status = BFA_STATUS_OK;
 	}
 }
 
 static void
 bfa_port_stats_timeout(void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
+
+	bfa_trc(fcport->bfa, fcport->stats_qfull);
+
+	if (fcport->stats_qfull) {
+		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
+		fcport->stats_qfull = BFA_FALSE;
+	}
+
+	fcport->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_port_stats, fcport);
+}
+
+static void
+__bfa_cb_fcport_stats(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_fcport_s *fcport = cbarg;
+
+	if (complete) {
+		if (fcport->stats_status == BFA_STATUS_OK) {
+			bfa_fcport_stats_swap(fcport->fcport_stats_ret,
+				fcport->fcport_stats);
+		}
+		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
+	} else {
+		fcport->stats_busy = BFA_FALSE;
+		fcport->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_fcport_stats_timeout(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
 
-	bfa_trc(port->bfa, port->stats_qfull);
+	bfa_trc(fcport->bfa, fcport->stats_qfull);
 
-	if (port->stats_qfull) {
-		bfa_reqq_wcancel(&port->stats_reqq_wait);
-		port->stats_qfull = BFA_FALSE;
+	if (fcport->stats_qfull) {
+		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
+		fcport->stats_qfull = BFA_FALSE;
 	}
 
-	port->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats, port);
+	fcport->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_fcport_stats,
+			fcport);
 }
 
 #define BFA_PORT_STATS_TOV	1000
@@ -1615,21 +1804,21 @@ bfa_status_t
 bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
 		    bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
 		return BFA_STATUS_DEVBUSY;
 	}
 
-	port->stats_busy = BFA_TRUE;
-	port->stats_ret = stats;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
+	fcport->stats_busy = BFA_TRUE;
+	fcport->stats_ret = stats;
+	fcport->stats_cbfn = cbfn;
+	fcport->stats_cbarg = cbarg;
 
-	bfa_port_stats_query(port);
+	bfa_port_stats_query(fcport);
 
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_timeout, port,
+	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_timeout, fcport,
 			BFA_PORT_STATS_TOV);
 	return BFA_STATUS_OK;
 }
@@ -1637,57 +1826,111 @@ bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
 bfa_status_t
 bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
 		return BFA_STATUS_DEVBUSY;
 	}
 
-	port->stats_busy = BFA_TRUE;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
+	fcport->stats_busy = BFA_TRUE;
+	fcport->stats_cbfn = cbfn;
+	fcport->stats_cbarg = cbarg;
 
-	bfa_port_stats_clear(port);
+	bfa_port_stats_clear(fcport);
 
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
-			BFA_PORT_STATS_TOV);
+	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_clr_timeout,
+			fcport, BFA_PORT_STATS_TOV);
 	return BFA_STATUS_OK;
 }
 
+/**
+ * @brief
+ * Fetch FCPort statistics.
+ * Todo TBD: sharing timer,stats_busy and other resources of fcport for now -
+ * ideally we want to create seperate ones for fcport once bfa_fcport_s is
+ * decided.
+ *
+ */
 bfa_status_t
-bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
+bfa_fcport_get_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+		bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	fcport->stats_busy = BFA_TRUE;
+	fcport->fcport_stats_ret = stats;
+	fcport->stats_cbfn = cbfn;
+	fcport->stats_cbarg = cbarg;
+
+	bfa_fcport_stats_query(fcport);
+
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_timeout, fcport,
+			BFA_PORT_STATS_TOV);
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	fcport->stats_busy = BFA_TRUE;
+	fcport->stats_cbfn = cbfn;
+	fcport->stats_cbarg = cbarg;
+
+	bfa_fcport_stats_clear(fcport);
+
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_clr_timeout,
+			fcport, BFA_PORT_STATS_TOV);
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_fcport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
+{
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, bitmap);
-	bfa_trc(bfa, pport->cfg.trunked);
-	bfa_trc(bfa, pport->cfg.trunk_ports);
+	bfa_trc(bfa, fcport->cfg.trunked);
+	bfa_trc(bfa, fcport->cfg.trunk_ports);
 
 	if (!bitmap || (bitmap & (bitmap - 1)))
 		return BFA_STATUS_EINVAL;
 
-	pport->cfg.trunked = BFA_TRUE;
-	pport->cfg.trunk_ports = bitmap;
+	fcport->cfg.trunked = BFA_TRUE;
+	fcport->cfg.trunk_ports = bitmap;
 
 	return BFA_STATUS_OK;
 }
 
 void
-bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
+bfa_fcport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	qos_attr->state = bfa_os_ntohl(pport->qos_attr.state);
-	qos_attr->total_bb_cr = bfa_os_ntohl(pport->qos_attr.total_bb_cr);
+	qos_attr->state = bfa_os_ntohl(fcport->qos_attr.state);
+	qos_attr->total_bb_cr = bfa_os_ntohl(fcport->qos_attr.total_bb_cr);
 }
 
 void
-bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 			  struct bfa_qos_vc_attr_s *qos_vc_attr)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
-	struct bfa_qos_vc_attr_s *bfa_vc_attr = &pport->qos_vc_attr;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_qos_vc_attr_s *bfa_vc_attr = &fcport->qos_vc_attr;
 	u32        i = 0;
 
 	qos_vc_attr->total_vc_count = bfa_os_ntohs(bfa_vc_attr->total_vc_count);
@@ -1713,7 +1956,7 @@ bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
  * Fetch QoS Stats.
  */
 bfa_status_t
-bfa_pport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
+bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
 			bfa_cb_pport_t cbfn, void *cbarg)
 {
 	/*
@@ -1723,23 +1966,23 @@ bfa_pport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
 }
 
 bfa_status_t
-bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
 		return BFA_STATUS_DEVBUSY;
 	}
 
-	port->stats_busy = BFA_TRUE;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
+	fcport->stats_busy = BFA_TRUE;
+	fcport->stats_cbfn = cbfn;
+	fcport->stats_cbarg = cbarg;
 
-	bfa_port_qos_stats_clear(port);
+	bfa_port_qos_stats_clear(fcport);
 
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
-			BFA_PORT_STATS_TOV);
+	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_clr_timeout,
+			fcport, BFA_PORT_STATS_TOV);
 	return BFA_STATUS_OK;
 }
 
@@ -1747,82 +1990,82 @@ bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
  * Fetch port attributes.
  */
 bfa_status_t
-bfa_pport_trunk_disable(struct bfa_s *bfa)
+bfa_fcport_trunk_disable(struct bfa_s *bfa)
 {
 	return BFA_STATUS_OK;
 }
 
 bfa_boolean_t
-bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap)
+bfa_fcport_trunk_query(struct bfa_s *bfa, u32 *bitmap)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	*bitmap = port->cfg.trunk_ports;
-	return port->cfg.trunked;
+	*bitmap = fcport->cfg.trunk_ports;
+	return fcport->cfg.trunked;
 }
 
 bfa_boolean_t
-bfa_pport_is_disabled(struct bfa_s *bfa)
+bfa_fcport_is_disabled(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return bfa_sm_to_state(hal_pport_sm_table, port->sm) ==
+	return bfa_sm_to_state(hal_pport_sm_table, fcport->sm) ==
 		BFA_PPORT_ST_DISABLED;
 
 }
 
 bfa_boolean_t
-bfa_pport_is_ratelim(struct bfa_s *bfa)
+bfa_fcport_is_ratelim(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	return pport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE;
+	return fcport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE;
 
 }
 
 void
-bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
+bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, on_off);
-	bfa_trc(bfa, pport->cfg.qos_enabled);
+	bfa_trc(bfa, fcport->cfg.qos_enabled);
 
-	pport->cfg.qos_enabled = on_off;
+	fcport->cfg.qos_enabled = on_off;
 }
 
 void
-bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
+bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, on_off);
-	bfa_trc(bfa, pport->cfg.ratelimit);
+	bfa_trc(bfa, fcport->cfg.ratelimit);
 
-	pport->cfg.ratelimit = on_off;
-	if (pport->cfg.trl_def_speed == BFA_PPORT_SPEED_UNKNOWN)
-		pport->cfg.trl_def_speed = BFA_PPORT_SPEED_1GBPS;
+	fcport->cfg.ratelimit = on_off;
+	if (fcport->cfg.trl_def_speed == BFA_PPORT_SPEED_UNKNOWN)
+		fcport->cfg.trl_def_speed = BFA_PPORT_SPEED_1GBPS;
 }
 
 /**
  * Configure default minimum ratelim speed
  */
 bfa_status_t
-bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, speed);
 
 	/*
 	 * Auto and speeds greater than the supported speed, are invalid
 	 */
-	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > pport->speed_sup)) {
-		bfa_trc(bfa, pport->speed_sup);
+	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > fcport->speed_sup)) {
+		bfa_trc(bfa, fcport->speed_sup);
 		return BFA_STATUS_UNSUPP_SPEED;
 	}
 
-	pport->cfg.trl_def_speed = speed;
+	fcport->cfg.trl_def_speed = speed;
 
 	return BFA_STATUS_OK;
 }
@@ -1831,45 +2074,45 @@ bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
  * Get default minimum ratelim speed
  */
 enum bfa_pport_speed
-bfa_pport_get_ratelim_speed(struct bfa_s *bfa)
+bfa_fcport_get_ratelim_speed(struct bfa_s *bfa)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	bfa_trc(bfa, pport->cfg.trl_def_speed);
-	return pport->cfg.trl_def_speed;
+	bfa_trc(bfa, fcport->cfg.trl_def_speed);
+	return fcport->cfg.trl_def_speed;
 
 }
 
 void
-bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status)
+bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, status);
-	bfa_trc(bfa, pport->diag_busy);
+	bfa_trc(bfa, fcport->diag_busy);
 
-	pport->diag_busy = status;
+	fcport->diag_busy = status;
 }
 
 void
-bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+bfa_fcport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
 		 bfa_boolean_t link_e2e_beacon)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	bfa_trc(bfa, beacon);
 	bfa_trc(bfa, link_e2e_beacon);
-	bfa_trc(bfa, pport->beacon);
-	bfa_trc(bfa, pport->link_e2e_beacon);
+	bfa_trc(bfa, fcport->beacon);
+	bfa_trc(bfa, fcport->link_e2e_beacon);
 
-	pport->beacon = beacon;
-	pport->link_e2e_beacon = link_e2e_beacon;
+	fcport->beacon = beacon;
+	fcport->link_e2e_beacon = link_e2e_beacon;
 }
 
 bfa_boolean_t
-bfa_pport_is_linkup(struct bfa_s *bfa)
+bfa_fcport_is_linkup(struct bfa_s *bfa)
 {
-	return bfa_sm_cmp_state(BFA_PORT_MOD(bfa), bfa_pport_sm_linkup);
+	return bfa_sm_cmp_state(BFA_FCPORT_MOD(bfa), bfa_fcport_sm_linkup);
 }
 
 
diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index eeb8c0b..0eba3f9 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -173,7 +173,7 @@ bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
 }
 
 void
-bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
+bfa_msix_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
 	u32 pi, ci;
diff --git a/drivers/scsi/bfa/bfa_module.c b/drivers/scsi/bfa/bfa_module.c
index 32eda8e..a7fcc80 100644
--- a/drivers/scsi/bfa/bfa_module.c
+++ b/drivers/scsi/bfa/bfa_module.c
@@ -24,7 +24,7 @@
  */
 struct bfa_module_s *hal_mods[] = {
 	&hal_mod_sgpg,
-	&hal_mod_pport,
+	&hal_mod_fcport,
 	&hal_mod_fcxp,
 	&hal_mod_lps,
 	&hal_mod_uf,
@@ -45,7 +45,7 @@ bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
 	bfa_isr_unhandled,	/* BFI_MC_DIAG */
 	bfa_isr_unhandled,	/* BFI_MC_FLASH */
 	bfa_isr_unhandled,	/* BFI_MC_CEE */
-	bfa_pport_isr,		/* BFI_MC_PORT */
+	bfa_fcport_isr,		/* BFI_MC_FCPORT */
 	bfa_isr_unhandled,	/* BFI_MC_IOCFC */
 	bfa_isr_unhandled,	/* BFI_MC_LL */
 	bfa_uf_isr,		/* BFI_MC_UF */
diff --git a/drivers/scsi/bfa/bfa_modules_priv.h b/drivers/scsi/bfa/bfa_modules_priv.h
index 96f7053..f554c2f 100644
--- a/drivers/scsi/bfa/bfa_modules_priv.h
+++ b/drivers/scsi/bfa/bfa_modules_priv.h
@@ -29,7 +29,7 @@
 
 
 struct bfa_modules_s {
-	struct bfa_pport_s	pport;	/*  physical port module	*/
+	struct bfa_fcport_s	fcport;	/*  fc port module	*/
 	struct bfa_fcxp_mod_s fcxp_mod; /*  fcxp module		*/
 	struct bfa_lps_mod_s lps_mod;   /*  fcxp module		*/
 	struct bfa_uf_mod_s uf_mod;	/*  unsolicited frame module	*/
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
index f29701b..4c8b99d 100644
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ b/drivers/scsi/bfa/bfa_port_priv.h
@@ -25,17 +25,17 @@
 /**
  * Link notification data structure
  */
-struct bfa_pport_ln_s {
-	struct bfa_pport_s     *pport;
+struct bfa_fcport_ln_s {
+	struct bfa_fcport_s     *fcport;
 	bfa_sm_t                sm;
 	struct bfa_cb_qe_s      ln_qe;  /*  BFA callback queue elem for ln */
 	enum bfa_pport_linkstate ln_event; /*  ln event for callback */
 };
 
 /**
- * BFA physical port data structure
+ * BFA FC port data structure
  */
-struct bfa_pport_s {
+struct bfa_fcport_s {
 	struct bfa_s 		*bfa;	/*  parent BFA instance */
 	bfa_sm_t		sm;	/*  port state machine */
 	wwn_t			nwwn;	/*  node wwn of physical port */
@@ -88,12 +88,17 @@ struct bfa_pport_s {
 					/*  driver callback function */
 	void			*stats_cbarg;
 					/* *!< user callback arg */
+	/* FCport stats */
+	u8         *fcport_stats_kva;
+	u64        fcport_stats_pa;
+	union bfa_fcport_stats_u *fcport_stats;
+	union bfa_fcport_stats_u *fcport_stats_ret;
 };
 
-#define BFA_PORT_MOD(__bfa)	(&(__bfa)->modules.pport)
+#define BFA_FCPORT_MOD(__bfa)	(&(__bfa)->modules.fcport)
 
 /*
  * public functions
  */
-void	bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void	bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 #endif /* __BFA_PORT_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_priv.h b/drivers/scsi/bfa/bfa_priv.h
index 0747a6b..be80fc7 100644
--- a/drivers/scsi/bfa/bfa_priv.h
+++ b/drivers/scsi/bfa/bfa_priv.h
@@ -101,7 +101,7 @@ extern bfa_boolean_t bfa_auto_recover;
 extern struct bfa_module_s hal_mod_flash;
 extern struct bfa_module_s hal_mod_fcdiag;
 extern struct bfa_module_s hal_mod_sgpg;
-extern struct bfa_module_s hal_mod_pport;
+extern struct bfa_module_s hal_mod_fcport;
 extern struct bfa_module_s hal_mod_fcxp;
 extern struct bfa_module_s hal_mod_lps;
 extern struct bfa_module_s hal_mod_uf;
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 73ec190..a8a529d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -664,7 +664,7 @@ bfad_fcs_port_cfg(struct bfad_s *bfad)
 
 	sprintf(symname, "%s-%d", BFAD_DRIVER_NAME, bfad->inst_no);
 	memcpy(port_cfg.sym_name.symname, symname, strlen(symname));
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 	port_cfg.nwwn = attr.nwwn;
 	port_cfg.pwwn = attr.pwwn;
 
@@ -922,7 +922,6 @@ bfad_start_ops(struct bfad_s *bfad)
 		bfad_os_rport_online_wait(bfad);
 	}
 
-	bfad_os_scsi_scan(bfad->pport.im_port);
 	bfa_log(bfad->logmod, BFA_LOG_LINUX_DEVICE_CLAIMED, bfad->pci_name);
 
 	return BFA_STATUS_OK;
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index adf801d..a691133 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -141,7 +141,7 @@ bfad_im_get_host_port_type(struct Scsi_Host *shost)
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
 
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 
 	switch (attr.port_type) {
 	case BFA_PPORT_TYPE_NPORT:
@@ -173,7 +173,7 @@ bfad_im_get_host_port_state(struct Scsi_Host *shost)
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
 
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 
 	switch (attr.port_state) {
 	case BFA_PPORT_ST_LINKDOWN:
@@ -232,7 +232,7 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 	unsigned long   flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	bfa_pport_get_attr(&bfad->bfa, &attr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
 	switch (attr.speed) {
 	case BFA_PPORT_SPEED_8GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f788c2a..23390b4 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -966,7 +966,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 		FC_PORTSPEED_1GBIT;
 
 	memset(&attr.pattr, 0, sizeof(attr.pattr));
-	bfa_pport_get_attr(&bfad->bfa, &attr.pattr);
+	bfa_fcport_get_attr(&bfad->bfa, &attr.pattr);
 	fc_host_maxframe_size(host) = attr.pattr.pport_cfg.maxfrsize;
 }
 
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index 37bf8ac..e1a4b31 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -37,7 +37,7 @@ BFA_TRC_FILE(FCS, FABRIC);
 #define BFA_FCS_FABRIC_CLEANUP_DELAY	(10000)	/* Milliseconds */
 
 #define bfa_fcs_fabric_set_opertype(__fabric) do {             \
-	if (bfa_pport_get_topology((__fabric)->fcs->bfa)       \
+	if (bfa_fcport_get_topology((__fabric)->fcs->bfa)       \
 				== BFA_PPORT_TOPOLOGY_P2P)     \
 		(__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;  \
 	else                                                   \
@@ -160,7 +160,7 @@ bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
 
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_START:
-		if (bfa_pport_is_linkup(fabric->fcs->bfa)) {
+		if (bfa_fcport_is_linkup(fabric->fcs->bfa)) {
 			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi);
 			bfa_fcs_fabric_login(fabric);
 		} else
@@ -224,7 +224,7 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_CONT_OP:
 
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
 		fabric->fab_type = BFA_FCS_FABRIC_SWITCHED;
 
 		if (fabric->auth_reqd && fabric->is_auth) {
@@ -251,7 +251,7 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_NO_FABRIC:
 		fabric->fab_type = BFA_FCS_FABRIC_N2N;
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
 		bfa_fcs_fabric_notify_online(fabric);
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_nofabric);
 		break;
@@ -418,7 +418,7 @@ bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_NO_FABRIC:
 		bfa_trc(fabric->fcs, fabric->bb_credit);
-		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
 		break;
 
 	default:
@@ -718,10 +718,10 @@ bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric)
 	struct bfa_port_cfg_s *pcfg = &fabric->bport.port_cfg;
 	u8         alpa = 0;
 
-	if (bfa_pport_get_topology(bfa) == BFA_PPORT_TOPOLOGY_LOOP)
-		alpa = bfa_pport_get_myalpa(bfa);
+	if (bfa_fcport_get_topology(bfa) == BFA_PPORT_TOPOLOGY_LOOP)
+		alpa = bfa_fcport_get_myalpa(bfa);
 
-	bfa_lps_flogi(fabric->lps, fabric, alpa, bfa_pport_get_maxfrsize(bfa),
+	bfa_lps_flogi(fabric->lps, fabric, alpa, bfa_fcport_get_maxfrsize(bfa),
 		      pcfg->pwwn, pcfg->nwwn, fabric->auth_reqd);
 
 	fabric->stats.flogi_sent++;
@@ -846,7 +846,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 void
 bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 {
-	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CREATE);
+	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
 	bfa_trc(fcs, 0);
 }
 
@@ -1176,8 +1176,8 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 	reqlen = fc_flogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 				    bfa_os_hton3b(FC_FABRIC_PORT),
 				    n2n_port->reply_oxid, pcfg->pwwn,
-				    pcfg->nwwn, bfa_pport_get_maxfrsize(bfa),
-				    bfa_pport_get_rx_bbcredit(bfa));
+				    pcfg->nwwn, bfa_fcport_get_maxfrsize(bfa),
+				    bfa_fcport_get_rx_bbcredit(bfa));
 
 	bfa_fcxp_send(fcxp, NULL, fabric->vf_id, bfa_lps_get_tag(fabric->lps),
 			BFA_FALSE, FC_CLASS_3, reqlen, &fchs,
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index 10dadf7..2c9e713 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -117,7 +117,7 @@ static void     bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 static void     bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
 			enum port_fdmi_event event);
 static void	bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
-			port_fdmi_event_t event);
+			enum port_fdmi_event event);
 
 /**
  * 		Start in offline state - awaiting MS to send start.
@@ -487,7 +487,7 @@ bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
  */
 static void
 bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
-				port_fdmi_event_t event)
+				enum port_fdmi_event event)
 {
 	struct bfa_fcs_port_s *port = fdmi->ms->port;
 
@@ -1175,7 +1175,7 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
 	/*
 	 * get pport attributes from hal
 	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 
 	/*
 	 * get FC4 type Bitmask
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 71ffb75..056cf20 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -26,6 +26,7 @@ struct bfa_fcxp_s;
 #include <defs/bfa_defs_pport.h>
 #include <defs/bfa_defs_rport.h>
 #include <defs/bfa_defs_qos.h>
+#include <defs/bfa_defs_fcport.h> 
 #include <cs/bfa_sm.h>
 #include <bfa.h>
 
@@ -151,60 +152,67 @@ struct bfa_lps_s {
 	bfa_eproto_status_t	ext_status;
 };
 
+#define BFA_FCPORT(_bfa)        (&((_bfa)->modules.port))
+
 /*
  * bfa pport API functions
  */
-bfa_status_t bfa_pport_enable(struct bfa_s *bfa);
-bfa_status_t bfa_pport_disable(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_speed(struct bfa_s *bfa,
+bfa_status_t bfa_fcport_enable(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_disable(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_speed(struct bfa_s *bfa,
 			enum bfa_pport_speed speed);
-enum bfa_pport_speed bfa_pport_get_speed(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_topology(struct bfa_s *bfa,
+enum bfa_pport_speed bfa_fcport_get_speed(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_topology(struct bfa_s *bfa,
 			enum bfa_pport_topology topo);
-enum bfa_pport_topology bfa_pport_get_topology(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
-bfa_boolean_t bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
-u8 bfa_pport_get_myalpa(struct bfa_s *bfa);
-bfa_status_t bfa_pport_clr_hardalpa(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
-u16 bfa_pport_get_maxfrsize(struct bfa_s *bfa);
-u32 bfa_pport_mypid(struct bfa_s *bfa);
-u8 bfa_pport_get_rx_bbcredit(struct bfa_s *bfa);
-bfa_status_t bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
-bfa_status_t bfa_pport_trunk_disable(struct bfa_s *bfa);
-bfa_boolean_t bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
-void bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
-wwn_t bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
+enum bfa_pport_topology bfa_fcport_get_topology(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
+bfa_boolean_t bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
+u8 bfa_fcport_get_myalpa(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_clr_hardalpa(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
+u16 bfa_fcport_get_maxfrsize(struct bfa_s *bfa);
+u32 bfa_fcport_mypid(struct bfa_s *bfa);
+u8 bfa_fcport_get_rx_bbcredit(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
+bfa_status_t bfa_fcport_trunk_disable(struct bfa_s *bfa);
+bfa_boolean_t bfa_fcport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
+void bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
+wwn_t bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
 bfa_status_t bfa_pport_get_stats(struct bfa_s *bfa,
 			union bfa_pport_stats_u *stats,
 			bfa_cb_pport_t cbfn, void *cbarg);
 bfa_status_t bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
 			void *cbarg);
-void bfa_pport_event_register(struct bfa_s *bfa,
+void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			bfa_pport_event_t event), void *event_cbarg);
-bfa_boolean_t bfa_pport_is_disabled(struct bfa_s *bfa);
-void bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
-void bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
-bfa_status_t bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa,
+bfa_boolean_t bfa_fcport_is_disabled(struct bfa_s *bfa);
+void bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
+void bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
+bfa_status_t bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa,
 			enum bfa_pport_speed speed);
-enum bfa_pport_speed bfa_pport_get_ratelim_speed(struct bfa_s *bfa);
+enum bfa_pport_speed bfa_fcport_get_ratelim_speed(struct bfa_s *bfa);
 
-void bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
-void bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status);
-void bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+void bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
+void bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status);
+void bfa_fcport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
 			bfa_boolean_t link_e2e_beacon);
 void bfa_cb_pport_event(void *cbarg, bfa_pport_event_t event);
-void bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
-void bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+void bfa_fcport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
+void bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 			struct bfa_qos_vc_attr_s *qos_vc_attr);
-bfa_status_t bfa_pport_get_qos_stats(struct bfa_s *bfa,
+bfa_status_t bfa_fcport_get_qos_stats(struct bfa_s *bfa,
 			union bfa_pport_stats_u *stats,
 			bfa_cb_pport_t cbfn, void *cbarg);
-bfa_status_t bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+bfa_status_t bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
 			void *cbarg);
-bfa_boolean_t     bfa_pport_is_ratelim(struct bfa_s *bfa);
-bfa_boolean_t	bfa_pport_is_linkup(struct bfa_s *bfa);
+bfa_boolean_t     bfa_fcport_is_ratelim(struct bfa_s *bfa);
+bfa_boolean_t	bfa_fcport_is_linkup(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
+		union bfa_fcport_stats_u *stats,
+		bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+		void *cbarg);
 
 /*
  * bfa rport API functions
diff --git a/drivers/scsi/bfa/include/bfi/bfi_pport.h b/drivers/scsi/bfa/include/bfi/bfi_pport.h
index c96d246..5c3d289 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_pport.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_pport.h
@@ -32,6 +32,8 @@ enum bfi_pport_h2i {
 	BFI_PPORT_H2I_ENABLE_TX_VF_TAG_REQ	= (7),
 	BFI_PPORT_H2I_GET_QOS_STATS_REQ		= (8),
 	BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ	= (9),
+	BFI_FCPORT_H2I_GET_STATS_REQ            = (10),
+	BFI_FCPORT_H2I_CLEAR_STATS_REQ          = (11),
 };
 
 enum bfi_pport_i2h {
@@ -45,6 +47,8 @@ enum bfi_pport_i2h {
 	BFI_PPORT_I2H_EVENT			= BFA_I2HM(8),
 	BFI_PPORT_I2H_GET_QOS_STATS_RSP		= BFA_I2HM(9),
 	BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP	= BFA_I2HM(10),
+	BFI_FCPORT_I2H_GET_STATS_RSP            = BFA_I2HM(11),
+	BFI_FCPORT_I2H_CLEAR_STATS_RSP          = BFA_I2HM(12),
 };
 
 /**
@@ -75,6 +79,7 @@ struct bfi_pport_enable_req_s {
 	wwn_t           pwwn;		/*  port wwn of physical port	    */
 	struct bfa_pport_cfg_s port_cfg;	/*  port configuration	    */
 	union bfi_addr_u  stats_dma_addr;	/*  DMA address for stats  */
+	union bfi_addr_u  fcport_stats_dma_addr;/*!< DMA address for stats  */
 	u32        msgtag;		/*  msgtag for reply		    */
 	u32        rsvd2;
 };
diff --git a/drivers/scsi/bfa/include/cs/bfa_plog.h b/drivers/scsi/bfa/include/cs/bfa_plog.h
index 670f86e..3a90b40 100644
--- a/drivers/scsi/bfa/include/cs/bfa_plog.h
+++ b/drivers/scsi/bfa/include/cs/bfa_plog.h
@@ -80,7 +80,8 @@ enum bfa_plog_mid {
 	BFA_PL_MID_HAL_FCXP 	= 4,
 	BFA_PL_MID_HAL_UF 	= 5,
 	BFA_PL_MID_FCS 		= 6,
-	BFA_PL_MID_MAX 		= 7
+	BFA_PL_MID_LPS		= 7,
+	BFA_PL_MID_MAX 		= 8
 };
 
 #define BFA_PL_MID_STRLEN    8
@@ -118,7 +119,11 @@ enum bfa_plog_eid {
 	BFA_PL_EID_RSCN 		= 17,
 	BFA_PL_EID_DEBUG 		= 18,
 	BFA_PL_EID_MISC 		= 19,
-	BFA_PL_EID_MAX 			= 20
+	BFA_PL_EID_FIP_FCF_DISC		= 20,
+	BFA_PL_EID_FIP_FCF_CVL		= 21,
+	BFA_PL_EID_LOGIN		= 22,
+	BFA_PL_EID_LOGO			= 23,
+	BFA_PL_EID_MAX 			= 24
 };
 
 #define BFA_PL_ENAME_STRLEN    	8
diff --git a/drivers/scsi/bfa/include/cs/bfa_sm.h b/drivers/scsi/bfa/include/cs/bfa_sm.h
index b0a92ba..11fba90 100644
--- a/drivers/scsi/bfa/include/cs/bfa_sm.h
+++ b/drivers/scsi/bfa/include/cs/bfa_sm.h
@@ -23,6 +23,14 @@
 #define __BFA_SM_H__
 
 typedef void (*bfa_sm_t)(void *sm, int event);
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_sm_state_decl(oc, st, otype, etype)         \
+	static void oc ## _sm_ ## st(otype * fsm, etype event)
 
 #define bfa_sm_set_state(_sm, _state)	((_sm)->sm = (bfa_sm_t)(_state))
 #define bfa_sm_send_event(_sm, _event)	((_sm)->sm((_sm), (_event)))
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h b/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
index 79f9b3e..b4fa092 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
@@ -19,6 +19,7 @@
 #define __BFA_DEFS_ETHPORT_H__
 
 #include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
 #include <protocol/types.h>
 #include <cna/pstats/phyport_defs.h>
 #include <cna/pstats/ethport_defs.h>
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
index 87f0401..c290fb1 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
@@ -236,6 +236,7 @@ struct bfa_fw_fip_stats_s {
     u32    disc_err;           /*  Discovery advt. parse errors        */
     u32    disc_unsol;         /*  Discovery unsolicited               */
     u32    disc_timeouts;      /*  Discovery timeouts                  */
+    u32    disc_fcf_unavail;   /*  Discovery FCF Not Avail.            */
     u32    linksvc_unsupp;     /*  Unsupported link service req        */
     u32    linksvc_err;        /*  Parse error in link service req     */
     u32    logo_req;           /*  Number of FIP logos received        */
diff --git a/drivers/scsi/bfa/loop.c b/drivers/scsi/bfa/loop.c
index f7c7f4f..f6342ef 100644
--- a/drivers/scsi/bfa/loop.c
+++ b/drivers/scsi/bfa/loop.c
@@ -162,7 +162,7 @@ bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port, u8 alpa)
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len, &fchs,
diff --git a/drivers/scsi/bfa/lport_api.c b/drivers/scsi/bfa/lport_api.c
index 4a4ccce..d3907d1 100644
--- a/drivers/scsi/bfa/lport_api.c
+++ b/drivers/scsi/bfa/lport_api.c
@@ -156,7 +156,7 @@ bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
 	/*
 	 * Get Physical port's current speed
 	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 	pport_speed = pport_attr.speed;
 	bfa_trc(fcs, pport_speed);
 
diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index f0275a4..e6db5fd 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -637,7 +637,7 @@ bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			     bfa_os_hton3b(FC_MGMT_SERVER),
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+			     bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_plogi_response,
diff --git a/drivers/scsi/bfa/ns.c b/drivers/scsi/bfa/ns.c
index 6de06a5..d20dd7e 100644
--- a/drivers/scsi/bfa/ns.c
+++ b/drivers/scsi/bfa/ns.c
@@ -660,7 +660,7 @@ bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 			     bfa_os_hton3b(FC_NAME_SERVER),
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+			     bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_plogi_response,
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index d7fc97a..b2184a3 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -1373,7 +1373,7 @@ bfa_fcs_rport_send_plogi(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
 			     bfa_fcs_port_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
-			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+			     bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_plogi_response,
@@ -1485,7 +1485,7 @@ bfa_fcs_rport_send_plogiacc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
 				 bfa_fcs_port_get_fcid(port), rport->reply_oxid,
 				 port->port_cfg.pwwn, port->port_cfg.nwwn,
-				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
@@ -1820,7 +1820,7 @@ bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
 	/*
 	 * get curent speed from pport attributes from BFA
 	 */
-	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 
 	speeds.port_op_speed = fc_bfa_speed_to_rpsc_operspeed(pport_attr.speed);
 
@@ -2171,7 +2171,7 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 		bfa_trc(port->fcs, port->fabric->bb_credit);
 
 		port->fabric->bb_credit = bfa_os_ntohs(plogi->csp.bbcred);
-		bfa_pport_set_tx_bbcredit(port->fcs->bfa,
+		bfa_fcport_set_tx_bbcredit(port->fcs->bfa,
 					  port->fabric->bb_credit);
 	}
 
diff --git a/drivers/scsi/bfa/rport_api.c b/drivers/scsi/bfa/rport_api.c
index 3dae177..a441f41 100644
--- a/drivers/scsi/bfa/rport_api.c
+++ b/drivers/scsi/bfa/rport_api.c
@@ -102,7 +102,7 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 	rport_attr->qos_attr = qos_attr;
 
 	rport_attr->trl_enforced = BFA_FALSE;
-	if (bfa_pport_is_ratelim(port->fcs->bfa)) {
+	if (bfa_fcport_is_ratelim(port->fcs->bfa)) {
 		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_UNKNOWN) ||
 			(rport->rpf.rpsc_speed <
 			bfa_fcs_port_get_rport_max_speed(port)))
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 14fb7ac..c5e534e 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -478,7 +478,7 @@ static void
 bfa_fcs_vport_do_fdisc(struct bfa_fcs_vport_s *vport)
 {
 	bfa_lps_fdisc(vport->lps, vport,
-		      bfa_pport_get_maxfrsize(__vport_bfa(vport)),
+		      bfa_fcport_get_maxfrsize(__vport_bfa(vport)),
 		      __vport_pwwn(vport), __vport_nwwn(vport));
 	vport->vport_stats.fdisc_sent++;
 }
-- 
1.6.5.3

