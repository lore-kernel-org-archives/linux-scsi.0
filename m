From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/8] bfa: bfa changes part 1
Date: Sun, 29 Nov 2009 17:39:15 -0800
Message-ID: <1259545155-4550-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:30855 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZK3BjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:39:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Changes to bfa part 1:
 - Changes related to fcport renaming. 
 - Modified the portstats get/clear logic.
 - Added new portlog entries for FIP events.
 - Fixed IOC type and mode when FCOE chip is operating in FC mode.
 - Changes to remove ioc_attr local variable from stack.
 - Misc style and formatting changes.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c | 1831 +++++++++++++++++++++++------------------
 drivers/scsi/bfa/bfa_ioc.c    | 1073 +++++++++---------------
 2 files changed, 1412 insertions(+), 1492 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index aef648b..286bcbf 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -23,40 +23,33 @@
 #include <cs/bfa_plog.h>
 #include <aen/bfa_aen_port.h>
 
-BFA_TRC_FILE(HAL, PPORT);
-BFA_MODULE(pport);
-
-#define bfa_pport_callback(__pport, __event) do {			\
-	if ((__pport)->bfa->fcs) {      \
-		(__pport)->event_cbfn((__pport)->event_cbarg, (__event));      \
-	} else {							\
-		(__pport)->hcb_event = (__event);      \
-		bfa_cb_queue((__pport)->bfa, &(__pport)->hcb_qe,	\
-		__bfa_cb_port_event, (__pport));      \
-	}								\
-} while (0)
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
-static void     __bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete);
-static void     __bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete);
-static void     bfa_port_stats_timeout(void *cbarg);
-static void     bfa_port_stats_clr_timeout(void *cbarg);
+static bfa_boolean_t bfa_fcport_send_enable(struct bfa_fcport_s *fcport);
+static bfa_boolean_t bfa_fcport_send_disable(struct bfa_fcport_s *fcport);
+static void	bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport);
+static void	bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport);
+static void	bfa_fcport_set_wwns(struct bfa_fcport_s *fcport);
+static void	__bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete);
+static void	bfa_fcport_callback(struct bfa_fcport_s *fcport,
+				enum bfa_pport_linkstate event);
+static void	bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln,
+				enum bfa_pport_linkstate event);
+static void	__bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete);
+static void	bfa_fcport_stats_get_timeout(void *cbarg);
+static void	bfa_fcport_stats_clr_timeout(void *cbarg);
 
 /**
  *  bfa_pport_private
@@ -65,111 +58,115 @@ static void     bfa_port_stats_clr_timeout(void *cbarg);
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
+	BFA_FCPORT_SM_START	= 1,	/*  start port state machine	*/
+	BFA_FCPORT_SM_STOP	= 2,	/*  stop port state machine	*/
+	BFA_FCPORT_SM_ENABLE	= 3,	/*  enable port		*/
+	BFA_FCPORT_SM_DISABLE	= 4,	/*  disable port state machine */
+	BFA_FCPORT_SM_FWRSP	= 5,	/*  firmware enable/disable rsp */
+	BFA_FCPORT_SM_LINKUP	= 6,	/*  firmware linkup event	*/
+	BFA_FCPORT_SM_LINKDOWN	= 7,	/*  firmware linkup down	*/
+	BFA_FCPORT_SM_QRESUME	= 8,	/*  CQ space available	*/
+	BFA_FCPORT_SM_HWFAIL	= 9,	/*  IOC h/w failure		*/
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
+/**
+ * BFA port link notification state machine events
+ */
+
+enum bfa_fcport_ln_sm_event {
+	BFA_FCPORT_LN_SM_LINKUP		= 1,	/*  linkup event */
+	BFA_FCPORT_LN_SM_LINKDOWN	= 2,	/*  linkdown event */
+	BFA_FCPORT_LN_SM_NOTIFICATION	= 3	/*  done notification */
+};
+
+static void	bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
+					enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_disabling_qwait(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_stopped(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_iocdown(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+static void	bfa_fcport_sm_iocfail(struct bfa_fcport_s *fcport,
+					 enum bfa_fcport_sm_event event);
+
+static void	bfa_fcport_ln_sm_dn(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_dn_nf(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_dn_up_nf(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_up(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_up_nf(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_up_dn_nf(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
+static void	bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
+					enum bfa_fcport_ln_sm_event event);
 
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
-	char            pwwn_ptr[BFA_STRING_32];
-	struct bfa_ioc_attr_s ioc_attr;
+	struct bfa_log_mod_s *logmod = fcport->bfa->logm;
+	wwn_t pwwn = fcport->pwwn;
+	char pwwn_ptr[BFA_STRING_32];
 
+	memset(&aen_data, 0, sizeof(aen_data));
 	wwn2str(pwwn_ptr, pwwn);
-	switch (event) {
-	case BFA_PORT_AEN_ONLINE:
-		bfa_log(logmod, BFA_AEN_PORT_ONLINE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_OFFLINE:
-		bfa_log(logmod, BFA_AEN_PORT_OFFLINE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_ENABLE:
-		bfa_log(logmod, BFA_AEN_PORT_ENABLE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_DISABLE:
-		bfa_log(logmod, BFA_AEN_PORT_DISABLE, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_DISCONNECT:
-		bfa_log(logmod, BFA_AEN_PORT_DISCONNECT, pwwn_ptr);
-		break;
-	case BFA_PORT_AEN_QOS_NEG:
-		bfa_log(logmod, BFA_AEN_PORT_QOS_NEG, pwwn_ptr);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, event), pwwn_ptr);
 
-	bfa_ioc_get_attr(&pport->bfa->ioc, &ioc_attr);
-	aen_data.port.ioc_type = ioc_attr.ioc_type;
-	aen_data.port.pwwn = pwwn;
+	aen_data.port.ioc_type = bfa_get_type(fcport->bfa);
+	aen_data.port.pwwn = pwwn;	/* Assert on FC/FCoE type? */
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_enabling_qwait);
 		break;
 
-	case BFA_PPORT_SM_ENABLE:
+	case BFA_FCPORT_SM_ENABLE:
 		/**
 		 * Port is persistently configured to be in enabled state. Do
 		 * not change state. Port enabling is done when START event is
@@ -177,389 +174,418 @@ bfa_pport_sm_uninit(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
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
+				enum bfa_fcport_sm_event event)
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
-			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_disabled);
+		bfa_reqq_wcancel(&fcport->reqq_wait);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
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
+bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event)
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_disabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
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
+bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
+						enum bfa_fcport_sm_event event)
 {
-	bfa_trc(pport->bfa, event);
+	struct bfi_fcport_event_s *pevent = fcport->event_arg.i2hmsg.event;
+
+	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
-	case BFA_PPORT_SM_LINKUP:
-		bfa_pport_update_linkinfo(pport);
-		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
-		bfa_assert(pport->event_cbfn);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
-		bfa_pport_callback(pport, BFA_PPORT_LINKUP);
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ONLINE);
+	case BFA_FCPORT_SM_LINKUP:
+		bfa_fcport_update_linkinfo(fcport);
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkup);
+		bfa_assert(fcport->event_cbfn);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
+		if (!bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
+
+			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipenabled);
+			bfa_trc(fcport->bfa, pevent->link_state.fcf.fipfailed);
+
+			if (pevent->link_state.fcf.fipfailed)
+				bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+					BFA_PL_EID_FIP_FCF_DISC, 0,
+					"FIP FCF Discovery Failed");
+			else
+				bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+					BFA_PL_EID_FIP_FCF_DISC, 0,
+					"FIP FCF Discovered");
+		}
+
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKUP);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_ONLINE);
 		/**
 		 * If QoS is enabled and it is not online,
 		 * Send a separate event.
 		 */
-		if ((pport->cfg.qos_enabled)
-		    && (bfa_os_ntohl(pport->qos_attr.state) != BFA_QOS_ONLINE))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_QOS_NEG);
+		if ((fcport->cfg.qos_enabled) &&
+		    (bfa_os_ntohl(fcport->qos_attr.state) != BFA_QOS_ONLINE))
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_disabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
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
+bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
+	enum bfa_fcport_sm_event event)
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
-
-		bfa_pport_reset_linkinfo(pport);
-		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
-		break;
-
-	case BFA_PPORT_SM_LINKDOWN:
-		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
-		bfa_pport_reset_linkinfo(pport);
-		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
-		if (BFA_PORT_IS_DISABLED(pport->bfa))
-			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_disabling_qwait);
+
+		bfa_fcport_reset_linkinfo(fcport);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_OFFLINE);
+		bfa_fcport_aen_post(fcport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_FCPORT_SM_LINKDOWN:
+		bfa_sm_set_state(fcport, bfa_fcport_sm_linkdown);
+		bfa_fcport_reset_linkinfo(fcport);
+		bfa_fcport_callback(fcport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
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
+				 enum bfa_fcport_sm_event event)
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
+						enum bfa_fcport_sm_event event)
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_enabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
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
+						enum bfa_fcport_sm_event event)
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_enabling_qwait);
 
-		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
-			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
-		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
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
+			 enum bfa_fcport_sm_event event)
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_enabling_qwait);
 		break;
 
 	default:
@@ -574,16 +600,18 @@ bfa_pport_sm_stopped(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  * Port is enabled. IOC is down/failed.
  */
 static void
-bfa_pport_sm_iocdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_iocdown(struct bfa_fcport_s *fcport,
+			 enum bfa_fcport_sm_event event)
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
+			bfa_sm_set_state(fcport,
+					 bfa_fcport_sm_enabling_qwait);
 		break;
 
 	default:
@@ -598,17 +626,18 @@ bfa_pport_sm_iocdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  * Port is disabled. IOC is down/failed.
  */
 static void
-bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+bfa_fcport_sm_iocfail(struct bfa_fcport_s *fcport,
+			 enum bfa_fcport_sm_event event)
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
@@ -619,6 +648,164 @@ bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
 	}
 }
 
+/**
+ * Link state is down
+ */
+static void
+bfa_fcport_ln_sm_dn(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKUP);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is waiting for down notification
+ */
+static void
+bfa_fcport_ln_sm_dn_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_up_nf);
+		break;
+
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is waiting for down notification and there is a pending up
+ */
+static void
+bfa_fcport_ln_sm_dn_up_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
+		break;
+
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKUP);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is up
+ */
+static void
+bfa_fcport_ln_sm_up(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is waiting for up notification
+ */
+static void
+bfa_fcport_ln_sm_up_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_nf);
+		break;
+
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is waiting for up notification and there is a pending down
+ */
+static void
+bfa_fcport_ln_sm_up_dn_nf(struct bfa_fcport_ln_s *ln,
+		enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKUP:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_up_nf);
+		break;
+
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
+/**
+ * Link state is waiting for up notification and there are pending down and up
+ */
+static void
+bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
+			enum bfa_fcport_ln_sm_event event)
+{
+	bfa_trc(ln->fcport->bfa, event);
+
+	switch (event) {
+	case BFA_FCPORT_LN_SM_LINKDOWN:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_up_dn_nf);
+		break;
+
+	case BFA_FCPORT_LN_SM_NOTIFICATION:
+		bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn_up_nf);
+		bfa_fcport_queue_cb(ln, BFA_PPORT_LINKDOWN);
+		break;
+
+	default:
+		bfa_sm_fault(ln->fcport->bfa, event);
+	}
+}
+
 
 
 /**
@@ -626,47 +813,76 @@ bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
  */
 
 static void
