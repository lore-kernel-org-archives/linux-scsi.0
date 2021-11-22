Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D26C4167D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhKVNJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239406AbhKVNJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5758C061748;
        Mon, 22 Nov 2021 05:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=q3PVOIAHYBJ4Pu/hIso5FbosXqZhQg/OhzOOopnmGTA=; b=dpmNxZlLiFKHoB+08iMEBpEZ0g
        l/IEzILZASigrdC/Afyb20Zn981P334eRgjHgo8ZNPv+udEWxvvKfsTvFpB4I+hAEp3uwRodSeqLX
        nkbrNjQWi9HAkXkwGLHva8pGF6BewSTncOJiSbOhCCW315blnNvBy4gD5XwBEw5uNRleDWdGJyEQ5
        BpFwF1hKlCVmTwu4Q2hHRcoPM+b4bqs7ZXGevU3sNJmud0qokXSqpR90P1q+JUXn5Xr1aa6Bl4pgy
        8iaF9rJQw1uqn127IGVKDVG/DB22mxU3sn3pbPsfkSmQxlg6ywdlP6Fts9r8ToTSQay99nPwsp/2U
        j2CH9kzA==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91r-00CrsS-2h; Mon, 22 Nov 2021 13:06:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 10/14] block: remove GENHD_FL_SUPPRESS_PARTITION_INFO
Date:   Mon, 22 Nov 2021 14:06:21 +0100
Message-Id: <20211122130625.1136848-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This flag is not set directly anywhere and only inherited from
GENHD_FL_HIDDEN.  Just check for GENHD_FL_HIDDEN instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 11 +++--------
 include/linux/genhd.h |  9 +--------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b37925ed1d7e9..09abd41249fd4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -496,10 +496,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 
 	if (disk->flags & GENHD_FL_HIDDEN) {
 		/*
-		 * Don't let hidden disks show up in /proc/partitions,
-		 * and don't bother scanning for partitions either.
+		 * Don't bother scanning for partitions.
 		 */
-		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 		disk->flags |= GENHD_FL_NO_PART;
 	} else {
 		ret = bdi_register(disk->bdi, "%u:%u",
@@ -725,8 +723,7 @@ void __init printk_all_partitions(void)
 		 * Don't show empty devices or things that have been
 		 * suppressed
 		 */
-		if (get_capacity(disk) == 0 ||
-		    (disk->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
+		if (get_capacity(disk) == 0 || (disk->flags & GENHD_FL_HIDDEN))
 			continue;
 
 		/*
@@ -819,9 +816,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	struct block_device *part;
 	unsigned long idx;
 
-	if (!get_capacity(sgp))
-		return 0;
-	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
+	if (!get_capacity(sgp) || (sgp->flags & GENHD_FL_HIDDEN))
 		return 0;
 
 	rcu_read_lock();
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0b9be3df94898..64a2f33ae9ea4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -46,11 +46,6 @@ struct partition_meta_info {
  * Must not be set for devices which are removed entirely when the
  * media is removed.
  *
- * ``GENHD_FL_SUPPRESS_PARTITION_INFO`` (0x0020): don't include
- * partition information in ``/proc/partitions`` or in the output of
- * printk_all_partitions().
- * Used for the null block device and some MMC devices.
- *
  * ``GENHD_FL_EXT_DEVT`` (0x0040): the driver supports extended
  * dynamic ``dev_t``, i.e. it wants extended device numbers
  * (``BLOCK_EXT_MAJOR``).
@@ -63,14 +58,12 @@ struct partition_meta_info {
  * ``GENHD_FL_HIDDEN`` (0x0400): the block device is hidden; it
  * doesn't produce events, doesn't appear in sysfs, and doesn't have
  * an associated ``bdev``.
- * Implies ``GENHD_FL_SUPPRESS_PARTITION_INFO`` and
- * ``GENHD_FL_NO_PART``.
+ * Implies ``GENHD_FL_NO_PART``.
  * Used for multipath devices.
  */
 #define GENHD_FL_REMOVABLE			0x0001
 /* 2 is unused (used to be GENHD_FL_DRIVERFS) */
 /* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
-#define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
 #define GENHD_FL_NO_PART			0x0200
 #define GENHD_FL_HIDDEN				0x0400
-- 
2.30.2

