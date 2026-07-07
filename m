Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38AD3101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403897; cv=none; b=IdzrUxMXFNaTXRbok3TACwOJKVYHTYsBHwXsoCPXb1ejd3WCwETlLo+h0BDW202oFN37y4vpWajzpkSHPMFzTXQZ32Bs8vS/OnwGnkUKJxWD0nWVJ532K92FScb5flwG/O0yEMm5XLtAX2bGUYraj8RKRqKS6OLIQIU3t7+Gbl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403897; c=relaxed/simple;
	bh=rI/aN2te/UJoCvyzf4oq+cRY/sL/qfaXD4dOY3W4K70=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAaXDZDFihp4tywMjVXtw2zK0ZacGtYpgmGnV1WzteWJEiTYYM7mjZlLa4PfZA0376As3BGBvcYo5xG1MwVSv33Hp4LJG6Br+rjhkeZbeH8WROiaCbWklvCGpyNhv5IEWcEy2Ds/0LLus9gnVGLPUpnF/Da4gFWePuhOB1wPAQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Q6N0cqZh; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q6N0cqZh"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748ki81656454;
	Mon, 6 Jul 2026 22:58:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	8WleMr78ytefROJ5dbceOZvGac5ysIkWUnKCpH7JR8=; b=Q6N0cqZhnt2ctnWzs
	KLjzm2BJPuwmO4QqM0+Z7pJ1OD/O3uJAHDpyNx/BKwZZljxtZpUyT59P5zAlqr+L
	CYvReIdL03RSOoHanXWtZziWUaFDeZcZED8x0U3t2gRBCVe6fpQIAaGXj1ktm97H
	TnPJOTQVuWeh/zE5d4UFyxJbdGpA0ziZKROmegk+XZm2A3M6WP5DC28Suq+SoXYP
	24421BpqpxjmrGjbaub5Lck0ZFDmNBFqJWhKKEQoyOhZpqylQBgcNtLYPdyHTG42
	BjSG7XgA7XQVQiU2/1cx1dyUd0uPuCuuzWdllw0Rxk1iNwdM7FQKWT5A635wC7rd
	brQIA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:13 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6A9F43F7066;
	Mon,  6 Jul 2026 22:58:09 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 66/88] scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
Date: Tue, 7 Jul 2026 11:24:13 +0530
Message-ID: <20260707055435.2680300-67-njavali@marvell.com>
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
X-Proofpoint-GUID: kmJpIa-_Rf5y4efLcszzFEb3gubRRXKJ
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9575 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=BO8Li1uPneQ87O9LqqwA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: kmJpIa-_Rf5y4efLcszzFEb3gubRRXKJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5/wAfJ0lFJWP
 GFsnrJWx7EnPZHKI4UY3qEb+BGspjGq+V3EJXKk7nR73OwfBVAriOUzu6jJvR3qFEEWPvD51GTR
 sSdEw080d6tnmTuJngB2Po9Sm6G0TwM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6fhf42eV9dRS
 8s5svqH9Rc079fAa01bUj+5DRvRIVmV1JEOwwCRV6AWzAUmaxXV/wVJApRyFV8xTJWlRHciIDD3
 GKvnMFGLxn8edO9TgExCjPY74y2dD4lVcXScP6lBCjFku0apGe0Use0rl/YYTrHtBLINSeiRDtt
 BLLTe/QSxatQW87T8wu2ewdkgpwjv+DTbasKc8xxNvCNO3K0i2NqAnWKjov2HJMAuVLK4E57ghk
 rg8I+hVWfRIfpGiLUdC2j/SnPZSQ7/ehxi+AGJ4BIHQo9hXmuX4wQtmePVhPEGkDt5a3YK/nNN5
 /3LKc1Kl0Q26wnWVeActVp4Og/uG6u+YJ4qE5F1B28nyC9+okCUJxo5876gTvYG5VqcVlx6h5MF
 dyuAmMSoylxJUK/Ij9OihVbmG1y5Jpay6Wevr3AFvNlNNf0xFPeog7Pegf1vPJ0L6vFA1QVOGWh
 kMhgeWuMfKfHQZu3Ciw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

For QLAFX00 the request ring is ioremapped device I/O memory
(ha->iobase + req_que_off), not DMA-coherent RAM, which is why the rest
of the FX00 path accesses it through memcpy_toio() and the wrt_reg_*
helpers. __qla2x00_alloc_iocbs() however zeroed the producer slot with a
plain memset(). On architectures such as ARM64 a regular memset() may
emit unaligned or block-zeroing instructions (e.g. DC ZVA) that are
invalid on Device memory, leading to a synchronous external abort.

Use memset_io() to clear the slot for QLAFX00, matching the I/O
accessors used elsewhere on this ring. Other adapters keep the plain
memset() on their DMA-coherent rings. The zero-fill is retained for FX00
because its IOCB builders (e.g. qlafx00_fxdisc_iocb()) copy only part of
the entry and rely on the unused tail being pre-zeroed.

Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 22f2d81e2009..c81df5a96014 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2454,11 +2454,13 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	 */
 	req->cnt -= req_cnt;
 	pkt = qla_req_ring_slot(ha, req);
-	memset(pkt, 0, qla_req_entry_size(ha));
 	if (IS_QLAFX00(ha)) {
+		memset_io((void __iomem __force *)pkt, 0,
+			  qla_req_entry_size(ha));
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
 	} else {
+		memset(pkt, 0, qla_req_entry_size(ha));
 		pkt->entry_count = req_cnt;
 		pkt->handle = handle;
 	}
-- 
2.47.3

