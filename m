Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A38253F13;
	Tue, 16 Dec 2025 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924272; cv=none; b=J8WBC7QDoPe0JOHbm/z0M4TxUHt/MFHzgBsWBCkPrpLbH5up7t2osytE5FbANj/ZlkeFDODdRLHH7kscOc3Yz020bfvENoxCTLo5M8zZb9OczO9bwDA0R8prWGAlTLGdbIsAxBMXSI6cI7vRDV9wENkTAGAUp/t78w2kkN+aWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924272; c=relaxed/simple;
	bh=Co8aDkxJXAktfzz1zQokSiXwpFDtoH+itsQDiiCPieA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyiMotC9A3do9/vUqB9DVTIW4oWyvrC38P9EvB5itXBXTry+kyg04SFjhnJl7ONQ/Q4Ci04T6XZS8vih+6Nlm7AAgugQtbpro0xlJFbIY3Dgl8dF5+4bdgbyHqXmNAIiWD19P0HvxObPZE0/nM/31QRDaz0XqlDcc1a/OC8Ww/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=issXhSWd; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="issXhSWd"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBV56fp3zmLCvh;
	Tue, 16 Dec 2025 22:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1765924267; x=1768516268; bh=SsHxg
	P5XMsdOtpHWqOZi6PfLKZLzdwAg5ZFNNRu7MsE=; b=issXhSWdumUx/9Jkoz1YZ
	hd3kcYOlTo57gDJsnyev4TRODr+LyU3qFqorWaqUIOI9YKWnwt2juqmNKf+Dug+r
	gZ0VZBle3gzVFCkbE5SWB4r6C8n/ISftjIjq0x+TJ3Gvg5FKjhUNOHar7lJVW/DZ
	bGqZZCJ9z/Ss4uW6oM5nno+lVGO1aWld58BjqzjWDpt4aLbA6q0psMtRQvcJ0LaV
	lQrhBSljBpwYAg3a9zmZdwA72LdW5roZLR/8SRSlY42NkPlmOvtWnBJGBjpjYxuR
	YwyVsIhcmAX5YbuBq+ColXPr74MkwaPeh8p3/EKLCdjqk5pUZwwRkp7c0m277jyF
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QLKQHAiKy0nm; Tue, 16 Dec 2025 22:31:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBV14Sr5zmP4v2;
	Tue, 16 Dec 2025 22:31:05 +0000 (UTC)
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
Subject: [PATCH v4 1/6] block: Rename busy_tag_iter_fn into blk_mq_rq_iter_fn
Date: Tue, 16 Dec 2025 14:30:45 -0800
Message-ID: <20251216223052.350366-2-bvanassche@acm.org>
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

The name 'busy_tag_iter_fn' is not correct since blk_mq_all_tag_iter()
uses this function pointer type for requests that may not be "busy"
(started). Hence rename 'busy_tag_iter_fn' into 'blk_mq_rq_iter_fn'.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-tag.c     | 16 ++++++++--------
 block/blk-mq.h         |  4 ++--
 include/linux/blk-mq.h |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5b664dbdf655..e8e1fd398d4b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -247,7 +247,7 @@ void blk_mq_put_tags(struct blk_mq_tags *tags, int *t=
ag_array, int nr_tags)
 struct bt_iter_data {
 	struct blk_mq_hw_ctx *hctx;
 	struct request_queue *q;
-	busy_tag_iter_fn *fn;
+	blk_mq_rq_iter_fn *fn;
 	void *data;
 	bool reserved;
 };
