From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcbuild.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 19:22:00 +0100
Message-ID: <1417976520-14846-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58617 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaLGSTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2014 13:19:22 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so4610783wgh.32
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2014 10:19:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
fc_tprlo_rsp_parse() fc_tprlo_build() fc_prlo_rsp_parse() fc_prlo_build()
fc_pdisc_rsp_parse() fc_pdisc_build() fc_logo_rsp_parse() fc_rpsc_build()
fc_rnid_build() fc_tprlo_acc_build() fc_logout_params_pages() fc_rrq_build()
fc_abts_rsp_parse() fc_abts_build() fc_pdisc_parse() fc_adisc_parse()
fc_prli_parse() fc_plogi_rsp_parse() fc_fdisc_build() fc_flogi_build()
fc_els_rsp_parse() fc_ganxt_build() fc_rptid_build() fc_rcsid_build()
fc_rpnid_build() fc_rftid_build_sol() fc_rscn_build() fc_ct_rsp_parse()
fc_gnnid_build() fc_ba_rjt_build() fc_rrq_rsp_parse()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcbuild.c |  607 ----------------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h |   87 ------
 2 files changed, 694 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index dce787f..300264f 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -189,27 +189,6 @@ fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 	fchs->ox_id = ox_id;
 }
 
-enum fc_parse_status
-fc_els_rsp_parse(struct fchs_s *fchs, int len)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-	struct fc_ls_rjt_s *ls_rjt = (struct fc_ls_rjt_s *) els_cmd;
-
-	len = len;
-
-	switch (els_cmd->els_code) {
-	case FC_ELS_LS_RJT:
-		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-
-	case FC_ELS_ACC:
-		return FC_PARSE_OK;
-	}
-	return FC_PARSE_OK;
-}
-
 static void
 fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 {
@@ -248,44 +227,6 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 }
 
 u16
-fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size,
-	       u8 set_npiv, u8 set_auth, u16 local_bb_credits)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
-	__be32	*vvl_info;
-
-	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	flogi->els_cmd.els_code = FC_ELS_FLOGI;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
-	flogi->port_name = port_name;
-	flogi->node_name = node_name;
-
-	/*
-	 * Set the NPIV Capability Bit ( word 1, bit 31) of Common
-	 * Service Parameters.
-	 */
-	flogi->csp.ciro = set_npiv;
-
-	/* set AUTH capability */
-	flogi->csp.security = set_auth;
-
-	flogi->csp.bbcred = cpu_to_be16(local_bb_credits);
-
-	/* Set brcd token in VVL */
-	vvl_info = (u32 *)&flogi->vvl[0];
-
-	/* set the flag to indicate the presence of VVL */
-	flogi->csp.npiv_supp    = 1; /* @todo. field name is not correct */
-	vvl_info[0]	= cpu_to_be32(FLOGI_VVL_BRCD);
-
-	return sizeof(struct fc_logi_s);
-}
-
-u16
 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 		   __be16 ox_id, wwn_t port_name, wwn_t node_name,
 		   u16 pdu_size, u16 local_bb_credits, u8 bb_scn)
@@ -308,24 +249,6 @@ fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 }
 
 u16
-fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
-
-	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	flogi->els_cmd.els_code = FC_ELS_FDISC;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
-	flogi->port_name = port_name;
-	flogi->node_name = node_name;
-
-	return sizeof(struct fc_logi_s);
-}
-
-u16
 fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	       u16 ox_id, wwn_t port_name, wwn_t node_name,
 	       u16 pdu_size, u16 bb_cr)
@@ -344,40 +267,6 @@ fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 }
 
 enum fc_parse_status
