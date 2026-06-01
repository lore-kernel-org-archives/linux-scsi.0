Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B203A1CD
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309868; cv=none; b=fdmioQOGjwJFRPc+ENEd4eaP26nmLK4XRD4QZnfG/A8f2umCr3XbC+qGzUlMOHKHwpuIbH8cuwOiXGpQatvQVplGE+48EC3i8eEn0Fj93hPg+mhKZAf6fLmsf3qAqRAb8IUlXOdtwD9CpHQ/G5k1drqpNmfhhLEGpi/anmPoiEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309868; c=relaxed/simple;
	bh=MW5iB+OWutp43lOG8NJdKK+5bUrh8Rnxd5nQAkECVNo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJgqoNl6jaD7j02EkNQvdMomtfXB2kzh6v24cVRm5FPVvfRycSKbVG8pktLN+YkchbYM+euS8sSUDe3qaRsJHLNghgP7ycdQgMKte2HrZPHVZ5Wan4WA5UMol12bqcGqnmlVlfvcWR6fbAs7kcR4HsqsGcJF7aJDeEeNhJOWLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=B7EPjJ1c; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="B7EPjJ1c"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLc5Q41194256;
	Mon, 1 Jun 2026 03:31:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	OD2aF5GrhVDyyzOH7VX0jk5mMtuDsZmTFeLcYIyugs=; b=B7EPjJ1cyI2guNVlP
	XAwbBXEe8gvWKBM7aoC0YYUiYFn6n3s1oaNaSEbYrg5c8Py9MjWQ5vFhfwDQAtXZ
	EdQcHdW5sDyDkpBvAOVndw/oP/vBJnUq6B6iBN3EdjICFa3ETY8y4H2zLUdHWnfj
	gaE/rbdXE6P15/lBltQo96BEti49onaU8jC/LxNyTu8DR0maZBbXTjx17zIFFyRI
	SlV52M0gS/1yqEY3j7WS9r6OUwauLgrJGs8DpymW/jotEirerR6b0ZIEagCbp5QB
	NlkZ/XDlg1MeR2DV7cC3Rn2irC5C4Bz197TFcw43YiVh/8cqtg86JhLUUWcNusnH
	AQKKA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:31:01 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:31:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:31:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CE4DA3F7053;
	Mon,  1 Jun 2026 03:30:57 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 34/44] scsi: qla2xxx: Add 29xx extended logio IOCB support
Date: Mon, 1 Jun 2026 15:58:43 +0530
Message-ID: <20260601102853.328426-35-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXyP66WtoHoQfk
 iKg7PLA1jTScRBjirBm4Blu9xWkKnsJoP1mdeboCoorqyyPJ7exVyIcgvXpcZbDJ4vtCapIw96/
 6vZUinLhAavQabwf5otzqM7XsTwN3YlvUoFiBG49vxDy8kMck5ohYSDvsGviw1NxwB3JZv7PSz8
 e6poSafCa8lhfUO4S261/7YO8a8RPMoQxu1W1zEKdZaMMhSoDJUKyF4PUvvKCM5Be8nXFSd7EYC
 304E9cJaCVs30WmBPvPkIVg5PHOV+JJMmcAiehWK1dOmrPuDBEkuMgNbk5iXe10kwF5ICODQj8K
 Fl00eWq+xt0kF+gN5PQXSf127+QrNMLco2LagtlKYoQhTa3sHdfGXkFrbJGgOrX5zzJgMjPTOQ+
 6SkGSNZCbrserpHQS7HoamyjQH16+K6iJzHhPqRheh3UN1jAu3x4ZTwZd6XnUH8s5YrG/ybuo5y
 ISpCYgXp6/tyAXNy5BQ==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f66 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=Gumq7SjJhAU_j5rd-wgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: gi_0UkgWXlSco-m7ZBtK_xVbXthCucTj
X-Proofpoint-GUID: gi_0UkgWXlSco-m7ZBtK_xVbXthCucTj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

The 29xx series uses a wider IOCB stride (128 bytes vs 64 bytes).
The logio_entry_24xx_ext layout extends logio_entry_24xx with a
wider vp_index field (__le16 vs u8) while keeping all other
read-side fields (comp_status, io_parameter[0..10], entry_status)
at identical offsets and widths.

