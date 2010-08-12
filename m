From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Thu, 12 Aug 2010 14:41:20 +0200
Message-ID: <1281616891-5691-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
List-Id: linux-scsi@vger.kernel.org

Hello,

This patchset replaces the current barrier implementation with
sequenced flush which doesn't impose any restriction on ordering
around the flush requests.  This patchst is result of the following
discussion thread.

  http://thread.gmane.org/gmane.linux.file-systems/43877

In summary, filesystems can take over the ordering of requests around
commit writes and the block layer should just supply a mechanism to
perform the commit writes themselves.  This would greatly lessen tha
stall caused by queue dumping and draining used by the current barrier
implementation for request ordering.

This patchset converts barrier mechanism to sequenced flush/fua
mechanism in the following steps.

1. Kill the mostly unused ORDERED_BY_TAG support.

2. Deprecate REQ_HARDBARRIER support.  All hard barrier requests are
   failed with -EOPNOTSUPP.

3. Drop barrier ordering by queue draining mechanism.

4. Rename barrier to flush and implement new interface based on
   REQ_FLUSH and REQ_FUA as suggested by Christoph.

blkdev_issue_flush() is converted to use the new mechanism but all the
filesystems still use the deprecated REQ_HARDBARRIER which always
fails.  Each filesystem needs to be updated to enforce request
ordering themselves and then to use REQ_FLUSH/FUA mechanism.

loop, md, dm, etc... haven't been converted yet and REQ_FLUSH/FUA
doesn't work with them yet.  I'll convert most of them soonish if this
patchset is generally agreed upon.

This patchset contains the following patches.

  0001-block-loop-queue-ordered-mode-should-be-DRAIN_FLUSH.patch
  0002-block-kill-QUEUE_ORDERED_BY_TAG.patch
  0003-block-deprecate-barrier-and-replace-blk_queue_ordere.patch
  0004-block-remove-spurious-uses-of-REQ_HARDBARRIER.patch
  0005-block-misc-cleanups-in-barrier-code.patch
  0006-block-drop-barrier-ordering-by-queue-draining.patch
  0007-block-rename-blk-barrier.c-to-blk-flush.c.patch
  0008-block-rename-barrier-ordered-to-flush.patch
  0009-block-implement-REQ_FLUSH-FUA-based-interface-for-FL.patch
  0010-fs-block-propagate-REQ_FLUSH-FUA-interface-to-upper-.patch
  0011-block-use-REQ_FLUSH-in-blkdev_issue_flush.patch

and is also available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contains the following changes.

 block/Makefile                      |    2 
 block/blk-barrier.c                 |  350 ------------------------------------
 block/blk-core.c                    |   55 ++---
 block/blk-flush.c                   |  248 +++++++++++++++++++++++++
 block/blk-settings.c                |   20 ++
 block/blk.h                         |    8 
 block/elevator.c                    |   79 --------
 drivers/block/brd.c                 |    1 
 drivers/block/loop.c                |    2 
 drivers/block/osdblk.c              |    5 
 drivers/block/pktcdvd.c             |    1 
 drivers/block/ps3disk.c             |    2 
 drivers/block/virtio_blk.c          |   34 ---
 drivers/block/xen-blkfront.c        |   47 +---
 drivers/ide/ide-disk.c              |   13 -
 drivers/md/dm.c                     |    2 
 drivers/mmc/card/queue.c            |    1 
 drivers/s390/block/dasd.c           |    1 
 drivers/scsi/aic7xxx_old.c          |   21 --
 drivers/scsi/libsas/sas_scsi_host.c |   13 -
 drivers/scsi/sd.c                   |   18 -
 fs/buffer.c                         |   27 +-
 include/linux/blk_types.h           |    4 
 include/linux/blkdev.h              |   73 +------
 include/linux/buffer_head.h         |    8 
 include/linux/fs.h                  |   20 +-
 include/scsi/scsi_tcq.h             |    6 
 27 files changed, 402 insertions(+), 659 deletions(-)

Thanks.

--
tejun
