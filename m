From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/6] bfa: replace endian swap macros with the ones provided by linux
Date: Mon, 18 Oct 2010 17:10:50 -0700
Message-ID: <1287447050-27777-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:48537 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab0JSAK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:10:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch replaces endian swap macros with the ones provided by the linux.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim.h   |    2 +-
 drivers/scsi/bfa/bfa_core.c      |   26 +++++-----
 drivers/scsi/bfa/bfa_fcbuild.c   |   92 ++++++++++++++++----------------
 drivers/scsi/bfa/bfa_fcpim.c     |   22 ++++----
 drivers/scsi/bfa/bfa_fcs.c       |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |  108 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |   24 ++++----
 drivers/scsi/bfa/bfa_ioc.c       |   14 +++---
 drivers/scsi/bfa/bfa_ioc.h       |    4 +-
 drivers/scsi/bfa/bfa_os_inc.h    |   27 ---------
 drivers/scsi/bfa/bfa_port.c      |    8 ++--
 drivers/scsi/bfa/bfa_svc.c       |   64 +++++++++++-----------
 drivers/scsi/bfa/bfad_attr.c     |    8 ++--
 drivers/scsi/bfa/bfad_im.c       |    8 ++--
 14 files changed, 191 insertions(+), 218 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cb_ioim.h b/drivers/scsi/bfa/bfa_cb_ioim.h
index a989a94..78c5ba2 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim.h
@@ -37,7 +37,7 @@ bfad_int_to_lun(u32 luno)
 	} lun;
 
 	lun.bfa_lun     = 0;
-	lun.scsi_lun[0] = bfa_os_htons(luno);
+	lun.scsi_lun[0] = cpu_to_be16(luno);
 
 	return lun.bfa_lun;
 }
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 4d0530b..7366924 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -400,14 +400,14 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 		bfa_dma_be_addr_set(cfg_info->req_shadow_ci[i],
 				    iocfc->req_cq_shadow_ci[i].pa);
 		cfg_info->req_cq_elems[i] =
-			bfa_os_htons(cfg->drvcfg.num_reqq_elems);
+			cpu_to_be16(cfg->drvcfg.num_reqq_elems);
 
 		bfa_dma_be_addr_set(cfg_info->rsp_cq_ba[i],
 				    iocfc->rsp_cq_ba[i].pa);
 		bfa_dma_be_addr_set(cfg_info->rsp_shadow_pi[i],
 				    iocfc->rsp_cq_shadow_pi[i].pa);
 		cfg_info->rsp_cq_elems[i] =
-			bfa_os_htons(cfg->drvcfg.num_rspq_elems);
+			cpu_to_be16(cfg->drvcfg.num_rspq_elems);
 	}
 
 	/**
@@ -634,11 +634,11 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	struct bfa_iocfc_fwcfg_s	*fwcfg	 = &cfgrsp->fwcfg;
 
 	fwcfg->num_cqs	      = fwcfg->num_cqs;
-	fwcfg->num_ioim_reqs  = bfa_os_ntohs(fwcfg->num_ioim_reqs);
-	fwcfg->num_tskim_reqs = bfa_os_ntohs(fwcfg->num_tskim_reqs);
-	fwcfg->num_fcxp_reqs  = bfa_os_ntohs(fwcfg->num_fcxp_reqs);
-	fwcfg->num_uf_bufs    = bfa_os_ntohs(fwcfg->num_uf_bufs);
-	fwcfg->num_rports     = bfa_os_ntohs(fwcfg->num_rports);
+	fwcfg->num_ioim_reqs  = be16_to_cpu(fwcfg->num_ioim_reqs);
+	fwcfg->num_tskim_reqs = be16_to_cpu(fwcfg->num_tskim_reqs);
+	fwcfg->num_fcxp_reqs  = be16_to_cpu(fwcfg->num_fcxp_reqs);
+	fwcfg->num_uf_bufs    = be16_to_cpu(fwcfg->num_uf_bufs);
+	fwcfg->num_rports     = be16_to_cpu(fwcfg->num_rports);
 
 	iocfc->cfgdone = BFA_TRUE;
 
@@ -876,12 +876,12 @@ bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr)
 	attr->intr_attr.coalesce = iocfc->cfginfo->intr_attr.coalesce;
 
 	attr->intr_attr.delay = iocfc->cfginfo->intr_attr.delay ?
-				bfa_os_ntohs(iocfc->cfginfo->intr_attr.delay) :
-				bfa_os_ntohs(iocfc->cfgrsp->intr_attr.delay);
+				be16_to_cpu(iocfc->cfginfo->intr_attr.delay) :
+				be16_to_cpu(iocfc->cfgrsp->intr_attr.delay);
 
 	attr->intr_attr.latency = iocfc->cfginfo->intr_attr.latency ?
-			bfa_os_ntohs(iocfc->cfginfo->intr_attr.latency) :
-			bfa_os_ntohs(iocfc->cfgrsp->intr_attr.latency);
+			be16_to_cpu(iocfc->cfginfo->intr_attr.latency) :
+			be16_to_cpu(iocfc->cfgrsp->intr_attr.latency);
 
 	attr->config	= iocfc->cfg;
 }
@@ -893,8 +893,8 @@ bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
 	struct bfi_iocfc_set_intr_req_s *m;
 
 	iocfc->cfginfo->intr_attr.coalesce = attr->coalesce;
-	iocfc->cfginfo->intr_attr.delay = bfa_os_htons(attr->delay);
-	iocfc->cfginfo->intr_attr.latency = bfa_os_htons(attr->latency);
+	iocfc->cfginfo->intr_attr.delay = cpu_to_be16(attr->delay);
+	iocfc->cfginfo->intr_attr.latency = cpu_to_be16(attr->latency);
 
 	if (!bfa_iocfc_is_operational(bfa))
 		return BFA_STATUS_OK;
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 7e7c14b..85b0050 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -94,13 +94,13 @@ fcbuild_init(void)
 	 */
 	plogi_tmpl.csp.verhi = FC_PH_VER_PH_3;
 	plogi_tmpl.csp.verlo = FC_PH_VER_4_3;
-	plogi_tmpl.csp.bbcred = bfa_os_htons(0x0004);
+	plogi_tmpl.csp.bbcred = cpu_to_be16(0x0004);
 	plogi_tmpl.csp.ciro = 0x1;
 	plogi_tmpl.csp.cisc = 0x0;
 	plogi_tmpl.csp.altbbcred = 0x0;
-	plogi_tmpl.csp.conseq = bfa_os_htons(0x00FF);
-	plogi_tmpl.csp.ro_bitmap = bfa_os_htons(0x0002);
-	plogi_tmpl.csp.e_d_tov = bfa_os_htonl(2000);
+	plogi_tmpl.csp.conseq = cpu_to_be16(0x00FF);
+	plogi_tmpl.csp.ro_bitmap = cpu_to_be16(0x0002);
+	plogi_tmpl.csp.e_d_tov = cpu_to_be32(2000);
 
 	plogi_tmpl.class3.class_valid = 1;
 	plogi_tmpl.class3.sequential = 1;
@@ -112,7 +112,7 @@ fcbuild_init(void)
 	 */
 	prli_tmpl.command = FC_ELS_PRLI;
 	prli_tmpl.pglen = 0x10;
-	prli_tmpl.pagebytes = bfa_os_htons(0x0014);
+	prli_tmpl.pagebytes = cpu_to_be16(0x0014);
 	prli_tmpl.parampage.type = FC_TYPE_FCP;
 	prli_tmpl.parampage.imagepair = 1;
 	prli_tmpl.parampage.servparams.rxrdisab = 1;
