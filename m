From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/6] bfa: Brocade BFA FC SCSI driver (fcs)
Date: Tue, 21 Jul 2009 16:10:03 -0700
Message-ID: <200907212310.n6LNA3ZU007402@swe57.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756519AbZGUXKq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com, xmzhang@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_fcs.c       |  180 +++
 bfa_fcs_lport.c |  941 ++++++++++++++++++++
 bfa_fcs_port.c  |   68 +
 bfa_fcs_uf.c    |  105 ++
 fab.c           |   62 +
 fabric.c        | 1280 +++++++++++++++++++++++++++
 fcbuild.c       | 1449 ++++++++++++++++++++++++++++++
 fcbuild.h       |  273 +++++
 fcpim.c         |  846 ++++++++++++++++++
 fcptm.c         |   68 +
 fcs.h           |   30 
 fcs_auth.h      |   37 
 fcs_fabric.h    |   61 +
 fcs_fcpim.h     |   44 
 fcs_fcptm.h     |   45 
 fcs_fcxp.h      |   29 
 fcs_lport.h     |  117 ++
 fcs_ms.h        |   35 
 fcs_port.h      |   32 
 fcs_rport.h     |   61 +
 fcs_trcmod.h    |   56 +
 fcs_uf.h        |   32 
 fcs_vport.h     |   39 
 fdmi.c          | 1223 ++++++++++++++++++++++++++
 loop.c          |  422 +++++++++
 lport_api.c     |  291 ++++++
 lport_priv.h    |   82 +
 ms.c            |  759 ++++++++++++++++
 n2n.c           |  105 ++
 ns.c            | 1243 ++++++++++++++++++++++++++
 plog.c          |  184 +++
 rport.c         | 2620 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rport_api.c     |  180 +++
 rport_ftrs.c    |  375 ++++++++
 scn.c           |  482 ++++++++++
 vfapi.c         |  292 ++++++
 vport.c         |  892 +++++++++++++++++++
 37 files changed, 15040 insertions(+)

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
diff -urpN orig/drivers/scsi/bfa/fcbuild.c patch/drivers/scsi/bfa/fcbuild.c
--- orig/drivers/scsi/bfa/fcbuild.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcbuild.c	2009-07-21 15:34:03.000000000 -0700
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
diff -urpN orig/drivers/scsi/bfa/fcbuild.h patch/drivers/scsi/bfa/fcbuild.h
--- orig/drivers/scsi/bfa/fcbuild.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcbuild.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,273 @@
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
+ * fcbuild.h - FC link service frame building and parsing routines
+ */
+
+#ifndef __FCBUILD_H__
+#define __FCBUILD_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/fc.h>
+#include <protocol/fcp.h>
+#include <protocol/ct.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_pport.h>
+
+/*
+ * Utility Macros/functions
+ */
+
+#define fcif_sof_set(_ifhdr, _sof)	(_ifhdr)->sof = FC_ ## _sof
+#define fcif_eof_set(_ifhdr, _eof)	(_ifhdr)->eof = FC_ ## _eof
+
+#define wwn_is_equal(_wwn1, _wwn2)		\
+	(memcmp(&(_wwn1), &(_wwn2), sizeof(wwn_t)) == 0)
+
+#define fc_roundup(_l, _s) (((_l) + ((_s) - 1)) & ~((_s) - 1))
+
+/*
+ * Given the fc response length, this routine will return
+ * the length of the actual payload bytes following the CT header.
+ *
+ * Assumes the input response length does not include the crc, eof, etc.
+ */
+static inline   u32
+fc_get_ctresp_pyld_len(u32 resp_len)
+{
+	return (resp_len - sizeof(struct ct_hdr_s));
+}
+
+/*
+ * Convert bfa speed to rpsc speed value.
+ */
+static inline enum bfa_pport_speed
+fc_rpsc_operspeed_to_bfa_speed(enum fc_rpsc_op_speed_s speed)
+{
+	switch (speed) {
+
+	case RPSC_OP_SPEED_1G:
+		return BFA_PPORT_SPEED_1GBPS;
+
+	case RPSC_OP_SPEED_2G:
+		return BFA_PPORT_SPEED_2GBPS;
+
+	case RPSC_OP_SPEED_4G:
+		return BFA_PPORT_SPEED_4GBPS;
+
+	case RPSC_OP_SPEED_8G:
+		return BFA_PPORT_SPEED_8GBPS;
+
+	default:
+		return BFA_PPORT_SPEED_UNKNOWN;
+	}
+}
+
+/*
+ * Convert RPSC speed to bfa speed value.
+ */
+static inline   enum fc_rpsc_op_speed_s
+fc_bfa_speed_to_rpsc_operspeed(enum bfa_pport_speed op_speed)
+{
+	switch (op_speed) {
+
+	case BFA_PPORT_SPEED_1GBPS:
+		return RPSC_OP_SPEED_1G;
+
+	case BFA_PPORT_SPEED_2GBPS:
+		return RPSC_OP_SPEED_2G;
+
+	case BFA_PPORT_SPEED_4GBPS:
+		return RPSC_OP_SPEED_4G;
+
+	case BFA_PPORT_SPEED_8GBPS:
+		return RPSC_OP_SPEED_8G;
+
+	default:
+		return RPSC_OP_SPEED_NOT_EST;
+	}
+}
+enum fc_parse_status {
+	FC_PARSE_OK = 0,
+	FC_PARSE_FAILURE = 1,
+	FC_PARSE_BUSY = 2,
+	FC_PARSE_LEN_INVAL,
+	FC_PARSE_ACC_INVAL,
+	FC_PARSE_PWWN_NOT_EQUAL,
+	FC_PARSE_NWWN_NOT_EQUAL,
+	FC_PARSE_RXSZ_INVAL,
+	FC_PARSE_NOT_FCP,
+	FC_PARSE_OPAFLAG_INVAL,
+	FC_PARSE_RPAFLAG_INVAL,
+	FC_PARSE_OPA_INVAL,
+	FC_PARSE_RPA_INVAL,
+
+};
+
+struct fc_templates_s {
+	struct fchs_s          fc_els_req;
+	struct fchs_s          fc_bls_req;
+	struct fc_logi_s      plogi;
+	struct fc_rrq_s        rrq;
+};
+
+void fcbuild_init(void);
+
+u16 fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
+			u32 s_id, u16 ox_id, wwn_t port_name,
+			wwn_t node_name, u16 pdu_size, u8 set_npiv,
+			u8 set_auth, u16 local_bb_credits);
+u16 fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi,
+			u32 s_id, u16 ox_id, wwn_t port_name,
+			wwn_t node_name, u16 pdu_size);
+u16 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
+			u32 s_id, u16 ox_id, wwn_t port_name,
+			wwn_t node_name, u16 pdu_size,
+			u16 local_bb_credits);
+u16 fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			u32 s_id, u16 ox_id, wwn_t port_name,
+			wwn_t node_name, u16 pdu_size);
+enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
+u16 fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
+			u16 ox_id);
+enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
+u16 fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq, u32 d_id,
+			u32 s_id, u16 ox_id, u16 rrq_oxid);
+enum fc_parse_status fc_rrq_rsp_parse(struct fchs_s *buf, int len);
+u16 fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			u16 ox_id, u8 *name);
+u16 fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			u16 ox_id, enum bfa_port_role role);
+u16 fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 ox_id, u8 *fc4_bitmap,
+			u32 bitmap_size);
+u16 fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 ox_id, u8 fc4_type, u8 fc4_ftrs);
+u16 fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 ox_id, wwn_t port_name);
+u16 fc_gpnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			u16 ox_id, u32 port_id);
+u16 fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
+			u8 set_br_reg, u32 s_id, u16 ox_id);
+u16 fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			u32 s_id, u16 ox_id,
+			wwn_t port_name, wwn_t node_name, u16 pdu_size);
+
+u16 fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			wwn_t port_name, wwn_t node_name);
+enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
+			u32 host_dap,
+			wwn_t node_name, wwn_t port_name);
+enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
+			wwn_t port_name, wwn_t node_name);
+u16 fc_adisc_acc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			wwn_t port_name, wwn_t node_name);
+u16 fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u8 reason_code, u8 reason_code_expl);
+u16 fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd,
+			u32 d_id, u32 s_id, u16 ox_id);
+u16 fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			u32 s_id, u16 ox_id);
+enum fc_parse_status fc_prli_rsp_parse(struct fc_prli_s *prli, int len);
+
+u16 fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			u32 s_id, u16 ox_id,
+			enum bfa_port_role role);
+u16 fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u32 data_format);
+u16 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u32 data_format,
+			struct fc_rnid_common_id_data_s *common_id_data,
+			struct fc_rnid_general_topology_data_s *
+			gen_topo_data);
+u16 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rps2c,
+			u32 d_id, u32 s_id,
+			u32 *pid_list, u16 npids);
+u16 fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
+			u32 d_id, u32 s_id, u16 ox_id);
+u16 fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			struct fc_rpsc_speed_info_s *oper_speed);
+u16 fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
+			u8 fc4_type);
+u16 fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u32 port_id, wwn_t port_name);
+u16 fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u32 port_id, wwn_t node_name);
+u16 fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u32 port_id, u32 cos);
+u16 fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u32 port_id, u8 port_type);
+u16 fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u32 port_id);
+u16 fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo,
+			u32 d_id, u32 s_id, u16 ox_id,
+			wwn_t port_name);
+u16 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
+			u32 s_id, u16 ox_id);
+u16 fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 cmd_code);
+u16 fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			wwn_t wwn);
+u16 fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			wwn_t wwn);
+void fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
+void fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id);
+enum fc_parse_status fc_els_rsp_parse(struct fchs_s *fchs, int len);
+enum fc_parse_status fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
+			 wwn_t port_name);
+enum fc_parse_status fc_prli_parse(struct fc_prli_s *prli);
+enum fc_parse_status fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
+			wwn_t port_name);
+u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			u16 rx_id);
+int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
+u16 fc_tprlo_acc_build(struct fchs_s *fchs,
+			struct fc_tprlo_acc_s *tprlo_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			int num_pages);
+u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
+			u32 d_id, u32 s_id, u16 ox_id,
+			int num_pages);
+u16 fc_logo_rsp_parse(struct fchs_s *fchs, int len);
+u16 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, wwn_t port_name, wwn_t node_name,
+			u16 pdu_size);
+u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
+u16 fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, int num_pages);
+u16 fc_prlo_rsp_parse(struct fchs_s *fchs, int len);
+u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, int num_pages,
+			enum fc_tprlo_type tprlo_type, u32 tpr_id);
+u16 fc_tprlo_rsp_parse(struct fchs_s *fchs, int len);
+u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
+			u16 ox_id, u32 reason_code,
+			u32 reason_expl);
+u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
+			u16 ox_id, u32 port_id);
+u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
+u16 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
+			u32 s_id, u16 ox_id);
+#endif
diff -urpN orig/drivers/scsi/bfa/fcpim.c patch/drivers/scsi/bfa/fcpim.c
--- orig/drivers/scsi/bfa/fcpim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcpim.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,846 @@
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
+ *  fcpim.c - FCP initiator mode i-t nexus state machine
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include "fcs_fcpim.h"
+#include "fcs_rport.h"
+#include "fcs_lport.h"
+#include "fcs_trcmod.h"
+#include "fcs_fcxp.h"
+#include "fcs.h"
+#include <fcs/bfa_fcs_fcpim.h>
+#include <fcb/bfa_fcb_fcpim.h>
+#include <aen/bfa_aen_itnim.h>
+
+BFA_TRC_FILE(FCS, FCPIM);
+
+/*
+ * forward declarations
+ */
+static void     bfa_fcs_itnim_timeout(void *arg);
+static void     bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim);
+static void     bfa_fcs_itnim_send_prli(void *itnim_cbarg,
+					struct bfa_fcxp_s *fcxp_alloced);
+static void     bfa_fcs_itnim_prli_response(void *fcsarg,
+					    struct bfa_fcxp_s *fcxp,
+					    void *cbarg,
+					    bfa_status_t req_status,
+					    u32 rsp_len,
+					    u32 resid_len,
+					    struct fchs_s *rsp_fchs);
+static void     bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
+				       enum bfa_itnim_aen_event event);
+
+/**
+ *  fcs_itnim_sm FCS itnim state machine events
+ */
+
+enum bfa_fcs_itnim_event {
+	BFA_FCS_ITNIM_SM_ONLINE = 1,	/*  rport online event */
+	BFA_FCS_ITNIM_SM_OFFLINE = 2,	/*  rport offline */
+	BFA_FCS_ITNIM_SM_FRMSENT = 3,	/*  prli frame is sent */
+	BFA_FCS_ITNIM_SM_RSP_OK = 4,	/*  good response */
+	BFA_FCS_ITNIM_SM_RSP_ERROR = 5,	/*  error response */
+	BFA_FCS_ITNIM_SM_TIMEOUT = 6,	/*  delay timeout */
+	BFA_FCS_ITNIM_SM_HCB_OFFLINE = 7,	/*  BFA online callback */
+	BFA_FCS_ITNIM_SM_HCB_ONLINE = 8,	/*  BFA offline callback */
+	BFA_FCS_ITNIM_SM_INITIATOR = 9,	/*  rport is initiator */
+	BFA_FCS_ITNIM_SM_DELETE = 10,	/*  delete event from rport */
+	BFA_FCS_ITNIM_SM_PRLO = 11,	/*  delete event from rport */
+};
+
+static void     bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
+					 enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
+					   enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
+				      enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
+					    enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
+					    enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
+					enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
+					     enum bfa_fcs_itnim_event event);
+static void     bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
+					   enum bfa_fcs_itnim_event event);
+
+static struct bfa_sm_table_s itnim_sm_table[] = {
+	{BFA_SM(bfa_fcs_itnim_sm_offline), BFA_ITNIM_OFFLINE},
+	{BFA_SM(bfa_fcs_itnim_sm_prli_send), BFA_ITNIM_PRLI_SEND},
+	{BFA_SM(bfa_fcs_itnim_sm_prli), BFA_ITNIM_PRLI_SENT},
+	{BFA_SM(bfa_fcs_itnim_sm_prli_retry), BFA_ITNIM_PRLI_RETRY},
+	{BFA_SM(bfa_fcs_itnim_sm_hcb_online), BFA_ITNIM_HCB_ONLINE},
+	{BFA_SM(bfa_fcs_itnim_sm_online), BFA_ITNIM_ONLINE},
+	{BFA_SM(bfa_fcs_itnim_sm_hcb_offline), BFA_ITNIM_HCB_OFFLINE},
+	{BFA_SM(bfa_fcs_itnim_sm_initiator), BFA_ITNIM_INITIATIOR},
+};
+
+/**
+ *  fcs_itnim_sm FCS itnim state machine
+ */
+
+static void
+bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
+			 enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_ONLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_send);
+		bfa_fcs_itnim_send_prli(itnim, NULL);
+		break;
+
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_INITIATOR:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+
+}
+
+static void
+bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
+			   enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_FRMSENT:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli);
+		break;
+
+	case BFA_FCS_ITNIM_SM_INITIATOR:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
+		bfa_fcxp_walloc_cancel(itnim->fcs->bfa, &itnim->fcxp_wqe);
+		break;
+
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcxp_walloc_cancel(itnim->fcs->bfa, &itnim->fcxp_wqe);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcxp_walloc_cancel(itnim->fcs->bfa, &itnim->fcxp_wqe);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
+		      enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_RSP_OK:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_hcb_online);
+		bfa_itnim_online(itnim->bfa_itnim, itnim->seq_rec);
+		break;
+
+	case BFA_FCS_ITNIM_SM_RSP_ERROR:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_retry);
+		bfa_timer_start(itnim->fcs->bfa, &itnim->timer,
+				bfa_fcs_itnim_timeout, itnim,
+				BFA_FCS_RETRY_TIMEOUT);
+		break;
+
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcxp_discard(itnim->fcxp);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_INITIATOR:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
+		/*
+		 * dont discard fcxp. accept will reach same state
+		 */
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcxp_discard(itnim->fcxp);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
+			    enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_TIMEOUT:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_prli_send);
+		bfa_fcs_itnim_send_prli(itnim, NULL);
+		break;
+
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_timer_stop(&itnim->timer);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_INITIATOR:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_initiator);
+		bfa_timer_stop(&itnim->timer);
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_timer_stop(&itnim->timer);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
+			    enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_HCB_ONLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_online);
+		bfa_fcb_itnim_online(itnim->itnim_drv);
+		bfa_fcs_itnim_aen_post(itnim, BFA_ITNIM_AEN_ONLINE);
+		break;
+
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_itnim_offline(itnim->bfa_itnim);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
+			enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_hcb_offline);
+		bfa_fcb_itnim_offline(itnim->itnim_drv);
+		bfa_itnim_offline(itnim->bfa_itnim);
+		if (bfa_fcs_port_is_online(itnim->rport->port) == BFA_TRUE) {
+			bfa_fcs_itnim_aen_post(itnim, BFA_ITNIM_AEN_DISCONNECT);
+		} else {
+			bfa_fcs_itnim_aen_post(itnim, BFA_ITNIM_AEN_OFFLINE);
+		}
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
+			     enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_HCB_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_itnim_free(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/*
+ * This state is set when a discovered rport is also in intiator mode.
+ * This ITN is marked as no_op and is not active and will not be truned into
+ * online state.
+ */
+static void
+bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
+			   enum bfa_fcs_itnim_event event)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_trc(itnim->fcs, event);
+
+	switch (event) {
+	case BFA_FCS_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_rport_itnim_ack(itnim->rport);
+		break;
+
+	case BFA_FCS_ITNIM_SM_RSP_ERROR:
+	case BFA_FCS_ITNIM_SM_ONLINE:
+	case BFA_FCS_ITNIM_SM_INITIATOR:
+		break;
+
+	case BFA_FCS_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+		bfa_fcs_itnim_free(itnim);
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
+ *  itnim_private FCS ITNIM private interfaces
+ */
+
+static void
+bfa_fcs_itnim_aen_post(struct bfa_fcs_itnim_s *itnim,
+		       enum bfa_itnim_aen_event event)
+{
+	struct bfa_fcs_rport_s *rport = itnim->rport;
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = rport->fcs->logm;
+	wwn_t           lpwwn = bfa_fcs_port_get_pwwn(rport->port);
+	wwn_t           rpwwn = rport->pwwn;
+	char            lpwwn_buf[BFA_STRING_32];
+	char            rpwwn_buf[BFA_STRING_32];
+	char           *lpwwn_ptr;
+	char           *rpwwn_ptr;
+
+	/*
+	 * Don't post events for well known addresses
+	 */
+	if (BFA_FCS_PID_IS_WKA(rport->pid))
+		return;
+
+	lpwwn_ptr = wwn2str(lpwwn_buf, sizeof(lpwwn_buf), lpwwn);
+	rpwwn_ptr = wwn2str(rpwwn_buf, sizeof(rpwwn_buf), rpwwn);
+
+	switch (event) {
+	case BFA_ITNIM_AEN_ONLINE:
+		bfa_log(logmod, BFA_AEN_ITNIM_ONLINE, rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_ITNIM_AEN_OFFLINE:
+		bfa_log(logmod, BFA_AEN_ITNIM_OFFLINE, rpwwn_ptr, lpwwn_ptr);
+		break;
+	case BFA_ITNIM_AEN_DISCONNECT:
+		bfa_log(logmod, BFA_AEN_ITNIM_DISCONNECT, rpwwn_ptr, lpwwn_ptr);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.itnim.vf_id = rport->port->fabric->vf_id;
+	aen_data.itnim.ppwwn =
+		bfa_fcs_port_get_pwwn(bfa_fcs_get_base_port(itnim->fcs));
+	aen_data.itnim.lpwwn = lpwwn;
+	aen_data.itnim.rpwwn = rpwwn;
+}
+
+static void
+bfa_fcs_itnim_send_prli(void *itnim_cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_itnim_s *itnim = itnim_cbarg;
+	struct bfa_fcs_rport_s *rport = itnim->rport;
+	struct bfa_fcs_port_s *port = rport->port;
+	struct fchs_s          fchs;
+	struct bfa_fcxp_s *fcxp;
+	int             len;
+
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		itnim->stats.fcxp_alloc_wait++;
+		bfa_fcxp_alloc_wait(port->fcs->bfa, &itnim->fcxp_wqe,
+				    bfa_fcs_itnim_send_prli, itnim);
+		return;
+	}
+	itnim->fcxp = fcxp;
+
+	len = fc_prli_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), itnim->rport->pid,
+			    bfa_fcs_port_get_fcid(port), 0);
+
+	bfa_fcxp_send(fcxp, rport->bfa_rport, port->fabric->vf_id, port->lp_tag,
+		      BFA_FALSE, FC_CLASS_3, len, &fchs,
+		      bfa_fcs_itnim_prli_response, (void *)itnim, FC_MAX_PDUSZ,
+		      FC_RA_TOV);
+
+	itnim->stats.prli_sent++;
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_FRMSENT);
+}
+
+static void
+bfa_fcs_itnim_prli_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
+			    bfa_status_t req_status, u32 rsp_len,
+			    u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cbarg;
+	struct fc_els_cmd_s   *els_cmd;
+	struct fc_prli_s      *prli_resp;
+	struct fc_ls_rjt_s    *ls_rjt;
+	struct fc_prli_params_s *sparams;
+
+	bfa_trc(itnim->fcs, req_status);
+
+	/*
+	 * Sanity Checks
+	 */
+	if (req_status != BFA_STATUS_OK) {
+		itnim->stats.prli_rsp_err++;
+		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_RSP_ERROR);
+		return;
+	}
+
+	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+	if (els_cmd->els_code == FC_ELS_ACC) {
+		prli_resp = (struct fc_prli_s *) els_cmd;
+
+		if (fc_prli_rsp_parse(prli_resp, rsp_len) != FC_PARSE_OK) {
+			bfa_trc(itnim->fcs, rsp_len);
+			/*
+			 * Check if this  r-port is also in Initiator mode.
+			 * If so, we need to set this ITN as a no-op.
+			 */
+			if (prli_resp->parampage.servparams.initiator) {
+				bfa_trc(itnim->fcs, prli_resp->parampage.type);
+				itnim->rport->scsi_function =
+					BFA_RPORT_INITIATOR;
+				itnim->stats.prli_rsp_acc++;
+				bfa_sm_send_event(itnim,
+						  BFA_FCS_ITNIM_SM_INITIATOR);
+				return;
+			}
+
+			itnim->stats.prli_rsp_parse_err++;
+			return;
+		}
+		itnim->rport->scsi_function = BFA_RPORT_TARGET;
+
+		sparams = &prli_resp->parampage.servparams;
+		itnim->seq_rec = sparams->retry;
+		itnim->rec_support = sparams->rec_support;
+		itnim->task_retry_id = sparams->task_retry_id;
+		itnim->conf_comp = sparams->confirm;
+
+		itnim->stats.prli_rsp_acc++;
+		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_RSP_OK);
+	} else {
+		ls_rjt = (struct fc_ls_rjt_s *) BFA_FCXP_RSP_PLD(fcxp);
+
+		bfa_trc(itnim->fcs, ls_rjt->reason_code);
+		bfa_trc(itnim->fcs, ls_rjt->reason_code_expl);
+
+		itnim->stats.prli_rsp_rjt++;
+		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_RSP_ERROR);
+	}
+}
+
+static void
+bfa_fcs_itnim_timeout(void *arg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)arg;
+
+	itnim->stats.timeout++;
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_TIMEOUT);
+}
+
+static void
+bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim)
+{
+	bfa_itnim_delete(itnim->bfa_itnim);
+	bfa_fcb_itnim_free(itnim->fcs->bfad, itnim->itnim_drv);
+}
+
+
+
+/**
+ *  itnim_public FCS ITNIM public interfaces
+ */
+
+/**
+ * 	Called by rport when a new rport is created.
+ *
+ * @param[in] rport	-  remote port.
+ */
+struct bfa_fcs_itnim_s *
+bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
+{
+	struct bfa_fcs_port_s *port = rport->port;
+	struct bfa_fcs_itnim_s *itnim;
+	struct bfad_itnim_s *itnim_drv;
+	struct bfa_itnim_s *bfa_itnim;
+
+	/*
+	 * call bfad to allocate the itnim
+	 */
+	bfa_fcb_itnim_alloc(port->fcs->bfad, &itnim, &itnim_drv);
+	if (itnim == NULL) {
+		bfa_trc(port->fcs, rport->pwwn);
+		return NULL;
+	}
+
+	/*
+	 * Initialize itnim
+	 */
+	itnim->rport = rport;
+	itnim->fcs = rport->fcs;
+	itnim->itnim_drv = itnim_drv;
+
+	/*
+	 * call BFA to create the itnim
+	 */
+	bfa_itnim = bfa_itnim_create(port->fcs->bfa, rport->bfa_rport, itnim);
+
+	if (bfa_itnim == NULL) {
+		bfa_trc(port->fcs, rport->pwwn);
+		bfa_fcb_itnim_free(port->fcs->bfad, itnim_drv);
+		bfa_assert(0);
+		return NULL;
+	}
+
+	itnim->bfa_itnim = bfa_itnim;
+	itnim->seq_rec = BFA_FALSE;
+	itnim->rec_support = BFA_FALSE;
+	itnim->conf_comp = BFA_FALSE;
+	itnim->task_retry_id = BFA_FALSE;
+
+	/*
+	 * Set State machine
+	 */
+	bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
+
+	return itnim;
+}
+
+/**
+ * 	Called by rport to delete  the instance of FCPIM.
+ *
+ * @param[in] rport	-  remote port.
+ */
+void
+bfa_fcs_itnim_delete(struct bfa_fcs_itnim_s *itnim)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pid);
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_DELETE);
+}
+
+/**
+ * Notification from rport that PLOGI is complete to initiate FC-4 session.
+ */
+void
+bfa_fcs_itnim_rport_online(struct bfa_fcs_itnim_s *itnim)
+{
+	itnim->stats.onlines++;
+
+	if (!BFA_FCS_PID_IS_WKA(itnim->rport->pid)) {
+		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_ONLINE);
+	} else {
+		/*
+		 * For well known addresses, we set the itnim to initiator
+		 * state
+		 */
+		itnim->stats.initiator++;
+		bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_INITIATOR);
+	}
+}
+
+/**
+ * Called by rport to handle a remote device offline.
+ */
+void
+bfa_fcs_itnim_rport_offline(struct bfa_fcs_itnim_s *itnim)
+{
+	itnim->stats.offlines++;
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_OFFLINE);
+}
+
+/**
+ * Called by rport when remote port is known to be an initiator from
+ * PRLI received.
+ */
+void
+bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pid);
+	itnim->stats.initiator++;
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_INITIATOR);
+}
+
+/**
+ * Called by rport to check if the itnim is online.
+ */
+bfa_status_t
+bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim)
+{
+	bfa_trc(itnim->fcs, itnim->rport->pid);
+	switch (bfa_sm_to_state(itnim_sm_table, itnim->sm)) {
+	case BFA_ITNIM_ONLINE:
+	case BFA_ITNIM_INITIATIOR:
+		return BFA_STATUS_OK;
+
+	default:
+		return BFA_STATUS_NO_FCPIM_NEXUS;
+
+	}
+}
+
+/**
+ * BFA completion callback for bfa_itnim_online().
+ */
+void
+bfa_cb_itnim_online(void *cbarg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cbarg;
+
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_ONLINE);
+}
+
+/**
+ * BFA completion callback for bfa_itnim_offline().
+ */
+void
+bfa_cb_itnim_offline(void *cb_arg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_OFFLINE);
+}
+
+/**
+ * Mark the beginning of PATH TOV handling. IO completion callbacks
+ * are still pending.
+ */
+void
+bfa_cb_itnim_tov_begin(void *cb_arg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_fcb_itnim_tov_begin(itnim->itnim_drv);
+}
+
+/**
+ * Mark the end of PATH TOV handling. All pending IOs are already cleaned up.
+ */
+void
+bfa_cb_itnim_tov(void *cb_arg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_fcb_itnim_tov(itnim->itnim_drv);
+}
+
+/**
+ * 		BFA notification to FCS/driver for second level error recovery.
+ *
+ * Atleast one I/O request has timedout and target is unresponsive to
+ * repeated abort requests. Second level error recovery should be initiated
+ * by starting implicit logout and recovery procedures.
+ */
+void
+bfa_cb_itnim_sler(void *cb_arg)
+{
+	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
+
+	itnim->stats.sler++;
+	bfa_trc(itnim->fcs, itnim->rport->pwwn);
+	bfa_fcs_rport_logo_imp(itnim->rport);
+}
+
+struct bfa_fcs_itnim_s *
+bfa_fcs_itnim_lookup(struct bfa_fcs_port_s *port, wwn_t rpwwn)
+{
+	struct bfa_fcs_rport_s *rport;
+	rport = bfa_fcs_rport_lookup(port, rpwwn);
+
+	if (!rport)
+		return NULL;
+
+	bfa_assert(rport->itnim != NULL);
+	return (rport->itnim);
+}
+
+bfa_status_t
+bfa_fcs_itnim_attr_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+		       struct bfa_itnim_attr_s *attr)
+{
+	struct bfa_fcs_itnim_s *itnim = NULL;
+
+	itnim = bfa_fcs_itnim_lookup(port, rpwwn);
+
+	if (itnim == NULL)
+		return BFA_STATUS_NO_FCPIM_NEXUS;
+
+	attr->state = bfa_sm_to_state(itnim_sm_table, itnim->sm);
+	attr->retry = itnim->seq_rec;
+	attr->rec_support = itnim->rec_support;
+	attr->conf_comp = itnim->conf_comp;
+	attr->task_retry_id = itnim->task_retry_id;
+
+	return BFA_STATUS_OK;
+}
+
+bfa_status_t
+bfa_fcs_itnim_stats_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+			struct bfa_itnim_stats_s *stats)
+{
+	struct bfa_fcs_itnim_s *itnim = NULL;
+
+	bfa_assert(port != NULL);
+
+	itnim = bfa_fcs_itnim_lookup(port, rpwwn);
+
+	if (itnim == NULL)
+		return BFA_STATUS_NO_FCPIM_NEXUS;
+
+	bfa_os_memcpy(stats, &itnim->stats, sizeof(struct bfa_itnim_stats_s));
+
+	return BFA_STATUS_OK;
+}
+
+bfa_status_t
+bfa_fcs_itnim_stats_clear(struct bfa_fcs_port_s *port, wwn_t rpwwn)
+{
+	struct bfa_fcs_itnim_s *itnim = NULL;
+
+	bfa_assert(port != NULL);
+
+	itnim = bfa_fcs_itnim_lookup(port, rpwwn);
+
+	if (itnim == NULL)
+		return BFA_STATUS_NO_FCPIM_NEXUS;
+
+	bfa_os_memset(&itnim->stats, 0, sizeof(struct bfa_itnim_stats_s));
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
+		      u16 len)
+{
+	struct fc_els_cmd_s   *els_cmd;
+
+	bfa_trc(itnim->fcs, fchs->type);
+
+	if (fchs->type != FC_TYPE_ELS)
+		return;
+
+	els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
+
+	bfa_trc(itnim->fcs, els_cmd->els_code);
+
+	switch (els_cmd->els_code) {
+	case FC_ELS_PRLO:
+		/* bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_PRLO); */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+void
+bfa_fcs_itnim_pause(struct bfa_fcs_itnim_s *itnim)
+{
+}
+
+void
+bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim)
+{
+}
+
+/**
+ *   Module initialization
+ */
+void
+bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs)
+{
+}
+
+/**
+ *   Module cleanup
+ */
+void
+bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs)
+{
+	bfa_fcs_modexit_comp(fcs);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/fcptm.c patch/drivers/scsi/bfa/fcptm.c
--- orig/drivers/scsi/bfa/fcptm.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcptm.c	2009-07-21 15:34:03.000000000 -0700
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
+ * This file contains dummy FCPTM routines to aid in Initiator Mode only
+ * compilation of OS driver.
+ *
+ */
+
+#include "bfa_os_inc.h"
+#include "fcs_rport.h"
+#include "fcs_fcptm.h"
+#include "fcs/bfa_fcs_rport.h"
+
+struct bfa_fcs_tin_s *
+bfa_fcs_tin_create(struct bfa_fcs_rport_s *rport)
+{
+	return NULL;
+}
+
+void
+bfa_fcs_tin_delete(struct bfa_fcs_tin_s *tin)
+{
+}
+
+void
+bfa_fcs_tin_rport_offline(struct bfa_fcs_tin_s *tin)
+{
+}
+
+void
+bfa_fcs_tin_rport_online(struct bfa_fcs_tin_s *tin)
+{
+}
+
+void
+bfa_fcs_tin_rx_prli(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs, u16 len)
+{
+}
+
+void
+bfa_fcs_fcptm_uf_recv(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs, u16 len)
+{
+}
+
+void
+bfa_fcs_tin_pause(struct bfa_fcs_tin_s *tin)
+{
+}
+
+void
+bfa_fcs_tin_resume(struct bfa_fcs_tin_s *tin)
+{
+}
diff -urpN orig/drivers/scsi/bfa/fcs.h patch/drivers/scsi/bfa/fcs.h
--- orig/drivers/scsi/bfa/fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,30 @@
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
+ *  fcs.h FCS module functions
+ */
+
+
+#ifndef __FCS_H__
+#define __FCS_H__
+
+#define __fcs_min_cfg(__fcs)       (__fcs)->min_cfg
+
+void bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs);
+
+#endif /* __FCS_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_auth.h patch/drivers/scsi/bfa/fcs_auth.h
--- orig/drivers/scsi/bfa/fcs_auth.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_auth.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,37 @@
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
+ *  fcs_uf.h FCS unsolicited frame receive
+ */
+
+
+#ifndef __FCS_AUTH_H__
+#define __FCS_AUTH_H__
+
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_vport.h>
+#include <fcs/bfa_fcs_lport.h>
+
+/*
+ * fcs friend functions: only between fcs modules
+ */
+void bfa_fcs_auth_uf_recv(struct bfa_fcs_fabric_s *fabric, int len);
+void bfa_fcs_auth_start(struct bfa_fcs_fabric_s *fabric);
+void bfa_fcs_auth_stop(struct bfa_fcs_fabric_s *fabric);
+
+#endif /* __FCS_UF_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_fabric.h patch/drivers/scsi/bfa/fcs_fabric.h
--- orig/drivers/scsi/bfa/fcs_fabric.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_fabric.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,61 @@
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
+ *  fcs_lport.h FCS logical port interfaces
+ */
+
+#ifndef __FCS_FABRIC_H__
+#define __FCS_FABRIC_H__
+
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_vport.h>
+#include <fcs/bfa_fcs_lport.h>
+
+/*
+* fcs friend functions: only between fcs modules
+ */
+void            bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
+void            bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
+void            bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
+					struct bfa_fcs_vport_s *vport);
+void            bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
+					struct bfa_fcs_vport_s *vport);
+int             bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric);
+struct bfa_fcs_vport_s *bfa_fcs_fabric_vport_lookup(
+			struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
+void            bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
+void            bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
+			struct fchs_s *fchs, u16 len);
+u16        bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
+bfa_boolean_t   bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric);
+enum bfa_pport_type bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric);
+void     	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
+void bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
+
+bfa_status_t bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf,
+			struct bfa_fcs_s *fcs, struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vf_s *vf_drv);
+void bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric,
+			enum auth_status status);
+
+void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
+			wwn_t fabric_name);
+#endif /* __FCS_FABRIC_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_fcpim.h patch/drivers/scsi/bfa/fcs_fcpim.h
--- orig/drivers/scsi/bfa/fcs_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_fcpim.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,44 @@
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
+#ifndef __FCS_FCPIM_H__
+#define __FCS_FCPIM_H__
+
+#include <defs/bfa_defs_port.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_rport.h>
+
+/*
+ * Following routines are from FCPIM and will be called by rport.
+ */
+struct bfa_fcs_itnim_s *bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_itnim_delete(struct bfa_fcs_itnim_s *itnim);
+void bfa_fcs_itnim_rport_offline(struct bfa_fcs_itnim_s *itnim);
+void bfa_fcs_itnim_rport_online(struct bfa_fcs_itnim_s *itnim);
+bfa_status_t bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim);
+
+void bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim);
+void bfa_fcs_itnim_pause(struct bfa_fcs_itnim_s *itnim);
+void bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim);
+
+/*
+ * Modudle init/cleanup routines.
+ */
+void bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
+			u16 len);
+#endif /* __FCS_FCPIM_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_fcptm.h patch/drivers/scsi/bfa/fcs_fcptm.h
--- orig/drivers/scsi/bfa/fcs_fcptm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_fcptm.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,45 @@
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
+#ifndef __FCS_FCPTM_H__
+#define __FCS_FCPTM_H__
+
+#include <defs/bfa_defs_port.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_rport.h>
+
+/*
+ * Following routines are from FCPTM and will be called by rport.
+ */
+struct bfa_fcs_tin_s *bfa_fcs_tin_create(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_tin_rport_offline(struct bfa_fcs_tin_s *tin);
+void bfa_fcs_tin_rport_online(struct bfa_fcs_tin_s *tin);
+void bfa_fcs_tin_delete(struct bfa_fcs_tin_s *tin);
+void bfa_fcs_tin_rx_prli(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
+			u16 len);
+void bfa_fcs_tin_pause(struct bfa_fcs_tin_s *tin);
+void bfa_fcs_tin_resume(struct bfa_fcs_tin_s *tin);
+
+/*
+ * Modudle init/cleanup routines.
+ */
+void bfa_fcs_fcptm_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fcptm_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_fcptm_uf_recv(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
+			u16 len);
+
+#endif /* __FCS_FCPTM_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_fcxp.h patch/drivers/scsi/bfa/fcs_fcxp.h
--- orig/drivers/scsi/bfa/fcs_fcxp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_fcxp.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,29 @@
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
+ *  fcs_fcxp.h FCXP helper macros for FCS
+ */
+
+
+#ifndef __FCS_FCXP_H__
+#define __FCS_FCXP_H__
+
+#define bfa_fcs_fcxp_alloc(__fcs)	\
+	bfa_fcxp_alloc(NULL, (__fcs)->bfa, 0, 0, NULL, NULL, NULL, NULL)
+
+#endif /* __FCS_FCXP_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_lport.h patch/drivers/scsi/bfa/fcs_lport.h
--- orig/drivers/scsi/bfa/fcs_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_lport.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,117 @@
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
+ *  fcs_lport.h FCS logical port interfaces
+ */
+
+#ifndef __FCS_LPORT_H__
+#define __FCS_LPORT_H__
+
+#define __VPORT_H__
+#include <defs/bfa_defs_port.h>
+#include <bfa_svc.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_rport.h>
+#include <fcs/bfa_fcs_vport.h>
+#include <fcs_fabric.h>
+#include <fcs_ms.h>
+#include <cs/bfa_q.h>
+#include <fcbuild.h>
+
+/*
+ * PID used in P2P/N2N ( In Big Endian)
+ */
+#define N2N_LOCAL_PID	    0x010000
+#define N2N_REMOTE_PID		0x020000
+
+/*
+ * Misc Timeouts
+ */
+/*
+ * To be used when spawning a timer before retrying a failed command. Milli
+ * Secs.
+ */
+#define	BFA_FCS_RETRY_TIMEOUT 2000
+
+/*
+ * Check for Port/Vport Mode/Role
+ */
+#define	BFA_FCS_VPORT_IS_INITIATOR_MODE(port) \
+		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_IM)
+
+#define	BFA_FCS_VPORT_IS_TARGET_MODE(port) \
+		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_TM)
+
+#define	BFA_FCS_VPORT_IS_IPFC_MODE(port) \
+		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_IPFC)
+
+/*
+ * Is this a Well Known Address
+ */
+#define BFA_FCS_PID_IS_WKA(pid)  ((bfa_os_ntoh3b(pid) > 0xFFF000) ?  1 : 0)
+
+/*
+ * Pointer to elements within Port
+ */
+#define BFA_FCS_GET_HAL_FROM_PORT(port)  (port->fcs->bfa)
+#define BFA_FCS_GET_NS_FROM_PORT(port)  (&port->port_topo.pfab.ns)
+#define BFA_FCS_GET_SCN_FROM_PORT(port)  (&port->port_topo.pfab.scn)
+#define BFA_FCS_GET_MS_FROM_PORT(port)  (&port->port_topo.pfab.ms)
+#define BFA_FCS_GET_FDMI_FROM_PORT(port)  (&port->port_topo.pfab.ms.fdmi)
+
+/*
+ * handler for unsolicied frames
+ */
+void bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
+			u16 len);
+
+/*
+ * Following routines will be called by Fabric to indicate port
+ * online/offline to vport.
+ */
+void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
+			u16 vf_id, struct bfa_port_cfg_s *port_cfg,
+			struct bfa_fcs_vport_s *vport);
+void bfa_fcs_port_online(struct bfa_fcs_port_s *port);
+void bfa_fcs_port_offline(struct bfa_fcs_port_s *port);
+void bfa_fcs_port_delete(struct bfa_fcs_port_s *port);
+bfa_boolean_t   bfa_fcs_port_is_online(struct bfa_fcs_port_s *port);
+
+/*
+ * Lookup rport based on PID
+ */
+struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pid(
+			struct bfa_fcs_port_s *port, u32 pid);
+
+/*
+ * Lookup rport based on PWWN
+ */
+struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pwwn(
+			struct bfa_fcs_port_s *port, wwn_t pwwn);
+struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_nwwn(
+			struct bfa_fcs_port_s *port, wwn_t nwwn);
+void bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
+			struct bfa_fcs_rport_s *rport);
+void bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
+			struct bfa_fcs_rport_s *rport);
+
+void bfa_fcs_port_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_port_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_port_lip(struct bfa_fcs_port_s *port);
+
+#endif /* __FCS_LPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_ms.h patch/drivers/scsi/bfa/fcs_ms.h
--- orig/drivers/scsi/bfa/fcs_ms.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_ms.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,35 @@
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
+ *  fcs_ms.h FCS ms interfaces
+ */
+#ifndef __FCS_MS_H__
+#define __FCS_MS_H__
+
+/* MS FCS routines */
+void bfa_fcs_port_ms_init(struct bfa_fcs_port_s *port);
+void bfa_fcs_port_ms_offline(struct bfa_fcs_port_s *port);
+void bfa_fcs_port_ms_online(struct bfa_fcs_port_s *port);
+void bfa_fcs_port_ms_fabric_rscn(struct bfa_fcs_port_s *port);
+
+/* FDMI FCS routines */
+void bfa_fcs_port_fdmi_init(struct bfa_fcs_port_ms_s *ms);
+void bfa_fcs_port_fdmi_offline(struct bfa_fcs_port_ms_s *ms);
+void bfa_fcs_port_fdmi_online(struct bfa_fcs_port_ms_s *ms);
+
+#endif
diff -urpN orig/drivers/scsi/bfa/fcs_port.h patch/drivers/scsi/bfa/fcs_port.h
--- orig/drivers/scsi/bfa/fcs_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_port.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,32 @@
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
+ *  fcs_pport.h FCS physical port interfaces
+ */
+
+
+#ifndef __FCS_PPORT_H__
+#define __FCS_PPORT_H__
+
+/*
+ * fcs friend functions: only between fcs modules
+ */
+void bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs);
+
+#endif /* __FCS_PPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_rport.h patch/drivers/scsi/bfa/fcs_rport.h
--- orig/drivers/scsi/bfa/fcs_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_rport.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,61 @@
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
+ *  fcs_rport.h FCS rport interfaces and defines
+ */
+
+#ifndef __FCS_RPORT_H__
+#define __FCS_RPORT_H__
+
+#include <fcs/bfa_fcs_rport.h>
+
+void bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs);
+
+void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
+			u16 len);
+void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
+
+struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_port_s *port,
+			u32 pid);
+void bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_start(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
+			struct fc_logi_s *plogi_rsp);
+void bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port,
+			struct fchs_s *rx_fchs,
+			struct fc_logi_s *plogi);
+void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
+			struct fc_logi_s *plogi);
+void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_fcptm_offline_done(struct bfa_fcs_rport_s *rport);
+int  bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport);
+struct bfa_fcs_rport_s *bfa_fcs_rport_create_by_wwn(struct bfa_fcs_port_s *port,
+			wwn_t wwn);
+
+
+/* Rport Features */
+void  bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport);
+void  bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport);
+void  bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport);
+
+#endif /* __FCS_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_trcmod.h patch/drivers/scsi/bfa/fcs_trcmod.h
--- orig/drivers/scsi/bfa/fcs_trcmod.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_trcmod.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,56 @@
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
+ *  fcs_trcmod.h BFA FCS trace modules
+ */
+
+#ifndef __FCS_TRCMOD_H__
+#define __FCS_TRCMOD_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_FCS_FABRIC		= 1,
+	BFA_TRC_FCS_VFAPI		= 2,
+	BFA_TRC_FCS_PORT		= 3,
+	BFA_TRC_FCS_VPORT		= 4,
+	BFA_TRC_FCS_VP_API		= 5,
+	BFA_TRC_FCS_VPS			= 6,
+	BFA_TRC_FCS_RPORT		= 7,
+	BFA_TRC_FCS_FCPIM		= 8,
+	BFA_TRC_FCS_FCPTM		= 9,
+	BFA_TRC_FCS_NS			= 10,
+	BFA_TRC_FCS_SCN			= 11,
+	BFA_TRC_FCS_LOOP		= 12,
+	BFA_TRC_FCS_UF			= 13,
+	BFA_TRC_FCS_PPORT		= 14,
+	BFA_TRC_FCS_FCPIP		= 15,
+	BFA_TRC_FCS_PORT_API	= 16,
+	BFA_TRC_FCS_RPORT_API	= 17,
+	BFA_TRC_FCS_AUTH		= 18,
+	BFA_TRC_FCS_N2N			= 19,
+	BFA_TRC_FCS_MS			= 20,
+	BFA_TRC_FCS_FDMI		= 21,
+	BFA_TRC_FCS_RPORT_FTRS	= 22,
+};
+
+#endif /* __FCS_TRCMOD_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_uf.h patch/drivers/scsi/bfa/fcs_uf.h
--- orig/drivers/scsi/bfa/fcs_uf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_uf.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,32 @@
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
+ *  fcs_uf.h FCS unsolicited frame receive
+ */
+
+
+#ifndef __FCS_UF_H__
+#define __FCS_UF_H__
+
+/*
+ * fcs friend functions: only between fcs modules
+ */
+void bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs);
+
+#endif /* __FCS_UF_H__ */
diff -urpN orig/drivers/scsi/bfa/fcs_vport.h patch/drivers/scsi/bfa/fcs_vport.h
--- orig/drivers/scsi/bfa/fcs_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcs_vport.h	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,39 @@
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
+#ifndef __FCS_VPORT_H__
+#define __FCS_VPORT_H__
+
+#include <fcs/bfa_fcs_lport.h>
+#include <fcs/bfa_fcs_vport.h>
+#include <defs/bfa_defs_pci.h>
+
+/*
+ * Modudle init/cleanup routines.
+ */
+
+void bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs);
+void bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs);
+
+void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
+u32 bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs);
+
+#endif /* __FCS_VPORT_H__ */
+
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
diff -urpN orig/drivers/scsi/bfa/plog.c patch/drivers/scsi/bfa/plog.c
--- orig/drivers/scsi/bfa/plog.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/plog.c	2009-07-21 15:34:03.000000000 -0700
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
diff -urpN orig/drivers/scsi/bfa/rport.c patch/drivers/scsi/bfa/rport.c
--- orig/drivers/scsi/bfa/rport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,2620 @@
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
+		bfa_fcb_rport_free(fcs->bfad, &rport_drv);
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
+			bfa_fcb_rport_free(fcs->bfad, &rport_drv);
+			return NULL;
+		}
+	}
+
+	if (bfa_fcs_port_is_target(port)) {
+		rport->tin = bfa_fcs_tin_create(rport);
+		if (!rport->tin) {
+			bfa_trc(fcs, rpid);
+			bfa_rport_delete(rport->bfa_rport);
+			bfa_fcb_rport_free(fcs->bfad, &rport_drv);
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
+	bfa_fcb_rport_free(rport->fcs->bfad, &rport->rp_drv);
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
+	char            lpwwn_buf[BFA_STRING_32];
+	char            rpwwn_buf[BFA_STRING_32];
+	char           *lpwwn_ptr;
+	char           *rpwwn_ptr;
+	char           *prio_str[] = { "unknown", "high", "medium", "low" };
+
+	lpwwn_ptr = wwn2str(lpwwn_buf, sizeof(lpwwn_buf), lpwwn);
+	rpwwn_ptr = wwn2str(rpwwn_buf, sizeof(rpwwn_buf), rpwwn);
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
+++ patch/drivers/scsi/bfa/rport_api.c	2009-07-21 15:34:03.000000000 -0700
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
diff -urpN orig/drivers/scsi/bfa/rport_ftrs.c patch/drivers/scsi/bfa/rport_ftrs.c
--- orig/drivers/scsi/bfa/rport_ftrs.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/rport_ftrs.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,375 @@
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
+++ patch/drivers/scsi/bfa/scn.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,482 @@
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
+++ patch/drivers/scsi/bfa/vfapi.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,292 @@
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
+++ patch/drivers/scsi/bfa/vport.c	2009-07-21 15:34:03.000000000 -0700
@@ -0,0 +1,892 @@
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
