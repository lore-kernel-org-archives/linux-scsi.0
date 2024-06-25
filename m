Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88214A630;
	Tue, 25 Jun 2024 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313589; cv=none; b=fN4r4MzuADa8TdaSKLYy8BHq1isG5jllHCrKmNlZ8+ArVhE5idETGTNO2MQLlMNezF2BQ/RdOXUAY05iWufUc6aR/ktVEczrJ+HFAxtJo4aq1vImR/0+4ati+SI1UdmMMafLnBV2PS2LYu80PG4FfuczEXxm7waa2vmp9eSimdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313589; c=relaxed/simple;
	bh=qUYuT9pldsNuInNlN3fjDmolGIHadkgqGfS6ouS8RCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TI6u7tI4+gWSVBY0lQxuHwQQH22VAQOpa0zx5aJns4J+sQw6CWosNhIUdCKCIBGu8A7JOBhkFW+O/Cmant9lceqhpJddf6spIq5+UqENK+7Z0BfyuuhqgfM4ewUq/JUzA1veZmaDAJWI5AAk7b/x/5Z7PAhx8ecPc1qnhLCxq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=agtijZld; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="agtijZld"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xzSuQpsZlR6t3WQwAuIgH3H0zXHzq8NWxz+3tJZSNS4=; b=agtijZldTZ/smEb5emrfrzUzU5
	700+iFcr+itwX7JkLAFYbpkQ1d8RLErz12daQolJKdolrgK/of5N8xgizNd2h7Y2TfQMBEA2uXcNd
	4YPlrxnwzCnQeYo+ZOxtYkjk4GVN+ZPGIPOhcFWF18BkBKogUqhAaABaZgTnnBSCon6DoJ9PnTVbj
	Hw+1s1QWKWgJinPqCBzsz/lhoFikHKyas/J/0tmu8E753PiEcmWHxhcvn6sjGhTDwxlqacSFIR1AB
	GOwL5nSe2JewPqa0qlMgheJWBXjfxXb3XRVGmarczSCDVBOOjk5/4/rc506cJZazWZfMT8pgqqDK6
	+4ZvZS0A==;
Received: from [2001:4bb8:2dc:2ee2:6df6:d2e9:d402:6e6b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM40F-00000002UKm-2wB2;
	Tue, 25 Jun 2024 11:06:24 +0000
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
Subject: [PATCH 5/7] block: remove disk_update_readahead
Date: Tue, 25 Jun 2024 13:05:45 +0200
Message-ID: <20240625110603.50885-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625110603.50885-1-hch@lst.de>
References: <20240625110603.50885-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Mark blk_apply_bdi_limits non-static and open code disk_update_readahead
in the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 8 +-------
 block/blk.h            | 2 ++
 block/genhd.c          | 2 +-
 include/linux/blkdev.h | 1 -
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index e38c522b3b6251..5f1c22881cb9d8 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -55,7 +55,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
-static void blk_apply_bdi_limits(struct backing_dev_info *bdi,
+void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 		struct queue_limits *lim)
 {
 	/*
@@ -434,12 +434,6 @@ int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
 }
 EXPORT_SYMBOL_GPL(queue_limits_set);
 
-void disk_update_readahead(struct gendisk *disk)
-{
-	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
-}
-EXPORT_SYMBOL_GPL(disk_update_readahead);
-
 /**
  * blk_limits_io_min - set minimum request size for a device
  * @limits: the queue limits
diff --git a/block/blk.h b/block/blk.h
index d0a986d8ee507e..95e5a4f81693c4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -358,6 +358,8 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio);
 
 int blk_set_default_limits(struct queue_limits *lim);
+void blk_apply_bdi_limits(struct backing_dev_info *bdi,
+		struct queue_limits *lim);
 int blk_dev_init(void);
 
 /*
diff --git a/block/genhd.c b/block/genhd.c
index 8f1f3c6b4d6729..4dc95a46350532 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -524,7 +524,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		disk->part0->bd_dev = MKDEV(disk->major, disk->first_minor);
 	}
 
-	disk_update_readahead(disk);
+	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
 	disk_add_events(disk);
 	set_bit(GD_ADDED, &disk->state);
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a7e9d9c16d78b..e23fc418bb2260 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -972,7 +972,6 @@ static inline void blk_queue_disable_write_zeroes(struct request_queue *q)
 /*
  * Access functions for manipulating queue properties
  */
-void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-- 
2.43.0

