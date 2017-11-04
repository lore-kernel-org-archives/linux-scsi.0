From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] SCSI: don't get target/host busy_count in scsi_mq_get_budget()
Date: Sat,  4 Nov 2017 09:55:34 +0800
Message-ID: <20171104015534.32684-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751419AbdKDBz5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Nov 2017 21:55:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>

It is very expensive to atomic_inc/atomic_dec the host wide counter of
host->busy_count, and it should have been avoided via blk-mq's mechanism
of getting driver tag, which uses the more efficient way of sbitmap queue.

Also we don't check atomic_read(&sdev->device_busy) in scsi_mq_get_budget()
and don't run queue if the counter becomes zero, so IO hang may be caused
if all requests are completed just before the current SCSI device
is added to shost->starved_list.

Fixes: 0df21c86bdbf(scsi: implement .get_budget and .put_budget for blk-mq)
Reported-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---

 drivers/scsi/scsi_lib.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a098af3070a1..7f218ef61900 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1944,11 +1944,7 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
 
-	atomic_dec(&shost->host_busy);
-	if (scsi_target(sdev)->can_queue > 0)
-		atomic_dec(&scsi_target(sdev)->target_busy);
 	atomic_dec(&sdev->device_busy);
 	put_device(&sdev->sdev_gendev);
 }
@@ -1957,7 +1953,6 @@ static blk_status_t scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
 	blk_status_t ret;
 
 	ret = prep_to_mq(scsi_prep_state_check(sdev, NULL));
@@ -1968,18 +1963,9 @@ static blk_status_t scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 		goto out;
 	if (!scsi_dev_queue_ready(q, sdev))
 		goto out_put_device;
-	if (!scsi_target_queue_ready(shost, sdev))
-		goto out_dec_device_busy;
-	if (!scsi_host_queue_ready(q, shost, sdev))
-		goto out_dec_target_busy;
 
 	return BLK_STS_OK;
 
-out_dec_target_busy:
-	if (scsi_target(sdev)->can_queue > 0)
-		atomic_dec(&scsi_target(sdev)->target_busy);
-out_dec_device_busy:
-	atomic_dec(&sdev->device_busy);
 out_put_device:
 	put_device(&sdev->sdev_gendev);
 out:
@@ -1992,6 +1978,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct request *req = bd->rq;
 	struct request_queue *q = req->q;
 	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	blk_status_t ret;
 	int reason;
@@ -2001,10 +1988,15 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		goto out_put_budget;
 
 	ret = BLK_STS_RESOURCE;
+	if (!scsi_target_queue_ready(shost, sdev))
+		goto out_put_budget;
+	if (!scsi_host_queue_ready(q, shost, sdev))
+		goto out_dec_target_busy;
+
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
 		if (ret != BLK_STS_OK)
-			goto out_put_budget;
+			goto out_dec_host_busy;
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
 		blk_mq_start_request(req);
@@ -2022,11 +2014,16 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
 		ret = BLK_STS_RESOURCE;
-		goto out_put_budget;
+		goto out_dec_host_busy;
 	}
 
 	return BLK_STS_OK;
 
+out_dec_host_busy:
+       atomic_dec(&shost->host_busy);
+out_dec_target_busy:
+	if (scsi_target(sdev)->can_queue > 0)
+		atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
 	scsi_mq_put_budget(hctx);
 	switch (ret) {
-- 
2.9.5
