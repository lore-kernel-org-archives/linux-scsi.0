Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94809287502;
	Tue, 16 Dec 2025 22:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924277; cv=none; b=dto5elOnBmP46GdZCuaIXh+IQAYG678EfOdHJHQOHiKXtuXVyCbhLqar77n8XG+5UXWdK6jFE8SvKnb+1HwlMxvENx2etU+6s+6hIBkc7vIvyeO/A/Y19bME2lBNZQ2vSX9GRPC3w8JOEVOsAzmeFiBg159xOHQQeFA9dDz8404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924277; c=relaxed/simple;
	bh=PPK3fADXD/buh6kravA7r/KgporUhWh+JpRrtcdKXMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbX0v0zfZCt2/GTYMc+xbq1J6LTUgH8Apkp3q/9vh1Sfkg6o9NLHQ9JVzRRFGi9n6p4KeIAvEuhHQlKLEkoYij1vsOrmj0+I/IzkQxkfOvsjG7YxzvcaIW6Mr7q+NzPy6utebv6i5sfxh1X00tIQkW96drJylc6dQ9HuY+DdUuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d2O1Bhvm; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d2O1Bhvm"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBVC11nrzmP6YV;
	Tue, 16 Dec 2025 22:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765924273; x=1768516274; bh=N818M
	RmrcUCo/N0tWzMP1IbxzGuIEV/PcQJrwDwov34=; b=d2O1BhvmbMKJQtrW6HJr7
	kPUS5k3jmdtcsjY7HThHnd0ty1APDnSJa+CxF+jHCgH+lPszAz8qnwI3QqBupx7x
	8+EEnOZDETYZI0in965S19dlNvBpBLA/zdXrAHHQhraus/PrHE7qx91BlOLLMzMc
	TSFZSaKohf1n81yuEY6Bh+NkOMNrfRvp1zJqRSHOZeOgDUvSZELPUndRijcU7wMb
	P6HvttxfD+EOBL4qRaMFf90MHVllET0396a0/dPS0GivI3wj1OreXEdKMw57MuTr
	p6fz91352B5TrrUOmosc7q0ry6J66uyvQ1Xt3VtqJasFPm5133qawruXo3TQjsl1
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MKuQSjIz9hl5; Tue, 16 Dec 2025 22:31:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBV700gKzmP4tw;
	Tue, 16 Dec 2025 22:31:10 +0000 (UTC)
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
Subject: [PATCH v4 3/6] block: Introduce blk_mq_tagset_iter()
Date: Tue, 16 Dec 2025 14:30:47 -0800
Message-ID: <20251216223052.350366-4-bvanassche@acm.org>
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
index 783addc52e09..0e58e615af87 100644
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
