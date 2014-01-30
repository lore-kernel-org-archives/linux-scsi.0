From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] block devices: validate block device capacity
Date: Thu, 30 Jan 2014 15:40:40 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Nick Piggin <npiggin@kernel.dk>, "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When running the LVM2 testsuite on 32-bit kernel, there are unkillable
processes stuck in the kernel consuming 100% CPU:
blkid           R running      0  2005   1409 0x00000004
ce009d00 00000082 ffffffcf c11280ba 00000060 560b5dfd 00003111 00fe41cb
00000000 ce009d00 00000000 d51cfeb0 00000000 0000001e 00000002 ffffffff
00000002 c10748c1 00000002 c106cca4 00000000 00000000 ffffffff 00000000
Call Trace:
[<c11280ba>] ? radix_tree_next_chunk+0xda/0x2c0
[<c10748c1>] ? release_pages+0x61/0x160
[<c106cca4>] ? find_get_pages+0x84/0x100
[<c1251fbe>] ? _cond_resched+0x1e/0x40
[<c10758cb>] ? truncate_inode_pages_range+0x12b/0x440
[<c1075cb7>] ? truncate_inode_pages+0x17/0x20
[<c10cf2ba>] ? __blkdev_put+0x3a/0x140
[<c10d02db>] ? blkdev_close+0x1b/0x40
[<c10a60b2>] ? __fput+0x72/0x1c0
[<c1039461>] ? task_work_run+0x61/0xa0
[<c1253b6f>] ? work_notifysig+0x24/0x35

This is caused by the fact that the LVM2 testsuite creates 64TB device.
The kernel uses "unsigned long" to index pages in files and block devices,
on 64TB device "unsigned long" overflows (it can address up to 16TB with
4k pages), causing the infinite loop.

On 32-bit architectures, we must limit block device size to
PAGE_SIZE*(2^32-1).

The bug with untested device size is pervasive across the whole kernel, 
some drivers test that the device size fits in sector_t, but this test is 
not sufficient on 32-bit architectures. This patch introduces a new 
function validate_disk_capacity that tests if the disk capacity is OK for 
the current kernel and modifies the drivers brd, ide-gd, dm, sd to use it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/genhd.c                 |   23 +++++++++++++++++++++++
 drivers/block/brd.c           |   15 +++++++++++----
 drivers/ide/ide-gd.c          |    8 ++++++++
 drivers/md/dm-ioctl.c         |    3 +--
 drivers/md/dm-table.c         |   14 +++++++++++++-
 drivers/scsi/sd.c             |   20 +++++++++++---------
 include/linux/device-mapper.h |    2 +-
 include/linux/genhd.h         |    2 ++
 8 files changed, 70 insertions(+), 17 deletions(-)

