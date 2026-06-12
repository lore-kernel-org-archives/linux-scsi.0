Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D8A35836B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258121; cv=none; b=l3B0fAUEgV7kwsSAczXoTBju4yWslsC4XVuEr3e2xMfdm/sM5nob5zWZD2GxQv9P1oaBIvaOzoWlnod3L2Jqve1r77anjLn6NIQYWGdQPsa8brgmxkgha06hSi+Qga8vQoekgRunVH1IkPi66ytR30xNYXX/TZvOdcgEeTcLucU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258121; c=relaxed/simple;
	bh=EQHEWf3MmdvUWfRKU1OrdfzO5hvzNUbOwuIuS4a5qlA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1/WU9nhPKV8eT8H+Irm8cBe6Ze3xB8EObpUnhEerLRT8lhqEtqLHZ351i/Q6vZGAE69g2cCiFuMsMPcMOLPcJT75qdrGpkm+8vTfJekQusMOTcsWkYjyAiWTkJFA6Xn7dgDptWozrckAjUNGeFiLf94ENh1ndjdTcjCpnNABS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ir1O0Fb7; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ir1O0Fb7"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qZA038076;
	Fri, 12 Jun 2026 02:55:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	swgbEbQRo6xdAdApQM0GQlQ79KLxeRpN+wDxkowhEg=; b=ir1O0Fb7kiBaWg6Dd
	I++yvbzhfijBZGimu92zXSH6xdCKb4ILYEZ79Oypg8uHrubEXuvT/4jglBB06swm
	/sp4SJoEq5SNb6ZSZVDqPPikNNDM3qftKAUC8SrUlwVYo9YdQmrZN1LeqfxngVEW
	rbi6eNRmbXNssMV5NsnMLOZSPDilEC9cjNwmSPF+5u3cTT4iLuWGmdMpL6g8Ln6n
	zZ733U0QYMZonTKOa5KgBHDldcP5Dtn72qIwjF+yFCSu1aW7GhWPUA5/wa26Upnj
	la4JRHMWnDsGz5I5WIFjWuSMiN41XF9vcmqAdxQFjcJtDz9zlqJ9XptMeG/uWtvu
	lBLvA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6rus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 74BFE3F7058;
	Fri, 12 Jun 2026 02:55:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 26/60] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Fri, 12 Jun 2026 15:22:59 +0530
Message-ID: <20260612095333.1666592-27-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3+gbCvqzMZOZ
 uL1DQ4Wbe7MNJyrERFMrEF2qXFRamhM/puf6I0Qn3nMgPxrPlJOAJ/og/HfEAwV4YvGQEPD7Kpr
 fGYu4xJ7ysfk/ekwwiLb3vkR5XlDN/I=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd785 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=TERegcne-j9u77qtkYEA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: UfmZ5FDJgecbdreJkjV8ENzenN4MMeZe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+GvwrDREH7gG
 kxxZWKAK8SlaRDJtkckEHGOFhASkwAntPTtFLSy6+SrSJl1+87tstdGaPRbCmJ+8fbQ9vqUSpbs
 mYgEhEFSr5epwYh2K2KOwZeXkKefBKUVZemZvHPq9EjgTBOSHC1S77+ffXG5KK48j6Rlam7CZTG
 3xYFpt3twOOEdbkqfiaCshiJAZhAreCAditXi9F9BNSefb0t08lpV2i07VJbaSnntVGyLQpXipR
 cbmkz1e3o/oIj0QM81eNSSMcPz0RGQm3k2Qk89GwxEiOJaEk5XrIkSD0sQHxePoF59Gjxuaz7hz
 Q2NW4dZqQhSNUeZY+vtsaNUnoF6lWL2dISIuQbQcjXiPbtDNYY+hDs2zY/xtcoQ1cn436gnKX2o
 Pa7rKV6Vv8hH75Lw+1op//AY/NR4dA0o2syJSisiJ5EcpOGCFrjxYEc6Z7XNY5slaO6w+TPOCpB
 ua7SrsUzTxnW3G6h7Fw==
X-Proofpoint-ORIG-GUID: UfmZ5FDJgecbdreJkjV8ENzenN4MMeZe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Enhance the qla2x00_mem_alloc function to include checks for
QLA29XX adapters.  This modification updates the conditions for
memory allocation and cleanup, ensuring proper handling of the
new adapter series alongside existing QLA27XX and QLA28XX checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a3e2c0a95a99..3ac48eeb9f69 100644
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