-__bfa_cb_port_event(void *cbarg, bfa_boolean_t complete)
+__bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete)
 {
-	struct bfa_pport_s *pport = cbarg;
+	struct bfa_fcport_ln_s *ln = cbarg;
 
 	if (complete)
-		pport->event_cbfn(pport->event_cbarg, pport->hcb_event);
+		ln->fcport->event_cbfn(ln->fcport->event_cbarg, ln->ln_event);
+	else
+		bfa_sm_send_event(ln, BFA_FCPORT_LN_SM_NOTIFICATION);
+}
+
+static void
+bfa_fcport_callback(struct bfa_fcport_s *fcport, enum bfa_pport_linkstate event)
+{
+	if (fcport->bfa->fcs) {
+		fcport->event_cbfn(fcport->event_cbarg, event);
+		return;
+	}
+
+	switch (event) {
+	case BFA_PPORT_LINKUP:
+		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKUP);
+		break;
+	case BFA_PPORT_LINKDOWN:
+		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKDOWN);
+		break;
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln, enum bfa_pport_linkstate event)
+{
+	ln->ln_event = event;
+	bfa_cb_queue(ln->fcport->bfa, &ln->ln_qe, __bfa_cb_fcport_event, ln);
 }
 
-#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_pport_stats_u), \
+#define FCPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
 							BFA_CACHELINE_SZ))
 
 static void
-bfa_pport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
-		  u32 *dm_len)
+bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		u32 *dm_len)
 {
-	*dm_len += PPORT_STATS_DMA_SZ;
+	*dm_len += FCPORT_STATS_DMA_SZ;
 }
 
 static void
-bfa_pport_qresume(void *cbarg)
+bfa_fcport_qresume(void *cbarg)
 {
-	struct bfa_pport_s *port = cbarg;
+	struct bfa_fcport_s *fcport = cbarg;
 
-	bfa_sm_send_event(port, BFA_PPORT_SM_QRESUME);
+	bfa_sm_send_event(fcport, BFA_FCPORT_SM_QRESUME);
 }
 
 static void
-bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
+bfa_fcport_mem_claim(struct bfa_fcport_s *fcport, struct bfa_meminfo_s *meminfo)
 {
-	u8        *dm_kva;
-	u64        dm_pa;
+	u8		*dm_kva;
+	u64	dm_pa;
 
 	dm_kva = bfa_meminfo_dma_virt(meminfo);
-	dm_pa = bfa_meminfo_dma_phys(meminfo);
+	dm_pa  = bfa_meminfo_dma_phys(meminfo);
 
-	pport->stats_kva = dm_kva;
-	pport->stats_pa = dm_pa;
-	pport->stats = (union bfa_pport_stats_u *)dm_kva;
+	fcport->stats_kva = dm_kva;
+	fcport->stats_pa  = dm_pa;
+	fcport->stats	  = (union bfa_fcport_stats_u *) dm_kva;
 
-	dm_kva += PPORT_STATS_DMA_SZ;
-	dm_pa += PPORT_STATS_DMA_SZ;
+	dm_kva += FCPORT_STATS_DMA_SZ;
+	dm_pa  += FCPORT_STATS_DMA_SZ;
 
 	bfa_meminfo_dma_virt(meminfo) = dm_kva;
 	bfa_meminfo_dma_phys(meminfo) = dm_pa;
@@ -676,18 +892,21 @@ bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
  * Memory initialization.
  */
 static void
-bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		 struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
-	struct bfa_pport_cfg_s *port_cfg = &pport->cfg;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_pport_cfg_s *port_cfg = &fcport->cfg;
+	struct bfa_fcport_ln_s *ln = &fcport->ln;
 
-	bfa_os_memset(pport, 0, sizeof(struct bfa_pport_s));
-	pport->bfa = bfa;
+	bfa_os_memset(fcport, 0, sizeof(struct bfa_fcport_s));
+	fcport->bfa = bfa;
+	ln->fcport = fcport;
 
-	bfa_pport_mem_claim(pport, meminfo);
+	bfa_fcport_mem_claim(fcport, meminfo);
 
-	bfa_sm_set_state(pport, bfa_pport_sm_uninit);
+	bfa_sm_set_state(fcport, bfa_fcport_sm_uninit);
+	bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
 
 	/**
 	 * initialize and set default configuration
@@ -699,30 +918,30 @@ bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
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
 
@@ -730,167 +949,321 @@ bfa_pport_detach(struct bfa_s *bfa)
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
+	struct bfi_fcport_event_s *pevent = fcport->event_arg.i2hmsg.event;
 
-	pport->speed = pevent->link_state.speed;
-	pport->topology = pevent->link_state.topology;
+	fcport->speed = pevent->link_state.speed;
+	fcport->topology = pevent->link_state.topology;
 
-	if (pport->topology == BFA_PPORT_TOPOLOGY_LOOP)
-		pport->myalpa = pevent->link_state.tl.loop_info.myalpa;
+	if (fcport->topology == BFA_PPORT_TOPOLOGY_LOOP)
+		fcport->myalpa =
+			pevent->link_state.tl.loop_info.myalpa;
 
-	/*
-	 * QoS Details
-	 */
-	bfa_os_assign(pport->qos_attr, pevent->link_state.qos_attr);
-	bfa_os_assign(pport->qos_vc_attr, pevent->link_state.qos_vc_attr);
+	/* QoS Details */
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
-static          bfa_boolean_t
-bfa_pport_send_enable(struct bfa_pport_s *port)
+static bfa_boolean_t
+bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 {
-	struct bfi_pport_enable_req_s *m;
+	struct bfi_fcport_enable_req_s *m;
 
 	/**
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
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_ENABLE_REQ,
-		    bfa_lpuid(port->bfa));
-	m->nwwn = port->nwwn;
-	m->pwwn = port->pwwn;
-	m->port_cfg = port->cfg;
-	m->msgtag = port->msgtag;
-	m->port_cfg.maxfrsize = bfa_os_htons(port->cfg.maxfrsize);
-	bfa_dma_be_addr_set(m->stats_dma_addr, port->stats_pa);
-	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_lo);
-	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_hi);
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_ENABLE_REQ,
+			bfa_lpuid(fcport->bfa));
+	m->nwwn = fcport->nwwn;
+	m->pwwn = fcport->pwwn;
+	m->port_cfg = fcport->cfg;
+	m->msgtag = fcport->msgtag;
+	m->port_cfg.maxfrsize = bfa_os_htons(fcport->cfg.maxfrsize);
+	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
+	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
+	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
 
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 	return BFA_TRUE;
 }
 
 /**
  * Send port disable message to firmware.
  */
-static          bfa_boolean_t
-bfa_pport_send_disable(struct bfa_pport_s *port)
+static	bfa_boolean_t
+bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 {
-	bfi_pport_disable_req_t *m;
+	struct bfi_fcport_req_s *m;
 
 	/**
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
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_DISABLE_REQ,
-		    bfa_lpuid(port->bfa));
-	m->msgtag = port->msgtag;
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_DISABLE_REQ,
+			bfa_lpuid(fcport->bfa));
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
-	struct bfi_pport_set_svc_params_req_s *m;
+	struct bfa_fcport_s *fcport = port_cbarg;
+	struct bfi_fcport_set_svc_params_req_s *m;
 
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
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_SET_SVC_PARAMS_REQ,
-		    bfa_lpuid(port->bfa));
-	m->tx_bbcredit = bfa_os_htons((u16) port->cfg.tx_bbcredit);
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ,
+			bfa_lpuid(fcport->bfa));
+	m->tx_bbcredit = bfa_os_htons((u16)fcport->cfg.tx_bbcredit);
 
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
+}
+
+static void
+bfa_fcport_qos_stats_swap(struct bfa_qos_stats_s *d,
+	struct bfa_qos_stats_s *s)
+{
+	u32	*dip = (u32 *) d;
+	u32	*sip = (u32 *) s;
+	int		i;
+
+	/* Now swap the 32 bit fields */
+	for (i = 0; i < (sizeof(struct bfa_qos_stats_s)/sizeof(u32)); ++i)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+bfa_fcport_fcoe_stats_swap(struct bfa_fcoe_stats_s *d,
+	struct bfa_fcoe_stats_s *s)
+{
+	u32	*dip = (u32 *) d;
+	u32	*sip = (u32 *) s;
+	int		i;
+
+	for (i = 0; i < ((sizeof(struct bfa_fcoe_stats_s))/sizeof(u32));
+	     i = i + 2) {
+#ifdef __BIGENDIAN
+		dip[i] = bfa_os_ntohl(sip[i]);
+		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
+#else
+		dip[i] = bfa_os_ntohl(sip[i + 1]);
+		dip[i + 1] = bfa_os_ntohl(sip[i]);
+#endif
+	}
+}
+
+static void
+__bfa_cb_fcport_stats_get(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_fcport_s *fcport = cbarg;
+
+	if (complete) {
+		if (fcport->stats_status == BFA_STATUS_OK) {
+
+			/* Swap FC QoS or FCoE stats */
+			if (bfa_ioc_get_fcmode(&fcport->bfa->ioc))
+				bfa_fcport_qos_stats_swap(
+					&fcport->stats_ret->fcqos,
+					&fcport->stats->fcqos);
+			else
+				bfa_fcport_fcoe_stats_swap(
+					&fcport->stats_ret->fcoe,
+					&fcport->stats->fcoe);
+		}
+		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
+	} else {
+		fcport->stats_busy = BFA_FALSE;
+		fcport->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_fcport_stats_get_timeout(void *cbarg)
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
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_fcport_stats_get,
+		fcport);
+}
+
+static void
+bfa_fcport_send_stats_get(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
+	struct bfi_fcport_req_s *msg;
+
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait,
+				bfa_fcport_send_stats_get, fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+				&fcport->stats_reqq_wait);
+		return;
+	}
+	fcport->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(struct bfi_fcport_req_s));
+	bfi_h2i_set(msg->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_STATS_GET_REQ,
+			bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
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
+	}
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
+	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+			__bfa_cb_fcport_stats_clr, fcport);
+}
+
+static void
+bfa_fcport_send_stats_clear(void *cbarg)
+{
+	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
+	struct bfi_fcport_req_s *msg;
+
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait,
+				bfa_fcport_send_stats_clear, fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+						&fcport->stats_reqq_wait);
+		return;
+	}
+	fcport->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(struct bfi_fcport_req_s));
+	bfi_h2i_set(msg->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_STATS_CLEAR_REQ,
+			bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 }
 
 
@@ -903,32 +1276,32 @@ bfa_port_send_txcredit(void *port_cbarg)
  * Firmware message handler.
  */
 void
-bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
-	union bfi_pport_i2h_msg_u i2hmsg;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	union bfi_fcport_i2h_msg_u i2hmsg;
 
 	i2hmsg.msg = msg;
-	pport->event_arg.i2hmsg = i2hmsg;
+	fcport->event_arg.i2hmsg = i2hmsg;
 
 	switch (msg->mhdr.msg_id) {
-	case BFI_PPORT_I2H_ENABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
-			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+	case BFI_FCPORT_I2H_ENABLE_RSP:
+		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
-	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
-			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+	case BFI_FCPORT_I2H_DISABLE_RSP:
+		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
-	case BFI_PPORT_I2H_EVENT:
+	case BFI_FCPORT_I2H_EVENT:
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
@@ -936,37 +1309,37 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		}
 		break;
 
-	case BFI_PPORT_I2H_GET_STATS_RSP:
-	case BFI_PPORT_I2H_GET_QOS_STATS_RSP:
+	case BFI_FCPORT_I2H_STATS_GET_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
-		if (pport->stats_busy == BFA_FALSE
-		    || pport->stats_status == BFA_STATUS_ETIMER)
+		if (fcport->stats_busy == BFA_FALSE ||
+		    fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
 
-		bfa_timer_stop(&pport->timer);
-		pport->stats_status = i2hmsg.getstats_rsp->status;
-		bfa_cb_queue(pport->bfa, &pport->hcb_qe, __bfa_cb_port_stats,
-			     pport);
+		bfa_timer_stop(&fcport->timer);
+		fcport->stats_status = i2hmsg.pstatsget_rsp->status;
+		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
+				__bfa_cb_fcport_stats_get, fcport);
 		break;
-	case BFI_PPORT_I2H_CLEAR_STATS_RSP:
-	case BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP:
+
+	case BFI_FCPORT_I2H_STATS_CLEAR_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
-		if (pport->stats_busy == BFA_FALSE
-		    || pport->stats_status == BFA_STATUS_ETIMER)
+		if (fcport->stats_busy == BFA_FALSE ||
+		    fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
 
-		bfa_timer_stop(&pport->timer);
-		pport->stats_status = BFA_STATUS_OK;
-		bfa_cb_queue(pport->bfa, &pport->hcb_qe,
-			     __bfa_cb_port_stats_clr, pport);
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
 
@@ -980,35 +1353,36 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
  * Registered callback for port events.
  */
 void
-bfa_pport_event_register(struct bfa_s *bfa,
-			 void (*cbfn) (void *cbarg, bfa_pport_event_t event),
-			 void *cbarg)
+bfa_fcport_event_register(struct bfa_s *bfa,
+				void (*cbfn) (void *cbarg,
+				bfa_pport_event_t event),
+				void *cbarg)
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
-	else if (bfa_sm_cmp_state
-		 (BFA_PORT_MOD(bfa), bfa_pport_sm_disabling_qwait))
+	else if (bfa_sm_cmp_state(BFA_FCPORT_MOD(bfa),
+					bfa_fcport_sm_disabling_qwait))
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
 
@@ -1016,18 +1390,18 @@ bfa_pport_disable(struct bfa_s *bfa)
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
@@ -1036,23 +1410,23 @@ bfa_pport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
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
@@ -1064,7 +1438,7 @@ bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
 		return BFA_STATUS_EINVAL;
 	}
 
-	pport->cfg.topology = topology;
+	fcport->cfg.topology = topology;
 	return BFA_STATUS_OK;
 }
 
@@ -1072,112 +1446,108 @@ bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
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
 
-	/*
-	 * with in range
-	 */
+	/* with in range */
 	if ((maxfrsize > FC_MAX_PDUSZ) || (maxfrsize < FC_MIN_PDUSZ))
 		return BFA_STATUS_INVLD_DFSZ;
 
-	/*
-	 * power of 2, if not the max frame size of 2112
-	 */
+	/* power of 2, if not the max frame size of 2112 */
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
+	fcport->cfg.tx_bbcredit = (u8)tx_bbcredit;
+	bfa_fcport_send_txcredit(fcport);
 }
 
 /**
@@ -1185,437 +1555,287 @@ bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
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
-		      sizeof(struct bfa_pport_cfg_s));
-	/*
-	 * speed attributes
-	 */
-	attr->pport_cfg.speed = pport->cfg.speed;
-	attr->speed_supported = pport->speed_sup;
-	attr->speed = pport->speed;
+	bfa_os_memcpy(&attr->pport_cfg, &fcport->cfg,
+		sizeof(struct bfa_pport_cfg_s));
+	/* speed attributes */
+	attr->pport_cfg.speed = fcport->cfg.speed;
+	attr->speed_supported = fcport->speed_sup;
+	attr->speed = fcport->speed;
 	attr->cos_supported = FC_CLASS_3;
 
-	/*
-	 * topology attributes
-	 */
-	attr->pport_cfg.topology = pport->cfg.topology;
-	attr->topology = pport->topology;
+	/* topology attributes */
+	attr->pport_cfg.topology = fcport->cfg.topology;
+	attr->topology = fcport->topology;
 
-	/*
-	 * beacon attributes
-	 */
-	attr->beacon = pport->beacon;
-	attr->link_e2e_beacon = pport->link_e2e_beacon;
-	attr->plog_enabled = bfa_plog_get_setting(pport->bfa->plog);
-
-	attr->pport_cfg.path_tov = bfa_fcpim_path_tov_get(bfa);
-	attr->pport_cfg.q_depth = bfa_fcpim_qdepth_get(bfa);
-	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, pport->sm);
-	if (bfa_ioc_is_disabled(&pport->bfa->ioc))
+	/* beacon attributes */
+	attr->beacon = fcport->beacon;
+	attr->link_e2e_beacon = fcport->link_e2e_beacon;
+	attr->plog_enabled = bfa_plog_get_setting(fcport->bfa->plog);
+
+	attr->pport_cfg.path_tov  = bfa_fcpim_path_tov_get(bfa);
+	attr->pport_cfg.q_depth  = bfa_fcpim_qdepth_get(bfa);
+	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, fcport->sm);
+	if (bfa_ioc_is_disabled(&fcport->bfa->ioc))
 		attr->port_state = BFA_PPORT_ST_IOCDIS;
-	else if (bfa_ioc_fw_mismatch(&pport->bfa->ioc))
+	else if (bfa_ioc_fw_mismatch(&fcport->bfa->ioc))
 		attr->port_state = BFA_PPORT_ST_FWMISMATCH;
 }
 
-static void
-bfa_port_stats_query(void *cbarg)
-{
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
-	bfi_pport_get_stats_req_t *msg;
-
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_query,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
-		return;
-	}
-	port->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
-
-	return;
-}
-
-static void
-bfa_port_stats_clear(void *cbarg)
-{
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
-	bfi_pport_clear_stats_req_t *msg;
-
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_clear,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
-		return;
-	}
-	port->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
-	return;
-}
+#define BFA_FCPORT_STATS_TOV	1000
 
-static void
-bfa_port_qos_stats_clear(void *cbarg)
+/**
+ * Fetch port statistics (FCQoS or FCoE).
+ */
+bfa_status_t
+bfa_fcport_get_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+	bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
-	bfi_pport_clear_qos_stats_req_t *msg;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		port->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_qos_stats_clear,
-			       port);
-		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
-		return;
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
+		return BFA_STATUS_DEVBUSY;
 	}
-	port->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_qos_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
-		    bfa_lpuid(port->bfa));
-	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
-	return;
-}
 
-static void
-bfa_pport_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
-{
-	u32       *dip = (u32 *) d;
-	u32       *sip = (u32 *) s;
-	int             i;
+	fcport->stats_busy  = BFA_TRUE;
+	fcport->stats_ret   = stats;
+	fcport->stats_cbfn  = cbfn;
+	fcport->stats_cbarg = cbarg;
 
-	/*
-	 * Do 64 bit fields swap first
-	 */
-	for (i = 0;
-	     i <
-	     ((sizeof(union bfa_pport_stats_u) -
-	       sizeof(struct bfa_qos_stats_s)) / sizeof(u32)); i = i + 2) {
-#ifdef __BIGENDIAN
-		dip[i] = bfa_os_ntohl(sip[i]);
-		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
-#else
-		dip[i] = bfa_os_ntohl(sip[i + 1]);
-		dip[i + 1] = bfa_os_ntohl(sip[i]);
-#endif
-	}
+	bfa_fcport_send_stats_get(fcport);
 
-	/*
-	 * Now swap the 32 bit fields
-	 */
-	for (; i < (sizeof(union bfa_pport_stats_u) / sizeof(u32)); ++i)
-		dip[i] = bfa_os_ntohl(sip[i]);
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_get_timeout,
+			fcport, BFA_FCPORT_STATS_TOV);
+	return BFA_STATUS_OK;
 }
 
-static void
-__bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete)
+/**
+ * Reset port statistics (FCQoS or FCoE).
+ */
+bfa_status_t
+bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = cbarg;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	if (complete) {
-		port->stats_cbfn(port->stats_cbarg, port->stats_status);
-	} else {
-		port->stats_busy = BFA_FALSE;
-		port->stats_status = BFA_STATUS_OK;
+	if (fcport->stats_busy) {
+		bfa_trc(bfa, fcport->stats_busy);
+		return BFA_STATUS_DEVBUSY;
 	}
-}
-
-static void
-bfa_port_stats_clr_timeout(void *cbarg)
-{
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
 
-	bfa_trc(port->bfa, port->stats_qfull);
+	fcport->stats_busy  = BFA_TRUE;
+	fcport->stats_cbfn  = cbfn;
+	fcport->stats_cbarg = cbarg;
 
-	if (port->stats_qfull) {
-		bfa_reqq_wcancel(&port->stats_reqq_wait);
-		port->stats_qfull = BFA_FALSE;
-	}
+	bfa_fcport_send_stats_clear(fcport);
 
-	port->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats_clr, port);
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_clr_timeout,
+			fcport, BFA_FCPORT_STATS_TOV);
+	return BFA_STATUS_OK;
 }
 
-static void
-__bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete)
+/**
+ * Fetch FCQoS port statistics
+ */
+bfa_status_t
+bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+	bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = cbarg;
+	/* Meaningful only for FC mode */
+	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
 
-	if (complete) {
-		if (port->stats_status == BFA_STATUS_OK)
-			bfa_pport_stats_swap(port->stats_ret, port->stats);
-		port->stats_cbfn(port->stats_cbarg, port->stats_status);
-	} else {
-		port->stats_busy = BFA_FALSE;
-		port->stats_status = BFA_STATUS_OK;
-	}
+	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
-static void
-bfa_port_stats_timeout(void *cbarg)
+/**
+ * Reset FCoE port statistics
+ */
+bfa_status_t
+bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
-
-	bfa_trc(port->bfa, port->stats_qfull);
+	/* Meaningful only for FC mode */
+	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
 
-	if (port->stats_qfull) {
-		bfa_reqq_wcancel(&port->stats_reqq_wait);
-		port->stats_qfull = BFA_FALSE;
-	}
-
-	port->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats, port);
+	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
 }
 
