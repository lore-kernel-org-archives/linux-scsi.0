From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/4] bfa: fixed checkpatch errors for fcs files
Date: Fri, 25 Sep 2009 12:31:01 -0700
Message-ID: <200909251931.n8PJV1i4012504@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:58281 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZIYTa6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 15:30:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch fixes checkpatch errors/warnings in fcs files.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 fabric.c     |   18 ++--
 fcbuild.c    |  190 ++++++++++++++++++++++++------------------------
 fcbuild.h    |    6 -
 fcpim.c      |    7 -
 fcs.h        |    2 
 fdmi.c       |    8 +-
 loop.c       |  231 ++---------------------------------------------------------
 lport_api.c  |   15 +--
 ns.c         |    5 -
 plog.c       |    2 
 rport_ftrs.c |   28 +++----
 vfapi.c      |    2 
 vport.c      |   20 ++---
 13 files changed, 160 insertions(+), 374 deletions(-)

diff -urpN orig/drivers/scsi/bfa/fabric.c patch/drivers/scsi/bfa/fabric.c
--- orig/drivers/scsi/bfa/fabric.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fabric.c	2009-09-24 23:41:15.000000000 -0700
@@ -36,12 +36,12 @@ BFA_TRC_FILE(FCS, FABRIC);
 #define BFA_FCS_FABRIC_RETRY_DELAY	(2000)	/* Milliseconds */
 #define BFA_FCS_FABRIC_CLEANUP_DELAY	(10000)	/* Milliseconds */
 