@@ -310,7 +310,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned =
int bitnr, void *data)
  *		bitmap_tags member of struct blk_mq_tags.
  */
 static void bt_for_each(struct blk_mq_hw_ctx *hctx, struct request_queue=
 *q,
-			struct sbitmap_queue *bt, busy_tag_iter_fn *fn,
+			struct sbitmap_queue *bt, blk_mq_rq_iter_fn *fn,
 			void *data, bool reserved)
 {
 	struct bt_iter_data iter_data =3D {
@@ -326,7 +326,7 @@ static void bt_for_each(struct blk_mq_hw_ctx *hctx, s=
truct request_queue *q,
=20
 struct bt_tags_iter_data {
 	struct blk_mq_tags *tags;
-	busy_tag_iter_fn *fn;
+	blk_mq_rq_iter_fn *fn;
 	void *data;
 	unsigned int flags;
 };
@@ -378,7 +378,7 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsi=
gned int bitnr, void *data)
  * @flags:	BT_TAG_ITER_*
  */
 static void bt_tags_for_each(struct blk_mq_tags *tags, struct sbitmap_qu=
eue *bt,
-			     busy_tag_iter_fn *fn, void *data, unsigned int flags)
+			blk_mq_rq_iter_fn *fn, void *data, unsigned int flags)
 {
 	struct bt_tags_iter_data iter_data =3D {
 		.tags =3D tags,
@@ -392,7 +392,7 @@ static void bt_tags_for_each(struct blk_mq_tags *tags=
, struct sbitmap_queue *bt,
 }
=20
 static void __blk_mq_all_tag_iter(struct blk_mq_tags *tags,
-		busy_tag_iter_fn *fn, void *priv, unsigned int flags)
+		blk_mq_rq_iter_fn *fn, void *priv, unsigned int flags)
 {
 	WARN_ON_ONCE(flags & BT_TAG_ITER_RESERVED);
=20
@@ -413,7 +413,7 @@ static void __blk_mq_all_tag_iter(struct blk_mq_tags =
*tags,
  *
  * Caller has to pass the tag map from which requests are allocated.
  */
-void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
+void blk_mq_all_tag_iter(struct blk_mq_tags *tags, blk_mq_rq_iter_fn *fn=
,
 		void *priv)
 {
 	__blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
@@ -432,7 +432,7 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, bu=
sy_tag_iter_fn *fn,
  * @fn returns.
  */
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
-		busy_tag_iter_fn *fn, void *priv)
+		blk_mq_rq_iter_fn *fn, void *priv)
 {
 	unsigned int flags =3D tagset->flags;
 	int i, nr_tags, srcu_idx;
@@ -493,7 +493,7 @@ EXPORT_SYMBOL(blk_mq_tagset_wait_completed_request);
  * called for all requests on all queues that share that tag set and not=
 only
  * for requests associated with @q.
  */
-void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_f=
n *fn,
+void blk_mq_queue_tag_busy_iter(struct request_queue *q, blk_mq_rq_iter_=
fn *fn,
 		void *priv)
 {
 	int srcu_idx;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index c4fccdeb5441..ae119cb12136 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -190,9 +190,9 @@ void blk_mq_tag_update_sched_shared_tags(struct reque=
st_queue *q,
 					 unsigned int nr);
=20
 void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
-void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_f=
n *fn,
+void blk_mq_queue_tag_busy_iter(struct request_queue *q, blk_mq_rq_iter_=
fn *fn,
 		void *priv);
-void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
+void blk_mq_all_tag_iter(struct blk_mq_tags *tags, blk_mq_rq_iter_fn *fn=
,
 		void *priv);
=20
 static inline struct sbq_wait_state *bt_wait_ptr(struct sbitmap_queue *b=
t,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b25d12545f46..3467cacb281c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -549,7 +549,7 @@ struct blk_mq_queue_data {
 	bool last;
 };
=20
-typedef bool (busy_tag_iter_fn)(struct request *, void *);
+typedef bool (blk_mq_rq_iter_fn)(struct request *, void *);
=20
 /**
  * struct blk_mq_ops - Callback functions that implements block driver
@@ -926,7 +926,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, =
bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long m=
secs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
-		busy_tag_iter_fn *fn, void *priv);
+		blk_mq_rq_iter_fn *fn, void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset)=
;
 void blk_mq_freeze_queue_nomemsave(struct request_queue *q);
 void blk_mq_unfreeze_queue_nomemrestore(struct request_queue *q);
