From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 6/14] bfa: Brocade BFA FC SCSI driver (fcs part-1)
Date: Fri, 24 Jul 2009 22:57:40 -0700
Message-ID: <200907250557.n6P5ven2023937@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate07out.mcdata.com ([144.49.194.4]:49874 "EHLO
	mx30.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbZGYF5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2009 01:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-1

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_fcs.c       |  180 +++++++
 bfa_fcs_lport.c |  941 +++++++++++++++++++++++++++++++++++++++++
 bfa_fcs_port.c  |   68 ++
 bfa_fcs_uf.c    |  105 ++++
 fab.c           |   62 ++
 fabric.c        | 1280 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 2636 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_fcs.c patch/drivers/scsi/bfa/bfa_fcs.c
--- orig/drivers/scsi/bfa/bfa_fcs.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcs.c	2009-07-21 15:34:04.000000000 -0700
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
+++ patch/drivers/scsi/bfa/bfa_fcs_lport.c	2009-07-21 15:34:04.000000000 -0700
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
+++ patch/drivers/scsi/bfa/bfa_fcs_port.c	2009-07-21 15:34:04.000000000 -0700
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
+++ patch/drivers/scsi/bfa/bfa_fcs_uf.c	2009-07-21 15:34:04.000000000 -0700
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
+++ patch/drivers/scsi/bfa/fab.c	2009-07-21 15:34:03.000000000 -0700
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
+++ patch/drivers/scsi/bfa/fabric.c	2009-07-21 15:34:03.000000000 -0700
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
