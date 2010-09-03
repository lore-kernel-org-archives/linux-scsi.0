From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET #upstream] block,
	fs: replace HARDBARRIER with FLUSH/FUA, take#2
Date: Fri,  3 Sep 2010 12:29:15 +0200
Message-ID: <1283509796-1510-1-git-send-email-tj@kernel.org>
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
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This patchset is combination of the following two patchsets.

 [1] block, fs: replace HARDBARRIER with FLUSH/FUA
 [2] block, dm: finish REQ_FLUSH/FUA conversion, take#2

Changes from the previous postings are

* Rebased on top of v2.6.36-rc3.

* 0010-block-implement-REQ_FLUSH-FUA-based-interface-for-FL.patch
  description updated to include why special -EOPNOTSUPP handling is
  no longer necessary as suggested by Mike Snitzer.

* 0025-dm-relax-ordering-of-bio-based-flush-implementation.patch
  description updated to include why flush_error and special error
  handling logic are no longer necessary as suggested by Mike
  Snitzer.

* 0013-block-initialize-flush-request-with-WRITE_FLUSH-inst.patch and
  0014-block-kick-queue-after-sequencing-REQ_FLUSH-FUA.patch added.
  These fixes aren't strictly required by the current users but remove
  fishy corner cases.

* 0015-block-make-sure-FSEQ_DATA-request-has-the-same-rq_di.patch
  added.  This is needed to make requested based dm work.

* 0026-dm-fix-locking-context-in-queue_io.patch added.  This fixes
  locking context problem introduced by
  0025-dm-relax-ordering-of-bio-based-flush-implementation.patch.

* Tested/Reviewed-by's added and patches reordered such that block
  layer conversion comes first followed by block driver conversions,
  filesystem conversions and then finally removal of deprecate stuff.

I think the patchset is mostly ready now although I would love to have
acked/reviewd-by's on bio-based dm conversion patches.  Jens,
Christoph, how do you guys wanna steer these patches?  I think it
would be best to go through the block tree but splitting parts and
doing cross tree pull/merges should be doable too.

This patchset contains the following patches

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
  0012-block-simplify-queue_next_fseq.patch
  0013-block-initialize-flush-request-with-WRITE_FLUSH-inst.patch
  0014-block-kick-queue-after-sequencing-REQ_FLUSH-FUA.patch
  0015-block-make-sure-FSEQ_DATA-request-has-the-same-rq_di.patch
  0016-block-update-documentation-for-REQ_FLUSH-REQ_FUA.patch
  0017-block-use-REQ_FLUSH-in-blkdev_issue_flush.patch
  0018-block-loop-implement-REQ_FLUSH-FUA-support.patch
  0019-virtio_blk-drop-REQ_HARDBARRIER-support.patch
  0020-lguest-replace-VIRTIO_F_BARRIER-support-with-VIRTIO_.patch
  0021-md-implment-REQ_FLUSH-FUA-support.patch
  0022-block-make-__blk_rq_prep_clone-copy-most-command-fla.patch
  0023-dm-implement-REQ_FLUSH-FUA-support-for-bio-based-dm.patch
  0024-dm-implement-REQ_FLUSH-FUA-support-for-request-based.patch
  0025-dm-relax-ordering-of-bio-based-flush-implementation.patch
  0026-dm-fix-locking-context-in-queue_io.patch
  0027-block-pass-gfp_mask-and-flags-to-sb_issue_discard.patch
  0028-xfs-replace-barriers-with-explicit-flush-FUA-usage.patch
  0029-btrfs-replace-barriers-with-explicit-flush-FUA-usage.patch
  0030-gfs2-replace-barriers-with-explicit-flush-FUA-usage.patch
  0031-reiserfs-replace-barriers-with-explicit-flush-FUA-us.patch
  0032-nilfs2-replace-barriers-with-explicit-flush-FUA-usag.patch
  0033-jbd-replace-barriers-with-explicit-flush-FUA-usage.patch
  0034-jbd2-Modify-ASYNC_COMMIT-code-to-not-rely-on-queue-d.patch
  0035-jbd2-replace-barriers-with-explicit-flush-FUA-usage.patch
  0036-ext4-do-not-send-discards-as-barriers.patch
  0037-fat-do-not-send-discards-as-barriers.patch
  0038-swap-do-not-send-discards-as-barriers.patch
  0039-block-remove-the-WRITE_BARRIER-flag.patch
  0040-block-remove-the-BLKDEV_IFL_BARRIER-flag.patch
  0041-block-remove-the-BH_Eopnotsupp-flag.patch

