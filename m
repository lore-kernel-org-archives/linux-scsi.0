Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A437395AE2
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309802; cv=none; b=GriNerrKBrQ73ket+KrMvpBjuQyAdYzvr+MdqcWh60xgQZ3z3bjPj8Gbp4013cW1b0u3+A1KR7huoRFOkP9mzfU6v4lkrEuQj580VRnRmDjQvs+oRwYUq/r9k0b0AgxiKGioIOXktfEZJ4m4uj4djw2zTDBTAVkXYgbLL4y4prc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309802; c=relaxed/simple;
	bh=725YTlk7N8KKQDaeZEssnNpMia5nX1D+5PFparyE0fk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZLjUaxJS+fMt+2Hm1IQR2yXK4r0R8bkrrNtDJTfkL9sosxdByPoek9CQgwuxqzSwTHrljiDm14rit+eMZS2lHY5bVlN+rL35zkrhY/VCQuBR7yp9liBZLZ+tbOR8QM3w1SOdYLNCJ97LgiBisl3ZpNb8viD/uaQNISAg+Fvzig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GiLx1ki4; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GiLx1ki4"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLlUeW3316094;
	Mon, 1 Jun 2026 03:29:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	lUwDUveSsl5g/5GMyjUy44RPN67qQCBME7QC7oJWoA=; b=GiLx1ki4GbZPRWF8t
	FzFLS/kbrOBxmett9wA2bq8y3LAuYezAfXWdLGm6ZG8cNRrme2+3QBA3oj+zXVFZ
	OaJegb7kcK8INN/Cu9Rm4InONPjHH1NUwMRpJUeEaZhU9DaIMhF4BsZIaP8dmJfH
	yS+1RMuE+um6T+2Rh7aiyIjhzs9Xj1Ws+ruINwUZ1obACxZBKbXtwyOxUwj14E8o
	qX5DyN5SP7kVprlUU2V7M1GcS1kYp21wcuUE3IFZyA72aedzbrTFKx8ysz3XJ46Q
	/JUH7BXmnRt5ZtWSxZYsApx/oGQB8mHFILMpsPf6UKnQznbuXjLEZBdEUAg/5lZ4
	vSwqA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:57 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:56 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AB0A53F7053;
	Mon,  1 Jun 2026 03:29:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 13/44] scsi: qla2xxx: Replace IS_QLA29XX() size checks with entry-size helpers
Date: Mon, 1 Jun 2026 15:58:22 +0530
Message-ID: <20260601102853.328426-14-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: RtTwpyF7Eb2TMt3dGfIGTynVFIHTbYj5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX6cMs1SAFr9ts
 Btnj9o4zgjM1dOW3CHWBbPz8k7ZjXaViqtuo1kHBSFWBYA+FilgBhNey0aj1LuvP/yO89rD1+uf
 ANNShFW6LjUfrDEjFOyx3dpIdb5pQp86EWN8TCtnWRlKLj3UYLJzFfuM7lHCXz5zNHTQdv6bOdy
 g3cmRJX2ym9h9N5WnvJ98ubX30MmWhZ6pJ94WhlFveY4mY4I1zhzaFLKR5/hcxkFnNmQWjM3Mfe
 H55eODmwLb/TuSmswouHRMlFm/7Peq6s7/3hNbmEf39w50HiD5LYhLA4miW0RFyGVquL3wgpqxl
 l2hoMCykmSoMFLBhvLe2mZhnLNwcGf1/PfUUO+l4vUY2Xx+8eG+vcMoe0G2nyOq1m+20+nahlIM
 I6hJsbknhwKqWZIRehcJYy0HazbqADZ2phEI4l/t11HT7gKo0kpMrnfYtV7cB5NlFyb0W0/BpwE
 2d5EitQC/Uqr8KavtbA==
X-Proofpoint-GUID: RtTwpyF7Eb2TMt3dGfIGTynVFIHTbYj5
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f25 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=71FFhkzmMnv0j4WARqMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Replace scattered IS_QLA29XX() ternary expressions for request and
response ring IOCB sizes with calls to qla_req_entry_size() and
qla_rsp_entry_size() inline helpers and pre-computed local variables.

