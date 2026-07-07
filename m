Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDDF33DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403801; cv=none; b=PqYRtYO20Wkbs9WQ1UwqZENgjcVshvwCcr+VtDLWHuoo0MB63pKGXS97/kn09ISspIKkIqJb6ILt3XG1QLjSc/3QTYcqsxyfrlH+kqTCsvMeEZaplQZs+8o1ODb+b8MQwRCuope5DOBSGRxxIob4VhgWzMsT1f9l0sD0oTTUXzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403801; c=relaxed/simple;
	bh=6ToWKH/5yTeap0SKGEjP0Vvm1kFkQX1ZOmTI424fp38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CqxsBUO0sL0YYBpoPTcGzXt9VMkpW/z4QmI7tSivhWsfFkt/+tWv2XAAzP3ij8f4GKuQssNjQMW9ptyrqjDD7MXY3PoYyoX6D/05NXHHmXcHy22NYc4Ve2AftPB938D2xZjUc7LAVmpOS9IY6FYWnPz11Zps6wqxClSjGe1fmJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jCDf238d; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jCDf238d"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6674834M872825;
	Mon, 6 Jul 2026 22:56:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=P
	PJfwF/5cJdUozGM+lq6cmYkITyQB+scSYiQBuThL80=; b=jCDf238dRGZNbWdFM
	OcW9KwTVnqqPY3VMqMQJfIoTLp8uOah9L4j6JlphnK7oBDn0YRiRxTLPRdQkoVjI
	pC9j3LhCfAn4nhr8w38B7tZ6GdAe/fhhoLBksYBee3ktwrLWH6svsZrFYn1H/7sq
	/LpFJyP51QhzROBWQkCarv5oWf98Rj6rfYQ6tubK+wL9j1u9t7/miw6eKI1FAYfe
	HpPzcIZZ6XE09NOc7bsnYCO9ckHm/+Wl6DlgLHr9ZFzH25tJ5fgwL/+mhM8sW21M
	QcVB3A5Un+tHvw/VBTXV8rW7THEIcuCexi6WJkM52TDNqmJk1WkzSj/AMcNlUKYa
	TMNbg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BA52F3F7067;
	Mon,  6 Jul 2026 22:56:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 33/88] scsi: qla2xxx: Add abort command handling for 29xx series
Date: Tue, 7 Jul 2026 11:23:40 +0530
Message-ID: <20260707055435.2680300-34-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: QARQKYt7SvvqQZX2w5CCp4z6oXgf0qkp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX496dJd7aE82V
 9mVdGoko8sc8AcPrgX0Ey6YKEn9Z30Q92yVGVwLCWmPC4MmdOzkSJTWnPQKoYxC5/zfTu5llLB2
 Yy11hVCPLOtzf3K941aackXtA/oBjlt099Jf8Qwpk5KBP+HlfabAywtUKwxOZMVMh/H/QNZlJi/
 P+ldGWKqWne245rs5qmcUJKLTK8+31MUKQ4R/5VY3GiLT1uFh6kbrpBWh6DN4feIV/TMEf3Bo6A
 j3aQ2mILZr2sNhhjlYy0l8LNGocA+jrzH/QzPM59sKhbiSorxb6Ej+h5GfbDBv1yCuYN+CEvNkQ
 0h5ttVRtOffaHXNrpA+7DYtf/OpIOR9vZfUK8LQjvWhrnlApz030irYU3pBn23vr4nWAenK4AWr
 6I6XoUSEh3tehGGv/CpaUhMww9qk9qWaNEIatToL7g7/ry+UVkZ9313sGdyUIw9gNCzl0AoXE+a
 FsmKi2GUtCdVJTXWCWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX+NIW2anNr9Lu
 rO2hX6SNPWmU06UhjunuiYbwhFVlQsHMbsscf7yGpNvL39p/eL7dwjM/P/Nm31mmsereoTuABtu
 0A3MaaAgJ7jCSTus8w57X0KmnZMNAQs=
