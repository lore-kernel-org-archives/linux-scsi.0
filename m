From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 9/14] bfa: Brocade BFA FC SCSI driver (fcs4)
Date: Wed, 23 Sep 2009 18:02:43 -0700
Message-ID: <200909240102.n8O12hmJ019754@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:38913 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZIXBCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 21:02:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-4

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 rport.c      | 2618 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rport_api.c  |  180 ++++
 rport_ftrs.c |  375 ++++++++
 scn.c        |  482 ++++++++++
 vfapi.c      |  292 ++++++
 vport.c      |  891 ++++++++++++++++++++
 6 files changed, 4838 insertions(+)

diff -urpN orig/drivers/scsi/bfa/rport.c patch/drivers/scsi/bfa/rport.c
--- orig/drivers/scsi/bfa/rport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,2618 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  rport.c Remote port implementation.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcbuild.h"
+#include "fcs_vport.h"
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_fcpim.h"
+#include "fcs_fcptm.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs.h"
+#include <fcb/bfa_fcb_rport.h>
+#include <aen/bfa_aen_rport.h>
+
+BFA_TRC_FILE(FCS, RPORT);
+
+#define BFA_FCS_RPORT_MAX_RETRIES		(5)
+
+/* In millisecs */
+static u32 bfa_fcs_rport_del_timeout =
+			BFA_FCS_RPORT_DEF_DEL_TIMEOUT * 1000;
+
+/*
+ * forward declarations
+ */
+static struct bfa_fcs_rport_s *bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port,
+						   wwn_t pwwn, u32 rpid);
+static void     bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_hal_online(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport,
+				     struct fc_logi_s *plogi);
+static void     bfa_fcs_rport_fc4_pause(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_fc4_resume(struct bfa_fcs_rport_s *rport);
+static void     bfa_fcs_rport_timeout(void *arg);
+static void     bfa_fcs_rport_send_plogi(void *rport_cbarg,
+					 struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rport_send_plogiacc(void *rport_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rport_plogi_response(void *fcsarg,
+					     struct bfa_fcxp_s *fcxp,
+					     void *cbarg,
+					     bfa_status_t req_status,
+					     u32 rsp_len,
+					     u32 resid_len,
+					     struct fchs_s *rsp_fchs);
+static void     bfa_fcs_rport_send_adisc(void *rport_cbarg,
+					 struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rport_adisc_response(void *fcsarg,
+					     struct bfa_fcxp_s *fcxp,
+					     void *cbarg,
+					     bfa_status_t req_status,
+					     u32 rsp_len,
+					     u32 resid_len,
+					     struct fchs_s *rsp_fchs);
+static void     bfa_fcs_rport_send_gidpn(void *rport_cbarg,
+					 struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rport_gidpn_response(void *fcsarg,
+					     struct bfa_fcxp_s *fcxp,
+					     void *cbarg,
+					     bfa_status_t req_status,
+					     u32 rsp_len,
+					     u32 resid_len,
+					     struct fchs_s *rsp_fchs);
+static void     bfa_fcs_rport_send_logo(void *rport_cbarg,
+					struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rport_send_logo_acc(void *rport_cbarg);
+static void     bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u16 len);
+static void     bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u8 reason_code,
+			u8 reason_code_expl);
+static void     bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u16 len);
+/**
+ *  fcs_rport_sm FCS rport state machine events
+ */
+
+enum rport_event {
+	RPSM_EVENT_PLOGI_SEND = 1,	/*  new rport; start with PLOGI */
+	RPSM_EVENT_PLOGI_RCVD = 2,	/*  Inbound PLOGI from remote port */
+	RPSM_EVENT_PLOGI_COMP = 3,	/*  PLOGI completed to rport */
+	RPSM_EVENT_LOGO_RCVD = 4,	/*  LOGO from remote device */
+	RPSM_EVENT_LOGO_IMP = 5,	/*  implicit logo for SLER */
+	RPSM_EVENT_FCXP_SENT = 6,	/*  Frame from has been sent */
+	RPSM_EVENT_DELETE = 7,	/*  RPORT delete request */
+	RPSM_EVENT_SCN = 8,	/*  state change notification */
+	RPSM_EVENT_ACCEPTED = 9,/*  Good response from remote device */
+	RPSM_EVENT_FAILED = 10,	/*  Request to rport failed.  */
+	RPSM_EVENT_TIMEOUT = 11,	/*  Rport SM timeout event */
+	RPSM_EVENT_HCB_ONLINE = 12,	/*  BFA rport online callback */
+	RPSM_EVENT_HCB_OFFLINE = 13,	/*  BFA rport offline callback */
+	RPSM_EVENT_FC4_OFFLINE = 14,	/*  FC-4 offline complete */
+	RPSM_EVENT_ADDRESS_CHANGE = 15,	/*  Rport's PID has changed */
+	RPSM_EVENT_ADDRESS_DISC = 16	/*  Need to Discover rport's PID */
+};
+
+static void     bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport,
+					enum rport_event event);
+static void     bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
+					       enum rport_event event);
+static void     bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
+						  enum rport_event event);
+static void     bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport,
+				       enum rport_event event);
+static void     bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
+					    enum rport_event event);
+static void     bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport,
+					enum rport_event event);
+static void     bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
+						 enum rport_event event);
+static void     bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport,
+					 enum rport_event event);
+static void     bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
+					       enum rport_event event);
+static void     bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport,
+				       enum rport_event event);
+static void     bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
+					      enum rport_event event);
+static void     bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
+					      enum rport_event event);
+static void     bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
+					      enum rport_event event);
+static void     bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport,
+					 enum rport_event event);
+static void     bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
+						enum rport_event event);
+static void     bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
+					      enum rport_event event);
+static void     bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+static void     bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
+					     enum rport_event event);
+
+static struct bfa_sm_table_s rport_sm_table[] = {
+	{BFA_SM(bfa_fcs_rport_sm_uninit), BFA_RPORT_UNINIT},
+	{BFA_SM(bfa_fcs_rport_sm_plogi_sending), BFA_RPORT_PLOGI},
+	{BFA_SM(bfa_fcs_rport_sm_plogiacc_sending), BFA_RPORT_ONLINE},
+	{BFA_SM(bfa_fcs_rport_sm_plogi_retry), BFA_RPORT_PLOGI_RETRY},
+	{BFA_SM(bfa_fcs_rport_sm_plogi), BFA_RPORT_PLOGI},
+	{BFA_SM(bfa_fcs_rport_sm_hal_online), BFA_RPORT_ONLINE},
+	{BFA_SM(bfa_fcs_rport_sm_online), BFA_RPORT_ONLINE},
+	{BFA_SM(bfa_fcs_rport_sm_nsquery_sending), BFA_RPORT_NSQUERY},
+	{BFA_SM(bfa_fcs_rport_sm_nsquery), BFA_RPORT_NSQUERY},
+	{BFA_SM(bfa_fcs_rport_sm_adisc_sending), BFA_RPORT_ADISC},
+	{BFA_SM(bfa_fcs_rport_sm_adisc), BFA_RPORT_ADISC},
+	{BFA_SM(bfa_fcs_rport_sm_fc4_logorcv), BFA_RPORT_LOGORCV},
+	{BFA_SM(bfa_fcs_rport_sm_fc4_logosend), BFA_RPORT_LOGO},
+	{BFA_SM(bfa_fcs_rport_sm_fc4_offline), BFA_RPORT_OFFLINE},
+	{BFA_SM(bfa_fcs_rport_sm_hcb_offline), BFA_RPORT_OFFLINE},
+	{BFA_SM(bfa_fcs_rport_sm_hcb_logorcv), BFA_RPORT_LOGORCV},
+	{BFA_SM(bfa_fcs_rport_sm_hcb_logosend), BFA_RPORT_LOGO},
+	{BFA_SM(bfa_fcs_rport_sm_logo_sending), BFA_RPORT_LOGO},
+	{BFA_SM(bfa_fcs_rport_sm_offline), BFA_RPORT_OFFLINE},
+	{BFA_SM(bfa_fcs_rport_sm_nsdisc_sending), BFA_RPORT_NSDISC},
+	{BFA_SM(bfa_fcs_rport_sm_nsdisc_retry), BFA_RPORT_NSDISC},
+	{BFA_SM(bfa_fcs_rport_sm_nsdisc_sent), BFA_RPORT_NSDISC},
+};
+
+/**
+ * 		Beginning state.
+ */
+static void
+bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_PLOGI_SEND:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_sending);
+		rport->plogi_retries = 0;
+		bfa_fcs_rport_send_plogi(rport, NULL);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+	case RPSM_EVENT_ADDRESS_DISC:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		PLOGI is being sent.
+ */
+static void
+bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
+			       enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_SCN:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		PLOGI is being sent.
+ */
+static void
+bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
+				  enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * Ignore, SCN is possibly online notification.
+		 */
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_HCB_OFFLINE:
+		/**
+		 * Ignore BFA callback, on a PLOGI receive we call bfa offline.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		PLOGI is sent.
+ */
+static void
+bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_SCN:
+		bfa_timer_stop(&rport->timer);
+		/*
+		 * !! fall through !!
+		 */
+
+	case RPSM_EVENT_TIMEOUT:
+		rport->plogi_retries++;
+		if (rport->plogi_retries < BFA_FCS_RPORT_MAX_RETRIES) {
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_sending);
+			bfa_fcs_rport_send_plogi(rport, NULL);
+		} else {
+			rport->pid = 0;
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+			bfa_timer_start(rport->fcs->bfa, &rport->timer,
+					bfa_fcs_rport_timeout, rport,
+					bfa_fcs_rport_del_timeout);
+		}
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_timer_stop(&rport->timer);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_timer_stop(&rport->timer);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		PLOGI is sent.
+ */
+static void
+bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_ACCEPTED:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		rport->plogi_retries = 0;
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_fcs_rport_send_logo_acc(rport);
+		bfa_fcxp_discard(rport->fcxp);
+		/*
+		 * !! fall through !!
+		 */
+	case RPSM_EVENT_FAILED:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_retry);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * Ignore SCN - wait for PLOGI response.
+		 */
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		PLOGI is complete. Awaiting BFA rport online callback. FC-4s
+ * 		are offline.
+ */
+static void
+bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_HCB_ONLINE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_online);
+		bfa_fcs_rport_online_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logorcv);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_offline);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_rport_offline(rport->bfa_rport);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logosend);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * @todo
+		 * Ignore SCN - PLOGI just completed, FC-4 login should detect
+		 * device failures.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport is ONLINE. FC-4s active.
+ */
+static void
+bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_SCN:
+		/**
+		 * Pause FC-4 activity till rport is authenticated.
+		 * In switched fabrics, check presence of device in nameserver
+		 * first.
+		 */
+		bfa_fcs_rport_fc4_pause(rport);
+
+		if (bfa_fcs_fabric_is_switched(rport->port->fabric)) {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsquery_sending);
+			rport->ns_retries = 0;
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		} else {
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_adisc_sending);
+			bfa_fcs_rport_send_adisc(rport, NULL);
+		}
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+	case RPSM_EVENT_LOGO_IMP:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		An SCN event is received in ONLINE state. NS query is being sent
+ * 		prior to ADISC authentication with rport. FC-4s are paused.
+ */
+static void
+bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
+				 enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsquery);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * ignore SCN, wait for response to query itself
+		 */
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	An SCN event is received in ONLINE state. NS query is sent to rport.
+ * 	FC-4s are paused.
+ */
+static void
+bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_ACCEPTED:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_adisc_sending);
+		bfa_fcs_rport_send_adisc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_FAILED:
+		rport->ns_retries++;
+		if (rport->ns_retries < BFA_FCS_RPORT_MAX_RETRIES) {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsquery_sending);
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		} else {
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+			bfa_fcs_rport_offline_action(rport);
+		}
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+	case RPSM_EVENT_PLOGI_RCVD:
+	case RPSM_EVENT_LOGO_IMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	An SCN event is received in ONLINE state. ADISC is being sent for
+ * 	authenticating with rport. FC-4s are paused.
+ */
+static void
+bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
+			       enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_adisc);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		An SCN event is received in ONLINE state. ADISC is to rport.
+ * 		FC-4s are paused.
+ */
+static void
+bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_ACCEPTED:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_online);
+		bfa_fcs_rport_fc4_resume(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		/**
+		 * Too complex to cleanup FC-4 & rport and then acc to PLOGI.
+		 * At least go offline when a PLOGI is received.
+		 */
+		bfa_fcxp_discard(rport->fcxp);
+		/*
+		 * !!! fall through !!!
+		 */
+
+	case RPSM_EVENT_FAILED:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * already processing RSCN
+		 */
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_offline);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logorcv);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_offline_action(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport has sent LOGO. Awaiting FC-4 offline completion callback.
+ */
+static void
+bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FC4_OFFLINE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logorcv);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		LOGO needs to be sent to rport. Awaiting FC-4 offline completion
+ * 		callback.
+ */
+static void
+bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
+			      enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FC4_OFFLINE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logosend);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	Rport is going offline. Awaiting FC-4 offline completion callback.
+ */
+static void
+bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FC4_OFFLINE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_offline);
+		bfa_rport_offline(rport->bfa_rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_LOGO_IMP:
+	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		/**
+		 * rport is already going offline.
+		 * SCN - ignore and wait till transitioning to offline state
+		 */
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_fc4_logosend);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
+ * 		callback.
+ */
+static void
+bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_HCB_OFFLINE:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		if (bfa_fcs_port_is_online(rport->port)) {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsdisc_sending);
+			rport->ns_retries = 0;
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		} else {
+			rport->pid = 0;
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+			bfa_timer_start(rport->fcs->bfa, &rport->timer,
+					bfa_fcs_rport_timeout, rport,
+					bfa_fcs_rport_del_timeout);
+		}
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_LOGO_RCVD:
+		/**
+		 * Ignore, already offline.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
+ * 		callback to send LOGO accept.
+ */
+static void
+bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_HCB_OFFLINE:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		if (rport->pid)
+			bfa_fcs_rport_send_logo_acc(rport);
+		/*
+		 * If the lport is online and if the rport is not a well known
+		 * address port, we try to re-discover the r-port.
+		 */
+		if (bfa_fcs_port_is_online(rport->port)
+		    && (!BFA_FCS_PID_IS_WKA(rport->pid))) {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsdisc_sending);
+			rport->ns_retries = 0;
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		} else {
+			/*
+			 * if it is not a well known address, reset the pid to
+			 *
+			 */
+			if (!BFA_FCS_PID_IS_WKA(rport->pid))
+				rport->pid = 0;
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+			bfa_timer_start(rport->fcs->bfa, &rport->timer,
+					bfa_fcs_rport_timeout, rport,
+					bfa_fcs_rport_del_timeout);
+		}
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logosend);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_offline);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		/**
+		 * Ignore - already processing a LOGO.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport is being deleted. FC-4s are offline. Awaiting BFA rport offline
+ * callback to send LOGO.
+ */
+static void
+bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
+			      enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_HCB_OFFLINE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_logo_sending);
+		bfa_fcs_rport_send_logo(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport is being deleted. FC-4s are offline. LOGO is being sent.
+ */
+static void
+bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
+			      enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		/*
+		 * Once LOGO is sent, we donot wait for the response
+		 */
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Rport is offline. FC-4s are offline. BFA rport is offline.
+ * 		Timer active to delete stale rport.
+ */
+static void
+bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		bfa_timer_stop(&rport->timer);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_LOGO_IMP:
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_SEND:
+		bfa_timer_stop(&rport->timer);
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_sending);
+		rport->plogi_retries = 0;
+		bfa_fcs_rport_send_plogi(rport, NULL);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	Rport address has changed. Nameserver discovery request is being sent.
+ */
+static void
+bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
+				enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sent);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_LOGO_RCVD:
+	case RPSM_EVENT_PLOGI_SEND:
+		break;
+
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		rport->ns_retries = 0;	/* reset the retry count */
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rport->fcxp_wqe);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Nameserver discovery failed. Waiting for timeout to retry.
+ */
+static void
+bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
+			      enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_SCN:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_nsdisc_sending);
+		bfa_timer_stop(&rport->timer);
+		rport->ns_retries = 0;
+		bfa_fcs_rport_send_gidpn(rport, NULL);
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_timer_stop(&rport->timer);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		bfa_fcs_rport_send_logo_acc(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_timer_stop(&rport->timer);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport address has changed. Nameserver discovery request is sent.
+ */
+static void
+bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
+			enum rport_event event)
+{
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPSM_EVENT_ACCEPTED:
+	case RPSM_EVENT_ADDRESS_CHANGE:
+		if (rport->pid) {
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogi_sending);
+			bfa_fcs_rport_send_plogi(rport, NULL);
+		} else {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsdisc_sending);
+			rport->ns_retries = 0;
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		}
+		break;
+
+	case RPSM_EVENT_FAILED:
+		rport->ns_retries++;
+		if (rport->ns_retries < BFA_FCS_RPORT_MAX_RETRIES) {
+			bfa_sm_set_state(rport,
+					 bfa_fcs_rport_sm_nsdisc_sending);
+			bfa_fcs_rport_send_gidpn(rport, NULL);
+		} else {
+			rport->pid = 0;
+			bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+			bfa_timer_start(rport->fcs->bfa, &rport->timer,
+					bfa_fcs_rport_timeout, rport,
+					bfa_fcs_rport_del_timeout);
+		};
+		break;
+
+	case RPSM_EVENT_DELETE:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_free(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_RCVD:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_send_plogiacc(rport, NULL);
+		break;
+
+	case RPSM_EVENT_LOGO_IMP:
+		rport->pid = 0;
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_offline);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_timer_start(rport->fcs->bfa, &rport->timer,
+				bfa_fcs_rport_timeout, rport,
+				bfa_fcs_rport_del_timeout);
+		break;
+
+	case RPSM_EVENT_SCN:
+		/**
+		 * ignore, wait for NS query response
+		 */
+		break;
+
+	case RPSM_EVENT_LOGO_RCVD:
+		/**
+		 * Not logged-in yet. Accept LOGO.
+		 */
+		bfa_fcs_rport_send_logo_acc(rport);
+		break;
+
+	case RPSM_EVENT_PLOGI_COMP:
+		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hal_online);
+		bfa_fcxp_discard(rport->fcxp);
+		bfa_fcs_rport_hal_online(rport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  fcs_rport_private FCS RPORT provate functions
+ */
+
+static void
+bfa_fcs_rport_send_plogi(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rport->fcxp_wqe,
+				    bfa_fcs_rport_send_plogi, rport);
+		return;
+	}
+	rport->fcxp = fcxp;
+
+	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn,
+			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_plogi_response,
+		      (void *)rport, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	rport->stats.plogis++;
+	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			     bfa_status_t req_status, u32 rsp_len,
+			     u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct fc_logi_s	*plogi_rsp;
+	struct fc_ls_rjt_s	*ls_rjt;
+	struct bfa_fcs_rport_s *twin;
+	struct list_head *qe;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(rport->fcs, req_status);
+		rport->stats.plogi_failed++;
+		bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+		return;
+	}
+
+	plogi_rsp = (struct fc_logi_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+	/**
+	 * Check for failure first.
+	 */
+	if (plogi_rsp->els_cmd.els_code != FC_ELS_ACC) {
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+		bfa_trc(rport->fcs, ls_rjt->reason_code);
+		bfa_trc(rport->fcs, ls_rjt->reason_code_expl);
+
+		rport->stats.plogi_rejects++;
+		bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+		return;
+	}
+
+	/**
+	 * PLOGI is complete. Make sure this device is not one of the known
+	 * device with a new FC port address.
+	 */
+	list_for_each(qe, &rport->port->rport_q) {
+		twin = (struct bfa_fcs_rport_s *)qe;
+		if (twin == rport)
+			continue;
+		if (!rport->pwwn && (plogi_rsp->port_name == twin->pwwn)) {
+			bfa_trc(rport->fcs, twin->pid);
+			bfa_trc(rport->fcs, rport->pid);
+
+			/*
+			 * Update plogi stats in twin
+			 */
+			twin->stats.plogis += rport->stats.plogis;
+			twin->stats.plogi_rejects += rport->stats.plogi_rejects;
+			twin->stats.plogi_timeouts +=
+				rport->stats.plogi_timeouts;
+			twin->stats.plogi_failed += rport->stats.plogi_failed;
+			twin->stats.plogi_rcvd += rport->stats.plogi_rcvd;
+			twin->stats.plogi_accs++;
+
+			bfa_fcs_rport_delete(rport);
+
+			bfa_fcs_rport_update(twin, plogi_rsp);
+			twin->pid = rsp_fchs->s_id;
+			bfa_sm_send_event(twin, RPSM_EVENT_PLOGI_COMP);
+			return;
+		}
+	}
+
+	/**
+	 * Normal login path -- no evil twins.
+	 */
+	rport->stats.plogi_accs++;
+	bfa_fcs_rport_update(rport, plogi_rsp);
+	bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
+}
+
+static void
+bfa_fcs_rport_send_plogiacc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->reply_oxid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rport->fcxp_wqe,
+				    bfa_fcs_rport_send_plogiacc, rport);
+		return;
+	}
+	rport->fcxp = fcxp;
+
+	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+				 bfa_fcs_port_get_fcid(port), rport->reply_oxid,
+				 port->port_cfg.pwwn, port->port_cfg.nwwn,
+				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+
+	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_rport_send_adisc(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rport->fcxp_wqe,
+				    bfa_fcs_rport_send_adisc, rport);
+		return;
+	}
+	rport->fcxp = fcxp;
+
+	len = fc_adisc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_adisc_response,
+		      rport, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	rport->stats.adisc_sent++;
+	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_rport_adisc_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			     bfa_status_t req_status, u32 rsp_len,
+			     u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	void           *pld = bfa_fcxp_get_rspbuf(fcxp);
+	struct fc_ls_rjt_s    *ls_rjt;
+
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(rport->fcs, req_status);
+		rport->stats.adisc_failed++;
+		bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+		return;
+	}
+
+	if (fc_adisc_rsp_parse((struct fc_adisc_s *)pld, rsp_len, rport->pwwn,
+		rport->nwwn)  == FC_PARSE_OK) {
+		rport->stats.adisc_accs++;
+		bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
+		return;
+	}
+
+	rport->stats.adisc_rejects++;
+	ls_rjt = pld;
+	bfa_trc(rport->fcs, ls_rjt->els_cmd.els_code);
+	bfa_trc(rport->fcs, ls_rjt->reason_code);
+	bfa_trc(rport->fcs, ls_rjt->reason_code_expl);
+	bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+}
+
+static void
+bfa_fcs_rport_send_gidpn(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(rport->fcs, rport->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rport->fcxp_wqe,
+				    bfa_fcs_rport_send_gidpn, rport);
+		return;
+	}
+	rport->fcxp = fcxp;
+
+	len = fc_gidpn_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			     bfa_fcs_port_get_fcid(port), 0, rport->pwwn);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_rport_gidpn_response,
+		      (void *)rport, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			     bfa_status_t req_status, u32 rsp_len,
+			     u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_fcs_rport_s *twin;
+	struct list_head *qe;
+	struct ct_hdr_s       	*cthdr;
+	struct fcgs_gidpn_resp_s	*gidpn_rsp;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		/*
+		 * Check if the pid is the same as before.
+		 */
+		gidpn_rsp = (struct fcgs_gidpn_resp_s *) (cthdr + 1);
+
+		if (gidpn_rsp->dap == rport->pid) {
+			/*
+			 * Device is online
+			 */
+			bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
+		} else {
+			/*
+			 * Device's PID has changed. We need to cleanup and
+			 * re-login. If there is another device with the the
+			 * newly discovered pid, send an scn notice so that its
+			 * new pid can be discovered.
+			 */
+			list_for_each(qe, &rport->port->rport_q) {
+				twin = (struct bfa_fcs_rport_s *)qe;
+				if (twin == rport)
+					continue;
+				if (gidpn_rsp->dap == twin->pid) {
+					bfa_trc(rport->fcs, twin->pid);
+					bfa_trc(rport->fcs, rport->pid);
+
+					twin->pid = 0;
+					bfa_sm_send_event(twin,
+						RPSM_EVENT_ADDRESS_CHANGE);
+				}
+			}
+			rport->pid = gidpn_rsp->dap;
+			bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_CHANGE);
+		}
+		return;
+	}
+
+	/*
+	 * Reject Response
+	 */
+	switch (cthdr->reason_code) {
+	case CT_RSN_LOGICAL_BUSY:
+		/*
+		 * Need to retry
+		 */
+		bfa_sm_send_event(rport, RPSM_EVENT_TIMEOUT);
+		break;
+
+	case CT_RSN_UNABLE_TO_PERF:
+		/*
+		 * device doesn't exist : Start timer to cleanup this later.
+		 */
+		bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+		break;
+
+	default:
+		bfa_sm_send_event(rport, RPSM_EVENT_FAILED);
+		break;
+	}
+}
+
+/**
+ *    Called to send a logout to the rport.
+ */
+static void
+bfa_fcs_rport_send_logo(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	u16        len;
+
+	bfa_trc(rport->fcs, rport->pid);
+
+	port = rport->port;
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rport->fcxp_wqe,
+				    bfa_fcs_rport_send_logo, rport);
+		return;
+	}
+	rport->fcxp = fcxp;
+
+	len = fc_logo_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+			    bfa_fcs_port_get_fcid(port), 0,
+			    bfa_fcs_port_get_pwwn(port));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, rport, FC_MAX_PDUSZ,
+		      FC_ED_TOV);
+
+	rport->stats.logos++;
+	bfa_fcxp_discard(rport->fcxp);
+	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
+}
+
+/**
+ *    Send ACC for a LOGO received.
+ */
+static void
+bfa_fcs_rport_send_logo_acc(void *rport_cbarg)
+{
+	struct bfa_fcs_rport_s *rport = rport_cbarg;
+	struct bfa_fcs_port_s *port;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	u16        len;
+
+	bfa_trc(rport->fcs, rport->pid);
+
+	port = rport->port;
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	rport->stats.logo_rcvd++;
+	len = fc_logo_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+				bfa_fcs_port_get_fcid(port), rport->reply_oxid);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+}
+
+/**
+ *     This routine will be called by bfa_timer on timer timeouts.
+ *
+ * 	param[in] 	rport 			- pointer to bfa_fcs_port_ns_t.
+ * 	param[out]	rport_status 	- pointer to return vport status in
+ *
+ * 	return
+ * 		void
+ *
+*  	Special Considerations:
+ *
+ * 	note
+ */
+static void
+bfa_fcs_rport_timeout(void *arg)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)arg;
+
+	rport->stats.plogi_timeouts++;
+	bfa_sm_send_event(rport, RPSM_EVENT_TIMEOUT);
+}
+
+static void
+bfa_fcs_rport_process_prli(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u16 len)
+{
+	struct bfa_fcxp_s *fcxp;
+	struct fchs_s          fchs;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fc_prli_s      *prli;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+	bfa_trc(port->fcs, rx_fchs->d_id);
+
+	rport->stats.prli_rcvd++;
+
+	if (BFA_FCS_VPORT_IS_TARGET_MODE(port)) {
+		/*
+		 * Target Mode : Let the fcptm handle it
+		 */
+		bfa_fcs_tin_rx_prli(rport->tin, rx_fchs, len);
+		return;
+	}
+
+	/*
+	 * We are either in Initiator or ipfc Mode
+	 */
+	prli = (struct fc_prli_s *) (rx_fchs + 1);
+
+	if (prli->parampage.servparams.initiator) {
+		bfa_trc(rport->fcs, prli->parampage.type);
+		rport->scsi_function = BFA_RPORT_INITIATOR;
+		bfa_fcs_itnim_is_initiator(rport->itnim);
+	} else {
+		/*
+		 * @todo: PRLI from a target ?
+		 */
+		bfa_trc(port->fcs, rx_fchs->s_id);
+		rport->scsi_function = BFA_RPORT_TARGET;
+	}
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_prli_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
+				port->port_cfg.roles);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+}
+
+static void
+bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u16 len)
+{
+	struct bfa_fcxp_s *fcxp;
+	struct fchs_s          fchs;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fc_rpsc_speed_info_s speeds;
+	struct bfa_pport_attr_s pport_attr;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+	bfa_trc(port->fcs, rx_fchs->d_id);
+
+	rport->stats.rpsc_rcvd++;
+	speeds.port_speed_cap =
+		RPSC_SPEED_CAP_1G | RPSC_SPEED_CAP_2G | RPSC_SPEED_CAP_4G |
+		RPSC_SPEED_CAP_8G;
+
+	/*
+	 * get curent speed from pport attributes from BFA
+	 */
+	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+
+	speeds.port_op_speed = fc_bfa_speed_to_rpsc_operspeed(pport_attr.speed);
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_rpsc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
+				&speeds);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+}
+
+static void
+bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
+			struct fchs_s *rx_fchs, u16 len)
+{
+	struct bfa_fcxp_s *fcxp;
+	struct fchs_s          fchs;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fc_adisc_s      *adisc;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+	bfa_trc(port->fcs, rx_fchs->d_id);
+
+	rport->stats.adisc_rcvd++;
+
+	if (BFA_FCS_VPORT_IS_TARGET_MODE(port)) {
+		/*
+		 * @todo : Target Mode handling
+		 */
+		bfa_trc(port->fcs, rx_fchs->d_id);
+		bfa_assert(0);
+		return;
+	}
+
+	adisc = (struct fc_adisc_s *) (rx_fchs + 1);
+
+	/*
+	 * Accept if the itnim for this rport is online. Else reject the ADISC
+	 */
+	if (bfa_fcs_itnim_get_online_state(rport->itnim) == BFA_STATUS_OK) {
+
+		fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+		if (!fcxp)
+			return;
+
+		len = fc_adisc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+					 rx_fchs->s_id,
+					 bfa_fcs_port_get_fcid(port),
+					 rx_fchs->ox_id, port->port_cfg.pwwn,
+					 port->port_cfg.nwwn);
+
+		bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag,
+			      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+			      FC_MAX_PDUSZ, 0);
+	} else {
+		rport->stats.adisc_rejected++;
+		bfa_fcs_rport_send_ls_rjt(rport, rx_fchs,
+					  FC_LS_RJT_RSN_UNABLE_TO_PERF_CMD,
+					  FC_LS_RJT_EXP_LOGIN_REQUIRED);
+	}
+
+}
+
+static void
+bfa_fcs_rport_hal_online(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+	struct bfa_rport_info_s rport_info;
+
+	rport_info.pid = rport->pid;
+	rport_info.local_pid = port->pid;
+	rport_info.lp_tag = port->lp_tag;
+	rport_info.vf_id = port->fabric->vf_id;
+	rport_info.vf_en = port->fabric->is_vf;
+	rport_info.fc_class = rport->fc_cos;
+	rport_info.cisc = rport->cisc;
+	rport_info.max_frmsz = rport->maxfrsize;
+	bfa_rport_online(rport->bfa_rport, &rport_info);
+}
+
+static void
+bfa_fcs_rport_fc4_pause(struct bfa_fcs_rport_s *rport)
+{
+	if (bfa_fcs_port_is_initiator(rport->port))
+		bfa_fcs_itnim_pause(rport->itnim);
+
+	if (bfa_fcs_port_is_target(rport->port))
+		bfa_fcs_tin_pause(rport->tin);
+}
+
+static void
+bfa_fcs_rport_fc4_resume(struct bfa_fcs_rport_s *rport)
+{
+	if (bfa_fcs_port_is_initiator(rport->port))
+		bfa_fcs_itnim_resume(rport->itnim);
+
+	if (bfa_fcs_port_is_target(rport->port))
+		bfa_fcs_tin_resume(rport->tin);
+}
+
+static struct bfa_fcs_rport_s *
+bfa_fcs_rport_alloc(struct bfa_fcs_port_s *port, wwn_t pwwn, u32 rpid)
+{
+	struct bfa_fcs_s *fcs = port->fcs;
+	struct bfa_fcs_rport_s *rport;
+	struct bfad_rport_s *rport_drv;
+
+	/**
+	 * allocate rport
+	 */
+	if (bfa_fcb_rport_alloc(fcs->bfad, &rport, &rport_drv)
+	    != BFA_STATUS_OK) {
+		bfa_trc(fcs, rpid);
+		return NULL;
+	}
+
+	/*
+	 * Initialize r-port
+	 */
+	rport->port = port;
+	rport->fcs = fcs;
+	rport->rp_drv = rport_drv;
+	rport->pid = rpid;
+	rport->pwwn = pwwn;
+
+	/**
+	 * allocate BFA rport
+	 */
+	rport->bfa_rport = bfa_rport_create(port->fcs->bfa, rport);
+	if (!rport->bfa_rport) {
+		bfa_trc(fcs, rpid);
+		kfree(rport_drv);
+		return NULL;
+	}
+
+	/**
+	 * allocate FC-4s
+	 */
+	bfa_assert(bfa_fcs_port_is_initiator(port) ^
+		   bfa_fcs_port_is_target(port));
+
+	if (bfa_fcs_port_is_initiator(port)) {
+		rport->itnim = bfa_fcs_itnim_create(rport);
+		if (!rport->itnim) {
+			bfa_trc(fcs, rpid);
+			bfa_rport_delete(rport->bfa_rport);
+			kfree(rport_drv);
+			return NULL;
+		}
+	}
+
+	if (bfa_fcs_port_is_target(port)) {
+		rport->tin = bfa_fcs_tin_create(rport);
+		if (!rport->tin) {
+			bfa_trc(fcs, rpid);
+			bfa_rport_delete(rport->bfa_rport);
+			kfree(rport_drv);
+			return NULL;
+		}
+	}
+
+	bfa_fcs_port_add_rport(port, rport);
+
+	bfa_sm_set_state(rport, bfa_fcs_rport_sm_uninit);
+
+	/*
+	 * Initialize the Rport Features(RPF) Sub Module
+	 */
+	if (!BFA_FCS_PID_IS_WKA(rport->pid))
+		bfa_fcs_rpf_init(rport);
+
+	return rport;
+}
+
+
+static void
+bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+
+	/**
+	 * - delete FC-4s
+	 * - delete BFA rport
+	 * - remove from queue of rports
+	 */
+	if (bfa_fcs_port_is_initiator(port))
+		bfa_fcs_itnim_delete(rport->itnim);
+
+	if (bfa_fcs_port_is_target(port))
+		bfa_fcs_tin_delete(rport->tin);
+
+	bfa_rport_delete(rport->bfa_rport);
+	bfa_fcs_port_del_rport(port, rport);
+	kfree(rport->rp_drv);
+}
+
+static void
+bfa_fcs_rport_aen_post(struct bfa_fcs_rport_s *rport,
+		       enum bfa_rport_aen_event event,
+		       struct bfa_rport_aen_data_s *data)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = rport->fcs->logm;
+	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(rport->port);
+	wwn_t           rpwwn = rport->pwwn;
+	char            lpwwn_ptr[BFA_STRING_32];
+	char            rpwwn_ptr[BFA_STRING_32];
+	char           *prio_str[] = { "unknown", "high", "medium", "low" };
+
+	wwn2str(lpwwn_ptr, lpwwn);
+	wwn2str(rpwwn_ptr, rpwwn);
+
+	switch (event) {
+	case BFA_RPORT_AEN_ONLINE:
+		bfa_log(logmod, BFA_AEN_RPORT_ONLINE, rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_RPORT_AEN_OFFLINE:
+		bfa_log(logmod, BFA_AEN_RPORT_OFFLINE, rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_RPORT_AEN_DISCONNECT:
+		bfa_log(logmod, BFA_AEN_RPORT_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_RPORT_AEN_QOS_PRIO:
+		aen_data.rport.priv.qos = data->priv.qos;
+		bfa_log(logmod, BFA_AEN_RPORT_QOS_PRIO,
+			prio_str[aen_data.rport.priv.qos.qos_priority],
+			rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_RPORT_AEN_QOS_FLOWID:
+		aen_data.rport.priv.qos = data->priv.qos;
+		bfa_log(logmod, BFA_AEN_RPORT_QOS_FLOWID,
+			aen_data.rport.priv.qos.qos_flow_id, rpwwn_ptr,
+			lpwwn_ptr);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.rport.vf_id = rport->port->fabric->vf_id;
+	aen_data.rport.ppwwn =
+		bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(rport->fcs));
+	aen_data.rport.lpwwn = lpwwn;
+	aen_data.rport.rpwwn = rpwwn;
+}
+
+static void
+bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+
+	rport->stats.onlines++;
+
+	if (bfa_fcs_port_is_initiator(port)) {
+		bfa_fcs_itnim_rport_online(rport->itnim);
+		if (!BFA_FCS_PID_IS_WKA(rport->pid))
+			bfa_fcs_rpf_rport_online(rport);
+	};
+
+	if (bfa_fcs_port_is_target(port))
+		bfa_fcs_tin_rport_online(rport->tin);
+
+	/*
+	 * Don't post events for well known addresses
+	 */
+	if (!BFA_FCS_PID_IS_WKA(rport->pid))
+		bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_ONLINE, NULL);
+}
+
+static void
+bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+
+	rport->stats.offlines++;
+
+	/*
+	 * Don't post events for well known addresses
+	 */
+	if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
+		if (bfa_fcs_port_is_online(rport->port) == BFA_TRUE) {
+			bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_DISCONNECT,
+					       NULL);
+		} else {
+			bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_OFFLINE,
+					       NULL);
+		}
+	}
+
+	if (bfa_fcs_port_is_initiator(port)) {
+		bfa_fcs_itnim_rport_offline(rport->itnim);
+		if (!BFA_FCS_PID_IS_WKA(rport->pid))
+			bfa_fcs_rpf_rport_offline(rport);
+	}
+
+	if (bfa_fcs_port_is_target(port))
+		bfa_fcs_tin_rport_offline(rport->tin);
+}
+
+/**
+ * Update rport parameters from PLOGI or PLOGI accept.
+ */
+static void
+bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+
+	/**
+	 * - port name
+	 * - node name
+	 */
+	rport->pwwn = plogi->port_name;
+	rport->nwwn = plogi->node_name;
+
+	/**
+	 * - class of service
+	 */
+	rport->fc_cos = 0;
+	if (plogi->class3.class_valid)
+		rport->fc_cos = FC_CLASS_3;
+
+	if (plogi->class2.class_valid)
+		rport->fc_cos |= FC_CLASS_2;
+
+	/**
+	 * - CISC
+	 * - MAX receive frame size
+	 */
+	rport->cisc = plogi->csp.cisc;
+	rport->maxfrsize = bfa_os_ntohs(plogi->class3.rxsz);
+
+	bfa_trc(port->fcs, bfa_os_ntohs(plogi->csp.bbcred));
+	bfa_trc(port->fcs, port->fabric->bb_credit);
+	/**
+	 * Direct Attach P2P mode :
+	 * This is to handle a bug (233476) in IBM targets in Direct Attach
+	 * Mode. Basically, in FLOGI Accept the target would have erroneously
+	 * set the BB Credit to the value used in the FLOGI sent by the HBA.
+	 * It uses the correct value (its own BB credit) in PLOGI.
+	 */
+	if ((!bfa_fcs_fabric_is_switched(port->fabric))
+	    && (bfa_os_ntohs(plogi->csp.bbcred) < port->fabric->bb_credit)) {
+
+		bfa_trc(port->fcs, bfa_os_ntohs(plogi->csp.bbcred));
+		bfa_trc(port->fcs, port->fabric->bb_credit);
+
+		port->fabric->bb_credit = bfa_os_ntohs(plogi->csp.bbcred);
+		bfa_pport_set_tx_bbcredit(port->fcs->bfa,
+					  port->fabric->bb_credit);
+	}
+
+}
+
+/**
+ *   Called to handle LOGO received from an existing remote port.
+ */
+static void
+bfa_fcs_rport_process_logo(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs)
+{
+	rport->reply_oxid = fchs->ox_id;
+	bfa_trc(rport->fcs, rport->reply_oxid);
+
+	rport->stats.logo_rcvd++;
+	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_RCVD);
+}
+
+
+
+/**
+ *  fcs_rport_public FCS rport public interfaces
+ */
+
+/**
+ * 	Called by bport/vport to create a remote port instance for a discovered
+ * 	remote device.
+ *
+ * @param[in] port	- base port or vport
+ * @param[in] rpid	- remote port ID
+ *
+ * @return None
+ */
+struct bfa_fcs_rport_s *
+bfa_fcs_rport_create(struct bfa_fcs_port_s *port, u32 rpid)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, rpid);
+	rport = bfa_fcs_rport_alloc(port, WWN_NULL, rpid);
+	if (!rport)
+		return NULL;
+
+	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
+	return rport;
+}
+
+/**
+ * Called to create a rport for which only the wwn is known.
+ *
+ * @param[in] port	- base port
+ * @param[in] rpwwn	- remote port wwn
+ *
+ * @return None
+ */
+struct bfa_fcs_rport_s *
+bfa_fcs_rport_create_by_wwn(struct bfa_fcs_port_s *port, wwn_t rpwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, rpwwn);
+	rport = bfa_fcs_rport_alloc(port, rpwwn, 0);
+	if (!rport)
+		return NULL;
+
+	bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_DISC);
+	return rport;
+}
+
+/**
+ * Called by bport in private loop topology to indicate that a
+ * rport has been discovered and plogi has been completed.
+ *
+ * @param[in] port	- base port or vport
+ * @param[in] rpid	- remote port ID
+ */
+void
+bfa_fcs_rport_start(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
+			struct fc_logi_s *plogi)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	rport = bfa_fcs_rport_alloc(port, WWN_NULL, fchs->s_id);
+	if (!rport)
+		return;
+
+	bfa_fcs_rport_update(rport, plogi);
+
+	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_COMP);
+}
+
+/**
+ *   Called by bport/vport to handle PLOGI received from a new remote port.
+ *   If an existing rport does a plogi, it will be handled separately.
+ */
+void
+bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
+			   struct fc_logi_s *plogi)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	rport = bfa_fcs_rport_alloc(port, plogi->port_name, fchs->s_id);
+	if (!rport)
+		return;
+
+	bfa_fcs_rport_update(rport, plogi);
+
+	rport->reply_oxid = fchs->ox_id;
+	bfa_trc(rport->fcs, rport->reply_oxid);
+
+	rport->stats.plogi_rcvd++;
+	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_RCVD);
+}
+
+static int
+wwn_compare(wwn_t wwn1, wwn_t wwn2)
+{
+	u8        *b1 = (u8 *) &wwn1;
+	u8        *b2 = (u8 *) &wwn2;
+	int             i;
+
+	for (i = 0; i < sizeof(wwn_t); i++) {
+		if (b1[i] < b2[i])
+			return -1;
+		if (b1[i] > b2[i])
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ *   Called by bport/vport to handle PLOGI received from an existing
+ * 	 remote port.
+ */
+void
+bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
+		    struct fc_logi_s *plogi)
+{
+	/**
+	 * @todo Handle P2P and initiator-initiator.
+	 */
+
+	bfa_fcs_rport_update(rport, plogi);
+
+	rport->reply_oxid = rx_fchs->ox_id;
+	bfa_trc(rport->fcs, rport->reply_oxid);
+
+	/**
+	 * In Switched fabric topology,
+	 * PLOGI to each other. If our pwwn is smaller, ignore it,
+	 * if it is not a well known address.
+	 * If the link topology is N2N,
+	 * this Plogi should be accepted.
+	 */
+	if ((wwn_compare(rport->port->port_cfg.pwwn, rport->pwwn) == -1)
+	    && (bfa_fcs_fabric_is_switched(rport->port->fabric))
+	    && (!BFA_FCS_PID_IS_WKA(rport->pid))) {
+		bfa_trc(rport->fcs, rport->pid);
+		return;
+	}
+
+	rport->stats.plogi_rcvd++;
+	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_RCVD);
+}
+
+/**
+ * Called by bport/vport to delete a remote port instance.
+ *
+* Rport delete is called under the following conditions:
+ * 		- vport is deleted
+ * 		- vf is deleted
+ * 		- explicit request from OS to delete rport (vmware)
+ */
+void
+bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
+}
+
+/**
+ * Called by bport/vport to  when a target goes offline.
+ *
+ */
+void
+bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
+}
+
+/**
+ * Called by bport in n2n when a target (attached port) becomes online.
+ *
+ */
+void
+bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
+}
+
+/**
+ *   Called by bport/vport to notify SCN for the remote port
+ */
+void
+bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport)
+{
+
+	rport->stats.rscns++;
+	bfa_sm_send_event(rport, RPSM_EVENT_SCN);
+}
+
+/**
+ *   Called by  fcpim to notify that the ITN cleanup is done.
+ */
+void
+bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
+}
+
+/**
+ *   Called by fcptm to notify that the ITN cleanup is done.
+ */
+void
+bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
+}
+
+/**
+ *     This routine BFA callback for bfa_rport_online() call.
+ *
+ * 	param[in] 	cb_arg	-  rport struct.
+ *
+ * 	return
+ * 		void
+ *
+* 	Special Considerations:
+ *
+ * 	note
+ */
+void
+bfa_cb_rport_online(void *cbarg)
+{
+
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_sm_send_event(rport, RPSM_EVENT_HCB_ONLINE);
+}
+
+/**
+ *     This routine BFA callback for bfa_rport_offline() call.
+ *
+ * 	param[in] 	rport 	-
+ *
+ * 	return
+ * 		void
+ *
+ * 	Special Considerations:
+ *
+ * 	note
+ */
+void
+bfa_cb_rport_offline(void *cbarg)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_sm_send_event(rport, RPSM_EVENT_HCB_OFFLINE);
+}
+
+/**
+ * This routine is a static BFA callback when there is a QoS flow_id
+ * change notification
+ *
+ * @param[in] 	rport 	-
+ *
+ * @return  	void
+ *
+ * Special Considerations:
+ *
+ * @note
+ */
+void
+bfa_cb_rport_qos_scn_flowid(void *cbarg,
+			    struct bfa_rport_qos_attr_s old_qos_attr,
+			    struct bfa_rport_qos_attr_s new_qos_attr)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_rport_aen_data_s aen_data;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	aen_data.priv.qos = new_qos_attr;
+	bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_QOS_FLOWID, &aen_data);
+}
+
+/**
+ * This routine is a static BFA callback when there is a QoS priority
+ * change notification
+ *
+ * @param[in] 	rport 	-
+ *
+ * @return 	void
+ *
+ * Special Considerations:
+ *
+ * @note
+ */
+void
+bfa_cb_rport_qos_scn_prio(void *cbarg, struct bfa_rport_qos_attr_s old_qos_attr,
+			  struct bfa_rport_qos_attr_s new_qos_attr)
+{
+	struct bfa_fcs_rport_s *rport = (struct bfa_fcs_rport_s *)cbarg;
+	struct bfa_rport_aen_data_s aen_data;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	aen_data.priv.qos = new_qos_attr;
+	bfa_fcs_rport_aen_post(rport, BFA_RPORT_AEN_QOS_PRIO, &aen_data);
+}
+
+/**
+ * 		Called to process any unsolicted frames from this remote port
+ */
+void
+bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport)
+{
+	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
+}
+
+/**
+ * 		Called to process any unsolicted frames from this remote port
+ */
+void
+bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
+			u16 len)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fc_els_cmd_s   *els_cmd;
+
+	bfa_trc(rport->fcs, fchs->s_id);
+	bfa_trc(rport->fcs, fchs->d_id);
+	bfa_trc(rport->fcs, fchs->type);
+
+	if (fchs->type != FC_TYPE_ELS)
+		return;
+
+	els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	bfa_trc(rport->fcs, els_cmd->els_code);
+
+	switch (els_cmd->els_code) {
+	case FC_ELS_LOGO:
+		bfa_fcs_rport_process_logo(rport, fchs);
+		break;
+
+	case FC_ELS_ADISC:
+		bfa_fcs_rport_process_adisc(rport, fchs, len);
+		break;
+
+	case FC_ELS_PRLO:
+		if (bfa_fcs_port_is_initiator(port))
+			bfa_fcs_fcpim_uf_recv(rport->itnim, fchs, len);
+
+		if (bfa_fcs_port_is_target(port))
+			bfa_fcs_fcptm_uf_recv(rport->tin, fchs, len);
+		break;
+
+	case FC_ELS_PRLI:
+		bfa_fcs_rport_process_prli(rport, fchs, len);
+		break;
+
+	case FC_ELS_RPSC:
+		bfa_fcs_rport_process_rpsc(rport, fchs, len);
+		break;
+
+	default:
+		bfa_fcs_rport_send_ls_rjt(rport, fchs,
+					  FC_LS_RJT_RSN_CMD_NOT_SUPP,
+					  FC_LS_RJT_EXP_NO_ADDL_INFO);
+		break;
+	}
+}
+
+/*
+ * Send a LS reject
+ */
+static void
+bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
+			  u8 reason_code, u8 reason_code_expl)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(rport->fcs, rx_fchs->s_id);
+
+	fcxp = bfa_fcs_fcxp_alloc(rport->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
+			      reason_code, reason_code_expl);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+}
+
+/**
+ *   Module initialization
+ */
+void
+bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs)
+{
+}
+
+/**
+ *   Module cleanup
+ */
+void
+bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
+
+/**
+ * Return state of rport.
+ */
+int
+bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport)
+{
+	return bfa_sm_to_state(rport_sm_table, rport->sm);
+}
+
+/**
+ * 		 Called by the Driver to set rport delete/ageout timeout
+ *
+ * 	param[in]		rport timeout value in seconds.
+ *
+ * 	return None
+ */
+void
+bfa_fcs_rport_set_del_timeout(u8 rport_tmo)
+{
+	/*
+	 * convert to Millisecs
+	 */
+	if (rport_tmo > 0)
+		bfa_fcs_rport_del_timeout = rport_tmo * 1000;
+}
diff -urpN orig/drivers/scsi/bfa/rport_api.c patch/drivers/scsi/bfa/rport_api.c
--- orig/drivers/scsi/bfa/rport_api.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport_api.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,180 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_vport.h"
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_trcmod.h"
+
+BFA_TRC_FILE(FCS, RPORT_API);
+
+/**
+ *  rport_api.c Remote port implementation.
+ */
+
+/**
+ *  fcs_rport_api FCS rport API.
+ */
+
+/**
+ * 	Direct API to add a target by port wwn. This interface is used, for
+ *	example, by bios when target pwwn is known from boot lun configuration.
+ */
+bfa_status_t
+bfa_fcs_rport_add(struct bfa_fcs_port_s *port, wwn_t *pwwn,
+			struct bfa_fcs_rport_s *rport,
+			struct bfad_rport_s *rport_drv)
+{
+	bfa_trc(port->fcs, *pwwn);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *	Direct API to remove a target and its associated resources. This
+ *	interface is used, for example, by vmware driver to remove target
+ *	ports from the target list for a VM.
+ */
+bfa_status_t
+bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport_in)
+{
+
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(rport_in->fcs, rport_in->pwwn);
+
+	rport = bfa_fcs_port_get_rport_by_pwwn(rport_in->port, rport_in->pwwn);
+	if (rport == NULL) {
+		/*
+		 * TBD Error handling
+		 */
+		bfa_trc(rport_in->fcs, rport_in->pid);
+		return BFA_STATUS_UNKNOWN_RWWN;
+	}
+
+	/*
+	 * TBD if this remote port is online, send a logo
+	 */
+	return BFA_STATUS_OK;
+
+}
+
+/**
+ *	Remote device status for display/debug.
+ */
+void
+bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_attr_s *rport_attr)
+{
+	struct bfa_rport_qos_attr_s qos_attr;
+	struct bfa_fcs_port_s *port = rport->port;
+
+	bfa_os_memset(rport_attr, 0, sizeof(struct bfa_rport_attr_s));
+
+	rport_attr->pid = rport->pid;
+	rport_attr->pwwn = rport->pwwn;
+	rport_attr->nwwn = rport->nwwn;
+	rport_attr->cos_supported = rport->fc_cos;
+	rport_attr->df_sz = rport->maxfrsize;
+	rport_attr->state = bfa_fcs_rport_get_state(rport);
+	rport_attr->fc_cos = rport->fc_cos;
+	rport_attr->cisc = rport->cisc;
+	rport_attr->scsi_function = rport->scsi_function;
+	rport_attr->curr_speed  = rport->rpf.rpsc_speed;
+	rport_attr->assigned_speed  = rport->rpf.assigned_speed;
+
+	bfa_rport_get_qos_attr(rport->bfa_rport, &qos_attr);
+	rport_attr->qos_attr = qos_attr;
+
+	rport_attr->trl_enforced = BFA_FALSE;
+	if (bfa_pport_is_ratelim(port->fcs->bfa)) {
+		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_UNKNOWN) ||
+			(rport->rpf.rpsc_speed <
+			bfa_fcs_port_get_rport_max_speed(port)))
+			rport_attr->trl_enforced = BFA_TRUE;
+	}
+
+	/*
+	 * TODO
+	 * rport->symname
+	 */
+}
+
+/**
+ * 	Per remote device statistics.
+ */
+void
+bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_stats_s *stats)
+{
+	*stats = rport->stats;
+}
+
+void
+bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport)
+{
+	bfa_os_memset((char *)&rport->stats, 0,
+			sizeof(struct bfa_rport_stats_s));
+}
+
+struct bfa_fcs_rport_s *
+bfa_fcs_rport_lookup(struct bfa_fcs_port_s *port, wwn_t rpwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	rport = bfa_fcs_port_get_rport_by_pwwn(port, rpwwn);
+	if (rport == NULL) {
+		/*
+		 * TBD Error handling
+		 */
+	}
+
+	return rport;
+}
+
+struct bfa_fcs_rport_s *
+bfa_fcs_rport_lookup_by_nwwn(struct bfa_fcs_port_s *port, wwn_t rnwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	rport = bfa_fcs_port_get_rport_by_nwwn(port, rnwwn);
+	if (rport == NULL) {
+		/*
+		 * TBD Error handling
+		 */
+	}
+
+	return rport;
+}
+
+/*
+ * This API is to set the Rport's speed. Should be used when RPSC is not
+ * supported by the rport.
+ */
+void
+bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport,
+			enum bfa_pport_speed speed)
+{
+	rport->rpf.assigned_speed  = speed;
+
+	/* Set this speed in f/w only if the RPSC speed is not available */
+	if (rport->rpf.rpsc_speed == BFA_PPORT_SPEED_UNKNOWN)
+		bfa_rport_speed(rport->bfa_rport, speed);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/rport_ftrs.c patch/drivers/scsi/bfa/rport_ftrs.c
--- orig/drivers/scsi/bfa/rport_ftrs.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport_ftrs.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,375 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  rport_ftrs.c Remote port features (RPF) implementation.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcbuild.h"
+#include "fcs_rport.h"
+#include "fcs_lport.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs.h"
+
+BFA_TRC_FILE(FCS, RPORT_FTRS);
+
+#define BFA_FCS_RPF_RETRIES	(3)
+#define BFA_FCS_RPF_RETRY_TIMEOUT  (1000) /* 1 sec (In millisecs) */
+
+static void     bfa_fcs_rpf_send_rpsc2(void *rport_cbarg,
+			struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_rpf_rpsc2_response(void *fcsarg,
+			struct bfa_fcxp_s *fcxp, void *cbarg,
+			bfa_status_t req_status, u32 rsp_len,
+			u32 resid_len,
+			struct fchs_s *rsp_fchs);
+static void     bfa_fcs_rpf_timeout(void *arg);
+
+/**
+ *  fcs_rport_ftrs_sm FCS rport state machine events
+ */
+
+enum rpf_event {
+	RPFSM_EVENT_RPORT_OFFLINE  = 1,     /*  Rport offline            */
+	RPFSM_EVENT_RPORT_ONLINE   = 2,     /*  Rport online            */
+	RPFSM_EVENT_FCXP_SENT      = 3,    /*  Frame from has been sent */
+	RPFSM_EVENT_TIMEOUT  	   = 4,    /*  Rport SM timeout event   */
+	RPFSM_EVENT_RPSC_COMP      = 5,
+	RPFSM_EVENT_RPSC_FAIL      = 6,
+	RPFSM_EVENT_RPSC_ERROR     = 7,
+};
+
+static void	bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf,
+					enum rpf_event event);
+static void     bfa_fcs_rpf_sm_rpsc_sending(struct bfa_fcs_rpf_s *rpf,
+					       enum rpf_event event);
+static void     bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s *rpf,
+					       enum rpf_event event);
+static void 	bfa_fcs_rpf_sm_rpsc_retry(struct bfa_fcs_rpf_s *rpf,
+							enum rpf_event event);
+static void     bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf,
+							enum rpf_event event);
+static void     bfa_fcs_rpf_sm_online(struct bfa_fcs_rpf_s *rpf,
+							enum rpf_event event);
+
+static void
+bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_RPORT_ONLINE :
+		if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
+			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
+			rpf->rpsc_retries = 0;
+			bfa_fcs_rpf_send_rpsc2(rpf, NULL);
+			break;
+		};
+
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_rpf_sm_rpsc_sending(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc);
+		break;
+
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
+		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rpf->fcxp_wqe);
+		rpf->rpsc_retries = 0;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_RPSC_COMP:
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_online);
+		/* Update speed info in f/w via BFA */
+		if (rpf->rpsc_speed != BFA_PPORT_SPEED_UNKNOWN) {
+			bfa_rport_speed(rport->bfa_rport, rpf->rpsc_speed);
+		} else if (rpf->assigned_speed != BFA_PPORT_SPEED_UNKNOWN) {
+			bfa_rport_speed(rport->bfa_rport, rpf->assigned_speed);
+		}
+		break;
+
+	case RPFSM_EVENT_RPSC_FAIL:
+		/* RPSC not supported by rport */
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_online);
+		break;
+
+	case RPFSM_EVENT_RPSC_ERROR:
+		/* need to retry...delayed a bit. */
+		if (rpf->rpsc_retries++ < BFA_FCS_RPF_RETRIES) {
+			bfa_timer_start(rport->fcs->bfa, &rpf->timer,
+				    bfa_fcs_rpf_timeout, rpf,
+				    BFA_FCS_RPF_RETRY_TIMEOUT);
+			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_retry);
+		} else {
+			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_online);
+		}
+		break;
+
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
+		bfa_fcxp_discard(rpf->fcxp);
+		rpf->rpsc_retries = 0;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_rpf_sm_rpsc_retry(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_TIMEOUT :
+		/* re-send the RPSC */
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
+		bfa_fcs_rpf_send_rpsc2(rpf, NULL);
+		break;
+
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		bfa_timer_stop(&rpf->timer);
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
+		rpf->rpsc_retries = 0;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_rpf_sm_online(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
+		rpf->rpsc_retries = 0;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
+{
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_trc(rport->fcs, event);
+
+	switch (event) {
+	case RPFSM_EVENT_RPORT_ONLINE :
+		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
+		bfa_fcs_rpf_send_rpsc2(rpf, NULL);
+		break;
+
+	case RPFSM_EVENT_RPORT_OFFLINE :
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+/**
+ * Called when Rport is created.
+ */
+void  bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_rpf_s *rpf = &rport->rpf;
+
+	bfa_trc(rport->fcs, rport->pid);
+	rpf->rport = rport;
+
+	bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_uninit);
+}
+
+/**
+ * Called when Rport becomes online
+ */
+void  bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport)
+{
+	bfa_trc(rport->fcs, rport->pid);
+
+	if (__fcs_min_cfg(rport->port->fcs))
+		return;
+
+	if (bfa_fcs_fabric_is_switched(rport->port->fabric))
+		bfa_sm_send_event(&rport->rpf, RPFSM_EVENT_RPORT_ONLINE);
+}
+
+/**
+ * Called when Rport becomes offline
+ */
+void  bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport)
+{
+	bfa_trc(rport->fcs, rport->pid);
+
+	if (__fcs_min_cfg(rport->port->fcs))
+		return;
+
+	bfa_sm_send_event(&rport->rpf, RPFSM_EVENT_RPORT_OFFLINE);
+}
+
+static void
+bfa_fcs_rpf_timeout(void *arg)
+{
+	struct bfa_fcs_rpf_s *rpf = (struct bfa_fcs_rpf_s *) arg;
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+
+	bfa_trc(rport->fcs, rport->pid);
+	bfa_sm_send_event(rpf, RPFSM_EVENT_TIMEOUT);
+}
+
+static void
+bfa_fcs_rpf_send_rpsc2(void *rpf_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_rpf_s *rpf 	= (struct bfa_fcs_rpf_s *)rpf_cbarg;
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(rport->fcs, rport->pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &rpf->fcxp_wqe,
+					bfa_fcs_rpf_send_rpsc2, rpf);
+		return;
+	}
+	rpf->fcxp = fcxp;
+
+	len = fc_rpsc2_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rport->pid,
+			    bfa_fcs_port_get_fcid(port), &rport->pid, 1);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+			  FC_CLASS_3, len, &fchs, bfa_fcs_rpf_rpsc2_response,
+			  rpf, FC_MAX_PDUSZ, FC_RA_TOV);
+	rport->stats.rpsc_sent++;
+	bfa_sm_send_event(rpf, RPFSM_EVENT_FCXP_SENT);
+
+}
+
+static void
+bfa_fcs_rpf_rpsc2_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			    bfa_status_t req_status, u32 rsp_len,
+			    u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_rpf_s *rpf = (struct bfa_fcs_rpf_s *) cbarg;
+	struct bfa_fcs_rport_s *rport = rpf->rport;
+	struct fc_ls_rjt_s    *ls_rjt;
+	struct fc_rpsc2_acc_s  *rpsc2_acc;
+	u16        num_ents;
+
+	bfa_trc(rport->fcs, req_status);
+
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(rport->fcs, req_status);
+		if (req_status == BFA_STATUS_ETIMER)
+			rport->stats.rpsc_failed++;
+		bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_ERROR);
+		return;
+	}
+
+	rpsc2_acc = (struct fc_rpsc2_acc_s *) BFA_FCXP_RSP_PLD(fcxp);
+	if (rpsc2_acc->els_cmd == FC_ELS_ACC) {
+		rport->stats.rpsc_accs++;
+		num_ents = bfa_os_ntohs(rpsc2_acc->num_pids);
+		bfa_trc(rport->fcs, num_ents);
+		if (num_ents > 0) {
+			bfa_assert(rpsc2_acc->port_info[0].pid != rport->pid);
+			bfa_trc(rport->fcs,
+				bfa_os_ntohs(rpsc2_acc->port_info[0].pid));
+			bfa_trc(rport->fcs,
+				bfa_os_ntohs(rpsc2_acc->port_info[0].speed));
+			bfa_trc(rport->fcs,
+				bfa_os_ntohs(rpsc2_acc->port_info[0].index));
+			bfa_trc(rport->fcs,
+				rpsc2_acc->port_info[0].type);
+
+			if (rpsc2_acc->port_info[0].speed == 0) {
+				bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_ERROR);
+				return;
+			}
+
+			rpf->rpsc_speed = fc_rpsc_operspeed_to_bfa_speed(
+				bfa_os_ntohs(rpsc2_acc->port_info[0].speed));
+
+			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_COMP);
+		}
+	} else {
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+		bfa_trc(rport->fcs, ls_rjt->reason_code);
+		bfa_trc(rport->fcs, ls_rjt->reason_code_expl);
+		rport->stats.rpsc_rejects++;
+		if (ls_rjt->reason_code == FC_LS_RJT_RSN_CMD_NOT_SUPP) {
+			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_FAIL);
+		} else {
+			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_ERROR);
+		}
+	}
+}
diff -urpN orig/drivers/scsi/bfa/scn.c patch/drivers/scsi/bfa/scn.c
--- orig/drivers/scsi/bfa/scn.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/scn.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,482 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_ms.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs.h"
+#include "lport_priv.h"
+
+BFA_TRC_FILE(FCS, SCN);
+
+#define FC_QOS_RSCN_EVENT		0x0c
+#define FC_FABRIC_NAME_RSCN_EVENT	0x0d
+
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_port_scn_send_scr(void *scn_cbarg,
+					  struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_scn_scr_response(void *fcsarg,
+					      struct bfa_fcxp_s *fcxp,
+					      void *cbarg,
+					      bfa_status_t req_status,
+					      u32 rsp_len,
+					      u32 resid_len,
+					      struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_scn_send_ls_acc(struct bfa_fcs_port_s *port,
+					     struct fchs_s *rx_fchs);
+static void     bfa_fcs_port_scn_timeout(void *arg);
+
+/**
+ *  fcs_scm_sm FCS SCN state machine
+ */
+
+/**
+ * VPort SCN State Machine events
+ */
+enum port_scn_event {
+	SCNSM_EVENT_PORT_ONLINE = 1,
+	SCNSM_EVENT_PORT_OFFLINE = 2,
+	SCNSM_EVENT_RSP_OK = 3,
+	SCNSM_EVENT_RSP_ERROR = 4,
+	SCNSM_EVENT_TIMEOUT = 5,
+	SCNSM_EVENT_SCR_SENT = 6,
+};
+
+static void     bfa_fcs_port_scn_sm_offline(struct bfa_fcs_port_scn_s *scn,
+					    enum port_scn_event event);
+static void     bfa_fcs_port_scn_sm_sending_scr(struct bfa_fcs_port_scn_s *scn,
+						enum port_scn_event event);
+static void     bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
+					enum port_scn_event event);
+static void     bfa_fcs_port_scn_sm_scr_retry(struct bfa_fcs_port_scn_s *scn,
+					      enum port_scn_event event);
+static void     bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
+					   enum port_scn_event event);
+
+/**
+ * 		Starting state - awaiting link up.
+ */
+static void
+bfa_fcs_port_scn_sm_offline(struct bfa_fcs_port_scn_s *scn,
+			    enum port_scn_event event)
+{
+	switch (event) {
+	case SCNSM_EVENT_PORT_ONLINE:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_sending_scr);
+		bfa_fcs_port_scn_send_scr(scn, NULL);
+		break;
+
+	case SCNSM_EVENT_PORT_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_scn_sm_sending_scr(struct bfa_fcs_port_scn_s *scn,
+				enum port_scn_event event)
+{
+	switch (event) {
+	case SCNSM_EVENT_SCR_SENT:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_scr);
+		break;
+
+	case SCNSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_offline);
+		bfa_fcxp_walloc_cancel(scn->port->fcs->bfa, &scn->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_scn_sm_scr(struct bfa_fcs_port_scn_s *scn,
+			enum port_scn_event event)
+{
+	struct bfa_fcs_port_s *port = scn->port;
+
+	switch (event) {
+	case SCNSM_EVENT_RSP_OK:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_online);
+		break;
+
+	case SCNSM_EVENT_RSP_ERROR:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_scr_retry);
+		bfa_timer_start(port->fcs->bfa, &scn->timer,
+				bfa_fcs_port_scn_timeout, scn,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case SCNSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_offline);
+		bfa_fcxp_discard(scn->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_scn_sm_scr_retry(struct bfa_fcs_port_scn_s *scn,
+			      enum port_scn_event event)
+{
+	switch (event) {
+	case SCNSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_sending_scr);
+		bfa_fcs_port_scn_send_scr(scn, NULL);
+		break;
+
+	case SCNSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_offline);
+		bfa_timer_stop(&scn->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_scn_sm_online(struct bfa_fcs_port_scn_s *scn,
+			   enum port_scn_event event)
+{
+	switch (event) {
+	case SCNSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  fcs_scn_private FCS SCN private functions
+ */
+
+/**
+ * This routine will be called to send a SCR command.
+ */
+static void
+bfa_fcs_port_scn_send_scr(void *scn_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_scn_s *scn = scn_cbarg;
+	struct bfa_fcs_port_s *port = scn->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &scn->fcxp_wqe,
+				    bfa_fcs_port_scn_send_scr, scn);
+		return;
+	}
+	scn->fcxp = fcxp;
+
+	/*
+	 * Handle VU registrations for Base port only
+	 */
+	if ((!port->vport) && bfa_ioc_get_fcmode(&port->fcs->bfa->ioc)) {
+		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				   bfa_lps_is_brcd_fabric(port->fabric->lps),
+				   port->pid, 0);
+	} else {
+		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), BFA_FALSE,
+				   port->pid, 0);
+	}
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_scn_scr_response,
+		      (void *)scn, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(scn, SCNSM_EVENT_SCR_SENT);
+}
+
+static void
+bfa_fcs_port_scn_scr_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+			      void *cbarg, bfa_status_t req_status,
+			      u32 rsp_len, u32 resid_len,
+			      struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *)cbarg;
+	struct bfa_fcs_port_s *port = scn->port;
+	struct fc_els_cmd_s   *els_cmd;
+	struct fc_ls_rjt_s    *ls_rjt;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(scn, SCNSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+	switch (els_cmd->els_code) {
+
+	case FC_ELS_ACC:
+		bfa_sm_send_event(scn, SCNSM_EVENT_RSP_OK);
+		break;
+
+	case FC_ELS_LS_RJT:
+
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+		bfa_trc(port->fcs, ls_rjt->reason_code);
+		bfa_trc(port->fcs, ls_rjt->reason_code_expl);
+
+		bfa_sm_send_event(scn, SCNSM_EVENT_RSP_ERROR);
+		break;
+
+	default:
+		bfa_sm_send_event(scn, SCNSM_EVENT_RSP_ERROR);
+	}
+}
+
+/*
+ * Send a LS Accept
+ */
+static void
+bfa_fcs_port_scn_send_ls_acc(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_rport_s *bfa_rport = NULL;
+	int             len;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id);
+
+	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+		      FC_MAX_PDUSZ, 0);
+}
+
+/**
+ *     This routine will be called by bfa_timer on timer timeouts.
+ *
+ * 	param[in] 	vport 			- pointer to bfa_fcs_port_t.
+ * 	param[out]	vport_status 	- pointer to return vport status in
+ *
+ * 	return
+ * 		void
+ *
+*  	Special Considerations:
+ *
+ * 	note
+ */
+static void
+bfa_fcs_port_scn_timeout(void *arg)
+{
+	struct bfa_fcs_port_scn_s *scn = (struct bfa_fcs_port_scn_s *)arg;
+
+	bfa_sm_send_event(scn, SCNSM_EVENT_TIMEOUT);
+}
+
+
+
+/**
+ *  fcs_scn_public FCS state change notification public interfaces
+ */
+
+/*
+ * Functions called by port/fab
+ */
+void
+bfa_fcs_port_scn_init(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
+
+	scn->port = port;
+	bfa_sm_set_state(scn, bfa_fcs_port_scn_sm_offline);
+}
+
+void
+bfa_fcs_port_scn_offline(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
+
+	scn->port = port;
+	bfa_sm_send_event(scn, SCNSM_EVENT_PORT_OFFLINE);
+}
+
+void
+bfa_fcs_port_scn_online(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
+
+	scn->port = port;
+	bfa_sm_send_event(scn, SCNSM_EVENT_PORT_ONLINE);
+}
+
+static void
+bfa_fcs_port_scn_portid_rscn(struct bfa_fcs_port_s *port, u32 rpid)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, rpid);
+
+	/**
+	 * If this is an unknown device, then it just came online.
+	 * Otherwise let rport handle the RSCN event.
+	 */
+	rport = bfa_fcs_port_get_rport_by_pid(port, rpid);
+	if (rport == NULL) {
+		/*
+		 * If min cfg mode is enabled, we donot need to
+		 * discover any new rports.
+		 */
+		if (!__fcs_min_cfg(port->fcs))
+			rport = bfa_fcs_rport_create(port, rpid);
+	} else {
+		bfa_fcs_rport_scn(rport);
+	}
+}
+
+/**
+ * rscn format based PID comparison
+ */
+#define __fc_pid_match(__c0, __c1, __fmt)		\
+	(((__fmt) == FC_RSCN_FORMAT_FABRIC) ||		\
+	 (((__fmt) == FC_RSCN_FORMAT_DOMAIN) &&		\
+	  ((__c0)[0] == (__c1)[0])) ||			\
+	 (((__fmt) == FC_RSCN_FORMAT_AREA) &&		\
+	  ((__c0)[0] == (__c1)[0]) &&			\
+	  ((__c0)[1] == (__c1)[1])))
+
+static void
+bfa_fcs_port_scn_multiport_rscn(struct bfa_fcs_port_s *port,
+			enum fc_rscn_format format, u32 rscn_pid)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe, *qe_next;
+	u8        *c0, *c1;
+
+	bfa_trc(port->fcs, format);
+	bfa_trc(port->fcs, rscn_pid);
+
+	c0 = (u8 *) &rscn_pid;
+
+	list_for_each_safe(qe, qe_next, &port->rport_q) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		c1 = (u8 *) &rport->pid;
+		if (__fc_pid_match(c0, c1, format))
+			bfa_fcs_rport_scn(rport);
+	}
+}
+
+void
+bfa_fcs_port_scn_process_rscn(struct bfa_fcs_port_s *port, struct fchs_s *fchs,
+			      u32 len)
+{
+	struct fc_rscn_pl_s   *rscn = (struct fc_rscn_pl_s *) (fchs + 1);
+	int             num_entries;
+	u32        rscn_pid;
+	bfa_boolean_t   nsquery = BFA_FALSE;
+	int             i = 0;
+
+	num_entries =
+		(bfa_os_ntohs(rscn->payldlen) -
+		 sizeof(u32)) / sizeof(rscn->event[0]);
+
+	bfa_trc(port->fcs, num_entries);
+
+	port->stats.num_rscn++;
+
+	bfa_fcs_port_scn_send_ls_acc(port, fchs);
+
+	for (i = 0; i < num_entries; i++) {
+		rscn_pid = rscn->event[i].portid;
+
+		bfa_trc(port->fcs, rscn->event[i].format);
+		bfa_trc(port->fcs, rscn_pid);
+
+		switch (rscn->event[i].format) {
+		case FC_RSCN_FORMAT_PORTID:
+			if (rscn->event[i].qualifier == FC_QOS_RSCN_EVENT) {
+				/*
+				 * Ignore this event. f/w would have processed
+				 * it
+				 */
+				bfa_trc(port->fcs, rscn_pid);
+			} else {
+				port->stats.num_portid_rscn++;
+				bfa_fcs_port_scn_portid_rscn(port, rscn_pid);
+			}
+			break;
+
+		case FC_RSCN_FORMAT_FABRIC:
+			if (rscn->event[i].qualifier ==
+			    FC_FABRIC_NAME_RSCN_EVENT) {
+				bfa_fcs_port_ms_fabric_rscn(port);
+				break;
+			}
+			/*
+			 * !!!!!!!!! Fall Through !!!!!!!!!!!!!
+			 */
+
+		case FC_RSCN_FORMAT_AREA:
+		case FC_RSCN_FORMAT_DOMAIN:
+			nsquery = BFA_TRUE;
+			bfa_fcs_port_scn_multiport_rscn(port,
+							rscn->event[i].format,
+							rscn_pid);
+			break;
+
+		default:
+			bfa_assert(0);
+			nsquery = BFA_TRUE;
+		}
+	}
+
+	/**
+	 * If any of area, domain or fabric RSCN is received, do a fresh discovery
+	 * to find new devices.
+	 */
+	if (nsquery)
+		bfa_fcs_port_ns_query(port);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/vfapi.c patch/drivers/scsi/bfa/vfapi.c
--- orig/drivers/scsi/bfa/vfapi.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/vfapi.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,292 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  vfapi.c Fabric module implementation.
+ */
+
+#include "fcs_fabric.h"
+#include "fcs_trcmod.h"
+
+BFA_TRC_FILE(FCS, VFAPI);
+
+/**
+ *  fcs_vf_api virtual fabrics API
+ */
+
+/**
+ * 		Enable VF mode.
+ *
+ * @param[in]		fcs		fcs module instance
+ * @param[in]		vf_id		default vf_id of port, FC_VF_ID_NULL
+ * 					to use standard default vf_id of 1.
+ *
+ * @retval	BFA_STATUS_OK		vf mode is enabled
+ * @retval	BFA_STATUS_BUSY		Port is active. Port must be disabled
+ *					before VF mode can be enabled.
+ */
+bfa_status_t
+bfa_fcs_vf_mode_enable(struct bfa_fcs_s *fcs, u16 vf_id)
+{
+	return BFA_STATUS_OK;
+}
+
+/**
+ * 		Disable VF mode.
+ *
+ * @param[in]		fcs		fcs module instance
+ *
+ * @retval	BFA_STATUS_OK		vf mode is disabled
+ * @retval	BFA_STATUS_BUSY		VFs are present and being used. All
+ * 					VFs must be deleted before disabling
+ *					VF mode.
+ */
+bfa_status_t
+bfa_fcs_vf_mode_disable(struct bfa_fcs_s *fcs)
+{
+	return BFA_STATUS_OK;
+}
+
+/**
+ * 		Create a new VF instance.
+ *
+ *  A new VF is created using the given VF configuration. A VF is identified
+ *  by VF id. No duplicate VF creation is allowed with the same VF id. Once
+ *  a VF is created, VF is automatically started after link initialization
+ *  and EVFP exchange is completed.
+ *
+ * 	param[in] vf		- 	FCS vf data structure. Memory is
+ *					allocated by caller (driver)
+ * 	param[in] fcs 		- 	FCS module
+ * 	param[in] vf_cfg	- 	VF configuration
+ * 	param[in] vf_drv 	- 	Opaque handle back to the driver's
+ *					virtual vf structure
+ *
+ * 	retval BFA_STATUS_OK VF creation is successful
+ * 	retval BFA_STATUS_FAILED VF creation failed
+ * 	retval BFA_STATUS_EEXIST A VF exists with the given vf_id
+ */
+bfa_status_t
+bfa_fcs_vf_create(bfa_fcs_vf_t *vf, struct bfa_fcs_s *fcs, u16 vf_id,
+		  struct bfa_port_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
+{
+	bfa_trc(fcs, vf_id);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to delete a BFA VF object. VF object should
+ * 		be stopped before this function call.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	retval BFA_STATUS_OK	On vf deletion success
+ * 	retval BFA_STATUS_BUSY VF is not in a stopped state
+ * 	retval BFA_STATUS_INPROGRESS VF deletion in in progress
+ */
+bfa_status_t
+bfa_fcs_vf_delete(bfa_fcs_vf_t *vf)
+{
+	bfa_trc(vf->fcs, vf->vf_id);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Start participation in VF. This triggers login to the virtual fabric.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	return None
+ */
+void
+bfa_fcs_vf_start(bfa_fcs_vf_t *vf)
+{
+	bfa_trc(vf->fcs, vf->vf_id);
+}
+
+/**
+ *  	Logout with the virtual fabric.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	retval BFA_STATUS_OK 	On success.
+ * 	retval BFA_STATUS_INPROGRESS VF is being stopped.
+ */
+bfa_status_t
+bfa_fcs_vf_stop(bfa_fcs_vf_t *vf)
+{
+	bfa_trc(vf->fcs, vf->vf_id);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Returns attributes of the given VF.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ * 	param[out] vf_attr 	vf attributes returned
+ *
+ * 	return None
+ */
+void
+bfa_fcs_vf_get_attr(bfa_fcs_vf_t *vf, struct bfa_vf_attr_s *vf_attr)
+{
+	bfa_trc(vf->fcs, vf->vf_id);
+}
+
+/**
+ * 		Return statistics associated with the given vf.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ * 	param[out] vf_stats 	vf statistics returned
+ *
+ *  @return None
+ */
+void
+bfa_fcs_vf_get_stats(bfa_fcs_vf_t *vf, struct bfa_vf_stats_s *vf_stats)
+{
+	bfa_os_memcpy(vf_stats, &vf->stats, sizeof(struct bfa_vf_stats_s));
+	return;
+}
+
+void
+/**
+ * 		clear statistics associated with the given vf.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ *
+ *  @return None
+ */
+bfa_fcs_vf_clear_stats(bfa_fcs_vf_t *vf)
+{
+	bfa_os_memset(&vf->stats, 0, sizeof(struct bfa_vf_stats_s));
+	return;
+}
+
+/**
+ *  	Returns FCS vf structure for a given vf_id.
+ *
+ * 	param[in] 	vf_id		- VF_ID
+ *
+ * 	return
+ * 		If lookup succeeds, retuns fcs vf object, otherwise returns NULL
+ */
+bfa_fcs_vf_t   *
+bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id)
+{
+	bfa_trc(fcs, vf_id);
+	if (vf_id == FC_VF_ID_NULL)
+		return (&fcs->fabric);
+
+	/**
+	 * @todo vf support
+	 */
+
+	return NULL;
+}
+
+/**
+ *  	Returns driver VF structure for a given FCS vf.
+ *
+ * 	param[in] 	vf		- pointer to bfa_vf_t
+ *
+ * 	return Driver VF structure
+ */
+struct bfad_vf_s      *
+bfa_fcs_vf_get_drv_vf(bfa_fcs_vf_t *vf)
+{
+	bfa_assert(vf);
+	bfa_trc(vf->fcs, vf->vf_id);
+	return vf->vf_drv;
+}
+
+/**
+ *  	Return the list of VFs configured.
+ *
+ * 	param[in]	fcs	fcs module instance
+ * 	param[out] 	vf_ids	returned list of vf_ids
+ * 	param[in,out] 	nvfs	in:size of vf_ids array,
+ * 				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ * 	return Driver VF structure
+ */
+void
+bfa_fcs_vf_list(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs)
+{
+	bfa_trc(fcs, *nvfs);
+}
+
+/**
+ *  	Return the list of all VFs visible from fabric.
+ *
+ * 	param[in]	fcs	fcs module instance
+ * 	param[out] 	vf_ids	returned list of vf_ids
+ * 	param[in,out] 	nvfs	in:size of vf_ids array,
+ *				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ * 	return Driver VF structure
+ */
+void
+bfa_fcs_vf_list_all(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs)
+{
+	bfa_trc(fcs, *nvfs);
+}
+
+/**
+ * 		Return the list of local logical ports present in the given VF.
+ *
+ * 	param[in]	vf	vf for which logical ports are returned
+ * 	param[out] 	lpwwn	returned logical port wwn list
+ * 	param[in,out] 	nlports	in:size of lpwwn list;
+ *				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ */
+void
+bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t lpwwn[], int *nlports)
+{
+	struct list_head        *qe;
+	struct bfa_fcs_vport_s *vport;
+	int             i;
+	struct bfa_fcs_s      *fcs;
+
+	if (vf == NULL || lpwwn == NULL || *nlports == 0)
+		return;
+
+	fcs = vf->fcs;
+
+	bfa_trc(fcs, vf->vf_id);
+	bfa_trc(fcs, (u32) *nlports);
+
+	i = 0;
+	lpwwn[i++] = vf->bport.port_cfg.pwwn;
+
+	list_for_each(qe, &vf->vport_q) {
+		if (i >= *nlports)
+			break;
+
+		vport = (struct bfa_fcs_vport_s *) qe;
+		lpwwn[i++] = vport->lport.port_cfg.pwwn;
+	}
+
+	bfa_trc(fcs, i);
+	*nlports = i;
+	return;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/vport.c patch/drivers/scsi/bfa/vport.c
--- orig/drivers/scsi/bfa/vport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/vport.c	2009-09-23 15:59:18.000000000 -0700
@@ -0,0 +1,891 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_vport.c FCS virtual port state machine
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <fcbuild.h>
+#include "fcs_fabric.h"
+#include "fcs_lport.h"
+#include "fcs_vport.h"
+#include "fcs_trcmod.h"
+#include "fcs.h"
+#include <aen/bfa_aen_lport.h>
+
+BFA_TRC_FILE(FCS, VPORT);
+
+#define __vport_fcs(__vp)       (__vp)->lport.fcs
+#define __vport_pwwn(__vp)      (__vp)->lport.port_cfg.pwwn
+#define __vport_nwwn(__vp)      (__vp)->lport.port_cfg.nwwn
+#define __vport_bfa(__vp)       (__vp)->lport.fcs->bfa
+#define __vport_fcid(__vp)      (__vp)->lport.pid
+#define __vport_fabric(__vp)    (__vp)->lport.fabric
+#define __vport_vfid(__vp)      (__vp)->lport.fabric->vf_id
+
+#define BFA_FCS_VPORT_MAX_RETRIES  5
+/*
+ * Forward declarations
+ */
+static void     bfa_fcs_vport_do_fdisc(struct bfa_fcs_vport_s *vport);
+static void     bfa_fcs_vport_timeout(void *vport_arg);
+static void     bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport);
+static void     bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport);
+
+/**
+ *  fcs_vport_sm FCS virtual port state machine
+ */
+
+/**
+ * VPort State Machine events
+ */
+enum bfa_fcs_vport_event {
+	BFA_FCS_VPORT_SM_CREATE = 1,	/*  vport create event */
+	BFA_FCS_VPORT_SM_DELETE = 2,	/*  vport delete event */
+	BFA_FCS_VPORT_SM_START = 3,	/*  vport start request */
+	BFA_FCS_VPORT_SM_STOP = 4,	/*  stop: unsupported */
+	BFA_FCS_VPORT_SM_ONLINE = 5,	/*  fabric online */
+	BFA_FCS_VPORT_SM_OFFLINE = 6,	/*  fabric offline event */
+	BFA_FCS_VPORT_SM_FRMSENT = 7,	/*  fdisc/logo sent events */
+	BFA_FCS_VPORT_SM_RSP_OK = 8,	/*  good response */
+	BFA_FCS_VPORT_SM_RSP_ERROR = 9,	/*  error/bad response */
+	BFA_FCS_VPORT_SM_TIMEOUT = 10,	/*  delay timer event */
+	BFA_FCS_VPORT_SM_DELCOMP = 11,	/*  lport delete completion */
+	BFA_FCS_VPORT_SM_RSP_DUP_WWN = 12,	/*  Dup wnn error */
+	BFA_FCS_VPORT_SM_RSP_FAILED = 13,	/*  non-retryable failure */
+};
+
+static void     bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
+					enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
+					 enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
+					 enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
+				       enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
+					     enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
+					enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
+					  enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
+					 enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
+				      enum bfa_fcs_vport_event event);
+static void     bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
+				       enum bfa_fcs_vport_event event);
+
+static struct bfa_sm_table_s vport_sm_table[] = {
+	{BFA_SM(bfa_fcs_vport_sm_uninit), BFA_FCS_VPORT_UNINIT},
+	{BFA_SM(bfa_fcs_vport_sm_created), BFA_FCS_VPORT_CREATED},
+	{BFA_SM(bfa_fcs_vport_sm_offline), BFA_FCS_VPORT_OFFLINE},
+	{BFA_SM(bfa_fcs_vport_sm_fdisc), BFA_FCS_VPORT_FDISC},
+	{BFA_SM(bfa_fcs_vport_sm_fdisc_retry), BFA_FCS_VPORT_FDISC_RETRY},
+	{BFA_SM(bfa_fcs_vport_sm_online), BFA_FCS_VPORT_ONLINE},
+	{BFA_SM(bfa_fcs_vport_sm_deleting), BFA_FCS_VPORT_DELETING},
+	{BFA_SM(bfa_fcs_vport_sm_cleanup), BFA_FCS_VPORT_CLEANUP},
+	{BFA_SM(bfa_fcs_vport_sm_logo), BFA_FCS_VPORT_LOGO},
+	{BFA_SM(bfa_fcs_vport_sm_error), BFA_FCS_VPORT_ERROR}
+};
+
+/**
+ * Beginning state.
+ */
+static void
+bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
+			enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_CREATE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_created);
+		bfa_fcs_fabric_addvport(__vport_fabric(vport), vport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Created state - a start event is required to start up the state machine.
+ */
+static void
+bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
+			 enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_START:
+		if (bfa_fcs_fabric_is_online(__vport_fabric(vport))
+		    && bfa_fcs_fabric_npiv_capable(__vport_fabric(vport))) {
+			bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc);
+			bfa_fcs_vport_do_fdisc(vport);
+		} else {
+			/**
+			 * Fabric is offline or not NPIV capable, stay in
+			 * offline state.
+			 */
+			vport->vport_stats.fab_no_npiv++;
+			bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
+		}
+		break;
+
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
+		bfa_fcs_port_delete(&vport->lport);
+		break;
+
+	case BFA_FCS_VPORT_SM_ONLINE:
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		/**
+		 * Ignore ONLINE/OFFLINE events from fabric till vport is started.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Offline state - awaiting ONLINE event from fabric SM.
+ */
+static void
+bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
+			 enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
+		bfa_fcs_port_delete(&vport->lport);
+		break;
+
+	case BFA_FCS_VPORT_SM_ONLINE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc);
+		vport->fdisc_retries = 0;
+		bfa_fcs_vport_do_fdisc(vport);
+		break;
+
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		/*
+		 * This can happen if the vport couldn't be initialzied due
+		 * the fact that the npiv was not enabled on the switch. In
+		 * that case we will put the vport in offline state. However,
+		 * the link can go down and cause the this event to be sent when
+		 * we are already offline. Ignore it.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * FDISC is sent and awaiting reply from fabric.
+ */
+static void
+bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
+		       enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_logo);
+		bfa_lps_discard(vport->lps);
+		bfa_fcs_vport_do_logo(vport);
+		break;
+
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
+		bfa_lps_discard(vport->lps);
+		break;
+
+	case BFA_FCS_VPORT_SM_RSP_OK:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_online);
+		bfa_fcs_port_online(&vport->lport);
+		break;
+
+	case BFA_FCS_VPORT_SM_RSP_ERROR:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc_retry);
+		bfa_timer_start(__vport_bfa(vport), &vport->timer,
+				bfa_fcs_vport_timeout, vport,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case BFA_FCS_VPORT_SM_RSP_FAILED:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
+		break;
+
+	case BFA_FCS_VPORT_SM_RSP_DUP_WWN:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_error);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * FDISC attempt failed - a timer is active to retry FDISC.
+ */
+static void
+bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
+			     enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
+		bfa_timer_stop(&vport->timer);
+		bfa_fcs_port_delete(&vport->lport);
+		break;
+
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
+		bfa_timer_stop(&vport->timer);
+		break;
+
+	case BFA_FCS_VPORT_SM_TIMEOUT:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc);
+		vport->vport_stats.fdisc_retries++;
+		vport->fdisc_retries++;
+		bfa_fcs_vport_do_fdisc(vport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Vport is online (FDISC is complete).
+ */
+static void
+bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
+			enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_deleting);
+		bfa_fcs_port_delete(&vport->lport);
+		break;
+
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
+		bfa_lps_discard(vport->lps);
+		bfa_fcs_port_offline(&vport->lport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Vport is being deleted - awaiting lport delete completion to send
+ * LOGO to fabric.
+ */
+static void
+bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
+			  enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		break;
+
+	case BFA_FCS_VPORT_SM_DELCOMP:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_logo);
+		bfa_fcs_vport_do_logo(vport);
+		break;
+
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Error State.
+ * This state will be set when the Vport Creation fails due to errors like
+ * Dup WWN. In this state only operation allowed is a Vport Delete.
+ */
+static void
+bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
+		       enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELETE:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
+		bfa_fcs_vport_free(vport);
+		break;
+
+	default:
+		bfa_trc(__vport_fcs(vport), event);
+	}
+}
+
+/**
+ * Lport cleanup is in progress since vport is being deleted. Fabric is
+ * offline, so no LOGO is needed to complete vport deletion.
+ */
+static void
+bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
+			 enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_DELCOMP:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
+		bfa_fcs_vport_free(vport);
+		break;
+
+	case BFA_FCS_VPORT_SM_DELETE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * LOGO is sent to fabric. Vport delete is in progress. Lport delete cleanup
+ * is done.
+ */
+static void
+bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
+		      enum bfa_fcs_vport_event event)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), event);
+
+	switch (event) {
+	case BFA_FCS_VPORT_SM_OFFLINE:
+		bfa_lps_discard(vport->lps);
+		/*
+		 * !!! fall through !!!
+		 */
+
+	case BFA_FCS_VPORT_SM_RSP_OK:
+	case BFA_FCS_VPORT_SM_RSP_ERROR:
+		bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
+		bfa_fcs_vport_free(vport);
+		break;
+
+	case BFA_FCS_VPORT_SM_DELETE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  fcs_vport_private FCS virtual port private functions
+ */
+
+/**
+ * Send AEN notification
+ */
+static void
+bfa_fcs_vport_aen_post(bfa_fcs_lport_t *port, enum bfa_lport_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = port->fcs->logm;
+	enum bfa_port_role role = port->port_cfg.roles;
+	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(port);
+	char            lpwwn_ptr[BFA_STRING_32];
+	char           *role_str[BFA_PORT_ROLE_FCP_MAX / 2 + 1] =
+		{ "Initiator", "Target", "IPFC" };
+
+	wwn2str(lpwwn_ptr, lpwwn);
+
+	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
+
+	switch (event) {
+	case BFA_LPORT_AEN_NPIV_DUP_WWN:
+		bfa_log(logmod, BFA_AEN_LPORT_NPIV_DUP_WWN, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_NPIV_FABRIC_MAX:
+		bfa_log(logmod, BFA_AEN_LPORT_NPIV_FABRIC_MAX, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_NPIV_UNKNOWN:
+		bfa_log(logmod, BFA_AEN_LPORT_NPIV_UNKNOWN, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.lport.vf_id = port->fabric->vf_id;
+	aen_data.lport.roles = role;
+	aen_data.lport.ppwwn =
+		bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(port->fcs));
+	aen_data.lport.lpwwn = lpwwn;
+}
+
+/**
+ * This routine will be called to send a FDISC command.
+ */
+static void
+bfa_fcs_vport_do_fdisc(struct bfa_fcs_vport_s *vport)
+{
+	bfa_lps_fdisc(vport->lps, vport,
+		      bfa_pport_get_maxfrsize(__vport_bfa(vport)),
+		      __vport_pwwn(vport), __vport_nwwn(vport));
+	vport->vport_stats.fdisc_sent++;
+}
+
+static void
+bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
+{
+	u8         lsrjt_rsn = bfa_lps_get_lsrjt_rsn(vport->lps);
+	u8         lsrjt_expl = bfa_lps_get_lsrjt_expl(vport->lps);
+
+	bfa_trc(__vport_fcs(vport), lsrjt_rsn);
+	bfa_trc(__vport_fcs(vport), lsrjt_expl);
+
+	/*
+	 * For certain reason codes, we don't want to retry.
+	 */
+	switch (bfa_lps_get_lsrjt_expl(vport->lps)) {
+	case FC_LS_RJT_EXP_INV_PORT_NAME:	/* by brocade */
+	case FC_LS_RJT_EXP_INVALID_NPORT_ID:	/* by Cisco */
+		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		else {
+			bfa_fcs_vport_aen_post(&vport->lport,
+					       BFA_LPORT_AEN_NPIV_DUP_WWN);
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_DUP_WWN);
+		}
+		break;
+
+	case FC_LS_RJT_EXP_INSUFF_RES:
+		/*
+		 * This means max logins per port/switch setting on the
+		 * switch was exceeded.
+		 */
+		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		else {
+			bfa_fcs_vport_aen_post(&vport->lport,
+					       BFA_LPORT_AEN_NPIV_FABRIC_MAX);
+			bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_FAILED);
+		}
+		break;
+
+	default:
+		if (vport->fdisc_retries == 0)	/* Print only once */
+			bfa_fcs_vport_aen_post(&vport->lport,
+					       BFA_LPORT_AEN_NPIV_UNKNOWN);
+		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+	}
+}
+
+/**
+ * 	Called to send a logout to the fabric. Used when a V-Port is
+ * 	deleted/stopped.
+ */
+static void
+bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport)
+{
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+
+	vport->vport_stats.logo_sent++;
+	bfa_lps_fdisclogo(vport->lps);
+}
+
+/**
+ *     This routine will be called by bfa_timer on timer timeouts.
+ *
+ * 	param[in] 	vport 		- pointer to bfa_fcs_vport_t.
+ * 	param[out]	vport_status 	- pointer to return vport status in
+ *
+ * 	return
+ * 		void
+ *
+* 	Special Considerations:
+ *
+ * 	note
+ */
+static void
+bfa_fcs_vport_timeout(void *vport_arg)
+{
+	struct bfa_fcs_vport_s *vport = (struct bfa_fcs_vport_s *)vport_arg;
+
+	vport->vport_stats.fdisc_timeouts++;
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_TIMEOUT);
+}
+
+static void
+bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport)
+{
+	bfa_fcs_fabric_delvport(__vport_fabric(vport), vport);
+	bfa_fcb_vport_delete(vport->vport_drv);
+	bfa_lps_delete(vport->lps);
+}
+
+
+
+/**
+ *  fcs_vport_public FCS virtual port public interfaces
+ */
+
+/**
+ * Online notification from fabric SM.
+ */
+void
+bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport)
+{
+	vport->vport_stats.fab_online++;
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_ONLINE);
+}
+
+/**
+ * Offline notification from fabric SM.
+ */
+void
+bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport)
+{
+	vport->vport_stats.fab_offline++;
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_OFFLINE);
+}
+
+/**
+ * Cleanup notification from fabric SM on link timer expiry.
+ */
+void
+bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport)
+{
+	vport->vport_stats.fab_cleanup++;
+}
+
+/**
+ * Delete completion callback from associated lport
+ */
+void
+bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
+{
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELCOMP);
+}
+
+/**
+ *   Module initialization
+ */
+void
+bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs)
+{
+}
+
+/**
+ *   Module cleanup
+ */
+void
+bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
+
+u32
+bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
+{
+	struct bfa_ioc_attr_s ioc_attr;
+
+	bfa_get_attr(fcs->bfa, &ioc_attr);
+
+	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
+		return (BFA_FCS_MAX_VPORTS_SUPP_CT);
+	else
+		return (BFA_FCS_MAX_VPORTS_SUPP_CB);
+}
+
+
+
+/**
+ *  fcs_vport_api Virtual port API
+ */
+
+/**
+ *  	Use this function to instantiate a new FCS vport object. This
+ * 	function will not trigger any HW initialization process (which will be
+ * 	done in vport_start() call)
+ *
+ * 	param[in] vport	- 	pointer to bfa_fcs_vport_t. This space
+ * 					needs to be allocated by the driver.
+ * 	param[in] fcs 		- 	FCS instance
+ * 	param[in] vport_cfg	- 	vport configuration
+ * 	param[in] vf_id    	- 	VF_ID if vport is created within a VF.
+ *                          		FC_VF_ID_NULL to specify base fabric.
+ * 	param[in] vport_drv 	- 	Opaque handle back to the driver's vport
+ * 					structure
+ *
+ * 	retval BFA_STATUS_OK - on success.
+ * 	retval BFA_STATUS_FAILED - on failure.
+ */
+bfa_status_t
+bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
+		     u16 vf_id, struct bfa_port_cfg_s *vport_cfg,
+		     struct bfad_vport_s *vport_drv)
+{
+	if (vport_cfg->pwwn == 0)
+		return (BFA_STATUS_INVALID_WWN);
+
+	if (bfa_fcs_port_get_pwwn(&fcs->fabric.bport) == vport_cfg->pwwn)
+		return BFA_STATUS_VPORT_WWN_BP;
+
+	if (bfa_fcs_vport_lookup(fcs, vf_id, vport_cfg->pwwn) != NULL)
+		return BFA_STATUS_VPORT_EXISTS;
+
+	if (bfa_fcs_fabric_vport_count(&fcs->fabric) ==
+	    bfa_fcs_vport_get_max(fcs))
+		return BFA_STATUS_VPORT_MAX;
+
+	vport->lps = bfa_lps_alloc(fcs->bfa);
+	if (!vport->lps)
+		return BFA_STATUS_VPORT_MAX;
+
+	vport->vport_drv = vport_drv;
+	bfa_sm_set_state(vport, bfa_fcs_vport_sm_uninit);
+
+	bfa_fcs_lport_init(&vport->lport, fcs, vf_id, vport_cfg, vport);
+
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_CREATE);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function initialize the vport.
+ *
+ *  @param[in] vport - pointer to bfa_fcs_vport_t.
+ *
+ *  @returns None
+ */
+bfa_status_t
+bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport)
+{
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_START);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function quiese the vport object. This function will return
+ * 	immediately, when the vport is actually stopped, the
+ * 	bfa_drv_vport_stop_cb() will be called.
+ *
+ * 	param[in] vport - pointer to bfa_fcs_vport_t.
+ *
+ * 	return None
+ */
+bfa_status_t
+bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport)
+{
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_STOP);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to delete a vport object. Fabric object should
+ * 		be stopped before this function call.
+ *
+ * 	param[in] vport - pointer to bfa_fcs_vport_t.
+ *
+ * 	return     None
+ */
+bfa_status_t
+bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport)
+{
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELETE);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to get vport's current status info.
+ *
+ * 	param[in] 	vport 		pointer to bfa_fcs_vport_t.
+ * 	param[out]	attr 		pointer to return vport attributes
+ *
+ * 	return None
+ */
+void
+bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
+		       struct bfa_vport_attr_s *attr)
+{
+	if (vport == NULL || attr == NULL)
+		return;
+
+	bfa_os_memset(attr, 0, sizeof(struct bfa_vport_attr_s));
+
+	bfa_fcs_port_get_attr(&vport->lport, &attr->port_attr);
+	attr->vport_state = bfa_sm_to_state(vport_sm_table, vport->sm);
+}
+
+/**
+ *  	Use this function to get vport's statistics.
+ *
+ * 	param[in] 	vport 		pointer to bfa_fcs_vport_t.
+ * 	param[out]	stats		pointer to return vport statistics in
+ *
+ * 	return None
+ */
+void
+bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
+			struct bfa_vport_stats_s *stats)
+{
+	*stats = vport->vport_stats;
+}
+
+/**
+ *  	Use this function to clear vport's statistics.
+ *
+ * 	param[in] 	vport 		pointer to bfa_fcs_vport_t.
+ *
+ * 	return None
+ */
+void
+bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport)
+{
+	bfa_os_memset(&vport->vport_stats, 0, sizeof(struct bfa_vport_stats_s));
+}
+
+/**
+ *      Lookup a virtual port. Excludes base port from lookup.
+ */
+struct bfa_fcs_vport_s *
+bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t vpwwn)
+{
+	struct bfa_fcs_vport_s *vport;
+	struct bfa_fcs_fabric_s *fabric;
+
+	bfa_trc(fcs, vf_id);
+	bfa_trc(fcs, vpwwn);
+
+	fabric = bfa_fcs_vf_lookup(fcs, vf_id);
+	if (!fabric) {
+		bfa_trc(fcs, vf_id);
+		return NULL;
+	}
+
+	vport = bfa_fcs_fabric_vport_lookup(fabric, vpwwn);
+	return vport;
+}
+
+/**
+ * FDISC Response
+ */
+void
+bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
+{
+	struct bfa_fcs_vport_s *vport = uarg;
+
+	bfa_trc(__vport_fcs(vport), __vport_pwwn(vport));
+	bfa_trc(__vport_fcs(vport), status);
+
+	switch (status) {
+	case BFA_STATUS_OK:
+		/*
+		 * Initialiaze the V-Port fields
+		 */
+		__vport_fcid(vport) = bfa_lps_get_pid(vport->lps);
+		vport->vport_stats.fdisc_accepts++;
+		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
+		break;
+
+	case BFA_STATUS_INVALID_MAC:
+		/*
+		 * Only for CNA
+		 */
+		vport->vport_stats.fdisc_acc_bad++;
+		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+
+		break;
+
+	case BFA_STATUS_EPROTOCOL:
+		switch (bfa_lps_get_extstatus(vport->lps)) {
+		case BFA_EPROTO_BAD_ACCEPT:
+			vport->vport_stats.fdisc_acc_bad++;
+			break;
+
+		case BFA_EPROTO_UNKNOWN_RSP:
+			vport->vport_stats.fdisc_unknown_rsp++;
+			break;
+
+		default:
+			break;
+		}
+
+		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+		break;
+
+	case BFA_STATUS_FABRIC_RJT:
+		vport->vport_stats.fdisc_rejects++;
+		bfa_fcs_vport_fdisc_rejected(vport);
+		break;
+
+	default:
+		vport->vport_stats.fdisc_rsp_err++;
+		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_ERROR);
+	}
+}
+
+/**
+ * LOGO response
+ */
+void
+bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg)
+{
+	struct bfa_fcs_vport_s *vport = uarg;
+	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
+}
+
+
