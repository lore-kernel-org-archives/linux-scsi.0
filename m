Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6B1CCA47C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiGDMps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGDMpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE718FD24;
        Mon,  4 Jul 2022 05:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tG1EVE0y9OwsTynhs8YS6/fcmDu5zRQ8umS/BPgqfmo=; b=e03BePyMv4cz89jSzF7bM2vIkH
        FN+4jMGkn3DdLo4HJ3fY+hpZ4ToqgZhAk2On5e3dlGb50dTDYlv8IGcLzNVamHyDQCWphU9h43A4j
        mjH5vbgCSxY3xdC16p0n056hWxCg8l7WHyA73RGltD3rtzzsNR0kXIfSIQ8XwM3i1zXc3kGxOPLGE
        7Rm9J9QcDhHxAmSDJ9dCSXnuX603JwR8jwDX/6Wb2Iyka+InPX1oTAk9QAOOi91pvvI/vinLr/NmO
        DmpjsUcjSATfKawcADYwgp81KmC3R5V/SQ5npz3hQJmGeQuv4Kz1jqJ9JHkVlXl+i6f3xHnQTxCbE
        ZgymGqyg==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LSD-008sNn-6Z; Mon, 04 Jul 2022 12:45:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 10/17] block: pass a gendisk to blk_queue_free_zone_bitmaps
Date:   Mon,  4 Jul 2022 14:44:53 +0200
Message-Id: <20220704124500.155247-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to a gendisk based API in preparation for moving all zone related
fields from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 8 +++++---
 block/blk.h       | 4 ++--
 block/genhd.c     | 2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5a97b48102221..9085f9fb3ab42 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -449,8 +449,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
-void blk_queue_free_zone_bitmaps(struct request_queue *q)
+void disk_free_zone_bitmaps(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	kfree(q->conv_zones_bitmap);
 	q->conv_zones_bitmap = NULL;
 	kfree(q->seq_zones_wlock);
@@ -612,7 +614,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		ret = 0;
 	} else {
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-		blk_queue_free_zone_bitmaps(q);
+		disk_free_zone_bitmaps(disk);
 	}
 	blk_mq_unfreeze_queue(q);
 
@@ -628,7 +630,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
 
 	blk_mq_freeze_queue(q);
 
-	blk_queue_free_zone_bitmaps(q);
+	disk_free_zone_bitmaps(disk);
 	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
 	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
 	q->nr_zones = 0;
diff --git a/block/blk.h b/block/blk.h
index 7482a3a441dd9..b71e22c97d773 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -405,10 +405,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 #endif
 
 #ifdef CONFIG_BLK_DEV_ZONED
-void blk_queue_free_zone_bitmaps(struct request_queue *q);
+void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
 #else
-static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
+static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 #endif
 
diff --git a/block/genhd.c b/block/genhd.c
index d0bdeb93e922c..9d30f159c59ac 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1165,7 +1165,7 @@ static void disk_release(struct device *dev)
 
 	disk_release_events(disk);
 	kfree(disk->random);
-	blk_queue_free_zone_bitmaps(disk->queue);
+	disk_free_zone_bitmaps(disk);
 	xa_destroy(&disk->part_tbl);
 
 	disk->queue->disk = NULL;
-- 
2.30.2

