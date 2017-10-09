From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v7 0/9] Hello Jens,
Date: Mon,  9 Oct 2017 16:13:51 -0700
Message-ID: <20171009231400.562-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

It is known that during the resume following a hibernate, especially when
using an md RAID1 array created on top of SCSI devices, sometimes the
system hangs instead of coming up properly. This patch series fixes this
problem. This patch series is an alternative for Ming Lei's "block/scsi:
safe SCSI quiescing" patch series. The advantage of this patch series is
that a fix for the md driver has been included.

These patches have been tested on top of the block layer for-next branch.

Please consider these changes for kernel v4.15.

Thanks,

Bart.

Changes between v6 and v7:
- Added support for the PREEMPT_ONLY flag in blk-mq-debugfs.c.
- Fixed kerneldoc header of blk_queue_enter().
- Added a rcu_read_lock_sched() / rcu_read_unlock_sched() pair in
  blk_set_preempt_only().
- Removed a synchronize_rcu() call from scsi_device_quiesce().
- Modified the description of patch 9/9 in this series.
- Removed scsi_run_queue() call from scsi_device_resume().

Changes between v5 and v6:
- Split an md patch into two patches to make it easier to review the changes.
- For the md patch that suspends I/O while the system is frozen, switched back
  to the freezer mechanism because this makes the code shorter and easier to
  review.
- Changed blk_set/clear_preempt_only() from EXPORT_SYMBOL() into
  EXPORT_SYMBOL_GPL().
- Made blk_set_preempt_only() behave as a test-and-set operation.
- Introduced blk_get_request_flags() and BLK_MQ_REQ_PREEMPT as requested by
  Christoph and reduced the number of arguments of blk_queue_enter() back from
  three to two.
- In scsi_device_quiesce(), moved the blk_mq_freeze_queue() call out of a
  critical section. Made the explanation of why the synchronize_rcu() call
  is necessary more detailed.

Changes between v4 and v5:
- Split blk_set_preempt_only() into two functions as requested by Christoph.
- Made blk_get_request() trigger WARN_ONCE() if it is attempted to allocate
  a request while the system is frozen. This is a big help to identify drivers
  that submit I/O while the system is frozen.
- Since kernel thread freezing is on its way out, reworked the approach for
  avoiding that the md driver submits I/O while the system is frozen such that
  the approach no longer depends on the kernel thread freeze mechanism.
- Fixed the (theoretical) deadlock in scsi_device_quiesce() that was identified
  by Ming.

Changes between v3 and v4:
- Made sure that this patch series not only works for scsi-mq but also for
  the legacy SCSI stack.
- Removed an smp_rmb()/smp_wmb() pair from the hot path and added a comment
  that explains why that is safe.
- Reordered the patches in this patch series.

Changes between v2 and v3:
- Made md kernel threads freezable.
- Changed the approach for quiescing SCSI devices again.
- Addressed Ming's review comments.

Changes compared to v1 of this patch series:
- Changed the approach and rewrote the patch series.

Bart Van Assche (8):
  md: Rename md_notifier into md_reboot_notifier
  md: Introduce md_stop_all_writes()
  md: Neither resync nor reshape while the system is frozen
  block: Introduce blk_get_request_flags()
  block: Introduce BLK_MQ_REQ_PREEMPT
  ide, scsi: Tell the block layer at request allocation time about
    preempt requests
  block: Add the QUEUE_FLAG_PREEMPT_ONLY request queue flag
  block, scsi: Make SCSI quiesce and resume work reliably

Ming Lei (1):
  block: Make q_usage_counter also track legacy requests

 block/blk-core.c        | 132 ++++++++++++++++++++++++++++++++++++++++--------
 block/blk-mq-debugfs.c  |   1 +
 block/blk-mq.c          |  16 +++---
 block/blk-timeout.c     |   2 +-
 drivers/ide/ide-pm.c    |   4 +-
 drivers/md/md.c         |  45 ++++++++++++++---
 drivers/scsi/scsi_lib.c |  34 ++++++++-----
 fs/block_dev.c          |   4 +-
 include/linux/blk-mq.h  |   1 +
 include/linux/blkdev.h  |  11 +++-
 10 files changed, 195 insertions(+), 55 deletions(-)

-- 
2.14.2
