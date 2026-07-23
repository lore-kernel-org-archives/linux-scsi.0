Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF71DFFB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783145; cv=none; b=sWg0y/iRSqgYO8Fp1lY8YDkVYM/EqeUuRvV9q6cRmf01C59CtTZqYonkUUP/m3esD83PmTM4ivHVibFjC4tCazPXeejaZ7H8u4N9r/irGESnqmewtKyzKYxjc7yp7oE7s0Mwzogj9JKOcGHAt9XtHTQ/nstQ4LaWH1j3LX6HOm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783145; c=relaxed/simple;
	bh=R5ExyK3VVMaRtV+MkzMOQwzegStDLaVDJrUVLJ1/lyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7GyN+4VOi77JgbZv6KqeeCucK2sHQGs1xLbymA0kyWww5n6rE+5eRHoLwsmiDjKAmt01G862IyWAqeUNXw3RP8BQTEsl2VhubqNV03GsNTNz3UEn0sc7JSFnGn6rYP49NgsRT7DU4cKt6074siQ8NsDbBge1rQFsAHZ15x26uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HzsWGIP7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HzsWGIP7"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w62g422860;
	Wed, 22 Jul 2026 22:05:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	kYL3mWnzUepfErZNQYAHkvnNkDwMcNCXvYYOZhmCyo=; b=HzsWGIP7++BEQNXYO
	5GHo9+bCfrlO/JN1cpSUjiklPJ5P5sW+VUspvs5A9xBS4PFZ2ux59qn6eaLJJcBP
	bM33B5uolBpgb94g0pxAqbZse2POP4Q3q3Ye4CVqdQxe1QR6cPlqeNE0H6EjGaeM
	ER1vUO12IF0igYLrHOzT76y+nyeFOiYZJRS+8rTmKLXBWDgPUIq6qO7itj+u5nvU
	0XBvIXxSyOwTpa4u7gE2dOdc+hmwyC5OsBkZV8CSt9AbeaL/WYTyu5G/KP97H+Lw
	cNb718MOENg/8hrtYjUkCENTvECZwE3ZSVdhoJrUFy+nNzAX+LfC1lHogMPC17aD
	Dhvug==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:37 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A324B5C68E6;
	Wed, 22 Jul 2026 22:05:34 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 24/56] scsi: qla2xxx: Add support for QLA29XX in memory allocation
Date: Thu, 23 Jul 2026 10:33:41 +0530
Message-ID: <20260723050413.3897522-25-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: dmfuSfEwNKtM9qxA1G31c_DO4hPm2dN-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXy8+KkNls7f4r
 HMgFu8bRVRqV0cDOBM330s0Qx1hZK++xch0E0K1khWk5EtT8/wKwq4Q3jYH3WCKg1IVuqbRePX9
 P25SekVFHbClUakEIaSOJPHRsaInRIE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+PbGHFLi9K1x
 6MN3ihRGj10b5a6Ixj2/YSLAslU6DoeZkkJH0H4TPXDrzQiK9EOKrTxdtNCjFlTnR5bo4g+33lk
 QQLXqATwpuFLlvY6ijtQRpwmDp+64RvELWXLOSVxBe8KtSlj/r6cjjfFrOGPECJGe8Jag+e7qJA
 t4vnZT3K5VlPI5vBmNsNesx7c6RtbA7rZjXVoXUVMiPXKllSZlVeuLVzS53TxGOgWno6EE2CMgT
 ZkzVBheMpRbYfuPMY9bLsVD2sliPxRbFsO7lpdWAAFy33FtyqP9hu4wvvPQWuyg5OKqtdqSv92J
 Jbb2/kDvSBN5SlIZN32pEGDQloP0VnRxzMYSWJDX8oN2MNyal5QYWzP88FU5cTAEswZ3EJuX0Jx
 AqkBgDXFeh750ffBqzx4fiVIXSseXc0eO3Juv/5wJHZrvKP9STk+365Me2cTNkusJJmyk2Fkrbu
 QQVc99t/WzvwCG2Iyew==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a121 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=TERegcne-j9u77qtkYEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: dmfuSfEwNKtM9qxA1G31c_DO4hPm2dN-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

