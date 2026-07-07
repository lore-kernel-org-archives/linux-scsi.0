Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E4386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403816; cv=none; b=m+24gG+r8nAtXAK1zLIg2UMFAPh5ygHgeoczEa4NjPGJ/hPHeKTS8hxTXzC+MlK0mEjU5UOcgi0IKcvXfHY7tgKD9MkskU/VD+6BGZjI09Pbf4vB0LjkQOLPQOwI/vNpo5PBon8QXrz4IxerwRUe2lbVpvWo6zmcL90HypsOi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403816; c=relaxed/simple;
	bh=Tkdb+5ti1Q3EStLGOLM861cTzw58isZdvyTsdXAG7mI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYGKRrc/h/r+xdezBVmATl3Wt3jPoVvA171/BPoysrUrMR20NvUL90hL6L3WN4CMA3bGmnbPTHtPA9hi4TVLI/CsKdEukWouOxoB86PISYWJuI5Zrj69+0JyoTDJMtgHoLEt8qsmY8oT7HxhQpXVYbBRXVg0VAbc/2FiSfIUd8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cZYL//5L; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cZYL//5L"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481Pv872631;
	Mon, 6 Jul 2026 22:56:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=2
	dGu8dJbza9pxX/ZWHhp2fBNcQ2MkU18pMktqzmOSS8=; b=cZYL//5LPrffqDHjW
	VvV7iGmtpKLvATHtPA8MLn4DiaZXgadvPzw7AOrG3L7KWQ3+2i0Yy6wzkLlWdekA
	ZNrojlUhtUxAp+6hfvfmu6M8I+m3TlZcc3Z7MSOlSyZjoiMFlxNEaysXOIFD7IWE
	jNdA0+aIU1i5nv7xR4LDAyV0W1JeCEoVTfPC9iBoMtCWXEa1jht7O3e91EyO9IjV
	23IaXdNA4OCro7i4YbbzJ5Ydy0l/94pyZRtwbR+6nxs8/u7O3nOy63DJDVQce4Ra
	EDt94Z/nect3nQdPCIGqHFrzfasBAv1jUefzAZbMwox7WXnhF85LOuKumizBc2q0
	XByew==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:51 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:50 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 12BE83F7066;
	Mon,  6 Jul 2026 22:56:47 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 38/88] scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
Date: Tue, 7 Jul 2026 11:23:45 +0530
Message-ID: <20260707055435.2680300-39-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: ZeJBDr1yUDuK79n4MxU9rvVl4a5QE7QG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzbJHzZugJ0wA
 wfJYkmt7XJkZyHQ42NcwxvVhuTs8P/TFS4EGUY1tjcA2DKBjwJBv0pxrmXg8jl749rPT1x4k6sZ
 Vcyo0w0HW2WJDIP9nbo6FUNxNm30ir8wlh2SB2PpqKqhAvISInD7+btukvb+X45ulWmpIsz8XvW
 hcQI9oxooIgAExzn7BeI6x5tFVsQYSdugN4UaotUVII7ODJr1WWDH2GxwmpCUqu+G5sVpbtbpgH
 VISiLdLQxr5SggksVN7sreSefHkIrYFoRvpOr2AB2hi7H/ClSqsAqMrjJ2vuFLtmYMiDXoPO4Dv
 /MpT/TMvi0EBAgVJXVLMozHOmgW8B0ncDQX55XtaoEM8XoFoj+N4a6bqkw6B9oyXwZTFNHEU/Jy
 XhMNbNERQb5gx5h+tdYazyi+4njugx5AIpPxdlmPrbn73CuP+ZR1FVFkJc9vqewtgxXPcM+Tv59
 I3J4GCzzfMqtwqKheZQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0U3l3iogoJjJ
 Et7HTUudHi8GwseLCTWlPfp1DkKTxQCvIJUKjkGXq8Egb5DATSz0ZwNg8lGVnvKnuJ18jqRXZ1I
 TF658+kd98TYJs3aH5DINJubAXHqCKw=
X-Proofpoint-GUID: ZeJBDr1yUDuK79n4MxU9rvVl4a5QE7QG
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9524 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=N8dHboFCl7IniiCa_5wA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Extend the LS4 pass-through IOCB handling to support the 128-byte
pt_ls4_request_ext layout used by 29xx series adapters.  The extension
grows inline DSD capacity from 2 to 5 entries.  Function signatures are
widened to void * so both layouts can be passed without casts.