and is on top of v2.6.26-rc3 (2bfc96a127bc1cc94d26bfaa40159966064f9c8c)
and available in the following git tree

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contains the following changes.  (hey, 1000 less lines!)

 Documentation/block/00-INDEX                    |    4 
 Documentation/block/barrier.txt                 |  261 ---------------
 Documentation/block/writeback_cache_control.txt |   86 +++++
 Documentation/lguest/lguest.c                   |   29 -
 block/Makefile                                  |    2 
 block/blk-barrier.c                             |  350 ---------------------
 block/blk-core.c                                |   72 ++--
 block/blk-flush.c                               |  265 +++++++++++++++
 block/blk-lib.c                                 |   18 -
 block/blk-settings.c                            |   20 +
 block/blk.h                                     |    8 
 block/elevator.c                                |   79 ----
 drivers/block/brd.c                             |    1 
 drivers/block/loop.c                            |   20 -
 drivers/block/osdblk.c                          |    5 
 drivers/block/pktcdvd.c                         |    1 
 drivers/block/ps3disk.c                         |    2 
 drivers/block/virtio_blk.c                      |   37 --
 drivers/block/xen-blkfront.c                    |   47 --
 drivers/ide/ide-disk.c                          |   13 
 drivers/ide/ide-io.c                            |   13 
 drivers/md/dm-crypt.c                           |    2 
 drivers/md/dm-io.c                              |   20 -
 drivers/md/dm-log.c                             |    2 
 drivers/md/dm-raid1.c                           |    8 
 drivers/md/dm-region-hash.c                     |   16 
 drivers/md/dm-snap-persistent.c                 |    2 
 drivers/md/dm-snap.c                            |    6 
 drivers/md/dm-stripe.c                          |    2 
 drivers/md/dm.c                                 |  400 +++++-------------------
 drivers/md/linear.c                             |    4 
 drivers/md/md.c                                 |  117 +------
 drivers/md/md.h                                 |   23 -
 drivers/md/multipath.c                          |    4 
 drivers/md/raid0.c                              |    4 
 drivers/md/raid1.c                              |  176 +++-------
 drivers/md/raid1.h                              |    2 
 drivers/md/raid10.c                             |    7 
 drivers/md/raid5.c                              |   43 +-
 drivers/md/raid5.h                              |    1 
 drivers/mmc/card/queue.c                        |    1 
 drivers/s390/block/dasd.c                       |    1 
 drivers/scsi/aic7xxx_old.c                      |   21 -
 drivers/scsi/libsas/sas_scsi_host.c             |   13 
 drivers/scsi/sd.c                               |   18 -
 fs/btrfs/disk-io.c                              |   19 -
 fs/btrfs/extent-tree.c                          |    2 
 fs/btrfs/volumes.c                              |    4 
 fs/btrfs/volumes.h                              |    1 
 fs/buffer.c                                     |    7 
 fs/ext4/mballoc.c                               |    3 
 fs/fat/fatent.c                                 |    4 
 fs/fat/misc.c                                   |    5 
 fs/gfs2/log.c                                   |   19 -
 fs/gfs2/rgrp.c                                  |    5 
 fs/jbd/commit.c                                 |   30 -
 fs/jbd2/commit.c                                |   72 +---
 fs/nilfs2/super.c                               |   10 
 fs/nilfs2/the_nilfs.c                           |    7 
 fs/reiserfs/journal.c                           |  106 +-----
 fs/xfs/linux-2.6/xfs_buf.c                      |   16 
 fs/xfs/linux-2.6/xfs_buf.h                      |   11 
 fs/xfs/linux-2.6/xfs_trace.h                    |    1 
 fs/xfs/xfs_log.c                                |   13 
 include/linux/blk_types.h                       |    5 
 include/linux/blkdev.h                          |   85 -----
 include/linux/buffer_head.h                     |    2 
 include/linux/fs.h                              |   28 -
 include/scsi/scsi_tcq.h                         |    6 
 mm/swapfile.c                                   |    9 
 70 files changed, 819 insertions(+), 1877 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/12363
[2] http://thread.gmane.org/gmane.linux.kernel/1029396
