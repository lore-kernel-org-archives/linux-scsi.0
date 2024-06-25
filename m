Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEFB1684AC;
	Tue, 25 Jun 2024 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327617; cv=none; b=aE3keieCMMNSqBJAFvS4MCLAPD57qZbgzOsQb/ZUr6VFWfSLIKnkT4enZj/3DlVnIVfsF9nOiVn7x4YLZh5hgn7FUueujIAyr4KA5nPz12PhubaxbYunDKzBdDGpRggIZ+4VTM0L1zSEaQgMjSqeGA9GoGK3TF3MJbT77BTpnuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327617; c=relaxed/simple;
	bh=/KFitF1lfx4MOfqotw6pXiGxlkUeA43Vos8fn9us1Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOXe0TC4yNyylIBpD+cL7WS9GDbi+YXZt6Vj3eLOzs78SUC7KSzh4ryGKyBCsrz/ObNLXnt8whDWkQXH7Rfid+UUgTyXckFAko0EsZQ9//Qm4eiAg2aiHzlXtOK3xnOVfW7r0FvgOnGGIjU5BGvS4nU4/7bDoVE3t3Jfi6AEpZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xNdKO93D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xNdKO93D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9HqEHDNcuzUmI5HVsYMUGNJQtwYKktWqkfOUkZi9+7s=; b=xNdKO93D22WOiEw+I81t9FNbX2
	Wi1XHFiLmJehkgxbrZTDoPorvUVcntbN6Q/NvAz523mQSCWsuf2x3Ut7W/S/14YmGxBmZAqj3dvWc
	lxTEHXLtpc7xqqkJLAMaqBCqu4TeZmm6VMZV1Cfx/HpKBvWyMgK/CEn6RA04/bkfJI90yl+TWEtyU
	eEcT6CN4Elyaub3kuO0e0UyTFYpuqVk+vp28oQPNCLuLMPB2Jw1NZdgjrZCzMNteUY1IpL/cHKzbC
	DjOjrWOdycog6f8/ybYwOl3ScwIOsQsZArG0COsaltCfkIKfiJ5nnBtWzTyk0IwvbQ171ukThV1Xr
	24bmlnhw==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7eV-00000003Ikb-0Twq;
	Tue, 25 Jun 2024 15:00:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/8] block: rename BLK_FLAG_MISALIGNED
Date: Tue, 25 Jun 2024 16:59:48 +0200
Message-ID: <20240625145955.115252-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625145955.115252-1-hch@lst.de>
References: <20240625145955.115252-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is a flag for ->flags and not a feature for ->features.  And fix the
one place that actually incorrectly cleared it from ->features.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 18 +++++++++---------
 include/linux/blkdev.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index ec7dbe93d5c324..ed39a55c5bae7c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -351,7 +351,7 @@ static int blk_validate_limits(struct queue_limits *lim)
 
 	if (lim->alignment_offset) {
 		lim->alignment_offset &= (lim->physical_block_size - 1);
-		lim->features &= ~BLK_FEAT_MISALIGNED;
+		lim->flags &= ~BLK_FLAG_MISALIGNED;
 	}
 
 	if (!(lim->features & BLK_FEAT_WRITE_CACHE))
@@ -564,7 +564,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &= ~BLK_FEAT_POLL;
 
-	t->flags |= (b->flags & BLK_FEAT_MISALIGNED);
+	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_user_sectors = min_not_zero(t->max_user_sectors,
@@ -603,7 +603,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 		/* Verify that top and bottom intervals line up */
 		if (max(top, bottom) % min(top, bottom)) {
-			t->flags |= BLK_FEAT_MISALIGNED;
+			t->flags |= BLK_FLAG_MISALIGNED;
 			ret = -1;
 		}
 	}
@@ -625,28 +625,28 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
 		t->physical_block_size = t->logical_block_size;
-		t->flags |= BLK_FEAT_MISALIGNED;
+		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
 
 	/* Minimum I/O a multiple of the physical block size? */
 	if (t->io_min & (t->physical_block_size - 1)) {
 		t->io_min = t->physical_block_size;
-		t->flags |= BLK_FEAT_MISALIGNED;
+		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
 
 	/* Optimal I/O a multiple of the physical block size? */
 	if (t->io_opt & (t->physical_block_size - 1)) {
 		t->io_opt = 0;
-		t->flags |= BLK_FEAT_MISALIGNED;
+		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
 	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
 		t->chunk_sectors = 0;
-		t->flags |= BLK_FEAT_MISALIGNED;
+		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
 
@@ -656,7 +656,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
-		t->flags |= BLK_FEAT_MISALIGNED;
+		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
 	}
 
@@ -809,7 +809,7 @@ int bdev_alignment_offset(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q->limits.flags & BLK_FEAT_MISALIGNED)
+	if (q->limits.flags & BLK_FLAG_MISALIGNED)
 		return -1;
 	if (bdev_is_partition(bdev))
 		return queue_limit_alignment_offset(&q->limits,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b2f1362c46814f..1a7e9d9c16d78b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -347,7 +347,7 @@ enum {
 	BLK_FLAG_WRITE_CACHE_DISABLED		= (1u << 0),
 
 	/* I/O topology is misaligned */
-	BLK_FEAT_MISALIGNED			= (1u << 1),
+	BLK_FLAG_MISALIGNED			= (1u << 1),
 };
 
 struct queue_limits {
-- 
2.43.0