-#define BFA_PORT_STATS_TOV	1000
-
 /**
- * Fetch port attributes.
+ * Fetch FCQoS port statistics
  */
 bfa_status_t
-bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
-		    bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_get_fcoe_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+	bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
-
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
-
-	port->stats_busy = BFA_TRUE;
-	port->stats_ret = stats;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
+	/* Meaningful only for FCoE mode */
+	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
 
-	bfa_port_stats_query(port);
-
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_timeout, port,
-			BFA_PORT_STATS_TOV);
-	return BFA_STATUS_OK;
+	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
+/**
+ * Reset FCoE port statistics
+ */
 bfa_status_t
-bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
-
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
+	/* Meaningful only for FCoE mode */
+	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
 
-	port->stats_busy = BFA_TRUE;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
-
-	bfa_port_stats_clear(port);
-
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
-			BFA_PORT_STATS_TOV);
-	return BFA_STATUS_OK;
+	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
 }
 
 bfa_status_t
-bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
+bfa_fcport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
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
-			  struct bfa_qos_vc_attr_s *qos_vc_attr)
+bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
+	struct bfa_qos_vc_attr_s *qos_vc_attr)
 {
-	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
-	struct bfa_qos_vc_attr_s *bfa_vc_attr = &pport->qos_vc_attr;
-	u32        i = 0;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	struct bfa_qos_vc_attr_s *bfa_vc_attr = &fcport->qos_vc_attr;
+	u32 i = 0;
 
 	qos_vc_attr->total_vc_count = bfa_os_ntohs(bfa_vc_attr->total_vc_count);
-	qos_vc_attr->shared_credit = bfa_os_ntohs(bfa_vc_attr->shared_credit);
-	qos_vc_attr->elp_opmode_flags =
-		bfa_os_ntohl(bfa_vc_attr->elp_opmode_flags);
+	qos_vc_attr->shared_credit  = bfa_os_ntohs(bfa_vc_attr->shared_credit);
+	qos_vc_attr->elp_opmode_flags  =
+			bfa_os_ntohl(bfa_vc_attr->elp_opmode_flags);
 
-	/*
-	 * Individual VC info
-	 */
+	/* Individual VC info */
 	while (i < qos_vc_attr->total_vc_count) {
-		qos_vc_attr->vc_info[i].vc_credit =
-			bfa_vc_attr->vc_info[i].vc_credit;
-		qos_vc_attr->vc_info[i].borrow_credit =
-			bfa_vc_attr->vc_info[i].borrow_credit;
-		qos_vc_attr->vc_info[i].priority =
-			bfa_vc_attr->vc_info[i].priority;
+		qos_vc_attr->vc_info[i].vc_credit	=
+				bfa_vc_attr->vc_info[i].vc_credit;
+		qos_vc_attr->vc_info[i].borrow_credit	=
+				bfa_vc_attr->vc_info[i].borrow_credit;
+		qos_vc_attr->vc_info[i].priority	=
+				bfa_vc_attr->vc_info[i].priority;
 		++i;
 	}
 }
 
 /**
- * Fetch QoS Stats.
- */
-bfa_status_t
-bfa_pport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
-			bfa_cb_pport_t cbfn, void *cbarg)
-{
-	/*
-	 * QoS stats is embedded in port stats
-	 */
-	return bfa_pport_get_stats(bfa, stats, cbfn, cbarg);
-}
-
-bfa_status_t
-bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
-{
-	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
-
-	if (port->stats_busy) {
-		bfa_trc(bfa, port->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
-
-	port->stats_busy = BFA_TRUE;
-	port->stats_cbfn = cbfn;
-	port->stats_cbarg = cbarg;
-
-	bfa_port_qos_stats_clear(port);
-
-	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
-			BFA_PORT_STATS_TOV);
-	return BFA_STATUS_OK;
-}
-
-/**
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
+	enum bfa_ioc_type_e ioc_type = bfa_get_type(bfa);
 
 	bfa_trc(bfa, on_off);
-	bfa_trc(bfa, pport->cfg.qos_enabled);
+	bfa_trc(bfa, fcport->cfg.qos_enabled);
+
+	bfa_trc(bfa, ioc_type);
 
-	pport->cfg.qos_enabled = on_off;
+	if (ioc_type == BFA_IOC_TYPE_FC)
+		fcport->cfg.qos_enabled = on_off;
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
 
-	/*
-	 * Auto and speeds greater than the supported speed, are invalid
-	 */
-	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > pport->speed_sup)) {
-		bfa_trc(bfa, pport->speed_sup);
+	/* Auto and speeds greater than the supported speed, are invalid */
+	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > fcport->speed_sup)) {
+		bfa_trc(bfa, fcport->speed_sup);
 		return BFA_STATUS_UNSUPP_SPEED;
 	}
 
-	pport->cfg.trl_def_speed = speed;
+	fcport->cfg.trl_def_speed = speed;
 
 	return BFA_STATUS_OK;
 }
@@ -1624,45 +1844,44 @@ bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
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
-
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
-		 bfa_boolean_t link_e2e_beacon)
+bfa_fcport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+	bfa_boolean_t link_e2e_beacon)
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
 
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 397d7e9..e7e87be 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -18,7 +18,7 @@
 #include <bfa.h>
 #include <bfa_ioc.h>
 #include <bfa_fwimg_priv.h>
-#include <bfa_trcmod_priv.h>
+#include <cna/bfa_cna_trcmod.h>
 #include <cs/bfa_debug.h>
 #include <bfi/bfi_ioc.h>
 #include <bfi/bfi_ctreg.h>
@@ -27,18 +27,17 @@
 #include <log/bfa_log_hal.h>
 #include <defs/bfa_defs_pci.h>
 
-BFA_TRC_FILE(HAL, IOC);
+BFA_TRC_FILE(CNA, IOC);
 
 /**
  * IOC local definitions
  */
 #define BFA_IOC_TOV		2000	/* msecs */
-#define BFA_IOC_HB_TOV		1000	/* msecs */
-#define BFA_IOC_HB_FAIL_MAX	4
+#define BFA_IOC_HWSEM_TOV	500	/* msecs */
+#define BFA_IOC_HB_TOV		500	/* msecs */
 #define BFA_IOC_HWINIT_MAX	2
-#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
-#define BFA_IOC_TOV_RECOVER	(BFA_IOC_HB_FAIL_MAX * BFA_IOC_HB_TOV \
-				+ BFA_IOC_TOV)
+#define BFA_IOC_FWIMG_MINSZ	(16 * 1024)
+#define BFA_IOC_TOV_RECOVER	 BFA_IOC_HB_TOV
 
 #define bfa_ioc_timer_start(__ioc)					\
 	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
@@ -51,36 +50,46 @@ BFA_TRC_FILE(HAL, IOC);
 	 (sizeof(struct bfa_trc_mod_s) -			\
 	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 #define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
-#define bfa_ioc_stats(_ioc, _stats)	((_ioc)->stats._stats++)
 
-#define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
-#define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
-#define BFA_FLASH_CHUNK_ADDR(chunkno)   (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
-bfa_boolean_t   bfa_auto_recover = BFA_FALSE;
+/**
+ * Asic specific macros : see bfa_hw_cb.c and bfa_hw_ct.c for details.
+ */
+
+#define bfa_ioc_firmware_lock(__ioc)			\
+			((__ioc)->ioc_hwif->ioc_firmware_lock(__ioc))
+#define bfa_ioc_firmware_unlock(__ioc)			\
+			((__ioc)->ioc_hwif->ioc_firmware_unlock(__ioc))
+#define bfa_ioc_fwimg_get_chunk(__ioc, __off)		\
+			((__ioc)->ioc_hwif->ioc_fwimg_get_chunk(__ioc, __off))
+#define bfa_ioc_fwimg_get_size(__ioc)			\
+			((__ioc)->ioc_hwif->ioc_fwimg_get_size(__ioc))
+#define bfa_ioc_reg_init(__ioc) ((__ioc)->ioc_hwif->ioc_reg_init(__ioc))
+#define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
+#define bfa_ioc_notify_hbfail(__ioc)			\
+			((__ioc)->ioc_hwif->ioc_notify_hbfail(__ioc))
+
+bfa_boolean_t bfa_auto_recover = BFA_TRUE;
 
 /*
  * forward declarations
  */
-static void     bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
-				 enum bfa_ioc_aen_event event);
-static void     bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
-static void     bfa_ioc_timeout(void *ioc);
-static void     bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
-static void     bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_recover(struct bfa_ioc_s *ioc);
-static bfa_boolean_t bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
+			     enum bfa_ioc_aen_event event);
+static void bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_timeout(void *ioc);
+static void bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
+static void bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_recover(struct bfa_ioc_s *ioc);
+static void bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
+static void bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
 
 /**
  *  bfa_ioc_sm
@@ -90,19 +99,20 @@ static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
  * IOC state machine events
  */
 enum ioc_event {
-	IOC_E_ENABLE = 1,	/*  IOC enable request */
-	IOC_E_DISABLE = 2,	/*  IOC disable request */
-	IOC_E_TIMEOUT = 3,	/*  f/w response timeout */
-	IOC_E_FWREADY = 4,	/*  f/w initialization done */
-	IOC_E_FWRSP_GETATTR = 5,	/*  IOC get attribute response */
-	IOC_E_FWRSP_ENABLE = 6,	/*  enable f/w response */
-	IOC_E_FWRSP_DISABLE = 7,	/*  disable f/w response */
-	IOC_E_HBFAIL = 8,	/*  heartbeat failure */
-	IOC_E_HWERROR = 9,	/*  hardware error interrupt */
-	IOC_E_SEMLOCKED = 10,	/*  h/w semaphore is locked */
-	IOC_E_DETACH = 11,	/*  driver detach cleanup */
+	IOC_E_ENABLE		= 1,	/*  IOC enable request		*/
+	IOC_E_DISABLE		= 2,	/*  IOC disable request	*/
+	IOC_E_TIMEOUT		= 3,	/*  f/w response timeout	*/
+	IOC_E_FWREADY		= 4,	/*  f/w initialization done	*/
+	IOC_E_FWRSP_GETATTR	= 5,	/*  IOC get attribute response	*/
+	IOC_E_FWRSP_ENABLE	= 6,	/*  enable f/w response	*/
+	IOC_E_FWRSP_DISABLE	= 7,	/*  disable f/w response	*/
+	IOC_E_HBFAIL		= 8,	/*  heartbeat failure		*/
+	IOC_E_HWERROR		= 9,	/*  hardware error interrupt	*/
+	IOC_E_SEMLOCKED		= 10,	/*  h/w semaphore is locked	*/
+	IOC_E_DETACH		= 11,	/*  driver detach cleanup	*/
 };
 
+
 bfa_fsm_state_decl(bfa_ioc, reset, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, fwcheck, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, mismatch, struct bfa_ioc_s, enum ioc_event);
