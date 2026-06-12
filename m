Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9D038644D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258168; cv=none; b=s5shNHCvsiG/sIsakCHdzaolkmW0Hp5uPmCBJ4kz9mD67dQNl3qCHaGK0kAcej7LjtiR4XFiCJipLzc5A0s8Pp5YDn0yhTNXZ9yVvfI/BHelC1yy4WBh7xeoX7YpAv5DTnC+NwSwRaCyhT+CzCzSaozTZWmYuNfEiJj/pt8tRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258168; c=relaxed/simple;
	bh=vNL026c0HVyjZVs5zEijkbxk880MxSX+/ysVJhe2jus=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HpKuk0Igm2Tm1/l6WFH1fcq28rLzXOPEENN8nIr85Dtz6mXnpEjGg2mvHms5VJG1pf26vNs25qjGUgXLbh95ZFwmQvWCnbop6M7FDII11KWDnPWoHSCYDmdHVfgCX2t081MNedJv0FEAAfqiwi+UjR4LtktoaN37i3DORgTb3HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QhRW/Cwt; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QhRW/Cwt"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qTj038053;
	Fri, 12 Jun 2026 02:56:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=0
	KtZbTYsraI5fIxqdeRN0ZtnhGG1rfkaioG4lApIZAw=; b=QhRW/CwtHsmMZpgqb
	uS9NDDyrYmNcNEFtnZsYtJyQITOkr2uPAkJ3/40BcW2hCZh6uCRnKXF5Rghg90O0
	tnB+aBE7sZRqSM1Hv/QwNG349SrskiFFDvi+y6rNU0oQxcvOolIW3CDjgPQltOZT
	2afTd/4VHtVDdNGIyRmB291Sa+v6h1Hin6Zxy1T/BIm8LRTiOV62PCYKIW7blT0b
	SRK5VhOkCNv2cfcuqlkE9ApKnGxKjJgAmu1vGykRneibCuIEwsF0VlT6nBLlezeg
	vyJkvTA1s35iNuy/StLK5DS+a0p8cG3qUqWxKh9prkeT9La8C+lINqkyxyqQzXFD
	RiAlA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:03 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:02 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9ACFC3F7040;
	Fri, 12 Jun 2026 02:55:59 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 40/60] scsi: qla2xxx: Add size check for extended VP report ID entry
Date: Fri, 12 Jun 2026 15:23:13 +0530
Message-ID: <20260612095333.1666592-41-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX/IVL1nJyrDTR
 syJu/PvftlnVE2MPms5lyZELFRQmZst7A2NcyG27XccWdbMCPonEL4WYbpmtPGsaiHHCOLgqFlt
 XsS2s677Bs4KJp+/REpHs9wwmP5HKXM=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd7b3 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=0iNNLWs7SH7HZXNUcMcA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: FR4dHGaImSEHyXgCkz-U8QfHvBdrBt8v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX1PecZVfh6leJ
 W9H6i6/IKtyUvz0vqO7EZ8scho44ja8qemngZZzg4dGzUIMMujh98vL9caK3D+jJm2ZtgTwrBUL
 EFSHGMpAk8rnaHaMHVvRrQH60EguMhtfDzIaAdYC15TY5suzt1L7xdK/5DaZYKWqRA6b3UJXaUv
 E+FUHKr2TkWQyitk0EFRFggdJg53pYGhXvJYSSOGJB57aLmS8ld3DScZzCTgmwgZVK+NTQQvO7H
 ItTmG/EhRGOgnbKnwicS7xJ+THv/3o3XcQluoqHZ7GUfdL9eKDMVC6kx8W5J8+Rd+q7akb6Asyl
 jeW27x3Pk9j1B4rqMUUDg6n6uGk1x1fFmEXSIE7bB+TGlYv7c2JoTzxedg2/CiOVa7RpmY46qvz
 ArG+UXRqIgzK5qfT2GTCJwvIp4AUng2i4sX4VbyIEQVWMA/mI+WA1XWFo2ePTxroPf/gfMHXc+1
 b2ZeIxWqW/RZXZXEnwA==
X-Proofpoint-ORIG-GUID: FR4dHGaImSEHyXgCkz-U8QfHvBdrBt8v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Add reserved_end[64] padding to bring the struct to 128 bytes, matching
the hardware IOCB stride.  Change qla24xx_report_id_acquisition() to
accept a void pointer and extract vp_idx and vp_status from the extended
structure on 29xx series adapters, maintaining data integrity for the
larger IOCB format.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
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
index 9c12e99ba5bd..fa45d57e3e21 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4237,8 +4237,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla2x00_status_cont_entry(rsp, pkt);
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
-			qla24xx_report_id_acquisition(vha,
-			    (struct vp_rpt_id_entry_24xx *)pkt);
+			qla24xx_report_id_acquisition(vha, pkt);
 			break;
 		case LOGINOUT_PORT_IOCB_TYPE:
 			qla24xx_logio_entry(vha, rsp->req, pkt);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bdf03d92e552..1df48593017c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4094,15 +4094,18 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
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
@@ -4110,6 +4113,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
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
@@ -4132,9 +4143,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
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
@@ -4231,8 +4241,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		/* buffer to buffer credit flag */
 		vha->flags.bbcr_enable = (rptid_entry->u.f1.bbcr & 0xf) != 0;
 
-		if (rptid_entry->vp_idx == 0) {
-			if (rptid_entry->vp_status == VP_STAT_COMPL) {
+		if (vp_idx == 0) {
+			if (vp_status == VP_STAT_COMPL) {
 				/* FA-WWN is only for physical port */
 				if (qla_ini_mode_enabled(vha) &&
 				    ha->flags.fawwpn_enabled &&
@@ -4249,18 +4259,18 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
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
index 397f2ffa56d1..d8945cab3251 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8439,6 +8439,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
-- 
2.47.3

