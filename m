Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1887C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FAAF61998
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhC3QST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhC3QR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FEAC061574;
        Tue, 30 Mar 2021 09:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wyvsveFJFd0KZLp7KdKurjtBa2vepo+6NNJNYPMY29c=; b=r5W7bDCevkdsvhxdZSA3ht7hbP
        nPiWehDt+t3t5FWIydEZh+pshTyjDBaBfWPFAVbKk0oqKri0JxM01JiyEBRCeVYXuZ0klu63t3oZU
        pOQKHjMHvy286CTH++Gg10XPqfS95Mwaf83fL0//X/Te3mIa4lL1Cay7af9uMZAkTI4IgBqNnf+kX
        ZVmbaLw4Ud+dR4yvMOKCbD0w/0Xz01fTk9vcP9b6obOujnK2g7Zo2HCIW1M1gjqLV5Z4+IPB+KnLk
        56KPNw1BdSUVMXTcd5wbuD1z/AUaxtKkuG08xLLGLEgeij3lgJ7J2dmTGYKMTjumtZETu3CZs1KSr
        6+Kz4+jA==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3x-008aKu-A1; Tue, 30 Mar 2021 16:17:54 +0000
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
Subject: [PATCH 08/15] block: split __blkdev_get
Date:   Tue, 30 Mar 2021 18:17:20 +0200
Message-Id: <20210330161727.2297292-9-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
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
index 0c09b6517b20b7..d732001285201a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1281,76 +1281,68 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
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
@@ -1444,7 +1436,10 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
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
2.30.1

