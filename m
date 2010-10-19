From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/6] bfa: remove os wrapper and unused functions
Date: Mon, 18 Oct 2010 17:08:54 -0700
Message-ID: <1287446934-26971-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43478 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab0JSAJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:09:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch removes os wrapper and unused functions. 
bfa_os_assign(), bfa_os_memset(), bfa_os_memcpy(), bfa_os_udelay()
bfa_os_vsprintf(), bfa_os_snprintf(), and bfa_os_get_clock() are replaced with
direct assignment or native linux functions. Some unused functions related to VF 
(Vitual fabric) are also removed.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c      |    8 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |  102 ++++++++++----------
 drivers/scsi/bfa/bfa_fcpim.c     |   29 +++---
 drivers/scsi/bfa/bfa_fcs.c       |  199 +-------------------------------------
 drivers/scsi/bfa/bfa_fcs.h       |   13 ---
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    4 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |   22 ++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    4 +-
 drivers/scsi/bfa/bfa_ioc.c       |   30 +++---
 drivers/scsi/bfa/bfa_ioc.h       |    2 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |    4 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |    6 +-
 drivers/scsi/bfa/bfa_os_inc.h    |   23 -----
 drivers/scsi/bfa/bfa_svc.c       |   62 ++++++------
 drivers/scsi/bfa/bfad.c          |   24 -----
 15 files changed, 136 insertions(+), 396 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index c2fa07f..4d0530b 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -440,7 +440,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	iocfc->bfa = bfa;
 	iocfc->action = BFA_IOCFC_ACT_NONE;
 
-	bfa_os_assign(iocfc->cfg, *cfg);
+	iocfc->cfg = *cfg;
 
 	/**
 	 * Initialize chip specific handlers.
@@ -503,13 +503,13 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
 		iocfc->req_cq_ba[i].kva = dm_kva;
 		iocfc->req_cq_ba[i].pa = dm_pa;
-		bfa_os_memset(dm_kva, 0, per_reqq_sz);
+		memset(dm_kva, 0, per_reqq_sz);
 		dm_kva += per_reqq_sz;
 		dm_pa += per_reqq_sz;
 
 		iocfc->rsp_cq_ba[i].kva = dm_kva;
 		iocfc->rsp_cq_ba[i].pa = dm_pa;
-		bfa_os_memset(dm_kva, 0, per_rspq_sz);
+		memset(dm_kva, 0, per_rspq_sz);
 		dm_kva += per_rspq_sz;
 		dm_pa += per_rspq_sz;
 	}
@@ -1038,7 +1038,7 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 
 	bfa_assert((cfg != NULL) && (meminfo != NULL));
 
-	bfa_os_memset((void *)meminfo, 0, sizeof(struct bfa_meminfo_s));
+	memset((void *)meminfo, 0, sizeof(struct bfa_meminfo_s));
 	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_type =
 		BFA_MEM_TYPE_KVA;
 	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_type =
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index b7d2657..7e7c14b 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -137,7 +137,7 @@ fcbuild_init(void)
 static void
 fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 {
-	bfa_os_memset(fchs, 0, sizeof(struct fchs_s));
+	memset(fchs, 0, sizeof(struct fchs_s));
 
 	fchs->routing = FC_RTG_FC4_DEV_DATA;
 	fchs->cat_info = FC_CAT_UNSOLICIT_CTRL;
@@ -159,7 +159,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 void
 fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
-	bfa_os_memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
+	memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = (d_id);
 	fchs->s_id = (s_id);
 	fchs->ox_id = bfa_os_htons(ox_id);
@@ -168,7 +168,7 @@ fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 static void
 fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
-	bfa_os_memcpy(fchs, &fc_els_rsp_tmpl, sizeof(struct fchs_s));
+	memcpy(fchs, &fc_els_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
 	fchs->s_id = s_id;
 	fchs->ox_id = ox_id;
@@ -198,7 +198,7 @@ fc_els_rsp_parse(struct fchs_s *fchs, int len)
 static void
 fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
-	bfa_os_memcpy(fchs, &fc_bls_rsp_tmpl, sizeof(struct fchs_s));
+	memcpy(fchs, &fc_bls_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
 	fchs->s_id = s_id;
 	fchs->ox_id = ox_id;
@@ -211,7 +211,7 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 {
 	struct fc_logi_s *plogi = (struct fc_logi_s *) (pld);
 
-	bfa_os_memcpy(plogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+	memcpy(plogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 
 	plogi->els_cmd.els_code = els_code;
 	if (els_code == FC_ELS_PLOGI)
@@ -221,8 +221,8 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 
 	plogi->csp.rxsz = plogi->class3.rxsz = bfa_os_htons(pdu_size);
 
-	bfa_os_memcpy(&plogi->port_name, &port_name, sizeof(wwn_t));
-	bfa_os_memcpy(&plogi->node_name, &node_name, sizeof(wwn_t));
+	memcpy(&plogi->port_name, &port_name, sizeof(wwn_t));
+	memcpy(&plogi->node_name, &node_name, sizeof(wwn_t));
 
 	return sizeof(struct fc_logi_s);
 }
@@ -235,7 +235,7 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
 	u32	*vvl_info;
 
-	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 
 	flogi->els_cmd.els_code = FC_ELS_FLOGI;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
@@ -272,7 +272,7 @@ fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 {
 	u32        d_id = 0;
 
-	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
 	flogi->els_cmd.els_code = FC_ELS_ACC;
@@ -291,7 +291,7 @@ fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 {
 	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
 
-	bfa_os_memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
+	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 
 	flogi->els_cmd.els_code = FC_ELS_FDISC;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
@@ -378,7 +378,7 @@ fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	struct fc_prli_s *prli = (struct fc_prli_s *) (pld);
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
+	memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
 
 	prli->command = FC_ELS_PRLI;
 	prli->parampage.servparams.initiator     = 1;
@@ -397,7 +397,7 @@ fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	struct fc_prli_s *prli = (struct fc_prli_s *) (pld);
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
+	memcpy(prli, &prli_tmpl, sizeof(struct fc_prli_s));
 
 	prli->command = FC_ELS_ACC;
 
@@ -448,7 +448,7 @@ fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(logo, '\0', sizeof(struct fc_logo_s));
+	memset(logo, '\0', sizeof(struct fc_logo_s));
 	logo->els_cmd.els_code = FC_ELS_LOGO;
 	logo->nport_id = (s_id);
 	logo->orig_port_name = port_name;
@@ -461,7 +461,7 @@ fc_adisc_x_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
 		 u32 s_id, u16 ox_id, wwn_t port_name,
 		 wwn_t node_name, u8 els_code)
 {
-	bfa_os_memset(adisc, '\0', sizeof(struct fc_adisc_s));
+	memset(adisc, '\0', sizeof(struct fc_adisc_s));
 
 	adisc->els_cmd.els_code = els_code;
 
@@ -554,7 +554,7 @@ fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
 u16
 fc_abts_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 {
-	bfa_os_memcpy(fchs, &fc_bls_req_tmpl, sizeof(struct fchs_s));
+	memcpy(fchs, &fc_bls_req_tmpl, sizeof(struct fchs_s));
 	fchs->cat_info = FC_CAT_ABTS;
 	fchs->d_id = (d_id);
 	fchs->s_id = (s_id);
@@ -582,7 +582,7 @@ fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id, u32 s_id,
 	/*
 	 * build rrq payload
 	 */
