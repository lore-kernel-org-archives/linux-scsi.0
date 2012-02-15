From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Kernel crashing on eject SD card
Date: Wed, 15 Feb 2012 11:56:19 +0900
Message-ID: <4F3B1ED3.4000706@ce.jp.nec.com>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca> <20120212220836.6aa7fa4d@stein> <20120212222027.71651e8b@stein> <20120213021813.GA589@redhat.com> <1329154831.4f394b0f3c69c@www.imp.polymtl.ca> <4F3A4220.4010901@ce.jp.nec.com> <20120214162858.GM12117@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120214162858.GM12117@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Naveen Goswamy <naveen.goswamy@polymtl.ca>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Thank you for the comments.

On 02/15/12 01:28, Tejun Heo wrote:
>> that could lead to oops like this:
>>
>>   process A                  process B
>>   ----------------------------------------------
>>   sys_open
>>     __blkdev_get
>>       sd_open
>>         returns -ENOMEDIUM
>>                              scsi_remove_device
>>                                <scsi_device torn down>
>>       rescan_partitions
>>         sd_revalidate_disk
>>           <oops>
>>
>> Should "revalidate_disk" of block_device_operations work
>> without successful open()?
>>
>> If so, sd_revalidate_disk() (and possibly other drivers) needs to be
>> fixed. (e.g. use scsi_disk_get/put by itself)
>>
>> If not, __blkdev_get() or rescan_partision() should avoid calling
>> "revalidate_disk" for -ENOMEDIUM case.
> 
> Hmmm... right, that's a problem.  Missed rescan_partitions() calling
> into driver.  What we should probably do is separating out
> invalidation & partition shoot down into a separate function, say
> trucate_disk(), and call that on -ENOMEDIUM instead of
> rescan_partitions().  All that's necessary is killing the partition
> devices (and maybe zapping device size to zero).  Any one interested
> in trying it?

How about this?

If the patch looks ok, I appreciate if somebody with removable media
could test the followings:
  - the oops in sd_revalidate_disk() should not occur:
    http://marc.info/?l=linux-scsi&m=132388619710052
  - the problem reported here should not be re-introduced:
    https://bugzilla.kernel.org/show_bug.cgi?id=13029

Index: linux-3.3/block/partition-generic.c
===================================================================
--- linux-3.3.orig/block/partition-generic.c	2012-02-15 09:00:25.147293790 +0900
+++ linux-3.3/block/partition-generic.c	2012-02-15 11:31:33.835554974 +0900
@@ -389,17 +389,11 @@ static bool disk_unlock_native_capacity(
 	}
 }
 
-int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
 {
-	struct parsed_partitions *state = NULL;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	int p, highest, res;
-rescan:
-	if (state && !IS_ERR(state)) {
-		kfree(state);
-		state = NULL;
-	}
+	int res;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
@@ -412,6 +406,24 @@ rescan:
 		delete_partition(disk, part->partno);
 	disk_part_iter_exit(&piter);
 
+	return 0;
+}
+
+int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	struct parsed_partitions *state = NULL;
+	struct hd_struct *part;
+	int p, highest, res;
+rescan:
+	if (state && !IS_ERR(state)) {
+		kfree(state);
+		state = NULL;
+	}
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
@@ -515,6 +527,22 @@ rescan:
 	return 0;
 }
 
+int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	int res;
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
+	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
+	/* tell userspace that the media / partition table may have changed */
+	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+
+	return 0;
+}
+
 unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
Index: linux-3.3/include/linux/genhd.h
===================================================================
--- linux-3.3.orig/include/linux/genhd.h	2012-02-09 12:21:53.000000000 +0900
+++ linux-3.3/include/linux/genhd.h	2012-02-15 11:18:59.661594629 +0900
@@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
+extern int invalidate_partitions(struct gendisk *disk, struct block_device *bdev);
 extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     int partno, sector_t start,
 						     sector_t len, int flags,
Index: linux-3.3/fs/block_dev.c
===================================================================
--- linux-3.3.orig/fs/block_dev.c	2012-02-09 12:21:53.000000000 +0900
+++ linux-3.3/fs/block_dev.c	2012-02-15 11:34:48.800549266 +0900
@@ -1183,8 +1183,12 @@ static int __blkdev_get(struct block_dev
 			 * The latter is necessary to prevent ghost
 			 * partitions on a removed medium.
 			 */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(disk, bdev);
+			}
 			if (ret)
 				goto out_clear;
 		} else {
@@ -1214,8 +1218,12 @@ static int __blkdev_get(struct block_dev
 			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
 			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(bdev->bd_disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(bdev->bd_disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(bdev->bd_disk, bdev);
+			}
 			if (ret)
 				goto out_unlock_bdev;
 		}
