From: <kgudipat@brocade.com>
Subject: [PATCH 18/23] bfa: Modified the portstats get/clear logic
Date: Fri, 5 Mar 2010 19:38:07 -0800
Message-ID: <1267846687-23371-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:55947 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0CFDiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:38:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Modified the portstats get/clear logic for port physical/FCoE/QoS stats.
	- Added more stats to FC
	- Fixed some issues with FCoE stats collection.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c                  |  732 ++++++++----------------
 drivers/scsi/bfa/bfa_port_priv.h               |   41 +-
 drivers/scsi/bfa/bfad_attr.c                   |    5 +-
 drivers/scsi/bfa/include/bfa_svc.h             |   26 +-
 drivers/scsi/bfa/include/bfi/bfi.h             |    4 +-
 drivers/scsi/bfa/include/bfi/bfi_pport.h       |  177 ++----
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h |  128 +++--
 7 files changed, 406 insertions(+), 707 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 0da6120..d109e65 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -47,16 +47,10 @@ static void     bfa_fcport_callback(struct bfa_fcport_s *fcport,
 				enum bfa_pport_linkstate event);
 static void     bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln,
 				enum bfa_pport_linkstate event);
-static void     __bfa_cb_fcport_stats(void *cbarg, bfa_boolean_t complete);
 static void     __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete);
-static void     bfa_fcport_stats_timeout(void *cbarg);
+static void     bfa_fcport_stats_get_timeout(void *cbarg);
 static void     bfa_fcport_stats_clr_timeout(void *cbarg);
 
-static void     __bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete);
-static void     __bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete);
-static void     bfa_port_stats_timeout(void *cbarg);
-static void     bfa_port_stats_clr_timeout(void *cbarg);
-
 /**
  *  bfa_pport_private
  */
@@ -303,7 +297,7 @@ static void
 bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 			enum bfa_fcport_sm_event event)
 {
-	struct bfi_pport_event_s *pevent = fcport->event_arg.i2hmsg.event;
+	struct bfi_fcport_event_s *pevent = fcport->event_arg.i2hmsg.event;
 	bfa_trc(fcport->bfa, event);
 
 	switch (event) {
@@ -819,8 +813,32 @@ __bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete)
 		bfa_sm_send_event(ln, BFA_FCPORT_LN_SM_NOTIFICATION);
 }
 
-#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
-							BFA_CACHELINE_SZ))
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
+}
 
 #define FCPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
 							BFA_CACHELINE_SZ))
@@ -829,8 +847,7 @@ static void
 bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
 		  u32 *dm_len)
 {
-	*dm_len += PPORT_STATS_DMA_SZ;
-	*dm_len += PPORT_STATS_DMA_SZ;
+	*dm_len += FCPORT_STATS_DMA_SZ;
 }
 
 static void
@@ -852,16 +869,7 @@ bfa_fcport_mem_claim(struct bfa_fcport_s *fcport, struct bfa_meminfo_s *meminfo)
 
 	fcport->stats_kva = dm_kva;
 	fcport->stats_pa = dm_pa;
-	fcport->stats = (union bfa_pport_stats_u *)dm_kva;
-
-	dm_kva += PPORT_STATS_DMA_SZ;
-	dm_pa += PPORT_STATS_DMA_SZ;
-
-	/* FC port stats */
-
-	fcport->fcport_stats_kva = dm_kva;
-	fcport->fcport_stats_pa = dm_pa;
-	fcport->fcport_stats = (union bfa_fcport_stats_u *) dm_kva;
+	fcport->stats = (union bfa_fcport_stats_u *)dm_kva;
 
 	dm_kva += FCPORT_STATS_DMA_SZ;
 	dm_pa += FCPORT_STATS_DMA_SZ;
