Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4EFC4708A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626DA6141B
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhEYGOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 02:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhEYGOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 02:14:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D62C06138B;
        Mon, 24 May 2021 23:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BGwPZ0dq5b6/GWSb9RwDXtCv4YSlOAhfSUUvUF/uZS4=; b=E7qtKLUhGkd4PXIdVcKaGk3MwH
        wC+Kw4xSAwN/dnH7IJUxJftWl5KO/t1WJICaCYCtic0X0aQ8Q3kLA0bL9fDX79zVa0xOjdffVDI0Q
        gGzxLT8AuAHsw1Dj6C2ExUGIdIAHo+VaEl/v3DA4+zrB+/vzmDEeuAN2bgBc//TYp+j1qU1F0E2AF
        0Cv3MoadfElLHdsRoJq+a4e+RcWb4ipUxetGqwHVwy13hP7k9IsXoRNh+FaReY+YunoSTSn9hHmg8
        Tp+PcAjnVQkSGtAqMI+P89VlWxcjbXzjxT/EITurUx5RyahmvVfvCx7k9fu+h/8XvXGSvfKB+qmAw
        IE6Sny3w==;
Received: from [2001:4bb8:190:7543:af90:8b76:7e65:6578] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llQJU-003ZAM-GT; Tue, 25 May 2021 06:13:13 +0000
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
Subject: [PATCH 3/8] block: move bd_mutex to struct gendisk
Date:   Tue, 25 May 2021 08:12:56 +0200
Message-Id: <20210525061301.2242282-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525061301.2242282-1-hch@lst.de>
References: <20210525061301.2242282-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the per-block device bd_mutex with a per-gendisk open_mutex,
thus simplifying locking wherever we deal with partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst |  2 +-
 block/genhd.c                         |  7 ++---
 block/partitions/core.c               | 24 ++++++++---------
 drivers/block/loop.c                  | 14 +++++-----
 drivers/block/xen-blkfront.c          |  8 +++---
 drivers/block/zram/zram_drv.c         | 18 ++++++-------
 drivers/block/zram/zram_drv.h         |  2 +-
 drivers/md/md.h                       |  6 ++---
 drivers/s390/block/dasd_genhd.c       |  8 +++---
 drivers/scsi/sd.c                     |  4 +--
 fs/block_dev.c                        | 37 +++++++++++----------------
 fs/btrfs/volumes.c                    |  2 +-
 fs/super.c                            |  8 +++---
 include/linux/blk_types.h             |  1 -
 include/linux/genhd.h                 |  3 +++
 15 files changed, 68 insertions(+), 76 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 1e894480115b..2183fd8cc350 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -480,7 +480,7 @@ prototypes::
 locking rules:
 
 ======================= ===================
-ops			bd_mutex
+ops			open_mutex
 ======================= ===================
 open:			yes
 release:		yes
diff --git a/block/genhd.c b/block/genhd.c
index 9f8cb7beaad1..7c88c52c6589 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -607,10 +607,10 @@ void del_gendisk(struct gendisk *disk)
 	blk_integrity_del(disk);
 	disk_del_events(disk);
 
-	mutex_lock(&disk->part0->bd_mutex);
+	mutex_lock(&disk->open_mutex);
 	disk->flags &= ~GENHD_FL_UP;
 	blk_drop_partitions(disk);
-	mutex_unlock(&disk->part0->bd_mutex);
+	mutex_unlock(&disk->open_mutex);
 
 	fsync_bdev(disk->part0);
 	__invalidate_device(disk->part0, true);
@@ -1295,6 +1295,7 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 		goto out_free_disk;
 
 	disk->node_id = node_id;
+	mutex_init(&disk->open_mutex);
 	xa_init(&disk->part_tbl);
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
@@ -1512,7 +1513,7 @@ void disk_unblock_events(struct gendisk *disk)
  * doesn't clear the events from @disk->ev.
  *
  * CONTEXT:
