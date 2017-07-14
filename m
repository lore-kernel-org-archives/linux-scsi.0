From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/6] SCSI: use blk_mq_run_hw_queues() in scsi_kick_queue()
Date: Sat, 15 Jul 2017 07:15:57 +0800
Message-ID: <20170714231601.14444-3-ming.lei@redhat.com>
References: <20170714231601.14444-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170714231601.14444-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now SCSI won't stop queue at all, and not necessary to use
blk_mq_start_hw_queues() to clear the state of 'stopped',
so switch to blk_mq_run_hw_queues() instead.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..91d890356b78 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -333,7 +333,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 static void scsi_kick_queue(struct request_queue *q)
 {
 	if (q->mq_ops)
-		blk_mq_start_hw_queues(q);
+		blk_mq_run_hw_queues(q, false);
 	else
 		blk_run_queue(q);
 }
-- 
2.9.4
