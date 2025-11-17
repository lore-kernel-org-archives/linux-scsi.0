Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E3727FD68;
	Mon, 17 Nov 2025 22:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419966; cv=none; b=SkJQehrfgUYFJ6MImRG0upQTG4397ub87yTA8W3pSc7Id07ijRjiMa4/FkB+XpEp2I6hOp6s2CbP84/2Mf3iWfoP8cjui+AzhRuqfEnkbp3RWw0UQVRtHO+rEeMHuFPUKQFQHW2G8aSIW0zjtJl0fD8PYOeXLo+3gUZMXlBEIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419966; c=relaxed/simple;
	bh=SES9V2B/BOO52H34xDaNgGtl6Z/pEIo+CDwyMNNF8lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT0+pcFfOOQejnznpwyOgvbKdUfsFVOMmWGFGojqxzDAzlvvrl++BcZMXxTZlIdXyeJOX2Emphq17S9RdjoApw4e1SLDHW0CuidDNH4Xmk2lSGrjUUfK1nHo5oDpJ/ulsD4UxR5ASmkkZrLRNN69eH/SNh+bcG11oPTcBDwSlNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2msCSAbl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2msCSAbl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9NLN11TPzltKWC;
	Mon, 17 Nov 2025 22:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1763419962; x=1766011963; bh=4qzid
	EP5w/V4nMetIYAPW9YW3hJh/LH6nNyfNI+Z9eM=; b=2msCSAbliPoacB30hzf7S
	ZB9M9DFR3Nuyjs8QnI0dmCxJwLeHN0sRY62GJy/HHPg4LTlXN4JxQTKWD/kihTkh
	9ctG0s5WemQKLOq0n7l9UOkWJVF3h1SU+cCb7NBu/hBPzsBZCvHUk1qb6ELM0JTI
	VPUuqeYk+/KIp6MAgRfgm3TdzT1dfQv0IDik2+72wVd8Y1t8X1MEenvuvHwN8mYY
	uO6tLKqhWATqlz6QIo4r9ya8PWFQe96OOzRvwBHbPYCk0Y5u3QKla7nbsO6ck7Dl
	XT7odXOEkDprHRu9TO1yrmtfYUX7uEb/b+bOcbUOuQeROmBJVE9GZVyn88QMo/Pr
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o_MyPuVDlA0N; Mon, 17 Nov 2025 22:52:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9NLD6sGPzltMJY;
	Mon, 17 Nov 2025 22:52:36 +0000 (UTC)
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
Subject: [PATCH v2 3/5] block: Introduce blk_mq_tagset_iter()
Date: Mon, 17 Nov 2025 14:52:02 -0800
Message-ID: <20251117225205.2024479-4-bvanassche@acm.org>
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

Support iterating over all requests in a tag set, including requests
that have not yet been started. A later patch will call this function
from scsi_device_busy().

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-tag.c     | 19 +++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index f169beeded64..f277ed7e7743 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -456,6 +456,25 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *=
tagset,
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
=20
+/**
+ * blk_mq_tagset_iter - iterate over all requests in a tag set
+ * @tagset:	Tag set to iterate over.
+ * @fn:		Pointer to the function that will be called for each request.
+ *		@fn will be called as follows: @fn(rq, @priv) where rq is a
+ *		pointer to a request. Return true to continue iterating tags,
+ *		false to stop.
+ * @priv:	Will be passed as second argument to @fn.
+ *
+ * We grab one request reference before calling @fn and release it after
+ * @fn returns.
+ */
+void blk_mq_tagset_iter(struct blk_mq_tag_set *tagset, blk_mq_rq_iter_fn=
 *fn,
+			void *priv)
+{
+	__blk_mq_tagset_iter(tagset, fn, priv, 0);
+}
+EXPORT_SYMBOL(blk_mq_tagset_iter);
+
 static bool blk_mq_tagset_count_completed_rqs(struct request *rq, void *=
data)
 {
 	unsigned *count =3D data;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3467cacb281c..20a22c1cd067 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -927,6 +927,8 @@ void blk_mq_run_hw_queues(struct request_queue *q, bo=
ol async);
 void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long m=
secs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		blk_mq_rq_iter_fn *fn, void *priv);
+void blk_mq_tagset_iter(struct blk_mq_tag_set *tagset, blk_mq_rq_iter_fn=
 *fn,
+		void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset)=
;
 void blk_mq_freeze_queue_nomemsave(struct request_queue *q);
 void blk_mq_unfreeze_queue_nomemrestore(struct request_queue *q);
