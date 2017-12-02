From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] SCSI: delay run queue if device is blocked in scsi_dev_queue_ready()
Date: Sun,  3 Dec 2017 00:31:50 +0800
Message-ID: <20171202163150.1273-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Before commit 0df21c86bdbf ("scsi: implement .get_budget and .put_budget
for blk-mq"), we run queue after 3ms if device is blocked and queue is
idle, which is done in handling BLK_STS_RESOURCE. After commit 0df21c86bdbf
is introduced, queue won't be run any more under this situation.

IO hang is observed when timeout happened, and this patch fixes the IO
hang issue by running queue after delay in scsi_dev_queue_ready, just like
non-mq.

This issue can be triggered by the following script:

	#!/bin/sh
	rmmod scsi_debug
	modprobe scsi_debug max_queue=1

	DEVICE=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`

	DISK_DIR=`ls -d /sys/block/$DEVICE/device/scsi_disk/*`

	echo "using scsi device $DEVICE"
	echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
	echo starting loop $i
	echo "temporary write through" >$DISK_DIR/cache_type
	echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
	echo none > /sys/block/$DEVICE/queue/scheduler
	dd if=/dev/$DEVICE of=/dev/null bs=1M iflag=direct count=1 &
	sleep 5
	echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
	wait
	echo "SUCCESS"

Fixes: 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf9f36a1113f..9aada86055d3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1387,6 +1387,15 @@ static void scsi_unprep_fn(struct request_queue *q, struct request *req)
 	scsi_uninit_cmd(blk_mq_rq_to_pdu(req));
 }
 
+static void scsi_mq_delay_queue(struct request_queue *q, unsigned long msecs)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		blk_mq_delay_run_hw_queue(hctx, msecs);
+}
+
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
  * return 0.
@@ -1407,11 +1416,10 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 		 * unblock after device_blocked iterates to zero
 		 */
 		if (atomic_dec_return(&sdev->device_blocked) > 0) {
-			/*
-			 * For the MQ case we take care of this in the caller.
-			 */
 			if (!q->mq_ops)
 				blk_delay_queue(q, SCSI_QUEUE_DELAY);
+			else
+				scsi_mq_delay_queue(q, SCSI_QUEUE_DELAY);
 			goto out_dec;
 		}
 		SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
-- 
2.9.5