@@ -957,7 +965,7 @@ bfa_fcport_iocdisable(struct bfa_s *bfa)
 static void
 bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 {
-	struct bfi_pport_event_s *pevent = fcport->event_arg.i2hmsg.event;
+	struct bfi_fcport_event_s *pevent = fcport->event_arg.i2hmsg.event;
 
 	fcport->speed = pevent->link_state.speed;
 	fcport->topology = pevent->link_state.topology;
@@ -989,7 +997,7 @@ bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport)
 static          bfa_boolean_t
 bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 {
-	struct bfi_pport_enable_req_s *m;
+	struct bfi_fcport_enable_req_s *m;
 
 	/**
 	 * Increment message tag before queue check, so that responses to old
@@ -1007,15 +1015,14 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 		return BFA_FALSE;
 	}
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_ENABLE_REQ,
-		    bfa_lpuid(fcport->bfa));
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_ENABLE_REQ,
+				bfa_lpuid(fcport->bfa));
 	m->nwwn = fcport->nwwn;
 	m->pwwn = fcport->pwwn;
 	m->port_cfg = fcport->cfg;
 	m->msgtag = fcport->msgtag;
 	m->port_cfg.maxfrsize = bfa_os_htons(fcport->cfg.maxfrsize);
 	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
-	bfa_dma_be_addr_set(m->fcport_stats_dma_addr, fcport->fcport_stats_pa);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
 
@@ -1032,7 +1039,7 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 static          bfa_boolean_t
 bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 {
-	bfi_pport_disable_req_t *m;
+	struct bfi_fcport_req_s *m;
 
 	/**
 	 * Increment message tag before queue check, so that responses to old
@@ -1050,8 +1057,8 @@ bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 		return BFA_FALSE;
 	}
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_DISABLE_REQ,
-		    bfa_lpuid(fcport->bfa));
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_DISABLE_REQ,
+			bfa_lpuid(fcport->bfa));
 	m->msgtag = fcport->msgtag;
 
 	/**
@@ -1077,7 +1084,7 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 {
 
 	struct bfa_fcport_s *fcport = port_cbarg;
-	struct bfi_pport_set_svc_params_req_s *m;
+	struct bfi_fcport_set_svc_params_req_s *m;
 
 	/**
 	 * check for room in queue to send request now
@@ -1088,8 +1095,8 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 		return;
 	}
 
-	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_SET_SVC_PARAMS_REQ,
-		    bfa_lpuid(fcport->bfa));
+	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ,
+			bfa_lpuid(fcport->bfa));
 	m->tx_bbcredit = bfa_os_htons((u16) fcport->cfg.tx_bbcredit);
 
 	/**
@@ -1098,7 +1105,158 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 }
 
+static void
+bfa_fcport_qos_stats_swap(struct bfa_qos_stats_s *d,
+	struct bfa_qos_stats_s *s)
+{
+	u32     *dip = (u32 *) d;
+	u32     *sip = (u32 *) s;
+	int             i;
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
+	u32     *dip = (u32 *) d;
+	u32     *sip = (u32 *) s;
+	int             i;
+
+	for (i = 0; i < ((sizeof(struct bfa_fcoe_stats_s))/sizeof(u32));
+		i = i + 2) {
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
+		bfa_lpuid(fcport->bfa));
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
 
+	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		fcport->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&fcport->stats_reqq_wait,
+				bfa_fcport_send_stats_clear, fcport);
+		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
+				&fcport->stats_reqq_wait);
+		return;
+	}
+	fcport->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(struct bfi_fcport_req_s));
+	bfi_h2i_set(msg->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_STATS_CLEAR_REQ,
+			bfa_lpuid(fcport->bfa));
+	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
+}
 
 /**
  *  bfa_pport_public
@@ -1111,23 +1269,23 @@ void
 bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	union bfi_pport_i2h_msg_u i2hmsg;
+	union bfi_fcport_i2h_msg_u i2hmsg;
 
 	i2hmsg.msg = msg;
 	fcport->event_arg.i2hmsg = i2hmsg;
 
 	switch (msg->mhdr.msg_id) {
-	case BFI_PPORT_I2H_ENABLE_RSP:
-		if (fcport->msgtag == i2hmsg.enable_rsp->msgtag)
+	case BFI_FCPORT_I2H_ENABLE_RSP:
+		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
-	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.enable_rsp->msgtag)
+	case BFI_FCPORT_I2H_DISABLE_RSP:
+		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
-	case BFI_PPORT_I2H_EVENT:
+	case BFI_FCPORT_I2H_EVENT:
 		switch (i2hmsg.event->link_state.linkstate) {
 		case BFA_PPORT_LINKUP:
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_LINKUP);
@@ -1141,58 +1299,27 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		}
 		break;
 
-	case BFI_PPORT_I2H_GET_STATS_RSP:
-	case BFI_PPORT_I2H_GET_QOS_STATS_RSP:
-		/*
-		 * check for timer pop before processing the rsp
-		 */
-		if (fcport->stats_busy == BFA_FALSE
-		    || fcport->stats_status == BFA_STATUS_ETIMER)
-			break;
-
-		bfa_timer_stop(&fcport->timer);
-		fcport->stats_status = i2hmsg.getstats_rsp->status;
-		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_port_stats,
-			     fcport);
-		break;
-	case BFI_PPORT_I2H_CLEAR_STATS_RSP:
-	case BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP:
-		/*
-		 * check for timer pop before processing the rsp
-		 */
-		if (fcport->stats_busy == BFA_FALSE
-		    || fcport->stats_status == BFA_STATUS_ETIMER)
-			break;
-
-		bfa_timer_stop(&fcport->timer);
-		fcport->stats_status = BFA_STATUS_OK;
-		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
-			     __bfa_cb_port_stats_clr, fcport);
-		break;
-
-	case BFI_FCPORT_I2H_GET_STATS_RSP:
+	case BFI_FCPORT_I2H_STATS_GET_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
 		if (fcport->stats_busy == BFA_FALSE ||
-			fcport->stats_status == BFA_STATUS_ETIMER) {
+			fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
-		}
 
 		bfa_timer_stop(&fcport->timer);
-		fcport->stats_status = i2hmsg.getstats_rsp->status;
+		fcport->stats_status = i2hmsg.pstatsget_rsp->status;
 		bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
-				__bfa_cb_fcport_stats, fcport);
+				__bfa_cb_fcport_stats_get, fcport);
 		break;
 
-	case BFI_FCPORT_I2H_CLEAR_STATS_RSP:
+	case BFI_FCPORT_I2H_STATS_CLEAR_RSP:
 		/*
 		 * check for timer pop before processing the rsp
 		 */
 		if (fcport->stats_busy == BFA_FALSE ||
-			fcport->stats_status == BFA_STATUS_ETIMER) {
+			fcport->stats_status == BFA_STATUS_ETIMER)
 			break;
-		}
 
 		bfa_timer_stop(&fcport->timer);
 		fcport->stats_status = BFA_STATUS_OK;
@@ -1206,8 +1333,6 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 	}
 }
 
-
-
 /**
  *  bfa_pport_api
  */
@@ -1472,329 +1597,13 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
 		attr->port_state = BFA_PPORT_ST_FWMISMATCH;
 }
 
