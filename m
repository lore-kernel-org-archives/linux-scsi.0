Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE281D279C;
	Sun, 17 Nov 2024 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731851555; cv=none; b=FXChhrLWzKwseQ0D5Kzn9U1sd6HYX88oYp74d7Ly5Kq/EBaHdKKj78lQKHLSirGJFXlRKMOkSK0D90YmVYPp5Cka4VsOoqsgojj9hrfaDKIHFflEH7JK9L91fBCcI14321Uz7vXjd2KB8R4USFy8bN+11ZvNIt33FhfBySShlvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731851555; c=relaxed/simple;
	bh=1cvX98D9YxoB08S+iXUipxja5yAoYMHNwTSrtXdUkJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQjzIlYKF1nNMsaWeb5c1Dc8z8boEIuhZkzz5kxgf4oaL+wYc8VPCWDpUfmF5Lq9vEgejInfhiLQQF4xcR+8Z6v7uNfiKq1X2F1+d1QtIv6okjibfMcJrCzYdER/ZNkLnmcvhFxuftJlkG951zrLAhppIn/l0AEr6JBGW9jOmq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QYqaMUJe; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QYqaMUJe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=bTKgxq3QI36epXvaDFoOnLLRC/hj1ZX9R4BGEkN6I/s=; b=QYqaMUJetFjJx7XP
	2RmWY+BAVhWFMmnFqOYXwv9g+UF68lmOE8WFjSb91MZPwMCpYvu/sQIhr9cdV8+odMqMGGWKJASgL
	72CFodbfYXPRp+9ftf91d84vmk2SXqdQSc2NEbBHPtRxKpIuBSCHgaAM1gEzT+WAJWvmTYq0HU+7S
	8ps3ALMnDhDhrN1HGOh/+zPzJh7ltxiv2HBSGoEC1WzthL3pesa9TbdRYYrEf9sq7xl+rawz5vZix
	CumWH2Zvi4CvLw6k625XOrbbni+H7nnVIg/XydXbndjUKV2eeR7naZuQr+LMvQcVnEAor15FRAs3N
	zRLBOmJsxqHkfwXnZA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tCfhJ-000MsI-1r;
	Sun, 17 Nov 2024 13:52:17 +0000
From: linux@treblig.org
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/2] scsi: bfa: Remove unused structure builders
Date: Sun, 17 Nov 2024 13:52:14 +0000
Message-ID: <20241117135215.38771-2-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241117135215.38771-1-linux@treblig.org>
References: <20241117135215.38771-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

bfa has a large set of structure builders, of which only
about 60% are used; remove the rest.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_fcbuild.c | 348 ---------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h |  55 ------
 2 files changed, 403 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 52303e8c716d..0f5d8a9cdf14 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -219,44 +219,6 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	return sizeof(struct fc_logi_s);
 }
 
-u16
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
 u16
 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 		   __be16 ox_id, wwn_t port_name, wwn_t node_name,
@@ -279,24 +241,6 @@ fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	return sizeof(struct fc_logi_s);
 }
 
-u16
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
 u16
 fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	       u16 ox_id, wwn_t port_name, wwn_t node_name,
@@ -545,18 +489,6 @@ fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
 	return FC_PARSE_OK;
 }
 
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
 enum fc_parse_status
 fc_abts_rsp_parse(struct fchs_s *fchs, int len)
 {
@@ -567,23 +499,6 @@ fc_abts_rsp_parse(struct fchs_s *fchs, int len)
 	return FC_PARSE_FAILURE;
 }
 
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
@@ -658,30 +573,6 @@ fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
 	return num_pages;
 }
 
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
@@ -706,20 +597,6 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 	return be16_to_cpu(prlo_acc->payload_len);
 }
 
-u16
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
 u16
 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 		  u32 s_id, __be16 ox_id, u32 data_format,
@@ -748,18 +625,6 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 
 }
 
-u16
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
 u16
 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 		u32 s_id, u32 *pid_list, u16 npids)
@@ -801,24 +666,6 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	return sizeof(struct fc_rpsc_acc_s);
 }
 
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
 u16
 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
 {
@@ -842,74 +689,6 @@ fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
 	return FC_PARSE_OK;
 }
 
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
@@ -973,22 +752,6 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	return sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s);
 }
 
-u16
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
 u16
 fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
 {
@@ -1034,26 +797,6 @@ fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 	return sizeof(struct fc_scr_s);
 }
 
-u16
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
-	return struct_size(rscn, event, 1);
-}
-
 u16
 fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       enum bfa_lport_role roles)
@@ -1078,26 +821,6 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
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
 u16
 fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       u8 fc4_type, u8 fc4_ftrs)
@@ -1181,24 +904,6 @@ fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 	return sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
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
 u16
 fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       wwn_t node_name)
@@ -1217,59 +922,6 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
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
index 49e0ee4a7334..26646106da4c 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -127,15 +127,6 @@ struct fc_templates_s {
 
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
@@ -148,14 +139,8 @@ u16        fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
 
 enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
 
-u16        fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
-			      u16 ox_id);
-
 enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
 
-u16        fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq, u32 d_id,
-			     u32 s_id, u16 ox_id, u16 rrq_oxid);
-
 u16        fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u16 ox_id, u8 *name);
 u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
@@ -164,10 +149,6 @@ u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
 u16        fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 			       u16 ox_id, enum bfa_lport_role role);
 
-u16       fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
-				   u16 ox_id, u8 *fc4_bitmap,
-				   u32 bitmap_size);
-
 u16	fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			u16 ox_id, u8 fc4_type, u8 fc4_ftrs);
 
@@ -216,10 +197,6 @@ u16        fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
 				  u32 s_id, __be16 ox_id,
 				  enum bfa_lport_role role);
 
-u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
-			      u32 d_id, u32 s_id, u16 ox_id,
-			      u32 data_format);
-
 u16        fc_rnid_acc_build(struct fchs_s *fchs,
 			struct fc_rnid_acc_s *rnid_acc, u32 d_id, u32 s_id,
 			__be16 ox_id, u32 data_format,
@@ -228,29 +205,15 @@ u16        fc_rnid_acc_build(struct fchs_s *fchs,
 
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
 
@@ -280,33 +243,15 @@ u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 
 int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
 
-u16 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
-
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
 		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
-u16 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name,
-		u16 pdu_size);
-
 u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
 
-u16 fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, int num_pages);
-
 u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 		u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
 		u32 tpr_id);
 
-u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		__be16 ox_id, u32 reason_code, u32 reason_expl);
-
-u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-		u32 port_id);
-
 u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
 
-u16 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn, u32 s_id,
-		u16 ox_id);
 #endif
-- 
2.47.0