-#define bfa_fcs_fabric_set_opertype(__fabric) do {          \
-    if (bfa_pport_get_topology((__fabric)->fcs->bfa)    \
-				== BFA_PPORT_TOPOLOGY_P2P)   \
-	    (__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;       \
-    else                                                    \
-	    (__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT;      \
+#define bfa_fcs_fabric_set_opertype(__fabric) do {             \
+	if (bfa_pport_get_topology((__fabric)->fcs->bfa)       \
+				== BFA_PPORT_TOPOLOGY_P2P)     \
+		(__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;  \
+	else                                                   \
+		(__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT; \
 } while (0)
 
 /*
@@ -887,7 +887,7 @@ bfa_fcs_fabric_modsusp(struct bfa_fcs_s 
 bfa_boolean_t
 bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric)
 {
-	return (bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_loopback));
+	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_loopback);
 }
 
 enum bfa_pport_type
@@ -974,7 +974,7 @@ bfa_fcs_fabric_port_delete_comp(struct b
 int
 bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
 {
-	return (bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online));
+	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online);
 }
 
 
@@ -1015,7 +1015,7 @@ bfa_fcs_fabric_vport_lookup(struct bfa_f
 u16
 bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
 {
-	return (fabric->num_vports);
+	return fabric->num_vports;
 }
 
 /**
diff -urpN orig/drivers/scsi/bfa/fcbuild.c patch/drivers/scsi/bfa/fcbuild.c
--- orig/drivers/scsi/bfa/fcbuild.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fcbuild.c	2009-09-24 23:41:15.000000000 -0700
@@ -188,14 +188,14 @@ fc_els_rsp_parse(struct fchs_s *fchs, in
 	switch (els_cmd->els_code) {
 	case FC_ELS_LS_RJT:
 		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return (FC_PARSE_BUSY);
+			return FC_PARSE_BUSY;
 		else
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 
 	case FC_ELS_ACC:
-		return (FC_PARSE_OK);
+		return FC_PARSE_OK;
 	}
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 static void
@@ -228,7 +228,7 @@ fc_plogi_x_build(struct fchs_s *fchs, vo
 	bfa_os_memcpy(&plogi->port_name, &port_name, sizeof(wwn_t));
 	bfa_os_memcpy(&plogi->node_name, &node_name, sizeof(wwn_t));
 
-	return (sizeof(struct fc_logi_s));
+	return sizeof(struct fc_logi_s);
 }
 
 u16
@@ -267,7 +267,7 @@ fc_flogi_build(struct fchs_s *fchs, stru
 	flogi->csp.npiv_supp    = 1; /* @todo. field name is not correct */
 	vvl_info[0]	= bfa_os_htonl(FLOGI_VVL_BRCD);
 
-	return (sizeof(struct fc_logi_s));
+	return sizeof(struct fc_logi_s);
 }
 
 u16
@@ -287,7 +287,7 @@ fc_flogi_acc_build(struct fchs_s *fchs, 
 
 	flogi->csp.bbcred = bfa_os_htons(local_bb_credits);
 
-	return (sizeof(struct fc_logi_s));
+	return sizeof(struct fc_logi_s);
 }
 
 u16
@@ -306,7 +306,7 @@ fc_fdisc_build(struct fchs_s *fchs, stru
 	flogi->port_name = port_name;
 	flogi->node_name = node_name;
 
-	return (sizeof(struct fc_logi_s));
+	return sizeof(struct fc_logi_s);
 }
 
 u16
@@ -338,26 +338,26 @@ fc_plogi_rsp_parse(struct fchs_s *fchs, 
 	case FC_ELS_LS_RJT:
 		ls_rjt = (struct fc_ls_rjt_s *) (fchs + 1);
 		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return (FC_PARSE_BUSY);
+			return FC_PARSE_BUSY;
 		else
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 	case FC_ELS_ACC:
 		plogi = (struct fc_logi_s *) (fchs + 1);
 		if (len < sizeof(struct fc_logi_s))
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 
 		if (!wwn_is_equal(plogi->port_name, port_name))
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 
 		if (!plogi->class3.class_valid)
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 
 		if (bfa_os_ntohs(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
-			return (FC_PARSE_FAILURE);
+			return FC_PARSE_FAILURE;
 
-		return (FC_PARSE_OK);
+		return FC_PARSE_OK;
 	default:
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 	}
 }
 
@@ -372,7 +372,7 @@ fc_plogi_parse(struct fchs_s *fchs)
 	if ((bfa_os_ntohs(plogi->class3.rxsz) < FC_MIN_PDUSZ)
 	    || (bfa_os_ntohs(plogi->class3.rxsz) > FC_MAX_PDUSZ)
 	    || (plogi->class3.rxsz == 0))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	return FC_PARSE_OK;
 }
@@ -393,7 +393,7 @@ fc_prli_build(struct fchs_s *fchs, void 
 	prli->parampage.servparams.task_retry_id = 0;
 	prli->parampage.servparams.confirm       = 1;
 
-	return (sizeof(struct fc_prli_s));
+	return sizeof(struct fc_prli_s);
 }
 
 u16
@@ -414,41 +414,41 @@ fc_prli_acc_build(struct fchs_s *fchs, v
 
 	prli->parampage.rspcode = FC_PRLI_ACC_XQTD;
 
-	return (sizeof(struct fc_prli_s));
+	return sizeof(struct fc_prli_s);
 }
 
 enum fc_parse_status
 fc_prli_rsp_parse(struct fc_prli_s *prli, int len)
 {
 	if (len < sizeof(struct fc_prli_s))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (prli->command != FC_ELS_ACC)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if ((prli->parampage.rspcode != FC_PRLI_ACC_XQTD)
 	    && (prli->parampage.rspcode != FC_PRLI_ACC_PREDEF_IMG))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (prli->parampage.servparams.target != 1)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 enum fc_parse_status
 fc_prli_parse(struct fc_prli_s *prli)
 {
 	if (prli->parampage.type != FC_TYPE_FCP)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (!prli->parampage.imagepair)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (!prli->parampage.servparams.initiator)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 u16
@@ -462,7 +462,7 @@ fc_logo_build(struct fchs_s *fchs, struc
 	logo->nport_id = (s_id);
 	logo->orig_port_name = port_name;
 
-	return (sizeof(struct fc_logo_s));
+	return sizeof(struct fc_logo_s);
 }
 
 static          u16
@@ -484,7 +484,7 @@ fc_adisc_x_build(struct fchs_s *fchs, st
 	adisc->orig_node_name = node_name;
 	adisc->nport_id = (s_id);
 
-	return (sizeof(struct fc_adisc_s));
+	return sizeof(struct fc_adisc_s);
 }
 
 u16
@@ -511,15 +511,15 @@ fc_adisc_rsp_parse(struct fc_adisc_s *ad
 {
 
 	if (len < sizeof(struct fc_adisc_s))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (adisc->els_cmd.els_code != FC_ELS_ACC)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (!wwn_is_equal(adisc->orig_port_name, port_name))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 enum fc_parse_status
@@ -529,14 +529,14 @@ fc_adisc_parse(struct fchs_s *fchs, void
 	struct fc_adisc_s     *adisc = (struct fc_adisc_s *) pld;
 
 	if (adisc->els_cmd.els_code != FC_ELS_ACC)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if ((adisc->nport_id == (host_dap))
 	    && wwn_is_equal(adisc->orig_port_name, port_name)
 	    && wwn_is_equal(adisc->orig_node_name, node_name))
-		return (FC_PARSE_OK);
+		return FC_PARSE_OK;
 
-	return (FC_PARSE_FAILURE);
+	return FC_PARSE_FAILURE;
 }
 
 enum fc_parse_status
@@ -550,13 +550,13 @@ fc_pdisc_parse(struct fchs_s *fchs, wwn_
 	if ((bfa_os_ntohs(pdisc->class3.rxsz) <
 		 (FC_MIN_PDUSZ - sizeof(struct fchs_s)))
 	    || (pdisc->class3.rxsz == 0))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	if (!wwn_is_equal(pdisc->node_name, node_name))
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	return FC_PARSE_OK;
 }
@@ -570,7 +570,7 @@ fc_abts_build(struct fchs_s *fchs, u32 d
 	fchs->s_id = (s_id);
 	fchs->ox_id = bfa_os_htons(ox_id);
 
-	return (sizeof(struct fchs_s));
+	return sizeof(struct fchs_s);
 }
 
 enum fc_parse_status
@@ -578,9 +578,9 @@ fc_abts_rsp_parse(struct fchs_s *fchs, i
 {
 	if ((fchs->cat_info == FC_CAT_BA_ACC)
 	    || (fchs->cat_info == FC_CAT_BA_RJT))
-		return (FC_PARSE_OK);
+		return FC_PARSE_OK;
 
-	return (FC_PARSE_FAILURE);
+	return FC_PARSE_FAILURE;
 }
 
 u16
@@ -597,7 +597,7 @@ fc_rrq_build(struct fchs_s *fchs, struct
 	rrq->ox_id = bfa_os_htons(rrq_oxid);
 	rrq->rx_id = FC_RXID_ANY;
 
-	return (sizeof(struct fc_rrq_s));
+	return sizeof(struct fc_rrq_s);
 }
 
 u16
@@ -611,7 +611,7 @@ fc_logo_acc_build(struct fchs_s *fchs, v
 	memset(acc, 0, sizeof(struct fc_els_cmd_s));
 	acc->els_code = FC_ELS_ACC;
 
-	return (sizeof(struct fc_els_cmd_s));
+	return sizeof(struct fc_els_cmd_s);
 }
 
 u16
@@ -627,7 +627,7 @@ fc_ls_rjt_build(struct fchs_s *fchs, str
 	ls_rjt->reason_code_expl = reason_code_expl;
 	ls_rjt->vendor_unique = 0x00;
 
-	return (sizeof(struct fc_ls_rjt_s));
+	return sizeof(struct fc_ls_rjt_s);
 }
 
 u16
@@ -643,7 +643,7 @@ fc_ba_acc_build(struct fchs_s *fchs, str
 	ba_acc->ox_id = fchs->ox_id;
 	ba_acc->rx_id = fchs->rx_id;
 
-	return (sizeof(struct fc_ba_acc_s));
+	return sizeof(struct fc_ba_acc_s);
 }
 
 u16
@@ -654,7 +654,7 @@ fc_ls_acc_build(struct fchs_s *fchs, str
 	memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
 	els_cmd->els_code = FC_ELS_ACC;
 
-	return (sizeof(struct fc_els_cmd_s));
+	return sizeof(struct fc_els_cmd_s);
 }
 
 int
@@ -696,7 +696,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, 
 		tprlo_acc->tprlo_acc_params[page].orig_process_assc = 0;
 		tprlo_acc->tprlo_acc_params[page].resp_process_assc = 0;
 	}
-	return (bfa_os_ntohs(tprlo_acc->payload_len));
+	return bfa_os_ntohs(tprlo_acc->payload_len);
 }
 
 u16
@@ -721,7 +721,7 @@ fc_prlo_acc_build(struct fchs_s *fchs, s
 		prlo_acc->prlo_acc_params[page].resp_process_assc = 0;
 	}
 
-	return (bfa_os_ntohs(prlo_acc->payload_len));
+	return bfa_os_ntohs(prlo_acc->payload_len);
 }
 
 u16
@@ -735,7 +735,7 @@ fc_rnid_build(struct fchs_s *fchs, struc
 	rnid->els_cmd.els_code = FC_ELS_RNID;
 	rnid->node_id_data_format = data_format;
 
-	return (sizeof(struct fc_rnid_cmd_s));
+	return sizeof(struct fc_rnid_cmd_s);
 }
 
 u16
@@ -759,10 +759,10 @@ fc_rnid_acc_build(struct fchs_s *fchs, s
 		rnid_acc->specific_id_data_length =
 			sizeof(struct fc_rnid_general_topology_data_s);
 		bfa_os_assign(rnid_acc->gen_topology_data, *gen_topo_data);
-		return (sizeof(struct fc_rnid_acc_s));
+		return sizeof(struct fc_rnid_acc_s);
 	} else {
-		return (sizeof(struct fc_rnid_acc_s) -
-			sizeof(struct fc_rnid_general_topology_data_s));
+		return sizeof(struct fc_rnid_acc_s) -
+			sizeof(struct fc_rnid_general_topology_data_s);
 	}
 
 }
@@ -776,7 +776,7 @@ fc_rpsc_build(struct fchs_s *fchs, struc
 	memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
 
 	rpsc->els_cmd.els_code = FC_ELS_RPSC;
-	return (sizeof(struct fc_rpsc_cmd_s));
+	return sizeof(struct fc_rpsc_cmd_s);
 }
 
 u16
@@ -797,8 +797,8 @@ fc_rpsc2_build(struct fchs_s *fchs, stru
 	for (i = 0; i < npids; i++)
 		rpsc2->pid_list[i].pid = pid_list[i];
 
-	return (sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) *
-			(sizeof(u32))));
+	return sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) *
+			(sizeof(u32)));
 }
 
 u16
