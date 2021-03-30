Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08595C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D4C619D0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhC3QSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhC3QSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:18:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967FFC061574;
        Tue, 30 Mar 2021 09:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DR3bXdoncb3KtK31aymdGf021lSb+B3vycacX+odNEI=; b=v9lNyRvjEg3vEVykjmUbcYxEWb
        X2j1HSB1aBr+6sn3gnSUEpFezPocqVgYDehDr9BffT+atPjQYFau+lpRGBczJN1fwe85gakG8an+J
        +xon6a2wZ4Kamg0mD4oOPS3vBFS8JRwc1az8dCBCAyTFTciZV5hIMJZRPLQFR1fU2LhEpMNX0vKld
        wZw4PLuO3OL3kDGQbENWvk3yCdJX0Y7WtPSAn1NKFrLS3lCJoF+U5adPDH/neQZjS4rJzP7j+D/2U
        Pee4Ywf9wCA4ondXAD3fVYOvaw7IAVUFWGXpdf0XSJBoTAx41bmQbSYrSDa3jVwI5CDpq6UtYFd2f
        WMFJ/Y9A==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH48-008aM8-0Q; Tue, 30 Mar 2021 16:18:04 +0000
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
Subject: [PATCH 12/15] block: split __blkdev_put
Date:   Tue, 30 Mar 2021 18:17:24 +0200
Message-Id: <20210330161727.2297292-13-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
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
index 044e9200783e2d..ade5a180ff62d3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1230,7 +1230,13 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
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
@@ -1307,6 +1313,14 @@ static int blkdev_get_whole(struct block_device *bdev, fmode_t mode)
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
@@ -1334,12 +1348,24 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
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
@@ -1537,29 +1563,6 @@ static int blkdev_open(struct inode * inode, struct file * filp)
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
@@ -1613,7 +1616,10 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
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
2.30.1