@@ -196,9 +206,7 @@ bfa_ioc_sm_fwcheck(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_DISABLE:
 		bfa_ioc_disable_comp(ioc);
-		/*
-		 * fall through
-		 */
+		/* fall through */
 
 	case IOC_E_DETACH:
 		bfa_ioc_hw_sem_get_cancel(ioc);
@@ -245,9 +253,7 @@ bfa_ioc_sm_mismatch(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_DISABLE:
 		bfa_ioc_disable_comp(ioc);
-		/*
-		 * fall through
-		 */
+		/* fall through */
 
 	case IOC_E_DETACH:
 		bfa_ioc_timer_stop(ioc);
@@ -320,9 +326,7 @@ bfa_ioc_sm_hwinit(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_HWERROR:
 		bfa_ioc_timer_stop(ioc);
-		/*
-		 * fall through
-		 */
+		/* fall through */
 
 	case IOC_E_TIMEOUT:
 		ioc->retry_count++;
@@ -373,9 +377,7 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_HWERROR:
 		bfa_ioc_timer_stop(ioc);
-		/*
-		 * fall through
-		 */
+		/* fall through */
 
 	case IOC_E_TIMEOUT:
 		ioc->retry_count++;
@@ -429,9 +431,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_HWERROR:
 		bfa_ioc_timer_stop(ioc);
-		/*
-		 * fall through
-		 */
+		/* fall through */
 
 	case IOC_E_TIMEOUT:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
@@ -477,9 +477,7 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 		 * Treat it same as heartbeat failure.
 		 */
 		bfa_ioc_hb_stop(ioc);
-		/*
-		 * !!! fall through !!!
-		 */
+		/* !!! fall through !!! */
 
 	case IOC_E_HBFAIL:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_hbfail);
@@ -508,14 +506,19 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_HWERROR:
 	case IOC_E_FWRSP_DISABLE:
 		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
 		/*
 		 * !!! fall through !!!
 		 */
 
 	case IOC_E_TIMEOUT:
+		bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
 		break;
 
@@ -601,29 +604,26 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 static void
 bfa_ioc_sm_hbfail_entry(struct bfa_ioc_s *ioc)
 {
-	struct list_head *qe;
-	struct bfa_ioc_hbfail_notify_s *notify;
+	struct list_head			*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
 
 	/**
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(ioc);
-	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_HBFAIL);
+	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
 
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
-		/*
-		 * Wait for halt to take effect
-		 */
-		bfa_reg_read(ioc->ioc_regs.ll_halt);
-	}
+	/**
+	 * Notify other functions on HB failure.
+	 */
+	bfa_ioc_notify_hbfail(ioc);
 
 	/**
 	 * Notify driver and common modules registered for notification.
 	 */
 	ioc->cbfn->hbfail_cbfn(ioc->bfa);
 	list_for_each(qe, &ioc->hb_notify_q) {
-		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
 		notify->cbfn(notify->cbarg);
 	}
 
@@ -672,6 +672,11 @@ bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		 */
 		break;
 
+	case IOC_E_HWERROR:
+		/*
+		 * HB failure notification, ignore.
+		 */
+		break;
 	default:
 		bfa_sm_fault(ioc, event);
 	}
@@ -686,8 +691,8 @@ bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 static void
 bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 {
-	struct list_head *qe;
-	struct bfa_ioc_hbfail_notify_s *notify;
+	struct list_head			*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
 
 	ioc->cbfn->disable_cbfn(ioc->bfa);
 
@@ -695,7 +700,7 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 	 * Notify common modules registered for notification.
 	 */
 	list_for_each(qe, &ioc->hb_notify_q) {
-		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
 		notify->cbfn(notify->cbarg);
 	}
 }
@@ -703,41 +708,47 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_sem_timeout(void *ioc_arg)
 {
-	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
 
 	bfa_ioc_hw_sem_get(ioc);
 }
 
-static void
-bfa_ioc_usage_sem_get(struct bfa_ioc_s *ioc)
+bfa_boolean_t
+bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
 {
-	u32        r32;
-	int             cnt = 0;
-#define BFA_SEM_SPINCNT	1000
+	u32 r32;
+	int cnt = 0;
+#define BFA_SEM_SPINCNT	3000
 
-	do {
-		r32 = bfa_reg_read(ioc->ioc_regs.ioc_usage_sem_reg);
+	r32 = bfa_reg_read(sem_reg);
+
+	while (r32 && (cnt < BFA_SEM_SPINCNT)) {
 		cnt++;
-		if (cnt > BFA_SEM_SPINCNT)
-			break;
-	} while (r32 != 0);
+		bfa_os_udelay(2);
+		r32 = bfa_reg_read(sem_reg);
+	}
+
+	if (r32 == 0)
+		return BFA_TRUE;
+
 	bfa_assert(cnt < BFA_SEM_SPINCNT);
+	return BFA_FALSE;
 }
 
-static void
-bfa_ioc_usage_sem_release(struct bfa_ioc_s *ioc)
+void
+bfa_ioc_sem_release(bfa_os_addr_t sem_reg)
 {
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_sem_reg, 1);
+	bfa_reg_write(sem_reg, 1);
 }
 
 static void
 bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 {
-	u32        r32;
+	u32	r32;
 
 	/**
 	 * First read to the semaphore register will return 0, subsequent reads
-	 * will return 1. Semaphore is released by writing 0 to the register
+	 * will return 1. Semaphore is released by writing 1 to the register
 	 */
 	r32 = bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
 	if (r32 == 0) {
@@ -746,10 +757,10 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 	}
 
 	bfa_timer_begin(ioc->timer_mod, &ioc->sem_timer, bfa_ioc_sem_timeout,
-			ioc, BFA_IOC_TOV);
+			ioc, BFA_IOC_HWSEM_TOV);
 }
 
-static void
+void
 bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
 {
 	bfa_reg_write(ioc->ioc_regs.ioc_sem_reg, 1);
@@ -767,14 +778,18 @@ bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
-	int             i;
+	u32	pss_ctl;
+	int		i;
 #define PSS_LMEM_INIT_TIME  10000
 
 	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
 	pss_ctl &= ~__PSS_LMEM_RESET;
 	pss_ctl |= __PSS_LMEM_INIT_EN;
-	pss_ctl |= __PSS_I2C_CLK_DIV(3UL); /* i2c workaround 12.5khz clock */
+
+	/*
+	 * i2c workaround 12.5khz clock
+	 */
+	pss_ctl |= __PSS_I2C_CLK_DIV(3UL);
 	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
 
 	/**
@@ -800,7 +815,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
+	u32	pss_ctl;
 
 	/**
 	 * Take processor out of reset.
@@ -814,7 +829,7 @@ bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
+	u32	pss_ctl;
 
 	/**
 	 * Put processors in reset.
@@ -828,13 +843,13 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 /**
  * Get driver and firmware versions.
  */
-static void
+void
 bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
-	u32        pgnum, pgoff;
-	u32        loff = 0;
-	int             i;
-	u32       *fwsig = (u32 *) fwhdr;
+	u32	pgnum, pgoff;
+	u32	loff = 0;
+	int		i;
+	u32	*fwsig = (u32 *) fwhdr;
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
@@ -842,36 +857,23 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
 	     i++) {
-		fwsig[i] = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		fwsig[i] =
+			bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
 		loff += sizeof(u32);
 	}
 }
 
-static u32 *
-bfa_ioc_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
-{
-	if (ioc->ctdev)
-		return bfi_image_ct_get_chunk(off);
-	return bfi_image_cb_get_chunk(off);
-}
-
-static          u32
-bfa_ioc_fwimg_get_size(struct bfa_ioc_s *ioc)
-{
-return (ioc->ctdev) ? bfi_image_ct_size : bfi_image_cb_size;
-}
-
 /**
  * Returns TRUE if same.
  */
-static          bfa_boolean_t
+bfa_boolean_t
 bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
 	struct bfi_ioc_image_hdr_s *drv_fwhdr;
-	int             i;
+	int i;
 
 	drv_fwhdr =
-		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+		(struct bfi_ioc_image_hdr_s *) bfa_ioc_fwimg_get_chunk(ioc, 0);
 
 	for (i = 0; i < BFI_IOC_MD5SUM_SZ; i++) {
 		if (fwhdr->md5sum[i] != drv_fwhdr->md5sum[i]) {
@@ -890,7 +892,7 @@ bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
  * Return true if current running version is valid. Firmware signature and
  * execution context (driver/bios) must match.
  */
-static          bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 {
 	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
@@ -903,7 +905,7 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 
 	bfa_ioc_fwver_get(ioc, &fwhdr);
 	drv_fwhdr =
-		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+		(struct bfi_ioc_image_hdr_s *) bfa_ioc_fwimg_get_chunk(ioc, 0);
 
 	if (fwhdr.signature != drv_fwhdr->signature) {
 		bfa_trc(ioc, fwhdr.signature);
@@ -921,101 +923,12 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Return true if firmware of current driver matches the running firmware.
- */
-static          bfa_boolean_t
-bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc)
-{
-	enum bfi_ioc_state ioc_fwstate;
-	u32        usecnt;
-	struct bfi_ioc_image_hdr_s fwhdr;
-
-	/**
-	 * Firmware match check is relevant only for CNA.
-	 */
-	if (!ioc->cna)
-		return BFA_TRUE;
-
-	/**
-	 * If bios boot (flash based) -- do not increment usage count
-	 */
-	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
-		return BFA_TRUE;
-
-	bfa_ioc_usage_sem_get(ioc);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
-
-	/**
-	 * If usage count is 0, always return TRUE.
-	 */
-	if (usecnt == 0) {
-		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
-		bfa_ioc_usage_sem_release(ioc);
-		bfa_trc(ioc, usecnt);
-		return BFA_TRUE;
-	}
-
-	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
-	bfa_trc(ioc, ioc_fwstate);
-
-	/**
-	 * Use count cannot be non-zero and chip in uninitialized state.
-	 */
-	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
-
-	/**
-	 * Check if another driver with a different firmware is active
-	 */
-	bfa_ioc_fwver_get(ioc, &fwhdr);
-	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
-		bfa_ioc_usage_sem_release(ioc);
-		bfa_trc(ioc, usecnt);
-		return BFA_FALSE;
-	}
-
-	/**
-	 * Same firmware version. Increment the reference count.
-	 */
-	usecnt++;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
-	bfa_ioc_usage_sem_release(ioc);
-	bfa_trc(ioc, usecnt);
-	return BFA_TRUE;
-}
-
-static void
-bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc)
-{
-	u32        usecnt;
-
-	/**
-	 * Firmware lock is relevant only for CNA.
-	 * If bios boot (flash based) -- do not decrement usage count
-	 */
-	if (!ioc->cna || (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ))
-		return;
-
-	/**
-	 * decrement usage count
-	 */
-	bfa_ioc_usage_sem_get(ioc);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
-	bfa_assert(usecnt > 0);
-
-	usecnt--;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
-	bfa_trc(ioc, usecnt);
-
-	bfa_ioc_usage_sem_release(ioc);
-}
-
-/**
  * Conditionally flush any pending message from firmware at start.
  */
 static void
 bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
 {
-	u32        r32;
+	u32	r32;
 
 	r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
 	if (r32)
@@ -1027,7 +940,7 @@ static void
 bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 {
 	enum bfi_ioc_state ioc_fwstate;
-	bfa_boolean_t   fwvalid;
+	bfa_boolean_t fwvalid;
 
 	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
 
@@ -1040,7 +953,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	 * check if firmware is valid
 	 */
 	fwvalid = (ioc_fwstate == BFI_IOC_UNINIT) ?
-			BFA_FALSE : bfa_ioc_fwver_valid(ioc);
+		BFA_FALSE : bfa_ioc_fwver_valid(ioc);
 
 	if (!fwvalid) {
 		bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
@@ -1083,7 +996,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 static void
 bfa_ioc_timeout(void *ioc_arg)
 {
-	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
 
 	bfa_trc(ioc, 0);
 	bfa_fsm_send_event(ioc, IOC_E_TIMEOUT);
@@ -1092,8 +1005,8 @@ bfa_ioc_timeout(void *ioc_arg)
 void
 bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 {
-	u32       *msgp = (u32 *) ioc_msg;
-	u32        i;
+	u32 *msgp = (u32 *) ioc_msg;
+	u32 i;
 
 	bfa_trc(ioc, msgp[0]);
 	bfa_trc(ioc, len);
@@ -1114,7 +1027,7 @@ bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 	 * write 1 to mailbox CMD to trigger LPU event
 	 */
 	bfa_reg_write(ioc->ioc_regs.hfn_mbox_cmd, 1);
-	(void)bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	(void) bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
 }
 
 static void
@@ -1141,7 +1054,7 @@ bfa_ioc_send_disable(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
 {
-	struct bfi_ioc_getattr_req_s attr_req;
+	struct bfi_ioc_getattr_req_s	attr_req;
 
 	bfi_h2i_set(attr_req.mh, BFI_MC_IOC, BFI_IOC_H2I_GETATTR_REQ,
 		    bfa_ioc_portid(ioc));
@@ -1152,36 +1065,30 @@ bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_hb_check(void *cbarg)
 {
-	struct bfa_ioc_s *ioc = cbarg;
-	u32        hb_count;
+	struct bfa_ioc_s  *ioc = cbarg;
+	u32	hb_count;
 
 	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
 	if (ioc->hb_count == hb_count) {
-		ioc->hb_fail++;
-	} else {
-		ioc->hb_count = hb_count;
-		ioc->hb_fail = 0;
-	}
-
-	if (ioc->hb_fail >= BFA_IOC_HB_FAIL_MAX) {
-		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE, hb_count);
-		ioc->hb_fail = 0;
+		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE,
+			hb_count);
 		bfa_ioc_recover(ioc);
 		return;
+	} else {
+		ioc->hb_count = hb_count;
 	}
 
 	bfa_ioc_mbox_poll(ioc);
-	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
-			BFA_IOC_HB_TOV);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
+			ioc, BFA_IOC_HB_TOV);
 }
 
 static void
 bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
 {
-	ioc->hb_fail = 0;
 	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
-	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
-			BFA_IOC_HB_TOV);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
+			ioc, BFA_IOC_HB_TOV);
 }
 
 static void
@@ -1190,124 +1097,19 @@ bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
 	bfa_timer_stop(&ioc->ioc_timer);
 }
 
