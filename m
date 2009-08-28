From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 7/14] bfa: Brocade BFA FC SCSI driver (fcs part2)
Date: Fri, 28 Aug 2009 01:09:53 -0700
Message-ID: <200908280809.n7S89rWf001543@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:28430 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZH1IJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 04:09:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains and FC state machine code. part-2

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 fcbuild.h    |  273 +++++++++++++
 fcpim.c      |  844 ++++++++++++++++++++++++++++++++++++++++
 fcptm.c      |   68 +++
 fcs.h        |   30 +
 fcs_auth.h   |   37 +
 fcs_fabric.h |   61 ++
 fcs_fcpim.h  |   44 ++
 fcs_fcptm.h  |   45 ++
 fcs_fcxp.h   |   29 +
 fcs_lport.h  |  117 +++++
 fcs_ms.h     |   35 +
 fcs_port.h   |   32 +
 fcs_rport.h  |   61 ++
 fcs_trcmod.h |   56 ++
 fcs_uf.h     |   32 +
 fcs_vport.h  |   39 +
 fdmi.c       | 1223 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 loop.c       |  422 ++++++++++++++++++++
 lport_api.c  |  291 ++++++++++++++
 lport_priv.h |   82 +++
 20 files changed, 3821 insertions(+)

diff -urpN orig/drivers/scsi/bfa/fcbuild.h patch/drivers/scsi/bfa/fcbuild.h
--- orig/drivers/scsi/bfa/fcbuild.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/fcbuild.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,273 @@
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
+++ patch/drivers/scsi/bfa/fcpim.c	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,844 @@
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
+	char            lpwwn_ptr[BFA_STRING_32];
+	char            rpwwn_ptr[BFA_STRING_32];
+
+	/*
+	 * Don't post events for well known addresses
+	 */
+	if (BFA_FCS_PID_IS_WKA(rport->pid))
+		return;
+
+	wwn2str(lpwwn_ptr, lpwwn);
+	wwn2str(rpwwn_ptr, rpwwn);
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
+++ patch/drivers/scsi/bfa/fcptm.c	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,68 @@
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
+++ patch/drivers/scsi/bfa/fcs.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,30 @@
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
+++ patch/drivers/scsi/bfa/fcs_auth.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,37 @@
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
+++ patch/drivers/scsi/bfa/fcs_fabric.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,61 @@
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
+++ patch/drivers/scsi/bfa/fcs_fcpim.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,44 @@
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
+++ patch/drivers/scsi/bfa/fcs_fcptm.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,45 @@
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
+++ patch/drivers/scsi/bfa/fcs_fcxp.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,29 @@
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
+++ patch/drivers/scsi/bfa/fcs_lport.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,117 @@
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
+++ patch/drivers/scsi/bfa/fcs_ms.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,35 @@
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
+++ patch/drivers/scsi/bfa/fcs_port.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,32 @@
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
+++ patch/drivers/scsi/bfa/fcs_rport.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,61 @@
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
+++ patch/drivers/scsi/bfa/fcs_trcmod.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,56 @@
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
+++ patch/drivers/scsi/bfa/fcs_uf.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,32 @@
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
+++ patch/drivers/scsi/bfa/fcs_vport.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,39 @@
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
+++ patch/drivers/scsi/bfa/fdmi.c	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,1223 @@
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
+++ patch/drivers/scsi/bfa/loop.c	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,422 @@
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
+++ patch/drivers/scsi/bfa/lport_api.c	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,291 @@
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
+++ patch/drivers/scsi/bfa/lport_priv.h	2009-08-27 19:41:57.000000000 -0700
@@ -0,0 +1,82 @@
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