-fc_plogi_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-	struct fc_logi_s *plogi;
-	struct fc_ls_rjt_s *ls_rjt;
-
-	switch (els_cmd->els_code) {
-	case FC_ELS_LS_RJT:
-		ls_rjt = (struct fc_ls_rjt_s *) (fchs + 1);
-		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	case FC_ELS_ACC:
-		plogi = (struct fc_logi_s *) (fchs + 1);
-		if (len < sizeof(struct fc_logi_s))
-			return FC_PARSE_FAILURE;
-
-		if (!wwn_is_equal(plogi->port_name, port_name))
-			return FC_PARSE_FAILURE;
-
-		if (!plogi->class3.class_valid)
-			return FC_PARSE_FAILURE;
-
-		if (be16_to_cpu(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
-			return FC_PARSE_FAILURE;
-
-		return FC_PARSE_OK;
-	default:
-		return FC_PARSE_FAILURE;
-	}
-}
-
-enum fc_parse_status
 fc_plogi_parse(struct fchs_s *fchs)
 {
 	struct fc_logi_s *plogi = (struct fc_logi_s *) (fchs + 1);
@@ -449,21 +338,6 @@ fc_prli_rsp_parse(struct fc_prli_s *prli, int len)
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_prli_parse(struct fc_prli_s *prli)
-{
-	if (prli->parampage.type != FC_TYPE_FCP)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.imagepair)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.servparams.initiator)
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
 u16
 fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 	      u16 ox_id, wwn_t port_name)
@@ -534,84 +408,6 @@ fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len, wwn_t port_name,
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_adisc_parse(struct fchs_s *fchs, void *pld, u32 host_dap, wwn_t node_name,
-	       wwn_t port_name)
-{
-	struct fc_adisc_s *adisc = (struct fc_adisc_s *) pld;
-
-	if (adisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	if ((adisc->nport_id == (host_dap))
-	    && wwn_is_equal(adisc->orig_port_name, port_name)
-	    && wwn_is_equal(adisc->orig_node_name, node_name))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
-enum fc_parse_status
-fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (pdisc->class3.class_valid != 1)
-		return FC_PARSE_FAILURE;
-
-	if ((be16_to_cpu(pdisc->class3.rxsz) <
-		(FC_MIN_PDUSZ - sizeof(struct fchs_s)))
-	    || (pdisc->class3.rxsz == 0))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->node_name, node_name))
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_abts_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
-{
-	memcpy(fchs, &fc_bls_req_tmpl, sizeof(struct fchs_s));
-	fchs->cat_info = FC_CAT_ABTS;
-	fchs->d_id = (d_id);
-	fchs->s_id = (s_id);
-	fchs->ox_id = cpu_to_be16(ox_id);
-
-	return sizeof(struct fchs_s);
-}
-
-enum fc_parse_status
-fc_abts_rsp_parse(struct fchs_s *fchs, int len)
-{
-	if ((fchs->cat_info == FC_CAT_BA_ACC)
-	    || (fchs->cat_info == FC_CAT_BA_RJT))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
-u16
-fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id, u32 s_id,
-	     u16 ox_id, u16 rrq_oxid)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	/*
-	 * build rrq payload
-	 */
-	memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
-	rrq->s_id = (s_id);
-	rrq->ox_id = cpu_to_be16(rrq_oxid);
-	rrq->rx_id = FC_RXID_ANY;
-
-	return sizeof(struct fc_rrq_s);
-}
-
 u16
 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 		  __be16 ox_id)
@@ -669,47 +465,6 @@ fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd, u32 d_id,
 	return sizeof(struct fc_els_cmd_s);
 }
 
