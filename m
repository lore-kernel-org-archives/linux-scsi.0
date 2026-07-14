Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5485355813
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022950; cv=none; b=TMOMJKCgAzfVVqIqBO31u+ZHIS2erAyc5qAICs6dkD2k22Zg6IeCveAEPNh+3hhxb0TttbnHM6gY85QcspFxelo+K2ibm7hKFiOkCCHOwRw80moM6Kqa5sRCRiJ8X0QWWt9qOQ0TXeu2E/Z0gLaUUX6ADdcHOSpvYSZa7MAZnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022950; c=relaxed/simple;
	bh=sbN6Ap9L8L7Qsrqmhn19BpaTKfCeGi9QuVFUiXN/tCc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBpp7XCV736esLSXzu3DgSVpToJZy1Tl7GDLbYcWzZdc9ZPOt967rboPjIC+YyW48rtsqHbuqPUOkgWDM0oybkulNlHPT/hduO7zqBFBI9022UN71ozqMXGFfU6Y57aZFkVI6uPxtT26n7uF/d7QEX+QpVizveJ0yk1zJo3p6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Owa933Eq; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Owa933Eq"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Uif33693326;
	Tue, 14 Jul 2026 02:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	vxgDrMgd3bT1/uQAO0DgFY1pwf04jgNA/rM/BHbSm8=; b=Owa933EqMj72hK0a0
	UJ0Z9J463kIpBAU5H4l7I+CLfLI8s+0veJDarOGKmZ4q+9WT6I6/8etZKkoQHZQp
	TcxHFzElfLZvqck2cfQEzzRIrw3scGPCLseFfrQaZZ3tbhiEbQQq4vEeP8q7T8Up
	xdYWvkuqyUHG6L7MmjgQOGtuh3WnVA/TMNlIEWfGfZjl92Qmrq5Kry8BoOntKA+9
	K4h+g8tt3X4Ajz4tARswlRT5tROTMm/9AX6aiKk2DZjwZtRWj2N8WnCV6aNdforf
	vO/gLzIMvsRo/yRyvlYhZSxmXEV4axAmPhvfDoWxmA0JLWBxJSLZVQWt1g/ZDL85
	CJIBA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:42 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:41 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 150645E6867;
	Tue, 14 Jul 2026 02:55:38 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 31/56] scsi: qla2xxx: Add 29xx extended logio IOCB support
Date: Tue, 14 Jul 2026 15:23:28 +0530
Message-ID: <20260714095353.289460-32-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: MFJl40_OXfkziqg_3aXMBgmBu89DX0gU
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a56079e cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=sRxA-cl792nyho4Z3XsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: MFJl40_OXfkziqg_3aXMBgmBu89DX0gU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXz3dbJqKB7yhq
 FAhIqYU9+1CJQ1/imST1U4jGgF8LRBacwpfO1EPjniZaZxzRuIEDTDjGkL96hqhVfoyxazV8Ts4
 fS3o7mso4+tdPgBN+PZRnbtd3LzNtj8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXxu1+PpYPYiQa
 7YEVS/z/HLjXLoUa6h/zlWc4Oyhb5NLvQ2lCbR0V5I/N+M1/OUk+jT9bUylXG7BDLUjyXXvOALy
 BzVNA2p6mCSY76BRiGHWhIi2x1Ur6/+8ooGwWUUb2kbHqPd+sVvX2x50MJ/FXF8mOGwHQAYcgSi
 oqzbR+bGY132dIf3fJnALxtDX3baQbfPjRbZzEdnBLSyKMysBL5AH88/F6U7vDxPnUA1XwHbTLE
 egBUU2DuECnuU+4mQpZAMpI98vxLttABJ6O2ZDm063rrskNVlDBQLucexTq7E7LKMnFWfWMH9QJ
 qu1W9TT2oU0K+b6WvNzZPdf7wj1R560JsFtf+uqlDyzSJR+3TuXbgcSMekIEumVczAzJ1zmjGap
 USZ2ChgG1RUkzKWS0odJ7JWUgvWsBZsJEAtZFZ4C2s13IKY18V3W3a6YjnIAOQeL6L/pitr8Z1D
 +34AEBd06jXbcOItXsg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_inline.h | 19 ++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 +++++++++++++--------
 drivers/scsi/qla2xxx/qla_isr.c    | 41 ++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_mbx.c    | 27 +++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c     |  1 +
 5 files changed, 78 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 2ade5e852251..d6140a92251f 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -119,6 +119,25 @@ qla_sts_cont_data_size(struct qla_hw_data *ha)
 		sizeof_field(sts_cont_entry_t, data);
 }
 
