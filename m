From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 3/3 blk-for-2.6.28] block: unify disk/part handling and improve ext devt, take #2
Date: Mon, 25 Aug 2008 19:56:04 +0900
Message-ID: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, again.

This is the second take of unify-disk-part-handling patchset.

Changes from the last take[L] are...

* adapted to blk-for-2.6.28.
* devt alloc path simplification in 0013.

For general description of the patchset, please read description of
the last take[L].

This patchset is against...

  blk-for-2.6.28 (9abd7c437c02e7448fb1d2d3cfc0b9c1ab77cf2d)
+ [1] klist-dont-iterate-over-deleted-entries
+ [2] use-klist-for-class-device-list-and-implement-iterator
+ [3] block-misc-fixes-and-improvements patchset
+ [4] block-extended-devt patchset, take #3

and available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-unify-disk-part
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-disk-part

and the combined diffstat follows.

 block/blk-core.c           |   89 ++++-----
 block/blk-integrity.c      |    5 
 block/blk-merge.c          |   12 -
 block/blk-sysfs.c          |    4 
 block/cmd-filter.c         |   12 -
 block/genhd.c              |  402 ++++++++++++++++++++++-----------------------
 block/ioctl.c              |    4 
 drivers/block/aoe/aoeblk.c |    6 
 drivers/block/aoe/aoecmd.c |   16 -
 drivers/block/aoe/aoedev.c |    2 
 drivers/block/nbd.c        |    4 
 drivers/ide/ide-cd.c       |    2 
 drivers/ide/ide-disk.c     |   16 -
 drivers/ide/ide-probe.c    |    2 
 drivers/md/dm-ioctl.c      |    2 
 drivers/md/dm.c            |   31 +--
 drivers/md/linear.c        |    9 -
 drivers/md/md.c            |   15 -
 drivers/md/multipath.c     |    9 -
 drivers/md/raid0.c         |    9 -
 drivers/md/raid1.c         |    9 -
 drivers/md/raid10.c        |    9 -
 drivers/md/raid5.c         |    9 -
 drivers/scsi/sd.c          |   83 ++++++---
 fs/block_dev.c             |   79 +++-----
 fs/partitions/check.c      |  165 +++++++++---------
 fs/partitions/check.h      |    4 
 include/linux/genhd.h      |  247 +++++++++++----------------
 28 files changed, 610 insertions(+), 646 deletions(-)

Thanks.

--
tejun

[L] http://lkml.org/lkml/2008/7/14/63
[1] http://article.gmane.org/gmane.linux.kernel/725706
[2] http://article.gmane.org/gmane.linux.kernel/725708
[3] http://thread.gmane.org/gmane.linux.kernel/725724
[4] http://lkml.org/lkml/2008/8/25/108
