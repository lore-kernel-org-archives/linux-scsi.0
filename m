From: Boaz Harrosh <openosd@gmail.com>
Subject: [RFD] brd.ko Never supported partitions should we remove the dead
 code ?
Date: Tue, 29 Jul 2014 19:37:49 +0300
Message-ID: <53D7CDDD.1000302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55262 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaG2Qhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 12:37:53 -0400
Received: by mail-pa0-f51.google.com with SMTP id ey11so12576848pad.24
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 09:37:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>

Hi folks

I've been playing with yet unseen prd block device, and hit an issue with partitioning
but since prd.c is a copy/paste of brd.c the same exact issue exists with brd.

It does not support partitions!

An attempt to fdisk say a couple of partitions, then mkfs && mount an individual
partition will result in the primary device being accessed and a corrupted disk data.

If I enable max_part(=2) properly on modprobe, then fdisk a couple of partitions all
goes well

But then if I pass the device to Kernel (Say via mount), after a call to
	bdev = blkdev_get_by_path(dev_name, mode, fs_type);

I get the following results: 
(size is extracted using:	i_size_read(bdev->bd_inode);
 part_size is extracted using:	bdev->bd_part->nr_sects << 9;
)

dev_name == /dev/ram0
[Jul29 17:40] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24340 bd_inode=ffff88003dc24430 bd_part=ffff88003ca22848 part_size=0x40000000

dev_name == /dev/ram0p1
[ +16.816065] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003d2f6d80 bd_inode=ffff88003d2f6e70 bd_part=ffff88003ca22848 part_size=0x40000000

dev_name == /dev/ram0p2
[Jul29 17:41] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003dc24680 bd_inode=ffff88003dc24770 bd_part=ffff88003ca22848 part_size=0x40000000

We can see that all 3 different bdev's point to the same bd_part, which is the BUG. Funny is that bd_inode is different but contains
same wrong size, for exactly the same reason.

The fix for this is easy:
----
diff --git drivers/block/brd.c drivers/block/brd.c
index c7d138e..0d982d7 100644
--- drivers/block/brd.c
+++ drivers/block/brd.c
@@ -378,10 +378,12 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
 
 	if (!brd)
 		return -ENODEV;
+	sector += get_start_sect(bdev);
 	if (sector & (PAGE_SECTORS-1))
 		return -EINVAL;
+/* Check is wrong here we need to check against bdev->bd_part->nr_sects */
 	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
 		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
@@ -532,11 +532,17 @@ static struct brd_device *brd_init_one(int i)
 			goto out;
 	}
 
+/*	In the structure of this driver this will never happen and is wrong
+ * 	to do. We should just return NULL if not found.
+ * 	This is not the bug it is just DEAD CODE
+ * 
 	brd = brd_alloc(i);
 	if (brd) {
 		add_disk(brd->brd_disk);
 		list_add_tail(&brd->brd_list, &brd_devices);
 	}
+*/
+	prd = NULL;
 out:
 	return brd;
 }
@@ -558,7 +564,8 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 	kobj = brd ? get_disk(brd->brd_disk) : NULL;
 	mutex_unlock(&brd_devices_mutex);
 
-	*part = 0;
+//	Fix the partition BUG *part comes in correctly must not need to touch it
+// 	*part = 0;
 	return kobj;
 }
---

After this simple fix of commenting out *part = 0, running again I get

dev_name == /dev/ram0
[  +0.000004] foo: [foo_mount:880] size=0x40000000 bdev=ffff88003d2f7740 inode=ffff88003d2f7830 part=ffff88001da8c048 part_size=0x40000000
dev_name == /dev/ram0p1
[  +0.000002] foo: [foo_mount:880] size=0x1e748200 bdev=ffff88003dc25040 inode=ffff88003dc25130 part=ffff880036f6a000 part_size=0x1e748200
dev_name == /dev/ram0p2
[  +0.000002] foo: [foo_mount:880] size=0x217b7e00 bdev=ffff88003d2f7a80 inode=ffff88003d2f7b70 part=ffff880036f69000 part_size=0x217b7e00
 

But before we are running to fix this bug. Could we please do better and just remove the support for partitions
all together.
	Since it *never* worked anyway, so probably no one needs it! Surly no one used it

Thanks
Boaz
