Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A376C4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B402081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HA2/PC+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfILPUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:20:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16666 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732699AbfILPUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:20:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFG4iN011683;
        Thu, 12 Sep 2019 08:20:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u/Y2ah65Y+cwgg8Ul3Z1qdh+ZTBA+zfyIn+eXFmPEGs=;
 b=HA2/PC+PnTUtPNK7d0812jBUv/kfAD86UQtNkdJSZVcULEcY3GvgtVXcpbXCu1NA5rME
 suUt2KAdUZgQvvM2zWJ/fq68AXMPv0D+noZx0uFG4xga0GV8xiQ6T9Kf+WKMCLWeKqMw
 0Tq0W2w4P7NIEejPi3WtYOXFDSFYg5f446e5sxnWk/sxgriRz/Rj+B/VSOSrY5H/nt8s
 XHJ1B7u0tVRzXmrZu2zRWPloLL12yawSgEir23YNIrR2oMfryaImw4aoFyxV61Jbq2sz
 UD6BPEQA09M1A3HMZzZqj1p8e1EzeDfiyfSTqNRsBk6AxtL5nRKP61Yo6EUcvBK3WxOi VQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfynw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:14 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:13 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9389A3F703F;
        Thu, 12 Sep 2019 08:20:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFKDZ8002642;
        Thu, 12 Sep 2019 08:20:13 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFKDcc002592;
        Thu, 12 Sep 2019 08:20:13 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 08/14] qla2xxx: Dual FCP-NVMe target port support
Date:   Thu, 12 Sep 2019 08:19:43 -0700
Message-ID: <20190912151949.2348-9-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912151949.2348-1-hmadhani@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_08:2019-09-11,2019-09-12 signatures=0
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
index 597f44ae7057..4c4f639f2bbd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2204,7 +2204,7 @@ typedef struct {
 	uint8_t fabric_port_name[WWN_SIZE];
 	uint16_t fp_speed;
 	uint8_t fc4_type;
-	uint8_t fc4f_nvme;	/* nvme fc4 feature bits */
+	uint8_t fc4_features;
 } sw_info_t;
 
 /* FCP-4 types */
