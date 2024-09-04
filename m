Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A7A1EC017
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463607; cv=none; b=lieOtjs6mDCJXxtTgsOwpT9EqcHozlQL7YL64OPGUEdDdtXC2w8NcjEbkiiRWjdmhbjQPvN5Ptkv8I4VGOwQGglh9OXv+UuPoKxnr4hlq3mGbbbLYb1qkNn+dDId82Z5NAQ6h4GsHUlvnccr0AJPxCKeLOY2YBG4Z6GZ0e4WF/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463607; c=relaxed/simple;
	bh=wgCiCeySyO0FcFxrr+YSd3x8cxBMpFU7my8lcR2bZro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgcs0zfHq9YoYFjKfkaaf0xxm+OoNOviCphdoYyPkHUV0bocY51tJAV06+/oUEE4lG4tgdzGj5FoVGEBUdZjKTJek6T3x26nGyDT27iQ4nbWwp77EXj/OEsPwZ/CRJgQ2/uhoN/UTgknRtU4PIONsW7n/XOi30Vo3x2xp6whYcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=NZ46nCG8; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NZ46nCG8"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4849U2Np022336
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=egTi6ZnQ87q4SMqOIPKOssZGP60h07A6RuSO4eqy0Ec=; b=
	NZ46nCG8ND7KWwYTthaKR3mFkW2WvO4AGdAU8J4YDryDRHRbmqJq+xsAAdCtIsrO
	1hNhT/RqHv7eY9a+Fm61GZu3hxF5wE00/FJT6uK5LTaAnXUIs8nIrB7y6uUMQZ4s
	ZuTBC9To3V+F2qrGbaRwgnT+L26aKcQHZoFWCwIR2Uk7oiWBeGimsAK1ErlpQG3e
	ssaC2YGlGKyKm28nh9WDyBYj0HjNoCuvEhhKxna5+E4SraaOosoQ+JQJzz0x/jKz
	sZoyTD2Cm0VDUcs3V9xINzRKXXOhCn0O1rBA9/8Tt0Ehchaaoy8txzHqKVebXl2V
	ThhXLRqGt8LF/jT8w5XaEQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41emyp1w8k-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:45 -0700 (PDT)
Received: from twshared34253.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:12 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id BFEAA12A036E9; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 04/10] nvme-rdma: use request helper to get integrity segments
Date: Wed, 4 Sep 2024 08:25:59 -0700
Message-ID: <20240904152605.4055570-5-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240904152605.4055570-1-kbusch@meta.com>
References: <20240904152605.4055570-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: TNZQOTI84PsmZySwthhqNq3Wd9bRzBiE
X-Proofpoint-ORIG-GUID: TNZQOTI84PsmZySwthhqNq3Wd9bRzBiE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to
recount the segements again.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 2eb33842f9711..dc0987d42c6b2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1496,7 +1496,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *=
ibdev, struct request *rq,
 		req->metadata_sgl->sg_table.sgl =3D
 			(struct scatterlist *)(req->metadata_sgl + 1);
 		ret =3D sg_alloc_table_chained(&req->metadata_sgl->sg_table,
-				blk_rq_count_integrity_sg(rq->q, rq->bio),
+				blk_rq_integrity_segments(rq),
 				req->metadata_sgl->sg_table.sgl,
 				NVME_INLINE_METADATA_SG_CNT);
 		if (unlikely(ret)) {
--=20
2.43.5

