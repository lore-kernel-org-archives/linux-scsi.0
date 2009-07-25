From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 7/14] bfa: Brocade BFA FC SCSI driver (fcs part-2)
Date: Fri, 24 Jul 2009 22:59:41 -0700
Message-ID: <200907250559.n6P5xflw024071@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:5400 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZGYF7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2009 01:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-2

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 fcbuild.c    | 1449 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fcbuild.h    |  273 +++++++++++
 fcpim.c      |  846 ++++++++++++++++++++++++++++++++++
 fcptm.c      |   68 ++
 fcs.h        |   30 +
 fcs_auth.h   |   37 +
 fcs_fabric.h |   61 ++
 fcs_fcpim.h  |   44 +
 fcs_fcptm.h  |   45 +
 fcs_fcxp.h   |   29 +
 fcs_lport.h  |  117 ++++
 fcs_ms.h     |   35 +
 fcs_port.h   |   32 +
 fcs_rport.h  |   61 ++
 fcs_trcmod.h |   56 ++
 fcs_uf.h     |   32 +
 fcs_vport.h  |   39 +
 17 files changed, 3254 insertions(+)

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
