Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDB4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354D9619C7
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhC3QSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhC3QSM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:18:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D78C061574;
        Tue, 30 Mar 2021 09:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=clkaBMHqFEToWoG3RDL6mkbv+bLYy50wIeoj77viXRA=; b=c3AcMH2v35AJV6QxSMjXVIjS3c
        xMGVOnpEA1YpVnz6WJU3lezlXMW0RilNWPUgV7xmP2S1UmvywCdmpnhUngNhTlr593ZbiaZt3kOXx
        1tRbtPGxTu4NTDfMciddtxSaYmSgx09AvUYjZQsuuZs5udhMxbC9Oq39h8diYJ6rgLeBT4HtlVi5D
        idX2moOu2jO7BFNsBTBUyl9O2H0t0Sg0wgpsIH9CA0Duv4evm4Fvv43krUoIxBIdU9bgLow67TYM4
        BAAhZV597MjoXiqzCYf2+FyFVjBaKBUAkszJTV+1NJC9Mejda6jwlNMoKNIcDJoIeWy/lJUStHbNL
        BOuCjqGA==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH4A-008aMG-LY; Tue, 30 Mar 2021 16:18:07 +0000
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
Subject: [PATCH 13/15] block: move bd_part_count to struct gendisk
Date:   Tue, 30 Mar 2021 18:17:25 +0200
Message-Id: <20210330161727.2297292-14-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The bd_part_count value only makes sense for whole devices, so move it
to struct gendisk and give it a more descriptive name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/core.c   | 2 +-
 fs/block_dev.c            | 4 ++--
 include/linux/blk_types.h | 3 ---
 include/linux/genhd.h     | 1 +
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 60388a41ff92a3..162b9b35c53171 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -527,7 +527,7 @@ int blk_drop_partitions(struct block_device *bdev)
 	struct disk_part_iter piter;
 	struct block_device *part;
 
-	if (bdev->bd_part_count)
+	if (bdev->bd_disk->open_partitions)
 		return -EBUSY;
 
 	sync_blockdev(bdev);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ade5a180ff62d3..6d7e3bd7cb7ce3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1339,7 +1339,7 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	if (!(disk->flags & GENHD_FL_UP) || !bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
-	whole->bd_part_count++;
+	disk->open_partitions++;
 	set_init_blocksize(part);
 	if (part->bd_bdi == &noop_backing_dev_info)
 		part->bd_bdi = bdi_get(disk->queue->backing_dev_info);
@@ -1361,7 +1361,7 @@ static void blkdev_put_part(struct block_device *part, fmode_t mode)
 	if (--part->bd_openers)
 		return;
 	blkdev_flush_mapping(part);
-	whole->bd_part_count--;
+	whole->bd_disk->open_partitions--;
 	blkdev_put_whole(whole, mode);
 	bdput(whole);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a09660671fa47e..fd3860d18d7ed7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,9 +39,6 @@ struct block_device {
 #endif
 	struct kobject		*bd_holder_dir;
 	u8			bd_partno;
-	/* number of times partitions within this device have been opened. */
-	unsigned		bd_part_count;
-
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	struct gendisk *	bd_disk;
 	struct backing_dev_info *bd_bdi;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02ea04144ece7b..146d2dafdccd58 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -155,6 +155,7 @@ struct gendisk {
 #define GD_READ_ONLY			1
 
 	struct mutex open_mutex;	/* open/close mutex */
+	unsigned open_partitions;	/* number of open partitions */
 
 	struct kobject *slave_dir;
 
-- 
2.30.1