@@ -148,7 +148,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 	fchs->rx_id = FC_RXID_ANY;
 	fchs->d_id = (d_id);
 	fchs->s_id = (s_id);
-	fchs->ox_id = bfa_os_htons(ox_id);
+	fchs->ox_id = cpu_to_be16(ox_id);
 
 	/**
 	 * @todo no need to set ox_id for request
@@ -162,7 +162,7 @@ fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 	memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = (d_id);
 	fchs->s_id = (s_id);
-	fchs->ox_id = bfa_os_htons(ox_id);
+	fchs->ox_id = cpu_to_be16(ox_id);
 }
 
 static void
@@ -219,7 +219,7 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	else
 		fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
-	plogi->csp.rxsz = plogi->class3.rxsz = bfa_os_htons(pdu_size);
+	plogi->csp.rxsz = plogi->class3.rxsz = cpu_to_be16(pdu_size);
 
 	memcpy(&plogi->port_name, &port_name, sizeof(wwn_t));
 	memcpy(&plogi->node_name, &node_name, sizeof(wwn_t));
@@ -240,7 +240,7 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	flogi->els_cmd.els_code = FC_ELS_FLOGI;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
 	flogi->port_name = port_name;
 	flogi->node_name = node_name;
 
@@ -253,14 +253,14 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	/* set AUTH capability */
 	flogi->csp.security = set_auth;
 
-	flogi->csp.bbcred = bfa_os_htons(local_bb_credits);
+	flogi->csp.bbcred = cpu_to_be16(local_bb_credits);
 
 	/* Set brcd token in VVL */
 	vvl_info = (u32 *)&flogi->vvl[0];
 
 	/* set the flag to indicate the presence of VVL */
 	flogi->csp.npiv_supp    = 1; /* @todo. field name is not correct */
-	vvl_info[0]	= bfa_os_htonl(FLOGI_VVL_BRCD);
+	vvl_info[0]	= cpu_to_be32(FLOGI_VVL_BRCD);
 
 	return sizeof(struct fc_logi_s);
 }
@@ -276,11 +276,11 @@ fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
 	flogi->els_cmd.els_code = FC_ELS_ACC;
-	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
 	flogi->port_name = port_name;
 	flogi->node_name = node_name;
 
-	flogi->csp.bbcred = bfa_os_htons(local_bb_credits);
+	flogi->csp.bbcred = cpu_to_be16(local_bb_credits);
 
 	return sizeof(struct fc_logi_s);
 }
@@ -296,7 +296,7 @@ fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	flogi->els_cmd.els_code = FC_ELS_FDISC;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);
+	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
 	flogi->port_name = port_name;
 	flogi->node_name = node_name;
 
@@ -346,7 +346,7 @@ fc_plogi_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
 		if (!plogi->class3.class_valid)
 			return FC_PARSE_FAILURE;
 