-int
-fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
-{
-	int             num_pages = 0;
-	struct fc_prlo_s *prlo;
-	struct fc_tprlo_s *tprlo;
-
-	if (els_code == FC_ELS_PRLO) {
-		prlo = (struct fc_prlo_s *) (fc_frame + 1);
-		num_pages = (be16_to_cpu(prlo->payload_len) - 4) / 16;
-	} else {
-		tprlo = (struct fc_tprlo_s *) (fc_frame + 1);
-		num_pages = (be16_to_cpu(tprlo->payload_len) - 4) / 16;
-	}
-	return num_pages;
-}
-
-u16
-fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, __be16 ox_id, int num_pages)
-{
-	int             page;
-
-	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
-
-	memset(tprlo_acc, 0, (num_pages * 16) + 4);
-	tprlo_acc->command = FC_ELS_ACC;
-
-	tprlo_acc->page_len = 0x10;
-	tprlo_acc->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		tprlo_acc->tprlo_acc_params[page].opa_valid = 0;
-		tprlo_acc->tprlo_acc_params[page].rpa_valid = 0;
-		tprlo_acc->tprlo_acc_params[page].fc4type_csp = FC_TYPE_FCP;
-		tprlo_acc->tprlo_acc_params[page].orig_process_assc = 0;
-		tprlo_acc->tprlo_acc_params[page].resp_process_assc = 0;
-	}
-	return be16_to_cpu(tprlo_acc->payload_len);
-}
-
 u16
 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 		  u32 s_id, __be16 ox_id, int num_pages)
@@ -735,20 +490,6 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 }
 
 u16
-fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
-		u32 s_id, u16 ox_id, u32 data_format)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	memset(rnid, 0, sizeof(struct fc_rnid_cmd_s));
-
-	rnid->els_cmd.els_code = FC_ELS_RNID;
-	rnid->node_id_data_format = data_format;
-
-	return sizeof(struct fc_rnid_cmd_s);
-}
-
-u16
 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 		  u32 s_id, __be16 ox_id, u32 data_format,
 		  struct fc_rnid_common_id_data_s *common_id_data,
@@ -777,18 +518,6 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 }
 
 u16
-fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
-		u32 s_id, u16 ox_id)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
-
-	rpsc->els_cmd.els_code = FC_ELS_RPSC;
-	return sizeof(struct fc_rpsc_cmd_s);
-}
-
-u16
 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 		u32 s_id, u32 *pid_list, u16 npids)
 {
@@ -829,202 +558,6 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	return sizeof(struct fc_rpsc_acc_s);
 }
 
