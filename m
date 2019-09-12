Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C143CC4CEC7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845652084F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ytHT6C3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfILSJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29054 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbfILSJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI4oGn006816;
        Thu, 12 Sep 2019 11:09:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=t1Oa/PkfmcZDFbXWC727sWzf4vKE99SFEeqvko8JItU=;
 b=ytHT6C3NOV91jSzpO8NjIqTUPXzNfv8sNBXNqe5NJeP5Kwp7+xloUNsTC+msUcNIDamw
 oZIysQKF3SmCpqKqS17gpdicuXHX8lcSwuUqRf7jmTPuvkMh+ylztYd9gfcBL9dG/6IL
 Lf5OFUDU6wpOC+dcWYjgoExs+z8YYrkJw0AIEgkESsUtcDwQ2IynftCou39bNwDElWBi
 xScRt1OAN9dbWkSoJi5D+vog/SHwiZXZIojJhpXR3g8LS5SZK1YkDOWzs20RkvRPOr2W
 d+zxKk+5l5NE4pNJ8kf077NDQ74l+cdQ4egft8xc83fTTbZ2tHJISgq1NIpYuWlVwuhu mA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uytdh067f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:45 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:44 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A76863F7040;
        Thu, 12 Sep 2019 11:09:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9igf006503;
        Thu, 12 Sep 2019 11:09:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9iEG006502;
        Thu, 12 Sep 2019 11:09:44 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 08/14] qla2xxx: Dual FCP-NVMe target port support
Date:   Thu, 12 Sep 2019 11:09:12 -0700
Message-ID: <20190912180918.6436-9-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Michael Hernandez <mhernandez@marvell.com>

Some storage arrays advertise FCP LUNs and NVMe namespaces behind the
same WWN.  The driver now offer's a user option by way of NVRAM
parameter to allow users to choose, on a per port basis, the kind of
FC-4 type they would like to prioritize for login.

Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 26 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_fw.h     |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c     | 42 ++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c   | 64 ++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_inline.h | 12 ++++++++
 drivers/scsi/qla2xxx/qla_mbx.c    | 11 ++++---
 drivers/scsi/qla2xxx/qla_os.c     | 17 +++++------
 7 files changed, 114 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6ffa9877c28b..721ee7f09b39 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2277,7 +2277,7 @@ typedef struct {
 	uint8_t fabric_port_name[WWN_SIZE];
 	uint16_t fp_speed;
 	uint8_t fc4_type;
-	uint8_t fc4f_nvme;	/* nvme fc4 feature bits */
+	uint8_t fc4_features;
 } sw_info_t;
 
 /* FCP-4 types */
