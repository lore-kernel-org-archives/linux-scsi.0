Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AFC339844
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258134; cv=none; b=QMjjacmMstgsqmDczhiBxpkeMq7T6qZabyydOe9kAP2y6YyA84rn/cwKUKNhU1PJG9y6HXRVZ23sZ/DFmsDTBwH5sS9nVGSjaJGajdsA+Ix5adB2uZpTGy4IhOd4++gqO2H5tG44fVBOnZkFMbI8WepuhfgSYfxrpUm3Jey0Y+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258134; c=relaxed/simple;
	bh=Ukzgh7Ob0328gC66AKZd6hq90Ai2huArpS4eeF87Xao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OguZjYgSA8ojqBgeVDmRA96jJHmJTwv6optpLKjJJXaJoQQikiWx4npk7a+wE6aZ5eH7ixfkb6GlZe4v/DyGI1NRBA0lM0FNU5AxCRK+ZZT4NoTgt9zUpEMQGsUdCATj7ROWhdie3C/zAC9Ub+fv2nnors85knEMNDK22p+y91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kXdIeavZ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kXdIeavZ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39Kpf3782362;
	Fri, 12 Jun 2026 02:55:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	w4kxy4oiGS20Zx8enaM81w62EaYXPUrMjKLdMCmWPU=; b=kXdIeavZWnegDWxc+
	wT4aH4iwMSoswlyFYkfeX9d14GoYCe2NDftaj9gcD7Fyz796EhQI3pqSxGSdWT8J
	vE5iW6WCT+I4niITcxgX51RCH44DpTRY14j569eHQz7zKyW8YwHBvI6Y2wVdXja+
	999HEpCw4Kh1ay8vz7zesR+0BAi1WsjmqJVOFsF4Sbb3W9zWoTSn/S1fwLuyjBnn
	0ATJcUTcZAA0sTGkqp65zzb5RC9WHbOnz61E1LztSvNySTXjfZvaIKEv/kZC0T0F
	khcq3NrDcSK81Ipv1AcdcO737623gHXunf9mcwdUASgT7TxMpCzbntTv92IrxApw
	VSx1Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:30 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 07A893F7040;
	Fri, 12 Jun 2026 02:55:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 30/60] scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series
Date: Fri, 12 Jun 2026 15:23:03 +0530
Message-ID: <20260612095333.1666592-31-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+0yWaGkBBjTw
 ruxrDV9UvFIgY86wTBFtbqgOI3yNE+AZFLpHd0jwDtyx1LhhqbE7eh/oh2K+vrL0nnq9EFAdxyQ
 ZGSoI43KAgIixhwwn7hrSw+eaOy+JZUJ4ryxB1t1zeIdYAspOhaYF3ZWKxlqjdMFbsxQf5krEAR
 r8s35aUZUwSpmgbN1YBKJ/RIbp8Tv3TrRoLP0HQ+ROgba8uQrOTMRfFL8d5arvd5knEiJo/YnO+
 u8Ku1FNbG4QIKqDN+FdozAQsRahijbx2GPzBIg6GDTzrI/DRg7G4braieR9aaNXMdlphg9sbvuT
 9BTWZHZJSbwxkDR2dT6ETndkNA8qrHzuz4Qyzx0ViQSJgXYjvLQQti6pR1MyZ1GvusaHDraR6pe
 iuCjeXpG0afGbaFWHMFYKFNSla1u+XdsJPKwfPF/5hEKkDosIXOSApLqIOWrzdyJCvHYyZJJNjR
 hjZU22GB29d4568vQAA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd792 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=-cAsXcPlQew20VEo0WgA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX5i/90+KiRFeF
 D+Q/S8m84aLRU38rb1D411MLNXiobXeH4gxMmUEx7rY1fS4lMRZwfoan9171oroTQQN7SipNVVI
 O72HtmJAK1P0OCFtfCIsZ3ZGI73aaKI=
X-Proofpoint-GUID: vOiFZgqHFZb0VMlMoKbzn6w7DI0juF4X
X-Proofpoint-ORIG-GUID: vOiFZgqHFZb0VMlMoKbzn6w7DI0juF4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Refine the handling of I/O control blocks (IOCBs) for the 29xx series
by introducing support for the extended structure ct_entry_24xx_ext.
Update function signatures to accept a generic pointer for IOCB packets,
differentiating between standard and extended structures, and ensuring
proper initialization and processing of command and response data.
Additionally, the size check for the extended structure is added to
maintain integrity.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 156 ++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_iocb.c |  78 ++++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   1 +
 3 files changed, 168 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b69a001fd4da..eefd1440d197 100644
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
index 595fe78920ae..c7814c51b324 100644
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
index ab9d2ccd41d6..ea4363800e60 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8348,6 +8348,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
 	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct ct_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2604);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
-- 
2.47.3