-		if (bfa_os_ntohs(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
+		if (be16_to_cpu(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
 			return FC_PARSE_FAILURE;
 
 		return FC_PARSE_OK;
@@ -363,8 +363,8 @@ fc_plogi_parse(struct fchs_s *fchs)
 	if (plogi->class3.class_valid != 1)
 		return FC_PARSE_FAILURE;
 
-	if ((bfa_os_ntohs(plogi->class3.rxsz) < FC_MIN_PDUSZ)
-	    || (bfa_os_ntohs(plogi->class3.rxsz) > FC_MAX_PDUSZ)
+	if ((be16_to_cpu(plogi->class3.rxsz) < FC_MIN_PDUSZ)
+	    || (be16_to_cpu(plogi->class3.rxsz) > FC_MAX_PDUSZ)
 	    || (plogi->class3.rxsz == 0))
 		return FC_PARSE_FAILURE;
 
@@ -537,7 +537,7 @@ fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
 	if (pdisc->class3.class_valid != 1)
 		return FC_PARSE_FAILURE;
 
-	if ((bfa_os_ntohs(pdisc->class3.rxsz) <
+	if ((be16_to_cpu(pdisc->class3.rxsz) <
 		(FC_MIN_PDUSZ - sizeof(struct fchs_s)))
 	    || (pdisc->class3.rxsz == 0))
 		return FC_PARSE_FAILURE;
@@ -558,7 +558,7 @@ fc_abts_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 	fchs->cat_info = FC_CAT_ABTS;
 	fchs->d_id = (d_id);
 	fchs->s_id = (s_id);
-	fchs->ox_id = bfa_os_htons(ox_id);
+	fchs->ox_id = cpu_to_be16(ox_id);
 
 	return sizeof(struct fchs_s);
 }
@@ -584,7 +584,7 @@ fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id, u32 s_id,
 	 */
 	memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
 	rrq->s_id = (s_id);
-	rrq->ox_id = bfa_os_htons(rrq_oxid);
+	rrq->ox_id = cpu_to_be16(rrq_oxid);
 	rrq->rx_id = FC_RXID_ANY;
 
 	return sizeof(struct fc_rrq_s);
@@ -656,10 +656,10 @@ fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
 
 	if (els_code == FC_ELS_PRLO) {
 		prlo = (struct fc_prlo_s *) (fc_frame + 1);
-		num_pages = (bfa_os_ntohs(prlo->payload_len) - 4) / 16;
+		num_pages = (be16_to_cpu(prlo->payload_len) - 4) / 16;
 	} else {
 		tprlo = (struct fc_tprlo_s *) (fc_frame + 1);
-		num_pages = (bfa_os_ntohs(tprlo->payload_len) - 4) / 16;
+		num_pages = (be16_to_cpu(tprlo->payload_len) - 4) / 16;
 	}
 	return num_pages;
 }
@@ -676,7 +676,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
 	tprlo_acc->command = FC_ELS_ACC;
 
 	tprlo_acc->page_len = 0x10;
-	tprlo_acc->payload_len = bfa_os_htons((num_pages * 16) + 4);
+	tprlo_acc->payload_len = cpu_to_be16((num_pages * 16) + 4);
 
 	for (page = 0; page < num_pages; page++) {
 		tprlo_acc->tprlo_acc_params[page].opa_valid = 0;
@@ -685,7 +685,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
 		tprlo_acc->tprlo_acc_params[page].orig_process_assc = 0;
 		tprlo_acc->tprlo_acc_params[page].resp_process_assc = 0;
 	}
-	return bfa_os_ntohs(tprlo_acc->payload_len);
+	return be16_to_cpu(tprlo_acc->payload_len);
 }
 
 u16
@@ -699,7 +699,7 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 	memset(prlo_acc, 0, (num_pages * 16) + 4);
 	prlo_acc->command = FC_ELS_ACC;
 	prlo_acc->page_len = 0x10;
-	prlo_acc->payload_len = bfa_os_htons((num_pages * 16) + 4);
+	prlo_acc->payload_len = cpu_to_be16((num_pages * 16) + 4);
 
 	for (page = 0; page < num_pages; page++) {
 		prlo_acc->prlo_acc_params[page].opa_valid = 0;
@@ -709,7 +709,7 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 		prlo_acc->prlo_acc_params[page].resp_process_assc = 0;
 	}
 
-	return bfa_os_ntohs(prlo_acc->payload_len);
+	return be16_to_cpu(prlo_acc->payload_len);
 }
 
 u16
@@ -778,8 +778,8 @@ fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 	memset(rpsc2, 0, sizeof(struct fc_rpsc2_cmd_s));
 
 	rpsc2->els_cmd.els_code = FC_ELS_RPSC;
-	rpsc2->token = bfa_os_htonl(FC_BRCD_TOKEN);
-	rpsc2->num_pids  = bfa_os_htons(npids);
+	rpsc2->token = cpu_to_be32(FC_BRCD_TOKEN);
+	rpsc2->num_pids  = cpu_to_be16(npids);
 	for (i = 0; i < npids; i++)
 		rpsc2->pid_list[i].pid = pid_list[i];
 
@@ -796,13 +796,13 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 
 	rpsc_acc->command = FC_ELS_ACC;
-	rpsc_acc->num_entries = bfa_os_htons(1);
+	rpsc_acc->num_entries = cpu_to_be16(1);
 
 	rpsc_acc->speed_info[0].port_speed_cap =
-		bfa_os_htons(oper_speed->port_speed_cap);
+		cpu_to_be16(oper_speed->port_speed_cap);
 
 	rpsc_acc->speed_info[0].port_op_speed =
-		bfa_os_htons(oper_speed->port_op_speed);
+		cpu_to_be16(oper_speed->port_op_speed);
 
 	return sizeof(struct fc_rpsc_acc_s);
 }
@@ -835,7 +835,7 @@ fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 	pdisc->els_cmd.els_code = FC_ELS_PDISC;
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
-	pdisc->csp.rxsz = pdisc->class3.rxsz = bfa_os_htons(pdu_size);
+	pdisc->csp.rxsz = pdisc->class3.rxsz = cpu_to_be16(pdu_size);
 	pdisc->port_name = port_name;
 	pdisc->node_name = node_name;
 
@@ -859,7 +859,7 @@ fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
 	if (!pdisc->class3.class_valid)
 		return FC_PARSE_NWWN_NOT_EQUAL;
 
-	if (bfa_os_ntohs(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
+	if (be16_to_cpu(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
 		return FC_PARSE_RXSZ_INVAL;
 
 	return FC_PARSE_OK;
@@ -876,7 +876,7 @@ fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 	memset(prlo, 0, (num_pages * 16) + 4);
 	prlo->command = FC_ELS_PRLO;
 	prlo->page_len = 0x10;
-	prlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
+	prlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
 
 	for (page = 0; page < num_pages; page++) {
 		prlo->prlo_params[page].type = FC_TYPE_FCP;
@@ -886,7 +886,7 @@ fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 		prlo->prlo_params[page].resp_process_assc = 0;
 	}
 
-	return bfa_os_ntohs(prlo->payload_len);
+	return be16_to_cpu(prlo->payload_len);
 }
 
 u16
@@ -901,7 +901,7 @@ fc_prlo_rsp_parse(struct fchs_s *fchs, int len)
 	if (prlo->command != FC_ELS_ACC)
 		return FC_PARSE_FAILURE;
 
-	num_pages = ((bfa_os_ntohs(prlo->payload_len)) - 4) / 16;
+	num_pages = ((be16_to_cpu(prlo->payload_len)) - 4) / 16;
 
 	for (page = 0; page < num_pages; page++) {
 		if (prlo->prlo_acc_params[page].type != FC_TYPE_FCP)
@@ -934,7 +934,7 @@ fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 	memset(tprlo, 0, (num_pages * 16) + 4);
 	tprlo->command = FC_ELS_TPRLO;
 	tprlo->page_len = 0x10;
-	tprlo->payload_len = bfa_os_htons((num_pages * 16) + 4);
+	tprlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
 
 	for (page = 0; page < num_pages; page++) {
 		tprlo->tprlo_params[page].type = FC_TYPE_FCP;
@@ -950,7 +950,7 @@ fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
 		}
 	}
 
-	return bfa_os_ntohs(tprlo->payload_len);
+	return be16_to_cpu(tprlo->payload_len);
 }
 
 u16
@@ -965,7 +965,7 @@ fc_tprlo_rsp_parse(struct fchs_s *fchs, int len)
 	if (tprlo->command != FC_ELS_ACC)
 		return FC_PARSE_ACC_INVAL;
 
-	num_pages = (bfa_os_ntohs(tprlo->payload_len) - 4) / 16;
+	num_pages = (be16_to_cpu(tprlo->payload_len) - 4) / 16;
 
 	for (page = 0; page < num_pages; page++) {
 		if (tprlo->tprlo_acc_params[page].type != FC_TYPE_FCP)
@@ -1015,7 +1015,7 @@ fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_DIRSERVICE;
 	cthdr->gs_sub_type = CT_GSSUBTYPE_NAMESERVER;
-	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+	cthdr->cmd_rsp_code = cpu_to_be16(cmd_code);
 }
 
 static void
@@ -1025,7 +1025,7 @@ fc_gs_fdmi_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
 	cthdr->gs_sub_type = CT_GSSUBTYPE_HBA_MGMTSERVER;
-	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+	cthdr->cmd_rsp_code = cpu_to_be16(cmd_code);
 }
 
 static void
@@ -1036,7 +1036,7 @@ fc_gs_ms_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code,
 	cthdr->rev_id = CT_GS3_REVISION;
 	cthdr->gs_type = CT_GSTYPE_MGMTSERVICE;
 	cthdr->gs_sub_type = sub_type;
-	cthdr->cmd_rsp_code = bfa_os_htons(cmd_code);
+	cthdr->cmd_rsp_code = cpu_to_be16(cmd_code);
 }
 
 u16
@@ -1090,7 +1090,7 @@ fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 u16
 fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
 {
-	if (bfa_os_ntohs(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
+	if (be16_to_cpu(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
 		if (cthdr->reason_code == CT_RSN_LOGICAL_BUSY)
 			return FC_PARSE_BUSY;
 		else
@@ -1129,7 +1129,7 @@ fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
 	rscn->pagelen = sizeof(rscn->event[0]);
 
 	payldlen = sizeof(u32) + rscn->pagelen;
-	rscn->payldlen = bfa_os_htons(payldlen);
+	rscn->payldlen = cpu_to_be16(payldlen);
 
 	rscn->event[0].format = FC_RSCN_FORMAT_PORTID;
 	rscn->event[0].portid = s_id;
@@ -1156,7 +1156,7 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	/* By default, FCP FC4 Type is registered */
 	index = FC_TYPE_FCP >> 5;
 	type_value = 1 << (FC_TYPE_FCP % 32);
-	rftid->fc4_type[index] = bfa_os_htonl(type_value);
+	rftid->fc4_type[index] = cpu_to_be32(type_value);
 
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
@@ -1365,7 +1365,7 @@ fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask)
 
 	index = fc4_type >> 5;
 	type_value = 1 << (fc4_type % 32);
-	ptr[index] = bfa_os_htonl(type_value);
+	ptr[index] = cpu_to_be32(type_value);
 
 }
 
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index e9075a6..8c585bd 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2260,11 +2260,11 @@ __bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete)
 		 * setup residue value correctly for normal completions
 		 */
 		if (m->resid_flags == FCP_RESID_UNDER) {
-			residue = bfa_os_ntohl(m->residue);
+			residue = be32_to_cpu(m->residue);
 			bfa_stats(ioim->itnim, iocomp_underrun);
 		}
 		if (m->resid_flags == FCP_RESID_OVER) {
-			residue = bfa_os_ntohl(m->residue);
+			residue = be32_to_cpu(m->residue);
 			residue = -residue;
 			bfa_stats(ioim->itnim, iocomp_overrun);
 		}
@@ -2357,7 +2357,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	/**
 	 * build i/o request message next
 	 */
-	m->io_tag = bfa_os_htons(ioim->iotag);
+	m->io_tag = cpu_to_be16(ioim->iotag);
 	m->rport_hdl = ioim->itnim->rport->fw_handle;
 	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
 
@@ -2395,7 +2395,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	m->cmnd.iodir = bfa_cb_ioim_get_iodir(ioim->dio);
 	m->cmnd.cdb = *(scsi_cdb_t *)bfa_cb_ioim_get_cdb(ioim->dio);
 	fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
-	m->cmnd.fcp_dl = bfa_os_htonl(fcp_dl);
+	m->cmnd.fcp_dl = cpu_to_be32(fcp_dl);
 
 	/**
 	 * set up I/O message header
@@ -2436,7 +2436,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 				bfa_cb_ioim_get_cdb(ioim->dio) + 1,
 				m->cmnd.addl_cdb_len * sizeof(u32));
 		fcp_cmnd_fcpdl(&m->cmnd) =
-				bfa_os_htonl(bfa_cb_ioim_get_size(ioim->dio));
+				cpu_to_be32(bfa_cb_ioim_get_size(ioim->dio));
 	}
 #endif
 
@@ -2564,7 +2564,7 @@ bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
 		msgop = BFI_IOIM_H2I_IOCLEANUP_REQ;
 
 	bfi_h2i_set(m->mh, BFI_MC_IOIM, msgop, bfa_lpuid(ioim->bfa));
-	m->io_tag    = bfa_os_htons(ioim->iotag);
+	m->io_tag    = cpu_to_be16(ioim->iotag);
 	m->abort_tag = ++ioim->abort_tag;
 
 	/**
@@ -2739,7 +2739,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	u16	iotag;
 	enum bfa_ioim_event evt = BFA_IOIM_SM_COMP;
 
-	iotag = bfa_os_ntohs(rsp->io_tag);
+	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
 	bfa_assert(ioim->iotag == iotag);
@@ -2822,7 +2822,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	struct bfa_ioim_s *ioim;
 	u16	iotag;
 
-	iotag = bfa_os_ntohs(rsp->io_tag);
+	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
 	bfa_assert(ioim->iotag == iotag);
@@ -3380,7 +3380,7 @@ bfa_tskim_send(struct bfa_tskim_s *tskim)
 	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_TM_REQ,
 			bfa_lpuid(tskim->bfa));
 
-	m->tsk_tag = bfa_os_htons(tskim->tsk_tag);
+	m->tsk_tag = cpu_to_be16(tskim->tsk_tag);
 	m->itn_fhdl = tskim->itnim->rport->fw_handle;
 	m->t_secs = tskim->tsecs;
 	m->lun = tskim->lun;
@@ -3415,7 +3415,7 @@ bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
 	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_ABORT_REQ,
 			bfa_lpuid(tskim->bfa));
 
-	m->tsk_tag  = bfa_os_htons(tskim->tsk_tag);
+	m->tsk_tag  = cpu_to_be16(tskim->tsk_tag);
 
 	/**
 	 * queue I/O message to firmware
@@ -3535,7 +3535,7 @@ bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
 	struct bfi_tskim_rsp_s *rsp = (struct bfi_tskim_rsp_s *) m;
 	struct bfa_tskim_s *tskim;
-	u16	tsk_tag = bfa_os_ntohs(rsp->tsk_tag);
+	u16	tsk_tag = be16_to_cpu(rsp->tsk_tag);
 
 	tskim = BFA_TSKIM_FROM_TAG(fcpim, tsk_tag);
 	bfa_assert(tskim->tsk_tag == tsk_tag);
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 2bb3a7a..88eb91a 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1329,7 +1329,7 @@ bfa_fcs_fabric_process_flogi(struct bfa_fcs_fabric_s *fabric,
 		return;
 	}
 
-	fabric->bb_credit = bfa_os_ntohs(flogi->csp.bbcred);
+	fabric->bb_credit = be16_to_cpu(flogi->csp.bbcred);
 	bport->port_topo.pn2n.rem_port_wwn = flogi->port_name;
 	bport->port_topo.pn2n.reply_oxid = fchs->ox_id;
 
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 6cee56f..263a7bf 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -482,9 +482,9 @@ bfa_fs_port_get_gen_topo_data(struct bfa_fcs_lport_s *port,
 	memset(gen_topo_data, 0,
 		      sizeof(struct fc_rnid_general_topology_data_s));
 
-	gen_topo_data->asso_type = bfa_os_htonl(RNID_ASSOCIATED_TYPE_HOST);
+	gen_topo_data->asso_type = cpu_to_be32(RNID_ASSOCIATED_TYPE_HOST);
 	gen_topo_data->phy_port_num = 0;	/* @todo */
-	gen_topo_data->num_attached_nodes = bfa_os_htonl(1);
+	gen_topo_data->num_attached_nodes = cpu_to_be32(1);
 }
 
 static void
@@ -1584,7 +1584,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	bfa_fcs_fdmi_get_hbaattr(fdmi, fcs_hba_attr);
 
 	rhba->hba_id = bfa_fcs_lport_get_pwwn(port);
-	rhba->port_list.num_ports = bfa_os_htonl(1);
+	rhba->port_list.num_ports = cpu_to_be32(1);
 	rhba->port_list.port_entry = bfa_fcs_lport_get_pwwn(port);
 
 	len = sizeof(rhba->hba_id) + sizeof(rhba->port_list);
@@ -1601,21 +1601,21 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 * Node Name
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_NODENAME);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_NODENAME);
 	attr->len = sizeof(wwn_t);
 	memcpy(attr->value, &bfa_fcs_lport_get_nwwn(port), attr->len);
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Manufacturer
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MANUFACTURER);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MANUFACTURER);
 	attr->len = (u16) strlen(fcs_hba_attr->manufacturer);
 	memcpy(attr->value, fcs_hba_attr->manufacturer, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1626,14 +1626,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Serial Number
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_SERIALNUM);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_SERIALNUM);
 	attr->len = (u16) strlen(fcs_hba_attr->serial_num);
 	memcpy(attr->value, fcs_hba_attr->serial_num, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1644,14 +1644,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Model
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL);
 	attr->len = (u16) strlen(fcs_hba_attr->model);
 	memcpy(attr->value, fcs_hba_attr->model, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1662,14 +1662,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Model Desc
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MODEL_DESC);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL_DESC);
 	attr->len = (u16) strlen(fcs_hba_attr->model_desc);
 	memcpy(attr->value, fcs_hba_attr->model_desc, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1680,7 +1680,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1688,7 +1688,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	if (fcs_hba_attr->hw_version[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
-		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_HW_VERSION);
+		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_HW_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->hw_version);
 		memcpy(attr->value, fcs_hba_attr->hw_version, attr->len);
 		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1699,7 +1699,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		len += attr->len;
 		count++;
 		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
+			cpu_to_be16(attr->len + sizeof(attr->type) +
 					 sizeof(attr->len));
 	}
 
