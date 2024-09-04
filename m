Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07611DEFC1
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463619; cv=none; b=sBJtwFQ2UtP4vcWK+4taDSIN5+4vHdhS/hs+BH/HcQn/oWbrozxUNRlfTRuUMZ+xVS4qKcIUt9KbDS2YpAk26G9+yKdfykr0gaswNWot8oeQLnsK9OWXZ9brKOSneYJCP0RnacGdTmzLAnB5G67+RC7gaDfRISsU98lan7mJX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463619; c=relaxed/simple;
	bh=zjPO7a36oyeTYw4vRZcmsRpR1owOO/bCCBvRpagrY/c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXgZ2WtPdnPvPc7Y0kcQT7IDvCpJhKQhdWyJi3vg5j88qNR6EGpKxs4H9Z9hGOAkSHe0kFjTVdmXjug/3bhb0KcmRrxJ+M+KytXMDIAyYlOKKs9/AVVTZvU1ePORAIRyUBQD353eOldtCmTrRYoiwrdKQbANBmdSIoeRbU7ilYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LDHAoo1X; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LDHAoo1X"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4849UfQC022985
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=1UwveGw9W/6ottXJOf2+aM2Smjb0TJhMxeWYP59wn24=; b=
	LDHAoo1XSGB2sWIJSk9qzaebmYZIgrIiR1Vs+iYRRE62yw6zWWXvFonOJZ5zpy8j
	nqw2awN3EWkK8+25A4dhgDDvyiQAjhLM28CbcmIp4wl0Ulk83YvsU05H6E5nGgsR
	ze/PQuonu+jIalBJCSoq7W8bKUa6creFJ7NCbAN3ZUqgyxdODBj7WA/4FxJtr6A+
	krWG3spX8FhVtf2dgwGqqn9wkM9GEc5flZgHcWqQf3hf6e0bIZ4G0ziKvpSvArkp
	nSGJrAKBE3sYuAZOuB+5pS0ff3bcA+QxtQgegHcU6UG3wpSYUYWmKFgTHZ0KSBJu
	cfnbDgfxtkXVAJsSkwflOw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41emyp1wcm-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:57 -0700 (PDT)
Received: from twshared34253.17.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:13 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 02BA112A036F5; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 09/10] blk-integrity: consider entire bio list for merging
Date: Wed, 4 Sep 2024 08:26:04 -0700
Message-ID: <20240904152605.4055570-10-kbusch@meta.com>
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
X-Proofpoint-GUID: eJGVoR_VcC3u1QaGr562izE7hURPhBCM
X-Proofpoint-ORIG-GUID: eJGVoR_VcC3u1QaGr562izE7hURPhBCM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

If a bio is merged to a req, the entire bio list is merged, so don't
temporarily unchain it when counting segments for consideration.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index f9367f3a04208..985de64409cf5 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -92,7 +92,6 @@ bool blk_integrity_merge_bio(struct request_queue *q, s=
truct request *req,
 			     struct bio *bio)
 {
 	int nr_integrity_segs;
-	struct bio *next =3D bio->bi_next;
=20
 	if (blk_integrity_rq(req) =3D=3D 0 && bio_integrity(bio) =3D=3D NULL)
 		return true;
@@ -103,10 +102,7 @@ bool blk_integrity_merge_bio(struct request_queue *q=
, struct request *req,
 	if (bio_integrity(req->bio)->bip_flags !=3D bio_integrity(bio)->bip_fla=
gs)
 		return false;
=20
-	bio->bi_next =3D NULL;
 	nr_integrity_segs =3D blk_rq_count_integrity_segs(bio);
-	bio->bi_next =3D next;
-
 	if (req->nr_integrity_segments + nr_integrity_segs >
 	    q->limits.max_integrity_segments)
 		return false;
--=20
2.43.5

