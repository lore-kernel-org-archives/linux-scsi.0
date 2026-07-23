Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CCD2D24B7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783140; cv=none; b=LXokh8RI1V68a4ty/58qq0rjiMMiD3B3aYs2PMEkt2snrSOPHpKG+hPoGdpNavKtom3GO/PXrHDiKNMi1J4G+Mxt0cywiTREogNCAYa/kncti7PkyzdAbCwEWujWfkNGzlw+UbQm3B4osbLRPMUcifFN1nV+5Q1jegYe4ND5nvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783140; c=relaxed/simple;
	bh=fggyqekK6CCV/EjxjJroPymYskHENqoCOEQbZDakQDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upw2YqFxDm4NpW1hFxQfFXWfxsd6bawqy2HAMAFMZFryfnV5NkIOztlzK1wAI2v825wid5E3EZoVWNAjAvVCprHnnyuoQvT880+MEUpcp3Kb2oXIPYt6eyLjQrFAsM+u+Ds9X4tyiqTXUWiq+J7j/If1+4QRkpuU+c+2qLn/JnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=S3Si21oT; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="S3Si21oT"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w2Gm486304;
	Wed, 22 Jul 2026 22:05:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	1W9+ow+ADJnHQgXSLTLSZgXC/zfz3i3+xF6dYeNQLM=; b=S3Si21oTpDqdBJ6I+
	bdO4vjCA8CN/v0JSdXsA4Vvebr+XtU6TrRSFy2nlGfkkFCtA5jUnOmPXrSZaRHLf
	UjTnreHzcKQQruGnfxX+6aIEJxRjNmxhYn9s4t6w+8AnSjgo923IRWxYe75VcvzP
	BxKUOpmof0OZCGsr0ObXR54oFcTLpOEpzVRKtCAqNk5IOKcJNQATrZGcx9JSAwI1
	oC/td/UwqFlFdk6Yc26/nRV1Bw7uwoXbqs3uwKkC+yHl4bKkYlISkggp39ko3F87
	QeLzTQwvVA+IxdMQCu9vz8VUPblGQVH7t3uZIDb6uyKAFQTNJjElpPBfAv58bUyb
	OYSRg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fjn9jurkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:35 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C85055C68E6;
	Wed, 22 Jul 2026 22:05:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 23/56] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Thu, 23 Jul 2026 10:33:40 +0530
Message-ID: <20260723050413.3897522-24-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=Je6Ma0KV c=1 sm=1 tr=0 ts=6a61a11f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=x7bcZWNirRMrbHSgiDIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXyqR8IRGsSYNE
 qwSIV6wkXXriyApM3kcFHMcYG40jeGIDrt3kB1uk9MYhjbh8+vpWwq/hwYLGJjKptYrTcxO1Lnc
 pzfTcDGdEFfw2oqhLSxhtdgzTI/xZI0=
X-Proofpoint-ORIG-GUID: O97pwzSaNecg-ad_pJ9lWAQ5u_cvbUUj
X-Proofpoint-GUID: O97pwzSaNecg-ad_pJ9lWAQ5u_cvbUUj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX3Gg1uzMkWdYl
 SueD08yS6mRcP0Ws0ajipmnEl8h56t1SkJrteEPnUwd3VUlMLJN4IJhGfJr3s8DEkuvdiaXOZL4
 3wor+65l2qUBjQd5KSBtCYPzLWInIiC2MwncZ99+8xjeCNNFW3baaVZdA3j46wpn/VXdx7SULGx
 A2sMUkOEDHNE3bYdnqbjDUBupgrTepKhhuLRHjQa08N3RpyL7pXDHFxaBBOy49vyL+6I2dWcyCW
 H+ElDVhzD4sQriV/oGA3efaJr1/ATdaJv+bSlPueAKNVq72DRaJeUtdtwL6ay4ZoA0jUJzbg4Uv
 e8gER8th66z7nnVHSAYd3JmE+LxRnxhEVDn2uGXhLcEXf64voZ5eKDZmAThooTUPsLBnBvHOXaj
 oAtoX0GpW+3glYIr4RyUKMi1y1zUox1rTDPpdYLWxbY6YOO4H0jpAIh7yiqgeEXNtZc8XejhW/U
 tZMKTpb90vsbB9wvQVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

