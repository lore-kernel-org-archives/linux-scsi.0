Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE19C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhKVNJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbhKVNJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6339C061757;
        Mon, 22 Nov 2021 05:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=RnxT9MLIbwrL7zTzp+T1Jj9iUQuLQQquelWXy2jYrcA=; b=rkayGMc+sElBPGiHjWUjddrfpf
        VaHdkJxVvEBGQhMD1GBEu8dSOgQEvP+rwaboqEX8Nhw0Gk4nfUvsgqpM8jmvhhLDSlHwhhbdXSF7u
        0jIAPHiL7x/EjEJY5WXp+tK97HecLWaL6oecxm6noqtYd9oBQ3AoH7tMTe6rqtESoY6z1cvw5NzBb
        6+XN6ecXB6kxA3ANk/VReANZrupp1YsClYEVW29xQn0tsxvNAdefTXkD9pV8P3WTZ099VqngsTi2z
        nUiSSsuI1eIbzjfqT//obZhO/hM+pQ0ZSDTDtj0Jcue+i7+7mJlJZ3VN64XLRe2x1fD3MPwWYmu8k
        QCO6hIfQ==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91l-00CrrT-Om; Mon, 22 Nov 2021 13:06:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 06/14] block: rename GENHD_FL_NO_PART_SCAN to GENHD_FL_NO_PART
Date:   Mon, 22 Nov 2021 14:06:17 +0100
Message-Id: <20211122130625.1136848-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The GENHD_FL_NO_PART_SCAN controls more than just partitions canning,
so rename it to GENHD_FL_NO_PART.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c            |  2 +-
 drivers/block/loop.c     |  8 ++++----
 drivers/block/n64cart.c  |  2 +-
 drivers/mmc/core/block.c |  4 ++--
 include/linux/genhd.h    | 13 ++++++-------
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0cf3d30429e14..b37925ed1d7e9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -500,7 +500,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		 * and don't bother scanning for partitions either.
 		 */
 		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
-		disk->flags |= GENHD_FL_NO_PART_SCAN;
+		disk->flags |= GENHD_FL_NO_PART;
 	} else {
 		ret = bdi_register(disk->bdi, "%u:%u",
 				   disk->major, disk->first_minor);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a154cab6cd989..7219d98c6fb8a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1061,7 +1061,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
 	if (partscan)
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
@@ -1191,7 +1191,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_flags = 0;
 	if (!part_shift)
-		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags |= GENHD_FL_NO_PART;
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
 
@@ -1301,7 +1301,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (!err && (lo->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(prev_lo_flags & LO_FLAGS_PARTSCAN)) {
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
 		partscan = true;
 	}
 out_unlock:
@@ -2032,7 +2032,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART_SCAN;
+		disk->flags |= GENHD_FL_NO_PART;
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index 78282f01f5813..4db9a8c244af5 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -136,7 +136,7 @@ static int __init n64cart_probe(struct platform_device *pdev)
 		goto out;
 
 	disk->first_minor = 0;
-	disk->flags = GENHD_FL_NO_PART_SCAN;
+	disk->flags = GENHD_FL_NO_PART;
 	disk->fops = &n64cart_fops;
 	disk->private_data = &pdev->dev;
 	strcpy(disk->disk_name, "n64cart");
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 90e1bcd03b46c..a71b3512c877a 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2397,8 +2397,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	set_disk_ro(md->disk, md->read_only || default_ro);
 	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
-		md->disk->flags |= GENHD_FL_NO_PART_SCAN
-				   | GENHD_FL_SUPPRESS_PARTITION_INFO;
+		md->disk->flags |= GENHD_FL_NO_PART |
+				   GENHD_FL_SUPPRESS_PARTITION_INFO;
 
 	/*
 	 * As discussed on lkml, GENHD_FL_REMOVABLE should:
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 74518c576fbb9..0b9be3df94898 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -56,15 +56,15 @@ struct partition_meta_info {
  * (``BLOCK_EXT_MAJOR``).
  * This affects the maximum number of partitions.
  *
- * ``GENHD_FL_NO_PART_SCAN`` (0x0200): partition scanning is disabled.
- * Used for loop devices in their default settings and some MMC
- * devices.
+ * ``GENHD_FL_NO_PART`` (0x0200): partition support is disabled.
+ * The kernel will not scan for partitions from add_disk, and users
+ * can't add partitions manually.
  *
  * ``GENHD_FL_HIDDEN`` (0x0400): the block device is hidden; it
  * doesn't produce events, doesn't appear in sysfs, and doesn't have
  * an associated ``bdev``.
  * Implies ``GENHD_FL_SUPPRESS_PARTITION_INFO`` and
- * ``GENHD_FL_NO_PART_SCAN``.
+ * ``GENHD_FL_NO_PART``.
  * Used for multipath devices.
  */
 #define GENHD_FL_REMOVABLE			0x0001
@@ -72,7 +72,7 @@ struct partition_meta_info {
 /* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
-#define GENHD_FL_NO_PART_SCAN			0x0200
+#define GENHD_FL_NO_PART			0x0200
 #define GENHD_FL_HIDDEN				0x0400
 
 enum {
@@ -180,8 +180,7 @@ static inline int disk_max_parts(struct gendisk *disk)
 
 static inline bool disk_part_scan_enabled(struct gendisk *disk)
 {
-	return disk_max_parts(disk) > 1 &&
-		!(disk->flags & GENHD_FL_NO_PART_SCAN);
+	return disk_max_parts(disk) > 1 && !(disk->flags & GENHD_FL_NO_PART);
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
-- 
2.30.2

