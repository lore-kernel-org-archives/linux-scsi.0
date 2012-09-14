From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Tape device =?utf-8?b?cmVxdWVzdF9xdWV1ZQ==?= kref accounting bug causes slab corruption
Date: Fri, 14 Sep 2012 21:41:38 +0000 (UTC)
Message-ID: <loom.20120914T233602-37@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49460 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab2IOBFC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 21:05:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1TCgoh-0000Jk-CV
	for linux-scsi@vger.kernel.org; Sat, 15 Sep 2012 03:05:03 +0200
Received: from rigel.stratus.com ([rigel.stratus.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2012 03:05:03 +0200
Received: from joe.lawrence by rigel.stratus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2012 03:05:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In [PATCH] block: make gendisk hold a reference to its queue 
(523e1d399ce0e23bec562abe2b2f8d297af81161), add_disk() and disk_release()
were modified to get/put an additional reference on a disk queue to fix a
reference counting discrepency between bdev release and SCSI device removal.

The relevent piece of the change:

diff --git a/block/genhd.c b/block/genhd.c
index e2f6790..d261b73 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -611,6 +611,12 @@ void add_disk(struct gendisk *disk)
 	register_disk(disk);
 	blk_register_queue(disk);
 
+	/*
+	 * Take an extra ref on queue which will be put on disk_release()
+	 * so that it sticks around as long as @disk is there.
+	 */
+	WARN_ON_ONCE(blk_get_queue(disk->queue));
+
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
 	WARN_ON(retval);
@@ -1095,6 +1101,8 @@ static void disk_release(struct device *dev)
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	free_part_info(&disk->part0);
+	if (disk->queue)
+		blk_put_queue(disk->queue);
 	kfree(disk);
 }
 struct class block_class = {


With this change in place in a Red Hat 6.3 kernel, we noticed that this
introduces a new reference get/put accounting bug when adding/removing
a SCSI tape device.


This was detected when turning on slub debugging, memory poisoning to be
exact, and then loading and unloading the mpt2sas driver.  Slub debugging
noticed that memory allocated in blk_alloc_queue_node and freed by 
blk_release_queue had changed between a free and a new allocation.  The
offset of the memory corruption was the exact byte that the kref counter for
the request_queue lives.  Further instrumentation revealed than a extra
kref_put was being performed, validating the '6a' byte that slub debugging
had detected.

I verified the same behavior with Fedora 17 running 3.6.0-rc5.  A simple
repro consisted of:

* Boot with slub_debug=FZPU, tape drive attached
* echo 1 > /sys/devices/... tape device pci path .../remove
* Wait for device removal
* echo 1 > /sys/kernel/slab/blkdev_queue/validate
* Slub debug complains about corrupted poison pattern

A quick review of the code...

st_probe
  alloc_disk
    alloc_disk_node
      device_initialize
        kobject_init(&dev->kobj, &device_ktype)
          kobject_init_internal
            kref_init

kobject_init assigns the dev->kobj the device_ktype, defined as:


drivers/base/core.c:
static struct kobj_type device_ktype = {
        .release        = device_release,
        .sysfs_ops      = &dev_sysfs_ops,
};

and if we look at the kobj_type's release function, we notice that it calls
the device release function:

drivers/base/core.c:
static void device_release(struct kobject *kobj)
{
        ...
        if (dev->release)
                dev->release(dev);

The disk_type device_type is defined as:

block/genhd.c:
static struct device_type disk_type = {
        .name           = "disk",
        .groups         = disk_attr_groups,
        .release        = disk_release,
        .devnode        = block_devnode,
};

Which means when we perform the final put on the kobject's kref, we will
invoke kobj_type.release (device_release) which then calls 
device_type.release (disk_release).

Unlike sd_probe, for example, st_probe never calls add_disk() in the first
place, so it never acquires the extra kref on its queue.

I'm pretty sure that similar fallout from the add_disk() patch was addressed
in [PATCH] floppy: Cleanup disk->queue before caling put_disk() if
add_disk() was never called (3f9a5aabd0a9fe0e0cd308506f48963d79169aa7) where
the floppy driver was modified to NULL the disk queue pointer immediately
after cleaning up the queue:

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 510fb10..401ba78 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4368,8 +4368,14 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue)
+		if (disks[dr]->queue) {
 			blk_cleanup_queue(disks[dr]->queue);
+			/*
+			 * put_disk() is not paired with add_disk() and
+			 * will put queue reference one extra time. fix it.
+			 */
+			disks[dr]->queue = NULL;
+		}
 		put_disk(disks[dr]);
 	}
 	return err;

In the case of SCSI tape, scsi_device_dev_release_usercontext() already NULLs
out the request queue after what should be the last blk_put_queue.
Unfortunately, __scsi_remove_device() invokes this indirectly when it performs
a put_device() at the very bottom of its function.  By this time, it's too
late and the kref is already 0.

I'll reply with a potential patch for this bug, which mimics the add_disk()'s
call to blk_get_queue().  I don't know if this is safe to do before
blk_register_queue() is called, please let me know if is not.  If another
bugfix is preferred (on the kref put side for example), I can modify / test.

Thanks,

-- Joe Lawrence
   jdl1291@gmail.com

