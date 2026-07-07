Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6491527466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403784; cv=none; b=pUiVhJmi3hJZs95eT/t1FM/lOkUtKNB5Zc+tmx0MinNkIpuPVAI6ybte4jhhq2imyZjCs45iy3QRjzJ4C7YS4IaJ+h9tWudO8a3NFOVtI1irHKVO1hzNykKsYFin4P6ZS0J8oqXC5Px5cl8oz4J529MDTdorG2JmxK33xAZOkSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403784; c=relaxed/simple;
	bh=aeoj+TKVG4K7zt2vZjjjWRUqpBhPcvXRT3obtH7kTRY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CorqMGIK8tpfTlf8OD7muUYuEVVmPliLzId3nCuvajKj6r18Sjqbu4kMnF3ayOLGGV9GlxnVubyE28t0IgZcOtuRMtUJyLGuBmvngmGaPVG6ax7Xk8aNRlF3qW6XWEMF304Dqwpx2RU/yFYQywhIrdKx+XtiC+VxY1FpSwpmBKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Qt6DyjIm; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Qt6DyjIm"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747glA854300;
	Mon, 6 Jul 2026 22:56:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=H
	TQcmojL9UK4MzQpaXDH3soApy6Q/ggSACzP1rlJ3fM=; b=Qt6DyjIm5IEie9HJo
	PKl2RpOqaV2wdv8fLuSVPCy2ljFPYYfcOV8y5nb1K1JJHbx2tL9zo/MXjOnch9Sn
	VMpjbbvsmzK1wKo/WFk7fodDtS8frx5PzcNymJHZAwOaO+hTfUlWIMzEv5FFMz7r
	X4wvNVUffegR6ZfCNwduJDJNQws/uRSluqJYjd7+aQDrxRg2a6MqeoenwCskHn5P
	8324FiVCTuPvDeNIIuI2J3ehxNhmyfy/yDBp5f3CRgpOMcDOFVkDjoy8mLK7oU5w
	CgbBHh5/mP7hjtNtxpEgQjE1/tIPegBhU+9lbHWYfpVQwhSIL4DzaHJ7+dXuEL8B
	3Mf3w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:19 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A31BA3F7067;
	Mon,  6 Jul 2026 22:56:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 27/88] scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series
Date: Tue, 7 Jul 2026 11:23:34 +0530
Message-ID: <20260707055435.2680300-28-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyahSwtN3AOa+
 AXVaKbIye47tenvJXgrGYle4yb7RSAS7MIFrSrPy1wkDyJ2z5S/d8Hsp2oGXQqYjRd1f/OX9lfC
 phnGaj1U8o758GkkjG2xoyxw6KwqcE+UwIIjcMWxGEvh6hq+H4bBa0vwrWmx3AIDpsqOqO+fk6k
 mINs/cp+zetQujhC3MGwH/A3BuNKv7LTns8pwB9mI+8BvuLcYTuRXJEwXbSVwl+js6jHMKgL/xb
 RFe6aYwxL/ABIrk0aVe3Ff334fYHtCtcHIu/vUQxggz1D/jQTAMavz0gS2lOOKBEt/l+JAOejlB
 sOHSq2ft8uTXaTQ7WQY0rMlLtTcfd6n5ebZH9LUHG877v5kjvi0Ru9pUEZD7/zoLc6OoR1ef00s
 Jp8EwneS0CYwO1CFzHIPkZD14KFLG0IAMhLG09S7o4cYFWuwIWwKFBdCVP6W2jElfjYsqmKAZJB
 SbGEHVR1GKkX++0ULNA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9503 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=-cAsXcPlQew20VEo0WgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5MgtoshXo/Um
 GW8npZ2G0kDhfRKdZoWAZoFjavW2pYlneDzjGziGW6fmO/9bmYxXO1HsT12hp5EALif8XcxL8q/
 cDUV26+qkqZLf+wF8JDX26zscm/VqHU=
