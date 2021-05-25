Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9015CC47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749A061413
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhEYGOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 02:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhEYGOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 02:14:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE868C061574;
        Mon, 24 May 2021 23:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yioblpsUEzu4cvchBoxhftZbC6yA55K4Z79uLhl2l6Y=; b=C7BGMARjYrq9AYXLrH/kJ8+BCb
        3gMekEyybo13xqtQZ8DSLHpdEFHQCpdLCC+dw+ld+3c14NFSGQKu1Wfb9PBgOaYuWgeXC6f5dr3lY
        Ro+IjzYvDMf5S8AJI6YH0PshxKZuG+N/Th2aIMWkXXsb3KN5ZmjFt62iS0rC66Qd/HsU6SyJB1H2/
        Sbfs9nF1LrwgbPliGGU/SKW0DwL+T/0M7C+vXL85xCbpxzm/Ev6CO1vB0+OOPmnfMYHoQdDyekbnQ
        tarJLT2z1FN7xvQ/AsArmYvbQJY86QInOCkPrd6YJDAo32PgFvCJB1512+v4fYITl0uOj5temX0y1
        CRIF08OQ==;
Received: from [2001:4bb8:190:7543:af90:8b76:7e65:6578] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llQJR-003Z9P-K2; Tue, 25 May 2021 06:13:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/8] block: move sync_blockdev from __blkdev_put to blkdev_put
Date:   Tue, 25 May 2021 08:12:55 +0200
Message-Id: <20210525061301.2242282-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525061301.2242282-1-hch@lst.de>
References: <20210525061301.2242282-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do the early unlocked syncing even earlier to move more code out of
the recursive path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 fs/block_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2b5073e3c923..41d2d9708bf8 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1552,16 +1552,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
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
@@ -1588,6 +1578,16 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
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

