Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D03176E4;
	Mon, 24 Nov 2025 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008549; cv=none; b=ZIiBUNJwxMUnihVAo62xekUVxH3ZIz+iOLJXVdpu1aH1KOBC68X/PmBIYT3vb3eUedFx4EKKVr1W7FfEzFcNM4xGe4bHP3UaTke0Ra7KDYaw11JQYXAdamDDKUopOmf0W/MPF4WrE6C7GO6+iEfhmilm612qM4Stgc55xdLO1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008549; c=relaxed/simple;
	bh=72PYP6hh+iWOxF8TKC2rsNMzyAnyXs7SKlyntA58SQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q25aIfAGe+cGsUTWJOzZFSa+TkyThbjFdojj1E9y9wcNl4Ii6ro5UE2JCqklkpqJ9m4IUy2uf/jShjbbnnajrO1fSsi1rIurHQVOBhP5OY3nIwWGyo9vjpiG6+UAAGjvLiBIaWouAWLjZx87wYNmQv6kDgUTX3H4xA44vM+d5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SECp9U5J; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SECp9U5J"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dFZ1H12WDzlgqVc;
	Mon, 24 Nov 2025 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1764008545; x=1766600546; bh=h+G7A
	hqrsuqt8KedeyjkYFvmPnAexedEJv6KezJgDiY=; b=SECp9U5Jy2cGz1ao4IuL6
	KT4MdOF/aFWjxd9Q6DDPTKIvoQv8R+nMKKHKOEP4XF4ZwEiPBHDnOqNNiKovLTh/
	18jeLM4cbJOQ0Q20tvh02o5cccjngAKQy+s2skvqyMMUMNjWU4iC3HCW7QSgfql6
	c3f7yng76j8UjbmbqllXYI/GB+0GyZeOvGoEold2DVOmU/dMFlxWbkqzHCoop3IC
	bjV3r7Fce1FOM74U7Z3YGoLBqj1BdevGhLQJN2jFaIgWwgxehMsgd3/zx+c0xo/4
	mSZ4IJ/lcQ6edR3jJ61ADRB00vkCiJBxtQceP2S72tUHMvHSko1UHd4Ohebk0m4D
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id e2DuDvbxd7DX; Mon, 24 Nov 2025 18:22:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dFZ172LGfzlgqVJ;
	Mon, 24 Nov 2025 18:22:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 1/5] block: Introduce __blk_mq_tagset_iter()
Date: Mon, 24 Nov 2025 10:21:56 -0800
Message-ID: <20251124182201.737160-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251124182201.737160-1-bvanassche@acm.org>
References: <20251124182201.737160-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for introducing a second caller of __blk_mq_tagset_iter(). No
functionality has been changed.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-tag.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 8a61c481015e..f169beeded64 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -419,6 +419,24 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, b=
lk_mq_rq_iter_fn *fn,
 	__blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
 }
=20
+static void __blk_mq_tagset_iter(struct blk_mq_tag_set *tagset,
+			blk_mq_rq_iter_fn *fn, void *priv, unsigned long flags)
+{
+	int i, nr_tags, srcu_idx;
+
+	srcu_idx =3D srcu_read_lock(&tagset->tags_srcu);
+
+	nr_tags =3D blk_mq_is_shared_tags(tagset->flags) ? 1 :
+		tagset->nr_hw_queues;
+
+	for (i =3D 0; i < nr_tags; i++) {
+		if (tagset->tags && tagset->tags[i])
+			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
+					      flags);
+	}
+	srcu_read_unlock(&tagset->tags_srcu, srcu_idx);
+}
+
 /**
  * blk_mq_tagset_busy_iter - iterate over all started requests in a tag =
set
  * @tagset:	Tag set to iterate over.
@@ -434,19 +452,7 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, b=
lk_mq_rq_iter_fn *fn,
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		blk_mq_rq_iter_fn *fn, void *priv)
 {
-	unsigned int flags =3D tagset->flags;
-	int i, nr_tags, srcu_idx;
-
-	srcu_idx =3D srcu_read_lock(&tagset->tags_srcu);
-
-	nr_tags =3D blk_mq_is_shared_tags(flags) ? 1 : tagset->nr_hw_queues;
-
-	for (i =3D 0; i < nr_tags; i++) {
-		if (tagset->tags && tagset->tags[i])
-			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
-					      BT_TAG_ITER_STARTED);
-	}
-	srcu_read_unlock(&tagset->tags_srcu, srcu_idx);
+	__blk_mq_tagset_iter(tagset, fn, priv, BT_TAG_ITER_STARTED);
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
=20