+/**
+ * qla_logio_set_vp_index() - write vp_index into a login/logout IOCB.
+ * @ha: HBA pointer
+ * @pkt: logio IOCB (logio_entry_24xx or logio_entry_24xx_ext)
+ * @vp_idx: virtual port index
+ *
+ * vp_index widens from u8 (logio_entry_24xx) to __le16
+ * (logio_entry_24xx_ext) on 29xx; write the field at the right width.
+ */
+static inline void
+qla_logio_set_vp_index(struct qla_hw_data *ha, void *pkt, u16 vp_idx)
+{
+	if (IS_QLA29XX(ha))
+		((struct logio_entry_24xx_ext *)pkt)->vp_index =
+			cpu_to_le16(vp_idx);
+	else
+		((struct logio_entry_24xx *)pkt)->vp_index = vp_idx;
+}
+
 static inline void
 qla2x00_poll(struct rsp_que *rsp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d4d7f75ca158..c7669541ce07 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2563,8 +2563,9 @@ qla2x00_alloc_iocbs(struct scsi_qla_host *vha, srb_t *sp)
 }
 
 static void
-qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_prli_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2591,12 +2592,13 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	qla_logio_set_vp_index(sp->vha->hw, pkt, sp->vha->vp_idx);
 }
 
 static void
-qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+qla24xx_login_iocb(srb_t *sp, void *pkt)
 {
+	struct logio_entry_24xx *logio = pkt;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
@@ -2621,7 +2623,7 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	qla_logio_set_vp_index(sp->vha->hw, pkt, sp->vha->vp_idx);
 }
 
 static void
@@ -2649,9 +2651,11 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
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
@@ -2668,7 +2672,7 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->vha->vp_idx;
+	qla_logio_set_vp_index(sp->vha->hw, pkt, sp->vha->vp_idx);
 }
 
 static void
@@ -2690,12 +2694,14 @@ qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
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
+	qla_logio_set_vp_index(sp->vha->hw, pkt, sp->vha->vp_idx);
 }
 
 static void
@@ -4056,8 +4062,10 @@ qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
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
@@ -4066,7 +4074,7 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	qla_logio_set_vp_index(sp->vha->hw, pkt, sp->fcport->vha->vp_idx);
 }
 
 static int qla_get_iocbs_resource(struct srb *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c286465ae013..afd685d48c6e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2583,8 +2583,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 }
 
 static void
-qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
-    struct logio_entry_24xx *logio)
+qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req, void *pkt)
 {
 	const char func[] = "LOGIO-IOCB";
 	const char *type;
@@ -2594,8 +2593,20 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
 
@@ -2615,7 +2626,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    logio->entry_status);
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x504d,
-		    logio, sizeof(*logio));
+		    pkt, qla_rsp_entry_size(ha));
 
 		goto logio_done;
 	}
@@ -2626,7 +2637,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    type, sp->handle, fcport->d_id.b24, fcport->port_name,
 		    le32_to_cpu(logio->io_parameter[0]));
 
-		vha->hw->exch_starvation = 0;
+		ha->exch_starvation = 0;
 		data[0] = MBS_COMMAND_COMPLETE;
 
 		if (sp->type == SRB_PRLI_CMD) {
@@ -2665,6 +2676,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	iop[0] = le32_to_cpu(logio->io_parameter[0]);
 	iop[1] = le32_to_cpu(logio->io_parameter[1]);
+
 	lio->u.logio.iop[0] = iop[0];
 	lio->u.logio.iop[1] = iop[1];
 	switch (iop[0]) {
@@ -2689,14 +2701,14 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
@@ -2712,16 +2724,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
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
@@ -4118,8 +4126,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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
index f9b326c02055..7dff227899a5 100644
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
@@ -2607,8 +2608,9 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = vha->vp_idx;
-	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	qla_logio_set_vp_index(ha, lg, vha->vp_idx);
+
+	rval = qla2x00_issue_iocb_timeout(vha, lg_buf, lg_dma, 0,
 	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1063,
@@ -2678,7 +2680,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 						 */
 	}
 
-	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);
 
 	return rval;
 }
@@ -2849,6 +2851,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int		rval;
+	void		*lg_buf;
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	struct qla_hw_data *ha = vha->hw;
@@ -2857,12 +2860,13 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
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
@@ -2875,8 +2879,9 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = vha->vp_idx;
-	rval = qla2x00_issue_iocb_timeout(vha, lg, lg_dma, 0,
+	qla_logio_set_vp_index(ha, lg, vha->vp_idx);
+
+	rval = qla2x00_issue_iocb_timeout(vha, lg_buf, lg_dma, 0,
 	    (ha->r_a_tov / 10 * 2) + 2);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x106f,
@@ -2898,7 +2903,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "Done %s.\n", __func__);
 	}
 
-	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+	dma_pool_free(ha->s_dma_pool, lg_buf, lg_dma);
 
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 81f3731ee384..b0e89dfff2e8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8392,6 +8392,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
 	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct logio_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
-- 
2.47.3