@@ -2388,7 +2388,7 @@ typedef struct fc_port {
 	u32 supported_classes;
 
 	uint8_t fc4_type;
-	uint8_t	fc4f_nvme;
+	uint8_t fc4_features;
 	uint8_t scan_state;
 
 	unsigned long last_queue_full;
@@ -2419,6 +2419,9 @@ typedef struct fc_port {
 	u16 n2n_chip_reset;
 } fc_port_t;
 
+#define FC4_PRIORITY_NVME	0
+#define FC4_PRIORITY_FCP	1
+
 #define QLA_FCPORT_SCAN		1
 #define QLA_FCPORT_FOUND	2
 
@@ -4235,6 +4238,8 @@ struct qla_hw_data {
 	atomic_t        nvme_active_aen_cnt;
 	uint16_t        nvme_last_rptd_aen;             /* Last recorded aen count */
 
+	uint8_t fc4_type_priority;
+
 	atomic_t zio_threshold;
 	uint16_t last_zio_threshold;
 
@@ -4760,6 +4765,23 @@ struct sff_8247_a0 {
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
index df079a8c2b33..49b7c66433a8 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2101,4 +2101,6 @@ struct qla_fcp_prio_cfg {
 #define FA_FLASH_LAYOUT_ADDR_83	(0x3F1000/4)
 #define FA_FLASH_LAYOUT_ADDR_28	(0x11000/4)
 
+#define NVRAM_DUAL_FCP_NVME_FLAG_OFFSET	0x196
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b197245fe929..ad7f02a8f6d7 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -252,7 +252,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    WWN_SIZE);
 
 		fcport->fc4_type = (ct_rsp->rsp.ga_nxt.fc4_types[2] & BIT_0) ?
-		    FC4_TYPE_FCP_SCSI : FC4_TYPE_OTHER;
+		    FS_FC4TYPE_FCP : FC4_TYPE_OTHER;
 
 		if (ct_rsp->rsp.ga_nxt.port_type != NS_N_PORT_TYPE &&
 		    ct_rsp->rsp.ga_nxt.port_type != NS_NL_PORT_TYPE)
@@ -2908,7 +2908,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
-	uint8_t fcp_scsi_features = 0;
+	uint8_t fcp_scsi_features = 0, nvme_features = 0;
 	struct ct_arg arg;
 
 	for (i = 0; i < ha->max_fibre_devices; i++) {
@@ -2956,14 +2956,19 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
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
@@ -3480,6 +3485,8 @@ void qla24xx_async_gffid_sp_done(void *s, int res)
        fc_port_t *fcport = sp->fcport;
        struct ct_sns_rsp *ct_rsp;
        struct event_arg ea;
+       uint8_t fc4_scsi_feat;
+       uint8_t fc4_nvme_feat;
 
        ql_dbg(ql_dbg_disc, vha, 0x2133,
 	   "Async done-%s res %x ID %x. %8phC\n",
@@ -3487,24 +3494,25 @@ void qla24xx_async_gffid_sp_done(void *s, int res)
 
        fcport->flags &= ~FCF_ASYNC_SENT;
        ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+       fc4_scsi_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+       fc4_nvme_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+
        /*
 	* FC-GS-7, 5.2.3.12 FC-4 Features - format
 	* The format of the FC-4 Features object, as defined by the FC-4,
 	* Shall be an array of 4-bit values, one for each type code value
 	*/
        if (!res) {
-	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
+	       if (fc4_scsi_feat & 0xf) {
 		       /* w1 b00:03 */
-		       fcport->fc4_type =
-			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
-		       fcport->fc4_type &= 0xf;
-	       }
+			fcport->fc4_type = FS_FC4TYPE_FCP;
+			fcport->fc4_features = fc4_scsi_feat & 0xf;
+		}
 
-	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
+	       if (fc4_nvme_feat & 0xf) {
 		       /* w5 [00:03]/28h */
-		       fcport->fc4f_nvme =
-			   ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-		       fcport->fc4f_nvme &= 0xf;
+			fcport->fc4_type |= FS_FC4TYPE_NVME;
+			fcport->fc4_features = fc4_nvme_feat & 0xf;
 	       }
        }
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b715dac7145..74a558c06b74 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -334,7 +334,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	else
 		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
-	if (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
@@ -737,19 +737,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
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
@@ -1245,13 +1243,13 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
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
@@ -1402,14 +1400,14 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
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
@@ -1598,7 +1596,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
 				    "%s %d %8phC post %s PRLI\n",
 				    __func__, __LINE__, fcport->port_name,
-				    fcport->fc4f_nvme ? "NVME" : "FC");
+				    NVME_TARGET(vha->hw, fcport) ? "NVME" :
+				    "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1941,13 +1940,22 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
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
@@ -2030,7 +2038,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
 		 * requests.
 		 */
-		if (ea->fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, ea->fcport)) {
 			ql_dbg(ql_dbg_disc, vha, 0x2117,
 				"%s %d %8phC post prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
@@ -5490,7 +5498,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla2x00_iidma_fcport(vha, fcport);
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
 		fcport->disc_state = DSC_LOGIN_COMPLETE;
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
@@ -5818,11 +5826,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
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
@@ -5878,7 +5883,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
 		if (ql2xgffidenable &&
-		    (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    (!(new_fcport->fc4_type & FS_FC4TYPE_FCP) &&
 		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
@@ -5947,7 +5952,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			break;
 		}
 
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
 				fcport->disc_state = DSC_GNL;
 				vha->fcport_count--;
@@ -8617,6 +8622,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
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
index bf063c664352..4299e960e41e 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -305,3 +305,15 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 
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
index 9575ba34c7b1..ac751aa91756 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1927,7 +1927,7 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(ha, fcport)) {
 			current_login_state = pd24->current_login_state >> 4;
 			last_login_state = pd24->last_login_state >> 4;
 		} else {
@@ -3894,8 +3894,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
+				fcport->fc4_type = FS_FC4TYPE_FCP;
 				if (vha->flags.nvme_enabled)
-					fcport->fc4f_nvme = 1;
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
@@ -6359,7 +6360,7 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	uint64_t zero = 0;
 	u8 current_login_state, last_login_state;
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		current_login_state = pd->current_login_state >> 4;
 		last_login_state = pd->last_login_state >> 4;
 	} else {
@@ -6394,8 +6395,8 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
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
index 836709ecc1be..27a22839c23d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5050,19 +5050,17 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
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
@@ -5164,7 +5162,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
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

