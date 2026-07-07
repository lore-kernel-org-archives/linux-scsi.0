Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2AA202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403816; cv=none; b=HoQlKzn+U8ZZHKT9VcJVt3Hx7CqKEPYqs5xAf8TXR/4RoJHMznXssBKo3zdi1dSVK4Ie55MU39GOOGFHYdsQI0WavBO0vAfTn1TqpMdYciJ6LqjEirW7sjEj1uem38GLOc2JzyuQAP3M5sJDQzxYxPrPzcE83qGOABM/qSw0CAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403816; c=relaxed/simple;
	bh=jl6v2yY4SeNjZhIcj7hpKPB0omVoE+pF8+lm/W3anEI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFvOhy2pqAhu4BzhuH6iYh8HNzMi8etStpSFJC1RYCVsrshCVMED/Vu5JwETmhV57cMjIEiJkOLIv6W8XyGHMVTBUgWrvBG/B7aHW7fdduDacPWbCWMCBQebir43C4XQ5wtZrnDH1vSACnzdZWadWfltgCmFFusecMfGXyEmBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=M1TiMpPC; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M1TiMpPC"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cNu1656126;
	Mon, 6 Jul 2026 22:56:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=m
	pooBUJ62B3S7vS6W6AqQi+gQxtYNGNTvTQe20gtNgo=; b=M1TiMpPCvihK58Mlf
	dChg8VK8KW/gPGL5YEPfRg5QZggIThxxNJB03T3sCq9XoyqrEG9+6rHFXe0u4vU7
	Y0RpXVguRlOoKDsNmS+UcsSUiqZvqnMbHw2Um1qYv/f0lgTS08gJUyMb3xVum7WW
	cBE6OyE7dyfuCfzbAsWI31tipfZ4ipW64LrmcW6LgqSS5XcCi6y2WKA1E+YFs/Yw
	k+VZvUfv9ORAVCAOtdt9SnhF9kbVlJrJ7BkPcokFOOE1XIfo4oxoieyTrtjSPEjL
	FnlPKGttjWfwjIb2mQZ3C5k457eJ06OYLsdNvwFrhANZDDK/0d8n945Ss3upvfnu
	LV5cQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:48 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:47 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 387C23F7066;
	Mon,  6 Jul 2026 22:56:44 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 37/88] scsi: qla2xxx: Add size check for extended VP report ID entry
Date: Tue, 7 Jul 2026 11:23:44 +0530
Message-ID: <20260707055435.2680300-38-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: YE8ivbaMNdWqj1DBSp-QFeZamo11tAxn
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9520 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=0iNNLWs7SH7HZXNUcMcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: YE8ivbaMNdWqj1DBSp-QFeZamo11tAxn
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX26jtNK9eOf4c
 nz0ddxFlMNqpZeVTFB9Qkg29pt4Nbuv8JaI/Cs8XdS05SSQFIggBkde74i53EBGlT9GdH0iLxt5
 xljRIgferwx6IpVVT5ydrq+XbPMVHzI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX4vKtQ55YBju/
 m6wlXcHnf4AJscaU/N/7fHRA/tEqtRGHrGrRC8EtdLnwkyuM7wX37STvNioEuuBSZDi3mW3P2r1
 D1tP62jLrrCKXjDsKPZ7Cn8Hu/mpYYWfiXm8qs5AR0PzIhzMv8dWUbGQxrvvNR9jk82Sfp4NrIK
 /5ac4jee8VoFwsP0cm09sI7IMlUodIxolZc0qCtUPtQEzJHtEYPl7RrM8AborDfLCZfi/FxoCYe
 +2cHmTfAijQRk8lu31/uQeKdFJXpFum6senChqDfSRbndX5zAKQ84SEnqZY0Z0th0scpyUAOqsA
 CjoldZD+GKnSII9Vn6YRgkJN76GtunXUjxB05rS293XFOjIYCZH2mwEtAUO+a8AFfjJ1/0C8FUR
 mhc38eqmimmRxk/AyNQ5W+PlHbYA1jLM6mVS0yGe+cnboLD3GY46Z/i+vEJtdeV87cMPmxXMlLp
 cKXpVkiIniyZQhJlDBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Add reserved_end[64] padding to bring the struct to 128 bytes, matching
the hardware IOCB stride.  Change qla24xx_report_id_acquisition() to
accept a void pointer and extract vp_idx and vp_status from the extended
structure on 29xx series adapters, maintaining data integrity for the
larger IOCB format.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw29.h |  1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |  3 +--
 drivers/scsi/qla2xxx/qla_isr.c  |  3 +--
 drivers/scsi/qla2xxx/qla_mbx.c  | 32 +++++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index 088a220472a5..a4aa5bacb171 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -693,6 +693,7 @@ struct vp_rpt_id_entry_24xx_ext {
 			uint8_t remote_nport_id[4];
 		} f2;
 	} u;
