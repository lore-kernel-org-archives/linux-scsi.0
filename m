From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 15 of 16] Add support for data integrity to DM
Date: Fri, 25 Apr 2008 19:12:17 -0400
Message-ID: <49afddbc72201fa3cdc2.1209165137@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44313 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760385AbYDYXRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:30 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

4 files changed, 60 insertions(+), 4 deletions(-)
drivers/md/dm-table.c         |   35 ++++++++++++++++++++++++++++++++++-
drivers/md/dm.c               |   26 ++++++++++++++++++++++++--
drivers/md/dm.h               |    2 +-
include/linux/device-mapper.h |    1 +


If all subdevices support the same protection format the DM device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r f32469624774 -r 49afddbc7220 drivers/md/dm-table.c
--- a/drivers/md/dm-table.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/md/dm-table.c	Fri Apr 25 17:39:29 2008 -0400
@@ -897,8 +897,12 @@
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
+void dm_table_set_restrictions(struct dm_table *t, struct mapped_device *md)
 {
+	struct request_queue *q = dm_queue(md);
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev *prev, *cur;
+
 	/*
 	 * Make sure we obey the optimistic sub devices
 	 * restrictions.
@@ -916,6 +920,35 @@
 	else
 		q->queue_flags |= (1 << QUEUE_FLAG_CLUSTER);
 
+	/*
+	 * Run through all devices to ensure they have matching
+	 * integrity profile
+	 */
+	cur = prev = NULL;
+
+	list_for_each_entry(cur, devices, list) {
+
+		if (prev && blk_integrity_compare(prev->bdev, cur->bdev) < 0) {
+			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
+			       __func__, prev->bdev->bd_disk->disk_name,
+			       cur->bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = cur;
+	}
+
+	/* Register dm device as being integrity capable */
+	if (prev && bdev_get_integrity(prev->bdev)) {
+		struct gendisk *disk = dm_disk(md);
+
+		if (blk_integrity_register(dm_disk(md), 
+					   bdev_get_integrity(prev->bdev)))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_INFO "Enabling data integrity on %s\n",
+			       disk->disk_name);
+	}
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff -r f32469624774 -r 49afddbc7220 drivers/md/dm.c
--- a/drivers/md/dm.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/md/dm.c	Fri Apr 25 17:39:29 2008 -0400
@@ -665,6 +665,12 @@
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_flags |= 1 << BIO_CLONED;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone, bio_sector_offset(bio, idx, offset), len);
+	}
 
 	return clone;
 }
@@ -686,6 +692,13 @@
 	clone->bi_vcnt = idx + bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone, bio_sector_offset(bio, idx, 0), len);
+	}
 
 	return clone;
 }
@@ -1059,6 +1072,7 @@
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+	printk(KERN_ERR "DM: Created %s\n", md->disk->disk_name);
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
@@ -1108,6 +1122,7 @@
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1151,7 +1166,6 @@
 
 static int __bind(struct mapped_device *md, struct dm_table *t)
 {
-	struct request_queue *q = md->queue;
 	sector_t size;
 
 	size = dm_table_get_size(t);
@@ -1172,7 +1186,7 @@
 
 	write_lock(&md->map_lock);
 	md->map = t;
-	dm_table_set_restrictions(t, q);
+	dm_table_set_restrictions(t, md);
 	write_unlock(&md->map_lock);
 
 	return 0;
@@ -1624,7 +1638,15 @@
  */
 struct gendisk *dm_disk(struct mapped_device *md)
 {
+	BUG_ON(md == NULL);
+	BUG_ON(md->disk == NULL);
+
 	return md->disk;
+}
+
+struct request_queue *dm_queue(struct mapped_device *md)
+{
+	return md->queue;
 }
 
 int dm_suspended(struct mapped_device *md)
diff -r f32469624774 -r 49afddbc7220 drivers/md/dm.h
--- a/drivers/md/dm.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/md/dm.h	Fri Apr 25 17:39:29 2008 -0400
@@ -104,7 +104,7 @@
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q);
+void dm_table_set_restrictions(struct dm_table *t, struct mapped_device *md);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
diff -r f32469624774 -r 49afddbc7220 include/linux/device-mapper.h
--- a/include/linux/device-mapper.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/linux/device-mapper.h	Fri Apr 25 17:39:29 2008 -0400
@@ -194,6 +194,7 @@
 const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
+struct request_queue *dm_queue(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 