@@ -2445,7 +2445,7 @@ typedef struct fc_port {
 	u32 supported_classes;
 
 	uint8_t fc4_type;
-	uint8_t	fc4f_nvme;
+	uint8_t fc4_features;
 	uint8_t scan_state;
 
 	unsigned long last_queue_full;
@@ -2476,6 +2476,9 @@ typedef struct fc_port {
 	u16 n2n_chip_reset;
 } fc_port_t;
 
+#define FC4_PRIORITY_NVME	0
+#define FC4_PRIORITY_FCP	1
+
 #define QLA_FCPORT_SCAN		1
 #define QLA_FCPORT_FOUND	2
 
@@ -4291,6 +4294,8 @@ struct qla_hw_data {
 	atomic_t        nvme_active_aen_cnt;
 	uint16_t        nvme_last_rptd_aen;             /* Last recorded aen count */
 
+	uint8_t fc4_type_priority;
+
 	atomic_t zio_threshold;
 	uint16_t last_zio_threshold;
 
@@ -4816,6 +4821,23 @@ struct sff_8247_a0 {
 	 ha->current_topology == ISP_CFG_N || \
 	 !ha->current_topology)
 
+#define NVME_TYPE(fcport) \
+	(fcport->fc4_type & FS_FC4TYPE_NVME) \
+
+#define FCP_TYPE(fcport) \
+	(fcport->fc4_type & FS_FC4TYPE_FCP) \
+
+#define NVME_ONLY_TARGET(fcport) \
+	(NVME_TYPE(fcport) && !FCP_TYPE(fcport))  \
+
+#define NVME_FCP_TARGET(fcport) \
+	(FCP_TYPE(fcport) && NVME_TYPE(fcport)) \
+
+#define NVME_TARGET(ha, fcport) \
+	((NVME_FCP_TARGET(fcport) && \
+	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
+	NVME_ONLY_TARGET(fcport)) \
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 732bb871c433..59f6903e5abe 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2101,4 +2101,6 @@ struct qla_fcp_prio_cfg {
 #define FA_FLASH_LAYOUT_ADDR_83	(0x3F1000/4)
 #define FA_FLASH_LAYOUT_ADDR_28	(0x11000/4)
 
+#define NVRAM_DUAL_FCP_NVME_FLAG_OFFSET	0x196
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5298ed10059f..5b5ac09f38db 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -248,7 +248,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    WWN_SIZE);
 
 		fcport->fc4_type = (ct_rsp->rsp.ga_nxt.fc4_types[2] & BIT_0) ?
-		    FC4_TYPE_FCP_SCSI : FC4_TYPE_OTHER;
+		    FS_FC4TYPE_FCP : FC4_TYPE_OTHER;
 
 		if (ct_rsp->rsp.ga_nxt.port_type != NS_N_PORT_TYPE &&
 		    ct_rsp->rsp.ga_nxt.port_type != NS_NL_PORT_TYPE)
@@ -2887,7 +2887,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
-	uint8_t fcp_scsi_features = 0;
+	uint8_t fcp_scsi_features = 0, nvme_features = 0;
 	struct ct_arg arg;
 
 	for (i = 0; i < ha->max_fibre_devices; i++) {
@@ -2933,14 +2933,19 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
 			fcp_scsi_features &= 0x0f;
 
-			if (fcp_scsi_features)
-				list[i].fc4_type = FC4_TYPE_FCP_SCSI;
-			else
-				list[i].fc4_type = FC4_TYPE_OTHER;
+			if (fcp_scsi_features) {
+				list[i].fc4_type = FS_FC4TYPE_FCP;
+				list[i].fc4_features = fcp_scsi_features;
+			}
 
-			list[i].fc4f_nvme =
+			nvme_features =
 			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-			list[i].fc4f_nvme &= 0xf;
+			nvme_features &= 0xf;
+
+			if (nvme_features) {
+				list[i].fc4_type |= FS_FC4TYPE_NVME;
+				list[i].fc4_features = nvme_features;
+			}
 		}
 
 		/* Last device exit. */
@@ -3435,6 +3440,8 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 	fc_port_t *fcport = sp->fcport;
 	struct ct_sns_rsp *ct_rsp;
 	struct event_arg ea;
+	uint8_t fc4_scsi_feat;
+	uint8_t fc4_nvme_feat;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2133,
 	       "Async done-%s res %x ID %x. %8phC\n",
@@ -3442,24 +3449,25 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+	fc4_scsi_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+	fc4_nvme_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+
 	/*
 	 * FC-GS-7, 5.2.3.12 FC-4 Features - format
 	 * The format of the FC-4 Features object, as defined by the FC-4,
 	 * Shall be an array of 4-bit values, one for each type code value
 	 */
 	if (!res) {
-		if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
+		if (fc4_scsi_feat & 0xf) {
 			/* w1 b00:03 */
-			fcport->fc4_type =
-			    ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
-			fcport->fc4_type &= 0xf;
-	       }
+			fcport->fc4_type = FS_FC4TYPE_FCP;
+			fcport->fc4_features = fc4_scsi_feat & 0xf;
+		}
 
-		if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
+		if (fc4_nvme_feat & 0xf) {
 			/* w5 [00:03]/28h */
-			fcport->fc4f_nvme =
-			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-			fcport->fc4f_nvme &= 0xf;
+			fcport->fc4_type |= FS_FC4TYPE_NVME;
+			fcport->fc4_features = fc4_nvme_feat & 0xf;
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 67f522a8a9d4..cba8102dc5c7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -328,7 +328,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	else
 		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
-	if (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
@@ -726,19 +726,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		if  (fcport->fc4f_nvme)
+		if (NVME_TARGET(vha->hw, fcport))
 			current_login_state = e->current_login_state >> 4;
 		else
 			current_login_state = e->current_login_state & 0xf;
 
-
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
-		    "%s found %8phC CLS [%x|%x] nvme %d ID[%02x%02x%02x|%02x%02x%02x] lid[%d|%d]\n",
+		    "%s found %8phC CLS [%x|%x] fc4_type %d ID[%06x|%06x] lid[%d|%d]\n",
 		    __func__, fcport->port_name,
 		    e->current_login_state, fcport->fw_login_state,
-		    fcport->fc4f_nvme, id.b.domain, id.b.area, id.b.al_pa,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, loop_id, fcport->loop_id);
+		    fcport->fc4_type, id.b24, fcport->d_id.b24,
+		    loop_id, fcport->loop_id);
 
 		switch (fcport->disc_state) {
 		case DSC_DELETE_PEND:
@@ -1225,13 +1223,13 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->done = qla2x00_async_prli_sp_done;
 	lio->u.logio.flags = 0;
 
-	if  (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_NVME_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x211b,
 	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d %s.\n",
 	    fcport->port_name, sp->handle, fcport->loop_id, fcport->d_id.b24,
-	    fcport->login_retry, fcport->fc4f_nvme ? "nvme" : "fc");
+	    fcport->login_retry, NVME_TARGET(vha->hw, fcport) ? "nvme" : "fc");
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -1382,14 +1380,14 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d2,
-	    "%s %8phC DS %d LS %d nvme %x rc %d\n", __func__, fcport->port_name,
-	    fcport->disc_state, pd->current_login_state, fcport->fc4f_nvme,
-	    ea->rc);
+	    "%s %8phC DS %d LS %d fc4_type %x rc %d\n", __func__,
+	    fcport->port_name, fcport->disc_state, pd->current_login_state,
+	    fcport->fc4_type, ea->rc);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
 
-	if (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		ls = pd->current_login_state >> 4;
 	else
 		ls = pd->current_login_state & 0xf;
@@ -1578,7 +1576,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
 				    "%s %d %8phC post %s PRLI\n",
 				    __func__, __LINE__, fcport->port_name,
-				    fcport->fc4f_nvme ? "NVME" : "FC");
+				    NVME_TARGET(vha->hw, fcport) ? "NVME" :
+				    "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1860,13 +1859,22 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		if (ea->fcport->fc4f_nvme) {
+		/*
+		 * Retry PRLI with other FC-4 type if failure ocurred on dual
+		 * FCP/NVMe port
+		 */
+		if (NVME_FCP_TARGET(ea->fcport)) {
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+			else
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
-				"%s %d %8phC post fc4 prli\n",
-				__func__, __LINE__, ea->fcport->port_name);
-			ea->fcport->fc4f_nvme = 0;
+				"%s %d %8phC post %s prli\n",
+				__func__, __LINE__, ea->fcport->port_name,
+				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
+				"NVMe" : "FCP");
 			qla24xx_post_prli_work(vha, ea->fcport);
