Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178F5C4708E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CBA6141C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhEYGOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 02:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhEYGOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 02:14:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B86BC06138C;
        Mon, 24 May 2021 23:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+b2Ihu9Ah4QIgUpxG+BjRrQUDlNLr1vvWZBQ/fchfLI=; b=E+aNSlQM3yvg/t7OuLmcGPNEVN
        y4VY2TQ1avVaykzOpRU9wf0f8GHSX+qrWUVpWvVAFiA8f6eLMTtWDN+QqaNrxkZynQc6qH/uTCg0r
        34ZZrdkqjsKIpZ2BD/OiI4YBh5zO97Uh6zeWyR530L4UtwwulZdXsGBE0lE4Z1CTrC/bhk5xM23K/
        xltRF52FErJnthV/NeCF2Zdrz/vEBdqKm9IBZ/XFgIyuJrW5WMUGVzHFAtwaXfisurTCRQWO5A+LA
        XbQxcfLuTf/kSw2zWhUQjRpA0NBjB8ji/mxXKLZU/Ho8qBr5HMGOp0VNFKXrXtfaKxDtNJ6TWfpHI
        x8YJztNw==;
Received: from [2001:4bb8:190:7543:af90:8b76:7e65:6578] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llQJX-003ZBI-Be; Tue, 25 May 2021 06:13:15 +0000
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
Subject: [PATCH 4/8] block: move adjusting bd_part_count out of __blkdev_get
Date:   Tue, 25 May 2021 08:12:57 +0200
Message-Id: <20210525061301.2242282-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525061301.2242282-1-hch@lst.de>
References: <20210525061301.2242282-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Keep in the callers and thus remove the for_part argument.  This mirrors
what is done on the blkdev_get side and slightly simplifies
blkdev_get_part as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index e094806c3a0c..43dce929e7ee 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1234,7 +1234,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
+static void __blkdev_put(struct block_device *bdev, fmode_t mode);
 
 int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 {
@@ -1329,12 +1329,12 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	ret = blkdev_get_whole(whole, mode);
 	if (ret)
 		goto out_put_whole;
-	whole->bd_part_count++;
 
 	ret = -ENXIO;
 	if (!bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
+	whole->bd_part_count++;
 	set_init_blocksize(part);
 	if (part->bd_bdi == &noop_backing_dev_info)
 		part->bd_bdi = bdi_get(disk->queue->backing_dev_info);
@@ -1343,7 +1343,7 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	return 0;
 
 out_blkdev_put:
-	__blkdev_put(whole, mode, 1);
+	__blkdev_put(whole, mode);
 out_put_whole:
 	bdput(whole);
 	return ret;
@@ -1542,14 +1542,11 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	return 0;
 }
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
+static void __blkdev_put(struct block_device *bdev, fmode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
-	if (for_part)
-		bdev->bd_part_count--;
-
 	if (!--bdev->bd_openers) {
 		WARN_ON_ONCE(bdev->bd_holders);
 		sync_blockdev(bdev);
@@ -1562,7 +1559,8 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!bdev_is_partition(bdev) && disk->fops->release)
 		disk->fops->release(disk, mode);
 	if (victim) {
-		__blkdev_put(victim, mode, 1);
+		victim->bd_part_count--;
+		__blkdev_put(victim, mode);
 		bdput(victim);
 	}
 }
@@ -1620,7 +1618,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 */
 	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
 
-	__blkdev_put(bdev, mode, 0);
+	__blkdev_put(bdev, mode);
 	mutex_unlock(&disk->open_mutex);
 
 	blkdev_put_no_open(bdev);
-- 
2.30.2