-static void
-bfa_port_stats_query(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
-	bfi_pport_get_stats_req_t *msg;
-
-	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		fcport->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&fcport->stats_reqq_wait, bfa_port_stats_query,
-			       fcport);
-		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
-				&fcport->stats_reqq_wait);
-		return;
-	}
-	fcport->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
-		    bfa_lpuid(fcport->bfa));
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-}
-
-static void
-bfa_port_stats_clear(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
-	bfi_pport_clear_stats_req_t *msg;
-
-	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		fcport->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&fcport->stats_reqq_wait, bfa_port_stats_clear,
-			       fcport);
-		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
-					&fcport->stats_reqq_wait);
-		return;
-	}
-	fcport->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
-		    bfa_lpuid(fcport->bfa));
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-}
-
-static void
-bfa_fcport_stats_query(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
-	bfi_pport_get_stats_req_t *msg;
-
-	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		fcport->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&fcport->stats_reqq_wait,
-			bfa_fcport_stats_query, fcport);
-		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
-			&fcport->stats_reqq_wait);
-		return;
-	}
-	fcport->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_FCPORT_H2I_GET_STATS_REQ,
-		bfa_lpuid(fcport->bfa));
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-}
-
-static void
-bfa_fcport_stats_clear(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
-	bfi_pport_clear_stats_req_t *msg;
-
-	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		fcport->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&fcport->stats_reqq_wait,
-			bfa_fcport_stats_clear, fcport);
-		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
-			&fcport->stats_reqq_wait);
-		return;
-	}
-	fcport->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_FCPORT_H2I_CLEAR_STATS_REQ,
-		bfa_lpuid(fcport->bfa));
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-}
-
-static void
-bfa_port_qos_stats_clear(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
-	bfi_pport_clear_qos_stats_req_t *msg;
-
-	msg = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
-
-	if (!msg) {
-		fcport->stats_qfull = BFA_TRUE;
-		bfa_reqq_winit(&fcport->stats_reqq_wait,
-			bfa_port_qos_stats_clear, fcport);
-		bfa_reqq_wait(fcport->bfa, BFA_REQQ_PORT,
-				&fcport->stats_reqq_wait);
-		return;
-	}
-	fcport->stats_qfull = BFA_FALSE;
-
-	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_qos_stats_req_t));
-	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
-		    bfa_lpuid(fcport->bfa));
-	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
-}
-
-static void
-bfa_fcport_stats_swap(union bfa_fcport_stats_u *d, union bfa_fcport_stats_u *s)
-{
-	u32        *dip = (u32 *) d;
-	u32        *sip = (u32 *) s;
-	int             i;
-
-	/* Do 64 bit fields swap first */
-	for (i = 0; i < ((sizeof(union bfa_fcport_stats_u) -
-			sizeof(struct bfa_qos_stats_s))/sizeof(u32)); i = i + 2) {
-#ifdef __BIGENDIAN
-		dip[i] = bfa_os_ntohl(sip[i]);
-		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
-#else
-		dip[i] = bfa_os_ntohl(sip[i + 1]);
-		dip[i + 1] = bfa_os_ntohl(sip[i]);
-#endif
-	}
-
-	/* Now swap the 32 bit fields */
-	for (; i < (sizeof(union bfa_fcport_stats_u)/sizeof(u32)); ++i)
-		dip[i] = bfa_os_ntohl(sip[i]);
-}
-
-static void
-bfa_port_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
-{
-	u32    *dip = (u32 *) d;
-	u32    *sip = (u32 *) s;
-	int     i;
-
-	/* Do 64 bit fields swap first */
-	for (i = 0; i < (sizeof(union bfa_pport_stats_u) / sizeof(u32));
-		i = i + 2) {
-#ifdef __BIGENDIAN
-		dip[i] = bfa_os_ntohl(sip[i]);
-		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
-#else
-		dip[i] = bfa_os_ntohl(sip[i + 1]);
-		dip[i + 1] = bfa_os_ntohl(sip[i]);
-#endif
-	}
-}
-
-static void
-__bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete)
-{
-	struct bfa_fcport_s *fcport = cbarg;
-
-	if (complete) {
-		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
-	} else {
-		fcport->stats_busy = BFA_FALSE;
-		fcport->stats_status = BFA_STATUS_OK;
-	}
-}
-
-static void
-__bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
-{
-	struct bfa_fcport_s *fcport = cbarg;
-
-	if (complete) {
-		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
-	} else {
-		fcport->stats_busy = BFA_FALSE;
-		fcport->stats_status = BFA_STATUS_OK;
-	}
-}
-
-static void
-bfa_port_stats_clr_timeout(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
-
-	bfa_trc(fcport->bfa, fcport->stats_qfull);
-
-	if (fcport->stats_qfull) {
-		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
-		fcport->stats_qfull = BFA_FALSE;
-	}
-
-	fcport->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe,
-				__bfa_cb_port_stats_clr, fcport);
-}
-
-static void
-bfa_fcport_callback(struct bfa_fcport_s *fcport, enum bfa_pport_linkstate event)
-{
-	if (fcport->bfa->fcs) {
-		fcport->event_cbfn(fcport->event_cbarg, event);
-		return;
-	}
-
-	switch (event) {
-	case BFA_PPORT_LINKUP:
-		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKUP);
-		break;
-	case BFA_PPORT_LINKDOWN:
-		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKDOWN);
-		break;
-	default:
-		bfa_assert(0);
-	}
-}
-
-static void
-bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln, enum bfa_pport_linkstate event)
-{
-	ln->ln_event = event;
-	bfa_cb_queue(ln->fcport->bfa, &ln->ln_qe, __bfa_cb_fcport_event, ln);
-}
-
-static void
-bfa_fcport_stats_clr_timeout(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
-
-	bfa_trc(fcport->bfa, fcport->stats_qfull);
-
-	if (fcport->stats_qfull) {
-		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
-		fcport->stats_qfull = BFA_FALSE;
-	}
-
-	fcport->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_fcport_stats_clr,
-			fcport);
-}
-
-static void
-__bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete)
-{
-	struct bfa_fcport_s *fcport = cbarg;
-
-	if (complete) {
-		if (fcport->stats_status == BFA_STATUS_OK)
-			bfa_port_stats_swap(fcport->stats_ret, fcport->stats);
-		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
-	} else {
-		fcport->stats_busy = BFA_FALSE;
-		fcport->stats_status = BFA_STATUS_OK;
-	}
-}
-
-static void
-bfa_port_stats_timeout(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *)cbarg;
-
-	bfa_trc(fcport->bfa, fcport->stats_qfull);
-
-	if (fcport->stats_qfull) {
-		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
-		fcport->stats_qfull = BFA_FALSE;
-	}
-
-	fcport->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_port_stats, fcport);
-}
-
-static void
-__bfa_cb_fcport_stats(void *cbarg, bfa_boolean_t complete)
-{
-	struct bfa_fcport_s *fcport = cbarg;
-
-	if (complete) {
-		if (fcport->stats_status == BFA_STATUS_OK) {
-			bfa_fcport_stats_swap(fcport->fcport_stats_ret,
-				fcport->fcport_stats);
-		}
-		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
-	} else {
-		fcport->stats_busy = BFA_FALSE;
-		fcport->stats_status = BFA_STATUS_OK;
-	}
-}
-
-static void
-bfa_fcport_stats_timeout(void *cbarg)
-{
-	struct bfa_fcport_s *fcport = (struct bfa_fcport_s *) cbarg;
-
-	bfa_trc(fcport->bfa, fcport->stats_qfull);
-
-	if (fcport->stats_qfull) {
-		bfa_reqq_wcancel(&fcport->stats_reqq_wait);
-		fcport->stats_qfull = BFA_FALSE;
-	}
-
-	fcport->stats_status = BFA_STATUS_ETIMER;
-	bfa_cb_queue(fcport->bfa, &fcport->hcb_qe, __bfa_cb_fcport_stats,
-			fcport);
-}
-
-#define BFA_PORT_STATS_TOV	1000
+#define BFA_FCPORT_STATS_TOV	1000
 
 /**
- * Fetch port attributes.
+ * Fetch port attributes (FCQoS or FCoE).
  */
 bfa_status_t
-bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
+bfa_fcport_get_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
 		    bfa_cb_pport_t cbfn, void *cbarg)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -1804,20 +1613,23 @@ bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
 		return BFA_STATUS_DEVBUSY;
 	}
 
-	fcport->stats_busy = BFA_TRUE;
-	fcport->stats_ret = stats;
-	fcport->stats_cbfn = cbfn;
+	fcport->stats_busy  = BFA_TRUE;
+	fcport->stats_ret   = stats;
+	fcport->stats_cbfn  = cbfn;
 	fcport->stats_cbarg = cbarg;
 
-	bfa_port_stats_query(fcport);
+	bfa_fcport_send_stats_get(fcport);
 
-	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_timeout, fcport,
-			BFA_PORT_STATS_TOV);
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_get_timeout,
+		fcport, BFA_FCPORT_STATS_TOV);
 	return BFA_STATUS_OK;
 }
 
+/**
+ * Reset port statistics (FCQoS or FCoE).
+ */
 bfa_status_t
-bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
@@ -1830,65 +1642,61 @@ bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 	fcport->stats_cbfn = cbfn;
 	fcport->stats_cbarg = cbarg;
 
-	bfa_port_stats_clear(fcport);
+	bfa_fcport_send_stats_clear(fcport);
 
-	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_clr_timeout,
-			fcport, BFA_PORT_STATS_TOV);
+	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_clr_timeout,
+			fcport, BFA_FCPORT_STATS_TOV);
 	return BFA_STATUS_OK;
 }
 
 /**
- * @brief
- * Fetch FCPort statistics.
- * Todo TBD: sharing timer,stats_busy and other resources of fcport for now -
- * ideally we want to create seperate ones for fcport once bfa_fcport_s is
- * decided.
- *
+ * Fetch FCQoS port statistics
  */
 bfa_status_t
