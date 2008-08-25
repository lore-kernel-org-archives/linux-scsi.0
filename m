From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2/3 blk-for-2.6.28] block: implement extended devt, take #3
Date: Mon, 25 Aug 2008 19:47:16 +0900
Message-ID: <1219661245-16055-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, all.

This is the third take of block-extended-devt patchset and contains
the following 10 patches.

0001-block-misc-updates.patch
0002-block-make-variable-and-argument-names-more-consist.patch
0003-block-don-t-depend-on-consecutive-minor-space.patch
0004-block-fix-disk-part-dereferencing-race.patch
0005-block-fix-diskstats-access.patch
0006-block-implement-extended-dev-numbers.patch
0007-block-adjust-formatting-for-large-minors-and-add-ex.patch
0008-sd-ide-disk-apply-extended-minors-to-sd-and-ide.patch
0009-block-implement-CONFIG_DEBUG_BLOCK_EXT_DEVT.patch

0001-0002 are trivial preparation patches.  0003 implements accessors
and applies them to insulate consecutive device number assumption and
help fixing partition dereferencing problem.  0004-0005 fixes
partition dereferencing bug and simplifies stats handling.  0006-0009
implement and apply extended devt.

Changes from the last take[L] are...

* Adapted to blk-for-2.6.28. 
* 0005 and 0006 of the last take are collapsed into 0005.
* Reverse iteration bug fixed.
* blk_alloc_devt() fixed to honor first_minor when allocating from
  consecutive minor range.

For general description of the patchset, please read description of
the first take[F].

This patchset is against...

  blk-for-2.6.28 (9abd7c437c02e7448fb1d2d3cfc0b9c1ab77cf2d)
+ [1] klist-dont-iterate-over-deleted-entries
+ [2] use-klist-for-class-device-list-and-implement-iterator
+ [3] block-misc-fixes-and-improvements patchset

and available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-extended-devt
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-extended-devt

and the combined diffstat follows.

 block/blk-core.c                    |   57 ++-
 block/blk-merge.c                   |   14 
 block/genhd.c                       |  534 ++++++++++++++++++++++++++++++------
 block/ioctl.c                       |   39 +-
 drivers/block/aoe/aoecmd.c          |   15 -
 drivers/block/pktcdvd.c             |    2 
 drivers/block/ps3disk.c             |    2 
 drivers/char/random.c               |    6 
 drivers/ide/ide-disk.c              |   17 -
 drivers/md/dm-ioctl.c               |    4 
 drivers/md/dm-stripe.c              |    4 
 drivers/md/dm.c                     |   33 +-
 drivers/md/linear.c                 |    7 
 drivers/md/multipath.c              |    7 
 drivers/md/raid0.c                  |    7 
 drivers/md/raid1.c                  |    8 
 drivers/md/raid10.c                 |    7 
 drivers/md/raid5.c                  |    8 
 drivers/memstick/core/mspro_block.c |    2 
 drivers/mmc/card/block.c            |    2 
 drivers/s390/block/dasd_proc.c      |    3 
 drivers/s390/block/dcssblk.c        |    4 
 drivers/scsi/sd.c                   |   15 -
 drivers/scsi/sr.c                   |    2 
 fs/block_dev.c                      |   23 -
 fs/partitions/check.c               |  118 +++++--
 include/linux/fs.h                  |    1 
 include/linux/genhd.h               |  237 ++++++++-------
 include/linux/major.h               |    2 
 lib/Kconfig.debug                   |   16 +
 30 files changed, 861 insertions(+), 335 deletions(-)

Thanks.

--
tejun

[L] http://kerneltrap.org/mailarchive/linux-kernel/2008/7/14/2453024
[F] http://thread.gmane.org/gmane.linux.kernel/701825
[1] http://article.gmane.org/gmane.linux.kernel/725706
[2] http://article.gmane.org/gmane.linux.kernel/725708
[3] http://thread.gmane.org/gmane.linux.kernel/725724
