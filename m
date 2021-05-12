Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BF7C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6536191D
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 06:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhELGU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 02:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhELGU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 02:20:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FB0C061574;
        Tue, 11 May 2021 23:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/WYzGEJJ/cmKCrP3iUVzHZwPmYOPPUAj6xt9dHQlObY=; b=ILMSfQv44k8X/PhjoykDFvXxqI
        FTaIWFIgpGyMdaXoDQvg56V0y83ck2s8nAvfKLtvxNM+K5P0IZHs23eDMke1g+qFcNsA8fw1TOA6q
        WWp2LEilrnQ1SZLrMhMSvrRSAzTCnVnifzPyQ6jDxLEa1AWH2p6txuLaEITsqAm0a09Il1m+qHJ++
        NuXtJUMo61cRZlPjBwajGoCnhkwIehV4IOwiXTpC/G1y1jWWqw5v+DmQ7imx4t2mvHPJfZ1BVPN6j
        FEPCP33IcXUK2CjeQTKZ0noimB17Fyv1qKPkvlp3es1QZQkjbOVRncB40JYlhLAErC9bdSlk6SOJa
        uk60twAw==;
Received: from [2001:4bb8:198:fbc8:1036:7ab9:f97a:adbc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgiDC-00A8sd-Eu; Wed, 12 May 2021 06:19:15 +0000
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
Subject: [PATCH 6/8] block: move bd_part_count to struct gendisk
Date:   Wed, 12 May 2021 08:18:54 +0200
Message-Id: <20210512061856.47075-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512061856.47075-1-hch@lst.de>
References: <20210512061856.47075-1-hch@lst.de>
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
 block/ioctl.c             | 2 +-
 fs/block_dev.c            | 6 +++---
 include/linux/blk_types.h | 3 ---
 include/linux/genhd.h     | 1 +
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 8ba1ed8defd0..24beec9ca9c9 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -89,7 +89,7 @@ static int blkdev_reread_part(struct block_device *bdev, fmode_t mode)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (bdev->bd_part_count)
+	if (bdev->bd_disk->open_partitions)
 		return -EBUSY;
 
 	/*
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4bcab845ac05..8dd8e2fd1401 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1250,7 +1250,7 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 	lockdep_assert_held(&disk->open_mutex);
 
 rescan:
-	if (bdev->bd_part_count)
+	if (disk->open_partitions)
 		return -EBUSY;
 	sync_blockdev(bdev);
 	invalidate_bdev(bdev);
@@ -1345,7 +1345,7 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 	if (!(disk->flags & GENHD_FL_UP) || !bdev_nr_sectors(part))
 		goto out_blkdev_put;
 
-	whole->bd_part_count++;
+	disk->open_partitions++;
 	set_init_blocksize(part);
 	if (part->bd_bdi == &noop_backing_dev_info)
 		part->bd_bdi = bdi_get(disk->queue->backing_dev_info);
@@ -1367,7 +1367,7 @@ static void blkdev_put_part(struct block_device *part, fmode_t mode)
 	if (--part->bd_openers)
 		return;
 	blkdev_flush_mapping(part);
-	whole->bd_part_count--;
+	whole->bd_disk->open_partitions--;
 	blkdev_put_whole(whole, mode);
 	bdput(whole);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a09660671fa4..fd3860d18d7e 100644
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
index 0747f1853f39..74fd28ddac70 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -155,6 +155,7 @@ struct gendisk {
 #define GD_READ_ONLY			1
 
 	struct mutex open_mutex;	/* open/close mutex */
+	unsigned open_partitions;	/* number of open partitions */
 
 	struct kobject *slave_dir;
 
-- 
2.30.2

