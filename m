From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 8/14] bfa: Brocade BFA FC SCSI driver (fcs part3)
Date: Thu, 20 Aug 2009 00:11:55 -0700
Message-ID: <200908200711.n7K7BtW2007528@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate07out.mcdata.com ([144.49.194.4]:3514 "EHLO
	mx30.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZHTHLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 03:11:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-3

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 ms.c        |  759 ++++++++++++++++++++++++++++++++++++
 n2n.c       |  105 +++++
 ns.c        | 1243 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 plog.c      |  184 ++++++++
 rport_api.c |  180 ++++++++
 5 files changed, 2471 insertions(+)

diff -urpN orig/drivers/scsi/bfa/ms.c patch/drivers/scsi/bfa/ms.c
--- orig/drivers/scsi/bfa/ms.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/ms.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,759 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
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
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "lport_priv.h"
+
+BFA_TRC_FILE(FCS, MS);
+
+#define BFA_FCS_MS_CMD_MAX_RETRIES  2
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_port_ms_send_plogi(void *ms_cbarg,
+					   struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ms_timeout(void *arg);
+static void     bfa_fcs_port_ms_plogi_response(void *fcsarg,
+					       struct bfa_fcxp_s *fcxp,
+					       void *cbarg,
+					       bfa_status_t req_status,
+					       u32 rsp_len,
+					       u32 resid_len,
+					       struct fchs_s *rsp_fchs);
+
+static void     bfa_fcs_port_ms_send_gmal(void *ms_cbarg,
+					  struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ms_gmal_response(void *fcsarg,
+					      struct bfa_fcxp_s *fcxp,
+					      void *cbarg,
+					      bfa_status_t req_status,
+					      u32 rsp_len,
+					      u32 resid_len,
+					      struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ms_send_gfn(void *ms_cbarg,
+					 struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ms_gfn_response(void *fcsarg,
+					     struct bfa_fcxp_s *fcxp,
+					     void *cbarg,
+					     bfa_status_t req_status,
+					     u32 rsp_len,
+					     u32 resid_len,
+					     struct fchs_s *rsp_fchs);
+/**
+ *  fcs_ms_sm FCS MS state machine
+ */
+
+/**
+ *  MS State Machine events
+ */
+enum port_ms_event {
+	MSSM_EVENT_PORT_ONLINE = 1,
+	MSSM_EVENT_PORT_OFFLINE = 2,
+	MSSM_EVENT_RSP_OK = 3,
+	MSSM_EVENT_RSP_ERROR = 4,
+	MSSM_EVENT_TIMEOUT = 5,
+	MSSM_EVENT_FCXP_SENT = 6,
+	MSSM_EVENT_PORT_FABRIC_RSCN = 7
+};
+
+static void     bfa_fcs_port_ms_sm_offline(struct bfa_fcs_port_ms_s *ms,
+					   enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_plogi_sending(struct bfa_fcs_port_ms_s *ms,
+						 enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms,
+					 enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
+					       enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
+						enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms,
+					enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
+					      enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
+					       enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms,
+				       enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
+					     enum port_ms_event event);
+static void     bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
+					  enum port_ms_event event);
+/**
+ * 		Start in offline state - awaiting NS to send start.
+ */
+static void
+bfa_fcs_port_ms_sm_offline(struct bfa_fcs_port_ms_s *ms,
+			   enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_PORT_ONLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi_sending);
+		bfa_fcs_port_ms_send_plogi(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_plogi_sending(struct bfa_fcs_port_ms_s *ms,
+				 enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+				       &ms->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi_retry);
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port), &ms->timer,
+				bfa_fcs_port_ms_timeout, ms,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case MSSM_EVENT_RSP_OK:
+		/*
+		 * since plogi is done, now invoke MS related sub-modules
+		 */
+		bfa_fcs_port_fdmi_online(ms);
+
+		/**
+		 * if this is a Vport, go to online state.
+		 */
+		if (ms->port->vport) {
+			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_online);
+			break;
+		}
+
+		/*
+		 * For a base port we need to get the
+		 * switch's IP address.
+		 */
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gmal_sending);
+		bfa_fcs_port_ms_send_gmal(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_discard(ms->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_plogi_retry(struct bfa_fcs_port_ms_s *ms,
+			       enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi_sending);
+		bfa_fcs_port_ms_send_plogi(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_timer_stop(&ms->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_online(struct bfa_fcs_port_ms_s *ms,
+			  enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		/*
+		 * now invoke MS related sub-modules
+		 */
+		bfa_fcs_port_fdmi_offline(ms);
+		break;
+
+	case MSSM_EVENT_PORT_FABRIC_RSCN:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_sending);
+		ms->retry_cnt = 0;
+		bfa_fcs_port_ms_send_gfn(ms, NULL);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_gmal_sending(struct bfa_fcs_port_ms_s *ms,
+				enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gmal);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+				       &ms->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		if (ms->retry_cnt++ < BFA_FCS_MS_CMD_MAX_RETRIES) {
+			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gmal_retry);
+			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+					&ms->timer, bfa_fcs_port_ms_timeout, ms,
+					BFA_FCS_RETRY_TIMEOUT);
+		} else {
+			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_sending);
+			bfa_fcs_port_ms_send_gfn(ms, NULL);
+			ms->retry_cnt = 0;
+		}
+		break;
+
+	case MSSM_EVENT_RSP_OK:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_sending);
+		bfa_fcs_port_ms_send_gfn(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_discard(ms->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_gmal_retry(struct bfa_fcs_port_ms_s *ms,
+			      enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gmal_sending);
+		bfa_fcs_port_ms_send_gmal(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_timer_stop(&ms->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *  ms_pvt MS local functions
+ */
+
+static void
+bfa_fcs_port_ms_send_gmal(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ms_s *ms = ms_cbarg;
+	struct bfa_fcs_port_s *port = ms->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
+				    bfa_fcs_port_ms_send_gmal, ms);
+		return;
+	}
+	ms->fcxp = fcxp;
+
+	len = fc_gmal_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				bfa_fcs_port_get_fcid(port),
+				bfa_lps_get_peer_nwwn(port->fabric->lps));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gmal_response,
+		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_port_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+			      void *cbarg, bfa_status_t req_status,
+			      u32 rsp_len, u32 resid_len,
+			      struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
+	struct bfa_fcs_port_s *port = ms->port;
+	struct ct_hdr_s       *cthdr = NULL;
+	struct fcgs_gmal_resp_s *gmal_resp;
+	struct fc_gmal_entry_s *gmal_entry;
+	u32        num_entries;
+	u8        *rsp_str;
+
+	bfa_trc(port->fcs, req_status);
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		gmal_resp = (struct fcgs_gmal_resp_s *)(cthdr + 1);
+		num_entries = bfa_os_ntohl(gmal_resp->ms_len);
+		if (num_entries == 0) {
+			bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+			return;
+		}
+		/*
+		 * The response could contain multiple Entries.
+		 * Entries for SNMP interface, etc.
+		 * We look for the entry with a telnet prefix.
+		 * First "http://" entry refers to IP addr
+		 */
+
+		gmal_entry = (struct fc_gmal_entry_s *)gmal_resp->ms_ma;
+		while (num_entries > 0) {
+			if (strncmp
+			    (gmal_entry->prefix, CT_GMAL_RESP_PREFIX_HTTP,
+			     sizeof(gmal_entry->prefix)) == 0) {
+
+				/*
+				 * if the IP address is terminating with a '/',
+				 * remove it. *Byte 0 consists of the length
+				 * of the string.
+				 */
+				rsp_str = &(gmal_entry->prefix[0]);
+				if (rsp_str[gmal_entry->len - 1] == '/')
+					rsp_str[gmal_entry->len - 1] = 0;
+				/*
+				 * copy IP Address to fabric
+				 */
+				strncpy(bfa_fcs_port_get_fabric_ipaddr(port),
+					gmal_entry->ip_addr,
+					BFA_FCS_FABRIC_IPADDR_SZ);
+				break;
+			} else {
+				--num_entries;
+				++gmal_entry;
+			}
+		}
+
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_OK);
+		return;
+	}
+
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+}
+
+static void
+bfa_fcs_port_ms_sm_gfn_sending(struct bfa_fcs_port_ms_s *ms,
+			       enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_FCXP_SENT:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+				       &ms->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		if (ms->retry_cnt++ < BFA_FCS_MS_CMD_MAX_RETRIES) {
+			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_retry);
+			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
+					&ms->timer, bfa_fcs_port_ms_timeout, ms,
+					BFA_FCS_RETRY_TIMEOUT);
+		} else {
+			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_online);
+			ms->retry_cnt = 0;
+		}
+		break;
+
+	case MSSM_EVENT_RSP_OK:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_online);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_fcxp_discard(ms->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ms_sm_gfn_retry(struct bfa_fcs_port_ms_s *ms,
+			     enum port_ms_event event)
+{
+	bfa_trc(ms->port->fcs, ms->port->port_cfg.pwwn);
+	bfa_trc(ms->port->fcs, event);
+
+	switch (event) {
+	case MSSM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_sending);
+		bfa_fcs_port_ms_send_gfn(ms, NULL);
+		break;
+
+	case MSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+		bfa_timer_stop(&ms->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *  ms_pvt MS local functions
+ */
+
+static void
+bfa_fcs_port_ms_send_gfn(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ms_s *ms = ms_cbarg;
+	struct bfa_fcs_port_s *port = ms->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
+				    bfa_fcs_port_ms_send_gfn, ms);
+		return;
+	}
+	ms->fcxp = fcxp;
+
+	len = fc_gfn_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			       bfa_fcs_port_get_fcid(port),
+			       bfa_lps_get_peer_nwwn(port->fabric->lps));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_gfn_response,
+		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_port_ms_gfn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			     bfa_status_t req_status, u32 rsp_len,
+			       u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
+	struct bfa_fcs_port_s *port = ms->port;
+	struct ct_hdr_s       *cthdr = NULL;
+	wwn_t          *gfn_resp;
+
+	bfa_trc(port->fcs, req_status);
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		gfn_resp = (wwn_t *) (cthdr + 1);
+		/*
+		 * check if it has actually changed
+		 */
+		if ((memcmp
+		     ((void *)&bfa_fcs_port_get_fabric_name(port), gfn_resp,
+		      sizeof(wwn_t)) != 0))
+			bfa_fcs_fabric_set_fabric_name(port->fabric, *gfn_resp);
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_OK);
+		return;
+	}
+
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+}
+
+/**
+ *  ms_pvt MS local functions
+ */
+
+static void
+bfa_fcs_port_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ms_s *ms = ms_cbarg;
+	struct bfa_fcs_port_s *port = ms->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ms_plogi_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ms->fcxp_wqe,
+				    bfa_fcs_port_ms_send_plogi, ms);
+		return;
+	}
+	ms->fcxp = fcxp;
+
+	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			     bfa_os_hton3b(FC_MGMT_SERVER),
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn,
+			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ms_plogi_response,
+		      (void *)ms, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	port->stats.ms_plogi_sent++;
+	bfa_sm_send_event(ms, MSSM_EVENT_FCXP_SENT);
+}
+
+static void
+bfa_fcs_port_ms_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+			       void *cbarg, bfa_status_t req_status,
+			       u32 rsp_len, u32 resid_len,
+			       struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)cbarg;
+
+	struct bfa_fcs_port_s *port = ms->port;
+	struct fc_els_cmd_s   *els_cmd;
+	struct fc_ls_rjt_s    *ls_rjt;
+
+	bfa_trc(port->fcs, req_status);
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		port->stats.ms_plogi_rsp_err++;
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+	switch (els_cmd->els_code) {
+
+	case FC_ELS_ACC:
+		if (rsp_len < sizeof(struct fc_logi_s)) {
+			bfa_trc(port->fcs, rsp_len);
+			port->stats.ms_plogi_acc_err++;
+			bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+			break;
+		}
+		port->stats.ms_plogi_accepts++;
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_OK);
+		break;
+
+	case FC_ELS_LS_RJT:
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+		bfa_trc(port->fcs, ls_rjt->reason_code);
+		bfa_trc(port->fcs, ls_rjt->reason_code_expl);
+
+		port->stats.ms_rejects++;
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+		break;
+
+	default:
+		port->stats.ms_plogi_unknown_rsp++;
+		bfa_trc(port->fcs, els_cmd->els_code);
+		bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
+	}
+}
+
+static void
+bfa_fcs_port_ms_timeout(void *arg)
+{
+	struct bfa_fcs_port_ms_s *ms = (struct bfa_fcs_port_ms_s *)arg;
+
+	ms->port->stats.ms_timeouts++;
+	bfa_sm_send_event(ms, MSSM_EVENT_TIMEOUT);
+}
+
+
+void
+bfa_fcs_port_ms_init(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
+
+	ms->port = port;
+	bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_offline);
+
+	/*
+	 * Invoke init routines of sub modules.
+	 */
+	bfa_fcs_port_fdmi_init(ms);
+}
+
+void
+bfa_fcs_port_ms_offline(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
+
+	ms->port = port;
+	bfa_sm_send_event(ms, MSSM_EVENT_PORT_OFFLINE);
+}
+
+void
+bfa_fcs_port_ms_online(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
+
+	ms->port = port;
+	bfa_sm_send_event(ms, MSSM_EVENT_PORT_ONLINE);
+}
+
+void
+bfa_fcs_port_ms_fabric_rscn(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
+
+	/*
+	 * @todo.  Handle this only when in Online state
+	 */
+	if (bfa_sm_cmp_state(ms, bfa_fcs_port_ms_sm_online))
+		bfa_sm_send_event(ms, MSSM_EVENT_PORT_FABRIC_RSCN);
+}
diff -urpN orig/drivers/scsi/bfa/n2n.c patch/drivers/scsi/bfa/n2n.c
--- orig/drivers/scsi/bfa/n2n.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/n2n.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,105 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
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
+ *  n2n.c n2n implementation.
+ */
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_trcmod.h"
+#include "lport_priv.h"
+
+BFA_TRC_FILE(FCS, N2N);
+
+/**
+ *   Called by fcs/port to initialize N2N topology.
+ */
+void
+bfa_fcs_port_n2n_init(struct bfa_fcs_port_s *port)
+{
+}
+
+/**
+ *   Called by fcs/port to notify transition to online state.
+ */
+void
+bfa_fcs_port_n2n_online(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_n2n_s *n2n_port = &port->port_topo.pn2n;
+	struct bfa_port_cfg_s *pcfg = &port->port_cfg;
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, pcfg->pwwn);
+
+	/*
+	 * If our PWWN is > than that of the r-port, we have to initiate PLOGI
+	 * and assign an Address. if not, we need to wait for its PLOGI.
+	 *
+	 * If our PWWN is < than that of the remote port, it will send a PLOGI
+	 * with the PIDs assigned. The rport state machine take care of this
+	 * incoming PLOGI.
+	 */
+	if (memcmp
+	    ((void *)&pcfg->pwwn, (void *)&n2n_port->rem_port_wwn,
+	     sizeof(wwn_t)) > 0) {
+		port->pid = N2N_LOCAL_PID;
+		/**
+		 * First, check if we know the device by pwwn.
+		 */
+		rport = bfa_fcs_port_get_rport_by_pwwn(port,
+						       n2n_port->rem_port_wwn);
+		if (rport) {
+			bfa_trc(port->fcs, rport->pid);
+			bfa_trc(port->fcs, rport->pwwn);
+			rport->pid = N2N_REMOTE_PID;
+			bfa_fcs_rport_online(rport);
+			return;
+		}
+
+		/*
+		 * In n2n there can be only one rport. Delete the old one whose
+		 * pid should be zero, because it is offline.
+		 */
+		if (port->num_rports > 0) {
+			rport = bfa_fcs_port_get_rport_by_pid(port, 0);
+			bfa_assert(rport != NULL);
+			if (rport) {
+				bfa_trc(port->fcs, rport->pwwn);
+				bfa_fcs_rport_delete(rport);
+			}
+		}
+		bfa_fcs_rport_create(port, N2N_REMOTE_PID);
+	}
+}
+
+/**
+ *   Called by fcs/port to notify transition to offline state.
+ */
+void
+bfa_fcs_port_n2n_offline(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_n2n_s *n2n_port = &port->port_topo.pn2n;
+
+	bfa_trc(port->fcs, port->pid);
+	port->pid = 0;
+	n2n_port->rem_port_wwn = 0;
+	n2n_port->reply_oxid = 0;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/ns.c patch/drivers/scsi/bfa/ns.c
--- orig/drivers/scsi/bfa/ns.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/ns.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,1243 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
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
+ * @page ns_sm_info VPORT NS State Machine
+ *
+ * @section ns_sm_interactions VPORT NS State Machine Interactions
+ *
+ * @section ns_sm VPORT NS State Machine
+ * 	img ns_sm.jpg
+ */
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfa_iocfc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs.h"
+#include "lport_priv.h"
+
+BFA_TRC_FILE(FCS, NS);
+
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_port_ns_send_plogi(void *ns_cbarg,
+					   struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg,
+					     struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ns_send_rft_id(void *ns_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ns_send_rff_id(void *ns_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ns_send_gid_ft(void *ns_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_ns_timeout(void *arg);
+static void     bfa_fcs_port_ns_plogi_response(void *fcsarg,
+					       struct bfa_fcxp_s *fcxp,
+					       void *cbarg,
+					       bfa_status_t req_status,
+					       u32 rsp_len,
+					       u32 resid_len,
+					       struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ns_rspn_id_response(void *fcsarg,
+						 struct bfa_fcxp_s *fcxp,
+						 void *cbarg,
+						 bfa_status_t req_status,
+						 u32 rsp_len,
+						 u32 resid_len,
+						 struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ns_rft_id_response(void *fcsarg,
+						struct bfa_fcxp_s *fcxp,
+						void *cbarg,
+						bfa_status_t req_status,
+						u32 rsp_len,
+						u32 resid_len,
+						struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ns_rff_id_response(void *fcsarg,
+						struct bfa_fcxp_s *fcxp,
+						void *cbarg,
+						bfa_status_t req_status,
+						u32 rsp_len,
+						u32 resid_len,
+						struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ns_gid_ft_response(void *fcsarg,
+						struct bfa_fcxp_s *fcxp,
+						void *cbarg,
+						bfa_status_t req_status,
+						u32 rsp_len,
+						u32 resid_len,
+						struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_ns_process_gidft_pids(struct bfa_fcs_port_s *port,
+						   u32 *pid_buf,
+						   u32 n_pids);
+
+static void     bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port);
+/**
+ *  fcs_ns_sm FCS nameserver interface state machine
+ */
+
+/**
+ * VPort NS State Machine events
+ */
+enum vport_ns_event {
+	NSSM_EVENT_PORT_ONLINE = 1,
+	NSSM_EVENT_PORT_OFFLINE = 2,
+	NSSM_EVENT_PLOGI_SENT = 3,
+	NSSM_EVENT_RSP_OK = 4,
+	NSSM_EVENT_RSP_ERROR = 5,
+	NSSM_EVENT_TIMEOUT = 6,
+	NSSM_EVENT_NS_QUERY = 7,
+	NSSM_EVENT_RSPNID_SENT = 8,
+	NSSM_EVENT_RFTID_SENT = 9,
+	NSSM_EVENT_RFFID_SENT = 10,
+	NSSM_EVENT_GIDFT_SENT = 11,
+};
+
+static void     bfa_fcs_port_ns_sm_offline(struct bfa_fcs_port_ns_s *ns,
+					   enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_plogi_sending(struct bfa_fcs_port_ns_s *ns,
+						 enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
+					 enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_plogi_retry(struct bfa_fcs_port_ns_s *ns,
+					       enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_sending_rspn_id(struct bfa_fcs_port_ns_s *ns,
+						   enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
+					   enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rspn_id_retry(struct bfa_fcs_port_ns_s *ns,
+						 enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_sending_rft_id(struct bfa_fcs_port_ns_s *ns,
+						  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rft_id_retry(struct bfa_fcs_port_ns_s *ns,
+						enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
+					  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_sending_rff_id(struct bfa_fcs_port_ns_s *ns,
+						  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rff_id_retry(struct bfa_fcs_port_ns_s *ns,
+						enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
+					  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_sending_gid_ft(struct bfa_fcs_port_ns_s *ns,
+						  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
+					  enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_gid_ft_retry(struct bfa_fcs_port_ns_s *ns,
+						enum vport_ns_event event);
+static void     bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
+					  enum vport_ns_event event);
+/**
+ * 		Start in offline state - awaiting linkup
+ */
+static void
+bfa_fcs_port_ns_sm_offline(struct bfa_fcs_port_ns_s *ns,
+			   enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_PORT_ONLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_plogi_sending);
+		bfa_fcs_port_ns_send_plogi(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_plogi_sending(struct bfa_fcs_port_ns_s *ns,
+				 enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_PLOGI_SENT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_plogi);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				       &ns->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_plogi(struct bfa_fcs_port_ns_s *ns,
+			 enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_plogi_retry);
+		ns->port->stats.ns_retries++;
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
+				bfa_fcs_port_ns_timeout, ns,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case NSSM_EVENT_RSP_OK:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rspn_id);
+		bfa_fcs_port_ns_send_rspn_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_discard(ns->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_plogi_retry(struct bfa_fcs_port_ns_s *ns,
+			       enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_plogi_sending);
+		bfa_fcs_port_ns_send_plogi(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_timer_stop(&ns->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_sending_rspn_id(struct bfa_fcs_port_ns_s *ns,
+				   enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSPNID_SENT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rspn_id);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				       &ns->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rspn_id(struct bfa_fcs_port_ns_s *ns,
+			   enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rspn_id_retry);
+		ns->port->stats.ns_retries++;
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
+				bfa_fcs_port_ns_timeout, ns,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case NSSM_EVENT_RSP_OK:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rft_id);
+		bfa_fcs_port_ns_send_rft_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_fcxp_discard(ns->fcxp);
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rspn_id_retry(struct bfa_fcs_port_ns_s *ns,
+				 enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rspn_id);
+		bfa_fcs_port_ns_send_rspn_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_timer_stop(&ns->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_sending_rft_id(struct bfa_fcs_port_ns_s *ns,
+				  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RFTID_SENT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rft_id);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				       &ns->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rft_id(struct bfa_fcs_port_ns_s *ns,
+			  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSP_OK:
+		/*
+		 * Now move to register FC4 Features
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rff_id);
+		bfa_fcs_port_ns_send_rff_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rft_id_retry);
+		ns->port->stats.ns_retries++;
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
+				bfa_fcs_port_ns_timeout, ns,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_discard(ns->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rft_id_retry(struct bfa_fcs_port_ns_s *ns,
+				enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rft_id);
+		bfa_fcs_port_ns_send_rft_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_timer_stop(&ns->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_sending_rff_id(struct bfa_fcs_port_ns_s *ns,
+				  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RFFID_SENT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rff_id);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				       &ns->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rff_id(struct bfa_fcs_port_ns_s *ns,
+			  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSP_OK:
+
+		/*
+		 * If min cfg mode is enabled, we donot initiate rport
+		 * discovery with the fabric. Instead, we will retrieve the
+		 * boot targets from HAL/FW.
+		 */
+		if (__fcs_min_cfg(ns->port->fcs)) {
+			bfa_fcs_port_ns_boot_target_disc(ns->port);
+			bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_online);
+			return;
+		}
+
+		/*
+		 * If the port role is Initiator Mode issue NS query.
+		 * If it is Target Mode, skip this and go to online.
+		 */
+		if (BFA_FCS_VPORT_IS_INITIATOR_MODE(ns->port)) {
+			bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_gid_ft);
+			bfa_fcs_port_ns_send_gid_ft(ns, NULL);
+		} else if (BFA_FCS_VPORT_IS_TARGET_MODE(ns->port)) {
+			bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_online);
+		}
+		/*
+		 * kick off mgmt srvr state machine
+		 */
+		bfa_fcs_port_ms_online(ns->port);
+		break;
+
+	case NSSM_EVENT_RSP_ERROR:
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_rff_id_retry);
+		ns->port->stats.ns_retries++;
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
+				bfa_fcs_port_ns_timeout, ns,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_discard(ns->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_rff_id_retry(struct bfa_fcs_port_ns_s *ns,
+				enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_rff_id);
+		bfa_fcs_port_ns_send_rff_id(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_timer_stop(&ns->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+static void
+bfa_fcs_port_ns_sm_sending_gid_ft(struct bfa_fcs_port_ns_s *ns,
+				  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_GIDFT_SENT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_gid_ft);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(ns->port),
+				       &ns->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_gid_ft(struct bfa_fcs_port_ns_s *ns,
+			  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_RSP_OK:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_online);
+		break;
+
+	case NSSM_EVENT_RSP_ERROR:
+		/*
+		 * TBD: for certain reject codes, we don't need to retry
+		 */
+		/*
+		 * Start timer for a delayed retry
+		 */
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_gid_ft_retry);
+		ns->port->stats.ns_retries++;
+		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ns->port), &ns->timer,
+				bfa_fcs_port_ns_timeout, ns,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_fcxp_discard(ns->fcxp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_gid_ft_retry(struct bfa_fcs_port_ns_s *ns,
+				enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_TIMEOUT:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_gid_ft);
+		bfa_fcs_port_ns_send_gid_ft(ns, NULL);
+		break;
+
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		bfa_timer_stop(&ns->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_ns_sm_online(struct bfa_fcs_port_ns_s *ns,
+			  enum vport_ns_event event)
+{
+	bfa_trc(ns->port->fcs, ns->port->port_cfg.pwwn);
+	bfa_trc(ns->port->fcs, event);
+
+	switch (event) {
+	case NSSM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+		break;
+
+	case NSSM_EVENT_NS_QUERY:
+		/*
+		 * If the port role is Initiator Mode issue NS query.
+		 * If it is Target Mode, skip this and go to online.
+		 */
+		if (BFA_FCS_VPORT_IS_INITIATOR_MODE(ns->port)) {
+			bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_sending_gid_ft);
+			bfa_fcs_port_ns_send_gid_ft(ns, NULL);
+		};
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
+ *  ns_pvt Nameserver local functions
+ */
+
+static void
+bfa_fcs_port_ns_send_plogi(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ns_s *ns = ns_cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_plogi_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				    bfa_fcs_port_ns_send_plogi, ns);
+		return;
+	}
+	ns->fcxp = fcxp;
+
+	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			     bfa_os_hton3b(FC_NAME_SERVER),
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn,
+			     bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_plogi_response,
+		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+	port->stats.ns_plogi_sent++;
+
+	bfa_sm_send_event(ns, NSSM_EVENT_PLOGI_SENT);
+}
+
+static void
+bfa_fcs_port_ns_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+			       void *cbarg, bfa_status_t req_status,
+			       u32 rsp_len, u32 resid_len,
+			       struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	/* struct fc_logi_s *plogi_resp; */
+	struct fc_els_cmd_s   *els_cmd;
+	struct fc_ls_rjt_s    *ls_rjt;
+
+	bfa_trc(port->fcs, req_status);
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		port->stats.ns_plogi_rsp_err++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+	switch (els_cmd->els_code) {
+
+	case FC_ELS_ACC:
+		if (rsp_len < sizeof(struct fc_logi_s)) {
+			bfa_trc(port->fcs, rsp_len);
+			port->stats.ns_plogi_acc_err++;
+			bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+			break;
+		}
+		port->stats.ns_plogi_accepts++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		break;
+
+	case FC_ELS_LS_RJT:
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+		bfa_trc(port->fcs, ls_rjt->reason_code);
+		bfa_trc(port->fcs, ls_rjt->reason_code_expl);
+
+		port->stats.ns_rejects++;
+
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		break;
+
+	default:
+		port->stats.ns_plogi_unknown_rsp++;
+		bfa_trc(port->fcs, els_cmd->els_code);
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+	}
+}
+
+/**
+ * Register the symbolic port name.
+ */
+static void
+bfa_fcs_port_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ns_s *ns = ns_cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+	u8         symbl[256];
+	u8        *psymbl = &symbl[0];
+
+	bfa_os_memset(symbl, 0, sizeof(symbl));
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_rspnid_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				    bfa_fcs_port_ns_send_rspn_id, ns);
+		return;
+	}
+	ns->fcxp = fcxp;
+
+	/*
+	 * for V-Port, form a Port Symbolic Name
+	 */
+	if (port->vport) {
+		/**For Vports,
+		 *  we append the vport's port symbolic name to that of the base port.
+		 */
+
+		strncpy((char *)psymbl,
+			(char *)
+			&(bfa_fcs_port_get_psym_name
+			  (bfa_fcs_get_base_port(port->fcs))),
+			strlen((char *)
+			       &bfa_fcs_port_get_psym_name(bfa_fcs_get_base_port
+							   (port->fcs))));
+
+		/*
+		 * Ensure we have a null terminating string.
+		 */
+		((char *)
+		 psymbl)[strlen((char *)
+				&bfa_fcs_port_get_psym_name
+				(bfa_fcs_get_base_port(port->fcs)))] = 0;
+
+		strncat((char *)psymbl,
+			(char *)&(bfa_fcs_port_get_psym_name(port)),
+			strlen((char *)&bfa_fcs_port_get_psym_name(port)));
+	} else {
+		psymbl = (u8 *) &(bfa_fcs_port_get_psym_name(port));
+	}
+
+	len = fc_rspnid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      bfa_fcs_port_get_fcid(port), 0, psymbl);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rspn_id_response,
+		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	port->stats.ns_rspnid_sent++;
+
+	bfa_sm_send_event(ns, NSSM_EVENT_RSPNID_SENT);
+}
+
+static void
+bfa_fcs_port_ns_rspn_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				 void *cbarg, bfa_status_t req_status,
+				 u32 rsp_len, u32 resid_len,
+				 struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		port->stats.ns_rspnid_rsp_err++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		port->stats.ns_rspnid_accepts++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		return;
+	}
+
+	port->stats.ns_rspnid_rejects++;
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+}
+
+/**
+ * Register FC4-Types
+ * TBD, Need to retrieve this from the OS driver, in case IPFC is enabled ?
+ */
+static void
+bfa_fcs_port_ns_send_rft_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ns_s *ns = ns_cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_rftid_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				    bfa_fcs_port_ns_send_rft_id, ns);
+		return;
+	}
+	ns->fcxp = fcxp;
+
+	len = fc_rftid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.roles);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rft_id_response,
+		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	port->stats.ns_rftid_sent++;
+	bfa_sm_send_event(ns, NSSM_EVENT_RFTID_SENT);
+}
+
+static void
+bfa_fcs_port_ns_rft_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		port->stats.ns_rftid_rsp_err++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		port->stats.ns_rftid_accepts++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		return;
+	}
+
+	port->stats.ns_rftid_rejects++;
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+}
+
+/**
+* Register FC4-Features : Should be done after RFT_ID
+ */
+static void
+bfa_fcs_port_ns_send_rff_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ns_s *ns = ns_cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+	u8         fc4_ftrs = 0;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_rffid_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				    bfa_fcs_port_ns_send_rff_id, ns);
+		return;
+	}
+	ns->fcxp = fcxp;
+
+	if (BFA_FCS_VPORT_IS_INITIATOR_MODE(ns->port)) {
+		fc4_ftrs = FC_GS_FCP_FC4_FEATURE_INITIATOR;
+	} else if (BFA_FCS_VPORT_IS_TARGET_MODE(ns->port)) {
+		fc4_ftrs = FC_GS_FCP_FC4_FEATURE_TARGET;
+	}
+
+	len = fc_rffid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			     bfa_fcs_port_get_fcid(port), 0, FC_TYPE_FCP,
+			     fc4_ftrs);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_rff_id_response,
+		      (void *)ns, FC_MAX_PDUSZ, FC_RA_TOV);
+
+	port->stats.ns_rffid_sent++;
+	bfa_sm_send_event(ns, NSSM_EVENT_RFFID_SENT);
+}
+
+static void
+bfa_fcs_port_ns_rff_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		port->stats.ns_rffid_rsp_err++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		port->stats.ns_rffid_accepts++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		return;
+	}
+
+	port->stats.ns_rffid_rejects++;
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+
+	if (cthdr->reason_code == CT_RSN_NOT_SUPP) {
+		/*
+		 * if this command is not supported, we don't retry
+		 */
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+	} else {
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+	}
+}
+
+/**
+ * Query Fabric for FC4-Types Devices.
+ *
+*  TBD : Need to use a local (FCS private) response buffer, since the response
+ * can be larger than 2K.
+ */
+static void
+bfa_fcs_port_ns_send_gid_ft(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_ns_s *ns = ns_cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct fchs_s          fchs;
+	int             len;
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_trc(port->fcs, port->pid);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_gidft_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				    bfa_fcs_port_ns_send_gid_ft, ns);
+		return;
+	}
+	ns->fcxp = fcxp;
+
+	/*
+	 * This query is only initiated for FCP initiator mode.
+	 */
+	len = fc_gid_ft_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), ns->port->pid,
+			      FC_TYPE_FCP);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, bfa_fcs_port_ns_gid_ft_response,
+		      (void *)ns, bfa_fcxp_get_maxrsp(port->fcs->bfa),
+		      FC_RA_TOV);
+
+	port->stats.ns_gidft_sent++;
+
+	bfa_sm_send_event(ns, NSSM_EVENT_GIDFT_SENT);
+}
+
+static void
+bfa_fcs_port_ns_gid_ft_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)cbarg;
+	struct bfa_fcs_port_s *port = ns->port;
+	struct ct_hdr_s       *cthdr = NULL;
+	u32        n_pids;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		port->stats.ns_gidft_rsp_err++;
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	if (resid_len != 0) {
+		/*
+		 * TBD : we will need to allocate a larger buffer & retry the
+		 * command
+		 */
+		bfa_trc(port->fcs, rsp_len);
+		bfa_trc(port->fcs, resid_len);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	switch (cthdr->cmd_rsp_code) {
+
+	case CT_RSP_ACCEPT:
+
+		port->stats.ns_gidft_accepts++;
+		n_pids = (fc_get_ctresp_pyld_len(rsp_len) / sizeof(u32));
+		bfa_trc(port->fcs, n_pids);
+		bfa_fcs_port_ns_process_gidft_pids(port,
+						   (u32 *) (cthdr + 1),
+						   n_pids);
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		break;
+
+	case CT_RSP_REJECT:
+
+		/*
+		 * Check the reason code  & explanation.
+		 * There may not have been any FC4 devices in the fabric
+		 */
+		port->stats.ns_gidft_rejects++;
+		bfa_trc(port->fcs, cthdr->reason_code);
+		bfa_trc(port->fcs, cthdr->exp_code);
+
+		if ((cthdr->reason_code == CT_RSN_UNABLE_TO_PERF)
+		    && (cthdr->exp_code == CT_NS_EXP_FT_NOT_REG)) {
+
+			bfa_sm_send_event(ns, NSSM_EVENT_RSP_OK);
+		} else {
+			/*
+			 * for all other errors, retry
+			 */
+			bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+		}
+		break;
+
+	default:
+		port->stats.ns_gidft_unknown_rsp++;
+		bfa_trc(port->fcs, cthdr->cmd_rsp_code);
+		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
+	}
+}
+
+/**
+ *     This routine will be called by bfa_timer on timer timeouts.
+ *
+ * 	param[in] 	port 	- pointer to bfa_fcs_port_t.
+ *
+ * 	return
+ * 		void
+ *
+* 	Special Considerations:
+ *
+ * 	note
+ */
+static void
+bfa_fcs_port_ns_timeout(void *arg)
+{
+	struct bfa_fcs_port_ns_s *ns = (struct bfa_fcs_port_ns_s *)arg;
+
+	ns->port->stats.ns_timeouts++;
+	bfa_sm_send_event(ns, NSSM_EVENT_TIMEOUT);
+}
+
+/*
+ * Process the PID list in GID_FT response
+ */
+static void
+bfa_fcs_port_ns_process_gidft_pids(struct bfa_fcs_port_s *port,
+				   u32 *pid_buf, u32 n_pids)
+{
+	struct fcgs_gidft_resp_s *gidft_entry;
+	struct bfa_fcs_rport_s *rport;
+	u32        ii;
+
+	for (ii = 0; ii < n_pids; ii++) {
+		gidft_entry = (struct fcgs_gidft_resp_s *) &pid_buf[ii];
+
+		if (gidft_entry->pid == port->pid)
+			continue;
+
+		/*
+		 * Check if this rport already exists
+		 */
+		rport = bfa_fcs_port_get_rport_by_pid(port, gidft_entry->pid);
+		if (rport == NULL) {
+			/*
+			 * this is a new device. create rport
+			 */
+			rport = bfa_fcs_rport_create(port, gidft_entry->pid);
+		} else {
+			/*
+			 * this rport already exists
+			 */
+			bfa_fcs_rport_scn(rport);
+		}
+
+		bfa_trc(port->fcs, gidft_entry->pid);
+
+		/*
+		 * if the last entry bit is set, bail out.
+		 */
+		if (gidft_entry->last)
+			return;
+	}
+}
+
+/**
+ *  fcs_ns_public FCS nameserver public interfaces
+ */
+
+/*
+ * Functions called by port/fab.
+ * These will send relevant Events to the ns state machine.
+ */
+void
+bfa_fcs_port_ns_init(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
+
+	ns->port = port;
+	bfa_sm_set_state(ns, bfa_fcs_port_ns_sm_offline);
+}
+
+void
+bfa_fcs_port_ns_offline(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
+
+	ns->port = port;
+	bfa_sm_send_event(ns, NSSM_EVENT_PORT_OFFLINE);
+}
+
+void
+bfa_fcs_port_ns_online(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
+
+	ns->port = port;
+	bfa_sm_send_event(ns, NSSM_EVENT_PORT_ONLINE);
+}
+
+void
+bfa_fcs_port_ns_query(struct bfa_fcs_port_s *port)
+{
+	struct bfa_fcs_port_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
+
+	bfa_trc(port->fcs, port->pid);
+	bfa_sm_send_event(ns, NSSM_EVENT_NS_QUERY);
+}
+
+static void
+bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port)
+{
+
+	struct bfa_fcs_rport_s *rport;
+	u8         nwwns;
+	wwn_t          *wwns;
+	int             ii;
+
+	bfa_iocfc_get_bootwwns(port->fcs->bfa, &nwwns, &wwns);
+
+	for (ii = 0; ii < nwwns; ++ii) {
+		rport = bfa_fcs_rport_create_by_wwn(port, wwns[ii]);
+		bfa_assert(rport);
+	}
+}
+
+
diff -urpN orig/drivers/scsi/bfa/plog.c patch/drivers/scsi/bfa/plog.c
--- orig/drivers/scsi/bfa/plog.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/plog.c	2009-08-19 17:47:55.000000000 -0700
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa_os_inc.h>
+#include <cs/bfa_plog.h>
+#include <cs/bfa_debug.h>
+
+static int
+plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
+{
+	if ((pl_rec->log_type != BFA_PL_LOG_TYPE_INT)
+	    && (pl_rec->log_type != BFA_PL_LOG_TYPE_STRING))
+		return 1;
+
+	if ((pl_rec->log_type != BFA_PL_LOG_TYPE_INT)
+	    && (pl_rec->log_num_ints > BFA_PL_INT_LOG_SZ))
+		return 1;
+
+	return 0;
+}
+
+static void
+bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
+{
+	u16        tail;
+	struct bfa_plog_rec_s *pl_recp;
+
+	if (plog->plog_enabled == 0)
+		return;
+
+	if (plkd_validate_logrec(pl_rec)) {
+		bfa_assert(0);
+		return;
+	}
+
+	tail = plog->tail;
+
+	pl_recp = &(plog->plog_recs[tail]);
+
+	bfa_os_memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
+
+	pl_recp->tv = BFA_TRC_TS(plog);
+	BFA_PL_LOG_REC_INCR(plog->tail);
+
+	if (plog->head == plog->tail)
+		BFA_PL_LOG_REC_INCR(plog->head);
+}
+
+void
+bfa_plog_init(struct bfa_plog_s *plog)
+{
+	bfa_os_memset((char *)plog, 0, sizeof(struct bfa_plog_s));
+
+	bfa_os_memcpy(plog->plog_sig, BFA_PL_SIG_STR, BFA_PL_SIG_LEN);
+	plog->head = plog->tail = 0;
+	plog->plog_enabled = 1;
+}
+
+void
+bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		enum bfa_plog_eid event,
+		u16 misc, char *log_str)
+{
+	struct bfa_plog_rec_s  lp;
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		lp.mid = mid;
+		lp.eid = event;
+		lp.log_type = BFA_PL_LOG_TYPE_STRING;
+		lp.misc = misc;
+		strncpy(lp.log_entry.string_log, log_str,
+			BFA_PL_STRING_LOG_SZ - 1);
+		lp.log_entry.string_log[BFA_PL_STRING_LOG_SZ - 1] = '\0';
+		bfa_plog_add(plog, &lp);
+	}
+}
+
+void
+bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		enum bfa_plog_eid event,
+		u16 misc, u32 *intarr, u32 num_ints)
+{
+	struct bfa_plog_rec_s  lp;
+	u32        i;
+
+	if (num_ints > BFA_PL_INT_LOG_SZ)
+		num_ints = BFA_PL_INT_LOG_SZ;
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		lp.mid = mid;
+		lp.eid = event;
+		lp.log_type = BFA_PL_LOG_TYPE_INT;
+		lp.misc = misc;
+
+		for (i = 0; i < num_ints; i++)
+			bfa_os_assign(lp.log_entry.int_log[i],
+					intarr[i]);
+
+		lp.log_num_ints = (u8) num_ints;
+
+		bfa_plog_add(plog, &lp);
+	}
+}
+
+void
+bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event,
+			u16 misc, struct fchs_s *fchdr)
+{
+	struct bfa_plog_rec_s  lp;
+	u32       *tmp_int = (u32 *) fchdr;
+	u32        ints[BFA_PL_INT_LOG_SZ];
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+
+		ints[0] = tmp_int[0];
+		ints[1] = tmp_int[1];
+		ints[2] = tmp_int[4];
+
+		bfa_plog_intarr(plog, mid, event, misc, ints, 3);
+	}
+}
+
+void
+bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		      enum bfa_plog_eid event, u16 misc, struct fchs_s *fchdr,
+		      u32 pld_w0)
+{
+	struct bfa_plog_rec_s  lp;
+	u32       *tmp_int = (u32 *) fchdr;
+	u32        ints[BFA_PL_INT_LOG_SZ];
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+
+		ints[0] = tmp_int[0];
+		ints[1] = tmp_int[1];
+		ints[2] = tmp_int[4];
+		ints[3] = pld_w0;
+
+		bfa_plog_intarr(plog, mid, event, misc, ints, 4);
+	}
+}
+
+void
+bfa_plog_clear(struct bfa_plog_s *plog)
+{
+	plog->head = plog->tail = 0;
+}
+
+void
+bfa_plog_enable(struct bfa_plog_s *plog)
+{
+	plog->plog_enabled = 1;
+}
+
+void
+bfa_plog_disable(struct bfa_plog_s *plog)
+{
+	plog->plog_enabled = 0;
+}
+
+bfa_boolean_t
+bfa_plog_get_setting(struct bfa_plog_s *plog)
+{
+	return((bfa_boolean_t)plog->plog_enabled);
+}
diff -urpN orig/drivers/scsi/bfa/rport_api.c patch/drivers/scsi/bfa/rport_api.c
--- orig/drivers/scsi/bfa/rport_api.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport_api.c	2009-08-19 17:47:55.000000000 -0700
@@ -0,0 +1,180 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
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
