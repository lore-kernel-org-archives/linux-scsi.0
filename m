Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68631355E;
	Mon, 17 Nov 2025 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419960; cv=none; b=Z6m17HiSjfwmCfNmtOYG7aIai+atyf/oLkRaWF7ztkpy8foB2YxD/Bjk9IJEkRhmYlO8DdFTEvpKpBXs8xgGpfT/nWQhlbWLg1HxTO5Ny8e+kTuWO6Fj6xCa7MV9rMK+g4E8ATcvidp2q7lUzjsoycHQWcArvtN9mv18xXp19yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419960; c=relaxed/simple;
	bh=72PYP6hh+iWOxF8TKC2rsNMzyAnyXs7SKlyntA58SQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iH2YLjPCHz2ik3fot7GAtrSf83bUORXEdWu/fJ6Gw4ZYf+e1w+K1QuiwGP0K9ufSUwGBsFtai0qWaOinSDaSiwdK+Hs76Lg/b+nwPy9MTRiakKSPiXAjvvTebRBK7P6LO8YwnxDu5WD2yIDbSbsBJsFkGlhpfR/2w1WLhVMVHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UZZeCM/g; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UZZeCM/g"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9NLF4V4NzltQ13;
	Mon, 17 Nov 2025 22:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763419955; x=1766011956; bh=h+G7A
	hqrsuqt8KedeyjkYFvmPnAexedEJv6KezJgDiY=; b=UZZeCM/gqVxNdDsI6ZCtO
	DimOWUBAe+fNdvAEeUy8xwh093ze0kwrUIxQzYCY/gZrfkk26XB1xVVXDVIfft99
	HmFBslxPomTRWuOyueMKUzV9JqqEc+gckhHrnwpYpGsEOE1GKbylx9jdOR27fbB0
	S01elRyZeWep7O5bZQ9kwyXSc/uG8eIF215Y3UKIYjY2VAvUyEYEEEIEIvugPoNh
	p4kh/AXZMjuX9reJMUNdYGzG7ZgO/VlrWf2LxZ6M9+u1MRjcOgQqqqfnHHBmnwrU
	ZUsMqdNgFYSDVca4riLML4uPqZxRJQ+Hji5ddluMmKTP1Mi7cglLTuZESn+/ZyoW
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id e_kTqKx_Q-9w; Mon, 17 Nov 2025 22:52:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9NL636tzzltKjq;
	Mon, 17 Nov 2025 22:52:29 +0000 (UTC)
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
Subject: [PATCH v2 2/5] block: Introduce __blk_mq_tagset_iter()
Date: Mon, 17 Nov 2025 14:52:01 -0800
Message-ID: <20251117225205.2024479-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251117225205.2024479-1-bvanassche@acm.org>
References: <20251117225205.2024479-1-bvanassche@acm.org>
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
