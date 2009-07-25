From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 8/14] bfa: Brocade BFA FC SCSI driver (fcs part-3)
Date: Fri, 24 Jul 2009 23:01:54 -0700
Message-ID: <200907250601.n6P61snt024283@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:19177 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZGYGB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2009 02:01:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-3

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 fdmi.c       | 1223 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 loop.c       |  422 ++++++++++++++++++++
 lport_api.c  |  291 +++++++++++++
 lport_priv.h |   82 +++
 ms.c         |  759 ++++++++++++++++++++++++++++++++++++
 n2n.c        |  105 ++++
 ns.c         | 1243 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 4125 insertions(+)

diff -urpN orig/drivers/scsi/bfa/fdmi.c patch/drivers/scsi/bfa/fdmi.c
--- orig/drivers/scsi/bfa/fdmi.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fdmi.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,1223 @@
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
+ *  port_api.c BFA FCS port
+ */
+
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "lport_priv.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include <fcs/bfa_fcs_fdmi.h>
+
+BFA_TRC_FILE(FCS, FDMI);
+
+#define BFA_FCS_FDMI_CMD_MAX_RETRIES 2
+
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg,
+					    struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg,
+					   struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_port_fdmi_rhba_response(void *fcsarg,
+						struct bfa_fcxp_s *fcxp,
+						void *cbarg,
+						bfa_status_t req_status,
+						u32 rsp_len,
+						u32 resid_len,
+						struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_fdmi_rprt_response(void *fcsarg,
+						struct bfa_fcxp_s *fcxp,
+						void *cbarg,
+						bfa_status_t req_status,
+						u32 rsp_len,
+						u32 resid_len,
+						struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_fdmi_rpa_response(void *fcsarg,
+					       struct bfa_fcxp_s *fcxp,
+					       void *cbarg,
+					       bfa_status_t req_status,
+					       u32 rsp_len,
+					       u32 resid_len,
+					       struct fchs_s *rsp_fchs);
+static void     bfa_fcs_port_fdmi_timeout(void *arg);
+static u16 bfa_fcs_port_fdmi_build_rhba_pyld(
+			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_rprt_pyld(
+			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_rpa_pyld(
+			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
+static u16 bfa_fcs_port_fdmi_build_portattr_block(
+			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
+void bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
+			struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
+void bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
+			struct bfa_fcs_fdmi_port_attr_s *port_attr);
+/**
+ *  fcs_fdmi_sm FCS FDMI state machine
+ */
+
+/**
+ *  FDMI State Machine events
+ */
+enum port_fdmi_event {
+	FDMISM_EVENT_PORT_ONLINE = 1,
+	FDMISM_EVENT_PORT_OFFLINE = 2,
+	FDMISM_EVENT_RSP_OK = 4,
+	FDMISM_EVENT_RSP_ERROR = 5,
+	FDMISM_EVENT_TIMEOUT = 6,
+	FDMISM_EVENT_RHBA_SENT = 7,
+	FDMISM_EVENT_RPRT_SENT = 8,
+	FDMISM_EVENT_RPA_SENT = 9,
+};
+
+static void bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void     bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void     bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+static void     bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+/**
+ * 		Start in offline state - awaiting MS to send start.
+ */
+static void
+bfa_fcs_port_fdmi_sm_offline(struct bfa_fcs_port_fdmi_s *fdmi,
+			     enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	fdmi->retry_cnt = 0;
+
+	switch (event) {
+	case FDMISM_EVENT_PORT_ONLINE:
+		if (port->vport) {
+			/*
+			 * For Vports, register a new port.
+			 */
+			bfa_sm_set_state(fdmi,
+					 bfa_fcs_port_fdmi_sm_sending_rprt);
+			bfa_fcs_port_fdmi_send_rprt(fdmi, NULL);
+		} else {
+			/*
+			 * For a base port, we should first register the HBA
+			 * atribute. The HBA attribute also contains the base
+			 *  port registration.
+			 */
+			bfa_sm_set_state(fdmi,
+					 bfa_fcs_port_fdmi_sm_sending_rhba);
+			bfa_fcs_port_fdmi_send_rhba(fdmi, NULL);
+		}
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_sending_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+				  enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RHBA_SENT:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rhba);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
+				       &fdmi->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rhba(struct bfa_fcs_port_fdmi_s *fdmi,
+			  enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RSP_ERROR:
+		/*
+		 * if max retries have not been reached, start timer for a
+		 * delayed retry
+		 */
+		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rhba_retry);
+			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
+					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
+					fdmi, BFA_FCS_RETRY_TIMEOUT);
+		} else {
+			/*
+			 * set state to offline
+			 */
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		}
+		break;
+
+	case FDMISM_EVENT_RSP_OK:
+		/*
+		 * Initiate Register Port Attributes
+		 */
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_sending_rpa);
+		fdmi->retry_cnt = 0;
+		bfa_fcs_port_fdmi_send_rpa(fdmi, NULL);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_fcxp_discard(fdmi->fcxp);
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rhba_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+				enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_sending_rhba);
+		bfa_fcs_port_fdmi_send_rhba(fdmi, NULL);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_timer_stop(&fdmi->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/*
+* RPRT : Register Port
+ */
+static void
+bfa_fcs_port_fdmi_sm_sending_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+				  enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RPRT_SENT:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rprt);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
+				       &fdmi->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rprt(struct bfa_fcs_port_fdmi_s *fdmi,
+			  enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RSP_ERROR:
+		/*
+		 * if max retries have not been reached, start timer for a
+		 * delayed retry
+		 */
+		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rprt_retry);
+			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
+					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
+					fdmi, BFA_FCS_RETRY_TIMEOUT);
+
+		} else {
+			/*
+			 * set state to offline
+			 */
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+			fdmi->retry_cnt = 0;
+		}
+		break;
+
+	case FDMISM_EVENT_RSP_OK:
+		fdmi->retry_cnt = 0;
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_online);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_fcxp_discard(fdmi->fcxp);
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rprt_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+				enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_sending_rprt);
+		bfa_fcs_port_fdmi_send_rprt(fdmi, NULL);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_timer_stop(&fdmi->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/*
+ * Register Port Attributes
+ */
+static void
+bfa_fcs_port_fdmi_sm_sending_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+				 enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RPA_SENT:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rpa);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_fcxp_walloc_cancel(BFA_FCS_GET_HAL_FROM_PORT(port),
+				       &fdmi->fcxp_wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rpa(struct bfa_fcs_port_fdmi_s *fdmi,
+			 enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_RSP_ERROR:
+		/*
+		 * if max retries have not been reached, start timer for a
+		 * delayed retry
+		 */
+		if (fdmi->retry_cnt++ < BFA_FCS_FDMI_CMD_MAX_RETRIES) {
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_rpa_retry);
+			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(port),
+					&fdmi->timer, bfa_fcs_port_fdmi_timeout,
+					fdmi, BFA_FCS_RETRY_TIMEOUT);
+		} else {
+			/*
+			 * set state to offline
+			 */
+			bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+			fdmi->retry_cnt = 0;
+		}
+		break;
+
+	case FDMISM_EVENT_RSP_OK:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_online);
+		fdmi->retry_cnt = 0;
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_fcxp_discard(fdmi->fcxp);
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
+			       enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_TIMEOUT:
+		/*
+		 * Retry Timer Expired. Re-send
+		 */
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_sending_rpa);
+		bfa_fcs_port_fdmi_send_rpa(fdmi, NULL);
+		break;
+
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		bfa_timer_stop(&fdmi->timer);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
+			    enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case FDMISM_EVENT_PORT_OFFLINE:
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+/**
+*   RHBA : Register HBA Attributes.
+ */
+static void
+bfa_fcs_port_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = fdmi_cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct fchs_s          fchs;
+	int             len, attr_len;
+	struct bfa_fcxp_s *fcxp;
+	u8        *pyld;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
+				    bfa_fcs_port_fdmi_send_rhba, fdmi);
+		return;
+	}
+	fdmi->fcxp = fcxp;
+
+	pyld = bfa_fcxp_get_reqbuf(fcxp);
+	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+
+	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
+				   FDMI_RHBA);
+
+	attr_len = bfa_fcs_port_fdmi_build_rhba_pyld(fdmi,
+			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, (len + attr_len), &fchs,
+		      bfa_fcs_port_fdmi_rhba_response, (void *)fdmi,
+		      FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RHBA_SENT);
+}
+
+static          u16
+bfa_fcs_port_fdmi_build_rhba_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+				  u8 *pyld)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct bfa_fcs_fdmi_hba_attr_s hba_attr;	/* @todo */
+	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr = &hba_attr; /* @todo */
+	struct fdmi_rhba_s    *rhba = (struct fdmi_rhba_s *) pyld;
+	struct fdmi_attr_s    *attr;
+	u8        *curr_ptr;
+	u16        len, count;
+
+	/*
+	 * get hba attributes
+	 */
+	bfa_fcs_fdmi_get_hbaattr(fdmi, fcs_hba_attr);
+
+	rhba->hba_id = bfa_fcs_port_get_pwwn(port);
+	rhba->port_list.num_ports = bfa_os_htonl(1);
+	rhba->port_list.port_entry = bfa_fcs_port_get_pwwn(port);
+
+	len = sizeof(rhba->hba_id) + sizeof(rhba->port_list);
+
+	count = 0;
+	len += sizeof(rhba->hba_attr_blk.attr_count);
+
+	/*
+	 * fill out the invididual entries of the HBA attrib Block
+	 */
+	curr_ptr = (u8 *) &rhba->hba_attr_blk.hba_attr;
+
+	/*
+	 * Node Name
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_NODENAME);
+	attr->len = sizeof(wwn_t);
+	memcpy(attr->value, &bfa_fcs_port_get_nwwn(port), attr->len);
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Manufacturer
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MANUFACTURER);
+	attr->len = (u16) strlen(fcs_hba_attr->manufacturer);
+	memcpy(attr->value, fcs_hba_attr->manufacturer, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Serial Number
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_SERIALNUM);
+	attr->len = (u16) strlen(fcs_hba_attr->serial_num);
+	memcpy(attr->value, fcs_hba_attr->serial_num, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Model
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL);
+	attr->len = (u16) strlen(fcs_hba_attr->model);
+	memcpy(attr->value, fcs_hba_attr->model, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Model Desc
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL_DESC);
+	attr->len = (u16) strlen(fcs_hba_attr->model_desc);
+	memcpy(attr->value, fcs_hba_attr->model_desc, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * H/W Version
+	 */
+	if (fcs_hba_attr->hw_version[0] != '\0') {
+		attr = (struct fdmi_attr_s *) curr_ptr;
+		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_HW_VERSION);
+		attr->len = (u16) strlen(fcs_hba_attr->hw_version);
+		memcpy(attr->value, fcs_hba_attr->hw_version, attr->len);
+		/* variable fields need to be 4 byte aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+		len += attr->len;
+		count++;
+		attr->len =
+			bfa_os_htons(attr->len + sizeof(attr->type) +
+				     sizeof(attr->len));
+	}
+
+	/*
+	 * Driver Version
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_DRIVER_VERSION);
+	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
+	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Option Rom Version
+	 */
+	if (fcs_hba_attr->option_rom_ver[0] != '\0') {
+		attr = (struct fdmi_attr_s *) curr_ptr;
+		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_ROM_VERSION);
+		attr->len = (u16) strlen(fcs_hba_attr->option_rom_ver);
+		memcpy(attr->value, fcs_hba_attr->option_rom_ver, attr->len);
+		/* variable fields need to be 4 byte aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+		len += attr->len;
+		count++;
+		attr->len =
+			bfa_os_htons(attr->len + sizeof(attr->type) +
+				     sizeof(attr->len));
+	}
+
+	/*
+	 * f/w Version = driver version
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_FW_VERSION);
+	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
+	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
+	/* variable fields need to be 4 byte aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * OS Name
+	 */
+	if (fcs_hba_attr->os_name[0] != '\0') {
+		attr = (struct fdmi_attr_s *) curr_ptr;
+		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_OS_NAME);
+		attr->len = (u16) strlen(fcs_hba_attr->os_name);
+		memcpy(attr->value, fcs_hba_attr->os_name, attr->len);
+		/* variable fields need to be 4 byte aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+		len += attr->len;
+		count++;
+		attr->len =
+			bfa_os_htons(attr->len + sizeof(attr->type) +
+				     sizeof(attr->len));
+	}
+
+	/*
+	 * MAX_CT_PAYLOAD
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MAX_CT);
+	attr->len = sizeof(fcs_hba_attr->max_ct_pyld);
+	memcpy(attr->value, &fcs_hba_attr->max_ct_pyld, attr->len);
+	len += attr->len;
+	count++;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Update size of payload
+	 */
+	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
+
+	rhba->hba_attr_blk.attr_count = bfa_os_htonl(count);
+	return len;
+}
+
+static void
+bfa_fcs_port_fdmi_rhba_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
+		return;
+	}
+
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+}
+
+/**
+*   RPRT : Register Port
+ */
+static void
+bfa_fcs_port_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = fdmi_cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct fchs_s          fchs;
+	u16        len, attr_len;
+	struct bfa_fcxp_s *fcxp;
+	u8        *pyld;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
+				    bfa_fcs_port_fdmi_send_rprt, fdmi);
+		return;
+	}
+	fdmi->fcxp = fcxp;
+
+	pyld = bfa_fcxp_get_reqbuf(fcxp);
+	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+
+	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
+				   FDMI_RPRT);
+
+	attr_len = bfa_fcs_port_fdmi_build_rprt_pyld(fdmi,
+			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len + attr_len, &fchs,
+		      bfa_fcs_port_fdmi_rprt_response, (void *)fdmi,
+		      FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPRT_SENT);
+}
+
+/**
+ * This routine builds Port Attribute Block that used in RPA, RPRT commands.
+ */
+static          u16
+bfa_fcs_port_fdmi_build_portattr_block(struct bfa_fcs_port_fdmi_s *fdmi,
+				       u8 *pyld)
+{
+	struct bfa_fcs_fdmi_port_attr_s fcs_port_attr;
+	struct fdmi_port_attr_s *port_attrib = (struct fdmi_port_attr_s *) pyld;
+	struct fdmi_attr_s    *attr;
+	u8        *curr_ptr;
+	u16        len;
+	u8         count = 0;
+
+	/*
+	 * get port attributes
+	 */
+	bfa_fcs_fdmi_get_portattr(fdmi, &fcs_port_attr);
+
+	len = sizeof(port_attrib->attr_count);
+
+	/*
+	 * fill out the invididual entries
+	 */
+	curr_ptr = (u8 *) &port_attrib->port_attr;
+
+	/*
+	 * FC4 Types
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_FC4_TYPES);
+	attr->len = sizeof(fcs_port_attr.supp_fc4_types);
+	memcpy(attr->value, fcs_port_attr.supp_fc4_types, attr->len);
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	++count;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * Supported Speed
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_SUPP_SPEED);
+	attr->len = sizeof(fcs_port_attr.supp_speed);
+	memcpy(attr->value, &fcs_port_attr.supp_speed, attr->len);
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	++count;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * current Port Speed
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_PORT_SPEED);
+	attr->len = sizeof(fcs_port_attr.curr_speed);
+	memcpy(attr->value, &fcs_port_attr.curr_speed, attr->len);
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	++count;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * max frame size
+	 */
+	attr = (struct fdmi_attr_s *) curr_ptr;
+	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_FRAME_SIZE);
+	attr->len = sizeof(fcs_port_attr.max_frm_size);
+	memcpy(attr->value, &fcs_port_attr.max_frm_size, attr->len);
+	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+	len += attr->len;
+	++count;
+	attr->len =
+		bfa_os_htons(attr->len + sizeof(attr->type) +
+			     sizeof(attr->len));
+
+	/*
+	 * OS Device Name
+	 */
+	if (fcs_port_attr.os_device_name[0] != '\0') {
+		attr = (struct fdmi_attr_s *) curr_ptr;
+		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_DEV_NAME);
+		attr->len = (u16) strlen(fcs_port_attr.os_device_name);
+		memcpy(attr->value, fcs_port_attr.os_device_name, attr->len);
+		/* variable fields need to be 4 byte aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+		len += attr->len;
+		++count;
+		attr->len =
+			bfa_os_htons(attr->len + sizeof(attr->type) +
+				     sizeof(attr->len));
+
+	}
+	/*
+	 * Host Name
+	 */
+	if (fcs_port_attr.host_name[0] != '\0') {
+		attr = (struct fdmi_attr_s *) curr_ptr;
+		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_HOST_NAME);
+		attr->len = (u16) strlen(fcs_port_attr.host_name);
+		memcpy(attr->value, fcs_port_attr.host_name, attr->len);
+		/* variable fields need to be 4 byte aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
+		len += attr->len;
+		++count;
+		attr->len =
+			bfa_os_htons(attr->len + sizeof(attr->type) +
+				     sizeof(attr->len));
+
+	}
+
+	/*
+	 * Update size of payload
+	 */
+	port_attrib->attr_count = bfa_os_htonl(count);
+	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
+	return len;
+}
+
+static          u16
+bfa_fcs_port_fdmi_build_rprt_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+				  u8 *pyld)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct fdmi_rprt_s    *rprt = (struct fdmi_rprt_s *) pyld;
+	u16        len;
+
+	rprt->hba_id = bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(port->fcs));
+	rprt->port_name = bfa_fcs_port_get_pwwn(port);
+
+	len = bfa_fcs_port_fdmi_build_portattr_block(fdmi,
+			(u8 *) &rprt->port_attr_blk);
+
+	len += sizeof(rprt->hba_id) + sizeof(rprt->port_name);
+
+	return len;
+}
+
+static void
+bfa_fcs_port_fdmi_rprt_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				void *cbarg, bfa_status_t req_status,
+				u32 rsp_len, u32 resid_len,
+				struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
+		return;
+	}
+
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+}
+
+/**
+*   RPA : Register Port Attributes.
+ */
+static void
+bfa_fcs_port_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = fdmi_cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct fchs_s          fchs;
+	u16        len, attr_len;
+	struct bfa_fcxp_s *fcxp;
+	u8        *pyld;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &fdmi->fcxp_wqe,
+				    bfa_fcs_port_fdmi_send_rpa, fdmi);
+		return;
+	}
+	fdmi->fcxp = fcxp;
+
+	pyld = bfa_fcxp_get_reqbuf(fcxp);
+	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+
+	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_port_get_fcid(port),
+				   FDMI_RPA);
+
+	attr_len = bfa_fcs_port_fdmi_build_rpa_pyld(fdmi,
+			(u8 *) ((struct ct_hdr_s *) pyld + 1));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len + attr_len, &fchs,
+		      bfa_fcs_port_fdmi_rpa_response, (void *)fdmi,
+		      FC_MAX_PDUSZ, FC_RA_TOV);
+
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPA_SENT);
+}
+
+static          u16
+bfa_fcs_port_fdmi_build_rpa_pyld(struct bfa_fcs_port_fdmi_s *fdmi,
+				 u8 *pyld)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct fdmi_rpa_s     *rpa = (struct fdmi_rpa_s *) pyld;
+	u16        len;
+
+	rpa->port_name = bfa_fcs_port_get_pwwn(port);
+
+	len = bfa_fcs_port_fdmi_build_portattr_block(fdmi,
+			(u8 *) &rpa->port_attr_blk);
+
+	len += sizeof(rpa->port_name);
+
+	return len;
+}
+
+static void
+bfa_fcs_port_fdmi_rpa_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+			       void *cbarg, bfa_status_t req_status,
+			       u32 rsp_len, u32 resid_len,
+			       struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)cbarg;
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct ct_hdr_s       *cthdr = NULL;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+		return;
+	}
+
+	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
+	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+
+	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
+		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
+		return;
+	}
+
+	bfa_trc(port->fcs, cthdr->reason_code);
+	bfa_trc(port->fcs, cthdr->exp_code);
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
+}
+
+static void
+bfa_fcs_port_fdmi_timeout(void *arg)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = (struct bfa_fcs_port_fdmi_s *)arg;
+
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_TIMEOUT);
+}
+
+void
+bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
+			 struct bfa_fcs_fdmi_hba_attr_s *hba_attr)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct bfa_fcs_driver_info_s *driver_info = &port->fcs->driver_info;
+	struct bfa_adapter_attr_s adapter_attr;
+
+	bfa_os_memset(hba_attr, 0, sizeof(struct bfa_fcs_fdmi_hba_attr_s));
+	bfa_os_memset(&adapter_attr, 0, sizeof(struct bfa_adapter_attr_s));
+
+	bfa_ioc_get_adapter_attr(&port->fcs->bfa->ioc, &adapter_attr);
+
+	strncpy(hba_attr->manufacturer, adapter_attr.manufacturer,
+		sizeof(adapter_attr.manufacturer));
+
+	strncpy(hba_attr->serial_num, adapter_attr.serial_num,
+		sizeof(adapter_attr.serial_num));
+
+	strncpy(hba_attr->model, adapter_attr.model, sizeof(hba_attr->model));
+
+	strncpy(hba_attr->model_desc, adapter_attr.model_descr,
+		sizeof(hba_attr->model_desc));
+
+	strncpy(hba_attr->hw_version, adapter_attr.hw_ver,
+		sizeof(hba_attr->hw_version));
+
+	strncpy(hba_attr->driver_version, (char *)driver_info->version,
+		sizeof(hba_attr->driver_version));
+
+	strncpy(hba_attr->option_rom_ver, adapter_attr.optrom_ver,
+		sizeof(hba_attr->option_rom_ver));
+
+	strncpy(hba_attr->fw_version, adapter_attr.fw_ver,
+		sizeof(hba_attr->fw_version));
+
+	strncpy(hba_attr->os_name, driver_info->host_os_name,
+		sizeof(hba_attr->os_name));
+
+	/*
+	 * If there is a patch level, append it to the os name along with a
+	 * separator
+	 */
+	if (driver_info->host_os_patch[0] != '\0') {
+		strncat(hba_attr->os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+		strncat(hba_attr->os_name, driver_info->host_os_patch,
+			sizeof(driver_info->host_os_patch));
+	}
+
+	hba_attr->max_ct_pyld = bfa_os_htonl(FC_MAX_PDUSZ);
+
+}
+
+void
+bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
+			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+	struct bfa_fcs_driver_info_s *driver_info = &port->fcs->driver_info;
+	struct bfa_pport_attr_s pport_attr;
+
+	bfa_os_memset(port_attr, 0, sizeof(struct bfa_fcs_fdmi_port_attr_s));
+
+	/*
+	 * get pport attributes from hal
+	 */
+	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+
+	/*
+	 * get FC4 type Bitmask
+	 */
+	fc_get_fc4type_bitmask(FC_TYPE_FCP, port_attr->supp_fc4_types);
+
+	/*
+	 * Supported Speeds
+	 */
+	port_attr->supp_speed = bfa_os_htonl(BFA_FCS_FDMI_SUPORTED_SPEEDS);
+
+	/*
+	 * Current Speed
+	 */
+	port_attr->curr_speed = bfa_os_htonl(pport_attr.speed);
+
+	/*
+	 * Max PDU Size.
+	 */
+	port_attr->max_frm_size = bfa_os_htonl(FC_MAX_PDUSZ);
+
+	/*
+	 * OS device Name
+	 */
+	strncpy(port_attr->os_device_name, (char *)driver_info->os_device_name,
+		sizeof(port_attr->os_device_name));
+
+	/*
+	 * Host name
+	 */
+	strncpy(port_attr->host_name, (char *)driver_info->host_machine_name,
+		sizeof(port_attr->host_name));
+
+}
+
+
+void
+bfa_fcs_port_fdmi_init(struct bfa_fcs_port_ms_s *ms)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = &ms->fdmi;
+
+	fdmi->ms = ms;
+	bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+}
+
+void
+bfa_fcs_port_fdmi_offline(struct bfa_fcs_port_ms_s *ms)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = &ms->fdmi;
+
+	fdmi->ms = ms;
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_PORT_OFFLINE);
+}
+
+void
+bfa_fcs_port_fdmi_online(struct bfa_fcs_port_ms_s *ms)
+{
+	struct bfa_fcs_port_fdmi_s *fdmi = &ms->fdmi;
+
+	fdmi->ms = ms;
+	bfa_sm_send_event(fdmi, FDMISM_EVENT_PORT_ONLINE);
+}
diff -urpN orig/drivers/scsi/bfa/loop.c patch/drivers/scsi/bfa/loop.c
--- orig/drivers/scsi/bfa/loop.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/loop.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,422 @@
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
+ *  port_loop.c vport private loop implementation.
+ */
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "fcs_trcmod.h"
+#include "lport_priv.h"
+
+BFA_TRC_FILE(FCS, LOOP);
+
+/**
+ *   ALPA to LIXA bitmap mapping
+ *
+ *   ALPA 0x00 (Word 0, Bit 30) is invalid for N_Ports. Also Word 0 Bit 31
+ * is for L_bit (login required) and is filled as ALPA 0x00 here.
+ */
+static const u8   port_loop_alpa_map[] = {
+	0xEF, 0xE8, 0xE4, 0xE2, 0xE1, 0xE0, 0xDC, 0xDA,	/* Word 3 Bits 0..7 */
+	0xD9, 0xD6, 0xD5, 0xD4, 0xD3, 0xD2, 0xD1, 0xCE,	/* Word 3 Bits 8..15 */
+	0xCD, 0xCC, 0xCB, 0xCA, 0xC9, 0xC7, 0xC6, 0xC5,	/* Word 3 Bits 16..23 */
+	0xC3, 0xBC, 0xBA, 0xB9, 0xB6, 0xB5, 0xB4, 0xB3,	/* Word 3 Bits 24..31 */
+
+	0xB2, 0xB1, 0xAE, 0xAD, 0xAC, 0xAB, 0xAA, 0xA9,	/* Word 2 Bits 0..7 */
+	0xA7, 0xA6, 0xA5, 0xA3, 0x9F, 0x9E, 0x9D, 0x9B,	/* Word 2 Bits 8..15 */
+	0x98, 0x97, 0x90, 0x8F, 0x88, 0x84, 0x82, 0x81,	/* Word 2 Bits 16..23 */
+	0x80, 0x7C, 0x7A, 0x79, 0x76, 0x75, 0x74, 0x73,	/* Word 2 Bits 24..31 */
+
+	0x72, 0x71, 0x6E, 0x6D, 0x6C, 0x6B, 0x6A, 0x69,	/* Word 1 Bits 0..7 */
+	0x67, 0x66, 0x65, 0x63, 0x5C, 0x5A, 0x59, 0x56,	/* Word 1 Bits 8..15 */
+	0x55, 0x54, 0x53, 0x52, 0x51, 0x4E, 0x4D, 0x4C,	/* Word 1 Bits 16..23 */
+	0x4B, 0x4A, 0x49, 0x47, 0x46, 0x45, 0x43, 0x3C,	/* Word 1 Bits 24..31 */
+
+	0x3A, 0x39, 0x36, 0x35, 0x34, 0x33, 0x32, 0x31,	/* Word 0 Bits 0..7 */
+	0x2E, 0x2D, 0x2C, 0x2B, 0x2A, 0x29, 0x27, 0x26,	/* Word 0 Bits 8..15 */
+	0x25, 0x23, 0x1F, 0x1E, 0x1D, 0x1B, 0x18, 0x17,	/* Word 0 Bits 16..23 */
+	0x10, 0x0F, 0x08, 0x04, 0x02, 0x01, 0x00, 0x00,	/* Word 0 Bits 24..31 */
+};
+
+/*
+ * Local Functions
+ */
+bfa_status_t    bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port,
+					     u8 alpa);
+
+void            bfa_fcs_port_loop_plogi_response(void *fcsarg,
+						 struct bfa_fcxp_s *fcxp,
+						 void *cbarg,
+						 bfa_status_t req_status,
+						 u32 rsp_len,
+						 u32 resid_len,
+						 struct fchs_s *rsp_fchs);
+
+bfa_status_t    bfa_fcs_port_loop_send_adisc(struct bfa_fcs_port_s *port,
+					     u8 alpa);
+
+void            bfa_fcs_port_loop_adisc_response(void *fcsarg,
+						 struct bfa_fcxp_s *fcxp,
+						 void *cbarg,
+						 bfa_status_t req_status,
+						 u32 rsp_len,
+						 u32 resid_len,
+						 struct fchs_s *rsp_fchs);
+
+bfa_status_t    bfa_fcs_port_loop_send_plogi_acc(struct bfa_fcs_port_s *port,
+						 u8 alpa);
+
+void            bfa_fcs_port_loop_plogi_acc_response(void *fcsarg,
+						     struct bfa_fcxp_s *fcxp,
+						     void *cbarg,
+						     bfa_status_t req_status,
+						     u32 rsp_len,
+						     u32 resid_len,
+						     struct fchs_s *rsp_fchs);
+
+bfa_status_t    bfa_fcs_port_loop_send_adisc_acc(struct bfa_fcs_port_s *port,
+						 u8 alpa);
+
+void            bfa_fcs_port_loop_adisc_acc_response(void *fcsarg,
+						     struct bfa_fcxp_s *fcxp,
+						     void *cbarg,
+						     bfa_status_t req_status,
+						     u32 rsp_len,
+						     u32 resid_len,
+						     struct fchs_s *rsp_fchs);
+/**
+ *   Called by port to initializar in provate LOOP topology.
+ */
+void
+bfa_fcs_port_loop_init(struct bfa_fcs_port_s *port)
+{
+}
+
+/**
+ *   Called by port to notify transition to online state.
+ */
+void
+bfa_fcs_port_loop_online(struct bfa_fcs_port_s *port)
+{
+
+	u8         num_alpa = port->port_topo.ploop.num_alpa;
+	u8        *alpa_pos_map = port->port_topo.ploop.alpa_pos_map;
+	struct bfa_fcs_rport_s *r_port;
+	int             ii = 0;
+
+	/*
+	 * If the port role is Initiator Mode, create Rports.
+	 */
+	if (port->port_cfg.roles == BFA_PORT_ROLE_FCP_IM) {
+		/*
+		 * Check if the ALPA positional bitmap is available.
+		 * if not, we send PLOGI to all possible ALPAs.
+		 */
+		if (num_alpa > 0) {
+			for (ii = 0; ii < num_alpa; ii++) {
+				/*
+				 * ignore ALPA of bfa port
+				 */
+				if (alpa_pos_map[ii] != port->pid) {
+					r_port = bfa_fcs_rport_create(port,
+						alpa_pos_map[ii]);
+				}
+			}
+		} else {
+			for (ii = 0; ii < MAX_ALPA_COUNT; ii++) {
+				/*
+				 * ignore ALPA of bfa port
+				 */
+				if ((port_loop_alpa_map[ii] > 0)
+				    && (port_loop_alpa_map[ii] != port->pid))
+					bfa_fcs_port_loop_send_plogi(port,
+						port_loop_alpa_map[ii]);
+				/**TBD */
+			}
+		}
+	} else {
+		/*
+		 * TBD Target Mode ??
+		 */
+	}
+
+}
+
+/**
+ *   Called by port to notify transition to offline state.
+ */
+void
+bfa_fcs_port_loop_offline(struct bfa_fcs_port_s *port)
+{
+
+}
+
+/**
+ *   Called by port to notify a LIP on the loop.
+ */
+void
+bfa_fcs_port_loop_lip(struct bfa_fcs_port_s *port)
+{
+}
+
+/**
+ * Local Functions.
+ */
+bfa_status_t
+bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port, u8 alpa)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp = NULL;
+	int             len;
+
+	bfa_trc(port->fcs, alpa);
+
+	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
+				  NULL);
+	bfa_assert(fcxp);
+
+	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn,
+				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_loop_plogi_response, (void *)port,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *   Called by fcxp to notify the Plogi response
+ */
+void
+bfa_fcs_port_loop_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				 void *cbarg, bfa_status_t req_status,
+				 u32 rsp_len, u32 resid_len,
+				 struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
+	struct fc_logi_s     *plogi_resp;
+	struct fc_els_cmd_s   *els_cmd;
+
+	bfa_trc(port->fcs, req_status);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		/*
+		 * @todo
+		 * This could mean that the device with this APLA does not
+		 * exist on the loop.
+		 */
+
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+	plogi_resp = (struct fc_logi_s *) els_cmd;
+
+	if (els_cmd->els_code == FC_ELS_ACC) {
+		bfa_fcs_rport_start(port, rsp_fchs, plogi_resp);
+	} else {
+		bfa_trc(port->fcs, plogi_resp->els_cmd.els_code);
+		bfa_assert(0);
+	}
+}
+
+bfa_status_t
+bfa_fcs_port_loop_send_plogi_acc(struct bfa_fcs_port_s *port, u8 alpa)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(port->fcs, alpa);
+
+	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
+				  NULL);
+	bfa_assert(fcxp);
+
+	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
+				 bfa_fcs_port_get_fcid(port), 0,
+				 port->port_cfg.pwwn, port->port_cfg.nwwn,
+				 bfa_pport_get_maxfrsize(port->fcs->bfa));
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+				 FC_CLASS_3, len, &fchs,
+				 bfa_fcs_port_loop_plogi_acc_response,
+				 (void *)port, FC_MAX_PDUSZ, 0); /* No response
+								  * expected
+								  */
+
+	return BFA_STATUS_OK;
+}
+
+/*
+ *  Plogi Acc Response
+ * We donot do any processing here.
+ */
+void
+bfa_fcs_port_loop_plogi_acc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				     void *cbarg, bfa_status_t req_status,
+				     u32 rsp_len, u32 resid_len,
+				     struct fchs_s *rsp_fchs)
+{
+
+	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
+
+	bfa_trc(port->fcs, port->pid);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		return;
+	}
+}
+
+bfa_status_t
+bfa_fcs_port_loop_send_adisc(struct bfa_fcs_port_s *port, u8 alpa)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(port->fcs, alpa);
+
+	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
+				  NULL);
+	bfa_assert(fcxp);
+
+	len = fc_adisc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
+			     bfa_fcs_port_get_fcid(port), 0,
+			     port->port_cfg.pwwn, port->port_cfg.nwwn);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+			  FC_CLASS_3, len, &fchs,
+			  bfa_fcs_port_loop_adisc_response, (void *)port,
+			  FC_MAX_PDUSZ, FC_RA_TOV);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *   Called by fcxp to notify the ADISC response
+ */
+void
+bfa_fcs_port_loop_adisc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				 void *cbarg, bfa_status_t req_status,
+				 u32 rsp_len, u32 resid_len,
+				 struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
+	struct bfa_fcs_rport_s *rport;
+	struct fc_adisc_s     *adisc_resp;
+	struct fc_els_cmd_s   *els_cmd;
+	u32        pid = rsp_fchs->s_id;
+
+	bfa_trc(port->fcs, req_status);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		/*
+		 * TBD : we may need to retry certain requests
+		 */
+		bfa_fcxp_free(fcxp);
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+	adisc_resp = (struct fc_adisc_s *) els_cmd;
+
+	if (els_cmd->els_code == FC_ELS_ACC) {
+	} else {
+		bfa_trc(port->fcs, adisc_resp->els_cmd.els_code);
+
+		/*
+		 * TBD: we may need to check for reject codes and retry
+		 */
+		rport = bfa_fcs_port_get_rport_by_pid(port, pid);
+		if (rport) {
+			list_del(&rport->qe);
+			bfa_fcs_rport_delete(rport);
+		}
+
+	}
+	return;
+}
+
+bfa_status_t
+bfa_fcs_port_loop_send_adisc_acc(struct bfa_fcs_port_s *port, u8 alpa)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(port->fcs, alpa);
+
+	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
+				  NULL);
+	bfa_assert(fcxp);
+
+	len = fc_adisc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
+				 bfa_fcs_port_get_fcid(port), 0,
+				 port->port_cfg.pwwn, port->port_cfg.nwwn);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+				FC_CLASS_3, len, &fchs,
+				bfa_fcs_port_loop_adisc_acc_response,
+				(void *)port, FC_MAX_PDUSZ, 0); /* no reponse
+								 * expected
+								 */
+
+	return BFA_STATUS_OK;
+}
+
+/*
+ *  Adisc Acc Response
+ * We donot do any processing here.
+ */
+void
+bfa_fcs_port_loop_adisc_acc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
+				     void *cbarg, bfa_status_t req_status,
+				     u32 rsp_len, u32 resid_len,
+				     struct fchs_s *rsp_fchs)
+{
+
+	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
+
+	bfa_trc(port->fcs, port->pid);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		bfa_trc(port->fcs, req_status);
+		return;
+	}
+}
diff -urpN orig/drivers/scsi/bfa/lport_api.c patch/drivers/scsi/bfa/lport_api.c
--- orig/drivers/scsi/bfa/lport_api.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/lport_api.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,291 @@
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
+ *  port_api.c BFA FCS port
+ */
+
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_rport.h>
+#include "fcs_rport.h"
+#include "fcs_fabric.h"
+#include "fcs_trcmod.h"
+#include "fcs_vport.h"
+
+BFA_TRC_FILE(FCS, PORT_API);
+
+
+
+/**
+ *  fcs_port_api BFA FCS port API
+ */
+
+void
+bfa_fcs_cfg_base_port(struct bfa_fcs_s *fcs, struct bfa_port_cfg_s *port_cfg)
+{
+}
+
+struct bfa_fcs_port_s *
+bfa_fcs_get_base_port(struct bfa_fcs_s *fcs)
+{
+	return (&fcs->fabric.bport);
+}
+
+wwn_t
+bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn, int index,
+		       int nrports, bfa_boolean_t bwwn)
+{
+	struct list_head *qh, *qe;
+	struct bfa_fcs_rport_s *rport = NULL;
+	int             i;
+	struct bfa_fcs_s *fcs;
+
+	if (port == NULL || nrports == 0)
+		return (wwn_t) 0;
+
+	fcs = port->fcs;
+	bfa_trc(fcs, (u32) nrports);
+
+	i = 0;
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while ((qe != qh) && (i < nrports)) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
+			qe = bfa_q_next(qe);
+			bfa_trc(fcs, (u32) rport->pwwn);
+			bfa_trc(fcs, rport->pid);
+			bfa_trc(fcs, i);
+			continue;
+		}
+
+		if (bwwn) {
+			if (!memcmp(&wwn, &rport->pwwn, 8))
+				break;
+		} else {
+			if (i == index)
+				break;
+		}
+
+		i++;
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(fcs, i);
+	if (rport) {
+		return rport->pwwn;
+	} else {
+		return (wwn_t) 0;
+	}
+}
+
+void
+bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port, wwn_t rport_wwns[],
+			int *nrports)
+{
+	struct list_head *qh, *qe;
+	struct bfa_fcs_rport_s *rport = NULL;
+	int             i;
+	struct bfa_fcs_s *fcs;
+
+	if (port == NULL || rport_wwns == NULL || *nrports == 0)
+		return;
+
+	fcs = port->fcs;
+	bfa_trc(fcs, (u32) *nrports);
+
+	i = 0;
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while ((qe != qh) && (i < *nrports)) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
+			qe = bfa_q_next(qe);
+			bfa_trc(fcs, (u32) rport->pwwn);
+			bfa_trc(fcs, rport->pid);
+			bfa_trc(fcs, i);
+			continue;
+		}
+
+		rport_wwns[i] = rport->pwwn;
+
+		i++;
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(fcs, i);
+	*nrports = i;
+	return;
+}
+
+/*
+ * Iterate's through all the rport's in the given port to
+ * determine the maximum operating speed.
+ */
+enum bfa_pport_speed
+bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port)
+{
+	struct list_head *qh, *qe;
+	struct bfa_fcs_rport_s *rport = NULL;
+	struct bfa_fcs_s *fcs;
+	enum bfa_pport_speed max_speed = 0;
+	struct bfa_pport_attr_s pport_attr;
+	enum bfa_pport_speed pport_speed;
+
+	if (port == NULL)
+		return 0;
+
+	fcs = port->fcs;
+
+	/*
+	 * Get Physical port's current speed
+	 */
+	bfa_pport_get_attr(port->fcs->bfa, &pport_attr);
+	pport_speed = pport_attr.speed;
+	bfa_trc(fcs, pport_speed);
+
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while (qe != qh) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000)
+		    || (bfa_fcs_rport_get_state(rport) == BFA_RPORT_OFFLINE)) {
+			qe = bfa_q_next(qe);
+			continue;
+		}
+
+		if ((rport->rpf.rpsc_speed == BFA_PPORT_SPEED_8GBPS)
+		    || (rport->rpf.rpsc_speed > pport_speed)) {
+			max_speed = rport->rpf.rpsc_speed;
+			break;
+		} else if (rport->rpf.rpsc_speed > max_speed) {
+			max_speed = rport->rpf.rpsc_speed;
+		}
+
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(fcs, max_speed);
+	return max_speed;
+}
+
+struct bfa_fcs_port_s *
+bfa_fcs_lookup_port(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t lpwwn)
+{
+	struct bfa_fcs_vport_s *vport;
+	bfa_fcs_vf_t   *vf;
+
+	bfa_assert(fcs != NULL);
+
+	vf = bfa_fcs_vf_lookup(fcs, vf_id);
+	if (vf == NULL) {
+		bfa_trc(fcs, vf_id);
+		return (NULL);
+	}
+
+	if (!lpwwn || (vf->bport.port_cfg.pwwn == lpwwn))
+		return (&vf->bport);
+
+	vport = bfa_fcs_fabric_vport_lookup(vf, lpwwn);
+	if (vport)
+		return (&vport->lport);
+
+	return (NULL);
+}
+
+/*
+ *  API corresponding to VmWare's NPIV_VPORT_GETINFO.
+ */
+void
+bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
+		      struct bfa_port_info_s *port_info)
+{
+
+	bfa_trc(port->fcs, port->fabric->fabric_name);
+
+	if (port->vport == NULL) {
+		/*
+		 * This is a Physical port
+		 */
+		port_info->port_type = BFA_PORT_TYPE_PHYSICAL;
+
+		/*
+		 * @todo : need to fix the state & reason
+		 */
+		port_info->port_state = 0;
+		port_info->offline_reason = 0;
+
+		port_info->port_wwn = bfa_fcs_port_get_pwwn(port);
+		port_info->node_wwn = bfa_fcs_port_get_nwwn(port);
+
+		port_info->max_vports_supp = bfa_fcs_vport_get_max(port->fcs);
+		port_info->num_vports_inuse =
+			bfa_fcs_fabric_vport_count(port->fabric);
+		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
+		port_info->num_rports_inuse = port->num_rports;
+	} else {
+		/*
+		 * This is a virtual port
+		 */
+		port_info->port_type = BFA_PORT_TYPE_VIRTUAL;
+
+		/*
+		 * @todo : need to fix the state & reason
+		 */
+		port_info->port_state = 0;
+		port_info->offline_reason = 0;
+
+		port_info->port_wwn = bfa_fcs_port_get_pwwn(port);
+		port_info->node_wwn = bfa_fcs_port_get_nwwn(port);
+	}
+}
+
+void
+bfa_fcs_port_get_stats(struct bfa_fcs_port_s *fcs_port,
+		       struct bfa_port_stats_s *port_stats)
+{
+	bfa_os_memcpy(port_stats, &fcs_port->stats,
+		      sizeof(struct bfa_port_stats_s));
+	return;
+}
+
+void
+bfa_fcs_port_clear_stats(struct bfa_fcs_port_s *fcs_port)
+{
+	bfa_os_memset(&fcs_port->stats, 0, sizeof(struct bfa_port_stats_s));
+	return;
+}
+
+void
+bfa_fcs_port_enable_ipfc_roles(struct bfa_fcs_port_s *fcs_port)
+{
+	fcs_port->port_cfg.roles |= BFA_PORT_ROLE_FCP_IPFC;
+	return;
+}
+
+void
+bfa_fcs_port_disable_ipfc_roles(struct bfa_fcs_port_s *fcs_port)
+{
+	fcs_port->port_cfg.roles &= ~BFA_PORT_ROLE_FCP_IPFC;
+	return;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/lport_priv.h patch/drivers/scsi/bfa/lport_priv.h
--- orig/drivers/scsi/bfa/lport_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/lport_priv.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,82 @@
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
+#ifndef __VP_PRIV_H__
+#define __VP_PRIV_H__
+
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_vport.h>
+
+/*
+ * Functions exported by vps
+ */
+void            bfa_fcs_vport_init(struct bfa_fcs_vport_s *vport);
+
+/*
+ * Functions exported by vps
+ */
+void            bfa_fcs_vps_online(struct bfa_fcs_port_s *port);
+void            bfa_fcs_vps_offline(struct bfa_fcs_port_s *port);
+void            bfa_fcs_vps_lip(struct bfa_fcs_port_s *port);
+
+/*
+ * Functions exported by port_fab
+ */
+void            bfa_fcs_port_fab_init(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_fab_online(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_fab_offline(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_fab_rx_frame(struct bfa_fcs_port_s *port,
+					  u8 *rx_frame, u32 len);
+
+/*
+ * Functions exported by VP-NS.
+ */
+void            bfa_fcs_port_ns_init(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_ns_offline(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_ns_online(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_ns_query(struct bfa_fcs_port_s *port);
+
+/*
+ * Functions exported by VP-SCN
+ */
+void            bfa_fcs_port_scn_init(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_scn_offline(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_scn_online(struct bfa_fcs_port_s *vport);
+void            bfa_fcs_port_scn_process_rscn(struct bfa_fcs_port_s *port,
+					      struct fchs_s *rx_frame, u32 len);
+
+/*
+ * Functions exported by VP-N2N
+ */
+
+void            bfa_fcs_port_n2n_init(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_n2n_online(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_n2n_offline(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_n2n_rx_frame(struct bfa_fcs_port_s *port,
+					  u8 *rx_frame, u32 len);
+
+/*
+ * Functions exported by VP-LOOP
+ */
+void            bfa_fcs_port_loop_init(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_loop_online(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_loop_offline(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_loop_lip(struct bfa_fcs_port_s *port);
+void            bfa_fcs_port_loop_rx_frame(struct bfa_fcs_port_s *port,
+					   u8 *rx_frame, u32 len);
+
+#endif /* __VP_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/ms.c patch/drivers/scsi/bfa/ms.c
--- orig/drivers/scsi/bfa/ms.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/ms.c	2009-07-21 15:34:03.000000000 -0700
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
+++ patch/drivers/scsi/bfa/n2n.c	2009-07-21 15:34:03.000000000 -0700
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
+++ patch/drivers/scsi/bfa/ns.c	2009-07-21 15:34:03.000000000 -0700
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
