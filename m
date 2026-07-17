Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62837140E5F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302261; cv=none; b=vDyIti+a9OJpecAKc2CDEwmauqWoyyaN68FLjrNDQhDbmnlNvo/OiX5ESlSoW87IlIr31wlQfX3/kAujWjwcTBtSIk5vJgvl9Kt9ZA7+oQLm9l1QPJw6CapfeihyAGqz/SEPZcLLR9B8FdKFDs0Cyw3CbBUGAPGJd8glEUWlZCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302261; c=relaxed/simple;
	bh=hYMz0345tRJ/fyjsp6NgtF5BBWhIo3cs5WjY6IcCIKs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJPOcJlzF5qZhbXcSarVdDHhFdGPELUMAU9nQQZBgUrCUlOjaL7KSzOV+XXIKskI5Q3WcfnEe+8ZmDDpO7UFSyMnAs1wf+lnJ+KmX0uC7bSAEjQh4g8p27OWhFFNs86OsHhXo9WE2OI4jh5pnw6N4NvKVeNRFnOT81Wsnl5xOtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DQlrC+9h; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DQlrC+9h"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5YXN2729498;
	Fri, 17 Jul 2026 08:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=t
	4tSc1FK5ac6dMAuBH7Ilt8Ft0hStRElh/J2rTP1IO0=; b=DQlrC+9h+CMYIZPHx
	Arx9Zx5Zp7JT7GdtTk1KdKppSrFnAfq4iN/J9bUj4XzalJEcuzLSbnfWqwc1z39H
	RvBh8eoiL0gKWefi1fW+RHXmGuwp2yBvEHbKUswJTSJWQpWvhlg8nl86X6+2C4z/
	HHRliF8Nek+lNwR4pX/ft3XJfuZQER0IiyJzt93KneDiVxIkSCJ13iBBgDZGh4Ns
	V6CiBpSlXvIgTyxh6M+/eF6Dc0Fpk+Txl9ZN/ESjfVd25XqABxYXzBmz3NaEfmjN
	1pNv/kidCsQADlXnvBJsvfWkRDbU8eqPVziWedgfkep57YuHYMxvz9aeGj4lXDld
	Enbtw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:56 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3F3BF5B693B;
	Fri, 17 Jul 2026 08:30:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 37/56] scsi: qla2xxx: Add size check for extended VP report ID entry
Date: Fri, 17 Jul 2026 20:58:45 +0530
Message-ID: <20260717152904.3155730-38-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: vkl0XRgLfRo6V64NeQGcKZUo6u25daXH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX9cFsSspZMtsg
 q1NNLJ8YUU/CpXjMQ51MJCna2RgsPOee8oWwAXfwPQSyuJtlfTXNgqvHhNVw1l2X7hLXkF3aorU
 ttRfSnE33JjnD/x/bmpmsLSLx32e/x/uAOPcOrbdU3vJA3z2k+XaYYofzrbgi0tViq3fTJr1kD0
 n7YVuMl1XxzYmaqKIBPD1Ovcqcv7waVVFK3GPINWSpqOQIhjyqBFGc/ORtAbk6hA/WJEAUZeSyq
 dQccnfTvPO+/RqgVoP9R7vD7SB3U26bOazoLtwAFBXXFPpd3eNATno9lyp5cBdbumKSP2glFsuw
 Lk4eLukHlVlk7Z2tMUiu8ipRQTUf9hEqGO/DBAI/41j0oTi1+V4iVNBw4DaF3Dgo7yw1OmTNZNy
 ZNUTENeIibymTKk9QlkCExy6rtITUdwccuwvrXQ7pYY4G0bokWaxJaPksRwIpN+vVvQr5QOQocZ
 jtfoN+BoSjnF1Ho1YMg==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4ab0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=0iNNLWs7SH7HZXNUcMcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: vkl0XRgLfRo6V64NeQGcKZUo6u25daXH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX0nd6ELuHzPfB
 oiYZ0z/UU4E0YeSWmUGjNs2b7ZtDxTxd9UawAVZzGwiFcqHvJ8vUHrvDv4q4jd4gr30/XBOiG1Q
 SE+cjRKLkOvV3u0TfxftnomLnWGgTwk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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
index fa302778d2ac..79a1e16d56ab 100644
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
index 128138b4d16a..085961e04ec2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4175,8 +4175,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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

