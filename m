Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF3E2E88B6;
	Tue, 14 Oct 2025 21:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478923; cv=none; b=pYRndABp7+SA1hp3r29YD+XOfJpYCHpDhx+8vfz+EjmhAl6LB35RTI5Z/fyby47mZkHSCW+MhL35Yvt4ZEElM5ip4ufSMfc5pSLc45yhyYiIknRQEqoKYy0neYns65j71SlzAcSxKb4ngF0PnsQzsi1lpFRiEm/G05dI1LtT+G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478923; c=relaxed/simple;
	bh=Ufxl2UkV0c+Hh77Tbp8x6e+Mm1NahCpBwbyMbzOHLr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBNCYmIDeF9g8c2F97v3H35/SSk5xnKwk8YwY2uTtD1MErbNlBZnTL9egkFbJHqt9gyurNRHEOFkl8bX+n3Ziq0VAUF7inUHVjF/F2UCU/tpWJh4UvXsjxq8KtHmCjzhWT7FQX6oBs8SZBJmM61GbOZXTh0ubI72xPiVxUNQJtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KruGerGy; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KruGerGy"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgr5Rkkzm0yVD;
	Tue, 14 Oct 2025 21:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478919; x=1763070920; bh=mpnax
	OVGH4VD79H0lHUAbbjpAvvzrt4nYyaA03cCCH8=; b=KruGerGyWrqXESgDYzRSY
	VoDlLOt9vsENlRaTHrCicAAH0RJPaYwLzPB1wyUb8MaGJKnrp8bDbXrQ62gAoHGU
	CvnMmS0U80kbSXltM7ICig9cDewWr5uG8dyddGWzrMTMvura2cF74Wavznu9yKUY
	RcNYfmABsaVVN4Y8uICulgcKqxm91B6+HaLiX+LMMDrndaxM2Fhqy41CFwhPtLWN
	IIB7XGt7QRBT6XbKyfyOdtObsDXpWvmQyyLWKH4IKJEqqyWtp7j0SOf07xG0leeb
	1LkjWdfX7oKAGJFp4PGB8SmNy5C7uil4QDGgRZqpzATi34NvJcHCKj0LdASDJ6vX
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hpS5nkRJjs9j; Tue, 14 Oct 2025 21:55:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgl3FRzzm0yVJ;
	Tue, 14 Oct 2025 21:55:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 05/20] blk-mq: Run all hwqs for sq scheds if write pipelining is enabled
Date: Tue, 14 Oct 2025 14:54:13 -0700
Message-ID: <20251014215428.3686084-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

One of the optimizations in the block layer is that blk_mq_run_hw_queues(=
)
only calls blk_mq_run_hw_queue() for a single hardware queue for single
queue I/O schedulers. Since this optimization may cause I/O reordering,
disable this optimization if ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELININ=
G
has been set. This patch prepares for adding write pipelining support in
the mq-deadline I/O scheduler.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 81952d0ae544..5f07483960f8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2401,8 +2401,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx=
, bool async)
 EXPORT_SYMBOL(blk_mq_run_hw_queue);
=20
 /*
- * Return prefered queue to dispatch from (if any) for non-mq aware IO
- * scheduler.
+ * Return preferred queue to dispatch from for single-queue IO scheduler=
s.
  */
 static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 {
@@ -2412,6 +2411,11 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(st=
ruct request_queue *q)
 	if (!blk_queue_sq_sched(q))
 		return NULL;
=20
+	if (blk_queue_is_zoned(q) && blk_pipeline_zwr(q) &&
+	    test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
+		     &q->elevator->flags))
+		return NULL;
+
 	ctx =3D blk_mq_get_ctx(q);
 	/*
 	 * If the IO scheduler does not respect hardware queues when
