From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2.6.26] block: implement extended devt, take #2
Date: Mon, 14 Jul 2008 16:12:04 +0900
Message-ID: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
List-Id: linux-scsi@vger.kernel.org

Hello, all.

This is the second take of block-extended-devt patchset and contains
the following 10 patches.

0001-block-misc-updates.patch
0002-block-make-variable-and-argument-names-more-consist.patch
0003-block-don-t-depend-on-consecutive-minor-space.patch
0004-block-fix-disk-part-dereferencing-race.patch
0005-block-always-use-__-disk-part-all-_stat_-and-kil.patch
0006-block-drop-underbars-from-__-disk-part-all-_stat_.patch
0007-block-implement-extended-dev-numbers.patch
0008-block-adjust-formatting-for-large-minors-and-add-ex.patch
0009-sd-ide-disk-apply-extended-minors-to-sd-and-ide.patch
0010-block-implement-CONFIG_DEBUG_BLOCK_EXT_DEVT.patch

0001-0002 are trivial preparation patches.  0003 implements accessors
and applies them to insulate consecutive device number assumption and
help fixing partition dereferencing problem.  0004-0006 fixes
partition dereferencing bug and simplifies stats handling.  0007-0010
implement and apply extended devt.

Changes from the last take[L] are...

* Partition dereferencing problem is fixed.  This is included in the
  patchset as it depends on partition helpers implemented by 0003 and
  extended devt changes depend on partition dereference fix.  Even if
  the extended devt patches get nacked, 0001-0006 should be worthwhile
  cleanup.

* For extended devts, kobj_map doesn't make much sense as there's no
  fixed MAJ:MIN mapping and kernel can't take any default action for
  missing device, so extended devt lookup no longer goes through
  kobj_map.  Instead, it's directly looked up using ida.

* ext devt ida lookup / removal locking fixed.  A separate mutex is
  used to protect lookup against removal.

For general description of the patchset, please read description of
the last take[L].

This patchset is against...

  v2.6.26 (bce7f793daec3e65ec5c5705d2457b81fe7b5725)
+ [1] RCU-implement-rcu_read_[un]lock_preempt
+ [2] block-fix-block_class-iteration-locking
+ [3] block-allow-deleting-zero-lenght-partition
+ [4] block-update-add_partition-error-handling

and available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-extended-devt
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-extended-devt

and the combined diffstat follows.

 block/blk-core.c                    |   53 ++-
 block/blk-merge.c                   |    9 
 block/genhd.c                       |  528 ++++++++++++++++++++++++++++++------
 block/ioctl.c                       |   38 +-
 drivers/block/aoe/aoecmd.c          |    6 
 drivers/block/pktcdvd.c             |    2 
 drivers/block/ps3disk.c             |    2 
 drivers/char/random.c               |    6 
 drivers/ide/ide-disk.c              |   17 -
 drivers/md/dm-ioctl.c               |    4 
 drivers/md/dm-stripe.c              |    4 
 drivers/md/dm.c                     |   13 
 drivers/md/linear.c                 |    2 
 drivers/md/multipath.c              |    2 
 drivers/md/raid0.c                  |    2 
 drivers/md/raid1.c                  |    2 
 drivers/md/raid10.c                 |    2 
 drivers/md/raid5.c                  |    2 
 drivers/memstick/core/mspro_block.c |    2 
 drivers/mmc/card/block.c            |    2 
 drivers/s390/block/dasd_proc.c      |    3 
 drivers/s390/block/dcssblk.c        |    4 
 drivers/scsi/sd.c                   |   15 -
 drivers/scsi/sr.c                   |    2 
 fs/block_dev.c                      |   23 -
 fs/partitions/check.c               |  110 ++++---
 include/linux/fs.h                  |    1 
 include/linux/genhd.h               |  171 ++++++-----
 include/linux/major.h               |    2 
 lib/Kconfig.debug                   |   16 +
 30 files changed, 777 insertions(+), 268 deletions(-)

Thanks.

--
tejun
 
[L] http://thread.gmane.org/gmane.linux.kernel/701825
[1] http://article.gmane.org/gmane.linux.kernel/706149
[2] http://article.gmane.org/gmane.linux.kernel/706152
[3] http://article.gmane.org/gmane.linux.kernel/706153
[4] http://article.gmane.org/gmane.linux.kernel/706154