@@ -819,7 +819,7 @@ fc_rpsc_acc_build(struct fchs_s *fchs, s
 	rpsc_acc->speed_info[0].port_op_speed =
 		bfa_os_htons(oper_speed->port_op_speed);
 
-	return (sizeof(struct fc_rpsc_acc_s));
+	return sizeof(struct fc_rpsc_acc_s);
 
 }
 
@@ -856,7 +856,7 @@ fc_pdisc_build(struct fchs_s *fchs, u32 
 	pdisc->port_name = port_name;
 	pdisc->node_name = node_name;
 
-	return (sizeof(struct fc_logi_s));
+	return sizeof(struct fc_logi_s);
 }
 
 u16
@@ -865,21 +865,21 @@ fc_pdisc_rsp_parse(struct fchs_s *fchs, 
 	struct fc_logi_s     *pdisc = (struct fc_logi_s *) (fchs + 1);
 
 	if (len < sizeof(struct fc_logi_s))
-		return (FC_PARSE_LEN_INVAL);
+		return FC_PARSE_LEN_INVAL;
 
 	if (pdisc->els_cmd.els_code != FC_ELS_ACC)
-		return (FC_PARSE_ACC_INVAL);
+		return FC_PARSE_ACC_INVAL;
 
 	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return (FC_PARSE_PWWN_NOT_EQUAL);
+		return FC_PARSE_PWWN_NOT_EQUAL;
 
 	if (!pdisc->class3.class_valid)
-		return (FC_PARSE_NWWN_NOT_EQUAL);
+		return FC_PARSE_NWWN_NOT_EQUAL;
 
 	if (bfa_os_ntohs(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
-		return (FC_PARSE_RXSZ_INVAL);
+		return FC_PARSE_RXSZ_INVAL;
 
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 u16
@@ -903,7 +903,7 @@ fc_prlo_build(struct fchs_s *fchs, u32 d
 		prlo->prlo_params[page].resp_process_assc = 0;
 	}
 
-	return (bfa_os_ntohs(prlo->payload_len));
+	return bfa_os_ntohs(prlo->payload_len);
 }
 
 u16
@@ -916,7 +916,7 @@ fc_prlo_rsp_parse(struct fchs_s *fchs, i
 	len = len;
 
 	if (prlo->command != FC_ELS_ACC)
-		return (FC_PARSE_FAILURE);
+		return FC_PARSE_FAILURE;
 
 	num_pages = ((bfa_os_ntohs(prlo->payload_len)) - 4) / 16;
 
@@ -936,7 +936,7 @@ fc_prlo_rsp_parse(struct fchs_s *fchs, i
 		if (prlo->prlo_acc_params[page].resp_process_assc != 0)
 			return FC_PARSE_FAILURE;
 	}
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 
 }
 
@@ -968,7 +968,7 @@ fc_tprlo_build(struct fchs_s *fchs, u32 
 		}
 	}
 
-	return (bfa_os_ntohs(tprlo->payload_len));
+	return bfa_os_ntohs(tprlo->payload_len);
 }
 
 u16
