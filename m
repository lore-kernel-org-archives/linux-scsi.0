Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDBAC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhKVNJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhKVNJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BFEC061574;
        Mon, 22 Nov 2021 05:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=57QTZnGVKq9NbT7DiGKAwuLNXVomZEhbRKBdt6qZkIw=; b=bbH5rY4FtCTelQeicdHvWKA4kP
        R0oN+d2DOWSNOaSU47FHyt/sQtbBcsGkpMvKLRhsmeDFKwi/srCEHCYDuBAAEsjlPj7t+ZdfwhwjF
        0nWLmgR6mRx1cxNvwRZOdj/+vmBuJEWy6EO0EC8H12oZDjlbhc0TbPd223V6PeHGOauAOCljXH2v7
        INuyh32LR0fxKHxaySG9CgGPy0Mcuowz47r9Y2i3KbpS4icRqN7bfH4m8EuT4OP6pJab5SnLlz9Xn
        DWtL795ZwcjKwS0YTa8M4MdrygchM2TuU5qPsVQJYlXE4/OenEuBW0N1oo+HlT7wei3idgTgrG+n+
        OkSxrC/A==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91h-00Crql-Rg; Mon, 22 Nov 2021 13:06:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 03/14] block: remove GENHD_FL_CD
Date:   Mon, 22 Nov 2021 14:06:14 +0100
Message-Id: <20211122130625.1136848-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