Update the logio IOCB builder functions (qla24xx_login_iocb,
qla24xx_logout_iocb, qla24xx_prli_iocb, qla24xx_prlo_iocb,
qla24xx_adisc_iocb) to accept a void pointer and dispatch the
vp_index write through IS_QLA29XX(), using an inline cast to the
extended layout at the single write site.

In the completion handler qla24xx_logio_entry(), accept a void
pointer and read through a single logio_entry_24xx view since all
accessed fields sit at the same offsets in both layouts.  Use the
qla_req_entry_size() helper for the dump buffer size.

In qla24xx_login_fabric() and qla24xx_fabric_logout(), allocate
through a void pointer from the DMA pool and dispatch vp_index
via the same inline-cast pattern.

Add a BUILD_BUG_ON for logio_entry_24xx_ext to enforce the 128-byte
size invariant at compile time.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 48 ++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  | 41 ++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c  | 35 ++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 4 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5c11f01d5c21..b67ecf8ad00d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2491,8 +2491,9 @@ qla2x00_alloc_iocbs(struct scsi_qla_host *vha, srb_t *sp)
 }
 
 static void
-qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_prli_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2519,12 +2520,17 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(sp->vha->vp_idx);
+	else
+		logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
-qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_login_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2549,7 +2555,11 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(sp->vha->vp_idx);
+	else
+		logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
@@ -2577,9 +2587,11 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
-qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_logout_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	u16 control_flags = LCF_COMMAND_LOGO;
+
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 
 	if (sp->fcport->explicit_logout) {
@@ -2596,7 +2608,11 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(sp->vha->vp_idx);
+	else
+		logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
@@ -2618,12 +2634,18 @@ qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
-qla24xx_adisc_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_adisc_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
+
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags = cpu_to_le16(LCF_COMMAND_ADISC);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	logio->vp_index = sp->vha->vp_idx;
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(sp->vha->vp_idx);
+	else
+		logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
@@ -3986,8 +4008,10 @@ qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
 }
 
 static void
-qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_prlo_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
+
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags =
 	    cpu_to_le16(LCF_COMMAND_PRLO|LCF_IMPL_PRLO);
@@ -3996,7 +4020,11 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(sp->fcport->vha->vp_idx);
+	else
+		logio->vp_index = sp->fcport->vha->vp_idx;
 }
 
 static int qla_get_iocbs_resource(struct srb *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 786e090e4037..6f97da237d0f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2593,8 +2593,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 }
 
 static void
-qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
-    struct logio_entry_24xx *logio)
+qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req, void *pkt)
 {
 	const char func[] = "LOGIO-IOCB";
 	const char *type;
@@ -2604,8 +2603,20 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	uint16_t *data;
 	uint32_t iop[2];
 	int logit = 1;
+	struct qla_hw_data *ha = vha->hw;
+	/*
+	 * logio_entry_24xx_ext overlays logio_entry_24xx through
+	 * io_parameter[10]: comp_status, io_parameter[0..10] and
+	 * entry_status are at identical offsets and types in both layouts
+	 * (only vp_index width differs, and that field is write-only on
+	 * the issue path).  So all reads in this completion handler are
+	 * stride-agnostic and we read through a single struct
+	 * logio_entry_24xx * view; the trailing reserved_2[64] of the
+	 * extended layout is irrelevant here.
+	 */
+	struct logio_entry_24xx *logio = pkt;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, logio);
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (!sp)
 		return;
 
@@ -2625,7 +2636,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    logio->entry_status);
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x504d,
-		    logio, sizeof(*logio));
+		    pkt, qla_req_entry_size(ha));
 
 		goto logio_done;
 	}
@@ -2636,7 +2647,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    type, sp->handle, fcport->d_id.b24, fcport->port_name,
 		    le32_to_cpu(logio->io_parameter[0]));
 
