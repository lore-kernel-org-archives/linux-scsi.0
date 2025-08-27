Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB61ACEDA;
	Wed, 27 Aug 2025 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330235; cv=none; b=UsEVwVQhEkJMIh5KriJsgtxu5M+SczsQbjNymR9rPZrauQvJeTVReM24nLlSgIkNkfk5MZDjvcs7spSg8xH/iPC8jujlYFwAjnMp6mWBgDuX5nI5Uoi/FJOIVlI/lscp7puW7SENYS/7wP1qjrpwu811JfG9LiJJYSpZZq5T7Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330235; c=relaxed/simple;
	bh=7Qli0bVQ145B0Q9GF7lcZ301dbwRBRqN19lTXYk7KTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK8gnqichz+mXHrWB7b1MnHPrqSTbpyI4woilgReVHKG+KHQ+NyYzqS5Buz5TRmc/c96WbXfwNXgwxTcdzGzZTzjO3yO3Kmy2aQi1FDzQMdy2vPxeim7jkrXp6E6JsEZyov6ofS1RgDjKb/XvxDwNrHOoZkcwkR2wCceRnrTRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S+PzdRZq; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S+PzdRZq"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPM5bNPzm174B;
	Wed, 27 Aug 2025 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330230; x=1758922231; bh=DvFVQ
	Qy0V7DickKpK7Qu5tJ5VB+WoKefexmKubOOLA0=; b=S+PzdRZqRuk6Ftpli2Xbz
	8xv7ywxmw2+JKJzTGXymCJZeusZPqiRSxwJ74m+UOkRQo0ORQBDvrGJXjCc+DssZ
	yJYnnbb7V9oGqjDuIRCGA2pafzZG3tGUICF4hCFFfHL5TwqIYe9hN2jalnAm9+RU
	hXxD5xT0s4A+ZTgOCCLZ8g+2Ta3QrDFlfG/piNW1yDXf7s+wYJosxApX3RXSNyuc
	uXQBc5R9dtGx1SgK/Fz69BR9bMRUi6lvQHvsTPTTe/2p4n6YIoYdtzTXhRyCA2BT
	E7yowRNGrOGs4xBAywL4q7lO4XeSivxHpNelk47asC2xMlf/dWoK7uSSFvHeGtyV
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hCZMsGVHAkB1; Wed, 27 Aug 2025 21:30:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPG4x4czm174Z;
	Wed, 27 Aug 2025 21:30:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 05/18] blk-mq: Run all hwqs for sq scheds if write pipelining is enabled
Date: Wed, 27 Aug 2025 14:29:24 -0700
Message-ID: <20250827212937.2759348-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
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
queue I/O schedulers instead of for all hardware queues. Disable this
optimization if ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING has been
set. This patch prepares for adding write pipelining support in the
mq-deadline I/O scheduler.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2d3239aacbc..33b639653b5d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2387,8 +2387,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx=
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
@@ -2398,6 +2397,11 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(st=
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