@@ -1707,7 +1707,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 * Driver Version
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_DRIVER_VERSION);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_DRIVER_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1718,7 +1718,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1726,7 +1726,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	if (fcs_hba_attr->option_rom_ver[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
-		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_ROM_VERSION);
+		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_ROM_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->option_rom_ver);
 		memcpy(attr->value, fcs_hba_attr->option_rom_ver, attr->len);
 		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1737,7 +1737,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		len += attr->len;
 		count++;
 		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
+			cpu_to_be16(attr->len + sizeof(attr->type) +
 					 sizeof(attr->len));
 	}
 
@@ -1745,7 +1745,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 * f/w Version = driver version
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_FW_VERSION);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_FW_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1756,7 +1756,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1764,7 +1764,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	if (fcs_hba_attr->os_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
-		attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_OS_NAME);
+		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_OS_NAME);
 		attr->len = (u16) strlen(fcs_hba_attr->os_name);
 		memcpy(attr->value, fcs_hba_attr->os_name, attr->len);
 		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1775,7 +1775,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		len += attr->len;
 		count++;
 		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
+			cpu_to_be16(attr->len + sizeof(attr->type) +
 					sizeof(attr->len));
 	}
 
@@ -1783,13 +1783,13 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 * MAX_CT_PAYLOAD
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_HBA_ATTRIB_MAX_CT);
+	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MAX_CT);
 	attr->len = sizeof(fcs_hba_attr->max_ct_pyld);
 	memcpy(attr->value, &fcs_hba_attr->max_ct_pyld, attr->len);
 	len += attr->len;
 	count++;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1798,7 +1798,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += ((sizeof(attr->type) +
 		 sizeof(attr->len)) * count);
 
