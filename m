From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2.6.36-rc2] block,
	fs: replace HARDBARRIER with FLUSH/FUA
Date: Wed, 25 Aug 2010 17:47:17 +0200
Message-ID: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
List-Id: linux-scsi@vger.kernel.org

Hello,

This patchset is combination of the following three patchset.

 [1] block: replace barrier with sequenced flush
 [2] block: convert to REQ_FLUSH/FUA
 [3] replace barriers with explicit flush / FUA usage

Changes from the previous postings are,

* Rebased on top of 2.6.36-rc2 (502adf5778f4151dcba3f64dd6ed322151f3712c)

* Acked/Reviewed-by's added.

* ide-remove-unnecessary-blk_queue_flushing-test-in-do_ide_request
  patch added which removes blk_queue_flushing().

* BH flags, which are no longer necessary on 2.6.36-rc2, are dropped
  from fs-block-propagate-REQ_FLUSH-FUA-interface-to-upper-layers and
  the patch is collapsed into
  block-implement-REQ_FLUSH-FUA-based-interface-for-FLUSH-FUA-requests.

* block-filter-flush-bio-s-in-__generic_make_request added.  This
  makes sure make_request based drivers which don't implement cache
  flushes don't see REQ_FLUSH/FUA requests.

* block-simplify-queue_next_fseq added.

* REQ_FUA support dropped from virtio/lguest conversion as suggested
  by Christoph.

* md conversion updated as suggested by Neil Brown.

* dm conversion is excluded for now.

* block-remove-the-BLKDEV_IFL_BARRIER-flag patch now also removes
  DISCARD_SECURE.

* block-remove-the-write-barrier-flag patch excluded for now (pending
  on dm conversion).

I've audited all make_request drivers and after this patchset only
blktrace, dm, drbd and xen need more work.  I'll work on blktrace and
dm but leave xen and drbd for the respective maintainers.

Build tested w/ allmodconfig and lightly tested w/ ext4 and xfs.

This patchst contains the following thirty patches.

  0001-ide-remove-unnecessary-blk_queue_flushing-test-in-do.patch
  0002-block-loop-queue-ordered-mode-should-be-DRAIN_FLUSH.patch
  0003-block-kill-QUEUE_ORDERED_BY_TAG.patch
  0004-block-deprecate-barrier-and-replace-blk_queue_ordere.patch
  0005-block-remove-spurious-uses-of-REQ_HARDBARRIER.patch
  0006-block-misc-cleanups-in-barrier-code.patch
  0007-block-drop-barrier-ordering-by-queue-draining.patch
  0008-block-rename-blk-barrier.c-to-blk-flush.c.patch
  0009-block-rename-barrier-ordered-to-flush.patch
  0010-block-implement-REQ_FLUSH-FUA-based-interface-for-FL.patch
  0011-block-filter-flush-bio-s-in-__generic_make_request.patch
  0012-block-use-REQ_FLUSH-in-blkdev_issue_flush.patch
  0013-block-simplify-queue_next_fseq.patch
  0014-block-loop-implement-REQ_FLUSH-FUA-support.patch
  0015-virtio_blk-drop-REQ_HARDBARRIER-support.patch
  0016-lguest-replace-VIRTIO_F_BARRIER-support-with-VIRTIO_.patch
  0017-md-implment-REQ_FLUSH-FUA-support.patch
  0018-block-pass-gfp_mask-and-flags-to-sb_issue_discard.patch
  0019-xfs-replace-barriers-with-explicit-flush-FUA-usage.patch
  0020-btrfs-replace-barriers-with-explicit-flush-FUA-usage.patch
  0021-gfs2-replace-barriers-with-explicit-flush-FUA-usage.patch
  0022-reiserfs-replace-barriers-with-explicit-flush-FUA-us.patch
  0023-nilfs2-replace-barriers-with-explicit-flush-FUA-usag.patch
  0024-jbd-replace-barriers-with-explicit-flush-FUA-usage.patch
  0025-jbd2-replace-barriers-with-explicit-flush-FUA-usage.patch
  0026-ext4-do-not-send-discards-as-barriers.patch
  0027-fat-do-not-send-discards-as-barriers.patch
  0028-swap-do-not-send-discards-as-barriers.patch
  0029-block-remove-the-BLKDEV_IFL_BARRIER-flag.patch
  0030-block-remove-the-BH_Eopnotsupp-flag.patch

