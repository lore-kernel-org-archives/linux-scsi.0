From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] brd: thin provisioning support
Date: Wed,  9 Mar 2016 14:16:32 +0100
Message-ID: <1457529392-53970-5-git-send-email-hare@suse.de>
References: <1457529392-53970-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457529392-53970-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Implement module parameter 'rd_mem_size' to restrict the overall
allocated memory size and 'rd_lowat_thresh' to add a low water mark
signalling.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/brd.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index cb27190..a8848c3 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -30,6 +30,13 @@
 #define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 
 /*
+ * Thin provisioning support
+ */
+static unsigned int rd_total_pages;
+static int rd_mem_size = CONFIG_BLK_DEV_RAM_SIZE * CONFIG_BLK_DEV_RAM_COUNT;
+static int rd_lowat_thresh = CONFIG_BLK_DEV_RAM_SIZE * CONFIG_BLK_DEV_RAM_COUNT;
+
+/*
  * Each block ramdisk device has a radix_tree brd_pages of pages that stores
  * the pages containing the block device's contents. A brd page's ->index is
  * its offset in PAGE_SIZE units. This is similar to, but in no way connected
@@ -44,6 +51,12 @@ struct brd_device {
 	struct list_head	brd_list;
 
 	/*
+	 * Thin provisioning support
+	 */
+	unsigned int		disk_events;
+	unsigned int		pending_events;
+
+	/*
 	 * Backing store of pages and lock to protect it. This is the contents
 	 * of the block device.
 	 */
@@ -91,11 +104,23 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	pgoff_t idx;
 	struct page *page;
 	gfp_t gfp_flags;
+	unsigned int rd_max_pages = rd_mem_size >> (PAGE_CACHE_SHIFT - 10);
+	unsigned int rd_lowat_pages = rd_lowat_thresh >> (PAGE_CACHE_SHIFT - 10);
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
 		return page;
 
+	if (rd_total_pages >= rd_max_pages)
+		return NULL;
+
+	if (rd_total_pages >= rd_lowat_pages &&
+	    !(brd->disk_events & DISK_EVENT_LOWAT)) {
+		brd->pending_events |= DISK_EVENT_LOWAT;
+		brd->disk_events |= DISK_EVENT_LOWAT;
+		disk_clear_events(brd->brd_disk, DISK_EVENT_LOWAT);
+	}
+
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
 	 * block or filesystem layers from page reclaim.
@@ -127,6 +152,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 		BUG_ON(!page);
 		BUG_ON(page->index != idx);
 	}
+	rd_total_pages++;
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
@@ -138,10 +164,16 @@ static void brd_free_page(struct brd_device *brd, sector_t sector)
 {
 	struct page *page;
 	pgoff_t idx;
+	unsigned int rd_lowat_pages = rd_lowat_thresh >> (PAGE_CACHE_SHIFT - 10);
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
 	page = radix_tree_delete(&brd->brd_pages, idx);
+	rd_total_pages--;
+	if (rd_total_pages < rd_lowat_pages) {
+		brd->disk_events &= ~DISK_EVENT_LOWAT;
+		brd->pending_events &= ~DISK_EVENT_LOWAT;
+	}
 	spin_unlock(&brd->brd_lock);
 	if (page)
 		__free_page(page);
@@ -434,11 +466,22 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	return error;
 }
 
+static unsigned int brd_check_events(struct gendisk *disk, unsigned int mask)
+{
+	struct brd_device *brd = disk->private_data;
+	unsigned int pending_events = brd->pending_events & mask;
+
+	brd->pending_events &= ~mask;
+
+	return pending_events;
+}
+
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
 	.ioctl =		brd_ioctl,
 	.direct_access =	brd_direct_access,
+	.check_events =		brd_check_events,
 };
 
 /*
@@ -456,6 +499,12 @@ static int max_part = 1;
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
 
+module_param(rd_mem_size, int, S_IRUGO);
+MODULE_PARM_DESC(rd_mem_size, "Maximal memory size in kbytes to allocate");
+
+module_param(rd_lowat_thresh, int, S_IRUGO);
+MODULE_PARM_DESC(rd_lowat_thresh, "Low water mark in kbytes for memory allocation");
+
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -519,6 +568,8 @@ static struct brd_device *brd_alloc(int i)
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
+	disk->events		= DISK_EVENT_LOWAT;
+	disk->async_events	= DISK_EVENT_LOWAT;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
@@ -607,6 +658,8 @@ static int __init brd_init(void)
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
 		return -EIO;
 
+	rd_total_pages = 0;
+
 	if (unlikely(!max_part))
 		max_part = 1;
 
-- 
1.8.5.6

