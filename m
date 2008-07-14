From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2.6.26] block: unify disk/part handling and improve ext devt
Date: Mon, 14 Jul 2008 16:48:00 +0900
Message-ID: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
List-Id: linux-scsi@vger.kernel.org

Hello, again.

This is the first take of unify-disk-part-handling patchset.

The block code represented a disk with struct genhd and a partition
with struct hd_struct.  The whole disk (a.k.a partition 0) has a lot
in common with other partitions but genhd and hd_struct had their own
versions for the same things.  This led to good number of duplicate
similar code paths and branches to deal with them separately.  Also,
the partition array disk->part[] is indexed by partno - 1 which gets
quite confusing at times.

This patchset introduces partition 0 and unifies handling of the whole
disk and other partitions and, on top of those changes, improves ext
devt handling such that increasing the number of allowed partitions
can be done without much overhead and the disk device itself can be
allocated an extended devt.

This patchset contains the following 13 patches.

  0001-block-implement-and-use-disk-part-_to_dev.patch
  0002-block-introduce-partition-0.patch
  0003-block-move-capacity-from-disk-to-part0.patch
  0004-block-move-__dev-from-disk-to-part0.patch
  0005-block-unify-sysfs-size-node-handling.patch
  0006-block-move-policy-from-disk-to-part0.patch
  0007-block-move-holder_dir-from-disk-to-part0.patch
  0008-block-always-set-bdev-bd_part.patch
  0009-block-kill-GENHD_FL_FAIL-and-use-part0-make_it_fai.patch
  0010-block-move-stats-from-disk-to-part0.patch
  0011-block-make-partition-array-dynamic.patch
  0012-block-replace-ext_minors-with-GENHD_FL_EXT_DEVT.patch
  0013-block-allow-disk-to-have-extended-device-number.patch

0001-0002: preps and introduces part0
0003-0009: moves what's common from disk to part0 and unifies code
	   paths
0010     : simplifies stats handling
0011	 : make partition array dynamic
0012	 : ext_minors restriction isn't necessary anymore.  simplify
           ext devt interface
0013     : allow disk (part0) to have extended devt

After this patchset, partition number is only limited by the number of
entries in struct parsed_partitions which is used by actual partition
scan code.  The limit is currently 256 but it can be increased by
changing MAX_PART.

A block driver now can simply set GENHD_FL_EXT_DEVT and skip
specifying disk->minors to tell block layer to use extended devt for
the disk and its partitions.  There's no need to allocate fixed
regions and worry about the device number availability.

If CONFIG_DEBUG_BLOCK_EXT_DEVT is turned on, sd and ide-disk use ext
devt for everything.

This patchset is on top of

  v2.6.26 (bce7f793daec3e65ec5c5705d2457b81fe7b5725)
+ [1] RCU-implement-rcu_read_[un]lock_preempt
+ [2] block-fix-block_class-iteration-locking
+ [3] block-allow-deleting-zero-lenght-partition
+ [4] block-update-add_partition-error-handling
+ [5] sd-update-index-allocation-and-use-ida
+ [6] block-extended-devt patchset, take #2

and available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-unify-disk-part
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-disk-part

Even with the added feature and comments, this patchset reduces code
by 40 lines.  ;-)

 block/blk-core.c           |   84 +++------
 block/blk-merge.c          |    8 
 block/blk-sysfs.c          |    4 
 block/genhd.c              |  402 ++++++++++++++++++++++-----------------------
 block/ioctl.c              |    4 
 drivers/block/aoe/aoeblk.c |    6 
 drivers/block/aoe/aoecmd.c |   12 -
 drivers/block/aoe/aoedev.c |    2 
 drivers/block/nbd.c        |    4 
 drivers/ide/ide-cd.c       |    2 
 drivers/ide/ide-disk.c     |   16 -
 drivers/ide/ide-probe.c    |    2 
 drivers/md/dm-ioctl.c      |    2 
 drivers/md/dm.c            |   19 +-
 drivers/md/linear.c        |    4 
 drivers/md/md.c            |   15 -
 drivers/md/multipath.c     |    4 
 drivers/md/raid0.c         |    4 
 drivers/md/raid1.c         |    4 
 drivers/md/raid10.c        |    4 
 drivers/md/raid5.c         |    4 
 drivers/scsi/sd.c          |   83 ++++++---
 fs/block_dev.c             |   79 +++-----
 fs/partitions/check.c      |  160 +++++++++--------
 fs/partitions/check.h      |    4 
 include/linux/genhd.h      |  238 +++++++++++---------------
 26 files changed, 565 insertions(+), 605 deletions(-)

--
tejun

[1] http://article.gmane.org/gmane.linux.kernel/706149
[2] http://article.gmane.org/gmane.linux.kernel/706152
[3] http://article.gmane.org/gmane.linux.kernel/706153
[4] http://article.gmane.org/gmane.linux.kernel/706154
[5] http://article.gmane.org/gmane.linux.scsi/43109
[6] http://thread.gmane.org/gmane.linux.kernel/706175