Index: linux-2.6-compile/block/genhd.c
===================================================================
--- linux-2.6-compile.orig/block/genhd.c	2014-01-30 17:23:15.000000000 +0100
+++ linux-2.6-compile/block/genhd.c	2014-01-30 19:28:42.000000000 +0100
@@ -1835,3 +1835,26 @@ static void disk_release_events(struct g
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+int validate_disk_capacity(u64 n_sectors, const char **reason)
+{
+	u64 n_pages;
+	if (n_sectors << 9 >> 9 != n_sectors) {
+		if (reason)
+			*reason = "The number of bytes is greater than 2^64.";
+		return -EOVERFLOW;
+	}
+	n_pages = (n_sectors + (1 << (PAGE_SHIFT - 9)) - 1) >> (PAGE_SHIFT - 9);
+	if (n_pages > ULONG_MAX) {
+		if (reason)
+			*reason = "Use 64-bit kernel.";
+		return -EFBIG;
+	}
+	if (n_sectors != (sector_t)n_sectors) {
+		if (reason)
+			*reason = "Use a kernel compiled with support for large block devices.";
+		return -ENOSPC;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(validate_disk_capacity);
Index: linux-2.6-compile/drivers/block/brd.c
===================================================================
--- linux-2.6-compile.orig/drivers/block/brd.c	2014-01-30 17:23:15.000000000 +0100
+++ linux-2.6-compile/drivers/block/brd.c	2014-01-30 19:26:51.000000000 +0100
@@ -429,12 +429,12 @@ static const struct block_device_operati
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static unsigned rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
 module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
-module_param(rd_size, int, S_IRUGO);
+module_param(rd_size, uint, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
@@ -446,7 +446,7 @@ MODULE_ALIAS("rd");
 /* Legacy boot options - nonmodular */
 static int __init ramdisk_size(char *str)
 {
-	rd_size = simple_strtol(str, NULL, 0);
+	rd_size = simple_strtoul(str, NULL, 0);
 	return 1;
 }
 __setup("ramdisk_size=", ramdisk_size);
@@ -463,6 +463,13 @@ static struct brd_device *brd_alloc(int
 {
 	struct brd_device *brd;
 	struct gendisk *disk;
+	u64 capacity = (u64)rd_size * 2;
+	const char *reason;
+
+	if (validate_disk_capacity(capacity, &reason)) {
+		printk(KERN_ERR "brd: disk is too big: %s\n", reason);
+		goto out;
+	}
 
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd)
@@ -493,7 +500,7 @@ static struct brd_device *brd_alloc(int
 	disk->queue		= brd->brd_queue;
 	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
-	set_capacity(disk, rd_size * 2);
+	set_capacity(disk, capacity);
 
 	return brd;
 
Index: linux-2.6-compile/drivers/ide/ide-gd.c
===================================================================
--- linux-2.6-compile.orig/drivers/ide/ide-gd.c	2014-01-30 17:23:17.000000000 +0100
+++ linux-2.6-compile/drivers/ide/ide-gd.c	2014-01-30 19:26:51.000000000 +0100
@@ -58,6 +58,14 @@ static void ide_disk_put(struct ide_disk
 
 sector_t ide_gd_capacity(ide_drive_t *drive)
 {
+	int v;
+	const char *reason;
+	v = validate_disk_capacity(drive->capacity64, &reason);
+	if (v) {
+		printk(KERN_ERR "%s: The disk is too big. %s\n",
+			drive->name, reason);
+		return 0;
+	}
 	return drive->capacity64;
 }
 
Index: linux-2.6-compile/drivers/scsi/sd.c
===================================================================
--- linux-2.6-compile.orig/drivers/scsi/sd.c	2014-01-30 17:23:24.000000000 +0100
+++ linux-2.6-compile/drivers/scsi/sd.c	2014-01-30 19:26:51.000000000 +0100
@@ -1960,6 +1960,8 @@ static int read_capacity_16(struct scsi_
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	int v;
+	const char *reason;
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
@@ -2014,10 +2016,9 @@ static int read_capacity_16(struct scsi_
 		return -ENODEV;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
-		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
-			"kernel compiled with support for large block "
-			"devices.\n");
+	v = validate_disk_capacity(lba + (lba != ULLONG_MAX), &reason);
+	if (v) {
+		sd_printk(KERN_ERR, sdkp, "The disk is too big. %s\n", reason);
 		sdkp->capacity = 0;
 		return -EOVERFLOW;
 	}
@@ -2053,8 +2054,10 @@ static int read_capacity_10(struct scsi_
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
-	sector_t lba;
+	unsigned long long lba;
 	unsigned sector_size;
+	int v;
+	const char *reason;
 
 	do {
 		cmd[0] = READ_CAPACITY;
@@ -2100,10 +2103,9 @@ static int read_capacity_10(struct scsi_
 		return sector_size;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
-		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
-			"kernel compiled with support for large block "
-			"devices.\n");
+	v = validate_disk_capacity(lba + 1, &reason);
+	if (v) {
+		sd_printk(KERN_ERR, sdkp, "The disk is too big. %s\n", reason);
 		sdkp->capacity = 0;
 		return -EOVERFLOW;
 	}
Index: linux-2.6-compile/include/linux/genhd.h
===================================================================
--- linux-2.6-compile.orig/include/linux/genhd.h	2014-01-30 17:23:29.000000000 +0100
+++ linux-2.6-compile/include/linux/genhd.h	2014-01-30 19:26:51.000000000 +0100
@@ -451,6 +451,8 @@ static inline void set_capacity(struct g
 	disk->part0.nr_sects = size;
 }
 
+extern int validate_disk_capacity(u64 n_sectors, const char **reason);
+
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 
 #define SOLARIS_X86_NUMSLICE	16
Index: linux-2.6-compile/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6-compile.orig/drivers/md/dm-ioctl.c	2014-01-30 17:23:17.000000000 +0100
+++ linux-2.6-compile/drivers/md/dm-ioctl.c	2014-01-30 19:26:51.000000000 +0100
@@ -1250,8 +1250,7 @@ static int populate_table(struct dm_tabl
 		}
 
 		r = dm_table_add_target(table, spec->target_type,
-					(sector_t) spec->sector_start,
-					(sector_t) spec->length,
+					spec->sector_start, spec->length,
 					target_params);
 		if (r) {
 			DMWARN("error adding target to table");
Index: linux-2.6-compile/drivers/md/dm-table.c
===================================================================
--- linux-2.6-compile.orig/drivers/md/dm-table.c	2014-01-30 17:23:17.000000000 +0100
+++ linux-2.6-compile/drivers/md/dm-table.c	2014-01-30 19:26:51.000000000 +0100
@@ -702,11 +702,12 @@ static int validate_hardware_logical_blo
 }
 
 int dm_table_add_target(struct dm_table *t, const char *type,
-			sector_t start, sector_t len, char *params)
+			u64 start, u64 len, char *params)
 {
 	int r = -EINVAL, argc;
 	char **argv;
 	struct dm_target *tgt;
+	const char *reason;
 
 	if (t->singleton) {
 		DMERR("%s: target type %s must appear alone in table",
@@ -724,6 +725,17 @@ int dm_table_add_target(struct dm_table
 		return -EINVAL;
 	}
 
+	if (start + len < start) {
+		DMERR("%s: target length overflow", dm_device_name(t->md));
+		return -EOVERFLOW;
+	}
+
+	r = validate_disk_capacity(start + len, &reason);
+	if (r) {
+		DMERR("%s: device is too big: %s", dm_device_name(t->md), reason);
+		return r;
+	}
+
 	tgt->type = dm_get_target_type(type);
 	if (!tgt->type) {
 		DMERR("%s: %s: unknown target type", dm_device_name(t->md),
Index: linux-2.6-compile/include/linux/device-mapper.h
===================================================================
--- linux-2.6-compile.orig/include/linux/device-mapper.h	2014-01-30 17:23:29.000000000 +0100
+++ linux-2.6-compile/include/linux/device-mapper.h	2014-01-30 19:26:51.000000000 +0100
@@ -428,7 +428,7 @@ int dm_table_create(struct dm_table **re
  * Then call this once for each target.
  */
 int dm_table_add_target(struct dm_table *t, const char *type,
-			sector_t start, sector_t len, char *params);
+			u64 start, u64 len, char *params);
 
 /*
  * Target_ctr should call this if it needs to add any callbacks.