-u16
-fc_logo_rsp_parse(struct fchs_s *fchs, int len)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-
-	len = len;
-	if (els_cmd->els_code != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	       wwn_t port_name, wwn_t node_name, u16 pdu_size)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	memcpy(pdisc, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	pdisc->els_cmd.els_code = FC_ELS_PDISC;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	pdisc->csp.rxsz = pdisc->class3.rxsz = cpu_to_be16(pdu_size);
-	pdisc->port_name = port_name;
-	pdisc->node_name = node_name;
-
-	return sizeof(struct fc_logi_s);
-}
-
-u16
-fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (len < sizeof(struct fc_logi_s))
-		return FC_PARSE_LEN_INVAL;
-
-	if (pdisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_ACC_INVAL;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_PWWN_NOT_EQUAL;
-
-	if (!pdisc->class3.class_valid)
-		return FC_PARSE_NWWN_NOT_EQUAL;
-
-	if (be16_to_cpu(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
-		return FC_PARSE_RXSZ_INVAL;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	      int num_pages)
-{
-	struct fc_prlo_s *prlo = (struct fc_prlo_s *) (fchs + 1);
-	int             page;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	memset(prlo, 0, (num_pages * 16) + 4);
-	prlo->command = FC_ELS_PRLO;
-	prlo->page_len = 0x10;
-	prlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		prlo->prlo_params[page].type = FC_TYPE_FCP;
-		prlo->prlo_params[page].opa_valid = 0;
-		prlo->prlo_params[page].rpa_valid = 0;
-		prlo->prlo_params[page].orig_process_assc = 0;
-		prlo->prlo_params[page].resp_process_assc = 0;
-	}
-
-	return be16_to_cpu(prlo->payload_len);
-}
-
-u16
-fc_prlo_rsp_parse(struct fchs_s *fchs, int len)
-{
-	struct fc_prlo_acc_s *prlo = (struct fc_prlo_acc_s *) (fchs + 1);
-	int             num_pages = 0;
-	int             page = 0;
-
-	len = len;
-
-	if (prlo->command != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	num_pages = ((be16_to_cpu(prlo->payload_len)) - 4) / 16;
-
-	for (page = 0; page < num_pages; page++) {
-		if (prlo->prlo_acc_params[page].type != FC_TYPE_FCP)
-			return FC_PARSE_FAILURE;
-
-		if (prlo->prlo_acc_params[page].opa_valid != 0)
-			return FC_PARSE_FAILURE;
-
-		if (prlo->prlo_acc_params[page].rpa_valid != 0)
-			return FC_PARSE_FAILURE;
-
-		if (prlo->prlo_acc_params[page].orig_process_assc != 0)
-			return FC_PARSE_FAILURE;
-
-		if (prlo->prlo_acc_params[page].resp_process_assc != 0)
-			return FC_PARSE_FAILURE;
-	}
-	return FC_PARSE_OK;
-
-}
-
-u16
-fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	       int num_pages, enum fc_tprlo_type tprlo_type, u32 tpr_id)
-{
-	struct fc_tprlo_s *tprlo = (struct fc_tprlo_s *) (fchs + 1);
-	int             page;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	memset(tprlo, 0, (num_pages * 16) + 4);
-	tprlo->command = FC_ELS_TPRLO;
-	tprlo->page_len = 0x10;
-	tprlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		tprlo->tprlo_params[page].type = FC_TYPE_FCP;
-		tprlo->tprlo_params[page].opa_valid = 0;
-		tprlo->tprlo_params[page].rpa_valid = 0;
-		tprlo->tprlo_params[page].orig_process_assc = 0;
-		tprlo->tprlo_params[page].resp_process_assc = 0;
-		if (tprlo_type == FC_GLOBAL_LOGO) {
-			tprlo->tprlo_params[page].global_process_logout = 1;
-		} else if (tprlo_type == FC_TPR_LOGO) {
-			tprlo->tprlo_params[page].tpo_nport_valid = 1;
-			tprlo->tprlo_params[page].tpo_nport_id = (tpr_id);
-		}
-	}
-
-	return be16_to_cpu(tprlo->payload_len);
-}
-
-u16
-fc_tprlo_rsp_parse(struct fchs_s *fchs, int len)
-{
-	struct fc_tprlo_acc_s *tprlo = (struct fc_tprlo_acc_s *) (fchs + 1);
-	int             num_pages = 0;
-	int             page = 0;
-
-	len = len;
-
-	if (tprlo->command != FC_ELS_ACC)
-		return FC_PARSE_ACC_INVAL;
-
-	num_pages = (be16_to_cpu(tprlo->payload_len) - 4) / 16;
-
-	for (page = 0; page < num_pages; page++) {
-		if (tprlo->tprlo_acc_params[page].type != FC_TYPE_FCP)
-			return FC_PARSE_NOT_FCP;
-		if (tprlo->tprlo_acc_params[page].opa_valid != 0)
-			return FC_PARSE_OPAFLAG_INVAL;
-		if (tprlo->tprlo_acc_params[page].rpa_valid != 0)
-			return FC_PARSE_RPAFLAG_INVAL;
-		if (tprlo->tprlo_acc_params[page].orig_process_assc != 0)
-			return FC_PARSE_OPA_INVAL;
-		if (tprlo->tprlo_acc_params[page].resp_process_assc != 0)
-			return FC_PARSE_RPA_INVAL;
-	}
-	return FC_PARSE_OK;
-}
-
-enum fc_parse_status
-fc_rrq_rsp_parse(struct fchs_s *fchs, int len)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-
-	len = len;
-	if (els_cmd->els_code != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id,
-		u32 reason_code, u32 reason_expl)
-{
-	struct fc_ba_rjt_s *ba_rjt = (struct fc_ba_rjt_s *) (fchs + 1);
-
-	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
-
-	fchs->cat_info = FC_CAT_BA_RJT;
-	ba_rjt->reason_code = reason_code;
-	ba_rjt->reason_expl = reason_expl;
-	return sizeof(struct fc_ba_rjt_s);
-}
-
 static void
 fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 {
@@ -1089,35 +622,6 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 }
 
 u16
-fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-	       u32 port_id)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	fcgs_gnnid_req_t *gnnid = (fcgs_gnnid_req_t *) (cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
-	fc_gs_cthdr_build(cthdr, s_id, GS_GNN_ID);
-
-	memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
-	gnnid->dap = port_id;
-	return sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
-{
-	if (be16_to_cpu(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
-		if (cthdr->reason_code == CT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	}
-
-	return FC_PARSE_OK;
-}
-
-u16
 fc_gs_rjt_build(struct fchs_s *fchs,  struct ct_hdr_s *cthdr,
 		u32 d_id, u32 s_id, u16 ox_id, u8 reason_code,
 		u8 reason_code_expl)
@@ -1150,26 +654,6 @@ fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 }
 
 u16
-fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
-		u32 s_id, u16 ox_id)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_CONTROLLER);
-	u16        payldlen;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	rscn->command = FC_ELS_RSCN;
-	rscn->pagelen = sizeof(rscn->event[0]);
-
-	payldlen = sizeof(u32) + rscn->pagelen;
-	rscn->payldlen = cpu_to_be16(payldlen);
-
-	rscn->event[0].format = FC_RSCN_FORMAT_PORTID;
-	rscn->event[0].portid = s_id;
-
-	return sizeof(struct fc_rscn_pl_s);
-}
-
-u16
 fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       enum bfa_lport_role roles)
 {
@@ -1194,26 +678,6 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 }
 
 u16
-fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-		   u8 *fc4_bitmap, u32 bitmap_size)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
-
-	memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
-
-	rftid->dap = s_id;
-	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
-		(bitmap_size < 32 ? bitmap_size : 32));
-
-	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
 fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       u8 fc4_type, u8 fc4_ftrs)
 {
@@ -1297,24 +761,6 @@ fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 }
 
 u16
-fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       wwn_t port_name)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rpnid_req_s *rpnid = (struct fcgs_rpnid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RPN_ID);
-
-	memset(rpnid, 0, sizeof(struct fcgs_rpnid_req_s));
-	rpnid->port_id = port_id;
-	rpnid->port_name = port_name;
-
-	return sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
 fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       wwn_t node_name)
 {
@@ -1332,59 +778,6 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	return sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       u32 cos)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rcsid_req_s *rcsid =
-			(struct fcgs_rcsid_req_s *) (cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RCS_ID);
-
-	memset(rcsid, 0, sizeof(struct fcgs_rcsid_req_s));
-	rcsid->port_id = port_id;
-	rcsid->cos = cos;
-
-	return sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       u8 port_type)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rptid_req_s *rptid = (struct fcgs_rptid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RPT_ID);
-
-	memset(rptid, 0, sizeof(struct fcgs_rptid_req_s));
-	rptid->port_id = port_id;
-	rptid->port_type = port_type;
-
-	return sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_ganxt_req_s *ganxt = (struct fcgs_ganxt_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_GA_NXT);
-
-	memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
-	ganxt->port_id = port_id;
-
-	return sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s);
-}
-
 /*
  * Builds fc hdr and ct hdr for FDMI requests.
  */
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 03c753d..0006800 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -134,15 +134,6 @@ struct fc_templates_s {
 
 void            fcbuild_init(void);
 
-u16        fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
-			u32 s_id, u16 ox_id, wwn_t port_name, wwn_t node_name,
-			       u16 pdu_size, u8 set_npiv, u8 set_auth,
-			       u16 local_bb_credits);
-
-u16        fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi, u32 s_id,
-			       u16 ox_id, wwn_t port_name, wwn_t node_name,
-			       u16 pdu_size);
-
 u16        fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
 				   u32 s_id, __be16 ox_id,
 				   wwn_t port_name, wwn_t node_name,
