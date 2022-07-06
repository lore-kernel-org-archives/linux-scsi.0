Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9822C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiGFHEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiGFHED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:04:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8C2F42;
        Wed,  6 Jul 2022 00:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fIbuap1XjSHBxWPy76ctu7Qj+NuYi3Uw4BF3kwSbcMY=; b=ysxVf0/5qfN8m2GJbYcGYKwS0f
        hb32gkJt518FVIjtTV8mlQ/EuqkNkINMqdOctvbeZ8ZQWhGRSXS2gxfYpZFyEPJl2edPdZ8+UJp/W
        HPaIvSiA/LPVzaqh0QiO8KNPOqYkXT2Fq8ID5Sfja9Hqt7OXufY+OWxYW8+6H4sJmVu8cc/8ZETRO
        g9idOKTdDqDRzDbpYQBAMZatw7av7FKlxW4fanPeETymN3AqrLt2tMGT/Wr4UjZD3HMOrSs5DSzcr
        uUHCm+a8RT25AR9V998lvWDvEFtSx4bXASBQF/Mk+FRlf0QB3yu4hmfUBPO3DS3JdKC6RE2NF3O4l
        ljReagww==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4o-006ur8-86; Wed, 06 Jul 2022 07:03:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/16] block: call blk_queue_free_zone_bitmaps from disk_release
Date:   Wed,  6 Jul 2022 09:03:36 +0200
Message-Id: <20220706070350.1703384-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The zone bitmaps are only used for non-passthrough I/O, so free them as
soon as the disk is released.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-sysfs.c | 2 --
 block/genhd.c     | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 58cb9cb9f48cd..7590810cf13fc 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -776,8 +776,6 @@ static void blk_release_queue(struct kobject *kobj)
 	blk_free_queue_stats(q->stats);
 	kfree(q->poll_stat);
 
-	blk_queue_free_zone_bitmaps(q);
-
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
diff --git a/block/genhd.c b/block/genhd.c
index b1fb7e058b9cc..d0bdeb93e922c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1165,6 +1165,7 @@ static void disk_release(struct device *dev)
 
 	disk_release_events(disk);
 	kfree(disk->random);
+	blk_queue_free_zone_bitmaps(disk->queue);
 	xa_destroy(&disk->part_tbl);
 
 	disk->queue->disk = NULL;
-- 
2.30.2

