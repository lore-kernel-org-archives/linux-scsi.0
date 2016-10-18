From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 02/11] blk-mq: Introduce blk_mq_hctx_stopped()
Date: Tue, 18 Oct 2016 14:49:09 -0700
Message-ID: <b5b0ffcc-767d-1b90-9c5a-52c57690dea8@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0055.outbound.protection.outlook.com ([104.47.36.55]:10192
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754138AbcJRVtV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 17:49:21 -0400
In-Reply-To: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Multiple functions test the BLK_MQ_S_STOPPED bit so introduce
a helper function that performs this test.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq.c         | 12 ++++++------
 drivers/md/dm-rq.c     |  2 +-
 include/linux/blk-mq.h |  5 +++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b5dcafb..b52b3a6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -787,7 +787,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	struct list_head *dptr;
 	int queued;
 
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (unlikely(blk_mq_hctx_stopped(hctx)))
 		return;
 
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
@@ -912,8 +912,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state) ||
-	    !blk_mq_hw_queue_mapped(hctx)))
+	if (unlikely(blk_mq_hctx_stopped(hctx) ||
+		     !blk_mq_hw_queue_mapped(hctx)))
 		return;
 
 	if (!async && !(hctx->flags & BLK_MQ_F_BLOCKING)) {
@@ -938,7 +938,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if ((!blk_mq_hctx_has_pending(hctx) &&
 		    list_empty_careful(&hctx->dispatch)) ||
-		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		    blk_mq_hctx_stopped(hctx))
 			continue;
 
 		blk_mq_run_hw_queue(hctx, async);
@@ -988,7 +988,7 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		if (!blk_mq_hctx_stopped(hctx))
 			continue;
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
@@ -1332,7 +1332,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (test_bit(BLK_MQ_S_STOPPED, &data.hctx->state) ||
+		if (blk_mq_hctx_stopped(data.hctx) ||
 		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
 			blk_mq_insert_request(old_rq, false, true, true);
 		goto done;
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index dc75bea..76d1666 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -909,7 +909,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * hctx that it really shouldn't.  The following check guards
 	 * against this rarity (albeit _not_ race-free).
 	 */
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (unlikely(blk_mq_hctx_stopped(hctx)))
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
 	if (ti->type->busy && ti->type->busy(ti))
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 535ab2e..bb000c3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -239,6 +239,11 @@ int blk_mq_reinit_tagset(struct blk_mq_tag_set *set);
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 
+static inline bool blk_mq_hctx_stopped(struct blk_mq_hw_ctx *hctx)
+{
+	return test_bit(BLK_MQ_S_STOPPED, &hctx->state);
+}
+
 /*
  * Driver command data is immediately after the request. So subtract request
  * size to get back to the original request, add request size to get the PDU.
-- 
2.10.1

