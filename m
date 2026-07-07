Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FD4386564
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403772; cv=none; b=ZGSoSTR5syj/2no6nv72wgyJaUaqvqlV5R10/3+lcmePjVo3rILOdXHbqECgWXzRDcFEZgcX8sO8W/rM8UhZ74tiR2jUsHxIf5RDuIEy9CvnJ+CJNAhBn1Wj7qgcXxEb7kebAAktumeHEA3io6FyzcJG6b1Jl4O32fmRg/80UUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403772; c=relaxed/simple;
	bh=Xz96bwm3VGDBDK8laEEOLiqIbMDR3AIvOqB9wStWsGw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F5aJDTXgcc61Iq5zsPAcviBii2Hk29vMSwrG6Y8kEXqHb2GBKE8GVTzj1i3LaNbrdk4LYm+uRQju/2+UlNR+uscf2Z/YE81MAluJjC7vswLtbmbQWr7TiCeKOQ29HZtsxLdsolSjn4LxCVqlc1fjQopKs0xtCUZnOiw8tYkktZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Kn9nvEP/; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Kn9nvEP/"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cwc1656123;
	Mon, 6 Jul 2026 22:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	CmTSDHzGOQ2ym1keOSd7QVK5aJFAlGP3wIci7cPrYE=; b=Kn9nvEP/PtHT6XE3c
	8qxleMxqfzmda6cUQjROTrj/HZTDBAkQcPJgLpkI6xr5hUcsrCtEqUl0RIM3x9qg
	0PegOem67lLeRrpMHMkDG9zR/XFFWU3OQuXxhyfF/aDzBVrB8PmUfjftpS7q/roH
	uz4naXnH/6b+KqK1Ts2gCGV/xg62gSXFJLvM4LcdInasAXlCb8spfkr/g4f7sAcZ
	EgDh7pV7OolrfBVdVbBSSJt8xpaKGfsG7KTUfL33LH4aruJOxra5wG8af/z1LYGx
	xeJ94bnJOHP0gH997DgdqbIou1D3BW8/1btL0lxGWNwoE91UCLgGUhLc325EReva
	VXhaw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:08 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 341DC3F7066;
	Mon,  6 Jul 2026 22:56:04 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 23/88] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Tue, 7 Jul 2026 11:23:30 +0530
Message-ID: <20260707055435.2680300-24-njavali@marvell.com>
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
X-Proofpoint-GUID: HK74pDSHlOZn5qtJyXaI5ojQ7b52XAiP
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94f8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=dJfbaqo3ldCnDXLoxNMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: HK74pDSHlOZn5qtJyXaI5ojQ7b52XAiP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzdi7CCDDFN/m
 FJqy1+0Rj397HwZusXD96AIZ1oniIa3IYNqSLFRqYf/NFSsxXSwrnCjuiak4oo6PHoNIF7VWO3d
 /ZZBNOt4osBO0n0bEemiirnUOJ1YlYs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1TgbUlUhuLDX
 5A6Zy6FUqcslLOUrRlzhjfHM9A8l29ETexYrjSBTJkIr+IpM6Gm1s4/Ogl73lGtVYklhVXTvy/3
 ymQlNDrT/XV6LN/ma3Lmxq3LDyz4Z2ydIaDnPafGwomC/3LXDL3puxkKeaaTqkFodnpfAtoAhos
 yWmu+AdM5HEjdk6yBVzdrrC14r8UixEBzNeuT32FRNIysn3ZEzzwSWL7pt/amtxK6Zrb6s90+3p
 DbfJmlvuC22XjRL23ER+lNKyo0wP8WrF7iD/SOX7OAPpT/L3TS2FEAoXZw0opY/RSI5x4Bincpb
 9t/VzdnUutLuqjB1zO3Kax6t6TX0apGRrrQGJMCZ15n9gihKGr1b710Q7DhjZD+zndD2jNL6SwP
 Yd4ovWgL/20/VidpoCF8c/hxP5UUk8s/3GPEykp2UtnZP1wXuPcJL6CzNIQ0QI057PFV0gtoHaz
 SN0UGH7RoVf9BnVygtA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
index 13882a399fbc..c0cec1f74dfc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2390,10 +2390,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2454,13 +2453,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
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