-/**
- * Host to LPU mailbox message addresses
- */
-static struct {
-	u32        hfn_mbox, lpu_mbox, hfn_pgn;
-} iocreg_fnreg[] = {
-	{
-	HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0}, {
-	HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1}, {
-	HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2}, {
-	HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3}
-};
-
-/**
- * Host <-> LPU mailbox command/status registers - port 0
- */
-static struct {
-	u32        hfn, lpu;
-} iocreg_mbcmd_p0[] = {
-	{
-	HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT}, {
-	HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT}, {
-	HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT}, {
-	HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT}
-};
-
-/**
- * Host <-> LPU mailbox command/status registers - port 1
- */
-static struct {
-	u32        hfn, lpu;
-} iocreg_mbcmd_p1[] = {
-	{
-	HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT}, {
-	HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT}, {
-	HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT}, {
-	HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT}
-};
-
-/**
- * Shared IRQ handling in INTX mode
- */
-static struct {
-	u32        isr, msk;
-} iocreg_shirq_next[] = {
-	{
-	HOSTFN1_INT_STATUS, HOSTFN1_INT_MSK}, {
-	HOSTFN2_INT_STATUS, HOSTFN2_INT_MSK}, {
-	HOSTFN3_INT_STATUS, HOSTFN3_INT_MSK}, {
-HOSTFN0_INT_STATUS, HOSTFN0_INT_MSK},};
-
-static void
-bfa_ioc_reg_init(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb;
-	int             pcifn = bfa_ioc_pcifn(ioc);
-
-	rb = bfa_ioc_bar0(ioc);
-
-	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
-	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
-	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
-
-	if (ioc->port_id == 0) {
-		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
-		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
-		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
-		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
-		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
-	} else {
-		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
-		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
-		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
-		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
-		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
-	}
-
-	/**
-	 * Shared IRQ handling in INTX mode
-	 */
-	ioc->ioc_regs.shirq_isr_next = rb + iocreg_shirq_next[pcifn].isr;
-	ioc->ioc_regs.shirq_msk_next = rb + iocreg_shirq_next[pcifn].msk;
-
-	/*
-	 * PSS control registers
-	 */
-	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
-	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
-	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
-
-	/*
-	 * IOC semaphore registers and serialization
-	 */
-	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
-	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
-	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
-
-	/**
-	 * sram memory access
-	 */
-	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
-	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT)
-		ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
-}
 
 /**
- *      Initiate a full firmware download.
+ *	Initiate a full firmware download.
  */
 static void
 bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		    u32 boot_param)
 {
-	u32       *fwimg;
-	u32        pgnum, pgoff;
-	u32        loff = 0;
-	u32        chunkno = 0;
-	u32        i;
+	u32 *fwimg;
+	u32 pgnum, pgoff;
+	u32 loff = 0;
+	u32 chunkno = 0;
+	u32 i;
 
 	/**
 	 * Initialize LMEM first before code download
@@ -1321,9 +1123,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
 		boot_type = BFI_BOOT_TYPE_FLASH;
 	fwimg = bfa_ioc_fwimg_get_chunk(ioc, chunkno);
-	fwimg[BFI_BOOT_TYPE_OFF / sizeof(u32)] = bfa_os_swap32(boot_type);
-	fwimg[BFI_BOOT_PARAM_OFF / sizeof(u32)] =
-		bfa_os_swap32(boot_param);
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
@@ -1332,17 +1131,17 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 	for (i = 0; i < bfa_ioc_fwimg_get_size(ioc); i++) {
 
-		if (BFA_FLASH_CHUNK_NO(i) != chunkno) {
-			chunkno = BFA_FLASH_CHUNK_NO(i);
+		if (BFA_IOC_FLASH_CHUNK_NO(i) != chunkno) {
+			chunkno = BFA_IOC_FLASH_CHUNK_NO(i);
 			fwimg = bfa_ioc_fwimg_get_chunk(ioc,
-					BFA_FLASH_CHUNK_ADDR(chunkno));
+					BFA_IOC_FLASH_CHUNK_ADDR(chunkno));
 		}
 
 		/**
 		 * write smem
 		 */
 		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff,
-			      fwimg[BFA_FLASH_OFFSET_IN_CHUNK(i)]);
+			      fwimg[BFA_IOC_FLASH_OFFSET_IN_CHUNK(i)]);
 
 		loff += sizeof(u32);
 
@@ -1352,12 +1151,21 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+				      pgnum);
 		}
 	}
 
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
 		      bfa_ioc_smem_pgnum(ioc, 0));
+
+	/*
+	 * Set boot type and boot param at the end.
+	*/
+	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_TYPE_OFF,
+			bfa_os_swap32(boot_type));
+	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_PARAM_OFF,
+			bfa_os_swap32(boot_param));
 }
 
 static void
@@ -1372,10 +1180,10 @@ bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 static void
 bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
 {
-	struct bfi_ioc_attr_s *attr = ioc->attr;
+	struct bfi_ioc_attr_s	*attr = ioc->attr;
 
-	attr->adapter_prop = bfa_os_ntohl(attr->adapter_prop);
-	attr->maxfrsize = bfa_os_ntohs(attr->maxfrsize);
+	attr->adapter_prop  = bfa_os_ntohl(attr->adapter_prop);
+	attr->maxfrsize	    = bfa_os_ntohs(attr->maxfrsize);
 
 	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
 }
