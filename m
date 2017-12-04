From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Mon,  4 Dec 2017 09:30:32 -0800
Message-ID: <20171204173032.16330-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 0df21c86bdbf introduced several bugs:
* A SCSI queue stall for queue depths > 1, addressed by commit
  88022d7201e9 ("blk-mq: don't handle failure in .get_budget")
* A systematic lockup for SCSI queues with queue depth 1. The
  following test reproduces that bug systematically:
  - Change the SRP initiator such that SCSI target queue depth is
    limited to 1.
  - Run the following command:
      srp-test/run_tests -f xfs -d -e none -r 60 -t 01
  See also "[PATCH 4/7] blk-mq: Avoid that request processing
  stalls when sharing tags"
  (https://marc.info/?l=linux-block&m=151208695316857). Note:
  reverting commit 0df21c86bdbf also fixes a sporadic SCSI request
  queue lockup while inserting a blk_mq_sched_mark_restart_hctx()
  before all blk_mq_dispatch_rq_list() calls only fixes the
  systematic lockup for queue depth 1.
* A scsi_debug lockup - see also "[PATCH] SCSI: delay run queue if
  device is blocked in scsi_dev_queue_ready()"
  (https://marc.info/?l=linux-block&m=151223233407154).

I think the above means that it is too risky to try to fix all bugs
introduced by commit 0df21c86bdbf before kernel v4.15 is released.
Hence revert that commit.

Fixes: commit 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_lib.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 84bd2b16d216..a7e7966f1477 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1976,9 +1976,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-	blk_status_t ret;
+	blk_status_t ret = BLK_STS_RESOURCE;
 	int reason;
 
+	if (!scsi_mq_get_budget(hctx))
+		goto out;
 	ret = prep_to_mq(scsi_prep_state_check(sdev, req));
 	if (ret != BLK_STS_OK)
 		goto out_put_budget;
@@ -2022,6 +2024,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
 	scsi_mq_put_budget(hctx);
+out:
 	switch (ret) {
 	case BLK_STS_OK:
 		break;
@@ -2225,8 +2228,6 @@ struct request_queue *scsi_old_alloc_queue(struct scsi_device *sdev)
 }
 
 static const struct blk_mq_ops scsi_mq_ops = {
-	.get_budget	= scsi_mq_get_budget,
-	.put_budget	= scsi_mq_put_budget,
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
-- 
2.15.0