-	bfa_os_memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
+	memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
 	rrq->s_id = (s_id);
 	rrq->ox_id = bfa_os_htons(rrq_oxid);
 	rrq->rx_id = FC_RXID_ANY;
@@ -598,7 +598,7 @@ fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(acc, 0, sizeof(struct fc_els_cmd_s));
+	memset(acc, 0, sizeof(struct fc_els_cmd_s));
 	acc->els_code = FC_ELS_ACC;
 
 	return sizeof(struct fc_els_cmd_s);
@@ -610,7 +610,7 @@ fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt, u32 d_id,
 		u8 reason_code_expl)
 {
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memset(ls_rjt, 0, sizeof(struct fc_ls_rjt_s));
+	memset(ls_rjt, 0, sizeof(struct fc_ls_rjt_s));
 
 	ls_rjt->els_cmd.els_code = FC_ELS_LS_RJT;
 	ls_rjt->reason_code = reason_code;
@@ -626,7 +626,7 @@ fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 {
 	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memcpy(ba_acc, &ba_acc_tmpl, sizeof(struct fc_ba_acc_s));
+	memcpy(ba_acc, &ba_acc_tmpl, sizeof(struct fc_ba_acc_s));
 
 	fchs->rx_id = rx_id;
 
@@ -641,7 +641,7 @@ fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd, u32 d_id,
 		u32 s_id, u16 ox_id)
 {
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
+	memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
 	els_cmd->els_code = FC_ELS_ACC;
 
 	return sizeof(struct fc_els_cmd_s);
@@ -672,7 +672,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(tprlo_acc, 0, (num_pages * 16) + 4);
+	memset(tprlo_acc, 0, (num_pages * 16) + 4);
 	tprlo_acc->command = FC_ELS_ACC;
 
 	tprlo_acc->page_len = 0x10;
@@ -696,7 +696,7 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(prlo_acc, 0, (num_pages * 16) + 4);
+	memset(prlo_acc, 0, (num_pages * 16) + 4);
 	prlo_acc->command = FC_ELS_ACC;
 	prlo_acc->page_len = 0x10;
 	prlo_acc->payload_len = bfa_os_htons((num_pages * 16) + 4);
@@ -718,7 +718,7 @@ fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(rnid, 0, sizeof(struct fc_rnid_cmd_s));
+	memset(rnid, 0, sizeof(struct fc_rnid_cmd_s));
 
 	rnid->els_cmd.els_code = FC_ELS_RNID;
 	rnid->node_id_data_format = data_format;
@@ -732,7 +732,7 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 		  struct fc_rnid_common_id_data_s *common_id_data,
 		  struct fc_rnid_general_topology_data_s *gen_topo_data)
 {
-	bfa_os_memset(rnid_acc, 0, sizeof(struct fc_rnid_acc_s));
+	memset(rnid_acc, 0, sizeof(struct fc_rnid_acc_s));
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
@@ -745,7 +745,7 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 	if (data_format == RNID_NODEID_DATA_FORMAT_DISCOVERY) {
 		rnid_acc->specific_id_data_length =
 			sizeof(struct fc_rnid_general_topology_data_s);
-		bfa_os_assign(rnid_acc->gen_topology_data, *gen_topo_data);
+		rnid_acc->gen_topology_data = *gen_topo_data;
 		return sizeof(struct fc_rnid_acc_s);
 	} else {
 		return sizeof(struct fc_rnid_acc_s) -
@@ -760,7 +760,7 @@ fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
 {
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
+	memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
 
 	rpsc->els_cmd.els_code = FC_ELS_RPSC;
 	return sizeof(struct fc_rpsc_cmd_s);
@@ -775,7 +775,7 @@ fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 
 	fc_els_req_build(fchs, bfa_os_hton3b(dctlr_id), s_id, 0);
 
-	bfa_os_memset(rpsc2, 0, sizeof(struct fc_rpsc2_cmd_s));
+	memset(rpsc2, 0, sizeof(struct fc_rpsc2_cmd_s));
 
 	rpsc2->els_cmd.els_code = FC_ELS_RPSC;
 	rpsc2->token = bfa_os_htonl(FC_BRCD_TOKEN);
@@ -791,7 +791,7 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 		u32 d_id, u32 s_id, u16 ox_id,
 		  struct fc_rpsc_speed_info_s *oper_speed)
 {
-	bfa_os_memset(rpsc_acc, 0, sizeof(struct fc_rpsc_acc_s));
+	memset(rpsc_acc, 0, sizeof(struct fc_rpsc_acc_s));
 
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
@@ -830,7 +830,7 @@ fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 {
 	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
 
-	bfa_os_memcpy(pdisc, &plogi_tmpl, sizeof(struct fc_logi_s));
+	memcpy(pdisc, &plogi_tmpl, sizeof(struct fc_logi_s));
 
 	pdisc->els_cmd.els_code = FC_ELS_PDISC;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
@@ -873,7 +873,7 @@ fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 	int             page;
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memset(prlo, 0, (num_pages * 16) + 4);
+	memset(prlo, 0, (num_pages * 16) + 4);
 	prlo->command = FC_ELS_PRLO;
 	prlo->page_len = 0x10;
 	prlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
@@ -931,7 +931,7 @@ fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 	int             page;
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	bfa_os_memset(tprlo, 0, (num_pages * 16) + 4);
+	memset(tprlo, 0, (num_pages * 16) + 4);
 	tprlo->command = FC_ELS_TPRLO;
 	tprlo->page_len = 0x10;
 	tprlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
@@ -1011,7 +1011,7 @@ fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 static void
 fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 {
-	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	memset(cthdr, 0, sizeof(struct ct_hdr_s));
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_DIRSERVICE;
 	cthdr->gs_sub_type = CT_GSSUBTYPE_NAMESERVER;
@@ -1021,7 +1021,7 @@ fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 static void
 fc_gs_fdmi_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 {
-	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	memset(cthdr, 0, sizeof(struct ct_hdr_s));
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
 	cthdr->gs_sub_type = CT_GSSUBTYPE_HBA_MGMTSERVER;
@@ -1032,7 +1032,7 @@ static void
 fc_gs_ms_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code,
 					 u8 sub_type)
 {
-	bfa_os_memset(cthdr, 0, sizeof(struct ct_hdr_s));
+	memset(cthdr, 0, sizeof(struct ct_hdr_s));
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
 	cthdr->gs_sub_type = sub_type;
@@ -1050,7 +1050,7 @@ fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GID_PN);
 
-	bfa_os_memset(gidpn, 0, sizeof(struct fcgs_gidpn_req_s));
+	memset(gidpn, 0, sizeof(struct fcgs_gidpn_req_s));
 	gidpn->port_name = port_name;
 	return sizeof(struct fcgs_gidpn_req_s) + sizeof(struct ct_hdr_s);
 }
@@ -1066,7 +1066,7 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GPN_ID);
 
-	bfa_os_memset(gpnid, 0, sizeof(fcgs_gpnid_req_t));
+	memset(gpnid, 0, sizeof(fcgs_gpnid_req_t));
 	gpnid->dap = port_id;
 	return sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s);
 }
@@ -1082,7 +1082,7 @@ fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GNN_ID);
 
-	bfa_os_memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
+	memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
 	gnnid->dap = port_id;
 	return sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s);
 }
@@ -1108,7 +1108,7 @@ fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	bfa_os_memset(scr, 0, sizeof(struct fc_scr_s));
+	memset(scr, 0, sizeof(struct fc_scr_s));
 	scr->command = FC_ELS_SCR;
 	scr->reg_func = FC_SCR_REG_FUNC_FULL;
 	if (set_br_reg)
