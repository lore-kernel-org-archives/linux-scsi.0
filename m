From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V4 12/16] blokc: mq-deadline: Introduce dispatch helpers
Date: Sun, 24 Sep 2017 16:02:43 +0900
Message-ID: <20170924070247.25560-13-damien.lemoal@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22595 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIXHDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 03:03:06 -0400
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Avoid directly referencing the next_rq and fifo_list arrays using the
helper functions deadline_next_request() and deadline_fifo_request() to
facilitate changes in the dispatch request selection in
__dd_dispatch_request().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/mq-deadline.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index fb88fee0fb54..1236a464b547 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -196,13 +196,36 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
 }
 
 /*
+ * For the specified data direction, return the next request to
+ * dispatch using arrival ordered lists.
+ */
+static struct request *
+deadline_fifo_request(struct deadline_data *dd, int data_dir)
+{
+	if (list_empty(&dd->fifo_list[data_dir]))
+		return NULL;
+
+	return rq_entry_fifo(dd->fifo_list[data_dir].next);
+}
+
+/*
+ * For the specified data direction, return the next request to
+ * dispatch using sector position sorted lists.
+ */
+static struct request *
+deadline_next_request(struct deadline_data *dd, int data_dir)
+{
+	return dd->next_rq[data_dir];
+}
+
+/*
  * deadline_dispatch_requests selects the best request according to
  * read/write expire, fifo_batch, etc
  */
 static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 {
 	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
-	struct request *rq;
+	struct request *rq, *next_rq;
 	bool reads, writes;
 	int data_dir;
 
@@ -218,10 +241,9 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	/*
 	 * batches are currently reads XOR writes
 	 */
-	if (dd->next_rq[WRITE])
-		rq = dd->next_rq[WRITE];
-	else
-		rq = dd->next_rq[READ];
+	rq = deadline_next_request(dd, WRITE);
+	if (!rq)
+		rq = deadline_next_request(dd, READ);
 
 	if (rq && dd->batching < dd->fifo_batch)
 		/* we have a next request are still entitled to batch */
@@ -264,19 +286,20 @@ static struct request *__dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	/*
 	 * we are not running a batch, find best request for selected data_dir
 	 */
-	if (deadline_check_fifo(dd, data_dir) || !dd->next_rq[data_dir]) {
+	next_rq = deadline_next_request(dd, data_dir);
+	if (deadline_check_fifo(dd, data_dir) || !next_rq) {
 		/*
 		 * A deadline has expired, the last request was in the other
 		 * direction, or we have run out of higher-sectored requests.
 		 * Start again from the request with the earliest expiry time.
 		 */
-		rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
+		rq = deadline_fifo_request(dd, data_dir);
 	} else {
 		/*
 		 * The last req was the same dir and we have a next request in
 		 * sort order. No expired requests so continue on from here.
 		 */
-		rq = dd->next_rq[data_dir];
+		rq = next_rq;
 	}
 
 	dd->batching = 0;
-- 
2.13.5
