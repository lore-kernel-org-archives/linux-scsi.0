Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C61DEFEA
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463611; cv=none; b=mSkQGwaQU84tQgS/201pinOuoIkWiqIGX7s0jRB6ibqbDiaWR9hEzcRxhcHsyFtbhMebs66hPzHarZDlmN293g5iFx+bcwvFmqcWaVypQh26YaXWp1lsgfyA3mt4Aw+etgSWad5joyAUthRMne6bpg47+RI5EX/RT/OUZXtnJnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463611; c=relaxed/simple;
	bh=3IVzbpR/rJR6wU1RUBfwFsTfYvzBRNjtgQJN0hgzS+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lz/xyZDkuSL+Gge1R/qHKQcfiUtzQrVV4waBgMFo5Q69UZu9XBbuRmK5wswu0T5R072ifdUJz/6pANz0cVyO05d5zQZslFxtdVPEZ+LWX3lp62nDME4ebvbVIa2BmShracPDAMOgZ1wA0LnHKvBbfZ/O6p7wnrju2r9evJGu7lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=e9HKErPF; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="e9HKErPF"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4849U2O1022336
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2024 08:26:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	s2048-2021-q4; bh=mx/X2bX0pns4vleyJjY1s7PAjZcF77tvDOIJw1tvmqU=; b=
	e9HKErPFSEqRS6SYxYEtI9ugoHRs6t3oU4pALUyW1xJlmj2BHRKFcBP4qm5fXSY3
	/737uAIkHJe+jJ5o6SCUfX/EPUP8ijUUSWv81aP0f1NS+XaioTE7nzqDgkY7jLIl
	Pee8NK65RncXXy2zrxyREMIniI9jnoLrIWOc3jfpOFeiAcm6V/xg5gX1qJan1QiX
	G0Ekw7fA3yJgvGciJWta+RMmBzvwEmRDwHwfDV6igqFxTK8m0V/3HzeimXxKuWZM
	Vmsbe2GL1TymKRc0JSnfSuNRyGNZ9irYYLAmLSqMHJi3kJocZkWbqhPULHMZc3Bq
	NHbwF5ttjON97JYNPjfS6A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41emyp1w8k-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2024 08:26:48 -0700 (PDT)
Received: from twshared17102.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 4 Sep 2024 15:26:17 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id E07A612A036EF; Wed,  4 Sep 2024 08:26:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 07/10] blk-integrity: simplify mapping sg
Date: Wed, 4 Sep 2024 08:26:02 -0700
Message-ID: <20240904152605.4055570-8-kbusch@meta.com>
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
X-Proofpoint-GUID: ZI4CParDnUGKiQ_5gSRU1pmMCjhLq4Ha
X-Proofpoint-ORIG-GUID: ZI4CParDnUGKiQ_5gSRU1pmMCjhLq4Ha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_13,2024-09-04_01,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

The segments are already packed to the queue limits when adding them to
the bio, so each vector is already its own segment. No need to attempt
compacting them even more.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-integrity.c         | 35 +++++++++--------------------------
 drivers/nvme/host/rdma.c      |  4 ++--
 drivers/scsi/scsi_lib.c       |  3 +--
 include/linux/blk-integrity.h |  6 ++----
 4 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index c180141b7871c..cfb394eff35c8 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -35,7 +35,6 @@ int blk_rq_count_integrity_segs(struct bio *bio)
=20
 /**
  * blk_rq_map_integrity_sg - Map integrity metadata into a scatterlist
- * @q:		request queue
  * @bio:	bio with integrity metadata attached
  * @sglist:	target scatterlist
  *
@@ -43,39 +42,23 @@ int blk_rq_count_integrity_segs(struct bio *bio)
  * scatterlist.  The scatterlist must be big enough to hold all
  * elements.  I.e. sized using blk_rq_count_integrity_segs().
  */
-int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
-			    struct scatterlist *sglist)
+int blk_rq_map_integrity_sg(struct bio *bio, struct scatterlist *sglist)
 {
-	struct bio_vec iv, ivprv =3D { NULL };
 	struct scatterlist *sg =3D NULL;
 	unsigned int segments =3D 0;
 	struct bvec_iter iter;
-	int prev =3D 0;
+	struct bio_vec iv;
=20
 	bio_for_each_integrity_vec(iv, bio, iter) {
-
-		if (prev) {
-			if (!biovec_phys_mergeable(q, &ivprv, &iv))
-				goto new_segment;
-			if (sg->length + iv.bv_len > queue_max_segment_size(q))
-				goto new_segment;
-
-			sg->length +=3D iv.bv_len;
-		} else {
-new_segment:
-			if (!sg)
-				sg =3D sglist;
-			else {
-				sg_unmark_end(sg);
-				sg =3D sg_next(sg);
-			}
-
-			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
-			segments++;
+		if (!sg)
+			sg =3D sglist;
+		else {
+			sg_unmark_end(sg);
+			sg =3D sg_next(sg);
 		}
=20
-		prev =3D 1;
-		ivprv =3D iv;
+		sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
+		segments++;
 	}
=20
 	if (sg)
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index dc0987d42c6b2..fab205bb4f3ed 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1504,8 +1504,8 @@ static int nvme_rdma_dma_map_req(struct ib_device *=
ibdev, struct request *rq,
 			goto out_unmap_sg;
 		}
=20
-		req->metadata_sgl->nents =3D blk_rq_map_integrity_sg(rq->q,
-				rq->bio, req->metadata_sgl->sg_table.sgl);
+		req->metadata_sgl->nents =3D blk_rq_map_integrity_sg(rq->bio,
+					req->metadata_sgl->sg_table.sgl);
 		*pi_count =3D ib_dma_map_sg(ibdev,
 					  req->metadata_sgl->sg_table.sgl,
 					  req->metadata_sgl->nents,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc1a1644cbc0c..33a7d07dcbe26 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1183,8 +1183,7 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *=
cmd)
 			goto out_free_sgtables;
 		}
=20
-		count =3D blk_rq_map_integrity_sg(rq->q, rq->bio,
-						prot_sdb->table.sgl);
+		count =3D blk_rq_map_integrity_sg(rq->bio, prot_sdb->table.sgl);
 		BUG_ON(count > ivecs);
 		BUG_ON(count > queue_max_integrity_segments(rq->q));
=20
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.=
h
index 0de05278ac824..38b43d6c797df 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -25,8 +25,7 @@ static inline bool queue_limits_stack_integrity_bdev(st=
ruct queue_limits *t,
 }
=20
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
-				   struct scatterlist *);
+int blk_rq_map_integrity_sg(struct bio *, struct scatterlist *);
 int blk_rq_count_integrity_segs(struct bio *);
=20
 static inline bool
@@ -95,8 +94,7 @@ static inline int blk_rq_count_integrity_segs(struct bi=
o *b)
 {
 	return 0;
 }
-static inline int blk_rq_map_integrity_sg(struct request_queue *q,
-					  struct bio *b,
+static inline int blk_rq_map_integrity_sg(struct bio *b,
 					  struct scatterlist *s)
 {
 	return 0;
--=20
2.43.5