@@ -1386,8 +1194,8 @@ bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	int             mc;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int	mc;
 
 	INIT_LIST_HEAD(&mod->cmd_q);
 	for (mc = 0; mc < BFI_MC_MAX; mc++) {
@@ -1402,9 +1210,9 @@ bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfa_mbox_cmd_s *cmd;
-	u32        stat;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
+	u32			stat;
 
 	/**
 	 * If no command pending, do nothing
@@ -1432,43 +1240,13 @@ bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfa_mbox_cmd_s *cmd;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
 
 	while (!list_empty(&mod->cmd_q))
 		bfa_q_deq(&mod->cmd_q, &cmd);
 }
 
-/**
- * Initialize IOC to port mapping.
- */
-
-#define FNC_PERS_FN_SHIFT(__fn)	((__fn) * 8)
-static void
-bfa_ioc_map_port(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        r32;
-
-	/**
-	 * For crossbow, port id is same as pci function.
-	 */
-	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT) {
-		ioc->port_id = bfa_ioc_pcifn(ioc);
-		return;
-	}
-
-	/**
-	 * For catapult, base port id on personality register and IOC type
-	 */
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
-	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
-	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
-
-	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
-	bfa_trc(ioc, ioc->port_id);
-}
-
 
 
 /**
@@ -1476,139 +1254,13 @@ bfa_ioc_map_port(struct bfa_ioc_s *ioc)
  */
 
 /**
-* Set interrupt mode for a function: INTX or MSIX
- */
-void
-bfa_ioc_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        r32, mode;
-
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
-	bfa_trc(ioc, r32);
-
-	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
-		__F0_INTX_STATUS;
-
-	/**
-	 * If already in desired mode, do not change anything
-	 */
-	if (!msix && mode)
-		return;
-
-	if (msix)
-		mode = __F0_INTX_STATUS_MSIX;
-	else
-		mode = __F0_INTX_STATUS_INTA;
-
-	r32 &= ~(__F0_INTX_STATUS << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
-	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
-	bfa_trc(ioc, r32);
-
-	bfa_reg_write(rb + FNC_PERS_REG, r32);
-}
-
-bfa_status_t
-bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        pll_sclk, pll_fclk, r32;
-
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		pll_sclk =
-			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
-			__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
-			__APP_PLL_312_JITLMT0_1(3U) |
-			__APP_PLL_312_CNTLMT0_1(1U);
-		pll_fclk =
-			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
-			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
-			__APP_PLL_425_JITLMT0_1(3U) |
-			__APP_PLL_425_CNTLMT0_1(1U);
-
-		/**
-		 * 	For catapult, choose operational mode FC/FCoE
-		 */
-		if (ioc->fcmode) {
-			bfa_reg_write((rb + OP_MODE), 0);
-			bfa_reg_write((rb + ETH_MAC_SER_REG),
-				      __APP_EMS_CMLCKSEL | __APP_EMS_REFCKBUFEN2
-				      | __APP_EMS_CHANNEL_SEL);
-		} else {
-			ioc->pllinit = BFA_TRUE;
-			bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
-			bfa_reg_write((rb + ETH_MAC_SER_REG),
-				      __APP_EMS_REFCKBUFEN1);
-		}
-	} else {
-		pll_sclk =
-			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
-			__APP_PLL_312_P0_1(3U) | __APP_PLL_312_JITLMT0_1(3U) |
-			__APP_PLL_312_CNTLMT0_1(3U);
-		pll_fclk =
-			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
-			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
-			__APP_PLL_425_JITLMT0_1(3U) |
-			__APP_PLL_425_CNTLMT0_1(3U);
-	}
-
-	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_BYPASS | __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_BYPASS | __APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_os_udelay(2);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_LOGIC_SOFT_RESET);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
-
-	/**
-	 * Wait for PLLs to lock.
-	 */
-	bfa_os_udelay(2000);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
-
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
-		bfa_os_udelay(1000);
-		r32 = bfa_reg_read((rb + MBIST_STAT_REG));
-		bfa_trc(ioc, r32);
-	}
-
-	return BFA_STATUS_OK;
-}
-
-/**
  * Interface used by diag module to do firmware boot with memory test
  * as the entry vector.
  */
 void
 bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 {
-	bfa_os_addr_t   rb;
+	bfa_os_addr_t	rb;
 
 	bfa_ioc_stats(ioc, ioc_boots);
 
@@ -1642,10 +1294,11 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 void
 bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
 {
-	bfa_auto_recover = BFA_FALSE;
+	bfa_auto_recover = auto_recover;
 }
 
 
+
 bfa_boolean_t
 bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 {
@@ -1655,9 +1308,9 @@ bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
-	u32       *msgp = mbmsg;
-	u32        r32;
-	int             i;
+	u32	*msgp = mbmsg;
+	u32	r32;
+	int		i;
 
 	/**
 	 * read the MBOX msg
@@ -1679,9 +1332,9 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 void
 bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 {
-	union bfi_ioc_i2h_msg_u *msg;
+	union bfi_ioc_i2h_msg_u	*msg;
 
-	msg = (union bfi_ioc_i2h_msg_u *)m;
+	msg = (union bfi_ioc_i2h_msg_u *) m;
 
 	bfa_ioc_stats(ioc, ioc_isrs);
 
@@ -1725,14 +1378,14 @@ bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa, struct bfa_ioc_cbfn_s *cbfn,
 	       struct bfa_timer_mod_s *timer_mod, struct bfa_trc_mod_s *trcmod,
 	       struct bfa_aen_s *aen, struct bfa_log_mod_s *logm)
 {
-	ioc->bfa = bfa;
-	ioc->cbfn = cbfn;
-	ioc->timer_mod = timer_mod;
-	ioc->trcmod = trcmod;
-	ioc->aen = aen;
-	ioc->logm = logm;
-	ioc->fcmode = BFA_FALSE;
-	ioc->pllinit = BFA_FALSE;
+	ioc->bfa	= bfa;
+	ioc->cbfn	= cbfn;
+	ioc->timer_mod	= timer_mod;
+	ioc->trcmod	= trcmod;
+	ioc->aen	= aen;
+	ioc->logm	= logm;
+	ioc->fcmode	= BFA_FALSE;
+	ioc->pllinit	= BFA_FALSE;
 	ioc->dbg_fwsave_once = BFA_TRUE;
 
 	bfa_ioc_mbox_attach(ioc);
@@ -1759,10 +1412,18 @@ void
 bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		 enum bfi_mclass mc)
 {
-	ioc->ioc_mc = mc;
-	ioc->pcidev = *pcidev;
-	ioc->ctdev = (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT);
-	ioc->cna = ioc->ctdev && !ioc->fcmode;
+	ioc->ioc_mc	= mc;
+	ioc->pcidev	= *pcidev;
+	ioc->ctdev	= (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT);
+	ioc->cna	= ioc->ctdev && !ioc->fcmode;
+
+	/**
+	 * Set asic specific interfaces. See bfa_ioc_cb.c and bfa_ioc_ct.c
+	 */
+	if (ioc->ctdev)
+		bfa_ioc_set_ct_hwif(ioc);
+	else
+		bfa_ioc_set_cb_hwif(ioc);
 
 	bfa_ioc_map_port(ioc);
 	bfa_ioc_reg_init(ioc);
@@ -1775,14 +1436,14 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
  * @param[in]	dm_pa	physical address of IOC dma memory
  */
 void
-bfa_ioc_mem_claim(struct bfa_ioc_s *ioc, u8 *dm_kva, u64 dm_pa)
+bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
 {
 	/**
 	 * dma memory for firmware attribute
 	 */
 	ioc->attr_dma.kva = dm_kva;
 	ioc->attr_dma.pa = dm_pa;
-	ioc->attr = (struct bfi_ioc_attr_s *)dm_kva;
+	ioc->attr = (struct bfi_ioc_attr_s *) dm_kva;
 }
 
 /**
@@ -1820,7 +1481,7 @@ bfa_ioc_disable(struct bfa_ioc_s *ioc)
 int
 bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
 {
-return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
+	return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 }
 
 /**
@@ -1830,8 +1491,7 @@ return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 void
 bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
 {
-	bfa_assert(ioc->auto_recover);
-	ioc->dbg_fwsave = dbg_fwsave;
+	ioc->dbg_fwsave	    = dbg_fwsave;
 	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->auto_recover);
 }
 
@@ -1856,8 +1516,8 @@ bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
 void
 bfa_ioc_mbox_register(struct bfa_ioc_s *ioc, bfa_ioc_mbox_mcfunc_t *mcfuncs)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	int             mc;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int				mc;
 
 	for (mc = 0; mc < BFI_MC_MAX; mc++)
 		mod->mbhdlr[mc].cbfn = mcfuncs[mc];
@@ -1870,9 +1530,9 @@ void
 bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 		    bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
 
-	mod->mbhdlr[mc].cbfn = cbfn;
+	mod->mbhdlr[mc].cbfn	= cbfn;
 	mod->mbhdlr[mc].cbarg = cbarg;
 }
 
@@ -1886,8 +1546,8 @@ bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 void
 bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	u32        stat;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	u32			stat;
 
 	/**
 	 * If a previous command is pending, queue new command
@@ -1918,9 +1578,9 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 void
 bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfi_mbmsg_s m;
-	int             mc;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfi_mbmsg_s		m;
+	int				mc;
 
 	bfa_ioc_msgget(ioc, &m);
 
@@ -1953,8 +1613,8 @@ bfa_ioc_error_isr(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 {
-	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling) ||
+		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
 }
 
 /**
@@ -1963,9 +1623,9 @@ bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 {
-	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_fwcheck)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch);
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset) ||
+		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_fwcheck) ||
+		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch);
 }
 
 #define bfa_ioc_state_disabled(__sm)		\
@@ -1973,7 +1633,7 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 	 ((__sm) == BFI_IOC_INITING) ||		\
 	 ((__sm) == BFI_IOC_HWINIT) ||		\
 	 ((__sm) == BFI_IOC_DISABLED) ||	\
-	 ((__sm) == BFI_IOC_HBFAIL) ||		\
+	 ((__sm) == BFI_IOC_FAIL) ||		\
 	 ((__sm) == BFI_IOC_CFG_DISABLED))
 
 /**
@@ -1983,8 +1643,8 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 {
-	u32        ioc_state;
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32	ioc_state;
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
 
 	if (!bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled))
 		return BFA_FALSE;
@@ -2002,7 +1662,7 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 
 /**
  * Add to IOC heartbeat failure notification queue. To be used by common
- * modules such as
+ * modules such as cee, port, diag.
  */
 void
 bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
@@ -2016,102 +1676,164 @@ void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 			 struct bfa_adapter_attr_s *ad_attr)
 {
-	struct bfi_ioc_attr_s *ioc_attr;
-	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
+	struct bfi_ioc_attr_s	*ioc_attr;
 
 	ioc_attr = ioc->attr;
-	bfa_os_memcpy((void *)&ad_attr->serial_num,
-		      (void *)ioc_attr->brcd_serialnum,
-		      BFA_ADAPTER_SERIAL_NUM_LEN);
 
-	bfa_os_memcpy(&ad_attr->fw_ver, ioc_attr->fw_version, BFA_VERSION_LEN);
-	bfa_os_memcpy(&ad_attr->optrom_ver, ioc_attr->optrom_version,
-		      BFA_VERSION_LEN);
-	bfa_os_memcpy(&ad_attr->manufacturer, BFA_MFG_NAME,
-		      BFA_ADAPTER_MFG_NAME_LEN);
+	bfa_ioc_get_adapter_serial_num(ioc, ad_attr->serial_num);
+	bfa_ioc_get_adapter_fw_ver(ioc, ad_attr->fw_ver);
+	bfa_ioc_get_adapter_optrom_ver(ioc, ad_attr->optrom_ver);
+	bfa_ioc_get_adapter_manufacturer(ioc, ad_attr->manufacturer);
 	bfa_os_memcpy(&ad_attr->vpd, &ioc_attr->vpd,
 		      sizeof(struct bfa_mfg_vpd_s));
 
-	ad_attr->nports = BFI_ADAPTER_GETP(NPORTS, ioc_attr->adapter_prop);
-	ad_attr->max_speed = BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
+	ad_attr->nports = bfa_ioc_get_nports(ioc);
+	ad_attr->max_speed = bfa_ioc_speed_sup(ioc);
 
-	/**
-	 * model name
-	 */
-	if (BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop) == 10) {
-		strcpy(model, "BR-10?0");
-		model[5] = '0' + ad_attr->nports;
-	} else {
-		strcpy(model, "Brocade-??5");
-		model[8] =
-			'0' + BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
-		model[9] = '0' + ad_attr->nports;
-	}
+	bfa_ioc_get_adapter_model(ioc, ad_attr->model);
+	/* For now, model descr uses same model string */
+	bfa_ioc_get_adapter_model(ioc, ad_attr->model_descr);
 
 	if (BFI_ADAPTER_IS_SPECIAL(ioc_attr->adapter_prop))
 		ad_attr->prototype = 1;
 	else
 		ad_attr->prototype = 0;
 
-	bfa_os_memcpy(&ad_attr->model, model, BFA_ADAPTER_MODEL_NAME_LEN);
-	bfa_os_memcpy(&ad_attr->model_descr, &ad_attr->model,
-		      BFA_ADAPTER_MODEL_NAME_LEN);
-
 	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
-	ad_attr->mac = bfa_ioc_get_mac(ioc);
+	ad_attr->mac  = bfa_ioc_get_mac(ioc);
 
 	ad_attr->pcie_gen = ioc_attr->pcie_gen;
 	ad_attr->pcie_lanes = ioc_attr->pcie_lanes;
 	ad_attr->pcie_lanes_orig = ioc_attr->pcie_lanes_orig;
 	ad_attr->asic_rev = ioc_attr->asic_rev;
-	ad_attr->hw_ver[0] = 'R';
-	ad_attr->hw_ver[1] = 'e';
-	ad_attr->hw_ver[2] = 'v';
-	ad_attr->hw_ver[3] = '-';
-	ad_attr->hw_ver[4] = ioc_attr->asic_rev;
-	ad_attr->hw_ver[5] = '\0';
+
+	bfa_ioc_get_pci_chip_rev(ioc, ad_attr->hw_ver);
 
 	ad_attr->cna_capable = ioc->cna;
 }
 