-	rhba->hba_attr_blk.attr_count = bfa_os_htonl(count);
+	rhba->hba_attr_blk.attr_count = cpu_to_be32(count);
 	return len;
 }
 
@@ -1825,7 +1825,7 @@ bfa_fcs_lport_fdmi_rhba_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
@@ -1909,56 +1909,56 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 * FC4 Types
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_FC4_TYPES);
+	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_FC4_TYPES);
 	attr->len = sizeof(fcs_port_attr.supp_fc4_types);
 	memcpy(attr->value, fcs_port_attr.supp_fc4_types, attr->len);
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Supported Speed
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_SUPP_SPEED);
+	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_SUPP_SPEED);
 	attr->len = sizeof(fcs_port_attr.supp_speed);
 	memcpy(attr->value, &fcs_port_attr.supp_speed, attr->len);
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * current Port Speed
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_PORT_SPEED);
+	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_PORT_SPEED);
 	attr->len = sizeof(fcs_port_attr.curr_speed);
 	memcpy(attr->value, &fcs_port_attr.curr_speed, attr->len);
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * max frame size
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
-	attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_FRAME_SIZE);
+	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_FRAME_SIZE);
 	attr->len = sizeof(fcs_port_attr.max_frm_size);
 	memcpy(attr->value, &fcs_port_attr.max_frm_size, attr->len);
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
 	attr->len =
-		bfa_os_htons(attr->len + sizeof(attr->type) +
+		cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1966,7 +1966,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 */
 	if (fcs_port_attr.os_device_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
-		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_DEV_NAME);
+		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_DEV_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.os_device_name);
 		memcpy(attr->value, fcs_port_attr.os_device_name, attr->len);
 		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1977,7 +1977,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 		len += attr->len;
 		++count;
 		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
+			cpu_to_be16(attr->len + sizeof(attr->type) +
 					sizeof(attr->len));
 	}
 	/*
@@ -1985,7 +1985,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 */
 	if (fcs_port_attr.host_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
-		attr->type = bfa_os_htons(FDMI_PORT_ATTRIB_HOST_NAME);
+		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_HOST_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.host_name);
 		memcpy(attr->value, fcs_port_attr.host_name, attr->len);
 		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
@@ -1996,14 +1996,14 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 		len += attr->len;
 		++count;
 		attr->len =
-			bfa_os_htons(attr->len + sizeof(attr->type) +
+			cpu_to_be16(attr->len + sizeof(attr->type) +
 				sizeof(attr->len));
 	}
 
 	/*
 	 * Update size of payload
 	 */
-	port_attrib->attr_count = bfa_os_htonl(count);
+	port_attrib->attr_count = cpu_to_be32(count);
 	len += ((sizeof(attr->type) +
 		 sizeof(attr->len)) * count);
 	return len;
@@ -2050,7 +2050,7 @@ bfa_fcs_lport_fdmi_rprt_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
@@ -2143,7 +2143,7 @@ bfa_fcs_lport_fdmi_rpa_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_OK);
@@ -2204,7 +2204,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 				sizeof(driver_info->host_os_patch));
 	}
 
-	hba_attr->max_ct_pyld = bfa_os_htonl(FC_MAX_PDUSZ);
+	hba_attr->max_ct_pyld = cpu_to_be32(FC_MAX_PDUSZ);
 }
 
 void
@@ -2230,17 +2230,17 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	/*
 	 * Supported Speeds
 	 */
-	port_attr->supp_speed = bfa_os_htonl(BFA_FCS_FDMI_SUPORTED_SPEEDS);
+	port_attr->supp_speed = cpu_to_be32(BFA_FCS_FDMI_SUPORTED_SPEEDS);
 
 	/*
 	 * Current Speed
 	 */
-	port_attr->curr_speed = bfa_os_htonl(pport_attr.speed);
+	port_attr->curr_speed = cpu_to_be32(pport_attr.speed);
 
 	/*
 	 * Max PDU Size.
 	 */
-	port_attr->max_frm_size = bfa_os_htonl(FC_MAX_PDUSZ);
+	port_attr->max_frm_size = cpu_to_be32(FC_MAX_PDUSZ);
 
 	/*
 	 * OS device Name
@@ -2657,12 +2657,12 @@ bfa_fcs_lport_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		gmal_resp = (struct fcgs_gmal_resp_s *)(cthdr + 1);
 
-		num_entries = bfa_os_ntohl(gmal_resp->ms_len);
+		num_entries = be32_to_cpu(gmal_resp->ms_len);
 		if (num_entries == 0) {
 			bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
 			return;
@@ -2853,7 +2853,7 @@ bfa_fcs_lport_ms_gfn_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		gfn_resp = (wwn_t *)(cthdr + 1);
@@ -3815,7 +3815,7 @@ bfa_fcs_lport_ns_rspn_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		port->stats.ns_rspnid_accepts++;
@@ -3887,7 +3887,7 @@ bfa_fcs_lport_ns_rft_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		port->stats.ns_rftid_accepts++;
@@ -3964,7 +3964,7 @@ bfa_fcs_lport_ns_rff_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		port->stats.ns_rffid_accepts++;
@@ -4058,7 +4058,7 @@ bfa_fcs_lport_ns_gid_ft_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	switch (cthdr->cmd_rsp_code) {
 
@@ -4624,7 +4624,7 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 	int             i = 0, j;
 
 	num_entries =
-		(bfa_os_ntohs(rscn->payldlen) -
+		(be16_to_cpu(rscn->payldlen) -
 		 sizeof(u32)) / sizeof(rscn->event[0]);
 
 	bfa_trc(port->fcs, num_entries);
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index a6872d3..12b50bd 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1621,7 +1621,7 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	bfa_trc(rport->fcs, rport->pwwn);
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		/* Check if the pid is the same as before. */
@@ -1691,7 +1691,7 @@ bfa_fcs_rport_gpnid_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	bfa_trc(rport->fcs, rport->pwwn);
 
 	cthdr = (struct ct_hdr_s *) BFA_FCXP_RSP_PLD(fcxp);