@@ -981,23 +981,23 @@ fc_tprlo_rsp_parse(struct fchs_s *fchs, 
 	len = len;
 
 	if (tprlo->command != FC_ELS_ACC)
-		return (FC_PARSE_ACC_INVAL);
+		return FC_PARSE_ACC_INVAL;
 
 	num_pages = (bfa_os_ntohs(tprlo->payload_len) - 4) / 16;
 
 	for (page = 0; page < num_pages; page++) {
 		if (tprlo->tprlo_acc_params[page].type != FC_TYPE_FCP)
-			return (FC_PARSE_NOT_FCP);
+			return FC_PARSE_NOT_FCP;
 		if (tprlo->tprlo_acc_params[page].opa_valid != 0)
-			return (FC_PARSE_OPAFLAG_INVAL);
+			return FC_PARSE_OPAFLAG_INVAL;
 		if (tprlo->tprlo_acc_params[page].rpa_valid != 0)
-			return (FC_PARSE_RPAFLAG_INVAL);
+			return FC_PARSE_RPAFLAG_INVAL;
 		if (tprlo->tprlo_acc_params[page].orig_process_assc != 0)
-			return (FC_PARSE_OPA_INVAL);
+			return FC_PARSE_OPA_INVAL;
 		if (tprlo->tprlo_acc_params[page].resp_process_assc != 0)
-			return (FC_PARSE_RPA_INVAL);
+			return FC_PARSE_RPA_INVAL;
 	}
-	return (FC_PARSE_OK);
+	return FC_PARSE_OK;
 }
 
 enum fc_parse_status
@@ -1024,7 +1024,7 @@ fc_ba_rjt_build(struct fchs_s *fchs, u32
 	fchs->cat_info = FC_CAT_BA_RJT;
 	ba_rjt->reason_code = reason_code;
 	ba_rjt->reason_expl = reason_expl;
-	return (sizeof(struct fc_ba_rjt_s));
+	return sizeof(struct fc_ba_rjt_s);
 }
 
 static void
