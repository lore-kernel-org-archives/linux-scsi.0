From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v9 00/10] block, scsi, md: Improve suspend and resume
Date: Mon, 16 Oct 2017 16:28:55 -0700
Message-ID: <20171016232905.5047-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:57364 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757510AbdJPX3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 19:29:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>

Hello Jens,

It is known that during the resume following a hibernate, especially when
using an md RAID1 array created on top of SCSI devices, sometimes the system
hangs instead of coming up properly. This patch series fixes that
problem. These patches have been tested on top of the block layer for-next
branch. Please consider these changes for kernel v4.15.

Thanks,

Bart.

Changes between v8 and v9:
- Modified the third patch such that the MD_RECOVERY_FROZEN flag is restored
  properly after a resume.
- Modified the ninth patch such that a kernel warning is reported if it is
  attempted to call scsi_device_quiesce() from multiple contexts concurrently.
- Added Reviewed-by / Tested-by tags as appropriate.
  
Changes between v7 and v8:
- Fixed a (theoretical?) race identified by Ming Lei.
- Added a tenth patch that checks whether the proper type of flags has been
  passed to a range of block layer functions.

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

Bart Van Assche (9):
  md: Rename md_notifier into md_reboot_notifier
  md: Introduce md_stop_all_writes()
  md: Neither resync nor reshape while the system is frozen
  block: Introduce blk_get_request_flags()
  block: Introduce BLK_MQ_REQ_PREEMPT
  ide, scsi: Tell the block layer at request allocation time about
    preempt requests
  block: Add the QUEUE_FLAG_PREEMPT_ONLY request queue flag
  block, scsi: Make SCSI quiesce and resume work reliably
  block, nvme: Introduce blk_mq_req_flags_t

Ming Lei (1):
  block: Make q_usage_counter also track legacy requests

 block/blk-core.c           | 132 ++++++++++++++++++++++++++++++++++++++-------
 block/blk-mq-debugfs.c     |   1 +
 block/blk-mq.c             |  20 +++----
 block/blk-mq.h             |   2 +-
 block/blk-timeout.c        |   2 +-
 drivers/ide/ide-pm.c       |   4 +-
 drivers/md/md.c            |  65 +++++++++++++++++++---
 drivers/md/md.h            |   8 +++
 drivers/nvme/host/core.c   |   5 +-
 drivers/nvme/host/nvme.h   |   5 +-
 drivers/scsi/scsi_lib.c    |  46 +++++++++++-----
 fs/block_dev.c             |   4 +-
 include/linux/blk-mq.h     |  16 ++++--
 include/linux/blk_types.h  |   2 +
 include/linux/blkdev.h     |  11 +++-
 include/scsi/scsi_device.h |   1 +
 16 files changed, 256 insertions(+), 68 deletions(-)

-- 
2.14.2