pt_ls4_request_ext overlays pt_ls4_request through exchange_address
(offsets 0-27 are byte-identical), so common-header writes go through a
single struct pt_ls4_request * view; only the divergent fields
(vp_index width, tx_/rx_byte_count offset, dsd[] base) are branched.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw29.h | 37 +++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 73 ++++++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_isr.c  |  9 ++--
 drivers/scsi/qla2xxx/qla_nvme.c | 64 +++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_nvme.h |  4 +-
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 6 files changed, 137 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index a4aa5bacb171..600a40d8bd5f 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -295,6 +295,43 @@ struct ct_entry_24xx_ext {
 	struct dsd64 dsd[NUM_CT_DSDS];	/* Data Segment Descriptors */
 };
 
+/*
+ * 29xx extended Link Service pass-through request IOCB (128 bytes).
+ *
+ * Same wire purpose as the 64-byte struct pt_ls4_request used on 24xx-class
+ * adapters, but laid out for the 128-byte 29xx request ring:
+ *   - vp_index widened to __le16 (bits [8:0] meaningful, see
+ *     CMD_EXT_VP_INDEX_MASK).
+ *   - reserved area expanded to 32 bytes between exchange_address and
+ *     rx_byte_count.
+ *   - inline DSD capacity grown from 2 to 5.
+ * Header through 'tx_dseg_count' (offset 14) and the control_flags /
+ * exchange_address fields keep the same offsets as struct pt_ls4_request,
+ * so common code can populate them via either type once IS_QLA29XX(ha) is
+ * branched for the layout-divergent fields.
+ */
+#define NUM_PT_LS4_EXT_DSDS	5
+struct pt_ls4_request_ext {
+	uint8_t entry_type;
+	uint8_t entry_count;
+	uint8_t sys_define;
+	uint8_t entry_status;
+	uint32_t handle;
+	__le16	status;
+	__le16	nport_handle;
+	__le16	tx_dseg_count;
+	__le16	vp_index;	/* VP Index 9 bits; see CMD_EXT_VP_INDEX_MASK */
+	__le16	timeout;
+	__le16	control_flags;	/* CF_LS4_* (see struct pt_ls4_request) */
+	__le16	rx_dseg_count;
+	__le16	rsvd2;
+	__le32	exchange_address;
+	uint8_t rsvd3[32];
+	__le32	rx_byte_count;
+	__le32	tx_byte_count;
+	struct dsd64 dsd[NUM_PT_LS4_EXT_DSDS];
+};
+
 /*
  * ISP queue - PUREX IOCB entry structure definition
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 05d480622db5..59648a9229ac 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3965,38 +3965,65 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
 }
 
 /*
- * Build NVME LS request
+ * Build NVME LS request.
+ *
+ * pt_ls4_request_ext overlays pt_ls4_request through exchange_address
+ * (offsets 0-27 are byte-identical), so the common-header writes go
+ * through one struct pt_ls4_request * view.  The ext layout has a wider
+ * __le16 vp_index and places rx_/tx_byte_count and dsd[] at different
+ * offsets, so those assignments diverge per stride.
  */
 static void
-qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
+qla_nvme_ls(srb_t *sp, void *cmd_pkt)
 {
-	struct srb_iocb *nvme;
+	struct srb_iocb *nvme = &sp->u.iocb_cmd;
+	struct qla_hw_data *ha = sp->vha->hw;
+	struct pt_ls4_request *pkt = cmd_pkt;
 
-	nvme = &sp->u.iocb_cmd;
-	cmd_pkt->entry_type = PT_LS4_REQUEST;
-	cmd_pkt->entry_count = 1;
-	cmd_pkt->timeout = cpu_to_le16(nvme->u.nvme.timeout_sec);
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	pkt->entry_type = PT_LS4_REQUEST;
+	pkt->entry_count = 1;
+	pkt->timeout = cpu_to_le16(nvme->u.nvme.timeout_sec);
+	pkt->tx_dseg_count = cpu_to_le16(1);
 
 	if (sp->unsol_rsp) {
-		cmd_pkt->control_flags =
-				cpu_to_le16(CF_LS4_RESPONDER << CF_LS4_SHIFT);
-		cmd_pkt->nport_handle = nvme->u.nvme.nport_handle;
-		cmd_pkt->exchange_address = nvme->u.nvme.exchange_address;
+		pkt->control_flags =
+			cpu_to_le16(CF_LS4_RESPONDER << CF_LS4_SHIFT);
+		pkt->nport_handle = nvme->u.nvme.nport_handle;
+		pkt->exchange_address = nvme->u.nvme.exchange_address;
 	} else {
-		cmd_pkt->control_flags =
-				cpu_to_le16(CF_LS4_ORIGINATOR << CF_LS4_SHIFT);
-		cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-		cmd_pkt->rx_dseg_count = cpu_to_le16(1);
-		cmd_pkt->rx_byte_count = nvme->u.nvme.rsp_len;
-		cmd_pkt->dsd[1].length  = nvme->u.nvme.rsp_len;
-		put_unaligned_le64(nvme->u.nvme.rsp_dma, &cmd_pkt->dsd[1].address);
+		pkt->control_flags =
+			cpu_to_le16(CF_LS4_ORIGINATOR << CF_LS4_SHIFT);
+		pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		pkt->rx_dseg_count = cpu_to_le16(1);
 	}
 
-	cmd_pkt->tx_dseg_count = cpu_to_le16(1);
-	cmd_pkt->tx_byte_count = nvme->u.nvme.cmd_len;
-	cmd_pkt->dsd[0].length = nvme->u.nvme.cmd_len;
-	put_unaligned_le64(nvme->u.nvme.cmd_dma, &cmd_pkt->dsd[0].address);
+	if (IS_QLA29XX(ha)) {
+		struct pt_ls4_request_ext *ext = cmd_pkt;
+
+		ext->vp_index = cpu_to_le16(sp->fcport->vha->vp_idx);
+		ext->tx_byte_count = nvme->u.nvme.cmd_len;
+		ext->dsd[0].length = nvme->u.nvme.cmd_len;
+		put_unaligned_le64(nvme->u.nvme.cmd_dma,
+				   &ext->dsd[0].address);
+		if (!sp->unsol_rsp) {
+			ext->rx_byte_count = nvme->u.nvme.rsp_len;
+			ext->dsd[1].length = nvme->u.nvme.rsp_len;
+			put_unaligned_le64(nvme->u.nvme.rsp_dma,
+					   &ext->dsd[1].address);
+		}
+	} else {
+		pkt->vp_index = sp->fcport->vha->vp_idx;
+		pkt->tx_byte_count = nvme->u.nvme.cmd_len;
+		pkt->dsd[0].length = nvme->u.nvme.cmd_len;
+		put_unaligned_le64(nvme->u.nvme.cmd_dma,
+				   &pkt->dsd[0].address);
+		if (!sp->unsol_rsp) {
+			pkt->rx_byte_count = nvme->u.nvme.rsp_len;
+			pkt->dsd[1].length = nvme->u.nvme.rsp_len;
+			put_unaligned_le64(nvme->u.nvme.rsp_dma,
+					   &pkt->dsd[1].address);
+		}
+	}
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c6e2323518f7..3a9237376050 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4034,7 +4034,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 }
 
 void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
-    struct pt_ls4_request *pkt, struct req_que *req)
+			   void *pkt, struct req_que *req)
 {
 	srb_t *sp;
 	const char func[] = "LS4_IOCB";
@@ -4044,7 +4044,9 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
 	if (!sp)
 		return;
 
-	comp_status = le16_to_cpu(pkt->status);
+	/* status lives at the same offset (8) in both IOCB strides */
+	comp_status = le16_to_cpu(((struct pt_ls4_request *)pkt)->status);
+
 	sp->done(sp, comp_status);
 }
 
@@ -4210,8 +4212,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qlt_response_pkt_all_vps(vha, rsp, (response_t *)pkt);
 			break;
 		case PT_LS4_REQUEST:
-			qla24xx_nvme_ls4_iocb(vha, (struct pt_ls4_request *)pkt,
-			    rsp->req);
+			qla24xx_nvme_ls4_iocb(vha, pkt, rsp->req);
 			break;
 		case NOTIFY_ACK_TYPE:
 			if (((response_t *)pkt)->handle == QLA_TGT_SKIP_HANDLE)
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8fa980db6ce4..0038b6274d44 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1197,37 +1197,57 @@ static void qla_nvme_fc_format_rjt(void *buf, u8 ls_cmd, u8 reason,
 	rjt->rjt.vendor = vendor;
 }
 
