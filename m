Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E54EC43219
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbhKVNJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbhKVNJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFC4C061714;
        Mon, 22 Nov 2021 05:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=b2GCEzlEc2/SFxBDjm4Bkw6Sh9Bf/eM8dFi6dn2Qq10=; b=YrQtuDoxGlmZInUMSmx6CSEWng
        XwfXpKwo1SrAJYX1KtiovUFTbuSjAlhc7L0hJVyFOrr9fHWMezGXhthTitjinu79ILe0IFqve1IPZ
        FV7SCaQko1bVge4DZSM0F9jOYrGF5sHHC7T0OUcxANOd+ugcdHH3e3YKa/MKMuSq1yEdISfcCWxBB
        57WlYAyUPsJS9U8sUzrEI94KTD4xyH0Oe4oh2AQDd7LU+rXJqvn0L971fpliqKMIA4IVzvJMH+qWN
        0CBWYVHYCSQZZh1orFGOTT44DQy70vAHLnDrtFCYzXMPautf5VzJImDk/DtNIbOVVSfc77FOFYW8Q
        ZNjRZcng==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91g-00Crqe-JH; Mon, 22 Nov 2021 13:06:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 02/14] block: move GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE to disk->event_flags
Date:   Mon, 22 Nov 2021 14:06:13 +0100
Message-Id: <20211122130625.1136848-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE is all about the event reporting
mechanism, so move it to the event_flags field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c               | 2 +-
 drivers/block/paride/pcd.c | 2 +-
 drivers/scsi/sr.c          | 5 +++--
 include/linux/genhd.h      | 6 ++----
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index b4dab2fb6a746..cf29c6508bff2 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -837,7 +837,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 		 * used in blkdev_get/put().
 		 */
 		if ((mode & FMODE_WRITE) && !bdev->bd_write_holder &&
-		    (disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE)) {
+		    (disk->event_flags & DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE)) {
 			bdev->bd_write_holder = true;
 			unblock_events = false;
 		}
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index f6b1d63e96e1b..430ee8004a514 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -928,8 +928,8 @@ static int pcd_init_unit(struct pcd_unit *cd, bool autoprobe, int port,
 	disk->minors = 1;
 	strcpy(disk->disk_name, cd->name);	/* umm... */
 	disk->fops = &pcd_bdops;
-	disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	disk->event_flags = DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
 
 	if (!pi_init(cd->pi, autoprobe, port, mode, unit, protocol, delay,
 			pcd_buffer, PI_PCD, verbose, cd->name)) {
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8e4af111c0787..be445dc35f2c7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,9 +684,10 @@ static int sr_probe(struct device *dev)
 	disk->minors = 1;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
-	disk->flags = GENHD_FL_CD | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
+	disk->flags = GENHD_FL_CD;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
-	disk->event_flags = DISK_EVENT_FLAG_POLL | DISK_EVENT_FLAG_UEVENT;
+	disk->event_flags = DISK_EVENT_FLAG_POLL | DISK_EVENT_FLAG_UEVENT |
+				DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
 
 	blk_queue_rq_timeout(sdev->request_queue, SR_TIMEOUT);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e490a71e5e9dd..c1136ff3c91fa 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -60,9 +60,6 @@ struct partition_meta_info {
  * (``BLOCK_EXT_MAJOR``).
  * This affects the maximum number of partitions.
  *
- * ``GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE`` (0x0100): event polling is
- * blocked whenever a writer holds an exclusive lock.
- *
  * ``GENHD_FL_NO_PART_SCAN`` (0x0200): partition scanning is disabled.
  * Used for loop devices in their default settings and some MMC
  * devices.
@@ -80,7 +77,6 @@ struct partition_meta_info {
 #define GENHD_FL_CD				0x0008
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
-#define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	0x0100
 #define GENHD_FL_NO_PART_SCAN			0x0200
 #define GENHD_FL_HIDDEN				0x0400
 
@@ -94,6 +90,8 @@ enum {
 	DISK_EVENT_FLAG_POLL			= 1 << 0,
 	/* Forward events to udev */
 	DISK_EVENT_FLAG_UEVENT			= 1 << 1,
+	/* Block event polling when open for exclusive write */
+	DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE	= 1 << 2,
 };
 
 struct disk_events;
-- 
2.30.2