This consolidates the size selection in eight functions across
qla_init.c (qla2x00_alloc_fw_dump), qla_mid.c (qla25xx_free_req_que,
qla25xx_free_rsp_que, qla25xx_create_req_que, qla25xx_create_rsp_que),
and qla_os.c (qla2x00_free_req_que, qla2x00_free_rsp_que,
qla2x00_mem_alloc), improving readability and avoiding repeated
conditionals in every allocation, free, and dump-size calculation.

Also extend the IS_QLA29XX() guard to the ring-index write path in
qla2x00_start_iocbs() and the IOCB allocation read path in
__qla2x00_alloc_iocbs().

No functional change.

Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c |  5 +++--
 drivers/scsi/qla2xxx/qla_mid.c  | 34 ++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_os.c   | 32 +++++++++++++++----------------
 4 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4a825a18ce31..41c2fd128da4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3814,6 +3814,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (ha->fw_dump) {
 		ql_dbg(ql_dbg_init, vha, 0x00bd,
@@ -3852,13 +3854,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			 * Resizing must be done at end-of-dump processing.
 			 */
 			mq_size += (ha->max_req_queues - 1) *
-			    (req->length *
-			     (IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-					       sizeof(request_t)));
+			    (req->length * req_entry_size);
 			mq_size += (ha->max_rsp_queues - 1) *
-			    (rsp->length *
-			     (IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-					       sizeof(response_t)));
+			    (rsp->length * rsp_entry_size);
 		}
 		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
@@ -3894,12 +3892,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		/* Add space for spare MPI fw dump. */
 		dump_size += ha->fwdt[1].dump_size;
 	} else {
-		req_q_size = req->length *
-		    (IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-				      sizeof(request_t));
-		rsp_q_size = rsp->length *
-		    (IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-				      sizeof(response_t));
+		req_q_size = req->length * req_entry_size;
+		rsp_q_size = rsp->length * rsp_entry_size;
 		dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 		dump_size += fixed_size + mem_size + req_q_size + rsp_q_size
 			+ eft_size;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38127313fd79..1cafca1ea596 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -485,7 +485,8 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 		qla_req_ring_advance(ha, req);
 
 		/* Set chip new ring index. */
-		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
 		} else if (IS_QLA83XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
@@ -2434,7 +2435,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		if (qpair->use_shadow_reg)
 			cnt = *req->out_ptr;
 		else if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			cnt = rd_reg_dword(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
 			cnt = rd_reg_dword(reg->isp82.req_q_out);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 482275ca4f26..bb2521c052bf 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -574,13 +574,11 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = req->id;
-	uint16_t reqsz;
+	size_t req_entry_size = qla_req_entry_size(ha);
 
-	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-				 sizeof(request_t);
-
-	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
-			  reqsz, req->ring, req->dma);
+	dma_free_coherent(&ha->pdev->dev,
+			  (req->length + 1) * req_entry_size,
+			  req->ring, req->dma);
 	req->ring = NULL;
 	req->dma = 0;
 	if (que_id) {
@@ -598,10 +596,7 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
-	uint16_t rspsz;
-
-	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-				 sizeof(response_t);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -610,8 +605,9 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->handle = NULL;
 	}
 
-	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
-			  rspsz, rsp->ring, rsp->dma);
+	dma_free_coherent(&ha->pdev->dev,
+			  (rsp->length + 1) * rsp_entry_size,
+			  rsp->ring, rsp->dma);
 	rsp->ring = NULL;
 	rsp->dma = 0;
 	if (que_id) {
@@ -715,7 +711,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	uint16_t que_id = 0;
 	device_reg_t *reg;
 	uint32_t cnt;
-	uint16_t reqsz;
+	size_t req_entry_size = qla_req_entry_size(ha);
 
 	req = kzalloc_obj(struct req_que);
 	if (req == NULL) {
@@ -724,12 +720,9 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
-	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-				 sizeof(request_t);
-
 	req->length = REQUEST_ENTRY_CNT_24XX;
 	req->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(req->length + 1) * reqsz,
+			(req->length + 1) * req_entry_size,
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
 		ql_log(ql_log_fatal, base_vha, 0x00da,
@@ -866,7 +859,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	struct scsi_qla_host *vha = pci_get_drvdata(ha->pdev);
 	uint16_t que_id = 0;
 	device_reg_t *reg;
-	uint16_t rspsz;
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	rsp = kzalloc_obj(struct rsp_que);
 	if (rsp == NULL) {
@@ -875,12 +868,9 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
-	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-				 sizeof(response_t);
-
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
 	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(rsp->length + 1) * rspsz,
+			(rsp->length + 1) * rsp_entry_size,
 			&rsp->dma, GFP_KERNEL);
 	if (rsp->ring == NULL) {
 		ql_log(ql_log_warn, base_vha, 0x00e1,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a0f10f58421c..1e79708f5bd8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -502,6 +502,8 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 
 static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 {
+	size_t req_entry_size = qla_req_entry_size(ha);
+
 	if (IS_QLAFX00(ha)) {
 		if (req && req->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -509,10 +511,8 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 			    req->ring_fx00, req->dma_fx00);
 	} else if (req && req->ring)
 		dma_free_coherent(&ha->pdev->dev,
-		(req->length + 1) *
-			(IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-					  sizeof(request_t)),
-		req->ring, req->dma);
+		    (req->length + 1) * req_entry_size,
+		    req->ring, req->dma);
 
 	if (req)
 		kfree(req->outstanding_cmds);
@@ -522,6 +522,8 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 
 static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
+
 	if (IS_QLAFX00(ha)) {
 		if (rsp && rsp->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -529,9 +531,7 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 			    rsp->ring_fx00, rsp->dma_fx00);
 	} else if (rsp && rsp->ring) {
 		dma_free_coherent(&ha->pdev->dev,
-		    (rsp->length + 1) *
-			(IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-					  sizeof(response_t)),
+		    (rsp->length + 1) * rsp_entry_size,
 		    rsp->ring, rsp->dma);
 	}
 	kfree(rsp);
@@ -4244,6 +4244,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 {
 	char	name[16];
 	int rc;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (QLA_TGT_MODE_ENABLED() || EDIF_CAP(ha)) {
 		ha->vp_map = kzalloc_objs(struct qla_vp_map,
@@ -4439,9 +4441,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	}
 	(*req)->length = req_len;
 	(*req)->ring = dma_alloc_coherent(&ha->pdev->dev,
-		((*req)->length + 1) *
-			(IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-					  sizeof(request_t)),
+		((*req)->length + 1) * req_entry_size,
 		&(*req)->dma, GFP_KERNEL);
 	if (!(*req)->ring) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x0029,
@@ -4462,9 +4462,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	(*rsp)->hw = ha;
 	(*rsp)->length = rsp_len;
 	(*rsp)->ring = dma_alloc_coherent(&ha->pdev->dev,
-		((*rsp)->length + 1) *
-			(IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-					  sizeof(response_t)),
+		((*rsp)->length + 1) * rsp_entry_size,
 		&(*rsp)->dma, GFP_KERNEL);
 	if (!(*rsp)->ring) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x002b,
@@ -4624,8 +4622,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
 fail_npiv_info:
-	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
-		(IS_QLA29XX(ha) ? sizeof(struct response_ext) : sizeof(response_t)),
+	dma_free_coherent(&ha->pdev->dev,
+		((*rsp)->length + 1) * rsp_entry_size,
 		(*rsp)->ring, (*rsp)->dma);
 	(*rsp)->ring = NULL;
 	(*rsp)->dma = 0;
@@ -4633,8 +4631,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	kfree(*rsp);
 	*rsp = NULL;
 fail_rsp:
-	dma_free_coherent(&ha->pdev->dev, ((*req)->length + 1) *
-		(IS_QLA29XX(ha) ? sizeof(struct request_ext) : sizeof(request_t)),
+	dma_free_coherent(&ha->pdev->dev,
+		((*req)->length + 1) * req_entry_size,
 		(*req)->ring, (*req)->dma);
 	(*req)->ring = NULL;
 	(*req)->dma = 0;
-- 
2.47.3

