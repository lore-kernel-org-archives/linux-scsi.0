Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987C4C43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiGDMpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiGDMp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4537E10572;
        Mon,  4 Jul 2022 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bhuSle6KIS4/VNLbSV+Q5Gwl7Yz+v4Dq7ZIN2JHsdyY=; b=bAbbSn5X/OjdOelyHdI2FzazqN
        i42cKkYBmONNqToE8asV0G5k+T9A5papzoX5Ini6/pBtCFTAOm+DhQ0tRwOWHLiEXclJ5eLoaPk6r
        00ivJidB+cPCUgPjMfxbhp3b6cbjKyreNotMn6xcmM/hYM0gFZTIEZXtyKFX+OUcmoPbImO0vSShp
        1TKK0gbCKLaJr5Lrf7HNNhH+bYzESVfrkO44J0KbS/NIwtkfvuDvXpBU6SraLeHch7+xDukbN8StA
        ybdlqwf3s4E0CJNQc5cGfQunbfR2+DWa6qD4mYxmp9SZzLHsEGGTJo4FKWW3VvxAR3fgmGLR5DrXA
        /CpGRbOg==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LSA-008sM9-JA; Mon, 04 Jul 2022 12:45:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 09/17] block: pass a gendisk to blk_queue_clear_zone_settings
Date:   Mon,  4 Jul 2022 14:44:52 +0200
Message-Id: <20220704124500.155247-10-hch@lst.de>
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
 block/blk-settings.c | 2 +-
 block/blk-zoned.c    | 4 +++-
 block/blk.h          | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 35b7bba306a83..8bb9eef5310eb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -946,7 +946,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		blk_queue_zone_write_granularity(q,
 						queue_logical_block_size(q));
 	} else {
-		blk_queue_clear_zone_settings(q);
+		disk_clear_zone_settings(disk);
 	}
 }
 EXPORT_SYMBOL_GPL(disk_set_zoned);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7fbe395fa51fc..5a97b48102221 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -622,8 +622,10 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
-void blk_queue_clear_zone_settings(struct request_queue *q)
+void disk_clear_zone_settings(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	blk_mq_freeze_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
diff --git a/block/blk.h b/block/blk.h
index 58ad50cacd2d5..7482a3a441dd9 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -406,10 +406,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void blk_queue_free_zone_bitmaps(struct request_queue *q);
-void blk_queue_clear_zone_settings(struct request_queue *q);
+void disk_clear_zone_settings(struct gendisk *disk);
 #else
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
-static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
+static inline void disk_clear_zone_settings(struct gendisk *disk) {}
 #endif
 
 int blk_alloc_ext_minor(void);
-- 
2.30.2