-	cthdr->cmd_rsp_code = bfa_os_ntohs(cthdr->cmd_rsp_code);
+	cthdr->cmd_rsp_code = be16_to_cpu(cthdr->cmd_rsp_code);
 
 	if (cthdr->cmd_rsp_code == CT_RSP_ACCEPT) {
 		bfa_sm_send_event(rport, RPSM_EVENT_ACCEPTED);
@@ -2123,9 +2123,9 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	 * - MAX receive frame size
 	 */
 	rport->cisc = plogi->csp.cisc;
-	rport->maxfrsize = bfa_os_ntohs(plogi->class3.rxsz);
+	rport->maxfrsize = be16_to_cpu(plogi->class3.rxsz);
 
-	bfa_trc(port->fcs, bfa_os_ntohs(plogi->csp.bbcred));
+	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 	bfa_trc(port->fcs, port->fabric->bb_credit);
 	/**
 	 * Direct Attach P2P mode :
@@ -2136,12 +2136,12 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	 * in PLOGI.
 	 */
 	if ((!bfa_fcs_fabric_is_switched(port->fabric))	 &&
-		(bfa_os_ntohs(plogi->csp.bbcred) < port->fabric->bb_credit)) {
+		(be16_to_cpu(plogi->csp.bbcred) < port->fabric->bb_credit)) {
 
-		bfa_trc(port->fcs, bfa_os_ntohs(plogi->csp.bbcred));
+		bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 		bfa_trc(port->fcs, port->fabric->bb_credit);
 
-		port->fabric->bb_credit = bfa_os_ntohs(plogi->csp.bbcred);
+		port->fabric->bb_credit = be16_to_cpu(plogi->csp.bbcred);
 		bfa_fcport_set_tx_bbcredit(port->fcs->bfa,
 					  port->fabric->bb_credit);
 	}
@@ -3090,16 +3090,16 @@ bfa_fcs_rpf_rpsc2_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	rpsc2_acc = (struct fc_rpsc2_acc_s *) BFA_FCXP_RSP_PLD(fcxp);
 	if (rpsc2_acc->els_cmd == FC_ELS_ACC) {
 		rport->stats.rpsc_accs++;
-		num_ents = bfa_os_ntohs(rpsc2_acc->num_pids);
+		num_ents = be16_to_cpu(rpsc2_acc->num_pids);
 		bfa_trc(rport->fcs, num_ents);
 		if (num_ents > 0) {
 			bfa_assert(rpsc2_acc->port_info[0].pid != rport->pid);
 			bfa_trc(rport->fcs,
-				bfa_os_ntohs(rpsc2_acc->port_info[0].pid));
+				be16_to_cpu(rpsc2_acc->port_info[0].pid));
 			bfa_trc(rport->fcs,
-				bfa_os_ntohs(rpsc2_acc->port_info[0].speed));
+				be16_to_cpu(rpsc2_acc->port_info[0].speed));
 			bfa_trc(rport->fcs,
-				bfa_os_ntohs(rpsc2_acc->port_info[0].index));
+				be16_to_cpu(rpsc2_acc->port_info[0].index));
 			bfa_trc(rport->fcs,
 				rpsc2_acc->port_info[0].type);
 
@@ -3109,7 +3109,7 @@ bfa_fcs_rpf_rpsc2_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			}
 
 			rpf->rpsc_speed = fc_rpsc_operspeed_to_bfa_speed(
-				bfa_os_ntohs(rpsc2_acc->port_info[0].speed));
+				be16_to_cpu(rpsc2_acc->port_info[0].speed));
 
 			bfa_sm_send_event(rpf, RPFSM_EVENT_RPSC_COMP);
 		}
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index bd25fc2..8d3bf40 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1450,7 +1450,7 @@ bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 	 */
 	for (i = 0; i < len / sizeof(u32); i++)
 		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32),
-			      bfa_os_wtole(msgp[i]));
+			      cpu_to_le32(msgp[i]));
 
 	for (; i < BFI_IOC_MSGLEN_MAX / sizeof(u32); i++)
 		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32), 0);
@@ -1472,7 +1472,7 @@ bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
 		    bfa_ioc_portid(ioc));
 	enable_req.ioc_class = ioc->ioc_mc;
 	bfa_os_gettimeofday(&tv);
-	enable_req.tv_sec = bfa_os_ntohl(tv.tv_sec);
+	enable_req.tv_sec = be32_to_cpu(tv.tv_sec);
 	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
 }
 
@@ -1609,9 +1609,9 @@ bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
 {
 	struct bfi_ioc_attr_s	*attr = ioc->attr;
 
-	attr->adapter_prop  = bfa_os_ntohl(attr->adapter_prop);
-	attr->card_type     = bfa_os_ntohl(attr->card_type);
-	attr->maxfrsize	    = bfa_os_ntohs(attr->maxfrsize);
+	attr->adapter_prop  = be32_to_cpu(attr->adapter_prop);
+	attr->card_type     = be32_to_cpu(attr->card_type);
+	attr->maxfrsize	    = be16_to_cpu(attr->maxfrsize);
 
 	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
 }
