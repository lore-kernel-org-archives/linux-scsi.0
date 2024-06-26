Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BA185E79;
	Wed, 26 Jun 2024 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412030; cv=none; b=peVL2zgHCx9ELgro0Ylalb0hTHxVfNNhCI1znEbR/fDz44z05x/ZmydlORSmfjtlLptly8p6va77I3/JtzjhX5iFcMdeGGU3OcDSz6CH54R0tyddd7g7XFIAMRvq3tvbCeAp5+Zt+pApGmTcuaIynYgkGCz1ntqluEFz4iowph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412030; c=relaxed/simple;
	bh=/YnDBnNDsFzTqwwN8r1JTP97sVf7rdYp7DBVS0xfxNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZourjNIfV642Xvbr4SIzCFfqm430EvypJydR6m3lyNn6wUOzdLWsnC05s/TZ8HRzUfFgrFZWS0cyT98wdV2tTtDdyN4jVn/aOVbeCvkn0ogmEMbTTWvGvjAlK6uwvSthSXZs6CYWdolSp6f36qiCKT2Z5tF71Ir8n+Gjkzbv5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lkkWJXL7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lkkWJXL7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OsiVQjjagKPX+E+jBCOu2LbKBRYJI4cy3HLotlU+qq4=; b=lkkWJXL7b16baBhu37jV0OCi4V
	Zj31aWQCG/A6BjiPSLcqkkuwZ6Libl6g6zmafPl6xjFd3rJS4cDGGg2nRS0gLvLqCvzILJOYy1g68
	KYia5xl8XLAJ/Mi4pk3F6Gfj/nVrd43P314ojd/+2qJ0TQbFobDVDIcIDdVW2Wda8/ro4vw5EsmoK
	8BWcmnk+t2H01S70oiOdC7aDKN+wD38kpx9KmJUtfp0WFDmirKdG7/jqYvsJdIPLvfl+EBnYHJIdi
	MSaC4mCb8QDER9nNUsqCu5Mlprzcr43ySNm6Y8ojDRqFpJb0KGVbwc2wHhcYgbqtWFvgDxB+hIrc/
	PZ750NPg==;
Received: from [2001:4bb8:2cd:5bfc:fac4:f2e7:8d6c:958e] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMTc2-000000079iO-2qJa;
	Wed, 26 Jun 2024 14:27:07 +0000
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
Subject: [PATCH 6/8] block: remove disk_update_readahead
Date: Wed, 26 Jun 2024 16:26:27 +0200
Message-ID: <20240626142637.300624-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240626142637.300624-1-hch@lst.de>
References: <20240626142637.300624-1-hch@lst.de>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-settings.c   | 8 +-------
 block/blk.h            | 2 ++
 block/genhd.c          | 2 +-
 include/linux/blkdev.h | 1 -
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c2221b7406d46a..c692e80bb4f890 100644
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
index b37826b350a2e3..6b88382012e958 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -973,7 +973,6 @@ static inline void blk_queue_disable_write_zeroes(struct request_queue *q)
 /*
  * Access functions for manipulating queue properties
  */
-void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-- 
2.43.0

