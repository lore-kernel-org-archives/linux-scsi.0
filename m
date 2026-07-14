Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA59432A3D7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022924; cv=none; b=EW+f7egX6CLxfpIjF+rYcv0N18ijm/KUPKQ67LaNVMLtbd6KFYiyUYpwhhRulKcy1hoMEhcQt0R8KYXO1kUwc8AJKGmqVfHwdAMs7/67uvQxEbnmdh7qPsFjjGKwHsuFeRozcoyWl1M7d4rVwZPhbeVZPXm+pzejjuVLmhqkF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022924; c=relaxed/simple;
	bh=R5ExyK3VVMaRtV+MkzMOQwzegStDLaVDJrUVLJ1/lyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H60LHId0e7ddIlOzjDnPm17PF3XPS2vxExqGj36VHa7Ir9jHlG6//nIqMM2l2mMW7EIwSkVvDDepKImNcAalm97gYR6Iz3W30EAZy64CwHTseRI16mq1rjCF8VMivmjyRkEJJk8P/SESgQ09sI/rH+iOO4SuhI4aYpDLXVrZ9pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=N6SiIOYr; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="N6SiIOYr"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UM4r2408068;
	Tue, 14 Jul 2026 02:55:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	kYL3mWnzUepfErZNQYAHkvnNkDwMcNCXvYYOZhmCyo=; b=N6SiIOYrLhvkRdp/l
	3yxVD2AoyMYXO36/wBw8cEj/kVyGUou84KLHm9hMOnqDLXY42jEc0YJBb2qF2kFw
	qEvezz9lno89Z5sem6LJMC7vtTil6NGhUrJj6YrAzYZqJnl9/2WhwN98LRRjIVQb
	5m9SKSpPaL5R756zrmuD6G+GkoeoeEDaPExWhYrjKAGZs/ErTgWHB8E9rxJhrgmY
	4ZQwvzLduc3EfrAOc3tFsYm6CXeKWOpoACZIwjR0AtRWiWv5GDcTaDB+2SWp6o1+
	N0nKUmt1USE/d6QYAkfXBNzhTioCh8Tft7Ekpcf/xF9jM6WYFbJWtMFsF7pwceb9
	CjUBw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:19 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1A75E5E6870;
	Tue, 14 Jul 2026 02:55:15 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 24/56] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Tue, 14 Jul 2026 15:23:21 +0530
Message-ID: <20260714095353.289460-25-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: KyzxaWeNLCOH4UCdOjJd7ob5oNDsmgXr
X-Proofpoint-GUID: KyzxaWeNLCOH4UCdOjJd7ob5oNDsmgXr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6RT3j0IReGMz
 jt/eJuCRZ5OnH8pkS4TlM+VIZYOGVrSc4snnUK9Fj8TZSnRM1meEhedXk86tmHyoHwdyVWFEAN4
 KUvdJuDKXqJIE18cf4UyuqeSI+7a+wc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9MymBdXugEoi
 bYnsqZExOYhXAGx9yreD67vxj8XJJtuUACeBIt+7LwUoFOuhXmOYHTTAXmix2CXejsV0vl2FJ21
 LkdNXYsPMbJpihbNzmQ4o9ygpmqaA2jIkSczA/mWb0ZfwtrdsqkHHRsVa28neeMjplKDMXxeiJ6
 aGZNamSir07ey56J68/8+1Nc+92dtFfaK2Zq1m8/AHKjG+p6fLAq3PZJ24U9OLCelvgrQBFM7ZF
 mIWGBtveXVDVMhp/Eh7+hATMhviUiO8ZJ3eawwpRGoTuYYwZdyXNX3VO5es8WBgm9TsqXiJZ+WK
 lG1JPj8X1w0Sw59VOIGuRYxPfIZlfUUbPZmzQ0zeZD90anr77RZ26+/aYoluCOkqQ+Whufdl8y0
 daTi04AnrYrdy6sg2Iv/k1VuukNM6za19T5Gxcmv4gK7FcCeutLX7i1HQqj3bSeJlwHudWPxyLp
 pzaE7TLQzQHQDDdkKOQ==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a560787 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=TERegcne-j9u77qtkYEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Enhance the qla2x00_mem_alloc function to include checks for
QLA29XX adapters.  This modification updates the conditions for
memory allocation and cleanup, ensuring proper handling of the
new adapter series alongside existing QLA27XX and QLA28XX checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5450c40259bf..3be59179a024 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4285,7 +4285,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->srb_mempool)
 		goto fail_free_gid_list;
 
-	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) || (ql2xsecenable && IS_QLA28XX(ha))) {
+	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) ||
+	    (ql2xsecenable && (IS_QLA28XX(ha) || IS_QLA29XX(ha)))) {
 		/* Allocate cache for CT6 Ctx. */
 		if (!ctx_cachep) {
 			ctx_cachep = kmem_cache_create("qla2xxx_ctx",
@@ -4319,7 +4320,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
 	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
 
-	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenable)) {
+	if (IS_P3P_TYPE(ha) || ql2xenabledif ||
+	    ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ql2xsecenable)) {
 		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			DSD_LIST_DMA_POOL_SIZE, 8, 0);
 		if (!ha->dl_dma_pool) {
@@ -4681,12 +4683,12 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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

