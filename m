From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 00/14] blk-mq-sched: fix SCSI-MQ performance regression
Date: Tue,  1 Aug 2017 00:50:57 +0800
Message-ID: <20170731165111.11536-2-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

In Red Hat internal storage test wrt. blk-mq scheduler, we
found that its performance is quite bad, especially
about sequential I/O on some multi-queue SCSI devcies.

Turns out one big issue causes the performance regression: requests
are still dequeued from sw queue/scheduler queue even when ldd's
queue is busy, so I/O merge becomes quite difficult to do, and
sequential IO degrades a lot.

The 1st five patches improve this situation, and brings back
some performance loss.

But looks they are still not enough. Finally it is caused by
the shared queue depth among all hw queues. For SCSI devices,
.cmd_per_lun defines the max number of pending I/O on one
request queue, which is per-request_queue depth. So during
dispatch, if one hctx is too busy to move on, all hctxs can't
dispatch too because of the per-request_queue depth.

Patch 6 ~ 14 use per-request_queue dispatch list to avoid
to dequeue requests from sw/scheduler queue when lld queue
is busy.

With this changes, SCSI-MQ performance is brought back
against block legacy path, follows the test result on lpfc:

- fio(libaio, bs:4k, dio, queue_depth:64, 20 jobs)


                   |v4.13-rc3       | v4.13-rc3   | patched v4.13-rc3
                   |legacy deadline | mq-none     | mq-none
---------------------------------------------------------------------
read        "iops" | 401749.4001    | 346237.5025 | 387536.4427
randread    "iops" | 25175.07121    | 21688.64067 | 25578.50374
write       "iops" | 376168.7578    | 335262.0475 | 370132.4735
reandwrite  "iops" | 25235.46163    | 24982.63819 | 23934.95610

                   |v4.13-rc3       | v4.13-rc3   | patched v4.13-rc3
                   |legacy deadline | mq-deadline | mq-deadline
------------------------------------------------------------------------------
read        "iops" | 401749.4001    | 35592.48901 | 401681.1137
randread    "iops" | 25175.07121    | 30029.52618 | 21446.68731
write       "iops" | 376168.7578    | 27340.56777 | 377356.7286
randwrite   "iops" | 25235.46163    | 24395.02969 | 24885.66152

Ming Lei (14):
  blk-mq-sched: fix scheduler bad performance
  blk-mq: rename flush_busy_ctx_data as ctx_iter_data
  blk-mq: introduce blk_mq_dispatch_rq_from_ctxs()
  blk-mq-sched: improve dispatching from sw queue
  blk-mq-sched: don't dequeue request until all in ->dispatch are
    flushed
  blk-mq-sched: introduce blk_mq_sched_queue_depth()
  blk-mq-sched: use q->queue_depth as hint for q->nr_requests
  blk-mq: introduce BLK_MQ_F_SHARED_DEPTH
  blk-mq-sched: cleanup blk_mq_sched_dispatch_requests()
  blk-mq-sched: introduce helpers for query, change busy state
  blk-mq: introduce helpers for operating ->dispatch list
  blk-mq: introduce pointers to dispatch lock & list
  blk-mq: pass 'request_queue *' to several helpers of operating BUSY
  blk-mq-sched: improve IO scheduling on SCSI devcie

 block/blk-mq-debugfs.c |  11 ++---
 block/blk-mq-sched.c   |  70 +++++++++++++++--------------
 block/blk-mq-sched.h   |  23 ++++++++++
 block/blk-mq.c         | 117 +++++++++++++++++++++++++++++++++++++++++++------
 block/blk-mq.h         |  72 ++++++++++++++++++++++++++++++
 block/blk-settings.c   |   2 +
 include/linux/blk-mq.h |   5 +++
 include/linux/blkdev.h |   5 +++
 8 files changed, 255 insertions(+), 50 deletions(-)

-- 
2.9.4