+/*
+ * pt_ls4_request_ext overlays pt_ls4_request through exchange_address
+ * (offsets 0-27 are byte-identical), so the common-header writes go
+ * through one struct pt_ls4_request * view.  The ext layout has a wider
+ * __le16 vp_index and places tx_/rx_byte_count and dsd[] at different
+ * offsets, so those assignments diverge per stride.
+ */
 static void qla_nvme_lsrjt_pt_iocb(struct scsi_qla_host *vha,
-				   struct pt_ls4_request *lsrjt_iocb,
+				   void *lsrjt_iocb,
 				   struct qla_nvme_lsrjt_pt_arg *a)
 {
-	lsrjt_iocb->entry_type = PT_LS4_REQUEST;
-	lsrjt_iocb->entry_count = 1;
-	lsrjt_iocb->sys_define = 0;
-	lsrjt_iocb->entry_status = 0;
-	lsrjt_iocb->handle = QLA_SKIP_HANDLE;
-	lsrjt_iocb->nport_handle = a->nport_handle;
-	lsrjt_iocb->exchange_address = a->xchg_address;
-	lsrjt_iocb->vp_index = a->vp_idx;
-
-	lsrjt_iocb->control_flags = cpu_to_le16(a->control_flags);
-
-	put_unaligned_le64(a->tx_addr, &lsrjt_iocb->dsd[0].address);
-	lsrjt_iocb->dsd[0].length = cpu_to_le32(a->tx_byte_count);
-	lsrjt_iocb->tx_dseg_count = cpu_to_le16(1);
-	lsrjt_iocb->tx_byte_count = cpu_to_le32(a->tx_byte_count);
-
-	put_unaligned_le64(a->rx_addr, &lsrjt_iocb->dsd[1].address);
-	lsrjt_iocb->dsd[1].length = 0;
-	lsrjt_iocb->rx_dseg_count = 0;
-	lsrjt_iocb->rx_byte_count = 0;
+	struct qla_hw_data *ha = vha->hw;
+	struct pt_ls4_request *pkt = lsrjt_iocb;
+
+	pkt->entry_type = PT_LS4_REQUEST;
+	pkt->entry_count = 1;
+	pkt->sys_define = 0;
+	pkt->entry_status = 0;
+	pkt->handle = QLA_SKIP_HANDLE;
+	pkt->nport_handle = a->nport_handle;
+	pkt->exchange_address = a->xchg_address;
+	pkt->control_flags = cpu_to_le16(a->control_flags);
+	pkt->tx_dseg_count = cpu_to_le16(1);
+	pkt->rx_dseg_count = 0;
+
+	if (IS_QLA29XX(ha)) {
+		struct pt_ls4_request_ext *ext = lsrjt_iocb;
+
+		ext->vp_index = cpu_to_le16(a->vp_idx);
+		ext->tx_byte_count = cpu_to_le32(a->tx_byte_count);
+		ext->rx_byte_count = 0;
+		put_unaligned_le64(a->tx_addr, &ext->dsd[0].address);
+		ext->dsd[0].length = cpu_to_le32(a->tx_byte_count);
+		put_unaligned_le64(a->rx_addr, &ext->dsd[1].address);
+		ext->dsd[1].length = 0;
+	} else {
+		pkt->vp_index = a->vp_idx;
+		pkt->tx_byte_count = cpu_to_le32(a->tx_byte_count);
+		pkt->rx_byte_count = 0;
+		put_unaligned_le64(a->tx_addr, &pkt->dsd[0].address);
+		pkt->dsd[0].length = cpu_to_le32(a->tx_byte_count);
+		put_unaligned_le64(a->rx_addr, &pkt->dsd[1].address);
+		pkt->dsd[1].length = 0;
+	}
 }
 
 static int
 qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
 			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
 {
-	struct pt_ls4_request *lsrjt_iocb;
+	void *lsrjt_iocb;
 
 	lsrjt_iocb = __qla2x00_alloc_iocbs(qp, NULL);
 	if (!lsrjt_iocb) {
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index a253ac55171b..e6a41d53cbe1 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -144,7 +144,7 @@ struct pt_ls4_rx_unsol {
 int qla_nvme_register_hba(struct scsi_qla_host *);
 int  qla_nvme_register_remote(struct scsi_qla_host *, struct fc_port *);
 void qla_nvme_delete(struct scsi_qla_host *);
-void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *, struct pt_ls4_request *,
-    struct req_que *);
+void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha, void *pkt,
+			   struct req_que *req);
 void qla24xx_async_gffid_sp_done(struct srb *sp, int);
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f539190dd504..186c6c7a3944 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8402,6 +8402,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
 	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
+	BUILD_BUG_ON(sizeof(struct pt_ls4_request_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_rx_unsol) != 64);
 	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct purex_entry_24xx_ext) != 128);
-- 
2.47.3

