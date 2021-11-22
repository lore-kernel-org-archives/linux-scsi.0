Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC63C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhKVNJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhKVNJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C37C061574;
        Mon, 22 Nov 2021 05:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Ccka5rQ6de/9yVOud2vfe9/QGfdseu/Z+9MEbjFaZCw=; b=o1vAlUi/IVJuISaLEmFbXFqUi7
        08hy1srLP2ztTlZFdsjEPuSp2jQeATLzKZd7AbNihi9JwA281EEmd6mhR81R/j2hdEqNlNWfpB0s0
        slEapuCmWsOoXs0dMbYN/RvaKCY6unkioMJCQF7Rdsu45W18quHpjhH/KRlfSpYC+Cwl0b1YC4lGY
        DpW0bbdykmIerQJqa+RD4JTq2wPErFyPaE9cYO+5jL+eWpUn+XMS2leFzqjneOmptz075CvsCzoiO
        /lfMcXPjBuEIoqx3SslLXyghQmeQx/WbZrThsI/hithGBsKANXdJ6CyFENSvdRDE/JwEHPBM7ySGD
        W/N0fNoA==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91f-00CrqU-C5; Mon, 22 Nov 2021 13:06:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 01/14] block: move GENHD_FL_NATIVE_CAPACITY to disk->state
Date:   Mon, 22 Nov 2021 14:06:12 +0100
Message-Id: <20211122130625.1136848-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The flag to indicate an unlocked native capacity is dynamic state,
not a driver capability flag, so move it to disk->state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/core.c | 15 ++++++---------
 include/linux/genhd.h   |  8 +-------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 334b72ef1d73f..520292fee9339 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -527,18 +527,15 @@ int bdev_resize_partition(struct gendisk *disk, int partno, sector_t start,
 
 static bool disk_unlock_native_capacity(struct gendisk *disk)
 {
-	const struct block_device_operations *bdops = disk->fops;
-
-	if (bdops->unlock_native_capacity &&
-	    !(disk->flags & GENHD_FL_NATIVE_CAPACITY)) {
-		printk(KERN_CONT "enabling native capacity\n");
-		bdops->unlock_native_capacity(disk);
-		disk->flags |= GENHD_FL_NATIVE_CAPACITY;
-		return true;
-	} else {
+	if (!disk->fops->unlock_native_capacity ||
+	    test_and_set_bit(GD_NATIVE_CAPACITY, &disk->state)) {
 		printk(KERN_CONT "truncated\n");
 		return false;
 	}
+
+	printk(KERN_CONT "enabling native capacity\n");
+	disk->fops->unlock_native_capacity(disk);
+	return true;
 }
 
 void blk_drop_partitions(struct gendisk *disk)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 74c4102631130..e490a71e5e9dd 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -60,12 +60,6 @@ struct partition_meta_info {
  * (``BLOCK_EXT_MAJOR``).
  * This affects the maximum number of partitions.
  *
- * ``GENHD_FL_NATIVE_CAPACITY`` (0x0080): based on information in the
- * partition table, the device's capacity has been extended to its
- * native capacity; i.e. the device has hidden capacity used by one
- * of the partitions (this is a flag used so that native capacity is
- * only ever unlocked once).
- *
  * ``GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE`` (0x0100): event polling is
  * blocked whenever a writer holds an exclusive lock.
  *
@@ -86,7 +80,6 @@ struct partition_meta_info {
 #define GENHD_FL_CD				0x0008
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
-#define GENHD_FL_NATIVE_CAPACITY		0x0080
 #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	0x0100
 #define GENHD_FL_NO_PART_SCAN			0x0200
 #define GENHD_FL_HIDDEN				0x0400
@@ -140,6 +133,7 @@ struct gendisk {
 #define GD_NEED_PART_SCAN		0
 #define GD_READ_ONLY			1
 #define GD_DEAD				2
+#define GD_NATIVE_CAPACITY		3
 
 	struct mutex open_mutex;	/* open/close mutex */
 	unsigned open_partitions;	/* number of open partitions */
-- 
2.30.2