+	uint8_t reserved_end[64];
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bba324febf09..cb48b9e15a44 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -266,8 +266,7 @@ extern int qla24xx_modify_vp_config(scsi_qla_host_t *);
 extern int qla2x00_send_change_request(scsi_qla_host_t *, uint16_t, uint16_t);
 extern void qla2x00_vp_stop_timer(scsi_qla_host_t *);
 extern int qla24xx_configure_vhba (scsi_qla_host_t *);
-extern void qla24xx_report_id_acquisition(scsi_qla_host_t *,
-    struct vp_rpt_id_entry_24xx *);
+extern void qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt);
 extern void qla2x00_do_dpc_all_vps(scsi_qla_host_t *);
 extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t *qla24xx_create_vhost(struct fc_vport *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7d2b6d135dc8..c6e2323518f7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4174,8 +4174,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    qla_sts_cont_data_size(rsp->hw));
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
-			qla24xx_report_id_acquisition(vha,
-			    (struct vp_rpt_id_entry_24xx *)pkt);
+			qla24xx_report_id_acquisition(vha, pkt);
 			break;
 		case LOGINOUT_PORT_IOCB_TYPE:
 			qla24xx_logio_entry(vha, rsp->req, pkt);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3ebda35dd584..cec308811d9e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4086,15 +4086,18 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 }
 
 void
-qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
-	struct vp_rpt_id_entry_24xx *rptid_entry)
+qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 {
 	struct qla_hw_data *ha = vha->hw;
+	struct vp_rpt_id_entry_24xx *rptid_entry = pkt;
+	struct vp_rpt_id_entry_24xx_ext *rptid_entry_ext = pkt;
 	scsi_qla_host_t *vp = NULL;
 	unsigned long   flags;
 	int found;
 	port_id_t id;
 	struct fc_port *fcport;
+	u16 vp_idx;
+	u8 vp_status;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b6,
 	    "Entered %s.\n", __func__);
@@ -4102,6 +4105,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	if (rptid_entry->entry_status != 0)
 		return;
 
+	if (IS_QLA29XX(ha)) {
+		vp_idx = rptid_entry_ext->vp_idx;
+		vp_status = rptid_entry_ext->vp_status;
+	} else {
+		vp_idx = rptid_entry->vp_idx;
+		vp_status = rptid_entry->vp_status;
+	}
+
 	id.b.domain = rptid_entry->port_id[2];
 	id.b.area   = rptid_entry->port_id[1];
 	id.b.al_pa  = rptid_entry->port_id[0];
@@ -4124,9 +4135,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	} else if (rptid_entry->format == 1) {
 		/* fabric */
 		ql_dbg(ql_dbg_async, vha, 0x10b9,
-		    "Format 1: VP[%d] enabled - status %d - with "
-		    "port id %02x%02x%02x.\n", rptid_entry->vp_idx,
-			rptid_entry->vp_status,
+		    "Format 1: VP[%d] enabled - status %d - with port id %02x%02x%02x.\n",
+		    vp_idx, vp_status,
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
 		ql_dbg(ql_dbg_async, vha, 0x5075,
@@ -4223,8 +4233,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		/* buffer to buffer credit flag */
 		vha->flags.bbcr_enable = (rptid_entry->u.f1.bbcr & 0xf) != 0;
 
-		if (rptid_entry->vp_idx == 0) {
-			if (rptid_entry->vp_status == VP_STAT_COMPL) {
+		if (vp_idx == 0) {
+			if (vp_status == VP_STAT_COMPL) {
 				/* FA-WWN is only for physical port */
 				if (qla_ini_mode_enabled(vha) &&
 				    ha->flags.fawwpn_enabled &&
@@ -4241,18 +4251,18 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 		} else {
-			if (rptid_entry->vp_status != VP_STAT_COMPL &&
-				rptid_entry->vp_status != VP_STAT_ID_CHG) {
+			if (vp_status != VP_STAT_COMPL &&
+				vp_status != VP_STAT_ID_CHG) {
 				ql_dbg(ql_dbg_mbx, vha, 0x10ba,
 				    "Could not acquire ID for VP[%d].\n",
-				    rptid_entry->vp_idx);
+				    vp_idx);
 				return;
 			}
 
 			found = 0;
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry(vp, &ha->vp_list, list) {
-				if (rptid_entry->vp_idx == vp->vp_idx) {
+				if (vp_idx == vp->vp_idx) {
 					found = 1;
 					break;
 				}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8e5d49abead4..f539190dd504 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8440,6 +8440,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
-- 
2.47.3

