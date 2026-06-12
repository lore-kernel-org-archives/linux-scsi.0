Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F17339844
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258081; cv=none; b=KrVxO++J5nj/nBuT6XoI58rC61ydx4Uljfv2u4tRyA1C+FDzzc70NuGBSU3/udjcR8ZrPQKEMFgUhZb8dxJcAdIJfvfx/xqsHZXI3bQDlgM2qRrar6mVTYVlli3w9FF5VJNID8/u6bW1xi+4Y2GRll9YC6FUMQ6TcDLOc/7G0Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258081; c=relaxed/simple;
	bh=JPFP0SzjJ9RYxNI4fUqROJqriYA/0kNff+z8G2e83M8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5Vh3gcOvyoyiDe3fHmp7fxHK2wqB2ko2RjQy20PKlShlmHlh1Rrp/2RvUrWLHrGotpksP3jUY1R7jkpBmgF7S+tiHEgH6o0fqPXqryINZiPID5G7ov4ZECrJJJwKHHWvuMJMZf7x3FLrveXqNhADvp/64e4/bbFdSDK4E3tqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=E4dz/u0a; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="E4dz/u0a"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qTf038053;
	Fri, 12 Jun 2026 02:54:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	1Vc1xvzmlXoSgWpGQdfrv/W2HPoSUr6jojblRpBwok=; b=E4dz/u0a4ouBQ4v2+
	l0V6Cus06L3OLbwE8vm1YQkSqu4EkBmLniUw7ox92r+pWg+rr4+89YQaqn3Gta6v
	DNeefCcfVeOucgUfryoTzHVIyQWJcmm7h1j2yEwA3ZASurmD7yeM/SzJBM1Uyvsr
	B9y9drQIU48lHWzGo0r+frUaN8TgjRxEsk7D9NH7t3vVp/Ic9is8+y2oFqRr2Zr4
	eqGD5UEZw1gk/ZsYUBeXm0CzZm0RVV3z0gd8xsd+Sk+pTfHDpOUFxdjX1RabWa/H
	W09NVKFH4na8KAMie1OBGdfcYgxWX3hFAC4VP99u1I7sCeeTXpzILqVGSVoudkfF
	AlXaQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9F92F5B6921;
	Fri, 12 Jun 2026 02:54:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 13/60] scsi: qla2xxx: Replace IS_QLA29XX() size checks with entry-size helpers
Date: Fri, 12 Jun 2026 15:22:46 +0530
Message-ID: <20260612095333.1666592-14-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXxK6jqWtgH/P8
 dlUfQq7cyYU9rKOWkidZd/TV1lHQrS9WsF+g+I05UnGlt/2iMhui5XtR0kcELJkvZHfE/Ijbdgy
 oDXLBS3eCdlsorQHbey49PbMd4bx5kk=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd75d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=71FFhkzmMnv0j4WARqMA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: _vIpKtAvfati8YM0Q8cLQHPN2LJ1dTUC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX/r5JHXzfinUU
 KbetMo8lAoYJmiG+PLWexu5IwgqBWGv60HmTZbtyBoMG4J9dq0FHekdzx/vfroLQHdl9chA+F3B
 1GPL5at2KXBchgn2smP3Km+Yq0EkpRhCXINV4fWD5IaVRZA6pCxDpjrVM1A5g7J39LFjBZgvaKr
 d4W40ANyCOiZMjd8GYPPsohKFFQB3inql5DNutf6T/0/M2GnPCloUSoYumwUo5U2j1dKjRDTHbH
 e0aoEc0pWdEBL/OeDfGqvdnbP1V3Ptp7TYXd9Qrd9l/fEiDvGalPicabxMuQ69cenFy2unaiAjN
 Tq+x2pTqxQWENIwi+VfJEQdLHaRD2Q6zNDRP6Iea4dGb35x32mrXKbm+dJ19oYP+vDvDXnaQPM8
 maBwL5UQkNfb4m4Eai+eAyg2B8fTMXfdzcS4CxNIfQ+1lAnVFzlCGGYtMJLXRPbPR5DR7AirPi+
 5RtEUL1rqYi5NVYktBw==
X-Proofpoint-ORIG-GUID: _vIpKtAvfati8YM0Q8cLQHPN2LJ1dTUC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c |  5 +++--
 drivers/scsi/qla2xxx/qla_mid.c  | 34 ++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_os.c   | 32 +++++++++++++++----------------
 4 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 292ffabcba99..20eb67096b0b 100644
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
index 6b8be182cdb8..4d22e059015f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -481,7 +481,8 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 		qla_req_ring_advance(ha, req);
 
 		/* Set chip new ring index. */
-		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
 		} else if (IS_QLA83XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
@@ -2421,7 +2422,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
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
index c79c1cca0b7d..ef105ae6af41 100644
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
@@ -4254,6 +4254,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 {
 	char	name[16];
 	int rc;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (QLA_TGT_MODE_ENABLED() || EDIF_CAP(ha)) {
 		ha->vp_map = kzalloc_objs(struct qla_vp_map,
@@ -4449,9 +4451,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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
@@ -4472,9 +4472,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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
@@ -4634,8 +4632,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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
@@ -4643,8 +4641,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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

