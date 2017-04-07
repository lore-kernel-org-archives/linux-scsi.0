From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 0/6] Avoid that scsi-mq and dm-mq queue processing stalls sporadically
Date: Fri, 7 Apr 2017 11:16:48 -0700
Message-ID: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

The six patches in this patch series fix the queue lockup I reported
recently on the linux-block mailing list. Please consider these patches
for inclusion in the upstream kernel.

Thanks,

Bart.

Changes between v3 and v4:
- Addressed the review comments on version three of this series about the
  patch that makes it safe to use RCU to iterate over .tag_list and also
  about the runtime performance and use of short variable names in patch 2/5.
- Clarified the description of the patch that fixes the scsi-mq stall.
- Added a patch to fix a dm-mq queue stall.
  
Changes between v2 and v3:
- Removed the blk_mq_ops.restart_hctx function pointer again.
- Modified blk_mq_sched_restart_queues() such that only a single hardware
  queue is restarted instead of multiple if hardware queues are shared.
- Introduced a new function in the block layer, namely
  blk_mq_delay_run_hw_queue().  

Changes between v1 and v2:
- Reworked scsi_restart_queues() such that it no longer takes the SCSI
  host lock.
- Added two patches - one for exporting blk_mq_sched_restart_hctx() and
  another one to make iterating with RCU over blk_mq_tag_set.tag_list safe.

Bart Van Assche (6):
  blk-mq: Make it safe to use RCU to iterate over
    blk_mq_tag_set.tag_list
  blk-mq: Restart a single queue if tag sets are shared
  blk-mq: Clarify comments in blk_mq_dispatch_rq_list()
  blk-mq: Introduce blk_mq_delay_run_hw_queue()
  scsi: Avoid that SCSI queues get stuck
  dm rq: Avoid that request processing stalls sporadically

 block/blk-mq-sched.c    | 63 +++++++++++++++++++++++++++++++++++-------
 block/blk-mq-sched.h    | 16 +----------
 block/blk-mq.c          | 73 +++++++++++++++++++++++++++++++++++++++----------
 drivers/md/dm-rq.c      |  1 +
 drivers/scsi/scsi_lib.c |  6 ++--
 include/linux/blk-mq.h  |  2 ++
 include/linux/blkdev.h  |  1 -
 7 files changed, 118 insertions(+), 44 deletions(-)

-- 
2.12.0
