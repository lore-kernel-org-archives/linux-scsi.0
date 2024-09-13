Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABED139590
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252155; cv=none; b=G6uEYqSynGNQBJImJHBQ+/y01gKih58STKHBkWV1FPGCnabnh6R8rf3as4CAX/56wfKTfg3ml2cQVMiTyw7vQ/m1kHcrsoQ/jHPWknBv0rpTuHz1r8S9nZ9l7zDvDndQiDXla8x5b/7PVyed/fuk8Suqf9ZZ9B1jvgwBO1Apo+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252155; c=relaxed/simple;
	bh=DVVKnOrWjiRoSCgaBNa//smYB0J1VdkCfgXVLidzJbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVSBhojuAX6lp0xTwH1BJK0liW5+GyhxUyRh9JDgAi6spDjWqZnXoLuwCx/WBFi/DQpFqKq9VhoZNOqYKqM0i4Fz5E142hoD7B9EadDrrPaCk8YRtvaTz6GCros9C5xJEQ6ZXrOqXo8te7CpJECjX6iqFEB851tWYeSUVXNZcjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=bVysg4A6; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="bVysg4A6"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DI2DVZ032589
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=oUfSROr0FhSCtvL6UbszCRKrsV9riysj4gJgGG+83JA=; b=
	bVysg4A6Z0dHj0+PmhLV8Fv/24JJKgX75zpqBCm4rw1XGrIsmNbHbP899aGx3k/p
	FiR6gcC19dPSqqe2R1E9VSiuYFZrzcfmwKtfZQA4TFKt7oi9PXtq0/tik3rolCri
	boS/0Vnnj0XCkqcL1iFPM0zVPObyQxeTSy+W5yOhUEBJzRldGLGJkEEWpibMPSaC
	+tpN+Wy24Dd3bXtAuRu7mRrgRk0Dm0PsT+zQz8LpqDlSemrRatH3rei457+o0Ytf
	aFC3KgiMMG2IOMwyDIzIJsZ0wmINfxF04AOMrnoXMRtOLynAtkBbVqYB1MLWi2vf
	woLE+om6VClxVlKH2/aChg==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41mqb2sp7a-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:13 -0700 (PDT)
Received: from twshared13976.17.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:06 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 6F30E12F91049; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 4/9] blk-integrity: consider entire bio list for merging
Date: Fri, 13 Sep 2024 11:28:49 -0700
Message-ID: <20240913182854.2445457-5-kbusch@meta.com>
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
X-Proofpoint-GUID: Bgv5YagGNgGvI6h2V4ROH2gaRBZW71HY
X-Proofpoint-ORIG-GUID: Bgv5YagGNgGvI6h2V4ROH2gaRBZW71HY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

If a bio is merged to a request, the entire bio list is merged, so don't
temporarily detach it from its list when counting segments. In most
cases, bi_next will already be NULL, so detaching is usually a no-op.
But if the bio does have a list, the current code is miscounting the
segments for the resulting merge.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index afd101555d3cb..84065691aaed0 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -134,7 +134,6 @@ bool blk_integrity_merge_bio(struct request_queue *q,=
 struct request *req,
 			     struct bio *bio)
 {
 	int nr_integrity_segs;
-	struct bio *next =3D bio->bi_next;
=20
 	if (blk_integrity_rq(req) =3D=3D 0 && bio_integrity(bio) =3D=3D NULL)
 		return true;
@@ -145,10 +144,7 @@ bool blk_integrity_merge_bio(struct request_queue *q=
, struct request *req,
 	if (bio_integrity(req->bio)->bip_flags !=3D bio_integrity(bio)->bip_fla=
gs)
 		return false;
=20
-	bio->bi_next =3D NULL;
 	nr_integrity_segs =3D blk_rq_count_integrity_sg(q, bio);
-	bio->bi_next =3D next;
-
 	if (req->nr_integrity_segments + nr_integrity_segs >
 	    q->limits.max_integrity_segments)
 		return false;
--=20
2.43.5

