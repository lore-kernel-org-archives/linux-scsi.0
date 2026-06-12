Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32782371D0A
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258057; cv=none; b=Z5CsWKj2eU8sa6O6m8yvbLCWf6uUcb4UuMgIIsjQON/mm61kv8SOd6wgB7dMASoHDP9Tq62SzORA5W9LA2C+4Q8UKtAsJJZNa6nacwgYa9h4b/bB1zdNcUZ9zWRKaaOADbelkZz5SqpXrZdiZ1+ZMPH41k6+ByGgs9aUZ9UsJF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258057; c=relaxed/simple;
	bh=Y2tBVjpVYgYuz0XybuXU/BR14gsBopzttJ71NDwM+vs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1/jcLXmE17HLQXVNXjE0A0ilxsHfyDORHJimRBPH33Wr9tTLAhIPMaGNluKbIzDHDuJV2HMt/Wctln+CrQQrl3FOvAjieCn14gkNbStXxsPb/8hXofQ2s/rPf+H4EnmkgbKqyhp/gCTzQdirpaD1zgVyqZYzanPmIv3015Zsfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZCO2wMA7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZCO2wMA7"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AaKW071283;
	Fri, 12 Jun 2026 02:54:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	M4rYMzL6TKgUTF75yDoF79Et+V66bC9H/FngfuUivI=; b=ZCO2wMA7doe4i9Cop
	0XLlM603UhOduY7EVqrfvyiXgF7/2iaC1e+qyP2jZneNDdrAGnoHvPImFsAXRNp/
	8LNZU1734/EpMIMcucJTIb0JNJ0TrzBfvZV7M4NBU3Jm4at8Y0iW1CMon0968Yu2
	Lq2LE0lhROVdviQaBCAcgN+AtJ/uE/Ds2EkFwX/tThfiD/RQ2ocBpoG0XdSboRmS
	LbDwzKbibBXRSv8ZuRM3PMu8K9L5TqO3j1zuNCWhLf7eJXo0UAtXzvh8hUAJSNbY
	+0X5sJCzd+c3X6bEEnvqjhrtUCPbS6jNqUchrt/PCVTm50d981mdzw9wbh0vjCtX
	Thtrw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:11 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2D1EB3F7040;
	Fri, 12 Jun 2026 02:54:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 05/60] scsi: qla2xxx: Add 29xx support in queue initialisation path
Date: Fri, 12 Jun 2026 15:22:38 +0530
Message-ID: <20260612095333.1666592-6-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX8cYc4jmXPUD1
 6/zN7Z246ebZgABPMxyL9xbpn+HvXrkDHyzTfu2KS/VFbaAN5ysjNBFqqUaadaEZrIk31wgchNj
 ikwjR37In03CVmbgDvQQfVVkZtVA7QQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXyzzVe1iYsafb
 69ogek31DM9QBYb5ybwq3dpXOze1nwjssWkMAwaazAfwAFnPzYXEGuWMnIlhrOW3u8i++UKFSnj
 RlXFzYn8w6JmTKthJAjGsUVMTx0QsO5rTkWLbRQmIPFrLHwDO3eRjvoGiJyIT/0m88BW7yolHqk
 gZ0oPPCKGeN82U8AiVVwFqiDt3VKf8x/20JdfAhG6wMBGCzkT1NJD38yUIoSYEpKoOubZOxvcwd
 TOS53NEEJoPkSJlJszg9Kol88mmswzk5x7HJx+yX4l8H533f7Olw9n18a+z70I9iCTzWlbywTcE
 u4bxLBHRbxTKNGXjhBns3/SHghGDW4pcRTOko/hJps4PjS9BwTFqKjP+c9hZX0X8EQeipHSntmA
 LtcVrRJD2lAjMc5KNPgvJM3yHDgkxZAnjSR9wCIsSb2h5DzEV+ZpbFrsq/cC2lF9RCS/k7Di2FN
 wziPEYpuALP2uyPhI1g==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd743 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=37MPRnnHHgc3qPsYtIsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: jNP5JUZgJvs8UviS3gQX7Sj9Ht8rMZhR
X-Proofpoint-GUID: jNP5JUZgJvs8UviS3gQX7Sj9Ht8rMZhR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

