Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FE82D0602
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427227; cv=none; b=ttUjlD+JzQj6PXC5AcKE89r65NNAtNrWjhGfWsy9eeT5pmAk1DFNYztmmBxuWzmz8F6SwiLg2uspSvBYq3bhOXFRA9FHBYk83y7rTDc4SuXVcMnyCD6Oz/dBypCuDPFT/sWpsN4koYOL91WuKill6qsGC89LnwD2UO40LVvYOvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427227; c=relaxed/simple;
	bh=/QeG1GvRbd3jBQtT6cX0HNJ5YXCLNeBQITybU9guAy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKubD2B78jpSNPn1xVgXF4qj5j1NW8aX8vTf+Zerr3NBM7oWr6GiEQFyOk3xqkOmdvFpGXN+eDGaz8Ewrl9La6zbjC+v0Od3MR3nxsIW0xU2FfN8m+E/trfK7XoOittP/7KGoxJZCmBsYPE1H6K+wJB5/F2Jt/fn6QERqQzhBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=e9Dg0xdC; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="e9Dg0xdC"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFUsVu3037261;
	Thu, 30 Jul 2026 09:00:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	7Imy32yt3Eyw6TDmDKtnZi7dp3uIMPPQhmLK+DKLGQ=; b=e9Dg0xdCdOecKW5nu
	WjsM9N5iXWwRt1vu7l649GFIQXAnl6xz2Y2XQaE9NaoiJ6ucVmrr9x6OXqzqvBKC
	zAu6K/EAk7L8DRCz7nM6W+DGf2HTPikaHbauILc6kvD9Yney84qi/sFklPEWetea
	6DRrR2DSW7WYUv2WGthnPdPxqd/LCyoADRgCVkMgZR48ADQ72fwTs2rgRKFnVww1
	hX0R+f/G0rPXsy+aUONV1YvYEr132K3FsSPgMYPnUNKthHJkMkIhzmuVZ164SX+S
	2V4E6FyZS6Z8wAYfpRx407At6u0ZGzNMh7W017T5B8pGb372Pg29Tyxbyxc+0VoK
	/HlEg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atr3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:20 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:20 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DE7BF5B6955;
	Thu, 30 Jul 2026 09:00:17 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 28/33] scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
Date: Thu, 30 Jul 2026 21:28:33 +0530
Message-ID: <20260730155838.2119230-29-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2/16Eslgt+qc
 7BwT+roDsvyTDpOk1Ph7K9E8qpCXwvZl7tVOdXbdgEe/IHIOy8M94twGEL3k4FVu8Yk+9fTw44g
 b3M6RWujQK1zAJ8+n75zsT147eWnjGRsaw37cXJFiow3EuC4ZfBkMn+wxM6Pf3Tqynl6TPEszBj
 qy4NF1fSgHSfJfBoidgqmFJ+jYUOSdPyUONUnJ0fFvtHV9SLa8qd5Qh1jh6M1C11ak8okQR9rQS
 Jnzz7z6A7uwzMe1B9nTj0knjVRroymYnpgmEZpsG4+DaXis9jYHaRXf+YtKB1BNropikG0QrKp3
 aoMmZn93/7v+p/Q2uH7Q62c1y3uFfhsjVnJHGejf78m4miGP3CWxd+ohK/hLW+jy49BfSt7fkWf
 WPPHp69N0Rd2nFfFzDd78NsYQQMTE9o4WxN8ZFTsnLuFeUQoyvOQNTkV53nbasS68PP1yGmLHE1
 gcEWehTZdqJOlW28jNQ==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b7514 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=KQ_0Cfz0W8kd5fU-n70A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: NMPvCOqDoK3f_1HmdQ7HY_Jb6CKwd-X6
X-Proofpoint-ORIG-GUID: NMPvCOqDoK3f_1HmdQ7HY_Jb6CKwd-X6
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXyC6YIIEyUl2/
 CFJxE1bAtMaItmOiY2u7Ssyhd9hjyGxOirf+nQnhybrUB+eVjWrNVLIesqmomoi7M106vszQZRU
 HH8qJHnEKcQR5H7b53b10UsvhXeWt7M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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

