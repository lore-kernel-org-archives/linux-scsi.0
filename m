Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B37C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A4961421
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhELGUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 02:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhELGUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 02:20:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C6CC061574;
        Tue, 11 May 2021 23:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=B+5tkY5tw2S4HJHnkMc6PL3oNijTONpmxe9JqSixljU=; b=l9lhuXjC3c4UQqcvVisNqapoqh
        wwNBhQcvKW/GYiIw1aeNVAUh3qcXf7LywlALlt47R/KS38F+bt2Rs+0leG1UXRGGpmXZGlxatZozk
        eOeYFuz1MvG5P9a8vIfM+rZ792OIzKJ0YBNza1uFfiV6ZneBKgHKfpHrafNbfxCX0KvxvXQTaJODv
        QXgKfd4qpbTXKFHlMtVxCvBRJn2KwuOO6fVzEa73QRaElz74WPmfkjuAHAJaSMbjGXGxU+Sj7se2Z
        wUzricQVYompesjBTjg/an2DtTZUjQJ9Vo+tGnQn018/pgWbEAI1G2pgcaZw2VvkyYVlMvp/ujAD+
        3FP3iq1Q==;
Received: from [2001:4bb8:198:fbc8:1036:7ab9:f97a:adbc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgiD1-00A8rg-KP; Wed, 12 May 2021 06:19:04 +0000
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
Subject: [PATCH 2/8] block: move sync_blockdev from __blkdev_put to blkdev_put
Date:   Wed, 12 May 2021 08:18:50 +0200
Message-Id: <20210512061856.47075-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512061856.47075-1-hch@lst.de>
References: <20210512061856.47075-1-hch@lst.de>
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
index d053510d2f6a..95fde785dae7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1553,16 +1553,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
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
@@ -1589,6 +1579,16 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
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
2.30.2

