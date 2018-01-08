From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/4] Make SCSI transport recovery more robust
Date: Mon,  8 Jan 2018 10:50:07 -0800
Message-ID: <20180108185011.30018-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

A longstanding issue with the SCSI core is that several SCSI transport drivers
use scsi_target_block() and scsi_target_unblock() to avoid concurrent
.queuecommand() calls during e.g. transport recovery but that this is not
sufficient to protect from such calls. Hence this patch series. Please
consider this patch series for kernel v4.16.

Thanks,

Bart.

Bart Van Assche (4):
  blk-mq: Rename request_queue.mq_freeze_wq into mq_wq
  block: Introduce blk_wait_if_quiesced() and
    blk_finish_wait_if_quiesced()
  scsi: Avoid that .queuecommand() gets called for a quiesced SCSI
    device
  IB/srp: Fix a sleep-in-invalid-context bug

 block/blk-core.c                    | 11 +++---
 block/blk-mq.c                      | 71 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 ++---------
 drivers/scsi/scsi_error.c           |  3 ++
 include/linux/blk-mq.h              |  2 ++
 include/linux/blkdev.h              |  2 +-
 6 files changed, 80 insertions(+), 30 deletions(-)

-- 
2.15.1
