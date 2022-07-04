Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8549FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiGDMpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiGDMp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9AE10552;
        Mon,  4 Jul 2022 05:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/IssQ5M5ONewsDcmW8lgwr8+4gSfIKEvscoWGMtLj7Y=; b=4zwO+RXb99rONG2I1JjEYZLgya
        SdcIRiXKkLf3Tfx6MJE6YVWgQ0xBuhqbe1SBJd4M2LQKkfiC5Uuuqo7nsl+L1D+2BE6JcNUVf/CwT
        KHUobw9YZ9k27xd4WgrdHFPCTL7+pt6BwLvx8fPkfApdVKThWFz6UShSHshskToQcqjnXJwkZykAy
        fduCQKzqUKY8pdfJETydzBD/nQLKxQJ5Ek2YgtPoOE2WXvXln+MTO3Zh1wTJ+xEk4vyMzuUo4lHJ9
        UMbZOTlbWR41RwLg33BGuEWH2Qvcugxo6B8Er7vxqoDW6bz1JdHc3wBYZn0jX6SFNaNvJKET+9oEs
        SyeNYiVw==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LS7-008sK7-St; Mon, 04 Jul 2022 12:45:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Date:   Mon,  4 Jul 2022 14:44:51 +0200
Message-Id: <20220704124500.155247-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for storing the zone related field in struct gendisk instead
of struct request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c           | 9 +++++----
 block/partitions/core.c        | 2 +-
 drivers/block/null_blk/zoned.c | 2 +-
 drivers/nvme/host/zns.c        | 2 +-
 drivers/scsi/sd.c              | 6 +++---
 drivers/scsi/sd_zbc.c          | 2 +-
 include/linux/blkdev.h         | 2 +-
 7 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ccceb421ed2f..35b7bba306a83 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -893,18 +893,19 @@ static bool disk_has_partitions(struct gendisk *disk)
 }
 
 /**
- * blk_queue_set_zoned - configure a disk queue zoned model.
+ * disk_set_zoned - configure the zoned model for a disk
  * @disk:	the gendisk of the queue to configure
  * @model:	the zoned model to set
  *
- * Set the zoned model of the request queue of @disk according to @model.
+ * Set the zoned model of @disk to @model.
+ *
  * When @model is BLK_ZONED_HM (host managed), this should be called only
  * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
  * If @model specifies BLK_ZONED_HA (host aware), the effective model used
  * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
  * on the disk.
  */
-void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
+void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 {
 	struct request_queue *q = disk->queue;
 
@@ -948,7 +949,7 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		blk_queue_clear_zone_settings(q);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+EXPORT_SYMBOL_GPL(disk_set_zoned);
 
 int bdev_alignment_offset(struct block_device *bdev)
 {
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 7dc487f5b03cd..1a45b1dd64918 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -330,7 +330,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	case BLK_ZONED_HA:
 		pr_info("%s: disabling host aware zoned block device support due to partitions\n",
 			disk->disk_name);
-		blk_queue_set_zoned(disk, BLK_ZONED_NONE);
+		disk_set_zoned(disk, BLK_ZONED_NONE);
 		break;
 	case BLK_ZONED_NONE:
 		break;
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 2fdd7b20c224e..b47bbd114058d 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -159,7 +159,7 @@ int null_register_zoned_dev(struct nullb *nullb)
 	struct nullb_device *dev = nullb->dev;
 	struct request_queue *q = nullb->q;
 
-	blk_queue_set_zoned(nullb->disk, BLK_ZONED_HM);
+	disk_set_zoned(nullb->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 9f81beb4df4ef..0ed15c2fd56de 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -109,7 +109,7 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 		goto free_data;
 	}
 
-	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
+	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
 	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb587e488601c..eb02d939dd448 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2934,15 +2934,15 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 	if (sdkp->device->type == TYPE_ZBC) {
 		/* Host-managed */
-		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
+		disk_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
 		sdkp->zoned = zoned;
 		if (sdkp->zoned == 1) {
 			/* Host-aware */
-			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
+			disk_set_zoned(sdkp->disk, BLK_ZONED_HA);
 		} else {
 			/* Regular disk or drive managed disk */
-			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
+			disk_set_zoned(sdkp->disk, BLK_ZONED_NONE);
 		}
 	}
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6acc4f406eb8c..0f5823b674685 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -929,7 +929,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 		/*
 		 * This can happen for a host aware disk with partitions.
 		 * The block device zone model was already cleared by
-		 * blk_queue_set_zoned(). Only free the scsi disk zone
+		 * disk_set_zoned(). Only free the scsi disk zone
 		 * information and exit early.
 		 */
 		sd_zbc_free_zone_info(sdkp);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b9baee910b825..ddf8353488fc8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -291,7 +291,7 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
-void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-- 
2.30.2

