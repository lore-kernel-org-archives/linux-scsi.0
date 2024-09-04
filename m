Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF1D1DEFC3
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463621; cv=none; b=n0AaqDzRDi9oiErriHC32vULMNjYrYgRCuLad7u6qTTCqt8gVvUheHM+olowT5KK4yIi7HJJEwfiE1gymW/QD3YuqPrPh6v3ZJe/bppG+6Lyqe9xTV8zxt9aDYC7CSiNzYncxqpaoGS02YSuTSQ6EvDCrrqoIhGlSPxXFZWk77g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463621; c=relaxed/simple;
	bh=5KQLAlCMR+XTitxHoZQD1lWU0ZzLC2eldZx59yE78U8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q19XcJHzNaRoWeUMfMc3TUYCtJOAgDiNz6BJ/FjZypAcxZm0WvcfuBzCEWVeuk/GA1ZufCzbvCxMxMJF7XSb+9KRlaDdvf5tmpy2ATHzo5jSwgzKF0pQW0ahK9fwXUpm22rT/1QX6gwt/tnsHhk+9N1L7yZ1onWhekp1SZdT7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nyL5oyEa; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nyL5oyEa"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4849UfQI022985
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=NJGuAIm2f/+xDgo4fPX/O74jcJilrmqmvJTBA0uhJGc=; b=
	nyL5oyEaGJWXzULQsfYGJ6uKN6VABTQnRYeh9CmKT0pqmLAP4tmD8ftHZj1FzyPv
	lLStP3qmimHauADdGo8UaU5K0EgMftNJ/tzK8KtGnngdNgoTCDb1jangu38tRBTU
	LpOdGHIVVXpQNZIfDQ9/N513Uxsbj3sH2H3VUN8d1UF40rXyXRg1LcW7Fx4X1/qN
	cAz2b1b+9zlOkfF3vMJebHWrex0uEb5kVHybCJUt1dQktESVlZUa7cFLAir8CpjA
	RMY7h8Ecvq4FSYr/iHXXbAjgAJx5ELK3rcsQ0jM1u3i6csMs31wN3NtZl36tehKB
	yNGh3JJEuzlbwYlr8seE2A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41emyp1wcm-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:59 -0700 (PDT)
Received: from twshared17102.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:17 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 0AD7412A036F7; Wed,  4 Sep 2024 08:26:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 10/10] blk-merge: properly account for integrity segments
Date: Wed, 4 Sep 2024 08:26:05 -0700
Message-ID: <20240904152605.4055570-11-kbusch@meta.com>
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
X-Proofpoint-GUID: SPXHixYXINp9A95dJ2B5j42QZHQv2PLQ
X-Proofpoint-ORIG-GUID: SPXHixYXINp9A95dJ2B5j42QZHQv2PLQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Merging two requests wasn't accounting for the new segment count, so add
the "next" segement count to the first on a successful merge.

Merging a bio into an existing request was double counting the bio's
segments, even if the merge failed later on. Move the segment accounting
to the end when the merge is successful.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c | 2 --
 block/blk-merge.c     | 7 +++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 985de64409cf5..4222c78eab18f 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -107,8 +107,6 @@ bool blk_integrity_merge_bio(struct request_queue *q,=
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
index 43ab1ce09de65..734e6e22a6d22 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -639,6 +639,10 @@ static inline int ll_new_hw_segment(struct request *=
req, struct bio *bio,
 	 * counters.
 	 */
 	req->nr_phys_segments +=3D nr_phys_segs;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	if (bio->bi_opf & REQ_INTEGRITY)
+		req->nr_integrity_segments +=3D blk_rq_count_integrity_segs(bio);
+#endif
 	return 1;
=20
 no_merge:
@@ -725,6 +729,9 @@ static int ll_merge_requests_fn(struct request_queue =
*q, struct request *req,
=20
 	/* Merge is OK... */
 	req->nr_phys_segments =3D total_phys_segments;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	req->nr_integrity_segments +=3D next->nr_integrity_segments;
+#endif
 	return 1;
 }
=20
--=20
2.43.5

