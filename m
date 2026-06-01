Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4975A342509
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309841; cv=none; b=cwLmqnFe9r52wLPEkqwCLOZIyNVOM5VYixXUhIScvMRxi7W4z0t2cRHBU0iqfh+KHsd0DTsWKcI0tjx/UztPO7G9ow2fDEFXacxgev/EdiqtuOLegVdTNtVJY3rCyUzNFTAlNhrk2UtUpcQWmP3S7b/g06ZvOeO+WY81gvVirBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309841; c=relaxed/simple;
	bh=gS2jTyM2SpXoFhojMhCdsHdRmt+5hydhlIg5q0fDMq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5KHQ/zL4mUGTgb+2jLcbO/A6wo178rzejwAAeODyy8RxttwLTUBWTQsXxJVAj1FGIypSCgFvTm9NvqrxppPZEzrCzSR/BL/vr+0SoFh3jLca3fpwjOwp6yGqvxu6TeCIpNw8dt47QVmfAGbHXnKkf+B+g/TeB0drmo7iDthQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SMJCWld+; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SMJCWld+"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLxm6P1231410;
	Mon, 1 Jun 2026 03:30:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	8weeSQuTbHZt+vCUznSQPKKex4FvpmC9FvP2aatA/Q=; b=SMJCWld+raNxoUENO
	z/rwoVJN6UE50aPEwXjo+MTfroFvCri0OtYh8ZBqXeyFRp23v74orW2EmZwdtD7p
	TMgikY4bOzSY2J3apcZbPlCnw68f7bh+ojAnBELV2IRVBy60cDzGu/joUKRt1KO+
	nz2T1MiBuNEg67tyJSeDY4LYAxbOIEijzXxgJQPedxY51F0e27IrDuirkkrALjNS
	pudQ11P5nuCEzBR820W5t3UbIpqr7cEYoiPqVTDgl73igt1iOu+kaEQZFqhkYD+L
	r70falyFnP7QUiNYzWgeYYaQ64FBC9N9hAnpSHdPRJfoifpy4+azVHqY00f97i+X
	05MUg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:36 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:35 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3AFCF3F7053;
	Mon,  1 Jun 2026 03:30:32 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 26/44] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Mon, 1 Jun 2026 15:58:35 +0530
Message-ID: <20260601102853.328426-27-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX2tT4+ADQfqxJ
 ELkvx5bfpsM0YAnBn0WNNv6yLNcPDz4WgbwHm5O9K0TFa+6fT74YUsmoXJQy6BfmxKxDs15IguK
 HploUMlDDougfNX+UWHBHiwscM5pdV8kZq6Vz4tY9deguQmwDlvUZGOR0oOZoq14VWBN1yEMlin
 gGpRoYHXg856rs1mHNbsv8j45HBa64T0+QGyPIJEOPzD1+E9Y7BueKSSITsV50Mg+i5de/bAqDI
 hf5IpDALJOJpuw9tmIdXECkF5tqeLkyYhi2B/UuXRL7UhgqxFSUBVyn7Nqwg4ALVaNm4zoMgb1G
 gQn2yBPGrlVsekNdoBhsnNVY1cFCwCaQzew9m8ZWXNAeaj0Mmiyd8o0EgBX/Wr6atm211ac6xh5
 Nc8Z/W6jNIQQZkQtZTvurbuHTA+u6nJRS0Za5cy/mLDvkct3XnxHBo6Iq2fxsO5D4npvAPSzhrU
 1G2tlBsbHBGMPtrwwMQ==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f4c cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=TERegcne-j9u77qtkYEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: rM9d3pDdWgnD8glmj_9PVHOYffO2km2-
X-Proofpoint-GUID: rM9d3pDdWgnD8glmj_9PVHOYffO2km2-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Enhance the qla2x00_mem_alloc function to include checks for
QLA29XX adapters.  This modification updates the conditions for
memory allocation and cleanup, ensuring proper handling of the
new adapter series alongside existing QLA27XX and QLA28XX checks.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2f713974c5b8..bbbddb55eabd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4275,7 +4275,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->srb_mempool)
 		goto fail_free_gid_list;
 
-	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) || (ql2xsecenable && IS_QLA28XX(ha))) {
+	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) ||
+	    (ql2xsecenable && (IS_QLA28XX(ha) || IS_QLA29XX(ha)))) {
 		/* Allocate cache for CT6 Ctx. */
 		if (!ctx_cachep) {
 			ctx_cachep = kmem_cache_create("qla2xxx_ctx",
@@ -4309,7 +4310,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
 	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
 
-	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenable)) {
+	if (IS_P3P_TYPE(ha) || ql2xenabledif ||
+	    ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ql2xsecenable)) {
 		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			DSD_LIST_DMA_POOL_SIZE, 8, 0);
 		if (!ha->dl_dma_pool) {
@@ -4671,12 +4673,12 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	}
 
 fail_dif_bundl_dma_pool:
-	if (IS_QLA82XX(ha) || ql2xenabledif) {
+	if (IS_QLA82XX(ha) || IS_QLA29XX(ha) || ql2xenabledif) {
 		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
 		ha->fcp_cmnd_dma_pool = NULL;
 	}
 fail_dl_dma_pool:
-	if (IS_QLA82XX(ha) || ql2xenabledif) {
+	if (IS_QLA82XX(ha) || IS_QLA29XX(ha) || ql2xenabledif) {
 		dma_pool_destroy(ha->dl_dma_pool);
 		ha->dl_dma_pool = NULL;
 	}
-- 
2.47.3