- * If @mask is non-zero must be called with bdev->bd_mutex held.
+ * If @mask is non-zero must be called with disk->open_mutex held.
  */
 void disk_flush_events(struct gendisk *disk, unsigned int mask)
 {
diff --git a/block/partitions/core.c b/block/partitions/core.c
index dc60ecf46fe6..0d33f55a7d78 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -282,7 +282,7 @@ struct device_type part_type = {
 };
 
 /*
- * Must be called either with bd_mutex held, before a disk can be opened or
+ * Must be called either with open_mutex held, before a disk can be opened or
  * after all disk users are gone.
  */
 static void delete_partition(struct block_device *part)
@@ -311,7 +311,7 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, 0444, whole_disk_show, NULL);
 
 /*
- * Must be called either with bd_mutex held, before a disk can be opened or
+ * Must be called either with open_mutex held, before a disk can be opened or
  * after all disk users are gone.
  */
 static struct block_device *add_partition(struct gendisk *disk, int partno,
@@ -450,15 +450,15 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 {
 	struct block_device *part;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	if (partition_overlaps(bdev->bd_disk, start, length, -1)) {
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
 		return -EBUSY;
 	}
 
 	part = add_partition(bdev->bd_disk, partno, start, length,
 			ADDPART_FLAG_NONE, NULL);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	return PTR_ERR_OR_ZERO(part);
 }
 
@@ -471,8 +471,7 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 	if (!part)
 		return -ENXIO;
 
-	mutex_lock(&part->bd_mutex);
-	mutex_lock_nested(&bdev->bd_mutex, 1);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 
 	ret = -EBUSY;
 	if (part->bd_openers)
@@ -481,8 +480,7 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 	delete_partition(part);
 	ret = 0;
 out_unlock:
-	mutex_unlock(&bdev->bd_mutex);
-	mutex_unlock(&part->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	bdput(part);
 	return ret;
 }
@@ -497,8 +495,7 @@ int bdev_resize_partition(struct block_device *bdev, int partno,
 	if (!part)
 		return -ENXIO;
 
-	mutex_lock(&part->bd_mutex);
-	mutex_lock_nested(&bdev->bd_mutex, 1);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	ret = -EINVAL;
 	if (start != part->bd_start_sect)
 		goto out_unlock;
@@ -511,8 +508,7 @@ int bdev_resize_partition(struct block_device *bdev, int partno,
 
 	ret = 0;
 out_unlock:
-	mutex_unlock(&part->bd_mutex);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	bdput(part);
 	return ret;
 }
@@ -538,7 +534,7 @@ void blk_drop_partitions(struct gendisk *disk)
 	struct block_device *part;
 	unsigned long idx;
 
-	lockdep_assert_held(&disk->part0->bd_mutex);
+	lockdep_assert_held(&disk->open_mutex);
 
 	xa_for_each_start(&disk->part_tbl, idx, part, 1) {
 		if (!bdgrab(part))
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d58d68f3c7cd..95c570f5923f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -652,9 +652,9 @@ static void loop_reread_partitions(struct loop_device *lo,
 {
 	int rc;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	rc = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	if (rc)
 		pr_warn("%s: partition scan of loop%d (%s) failed (rc=%d)\n",
 			__func__, lo->lo_number, lo->lo_file_name, rc);
@@ -747,7 +747,7 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	mutex_unlock(&lo->lo_mutex);
 	/*
 	 * We must drop file reference outside of lo_mutex as dropping
-	 * the file ref can take bd_mutex which creates circular locking
+	 * the file ref can take open_mutex which creates circular locking
 	 * dependency.
 	 */
 	fput(old_file);
@@ -1260,7 +1260,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	mutex_unlock(&lo->lo_mutex);
 	if (partscan) {
 		/*
-		 * bd_mutex has been held already in release path, so don't
+		 * open_mutex has been held already in release path, so don't
 		 * acquire it if this function is called in such case.
 		 *
 		 * If the reread partition isn't from release path, lo_refcnt
@@ -1268,10 +1268,10 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 		 * current holder is released.
 		 */
 		if (!release)
-			mutex_lock(&bdev->bd_mutex);
+			mutex_lock(&bdev->bd_disk->open_mutex);
 		err = bdev_disk_changed(bdev, false);
 		if (!release)
-			mutex_unlock(&bdev->bd_mutex);
+			mutex_unlock(&bdev->bd_disk->open_mutex);
 		if (err)
 			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
 				__func__, lo_number, err);
@@ -1298,7 +1298,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	/*
 	 * Need not hold lo_mutex to fput backing file. Calling fput holding
 	 * lo_mutex triggers a circular lock dependency possibility warning as
-	 * fput can take bd_mutex which is usually taken before lo_mutex.
+	 * fput can take open_mutex which is usually taken before lo_mutex.
 	 */
 	if (filp)
 		fput(filp);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 10df39a8b18d..f2c1aedcdf5a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2163,7 +2163,7 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 	}
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 
 	if (bdev->bd_openers) {
 		xenbus_dev_error(xbdev, -EBUSY,
@@ -2174,7 +2174,7 @@ static void blkfront_closing(struct blkfront_info *info)
 		xenbus_frontend_closed(xbdev);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	bdput(bdev);
 }
 
@@ -2531,7 +2531,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 	 * isn't closed yet, we let release take care of it.
 	 */
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&disk->open_mutex);
 	info = disk->private_data;
 
 	dev_warn(disk_to_dev(disk),
@@ -2546,7 +2546,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 		mutex_unlock(&blkfront_mutex);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&disk->open_mutex);
 	bdput(bdev);
 
 	return 0;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cf8deecc39ef..b3bf544493d3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1781,24 +1781,24 @@ static ssize_t reset_store(struct device *dev,
 	zram = dev_to_zram(dev);
 	bdev = zram->disk->part0;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	/* Do not reset an active device or claimed device */
 	if (bdev->bd_openers || zram->claim) {
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
 		return -EBUSY;
 	}
 
 	/* From now on, anyone can't open /dev/zram[0-9] */
 	zram->claim = true;
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	zram->claim = false;
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 
 	return len;
 }
@@ -1808,7 +1808,7 @@ static int zram_open(struct block_device *bdev, fmode_t mode)
 	int ret = 0;
 	struct zram *zram;
 
-	WARN_ON(!mutex_is_locked(&bdev->bd_mutex));
+	WARN_ON(!mutex_is_locked(&bdev->bd_disk->open_mutex));
 
 	zram = bdev->bd_disk->private_data;
 	/* zram was claimed to reset so open request fails */
@@ -1982,14 +1982,14 @@ static int zram_remove(struct zram *zram)
 {
 	struct block_device *bdev = zram->disk->part0;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	if (bdev->bd_openers || zram->claim) {
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
 		return -EBUSY;
 	}
 
 	zram->claim = true;
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 
 	zram_debugfs_unregister(zram);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 419a7e8281ee..74c411911b6e 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -112,7 +112,7 @@ struct zram {
 	/*
 	 * zram is claimed so open request will be failed
 	 */
-	bool claim; /* Protected by bdev->bd_mutex */
+	bool claim; /* Protected by disk->open_mutex */
 	struct file *backing_dev;
 #ifdef CONFIG_ZRAM_WRITEBACK
 	spinlock_t wb_limit_lock;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fb7eab58cfd5..a88086d4110c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -395,10 +395,10 @@ struct mddev {
 	 * that we are never stopping an array while it is open.
 	 * 'reconfig_mutex' protects all other reconfiguration.
 	 * These locks are separate due to conflicting interactions
-	 * with bdev->bd_mutex.
+	 * with disk->open_mutex.
 	 * Lock ordering is:
-	 *  reconfig_mutex -> bd_mutex
-	 *  bd_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
+	 *  reconfig_mutex -> disk->open_mutex
+	 *  disk->open_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
 	 */
 	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 8d6587ec73e2..bf2082d461c7 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -109,9 +109,9 @@ int dasd_scan_partitions(struct dasd_block *block)
 		return -ENODEV;
 	}
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&block->gdp->open_mutex);
 	rc = bdev_disk_changed(bdev, false);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&block->gdp->open_mutex);
 	if (rc)
 		DBF_DEV_EVENT(DBF_ERR, block->base,
 				"scan partitions error, rc %d", rc);
@@ -145,9 +145,9 @@ void dasd_destroy_partitions(struct dasd_block *block)
 	bdev = block->bdev;
 	block->bdev = NULL;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 	bdev_disk_changed(bdev, true);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 
 	/* Matching blkdev_put to the blkdev_get in dasd_scan_partitions. */
 	blkdev_put(bdev, FMODE_READ);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb3c37d1e009..d3ff723af879 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1400,7 +1400,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
  *	In the latter case @inode and @filp carry an abridged amount
  *	of information as noted above.
  *
- *	Locking: called with bdev->bd_mutex held.
+ *	Locking: called with bdev->bd_disk->open_mutex held.
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
@@ -1476,7 +1476,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
  *	Note: may block (uninterruptible) if error recovery is underway
  *	on this disk.
  *
- *	Locking: called with bdev->bd_mutex held.
+ *	Locking: called with bdev->bd_disk->open_mutex held.
  **/
 static void sd_release(struct gendisk *disk, fmode_t mode)
 {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 41d2d9708bf8..e094806c3a0c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -895,7 +895,6 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 	mapping_set_gfp_mask(&inode->i_data, GFP_USER);
 
 	bdev = I_BDEV(inode);
-	mutex_init(&bdev->bd_mutex);
 	mutex_init(&bdev->bd_fsfreeze_mutex);
 	spin_lock_init(&bdev->bd_size_lock);
 	bdev->bd_disk = disk;
@@ -1154,7 +1153,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	struct bd_holder_disk *holder;
 	int ret = 0;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 
 	WARN_ON_ONCE(!bdev->bd_holder);
 
@@ -1199,7 +1198,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 out_free:
 	kfree(holder);
 out_unlock:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
@@ -1218,7 +1217,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&bdev->bd_disk->open_mutex);
 
 	holder = bd_find_holder_disk(bdev, disk);
 
@@ -1230,7 +1229,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		kfree(holder);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
@@ -1242,7 +1241,7 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 	struct gendisk *disk = bdev->bd_disk;
 	int ret = 0;
 
-	lockdep_assert_held(&bdev->bd_mutex);
+	lockdep_assert_held(&disk->open_mutex);
 
 	if (!(disk->flags & GENHD_FL_UP))
 		return -ENXIO;
@@ -1327,14 +1326,10 @@ static int blkdev_get_part(struct block_device *part, fmode_t mode)
 		goto done;
 
 	whole = bdgrab(disk->part0);
-	mutex_lock_nested(&whole->bd_mutex, 1);
 	ret = blkdev_get_whole(whole, mode);
-	if (ret) {
-		mutex_unlock(&whole->bd_mutex);
+	if (ret)
 		goto out_put_whole;
-	}
 	whole->bd_part_count++;
-	mutex_unlock(&whole->bd_mutex);
 
 	ret = -ENXIO;
 	if (!bdev_nr_sectors(part))
@@ -1437,7 +1432,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 
 	disk_block_events(disk);
 
-	mutex_lock(&bdev->bd_mutex);
+	mutex_lock(&disk->open_mutex);
 	ret = -ENXIO;
 	if (!(disk->flags & GENHD_FL_UP))
 		goto abort_claiming;
@@ -1463,7 +1458,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 			unblock_events = false;
 		}
 	}
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&disk->open_mutex);
 
 	if (unblock_events)
 		disk_unblock_events(disk);
@@ -1472,7 +1467,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 abort_claiming:
 	if (mode & FMODE_EXCL)
 		bd_abort_claiming(bdev, holder);
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&disk->open_mutex);
 	disk_unblock_events(disk);
 put_blkdev:
 	blkdev_put_no_open(bdev);
