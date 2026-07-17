Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378143AC00
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302226; cv=none; b=M2g9S4Ig8zf1BlD+QnTAKqu7W5ufzBpFJ7mElh5KlLVTF9FRHPbH5OeWfkWWb1IbuNP8vOJL6dHRqGWFpYZH7xrZROy6sVqMtJFxmi0o1LdVqL2OhdoTXPLBkW8Ka+Ttu5SVliou8u+a1WMP6DFxFJP5s3/KQTSTxsG5c6KR80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302226; c=relaxed/simple;
	bh=R5ExyK3VVMaRtV+MkzMOQwzegStDLaVDJrUVLJ1/lyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyhGKiUKJ3fBYD6oUVJdqRBIiX6oS0npeQvUed+L3gF2Drjrozul7jeZssULM61Q3DxiVbTPjfAgvlBKFJUtMyysGJ20NPB5JhYawdy06oMaAq7QjmKzP53pR7F7UlaYRQdikMGDX552vRewEkV5QjZHEssPThA4L7AaZSiYexE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZGEgsCHv; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZGEgsCHv"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7tws094741;
	Fri, 17 Jul 2026 08:30:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	kYL3mWnzUepfErZNQYAHkvnNkDwMcNCXvYYOZhmCyo=; b=ZGEgsCHvSfBpyuGrI
	dcMdk8WWQLIIYJWu+DcWaOSCIar+5boBtn0oQWiOX5pJ6by1QWhbI3JJ1YCVvK91
	oCZ0wZ5bOBKWFCIBr66VViHOKugq3pW4gH6yRpzQEKvaLtQAoaaxxcmqwB8yrr0V
	Ssr6yGFzUCIWwPwANn5b2d3YjbXwT2U3f+cyj4ZgLNygfK8yk/S/5IgrJ70xdgbp
	S36E4DesHeI3auUR4Pv1TVgQrOAPVsPcPp488kpcOKKJjIw+zR5cluVNccmmn10p
	tE2Nh42HkEAXmkoRXeoguh7/E6fvDegV9ziNX9TZpWp01IMIFvXc+zOs/xlUe+oU
	Wtp2Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxcv-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:21 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A94545B693D;
	Fri, 17 Jul 2026 08:30:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 24/56] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Fri, 17 Jul 2026 20:58:32 +0530
Message-ID: <20260717152904.3155730-25-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PI8WMmkPBK3ZvP0Zno6wuhlnhSctE3Lz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5UNZ0dyB4OAR
 TBXwJ3QCFSSSqZvsD2G0HITb5l6irfPSEd/Eps71Q7WSxzXezLC69wtxaWOkthfQ2ZhIypKn4qe
 GeQ8QNT5frwJXFQzo7NKDJRzO6Jy86o=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a8d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=TERegcne-j9u77qtkYEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX2EdYOSnvXSah
 Gj2sRTzgHK35SgHKioivIcSphil54Jnqe9fJwgfK7LQsSDDfSV9n9lhy1xw61ddhzaYh8Y1ShEP
 rWz3OYacZ/TRTQyumej8XlfiXUHPm4AivHn8bcBik5yjBOJV8IMiDGMNcElpzftqc4njFcJDtbm
 5Or3LWpfYdfH6TjvuGeqUdnCOiBi3LPvXMSJ3Nm2kLV2Zn/0M+pN+XRa2XrqqNr4V5dfSKaUId6
 ITaYCfY7Q2Vkax5hwtFJ7YTJlMkUSlw8CQ0F2QWlCVZuGRdDl248msvlknzG8KeAdVuqhGI1mDN
 4/V3oA7gDgPHHvolfVIJYg38irEICKtiGXyflc34NUWSchnnVz0ApI1Gq1weuCpBN6Yzlh93VTB
 JbJ/gfgIFG+F6/Sz+vyyh3DPxeu5nTwaffJEGqQmpORk0McHgr9Zq3iwpaF3OebzuWOjh1LDjFQ
 ObNmBs5DFhB9eSpgLsA==
X-Proofpoint-ORIG-GUID: PI8WMmkPBK3ZvP0Zno6wuhlnhSctE3Lz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