@@ -1073,7 +1073,7 @@ fc_gidpn_build(struct fchs_s *fchs, void
 
 	bfa_os_memset(gidpn, 0, sizeof(struct fcgs_gidpn_req_s));
 	gidpn->port_name = port_name;
-	return (sizeof(struct fcgs_gidpn_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_gidpn_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1090,7 +1090,7 @@ fc_gpnid_build(struct fchs_s *fchs, void
 
 	bfa_os_memset(gpnid, 0, sizeof(fcgs_gpnid_req_t));
 	gpnid->dap = port_id;
-	return (sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s));
+	return sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1107,7 +1107,7 @@ fc_gnnid_build(struct fchs_s *fchs, void
 
 	bfa_os_memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
 	gnnid->dap = port_id;
-	return (sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s));
+	return sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1137,7 +1137,7 @@ fc_scr_build(struct fchs_s *fchs, struct
 	if (set_br_reg)
 		scr->vu_reg_func = FC_VU_SCR_REG_FUNC_FABRIC_NAME_CHANGE;
 
-	return (sizeof(struct fc_scr_s));
+	return sizeof(struct fc_scr_s);
 }
 
 u16
@@ -1157,7 +1157,7 @@ fc_rscn_build(struct fchs_s *fchs, struc
 	rscn->event[0].format = FC_RSCN_FORMAT_PORTID;
 	rscn->event[0].portid = s_id;
 
-	return (sizeof(struct fc_rscn_pl_s));
+	return sizeof(struct fc_rscn_pl_s);
 }
 
 u16
@@ -1188,7 +1188,7 @@ fc_rftid_build(struct fchs_s *fchs, void
 		rftid->fc4_type[index] |= bfa_os_htonl(type_value);
 	}
 
-	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1210,7 +1210,7 @@ fc_rftid_build_sol(struct fchs_s *fchs, 
 	bfa_os_memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
 			(bitmap_size < 32 ? bitmap_size : 32));
 
-	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1231,7 +1231,7 @@ fc_rffid_build(struct fchs_s *fchs, void
 	rffid->fc4ftr_bits  = fc4_ftrs;
 	rffid->fc4_type		= fc4_type;
 
-	return (sizeof(struct fcgs_rffid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rffid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1253,7 +1253,7 @@ fc_rspnid_build(struct fchs_s *fchs, voi
 	rspnid->spn_len = (u8) strlen((char *)name);
 	strncpy((char *)rspnid->spn, (char *)name, rspnid->spn_len);
 
-	return (sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1275,7 +1275,7 @@ fc_gid_ft_build(struct fchs_s *fchs, voi
 	gidft->domain_id = 0;
 	gidft->area_id = 0;
 
-	return (sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1294,7 +1294,7 @@ fc_rpnid_build(struct fchs_s *fchs, void
 	rpnid->port_id = port_id;
 	rpnid->port_name = port_name;
 
-	return (sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1313,7 +1313,7 @@ fc_rnnid_build(struct fchs_s *fchs, void
 	rnnid->port_id = port_id;
 	rnnid->node_name = node_name;
 
-	return (sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1332,7 +1332,7 @@ fc_rcsid_build(struct fchs_s *fchs, void
 	rcsid->port_id = port_id;
 	rcsid->cos = cos;
 
-	return (sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1351,7 +1351,7 @@ fc_rptid_build(struct fchs_s *fchs, void
 	rptid->port_id = port_id;
 	rptid->port_type = port_type;
 
-	return (sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s));
+	return sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s);
 }
 
 u16
@@ -1368,7 +1368,7 @@ fc_ganxt_build(struct fchs_s *fchs, void
 	bfa_os_memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
 	ganxt->port_id = port_id;
 
-	return (sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s));
+	return sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s);
 }
 
 /*
@@ -1385,7 +1385,7 @@ fc_fdmi_reqhdr_build(struct fchs_s *fchs
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_fdmi_cthdr_build(cthdr, s_id, cmd_code);
 
-	return (sizeof(struct ct_hdr_s));
+	return sizeof(struct ct_hdr_s);
 }
 
 /*
@@ -1425,7 +1425,7 @@ fc_gmal_req_build(struct fchs_s *fchs, v
 	bfa_os_memset(gmal, 0, sizeof(fcgs_gmal_req_t));
 	gmal->wwn = wwn;
 
-	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gmal_req_t));
+	return sizeof(struct ct_hdr_s) + sizeof(fcgs_gmal_req_t);
 }
 
 /*
@@ -1445,5 +1445,5 @@ fc_gfn_req_build(struct fchs_s *fchs, vo
 	bfa_os_memset(gfn, 0, sizeof(fcgs_gfn_req_t));
 	gfn->wwn = wwn;
 
-	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gfn_req_t));
+	return sizeof(struct ct_hdr_s) + sizeof(fcgs_gfn_req_t);
 }
diff -urpN orig/drivers/scsi/bfa/fcbuild.h patch/drivers/scsi/bfa/fcbuild.h
--- orig/drivers/scsi/bfa/fcbuild.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fcbuild.h	2009-09-24 23:41:15.000000000 -0700
@@ -32,8 +32,8 @@
  * Utility Macros/functions
  */
 
-#define fcif_sof_set(_ifhdr, _sof)	(_ifhdr)->sof = FC_ ## _sof
-#define fcif_eof_set(_ifhdr, _eof)	(_ifhdr)->eof = FC_ ## _eof
+#define fcif_sof_set(_ifhdr, _sof)	((_ifhdr)->sof = FC_ ## _sof)
+#define fcif_eof_set(_ifhdr, _eof)	((_ifhdr)->eof = FC_ ## _eof)
 
 #define wwn_is_equal(_wwn1, _wwn2)		\
 	(memcmp(&(_wwn1), &(_wwn2), sizeof(wwn_t)) == 0)
@@ -49,7 +49,7 @@
 static inline   u32
 fc_get_ctresp_pyld_len(u32 resp_len)
 {
-	return (resp_len - sizeof(struct ct_hdr_s));
+	return resp_len - sizeof(struct ct_hdr_s);
 }
 
 /*
diff -urpN orig/drivers/scsi/bfa/fcpim.c patch/drivers/scsi/bfa/fcpim.c
--- orig/drivers/scsi/bfa/fcpim.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fcpim.c	2009-09-24 23:41:15.000000000 -0700
@@ -286,11 +286,10 @@ bfa_fcs_itnim_sm_online(struct bfa_fcs_i
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_hcb_offline);
 		bfa_fcb_itnim_offline(itnim->itnim_drv);
 		bfa_itnim_offline(itnim->bfa_itnim);
-		if (bfa_fcs_port_is_online(itnim->rport->port) == BFA_TRUE) {
+		if (bfa_fcs_port_is_online(itnim->rport->port) == BFA_TRUE)
 			bfa_fcs_itnim_aen_post(itnim, BFA_ITNIM_AEN_DISCONNECT);
-		} else {
+		else
 			bfa_fcs_itnim_aen_post(itnim, BFA_ITNIM_AEN_OFFLINE);
-		}
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -732,7 +731,7 @@ bfa_fcs_itnim_lookup(struct bfa_fcs_port
 		return NULL;
 
 	bfa_assert(rport->itnim != NULL);
-	return (rport->itnim);
+	return rport->itnim;
 }
 
 bfa_status_t
diff -urpN orig/drivers/scsi/bfa/fcs.h patch/drivers/scsi/bfa/fcs.h
--- orig/drivers/scsi/bfa/fcs.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fcs.h	2009-09-24 23:41:15.000000000 -0700
@@ -23,7 +23,7 @@
 #ifndef __FCS_H__
 #define __FCS_H__
 
-#define __fcs_min_cfg(__fcs)       (__fcs)->min_cfg
+#define __fcs_min_cfg(__fcs)       ((__fcs)->min_cfg)
 
 void bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs);
 
diff -urpN orig/drivers/scsi/bfa/fdmi.c patch/drivers/scsi/bfa/fdmi.c
--- orig/drivers/scsi/bfa/fdmi.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/fdmi.c	2009-09-24 23:41:15.000000000 -0700
@@ -72,9 +72,9 @@ static u16 bfa_fcs_port_fdmi_build_rpa_p
 			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
 static u16 bfa_fcs_port_fdmi_build_portattr_block(
 			struct bfa_fcs_port_fdmi_s *fdmi, u8 *pyld);
-void bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
+static void bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
-void bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
+static void bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			struct bfa_fcs_fdmi_port_attr_s *port_attr);
 /**
  *  fcs_fdmi_sm FCS FDMI state machine
@@ -1091,7 +1091,7 @@ bfa_fcs_port_fdmi_timeout(void *arg)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_TIMEOUT);
 }
 
-void
+static void
 bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			 struct bfa_fcs_fdmi_hba_attr_s *hba_attr)
 {
@@ -1145,7 +1145,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_
 
 }
 
-void
+static void
 bfa_fcs_fdmi_get_portattr(struct bfa_fcs_port_fdmi_s *fdmi,
 			  struct bfa_fcs_fdmi_port_attr_s *port_attr)
 {
diff -urpN orig/drivers/scsi/bfa/loop.c patch/drivers/scsi/bfa/loop.c
--- orig/drivers/scsi/bfa/loop.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/loop.c	2009-09-24 23:41:15.000000000 -0700
@@ -58,49 +58,16 @@ static const u8   port_loop_alpa_map[] =
 /*
  * Local Functions
  */
-bfa_status_t    bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port,
-					     u8 alpa);
+static bfa_status_t bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port,
+					u8 alpa);
 
-void            bfa_fcs_port_loop_plogi_response(void *fcsarg,
-						 struct bfa_fcxp_s *fcxp,
-						 void *cbarg,
-						 bfa_status_t req_status,
-						 u32 rsp_len,
-						 u32 resid_len,
-						 struct fchs_s *rsp_fchs);
-
-bfa_status_t    bfa_fcs_port_loop_send_adisc(struct bfa_fcs_port_s *port,
-					     u8 alpa);
-
-void            bfa_fcs_port_loop_adisc_response(void *fcsarg,
-						 struct bfa_fcxp_s *fcxp,
-						 void *cbarg,
-						 bfa_status_t req_status,
-						 u32 rsp_len,
-						 u32 resid_len,
-						 struct fchs_s *rsp_fchs);
-
-bfa_status_t    bfa_fcs_port_loop_send_plogi_acc(struct bfa_fcs_port_s *port,
-						 u8 alpa);
-
-void            bfa_fcs_port_loop_plogi_acc_response(void *fcsarg,
-						     struct bfa_fcxp_s *fcxp,
-						     void *cbarg,
-						     bfa_status_t req_status,
-						     u32 rsp_len,
-						     u32 resid_len,
-						     struct fchs_s *rsp_fchs);
-
-bfa_status_t    bfa_fcs_port_loop_send_adisc_acc(struct bfa_fcs_port_s *port,
-						 u8 alpa);
-
-void            bfa_fcs_port_loop_adisc_acc_response(void *fcsarg,
-						     struct bfa_fcxp_s *fcxp,
-						     void *cbarg,
-						     bfa_status_t req_status,
-						     u32 rsp_len,
-						     u32 resid_len,
-						     struct fchs_s *rsp_fchs);
+static void bfa_fcs_port_loop_plogi_response(void *fcsarg,
+					struct bfa_fcxp_s *fcxp,
+					void *cbarg,
+					bfa_status_t req_status,
+					u32 rsp_len,
+					u32 resid_len,
+					struct fchs_s *rsp_fchs);
 /**
  *   Called by port to initializar in provate LOOP topology.
  */
@@ -179,7 +146,7 @@ bfa_fcs_port_loop_lip(struct bfa_fcs_por
 /**
  * Local Functions.
  */
-bfa_status_t
+static bfa_status_t
 bfa_fcs_port_loop_send_plogi(struct bfa_fcs_port_s *port, u8 alpa)
 {
 	struct fchs_s          fchs;
@@ -208,7 +175,7 @@ bfa_fcs_port_loop_send_plogi(struct bfa_
 /**
  *   Called by fcxp to notify the Plogi response
  */
-void
+static void
 bfa_fcs_port_loop_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 				 void *cbarg, bfa_status_t req_status,
 				 u32 rsp_len, u32 resid_len,
@@ -244,179 +211,3 @@ bfa_fcs_port_loop_plogi_response(void *f
 		bfa_assert(0);
 	}
 }
-
-bfa_status_t
-bfa_fcs_port_loop_send_plogi_acc(struct bfa_fcs_port_s *port, u8 alpa)
-{
-	struct fchs_s          fchs;
-	struct bfa_fcxp_s *fcxp;
-	int             len;
-
-	bfa_trc(port->fcs, alpa);
-
-	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
-				  NULL);
-	bfa_assert(fcxp);
-
-	len = fc_plogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
-				 bfa_fcs_port_get_fcid(port), 0,
-				 port->port_cfg.pwwn, port->port_cfg.nwwn,
-				 bfa_pport_get_maxfrsize(port->fcs->bfa));
-
-	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-				 FC_CLASS_3, len, &fchs,
-				 bfa_fcs_port_loop_plogi_acc_response,
-				 (void *)port, FC_MAX_PDUSZ, 0); /* No response
-								  * expected
-								  */
-
-	return BFA_STATUS_OK;
-}
-
-/*
- *  Plogi Acc Response
- * We donot do any processing here.
- */
-void
-bfa_fcs_port_loop_plogi_acc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-				     void *cbarg, bfa_status_t req_status,
-				     u32 rsp_len, u32 resid_len,
-				     struct fchs_s *rsp_fchs)
-{
-
-	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
-
-	bfa_trc(port->fcs, port->pid);
-
-	/*
-	 * Sanity Checks
-	 */
-	if (req_status != BFA_STATUS_OK) {
-		bfa_trc(port->fcs, req_status);
-		return;
-	}
-}
-
-bfa_status_t
-bfa_fcs_port_loop_send_adisc(struct bfa_fcs_port_s *port, u8 alpa)
-{
-	struct fchs_s          fchs;
-	struct bfa_fcxp_s *fcxp;
-	int             len;
-
-	bfa_trc(port->fcs, alpa);
-
-	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
-				  NULL);
-	bfa_assert(fcxp);
-
-	len = fc_adisc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
-			     bfa_fcs_port_get_fcid(port), 0,
-			     port->port_cfg.pwwn, port->port_cfg.nwwn);
-
-	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-			  FC_CLASS_3, len, &fchs,
-			  bfa_fcs_port_loop_adisc_response, (void *)port,
-			  FC_MAX_PDUSZ, FC_RA_TOV);
-
-	return BFA_STATUS_OK;
-}
-
-/**
- *   Called by fcxp to notify the ADISC response
- */
-void
-bfa_fcs_port_loop_adisc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-				 void *cbarg, bfa_status_t req_status,
-				 u32 rsp_len, u32 resid_len,
-				 struct fchs_s *rsp_fchs)
-{
-	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
-	struct bfa_fcs_rport_s *rport;
-	struct fc_adisc_s     *adisc_resp;
-	struct fc_els_cmd_s   *els_cmd;
-	u32        pid = rsp_fchs->s_id;
-
-	bfa_trc(port->fcs, req_status);
-
-	/*
-	 * Sanity Checks
-	 */
-	if (req_status != BFA_STATUS_OK) {
-		/*
-		 * TBD : we may need to retry certain requests
-		 */
-		bfa_fcxp_free(fcxp);
-		return;
-	}
-
-	els_cmd = (struct fc_els_cmd_s *) BFA_FCXP_RSP_PLD(fcxp);
-	adisc_resp = (struct fc_adisc_s *) els_cmd;
-
-	if (els_cmd->els_code == FC_ELS_ACC) {
-	} else {
-		bfa_trc(port->fcs, adisc_resp->els_cmd.els_code);
-
-		/*
-		 * TBD: we may need to check for reject codes and retry
-		 */
-		rport = bfa_fcs_port_get_rport_by_pid(port, pid);
-		if (rport) {
-			list_del(&rport->qe);
-			bfa_fcs_rport_delete(rport);
-		}
-
-	}
-	return;
-}
-
-bfa_status_t
-bfa_fcs_port_loop_send_adisc_acc(struct bfa_fcs_port_s *port, u8 alpa)
-{
-	struct fchs_s          fchs;
-	struct bfa_fcxp_s *fcxp;
-	int             len;
-
-	bfa_trc(port->fcs, alpa);
-
-	fcxp = bfa_fcxp_alloc(NULL, port->fcs->bfa, 0, 0, NULL, NULL, NULL,
-				  NULL);
-	bfa_assert(fcxp);
-
-	len = fc_adisc_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp), alpa,
-				 bfa_fcs_port_get_fcid(port), 0,
-				 port->port_cfg.pwwn, port->port_cfg.nwwn);
-
-	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
-				FC_CLASS_3, len, &fchs,
-				bfa_fcs_port_loop_adisc_acc_response,
-				(void *)port, FC_MAX_PDUSZ, 0); /* no reponse
-								 * expected
-								 */
-
-	return BFA_STATUS_OK;
-}
-
-/*
- *  Adisc Acc Response
- * We donot do any processing here.
- */
-void
-bfa_fcs_port_loop_adisc_acc_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
-				     void *cbarg, bfa_status_t req_status,
-				     u32 rsp_len, u32 resid_len,
-				     struct fchs_s *rsp_fchs)
-{
-
-	struct bfa_fcs_port_s *port = (struct bfa_fcs_port_s *) cbarg;
-
-	bfa_trc(port->fcs, port->pid);
-
-	/*
-	 * Sanity Checks
-	 */
-	if (req_status != BFA_STATUS_OK) {
-		bfa_trc(port->fcs, req_status);
-		return;
-	}
-}
diff -urpN orig/drivers/scsi/bfa/lport_api.c patch/drivers/scsi/bfa/lport_api.c
--- orig/drivers/scsi/bfa/lport_api.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/lport_api.c	2009-09-24 23:41:15.000000000 -0700
@@ -43,7 +43,7 @@ bfa_fcs_cfg_base_port(struct bfa_fcs_s *
 struct bfa_fcs_port_s *
 bfa_fcs_get_base_port(struct bfa_fcs_s *fcs)
 {
-	return (&fcs->fabric.bport);
+	return &fcs->fabric.bport;
 }
 
 wwn_t
@@ -88,11 +88,10 @@ bfa_fcs_port_get_rport(struct bfa_fcs_po
 	}
 
 	bfa_trc(fcs, i);
-	if (rport) {
+	if (rport)
 		return rport->pwwn;
-	} else {
+	else
 		return (wwn_t) 0;
-	}
 }
 
 void
