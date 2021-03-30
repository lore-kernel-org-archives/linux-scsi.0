Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4645EC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE7A61964
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhC3QSZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhC3QSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:18:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2188FC061574;
        Tue, 30 Mar 2021 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0hz+oDJxzJNnnCNG5wv/fs44kE+rx0ZokkFFA5WwtJk=; b=Op8NfLVeV35UGonqFocC6m6jkl
        rwDvaREhNDpaOTJX6xzZkEl18YP4kQmNJLF6mWtaXPv+AlsnMCWFymbIJYMNm5gxLyhutQCvgapDv
        a+/MR0bwOAuzUEHofTANtATu48mYShwzPNek9Qqz1n2PaUHdI5YQJi36e5883/XZSB30VuO8LwDEL
        ueDBkKGmPsmSL+c/SOkOJQ0IeF/zrfqC+s8OKCKofF+EO/QX7GE6uvSAxt4+pTy084Zu6aPNvsNF1
        zYH2t7wUbGOFRuI84xZM4B4S72uCOYzxts/+TFRFsgtRB5kdeYAJvgQS0jP0MGPiVKklfSpzljnl1
        xwZ4ewtQ==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH45-008aLx-L0; Tue, 30 Mar 2021 16:18:02 +0000
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
Subject: [PATCH 11/15] block: move adjusting bd_part_count out of __blkdev_get
Date:   Tue, 30 Mar 2021 18:17:23 +0200
Message-Id: <20210330161727.2297292-12-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
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
index 4113a27ad9e72d..044e9200783e2d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1230,7 +1230,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
-static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
+static void __blkdev_put(struct block_device *bdev, fmode_t mode);
 
 int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 {
@@ -1320,12 +1320,12 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
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
@@ -1334,7 +1334,7 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	return 0;
 
 out_blkdev_put:
-	__blkdev_put(whole, mode, 1);
+	__blkdev_put(whole, mode);
 out_put_whole:
 	bdput(whole);
 	return ret;
@@ -1537,14 +1537,11 @@ static int blkdev_open(struct inode * inode, struct file * filp)
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
@@ -1557,7 +1554,8 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!bdev_is_partition(bdev) && disk->fops->release)
 		disk->fops->release(disk, mode);
 	if (victim) {
-		__blkdev_put(victim, mode, 1);
+		victim->bd_part_count--;
+		__blkdev_put(victim, mode);
 		bdput(victim);
 	}
 }
@@ -1615,7 +1613,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 */
 	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
 
-	__blkdev_put(bdev, mode, 0);
+	__blkdev_put(bdev, mode);
 	mutex_unlock(&disk->open_mutex);
 
 	blkdev_put_no_open(bdev);
-- 
2.30.1

