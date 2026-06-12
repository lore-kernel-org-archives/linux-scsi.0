Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04A2368D43
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258148; cv=none; b=BQ9ZlYLwsAQLDi14Tqtnv59ufRkkTwAihZTXkbkctMruuCHTi0zPk+GbH6pvGN0nIWvHLbbqiLlYC4x8Fo2t4VJxlQm0wcSr3n3PBQXb48ll3Qne3attAChmiuFK9HywqWVPX3FId8Z5EZ4mkcgRpJmWIet09dpH6HRsAyBukDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258148; c=relaxed/simple;
	bh=dP3OdDvhE6Bsvt+ZMyXgWEtEgNROKu9m4yh18ipFW8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GryUzYw2muLk3S4L2XStTZYGiuLq4O+hhM6dOTcFkE7xesOxoSBzI6gayTgNaQw0H74tu0kZqRxiKH8sCczBi84rQqTDkdzWgP7clW61h8fNyguoNdsuu3EArxqS61x3FcpqMy0lU1SrbUkFUYUnEDeM6TD+Pe8XNExYoD3pXf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NH2EH8Yi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NH2EH8Yi"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38x5W3678669;
	Fri, 12 Jun 2026 02:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=X
	OqTrHDjUP4yFrOYDtKj2uZeH2nvmAo4S1zFGFBNigo=; b=NH2EH8YiSfZE+NyP9
	PaJlqGx8yyzsGdoQx7YihBfTouy1yxg3LG9r7e+ub38gN3djsJvv5upOVwT8K2xx
	N8zXVSizPS95NaNGjj5wOamTZMVP4fF/PANnwnRi19kvZzS1zFxTCsOZL1oMU2x3
	AmZR915QCjL2wscJTrusnjSh+/dEvsLLFxVjggx9iA/7qV9rZrApsIpYdXjjUw44
	3rehsvehZOBOGwkScTxr/VI4EXAfNkgYUymKaqTGWCAHhGLBojhSOe2z+49YtVma
	xJbFCOROFzkzYOvMWFsP7QTKd0we9TPASyDjSbTc40LKxtR94XgvbbYpM5N5jRSy
	XYXfA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92kx-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:43 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:41 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1A40F3F7040;
	Fri, 12 Jun 2026 02:55:38 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 34/60] scsi: qla2xxx: Add 29xx extended logio IOCB support
Date: Fri, 12 Jun 2026 15:23:07 +0530
Message-ID: <20260612095333.1666592-35-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: zofVcwodqcVuZ0xNVzDBQrcnPytyb0Wm
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd79f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=Gumq7SjJhAU_j5rd-wgA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX4bT9BOPF9qwR
 XM6w7I4ExrQ0/2qnrbcl5sgQkBaKGP2RVgP2tJMCJC3CTarWDmBFSkP0toQomhij11Sp4whJmEd
 3VZk+0twTwF6+kPrnNTAgDFDcU6ySBg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXxDbsjGfzRE4X
 cMOZjImVcQSaGudJ99rUtgLDuHSCNPoRDc9xxyx0ofVo9dPmtqgTvtDzGYQZF7tbEI/+T6u9omP
 sWaw7ypSmkmTWju9g6eugygzvcTwZ3Nq4UegF0SgamUCU1xIFbd5H0f65d3GRrmQngcA7BX8uoo
 g3Zr11FP9fq0O0MSMN0bxue6/uPrc63hQOtc+Rjf4tXo7mD3mIgWEaYOGwaDZPpNu3kc4Xr2v52
 nwNpVGr1s0QWJ+H+kOmSlFYilcxqzxUy2mLd89tIlKYrh9tTo7GvVMS8nUFdGifIfjGUHj+XUAU
 3RULFHEcbSlqR2cvWvo8k0W0VHjbJMHDfTBU7TW4X513C4OVyGp6UTjsTKesKwyWLYLPJhkH/Ex
 6O/xrsC8bvxfoQL5JEMZMsIgyo2kEvUSFnYmcNjvB8aBSDK9/Apxww1vVBTmrZDUXckDdUGPPNZ
 gzr1lxx6lSZ2MCrI2Rw==
X-Proofpoint-GUID: zofVcwodqcVuZ0xNVzDBQrcnPytyb0Wm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 48 ++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  | 41 ++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c  | 35 ++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 4 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 45d6837100ad..d0d3a56affdc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2488,8 +2488,9 @@ qla2x00_alloc_iocbs(struct scsi_qla_host *vha, srb_t *sp)
 }
 
 static void
-qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_prli_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2516,12 +2517,17 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
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
@@ -2546,7 +2552,11 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
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
@@ -2574,9 +2584,11 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
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
@@ -2593,7 +2605,11 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
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
@@ -2615,12 +2631,18 @@ qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
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
@@ -3983,8 +4005,10 @@ qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
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
@@ -3993,7 +4017,11 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
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
index 173b37b03d61..d76f201d694a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2635,8 +2635,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 }
 
 static void
-qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
-    struct logio_entry_24xx *logio)
+qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req, void *pkt)
 {
 	const char func[] = "LOGIO-IOCB";
 	const char *type;
@@ -2646,8 +2645,20 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
 
@@ -2667,7 +2678,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    logio->entry_status);
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x504d,
-		    logio, sizeof(*logio));
+		    pkt, qla_rsp_entry_size(ha));
 
 		goto logio_done;
 	}
@@ -2678,7 +2689,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    type, sp->handle, fcport->d_id.b24, fcport->port_name,
 		    le32_to_cpu(logio->io_parameter[0]));
 
-		vha->hw->exch_starvation = 0;
+		ha->exch_starvation = 0;
 		data[0] = MBS_COMMAND_COMPLETE;
 
 		if (sp->type == SRB_PRLI_CMD) {
@@ -2717,6 +2728,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	iop[0] = le32_to_cpu(logio->io_parameter[0]);
 	iop[1] = le32_to_cpu(logio->io_parameter[1]);
+
 	lio->u.logio.iop[0] = iop[0];
 	lio->u.logio.iop[1] = iop[1];
 	switch (iop[0]) {
@@ -2741,14 +2753,14 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
@@ -2764,16 +2776,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
@@ -4181,8 +4189,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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
index f9b326c02055..461b11df2e7e 100644
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
index 6ce29157a72c..3feaaed43857 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8391,6 +8391,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
 	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct logio_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
-- 
2.47.3

