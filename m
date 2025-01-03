Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD641C1F10;
	Fri,  3 Jan 2025 07:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735890168; cv=none; b=taUW1T7W4kkk7jCnVmIrhDE7v/9/JIQCjfXkfc9KQ4YIZgFur5yxOHuCwDIrXqDWMogcbXb1oO8tMNXUWuQhuE+oGrGQjKB/OVUDlEMRuEs/MD3mb2ptC88MyCDme7Hloo7b3BsOeyyJm45GMGhYgjSy8y8LBPjuy5ptDcK/xY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735890168; c=relaxed/simple;
	bh=gqiiuxWFqOtjmGeacp7miM9NePkQV3IGJbgcDuIFJrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0/tBxglfQzuJAbQD1INTr3fCrEa7DrRB3F2xp0aWBF9SFjfOHuHrmQNmdGYx8JillOoD2g2VuchqdxsWtTLXkh5CYbvE7FNy1j3LHmGHjgcZEyggJxmzy9rN/dsv+r81GZnyXHvnFwu6hygLQXQ1ZmxQY+jn9Bb0q1zsQHi+zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=frmeOPwJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="frmeOPwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Bd8p4JEGKwYB4tvubVq9HlXXuKHyAC7dFmjVLgsKr4s=; b=frmeOPwJomu55PiJ+dp2tDmpJG
	yZXPgOSwhuBj3X52Si3HKV/skVj+Elyg+utXkBtGFEY+qGr6ApymX0OQ9xGmuP4LyMQ1xI0THNxhA
	x4uFCacv0XuHVlqnw5kHmPgbc+qnO+vW+4DB+fhNXsVPLD5LhJZ8+gZ0nSXrHRYvHmVIXWMH9Vesk
	a6Y5jBPcXX9enYr2NR1I8OHpmDfzePeZCpIFe3zqVsGEyRLsraMcxTZj0dKhS9l6js7FLHZa4SyPY
	Yms9vHZBMO1zkG2a1tRjRmPyDiyCH4sXyzlxc/f7kyeXvieiv0YtaTk8IibqRB4KTd6VEYywkBPRx
	OHnjpy/w==;
Received: from [2001:4bb8:2dc:484c:63c3:48c7:ceee:8370] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tTcKT-0000000CNrV-2ds3;
	Fri, 03 Jan 2025 07:42:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] block: remove blk_mq_init_bitmaps
Date: Fri,  3 Jan 2025 08:42:10 +0100
Message-ID: <20250103074237.460751-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250103074237.460751-1-hch@lst.de>
References: <20250103074237.460751-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The little work done in blk_mq_init_bitmaps is easier done in the only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-tag.c | 38 ++++++++++++--------------------------
 block/blk-mq.h     |  3 ---
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 2cafcf11ee8b..ab4a66791a20 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -544,30 +544,12 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
 				       node);
 }
 
-int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
-			struct sbitmap_queue *breserved_tags,
-			unsigned int queue_depth, unsigned int reserved,
-			int node, int alloc_policy)
-{
-	unsigned int depth = queue_depth - reserved;
-	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
-
-	if (bt_alloc(bitmap_tags, depth, round_robin, node))
-		return -ENOMEM;
-	if (bt_alloc(breserved_tags, reserved, round_robin, node))
-		goto free_bitmap_tags;
-
-	return 0;
-
-free_bitmap_tags:
-	sbitmap_queue_free(bitmap_tags);
-	return -ENOMEM;
-}
-
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags,
 				     int node, int alloc_policy)
 {
+	unsigned int depth = total_tags - reserved_tags;
+	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
 	struct blk_mq_tags *tags;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
@@ -582,14 +564,18 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 	spin_lock_init(&tags->lock);
+	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
+		goto out_free_tags;
+	if (bt_alloc(&tags->breserved_tags, reserved_tags, round_robin, node))
+		goto out_free_bitmap_tags;
 
-	if (blk_mq_init_bitmaps(&tags->bitmap_tags, &tags->breserved_tags,
-				total_tags, reserved_tags, node,
-				alloc_policy) < 0) {
-		kfree(tags);
-		return NULL;
-	}
 	return tags;
+
+out_free_bitmap_tags:
+	sbitmap_queue_free(&tags->bitmap_tags);
+out_free_tags:
+	kfree(tags);
+	return NULL;
 }
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 89a20fffa4b1..3bb9ea80f9b6 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -165,9 +165,6 @@ struct blk_mq_alloc_data {
 struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 		unsigned int reserved_tags, int node, int alloc_policy);
 void blk_mq_free_tags(struct blk_mq_tags *tags);
-int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
-		struct sbitmap_queue *breserved_tags, unsigned int queue_depth,
-		unsigned int reserved, int node, int alloc_policy);
 
 unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 unsigned long blk_mq_get_tags(struct blk_mq_alloc_data *data, int nr_tags,
-- 
2.45.2

