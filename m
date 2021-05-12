Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B211DC43470
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 923A661433
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELGUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 02:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhELGUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 02:20:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC340C061574;
        Tue, 11 May 2021 23:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6saAPsU6kJh2c9PPvGH8Mdntk/kERHTUb6DGNS1VeY0=; b=cMVDvHhi8JTmt30+GKLoPy56eI
        XEKOdQWniksyLZzUZp3OIds1mubW1LMKv0XGiTYJ7QUaC8bB8Upz0kdk6d6mrvoe5t0YItYDAtxG1
        MVR4zoY/ROrHLX8y9ykvMijS46BLsjbRsBitFfUX8AYjr8FsIVKL5UhzgfVa/vUnqiZq3U7xAvERh
        JYbNttsbdTCUowa1JEP8vm44/9EwwZ0iduB4daLXUqvCRpG8aYMBOUGs6iM64q44GD+j3Hm5m4bfC
        rKDC5UDq3zh842V3YaT9Ehl4vPS9QpslOZQVGXhHwusgS+jPfdyKT12T8vhq4iX98CFtiaqjAEExM
        GlLBacLQ==;
Received: from [2001:4bb8:198:fbc8:1036:7ab9:f97a:adbc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgiCz-00A8rW-12; Wed, 12 May 2021 06:19:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/8] block: split __blkdev_get
Date:   Wed, 12 May 2021 08:18:49 +0200
Message-Id: <20210512061856.47075-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512061856.47075-1-hch@lst.de>
References: <20210512061856.47075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split __blkdev_get into one helper for the whole device, and one for
opening partitions.  This removes the (bounded) recursion when opening
a partition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 115 +++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 60 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index b8abccd03e5d..d053510d2f6a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1287,76 +1287,68 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
  */
 EXPORT_SYMBOL_GPL(bdev_disk_changed);
 
-/*
- * bd_mutex locking:
- *
- *  mutex_lock(part->bd_mutex)
- *    mutex_lock_nested(whole->bd_mutex, 1)
- */
-static int __blkdev_get(struct block_device *bdev, fmode_t mode)
+static int blkdev_get_whole(struct block_device *bdev, fmode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	int ret = 0;
 
-	if (!bdev->bd_openers) {
-		if (!bdev_is_partition(bdev)) {
-			ret = 0;
-			if (disk->fops->open)
-				ret = disk->fops->open(bdev, mode);
-
-			if (!ret)
-				set_init_blocksize(bdev);
-
-			/*
-			 * If the device is invalidated, rescan partition
-			 * if open succeeded or failed with -ENOMEDIUM.
-			 * The latter is necessary to prevent ghost
-			 * partitions on a removed medium.
-			 */
-			if (test_bit(GD_NEED_PART_SCAN, &disk->state) &&
-			    (!ret || ret == -ENOMEDIUM))
-				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
-
-			if (ret)
-				return ret;
-		} else {
-			struct block_device *whole = bdgrab(disk->part0);
-
-			mutex_lock_nested(&whole->bd_mutex, 1);
-			ret = __blkdev_get(whole, mode);
-			if (ret) {
-				mutex_unlock(&whole->bd_mutex);
-				bdput(whole);
-				return ret;
-			}
-			whole->bd_part_count++;
-			mutex_unlock(&whole->bd_mutex);
-
-			if (!(disk->flags & GENHD_FL_UP) ||
-			    !bdev_nr_sectors(bdev)) {
-				__blkdev_put(whole, mode, 1);
-				bdput(whole);
-				return -ENXIO;
-			}
-			set_init_blocksize(bdev);
+	if (disk->fops->open) {
+		ret = disk->fops->open(bdev, mode);
+		if (ret) {
+			/* avoid ghost partitions on a removed medium */
+			if (ret == -ENOMEDIUM &&
+			     test_bit(GD_NEED_PART_SCAN, &disk->state))
+				bdev_disk_changed(bdev, true);
+			return ret;
 		}
+	}
 
+	if (!bdev->bd_openers) {
+		set_init_blocksize(bdev);
 		if (bdev->bd_bdi == &noop_backing_dev_info)
 			bdev->bd_bdi = bdi_get(disk->queue->backing_dev_info);
-	} else {
-		if (!bdev_is_partition(bdev)) {
-			if (bdev->bd_disk->fops->open)
-				ret = bdev->bd_disk->fops->open(bdev, mode);
-			/* the same as first opener case, read comment there */
-			if (test_bit(GD_NEED_PART_SCAN, &disk->state) &&
-			    (!ret || ret == -ENOMEDIUM))
-				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
-			if (ret)
-				return ret;
-		}
 	}
+	if (test_bit(GD_NEED_PART_SCAN, &disk->state))
+		bdev_disk_changed(bdev, false);
 	bdev->bd_openers++;
+	return 0;;
+}
+
+static int blkdev_get_part(struct block_device *part, fmode_t mode)
+{
+	struct gendisk *disk = part->bd_disk;
+	struct block_device *whole;
+	int ret;
+
+	if (part->bd_openers)
+		goto done;
+
+	whole = bdgrab(disk->part0);
+	mutex_lock_nested(&whole->bd_mutex, 1);
+	ret = blkdev_get_whole(whole, mode);
+	if (ret) {
+		mutex_unlock(&whole->bd_mutex);
+		goto out_put_whole;
+	}
+	whole->bd_part_count++;
+	mutex_unlock(&whole->bd_mutex);
+
+	ret = -ENXIO;
+	if (!(disk->flags & GENHD_FL_UP) || !bdev_nr_sectors(part))
+		goto out_blkdev_put;
+
+	set_init_blocksize(part);
+	if (part->bd_bdi == &noop_backing_dev_info)
+		part->bd_bdi = bdi_get(disk->queue->backing_dev_info);
+done:
+	part->bd_openers++;
 	return 0;
+
+out_blkdev_put:
+	__blkdev_put(whole, mode, 1);
+out_put_whole:
+	bdput(whole);
+	return ret;
 }
 
 struct block_device *blkdev_get_no_open(dev_t dev)
@@ -1450,7 +1442,10 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 	disk_block_events(disk);
 
 	mutex_lock(&bdev->bd_mutex);
-	ret =__blkdev_get(bdev, mode);
+	if (bdev_is_partition(bdev))
+		ret = blkdev_get_part(bdev, mode);
+	else
+		ret = blkdev_get_whole(bdev, mode);
 	if (ret)
 		goto abort_claiming;
 	if (mode & FMODE_EXCL) {
-- 
2.30.2

