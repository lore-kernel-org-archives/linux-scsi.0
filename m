Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A552D1DA615
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463587; cv=none; b=k2gboSlgj10Y0fv+5x4ERx7XJBWRy2G2DKhjWcHmPk7PtDmk/RS1oTOmmR762qKJ2MkMciCKbcURPbNEwy0KdlaAs62XN2/6UPQ3CM+7N2uGKn5YIWVAABSXcfa4adsgJq+bGJi1bY5xJosktHW15Emdy2zBOq9DlcnTsxddnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463587; c=relaxed/simple;
	bh=9vS7WtpRyiE+BLkhEWwb5KsvA1A51Cz9iROIwAJDUsY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o67zub4AlBsxvKKbu8apTc1k3pc3pFovyVVamarhF3oS64kyaRldxrE77FJ+IeRAXPE//iyGekL/5yg/+tl+99tK2TID1w6+K7RSFNjYk6rGGuGLa6zvgP73BYrfXn8T31jbAkEQHSgFemZrOTmRa1/IDPr2QHWgJYVEoQGtEIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Hi8kP2nY; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Hi8kP2nY"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4845F7Wj022818
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=rd7a/k5fb4q3A2ywz24VKgaB3Pwg9YzXlvjTsg1C6HY=; b=
	Hi8kP2nYf0wRpYjozES0Sosfu/EGIo6kVR9uDPeUa5Xt+sWTKXii+m1+4myIO4TM
	OZQDic7hNdeGNzd3dFBEsaCMq2hOmN4RG9bQtWju7JTHWhe1REUMMbtgP859sCam
	WxjlCernoQTGslwKD2RwQqHkjlqS6zdT3oNhwQSf4VzYIEHafhmR7GoAzU2GRNQ5
	T5NAUygpwUs82YEhJVOZfeQjRJI2Ap8cO+CBe55ZX04Gcd0KBAZiQnf5Or8ATkJp
	eMYvriATFnxqP41EWtvYbyv2VlxdY6ymsOArUVSoqBbCxOe1A5OWiR6yCfNUiyJN
	cOHoyyDnxm3Sdk4XqryLsA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41eh7v2vxw-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:24 -0700 (PDT)
Received: from twshared34253.17.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:12 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id A784612A036E3; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 01/10] blk-mq: set the nr_integrity_segments from bio
Date: Wed, 4 Sep 2024 08:25:56 -0700
Message-ID: <20240904152605.4055570-2-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: Eclz2GJnv_iy37q45D9j3nrvf_BjnN24
X-Proofpoint-GUID: Eclz2GJnv_iy37q45D9j3nrvf_BjnN24
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

This value is used for potential merging later.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 36abbaefe3874..3ed5181c75610 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2546,6 +2546,10 @@ static void blk_mq_bio_to_request(struct request *=
rq, struct bio *bio,
 	rq->__sector =3D bio->bi_iter.bi_sector;
 	rq->write_hint =3D bio->bi_write_hint;
 	blk_rq_bio_prep(rq, bio, nr_segs);
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	if (bio->bi_opf & REQ_INTEGRITY)
+		rq->nr_integrity_segments =3D blk_rq_count_integrity_sg(rq->q, bio);
+#endif
=20
 	/* This can't fail, since GFP_NOIO includes __GFP_DIRECT_RECLAIM. */
 	err =3D blk_crypto_rq_bio_prep(rq, bio, GFP_NOIO);
--=20
2.43.5