-			return;
+			break;
 		}
 
 		/* at this point both PRLI NVME & PRLI FCP failed */
@@ -1952,7 +1960,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
 		 * requests.
 		 */
-		if (ea->fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, ea->fcport)) {
 			ql_dbg(ql_dbg_disc, vha, 0x2117,
 				"%s %d %8phC post prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
@@ -5396,7 +5404,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla2x00_iidma_fcport(vha, fcport);
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
 		fcport->disc_state = DSC_LOGIN_COMPLETE;
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
@@ -5724,11 +5732,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 				new_fcport->fc4_type = swl[swl_idx].fc4_type;
 
 				new_fcport->nvme_flag = 0;
-				new_fcport->fc4f_nvme = 0;
 				if (vha->flags.nvme_enabled &&
-				    swl[swl_idx].fc4f_nvme) {
-					new_fcport->fc4f_nvme =
-					    swl[swl_idx].fc4f_nvme;
+				    swl[swl_idx].fc4_type & FS_FC4TYPE_NVME) {
 					ql_log(ql_log_info, vha, 0x2131,
 					    "FOUND: NVME port %8phC as FC Type 28h\n",
 					    new_fcport->port_name);
@@ -5784,7 +5789,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
 		if (ql2xgffidenable &&
-		    (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    (!(new_fcport->fc4_type & FS_FC4TYPE_FCP) &&
 		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
@@ -5853,7 +5858,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			break;
 		}
 
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
 				fcport->disc_state = DSC_GNL;
 				vha->fcport_count--;
@@ -8528,6 +8533,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	/* N2N: driver will initiate Login instead of FW */
 	icb->firmware_options_3 |= BIT_8;
 
+	/* Determine NVMe/FCP priority for target ports */
+	ha->fc4_type_priority = qla2xxx_get_fc4_priority(vha);
+	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
+	    ha->fc4_type_priority & BIT_0 ? "FCP" : "NVMe");
+
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0076,
 		    "NVRAM configuration failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 0c3d907af769..d728b179e347 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -307,3 +307,15 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 
 	WRT_REG_DWORD(req->req_q_in, req->ring_index);
 }
+
+static inline int
+qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
+{
+	uint32_t data;
+
+	data =
+	    ((uint8_t *)vha->hw->nvram)[NVRAM_DUAL_FCP_NVME_FLAG_OFFSET];
+
+
+	return ((data >> 6) & BIT_0);
+}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1cc6913f76c4..d4d75bcdac73 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1931,7 +1931,7 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(ha, fcport)) {
 			current_login_state = pd24->current_login_state >> 4;
 			last_login_state = pd24->last_login_state >> 4;
 		} else {
@@ -3898,8 +3898,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
+				fcport->fc4_type = FS_FC4TYPE_FCP;
 				if (vha->flags.nvme_enabled)
-					fcport->fc4f_nvme = 1;
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
@@ -6361,7 +6362,7 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	uint64_t zero = 0;
 	u8 current_login_state, last_login_state;
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		current_login_state = pd->current_login_state >> 4;
 		last_login_state = pd->last_login_state >> 4;
 	} else {
@@ -6396,8 +6397,8 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->d_id.b.al_pa = pd->port_id[2];
 	fcport->d_id.b.rsvd_1 = 0;
 
-	if (fcport->fc4f_nvme) {
-		fcport->port_type = 0;
+	if (NVME_TARGET(vha->hw, fcport)) {
+		fcport->port_type = FCT_NVME;
 		if ((pd->prli_svc_param_word_3[0] & BIT_5) == 0)
 			fcport->port_type |= FCT_NVME_INITIATOR;
 		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ee47de9fbc05..c2ec8ee5df79 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5023,19 +5023,17 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->d_id = e->u.new_sess.id;
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
-			if (e->u.new_sess.fc4_type == FS_FC4TYPE_FCP)
-				fcport->fc4_type = FC4_TYPE_FCP_SCSI;
-
-			if (e->u.new_sess.fc4_type == FS_FC4TYPE_NVME) {
-				fcport->fc4_type = FC4_TYPE_OTHER;
-				fcport->fc4f_nvme = FC4_TYPE_NVME;
-			}
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
 
-			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N)
+			fcport->fc4_type = e->u.new_sess.fc4_type;
+			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N) {
+				fcport->fc4_type = FS_FC4TYPE_FCP;
 				fcport->n2n_flag = 1;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
+			}
 
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -5139,7 +5137,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				fcport->flags &= ~FCF_FABRIC_DEVICE;
 				fcport->keep_nport_handle = 1;
 				if (vha->flags.nvme_enabled) {
-					fcport->fc4f_nvme = 1;
+					fcport->fc4_type =
+					    (FS_FC4TYPE_NVME | FS_FC4TYPE_FCP);
 					fcport->n2n_flag = 1;
 				}
 				fcport->fw_login_state = 0;
-- 
2.12.0