@@ -1149,7 +1149,7 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
 
-	bfa_os_memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
+	memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
 
 	rftid->dap = s_id;
 
@@ -1172,10 +1172,10 @@ fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
 
-	bfa_os_memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
+	memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
 
 	rftid->dap = s_id;
-	bfa_os_memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
+	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
 		(bitmap_size < 32 ? bitmap_size : 32));
 
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
@@ -1192,7 +1192,7 @@ fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RFF_ID);
 
-	bfa_os_memset(rffid, 0, sizeof(struct fcgs_rffid_req_s));
+	memset(rffid, 0, sizeof(struct fcgs_rffid_req_s));
 
 	rffid->dap	    = s_id;
 	rffid->fc4ftr_bits  = fc4_ftrs;
@@ -1214,7 +1214,7 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RSPN_ID);
 
-	bfa_os_memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
+	memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
 
 	rspnid->dap = s_id;
 	rspnid->spn_len = (u8) strlen((char *)name);
@@ -1235,7 +1235,7 @@ fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 
 	fc_gs_cthdr_build(cthdr, s_id, GS_GID_FT);
 
-	bfa_os_memset(gidft, 0, sizeof(struct fcgs_gidft_req_s));
+	memset(gidft, 0, sizeof(struct fcgs_gidft_req_s));
 	gidft->fc4_type = fc4_type;
 	gidft->domain_id = 0;
 	gidft->area_id = 0;
@@ -1254,7 +1254,7 @@ fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RPN_ID);
 
-	bfa_os_memset(rpnid, 0, sizeof(struct fcgs_rpnid_req_s));
+	memset(rpnid, 0, sizeof(struct fcgs_rpnid_req_s));
 	rpnid->port_id = port_id;
 	rpnid->port_name = port_name;
 
@@ -1272,7 +1272,7 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RNN_ID);
 
-	bfa_os_memset(rnnid, 0, sizeof(struct fcgs_rnnid_req_s));
+	memset(rnnid, 0, sizeof(struct fcgs_rnnid_req_s));
 	rnnid->port_id = port_id;
 	rnnid->node_name = node_name;
 
@@ -1291,7 +1291,7 @@ fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RCS_ID);
 
-	bfa_os_memset(rcsid, 0, sizeof(struct fcgs_rcsid_req_s));
+	memset(rcsid, 0, sizeof(struct fcgs_rcsid_req_s));
 	rcsid->port_id = port_id;
 	rcsid->cos = cos;
 
@@ -1309,7 +1309,7 @@ fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RPT_ID);
 
-	bfa_os_memset(rptid, 0, sizeof(struct fcgs_rptid_req_s));
+	memset(rptid, 0, sizeof(struct fcgs_rptid_req_s));
 	rptid->port_id = port_id;
 	rptid->port_type = port_type;
 
@@ -1326,7 +1326,7 @@ fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GA_NXT);
 
-	bfa_os_memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
+	memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
 	ganxt->port_id = port_id;
 
 	return sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s);
@@ -1383,7 +1383,7 @@ fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GMAL_CMD,
 			CT_GSSUBTYPE_CFGSERVER);
 
-	bfa_os_memset(gmal, 0, sizeof(fcgs_gmal_req_t));
+	memset(gmal, 0, sizeof(fcgs_gmal_req_t));
 	gmal->wwn = wwn;
 
 	return sizeof(struct ct_hdr_s) + sizeof(fcgs_gmal_req_t);
@@ -1403,7 +1403,7 @@ fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GFN_CMD,
 			CT_GSSUBTYPE_CFGSERVER);
 
-	bfa_os_memset(gfn, 0, sizeof(fcgs_gfn_req_t));
+	memset(gfn, 0, sizeof(fcgs_gfn_req_t));
 	gfn->wwn = wwn;
 
 	return sizeof(struct ct_hdr_s) + sizeof(fcgs_gfn_req_t);
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 33c8dd5..e9075a6 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -463,7 +463,7 @@ bfa_fcpim_port_iostats(struct bfa_s *bfa, struct bfa_itnim_iostats_s *stats,
 	struct bfa_itnim_s *itnim;
 
 	/* accumulate IO stats from itnim */
-	bfa_os_memset(stats, 0, sizeof(struct bfa_itnim_iostats_s));
+	memset(stats, 0, sizeof(struct bfa_itnim_iostats_s));
 	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
 		itnim = (struct bfa_itnim_s *) qe;
 		if (itnim->rport->rport_info.lp_tag != lp_tag)
@@ -480,7 +480,7 @@ bfa_fcpim_get_modstats(struct bfa_s *bfa, struct bfa_itnim_iostats_s *modstats)
 	struct bfa_itnim_s *itnim;
 
 	/* accumulate IO stats from itnim */
-	bfa_os_memset(modstats, 0, sizeof(struct bfa_itnim_iostats_s));
+	memset(modstats, 0, sizeof(struct bfa_itnim_iostats_s));
 	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
 		itnim = (struct bfa_itnim_s *) qe;
 		bfa_fcpim_add_stats(modstats, &(itnim->stats));
@@ -560,7 +560,7 @@ bfa_fcpim_clr_modstats(struct bfa_s *bfa)
 		itnim = (struct bfa_itnim_s *) qe;
 		bfa_itnim_clear_stats(itnim);
 	}
