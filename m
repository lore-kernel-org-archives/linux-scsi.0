Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9E212C54B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252152; cv=none; b=a4rAVHF2+y0RM+TB3y968FhhaQpBWmbfP6Uld7FQmcqj9LpBSigZePi15areJKm/6AT+zleQvXUVYxDJkZeXKWmePQwHPPSg5XH2eWoehtgJ80AlgPvoWLS5ydZyC/i3SBMLVsrdxHZv31nJCNzQGp1lK6FyBPzIkSSPNCMrKe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252152; c=relaxed/simple;
	bh=eyPe9KJBGop6ccg4/RvQbOot9mGALbwbD2rK7OeE/9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6X06rNcOupY6ZSWzuvqPuupzLDHUFOw0gk5uWpz9x7DBclCPMGkFwJPsrlY0G1kk0/l3DQ09rPP+Yp8d+Y9esX6gxU0w1YtvkIY+rAeu2W2ce3Uj+qXOl73E7YHgwwxCy06SK1EytMCqEY7kK/X4OwNi8fjE+NieECUqzXJI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LKbwMfgG; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LKbwMfgG"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DIANFH018518
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=RWIdamZUV/daqLi0XaMr2NW2huZHn5RwNbZdv3Y9OBM=; b=
	LKbwMfgGhLRc6oJ2BAVl3N4UNTH0SbpitrSMMSwvxps3IanpH0HsvJwBegSkQLZo
	xtQ566wFijhLEAk03KoDXz1BBbHloLyTwHrO1FKFtf/6/L1HoQsF84eAzqeRnzyC
	LSFrPAKEdTC3Tkp6YWM5u1SkqT0tzhWK9Mp7vbheeubxhXn9/wjTBjFXMTfFlXUB
	RKR3VlKPCgf82TDnjBI/0mpBWSVax4EEin672AE/pkRlcCs9/CMMiY65qBaSjDS1
	MLEVQoNEUOx6IJ33S4q5lfutcHt/DAH5miwUtpufY+0Zs6kvOSX71cM+N1FJCH+U
	+19TRb7p1U7wFGscel6TFA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41mte705nd-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:10 -0700 (PDT)
Received: from twshared18321.17.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:07 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8DC0712F9104F; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCHv5 7/9] nvme-rdma: use request to get integrity segments
Date: Fri, 13 Sep 2024 11:28:52 -0700
Message-ID: <20240913182854.2445457-8-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240913182854.2445457-1-kbusch@meta.com>
References: <20240913182854.2445457-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Fb9GmU7zeUzlUK3-tzPA9AGsrVniYtUo
X-Proofpoint-GUID: Fb9GmU7zeUzlUK3-tzPA9AGsrVniYtUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The request tracks the integrity segments already, so no need to recount
the segments again.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 15b5e06039a5f..256466bdaee7c 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1496,7 +1496,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *=
ibdev, struct request *rq,
 		req->metadata_sgl->sg_table.sgl =3D
 			(struct scatterlist *)(req->metadata_sgl + 1);
 		ret =3D sg_alloc_table_chained(&req->metadata_sgl->sg_table,
-				blk_rq_count_integrity_sg(rq->q, rq->bio),
+				rq->nr_integrity_segments,
 				req->metadata_sgl->sg_table.sgl,
 				NVME_INLINE_METADATA_SG_CNT);
 		if (unlikely(ret)) {
--=20
2.43.5