-bfa_fcport_get_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
-		bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+	bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	if (fcport->stats_busy) {
-		bfa_trc(bfa, fcport->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
-
-	fcport->stats_busy = BFA_TRUE;
-	fcport->fcport_stats_ret = stats;
-	fcport->stats_cbfn = cbfn;
-	fcport->stats_cbarg = cbarg;
+	/* Meaningful only for FC mode */
+	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
 
-	bfa_fcport_stats_query(fcport);
-
-	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_timeout, fcport,
-			BFA_PORT_STATS_TOV);
-
-	return BFA_STATUS_OK;
+	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
+/**
+ * Reset FCoE port statistics
+ */
 bfa_status_t
-bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
 {
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+	/* Meaningful only for FC mode */
+	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
 
-	if (fcport->stats_busy) {
-		bfa_trc(bfa, fcport->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
+	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
+}
 
-	fcport->stats_busy = BFA_TRUE;
-	fcport->stats_cbfn = cbfn;
-	fcport->stats_cbarg = cbarg;
+/**
+ * Fetch FCQoS port statistics
+ */
+bfa_status_t
+bfa_fcport_get_fcoe_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
+	bfa_cb_pport_t cbfn, void *cbarg)
+{
+	/* Meaningful only for FCoE mode */
+	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
 
-	bfa_fcport_stats_clear(fcport);
+	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
+}
 
-	bfa_timer_start(bfa, &fcport->timer, bfa_fcport_stats_clr_timeout,
-			fcport, BFA_PORT_STATS_TOV);
+/**
+ * Reset FCoE port statistics
+ */
+bfa_status_t
+bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	/* Meaningful only for FCoE mode */
+	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
 
-	return BFA_STATUS_OK;
+	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
 }
 
 bfa_status_t
@@ -1946,40 +1754,6 @@ bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 }
 
 /**
- * Fetch QoS Stats.
- */
-bfa_status_t
-bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
-			bfa_cb_pport_t cbfn, void *cbarg)
-{
-	/*
-	 * QoS stats is embedded in port stats
-	 */
-	return bfa_pport_get_stats(bfa, stats, cbfn, cbarg);
-}
-
-bfa_status_t
-bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	if (fcport->stats_busy) {
-		bfa_trc(bfa, fcport->stats_busy);
-		return BFA_STATUS_DEVBUSY;
-	}
-
-	fcport->stats_busy = BFA_TRUE;
-	fcport->stats_cbfn = cbfn;
-	fcport->stats_cbarg = cbarg;
-
-	bfa_port_qos_stats_clear(fcport);
-
-	bfa_timer_start(bfa, &fcport->timer, bfa_port_stats_clr_timeout,
-			fcport, BFA_PORT_STATS_TOV);
-	return BFA_STATUS_OK;
-}
-
-/**
  * Fetch port attributes.
  */
 bfa_status_t
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
index 6d315ff..40e256e 100644
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ b/drivers/scsi/bfa/bfa_port_priv.h
@@ -46,6 +46,8 @@ struct bfa_fcport_s {
 	enum bfa_pport_topology topology;	/*  current topology */
 	u8			myalpa;	/*  my ALPA in LOOP topology */
 	u8			rsvd[3];
+	u32             mypid:24;
+	u32             rsvd_b:8;
 	struct bfa_pport_cfg_s	cfg;	/*  current port configuration */
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
 	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
@@ -59,40 +61,25 @@ struct bfa_fcport_s {
 	void			(*event_cbfn) (void *cbarg,
 						bfa_pport_event_t event);
 	union {
-		union bfi_pport_i2h_msg_u i2hmsg;
+		union bfi_fcport_i2h_msg_u i2hmsg;
 	} event_arg;
 	void			*bfad;	/*  BFA driver handle */
 	struct bfa_fcport_ln_s   ln; /* Link Notification */
 	struct bfa_cb_qe_s		hcb_qe;	/*  BFA callback queue elem */
+	struct bfa_timer_s      timer;  /*  timer */
 	u32		msgtag;	/*  fimrware msg tag for reply */
 	u8			*stats_kva;
 	u64		stats_pa;
-	union bfa_pport_stats_u *stats;	/*  pport stats */
-	u32		mypid:24;
-	u32		rsvd_b:8;
-	struct bfa_timer_s 	timer;	/*  timer */
-	union bfa_pport_stats_u 	*stats_ret;
-					/*  driver stats location */
-	bfa_status_t		stats_status;
-					/*  stats/statsclr status */
-	bfa_boolean_t   	stats_busy;
-					/*  outstanding stats/statsclr */
-	bfa_boolean_t   	stats_qfull;
-	bfa_boolean_t   	diag_busy;
-					/*  diag busy status */
-	bfa_boolean_t   	beacon;
-					/*  port beacon status */
-	bfa_boolean_t   	link_e2e_beacon;
-					/*  link beacon status */
-	bfa_cb_pport_t		stats_cbfn;
-					/*  driver callback function */
-	void			*stats_cbarg;
-					/* *!< user callback arg */
-	/* FCport stats */
-	u8         *fcport_stats_kva;
-	u64        fcport_stats_pa;
-	union bfa_fcport_stats_u *fcport_stats;
-	union bfa_fcport_stats_u *fcport_stats_ret;
+	union bfa_fcport_stats_u *stats;
+	union bfa_fcport_stats_u *stats_ret; /*  driver stats location */
+	bfa_status_t            stats_status; /*  stats/statsclr status */
+	bfa_boolean_t           stats_busy; /*  outstanding stats/statsclr */
+	bfa_boolean_t           stats_qfull;
+	bfa_cb_pport_t          stats_cbfn; /*  driver callback function */
+	void                    *stats_cbarg; /* *!< user callback arg */
+	bfa_boolean_t           diag_busy; /*  diag busy status */
+	bfa_boolean_t           beacon; /*  port beacon status */
+	bfa_boolean_t           link_e2e_beacon; /*  link beacon status */
 };
 
 #define BFA_FCPORT_MOD(__bfa)	(&(__bfa)->modules.fcport)
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index dd5cb20..d97f691 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -288,7 +288,7 @@ bfad_im_get_stats(struct Scsi_Host *shost)
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	memset(hstats, 0, sizeof(struct fc_host_statistics));
-	rc = bfa_pport_get_stats(&bfad->bfa,
+	rc =  bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
 				     (union bfa_pport_stats_u *) hstats,
 				     bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -315,7 +315,8 @@ bfad_im_reset_stats(struct Scsi_Host *shost)
 
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rc = bfa_pport_clear_stats(&bfad->bfa, bfad_hcb_comp, &fcomp);
+	rc = bfa_port_clear_stats(BFA_FCPORT(&bfad->bfa), bfad_hcb_comp,
+		&fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	if (rc != BFA_STATUS_OK)
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 056cf20..1349b99 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -26,7 +26,7 @@ struct bfa_fcxp_s;
 #include <defs/bfa_defs_pport.h>
 #include <defs/bfa_defs_rport.h>
 #include <defs/bfa_defs_qos.h>
-#include <defs/bfa_defs_fcport.h> 
+#include <defs/bfa_defs_fcport.h>
 #include <cs/bfa_sm.h>
 #include <bfa.h>
 
@@ -36,7 +36,7 @@ struct bfa_fcxp_s;
 struct bfa_rport_info_s {
 	u16        max_frmsz;	/*  max rcv pdu size               */
 	u32        pid:24,		/*  remote port ID                 */
-			lp_tag:8;
+			lp_tag:8;	/*  tag                     */
 	u32        local_pid:24,	/*  local port ID		    */
 			cisc:8;		/*  CIRO supported		    */
 	u8         fc_class;	/*  supported FC classes. enum fc_cos */
@@ -55,7 +55,7 @@ struct bfa_rport_s {
 	void                  *rport_drv; /*  fcs/driver rport object */
 	u16              fw_handle; /*  firmware rport handle */
 	u16              rport_tag; /*  BFA rport tag */
-	struct bfa_rport_info_s rport_info; /*  rport info from *fcs/driver */
+	struct bfa_rport_info_s rport_info; /*  rport info from fcs/driver */
 	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
 	struct bfa_cb_qe_s    hcb_qe;	 /*  BFA callback qelem */
 	struct bfa_rport_hal_stats_s stats; /*  BFA rport statistics  */
@@ -102,7 +102,7 @@ struct bfa_uf_buf_s {
 struct bfa_uf_s {
 	struct list_head	qe;		/*  queue element	  */
 	struct bfa_s	*bfa;		/*  bfa instance	  */
-	u16        uf_tag;		/*  identifying tag f/w messages */
+	u16        uf_tag;		/*  identifying tag fw msgs     */
 	u16        vf_id;
 	u16        src_rport_handle;
 	u16        rsvd;
@@ -128,7 +128,7 @@ struct bfa_lps_s {
 	u8		reqq;		/*  lport request queue	*/
 	u8		alpa;		/*  ALPA for loop topologies	*/
 	u32	lp_pid;		/*  lport port ID		*/
-	bfa_boolean_t	fdisc;		/*  send FDISC instead of FLOGI*/
+	bfa_boolean_t	fdisc;		/*  send FDISC instead of FLOGI  */
 	bfa_boolean_t	auth_en;	/*  enable authentication	*/
 	bfa_boolean_t	auth_req;	/*  authentication required	*/
 	bfa_boolean_t	npiv_en;	/*  NPIV is allowed by peer	*/
@@ -178,11 +178,6 @@ bfa_status_t bfa_fcport_trunk_disable(struct bfa_s *bfa);
 bfa_boolean_t bfa_fcport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
 void bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
 wwn_t bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
-bfa_status_t bfa_pport_get_stats(struct bfa_s *bfa,
-			union bfa_pport_stats_u *stats,
-			bfa_cb_pport_t cbfn, void *cbarg);
-bfa_status_t bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
-			void *cbarg);
 void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			bfa_pport_event_t event), void *event_cbarg);
@@ -198,14 +193,21 @@ void bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status);
 void bfa_fcport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
 			bfa_boolean_t link_e2e_beacon);
 void bfa_cb_pport_event(void *cbarg, bfa_pport_event_t event);
-void bfa_fcport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
+void bfa_fcport_qos_get_attr(struct bfa_s *bfa,
+			struct bfa_qos_attr_s *qos_attr);
 void bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 			struct bfa_qos_vc_attr_s *qos_vc_attr);
 bfa_status_t bfa_fcport_get_qos_stats(struct bfa_s *bfa,
-			union bfa_pport_stats_u *stats,
+			union bfa_fcport_stats_u *stats,
 			bfa_cb_pport_t cbfn, void *cbarg);
 bfa_status_t bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
 			void *cbarg);
+bfa_status_t bfa_fcport_get_fcoe_stats(struct bfa_s *bfa,
+			union bfa_fcport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+
 bfa_boolean_t     bfa_fcport_is_ratelim(struct bfa_s *bfa);
 bfa_boolean_t	bfa_fcport_is_linkup(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
diff --git a/drivers/scsi/bfa/include/bfi/bfi.h b/drivers/scsi/bfa/include/bfi/bfi.h
index 7042c18..a550e80 100644
--- a/drivers/scsi/bfa/include/bfi/bfi.h
+++ b/drivers/scsi/bfa/include/bfi/bfi.h
@@ -143,8 +143,8 @@ enum bfi_mclass {
 	BFI_MC_IOC		= 1,	/*  IO Controller (IOC)	    */
 	BFI_MC_DIAG		= 2,	/*  Diagnostic Msgs		    */
 	BFI_MC_FLASH		= 3,	/*  Flash message class	    */
-	BFI_MC_CEE		= 4,
-	BFI_MC_FC_PORT		= 5,	/*  FC port		   	    */
+	BFI_MC_CEE		= 4,	/*  CEE                     */
+	BFI_MC_FCPORT		= 5,	/*  FC port		   	    */
 	BFI_MC_IOCFC		= 6,	/*  FC - IO Controller (IOC)	    */
 	BFI_MC_LL		= 7,	/*  Link Layer		 	    */
 	BFI_MC_UF		= 8,	/*  Unsolicited frame receive	    */
diff --git a/drivers/scsi/bfa/include/bfi/bfi_pport.h b/drivers/scsi/bfa/include/bfi/bfi_pport.h
index 5c3d289..50dcf45 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_pport.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_pport.h
@@ -22,168 +22,97 @@
 
 #pragma pack(1)
 
-enum bfi_pport_h2i {
-	BFI_PPORT_H2I_ENABLE_REQ		= (1),
-	BFI_PPORT_H2I_DISABLE_REQ		= (2),
-	BFI_PPORT_H2I_GET_STATS_REQ		= (3),
-	BFI_PPORT_H2I_CLEAR_STATS_REQ	= (4),
-	BFI_PPORT_H2I_SET_SVC_PARAMS_REQ	= (5),
-	BFI_PPORT_H2I_ENABLE_RX_VF_TAG_REQ	= (6),
-	BFI_PPORT_H2I_ENABLE_TX_VF_TAG_REQ	= (7),
-	BFI_PPORT_H2I_GET_QOS_STATS_REQ		= (8),
-	BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ	= (9),
-	BFI_FCPORT_H2I_GET_STATS_REQ            = (10),
-	BFI_FCPORT_H2I_CLEAR_STATS_REQ          = (11),
+enum bfi_fcport_h2i {
+	BFI_FCPORT_H2I_ENABLE_REQ		= (1),
+	BFI_FCPORT_H2I_DISABLE_REQ		= (2),
+	BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ	= (3),
+	BFI_FCPORT_H2I_STATS_GET_REQ		= (4),
+	BFI_FCPORT_H2I_STATS_CLEAR_REQ		= (5),
 };
 
-enum bfi_pport_i2h {
-	BFI_PPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
-	BFI_PPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
-	BFI_PPORT_I2H_GET_STATS_RSP		= BFA_I2HM(3),
-	BFI_PPORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
-	BFI_PPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(5),
-	BFI_PPORT_I2H_ENABLE_RX_VF_TAG_RSP	= BFA_I2HM(6),
-	BFI_PPORT_I2H_ENABLE_TX_VF_TAG_RSP	= BFA_I2HM(7),
-	BFI_PPORT_I2H_EVENT			= BFA_I2HM(8),
-	BFI_PPORT_I2H_GET_QOS_STATS_RSP		= BFA_I2HM(9),
-	BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP	= BFA_I2HM(10),
-	BFI_FCPORT_I2H_GET_STATS_RSP            = BFA_I2HM(11),
-	BFI_FCPORT_I2H_CLEAR_STATS_RSP          = BFA_I2HM(12),
+enum bfi_fcport_i2h {
+	BFI_FCPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_FCPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
+	BFI_FCPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(3),
+	BFI_FCPORT_I2H_STATS_GET_RSP		= BFA_I2HM(4),
+	BFI_FCPORT_I2H_STATS_CLEAR_RSP		= BFA_I2HM(5),
+	BFI_FCPORT_I2H_EVENT			= BFA_I2HM(6),
 };
 
 /**
  * Generic REQ type
  */
-struct bfi_pport_generic_req_s {
+struct bfi_fcport_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header			    */
-	u32        msgtag;		/*  msgtag for reply		    */
+	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
 /**
  * Generic RSP type
  */
-struct bfi_pport_generic_rsp_s {
+struct bfi_fcport_rsp_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		    */
-	u8         status;		/*  port enable status		    */
-	u8         rsvd[3];
-	u32        msgtag;		/*  msgtag for reply		    */
+	u8		   status;	/*  port enable status		    */
+	u8		   rsvd[3];
+	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
 /**
- * BFI_PPORT_H2I_ENABLE_REQ
+ * BFI_FCPORT_H2I_ENABLE_REQ
  */
-struct bfi_pport_enable_req_s {
+struct bfi_fcport_enable_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header			    */
-	u32        rsvd1;
-	wwn_t           nwwn;		/*  node wwn of physical port	    */
-	wwn_t           pwwn;		/*  port wwn of physical port	    */
-	struct bfa_pport_cfg_s port_cfg;	/*  port configuration	    */
-	union bfi_addr_u  stats_dma_addr;	/*  DMA address for stats  */
-	union bfi_addr_u  fcport_stats_dma_addr;/*!< DMA address for stats  */
-	u32        msgtag;		/*  msgtag for reply		    */
-	u32        rsvd2;
+	u32	   rsvd1;
+	wwn_t		   nwwn;	/*  node wwn of physical port	    */
+	wwn_t		   pwwn;	/*  port wwn of physical port	    */
+	struct bfa_pport_cfg_s port_cfg; /*  port configuration	    */
+	union bfi_addr_u   stats_dma_addr; /*  DMA address for stats	    */
+	u32	   msgtag;	/*  msgtag for reply		    */
+	u32	   rsvd2;
 };
 
 /**
- * BFI_PPORT_I2H_ENABLE_RSP
+ * BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ
  */
-#define bfi_pport_enable_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_DISABLE_REQ
- */
-#define bfi_pport_disable_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_DISABLE_RSP
- */
-#define bfi_pport_disable_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_GET_STATS_REQ
- */
-#define bfi_pport_get_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_GET_STATS_RSP
- */
-#define bfi_pport_get_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_STATS_REQ
- */
-#define bfi_pport_clear_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_CLEAR_STATS_RSP
- */
-#define bfi_pport_clear_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_GET_QOS_STATS_REQ
- */
-#define bfi_pport_get_qos_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_H2I_GET_QOS_STATS_RSP
- */
-#define bfi_pport_get_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ
- */
-#define bfi_pport_clear_qos_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_QOS_STATS_RSP
- */
-#define bfi_pport_clear_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_SET_SVC_PARAMS_REQ
- */
-struct bfi_pport_set_svc_params_req_s {
+struct bfi_fcport_set_svc_params_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header */
-	u16        tx_bbcredit;	/*  Tx credits */
-	u16        rsvd;
+	u16	   tx_bbcredit;	/*  Tx credits */
+	u16	   rsvd;
 };
 
 /**
- * BFI_PPORT_I2H_SET_SVC_PARAMS_RSP
- */
-
-/**
- * BFI_PPORT_I2H_EVENT
+ * BFI_FCPORT_I2H_EVENT
  */
-struct bfi_pport_event_s {
+struct bfi_fcport_event_s {
 	struct bfi_mhdr_s 	mh;	/*  common msg header */
 	struct bfa_pport_link_s	link_state;
 };
 
-union bfi_pport_h2i_msg_u {
+/**
+ * fcport H2I message
+ */
+union bfi_fcport_h2i_msg_u {
 	struct bfi_mhdr_s			*mhdr;
-	struct bfi_pport_enable_req_s		*penable;
-	struct bfi_pport_generic_req_s		*pdisable;
-	struct bfi_pport_generic_req_s		*pgetstats;
-	struct bfi_pport_generic_req_s		*pclearstats;
-	struct bfi_pport_set_svc_params_req_s	*psetsvcparams;
-	struct bfi_pport_get_qos_stats_req_s	*pgetqosstats;
-	struct bfi_pport_generic_req_s		*pclearqosstats;
+	struct bfi_fcport_enable_req_s		*penable;
+	struct bfi_fcport_req_s			*pdisable;
+	struct bfi_fcport_set_svc_params_req_s	*psetsvcparams;
+	struct bfi_fcport_req_s			*pstatsget;
+	struct bfi_fcport_req_s			*pstatsclear;
 };
 
-union bfi_pport_i2h_msg_u {
+/**
+ * fcport I2H message
+ */
+union bfi_fcport_i2h_msg_u {
 	struct bfi_msg_s			*msg;
-	struct bfi_pport_generic_rsp_s		*enable_rsp;
-	struct bfi_pport_disable_rsp_s		*disable_rsp;
-	struct bfi_pport_generic_rsp_s		*getstats_rsp;
-	struct bfi_pport_clear_stats_rsp_s	*clearstats_rsp;
-	struct bfi_pport_set_svc_params_rsp_s	*setsvcparasm_rsp;
-	struct bfi_pport_get_qos_stats_rsp_s	*getqosstats_rsp;
-	struct bfi_pport_clear_qos_stats_rsp_s	*clearqosstats_rsp;
-	struct bfi_pport_event_s		*event;
+	struct bfi_fcport_rsp_s			*penable_rsp;
+	struct bfi_fcport_rsp_s			*pdisable_rsp;
+	struct bfi_fcport_rsp_s			*psetsvcparams_rsp;
+	struct bfi_fcport_rsp_s			*pstatsget_rsp;
+	struct bfi_fcport_rsp_s			*pstatsclear_rsp;
+	struct bfi_fcport_event_s		*event;
 };
 
 #pragma pack()
 
 #endif /* __BFI_PPORT_H__ */
-
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index 164cfbe..26e5cc7 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -240,73 +240,79 @@ struct bfa_pport_attr_s {
  * 		FC Port statistics.
  */
 struct bfa_pport_fc_stats_s {
-	u64        secs_reset;	/*  seconds since stats is reset */
-	u64        tx_frames;	/*  transmitted frames */
-	u64        tx_words;	/*  transmitted words */
-	u64        rx_frames;	/*  received frames */
-	u64        rx_words;	/*  received words */
-	u64        lip_count;	/*  LIPs seen */
-	u64        nos_count;	/*  NOS count */
-	u64        error_frames;	/*  errored frames */
-	u64        dropped_frames;	/*  dropped frames */
-	u64        link_failures;	/*  link failure count */
-	u64        loss_of_syncs;	/*  loss of sync count */
-	u64        loss_of_signals;/*  loss of signal count */
-	u64        primseq_errs;	/*  primitive sequence protocol */
-	u64        bad_os_count;	/*  invalid ordered set */
-	u64        err_enc_out;	/*  Encoding error outside frame */
-	u64        invalid_crcs;	/*  frames received with invalid CRC*/
-	u64	undersized_frm; /*  undersized frames */
-	u64	oversized_frm;	/*  oversized frames */
-	u64	bad_eof_frm;	/*  frames with bad EOF */
-	struct bfa_qos_stats_s	qos_stats;	/*  QoS statistics */
+	u64    secs_reset; /* Seconds since stats is reset     */
+	u64    tx_frames;  /* Tx frames                */
+	u64    tx_words;   /* Tx words                 */
+	u64    tx_lip;     /* TX LIP               */
+	u64    tx_nos;     /* Tx NOS               */
+	u64    tx_ols;     /* Tx OLS               */
+	u64    tx_lr;      /* Tx LR                */
+	u64    tx_lrr;     /* Tx LRR               */
+	u64    rx_frames;  /* Rx frames                */
+	u64    rx_words;   /* Rx words                 */
+	u64    lip_count;  /* Rx LIP                   */
+	u64    nos_count;  /* Rx NOS               */
+	u64    ols_count;  /* Rx OLS               */
+	u64    lr_count;   /* Rx LR                */
+	u64    lrr_count;  /* Rx LRR               */
+	u64    invalid_crcs;   /* Rx CRC err frames            */
+	u64    invalid_crc_gd_eof; /* Rx CRC err good EOF frames   */
+	u64    undersized_frm; /* Rx undersized frames         */
+	u64    oversized_frm;  /* Rx oversized frames          */
+	u64    bad_eof_frm;    /* Rx frames with bad EOF       */
+	u64    error_frames;   /* Errored frames           */
+	u64    dropped_frames; /* Dropped frames           */
+	u64    link_failures;  /* Link Failure (LF) count          */
+	u64    loss_of_syncs;  /* Loss of sync count           */
+	u64    loss_of_signals;/* Loss of signal count         */
+	u64    primseq_errs;   /* Primitive sequence protocol err. */
+	u64    bad_os_count;   /* Invalid ordered sets         */
+	u64    err_enc_out;    /* Encoding err nonframe_8b10b      */
+	u64    err_enc;    /* Encoding err frame_8b10b         */
 };
 
 /**
  * 		Eth Port statistics.
  */
 struct bfa_pport_eth_stats_s {
-	u64	secs_reset;	/*  seconds since stats is reset */
-	u64	frame_64;      /*  both rx and tx counter */
-	u64	frame_65_127;      /* both rx and tx counter */
-	u64	frame_128_255;     /* both rx and tx counter */
-	u64	frame_256_511;     /* both rx and tx counter */
-	u64	frame_512_1023;    /* both rx and tx counter */
-	u64	frame_1024_1518;   /* both rx and tx counter */
-	u64	frame_1519_1522;   /* both rx and tx counter */
-
-	u64	tx_bytes;
-	u64	tx_packets;
-	u64	tx_mcast_packets;
-	u64	tx_bcast_packets;
-	u64	tx_control_frame;
-	u64	tx_drop;
-	u64	tx_jabber;
-	u64	tx_fcs_error;
-	u64	tx_fragments;
-
-	u64	rx_bytes;
-	u64	rx_packets;
-	u64	rx_mcast_packets;
-	u64	rx_bcast_packets;
-	u64	rx_control_frames;
-	u64	rx_unknown_opcode;
-	u64	rx_drop;
-	u64	rx_jabber;
-	u64	rx_fcs_error;
-	u64	rx_alignment_error;
-	u64	rx_frame_length_error;
-	u64	rx_code_error;
-	u64	rx_fragments;
-
-	u64	rx_pause; /* BPC */
-	u64	rx_zero_pause; /*  BPC Pause cancellation */
-	u64	tx_pause;      /* BPC */
-	u64	tx_zero_pause; /*  BPC Pause cancellation */
-	u64	rx_fcoe_pause; /* BPC */
-	u64	rx_fcoe_zero_pause; /*  BPC Pause cancellation */
-	u64	tx_fcoe_pause;      /* BPC */
-	u64	tx_fcoe_zero_pause; /*  BPC Pause cancellation */
+	u64    secs_reset;   /* Seconds since stats is reset   */
+	u64    frame_64;     /* Frames 64 bytes            */
+	u64    frame_65_127;     /* Frames 65-127 bytes        */
+	u64    frame_128_255;    /* Frames 128-255 bytes       */
+	u64    frame_256_511;    /* Frames 256-511 bytes       */
+	u64    frame_512_1023;   /* Frames 512-1023 bytes          */
+	u64    frame_1024_1518;  /* Frames 1024-1518 bytes         */
+	u64    frame_1519_1522;  /* Frames 1519-1522 bytes         */
+	u64    tx_bytes;     /* Tx bytes               */
+	u64    tx_packets;   /* Tx packets             */
+	u64    tx_mcast_packets; /* Tx multicast packets       */
+	u64    tx_bcast_packets; /* Tx broadcast packets       */
+	u64    tx_control_frame; /* Tx control frame           */
+	u64    tx_drop;      /* Tx drops               */
+	u64    tx_jabber;    /* Tx jabber              */
+	u64    tx_fcs_error;     /* Tx FCS error           */
+	u64    tx_fragments;     /* Tx fragments           */
+	u64    rx_bytes;     /* Rx bytes               */
+	u64    rx_packets;   /* Rx packets             */
+	u64    rx_mcast_packets; /* Rx multicast packets       */
+	u64    rx_bcast_packets; /* Rx broadcast packets       */
+	u64    rx_control_frames; /* Rx control frames         */
+	u64    rx_unknown_opcode; /* Rx unknown opcode         */
+	u64    rx_drop;      /* Rx drops               */
+	u64    rx_jabber;    /* Rx jabber              */
+	u64    rx_fcs_error;     /* Rx FCS errors              */
+	u64    rx_alignment_error; /* Rx alignment errors          */
+	u64    rx_frame_length_error; /* Rx frame len errors       */
+	u64    rx_code_error;    /* Rx code errors             */
+	u64    rx_fragments;     /* Rx fragments           */
+	u64    rx_pause;     /* Rx pause               */
+	u64    rx_zero_pause;    /* Rx zero pause              */
+	u64    tx_pause;     /* Tx pause               */
+	u64    tx_zero_pause;    /* Tx zero pause              */
+	u64    rx_fcoe_pause;    /* Rx fcoe pause              */
+	u64    rx_fcoe_zero_pause; /* Rx FCoE zero pause       */
+	u64    tx_fcoe_pause;    /* Tx FCoE pause              */
+	u64    tx_fcoe_zero_pause; /* Tx FCoE zero pause       */
 };
 
 /**
-- 
1.6.5.3