-	bfa_os_memset(&fcpim->del_itn_stats, 0,
+	memset(&fcpim->del_itn_stats, 0,
 		sizeof(struct bfa_fcpim_del_itn_stats_s));
 
 	return BFA_STATUS_OK;
@@ -1229,7 +1229,7 @@ bfa_itnim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	fcpim->itnim_arr = itnim;
 
 	for (i = 0; i < fcpim->num_itnims; i++, itnim++) {
-		bfa_os_memset(itnim, 0, sizeof(struct bfa_itnim_s));
+		memset(itnim, 0, sizeof(struct bfa_itnim_s));
 		itnim->bfa = bfa;
 		itnim->fcpim = fcpim;
 		itnim->reqq = BFA_REQQ_QOS_LO;
@@ -1597,8 +1597,8 @@ void
 bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
 {
 	int j;
-	bfa_os_memset(&itnim->stats, 0, sizeof(itnim->stats));
-	bfa_os_memset(&itnim->ioprofile, 0, sizeof(itnim->ioprofile));
+	memset(&itnim->stats, 0, sizeof(itnim->stats));
+	memset(&itnim->ioprofile, 0, sizeof(itnim->ioprofile));
 	for (j = 0; j < BFA_IOBUCKET_MAX; j++)
 		itnim->ioprofile.io_latency.min[j] = ~0;
 }
@@ -2390,11 +2390,10 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	/**
 	 * set up I/O command parameters
 	 */
-	bfa_os_assign(m->cmnd, cmnd_z0);
+	m->cmnd = cmnd_z0;
 	m->cmnd.lun = bfa_cb_ioim_get_lun(ioim->dio);
 	m->cmnd.iodir = bfa_cb_ioim_get_iodir(ioim->dio);
-	bfa_os_assign(m->cmnd.cdb,
-			*(scsi_cdb_t *)bfa_cb_ioim_get_cdb(ioim->dio));
+	m->cmnd.cdb = *(scsi_cdb_t *)bfa_cb_ioim_get_cdb(ioim->dio);
 	fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
 	m->cmnd.fcp_dl = bfa_os_htonl(fcp_dl);
 
@@ -2433,7 +2432,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	m->cmnd.addl_cdb_len = (bfa_cb_ioim_get_cdblen(ioim->dio) -
 					FCP_CMND_CDB_LEN) / sizeof(u32);
 	if (m->cmnd.addl_cdb_len) {
-		bfa_os_memcpy(&m->cmnd.cdb + 1, (scsi_cdb_t *)
+		memcpy(&m->cmnd.cdb + 1, (scsi_cdb_t *)
 				bfa_cb_ioim_get_cdb(ioim->dio) + 1,
 				m->cmnd.addl_cdb_len * sizeof(u32));
 		fcp_cmnd_fcpdl(&m->cmnd) =
@@ -2706,7 +2705,7 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 		/*
 		 * initialize IOIM
 		 */
-		bfa_os_memset(ioim, 0, sizeof(struct bfa_ioim_s));
+		memset(ioim, 0, sizeof(struct bfa_ioim_s));
 		ioim->iotag   = i;
 		ioim->bfa     = fcpim->bfa;
 		ioim->fcpim   = fcpim;
@@ -2750,7 +2749,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	bfa_trc(ioim->bfa, rsp->reuse_io_tag);
 
 	if (bfa_sm_cmp_state(ioim, bfa_ioim_sm_active))
-		bfa_os_assign(ioim->iosp->comp_rspmsg, *m);
+		ioim->iosp->comp_rspmsg = *m;
 
 	switch (rsp->io_status) {
 	case BFI_IOIM_STS_OK:
@@ -2837,7 +2836,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 void
 bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 {
-	ioim->start_time = bfa_os_get_clock();
+	ioim->start_time = jiffies;
 }
 
 void
@@ -2845,7 +2844,7 @@ bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 {
 	u32 fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
 	u32 index = bfa_ioim_get_index(fcp_dl);
-	u64 end_time = bfa_os_get_clock();
+	u64 end_time = jiffies;
 	struct bfa_itnim_latency_s *io_lat =
 			&(ioim->itnim->ioprofile.io_latency);
 	u32 val = (u32)(end_time - ioim->start_time);
@@ -3507,7 +3506,7 @@ bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 		/*
 		 * initialize TSKIM
 		 */
-		bfa_os_memset(tskim, 0, sizeof(struct bfa_tskim_s));
+		memset(tskim, 0, sizeof(struct bfa_tskim_s));
 		tskim->tsk_tag = i;
 		tskim->bfa	= fcpim->bfa;
 		tskim->fcpim	= fcpim;
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 9cebbe3..2bb3a7a 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -978,7 +978,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	struct bfa_fcs_fabric_s *fabric;
 
 	fabric = &fcs->fabric;
-	bfa_os_memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
+	memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
 
 	/**
 	 * Initialize base fabric.
@@ -1418,129 +1418,6 @@ bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 }
 
 /**
- *  fcs_vf_api virtual fabrics API
- */
-
-/**
- * Enable VF mode.
- *
- * @param[in]		fcs		fcs module instance
- * @param[in]		vf_id		default vf_id of port, FC_VF_ID_NULL
- *					to use standard default vf_id of 1.
- *
- * @retval	BFA_STATUS_OK		vf mode is enabled
- * @retval	BFA_STATUS_BUSY		Port is active. Port must be disabled
- *					before VF mode can be enabled.
- */
-bfa_status_t
-bfa_fcs_vf_mode_enable(struct bfa_fcs_s *fcs, u16 vf_id)
-{
-	return BFA_STATUS_OK;
-}
-
-/**
- * Disable VF mode.
- *
- * @param[in]		fcs		fcs module instance
- *
- * @retval	BFA_STATUS_OK		vf mode is disabled
- * @retval	BFA_STATUS_BUSY		VFs are present and being used. All
- *					VFs must be deleted before disabling
- *					VF mode.
- */
-bfa_status_t
-bfa_fcs_vf_mode_disable(struct bfa_fcs_s *fcs)
-{
-	return BFA_STATUS_OK;
-}
-
-/**
- *  Create a new VF instance.
- *
- *  A new VF is created using the given VF configuration. A VF is identified
- *  by VF id. No duplicate VF creation is allowed with the same VF id. Once
- *  a VF is created, VF is automatically started after link initialization
- *  and EVFP exchange is completed.
- *
- *	param[in] vf	 -	FCS vf data structure. Memory is
- *				allocated by caller (driver)
- *	param[in] fcs	 -	FCS module
- *	param[in] vf_cfg -	VF configuration
- *	param[in] vf_drv -	Opaque handle back to the driver's
- *				virtual vf structure
- *
- *	retval BFA_STATUS_OK VF creation is successful
- *	retval BFA_STATUS_FAILED VF creation failed
- *	retval BFA_STATUS_EEXIST A VF exists with the given vf_id
- */
-bfa_status_t
-bfa_fcs_vf_create(bfa_fcs_vf_t *vf, struct bfa_fcs_s *fcs, u16 vf_id,
-		  struct bfa_lport_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
-{
-	bfa_trc(fcs, vf_id);
-	return BFA_STATUS_OK;
-}
-
-/**
- *	Use this function to delete a BFA VF object. VF object should
- *	be stopped before this function call.
- *
- *	param[in] vf - pointer to bfa_vf_t.
- *
- *	retval BFA_STATUS_OK	On vf deletion success
- *	retval BFA_STATUS_BUSY VF is not in a stopped state
- *	retval BFA_STATUS_INPROGRESS VF deletion in in progress
- */
-bfa_status_t
-bfa_fcs_vf_delete(bfa_fcs_vf_t *vf)
-{
-	bfa_trc(vf->fcs, vf->vf_id);
-	return BFA_STATUS_OK;
-}
-
-
-/**
- *	Returns attributes of the given VF.
- *
- *	param[in]	vf	pointer to bfa_vf_t.
- *	param[out] vf_attr	vf attributes returned
- *
- *	return None
- */
-void
-bfa_fcs_vf_get_attr(bfa_fcs_vf_t *vf, struct bfa_vf_attr_s *vf_attr)
-{
-	bfa_trc(vf->fcs, vf->vf_id);
-}
-
-/**
- *	Return statistics associated with the given vf.
- *
- *	param[in] vf		pointer to bfa_vf_t.
- *	param[out] vf_stats	vf statistics returned
- *
- *	@return None
- */
-void
-bfa_fcs_vf_get_stats(bfa_fcs_vf_t *vf, struct bfa_vf_stats_s *vf_stats)
-{
-	bfa_os_memcpy(vf_stats, &vf->stats, sizeof(struct bfa_vf_stats_s));
-}
-
-/**
- *	clear statistics associated with the given vf.
- *
- *	param[in]	vf	pointer to bfa_vf_t.
- *
- *	@return None
- */
-void
-bfa_fcs_vf_clear_stats(bfa_fcs_vf_t *vf)
-{
-	bfa_os_memset(&vf->stats, 0, sizeof(struct bfa_vf_stats_s));
-}
-
-/**
  *	Returns FCS vf structure for a given vf_id.
  *
  *	param[in]	vf_id - VF_ID
@@ -1559,80 +1436,6 @@ bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id)
 }
 
 /**
- *	Return the list of VFs configured.
- *
- *	param[in]	fcs	fcs module instance
- *	param[out]	vf_ids	returned list of vf_ids
- *	param[in,out]	nvfs	in:size of vf_ids array,
- *				out:total elements present,
- *				actual elements returned is limited by the size
- *
- *	return Driver VF structure
- */
-void
-bfa_fcs_vf_list(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs)
-{
-	bfa_trc(fcs, *nvfs);
-}
-
-/**
- *	Return the list of all VFs visible from fabric.
- *
- *	param[in]	fcs	fcs module instance
- *	param[out]	vf_ids	returned list of vf_ids
- *	param[in,out]	nvfs	in:size of vf_ids array,
- *				out:total elements present,
- *				actual elements returned is limited by the size
- *
- *	return Driver VF structure
- */
-void
-bfa_fcs_vf_list_all(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs)
-{
-	bfa_trc(fcs, *nvfs);
-}
-
-/**
- *	Return the list of local logical ports present in the given VF.
- *
- *	param[in]	vf	vf for which logical ports are returned
- *	param[out]	lpwwn	returned logical port wwn list
- *	param[in,out]	nlports	in:size of lpwwn list;
- *				out:total elements present,
- *				actual elements returned is limited by the size
- */
-void
-bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t lpwwn[], int *nlports)
-{
-	struct list_head	*qe;
-	struct bfa_fcs_vport_s *vport;
-	int	i;
-	struct bfa_fcs_s      *fcs;
-
-	if (vf == NULL || lpwwn == NULL || *nlports == 0)
-		return;
-
-	fcs = vf->fcs;
-
-	bfa_trc(fcs, vf->vf_id);
-	bfa_trc(fcs, (u32) *nlports);
-
-	i = 0;
-	lpwwn[i++] = vf->bport.port_cfg.pwwn;
-
-	list_for_each(qe, &vf->vport_q) {
-		if (i >= *nlports)
-			break;
-
-		vport = (struct bfa_fcs_vport_s *) qe;
-		lpwwn[i++] = vport->lport.port_cfg.pwwn;
-	}
-
-	bfa_trc(fcs, i);
-	*nlports = i;
-}
-
-/**
  * BFA FCS PPORT ( physical port)
  */
 static void
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index d75045d..e5ff919 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -680,19 +680,6 @@ void		bfa_fcs_start(struct bfa_fcs_s *fcs);
 /**
  * bfa fcs vf public functions
  */
-bfa_status_t bfa_fcs_vf_mode_enable(struct bfa_fcs_s *fcs, u16 vf_id);
-bfa_status_t bfa_fcs_vf_mode_disable(struct bfa_fcs_s *fcs);
-bfa_status_t bfa_fcs_vf_create(bfa_fcs_vf_t *vf, struct bfa_fcs_s *fcs,
-			       u16 vf_id, struct bfa_lport_cfg_s *port_cfg,
-			       struct bfad_vf_s *vf_drv);
-bfa_status_t bfa_fcs_vf_delete(bfa_fcs_vf_t *vf);
-void bfa_fcs_vf_list(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs);
-void bfa_fcs_vf_list_all(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs);
-void bfa_fcs_vf_get_attr(bfa_fcs_vf_t *vf, struct bfa_vf_attr_s *vf_attr);
-void bfa_fcs_vf_get_stats(bfa_fcs_vf_t *vf,
-			  struct bfa_vf_stats_s *vf_stats);
-void bfa_fcs_vf_clear_stats(bfa_fcs_vf_t *vf);
-void bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t vpwwn[], int *nports);
 bfa_fcs_vf_t *bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id);
 u16 bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
 
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 569dfef..faca5f3 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -736,7 +736,7 @@ bfa_fcs_itnim_stats_get(struct bfa_fcs_lport_s *port, wwn_t rpwwn,
 	if (itnim == NULL)
 		return BFA_STATUS_NO_FCPIM_NEXUS;
 
-	bfa_os_memcpy(stats, &itnim->stats, sizeof(struct bfa_itnim_stats_s));
+	memcpy(stats, &itnim->stats, sizeof(struct bfa_itnim_stats_s));
 
 	return BFA_STATUS_OK;
 }
@@ -753,7 +753,7 @@ bfa_fcs_itnim_stats_clear(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	if (itnim == NULL)
 		return BFA_STATUS_NO_FCPIM_NEXUS;
 
-	bfa_os_memset(&itnim->stats, 0, sizeof(struct bfa_itnim_stats_s));
+	memset(&itnim->stats, 0, sizeof(struct bfa_itnim_stats_s));
 	return BFA_STATUS_OK;
 }
 
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index b522bf3..6cee56f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -479,7 +479,7 @@ static void
 bfa_fs_port_get_gen_topo_data(struct bfa_fcs_lport_s *port,
 			struct fc_rnid_general_topology_data_s *gen_topo_data)
 {
-	bfa_os_memset(gen_topo_data, 0,
+	memset(gen_topo_data, 0,
 		      sizeof(struct fc_rnid_general_topology_data_s));
 
 	gen_topo_data->asso_type = bfa_os_htonl(RNID_ASSOCIATED_TYPE_HOST);
@@ -878,7 +878,7 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 	struct bfad_s *bfad = (struct bfad_s *)lport->fcs->bfad;
 	char    lpwwn_buf[BFA_STRING_32];
 
-	bfa_os_assign(lport->port_cfg, *port_cfg);
+	lport->port_cfg = *port_cfg;
 
 	lport->bfad_port = bfa_fcb_lport_new(lport->fcs->bfad, lport,
 					lport->port_cfg.roles,
@@ -1549,7 +1549,7 @@ bfa_fcs_lport_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fdmi->fcxp = fcxp;
 
 	pyld = bfa_fcxp_get_reqbuf(fcxp);
-	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+	memset(pyld, 0, FC_MAX_PDUSZ);
 
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_lport_get_fcid(port),
 				   FDMI_RHBA);
@@ -1861,7 +1861,7 @@ bfa_fcs_lport_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fdmi->fcxp = fcxp;
 
 	pyld = bfa_fcxp_get_reqbuf(fcxp);
-	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+	memset(pyld, 0, FC_MAX_PDUSZ);
 
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_lport_get_fcid(port),
 				   FDMI_RPRT);
@@ -2086,7 +2086,7 @@ bfa_fcs_lport_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	fdmi->fcxp = fcxp;
 
 	pyld = bfa_fcxp_get_reqbuf(fcxp);
-	bfa_os_memset(pyld, 0, FC_MAX_PDUSZ);
+	memset(pyld, 0, FC_MAX_PDUSZ);
 
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_lport_get_fcid(port),
 				   FDMI_RPA);
@@ -2170,7 +2170,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	struct bfa_fcs_lport_s *port = fdmi->ms->port;
 	struct bfa_fcs_driver_info_s  *driver_info = &port->fcs->driver_info;
 
-	bfa_os_memset(hba_attr, 0, sizeof(struct bfa_fcs_fdmi_hba_attr_s));
+	memset(hba_attr, 0, sizeof(struct bfa_fcs_fdmi_hba_attr_s));
 
 	bfa_ioc_get_adapter_manufacturer(&port->fcs->bfa->ioc,
 					hba_attr->manufacturer);
@@ -2215,7 +2215,7 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	struct bfa_fcs_driver_info_s  *driver_info = &port->fcs->driver_info;
 	struct bfa_port_attr_s pport_attr;
 
-	bfa_os_memset(port_attr, 0, sizeof(struct bfa_fcs_fdmi_port_attr_s));
+	memset(port_attr, 0, sizeof(struct bfa_fcs_fdmi_port_attr_s));
 
 	/*
 	 * get pport attributes from hal
@@ -3738,7 +3738,7 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	u8         symbl[256];
 	u8         *psymbl = &symbl[0];
 
-	bfa_os_memset(symbl, 0, sizeof(symbl));
+	memset(symbl, 0, sizeof(symbl));
 
 	bfa_trc(port->fcs, port->port_cfg.pwwn);
 
@@ -4943,7 +4943,7 @@ bfa_fcs_lport_get_stats(struct bfa_fcs_lport_s *fcs_port,
 void
 bfa_fcs_lport_clear_stats(struct bfa_fcs_lport_s *fcs_port)
 {
-	bfa_os_memset(&fcs_port->stats, 0, sizeof(struct bfa_lport_stats_s));
+	memset(&fcs_port->stats, 0, sizeof(struct bfa_lport_stats_s));
 }
 
 /**
@@ -5672,7 +5672,7 @@ bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 	if (vport == NULL || attr == NULL)
 		return;
 
-	bfa_os_memset(attr, 0, sizeof(struct bfa_vport_attr_s));
+	memset(attr, 0, sizeof(struct bfa_vport_attr_s));
 
 	bfa_fcs_lport_get_attr(&vport->lport, &attr->port_attr);
 	attr->vport_state = bfa_sm_to_state(vport_sm_table, vport->sm);
@@ -5703,7 +5703,7 @@ bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
 void
 bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport)
 {
-	bfa_os_memset(&vport->vport_stats, 0, sizeof(struct bfa_vport_stats_s));
+	memset(&vport->vport_stats, 0, sizeof(struct bfa_vport_stats_s));
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 635f0cd..a6872d3 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2674,7 +2674,7 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 	bfa_fcs_lport_t *port = rport->port;
 	bfa_port_speed_t rport_speed = rport->rpf.rpsc_speed;
 
-	bfa_os_memset(rport_attr, 0, sizeof(struct bfa_rport_attr_s));
+	memset(rport_attr, 0, sizeof(struct bfa_rport_attr_s));
 
 	rport_attr->pid = rport->pid;
 	rport_attr->pwwn = rport->pwwn;
@@ -2717,7 +2717,7 @@ bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
 void
 bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport)
 {
-	bfa_os_memset((char *)&rport->stats, 0,
+	memset((char *)&rport->stats, 0,
 			sizeof(struct bfa_rport_stats_s));
 }
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 6795b24..bd25fc2 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1133,7 +1133,7 @@ bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
 
 	while (r32 && (cnt < BFA_SEM_SPINCNT)) {
 		cnt++;
-		bfa_os_udelay(2);
+		udelay(2);
 		r32 = bfa_reg_read(sem_reg);
 	}
 
@@ -2293,7 +2293,7 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	bfa_ioc_get_adapter_fw_ver(ioc, ad_attr->fw_ver);
 	bfa_ioc_get_adapter_optrom_ver(ioc, ad_attr->optrom_ver);
 	bfa_ioc_get_adapter_manufacturer(ioc, ad_attr->manufacturer);
-	bfa_os_memcpy(&ad_attr->vpd, &ioc_attr->vpd,
+	memcpy(&ad_attr->vpd, &ioc_attr->vpd,
 		      sizeof(struct bfa_mfg_vpd_s));
 
 	ad_attr->nports = bfa_ioc_get_nports(ioc);
@@ -2343,8 +2343,8 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
 {
-	bfa_os_memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
-	bfa_os_memcpy((void *)serial_num,
+	memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
+	memcpy((void *)serial_num,
 			(void *)ioc->attr->brcd_serialnum,
 			BFA_ADAPTER_SERIAL_NUM_LEN);
 }
@@ -2352,8 +2352,8 @@ bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
 void
 bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver)
 {
-	bfa_os_memset((void *)fw_ver, 0, BFA_VERSION_LEN);
-	bfa_os_memcpy(fw_ver, ioc->attr->fw_version, BFA_VERSION_LEN);
+	memset((void *)fw_ver, 0, BFA_VERSION_LEN);
+	memcpy(fw_ver, ioc->attr->fw_version, BFA_VERSION_LEN);
 }
 
 void
@@ -2361,7 +2361,7 @@ bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev)
 {
 	bfa_assert(chip_rev);
 
-	bfa_os_memset((void *)chip_rev, 0, BFA_IOC_CHIP_REV_LEN);
+	memset((void *)chip_rev, 0, BFA_IOC_CHIP_REV_LEN);
 
 	chip_rev[0] = 'R';
 	chip_rev[1] = 'e';
@@ -2374,16 +2374,16 @@ bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev)
 void
 bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver)
 {
-	bfa_os_memset((void *)optrom_ver, 0, BFA_VERSION_LEN);
-	bfa_os_memcpy(optrom_ver, ioc->attr->optrom_version,
+	memset((void *)optrom_ver, 0, BFA_VERSION_LEN);
+	memcpy(optrom_ver, ioc->attr->optrom_version,
 		      BFA_VERSION_LEN);
 }
 
 void
 bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
 {
-	bfa_os_memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
-	bfa_os_memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+	memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
+	memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
 }
 
 void
@@ -2392,14 +2392,14 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 	struct bfi_ioc_attr_s	*ioc_attr;
 
 	bfa_assert(model);
-	bfa_os_memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
+	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
 
 	ioc_attr = ioc->attr;
 
 	/**
 	 * model name
 	 */
-	bfa_os_snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
+	snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
 		BFA_MFG_NAME, ioc_attr->card_type);
 }
 
@@ -2446,7 +2446,7 @@ bfa_ioc_get_state(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 {
-	bfa_os_memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
+	memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
 
 	ioc_attr->state = bfa_ioc_get_state(ioc);
 	ioc_attr->port_id = ioc->port_id;
@@ -2541,7 +2541,7 @@ bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 	if (tlen > ioc->dbg_fwsave_len)
 		tlen = ioc->dbg_fwsave_len;
 
-	bfa_os_memcpy(trcdata, ioc->dbg_fwsave, tlen);
+	memcpy(trcdata, ioc->dbg_fwsave, tlen);
 	*trclen = tlen;
 	return BFA_STATUS_OK;
 }
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 288c580..97e1b16 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -267,7 +267,7 @@ struct bfa_ioc_hwif_s {
 #define bfa_ioc_fetch_stats(__ioc, __stats) \
 		(((__stats)->drv_stats) = (__ioc)->stats)
 #define bfa_ioc_clr_stats(__ioc)	\
-		bfa_os_memset(&(__ioc)->stats, 0, sizeof((__ioc)->stats))
+		memset(&(__ioc)->stats, 0, sizeof((__ioc)->stats))
 #define bfa_ioc_maxfrsize(__ioc)	((__ioc)->attr->maxfrsize)
 #define bfa_ioc_rx_bbcredit(__ioc)	((__ioc)->attr->rx_bbcredit)
 #define bfa_ioc_speed_sup(__ioc)	\
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index d7ac864..a32c860 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -217,7 +217,7 @@ bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
 			  __APP_PLL_400_BYPASS |
 			  __APP_PLL_400_LOGIC_SOFT_RESET);
-	bfa_os_udelay(2);
+	udelay(2);
 	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
 			  __APP_PLL_212_LOGIC_SOFT_RESET);
 	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
@@ -226,7 +226,7 @@ bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 			  pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
 	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
 			  pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
-	bfa_os_udelay(2000);
+	udelay(2000);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + APP_PLL_212_CTL_REG), pll_sclk);
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index f21b82c..5008afe 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -381,7 +381,7 @@ bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
 		__APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE);
 	bfa_reg_read(rb + HOSTFN0_INT_MSK);
