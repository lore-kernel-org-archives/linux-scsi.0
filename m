Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4665C4418F2
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022867; cv=none; b=QlO4L2ccNchjaGweZM79kMINFwDgk0OzZilPnNMRxzN/BE2ByriNZ++oroUhBbmS52aQ2FBQlHmD2/k579NMh71fAGaGHYo/sMCz4A4w+kxP3MwA4EVLHBCAPuDsyYCyFFv4AKuw2rkXLw1NuosD/BiwEYvDJmGxFgRaHJfCVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022867; c=relaxed/simple;
	bh=o9b5d1qkIzFKZnRXVjj0cCWV6EQplZAX7+bBQaCuqAQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2K4yA3FJ2HY7mzHrWkpdaLE9FO7fRNgMMMW1Qq2ar9Z26TZ6LhUQcXjoP55HEqGNprx6rK2BBEWY08An3YY3IcpUF5cE9N8L8urrZObC6REecSm4rpqzDO4Ln25E9t0ngjYXHQmN1s4fkTWDVgzsT6B3nyzkZhz1v5n1d+jFKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hJ6ZXBT+; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hJ6ZXBT+"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UiHx3693335;
	Tue, 14 Jul 2026 02:54:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	YwJ0pUxWrkA2ck1aSbpBOuVPvyRi6R0/R+nksrkPtM=; b=hJ6ZXBT+qOD7RQH48
	CJBFl3f9Zog3qq0GWmX+fASJNzouwimXGZDofg4xB8lA3vTXh6G0/QpWLjtgWXJ1
	mS3R4Z2LMa1e9D2AUtuAq4Q4zyw8HVCMDu0Yz6Io4fMc27i8VY84kR3y7ryoj/fL
	o2+sutw4YPMGK2MOuvlarQa8NTOGFE+Iav3iqWAibH05b0ciEDZCdLHdhEU3SHOE
	sxdD53bt1tnu1pRsGa8Db6TRDOIfP7gzPv9qvzNA5AGAb9KOeyoPipgB+FHLrEgz
	Sq5nebZ4lQrA3Nh3L3SADeiTwTT+ou6ix6FRr2FIhBBJ5r2OiRBemNNSoeHk63ri
	BMwwg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:18 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F2F275E6868;
	Tue, 14 Jul 2026 02:54:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 04/56] scsi: qla2xxx: Add 29xx support in queue initialisation path
Date: Tue, 14 Jul 2026 15:23:01 +0530
Message-ID: <20260714095353.289460-5-njavali@marvell.com>
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
X-Proofpoint-GUID: DfpL3aA1mFsIXUGn1kqY0uPlip2aK_Eu
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a56074a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=37MPRnnHHgc3qPsYtIsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: DfpL3aA1mFsIXUGn1kqY0uPlip2aK_Eu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9C02jX/GthMO
 XIQjhrSSMoMxjyK2tKHG74/gWWqIR8lOCvmIw4jHIOHLW5N8CeMhtIQnWFCkxM5EdA8Doj3g+/a
 axxsuA/40dRncgZMpQwHmw2TX7MHd9g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX84vwClfF29Ob
 TFk7sKZzqWJuKnYtL+wmknj+vLVwXJFoHxWKKyEA4JjZcYJ1VmFVHpVwHArbZvOTJU2D3qDHkQb
 j3n6AGlDzJ0vKzYde4SuKYKCHZse3KEjYblyld3iP4xPWICTl4c+579sajlTTOLkr+b29HVOAjl
 9zUq41NEK1AXGj0FgYVesJEuYwhLpxbc99W8S4cPDjHzszmRtgXEaR6XJoHCkdUBSI7rlkmTEUX
 UCSB1lnWMspPES7VJvKNk6SlM7FgXkL7IUnzdZLEOaxB1SGoMUvzVrlI2SHgiDWgWffxd5gwQaS
 5ODpBcYqlPB8XhnBt36TMaHpYTnRxSFXSRerZYAj7bp8uiZ2IR9OCsTai6XV2fUvb1k1MqCwspa
 CTb/OYg13J3fFRymmexQsOQY6/PbrEHdylBrQWam7HYxPmkkQmhEfs/O9TqLp2Jtnnk0MKNbsOk
 3xnXaZz47P7KfD035og==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Extend the queue initialisation and multi-queue management mailbox
commands to include IS_QLA29XX() checks, following the same mailbox
interface as 27xx/28xx.

Unlike earlier adapters that use 64-byte request/response ring entries
(request_t / response_t), 29xx uses 128-byte entries.  Add struct
request_ext and struct response_ext, which extend the legacy 64-byte
layout with a 64-byte reserved area.  The first 64 bytes are
layout-compatible with the legacy structures, so common header
accesses remain valid.

The enlarged entry stride doubles the DMA ring memory allocated for
both request and response queues on 29xx, and all ring pointer
arithmetic must account for the wider entries (handled by later
patches in this series).

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 30 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c | 20 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_mid.c | 25 +++++++++++++++++++++----
 3 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 89ddf332cdbd..1ec7ee578e0c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1989,6 +1989,18 @@ typedef struct {
 #define RESPONSE_PROCESSED	0xDEADDEAD	/* Signature */
 } response_t;
 