@@ -198,17 +197,17 @@ bfa_fcs_lookup_port(struct bfa_fcs_s *fc
 	vf = bfa_fcs_vf_lookup(fcs, vf_id);
 	if (vf == NULL) {
 		bfa_trc(fcs, vf_id);
-		return (NULL);
+		return NULL;
 	}
 
 	if (!lpwwn || (vf->bport.port_cfg.pwwn == lpwwn))
-		return (&vf->bport);
+		return &vf->bport;
 
 	vport = bfa_fcs_fabric_vport_lookup(vf, lpwwn);
 	if (vport)
-		return (&vport->lport);
+		return &vport->lport;
 
-	return (NULL);
+	return NULL;
 }
 
 /*
diff -urpN orig/drivers/scsi/bfa/ns.c patch/drivers/scsi/bfa/ns.c
--- orig/drivers/scsi/bfa/ns.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/ns.c	2009-09-24 23:41:16.000000000 -0700
@@ -932,11 +932,10 @@ bfa_fcs_port_ns_send_rff_id(void *ns_cba
 	}
 	ns->fcxp = fcxp;
 
-	if (BFA_FCS_VPORT_IS_INITIATOR_MODE(ns->port)) {
+	if (BFA_FCS_VPORT_IS_INITIATOR_MODE(ns->port))
 		fc4_ftrs = FC_GS_FCP_FC4_FEATURE_INITIATOR;
-	} else if (BFA_FCS_VPORT_IS_TARGET_MODE(ns->port)) {
+	else if (BFA_FCS_VPORT_IS_TARGET_MODE(ns->port))
 		fc4_ftrs = FC_GS_FCP_FC4_FEATURE_TARGET;
-	}
 
 	len = fc_rffid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 			     bfa_fcs_port_get_fcid(port), 0, FC_TYPE_FCP,
diff -urpN orig/drivers/scsi/bfa/plog.c patch/drivers/scsi/bfa/plog.c
--- orig/drivers/scsi/bfa/plog.c	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/plog.c	2009-09-24 23:41:16.000000000 -0700
@@ -180,5 +180,5 @@ bfa_plog_disable(struct bfa_plog_s *plog
 bfa_boolean_t
 bfa_plog_get_setting(struct bfa_plog_s *plog)
 {
-	return((bfa_boolean_t)plog->plog_enabled);
+	return (bfa_boolean_t)plog->plog_enabled;
 }
diff -urpN orig/drivers/scsi/bfa/rport_ftrs.c patch/drivers/scsi/bfa/rport_ftrs.c
--- orig/drivers/scsi/bfa/rport_ftrs.c	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/rport_ftrs.c	2009-09-24 23:41:16.000000000 -0700
@@ -79,7 +79,7 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf
 	bfa_trc(rport->fcs, event);
 
 	switch (event) {
-	case RPFSM_EVENT_RPORT_ONLINE :
+	case RPFSM_EVENT_RPORT_ONLINE:
 		if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
 			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
 			rpf->rpsc_retries = 0;
@@ -87,7 +87,7 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf
 			break;
 		};
 
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		break;
 
 	default:
@@ -107,7 +107,7 @@ bfa_fcs_rpf_sm_rpsc_sending(struct bfa_f
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc);
 		break;
 
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
 		bfa_fcxp_walloc_cancel(rport->fcs->bfa, &rpf->fcxp_wqe);
 		rpf->rpsc_retries = 0;
@@ -130,11 +130,10 @@ bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s
 	case RPFSM_EVENT_RPSC_COMP:
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_online);
 		/* Update speed info in f/w via BFA */