@@ -1552,7 +1547,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
-	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (for_part)
 		bdev->bd_part_count--;
 
@@ -1567,7 +1561,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 	if (!bdev_is_partition(bdev) && disk->fops->release)
 		disk->fops->release(disk, mode);
-	mutex_unlock(&bdev->bd_mutex);
 	if (victim) {
 		__blkdev_put(victim, mode, 1);
 		bdput(victim);
@@ -1588,15 +1581,14 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	if (bdev->bd_openers == 1)
 		sync_blockdev(bdev);
 
-	mutex_lock(&bdev->bd_mutex);
-
+	mutex_lock(&disk->open_mutex);
 	if (mode & FMODE_EXCL) {
 		struct block_device *whole = bdev_whole(bdev);
 		bool bdev_free;
 
 		/*
 		 * Release a claim on the device.  The holder fields
-		 * are protected with bdev_lock.  bd_mutex is to
+		 * are protected with bdev_lock.  open_mutex is to
 		 * synchronize disk_holder unlinking.
 		 */
 		spin_lock(&bdev_lock);
@@ -1627,9 +1619,10 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 	 * from userland - e.g. eject(1).
 	 */
 	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
-	mutex_unlock(&bdev->bd_mutex);
 
 	__blkdev_put(bdev, mode, 0);
+	mutex_unlock(&disk->open_mutex);
+
 	blkdev_put_no_open(bdev);
 }
 EXPORT_SYMBOL(blkdev_put);
@@ -1936,10 +1929,10 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 		old_inode = inode;
 		bdev = I_BDEV(inode);
 
-		mutex_lock(&bdev->bd_mutex);
+		mutex_lock(&bdev->bd_disk->open_mutex);
 		if (bdev->bd_openers)
 			func(bdev, arg);
-		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdev->bd_disk->open_mutex);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 47d27059d064..f246eb2772e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1247,7 +1247,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	lockdep_assert_held(&uuid_mutex);
 	/*
 	 * The device_list_mutex cannot be taken here in case opening the
-	 * underlying device takes further locks like bd_mutex.
+	 * underlying device takes further locks like open_mutex.
 	 *
 	 * We also don't need the lock here as this is called during mount and
 	 * exclusion is provided by uuid_mutex
diff --git a/fs/super.c b/fs/super.c
index 11b7e7213fd1..91b7f156735b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1277,9 +1277,9 @@ int get_tree_bdev(struct fs_context *fc,
 		}
 
 		/*
-		 * s_umount nests inside bd_mutex during
+		 * s_umount nests inside open_mutex during
 		 * __invalidate_device().  blkdev_put() acquires
-		 * bd_mutex and can't be called under s_umount.  Drop
+		 * open_mutex and can't be called under s_umount.  Drop
 		 * s_umount temporarily.  This is safe as we're
 		 * holding an active reference.
 		 */
@@ -1352,9 +1352,9 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * s_umount nests inside bd_mutex during
+		 * s_umount nests inside open_mutex during
 		 * __invalidate_device().  blkdev_put() acquires
-		 * bd_mutex and can't be called under s_umount.  Drop
+		 * open_mutex and can't be called under s_umount.  Drop
 		 * s_umount temporarily.  This is safe as we're
 		 * holding an active reference.
 		 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..a09660671fa4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -29,7 +29,6 @@ struct block_device {
 	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
-	struct mutex		bd_mutex;	/* open/close mutex */
 	void *			bd_claiming;
 	struct device		bd_device;
 	void *			bd_holder;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6fc26f7bdf71..55072e17ea82 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -153,6 +153,9 @@ struct gendisk {
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
 #define GD_READ_ONLY			1
+
+	struct mutex open_mutex;	/* open/close mutex */
+
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-- 
2.30.2

