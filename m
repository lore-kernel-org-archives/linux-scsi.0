From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 0/4] Make SCSI transport recovery more robust
Date: Wed, 10 Jan 2018 10:18:13 -0800
Message-ID: <20180110181817.25166-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

A longstanding issue with the SCSI core is that several SCSI transport drivers
use scsi_target_block() and scsi_target_unblock() to avoid concurrent
.queuecommand() calls during e.g. transport recovery but that this is not
sufficient to protect from such calls. Hence this patch series. An additional
benefit of this patch series is that it allows to remove an ugly hack from
the SRP initiator driver. Please consider this patch series for kernel v4.16.

Thanks,

Bart.

Changes compared to v1:
- Renamed blk_wait_if_quiesced() into blk_start_wait_if_quiesced().
- Mentioned in the comment above blk_start_wait_if_quiesced() that every call
  of this function has to be followed by a call of
  blk_finish_wait_if_quiesced().

Bart Van Assche (4):
  blk-mq: Rename request_queue.mq_freeze_wq into mq_wq
  block: Introduce blk_start_wait_if_quiesced() and
    blk_finish_wait_if_quiesced()
  scsi: Avoid that .queuecommand() gets called for a quiesced SCSI
    device
  IB/srp: Fix a sleep-in-invalid-context bug

 block/blk-core.c                    | 11 +++---
 block/blk-mq.c                      | 74 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 +----------
 drivers/scsi/scsi_error.c           |  3 ++
 include/linux/blk-mq.h              |  2 +
 include/linux/blkdev.h              |  2 +-
 6 files changed, 83 insertions(+), 30 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
