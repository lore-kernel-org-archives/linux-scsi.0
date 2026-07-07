Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D85474E
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403776; cv=none; b=hT9jXsje4NfvVTryE9UATdNXEap94vps1Xa8BK2+p6v42+nf42KwRoKJYFtG0RuKZ8MjDEz2B5E5Hv3O8iA148BO+tm8auFLDwNuKUWc+dcmS9KQFtpLpwrxx+l2JPpHJyMLkKfVBzNjCVCVJ4CJseMYz+p3dmSbSd8SQYAmM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403776; c=relaxed/simple;
	bh=R5ExyK3VVMaRtV+MkzMOQwzegStDLaVDJrUVLJ1/lyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1hVBUaCtxQLWa8CD2mzRi/HkH2Tj1aUbHzVUbqa0/isBKsWuUL6eoG6OyvBYEPxR+iftL/YLIRz8BgVFF4OI/e7WC7yVCQCuR6oL+rE+VdmgdBC9UnQHZqMLHC7D4d3h5VUGOZbBvts9IS4e/VEasQVobFRufjqBh92hrvYo28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=I33u1tim; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="I33u1tim"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748Zm21656002;
	Mon, 6 Jul 2026 22:56:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	kYL3mWnzUepfErZNQYAHkvnNkDwMcNCXvYYOZhmCyo=; b=I33u1timO3QauB4fD
	u6IDHeRpO8yAfGOQ0vr8sF4x3VcaT5bDtLaUY1lYnsoyw52NDtH/QsXIs9bdSBf+
	SCbqQDejbx0RAh80rX4oLRUK31rq0gfD6gV2DtDAv/zxMdrCpfaL7Kb71j2q49xQ
	wTei8qUab7+cQEG+v1QvrSpLAhCEG5ay7WvzaDmkZS59T32Q1N0sICEuxOag8yts
	cKjjDbQMZ9KYwPRPMoRTzdiWc1pMW+OdytQB55PV6JXnSZmEuxfuAXwlnczDvy5o
	4gpyGMkdzh1kslMD9ZojACDIbPjMD17TRIg+0M1KAtGWYCHJHTkCkqXvr76RyX+F
	rknRg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:11 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0EEDB3F7066;
	Mon,  6 Jul 2026 22:56:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 24/88] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Tue, 7 Jul 2026 11:23:31 +0530
Message-ID: <20260707055435.2680300-25-njavali@marvell.com>
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
X-Proofpoint-GUID: 5-qbgLAElYybAz5PSIvTDfqrkifAYK9h
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94fb cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=TERegcne-j9u77qtkYEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 5-qbgLAElYybAz5PSIvTDfqrkifAYK9h
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX9+ikz4EySGMJ
 a9YnYVwTDpc2G6NI7OvekiP8WeZtDI5q806WGLmf+1zyw1mTaIZTxOHW8Tu0S3nJbGQUo9InRQ0
 STApEAXerYZN7L5GzQ+NN02BUxsjq9U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5iqN0WijKBIs
 i/18A23IW5YgRDNynjYdx+UQ5I3+UP7eTN1oVGOiWMo63B1lnhg+E2zXoN6drYyACSc6g4EIrXx
 +wgQCy7cPlzrftBUKz/8TbIRELyNkbN5Ofr3I8sue6+MUb3K73SEnOpUbeyzJX9G+OJEyxUYrBJ
 8udR5+rWaCJpOPRFKrQ4UJB7gHLTzm5HhT/hUkDweJ4KDzr8viNmyt0aLh8C4ZcgY7UmmDJ3MBl
 46O0I8lzee1du3DmvbJKYzlrbdfnNdh8akdx9cXxLt5huqwDsxrLdXkZkhM4CCSOdmLe7oWGXXz
 JKIyNy0ttEma7c19KKxSbPmvX+yFjAcIIyAqqcoyWQ6zRf2i3MLaF5NqQYJNqyeIhBWawdw3Pf4
 pXdbTfMGDrk8X5zv9Ka2QguWOkjubrsnFSnPt36GKY/wPbfYVHD/p01CYXM2R01BRNm+bSYhN/T
 nojXVX7mMgfVo6yfNuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