-		vha->hw->exch_starvation = 0;
+		ha->exch_starvation = 0;
 		data[0] = MBS_COMMAND_COMPLETE;
 
 		if (sp->type == SRB_PRLI_CMD) {
@@ -2675,6 +2686,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	iop[0] = le32_to_cpu(logio->io_parameter[0]);
 	iop[1] = le32_to_cpu(logio->io_parameter[1]);
+
 	lio->u.logio.iop[0] = iop[0];
 	lio->u.logio.iop[1] = iop[1];
 	switch (iop[0]) {
@@ -2699,14 +2711,14 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		data[0] = MBS_COMMAND_ERROR;
 		break;
 	case LSC_SCODE_NOXCB:
-		vha->hw->exch_starvation++;
-		if (vha->hw->exch_starvation > 5) {
+		ha->exch_starvation++;
+		if (ha->exch_starvation > 5) {
 			ql_log(ql_log_warn, vha, 0xd046,
 			    "Exchange starvation. Resetting RISC\n");
 
-			vha->hw->exch_starvation = 0;
+			ha->exch_starvation = 0;
 
-			if (IS_P3P_TYPE(vha->hw))
+			if (IS_P3P_TYPE(ha))
 				set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 			else
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -2722,16 +2734,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		ql_log(ql_log_warn, sp->vha, 0x5037, "Async-%s failed: "
 		       "handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
 		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
-		       le16_to_cpu(logio->comp_status),
-		       le32_to_cpu(logio->io_parameter[0]),
-		       le32_to_cpu(logio->io_parameter[1]));
+		       le16_to_cpu(logio->comp_status), iop[0], iop[1]);
 	else
 		ql_dbg(ql_dbg_disc, sp->vha, 0x5037, "Async-%s failed: "
 		       "handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
 		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
-		       le16_to_cpu(logio->comp_status),
-		       le32_to_cpu(logio->io_parameter[0]),
-		       le32_to_cpu(logio->io_parameter[1]));
+		       le16_to_cpu(logio->comp_status), iop[0], iop[1]);
 
 logio_done:
 	sp->done(sp, 0);
@@ -4139,8 +4147,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
 			break;
 		case LOGINOUT_PORT_IOCB_TYPE:
-			qla24xx_logio_entry(vha, rsp->req,
-			    (struct logio_entry_24xx *)pkt);
+			qla24xx_logio_entry(vha, rsp->req, pkt);
 			break;
 		case CT_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e70d7521e825..ea8f4dddbc99 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2573,7 +2573,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
 {
 	int		rval;
-
+	void		*lg_buf;
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	uint32_t	iop[2];
@@ -2588,12 +2588,13 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	else
 		req = ha->req_q_map[0];
 
-	lg = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
-	if (lg == NULL) {
+	lg_buf = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
+	if (!lg_buf) {
 		ql_log(ql_log_warn, vha, 0x1062,
 		    "Failed to allocate login IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
+	lg = lg_buf;
 
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
@@ -2607,8 +2608,13 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = vha->vp_idx;
-	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	if (IS_QLA29XX(ha))
+		((struct logio_entry_24xx_ext *)lg)->vp_index =
+		    cpu_to_le16(vha->vp_idx);
+	else
+		lg->vp_index = vha->vp_idx;
+
+	rval = qla2x00_issue_iocb_timeout(vha, lg_buf, lg_dma, 0,
 	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1063,
@@ -2678,7 +2684,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 						 */
 	}
 
-	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);
 
 	return rval;
 }
@@ -2849,6 +2855,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int		rval;
+	void		*lg_buf;
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	struct qla_hw_data *ha = vha->hw;
@@ -2857,12 +2864,13 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
 	    "Entered %s.\n", __func__);
 
-	lg = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
-	if (lg == NULL) {
+	lg_buf = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
+	if (!lg_buf) {
 		ql_log(ql_log_warn, vha, 0x106e,
 		    "Failed to allocate logout IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
+	lg = lg_buf;
 
 	req = vha->req;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2875,8 +2883,13 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = vha->vp_idx;
-	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	if (IS_QLA29XX(ha))
+		((struct logio_entry_24xx_ext *)lg)->vp_index =
+		    cpu_to_le16(vha->vp_idx);
+	else
+		lg->vp_index = vha->vp_idx;
+
+	rval = qla2x00_issue_iocb_timeout(vha, lg_buf, lg_dma, 0,
 	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x106f,
@@ -2898,7 +2911,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "Done %s.\n", __func__);
 	}
 
-	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);
 
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9d6baa8a1f83..e128e3dee4b5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8382,6 +8382,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
 	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct logio_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
-- 
2.47.3