@@ -1710,7 +1710,7 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 	bfa_trc(ioc, len);
 	for (i = 0; i < len; i++) {
 		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
-		buf[i] = bfa_os_ntohl(r32);
+		buf[i] = be32_to_cpu(r32);
 		loff += sizeof(u32);
 
 		/**
@@ -1925,7 +1925,7 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 	     i++) {
 		r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox +
 				   i * sizeof(u32));
-		msgp[i] = bfa_os_htonl(r32);
+		msgp[i] = cpu_to_be32(r32);
 	}
 
 	/**
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 97e1b16..71c0b5a 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -125,8 +125,8 @@ __bfa_dma_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 static inline void
 __bfa_dma_be_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 {
-	dma_addr->a32.addr_lo = (u32) bfa_os_htonl(pa);
-	dma_addr->a32.addr_hi = (u32) bfa_os_htonl(bfa_os_u32(pa));
+	dma_addr->a32.addr_lo = (u32) cpu_to_be32(pa);
+	dma_addr->a32.addr_hi = (u32) cpu_to_be32(bfa_os_u32(pa));
 }
 
 struct bfa_ioc_regs_s {
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index a79a443..d928dca 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -65,16 +65,6 @@ do {									\
 	((_x) & 0x00ff00) |			\
 	(((_x) & 0xff0000) >> 16))
 
-#define bfa_swap_8b(_x)					\
-	((((_x) & 0xff00000000000000ull) >> 56)		\
-	 | (((_x) & 0x00ff000000000000ull) >> 40)	\
-	 | (((_x) & 0x0000ff0000000000ull) >> 24)	\
-	 | (((_x) & 0x000000ff00000000ull) >> 8)	\
-	 | (((_x) & 0x00000000ff000000ull) << 8)	\
-	 | (((_x) & 0x0000000000ff0000ull) << 24)	\
-	 | (((_x) & 0x000000000000ff00ull) << 40)	\
-	 | (((_x) & 0x00000000000000ffull) << 56))
-
 #define bfa_os_swap32(_x)			\
 	((((_x) & 0xff) << 24)		|	\
 	(((_x) & 0x0000ff00) << 8)	|	\
@@ -92,32 +82,15 @@ do {									\
 	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
 
 #ifndef __BIGENDIAN
-#define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
-				 (((_x) & 0x00ff) << 8)))
-#define bfa_os_htonl(_x)	bfa_os_swap32(_x)
-#define bfa_os_htonll(_x)	bfa_swap_8b(_x)
 #define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
-#define bfa_os_wtole(_x)   (_x)
 #define bfa_os_sgaddr(_x)  (_x)
-
 #else
-
-#define bfa_os_htons(_x)   (_x)
-#define bfa_os_htonl(_x)   (_x)
 #define bfa_os_hton3b(_x)  (_x)
-#define bfa_os_htonll(_x)  (_x)
-#define bfa_os_wtole(_x)   bfa_os_swap32(_x)
 #define bfa_os_sgaddr(_x)  bfa_os_swap_sgaddr(_x)
-
 #endif
 
-#define bfa_os_ntohs(_x)   bfa_os_htons(_x)
-#define bfa_os_ntohl(_x)   bfa_os_htonl(_x)
-#define bfa_os_ntohll(_x)  bfa_os_htonll(_x)
 #define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
-
 #define bfa_os_u32(__pa64) ((__pa64) >> 32)
-
 #define bfa_os_addr_t void __iomem *
 
 #define bfa_os_reg_read(_raddr) readl(_raddr)
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index b6d170a..17834ff 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -37,11 +37,11 @@ bfa_port_stats_swap(struct bfa_port_s *port, union bfa_port_stats_u *stats)
 		t0 = dip[i];
 		t1 = dip[i + 1];
 #ifdef __BIGENDIAN
-		dip[i] = bfa_os_ntohl(t0);
-		dip[i + 1] = bfa_os_ntohl(t1);
+		dip[i] = be32_to_cpu(t0);
+		dip[i + 1] = be32_to_cpu(t1);
 #else
-		dip[i] = bfa_os_ntohl(t1);
-		dip[i + 1] = bfa_os_ntohl(t0);
+		dip[i] = be32_to_cpu(t1);
+		dip[i + 1] = be32_to_cpu(t0);
 #endif
 	}
 }
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index ee0701f..4d13688 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -740,11 +740,11 @@ hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
 {
 	struct bfa_fcxp_mod_s	*mod = BFA_FCXP_MOD(bfa);
 	struct bfa_fcxp_s	*fcxp;
-	u16		fcxp_tag = bfa_os_ntohs(fcxp_rsp->fcxp_tag);
+	u16		fcxp_tag = be16_to_cpu(fcxp_rsp->fcxp_tag);
 
 	bfa_trc(bfa, fcxp_tag);
 
-	fcxp_rsp->rsp_len = bfa_os_ntohl(fcxp_rsp->rsp_len);
+	fcxp_rsp->rsp_len = be32_to_cpu(fcxp_rsp->rsp_len);
 
 	/**
 	 * @todo f/w should not set residue to non-0 when everything
@@ -753,7 +753,7 @@ hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
 	if (fcxp_rsp->req_status == BFA_STATUS_OK)
 		fcxp_rsp->residue_len = 0;
 	else
-		fcxp_rsp->residue_len = bfa_os_ntohl(fcxp_rsp->residue_len);
+		fcxp_rsp->residue_len = be32_to_cpu(fcxp_rsp->residue_len);
 
 	fcxp = BFA_FCXP_FROM_TAG(mod, fcxp_tag);
 
@@ -884,26 +884,26 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 	bfi_h2i_set(send_req->mh, BFI_MC_FCXP, BFI_FCXP_H2I_SEND_REQ,
 		    bfa_lpuid(bfa));
 
-	send_req->fcxp_tag = bfa_os_htons(fcxp->fcxp_tag);
+	send_req->fcxp_tag = cpu_to_be16(fcxp->fcxp_tag);
 	if (rport) {
 		send_req->rport_fw_hndl = rport->fw_handle;
-		send_req->max_frmsz = bfa_os_htons(rport->rport_info.max_frmsz);
+		send_req->max_frmsz = cpu_to_be16(rport->rport_info.max_frmsz);
 		if (send_req->max_frmsz == 0)
-			send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+			send_req->max_frmsz = cpu_to_be16(FC_MAX_PDUSZ);
 	} else {
 		send_req->rport_fw_hndl = 0;
-		send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+		send_req->max_frmsz = cpu_to_be16(FC_MAX_PDUSZ);
 	}
 
-	send_req->vf_id = bfa_os_htons(reqi->vf_id);
+	send_req->vf_id = cpu_to_be16(reqi->vf_id);
 	send_req->lp_tag = reqi->lp_tag;
 	send_req->class = reqi->class;
 	send_req->rsp_timeout = rspi->rsp_timeout;
 	send_req->cts = reqi->cts;
 	send_req->fchs = reqi->fchs;
 
-	send_req->req_len = bfa_os_htonl(reqi->req_tot_len);
-	send_req->rsp_maxlen = bfa_os_htonl(rspi->rsp_maxlen);
+	send_req->req_len = cpu_to_be32(reqi->req_tot_len);
+	send_req->rsp_maxlen = cpu_to_be32(rspi->rsp_maxlen);
 
 	/*
 	 * setup req sgles
@@ -1549,7 +1549,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 		lps->fport	= rsp->f_port;
 		lps->npiv_en	= rsp->npiv_en;
 		lps->lp_pid	= rsp->lp_pid;
-		lps->pr_bbcred	= bfa_os_ntohs(rsp->bb_credit);
+		lps->pr_bbcred	= be16_to_cpu(rsp->bb_credit);
 		lps->pr_pwwn	= rsp->port_name;
 		lps->pr_nwwn	= rsp->node_name;
 		lps->auth_req	= rsp->auth_req;
@@ -1647,7 +1647,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 
 	m->lp_tag	= lps->lp_tag;
 	m->alpa		= lps->alpa;
-	m->pdu_size	= bfa_os_htons(lps->pdusz);
+	m->pdu_size	= cpu_to_be16(lps->pdusz);
 	m->pwwn		= lps->pwwn;
 	m->nwwn		= lps->nwwn;
 	m->fdisc	= lps->fdisc;
@@ -2995,7 +2995,7 @@ bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 		trunk->attr.state = BFA_TRUNK_DISABLED;
 
 	/* update FCoE specific */
-	fcport->fcoe_vlan = bfa_os_ntohs(pevent->link_state.vc_fcf.fcf.vlan);
+	fcport->fcoe_vlan = be16_to_cpu(pevent->link_state.vc_fcf.fcf.vlan);
 
 	bfa_trc(fcport->bfa, fcport->speed);
 	bfa_trc(fcport->bfa, fcport->topology);
@@ -3038,7 +3038,7 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 	m->pwwn = fcport->pwwn;
 	m->port_cfg = fcport->cfg;
 	m->msgtag = fcport->msgtag;
-	m->port_cfg.maxfrsize = bfa_os_htons(fcport->cfg.maxfrsize);
+	m->port_cfg.maxfrsize = cpu_to_be16(fcport->cfg.maxfrsize);
 	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
@@ -3114,7 +3114,7 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 
 	bfi_h2i_set(m->mh, BFI_MC_FCPORT, BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ,
 			bfa_lpuid(fcport->bfa));
-	m->tx_bbcredit = bfa_os_htons((u16)fcport->cfg.tx_bbcredit);
+	m->tx_bbcredit = cpu_to_be16((u16)fcport->cfg.tx_bbcredit);
 
 	/**
 	 * queue I/O message to firmware
@@ -3132,7 +3132,7 @@ bfa_fcport_qos_stats_swap(struct bfa_qos_stats_s *d,
 
 	/* Now swap the 32 bit fields */
 	for (i = 0; i < (sizeof(struct bfa_qos_stats_s)/sizeof(u32)); ++i)
-		dip[i] = bfa_os_ntohl(sip[i]);
+		dip[i] = be32_to_cpu(sip[i]);
 }
 
 static void
@@ -3146,11 +3146,11 @@ bfa_fcport_fcoe_stats_swap(struct bfa_fcoe_stats_s *d,
 	for (i = 0; i < ((sizeof(struct bfa_fcoe_stats_s))/sizeof(u32));
 	     i = i + 2) {
 #ifdef __BIGENDIAN
-		dip[i] = bfa_os_ntohl(sip[i]);
-		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
+		dip[i] = be32_to_cpu(sip[i]);
+		dip[i + 1] = be32_to_cpu(sip[i + 1]);
 #else
-		dip[i] = bfa_os_ntohl(sip[i + 1]);
-		dip[i + 1] = bfa_os_ntohl(sip[i]);
+		dip[i] = be32_to_cpu(sip[i + 1]);
+		dip[i + 1] = be32_to_cpu(sip[i]);
 #endif
 	}
 }
