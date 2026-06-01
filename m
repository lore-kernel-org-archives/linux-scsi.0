Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D19D356773
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309837; cv=none; b=W2GBHVKYuPX+KxDDaXCAWMZ6uRqoDwzuuilMdOa5k7npKRAF+ZlFi2mAEj49qt0xAJ4j11vsT7j0SMr4jm4GQaMdBgaH7OfW3C70TLY2ZPPqQ6IEYNA4EQK8+ZUdcXmfmGanhU3oT7qVsgg4J/bUBqohLsYYhsKItYQFI1zmOn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309837; c=relaxed/simple;
	bh=Tlv05vFzHK2tY5Y0w3LFr1zg1HCOCgk1YANJWsx1bbE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mIUyxvK5yoHpueR9sVegx0m/1VpyN9To6AbOQv/Q4ayx6zQgwEHQkLaF2zSME2ART5o99LQcc70dlr9X3I8bLs2jM5ext2mpyLXS6E4mqE+xahL1TVOopqzfGlPZlsoJSIigBflBMEHjRVs8yyKKLkOadz/zC2jVM7dJjycU6Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=InoIqyJM; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="InoIqyJM"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLc5Px1194256;
	Mon, 1 Jun 2026 03:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	cd4ETLqpxFY7GSef9rs5vo1V9cecEjRMBiNztchqsw=; b=InoIqyJM/xYmusChs
	moO0OKTy7W/jxoqZcwy1T3cRxSDNHP2PtgZGi9cWXhyMxZ/G4LfzqVyrFJ3ItpGi
	yboeOrCvjnkyXXjnIFusGh0RRRTcQrFppT2LSBWE130t3hF1s+CMpsOafC++Xuea
	F9BMmyc57NCO/EskvnPeKtSQEyjCUsjmJGz9hqWvXrn7lp9PAeL6Q1HZ/MtDbvzi
	W1rZkmnn3wwuTKWHaA5Xx7Z9QCXikmOxj9KU+6WDRxr0La7RKq/IGXTDm9RfHLqX
	xtzQfv7/hl+wTe2dQqnpLVvo640+o6OSR/MITMGGvm02eTSqVLHU3lFgcI7iVDw2
	tXgcA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:33 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:32 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3C7C53F7054;
	Mon,  1 Jun 2026 03:30:29 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 25/44] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Mon, 1 Jun 2026 15:58:34 +0530
Message-ID: <20260601102853.328426-26-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXz/dhkyLEtlhb
 KHlhC5XcHk3RTNLUuzFtXBpZ6lJ3MZ+lFC0qhW7IFiz0oMoz2JiqzkO4opj4KyPv3N4vU0gfroN
 c/1900J8X1aMqLwdywacdYkLm0JQdrGoZDTFVzpI/M14qcqII0dBD3qjSybJfEzBGi9HyxoRJOi
 1+MjZUPLzbdOE2nJsiwBTwocmMUIMz5A5KpUABWcCRbvU+o1u9qlcSsz1DyOtbXoruSsELtCj3L
 TTmo+XigxaPiESR439+lHMGpQmcd4C4klXMVAe4SOHT+YnM2IpxWR+vxWh2c5PEEWFadbp/izOp
 Zgl8AiZCgozEjIKyKgPN2HC/GG38PkD/C9gwdWlcDtonNC/FLoTeRmfLBGIpFMgGnRpfkd+qE+G
 ETtURTAD98IMxcG90D+VuwQTuRwvBjkgYqyLezJl6/+LS9kX54foO82wQsdqhQ6YBi13WOU4eCH
 BszPShZ9FVYB66YdskA==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f49 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=bZetTGex_0g1jdX2yFoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: gFtdC0VsXrsmogB1d6bt_BS67pbfsK8R
X-Proofpoint-GUID: gFtdC0VsXrsmogB1d6bt_BS67pbfsK8R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

__qla2x00_alloc_iocbs() open-codes ring pointer selection and entry
size based on IS_QLA29XX(ha): 29xx reaches the slot via ring_ext_ptr
and zeroes REQUEST_ENTRY_SIZE_EXT bytes, while other adapters use
ring_ptr with REQUEST_ENTRY_SIZE bytes.

Replace the two branches with the qla_req_ring_slot() and
qla_req_entry_size() helpers, and initialise pkt at declaration.
The IS_QLAFX00 register-mapped writes remain guarded because
IS_QLAFX00 and IS_QLA29XX cannot be true simultaneously.

No functional change: the bytes written to the firmware-visible IOCB
are identical.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1cafca1ea596..e5a4bc58cc9a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2418,10 +2418,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2482,13 +2481,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	 * layout-compatible once we return the pkt as request_t *.
 	 */
 	req->cnt -= req_cnt;
-	if (IS_QLA29XX(ha)) {
-		pkt = (request_t *)req->ring_ext_ptr;
-		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
-	} else {
-		pkt = req->ring_ptr;
-		memset(pkt, 0, REQUEST_ENTRY_SIZE);
-	}
+	pkt = qla_req_ring_slot(ha, req);
+	memset(pkt, 0, qla_req_entry_size(ha));
 	if (IS_QLAFX00(ha)) {
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
-- 
2.47.3