GENHD_FL_CD marks a gendisk as a vaguely CD-ROM like device.
Besides being used internally inside of sunvdc.c an xen-blkfront it
is used by xen-blkback as a hint to claim a device exported to a
guest is a CD-ROM like device.  Just check for disk->cdi instead
which is the right indicator for "real" CD-ROM or DVD drivers.  This
will miss the paravirtualized guest drivers, but those make little
sense to report anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/sunvdc.c             | 17 +++++++++--------
 drivers/block/xen-blkback/xenbus.c |  2 +-
 drivers/block/xen-blkfront.c       | 26 +++++++++++---------------
 drivers/scsi/sr.c                  |  1 -
 include/linux/genhd.h              |  5 -----
 5 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 6f45a53f7cbf5..2157936de623c 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -143,8 +143,8 @@ static int vdc_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int vdc_ioctl(struct block_device *bdev, fmode_t mode,
 		     unsigned command, unsigned long argument)
 {
+	struct vdc_port *port = bdev->bd_disk->private_data;
 	int i;
-	struct gendisk *disk;
 
 	switch (command) {
 	case CDROMMULTISESSION:
@@ -155,12 +155,15 @@ static int vdc_ioctl(struct block_device *bdev, fmode_t mode,
 		return 0;
 
 	case CDROM_GET_CAPABILITY:
-		disk = bdev->bd_disk;
-
-		if (bdev->bd_disk && (disk->flags & GENHD_FL_CD))
+		if (!vdc_version_supported(port, 1, 1))
+			return -EINVAL;
+		switch (port->vdisk_mtype) {
+		case VD_MEDIA_TYPE_CD:
+		case VD_MEDIA_TYPE_DVD:
 			return 0;
-		return -EINVAL;
-
+		default:
+			return -EINVAL;
+		}
 	default:
 		pr_debug(PFX "ioctl %08x not supported\n", command);
 		return -EINVAL;
@@ -854,14 +857,12 @@ static int probe_disk(struct vdc_port *port)
 		switch (port->vdisk_mtype) {
 		case VD_MEDIA_TYPE_CD:
 			pr_info(PFX "Virtual CDROM %s\n", port->disk_name);
-			g->flags |= GENHD_FL_CD;
 			g->flags |= GENHD_FL_REMOVABLE;
 			set_disk_ro(g, 1);
 			break;
 
 		case VD_MEDIA_TYPE_DVD:
 			pr_info(PFX "Virtual DVD %s\n", port->disk_name);
-			g->flags |= GENHD_FL_CD;
 			g->flags |= GENHD_FL_REMOVABLE;
 			set_disk_ro(g, 1);
 			break;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 914587aabca0c..62125fd4af4a7 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -510,7 +510,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	}
 	vbd->size = vbd_sz(vbd);
 
-	if (vbd->bdev->bd_disk->flags & GENHD_FL_CD || cdrom)
+	if (cdrom || disk_to_cdi(vbd->bdev->bd_disk))
 		vbd->type |= VDISK_CDROM;
 	if (vbd->bdev->bd_disk->flags & GENHD_FL_REMOVABLE)
 		vbd->type |= VDISK_REMOVABLE;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8e3983e456f3c..700c765a759a1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -198,6 +198,7 @@ struct blkfront_info
 	struct gendisk *gd;
 	u16 sector_size;
 	unsigned int physical_sector_size;
+	unsigned long vdisk_info;
 	int vdevice;
 	blkif_vdev_t handle;
 	enum blkif_state connected;
@@ -505,6 +506,7 @@ static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
 static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned command, unsigned long argument)
 {
+	struct blkfront_info *info = bdev->bd_disk->private_data;
 	int i;
 
 	switch (command) {
@@ -514,9 +516,9 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 				return -EFAULT;
 		return 0;
 	case CDROM_GET_CAPABILITY:
-		if (bdev->bd_disk->flags & GENHD_FL_CD)
-			return 0;
-		return -EINVAL;
+		if (!(info->vdisk_info & VDISK_CDROM))
+			return -EINVAL;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -1057,9 +1059,8 @@ static char *encode_disk_name(char *ptr, unsigned int n)
 }
 
 static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
-			       struct blkfront_info *info,
-			       u16 vdisk_info, u16 sector_size,
-			       unsigned int physical_sector_size)
+		struct blkfront_info *info, u16 sector_size,
+		unsigned int physical_sector_size)
 {
 	struct gendisk *gd;
 	int nr_minors = 1;
@@ -1157,15 +1158,11 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 
 	xlvbd_flush(info);
 
-	if (vdisk_info & VDISK_READONLY)
+	if (info->vdisk_info & VDISK_READONLY)
 		set_disk_ro(gd, 1);
-
-	if (vdisk_info & VDISK_REMOVABLE)
+	if (info->vdisk_info & VDISK_REMOVABLE)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
-	if (vdisk_info & VDISK_CDROM)
-		gd->flags |= GENHD_FL_CD;
-
 	return 0;
 
 out_free_tag_set:
@@ -2304,7 +2301,6 @@ static void blkfront_connect(struct blkfront_info *info)
 	unsigned long long sectors;
 	unsigned long sector_size;
 	unsigned int physical_sector_size;
-	unsigned int binfo;
 	int err, i;
 	struct blkfront_ring_info *rinfo;
 
@@ -2342,7 +2338,7 @@ static void blkfront_connect(struct blkfront_info *info)
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "sectors", "%llu", &sectors,
-			    "info", "%u", &binfo,
+			    "info", "%u", &info->vdisk_info,
 			    "sector-size", "%lu", &sector_size,
 			    NULL);
 	if (err) {
@@ -2371,7 +2367,7 @@ static void blkfront_connect(struct blkfront_info *info)
 		}
 	}
 
-	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size,
+	err = xlvbd_alloc_gendisk(sectors, info, sector_size,
 				  physical_sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index be445dc35f2c7..6646797a7756e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,7 +684,6 @@ static int sr_probe(struct device *dev)
 	disk->minors = 1;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
-	disk->flags = GENHD_FL_CD;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
 	disk->event_flags = DISK_EVENT_FLAG_POLL | DISK_EVENT_FLAG_UEVENT |
 				DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c1136ff3c91fa..74518c576fbb9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -46,10 +46,6 @@ struct partition_meta_info {
  * Must not be set for devices which are removed entirely when the
  * media is removed.
  *
- * ``GENHD_FL_CD`` (0x0008): the block device is a CD-ROM-style
- * device.
- * Affects responses to the ``CDROM_GET_CAPABILITY`` ioctl.
- *
  * ``GENHD_FL_SUPPRESS_PARTITION_INFO`` (0x0020): don't include
  * partition information in ``/proc/partitions`` or in the output of
  * printk_all_partitions().
@@ -74,7 +70,6 @@ struct partition_meta_info {
 #define GENHD_FL_REMOVABLE			0x0001
 /* 2 is unused (used to be GENHD_FL_DRIVERFS) */
 /* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
-#define GENHD_FL_CD				0x0008
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
 #define GENHD_FL_NO_PART_SCAN			0x0200
-- 
2.30.2