-		if (rpf->rpsc_speed != BFA_PPORT_SPEED_UNKNOWN) {
+		if (rpf->rpsc_speed != BFA_PPORT_SPEED_UNKNOWN)
 			bfa_rport_speed(rport->bfa_rport, rpf->rpsc_speed);
-		} else if (rpf->assigned_speed != BFA_PPORT_SPEED_UNKNOWN) {
+		else if (rpf->assigned_speed != BFA_PPORT_SPEED_UNKNOWN)
 			bfa_rport_speed(rport->bfa_rport, rpf->assigned_speed);
-		}
 		break;
 
 	case RPFSM_EVENT_RPSC_FAIL:
@@ -154,7 +153,7 @@ bfa_fcs_rpf_sm_rpsc(struct bfa_fcs_rpf_s
 		}
 		break;
 
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
 		bfa_fcxp_discard(rpf->fcxp);
 		rpf->rpsc_retries = 0;
@@ -174,13 +173,13 @@ bfa_fcs_rpf_sm_rpsc_retry(struct bfa_fcs
 	bfa_trc(rport->fcs, event);
 
 	switch (event) {
-	case RPFSM_EVENT_TIMEOUT :
+	case RPFSM_EVENT_TIMEOUT:
 		/* re-send the RPSC */
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
 		bfa_fcs_rpf_send_rpsc2(rpf, NULL);
 		break;
 
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		bfa_timer_stop(&rpf->timer);
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
 		rpf->rpsc_retries = 0;
@@ -201,7 +200,7 @@ bfa_fcs_rpf_sm_online(struct bfa_fcs_rpf
 	bfa_trc(rport->fcs, event);
 
 	switch (event) {
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_offline);
 		rpf->rpsc_retries = 0;
 		break;
@@ -221,12 +220,12 @@ bfa_fcs_rpf_sm_offline(struct bfa_fcs_rp
 	bfa_trc(rport->fcs, event);
 
 	switch (event) {
-	case RPFSM_EVENT_RPORT_ONLINE :
+	case RPFSM_EVENT_RPORT_ONLINE:
 		bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
 		bfa_fcs_rpf_send_rpsc2(rpf, NULL);
 		break;
 
-	case RPFSM_EVENT_RPORT_OFFLINE :
+	case RPFSM_EVENT_RPORT_OFFLINE:
 		break;
 
 	default:
@@ -366,10 +365,9 @@ bfa_fcs_rpf_rpsc2_response(void *fcsarg,
 		bfa_trc(rport->fcs, ls_rjt->reason_code);
 		bfa_trc(rport->fcs, ls_rjt->reason_code_expl);
 		rport->stats.rpsc_rejects++;
-		if (ls_rjt->reason_code == FC_LS_RJT_RSN_CMD_NOT_SUPP) {
+		if (ls_rjt->reason_code == FC_LS_RJT_RSN_CMD_NOT_SUPP)
 			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_FAIL);
-		} else {
+		else
 			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_ERROR);
-		}
 	}
 }
diff -urpN orig/drivers/scsi/bfa/vfapi.c patch/drivers/scsi/bfa/vfapi.c
--- orig/drivers/scsi/bfa/vfapi.c	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/vfapi.c	2009-09-24 23:41:16.000000000 -0700
@@ -189,7 +189,7 @@ bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs,
 {
 	bfa_trc(fcs, vf_id);
 	if (vf_id == FC_VF_ID_NULL)
-		return (&fcs->fabric);
+		return &fcs->fabric;
 
 	/**
 	 * @todo vf support
diff -urpN orig/drivers/scsi/bfa/vport.c patch/drivers/scsi/bfa/vport.c
--- orig/drivers/scsi/bfa/vport.c	2009-09-24 23:41:16.000000000 -0700
+++ patch/drivers/scsi/bfa/vport.c	2009-09-24 23:41:16.000000000 -0700
@@ -31,13 +31,13 @@
 
 BFA_TRC_FILE(FCS, VPORT);
 
-#define __vport_fcs(__vp)       (__vp)->lport.fcs
-#define __vport_pwwn(__vp)      (__vp)->lport.port_cfg.pwwn
-#define __vport_nwwn(__vp)      (__vp)->lport.port_cfg.nwwn
-#define __vport_bfa(__vp)       (__vp)->lport.fcs->bfa
-#define __vport_fcid(__vp)      (__vp)->lport.pid
-#define __vport_fabric(__vp)    (__vp)->lport.fabric
-#define __vport_vfid(__vp)      (__vp)->lport.fabric->vf_id
+#define __vport_fcs(__vp)       ((__vp)->lport.fcs)
+#define __vport_pwwn(__vp)      ((__vp)->lport.port_cfg.pwwn)
+#define __vport_nwwn(__vp)      ((__vp)->lport.port_cfg.nwwn)
+#define __vport_bfa(__vp)       ((__vp)->lport.fcs->bfa)
+#define __vport_fcid(__vp)      ((__vp)->lport.pid)
+#define __vport_fabric(__vp)    ((__vp)->lport.fabric)
+#define __vport_vfid(__vp)      ((__vp)->lport.fabric->vf_id)
 
 #define BFA_FCS_VPORT_MAX_RETRIES  5
 /*
@@ -641,9 +641,9 @@ bfa_fcs_vport_get_max(struct bfa_fcs_s *
 	bfa_get_attr(fcs->bfa, &ioc_attr);
 
 	if (ioc_attr.pci_attr.device_id == BFA_PCI_DEVICE_ID_CT)
-		return (BFA_FCS_MAX_VPORTS_SUPP_CT);
+		return BFA_FCS_MAX_VPORTS_SUPP_CT;
 	else
-		return (BFA_FCS_MAX_VPORTS_SUPP_CB);
+		return BFA_FCS_MAX_VPORTS_SUPP_CB;
 }
 
 
@@ -675,7 +675,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vpor
 		     struct bfad_vport_s *vport_drv)
 {
 	if (vport_cfg->pwwn == 0)
-		return (BFA_STATUS_INVALID_WWN);
+		return BFA_STATUS_INVALID_WWN;
 
 	if (bfa_fcs_port_get_pwwn(&fcs->fabric.bport) == vport_cfg->pwwn)
 		return BFA_STATUS_VPORT_WWN_BP;