+enum bfa_ioc_type_e
+bfa_ioc_get_type(struct bfa_ioc_s *ioc)
+{
+	if (!ioc->ctdev || ioc->fcmode)
+		return BFA_IOC_TYPE_FC;
+	else if (ioc->ioc_mc == BFI_MC_IOCFC)
+		return BFA_IOC_TYPE_FCoE;
+	else if (ioc->ioc_mc == BFI_MC_LL)
+		return BFA_IOC_TYPE_LL;
+	else {
+		bfa_assert(ioc->ioc_mc == BFI_MC_LL);
+		return BFA_IOC_TYPE_LL;
+	}
+}
+
+void
+bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
+{
+	bfa_os_memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
+	bfa_os_memcpy((void *)serial_num,
+			(void *)ioc->attr->brcd_serialnum,
+			BFA_ADAPTER_SERIAL_NUM_LEN);
+}
+
+void
+bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver)
+{
+	bfa_os_memset((void *)fw_ver, 0, BFA_VERSION_LEN);
+	bfa_os_memcpy(fw_ver, ioc->attr->fw_version, BFA_VERSION_LEN);
+}
+
+void
+bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev)
+{
+	bfa_assert(chip_rev);
+
+	bfa_os_memset((void *)chip_rev, 0, BFA_IOC_CHIP_REV_LEN);
+
+	chip_rev[0] = 'R';
+	chip_rev[1] = 'e';
+	chip_rev[2] = 'v';
+	chip_rev[3] = '-';
+	chip_rev[4] = ioc->attr->asic_rev;
+	chip_rev[5] = '\0';
+}
+
+void
+bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver)
+{
+	bfa_os_memset((void *)optrom_ver, 0, BFA_VERSION_LEN);
+	bfa_os_memcpy(optrom_ver, ioc->attr->optrom_version,
+		      BFA_VERSION_LEN);
+}
+
+void
+bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
+{
+	bfa_os_memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
+	bfa_os_memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+}
+
+void
+bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
+{
+	struct bfi_ioc_attr_s	*ioc_attr;
+	u8		nports;
+	u8		max_speed;
+
+	bfa_assert(model);
+	bfa_os_memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
+
+	ioc_attr = ioc->attr;
+
+	nports = bfa_ioc_get_nports(ioc);
+	max_speed = bfa_ioc_speed_sup(ioc);
+
+	/**
+	 * model name
+	 */
+	if (max_speed == 10) {
+		strcpy(model, "BR-10?0");
+		model[5] = '0' + nports;
+	} else {
+		strcpy(model, "Brocade-??5");
+		model[8] = '0' + max_speed;
+		model[9] = '0' + nports;
+	}
+}
+
+enum bfa_ioc_state
+bfa_ioc_get_state(struct bfa_ioc_s *ioc)
+{
+	return bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+}
+
 void
 bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 {
 	bfa_os_memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
 
-	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	ioc_attr->state = bfa_ioc_get_state(ioc);
 	ioc_attr->port_id = ioc->port_id;
 
-	if (!ioc->ctdev)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_FC;
-	else if (ioc->ioc_mc == BFI_MC_IOCFC)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_FCoE;
-	else if (ioc->ioc_mc == BFI_MC_LL)
-		ioc_attr->ioc_type = BFA_IOC_TYPE_LL;
+	ioc_attr->ioc_type = bfa_ioc_get_type(ioc);
 
 	bfa_ioc_get_adapter_attr(ioc, &ioc_attr->adapter_attr);
 
 	ioc_attr->pci_attr.device_id = ioc->pcidev.device_id;
 	ioc_attr->pci_attr.pcifn = ioc->pcidev.pci_func;
-	ioc_attr->pci_attr.chip_rev[0] = 'R';
-	ioc_attr->pci_attr.chip_rev[1] = 'e';
-	ioc_attr->pci_attr.chip_rev[2] = 'v';
-	ioc_attr->pci_attr.chip_rev[3] = '-';
-	ioc_attr->pci_attr.chip_rev[4] = ioc_attr->adapter_attr.asic_rev;
-	ioc_attr->pci_attr.chip_rev[5] = '\0';
+	bfa_ioc_get_pci_chip_rev(ioc, ioc_attr->pci_attr.chip_rev);
 }
 
 /**
- *  hal_wwn_public
+ *  bfa_wwn_public
  */
 wwn_t
 bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
 {
 	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w;
+		wwn_t	wwn;
+		u8	byte[sizeof(wwn_t)];
+	} w;
 
 	w.wwn = ioc->attr->mfg_wwn;
 
@@ -2125,10 +1847,9 @@ wwn_t
 bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
 {
 	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w;
+		wwn_t	wwn;
+		u8	byte[sizeof(wwn_t)];
+	} w;
 
 	w.wwn = ioc->attr->mfg_wwn;
 
@@ -2144,10 +1865,9 @@ wwn_t
 bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst)
 {
 	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w              , w5;
+		wwn_t		wwn;
+		u8		byte[sizeof(wwn_t)];
+	} w, w5;
 
 	bfa_trc(ioc, inst);
 
@@ -2170,10 +1890,10 @@ bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
 	return ioc->attr->mfg_wwn;
 }
 
-mac_t
+struct mac_s
 bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 {
-	mac_t           mac;
+	struct mac_s	mac;
 
 	mac = ioc->attr->mfg_mac;
 	mac.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
@@ -2184,7 +1904,7 @@ bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
 {
-	ioc->fcmode = BFA_TRUE;
+	ioc->fcmode  = BFA_TRUE;
 	ioc->port_id = bfa_ioc_pcifn(ioc);
 }
 
@@ -2195,63 +1915,22 @@ bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Return true if interrupt should be claimed.
- */
-bfa_boolean_t
-bfa_ioc_intx_claim(struct bfa_ioc_s *ioc)
-{
-	u32        isr, msk;
-
-	/**
-	 * Always claim if not catapult.
-	 */
-	if (!ioc->ctdev)
-		return BFA_TRUE;
-
-	/**
-	 * FALSE if next device is claiming interrupt.
-	 * TRUE if next device is not interrupting or not present.
-	 */
-	msk = bfa_reg_read(ioc->ioc_regs.shirq_msk_next);
-	isr = bfa_reg_read(ioc->ioc_regs.shirq_isr_next);
-	return !(isr & ~msk);
-}
-
-/**
  * Send AEN notification
  */
 static void
 bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 {
-	union bfa_aen_data_u aen_data;
+	union bfa_aen_data_u  aen_data;
 	struct bfa_log_mod_s *logmod = ioc->logm;
-	s32         inst_num = 0;
-	struct bfa_ioc_attr_s ioc_attr;
+	s32	inst_num = 0;
+	enum bfa_ioc_type_e ioc_type;
 
-	switch (event) {
-	case BFA_IOC_AEN_HBGOOD:
-		bfa_log(logmod, BFA_AEN_IOC_HBGOOD, inst_num);
-		break;
-	case BFA_IOC_AEN_HBFAIL:
-		bfa_log(logmod, BFA_AEN_IOC_HBFAIL, inst_num);
-		break;
-	case BFA_IOC_AEN_ENABLE:
-		bfa_log(logmod, BFA_AEN_IOC_ENABLE, inst_num);
-		break;
-	case BFA_IOC_AEN_DISABLE:
-		bfa_log(logmod, BFA_AEN_IOC_DISABLE, inst_num);
-		break;
-	case BFA_IOC_AEN_FWMISMATCH:
-		bfa_log(logmod, BFA_AEN_IOC_FWMISMATCH, inst_num);
-		break;
-	default:
-		break;
-	}
+	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, event), inst_num);
 
 	memset(&aen_data.ioc.pwwn, 0, sizeof(aen_data.ioc.pwwn));
 	memset(&aen_data.ioc.mac, 0, sizeof(aen_data.ioc.mac));
-	bfa_ioc_get_attr(ioc, &ioc_attr);
-	switch (ioc_attr.ioc_type) {
+	ioc_type = bfa_ioc_get_type(ioc);
+	switch (ioc_type) {
 	case BFA_IOC_TYPE_FC:
 		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
 		break;
@@ -2263,10 +1942,10 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
 		break;
 	default:
-		bfa_assert(ioc_attr.ioc_type == BFA_IOC_TYPE_FC);
+		bfa_assert(ioc_type == BFA_IOC_TYPE_FC);
 		break;
 	}
-	aen_data.ioc.ioc_type = ioc_attr.ioc_type;
+	aen_data.ioc.ioc_type = ioc_type;
 }
 
 /**
@@ -2275,7 +1954,7 @@ bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 bfa_status_t
 bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 {
-	int             tlen;
+	int	tlen;
 
 	if (ioc->dbg_fwsave_len == 0)
 		return BFA_STATUS_ENOFSAVE;
@@ -2290,20 +1969,36 @@ bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 }
 
 /**
+ * Clear saved firmware trace
+ */
+void
+bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc)
+{
+	ioc->dbg_fwsave_once = BFA_TRUE;
+}
+
+/**
  * Retrieve saved firmware trace from a prior IOC failure.
  */
 bfa_status_t
 bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 {
-	u32        pgnum;
-	u32        loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
-	int             i, tlen;
-	u32       *tbuf = trcdata, r32;
+	u32 pgnum;
+	u32 loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
+	int i, tlen;
+	u32 *tbuf = trcdata, r32;
 
 	bfa_trc(ioc, *trclen);
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	loff = bfa_ioc_smem_pgoff(ioc, loff);
+
+	/*
+	 *  Hold semaphore to serialize pll init and fwtrc.
+	 */
+	if (BFA_FALSE == bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg))
+		return BFA_STATUS_FAILED;
+
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
 
 	tlen = *trclen;
@@ -2324,11 +2019,18 @@ bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+				      pgnum);
 		}
 	}
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
 		      bfa_ioc_smem_pgnum(ioc, 0));
+
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
 	bfa_trc(ioc, pgnum);
 
 	*trclen = tlen * sizeof(u32);
@@ -2341,7 +2043,7 @@ bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 static void
 bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
 {
-	int             tlen;
+	int		tlen;
 
 	if (ioc->dbg_fwsave_len) {
 		tlen = ioc->dbg_fwsave_len;
@@ -2368,8 +2070,7 @@ bfa_ioc_recover(struct bfa_ioc_s *ioc)
 
 static void
 bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
-{
-}
+{ }
 
 static void
 bfa_ioc_recover(struct bfa_ioc_s *ioc)
-- 
1.6.5.2

