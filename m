Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEAAC43462
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1374861433
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhELGUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 02:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 02:20:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FEEC061574;
        Tue, 11 May 2021 23:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8AXXXPzui4TiD0djzBg3A5JPaB8WEZdZR0JlpRgSLWM=; b=CdJGtVrGsNeyekmnqXgs8uZMQM
        x7NEdY5ZXzA6Zr0+ibAT+/wmOSd3MZZJb09iYucr+dQO/VzaaKHzULLD5j2dvCk6b5xn7gVcpizuK
        xHAXX89P5ANHWR600crj9erPiQeTPLdcQ+cG8nxiVPOonWyDVc9EwkWSqADiWIbnyJrfmlARGP2Qx
        Cc0CzU6N3JQtCpOKqW6DAux3jslsnubBhJM22XgH5O1oOq20P/t7YmAI3xdgaXO1jErDMcHXhiYLK
        bS7YLOpTwhzZs5TuQLV2AgemnipJ7qXA/4oInIN9WqLZxGy0OyK3lkVHcykEtUFFPKV0lo65RpC1X
        wUrvJ6+g==;
Received: from [2001:4bb8:198:fbc8:1036:7ab9:f97a:adbc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgiD6-00A8s0-VM; Wed, 12 May 2021 06:19:09 +0000
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
Date:   Wed, 12 May 2021 08:18:52 +0200
Message-Id: <20210512061856.47075-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512061856.47075-1-hch@lst.de>
References: <20210512061856.47075-1-hch@lst.de>
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
index 3597532cc081..59cdcdb97e3d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1234,7 +1234,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
+static void __blkdev_put(struct block_device *bdev, fmode_t mode);
 
 int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 {
@@ -1326,12 +1326,12 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	ret = blkdev_get_whole(whole, mode);
 	if (ret)
 		goto out_put_whole;
-	whole->bd_part_count++;
 
 	ret = -ENXIO;
 	if (!(disk->flags & GENHD_FL_UP) || !bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
+	whole->bd_part_count++;
 	set_init_blocksize(part);
 	if (part->bd_bdi == &noop_backing_dev_info)
 		part->bd_bdi = bdi_get(disk->queue->backing_dev_info);
@@ -1340,7 +1340,7 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	return 0;
 
 out_blkdev_put:
-	__blkdev_put(whole, mode, 1);
+	__blkdev_put(whole, mode);
 out_put_whole:
 	bdput(whole);
 	return ret;
@@ -1543,14 +1543,11 @@ static int blkdev_open(struct inode * inode, struct file * filp)
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
@@ -1563,7 +1560,8 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!bdev_is_partition(bdev) && disk->fops->release)
 		disk->fops->release(disk, mode);
 	if (victim) {
-		__blkdev_put(victim, mode, 1);
+		victim->bd_part_count--;
+		__blkdev_put(victim, mode);
 		bdput(victim);
 	}
 }
@@ -1621,7 +1619,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 */
 	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
 
-	__blkdev_put(bdev, mode, 0);
+	__blkdev_put(bdev, mode);
 	mutex_unlock(&disk->open_mutex);
 
 	blkdev_put_no_open(bdev);
-- 
2.30.2

