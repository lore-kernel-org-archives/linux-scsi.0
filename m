Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D70013774B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252162; cv=none; b=ugQEybI75SmLwwmaxy54JqheNsncqwZdUkNHxB+bnXTvQAB7srmmNFouZ7UC8lp5AeTJGL39kmmIvNFJfh7TfnhGEqTYSK+vgpfpwtpbXMvBYMYOaAl4dqzQc0iw2JpWd6935UtbAVIiEdDqjHMWFe+t50G2Do3dBApeyDYm+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252162; c=relaxed/simple;
	bh=X81DJqYcgEwRYW6k80qOnRuSdeOnPN+S7H+naGQt1Bc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tIq49c8yz1foh1CwK9RWUhyUjJz5v6/Uxt3oe1RluGoEdF+0EMSyMlFpJJDKNwgnlwSEAnBcqgW2LlT64a+v+1eOx2LuXvxnvHC38/dJ8MwPGdAQVv5vX9z+9sEDKzim1yFAnWyZW7elVo91SX+LSbMQBjB3xecsr/kM9cWow/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=TjYEE7q+; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="TjYEE7q+"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DI2Cud032443
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=EK7qRVh7IubhEF75usjllDVX8wTrwNSbwEX2ZPVAxZ4=; b=
	TjYEE7q+wgX0XEKkcNJRs2RGesVbDegYUp+HLCdvhP7zrqHfohg3ek3iTeoo+meG
	BBVc4rVWbwZy0hXGn5+DVQMO7hYf+vAvmbM5kFupk7hFbth4FP800IBqxZeiooGN
	6qAhyDt1zKE1G53ikDLp23fUuw9jreMlAznSwFwxT7fKBUG0Rv7FkK69ERmN/kGI
	8bgUQMbI2FxmbCcQYZpZb1LO80kHTzakPAyHodDud3CxCp8Yskwq5OASjWgcJGCL
	FghDqLZNkxvsMQU9g2MBdOSvaAPGYoleevYzCcb5r+ZVOyZHOpxrEdN4a8R29JhX
	cJAtHF8JxJcwvGUMP7aFWw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41mqb2sp95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:20 -0700 (PDT)
Received: from twshared32638.07.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:10 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 691FB12F91047; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 3/9] blk-integrity: properly account for segments
Date: Fri, 13 Sep 2024 11:28:48 -0700
Message-ID: <20240913182854.2445457-4-kbusch@meta.com>
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
X-Proofpoint-GUID: yKBvhoGjNeHW7VPU1Bkximtv5ztSXFRS
X-Proofpoint-ORIG-GUID: yKBvhoGjNeHW7VPU1Bkximtv5ztSXFRS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

