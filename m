Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED51BBBC7
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085575; cv=none; b=O3rvQc494UWtKjtW3wMXUnDhikkSvza4BCX/JWcRxS6XFueHJE+lizi7UqoFPqyzbnNXrZ7bVhqJCgVA1/5+SiYVgk8al8t9xa1IrZ43MG7CzjwKax9p/HBtJTtI4j+E/U8aSnuE3sQWzUb8cdt8ciF+4p4AmYNwAzI4pMUCueA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085575; c=relaxed/simple;
	bh=ojgUxIzyLa6j2aHms0PJDxM1OGnIF7WDibMNmTNwnTE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PzkKyUQz4BXsLTJhIim8i7T0sEaEKKP1ZwPtitRbuil/O2NwKruXfHZgFYuraopRtJD3QgPnedPMRnQhE9hrLoua3Dx4j1BourdhNx5vbBoPNOrLOG8BixSamfzP0ETSFkB6XI9Hj5gOSnOLjM6lKgKGH4+0Y5CWnoYyT0VH+pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kagZ2l1M; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kagZ2l1M"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 48BHjWc6004157
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=MMy4GT/2WxENY3dYTa/eDihiGlxScK9w4eG6NktGWso=; b=
	kagZ2l1MdOU9Sv+j1uT1Ge9kCNygIQUqqV/OCWrnxlPLSDlFNL1k3mN+NCsvba7b
	6ZMga5xh/pgywTZ/H/42SgSOThEpZtaQyIG+08zwe34wNPp9DoSehyOMmORGyJ1p
	4MF9QD/lmudAZXuyNeutIXiKJmS30rYe+NuKLNHllyK18Gp4vGd9bVMDBlLX5Sx9
	RgpNWyC98VPJe2Rxj6l6rRBAVuPWdSXMlf6aqfrxXiVSeN+1x/IsGCB7L4zamqxn
	zqacx6C4iDo55nBb4ufQWzkuQMDxhmw+GoTTXq4gjl7FaMjSLiWbivr4OOB7ZHuh
	fbjwyPeKIrz0GMQUXQnKzA==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 41k44nnb2x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:52 -0700 (PDT)
Received: from twshared57535.03.ash8.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id CD5BB12E5EDA7; Wed, 11 Sep 2024 13:12:41 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 02/10] blk-mq: set the nr_integrity_segments from bio
Date: Wed, 11 Sep 2024 13:12:32 -0700
Message-ID: <20240911201240.3982856-3-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: Hn-HB9Y5juVDDXd7gLlZmgoJ2zfEGVpk
X-Proofpoint-GUID: Hn-HB9Y5juVDDXd7gLlZmgoJ2zfEGVpk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

This value is used for merging considerations, so it needs to be
accurate.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
v3->v4:

  Removed the "#if defined" condition.

  Replaced the 'bi_opf & REQ_INTEGRITY' check with bio_integrity(). If
  CONFIG_BLK_DEV_INTEGRITY is not set, the stub function will return
  NULL inline, so the compiler will optimize the setting without
  adding runtime overhead.

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