@@ -3325,7 +3325,7 @@ bfa_trunk_scn(struct bfa_fcport_s *fcport, struct bfi_fcport_trunk_scn_s *scn)
 		lattr->trunk_wwn  = tlink->trunk_wwn;
 		lattr->fctl	  = tlink->fctl;
 		lattr->speed	  = tlink->speed;
-		lattr->deskew	  = bfa_os_ntohl(tlink->deskew);
+		lattr->deskew	  = be32_to_cpu(tlink->deskew);
 
 		if (tlink->state == BFA_TRUNK_LINK_STATE_UP) {
 			fcport->speed	 = tlink->speed;
@@ -3874,7 +3874,7 @@ bfa_fcport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
 	qos_attr->state = fcport->qos_attr.state;
-	qos_attr->total_bb_cr = bfa_os_ntohl(fcport->qos_attr.total_bb_cr);
+	qos_attr->total_bb_cr = be32_to_cpu(fcport->qos_attr.total_bb_cr);
 }
 
 void
@@ -3885,10 +3885,10 @@ bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 	struct bfa_qos_vc_attr_s *bfa_vc_attr = &fcport->qos_vc_attr;
 	u32 i = 0;
 
-	qos_vc_attr->total_vc_count = bfa_os_ntohs(bfa_vc_attr->total_vc_count);
-	qos_vc_attr->shared_credit  = bfa_os_ntohs(bfa_vc_attr->shared_credit);
+	qos_vc_attr->total_vc_count = be16_to_cpu(bfa_vc_attr->total_vc_count);
+	qos_vc_attr->shared_credit  = be16_to_cpu(bfa_vc_attr->shared_credit);
 	qos_vc_attr->elp_opmode_flags  =
-			bfa_os_ntohl(bfa_vc_attr->elp_opmode_flags);
+			be32_to_cpu(bfa_vc_attr->elp_opmode_flags);
 
 	/* Individual VC info */
 	while (i < qos_vc_attr->total_vc_count) {
@@ -4273,9 +4273,9 @@ bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
 		bfa_trc(rp->bfa, qos_scn->new_qos_attr.qos_priority);
 
 		qos_scn->old_qos_attr.qos_flow_id  =
-			bfa_os_ntohl(qos_scn->old_qos_attr.qos_flow_id);
+			be32_to_cpu(qos_scn->old_qos_attr.qos_flow_id);
 		qos_scn->new_qos_attr.qos_flow_id  =
-			bfa_os_ntohl(qos_scn->new_qos_attr.qos_flow_id);
+			be32_to_cpu(qos_scn->new_qos_attr.qos_flow_id);
 
 		if (qos_scn->old_qos_attr.qos_flow_id !=
 			qos_scn->new_qos_attr.qos_flow_id)
@@ -4697,7 +4697,7 @@ bfa_rport_send_fwcreate(struct bfa_rport_s *rp)
 	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_CREATE_REQ,
 			bfa_lpuid(rp->bfa));
 	m->bfa_handle = rp->rport_tag;
-	m->max_frmsz = bfa_os_htons(rp->rport_info.max_frmsz);
+	m->max_frmsz = cpu_to_be16(rp->rport_info.max_frmsz);
 	m->pid = rp->rport_info.pid;
 	m->lp_tag = rp->rport_info.lp_tag;
 	m->local_pid = rp->rport_info.local_pid;
@@ -4888,7 +4888,7 @@ bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
 					struct bfa_rport_qos_attr_s *qos_attr)
 {
 	qos_attr->qos_priority  = rport->qos_attr.qos_priority;
-	qos_attr->qos_flow_id  = bfa_os_ntohl(rport->qos_attr.qos_flow_id);
+	qos_attr->qos_flow_id  = be32_to_cpu(rport->qos_attr.qos_flow_id);
 
 }
 
@@ -5155,7 +5155,7 @@ claim_uf_post_msgs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 
 		uf_bp_msg->buf_tag = i;
 		buf_len = sizeof(struct bfa_uf_buf_s);
-		uf_bp_msg->buf_len = bfa_os_htons(buf_len);
+		uf_bp_msg->buf_len = cpu_to_be16(buf_len);
 		bfi_h2i_set(uf_bp_msg->mh, BFI_MC_UF, BFI_UF_H2I_BUF_POST,
 			    bfa_lpuid(ufm->bfa));
 
@@ -5308,8 +5308,8 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	u8 *buf = &uf_buf->d[0];
 	struct fchs_s *fchs;
 
-	m->frm_len = bfa_os_ntohs(m->frm_len);
-	m->xfr_len = bfa_os_ntohs(m->xfr_len);
+	m->frm_len = be16_to_cpu(m->frm_len);
+	m->xfr_len = be16_to_cpu(m->xfr_len);
 
 	fchs = (struct fchs_s *)uf_buf;
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d884372..27dd06f 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -70,7 +70,7 @@ bfad_im_get_starget_node_name(struct scsi_target *starget)
 	if (itnim)
 		node_name = bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim);
 
-	fc_starget_node_name(starget) = bfa_os_htonll(node_name);
+	fc_starget_node_name(starget) = cpu_to_be64(node_name);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
@@ -96,7 +96,7 @@ bfad_im_get_starget_port_name(struct scsi_target *starget)
 	if (itnim)
 		port_name = bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim);
 
-	fc_starget_port_name(starget) = bfa_os_htonll(port_name);
+	fc_starget_port_name(starget) = cpu_to_be64(port_name);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
@@ -249,7 +249,7 @@ bfad_im_get_host_fabric_name(struct Scsi_Host *shost)
 
 	fabric_nwwn = bfa_fcs_lport_get_fabric_name(port->fcs_port);
 
-	fc_host_fabric_name(shost) = bfa_os_htonll(fabric_nwwn);
+	fc_host_fabric_name(shost) = cpu_to_be64(fabric_nwwn);
 
 }
 
@@ -733,7 +733,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	u64        nwwn;
 
 	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", bfa_os_htonll(nwwn));
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", cpu_to_be64(nwwn));
 }
 
 static ssize_t
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index d950ee4..236922b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -949,9 +949,9 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	char symname[BFA_SYMNAME_MAXLEN];
 
 	fc_host_node_name(host) =
-		bfa_os_htonll((bfa_fcs_lport_get_nwwn(port->fcs_port)));
+		cpu_to_be64((bfa_fcs_lport_get_nwwn(port->fcs_port)));
 	fc_host_port_name(host) =
-		bfa_os_htonll((bfa_fcs_lport_get_pwwn(port->fcs_port)));
+		cpu_to_be64((bfa_fcs_lport_get_pwwn(port->fcs_port)));
 	fc_host_max_npiv_vports(host) = bfa_lps_get_max_vport(&bfad->bfa);
 
 	fc_host_supported_classes(host) = FC_COS_CLASS3;
@@ -983,9 +983,9 @@ bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct bfad_itnim_s *itnim)
 	struct bfad_itnim_data_s *itnim_data;
 
 	rport_ids.node_name =
-		bfa_os_htonll(bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim));
+		cpu_to_be64(bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim));
 	rport_ids.port_name =
-		bfa_os_htonll(bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
+		cpu_to_be64(bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
 	rport_ids.port_id =
 		bfa_os_hton3b(bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim));
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
-- 
1.6.5.2

