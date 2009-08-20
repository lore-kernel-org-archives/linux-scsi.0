From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 6/14] bfa: Brocade BFA FC SCSI driver (fcs part1)
Date: Thu, 20 Aug 2009 00:08:05 -0700
Message-ID: <200908200708.n7K785v4007219@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:16909 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZHTHIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 03:08:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-1

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_fcs.c       |  180 ++++++
 bfa_fcs_lport.c |  941 ++++++++++++++++++++++++++++++++++++
 bfa_fcs_port.c  |   68 ++
 bfa_fcs_uf.c    |  105 ++++
 fab.c           |   62 ++
 fabric.c        | 1280 +++++++++++++++++++++++++++++++++++++++++++++++++
 fcbuild.c       | 1449 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 4085 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_fcs.c patch/drivers/scsi/bfa/bfa_fcs.c
--- orig/drivers/scsi/bfa/bfa_fcs.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcs.c	2009-08-19 17:47:56.000000000 -0700
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
+
+/**
+ *  bfa_fcs.c BFA FCS main
+ */
+
+#include <fcs/bfa_fcs.h>
+#include "fcs_port.h"
+#include "fcs_uf.h"
+#include "fcs_vport.h"
+#include "fcs_rport.h"
+#include "fcs_fabric.h"
+#include "fcs_fcpim.h"
+#include "fcs_fcptm.h"
+#include "fcbuild.h"
+#include "fcs.h"
+#include <fcb/bfa_fcb.h>
+
+/**
+ * FCS sub-modules
+ */
+struct bfa_fcs_mod_s {
+	void            (*modinit) (struct bfa_fcs_s *fcs);
+	void            (*modexit) (struct bfa_fcs_s *fcs);
+};
+
+#define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
+
+static struct bfa_fcs_mod_s fcs_modules[] = {
+	BFA_FCS_MODULE(bfa_fcs_pport),
+	BFA_FCS_MODULE(bfa_fcs_uf),
+	BFA_FCS_MODULE(bfa_fcs_fabric),
+	BFA_FCS_MODULE(bfa_fcs_vport),
+	BFA_FCS_MODULE(bfa_fcs_rport),
+	BFA_FCS_MODULE(bfa_fcs_fcpim),
+};
+
+/**
+ *  fcs_api BFA FCS API
+ */
+
+static void
+bfa_fcs_exit_comp(void *fcs_cbarg)
+{
+	struct bfa_fcs_s      *fcs = fcs_cbarg;
+
+	bfa_fcb_exit(fcs->bfad);
+}
+
+
+
+/**
+ *  fcs_api BFA FCS API
+ */
+
+/**
+ * 		FCS instance initialization.
+ *
+ * 	param[in]		fcs		FCS instance
+ * 	param[in]		bfa		BFA instance
+ * 	param[in]		bfad		BFA driver instance
+ *
+ * 	return None
+ */
+void
+bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+			bfa_boolean_t min_cfg)
+{
+	int             i;
+	struct bfa_fcs_mod_s  *mod;
+
+	fcs->bfa = bfa;
+	fcs->bfad = bfad;
+	fcs->min_cfg = min_cfg;
+
+	bfa_attach_fcs(bfa);
+	fcbuild_init();
+
+	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+		mod = &fcs_modules[i];
+		mod->modinit(fcs);
+	}
+}
+
+/**
+ * Start FCS operations.
+ */
+void
+bfa_fcs_start(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_fabric_modstart(fcs);
+}
+
+/**
+ * 		FCS driver details initialization.
+ *
+ * 	param[in]		fcs		FCS instance
+ * 	param[in]		driver_info	Driver Details
+ *
+ * 	return None
+ */
+void
+bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
+			struct bfa_fcs_driver_info_s *driver_info)
+{
+
+	fcs->driver_info = *driver_info;
+
+	bfa_fcs_fabric_psymb_init(&fcs->fabric);
+}
+
+/**
+ * 		FCS instance cleanup and exit.
+ *
+ * 	param[in]		fcs			FCS instance
+ * 	return None
+ */
+void
+bfa_fcs_exit(struct bfa_fcs_s *fcs)
+{
+	struct bfa_fcs_mod_s  *mod;
+	int             nmods, i;
+
+	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
+
+	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
+
+	for (i = 0; i < nmods; i++) {
+		bfa_wc_up(&fcs->wc);
+
+		mod = &fcs_modules[i];
+		mod->modexit(fcs);
+	}
+
+	bfa_wc_wait(&fcs->wc);
+}
+
+
+void
+bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod)
+{
+	fcs->trcmod = trcmod;
+}
+
+
+void
+bfa_fcs_log_init(struct bfa_fcs_s *fcs, struct bfa_log_mod_s *logmod)
+{
+	fcs->logm = logmod;
+}
+
+
+void
+bfa_fcs_aen_init(struct bfa_fcs_s *fcs, struct bfa_aen_s *aen)
+{
+	fcs->aen = aen;
+}
+
+void
+bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs)
+{
+	bfa_wc_down(&fcs->wc);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcs_lport.c patch/drivers/scsi/bfa/bfa_fcs_lport.c
--- orig/drivers/scsi/bfa/bfa_fcs_lport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcs_lport.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,941 @@
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
+ *  bfa_fcs_port.c BFA FCS port
+ */
+
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_rport.h>
+#include <fcb/bfa_fcb_port.h>
+#include <bfa_svc.h>
+#include <log/bfa_log_fcs.h>
+#include "fcs.h"
+#include "fcs_lport.h"
+#include "fcs_vport.h"
+#include "fcs_rport.h"
+#include "fcs_fcxp.h"
+#include "fcs_trcmod.h"
+#include "lport_priv.h"
+#include <aen/bfa_aen_lport.h>
+
+BFA_TRC_FILE(FCS, PORT);
+
+/**
+ * Forward declarations
+ */
+
+static void     bfa_fcs_port_aen_post(struct bfa_fcs_port_s *port,
+				      enum bfa_lport_aen_event event);
+static void     bfa_fcs_port_send_ls_rjt(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs, u8 reason_code,
+			u8 reason_code_expl);
+static void     bfa_fcs_port_plogi(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs,
+			struct fc_logi_s *plogi);
+static void     bfa_fcs_port_online_actions(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_offline_actions(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_unknown_init(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_unknown_online(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_unknown_offline(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_deleted(struct bfa_fcs_port_s *port);
+static void     bfa_fcs_port_echo(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs,
+			struct fc_echo_s *echo, u16 len);
+static void     bfa_fcs_port_rnid(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs,
+			struct fc_rnid_cmd_s *rnid, u16 len);
+static void     bfa_fs_port_get_gen_topo_data(struct bfa_fcs_port_s *port,
+			struct fc_rnid_general_topology_data_s *gen_topo_data);
+
+static struct {
+	void            (*init) (struct bfa_fcs_port_s *port);
+	void            (*online) (struct bfa_fcs_port_s *port);
+	void            (*offline) (struct bfa_fcs_port_s *port);
+} __port_action[] = {
+	{
+	bfa_fcs_port_unknown_init, bfa_fcs_port_unknown_online,
+			bfa_fcs_port_unknown_offline}, {
+	bfa_fcs_port_fab_init, bfa_fcs_port_fab_online,
+			bfa_fcs_port_fab_offline}, {
+	bfa_fcs_port_loop_init, bfa_fcs_port_loop_online,
+			bfa_fcs_port_loop_offline}, {
+bfa_fcs_port_n2n_init, bfa_fcs_port_n2n_online,
+			bfa_fcs_port_n2n_offline},};
+
+/**
+ *  fcs_port_sm FCS logical port state machine
+ */
+
+enum bfa_fcs_port_event {
+	BFA_FCS_PORT_SM_CREATE = 1,
+	BFA_FCS_PORT_SM_ONLINE = 2,
+	BFA_FCS_PORT_SM_OFFLINE = 3,
+	BFA_FCS_PORT_SM_DELETE = 4,
+	BFA_FCS_PORT_SM_DELRPORT = 5,
+};
+
+static void     bfa_fcs_port_sm_uninit(struct bfa_fcs_port_s *port,
+				       enum bfa_fcs_port_event event);
+static void     bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port,
+				     enum bfa_fcs_port_event event);
+static void     bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
+				       enum bfa_fcs_port_event event);
+static void     bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
+					enum bfa_fcs_port_event event);
+static void     bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
+					 enum bfa_fcs_port_event event);
+
+static void
+bfa_fcs_port_sm_uninit(struct bfa_fcs_port_s *port,
+			enum bfa_fcs_port_event event)
+{
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_PORT_SM_CREATE:
+		bfa_sm_set_state(port, bfa_fcs_port_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_sm_init(struct bfa_fcs_port_s *port, enum bfa_fcs_port_event event)
+{
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_PORT_SM_ONLINE:
+		bfa_sm_set_state(port, bfa_fcs_port_sm_online);
+		bfa_fcs_port_online_actions(port);
+		break;
+
+	case BFA_FCS_PORT_SM_DELETE:
+		bfa_sm_set_state(port, bfa_fcs_port_sm_uninit);
+		bfa_fcs_port_deleted(port);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_sm_online(struct bfa_fcs_port_s *port,
+			enum bfa_fcs_port_event event)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe, *qen;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_PORT_SM_OFFLINE:
+		bfa_sm_set_state(port, bfa_fcs_port_sm_offline);
+		bfa_fcs_port_offline_actions(port);
+		break;
+
+	case BFA_FCS_PORT_SM_DELETE:
+
+		__port_action[port->fabric->fab_type].offline(port);
+
+		if (port->num_rports == 0) {
+			bfa_sm_set_state(port, bfa_fcs_port_sm_uninit);
+			bfa_fcs_port_deleted(port);
+		} else {
+			bfa_sm_set_state(port, bfa_fcs_port_sm_deleting);
+			list_for_each_safe(qe, qen, &port->rport_q) {
+				rport = (struct bfa_fcs_rport_s *)qe;
+				bfa_fcs_rport_delete(rport);
+			}
+		}
+		break;
+
+	case BFA_FCS_PORT_SM_DELRPORT:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_sm_offline(struct bfa_fcs_port_s *port,
+			enum bfa_fcs_port_event event)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe, *qen;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_PORT_SM_ONLINE:
+		bfa_sm_set_state(port, bfa_fcs_port_sm_online);
+		bfa_fcs_port_online_actions(port);
+		break;
+
+	case BFA_FCS_PORT_SM_DELETE:
+		if (port->num_rports == 0) {
+			bfa_sm_set_state(port, bfa_fcs_port_sm_uninit);
+			bfa_fcs_port_deleted(port);
+		} else {
+			bfa_sm_set_state(port, bfa_fcs_port_sm_deleting);
+			list_for_each_safe(qe, qen, &port->rport_q) {
+				rport = (struct bfa_fcs_rport_s *)qe;
+				bfa_fcs_rport_delete(rport);
+			}
+		}
+		break;
+
+	case BFA_FCS_PORT_SM_DELRPORT:
+	case BFA_FCS_PORT_SM_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_port_sm_deleting(struct bfa_fcs_port_s *port,
+			 enum bfa_fcs_port_event event)
+{
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_PORT_SM_DELRPORT:
+		if (port->num_rports == 0) {
+			bfa_sm_set_state(port, bfa_fcs_port_sm_uninit);
+			bfa_fcs_port_deleted(port);
+		}
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
+ *  fcs_port_pvt
+ */
+
+/**
+ * Send AEN notification
+ */
+static void
+bfa_fcs_port_aen_post(struct bfa_fcs_port_s *port,
+		      enum bfa_lport_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = port->fcs->logm;
+	enum bfa_port_role role = port->port_cfg.roles;
+	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(port);
+	char            lpwwn_buf[BFA_STRING_32];
+	char           *lpwwn_ptr;
+	char           *role_str[BFA_PORT_ROLE_FCP_MAX / 2 + 1] =
+		{ "Initiator", "Target", "IPFC" };
+
+	lpwwn_ptr = wwn2str(lpwwn_buf, sizeof(lpwwn_buf), lpwwn);
+
+	bfa_assert(role <= BFA_PORT_ROLE_FCP_MAX);
+
+	switch (event) {
+	case BFA_LPORT_AEN_ONLINE:
+		bfa_log(logmod, BFA_AEN_LPORT_ONLINE, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_OFFLINE:
+		bfa_log(logmod, BFA_AEN_LPORT_OFFLINE, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_NEW:
+		bfa_log(logmod, BFA_AEN_LPORT_NEW, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_DELETE:
+		bfa_log(logmod, BFA_AEN_LPORT_DELETE, lpwwn_ptr,
+			role_str[role / 2]);
+		break;
+	case BFA_LPORT_AEN_DISCONNECT:
+		bfa_log(logmod, BFA_AEN_LPORT_DISCONNECT, lpwwn_ptr,
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
+/*
+ * Send a LS reject
+ */
+static void
+bfa_fcs_port_send_ls_rjt(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
+			 u8 reason_code, u8 reason_code_expl)
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
+	len = fc_ls_rjt_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
+			      reason_code, reason_code_expl);
+
+	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+		      FC_MAX_PDUSZ, 0);
+}
+
+/**
+ * Process incoming plogi from a remote port.
+ */
+static void
+bfa_fcs_port_plogi(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
+			struct fc_logi_s *plogi)
+{
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, rx_fchs->d_id);
+	bfa_trc(port->fcs, rx_fchs->s_id);
+
+	/*
+	 * If min cfg mode is enabled, drop any incoming PLOGIs
+	 */
+	if (__fcs_min_cfg(port->fcs)) {
+		bfa_trc(port->fcs, rx_fchs->s_id);
+		return;
+	}
+
+	if (fc_plogi_parse(rx_fchs) != FC_PARSE_OK) {
+		bfa_trc(port->fcs, rx_fchs->s_id);
+		/*
+		 * send a LS reject
+		 */
+		bfa_fcs_port_send_ls_rjt(port, rx_fchs,
+					 FC_LS_RJT_RSN_PROTOCOL_ERROR,
+					 FC_LS_RJT_EXP_SPARMS_ERR_OPTIONS);
+		return;
+	}
+
+	/**
+* Direct Attach P2P mode : verify address assigned by the r-port.
+	 */
+	if ((!bfa_fcs_fabric_is_switched(port->fabric))
+	    &&
+	    (memcmp
+	     ((void *)&bfa_fcs_port_get_pwwn(port), (void *)&plogi->port_name,
+	      sizeof(wwn_t)) < 0)) {
+		if (BFA_FCS_PID_IS_WKA(rx_fchs->d_id)) {
+			/*
+			 * Address assigned to us cannot be a WKA
+			 */
+			bfa_fcs_port_send_ls_rjt(port, rx_fchs,
+					FC_LS_RJT_RSN_PROTOCOL_ERROR,
+					FC_LS_RJT_EXP_INVALID_NPORT_ID);
+			return;
+		}
+		port->pid = rx_fchs->d_id;
+	}
+
+	/**
+	 * First, check if we know the device by pwwn.
+	 */
+	rport = bfa_fcs_port_get_rport_by_pwwn(port, plogi->port_name);
+	if (rport) {
+		/**
+		 * Direct Attach P2P mode: handle address assigned by the rport.
+		 */
+		if ((!bfa_fcs_fabric_is_switched(port->fabric))
+		    &&
+		    (memcmp
+		     ((void *)&bfa_fcs_port_get_pwwn(port),
+		      (void *)&plogi->port_name, sizeof(wwn_t)) < 0)) {
+			port->pid = rx_fchs->d_id;
+			rport->pid = rx_fchs->s_id;
+		}
+		bfa_fcs_rport_plogi(rport, rx_fchs, plogi);
+		return;
+	}
+
+	/**
+	 * Next, lookup rport by PID.
+	 */
+	rport = bfa_fcs_port_get_rport_by_pid(port, rx_fchs->s_id);
+	if (!rport) {
+		/**
+		 * Inbound PLOGI from a new device.
+		 */
+		bfa_fcs_rport_plogi_create(port, rx_fchs, plogi);
+		return;
+	}
+
+	/**
+	 * Rport is known only by PID.
+	 */
+	if (rport->pwwn) {
+		/**
+		 * This is a different device with the same pid. Old device
+		 * disappeared. Send implicit LOGO to old device.
+		 */
+		bfa_assert(rport->pwwn != plogi->port_name);
+		bfa_fcs_rport_logo_imp(rport);
+
+		/**
+		 * Inbound PLOGI from a new device (with old PID).
+		 */
+		bfa_fcs_rport_plogi_create(port, rx_fchs, plogi);
+		return;
+	}
+
+	/**
+	 * PLOGI crossing each other.
+	 */
+	bfa_assert(rport->pwwn == WWN_NULL);
+	bfa_fcs_rport_plogi(rport, rx_fchs, plogi);
+}
+
+/*
+ * Process incoming ECHO.
+ * Since it does not require a login, it is processed here.
+ */
+static void
+bfa_fcs_port_echo(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
+			struct fc_echo_s *echo, u16 rx_len)
+{
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_rport_s *bfa_rport = NULL;
+	int             len, pyld_len;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+	bfa_trc(port->fcs, rx_fchs->d_id);
+	bfa_trc(port->fcs, rx_len);
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	len = fc_ls_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+			      bfa_fcs_port_get_fcid(port), rx_fchs->ox_id);
+
+	/*
+	 * Copy the payload (if any) from the echo frame
+	 */
+	pyld_len = rx_len - sizeof(struct fchs_s);
+	bfa_trc(port->fcs, pyld_len);
+
+	if (pyld_len > len)
+		memcpy(((u8 *) bfa_fcxp_get_reqbuf(fcxp)) +
+		       sizeof(struct fc_echo_s), (echo + 1),
+		       (pyld_len - sizeof(struct fc_echo_s)));
+
+	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, pyld_len, &fchs, NULL, NULL,
+		      FC_MAX_PDUSZ, 0);
+}
+
+/*
+ * Process incoming RNID.
+ * Since it does not require a login, it is processed here.
+ */
+static void
+bfa_fcs_port_rnid(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
+			struct fc_rnid_cmd_s *rnid, u16 rx_len)
+{
+	struct fc_rnid_common_id_data_s common_id_data;
+	struct fc_rnid_general_topology_data_s gen_topo_data;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_rport_s *bfa_rport = NULL;
+	u16        len;
+	u32        data_format;
+
+	bfa_trc(port->fcs, rx_fchs->s_id);
+	bfa_trc(port->fcs, rx_fchs->d_id);
+	bfa_trc(port->fcs, rx_len);
+
+	fcxp = bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp)
+		return;
+
+	/*
+	 * Check Node Indentification Data Format
+	 * We only support General Topology Discovery Format.
+	 * For any other requested Data Formats, we return Common Node Id Data
+	 * only, as per FC-LS.
+	 */
+	bfa_trc(port->fcs, rnid->node_id_data_format);
+	if (rnid->node_id_data_format == RNID_NODEID_DATA_FORMAT_DISCOVERY) {
+		data_format = RNID_NODEID_DATA_FORMAT_DISCOVERY;
+		/*
+		 * Get General topology data for this port
+		 */
+		bfa_fs_port_get_gen_topo_data(port, &gen_topo_data);
+	} else {
+		data_format = RNID_NODEID_DATA_FORMAT_COMMON;
+	}
+
+	/*
+	 * Copy the Node Id Info
+	 */
+	common_id_data.port_name = bfa_fcs_port_get_pwwn(port);
+	common_id_data.node_name = bfa_fcs_port_get_nwwn(port);
+
+	len = fc_rnid_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), rx_fchs->s_id,
+				bfa_fcs_port_get_fcid(port), rx_fchs->ox_id,
+				data_format, &common_id_data, &gen_topo_data);
+
+	bfa_fcxp_send(fcxp, bfa_rport, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, len, &fchs, NULL, NULL,
+		      FC_MAX_PDUSZ, 0);
+
+	return;
+}
+
+/*
+ *  Fill out General Topolpgy Discovery Data for RNID ELS.
+ */
+static void
+bfa_fs_port_get_gen_topo_data(struct bfa_fcs_port_s *port,
+			struct fc_rnid_general_topology_data_s *gen_topo_data)
+{
+
+	bfa_os_memset(gen_topo_data, 0,
+		      sizeof(struct fc_rnid_general_topology_data_s));
+
+	gen_topo_data->asso_type = bfa_os_htonl(RNID_ASSOCIATED_TYPE_HOST);
+	gen_topo_data->phy_port_num = 0;	/* @todo */
+	gen_topo_data->num_attached_nodes = bfa_os_htonl(1);
+}
+
+static void
+bfa_fcs_port_online_actions(struct bfa_fcs_port_s *port)
+{
+	bfa_trc(port->fcs, port->fabric->oper_type);
+
+	__port_action[port->fabric->fab_type].init(port);
+	__port_action[port->fabric->fab_type].online(port);
+
+	bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_ONLINE);
+	bfa_fcb_port_online(port->fcs->bfad, port->port_cfg.roles,
+			port->fabric->vf_drv, (port->vport == NULL) ?
+			NULL : port->vport->vport_drv);
+}
+
+static void
+bfa_fcs_port_offline_actions(struct bfa_fcs_port_s *port)
+{
+	struct list_head *qe, *qen;
+	struct bfa_fcs_rport_s *rport;
+
+	bfa_trc(port->fcs, port->fabric->oper_type);
+
+	__port_action[port->fabric->fab_type].offline(port);
+
+	if (bfa_fcs_fabric_is_online(port->fabric) == BFA_TRUE) {
+		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_DISCONNECT);
+	} else {
+		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_OFFLINE);
+	}
+	bfa_fcb_port_offline(port->fcs->bfad, port->port_cfg.roles,
+			port->fabric->vf_drv,
+			(port->vport == NULL) ? NULL : port->vport->vport_drv);
+
+	list_for_each_safe(qe, qen, &port->rport_q) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		bfa_fcs_rport_offline(rport);
+	}
+}
+
+static void
+bfa_fcs_port_unknown_init(struct bfa_fcs_port_s *port)
+{
+	bfa_assert(0);
+}
+
+static void
+bfa_fcs_port_unknown_online(struct bfa_fcs_port_s *port)
+{
+	bfa_assert(0);
+}
+
+static void
+bfa_fcs_port_unknown_offline(struct bfa_fcs_port_s *port)
+{
+	bfa_assert(0);
+}
+
+static void
+bfa_fcs_port_deleted(struct bfa_fcs_port_s *port)
+{
+	bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_DELETE);
+
+	/*
+	 * Base port will be deleted by the OS driver
+	 */
+	if (port->vport) {
+		bfa_fcb_port_delete(port->fcs->bfad, port->port_cfg.roles,
+			port->fabric->vf_drv,
+			port->vport ? port->vport->vport_drv : NULL);
+		bfa_fcs_vport_delete_comp(port->vport);
+	} else {
+		bfa_fcs_fabric_port_delete_comp(port->fabric);
+	}
+}
+
+
+
+/**
+ *  fcs_lport_api BFA FCS port API
+ */
+/**
+ *   Module initialization
+ */
+void
+bfa_fcs_port_modinit(struct bfa_fcs_s *fcs)
+{
+
+}
+
+/**
+ *   Module cleanup
+ */
+void
+bfa_fcs_port_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
+
+/**
+ * 		Unsolicited frame receive handling.
+ */
+void
+bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
+			u16 len)
+{
+	u32        pid = fchs->s_id;
+	struct bfa_fcs_rport_s *rport = NULL;
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	bfa_stats(lport, uf_recvs);
+
+	if (!bfa_fcs_port_is_online(lport)) {
+		bfa_stats(lport, uf_recv_drops);
+		return;
+	}
+
+	/**
+	 * First, handle ELSs that donot require a login.
+	 */
+	/*
+	 * Handle PLOGI first
+	 */
+	if ((fchs->type == FC_TYPE_ELS) &&
+		(els_cmd->els_code == FC_ELS_PLOGI)) {
+		bfa_fcs_port_plogi(lport, fchs, (struct fc_logi_s *) els_cmd);
+		return;
+	}
+
+	/*
+	 * Handle ECHO separately.
+	 */
+	if ((fchs->type == FC_TYPE_ELS) && (els_cmd->els_code == FC_ELS_ECHO)) {
+		bfa_fcs_port_echo(lport, fchs,
+			(struct fc_echo_s *) els_cmd, len);
+		return;
+	}
+
+	/*
+	 * Handle RNID separately.
+	 */
+	if ((fchs->type == FC_TYPE_ELS) && (els_cmd->els_code == FC_ELS_RNID)) {
+		bfa_fcs_port_rnid(lport, fchs,
+			(struct fc_rnid_cmd_s *) els_cmd, len);
+		return;
+	}
+
+	/**
+	 * look for a matching remote port ID
+	 */
+	rport = bfa_fcs_port_get_rport_by_pid(lport, pid);
+	if (rport) {
+		bfa_trc(rport->fcs, fchs->s_id);
+		bfa_trc(rport->fcs, fchs->d_id);
+		bfa_trc(rport->fcs, fchs->type);
+
+		bfa_fcs_rport_uf_recv(rport, fchs, len);
+		return;
+	}
+
+	/**
+	 * Only handles ELS frames for now.
+	 */
+	if (fchs->type != FC_TYPE_ELS) {
+		bfa_trc(lport->fcs, fchs->type);
+		bfa_assert(0);
+		return;
+	}
+
+	bfa_trc(lport->fcs, els_cmd->els_code);
+	if (els_cmd->els_code == FC_ELS_RSCN) {
+		bfa_fcs_port_scn_process_rscn(lport, fchs, len);
+		return;
+	}
+
+	if (els_cmd->els_code == FC_ELS_LOGO) {
+		/**
+		 * @todo Handle LOGO frames received.
+		 */
+		bfa_trc(lport->fcs, els_cmd->els_code);
+		return;
+	}
+
+	if (els_cmd->els_code == FC_ELS_PRLI) {
+		/**
+		 * @todo Handle PRLI frames received.
+		 */
+		bfa_trc(lport->fcs, els_cmd->els_code);
+		return;
+	}
+
+	/**
+	 * Unhandled ELS frames. Send a LS_RJT.
+	 */
+	bfa_fcs_port_send_ls_rjt(lport, fchs, FC_LS_RJT_RSN_CMD_NOT_SUPP,
+				 FC_LS_RJT_EXP_NO_ADDL_INFO);
+
+}
+
+/**
+ *   PID based Lookup for a R-Port in the Port R-Port Queue
+ */
+struct bfa_fcs_rport_s *
+bfa_fcs_port_get_rport_by_pid(struct bfa_fcs_port_s *port, u32 pid)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe;
+
+	list_for_each(qe, &port->rport_q) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if (rport->pid == pid)
+			return rport;
+	}
+
+	bfa_trc(port->fcs, pid);
+	return NULL;
+}
+
+/**
+ *   PWWN based Lookup for a R-Port in the Port R-Port Queue
+ */
+struct bfa_fcs_rport_s *
+bfa_fcs_port_get_rport_by_pwwn(struct bfa_fcs_port_s *port, wwn_t pwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe;
+
+	list_for_each(qe, &port->rport_q) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if (wwn_is_equal(rport->pwwn, pwwn))
+			return rport;
+	}
+
+	bfa_trc(port->fcs, pwwn);
+	return (NULL);
+}
+
+/**
+ *   NWWN based Lookup for a R-Port in the Port R-Port Queue
+ */
+struct bfa_fcs_rport_s *
+bfa_fcs_port_get_rport_by_nwwn(struct bfa_fcs_port_s *port, wwn_t nwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+	struct list_head *qe;
+
+	list_for_each(qe, &port->rport_q) {
+		rport = (struct bfa_fcs_rport_s *)qe;
+		if (wwn_is_equal(rport->nwwn, nwwn))
+			return rport;
+	}
+
+	bfa_trc(port->fcs, nwwn);
+	return (NULL);
+}
+
+/**
+ * Called by rport module when new rports are discovered.
+ */
+void
+bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
+		       struct bfa_fcs_rport_s *rport)
+{
+	list_add_tail(&rport->qe, &port->rport_q);
+	port->num_rports++;
+}
+
+/**
+ * Called by rport module to when rports are deleted.
+ */
+void
+bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
+		       struct bfa_fcs_rport_s *rport)
+{
+	bfa_assert(bfa_q_is_on_q(&port->rport_q, rport));
+	list_del(&rport->qe);
+	port->num_rports--;
+
+	bfa_sm_send_event(port, BFA_FCS_PORT_SM_DELRPORT);
+}
+
+/**
+ * Called by fabric for base port when fabric login is complete.
+ * Called by vport for virtual ports when FDISC is complete.
+ */
+void
+bfa_fcs_port_online(struct bfa_fcs_port_s *port)
+{
+	bfa_sm_send_event(port, BFA_FCS_PORT_SM_ONLINE);
+}
+
+/**
+ * Called by fabric for base port when fabric goes offline.
+ * Called by vport for virtual ports when virtual port becomes offline.
+ */
+void
+bfa_fcs_port_offline(struct bfa_fcs_port_s *port)
+{
+	bfa_sm_send_event(port, BFA_FCS_PORT_SM_OFFLINE);
+}
+
+/**
+ * Called by fabric to delete base lport and associated resources.
+ *
+ * Called by vport to delete lport and associated resources. Should call
+ * bfa_fcs_vport_delete_comp() for vports on completion.
+ */
+void
+bfa_fcs_port_delete(struct bfa_fcs_port_s *port)
+{
+	bfa_sm_send_event(port, BFA_FCS_PORT_SM_DELETE);
+}
+
+/**
+ * Called by fabric in private loop topology to process LIP event.
+ */
+void
+bfa_fcs_port_lip(struct bfa_fcs_port_s *port)
+{
+}
+
+/**
+ * Return TRUE if port is online, else return FALSE
+ */
+bfa_boolean_t
+bfa_fcs_port_is_online(struct bfa_fcs_port_s *port)
+{
+	return (bfa_sm_cmp_state(port, bfa_fcs_port_sm_online));
+}
+
+/**
+ * Logical port initialization of base or virtual port.
+ * Called by fabric for base port or by vport for virtual ports.
+ */
+void
+bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+		   u16 vf_id, struct bfa_port_cfg_s *port_cfg,
+		   struct bfa_fcs_vport_s *vport)
+{
+	lport->fcs = fcs;
+	lport->fabric = bfa_fcs_vf_lookup(fcs, vf_id);
+	bfa_os_assign(lport->port_cfg, *port_cfg);
+	lport->vport = vport;
+	lport->lp_tag = (vport) ? bfa_lps_get_tag(vport->lps) :
+			 bfa_lps_get_tag(lport->fabric->lps);
+
+	INIT_LIST_HEAD(&lport->rport_q);
+	lport->num_rports = 0;
+
+	lport->bfad_port =
+		bfa_fcb_port_new(fcs->bfad, lport, lport->port_cfg.roles,
+				lport->fabric->vf_drv,
+				vport ? vport->vport_drv : NULL);
+	bfa_fcs_port_aen_post(lport, BFA_LPORT_AEN_NEW);
+
+	bfa_sm_set_state(lport, bfa_fcs_port_sm_uninit);
+	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
+}
+
+
+
+/**
+ *  fcs_lport_api
+ */
+
+void
+bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
+		      struct bfa_port_attr_s *port_attr)
+{
+	if (bfa_sm_cmp_state(port, bfa_fcs_port_sm_online))
+		port_attr->pid = port->pid;
+	else
+		port_attr->pid = 0;
+
+	port_attr->port_cfg = port->port_cfg;
+
+	if (port->fabric) {
+		port_attr->port_type = bfa_fcs_fabric_port_type(port->fabric);
+		port_attr->loopback = bfa_fcs_fabric_is_loopback(port->fabric);
+		port_attr->fabric_name = bfa_fcs_port_get_fabric_name(port);
+		memcpy(port_attr->fabric_ip_addr,
+		       bfa_fcs_port_get_fabric_ipaddr(port),
+		       BFA_FCS_FABRIC_IPADDR_SZ);
+
+		if (port->vport != NULL)
+			port_attr->port_type = BFA_PPORT_TYPE_VPORT;
+
+	} else {
+		port_attr->port_type = BFA_PPORT_TYPE_UNKNOWN;
+		port_attr->state = BFA_PORT_UNINIT;
+	}
+
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcs_port.c patch/drivers/scsi/bfa/bfa_fcs_port.c
--- orig/drivers/scsi/bfa/bfa_fcs_port.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcs_port.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,68 @@
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
+ *  bfa_fcs_pport.c BFA FCS PPORT ( physical port)
+ */
+
+#include <fcs/bfa_fcs.h>
+#include <bfa_svc.h>
+#include <fcs/bfa_fcs_fabric.h>
+#include "fcs_trcmod.h"
+#include "fcs.h"
+#include "fcs_fabric.h"
+#include "fcs_port.h"
+
+BFA_TRC_FILE(FCS, PPORT);
+
+static void
+bfa_fcs_pport_event_handler(void *cbarg, bfa_pport_event_t event)
+{
+	struct bfa_fcs_s      *fcs = cbarg;
+
+	bfa_trc(fcs, event);
+
+	switch (event) {
+	case BFA_PPORT_LINKUP:
+		bfa_fcs_fabric_link_up(&fcs->fabric);
+		break;
+
+	case BFA_PPORT_LINKDOWN:
+		bfa_fcs_fabric_link_down(&fcs->fabric);
+		break;
+
+	case BFA_PPORT_TRUNK_LINKDOWN:
+		bfa_assert(0);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+void
+bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs)
+{
+	bfa_pport_event_register(fcs->bfa, bfa_fcs_pport_event_handler,
+				     fcs);
+}
+
+void
+bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
diff -urpN orig/drivers/scsi/bfa/bfa_fcs_uf.c patch/drivers/scsi/bfa/bfa_fcs_uf.c
--- orig/drivers/scsi/bfa/bfa_fcs_uf.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcs_uf.c	2009-08-19 17:47:56.000000000 -0700
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
+ *  bfa_fcs_uf.c BFA FCS UF ( Unsolicited Frames)
+ */
+
+#include <fcs/bfa_fcs.h>
+#include <bfa_svc.h>
+#include <fcs/bfa_fcs_fabric.h>
+#include "fcs.h"
+#include "fcs_trcmod.h"
+#include "fcs_fabric.h"
+#include "fcs_uf.h"
+
+BFA_TRC_FILE(FCS, UF);
+
+/**
+ * 		BFA callback for unsolicited frame receive handler.
+ *
+ * @param[in]		cbarg		callback arg for receive handler
+ * @param[in]		uf		unsolicited frame descriptor
+ *
+ * @return None
+ */
+static void
+bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
+{
+	struct bfa_fcs_s      *fcs = (struct bfa_fcs_s *) cbarg;
+	struct fchs_s         *fchs = bfa_uf_get_frmbuf(uf);
+	u16        len = bfa_uf_get_frmlen(uf);
+	struct fc_vft_s       *vft;
+	struct bfa_fcs_fabric_s *fabric;
+
+	/**
+	 * check for VFT header
+	 */
+	if (fchs->routing == FC_RTG_EXT_HDR &&
+		fchs->cat_info == FC_CAT_VFT_HDR) {
+		bfa_stats(fcs, uf.tagged);
+		vft = bfa_uf_get_frmbuf(uf);
+		if (fcs->port_vfid == vft->vf_id)
+			fabric = &fcs->fabric;
+		else
+			fabric = bfa_fcs_vf_lookup(fcs, (u16) vft->vf_id);
+
+		/**
+		 * drop frame if vfid is unknown
+		 */
+		if (!fabric) {
+			bfa_assert(0);
+			bfa_stats(fcs, uf.vfid_unknown);
+			bfa_uf_free(uf);
+			return;
+		}
+
+		/**
+		 * skip vft header
+		 */
+		fchs = (struct fchs_s *) (vft + 1);
+		len -= sizeof(struct fc_vft_s);
+
+		bfa_trc(fcs, vft->vf_id);
+	} else {
+		bfa_stats(fcs, uf.untagged);
+		fabric = &fcs->fabric;
+	}
+
+	bfa_trc(fcs, ((u32 *) fchs)[0]);
+	bfa_trc(fcs, ((u32 *) fchs)[1]);
+	bfa_trc(fcs, ((u32 *) fchs)[2]);
+	bfa_trc(fcs, ((u32 *) fchs)[3]);
+	bfa_trc(fcs, ((u32 *) fchs)[4]);
+	bfa_trc(fcs, ((u32 *) fchs)[5]);
+	bfa_trc(fcs, len);
+
+	bfa_fcs_fabric_uf_recv(fabric, fchs, len);
+	bfa_uf_free(uf);
+}
+
+void
+bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs)
+{
+	bfa_uf_recv_register(fcs->bfa, bfa_fcs_uf_recv, fcs);
+}
+
+void
+bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
diff -urpN orig/drivers/scsi/bfa/fab.c patch/drivers/scsi/bfa/fab.c
--- orig/drivers/scsi/bfa/fab.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fab.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,62 @@
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
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_lport.h"
+#include "fcs_rport.h"
+#include "lport_priv.h"
+
+/**
+ *  fab.c port fab implementation.
+ */
+
+/**
+ *  bfa_fcs_port_fab_public port fab public functions
+ */
+
+/**
+ *   Called by port to initialize fabric services of the base port.
+ */
+void
+bfa_fcs_port_fab_init(struct bfa_fcs_port_s *port)
+{
+	bfa_fcs_port_ns_init(port);
+	bfa_fcs_port_scn_init(port);
+	bfa_fcs_port_ms_init(port);
+}
+
+/**
+ *   Called by port to notify transition to online state.
+ */
+void
+bfa_fcs_port_fab_online(struct bfa_fcs_port_s *port)
+{
+	bfa_fcs_port_ns_online(port);
+	bfa_fcs_port_scn_online(port);
+}
+
+/**
+ *   Called by port to notify transition to offline state.
+ */
+void
+bfa_fcs_port_fab_offline(struct bfa_fcs_port_s *port)
+{
+	bfa_fcs_port_ns_offline(port);
+	bfa_fcs_port_scn_offline(port);
+	bfa_fcs_port_ms_offline(port);
+}
diff -urpN orig/drivers/scsi/bfa/fabric.c patch/drivers/scsi/bfa/fabric.c
--- orig/drivers/scsi/bfa/fabric.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fabric.c	2009-08-19 17:47:56.000000000 -0700
@@ -0,0 +1,1280 @@
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
+ *  fabric.c Fabric module implementation.
+ */
+
+#include "fcs_fabric.h"
+#include "fcs_lport.h"
+#include "fcs_vport.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs_auth.h"
+#include "fcs.h"
+#include "fcbuild.h"
+#include <log/bfa_log_fcs.h>
+#include <aen/bfa_aen_port.h>
+#include <bfa_svc.h>
+
+BFA_TRC_FILE(FCS, FABRIC);
+
+#define BFA_FCS_FABRIC_RETRY_DELAY	(2000)	/* Milliseconds */
+#define BFA_FCS_FABRIC_CLEANUP_DELAY	(10000)	/* Milliseconds */
+
+#define bfa_fcs_fabric_set_opertype(__fabric) do {          \
+    if (bfa_pport_get_topology((__fabric)->fcs->bfa)    \
+				== BFA_PPORT_TOPOLOGY_P2P)   \
+	    (__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;       \
+    else                                                    \
+	    (__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT;      \
+} while (0)
+
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_delay(void *cbarg);
+static void     bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_delete_comp(void *cbarg);
+static void     bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric,
+					  struct fchs_s *fchs, u16 len);
+static void     bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
+					     struct fchs_s *fchs, u16 len);
+static void     bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric);
+static void     bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
+					     struct bfa_fcxp_s *fcxp,
+					     void *cbarg, bfa_status_t status,
+					     u32 rsp_len,
+					     u32 resid_len,
+					     struct fchs_s *rspfchs);
+/**
+ *  fcs_fabric_sm fabric state machine functions
+ */
+
+/**
+ * Fabric state machine events
+ */
+enum bfa_fcs_fabric_event {
+	BFA_FCS_FABRIC_SM_CREATE = 1,	/*  fabric create from driver */
+	BFA_FCS_FABRIC_SM_DELETE = 2,	/*  fabric delete from driver */
+	BFA_FCS_FABRIC_SM_LINK_DOWN = 3,	/*  link down from port */
+	BFA_FCS_FABRIC_SM_LINK_UP = 4,	/*  link up from port */
+	BFA_FCS_FABRIC_SM_CONT_OP = 5,	/*  continue op from flogi/auth */
+	BFA_FCS_FABRIC_SM_RETRY_OP = 6,	/*  continue op from flogi/auth */
+	BFA_FCS_FABRIC_SM_NO_FABRIC = 7,	/*  no fabric from flogi/auth
+						 */
+	BFA_FCS_FABRIC_SM_PERF_EVFP = 8,	/*  perform EVFP from
+						 *flogi/auth */
+	BFA_FCS_FABRIC_SM_ISOLATE = 9,	/*  isolate from EVFP processing */
+	BFA_FCS_FABRIC_SM_NO_TAGGING = 10,/*  no VFT tagging from EVFP */
+	BFA_FCS_FABRIC_SM_DELAYED = 11,	/*  timeout delay event */
+	BFA_FCS_FABRIC_SM_AUTH_FAILED = 12,	/*  authentication failed */
+	BFA_FCS_FABRIC_SM_AUTH_SUCCESS = 13,	/*  authentication successful
+						 */
+	BFA_FCS_FABRIC_SM_DELCOMP = 14,	/*  all vports deleted event */
+	BFA_FCS_FABRIC_SM_LOOPBACK = 15,	/*  Received our own FLOGI */
+	BFA_FCS_FABRIC_SM_START = 16,	/*  fabric delete from driver */
+};
+
+static void     bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
+					 enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
+					  enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_linkdown(struct bfa_fcs_fabric_s *fabric,
+					   enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
+					enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
+					      enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
+				       enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
+					      enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
+					   enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
+					   enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
+					 enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
+				       enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
+					    enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
+					   enum bfa_fcs_fabric_event event);
+static void     bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
+					   enum bfa_fcs_fabric_event event);
+/**
+ *   Beginning state before fabric creation.
+ */
+static void
+bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
+			 enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_CREATE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_created);
+		bfa_fcs_fabric_init(fabric);
+		bfa_fcs_lport_init(&fabric->bport, fabric->fcs, FC_VF_ID_NULL,
+				   &fabric->bport.port_cfg, NULL);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_UP:
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Beginning state before fabric creation.
+ */
+static void
+bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
+			  enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_START:
+		if (bfa_pport_is_linkup(fabric->fcs->bfa)) {
+			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi);
+			bfa_fcs_fabric_login(fabric);
+		} else
+			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_UP:
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
+		bfa_fcs_modexit_comp(fabric->fcs);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Link is down, awaiting LINK UP event from port. This is also the
+ *   first state at fabric creation.
+ */
+static void
+bfa_fcs_fabric_sm_linkdown(struct bfa_fcs_fabric_s *fabric,
+			   enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_LINK_UP:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi);
+		bfa_fcs_fabric_login(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_RETRY_OP:
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   FLOGI is in progress, awaiting FLOGI reply.
+ */
+static void
+bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
+			enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_CONT_OP:
+
+		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		fabric->fab_type = BFA_FCS_FABRIC_SWITCHED;
+
+		if (fabric->auth_reqd && fabric->is_auth) {
+			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_auth);
+			bfa_trc(fabric->fcs, event);
+		} else {
+			bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_online);
+			bfa_fcs_fabric_notify_online(fabric);
+		}
+		break;
+
+	case BFA_FCS_FABRIC_SM_RETRY_OP:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi_retry);
+		bfa_timer_start(fabric->fcs->bfa, &fabric->delay_timer,
+				bfa_fcs_fabric_delay, fabric,
+				BFA_FCS_FABRIC_RETRY_DELAY);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LOOPBACK:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_loopback);
+		bfa_lps_discard(fabric->lps);
+		bfa_fcs_fabric_set_opertype(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_NO_FABRIC:
+		fabric->fab_type = BFA_FCS_FABRIC_N2N;
+		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		bfa_fcs_fabric_notify_online(fabric);
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_nofabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_lps_discard(fabric->lps);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_lps_discard(fabric->lps);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+
+static void
+bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
+			      enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_DELAYED:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_flogi);
+		bfa_fcs_fabric_login(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_timer_stop(&fabric->delay_timer);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_timer_stop(&fabric->delay_timer);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Authentication is in progress, awaiting authentication results.
+ */
+static void
+bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
+		       enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_AUTH_FAILED:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_auth_failed);
+		bfa_lps_discard(fabric->lps);
+		break;
+
+	case BFA_FCS_FABRIC_SM_AUTH_SUCCESS:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_online);
+		bfa_fcs_fabric_notify_online(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_PERF_EVFP:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_evfp);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_lps_discard(fabric->lps);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Authentication failed
+ */
+static void
+bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
+			      enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_fcs_fabric_notify_offline(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Port is in loopback mode.
+ */
+static void
+bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
+			   enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_fcs_fabric_notify_offline(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   There is no attached fabric - private loop or NPort-to-NPort topology.
+ */
+static void
+bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
+			   enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_lps_discard(fabric->lps);
+		bfa_fcs_fabric_notify_offline(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_NO_FABRIC:
+		bfa_trc(fabric->fcs, fabric->bb_credit);
+		bfa_pport_set_tx_bbcredit(fabric->fcs->bfa, fabric->bb_credit);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Fabric is online - normal operating state.
+ */
+static void
+bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
+			 enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
+		bfa_lps_discard(fabric->lps);
+		bfa_fcs_fabric_notify_offline(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_DELETE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
+		bfa_fcs_fabric_delete(fabric);
+		break;
+
+	case BFA_FCS_FABRIC_SM_AUTH_FAILED:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_auth_failed);
+		bfa_lps_discard(fabric->lps);
+		break;
+
+	case BFA_FCS_FABRIC_SM_AUTH_SUCCESS:
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   Exchanging virtual fabric parameters.
+ */
+static void
+bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
+		       enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_CONT_OP:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_evfp_done);
+		break;
+
+	case BFA_FCS_FABRIC_SM_ISOLATE:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_isolated);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+/**
+ *   EVFP exchange complete and VFT tagging is enabled.
+ */
+static void
+bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
+			    enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+}
+
+/**
+ *   Port is isolated after EVFP exchange due to VF_ID mismatch (N and F).
+ */
+static void
+bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
+			   enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	bfa_log(fabric->fcs->logm, BFA_LOG_FCS_FABRIC_ISOLATED,
+		fabric->bport.port_cfg.pwwn, fabric->fcs->port_vfid,
+		fabric->event_arg.swp_vfid);
+}
+
+/**
+ *   Fabric is being deleted, awaiting vport delete completions.
+ */
+static void
+bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
+			   enum bfa_fcs_fabric_event event)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_FABRIC_SM_DELCOMP:
+		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
+		bfa_fcs_modexit_comp(fabric->fcs);
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_UP:
+		break;
+
+	case BFA_FCS_FABRIC_SM_LINK_DOWN:
+		bfa_fcs_fabric_notify_offline(fabric);
+		break;
+
+	default:
+		bfa_sm_fault(fabric->fcs, event);
+	}
+}
+
+
+
+/**
+ *  fcs_fabric_private fabric private functions
+ */
+
+static void
+bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
+
+	port_cfg->roles = BFA_PORT_ROLE_FCP_IM;
+	port_cfg->nwwn = bfa_ioc_get_nwwn(&fabric->fcs->bfa->ioc);
+	port_cfg->pwwn = bfa_ioc_get_pwwn(&fabric->fcs->bfa->ioc);
+}
+
+/**
+ * Port Symbolic Name Creation for base port.
+ */
+void
+bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
+	struct bfa_adapter_attr_s adapter_attr;
+	struct bfa_fcs_driver_info_s *driver_info = &fabric->fcs->driver_info;
+
+	bfa_os_memset((void *)&adapter_attr, 0,
+		      sizeof(struct bfa_adapter_attr_s));
+	bfa_ioc_get_adapter_attr(&fabric->fcs->bfa->ioc, &adapter_attr);
+
+	/*
+	 * Model name/number
+	 */
+	strncpy((char *)&port_cfg->sym_name, adapter_attr.model,
+		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+
+	/*
+	 * Driver Version
+	 */
+	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
+		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+
+	/*
+	 * Host machine name
+	 */
+	strncat((char *)&port_cfg->sym_name,
+		(char *)driver_info->host_machine_name,
+		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+
+	/*
+	 * Host OS Info :
+	 * If OS Patch Info is not there, do not truncate any bytes from the
+	 * OS name string and instead copy the entire OS info string (64 bytes).
+	 */
+	if (driver_info->host_os_patch[0] == '\0') {
+		strncat((char *)&port_cfg->sym_name,
+			(char *)driver_info->host_os_name, BFA_FCS_OS_STR_LEN);
+		strncat((char *)&port_cfg->sym_name,
+			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	} else {
+		strncat((char *)&port_cfg->sym_name,
+			(char *)driver_info->host_os_name,
+			BFA_FCS_PORT_SYMBNAME_OSINFO_SZ);
+		strncat((char *)&port_cfg->sym_name,
+			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+
+		/*
+		 * Append host OS Patch Info
+		 */
+		strncat((char *)&port_cfg->sym_name,
+			(char *)driver_info->host_os_patch,
+			BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ);
+	}
+
+	/*
+	 * null terminate
+	 */
+	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
+}
+
+/**
+ * bfa lps login completion callback
+ */
+void
+bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
+{
+	struct bfa_fcs_fabric_s *fabric = uarg;
+
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_trc(fabric->fcs, status);
+
+	switch (status) {
+	case BFA_STATUS_OK:
+		fabric->stats.flogi_accepts++;
+		break;
+
+	case BFA_STATUS_INVALID_MAC:
+		/*
+		 * Only for CNA
+		 */
+		fabric->stats.flogi_acc_err++;
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_RETRY_OP);
+
+		return;
+
+	case BFA_STATUS_EPROTOCOL:
+		switch (bfa_lps_get_extstatus(fabric->lps)) {
+		case BFA_EPROTO_BAD_ACCEPT:
+			fabric->stats.flogi_acc_err++;
+			break;
+
+		case BFA_EPROTO_UNKNOWN_RSP:
+			fabric->stats.flogi_unknown_rsp++;
+			break;
+
+		default:
+			break;
+		}
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_RETRY_OP);
+
+		return;
+
+	case BFA_STATUS_FABRIC_RJT:
+		fabric->stats.flogi_rejects++;
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_RETRY_OP);
+		return;
+
+	default:
+		fabric->stats.flogi_rsp_err++;
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_RETRY_OP);
+		return;
+	}
+
+	fabric->bb_credit = bfa_lps_get_peer_bbcredit(fabric->lps);
+	bfa_trc(fabric->fcs, fabric->bb_credit);
+
+	if (!bfa_lps_is_brcd_fabric(fabric->lps))
+		fabric->fabric_name = bfa_lps_get_peer_nwwn(fabric->lps);
+
+	/*
+	 * Check port type. It should be 1 = F-port.
+	 */
+	if (bfa_lps_is_fport(fabric->lps)) {
+		fabric->bport.pid = bfa_lps_get_pid(fabric->lps);
+		fabric->is_npiv = bfa_lps_is_npiv_en(fabric->lps);
+		fabric->is_auth = bfa_lps_is_authreq(fabric->lps);
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CONT_OP);
+	} else {
+		/*
+		 * Nport-2-Nport direct attached
+		 */
+		fabric->bport.port_topo.pn2n.rem_port_wwn =
+			bfa_lps_get_peer_pwwn(fabric->lps);
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_NO_FABRIC);
+	}
+
+	bfa_trc(fabric->fcs, fabric->bport.pid);
+	bfa_trc(fabric->fcs, fabric->is_npiv);
+	bfa_trc(fabric->fcs, fabric->is_auth);
+}
+
+/**
+ * 		Allocate and send FLOGI.
+ */
+static void
+bfa_fcs_fabric_login(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_s   *bfa = fabric->fcs->bfa;
+	struct bfa_port_cfg_s *pcfg = &fabric->bport.port_cfg;
+	u8         alpa = 0;
+
+	if (bfa_pport_get_topology(bfa) == BFA_PPORT_TOPOLOGY_LOOP)
+		alpa = bfa_pport_get_myalpa(bfa);
+
+	bfa_lps_flogi(fabric->lps, fabric, alpa, bfa_pport_get_maxfrsize(bfa),
+		      pcfg->pwwn, pcfg->nwwn, fabric->auth_reqd);
+
+	fabric->stats.flogi_sent++;
+}
+
+static void
+bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_fcs_vport_s *vport;
+	struct list_head *qe, *qen;
+
+	bfa_trc(fabric->fcs, fabric->fabric_name);
+
+	bfa_fcs_fabric_set_opertype(fabric);
+	fabric->stats.fabric_onlines++;
+
+	/**
+	 * notify online event to base and then virtual ports
+	 */
+	bfa_fcs_port_online(&fabric->bport);
+
+	list_for_each_safe(qe, qen, &fabric->vport_q) {
+		vport = (struct bfa_fcs_vport_s *)qe;
+		bfa_fcs_vport_online(vport);
+	}
+}
+
+static void
+bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_fcs_vport_s *vport;
+	struct list_head *qe, *qen;
+
+	bfa_trc(fabric->fcs, fabric->fabric_name);
+	fabric->stats.fabric_offlines++;
+
+	/**
+	 * notify offline event first to vports and then base port.
+	 */
+	list_for_each_safe(qe, qen, &fabric->vport_q) {
+		vport = (struct bfa_fcs_vport_s *)qe;
+		bfa_fcs_vport_offline(vport);
+	}
+
+	bfa_fcs_port_offline(&fabric->bport);
+
+	fabric->fabric_name = 0;
+	fabric->fabric_ip_addr[0] = 0;
+}
+
+static void
+bfa_fcs_fabric_delay(void *cbarg)
+{
+	struct bfa_fcs_fabric_s *fabric = cbarg;
+
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELAYED);
+}
+
+/**
+ * Delete all vports and wait for vport delete completions.
+ */
+static void
+bfa_fcs_fabric_delete(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_fcs_vport_s *vport;
+	struct list_head *qe, *qen;
+
+	list_for_each_safe(qe, qen, &fabric->vport_q) {
+		vport = (struct bfa_fcs_vport_s *)qe;
+		bfa_fcs_vport_delete(vport);
+	}
+
+	bfa_fcs_port_delete(&fabric->bport);
+	bfa_wc_wait(&fabric->wc);
+}
+
+static void
+bfa_fcs_fabric_delete_comp(void *cbarg)
+{
+	struct bfa_fcs_fabric_s *fabric = cbarg;
+
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELCOMP);
+}
+
+
+
+/**
+ *  fcs_fabric_public fabric public functions
+ */
+
+/**
+ *   Module initialization
+ */
+void
+bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
+{
+	struct bfa_fcs_fabric_s *fabric;
+
+	fabric = &fcs->fabric;
+	bfa_os_memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
+
+	/**
+	 * Initialize base fabric.
+	 */
+	fabric->fcs = fcs;
+	INIT_LIST_HEAD(&fabric->vport_q);
+	INIT_LIST_HEAD(&fabric->vf_q);
+	fabric->lps = bfa_lps_alloc(fcs->bfa);
+	bfa_assert(fabric->lps);
+
+	/**
+	 * Initialize fabric delete completion handler. Fabric deletion is complete
+	 * when the last vport delete is complete.
+	 */
+	bfa_wc_init(&fabric->wc, bfa_fcs_fabric_delete_comp, fabric);
+	bfa_wc_up(&fabric->wc);	/* For the base port */
+
+	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CREATE);
+	bfa_trc(fcs, 0);
+}
+
+/**
+ *   Module cleanup
+ */
+void
+bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
+{
+	struct bfa_fcs_fabric_s *fabric;
+
+	bfa_trc(fcs, 0);
+
+	/**
+	 * Cleanup base fabric.
+	 */
+	fabric = &fcs->fabric;
+	bfa_lps_delete(fabric->lps);
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELETE);
+}
+
+/**
+ * Fabric module start -- kick starts FCS actions
+ */
+void
+bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs)
+{
+	struct bfa_fcs_fabric_s *fabric;
+
+	bfa_trc(fcs, 0);
+	fabric = &fcs->fabric;
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_START);
+}
+
+/**
+ *   Suspend fabric activity as part of driver suspend.
+ */
+void
+bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs)
+{
+}
+
+bfa_boolean_t
+bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric)
+{
+	return (bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_loopback));
+}
+
+enum bfa_pport_type
+bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric)
+{
+	return fabric->oper_type;
+}
+
+/**
+ *   Link up notification from BFA physical port module.
+ */
+void
+bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LINK_UP);
+}
+
+/**
+ *   Link down notification from BFA physical port module.
+ */
+void
+bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric)
+{
+	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LINK_DOWN);
+}
+
+/**
+ *   A child vport is being created in the fabric.
+ *
+ *   Call from vport module at vport creation. A list of base port and vports
+ *   belonging to a fabric is maintained to propagate link events.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *   param[in] vport  - Vport being created.
+ *
+ *   @return None (always succeeds)
+ */
+void
+bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
+			struct bfa_fcs_vport_s *vport)
+{
+	/**
+	 * - add vport to fabric's vport_q
+	 */
+	bfa_trc(fabric->fcs, fabric->vf_id);
+
+	list_add_tail(&vport->qe, &fabric->vport_q);
+	fabric->num_vports++;
+	bfa_wc_up(&fabric->wc);
+}
+
+/**
+ *   A child vport is being deleted from fabric.
+ *
+ *   Vport is being deleted.
+ */
+void
+bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
+			struct bfa_fcs_vport_s *vport)
+{
+	list_del(&vport->qe);
+	fabric->num_vports--;
+	bfa_wc_down(&fabric->wc);
+}
+
+/**
+ *   Base port is deleted.
+ */
+void
+bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric)
+{
+	bfa_wc_down(&fabric->wc);
+}
+
+/**
+ *    Check if fabric is online.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *
+ *   @return  TRUE/FALSE
+ */
+int
+bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
+{
+	return (bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online));
+}
+
+
+bfa_status_t
+bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf, struct bfa_fcs_s *fcs,
+		     struct bfa_port_cfg_s *port_cfg,
+		     struct bfad_vf_s *vf_drv)
+{
+	bfa_sm_set_state(vf, bfa_fcs_fabric_sm_uninit);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Lookup for a vport withing a fabric given its pwwn
+ */
+struct bfa_fcs_vport_s *
+bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
+{
+	struct bfa_fcs_vport_s *vport;
+	struct list_head *qe;
+
+	list_for_each(qe, &fabric->vport_q) {
+		vport = (struct bfa_fcs_vport_s *)qe;
+		if (bfa_fcs_port_get_pwwn(&vport->lport) == pwwn)
+			return vport;
+	}
+
+	return NULL;
+}
+
+/**
+ *    In a given fabric, return the number of lports.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *
+*    @return : 1 or more.
+ */
+u16
+bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
+{
+	return (fabric->num_vports);
+}
+
+/**
+ * 		Unsolicited frame receive handling.
+ */
+void
+bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
+		       u16 len)
+{
+	u32        pid = fchs->d_id;
+	struct bfa_fcs_vport_s *vport;
+	struct list_head *qe;
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+	struct fc_logi_s     *flogi = (struct fc_logi_s *) els_cmd;
+
+	bfa_trc(fabric->fcs, len);
+	bfa_trc(fabric->fcs, pid);
+
+	/**
+	 * Look for our own FLOGI frames being looped back. This means an
+	 * external loopback cable is in place. Our own FLOGI frames are
+	 * sometimes looped back when switch port gets temporarily bypassed.
+	 */
+	if ((pid == bfa_os_ntoh3b(FC_FABRIC_PORT))
+	    && (els_cmd->els_code == FC_ELS_FLOGI)
+	    && (flogi->port_name == bfa_fcs_port_get_pwwn(&fabric->bport))) {
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LOOPBACK);
+		return;
+	}
+
+	/**
+	 * FLOGI/EVFP exchanges should be consumed by base fabric.
+	 */
+	if (fchs->d_id == bfa_os_hton3b(FC_FABRIC_PORT)) {
+		bfa_trc(fabric->fcs, pid);
+		bfa_fcs_fabric_process_uf(fabric, fchs, len);
+		return;
+	}
+
+	if (fabric->bport.pid == pid) {
+		/**
+		 * All authentication frames should be routed to auth
+		 */
+		bfa_trc(fabric->fcs, els_cmd->els_code);
+		if (els_cmd->els_code == FC_ELS_AUTH) {
+			bfa_trc(fabric->fcs, els_cmd->els_code);
+			fabric->auth.response = (u8 *) els_cmd;
+			return;
+		}
+
+		bfa_trc(fabric->fcs, *(u8 *) ((u8 *) fchs));
+		bfa_fcs_port_uf_recv(&fabric->bport, fchs, len);
+		return;
+	}
+
+	/**
+	 * look for a matching local port ID
+	 */
+	list_for_each(qe, &fabric->vport_q) {
+		vport = (struct bfa_fcs_vport_s *)qe;
+		if (vport->lport.pid == pid) {
+			bfa_fcs_port_uf_recv(&vport->lport, fchs, len);
+			return;
+		}
+	}
+	bfa_trc(fabric->fcs, els_cmd->els_code);
+	bfa_fcs_port_uf_recv(&fabric->bport, fchs, len);
+}
+
+/**
+ * 		Unsolicited frames to be processed by fabric.
+ */
+static void
+bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
+			  u16 len)
+{
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	bfa_trc(fabric->fcs, els_cmd->els_code);
+
+	switch (els_cmd->els_code) {
+	case FC_ELS_FLOGI:
+		bfa_fcs_fabric_process_flogi(fabric, fchs, len);
+		break;
+
+	default:
+		/*
+		 * need to generate a LS_RJT
+		 */
+		break;
+	}
+}
+
+/**
+ * 	Process	incoming FLOGI
+ */
+static void
+bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
+			struct fchs_s *fchs, u16 len)
+{
+	struct fc_logi_s     *flogi = (struct fc_logi_s *) (fchs + 1);
+	struct bfa_fcs_port_s *bport = &fabric->bport;
+
+	bfa_trc(fabric->fcs, fchs->s_id);
+
+	fabric->stats.flogi_rcvd++;
+	/*
+	 * Check port type. It should be 0 = n-port.
+	 */
+	if (flogi->csp.port_type) {
+		/*
+		 * @todo: may need to send a LS_RJT
+		 */
+		bfa_trc(fabric->fcs, flogi->port_name);
+		fabric->stats.flogi_rejected++;
+		return;
+	}
+
+	fabric->bb_credit = bfa_os_ntohs(flogi->csp.bbcred);
+	bport->port_topo.pn2n.rem_port_wwn = flogi->port_name;
+	bport->port_topo.pn2n.reply_oxid = fchs->ox_id;
+
+	/*
+	 * Send a Flogi Acc
+	 */
+	bfa_fcs_fabric_send_flogi_acc(fabric);
+	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_NO_FABRIC);
+}
+
+static void
+bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
+{
+	struct bfa_port_cfg_s *pcfg = &fabric->bport.port_cfg;
+	struct bfa_fcs_port_n2n_s *n2n_port = &fabric->bport.port_topo.pn2n;
+	struct bfa_s   *bfa = fabric->fcs->bfa;
+	struct bfa_fcxp_s *fcxp;
+	u16        reqlen;
+	struct fchs_s          fchs;
+
+	fcxp = bfa_fcs_fcxp_alloc(fabric->fcs);
+	/**
+	 * Do not expect this failure -- expect remote node to retry
+	 */
+	if (!fcxp)
+		return;
+
+	reqlen = fc_flogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+				    bfa_os_hton3b(FC_FABRIC_PORT),
+				    n2n_port->reply_oxid, pcfg->pwwn,
+				    pcfg->nwwn, bfa_pport_get_maxfrsize(bfa),
+				    bfa_pport_get_rx_bbcredit(bfa));
+
+	bfa_fcxp_send(fcxp, NULL, fabric->vf_id, bfa_lps_get_tag(fabric->lps),
+			BFA_FALSE, FC_CLASS_3, reqlen, &fchs,
+			bfa_fcs_fabric_flogiacc_comp, fabric,
+			FC_MAX_PDUSZ, 0); /* Timeout 0 indicates no
+					   * response expected
+					   */
+}
+
+/**
+ *   Flogi Acc completion callback.
+ */
+static void
+bfa_fcs_fabric_flogiacc_comp(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			     bfa_status_t status, u32 rsp_len,
+			     u32 resid_len, struct fchs_s *rspfchs)
+{
+	struct bfa_fcs_fabric_s *fabric = cbarg;
+
+	bfa_trc(fabric->fcs, status);
+}
+
+/*
+ *
+ * @param[in] fabric - fabric
+ * @param[in] result - 1
+ *
+ * @return - none
+ */
+void
+bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric, enum auth_status status)
+{
+	bfa_trc(fabric->fcs, status);
+
+	if (status == FC_AUTH_STATE_SUCCESS)
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_AUTH_SUCCESS);
+	else
+		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_AUTH_FAILED);
+}
+
+/**
+ * Send AEN notification
+ */
+static void
+bfa_fcs_fabric_aen_post(struct bfa_fcs_port_s *port,
+			enum bfa_port_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = port->fcs->logm;
+	wwn_t           pwwn = bfa_fcs_port_get_pwwn(port);
+	wwn_t           fwwn = bfa_fcs_port_get_fabric_name(port);
+	char            pwwn_buf[BFA_STRING_32];
+	char            fwwn_buf[BFA_STRING_32];
+	char           *pwwn_ptr;
+	char           *fwwn_ptr;
+
+	pwwn_ptr = wwn2str(pwwn_buf, sizeof(pwwn_buf), pwwn);
+	fwwn_ptr = wwn2str(fwwn_buf, sizeof(fwwn_buf), fwwn);
+
+	switch (event) {
+	case BFA_PORT_AEN_FABRIC_NAME_CHANGE:
+		bfa_log(logmod, BFA_AEN_PORT_FABRIC_NAME_CHANGE, pwwn_ptr,
+			fwwn_ptr);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.port.pwwn = pwwn;
+	aen_data.port.fwwn = fwwn;
+}
+
+/*
+ *
+ * @param[in] fabric - fabric
+ * @param[in] wwn_t - new fabric name
+ *
+ * @return - none
+ */
+void
+bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
+			       wwn_t fabric_name)
+{
+	bfa_trc(fabric->fcs, fabric_name);
+
+	if (fabric->fabric_name == 0) {
+		/*
+		 * With BRCD switches, we don't get Fabric Name in FLOGI.
+		 * Don't generate a fabric name change event in this case.
+		 */
+		fabric->fabric_name = fabric_name;
+	} else {
+		fabric->fabric_name = fabric_name;
+		/*
+		 * Generate a Event
+		 */
+		bfa_fcs_fabric_aen_post(&fabric->bport,
+					BFA_PORT_AEN_FABRIC_NAME_CHANGE);
+	}
+
+}
+
+/**
+ * Not used by FCS.
+ */
+void
+bfa_cb_lps_flogo_comp(void *bfad, void *uarg)
+{
+}
+
+
diff -urpN orig/drivers/scsi/bfa/fcbuild.c patch/drivers/scsi/bfa/fcbuild.c
--- orig/drivers/scsi/bfa/fcbuild.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcbuild.c	2009-08-19 17:47:55.000000000 -0700
@@ -0,0 +1,1449 @@
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
+/*
+ * fcbuild.c - FC link service frame building and parsing routines
+ */
+
+#include <bfa_os_inc.h>
+#include "fcbuild.h"
+
+/*
+ * static build functions
+ */
+static void fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id);
+static void fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id);
+static struct fchs_s   fc_els_req_tmpl;
+static struct fchs_s   fc_els_rsp_tmpl;
+static struct fchs_s   fc_bls_req_tmpl;
+static struct fchs_s   fc_bls_rsp_tmpl;
+static struct fc_ba_acc_s ba_acc_tmpl;
+static struct fc_logi_s plogi_tmpl;
+static struct fc_prli_s prli_tmpl;
+static struct fc_rrq_s rrq_tmpl;
+static struct fchs_s   fcp_fchs_tmpl;
+
+void
+fcbuild_init(void)
+{
+	/*
+	 * fc_els_req_tmpl
+	 */
+	fc_els_req_tmpl.routing = FC_RTG_EXT_LINK;
+	fc_els_req_tmpl.cat_info = FC_CAT_LD_REQUEST;
+	fc_els_req_tmpl.type = FC_TYPE_ELS;
+	fc_els_req_tmpl.f_ctl =
+		bfa_os_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
+			      FCTL_SI_XFER);
+	fc_els_req_tmpl.rx_id = FC_RXID_ANY;
+
+	/*
+	 * fc_els_rsp_tmpl
+	 */
+	fc_els_rsp_tmpl.routing = FC_RTG_EXT_LINK;
+	fc_els_rsp_tmpl.cat_info = FC_CAT_LD_REPLY;
+	fc_els_rsp_tmpl.type = FC_TYPE_ELS;
+	fc_els_rsp_tmpl.f_ctl =
+		bfa_os_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
+			      FCTL_END_SEQ | FCTL_SI_XFER);
+	fc_els_rsp_tmpl.rx_id = FC_RXID_ANY;
+
+	/*
+	 * fc_bls_req_tmpl
+	 */
+	fc_bls_req_tmpl.routing = FC_RTG_BASIC_LINK;
+	fc_bls_req_tmpl.type = FC_TYPE_BLS;
+	fc_bls_req_tmpl.f_ctl = bfa_os_hton3b(FCTL_END_SEQ | FCTL_SI_XFER);
+	fc_bls_req_tmpl.rx_id = FC_RXID_ANY;
+
+	/*
+	 * fc_bls_rsp_tmpl
+	 */
+	fc_bls_rsp_tmpl.routing = FC_RTG_BASIC_LINK;
+	fc_bls_rsp_tmpl.cat_info = FC_CAT_BA_ACC;
+	fc_bls_rsp_tmpl.type = FC_TYPE_BLS;
+	fc_bls_rsp_tmpl.f_ctl =
+		bfa_os_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
+			      FCTL_END_SEQ | FCTL_SI_XFER);
+	fc_bls_rsp_tmpl.rx_id = FC_RXID_ANY;
+
+	/*
+	 * ba_acc_tmpl
+	 */
+	ba_acc_tmpl.seq_id_valid = 0;
+	ba_acc_tmpl.low_seq_cnt = 0;
+	ba_acc_tmpl.high_seq_cnt = 0xFFFF;
+
+	/*
+	 * plogi_tmpl
+	 */
+	plogi_tmpl.csp.verhi = FC_PH_VER_PH_3;
+	plogi_tmpl.csp.verlo = FC_PH_VER_4_3;
+	plogi_tmpl.csp.bbcred = bfa_os_htons(0x0004);
+	plogi_tmpl.csp.ciro = 0x1;
+	plogi_tmpl.csp.cisc = 0x0;
+	plogi_tmpl.csp.altbbcred = 0x0;
+	plogi_tmpl.csp.conseq = bfa_os_htons(0x00FF);
+	plogi_tmpl.csp.ro_bitmap = bfa_os_htons(0x0002);
+	plogi_tmpl.csp.e_d_tov = bfa_os_htonl(2000);
+
+	plogi_tmpl.class3.class_valid = 1;
+	plogi_tmpl.class3.sequential = 1;
+	plogi_tmpl.class3.conseq = 0xFF;
+	plogi_tmpl.class3.ospx = 1;
+
+	/*
+	 * prli_tmpl
+	 */
+	prli_tmpl.command = FC_ELS_PRLI;
+	prli_tmpl.pglen = 0x10;
+	prli_tmpl.pagebytes = bfa_os_htons(0x0014);
+	prli_tmpl.parampage.type = FC_TYPE_FCP;
+	prli_tmpl.parampage.imagepair = 1;
+	prli_tmpl.parampage.servparams.rxrdisab = 1;
+
+	/*
+	 * rrq_tmpl
+	 */
+	rrq_tmpl.els_cmd.els_code = FC_ELS_RRQ;
+
+	/*
+	 * fcp_fchs_tmpl
+	 */
+	fcp_fchs_tmpl.routing = FC_RTG_FC4_DEV_DATA;
+	fcp_fchs_tmpl.cat_info = FC_CAT_UNSOLICIT_CMD;
+	fcp_fchs_tmpl.type = FC_TYPE_FCP;
+	fcp_fchs_tmpl.f_ctl =
+		bfa_os_hton3b(FCTL_FS_EXCH | FCTL_END_SEQ | FCTL_SI_XFER);
+	fcp_fchs_tmpl.seq_id = 1;
+	fcp_fchs_tmpl.rx_id = FC_RXID_ANY;
+}
+
+static void
+fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u32 ox_id)
+{
+	bfa_os_memset(fchs, 0, sizeof(struct fchs_s));
+
+	fchs->routing = FC_RTG_FC4_DEV_DATA;
+	fchs->cat_info = FC_CAT_UNSOLICIT_CTRL;
+	fchs->type = FC_TYPE_SERVICES;
+	fchs->f_ctl =
+		bfa_os_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
+			      FCTL_SI_XFER);
+	fchs->rx_id = FC_RXID_ANY;
+	fchs->d_id = (d_id);
+	fchs->s_id = (s_id);
+	fchs->ox_id = bfa_os_htons(ox_id);
+
+	/**
+	 * @todo no need to set ox_id for request
+	 *       no need to set rx_id for response
+	 */
+}
+
+void
+fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id)
+{
+	bfa_os_memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
+	fchs->d_id = (d_id);
+	fchs->s_id = (s_id);
+	fchs->ox_id = bfa_os_htons(ox_id);
+}
+
+static void
+fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id)
+{
+	bfa_os_memcpy(fchs, &fc_els_rsp_tmpl, sizeof(struct fchs_s));
+	fchs->d_id = d_id;
+	fchs->s_id = s_id;
+	fchs->ox_id = ox_id;
+}
+
+enum fc_parse_status
+fc_els_rsp_parse(struct fchs_s *fchs, int len)
+{
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+	struct fc_ls_rjt_s    *ls_rjt = (struct fc_ls_rjt_s *) els_cmd;
+
+	len = len;
+
+	switch (els_cmd->els_code) {
+	case FC_ELS_LS_RJT:
+		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
+			return (FC_PARSE_BUSY);
+		else
+			return (FC_PARSE_FAILURE);
+
+	case FC_ELS_ACC:
+		return (FC_PARSE_OK);
+	}
+	return (FC_PARSE_OK);
+}
+
+static void
+fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id)
+{
+	bfa_os_memcpy(fchs, &fc_bls_rsp_tmpl, sizeof(struct fchs_s));
+	fchs->d_id = d_id;
+	fchs->s_id = s_id;
+	fchs->ox_id = ox_id;
+}
+
+static          u16
+fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+		 u16 ox_id, wwn_t port_name, wwn_t node_name,
+		 u16 pdu_size, u8 els_code)
+{
+	struct fc_logi_s     *plogi = (struct fc_logi_s *) (pld);
+
+	bfa_os_memcpy(plogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+
+	plogi->els_cmd.els_code = els_code;
+	if (els_code == FC_ELS_PLOGI)
+		fc_els_req_build(fchs, d_id, s_id, ox_id);
+	else
+		fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	plogi->csp.rxsz = plogi->class3.rxsz = bfa_os_htons(pdu_size);
+
+	bfa_os_memcpy(&plogi->port_name, &port_name, sizeof(wwn_t));
+	bfa_os_memcpy(&plogi->node_name, &node_name, sizeof(wwn_t));
+
+	return (sizeof(struct fc_logi_s));
+}
+
+u16
+fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
+		u16 ox_id, wwn_t port_name, wwn_t node_name,
+		u16 pdu_size, u8 set_npiv, u8 set_auth,
+		u16 local_bb_credits)
+{
+	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
+	u32 	*vvl_info;
+
+	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+
+	flogi->els_cmd.els_code = FC_ELS_FLOGI;
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->port_name = port_name;
+	flogi->node_name = node_name;
+
+	/*
+	 * Set the NPIV Capability Bit ( word 1, bit 31) of Common
+	 * Service Parameters.
+	 */
+	flogi->csp.ciro = set_npiv;
+
+	/* set AUTH capability */
+	flogi->csp.security = set_auth;
+
+	flogi->csp.bbcred = bfa_os_htons(local_bb_credits);
+
+	/* Set brcd token in VVL */
+	vvl_info = (u32 *)&flogi->vvl[0];
+
+	/* set the flag to indicate the presence of VVL */
+	flogi->csp.npiv_supp    = 1; /* @todo. field name is not correct */
+	vvl_info[0]	= bfa_os_htonl(FLOGI_VVL_BRCD);
+
+	return (sizeof(struct fc_logi_s));
+}
+
+u16
+fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
+		   u16 ox_id, wwn_t port_name, wwn_t node_name,
+		   u16 pdu_size, u16 local_bb_credits)
+{
+	u32        d_id = 0;
+
+	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	flogi->els_cmd.els_code = FC_ELS_ACC;
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->port_name = port_name;
+	flogi->node_name = node_name;
+
+	flogi->csp.bbcred = bfa_os_htons(local_bb_credits);
+
+	return (sizeof(struct fc_logi_s));
+}
+
+u16
+fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
+		u16 ox_id, wwn_t port_name, wwn_t node_name,
+		u16 pdu_size)
+{
+	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
+
+	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+
+	flogi->els_cmd.els_code = FC_ELS_FDISC;
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->port_name = port_name;
+	flogi->node_name = node_name;
+
+	return (sizeof(struct fc_logi_s));
+}
+
+u16
+fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+	       u16 ox_id, wwn_t port_name, wwn_t node_name,
+	       u16 pdu_size)
+{
+	return fc_plogi_x_build(fchs, pld, d_id, s_id, ox_id, port_name,
+				node_name, pdu_size, FC_ELS_PLOGI);
+}
+
+u16
+fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+		   u16 ox_id, wwn_t port_name, wwn_t node_name,
+		   u16 pdu_size)
+{
+	return fc_plogi_x_build(fchs, pld, d_id, s_id, ox_id, port_name,
+				node_name, pdu_size, FC_ELS_ACC);
+}
+
+enum fc_parse_status
+fc_plogi_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
+{
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+	struct fc_logi_s     *plogi;
+	struct fc_ls_rjt_s    *ls_rjt;
+
+	switch (els_cmd->els_code) {
+	case FC_ELS_LS_RJT:
+		ls_rjt = (struct fc_ls_rjt_s *) (fchs + 1);
+		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
+			return (FC_PARSE_BUSY);
+		else
+			return (FC_PARSE_FAILURE);
+	case FC_ELS_ACC:
+		plogi = (struct fc_logi_s *) (fchs + 1);
+		if (len < sizeof(struct fc_logi_s))
+			return (FC_PARSE_FAILURE);
+
+		if (!wwn_is_equal(plogi->port_name, port_name))
+			return (FC_PARSE_FAILURE);
+
+		if (!plogi->class3.class_valid)
+			return (FC_PARSE_FAILURE);
+
+		if (bfa_os_ntohs(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
+			return (FC_PARSE_FAILURE);
+
+		return (FC_PARSE_OK);
+	default:
+		return (FC_PARSE_FAILURE);
+	}
+}
+
+enum fc_parse_status
+fc_plogi_parse(struct fchs_s *fchs)
+{
+	struct fc_logi_s     *plogi = (struct fc_logi_s *) (fchs + 1);
+
+	if (plogi->class3.class_valid != 1)
+		return FC_PARSE_FAILURE;
+
+	if ((bfa_os_ntohs(plogi->class3.rxsz) < FC_MIN_PDUSZ)
+	    || (bfa_os_ntohs(plogi->class3.rxsz) > FC_MAX_PDUSZ)
+	    || (plogi->class3.rxsz == 0))
+		return (FC_PARSE_FAILURE);
+
+	return FC_PARSE_OK;
+}
+
+u16
+fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+	      u16 ox_id)
+{
+	struct fc_prli_s      *prli = (struct fc_prli_s *) (pld);
+
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+	bfa_os_memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
+
+	prli->command = FC_ELS_PRLI;
+	prli->parampage.servparams.initiator     = 1;
+	prli->parampage.servparams.retry         = 1;
+	prli->parampage.servparams.rec_support   = 1;
+	prli->parampage.servparams.task_retry_id = 0;
+	prli->parampage.servparams.confirm       = 1;
+
+	return (sizeof(struct fc_prli_s));
+}
+
+u16
+fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+		  u16 ox_id, enum bfa_port_role role)
+{
+	struct fc_prli_s      *prli = (struct fc_prli_s *) (pld);
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+	bfa_os_memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
+
+	prli->command = FC_ELS_ACC;
+
+	if ((role & BFA_PORT_ROLE_FCP_TM) == BFA_PORT_ROLE_FCP_TM)
+		prli->parampage.servparams.target = 1;
+	else
+		prli->parampage.servparams.initiator = 1;
+
+	prli->parampage.rspcode = FC_PRLI_ACC_XQTD;
+
+	return (sizeof(struct fc_prli_s));
+}
+
+enum fc_parse_status
+fc_prli_rsp_parse(struct fc_prli_s *prli, int len)
+{
+	if (len < sizeof(struct fc_prli_s))
+		return (FC_PARSE_FAILURE);
+
+	if (prli->command != FC_ELS_ACC)
+		return (FC_PARSE_FAILURE);
+
+	if ((prli->parampage.rspcode != FC_PRLI_ACC_XQTD)
+	    && (prli->parampage.rspcode != FC_PRLI_ACC_PREDEF_IMG))
+		return (FC_PARSE_FAILURE);
+
+	if (prli->parampage.servparams.target != 1)
+		return (FC_PARSE_FAILURE);
+
+	return (FC_PARSE_OK);
+}
+
+enum fc_parse_status
+fc_prli_parse(struct fc_prli_s *prli)
+{
+	if (prli->parampage.type != FC_TYPE_FCP)
+		return (FC_PARSE_FAILURE);
+
+	if (!prli->parampage.imagepair)
+		return (FC_PARSE_FAILURE);
+
+	if (!prli->parampage.servparams.initiator)
+		return (FC_PARSE_FAILURE);
+
+	return (FC_PARSE_OK);
+}
+
+u16
+fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id,
+			u32 s_id, u16 ox_id, wwn_t port_name)
+{
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	memset(logo, '\0', sizeof(struct fc_logo_s));
+	logo->els_cmd.els_code = FC_ELS_LOGO;
+	logo->nport_id = (s_id);
+	logo->orig_port_name = port_name;
+
+	return (sizeof(struct fc_logo_s));
+}
+
+static          u16
+fc_adisc_x_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
+		 u32 s_id, u16 ox_id, wwn_t port_name,
+		 wwn_t node_name, u8 els_code)
+{
+	memset(adisc, '\0', sizeof(struct fc_adisc_s));
+
+	adisc->els_cmd.els_code = els_code;
+
+	if (els_code == FC_ELS_ADISC)
+		fc_els_req_build(fchs, d_id, s_id, ox_id);
+	else
+		fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	adisc->orig_HA = 0;
+	adisc->orig_port_name = port_name;
+	adisc->orig_node_name = node_name;
+	adisc->nport_id = (s_id);
+
+	return (sizeof(struct fc_adisc_s));
+}
+
+u16
+fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
+		u32 s_id, u16 ox_id, wwn_t port_name,
+		wwn_t node_name)
+{
+	return fc_adisc_x_build(fchs, adisc, d_id, s_id, ox_id, port_name,
+				node_name, FC_ELS_ADISC);
+}
+
+u16
+fc_adisc_acc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
+		   u32 s_id, u16 ox_id, wwn_t port_name,
+		   wwn_t node_name)
+{
+	return fc_adisc_x_build(fchs, adisc, d_id, s_id, ox_id, port_name,
+				node_name, FC_ELS_ACC);
+}
+
+enum fc_parse_status
+fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len, wwn_t port_name,
+				 wwn_t node_name)
+{
+
+	if (len < sizeof(struct fc_adisc_s))
+		return (FC_PARSE_FAILURE);
+
+	if (adisc->els_cmd.els_code != FC_ELS_ACC)
+		return (FC_PARSE_FAILURE);
+
+	if (!wwn_is_equal(adisc->orig_port_name, port_name))
+		return (FC_PARSE_FAILURE);
+
+	return (FC_PARSE_OK);
+}
+
+enum fc_parse_status
+fc_adisc_parse(struct fchs_s *fchs, void *pld, u32 host_dap,
+		 wwn_t node_name, wwn_t port_name)
+{
+	struct fc_adisc_s     *adisc = (struct fc_adisc_s *) pld;
+
+	if (adisc->els_cmd.els_code != FC_ELS_ACC)
+		return (FC_PARSE_FAILURE);
+
+	if ((adisc->nport_id == (host_dap))
+	    && wwn_is_equal(adisc->orig_port_name, port_name)
+	    && wwn_is_equal(adisc->orig_node_name, node_name))
+		return (FC_PARSE_OK);
+
+	return (FC_PARSE_FAILURE);
+}
+
+enum fc_parse_status
+fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
+{
+	struct fc_logi_s     *pdisc = (struct fc_logi_s *) (fchs + 1);
+
+	if (pdisc->class3.class_valid != 1)
+		return FC_PARSE_FAILURE;
+
+	if ((bfa_os_ntohs(pdisc->class3.rxsz) <
+		 (FC_MIN_PDUSZ - sizeof(struct fchs_s)))
+	    || (pdisc->class3.rxsz == 0))
+		return (FC_PARSE_FAILURE);
+
+	if (!wwn_is_equal(pdisc->port_name, port_name))
+		return (FC_PARSE_FAILURE);
+
+	if (!wwn_is_equal(pdisc->node_name, node_name))
+		return (FC_PARSE_FAILURE);
+
+	return FC_PARSE_OK;
+}
+
+u16
+fc_abts_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
+{
+	bfa_os_memcpy(fchs, &fc_bls_req_tmpl, sizeof(struct fchs_s));
+	fchs->cat_info = FC_CAT_ABTS;
+	fchs->d_id = (d_id);
+	fchs->s_id = (s_id);
+	fchs->ox_id = bfa_os_htons(ox_id);
+
+	return (sizeof(struct fchs_s));
+}
+
+enum fc_parse_status
+fc_abts_rsp_parse(struct fchs_s *fchs, int len)
+{
+	if ((fchs->cat_info == FC_CAT_BA_ACC)
+	    || (fchs->cat_info == FC_CAT_BA_RJT))
+		return (FC_PARSE_OK);
+
+	return (FC_PARSE_FAILURE);
+}
+
+u16
+fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id,
+			 u32 s_id, u16 ox_id, u16 rrq_oxid)
+{
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	/*
+	 * build rrq payload
+	 */
+	bfa_os_memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
+	rrq->s_id = (s_id);
+	rrq->ox_id = bfa_os_htons(rrq_oxid);
+	rrq->rx_id = FC_RXID_ANY;
+
+	return (sizeof(struct fc_rrq_s));
+}
+
+u16
+fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
+		  u16 ox_id)
+{
+	struct fc_els_cmd_s   *acc = pld;
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	memset(acc, 0, sizeof(struct fc_els_cmd_s));
+	acc->els_code = FC_ELS_ACC;
+
+	return (sizeof(struct fc_els_cmd_s));
+}
+
+u16
+fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt, u32 d_id,
+		u32 s_id, u16 ox_id, u8 reason_code,
+		u8 reason_code_expl)
+{
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+	memset(ls_rjt, 0, sizeof(struct fc_ls_rjt_s));
+
+	ls_rjt->els_cmd.els_code = FC_ELS_LS_RJT;
+	ls_rjt->reason_code = reason_code;
+	ls_rjt->reason_code_expl = reason_code_expl;
+	ls_rjt->vendor_unique = 0x00;
+
+	return (sizeof(struct fc_ls_rjt_s));
+}
+
+u16
+fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
+		u32 s_id, u16 ox_id, u16 rx_id)
+{
+	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
+
+	bfa_os_memcpy(ba_acc, &ba_acc_tmpl, sizeof(struct fc_ba_acc_s));
+
+	fchs->rx_id = rx_id;
+
+	ba_acc->ox_id = fchs->ox_id;
+	ba_acc->rx_id = fchs->rx_id;
+
+	return (sizeof(struct fc_ba_acc_s));
+}
+
+u16
+fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd,
+			u32 d_id, u32 s_id, u16 ox_id)
+{
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+	memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
+	els_cmd->els_code = FC_ELS_ACC;
+
+	return (sizeof(struct fc_els_cmd_s));
+}
+
+int
+fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
+{
+	int             num_pages = 0;
+	struct fc_prlo_s      *prlo;
+	struct fc_tprlo_s     *tprlo;
+
+	if (els_code == FC_ELS_PRLO) {
+		prlo = (struct fc_prlo_s *) (fc_frame + 1);
+		num_pages = (bfa_os_ntohs(prlo->payload_len) - 4) / 16;
+	} else {
+		tprlo = (struct fc_tprlo_s *) (fc_frame + 1);
+		num_pages = (bfa_os_ntohs(tprlo->payload_len) - 4) / 16;
+	}
+	return num_pages;
+}
+
+u16
+fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			int num_pages)
+{
+	int             page;
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	memset(tprlo_acc, 0, (num_pages * 16) + 4);
+	tprlo_acc->command = FC_ELS_ACC;
+
+	tprlo_acc->page_len = 0x10;
+	tprlo_acc->payload_len = bfa_os_htons((num_pages * 16) + 4);
+
+	for (page = 0; page < num_pages; page++) {
+		tprlo_acc->tprlo_acc_params[page].opa_valid = 0;
+		tprlo_acc->tprlo_acc_params[page].rpa_valid = 0;
+		tprlo_acc->tprlo_acc_params[page].fc4type_csp = FC_TYPE_FCP;
+		tprlo_acc->tprlo_acc_params[page].orig_process_assc = 0;
+		tprlo_acc->tprlo_acc_params[page].resp_process_assc = 0;
+	}
+	return (bfa_os_ntohs(tprlo_acc->payload_len));
+}
+
+u16
+fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			int num_pages)
+{
+	int             page;
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	memset(prlo_acc, 0, (num_pages * 16) + 4);
+	prlo_acc->command = FC_ELS_ACC;
+	prlo_acc->page_len = 0x10;
+	prlo_acc->payload_len = bfa_os_htons((num_pages * 16) + 4);
+
+	for (page = 0; page < num_pages; page++) {
+		prlo_acc->prlo_acc_params[page].opa_valid = 0;
+		prlo_acc->prlo_acc_params[page].rpa_valid = 0;
+		prlo_acc->prlo_acc_params[page].fc4type_csp = FC_TYPE_FCP;
+		prlo_acc->prlo_acc_params[page].orig_process_assc = 0;
+		prlo_acc->prlo_acc_params[page].resp_process_assc = 0;
+	}
+
+	return (bfa_os_ntohs(prlo_acc->payload_len));
+}
+
+u16
+fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
+			u32 s_id, u16 ox_id, u32 data_format)
+{
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	memset(rnid, 0, sizeof(struct fc_rnid_cmd_s));
+
+	rnid->els_cmd.els_code = FC_ELS_RNID;
+	rnid->node_id_data_format = data_format;
+
+	return (sizeof(struct fc_rnid_cmd_s));
+}
+
+u16
+fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u32 data_format,
+			struct fc_rnid_common_id_data_s *common_id_data,
+			struct fc_rnid_general_topology_data_s *gen_topo_data)
+{
+	memset(rnid_acc, 0, sizeof(struct fc_rnid_acc_s));
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	rnid_acc->els_cmd.els_code = FC_ELS_ACC;
+	rnid_acc->node_id_data_format = data_format;
+	rnid_acc->common_id_data_length =
+			sizeof(struct fc_rnid_common_id_data_s);
+	rnid_acc->common_id_data = *common_id_data;
+
+	if (data_format == RNID_NODEID_DATA_FORMAT_DISCOVERY) {
+		rnid_acc->specific_id_data_length =
+			sizeof(struct fc_rnid_general_topology_data_s);
+		bfa_os_assign(rnid_acc->gen_topology_data, *gen_topo_data);
+		return (sizeof(struct fc_rnid_acc_s));
+	} else {
+		return (sizeof(struct fc_rnid_acc_s) -
+			sizeof(struct fc_rnid_general_topology_data_s));
+	}
+
+}
+
+u16
+fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
+			u32 s_id, u16 ox_id)
+{
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
+
+	rpsc->els_cmd.els_code = FC_ELS_RPSC;
+	return (sizeof(struct fc_rpsc_cmd_s));
+}
+
+u16
+fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2,
+			u32 d_id, u32 s_id, u32 *pid_list,
+			u16 npids)
+{
+	u32 dctlr_id = FC_DOMAIN_CTRLR(bfa_os_hton3b(d_id));
+	int i = 0;
+
+	fc_els_req_build(fchs, bfa_os_hton3b(dctlr_id), s_id, 0);
+
+	memset(rpsc2, 0, sizeof(struct fc_rpsc2_cmd_s));
+
+	rpsc2->els_cmd.els_code = FC_ELS_RPSC;
+	rpsc2->token = bfa_os_htonl(FC_BRCD_TOKEN);
+	rpsc2->num_pids  = bfa_os_htons(npids);
+	for (i = 0; i < npids; i++)
+		rpsc2->pid_list[i].pid = pid_list[i];
+
+	return (sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) *
+			(sizeof(u32))));
+}
+
+u16
+fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			struct fc_rpsc_speed_info_s *oper_speed)
+{
+	memset(rpsc_acc, 0, sizeof(struct fc_rpsc_acc_s));
+
+	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
+
+	rpsc_acc->command = FC_ELS_ACC;
+	rpsc_acc->num_entries = bfa_os_htons(1);
+
+	rpsc_acc->speed_info[0].port_speed_cap =
+		bfa_os_htons(oper_speed->port_speed_cap);
+
+	rpsc_acc->speed_info[0].port_op_speed =
+		bfa_os_htons(oper_speed->port_op_speed);
+
+	return (sizeof(struct fc_rpsc_acc_s));
+
+}
+
+/*
+ * TBD -
+ * . get rid of unnecessary memsets
+ */
+
+u16
+fc_logo_rsp_parse(struct fchs_s *fchs, int len)
+{
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	len = len;
+	if (els_cmd->els_code != FC_ELS_ACC)
+		return FC_PARSE_FAILURE;
+
+	return FC_PARSE_OK;
+}
+
+u16
+fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, wwn_t port_name, wwn_t node_name,
+			u16 pdu_size)
+{
+	struct fc_logi_s     *pdisc = (struct fc_logi_s *) (fchs + 1);
+
+	bfa_os_memcpy(pdisc, &plogi_tmpl, sizeof(struct fc_logi_s));
+
+	pdisc->els_cmd.els_code = FC_ELS_PDISC;
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	pdisc->csp.rxsz = pdisc->class3.rxsz = bfa_os_htons(pdu_size);
+	pdisc->port_name = port_name;
+	pdisc->node_name = node_name;
+
+	return (sizeof(struct fc_logi_s));
+}
+
+u16
+fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
+{
+	struct fc_logi_s     *pdisc = (struct fc_logi_s *) (fchs + 1);
+
+	if (len < sizeof(struct fc_logi_s))
+		return (FC_PARSE_LEN_INVAL);
+
+	if (pdisc->els_cmd.els_code != FC_ELS_ACC)
+		return (FC_PARSE_ACC_INVAL);
+
+	if (!wwn_is_equal(pdisc->port_name, port_name))
+		return (FC_PARSE_PWWN_NOT_EQUAL);
+
+	if (!pdisc->class3.class_valid)
+		return (FC_PARSE_NWWN_NOT_EQUAL);
+
+	if (bfa_os_ntohs(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
+		return (FC_PARSE_RXSZ_INVAL);
+
+	return (FC_PARSE_OK);
+}
+
+u16
+fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
+	      int num_pages)
+{
+	struct fc_prlo_s      *prlo = (struct fc_prlo_s *) (fchs + 1);
+	int             page;
+
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+	memset(prlo, 0, (num_pages * 16) + 4);
+	prlo->command = FC_ELS_PRLO;
+	prlo->page_len = 0x10;
+	prlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
+
+	for (page = 0; page < num_pages; page++) {
+		prlo->prlo_params[page].type = FC_TYPE_FCP;
+		prlo->prlo_params[page].opa_valid = 0;
+		prlo->prlo_params[page].rpa_valid = 0;
+		prlo->prlo_params[page].orig_process_assc = 0;
+		prlo->prlo_params[page].resp_process_assc = 0;
+	}
+
+	return (bfa_os_ntohs(prlo->payload_len));
+}
+
+u16
+fc_prlo_rsp_parse(struct fchs_s *fchs, int len)
+{
+	struct fc_prlo_acc_s  *prlo = (struct fc_prlo_acc_s *) (fchs + 1);
+	int             num_pages = 0;
+	int             page = 0;
+
+	len = len;
+
+	if (prlo->command != FC_ELS_ACC)
+		return (FC_PARSE_FAILURE);
+
+	num_pages = ((bfa_os_ntohs(prlo->payload_len)) - 4) / 16;
+
+	for (page = 0; page < num_pages; page++) {
+		if (prlo->prlo_acc_params[page].type != FC_TYPE_FCP)
+			return FC_PARSE_FAILURE;
+
+		if (prlo->prlo_acc_params[page].opa_valid != 0)
+			return FC_PARSE_FAILURE;
+
+		if (prlo->prlo_acc_params[page].rpa_valid != 0)
+			return FC_PARSE_FAILURE;
+
+		if (prlo->prlo_acc_params[page].orig_process_assc != 0)
+			return FC_PARSE_FAILURE;
+
+		if (prlo->prlo_acc_params[page].resp_process_assc != 0)
+			return FC_PARSE_FAILURE;
+	}
+	return (FC_PARSE_OK);
+
+}
+
+u16
+fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, int num_pages,
+			enum fc_tprlo_type tprlo_type, u32 tpr_id)
+{
+	struct fc_tprlo_s     *tprlo = (struct fc_tprlo_s *) (fchs + 1);
+	int             page;
+
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+	memset(tprlo, 0, (num_pages * 16) + 4);
+	tprlo->command = FC_ELS_TPRLO;
+	tprlo->page_len = 0x10;
+	tprlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
+
+	for (page = 0; page < num_pages; page++) {
+		tprlo->tprlo_params[page].type = FC_TYPE_FCP;
+		tprlo->tprlo_params[page].opa_valid = 0;
+		tprlo->tprlo_params[page].rpa_valid = 0;
+		tprlo->tprlo_params[page].orig_process_assc = 0;
+		tprlo->tprlo_params[page].resp_process_assc = 0;
+		if (tprlo_type == FC_GLOBAL_LOGO) {
+			tprlo->tprlo_params[page].global_process_logout = 1;
+		} else if (tprlo_type == FC_TPR_LOGO) {
+			tprlo->tprlo_params[page].tpo_nport_valid = 1;
+			tprlo->tprlo_params[page].tpo_nport_id = (tpr_id);
+		}
+	}
+
+	return (bfa_os_ntohs(tprlo->payload_len));
+}
+
+u16
+fc_tprlo_rsp_parse(struct fchs_s *fchs, int len)
+{
+	struct fc_tprlo_acc_s *tprlo = (struct fc_tprlo_acc_s *) (fchs + 1);
+	int             num_pages = 0;
+	int             page = 0;
+
+	len = len;
+
+	if (tprlo->command != FC_ELS_ACC)
+		return (FC_PARSE_ACC_INVAL);
+
+	num_pages = (bfa_os_ntohs(tprlo->payload_len) - 4) / 16;
+
+	for (page = 0; page < num_pages; page++) {
+		if (tprlo->tprlo_acc_params[page].type != FC_TYPE_FCP)
+			return (FC_PARSE_NOT_FCP);
+		if (tprlo->tprlo_acc_params[page].opa_valid != 0)
+			return (FC_PARSE_OPAFLAG_INVAL);
+		if (tprlo->tprlo_acc_params[page].rpa_valid != 0)
+			return (FC_PARSE_RPAFLAG_INVAL);
+		if (tprlo->tprlo_acc_params[page].orig_process_assc != 0)
+			return (FC_PARSE_OPA_INVAL);
+		if (tprlo->tprlo_acc_params[page].resp_process_assc != 0)
+			return (FC_PARSE_RPA_INVAL);
+	}
+	return (FC_PARSE_OK);
+}
+
+enum fc_parse_status
+fc_rrq_rsp_parse(struct fchs_s *fchs, int len)
+{
+	struct fc_els_cmd_s   *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	len = len;
+	if (els_cmd->els_code != FC_ELS_ACC)
+		return FC_PARSE_FAILURE;
+
+	return FC_PARSE_OK;
+}
+
+u16
+fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, u32 reason_code,
+			u32 reason_expl)
+{
+	struct fc_ba_rjt_s    *ba_rjt = (struct fc_ba_rjt_s *) (fchs + 1);
+
+	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
+
+	fchs->cat_info = FC_CAT_BA_RJT;
+	ba_rjt->reason_code = reason_code;
+	ba_rjt->reason_expl = reason_expl;
+	return (sizeof(struct fc_ba_rjt_s));
+}
+
+static void
+fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
+{
+	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	cthdr->rev_id = CT_GS3_REVISION;
+	cthdr->gs_type = CT_GSTYPE_DIRSERVICE;
+	cthdr->gs_sub_type = CT_GSSUBTYPE_NAMESERVER;
+	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+}
+
+static void
+fc_gs_fdmi_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
+{
+	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	cthdr->rev_id = CT_GS3_REVISION;
+	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
+	cthdr->gs_sub_type = CT_GSSUBTYPE_HBA_MGMTSERVER;
+	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+}
+
+static void
+fc_gs_ms_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code,
+					 u8 sub_type)
+{
+	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	cthdr->rev_id = CT_GS3_REVISION;
+	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
+	cthdr->gs_sub_type = sub_type;
+	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+}
+
+u16
+fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+	       wwn_t port_name)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_gidpn_req_s *gidpn =
+			(struct fcgs_gidpn_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_GID_PN);
+
+	bfa_os_memset(gidpn, 0, sizeof(struct fcgs_gidpn_req_s));
+	gidpn->port_name = port_name;
+	return (sizeof(struct fcgs_gidpn_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+	       u32 port_id)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	fcgs_gpnid_req_t *gpnid = (fcgs_gpnid_req_t *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_GPN_ID);
+
+	bfa_os_memset(gpnid, 0, sizeof(fcgs_gpnid_req_t));
+	gpnid->dap = port_id;
+	return (sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+	       u32 port_id)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	fcgs_gnnid_req_t *gnnid = (fcgs_gnnid_req_t *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_GNN_ID);
+
+	bfa_os_memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
+	gnnid->dap = port_id;
+	return (sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
+{
+	if (bfa_os_ntohs(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
+		if (cthdr->reason_code == CT_RSN_LOGICAL_BUSY)
+			return FC_PARSE_BUSY;
+		else
+			return FC_PARSE_FAILURE;
+	}
+
+	return FC_PARSE_OK;
+}
+
+u16
+fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr, u8 set_br_reg,
+			u32 s_id, u16 ox_id)
+{
+	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
+
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+
+	bfa_os_memset(scr, 0, sizeof(struct fc_scr_s));
+	scr->command = FC_ELS_SCR;
+	scr->reg_func = FC_SCR_REG_FUNC_FULL;
+	if (set_br_reg)
+		scr->vu_reg_func = FC_VU_SCR_REG_FUNC_FABRIC_NAME_CHANGE;
+
+	return (sizeof(struct fc_scr_s));
+}
+
+u16
+fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn, u32 s_id,
+			u16 ox_id)
+{
+	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
+	u16        payldlen;
+
+	fc_els_req_build(fchs, d_id, s_id, ox_id);
+	rscn->command = FC_ELS_RSCN;
+	rscn->pagelen = sizeof(rscn->event[0]);
+
+	payldlen = sizeof(u32) + rscn->pagelen;
+	rscn->payldlen = bfa_os_htons(payldlen);
+
+	rscn->event[0].format = FC_RSCN_FORMAT_PORTID;
+	rscn->event[0].portid = s_id;
+
+	return (sizeof(struct fc_rscn_pl_s));
+}
+
+u16
+fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+	       enum bfa_port_role roles)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rftid_req_s *rftid =
+			(struct fcgs_rftid_req_s *) (cthdr + 1);
+	u32        type_value, d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u8         index;
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
+
+	bfa_os_memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
+
+	rftid->dap = s_id;
+
+	/* By default, FCP FC4 Type is registered */
+	index = FC_TYPE_FCP >> 5;
+	type_value = 1 << (FC_TYPE_FCP % 32);
+	rftid->fc4_type[index] = bfa_os_htonl(type_value);
+
+	if (roles & BFA_PORT_ROLE_FCP_IPFC) {
+		index = FC_TYPE_IP >> 5;
+		type_value = 1 << (FC_TYPE_IP % 32);
+		rftid->fc4_type[index] |= bfa_os_htonl(type_value);
+	}
+
+	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 ox_id, u8 *fc4_bitmap,
+			u32 bitmap_size)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rftid_req_s *rftid =
+			(struct fcgs_rftid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
+
+	bfa_os_memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
+
+	rftid->dap = s_id;
+	bfa_os_memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
+			(bitmap_size < 32 ? bitmap_size : 32));
+
+	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+	       u8 fc4_type, u8 fc4_ftrs)
+{
+	struct ct_hdr_s         *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rffid_req_s *rffid =
+			(struct fcgs_rffid_req_s *) (cthdr + 1);
+	u32         d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RFF_ID);
+
+	bfa_os_memset(rffid, 0, sizeof(struct fcgs_rffid_req_s));
+
+	rffid->dap 		 	= s_id;
+	rffid->fc4ftr_bits  = fc4_ftrs;
+	rffid->fc4_type		= fc4_type;
+
+	return (sizeof(struct fcgs_rffid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
+		u8 *name)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rspnid_req_s *rspnid =
+			(struct fcgs_rspnid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RSPN_ID);
+
+	bfa_os_memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
+
+	rspnid->dap = s_id;
+	rspnid->spn_len = (u8) strlen((char *)name);
+	strncpy((char *)rspnid->spn, (char *)name, rspnid->spn_len);
+
+	return (sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u8 fc4_type)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_gidft_req_s *gidft =
+			(struct fcgs_gidft_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+
+	fc_gs_cthdr_build(cthdr, s_id, GS_GID_FT);
+
+	bfa_os_memset(gidft, 0, sizeof(struct fcgs_gidft_req_s));
+	gidft->fc4_type = fc4_type;
+	gidft->domain_id = 0;
+	gidft->area_id = 0;
+
+	return (sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
+	       wwn_t port_name)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rpnid_req_s *rpnid =
+			(struct fcgs_rpnid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RPN_ID);
+
+	bfa_os_memset(rpnid, 0, sizeof(struct fcgs_rpnid_req_s));
+	rpnid->port_id = port_id;
+	rpnid->port_name = port_name;
+
+	return (sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
+	       wwn_t node_name)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rnnid_req_s *rnnid =
+			(struct fcgs_rnnid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RNN_ID);
+
+	bfa_os_memset(rnnid, 0, sizeof(struct fcgs_rnnid_req_s));
+	rnnid->port_id = port_id;
+	rnnid->node_name = node_name;
+
+	return (sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
+	       u32 cos)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rcsid_req_s *rcsid =
+			(struct fcgs_rcsid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RCS_ID);
+
+	bfa_os_memset(rcsid, 0, sizeof(struct fcgs_rcsid_req_s));
+	rcsid->port_id = port_id;
+	rcsid->cos = cos;
+
+	return (sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
+	       u8 port_type)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_rptid_req_s *rptid =
+			(struct fcgs_rptid_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_cthdr_build(cthdr, s_id, GS_RPT_ID);
+
+	bfa_os_memset(rptid, 0, sizeof(struct fcgs_rptid_req_s));
+	rptid->port_id = port_id;
+	rptid->port_type = port_type;
+
+	return (sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s));
+}
+
+u16
+fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	struct fcgs_ganxt_req_s *ganxt =
+			(struct fcgs_ganxt_req_s *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_cthdr_build(cthdr, s_id, GS_GA_NXT);
+
+	bfa_os_memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
+	ganxt->port_id = port_id;
+
+	return (sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s));
+}
+
+/*
+ * Builds fc hdr and ct hdr for FDMI requests.
+ */
+u16
+fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+		     u16 cmd_code)
+{
+
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_fdmi_cthdr_build(cthdr, s_id, cmd_code);
+
+	return (sizeof(struct ct_hdr_s));
+}
+
+/*
+ * Given a FC4 Type, this function returns a fc4 type bitmask
+ */
+void
+fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask)
+{
+	u8         index;
+	u32       *ptr = (u32 *) bit_mask;
+	u32        type_value;
+
+	/*
+	 * @todo : Check for bitmask size
+	 */
+
+	index = fc4_type >> 5;
+	type_value = 1 << (fc4_type % 32);
+	ptr[index] = bfa_os_htonl(type_value);
+
+}
+
+/*
+ * GMAL Request
+ */
+u16
+fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	fcgs_gmal_req_t *gmal = (fcgs_gmal_req_t *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GMAL_CMD,
+			CT_GSSUBTYPE_CFGSERVER);
+
+	bfa_os_memset(gmal, 0, sizeof(fcgs_gmal_req_t));
+	gmal->wwn = wwn;
+
+	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gmal_req_t));
+}
+
+/*
+ * GFN (Get Fabric Name) Request
+ */
+u16
+fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
+{
+	struct ct_hdr_s       *cthdr = (struct ct_hdr_s *) pyld;
+	fcgs_gfn_req_t *gfn = (fcgs_gfn_req_t *) (cthdr + 1);
+	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+
+	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
+	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GFN_CMD,
+			CT_GSSUBTYPE_CFGSERVER);
+
+	bfa_os_memset(gfn, 0, sizeof(fcgs_gfn_req_t));
+	gfn->wwn = wwn;
+
+	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gfn_req_t));
+}
