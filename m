Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338AC1BC06B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085580; cv=none; b=KpDKEzzPIGj5ZbX0gJ92Mzn2ACjLAUV9EXaKecikzeGq0UsS/ax+PkMRuV3LKL6sRY91ZreO+X3lm0h9SUERj+27EQc5aKF2KcMraDWEv+ya64S1cIDR9Wgr7KLbB3WvuUWAxyWDvdrtbZnHIFhmuUzRgJCm/0Ze1+enDKv3qFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085580; c=relaxed/simple;
	bh=MtL+xMdWtX3zmGfgV5OZol7dT1a/qLsRdJ7ZFkY35OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/NNLu79HbH2lrE3CZgh+lZcblb0+aO6RdFO3Qn8r0OrIgmpnZwqBKAe0tYnmesV+4g/hdCAdEKgJSTzxOWVUrhoTRBJyUcOeq07bZcNFbO9asO9x5up9kgOixOuAE0sUx0SI5Bd308fMq2hns9l6fw90FnwsNgPxJHr1hdkGLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=k17NauQx; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="k17NauQx"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHjGDx027790
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=5n0At+8tCXW+reOy0jr/4TaG/eg7u6AwzViidtavUks=; b=
	k17NauQxxl8y7vD3mV5XJfokHvdYrDijzNQDIGGBsP9et9Xm3RgT8Vo4ieQf454D
	Qi0QTRkuF3vRT1uzVOZOwUzVTr8NYLH3oKyUa3Vxqk0WsZmIiSbV6lBidHieZ4nc
	V4kcIYAHG78+11NpAeKaxtQ12CAerlK8W/E9ArN2Z0nwjAgOXJadwaqXUHef7B92
	Lohpkfqy6fPye/o+xRhfhMDbHxg5TY8Q512+kdiQlol4BixAF7P+5Jtskhv/c1uU
	E3K6Wr92hfjxPZUTTylVZSoxC7ChnSSNwEQ22Ay+uEYPw2j7xnzT/S0FZj9zO7Q4
	gkUgWYjWVSZcXEC0JRYQow==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41k61wn0k0-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:58 -0700 (PDT)
Received: from twshared10900.35.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:57 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id DFB9712E5EDAA; Wed, 11 Sep 2024 13:12:41 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 03/10] blk-integrity: properly account for segments
Date: Wed, 11 Sep 2024 13:12:33 -0700
Message-ID: <20240911201240.3982856-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240911201240.3982856-1-kbusch@meta.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NW8XTHOQ_ci6QcnOqoY0MRKRZYwCukT6
X-Proofpoint-GUID: NW8XTHOQ_ci6QcnOqoY0MRKRZYwCukT6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Both types of merging when integrity data is used are miscounting the
segments:

Merging two requests wasn't accounting for the new segment count, so add
the "next" segment count to the first on a successful merge to ensure
this value is accurate.

Merging a bio into an existing request was double counting the bio's
segments, even if the merge failed later on. Move the segment accounting
to the end when the merge is successful.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c | 2 --
 block/blk-merge.c     | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 010decc892eaa..afd101555d3cb 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -153,8 +153,6 @@ bool blk_integrity_merge_bio(struct request_queue *q,=
 struct request *req,
 	    q->limits.max_integrity_segments)
 		return false;
=20
-	req->nr_integrity_segments +=3D nr_integrity_segs;
-
 	return true;
 }
=20
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 56769c4bcd799..ad763ec313b6a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -639,6 +639,9 @@ static inline int ll_new_hw_segment(struct request *r=
eq, struct bio *bio,
 	 * counters.
 	 */
 	req->nr_phys_segments +=3D nr_phys_segs;
+	if (bio_integrity(bio))
+		req->nr_integrity_segments +=3D blk_rq_count_integrity_sg(req->q,
+									bio);
 	return 1;
=20
 no_merge:
@@ -731,6 +734,7 @@ static int ll_merge_requests_fn(struct request_queue =
*q, struct request *req,
=20
 	/* Merge is OK... */
 	req->nr_phys_segments =3D total_phys_segments;
+	req->nr_integrity_segments +=3D next->nr_integrity_segments;
 	return 1;
 }
=20
--=20
2.43.5