-	bfa_os_udelay(2000);
+	udelay(2000);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
 	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
@@ -395,14 +395,14 @@ bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 	r32 = bfa_reg_read((rb + PSS_CTL_REG));
 	r32 &= ~__PSS_LMEM_RESET;
 	bfa_reg_write((rb + PSS_CTL_REG), r32);
-	bfa_os_udelay(1000);
+	udelay(1000);
 	if (!fcmode) {
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), 0);
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), 0);
 	}
 
 	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
-	bfa_os_udelay(1000);
+	udelay(1000);
 	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
 	bfa_reg_write((rb + MBIST_CTL_REG), 0);
 	return BFA_STATUS_OK;
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index 788a250..a79a443 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -15,10 +15,6 @@
  * General Public License for more details.
  */
 
-/**
- * Contains declarations all OS Specific files needed for BFA layer
- */
-
 #ifndef __BFA_OS_INC_H__
 #define __BFA_OS_INC_H__
 
@@ -44,11 +40,6 @@
 #define __BIGENDIAN
 #endif
 
-static inline u64 bfa_os_get_clock(void)
-{
-	return jiffies;
-}
-
 static inline u64 bfa_os_get_log_time(void)
 {
 	u64 system_time = 0;
@@ -63,13 +54,6 @@ static inline u64 bfa_os_get_log_time(void)
 #define bfa_io_lat_clock_res_div HZ
 #define bfa_io_lat_clock_res_mul 1000
 
-#define BFA_ASSERT(p) do {						\
-	if (!(p)) {      \
-		printk(KERN_ERR "assert(%s) failed at %s:%d\n",		\
-		#p, __FILE__, __LINE__);      \
-	}								\
-} while (0)
-
 #define BFA_LOG(level, bfad, mask, fmt, arg...)				\
 do {									\
 	if (((mask) == 4) || (level[1] <= '4'))				\
@@ -134,13 +118,6 @@ do {									\
 
 #define bfa_os_u32(__pa64) ((__pa64) >> 32)
 
-#define bfa_os_memset	memset
-#define bfa_os_memcpy	memcpy
-#define bfa_os_udelay	udelay
-#define bfa_os_vsprintf vsprintf
-#define bfa_os_snprintf snprintf
-
-#define bfa_os_assign(__t, __s) __t = __s
 #define bfa_os_addr_t void __iomem *
 
 #define bfa_os_reg_read(_raddr) readl(_raddr)
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index aa1dc74..ee0701f 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -330,7 +330,7 @@ bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 
 	pl_recp = &(plog->plog_recs[tail]);
 
-	bfa_os_memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
+	memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
 
 	pl_recp->tv = bfa_os_get_log_time();
 	BFA_PL_LOG_REC_INCR(plog->tail);
@@ -342,9 +342,9 @@ bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 void
 bfa_plog_init(struct bfa_plog_s *plog)
 {
-	bfa_os_memset((char *)plog, 0, sizeof(struct bfa_plog_s));
+	memset((char *)plog, 0, sizeof(struct bfa_plog_s));
 
-	bfa_os_memcpy(plog->plog_sig, BFA_PL_SIG_STR, BFA_PL_SIG_LEN);
+	memcpy(plog->plog_sig, BFA_PL_SIG_STR, BFA_PL_SIG_LEN);
 	plog->head = plog->tail = 0;
 	plog->plog_enabled = 1;
 }
@@ -357,7 +357,7 @@ bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	struct bfa_plog_rec_s  lp;
 
 	if (plog->plog_enabled) {
-		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
 		lp.mid = mid;
 		lp.eid = event;
 		lp.log_type = BFA_PL_LOG_TYPE_STRING;
@@ -381,15 +381,14 @@ bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 		num_ints = BFA_PL_INT_LOG_SZ;
 
 	if (plog->plog_enabled) {
-		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
 		lp.mid = mid;
 		lp.eid = event;
 		lp.log_type = BFA_PL_LOG_TYPE_INT;
 		lp.misc = misc;
 
 		for (i = 0; i < num_ints; i++)
-			bfa_os_assign(lp.log_entry.int_log[i],
-					intarr[i]);
+			lp.log_entry.int_log[i] = intarr[i];
 
 		lp.log_num_ints = (u8) num_ints;
 
@@ -407,7 +406,7 @@ bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	u32	ints[BFA_PL_INT_LOG_SZ];
 
 	if (plog->plog_enabled) {
-		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
 
 		ints[0] = tmp_int[0];
 		ints[1] = tmp_int[1];
@@ -427,7 +426,7 @@ bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	u32	ints[BFA_PL_INT_LOG_SZ];
 
 	if (plog->plog_enabled) {
-		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
 
 		ints[0] = tmp_int[0];
 		ints[1] = tmp_int[1];
@@ -485,7 +484,7 @@ claim_fcxp_req_rsp_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
 	mod->req_pld_list_pa = dm_pa;
 	dm_kva += buf_pool_sz;
 	dm_pa += buf_pool_sz;
-	bfa_os_memset(mod->req_pld_list_kva, 0, buf_pool_sz);
+	memset(mod->req_pld_list_kva, 0, buf_pool_sz);
 
 	/*
 	 * Initialize the fcxp rsp payload list
@@ -495,7 +494,7 @@ claim_fcxp_req_rsp_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
 	mod->rsp_pld_list_pa = dm_pa;
 	dm_kva += buf_pool_sz;
 	dm_pa += buf_pool_sz;
-	bfa_os_memset(mod->rsp_pld_list_kva, 0, buf_pool_sz);
+	memset(mod->rsp_pld_list_kva, 0, buf_pool_sz);
 
 	bfa_meminfo_dma_virt(mi) = dm_kva;
 	bfa_meminfo_dma_phys(mi) = dm_pa;
@@ -508,7 +507,7 @@ claim_fcxps_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
 	struct bfa_fcxp_s *fcxp;
 
 	fcxp = (struct bfa_fcxp_s *) bfa_meminfo_kva(mi);
-	bfa_os_memset(fcxp, 0, sizeof(struct bfa_fcxp_s) * mod->num_fcxps);
+	memset(fcxp, 0, sizeof(struct bfa_fcxp_s) * mod->num_fcxps);
 
 	INIT_LIST_HEAD(&mod->fcxp_free_q);
 	INIT_LIST_HEAD(&mod->fcxp_active_q);
@@ -559,7 +558,7 @@ bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 {
 	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
 
-	bfa_os_memset(mod, 0, sizeof(struct bfa_fcxp_mod_s));
+	memset(mod, 0, sizeof(struct bfa_fcxp_mod_s));
 	mod->bfa = bfa;
 	mod->num_fcxps = cfg->fwcfg.num_fcxp_reqs;
 
@@ -1479,7 +1478,7 @@ bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_lps_s	*lps;
 	int			i;
 
-	bfa_os_memset(mod, 0, sizeof(struct bfa_lps_mod_s));
+	memset(mod, 0, sizeof(struct bfa_lps_mod_s));
 	mod->num_lps = BFA_LPS_MAX_LPORTS;
 	if (cfg->drvcfg.min_cfg)
 		mod->num_lps = BFA_LPS_MIN_LPORTS;
@@ -2909,7 +2908,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_fcport_ln_s *ln = &fcport->ln;
 	struct bfa_timeval_s tv;
 
-	bfa_os_memset(fcport, 0, sizeof(struct bfa_fcport_s));
+	memset(fcport, 0, sizeof(struct bfa_fcport_s));
 	fcport->bfa = bfa;
 	ln->fcport = fcport;
 
@@ -2986,9 +2985,8 @@ bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 		fcport->myalpa = 0;
 
 	/* QoS Details */
-	bfa_os_assign(fcport->qos_attr, pevent->link_state.qos_attr);
-	bfa_os_assign(fcport->qos_vc_attr,
-		pevent->link_state.vc_fcf.qos_vc_attr);
+	fcport->qos_attr = pevent->link_state.qos_attr;
+	fcport->qos_vc_attr = pevent->link_state.vc_fcf.qos_vc_attr;
 
 	/**
 	 * update trunk state if applicable
@@ -3223,7 +3221,7 @@ bfa_fcport_send_stats_get(void *cbarg)
 	}
 	fcport->stats_qfull = BFA_FALSE;
 
-	bfa_os_memset(msg, 0, sizeof(struct bfi_fcport_req_s));
+	memset(msg, 0, sizeof(struct bfi_fcport_req_s));
 	bfi_h2i_set(msg->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_STATS_GET_REQ,
 			bfa_lpuid(fcport->bfa));
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
@@ -3285,7 +3283,7 @@ bfa_fcport_send_stats_clear(void *cbarg)
 	}
 	fcport->stats_qfull = BFA_FALSE;
 
-	bfa_os_memset(msg, 0, sizeof(struct bfi_fcport_req_s));
+	memset(msg, 0, sizeof(struct bfi_fcport_req_s));
 	bfi_h2i_set(msg->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_STATS_CLEAR_REQ,
 			bfa_lpuid(fcport->bfa));
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
@@ -3729,7 +3727,7 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	bfa_os_memset(attr, 0, sizeof(struct bfa_port_attr_s));
+	memset(attr, 0, sizeof(struct bfa_port_attr_s));
 
 	attr->nwwn = fcport->nwwn;
 	attr->pwwn = fcport->pwwn;
@@ -3737,7 +3735,7 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 	attr->factorypwwn =  bfa_ioc_get_mfg_pwwn(&bfa->ioc);
 	attr->factorynwwn =  bfa_ioc_get_mfg_nwwn(&bfa->ioc);
 
-	bfa_os_memcpy(&attr->pport_cfg, &fcport->cfg,
+	memcpy(&attr->pport_cfg, &fcport->cfg,
 		sizeof(struct bfa_port_cfg_s));
 	/* speed attributes */
 	attr->pport_cfg.speed = fcport->cfg.speed;
@@ -4612,7 +4610,7 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		   !(mod->num_rports & (mod->num_rports - 1)));
 
 	for (i = 0; i < mod->num_rports; i++, rp++) {
-		bfa_os_memset(rp, 0, sizeof(struct bfa_rport_s));
+		memset(rp, 0, sizeof(struct bfa_rport_s));
 		rp->bfa = bfa;
 		rp->rport_tag = i;
 		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
@@ -4858,7 +4856,7 @@ bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 		rport_info->max_frmsz = FC_MIN_PDUSZ;
 	}
 
-	bfa_os_assign(rport->rport_info, *rport_info);
+	rport->rport_info = *rport_info;
 	bfa_sm_send_event(rport, BFA_RPORT_SM_ONLINE);
 }
 
@@ -4897,7 +4895,7 @@ bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
 void
 bfa_rport_clear_stats(struct bfa_rport_s *rport)
 {
-	bfa_os_memset(&rport->stats, 0, sizeof(rport->stats));
+	memset(&rport->stats, 0, sizeof(rport->stats));
 }
 
 
@@ -4957,8 +4955,8 @@ bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_assert(!(sgpg_pa.pa & (sizeof(struct bfi_sgpg_s) - 1)));
 
 	for (i = 0; i < mod->num_sgpgs; i++) {
-		bfa_os_memset(hsgpg, 0, sizeof(*hsgpg));
-		bfa_os_memset(sgpg, 0, sizeof(*sgpg));
+		memset(hsgpg, 0, sizeof(*hsgpg));
+		memset(sgpg, 0, sizeof(*sgpg));
 
 		hsgpg->sgpg = sgpg;
 		sgpg_pa_tmp.pa = bfa_sgaddr_le(sgpg_pa.pa);
@@ -5136,7 +5134,7 @@ claim_uf_pbs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 	bfa_meminfo_dma_virt(mi) += uf_pb_tot_sz;
 	bfa_meminfo_dma_phys(mi) += uf_pb_tot_sz;
 
-	bfa_os_memset((void *)ufm->uf_pbs_kva, 0, uf_pb_tot_sz);
+	memset((void *)ufm->uf_pbs_kva, 0, uf_pb_tot_sz);
 }
 
 static void
@@ -5153,7 +5151,7 @@ claim_uf_post_msgs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 
 	for (i = 0, uf_bp_msg = ufm->uf_buf_posts; i < ufm->num_ufs;
 	     i++, uf_bp_msg++) {
-		bfa_os_memset(uf_bp_msg, 0, sizeof(struct bfi_uf_buf_post_s));
+		memset(uf_bp_msg, 0, sizeof(struct bfi_uf_buf_post_s));
 
 		uf_bp_msg->buf_tag = i;
 		buf_len = sizeof(struct bfa_uf_buf_s);
@@ -5194,7 +5192,7 @@ claim_ufs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 	 * Initialize UFs and queue it in UF free queue
 	 */
 	for (i = 0, uf = ufm->uf_list; i < ufm->num_ufs; i++, uf++) {
-		bfa_os_memset(uf, 0, sizeof(struct bfa_uf_s));
+		memset(uf, 0, sizeof(struct bfa_uf_s));
 		uf->bfa = ufm->bfa;
 		uf->uf_tag = i;
 		uf->pb_len = sizeof(struct bfa_uf_buf_s);
@@ -5241,7 +5239,7 @@ bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 {
 	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
 
-	bfa_os_memset(ufm, 0, sizeof(struct bfa_uf_mod_s));
+	memset(ufm, 0, sizeof(struct bfa_uf_mod_s));
 	ufm->bfa = bfa;
 	ufm->num_ufs = cfg->fwcfg.num_uf_bufs;
 	INIT_LIST_HEAD(&ufm->uf_free_q);
@@ -5279,7 +5277,7 @@ bfa_uf_post(struct bfa_uf_mod_s *ufm, struct bfa_uf_s *uf)
 	if (!uf_post_msg)
 		return BFA_STATUS_FAILED;
 
-	bfa_os_memcpy(uf_post_msg, &ufm->uf_buf_posts[uf->uf_tag],
+	memcpy(uf_post_msg, &ufm->uf_buf_posts[uf->uf_tag],
 		      sizeof(struct bfi_uf_buf_post_s));
 	bfa_reqq_produce(ufm->bfa, BFA_REQQ_FCXP);
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 4d8784e..d3966bc 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -716,30 +716,6 @@ ext:
 	return rc;
 }
 
-/**
- * Create a vf and its base vport implicitely.
- */
-bfa_status_t
-bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
-	       struct bfa_lport_cfg_s *port_cfg)
-{
-	struct bfad_vf_s      *vf;
-	int		rc = BFA_STATUS_OK;
-
-	vf = kzalloc(sizeof(struct bfad_vf_s), GFP_KERNEL);
-	if (!vf) {
-		rc = BFA_STATUS_FAILED;
-		goto ext;
-	}
-
-	rc = bfa_fcs_vf_create(&vf->fcs_vf, &bfad->bfa_fcs, vf_id, port_cfg,
-			       vf);
-	if (rc != BFA_STATUS_OK)
-		kfree(vf);
-ext:
-	return rc;
-}
-
 void
 bfad_bfa_tmo(unsigned long data)
 {
-- 
1.6.5.2

