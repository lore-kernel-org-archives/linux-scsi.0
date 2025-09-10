Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D86308F32;
	Wed, 10 Sep 2025 21:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540002; cv=none; b=aoGu1WjeoSBMWexWVIe8BFcPaSql8UR+R8/OwhVpAlvyPLK3d1vwj1aswy3yUaEHWc1C+B1t0sYk6xK4HTwZG/q7SGfBHrEufmF6ERoHXFH6FSnL3v/MkXhl9lvFQPhmIQLvGVA1SKZzO6F2MJSIphFDPHKE3vYRTcjSL4BPAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540002; c=relaxed/simple;
	bh=+Vz2C/szieCFu676AUaOfHrBLXbZidNiAnH2QkRXIxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrAkix9ksZdp9Jr1T3hC/zTSNcveqhW9jSkQgUI/2kSVgPoZql+zrfGK373ZMEmMBqHO5JYIwF0kyS3AQX0RjvKW34RWXPX+u4KRgJyspb3ux9v83Uq8rSYJNlNiIPWirqCgDJCvEDojSztbrXwlSKidG7Y3s89E8wP7B/VsWmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lrYqQGDT; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lrYqQGDT"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cMYp61z7czm174M;
	Wed, 10 Sep 2025 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757539996; x=1760131997; bh=It5L8
	r69M+QtfUVMCgTNLWZo1vOfzVnQ9/IfjgtO03o=; b=lrYqQGDTr+xZ/fQ1gnWQH
	iYkZUz/+uMFWk6D9MPyPL9HgHYdenagO0bGtUd/tzgDH/S4zmrvwXC/Nui+JCD0b
	MCKF80Oyudfh3283aSC0Dloffl8z3QMoP7XHuipKu8eutfB1DRWCgjq4j7Xcf8fG
	DRoVnIW75mK4ju8b0tLzWe+CBEiqxTGT8ZQPSCZRzsFyizV9f16ZNFwP9I4mI/ML
	ph3BLPI/RXhVbyhkkIO/OCZ1qXYKGBJVuWfs2sReiN+UY2AGE8yN05J5Cun68+BB
	NeJ0UQMFUOR2TLfxXu552ZYxuGOXS3mBby1ySh4Ok5NgBBDmFHpBLGO55S4jSSfd
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7CYRhqKJpuE3; Wed, 10 Sep 2025 21:33:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cMYnz0lH8zm0yTF;
	Wed, 10 Sep 2025 21:33:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/3] block: Export blk_mq_all_tag_iter()
Date: Wed, 10 Sep 2025 14:32:49 -0700
Message-ID: <20250910213254.1215318-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250910213254.1215318-1-bvanassche@acm.org>
References: <20250910213254.1215318-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for using blk_mq_all_tag_iter() in the SCSI core.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-tag.c     | 1 +
 block/blk-mq.h         | 2 --
 include/linux/blk-mq.h | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d880c50629d6..1d56ee8722c5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -419,6 +419,7 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, bu=
sy_tag_iter_fn *fn,
 {
 	__blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
 }
+EXPORT_SYMBOL(blk_mq_all_tag_iter);
=20
 /**
  * blk_mq_tagset_busy_iter - iterate over all started requests in a tag =
set
diff --git a/block/blk-mq.h b/block/blk-mq.h
index affb2e14b56e..944668f34856 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -179,8 +179,6 @@ void blk_mq_tag_update_sched_shared_tags(struct reque=
st_queue *q);
 void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_f=
n *fn,
 		void *priv);
-void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
-		void *priv);
=20
 static inline struct sbq_wait_state *bt_wait_ptr(struct sbitmap_queue *b=
t,
 						 struct blk_mq_hw_ctx *hctx)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2a5a828f19a0..8ed09783f289 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -921,6 +921,8 @@ void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *=
hctx, unsigned long msecs);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long m=
secs);
+void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
+		void *priv);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset)=
;