and available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contain the following changes.

 Documentation/lguest/lguest.c       |   29 --
 block/Makefile                      |    2 
 block/blk-barrier.c                 |  350 ------------------------------------
 block/blk-core.c                    |   68 +++---
 block/blk-flush.c                   |  242 ++++++++++++++++++++++++
 block/blk-lib.c                     |   18 -
 block/blk-settings.c                |   20 ++
 block/blk.h                         |    8 
 block/elevator.c                    |   79 --------
 drivers/block/brd.c                 |    1 
 drivers/block/loop.c                |   20 +-
 drivers/block/osdblk.c              |    5 
 drivers/block/pktcdvd.c             |    1 
 drivers/block/ps3disk.c             |    2 
 drivers/block/virtio_blk.c          |   37 ---
 drivers/block/xen-blkfront.c        |   47 +---
 drivers/ide/ide-disk.c              |   13 -
 drivers/ide/ide-io.c                |   13 -
 drivers/md/dm.c                     |    2 
 drivers/md/linear.c                 |    4 
 drivers/md/md.c                     |  117 ++----------
 drivers/md/md.h                     |   23 --
 drivers/md/multipath.c              |    4 
 drivers/md/raid0.c                  |    4 
 drivers/md/raid1.c                  |  175 ++++++------------
 drivers/md/raid1.h                  |    2 
 drivers/md/raid10.c                 |    7 
 drivers/md/raid5.c                  |   43 ++--
 drivers/md/raid5.h                  |    1 
 drivers/mmc/card/queue.c            |    1 
 drivers/s390/block/dasd.c           |    1 
 drivers/scsi/aic7xxx_old.c          |   21 --
 drivers/scsi/libsas/sas_scsi_host.c |   13 -
 drivers/scsi/sd.c                   |   18 -
 fs/btrfs/disk-io.c                  |   19 -
 fs/btrfs/extent-tree.c              |    2 
 fs/btrfs/volumes.c                  |    4 
 fs/btrfs/volumes.h                  |    1 
 fs/buffer.c                         |    7 
 fs/ext4/mballoc.c                   |    3 
 fs/fat/fatent.c                     |    4 
 fs/fat/misc.c                       |    5 
 fs/gfs2/log.c                       |   19 -
 fs/gfs2/rgrp.c                      |    5 
 fs/jbd/commit.c                     |   30 ---
 fs/jbd2/commit.c                    |   43 ----
 fs/nilfs2/super.c                   |   10 -
 fs/nilfs2/the_nilfs.c               |    7 
 fs/reiserfs/journal.c               |  106 ++--------
 fs/xfs/linux-2.6/xfs_buf.c          |   16 -
 fs/xfs/linux-2.6/xfs_buf.h          |   11 -
 fs/xfs/linux-2.6/xfs_trace.h        |    1 
 fs/xfs/xfs_log.c                    |   13 -
 include/linux/blk_types.h           |    4 
 include/linux/blkdev.h              |   85 +-------
 include/linux/buffer_head.h         |    2 
 include/linux/fs.h                  |   27 +-
 include/scsi/scsi_tcq.h             |    6 
 mm/swapfile.c                       |    9 
 59 files changed, 585 insertions(+), 1245 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1022363
[2] http://thread.gmane.org/gmane.linux.raid/29100
[3] http://thread.gmane.org/gmane.linux.file-systems/44957
