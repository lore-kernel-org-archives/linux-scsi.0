Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2810312831
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309855; cv=none; b=RhXa5+1wEFnNvvVmV6k933yXpAHWZWqiaj313EvLi1lLlXqFmqw/m/Ot2gWbBgwQQrzVfMZ9+GraDxwCdOFPVOC1ZGUpX89prQ2zTI91ViP7b3lC/6N6Fpk04YFMezyNLbgNl5z8Zfs0c1ZDGQyxt79VJebA02qUmlMTFyaGmm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309855; c=relaxed/simple;
	bh=c6tgiRwqhRwmVJ0L6mLXTv6sn0gwQj4rzJbhAejm7NA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tt0Qm9ON7hyLBN4eMsc1oo21528Kk+ZhWNMCaVQYRqTOh7ABKDulbOC1pKMqDXX+UZiWfbUmfAzDS7DygD6JhaE+v+2n1F3FsWBJx8tmNpSVryJUCy5RKCTW3XRk+6rDvYYpZf9eMUvNI5gM9nFqpAWxD8n2xKpAf2/UpMeknbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KRUHl5BF; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KRUHl5BF"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLsWtR3327791;
	Mon, 1 Jun 2026 03:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	8ER90vk4vxH/sgFh40Y6hXd55lIIwQhw9hCVTOcfjo=; b=KRUHl5BFk1YeiwExt
	yS2ZCPhVNpNx8y5dy3N6E9wqFJ/WNv+GBeaJFji48GJk/YCnMdyyw+F78tbSCEXk
	90w2qifiVes1m87cFPhzX0wkGKZ76PywHBPQEWnJ9wYOvTpOFWWYVlKWDzQArFae
	cdyfmUhoTl9FGFEHWAwyths+PSZVxjVPnsxHbWQk81tAgMG6rewFECCHggFfvca+
	v9c3qpynKDH5ZoxkbgTuehQIx+1f4mTxqGZPvEu05eA2lbY6hVGYYPoEtRHD8XLy
	scTs14/S7cD+hkjJ5Q8C4UnQLzi0Fp2YbOnIWcY/U6DQTHqe8xX2xRfeVvS4h0r1
	dH8+g==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:49 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:48 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D0C573F7053;
	Mon,  1 Jun 2026 03:30:45 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 30/44] scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series
Date: Mon, 1 Jun 2026 15:58:39 +0530
Message-ID: <20260601102853.328426-31-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: qQbj109hTUxZ7MfnzERglD-uwOj2giMO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXyeX8aZHSSgbN
 x2aObNIoH7Sf0O3oiFeoBBlNWjFgXdqzY1TWTmvRn8mB44ZCyLliKnVF6an8THCVf+BKWfbKgQA
 wGfvbJE+HJxIMMdk2kwFKDM5j4DOGcM+XS3cYn1C6M2phoVek8u5RSCWmwFb3hqE1QPzjZgTbyF
 DROutdYZce0JlYFZGXOWKTZxq3QAWKyQhF27qWx9QgMpIIDvW6VdyOvS+tpOs2iDm/IVa60QIj6
 +yVFv0aWH4mANLDHPICD5BQpTeE392ne5MEuB25QtxtKyPEaYbp3IaqbgOandFaJWNUdSXUjYjQ
 7EsZFJ51yVfOr0hj3eAwsXxoBhN4tMRF0VoOA07CsfPdYUI/bGruqebI/Qncr5wfjC16WueKIaV
 1MatyTfMLwtL6asvsg/rnnvUdLob4PRRZy5x9MXw2GdOOrfxzz8Oukz2cBsF8HqnGka4B5qOauI
 jyJct6DMO7j7T060YjA==
X-Proofpoint-GUID: qQbj109hTUxZ7MfnzERglD-uwOj2giMO
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f59 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=-cAsXcPlQew20VEo0WgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Refine the handling of I/O control blocks (IOCBs) for the 29xx series
by introducing support for the extended structure ct_entry_24xx_ext.
Update function signatures to accept a generic pointer for IOCB packets,
differentiating between standard and extended structures, and ensuring
proper initialization and processing of command and response data.
Additionally, the size check for the extended structure is added to
maintain integrity.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 156 ++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_iocb.c |  78 ++++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   1 +
 3 files changed, 168 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 880cd73feaca..053dab545b5b 100644
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
index 6bff1b464660..782ba94a0293 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3397,7 +3397,7 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 }
 
 static void
-qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
+qla24xx_ct_iocb(srb_t *sp, void *pkt)
 {
 	uint16_t        avail_dsds;
 	struct dsd64	*cur_dsd;
@@ -3409,36 +3409,50 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
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
@@ -3487,7 +3501,11 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
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
@@ -3860,11 +3878,15 @@ qla2x00_mb_iocb(srb_t *sp, struct mbx_24xx_entry *mbx)
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
index 26e2cfd38361..2905ad249f12 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8339,6 +8339,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
 	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct ct_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2604);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
-- 
2.47.3