X-Proofpoint-ORIG-GUID: e_bgAFxqPYU09OcVphT1Lkhstal0ba_f
X-Proofpoint-GUID: e_bgAFxqPYU09OcVphT1Lkhstal0ba_f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Refine the handling of I/O control blocks (IOCBs) for the 29xx series
by introducing support for the extended structure ct_entry_24xx_ext.
Update function signatures to accept a generic pointer for IOCB packets,
differentiating between standard and extended structures, and ensuring
proper initialization and processing of command and response data.
Additionally, the size check for the extended structure is added to
maintain integrity.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 156 ++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_iocb.c |  78 ++++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   1 +
 3 files changed, 168 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 514f04aa1423..7a4d2fdc095f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -68,30 +68,62 @@ void *
 qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, struct ct_arg *arg)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct ct_entry_24xx *ct_pkt;
 
-	ct_pkt = (struct ct_entry_24xx *)arg->iocb;
-	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+	if (IS_QLA29XX(ha)) {
+		struct ct_entry_24xx_ext *ct_pkt;
 
-	ct_pkt->entry_type = CT_IOCB_TYPE;
-	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(arg->nport_handle);
-	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_byte_count = cpu_to_le32(arg->rsp_size);
-	ct_pkt->cmd_byte_count = cpu_to_le32(arg->req_size);
+		ct_pkt = (struct ct_entry_24xx_ext *)arg->iocb;
+		memset(ct_pkt, 0, sizeof(struct ct_entry_24xx_ext));
 
-	put_unaligned_le64(arg->req_dma, &ct_pkt->dsd[0].address);
-	ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
+		ct_pkt->entry_type = CT_IOCB_TYPE;
+		ct_pkt->entry_count = 1;
+		ct_pkt->nport_handle = cpu_to_le16(arg->nport_handle);
+		ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
+		ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_byte_count = cpu_to_le32(arg->rsp_size);
+		ct_pkt->cmd_byte_count = cpu_to_le32(arg->req_size);
 
-	put_unaligned_le64(arg->rsp_dma, &ct_pkt->dsd[1].address);
-	ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = vha->vp_idx;
+		put_unaligned_le64(arg->req_dma,
+				   &ct_pkt->dsd[0].address);
+		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
 
-	vha->qla_stats.control_requests++;
+		put_unaligned_le64(arg->rsp_dma,
+				   &ct_pkt->dsd[1].address);
+		ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
+		ct_pkt->vp_index = cpu_to_le16(vha->vp_idx);
+
+		vha->qla_stats.control_requests++;
+
+		return ct_pkt;
+	} else {
+		struct ct_entry_24xx *ct_pkt;
+
+		ct_pkt = (struct ct_entry_24xx *)arg->iocb;
+		memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+
+		ct_pkt->entry_type = CT_IOCB_TYPE;
+		ct_pkt->entry_count = 1;
+		ct_pkt->nport_handle = cpu_to_le16(arg->nport_handle);
+		ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
+		ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_byte_count = cpu_to_le32(arg->rsp_size);
+		ct_pkt->cmd_byte_count = cpu_to_le32(arg->req_size);
+
+		put_unaligned_le64(arg->req_dma,
+				   &ct_pkt->dsd[0].address);
+		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
 
-	return (ct_pkt);
+		put_unaligned_le64(arg->rsp_dma,
+				   &ct_pkt->dsd[1].address);
+		ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
+		ct_pkt->vp_index = vha->vp_idx;
+
+		vha->qla_stats.control_requests++;
+
+		return ct_pkt;
+	}
 }
 
 /**
@@ -132,7 +164,10 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 		    routine, ms_pkt->entry_status, vha->d_id.b.domain,
 		    vha->d_id.b.area, vha->d_id.b.al_pa);
 	} else {
-		if (IS_FWI2_CAPABLE(ha))
+		if (IS_QLA29XX(ha))
+			comp_status = le16_to_cpu(
+			    ((struct ct_entry_24xx_ext *)ms_pkt)->comp_status);
+		else if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
 			    ((struct ct_entry_24xx *)ms_pkt)->comp_status);
 		else
@@ -1437,42 +1472,85 @@ void *
 qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
     uint32_t rsp_size)
 {
-	struct ct_entry_24xx *ct_pkt;
 	struct qla_hw_data *ha = vha->hw;
 
-	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
-	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+	if (IS_QLA29XX(ha)) {
+		struct ct_entry_24xx_ext *ct_pkt;
+
+		ct_pkt = (struct ct_entry_24xx_ext *)ha->ms_iocb;
+		memset(ct_pkt, 0, sizeof(struct ct_entry_24xx_ext));
+
+		ct_pkt->entry_type = CT_IOCB_TYPE;
+		ct_pkt->entry_count = 1;
+		ct_pkt->nport_handle =
+		    cpu_to_le16(vha->mgmt_svr_loop_id);
+		ct_pkt->timeout =
+		    cpu_to_le16(ha->r_a_tov / 10 * 2);
+		ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
+		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+
+		put_unaligned_le64(ha->ct_sns_dma,
+				   &ct_pkt->dsd[0].address);
+		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
+
+		put_unaligned_le64(ha->ct_sns_dma,
+				   &ct_pkt->dsd[1].address);
+		ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
+		ct_pkt->vp_index = cpu_to_le16(vha->vp_idx);
 
-	ct_pkt->entry_type = CT_IOCB_TYPE;
-	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
-	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
-	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
-	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+		return ct_pkt;
+	} else {
+		struct ct_entry_24xx *ct_pkt;
+
+		ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
+		memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+
+		ct_pkt->entry_type = CT_IOCB_TYPE;
+		ct_pkt->entry_count = 1;
+		ct_pkt->nport_handle =
+		    cpu_to_le16(vha->mgmt_svr_loop_id);
+		ct_pkt->timeout =
+		    cpu_to_le16(ha->r_a_tov / 10 * 2);
+		ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_dsd_count = cpu_to_le16(1);
+		ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
+		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 
-	put_unaligned_le64(ha->ct_sns_dma, &ct_pkt->dsd[0].address);
-	ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
+		put_unaligned_le64(ha->ct_sns_dma,
+				   &ct_pkt->dsd[0].address);
+		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
 
-	put_unaligned_le64(ha->ct_sns_dma, &ct_pkt->dsd[1].address);
-	ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = vha->vp_idx;
+		put_unaligned_le64(ha->ct_sns_dma,
+				   &ct_pkt->dsd[1].address);
+		ct_pkt->dsd[1].length = ct_pkt->rsp_byte_count;
+		ct_pkt->vp_index = vha->vp_idx;
 
-	return ct_pkt;
+		return ct_pkt;
+	}
 }
 
 static void
 qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
 {
 	struct qla_hw_data *ha = vha->hw;
-	ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
-	struct ct_entry_24xx *ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_QLA29XX(ha)) {
+		struct ct_entry_24xx_ext *ct_pkt =
+		    (struct ct_entry_24xx_ext *)ha->ms_iocb;
+
+		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
+	} else if (IS_FWI2_CAPABLE(ha)) {
+		struct ct_entry_24xx *ct_pkt =
+		    (struct ct_entry_24xx *)ha->ms_iocb;
+
 		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 		ct_pkt->dsd[0].length = ct_pkt->cmd_byte_count;
 	} else {
+		ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
+
 		ms_pkt->req_bytecount = cpu_to_le32(req_size);
 		ms_pkt->req_dsd.length = ms_pkt->req_bytecount;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c0cec1f74dfc..79403d460977 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3394,7 +3394,7 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 }
 
 static void
-qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
+qla24xx_ct_iocb(srb_t *sp, void *pkt)
 {
 	uint16_t        avail_dsds;
 	struct dsd64	*cur_dsd;
@@ -3406,36 +3406,50 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int entry_count = 1;
 
-	ct_iocb->entry_type = CT_IOCB_TYPE;
-        ct_iocb->entry_status = 0;
-        ct_iocb->sys_define = 0;
-        ct_iocb->handle = sp->handle;
-
-	ct_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	ct_iocb->vp_index = sp->vha->vp_idx;
-	ct_iocb->comp_status = cpu_to_le16(0);
-
 	cmd_dsds = bsg_job->request_payload.sg_cnt;
 	rsp_dsds = bsg_job->reply_payload.sg_cnt;
 
-	ct_iocb->cmd_dsd_count = cpu_to_le16(cmd_dsds);
-        ct_iocb->timeout = 0;
-	ct_iocb->rsp_dsd_count = cpu_to_le16(rsp_dsds);
-        ct_iocb->cmd_byte_count =
-            cpu_to_le32(bsg_job->request_payload.payload_len);
+	if (IS_QLA29XX(ha)) {
+		struct ct_entry_24xx_ext *ct_iocb = pkt;
+
+		ct_iocb->entry_type = CT_IOCB_TYPE;
+		ct_iocb->entry_status = 0;
+		ct_iocb->sys_define = 0;
+		ct_iocb->handle = sp->handle;
+		ct_iocb->nport_handle =
+		    cpu_to_le16(sp->fcport->loop_id);
+		ct_iocb->vp_index = cpu_to_le16(sp->vha->vp_idx);
+		ct_iocb->comp_status = cpu_to_le16(0);
+		ct_iocb->cmd_dsd_count = cpu_to_le16(cmd_dsds);
+		ct_iocb->timeout = 0;
+		ct_iocb->rsp_dsd_count = cpu_to_le16(rsp_dsds);
+		ct_iocb->cmd_byte_count =
+		    cpu_to_le32(bsg_job->request_payload.payload_len);
+		avail_dsds = NUM_CT_DSDS;
+		cur_dsd = ct_iocb->dsd;
+	} else {
+		struct ct_entry_24xx *ct_iocb = pkt;
+
+		ct_iocb->entry_type = CT_IOCB_TYPE;
+		ct_iocb->entry_status = 0;
+		ct_iocb->sys_define = 0;
+		ct_iocb->handle = sp->handle;
+		ct_iocb->nport_handle =
+		    cpu_to_le16(sp->fcport->loop_id);
+		ct_iocb->vp_index = sp->vha->vp_idx;
+		ct_iocb->comp_status = cpu_to_le16(0);
+		ct_iocb->cmd_dsd_count = cpu_to_le16(cmd_dsds);
+		ct_iocb->timeout = 0;
+		ct_iocb->rsp_dsd_count = cpu_to_le16(rsp_dsds);
+		ct_iocb->cmd_byte_count =
+		    cpu_to_le32(bsg_job->request_payload.payload_len);
+		avail_dsds = 2;
+		cur_dsd = ct_iocb->dsd;
+	}
 
-	avail_dsds = 2;
-	cur_dsd = ct_iocb->dsd;
 	index = 0;
 
 	for_each_sg(bsg_job->request_payload.sg_list, sg, cmd_dsds, index) {
-		/*
-		 * Allocate additional continuation packets.  24xx uses the
-		 * 64-byte cont_a64_entry_t (5 DSDs); 29xx uses the 128-byte
-		 * cont_a64_entry_ext_t (NUM_CONT1_DSDS) and advances through
-		 * the ring_ext_ptr stride so the CT head IOCB isn't
-		 * overlapped.
-		 */
 		if (avail_dsds == 0) {
 			if (IS_QLA29XX(ha)) {
 				struct cont_a64_entry_ext *cont_pkt;
@@ -3484,7 +3498,11 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 		append_dsd64(&cur_dsd, sg);
 		avail_dsds--;
 	}
-        ct_iocb->entry_count = entry_count;
+
+	if (IS_QLA29XX(ha))
+		((struct ct_entry_24xx_ext *)pkt)->entry_count = entry_count;
+	else
+		((struct ct_entry_24xx *)pkt)->entry_count = entry_count;
 }
 
 /*
@@ -3857,11 +3875,15 @@ qla2x00_mb_iocb(srb_t *sp, struct mbx_24xx_entry *mbx)
 }
 
 static void
-qla2x00_ctpthru_cmd_iocb(srb_t *sp, struct ct_entry_24xx *ct_pkt)
+qla2x00_ctpthru_cmd_iocb(srb_t *sp, void *pkt)
 {
-	sp->u.iocb_cmd.u.ctarg.iocb = ct_pkt;
+	sp->u.iocb_cmd.u.ctarg.iocb = pkt;
 	qla24xx_prep_ms_iocb(sp->vha, &sp->u.iocb_cmd.u.ctarg);
-	ct_pkt->handle = sp->handle;
+
+	if (IS_QLA29XX(sp->vha->hw))
+		((struct ct_entry_24xx_ext *)pkt)->handle = sp->handle;
+	else
+		((struct ct_entry_24xx *)pkt)->handle = sp->handle;
 }
 
 static void qla2x00_send_notify_ack_iocb(srb_t *sp,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4f7e5f9372ef..0b7c4ee73ebf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8349,6 +8349,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
 	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct ct_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2604);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
-- 
2.47.3

