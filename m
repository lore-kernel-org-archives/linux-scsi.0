Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50129443AAB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427177; cv=none; b=toJ5jW8aqdR2SPJKfUWAPpY6UL4Xoatb86AsmtJyQHK4Nl4mCpeyxzfRGBV7bTpzdmOF9+hx/p77pZel9ZoDozf3KaJiQl52XAmEyFhiAsauoJ25jBwvWJXrmdeyhU5uETM1R2b2WH4dtRJVztcrOU5GDMvdozOaRm4IN7BDK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427177; c=relaxed/simple;
	bh=oLtohNwlmjw/U8MTMbdgHwHq7mSiBZ5vP0xmn8Kal1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p83qxrQ17lhReKGOHojfp+oCdj7kWb2JHIMHoBAvDiHwOIx01JkjFKVxuSAA9dnSZapeWgvPDGqB24TxQy59k8ri38IpX6PA3R8ckvCWCLh0HW51RQR09j4NJE7jomB1TW8Kow7BZKMqA3AIuaGfYTLnM4Qy7Od+4MrAM6pQTJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Hkzequgh; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Hkzequgh"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFUcLT3036967;
	Thu, 30 Jul 2026 08:59:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	FJ5JeGu5fpVLFXsuxPlYn9pXivsqRHbY+p0RqBK+RI=; b=HkzequghmaslFTI8i
	l7FG1gXsJY7TFmkcQeXPoq9xWBUM/KZ3j+PMKlstZ/vPKeDdnYR6GVx7McwYpxmm
	j5hZqFuEmQeAWfVsUxP+YaC/YiuBFTJ/xbgHwkOgqqBdQRTlxE72BeRUUTGL9pAR
	XXWi2+rXvgVKjflPbJlyl6HC6rkEp6C4D2yd+V4HOOws6izHk86AnMij51/27Deg
	ROQfCSRXhnvgyfcSWtG/YY6yRw8BvnVoLlQeyhPjj2Q4y3RhZjwaikzOaGs1RLNW
	tpnJp24evm+Z4vLESwS1din6g2wPWGh3+aVPInO2siONmZ6pDLmN9oAvM1FVfS83
	HaLGw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7atqwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:32 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7BFB63F704A;
	Thu, 30 Jul 2026 08:59:29 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 10/33] scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
Date: Thu, 30 Jul 2026 21:28:15 +0530
Message-ID: <20260730155838.2119230-11-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXx9QxqwAf8Du0
 N0oHCGghQiVCuYSrKfjYRvkH8QW+RuRr42JPZj8oAaJ6/tKBEVogGdD2ODk3OvBahiNq6VY3FBY
 PQz46iRtVOKNMScBQ9vtv8dTLQErxnCcrq6oTChvE4XbXqiK9PoQJ/3MBvNRifDF08RBNFpLvzo
 jgV+xYppzrlC/Mn6LefFfJcBmCjRCz28exLt+M1hgy/wuiK3xI4vbDq5hkpDt5BqxNOLFY4dzcl
 qjn+kOsko8lG+7DZHSWdM2KFjmlFAoVLbzPHWMxUcDP70qOqRyvaUUj2T39Iveb1h7f1bzH3vRV
 8TKFtIgpq+AEjwU2pGdNdcR36RJVDvRT0nkG/PmZyNkXFGsSjc5UzAmoehycTHOVimXP3z2deqd
 4KctDtaCX1ln5V4z5m+pjS0UztpOsZN6UafuJXYoWkz1KovXIu/dwwLX5JvOTEZckxMHSFQNAQJ
 vgCU7pl4DmegEu4bs4A==
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a6b74e4 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=bAolQom50hykzV7YMrMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: PAAUM_PBgIdpakKgPq89LYEmqbx4Sus_
X-Proofpoint-ORIG-GUID: PAAUM_PBgIdpakKgPq89LYEmqbx4Sus_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX7Yz5gObYn7OX
 CbaCe5aR7mg3S9njHPz2CXSw1pnxTtR294K5+hKxruw0ANl/6/bWkujf6YUsZCIs4mexmJjNvii
 /i6/Jivdq02LCXJXoUi23+V4p956hmU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla2x00_free_fce_trace() freed and cleared ha->fce while holding only
fce_mutex. The firmware-dump consumers qla27xx_fwdt_entry_t264() and
qla25xx_copy_fce() read ha->fce (NULL check followed by a copy of the
buffer) under hardware_lock and never take fce_mutex. A debugfs FCE
disable could therefore free the DMA buffer between a dump's NULL check
and its copy, resulting in a use-after-free.

Unpublish ha->fce under hardware_lock, then release the lock and free
the DMA buffer (dma_free_coherent() may sleep). A concurrent dump either
completes its check and copy with the buffer still valid, or observes
ha->fce == NULL and skips it.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fb417364fa75..fed6dbc3b6ae 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3752,11 +3752,27 @@ int qla2x00_alloc_fce_trace(scsi_qla_host_t *vha)
 
 void qla2x00_free_fce_trace(struct qla_hw_data *ha)
 {
-	if (!ha->fce)
+	void *fce;
+	dma_addr_t fce_dma;
+	unsigned long flags;
+
+	/*
+	 * Unpublish ha->fce under hardware_lock so a firmware dump in
+	 * progress (which reads ha->fce under the same lock) cannot race
+	 * with the buffer being freed.
+	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (!ha->fce) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return;
-	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce, ha->fce_dma);
+	}
+	fce = ha->fce;
+	fce_dma = ha->fce_dma;
 	ha->fce = NULL;
 	ha->fce_dma = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, fce, fce_dma);
 }
 
 static void
-- 
2.47.3

