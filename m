Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729D6385D8B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403950; cv=none; b=FcFT11SwjrklzkylRli1PzM9XBTCfdItwF3fhcwPd/dutUk1K2LS4McoxcmtiqcLZsoAihmV9ew7hfbpV+EQPW9uvKFpWgT1LfhCoWl+DMGZf7t0IkIhI9FwwTmpQ4dcg/WAJrdYQqFGqPliBaIofQ6qAF8ESNuOmRVA8MsjPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403950; c=relaxed/simple;
	bh=dB8LSVcd+9wmHUkNONNLQCQ8nxG9FrCNPuHjgrJfPSM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeRC9fLNN984ekgoa/KG2O9zbsS96XOGO4aKdNnsqztO08jD2a+aHlndp3PhuOIL0R1C+XQC1gaikPSyyz9Xx/CJe3P96eBSNn6kEx9RtGdaz1vqw5WUbVxoP2EqoyYf1lpKmbKwwQYEcw0AIJFS/d68ecmZciomTzuV5y/ymqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ebPH6nuZ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ebPH6nuZ"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cws1656123;
	Mon, 6 Jul 2026 22:59:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=M
	BOFbUKa79Q+WBxjd+sI4YIFkwZ6ddv2HlCq9gGnlmE=; b=ebPH6nuZ1yLvCKLCv
	rFEj/XoJH1S2OTvM09Vh0JcYaf/LVzOm5aF4sYS9V8rV3LdAT3KA94WrWCHfYsPX
	v/uguiOwU2a2Oi8l7XNA8oNGNiKU/TOKnx6yOFb4v+k+w+0dSqitTrQgvEcsMIgr
	+3xv8SOb48ln5cAfWitA9AB2UhphLVXniWtFoErruHCJ2gaq/RCS1buHHZ9FZhf6
	6+OiboufdtMBk+itfb9mlJBJDU48QmzzImBM4QHqVHv3jrQSgXEM4469mwPc+ei8
	YXNRnPUxfGuMTC6PnY/QbDbqhtJryo3Kh29+71et+jQxiMaJS6GCNCTiniD/54b+
	uBAZQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:04 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B89283F7067;
	Mon,  6 Jul 2026 22:59:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 84/88] scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
Date: Tue, 7 Jul 2026 11:24:31 +0530
Message-ID: <20260707055435.2680300-85-njavali@marvell.com>
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
X-Proofpoint-GUID: 3zKttneBEU8FjalFmnsTQX762FulWzit
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c95a9 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=1WpiJS57FI1c4jI2GfIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 3zKttneBEU8FjalFmnsTQX762FulWzit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXw1PR/LOYbwsK
 n3+KYQQ5A9xHmq+eRu36xUImQ/ARsgRHznui6h5fyAd3zFFKTiH4Dj0h+k5KqEnlWYh6VB8Ks2E
 2UwbtsoU/K9WNoViwidvTQRo+Sxw3v4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX/Q/+nPo2vgLA
 tx1U8yRrWeHuhWg2wQ4NYI0juNTq0ZzPtShbybEKPqj9roQP4kM72wAcK0Njh1Gmwcg634M3TVH
 QDB9N8mOMXH/JcukRLMRC9CCUjHyO7pDCi94y6OUIQiaILRil34EKNTyzeA38a5l2uuuf7L+cFT
 rP6WsVKCaxRrI/0dCkI0Tohq2rsdwKPqSoOFayEHfXOdBAlZiw2go7FhUgdNLF6A5XwdfJkS3LW
 L0FS0K/+fxhmu3GTsF/nKaxmeGh1bW/BN7tpE+tcDO22f9w1CZpY+jj4JnayeMj8dMGFisylZXG
 rMcmATfJT9xVxB6hOoKpTWL/1q1QYZ1KS51XcQtf1crfq2Gew7s1l1jolVOLC4N2f4njm0CBSAN
 Fji+9NhbyTHx22rcglysuD/YYTWP7VzoEDVVKqeL4hPDWJAB07XZcRRsyWxfAvkT5OIHsTAxTko
 pji3S/3R05khZJzV5Ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Several bsg handlers stage their request/reply in an uninitialized 256-byte
on-stack buffer (uint8_t bsg[DMA_POOL_SIZE]) and fill it via
sg_copy_to_buffer(), which only copies as many bytes as the user-supplied
request payload. When the request is shorter than the structure, the
remainder of the buffer is left holding stale stack data.

qla2x00_read_fru_status() and qla2x00_read_i2c() then copy the full
structure back to the reply payload with sg_copy_from_buffer(), leaking the
uninitialized stack bytes to user space. The write/update paths do not copy
the buffer back, but can feed uninitialized fields to the device.

Zero the stack buffer at declaration in all five handlers, mirroring the
heap kzalloc() approach, so short requests can no longer expose stale
memory.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 55142df30bda..cb7227298b24 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1959,7 +1959,7 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_image_version_list *list = (void *)bsg;
 	struct qla_image_version *image;
 	uint32_t count;
@@ -2019,7 +2019,7 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2070,7 +2070,7 @@ qla2x00_write_fru_status(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2117,7 +2117,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2163,7 +2163,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
-- 
2.47.3

