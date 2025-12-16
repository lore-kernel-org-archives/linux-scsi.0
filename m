Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6853253F13;
	Tue, 16 Dec 2025 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924276; cv=none; b=gdxRfCvIKGv0CCwYUy3WMJUZ7SuVnIKqUE2YWpABT7UBd4XASX0bqEm9FdTQmYAAC+7405ply7uPdiNor1XXs80WnnHwe8Qm9YVp8A3zIft2qQVG3Qd1oTCu1m+0LKMyMy56iVdT0vUPPiXfSMKZWL7lidQ9ZJHobbdwetXnahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924276; c=relaxed/simple;
	bh=NQTcEbmwNzHHI1GzsF73E8u3su+QbpxK5uJYnXA+APk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7xlwh1SxQlaDWCrXKOTriIQiR8VLZhALWXf9DGcCcquVBjua9nk2zI41xUKvG9Wme/Wh7KH/UB4Sif/FyUnmi00bDwiQed/ubo+EPnsv8g96qkeKh0FdWhgxhCKJa9UKzw10ms95HLfNYqUIDCkjpjGkvrqn20OYHv5ZQY/IBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=osLuNpYQ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="osLuNpYQ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBV82fjJzmP4vH;
	Tue, 16 Dec 2025 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765924270; x=1768516271; bh=JJ5Ow
	iC2DbbbNT3xDxz241jp3azEsW31oFQirbOc6ds=; b=osLuNpYQFRcKlWmVbHfA1
	LN95vN+1aQ8d0ZlWCxPLu17s+3kyJxLPPs4brCen+g2I9Z2fowKnkfKIxMF90fF9
	UOVOYc+r6mMC7FQd3gRttg8ZW1Y3+OY6Anz9p5EKIrnBq19gpd1Cho9qYF6/mLYs
	QKnyZvdSN9cuEPLjp2a492PeKEv1prYEnBgFyhZiPv0Av763jTMIXb0HOGxscJIE
	3jwVJf3L0Q9dA8Y8iwAToZ1K5PVVV2PMOkkC85F/6In3a7g4cs/usKAXQgqWP88r
	arxXXfS+t1rrOIvgFeOe1d4291dGkj8cwhvmnbMJ+ezajJCrrck5FO6RsQD8urM8
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Cw3K1l7aKuVR; Tue, 16 Dec 2025 22:31:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBV41fj7zmKtSM;
	Tue, 16 Dec 2025 22:31:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v4 2/6] block: Introduce __blk_mq_tagset_iter()
Date: Tue, 16 Dec 2025 14:30:46 -0800
Message-ID: <20251216223052.350366-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
In-Reply-To: <20251216223052.350366-1-bvanassche@acm.org>
References: <20251216223052.350366-1-bvanassche@acm.org>
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
index e8e1fd398d4b..783addc52e09 100644
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