@@ -155,15 +146,6 @@ u16        fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
 
 enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
 
-u16        fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
-			      u16 ox_id);
-
-enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
-
-u16        fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq, u32 d_id,
-			     u32 s_id, u16 ox_id, u16 rrq_oxid);
-enum fc_parse_status fc_rrq_rsp_parse(struct fchs_s *buf, int len);
-
 u16        fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u16 ox_id, u8 *name);
 u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
@@ -172,10 +154,6 @@ u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
 u16        fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 			       u16 ox_id, enum bfa_lport_role role);
 
-u16       fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
-				   u16 ox_id, u8 *fc4_bitmap,
-				   u32 bitmap_size);
-
 u16	fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			u16 ox_id, u8 fc4_type, u8 fc4_ftrs);
 
@@ -201,9 +179,6 @@ u16        fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
 			u32 d_id, u32 s_id, __be16 ox_id, wwn_t port_name,
 			       wwn_t node_name);
 
-enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
-			u32 host_dap, wwn_t node_name, wwn_t port_name);
-
 enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
 				 wwn_t port_name, wwn_t node_name);
 
@@ -224,10 +199,6 @@ u16        fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
 				  u32 s_id, __be16 ox_id,
 				  enum bfa_lport_role role);
 
-u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
-			      u32 d_id, u32 s_id, u16 ox_id,
-			      u32 data_format);
-
 u16        fc_rnid_acc_build(struct fchs_s *fchs,
 			struct fc_rnid_acc_s *rnid_acc, u32 d_id, u32 s_id,
 			__be16 ox_id, u32 data_format,
@@ -236,29 +207,15 @@ u16        fc_rnid_acc_build(struct fchs_s *fchs,
 
 u16	fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rps2c,
 			u32 d_id, u32 s_id, u32 *pid_list, u16 npids);
-u16        fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
-			      u32 d_id, u32 s_id, u16 ox_id);
 u16        fc_rpsc_acc_build(struct fchs_s *fchs,
 			struct fc_rpsc_acc_s *rpsc_acc, u32 d_id, u32 s_id,
 			__be16 ox_id, struct fc_rpsc_speed_info_s *oper_speed);
 u16        fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u8 fc4_type);
 
-u16        fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, wwn_t port_name);
-
 u16        fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			       u32 port_id, wwn_t node_name);
 
-u16        fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, u32 cos);
-
-u16        fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, u8 port_type);
-
-u16        fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id);
-
 u16        fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id,
 			      u32 s_id, u16 ox_id, wwn_t port_name);
 
@@ -275,54 +232,10 @@ void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
 void		fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 					 __be16 ox_id);
 
-enum fc_parse_status	fc_els_rsp_parse(struct fchs_s *fchs, int len);
-
-enum fc_parse_status	fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
-					wwn_t port_name);
-
-enum fc_parse_status	fc_prli_parse(struct fc_prli_s *prli);
-
-enum fc_parse_status	fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
-					wwn_t port_name);
-
 u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 		u32 s_id, __be16 ox_id, u16 rx_id);
 
-int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
-
-u16 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
-
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
 		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
-u16 fc_logo_rsp_parse(struct fchs_s *fchs, int len);
-
-u16 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name,
-		u16 pdu_size);
-
-u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
-
-u16 fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, int num_pages);
-
-u16 fc_prlo_rsp_parse(struct fchs_s *fchs, int len);
-
-u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
-		u32 tpr_id);
-
-u16 fc_tprlo_rsp_parse(struct fchs_s *fchs, int len);
-
-u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		__be16 ox_id, u32 reason_code, u32 reason_expl);
-
-u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-		u32 port_id);
-
-u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
-
-u16 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn, u32 s_id,
-		u16 ox_id);
 #endif
-- 
1.7.10.4

