Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D028BC4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCDE61964
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhC3QSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbhC3QSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:18:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AD6C061574;
        Tue, 30 Mar 2021 09:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4L2qT1khKY2QTFz1lzxiescWjxM5Qi1GFLY/dRNxlyc=; b=QWtp3pC/JljBgg0SwzE0JD6MTD
        6t5Kalb+rtVodDwmuWpDBBBMlhGRVttYpNAyuX2d+ZjHYgnL4wHK6AnVoU/Iz2tIUAbW4UgYaFSLl
        tOPmMoyKortlmnCXTEZ7j2gRof0TE4fKLclbumoAgoSv0cHR8kbFN3R1TEWXcUEt/zPEyfDwl38l1
        ZrJX3lWg956OafIh51eD8JSq5BKqEnmsokKiubXD5J+Qq7g1tN/w2yTU8Qt+QSxYaLhDYnh4AOR/8
        6YWZRlla7mLYzGdoJ18jkTlPO6awHSm1ypZ4s7I5Nu2974kTXKPI11u7KTCYXNtM2nLbfGOelTX9D
        fIuUWVOw==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH40-008aL2-3v; Tue, 30 Mar 2021 16:17:56 +0000
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
Subject: [PATCH 09/15] block: move sync_blockdev from __blkdev_put to blkdev_put
Date:   Tue, 30 Mar 2021 18:17:21 +0200
Message-Id: <20210330161727.2297292-10-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do the early unlocked syncing even earlier to move more code out of
the recursive path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d732001285201a..691eef20a7ced7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1547,16 +1547,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
-	/*
-	 * Sync early if it looks like we're the last one.  If someone else
-	 * opens the block device between now and the decrement of bd_openers
-	 * then we did a sync that we didn't need to, but that's not the end
-	 * of the world and we want to avoid long (could be several minute)
-	 * syncs while holding the mutex.
-	 */
-	if (bdev->bd_openers == 1)
-		sync_blockdev(bdev);
-
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (for_part)
 		bdev->bd_part_count--;
@@ -1583,6 +1573,16 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
 
+	/*
+	 * Sync early if it looks like we're the last one.  If someone else
+	 * opens the block device between now and the decrement of bd_openers
+	 * then we did a sync that we didn't need to, but that's not the end
+	 * of the world and we want to avoid long (could be several minute)
+	 * syncs while holding the mutex.
+	 */
+	if (bdev->bd_openers == 1)
+		sync_blockdev(bdev);
+
 	mutex_lock(&bdev->bd_mutex);
 
 	if (mode & FMODE_EXCL) {
-- 
2.30.1