+struct response_ext {
+	uint8_t		entry_type;		/* Entry type. */
+	uint8_t		entry_count;		/* Entry count. */
+	uint8_t		sys_define;		/* System defined. */
+	uint8_t		entry_status;		/* Entry Status. */
+	uint32_t	handle;			/* System defined handle */
+	uint8_t		data[52];
+	uint32_t	signature;
+	uint8_t		reserved[64];
+#define RESPONSE_PROCESSED	0xDEADDEAD	/* Signature */
+};
+
 /*
  * ISP queue - ATIO queue entry definition.
  */
@@ -2067,6 +2079,24 @@ typedef struct {
 	struct dsd64 dsd[2];
 } cmd_a64_entry_t, request_t;
 
+struct request_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+	uint32_t handle;		/* System handle. */
+	target_id_t target;		/* SCSI ID */
+	__le16  lun;			/* SCSI LUN */
+	__le16  control_flags;		/* Control flags. */
+	uint16_t reserved_1;
+	__le16  timeout;		/* Command timeout. */
+	__le16  dseg_count;		/* Data segment count. */
+	uint8_t scsi_cdb[MAX_CMDSZ];	/* SCSI command words. */
+	uint32_t byte_count;		/* Total byte count. */
+	struct dsd64 dsd[2];
+	uint8_t reserved[64];
+};
+
 /*
  * ISP queue - continuation entry structure definition.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2d052f870b2b..2b232b225c90 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4584,7 +4584,8 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	mcp->mb[12] = req->qos;
 	mcp->mb[11] = req->vp_idx;
 	mcp->mb[13] = req->rid;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		mcp->mb[15] = 0;
 
 	mcp->mb[4] = req->id;
@@ -4599,9 +4600,10 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	mcp->tov = MBX_TOV_SECONDS * 2;
 
 	if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha))
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_1;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha)) {
 		mcp->out_mb |= MBX_15;
 		/* debug q create issue in SR-IOV */
 		mcp->in_mb |= MBX_9 | MBX_8 | MBX_7;
@@ -4610,7 +4612,8 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(req->options & BIT_0)) {
 		wrt_reg_dword(req->req_q_in, 0);
-		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+		    !IS_QLA29XX(ha))
 			wrt_reg_dword(req->req_q_out, 0);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4654,7 +4657,8 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	mcp->mb[5] = rsp->length;
 	mcp->mb[14] = rsp->msix->entry;
 	mcp->mb[13] = rsp->rid;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	    IS_QLA29XX(ha))
 		mcp->mb[15] = 0;
 
 	mcp->mb[4] = rsp->id;
@@ -4671,7 +4675,8 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	if (IS_QLA81XX(ha)) {
 		mcp->out_mb |= MBX_12|MBX_11|MBX_10;
 		mcp->in_mb |= MBX_1;
-	} else if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	} else if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		   IS_QLA29XX(ha)) {
 		mcp->out_mb |= MBX_15|MBX_12|MBX_11|MBX_10;
 		mcp->in_mb |= MBX_1;
 		/* debug q create issue in SR-IOV */
@@ -4681,7 +4686,8 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(rsp->options & BIT_0)) {
 		wrt_reg_dword(rsp->rsp_q_out, 0);
-		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+		    !IS_QLA29XX(ha))
 			wrt_reg_dword(rsp->rsp_q_in, 0);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c563133f751e..e75b7ae22bc5 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -574,9 +574,13 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = req->id;
+	uint16_t reqsz;
+
+	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
+				 sizeof(request_t);
 
 	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
-		sizeof(request_t), req->ring, req->dma);
+			  reqsz, req->ring, req->dma);
 	req->ring = NULL;
 	req->dma = 0;
 	if (que_id) {
@@ -594,6 +598,10 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
+	uint16_t rspsz;
+
+	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
+				 sizeof(response_t);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -601,8 +609,9 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->in_use = 0;
 		rsp->msix->handle = NULL;
 	}
+
 	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
-		sizeof(response_t), rsp->ring, rsp->dma);
+			  rspsz, rsp->ring, rsp->dma);
 	rsp->ring = NULL;
 	rsp->dma = 0;
 	if (que_id) {
@@ -706,6 +715,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	uint16_t que_id = 0;
 	device_reg_t *reg;
 	uint32_t cnt;
+	uint16_t reqsz;
 
 	req = kzalloc_obj(struct req_que);
 	if (req == NULL) {
@@ -714,9 +724,12 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
+	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
+				 sizeof(request_t);
+
 	req->length = REQUEST_ENTRY_CNT_24XX;
 	req->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(req->length + 1) * sizeof(request_t),
+			(req->length + 1) * reqsz,
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
 		ql_log(ql_log_fatal, base_vha, 0x00da,
@@ -833,6 +846,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	struct scsi_qla_host *vha = pci_get_drvdata(ha->pdev);
 	uint16_t que_id = 0;
 	device_reg_t *reg;
+	uint16_t rspsz;
 
 	rsp = kzalloc_obj(struct rsp_que);
 	if (rsp == NULL) {
@@ -841,9 +855,12 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
+	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
+				 sizeof(response_t);
+
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
 	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(rsp->length + 1) * sizeof(response_t),
+			(rsp->length + 1) * rspsz,
 			&rsp->dma, GFP_KERNEL);
 	if (rsp->ring == NULL) {
 		ql_log(ql_log_warn, base_vha, 0x00e1,
-- 
2.47.3