X-Proofpoint-GUID: QARQKYt7SvvqQZX2w5CCp4z6oXgf0qkp
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9515 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=6rvhxTjoopgx-VfHQW4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Extend the abort-IOCB code path to support the 29xx extended
abort_entry_24xx_ext structure alongside the existing
abort_entry_24xx.

The two layouts overlay byte-for-byte through req_que_no
(offsets 0-17): entry_status (offset 3), the
nport_handle/comp_status union (offset 8), and options (offset 10)
sit at identical positions in both.  After that they diverge: the
24xx variant carries reserved_1[30], port_id[3], and a u8 vp_index
at offsets 48-51, while the ext variant places a __le16 vp_index at
offset 18 and drops port_id.  The drv / fw unions live at offset 56
in the 24xx layout but offset 24 in ext.

Leverage this overlap by using a single struct abort_entry_24xx *
view for the common header writes (entry_type, count, handle,
nport_handle, handle_to_abort, req_que_no) and completion-status
reads (entry_status, comp_status), branching on IS_QLA29XX() only
where the layouts genuinely diverge:

  - port_id (24xx-only) and vp_index width on the issue path
    (qla24xx_abort_iocb in qla_iocb.c, qla24xx_abort_command in
    qla_mbx.c);
  - drv / fw union access in qla_nvme_abort_set_option /
    qla_nvme_abort_process_comp_status (qla_nvme.c);
  - completion comp_status read in qla24xx_abort_iocb_entry
    (qla_isr.c) is stride-agnostic -- no IS_QLA29XX dispatch
    needed.

Function signatures in qla_nvme_abort_set_option(),
qla_nvme_abort_process_comp_status(), qla24xx_abort_iocb(), and
qla24xx_abort_iocb_entry() are widened to accept void * so both
struct variants can be passed through.  memset() uses
qla_req_entry_size(ha) to match the ring-slot size.  Response
status checking now reads comp_status instead of nport_handle.  A
BUILD_BUG_ON verifies abort_entry_24xx_ext is 128 bytes.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  6 ++--
 drivers/scsi/qla2xxx/qla_iocb.c | 52 ++++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_isr.c  | 14 ++++++---
 drivers/scsi/qla2xxx/qla_mbx.c  | 45 ++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_nvme.c | 54 +++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 6 files changed, 120 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4ac3cb08fcc9..bba324febf09 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -989,10 +989,8 @@ extern void qla24xx_process_purex_list(struct purex_list *);
 extern void qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp);
 extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
 extern void qla_wait_nvme_release_cmd_kref(srb_t *sp);
-extern void qla_nvme_abort_set_option
-		(struct abort_entry_24xx *abt, srb_t *sp);
-extern void qla_nvme_abort_process_comp_status
-		(struct abort_entry_24xx *abt, srb_t *sp);
+extern void qla_nvme_abort_set_option(void *pkt, srb_t *sp);
+extern void qla_nvme_abort_process_comp_status(void *pkt, srb_t *sp);
 struct scsi_qla_host *qla_find_host_by_vp_idx(struct scsi_qla_host *vha,
 	uint16_t vp_idx);
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 98d735c216da..7d0392074760 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3852,32 +3852,50 @@ qla82xx_start_scsi(srb_t *sp)
 }
 
 static void
-qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
+qla24xx_abort_iocb(srb_t *sp, void *pkt)
 {
 	struct srb_iocb *aio = &sp->u.iocb_cmd;
 	scsi_qla_host_t *vha = sp->vha;
+	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = sp->qpair->req;
 	srb_t *orig_sp = sp->cmd_sp;
+	struct abort_entry_24xx *abt = pkt;
 
-	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
-	abt_iocb->entry_type = ABORT_IOCB_TYPE;
-	abt_iocb->entry_count = 1;
-	abt_iocb->handle = make_handle(req->id, sp->handle);
-	if (sp->fcport) {
-		abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-		abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
-		abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
-		abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	}
-	abt_iocb->handle_to_abort =
-		make_handle(le16_to_cpu(aio->u.abt.req_que_no),
-			    aio->u.abt.cmd_hndl);
-	abt_iocb->vp_index = vha->vp_idx;
-	abt_iocb->req_que_no = aio->u.abt.req_que_no;
+	/*
+	 * abort_entry_24xx_ext overlays abort_entry_24xx through
+	 * req_que_no (offsets 0-17).  After that the layouts diverge:
+	 * the 24xx variant has 30 bytes of reserved_1 followed by
+	 * port_id[3] and a u8 vp_index at offsets 48-51, while the
+	 * ext variant places a __le16 vp_index at offset 18 and has
+	 * no port_id field.  Common-header writes go through one
+	 * struct abort_entry_24xx * view; only port_id / vp_index
+	 * branch on stride.
+	 */
+	memset(pkt, 0, qla_req_entry_size(ha));
+	abt->entry_type = ABORT_IOCB_TYPE;
+	abt->entry_count = 1;
+	abt->handle = make_handle(req->id, sp->handle);
+	if (sp->fcport)
+		abt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	abt->handle_to_abort =
+	    make_handle(le16_to_cpu(aio->u.abt.req_que_no),
+			aio->u.abt.cmd_hndl);
+	abt->req_que_no = aio->u.abt.req_que_no;
+	if (IS_QLA29XX(ha)) {
+		((struct abort_entry_24xx_ext *)pkt)->vp_index =
+		    cpu_to_le16(vha->vp_idx);
+	} else {
+		if (sp->fcport) {
+			abt->port_id[0] = sp->fcport->d_id.b.al_pa;
+			abt->port_id[1] = sp->fcport->d_id.b.area;
+			abt->port_id[2] = sp->fcport->d_id.b.domain;
+		}
+		abt->vp_index = vha->vp_idx;
+	}
 
 	/* need to pass original sp */
 	if (orig_sp)
-		qla_nvme_abort_set_option(abt_iocb, orig_sp);
+		qla_nvme_abort_set_option(pkt, orig_sp);
 
 	/* Send the command to the firmware */
 	wmb();
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index afd685d48c6e..dd4416a3bf3a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3960,7 +3960,7 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 
 static void
 qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
-	struct abort_entry_24xx *pkt)
+	void *pkt)
 {
 	const char func[] = "ABT_IOCB";
 	srb_t *sp;
@@ -3972,7 +3972,14 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 
 	abt = &sp->u.iocb_cmd;
-	abt->u.abt.comp_status = pkt->comp_status;
+	/*
+	 * abort_entry_24xx_ext overlays abort_entry_24xx through the
+	 * nport_handle/comp_status union at offset 8, so reading
+	 * comp_status is stride-agnostic and goes through the 24xx view.
+	 */
+	abt->u.abt.comp_status =
+	    ((struct abort_entry_24xx *)pkt)->comp_status;
+
 	orig_sp = sp->cmd_sp;
 	/* Need to pass original sp */
 	if (orig_sp)
@@ -4174,8 +4181,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla_marker_iocb_entry(vha, rsp->req, pkt);
 			break;
 		case ABORT_IOCB_TYPE:
-			qla24xx_abort_iocb_entry(vha, rsp->req,
-			    (struct abort_entry_24xx *)pkt);
+			qla24xx_abort_iocb_entry(vha, rsp->req, pkt);
 			break;
 		case MBX_IOCB_TYPE:
 			qla24xx_mbx_iocb_entry(vha, rsp->req,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9bef87862077..0d7aa6fce007 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3324,7 +3324,7 @@ qla24xx_abort_command(srb_t *sp)
 {
 	int		rval;
 	unsigned long   flags = 0;
-
+	void		*abt_buf;
 	struct abort_entry_24xx *abt;
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
@@ -3356,28 +3356,42 @@ qla24xx_abort_command(srb_t *sp)
 		return QLA_ERR_NOT_FOUND;
 	}
 
-	abt = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
-	if (abt == NULL) {
+	abt_buf = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
+	if (abt_buf == NULL) {
 		ql_log(ql_log_warn, vha, 0x108d,
 		    "Failed to allocate abort IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
+	abt = abt_buf;
 
+	/*
+	 * abort_entry_24xx_ext overlays abort_entry_24xx through
+	 * req_que_no (offsets 0-17), and entry_status (offset 3) and
+	 * comp_status (offset 8) sit at identical offsets in both, so
+	 * the common header writes and the completion-status reads are
+	 * stride-agnostic and go through the 24xx view.  Only port_id
+	 * (24xx-only) and vp_index width / offset diverge per stride.
+	 */
 	abt->entry_type = ABORT_IOCB_TYPE;
 	abt->entry_count = 1;
 	abt->handle = make_handle(req->id, abt->handle);
 	abt->nport_handle = cpu_to_le16(fcport->loop_id);
 	abt->handle_to_abort = make_handle(req->id, handle);
-	abt->port_id[0] = fcport->d_id.b.al_pa;
-	abt->port_id[1] = fcport->d_id.b.area;
-	abt->port_id[2] = fcport->d_id.b.domain;
-	abt->vp_index = fcport->vha->vp_idx;
-
 	abt->req_que_no = cpu_to_le16(req->id);
+	if (IS_QLA29XX(ha)) {
+		((struct abort_entry_24xx_ext *)abt)->vp_index =
+		    cpu_to_le16(fcport->vha->vp_idx);
+	} else {
+		abt->port_id[0] = fcport->d_id.b.al_pa;
+		abt->port_id[1] = fcport->d_id.b.area;
+		abt->port_id[2] = fcport->d_id.b.domain;
+		abt->vp_index = fcport->vha->vp_idx;
+	}
+
 	/* Need to pass original sp */
-	qla_nvme_abort_set_option(abt, sp);
+	qla_nvme_abort_set_option(abt_buf, sp);
 
-	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
+	rval = qla2x00_issue_iocb(vha, abt_buf, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x108e,
 		    "Failed to issue IOCB (%x).\n", rval);
@@ -3386,11 +3400,11 @@ qla24xx_abort_command(srb_t *sp)
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    abt->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (abt->nport_handle != cpu_to_le16(0)) {
+	} else if (abt->comp_status != cpu_to_le16(0)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1090,
 		    "Failed to complete IOCB -- completion status (%x).\n",
-		    le16_to_cpu(abt->nport_handle));
-		if (abt->nport_handle == cpu_to_le16(CS_IOCB_ERROR))
+		    le16_to_cpu(abt->comp_status));
+		if (abt->comp_status == cpu_to_le16(CS_IOCB_ERROR))
 			rval = QLA_FUNCTION_PARAMETER_ERROR;
 		else
 			rval = QLA_FUNCTION_FAILED;
@@ -3398,12 +3412,13 @@ qla24xx_abort_command(srb_t *sp)
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1091,
 		    "Done %s.\n", __func__);
 	}
+
 	if (rval == QLA_SUCCESS)
-		qla_nvme_abort_process_comp_status(abt, sp);
+		qla_nvme_abort_process_comp_status(abt_buf, sp);
 
 	qla_wait_nvme_release_cmd_kref(sp);
 
-	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
+	dma_pool_free(ha->s_dma_pool, abt_buf, abt_dma);
 
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index b2eacf0277f4..8fa980db6ce4 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1067,36 +1067,69 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	return ret;
 }
 
-void qla_nvme_abort_set_option(struct abort_entry_24xx *abt, srb_t *orig_sp)
+void qla_nvme_abort_set_option(void *pkt, srb_t *orig_sp)
 {
 	struct qla_hw_data *ha;
+	struct abort_entry_24xx *abt = pkt;
 
 	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
 		return;
 
 	ha = orig_sp->fcport->vha->hw;
 
+	/*
+	 * abort_entry_24xx_ext overlays abort_entry_24xx through 'options'
+	 * (offset 10), so options writes are stride-agnostic.  The drv
+	 * union sits at offset 56 in the 24xx layout but offset 24 in the
+	 * ext layout, so the drv writes need a typed pointer.
+	 */
 	WARN_ON_ONCE(abt->options & cpu_to_le16(BIT_0));
-	/* Use Driver Specified Retry Count */
 	abt->options |= cpu_to_le16(AOF_ABTS_RTY_CNT);
-	abt->drv.abts_rty_cnt = cpu_to_le16(2);
-	/* Use specified response timeout */
 	abt->options |= cpu_to_le16(AOF_RSP_TIMEOUT);
-	/* set it to 2 * r_a_tov in secs */
-	abt->drv.rsp_timeout = cpu_to_le16(2 * (ha->r_a_tov / 10));
+	if (IS_QLA29XX(ha)) {
+		struct abort_entry_24xx_ext *abt_ext = pkt;
+
+		abt_ext->drv.abts_rty_cnt = cpu_to_le16(2);
+		abt_ext->drv.rsp_timeout =
+		    cpu_to_le16(2 * (ha->r_a_tov / 10));
+	} else {
+		abt->drv.abts_rty_cnt = cpu_to_le16(2);
+		abt->drv.rsp_timeout = cpu_to_le16(2 * (ha->r_a_tov / 10));
+	}
 }
 
-void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, srb_t *orig_sp)
+void qla_nvme_abort_process_comp_status(void *pkt, srb_t *orig_sp)
 {
 	u16	comp_status;
 	struct scsi_qla_host *vha;
+	u8	rjt_vendor_unique, rjt_reason_expl, rjt_reason_code;
+	struct abort_entry_24xx *abt = pkt;
 
 	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
 		return;
 
 	vha = orig_sp->fcport->vha;
 
+	/*
+	 * comp_status sits at offset 8 in both layouts (the
+	 * nport_handle/comp_status union), so the read is
+	 * stride-agnostic.  The fw union, like drv, lives at offset
+	 * 56 in the 24xx layout and offset 24 in the ext layout, so
+	 * those byte reads still need a typed pointer.
+	 */
 	comp_status = le16_to_cpu(abt->comp_status);
+	if (IS_QLA29XX(vha->hw)) {
+		struct abort_entry_24xx_ext *abt_ext = pkt;
+
+		rjt_vendor_unique = abt_ext->fw.ba_rjt_vendorUnique;
+		rjt_reason_expl = abt_ext->fw.ba_rjt_reasonCodeExpl;
+		rjt_reason_code = abt_ext->fw.ba_rjt_reasonCode;
+	} else {
+		rjt_vendor_unique = abt->fw.ba_rjt_vendorUnique;
+		rjt_reason_expl = abt->fw.ba_rjt_reasonCodeExpl;
+		rjt_reason_code = abt->fw.ba_rjt_reasonCode;
+	}
+
 	switch (comp_status) {
 	case CS_RESET:		/* reset event aborted */
 	case CS_ABORTED:	/* IOCB was cleaned */
@@ -1116,11 +1149,8 @@ void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, srb_t *ori
 	/* BA_RJT was received for the ABTS */
 	case CS_REJECT_RECEIVED:
 		ql_dbg(ql_dbg_async, vha, 0xf09e,
-		       "BA_RJT was received for the ABTS rjt_vendorUnique = %u",
-			abt->fw.ba_rjt_vendorUnique);
-		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
-		       "ba_rjt_reasonCodeExpl = %u, ba_rjt_reasonCode = %u\n",
-		       abt->fw.ba_rjt_reasonCodeExpl, abt->fw.ba_rjt_reasonCode);
+		    "BA_RJT was received for the ABTS rjt_vendorUnique=%u, ba_rjt_reasonCodeExpl=%u, ba_rjt_reasonCode=%u\n",
+		    rjt_vendor_unique, rjt_reason_expl, rjt_reason_code);
 		break;
 
 	case CS_COMPLETE:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6c951839507b..d9141d62bbb5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8358,6 +8358,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(request_t) != 64);
 	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct abort_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct abort_iocb_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
-- 
2.47.3

