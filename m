From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Fri,  1 Sep 2017 01:27:19 +0800
Message-ID: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdHaR2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 13:28:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>

The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.

Once SCSI device is put into QUIESCE, no new request except for RQF_PREEMPT
can be dispatched to SCSI successfully, and scsi_device_quiesce() just simply
waits for completion of I/Os dispatched to SCSI stack. It isn't enough at all.

Because new request still can be allocated, but all the allocated
requests can't be dispatched successfully, so request pool can be
consumed up easily.

Then request with RQF_PREEMPT can't be allocated, and system may
hang forever, such as during system suspend or SCSI domain alidation.

Both IO hang inside system suspend[1] or SCSI domain validation
were reported before.

This patch tries to solve the issue by freezing block queue during
SCSI quiescing, and allowing to allocate request of RQF_PREEMPT
when queue is frozen.

Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
them all by unifying blk_freeze_queue() and blk_unfreeze_queue().


[1] https://marc.info/?t=150340250100013&r=3&w=2

Ming Lei (9):
  percpu-refcount: introduce percpu_ref_is_dead()
  blk-mq: rename blk_mq_unfreeze_queue as blk_unfreeze_queue
  blk-mq: rename blk_mq_freeze_queue as blk_freeze_queue
  blk-mq: only run hw queues for blk-mq
  block: introduce blk_drain_queue()
  blk-mq: rename blk_mq_freeze_queue_wait as blk_freeze_queue_wait
  block: tracking request allocation with q_usage_counter
  block: allow to allocate req with REQF_PREEMPT when queue is frozen
  SCSI: freeze block queue when SCSI device is put into quiesce

 block/bfq-iosched.c             |  2 +-
 block/blk-cgroup.c              |  8 +++----
 block/blk-core.c                | 49 +++++++++++++++++++++++++++++++++--------
 block/blk-mq.c                  | 49 +++++++++++++++++++++--------------------
 block/blk-mq.h                  |  1 -
 block/blk.h                     |  5 +++++
 block/elevator.c                |  4 ++--
 drivers/block/loop.c            | 16 +++++++-------
 drivers/block/rbd.c             |  2 +-
 drivers/ide/ide-pm.c            |  3 ++-
 drivers/nvme/host/core.c        |  8 +++----
 drivers/scsi/scsi_lib.c         | 23 +++++++++++++++++--
 include/linux/blk-mq.h          | 13 ++++++-----
 include/linux/blkdev.h          | 18 +++++++++++++--
 include/linux/percpu-refcount.h | 17 ++++++++++++++
 15 files changed, 153 insertions(+), 65 deletions(-)

-- 
2.9.5
