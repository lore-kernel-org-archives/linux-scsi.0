Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42F33998
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302223; cv=none; b=BdCF5jLyIH/bO6fGFpnfhPJ7M5XKNw8L4egPD+QFDMoRa69VbkDUsu7QF77sbRQVc0aVOED3ILxXftf9yZum9EcddjcHSItgyzjlqjcIA+PdWOMFxt2kb96ZSKFMxz8lnC2Gi/1PHat9a5g/8JFO6f0hy+AtsiLBexmvEIeuqlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302223; c=relaxed/simple;
	bh=fggyqekK6CCV/EjxjJroPymYskHENqoCOEQbZDakQDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPOflxz63nj1eo9K/DTx4arZAH+nBlpSXzNzY7i2bV9apoQqc4iaryWA8Ly4U1kqLrTJ5N9PNTDy8vdsPi2JHs0o9/7pLHXiUbKs9veAOaX7Ojh7eJ3CIp8esrlIJJJPykRY195Ahe5WjB0eFaZ4gNI8kJyYtRVjrrPP77hVIoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QZH4oYGR; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QZH4oYGR"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7twn094741;
	Fri, 17 Jul 2026 08:30:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	1W9+ow+ADJnHQgXSLTLSZgXC/zfz3i3+xF6dYeNQLM=; b=QZH4oYGRyH5SokbPQ
	O3K3ix3cj5MRwqVFvf0fBvXhpFfHUC3TraIFd6GIruVODqJe1IvPCVIkWXD8Kczw
	12kgadOyidZG/6lFmJ9hc4qCBBFsdKD/w6qSKpHWm23HGxSx4X6/8ws+/3p46yww
	F3i9NPK2rPIZtGJkR3tk/8Q4sSN4fkj2uHwA6MhrqzYI+hR+NQ42uC7Lpx5juyhz
	nLzfzGKl5Wa7TropQxgtE4ffxYGNOk4KStMgLucvHGwTxdRZLF9WKnHb76OKOnP6
	5QsU95v6zDKbh/m409mORCl/Kbn8f2UE/IDrJNmGgt9kV40nCp/U7yKNlTFwuOhz
	3nrHA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0F4255B693E;
	Fri, 17 Jul 2026 08:30:13 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 23/56] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Fri, 17 Jul 2026 20:58:31 +0530
Message-ID: <20260717152904.3155730-24-njavali@marvell.com>
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
X-Proofpoint-GUID: mJ3ulz7aD7zr7B_sPRD96CBuxJR-rTDq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXxV1OJbVonit6
 foDu6wLLT387r7pSSEzsyUoY9vaOyaFngPzky2sLv+tLP+VPFFnEgByq3l7TNplqkrrXYhq8uDp
 MGPHtr0ifvX8PclFOGBVUoCPpTBWtcQ=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a89 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=x7bcZWNirRMrbHSgiDIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX65n83D76W2MZ
 KMvO/SBRmQqfn2WIJ5gWz9cPlQqF5uS+n6/Z6DhG0rUb1oHjV0eXNU5yRHLKElxnPQnQffY6MJf
 RHbSXRsIvvl5XdRfru/nSklM4TQ6IOJi6H3+7wu8CZAGHAhOnPq/qH+Tsapu9roOP/RkU/antlZ
 s+TpBUXu8LKjUnoTmfW3W4GKfOpIfyySQTab4cxRjlLd5tuRF/AQqFhZygKI1S3SMOj+LXnx/Qm
 4QpPcaLVgkO+G1EFCKKEFvJs1Zsc9zavVO1NTnWMfjAy7EL8iXCJJ63kfiUJG2aNpPgpawfbeRM
 /mAev4sjiiXfFnoLZEma7XtAA4Xx6kz7kdSRuNE0OJBs0g/kv9fGJ6wVW63Y6IOT8lEA1+TCo90
 VQ9f7F+rbXQXlciu0KQ2lpE7slnMldTVMqcLzOZ5Muxswr/TpUDfwmxV/DAG63pwGXBF1bg0qPS
 KT7B8CoMpXZhnWOYsFw==
X-Proofpoint-ORIG-GUID: mJ3ulz7aD7zr7B_sPRD96CBuxJR-rTDq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index aab7905c0d6c..1ca50fc200d6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2466,10 +2466,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2530,13 +2529,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
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

