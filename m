Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761D38E106
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427235; cv=none; b=SYP5potGoZW9DTk5Jx6om04XJXal1/vlx56v08fSMZVZaMuA+duwW8lamqm7AojGYQYbZ7MLRJGqQxQe5vAoFkbvnFNcEHMwPNHR8OakTk8GTw7p0oZ9zG/uQjvP1r8oTKMgOv5XlCQ1lFFJkjnC5WckEckMURwwEh+u8/K26zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427235; c=relaxed/simple;
	bh=VXpoCfPyfl9QkH6/4qWQKkx44NOj9xl+/HieR969I9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7zC0aKwpsSit0QYtmnZ97a6AI1cDqvdKpg9+yK59333lGa1/gpMr/8hkQHKSJ4EX5sRxGk9oM1WCkzcrX2VYOcBuMposYO3wzeza/TMDq0bYFhBeXqGEokWyo6Kra8RMQjorD3QlbjfL0A9Bw8sCi1R/XfCZmnOvoeMnMqoDdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FxO/fIDV; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FxO/fIDV"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFUcLc3036967;
	Thu, 30 Jul 2026 09:00:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	OnRIP2jh85tQSWvxOyRgU3Uqg558hR9jNWhN5CpODk=; b=FxO/fIDVR1hx2rIVp
	9LlDVfnRK0MOYue1fqGZcX6iP4DiMRXfnTTQBw34mWyNTdUIxSMQ5Jn3SNcf8E1n
	HLzYkcXF1vl3yCaK2O0VpJ7hFeHzmUDZLavH96BudUjPlSagndDHGJgl5fUFnyZD
	omp5N6QbkYgvq1CWEJYctVXd06s+3YiXVqabFOpBYOtjTsa2ZhP5VT7DU7ub8kHm
	1DNov0EC2GjTS15+RKKhZK6pQEUikkSLmHYOni84qkKQEY7XC9sF1/JfMZWRpt9H
	KuNj5JhmTEHPR182jBVafIU5F2uG3lypocGb0wgspWIYxiYR3v4ZljmFZvfsvd++
	wIK5A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atr4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:28 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 55CA93F704A;
	Thu, 30 Jul 2026 09:00:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 31/33] scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
Date: Thu, 30 Jul 2026 21:28:36 +0530
Message-ID: <20260730155838.2119230-32-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXwqYGw2Lm7kjP
 25c8qAOBNbA16E2Ae5UchSxGM0+4XlyWA3G5tDfWkddQ6jx2Ug+BG4HF8R2AF1pJ5m/c/9lrL62
 w2iBW0TD87MbePpA8mKtWBOd09vA98LPKlWD6nKWerHSf8uhcT5/JQIIuY63wDj1TsppCxkZmqg
 IbCmDSeMhsNIDPGuF45Z1pG6gZBiXNrIQ6EU1bLj1fpLRtGemzOqd9Bt4p/RLUQsBDZr0XQ1d3N
 4RrloQNJefXqiwoXUPfl9Wq/XosELnqqcaEtVk1LyFbdq/2lXZpuRT9J+EqY7kQ2NL29dJSxf0s
 n8PauZQ0l2Vl7pLAfcUfEMhCJpWqaxFdBw3z9KmcjImMa9yxTV/o3FZLACD/1kvNvN16TUGNtoR
 dooj9gLx/4ToVf6P2hfskvxWvYfvYgULH0DG/30Fu8Rigvhs1WNUcFcsdMGptVs5MtcCBtYs+EU
 drMeFp7StNsDVpB76kA==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b751d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=Xx_P917AdCZa4SjJxbsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: xyafZ_RR0jPWyqH2hbTBHRXW2xqTbr_B
X-Proofpoint-ORIG-GUID: xyafZ_RR0jPWyqH2hbTBHRXW2xqTbr_B
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX12Uw3mKdeKqV
 26fAGT/NBTwbO1i9/+sX99wQiAR+xvWzjKmbKKtqYudsIpUgo0C1oqMK6OcA50o+2fY2dV0WBWP
 ofCLhq4qaVruG5rA8LNOc1XoroU6R7k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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
index 7fe7480fdc1b..59fcc726b682 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2008,7 +2008,7 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 	struct qla_image_version *image;
 	uint32_t count;
 	dma_addr_t sfp_dma;
-	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	void *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2066,7 +2066,7 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2117,7 +2117,7 @@ qla2x00_write_fru_status(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2164,7 +2164,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -2210,7 +2210,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
-- 
2.47.3

