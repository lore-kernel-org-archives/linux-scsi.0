Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9318C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbhKVNJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbhKVNJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B581C061714;
        Mon, 22 Nov 2021 05:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bAb+JD+ooWjn8lt6VBuD1QqrjOcpbK8moceL7wbn6hI=; b=pK1SCNUroNUE4I0Y0GqwVVwyIK
        cwJcCvRggKmybYx5Wet6+hLPQJ34tV6uULwJPH535pdnXh/qRAQV73V/QcYs1iLvMt0EZ3hb73ShM
        16gU2szXGuNOJNgm70uItjvKzrcnKEkKyPD0G7irZaPkWsm2FRZ35ybwxQZQOSZH3w1pN26Tms3uS
        +b444edcwTgJ+5i1Y8SOpL9qtlHIuhIysU09J2JlhNmWR0VDbEFdv9POaXH51WW9+29g9e8iwizj9
        W69epPFwvacRFvXLcExFzKbsKVHEGWf3kY4f/CDoKaogwvuFiozN15rdVQRB7cKAWptpxIDyQDv6u
        PjlHyK0w==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91k-00Crr8-CB; Mon, 22 Nov 2021 13:06:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 05/14] block: merge disk_scan_partitions and blkdev_reread_part
Date:   Mon, 22 Nov 2021 14:06:16 +0100
Message-Id: <20211122130625.1136848-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unify the functionality that implements a partition rescan for a
gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h   |  1 +
 block/genhd.c | 19 ++++++++++++-------
 block/ioctl.c | 31 +++++--------------------------
 3 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 296e3010f8d65..cb436dd017ae8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -449,6 +449,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		unsigned int max_sectors, bool *same_page);
 
 struct request_queue *blk_alloc_queue(int node_id);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
diff --git a/block/genhd.c b/block/genhd.c
index b1c0f62505bf0..0cf3d30429e14 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -372,17 +372,21 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-static void disk_scan_partitions(struct gendisk *disk)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
 
-	if (!get_capacity(disk) || !disk_part_scan_enabled(disk))
-		return;
+	if (!disk_part_scan_enabled(disk))
+		return -EINVAL;
+	if (disk->open_partitions)
+		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
-	bdev = blkdev_get_by_dev(disk_devt(disk), FMODE_READ, NULL);
-	if (!IS_ERR(bdev))
-		blkdev_put(bdev, FMODE_READ);
+	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+	blkdev_put(bdev, mode);
+	return 0;
 }
 
 /**
@@ -509,7 +513,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 			goto out_unregister_bdi;
 
 		bdev_add(disk->part0, ddev->devt);
-		disk_scan_partitions(disk);
+		if (get_capacity(disk))
+			disk_scan_partitions(disk, FMODE_READ);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
diff --git a/block/ioctl.c b/block/ioctl.c
index 0a1d10ac2e1a5..4a86340133e46 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -82,31 +82,6 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 }
 #endif
 
-static int blkdev_reread_part(struct block_device *bdev, fmode_t mode)
-{
-	struct block_device *tmp;
-
-	if (!disk_part_scan_enabled(bdev->bd_disk) || bdev_is_partition(bdev))
-		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (bdev->bd_disk->open_partitions)
-		return -EBUSY;
-
-	/*
-	 * Reopen the device to revalidate the driver state and force a
-	 * partition rescan.
-	 */
-	mode &= ~FMODE_EXCL;
-	set_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
-
-	tmp = blkdev_get_by_dev(bdev->bd_dev, mode, NULL);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-	blkdev_put(tmp, mode);
-	return 0;
-}
-
 static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 		unsigned long arg, unsigned long flags)
 {
@@ -522,7 +497,11 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 		bdev->bd_disk->bdi->ra_pages = (arg * 512) / PAGE_SIZE;
 		return 0;
 	case BLKRRPART:
-		return blkdev_reread_part(bdev, mode);
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		if (bdev_is_partition(bdev))
+			return -EINVAL;
+		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
-- 
2.30.2

