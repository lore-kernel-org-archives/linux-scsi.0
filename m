Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC5BC43470
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7CF61421
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhELGUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 02:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhELGUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 02:20:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D3FC06174A;
        Tue, 11 May 2021 23:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+Vapaqohy9BlIzoJHnQ0Ym+FL+eDAEgHBLsFwnOQMbg=; b=C7Rl+bXEyFe/bLSkLZViB43fWd
        67auSaEhCh0YOyw3y8ciVzW4hD9n/qnNwOh4EJ/jZSVayEviQ0tYYdftpv+OixUUgBkQyAh8V+aOc
        6j6ANi5wh23labS2RLzVC1x1b8AKjIaNf5hUcDDXWdSPHb4mu8Vov8sBjiEAGygumzlKd5i+JmgLK
        MDhrXEG1yTWqSPdl/rIKGEniMIp6/ZojJYZFbwP0cSySoMYqdBe04afsWacG5s6C+PtXZSydJe672
        zVn6XXlLkJVpIlaIMzJg9328cKobjSd9z/J5xP8dx2LoNSOVtcF9wj1us9S6gOLdFf1lg68K69zbK
        tuMHg21A==;
Received: from [2001:4bb8:198:fbc8:1036:7ab9:f97a:adbc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgiD9-00A8sD-M2; Wed, 12 May 2021 06:19:12 +0000
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
Subject: [PATCH 5/8] block: split __blkdev_put
Date:   Wed, 12 May 2021 08:18:53 +0200
Message-Id: <20210512061856.47075-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512061856.47075-1-hch@lst.de>
References: <20210512061856.47075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split __blkdev_put into one helper for the whole device, and one for
partitions as well as another shared helper for flushing the block
device inode mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 58 ++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 59cdcdb97e3d..4bcab845ac05 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1234,7 +1234,13 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode);
+static void blkdev_flush_mapping(struct block_device *bdev)
+{
+	WARN_ON_ONCE(bdev->bd_holders);
+	sync_blockdev(bdev);
+	kill_bdev(bdev);
+	bdev_write_inode(bdev);
+}
 
 int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 {
@@ -1313,6 +1319,14 @@ static int blkdev_get_whole(struct block_device *bdev, fmode_t mode)
 	return 0;;
 }
 
+static void blkdev_put_whole(struct block_device *bdev, fmode_t mode)
+{
+	if (!--bdev->bd_openers)
+		blkdev_flush_mapping(bdev);
+	if (bdev->bd_disk->fops->release)
+		bdev->bd_disk->fops->release(bdev->bd_disk, mode);
+}
+
 static int blkdev_get_part(struct block_device *part, fmode_t mode)
 {
 	struct gendisk *disk = part->bd_disk;
@@ -1340,12 +1354,24 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	return 0;
 
 out_blkdev_put:
-	__blkdev_put(whole, mode);
+	blkdev_put_whole(whole, mode);
 out_put_whole:
 	bdput(whole);
 	return ret;
 }
 
+static void blkdev_put_part(struct block_device *part, fmode_t mode)
+{
+	struct block_device *whole = bdev_whole(part);
+
+	if (--part->bd_openers)
+		return;
+	blkdev_flush_mapping(part);
+	whole->bd_part_count--;
+	blkdev_put_whole(whole, mode);
+	bdput(whole);
+}
+
 struct block_device *blkdev_get_no_open(dev_t dev)
 {
 	struct block_device *bdev;
@@ -1543,29 +1569,6 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	return 0;
 }
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode)
-{
-	struct gendisk *disk = bdev->bd_disk;
-	struct block_device *victim = NULL;
-
-	if (!--bdev->bd_openers) {
-		WARN_ON_ONCE(bdev->bd_holders);
-		sync_blockdev(bdev);
-		kill_bdev(bdev);
-		bdev_write_inode(bdev);
-		if (bdev_is_partition(bdev))
-			victim = bdev_whole(bdev);
-	}
-
-	if (!bdev_is_partition(bdev) && disk->fops->release)
-		disk->fops->release(disk, mode);
-	if (victim) {
-		victim->bd_part_count--;
-		__blkdev_put(victim, mode);
-		bdput(victim);
-	}
-}
-
 void blkdev_put(struct block_device *bdev, fmode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
@@ -1619,7 +1622,10 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 */
 	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
 
-	__blkdev_put(bdev, mode);
+	if (bdev_is_partition(bdev))
+		blkdev_put_part(bdev, mode);
+	else
+		blkdev_put_whole(bdev, mode);
 	mutex_unlock(&disk->open_mutex);
 
 	blkdev_put_no_open(bdev);
-- 
2.30.2

