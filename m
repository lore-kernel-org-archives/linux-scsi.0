Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C653101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403946; cv=none; b=npHwKV7zY4azyyXhuwin5bJtvPO8i9Dl7fJd826VqhBQe0qQKFLKy9jk5Z9l/xBqBEyDv6mihDMdvtB5eZ3wQcj7gZxp+Nbj7nAFvH6GgOCAZ8uXOjFxysj119PgBXjczgLSUf8ozVJDv6sRHW+GYTSN27Na7ouxQ8Oup0tionI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403946; c=relaxed/simple;
	bh=/QeG1GvRbd3jBQtT6cX0HNJ5YXCLNeBQITybU9guAy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ci7KJO+M92jUOOubJcNfqLS5C/1QH5E1DtwjGHGnNVFydec17iN9ek1jYVwueRZY09P8kyNeSWNnVETelgpKh1zSjUZcDfmx3UayyNeH6l7yGrwJ83JebhTXoREkmsGhiXa1OvzSBiLeKrVbG9nbsKVJfABaKAdM9sPZNFauU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GtHUsHca; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GtHUsHca"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6674834g872825;
	Mon, 6 Jul 2026 22:59:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	7Imy32yt3Eyw6TDmDKtnZi7dp3uIMPPQhmLK+DKLGQ=; b=GtHUsHcay9GpwXksY
	IGu2rYBPTGyG1U9A89m+b3lmlx81Hbt9CqwtsJ/qbWcD1OJto/CKr9o5dobJLDSA
	YDloqpY320h20M5Pdr0kYFDI0h9UVSVsx6C6dL1oB3Y1tSGbs4aYTfZQbJ3hsHQ+
	gXy57Eps3Mb5NFAbh7ZclZrK1L7dmDXH85n8Ygu6XHQYdsy0vP9v4KJ5244v+HES
	OO6mJRwaAg5xdlBsRMehiK/7SJF2H+uzCkLIvdS3hYCfo4QmTJiYudFLq1nlQYZg
	91bV8QqfHhDf7Jmb07TSQH/djYhIetbiwwCP8rfH09jtdIMP3EPpvlXiMyvdlIsH
	+gxeg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waace-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:02 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DE4D43F7066;
	Mon,  6 Jul 2026 22:58:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 83/88] scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
Date: Tue, 7 Jul 2026 11:24:30 +0530
Message-ID: <20260707055435.2680300-84-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: tD2Pfz5vezgKAQfl9hjVZfoqr3_dnItv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX4drhnrSTRXsv
 YP1bArtuIevh3yyNEfzr569KxDOv6wcq3V7ljsPihr36OTEDxaAYsepQ+AVwmOsQfxO3kIWfNRh
 4dLLrbgaOYpu3RYLCoSblxHV2bGIeG4oOJkN4asK76lmsj5wYNi81DaHWUzmzRi7dQXKxhkXv0t
 /NJw8FZoBo72AuD85eKxC/NxMFeSczNrZ9/omrNKeY7rWzFSeMpj2K6Zb8y/giq7EisM3CeuNDf
 Z/0kHuwUz8W6izF/nbTC/tkBmUiY0Ocr2CkJfpc1WS90KVbQ2FavuQ3lFYDAvmeDYjrqGx5ej7u
 TYClB4iTuQo1ZM0306V5BnxHtqirOmT3FZJQKMAs2yQluNBonYw4OOOWrW6dVVTh4Zin8BgTPbD
 Y7+VOmLHq60WvLnrIG3Ih5zaY5D4Tl0NRydDP9D8mHrkVVq8hMFa3nhs3ORWi0yuyQtoWxY+o9I
 Y1hOIbXgEkQrkfHFvXA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5THeeclsNft1
 yNSV8ZnOCNC6D7w9NZcBYqLe37Og+nnqjWgMBiOAk84H9CLYBXaCsb8G1+2/XaHDdcClShX1iBQ
 YTTW317HQvt5MCnAGPRlwkJmEUKWmpg=
X-Proofpoint-GUID: tD2Pfz5vezgKAQfl9hjVZfoqr3_dnItv
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c95a6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=KQ_0Cfz0W8kd5fU-n70A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla26xx_dport_diagnostics() streaming-maps the caller's result buffer with
dma_map_single(). The bsg path passes &dd->buf from the __packed struct
qla_dport_diag, where buf lands at a 2-byte offset and shares cachelines
with the surrounding options/unused fields. Mapping such a misaligned
sub-buffer violates the DMA API requirement that streaming buffers be
cacheline aligned and not share a cacheline with other data, and can
corrupt data on non-DMA-coherent architectures.

Allocate a dedicated DMA-coherent buffer inside qla26xx_dport_diagnostics()
for the mailbox command and copy the result back into the caller's buffer.
This removes the streaming map of the misaligned sub-buffer entirely; the
caller's buffer is now only a plain CPU buffer, so its packing no longer
matters.

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 39544deab576..59ec5605930b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6579,6 +6579,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	dma_addr_t dd_dma;
+	void *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
 	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
@@ -6587,15 +6588,12 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,
 	    "Entered %s.\n", __func__);
 
-	dd_dma = dma_map_single(&vha->hw->pdev->dev,
-	    dd_buf, size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
-		ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
+	dd = dma_alloc_coherent(&vha->hw->pdev->dev, size, &dd_dma, GFP_KERNEL);
+	if (!dd) {
+		ql_log(ql_log_warn, vha, 0x1194, "Failed to allocate dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(dd_buf, 0, size);
-
 	mcp->mb[0] = MBC_DPORT_DIAGNOSTICS;
 	mcp->mb[1] = options;
 	mcp->mb[2] = MSW(LSD(dd_dma));
@@ -6617,8 +6615,9 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 		    "Done %s.\n", __func__);
 	}
 
-	dma_unmap_single(&vha->hw->pdev->dev, dd_dma,
-	    size, DMA_FROM_DEVICE);
+	memcpy(dd_buf, dd, size);
+
+	dma_free_coherent(&vha->hw->pdev->dev, size, dd, dd_dma);
 
 	return rval;
 }
-- 
2.47.3

