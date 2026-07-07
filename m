Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D860386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403954; cv=none; b=qMGq2O9UtgjJHm5HpSnvEXax/IKMN0+W8BA7hTqabIwx9ajCaZhX5YseKrSVd+cvQF6YLT+F/ldqYxdLb3PoIxXu8Sie6PXQwu+IeefCCVaIY3sHhZ+r4VY+wz/liu+lvRSg4oRkg2+d4bY7w155wZZkI/Ha46VlXi3M8p+XV7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403954; c=relaxed/simple;
	bh=jBHNGq5dYlGNCnnx4bTWz9jchTuA/rpbhAQUAjJD1zY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avChXosx+AnPvnXcx9TBe0YsJufyWUNVvhajU3G6iRTzp/fUSQochR6JVnpSKX6KsERlwLtO/bv/i0zEVhRostTV/B1authuWajtHX8j90Nye91AO2ITfJF9zibHkyZgc3S71nhocumqoz07TGak809JxXK+BAghpNpRa7gkK+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jX/X3ZEK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jX/X3ZEK"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748but1656070;
	Mon, 6 Jul 2026 22:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	cH9+3WtF1leArLdij0AFv8XeiuCHpPA7TfZfgTVqaQ=; b=jX/X3ZEKMQmBpEPTt
	hArHw7AubjvKVp+4hh731FRQxWNDDeRW1VVaxl13bDqwwXYA0PsmL1LTuV9Njj39
	dMlBi+k/xbeBnVywIKVseH4Vs73tfU+iSWjL5Gn3YiJ3QschtT359wKmQdTeObDk
	Yog2iD1DfoTONhTYQXasvcKJxSO4+5TbLYhuVSkocBbnkxDVW+Q3MSUVsvbZpoqt
	t1ymysG5w9W5UyUNNQT6l+ScKEs9Krk6AWFjqNacWrtWwRT+bR15VAPV030J863c
	s/d2OQpay7hjbfF2dJGk0X+hFxWXdJu/qoi1L21CDIWWpiRiv1bDJkW68YtnzRT3
	30Opw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:10 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 76BB33F7066;
	Mon,  6 Jul 2026 22:59:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 86/88] scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
Date: Tue, 7 Jul 2026 11:24:33 +0530
Message-ID: <20260707055435.2680300-87-njavali@marvell.com>
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
X-Proofpoint-GUID: 0TLauIyvrmMOG3pcGE0DcEQpRlD0mzOd
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c95ae cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=Xx_P917AdCZa4SjJxbsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 0TLauIyvrmMOG3pcGE0DcEQpRlD0mzOd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX4szoq3qKNKpH
 emwNP7D6xzEPGKmYhMUtlNgNqdTG8m2zzhJ8c9of2U5NbyvXDF9jaxmTlF800v8/WXpCg/Ejnp2
 JD6daTH2O9eWj6nQyk0HoZHOjqD9gUQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX12YHXvYG8yRP
 /mjKwT4TDqb2zH7dltV32JpDgQv0qhaEjqUrHYXxiVdCDL+cFsMUzIrHaoSvl5474gzWVU/UC/f
 HtlwfbPKYkTZHlzPmDfnTczsjH9H2Phu4F3Ozd4XkAnFdhZyd2bDPx2Xp9zpOusthwXm5DJUAWo
 VV7jZP0YslGd+1mdACkzaM+WLQwdtuGXOSBDA5wpQiQVFagjd1WVmJSy29HfBlGj291cCoss/ku
 QoXTAIxDhVLdwuXcDgs8bm1t4s5P42DEhgjCudHgZJINsUXw3xYOesj7mxlyihbKzCFvtZa4hRt
 TBX2LiPXgAPrZWrTt02Ep4S/Ha4BiBMdfZhP5+jhkLB+qxZdIA7FQUplCGYVOMhcSyTH+1FqSWb
 5v4UPYlGv6puUFVSsGAgXw19aYBALGZ9HWIUFMsWu0REnFjWG6id8cjStoq2S0SkTcDvw0muMac
 oUXl+BTNAR7tIv83Lfg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The FRU and I2C bsg handlers stage their transfer in a DMA_POOL_SIZE
(256-byte) bounce buffer obtained from dma_pool_alloc(), which does not
zero the allocation. They initialize only a few leading bytes before
handing the buffer to qla2x00_write_sfp().

qla2x00_write_sfp() can override the transfer length with a user-supplied
value:

	if (len == 1)
		opt |= BIT_0;
	if (opt & BIT_0)
		len = *sfp;

*sfp is the first byte of the (user-controlled) payload, so len can grow
up to 255. The device then DMA-reads len bytes from the 256-byte pool
buffer. Since only a small prefix was written
(e.g. MAX_FRU_SIZE == 36 bytes for a FRU version, one byte for a FRU
status register), the hardware reads past the initialized region and
writes up to ~219 bytes of stale DMA-pool heap memory to the device
flash.

Allocate the buffer with dma_pool_zalloc() in all five FRU/I2C handlers
so any bytes beyond the initialized data are zero rather than stale heap
contents.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e671c3de8c05..51ab638b4fc0 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1994,7 +1994,7 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 	struct qla_image_version *image;
 	uint32_t count;
 	dma_addr_t sfp_dma;
-	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	void *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2052,7 +2052,7 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2103,7 +2103,7 @@ qla2x00_write_fru_status(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2150,7 +2150,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2196,7 +2196,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
-- 
2.47.3

