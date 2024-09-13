Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C47F13AA41
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252163; cv=none; b=EvlHjn/sjFbzPuBnrb6Z9T7OaopyX2PbzGimYnJCOw6ySNTcbUUAlzyAMQJIZjQogaExuBo1We5LoOUTCTt5ZpdMSXbHMEcx8bEbrDLXwTrG/mSzjQL2pZzkSweSc6tMlp72CMqp06CppyJ0ZdZZamSrJv+1SBzcyn2h8xiBKNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252163; c=relaxed/simple;
	bh=XIbXz65NGOF+8WjRY9AcaYfdofzplqXjYiKbIsxhYPI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvjHXKtMA88MkLYzkoZL3z44U4+rXyDHUVbCpNVbr7uHtBOLIo+yrSyc+kWjujNrlgd3Nt6u1JVocyJ+UjsDLHM/nKD1MHwMnmslG1A05M5KsGUIDUMpuGN/1RP7yBjmQxuYtb2HDALCZUamPd+eU/kGSDt5mePA5bVZeXcvWSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=l9BOmwG0; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="l9BOmwG0"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DI2Cuf032443
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=dDsEwI+ao/aPgw7GYpJ4ITMYtFyfxhpYZ0cKsKXdu2I=; b=
	l9BOmwG0WeCwavTRrsEDifIzDVYyiRmWIh5N1E1kuGr7Jn2A4OYBq7G9ctZXukqh
	hlR88tdODz6m3QdLgkl+Cvem0f1IXHdZRhk8xoP1ExikjXrNAh/XhMRf9BLHnNEB
	LurENNvH3OSx6L9mEm6yG8305I1Q12ifUN7btMSqrn2PY+qLmAb042CmRNgxow3Q
	dAPwvbY8V5wSfI48yyJcn4ChVKEP3E+BUv/gHke6O/OUmCr64tY6BjpVTfYkg/rL
	A4qaGRMDMuFb1d30v7LRxRD+ut7cW6dnedzsjNQL2NCOqeKUrXlXHXkvhaz5CGAf
	BVynHnzfFWdoOkRRQW/0xw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41mqb2sp95-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:21 -0700 (PDT)
Received: from twshared32638.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:10 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 60F6E12F91045; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 2/9] blk-mq: set the nr_integrity_segments from bio
Date: Fri, 13 Sep 2024 11:28:47 -0700
Message-ID: <20240913182854.2445457-3-kbusch@meta.com>
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
X-Proofpoint-GUID: CmL8LgEoD1UyQDnXUgNNV1vCr-4p4twG
X-Proofpoint-ORIG-GUID: CmL8LgEoD1UyQDnXUgNNV1vCr-4p4twG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

This value is used for merging considerations, so it needs to be
accurate.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ef3a2ed499563..82219f0e9a256 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2544,6 +2544,9 @@ static void blk_mq_bio_to_request(struct request *r=
q, struct bio *bio,
 	rq->__sector =3D bio->bi_iter.bi_sector;
 	rq->write_hint =3D bio->bi_write_hint;
 	blk_rq_bio_prep(rq, bio, nr_segs);
+	if (bio_integrity(bio))
+		rq->nr_integrity_segments =3D blk_rq_count_integrity_sg(rq->q,
+								      bio);
=20
 	/* This can't fail, since GFP_NOIO includes __GFP_DIRECT_RECLAIM. */
 	err =3D blk_crypto_rq_bio_prep(rq, bio, GFP_NOIO);
--=20
2.43.5

