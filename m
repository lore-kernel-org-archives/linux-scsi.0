From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 27/28] blk_end_request: changing scsi mid-layer
 for bidi (take 3)
Date: Fri, 30 Nov 2007 18:35:12 -0500 (EST)
Message-ID: <20071130.183512.120442861.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts bidi of scsi mid-layer to use blk_end_request().

rq->next_rq represents a pair of bidi requests.
(There are no other use of 'next_rq' of struct request.)
For both requests in the pair, end_that_request_chunk() should be
called before end_that_request_last() is called for one of them.
Since the calls to end_that_request_first()/chunk() and
end_that_request_last() are packaged into blk_end_request(),
the handling of next_rq completion has to be moved into
blk_end_request(), too.

Bidi sets its specific value to rq->data_len before the request is
completed so that upper-layer can read it.
This setting must be between end_that_request_chunk() and
end_that_request_last(), because rq->data_len may be used
in end_that_request_chunk() by blk_trace and so on.
To satisfy the requirement, use blk_end_request_callback() which
is added in PATCH 25 only for the tricky drivers.

If bidi didn't reuse rq->data_len and added new members to request
for the specific value, it could set before end_that_request_chunk()
and use the standard blk_end_request() like below.

void scsi_end_bidi_request(struct scsi_cmnd *cmd)
{
	struct request *req = cmd->request;

	rq->resid = scsi_out(cmd)->resid;
	rq->next_rq->resid = scsi_in(cmd)->resid;

	if (blk_end_request(req, 1, req->data_len))
		BUG();

	scsi_release_buffers(cmd);
	scsi_next_command(cmd);
}

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c       |   18 +++++++++++++
 drivers/scsi/scsi_lib.c |   66 ++++++++++++++++++++++++------------------------
 2 files changed, 52 insertions(+), 32 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
+++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
@@ -629,28 +629,6 @@ void scsi_run_host_queues(struct Scsi_Ho
 		scsi_run_queue(sdev->request_queue);
 }
 
-static void scsi_finalize_request(struct scsi_cmnd *cmd, int uptodate)
-{
-	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
-	unsigned long flags;
-
-	add_disk_randomness(req->rq_disk);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-
-	end_that_request_last(req, uptodate);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	scsi_next_command(cmd);
-}
-
 /*
  * Function:    scsi_end_request()
  *
@@ -921,6 +899,20 @@ void scsi_release_buffers(struct scsi_cm
 EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
+ * Called from blk_end_request_callback() after all DATA in rq and its next_rq
+ * are completed before rq is completed/freed.
+ */
+static int scsi_end_bidi_request_cb(struct request *rq)
+{
+	struct scsi_cmnd *cmd = rq->special;
+
+	rq->data_len = scsi_out(cmd)->resid;
+	rq->next_rq->data_len = scsi_in(cmd)->resid;
+
+	return 0;
+}
+
+/*
  * Bidi commands Must be complete as a whole, both sides at once.
  * If part of the bytes were written and lld returned
  * scsi_in()->resid and/or scsi_out()->resid this information will be left
@@ -931,22 +923,32 @@ void scsi_end_bidi_request(struct scsi_c
 {
 	struct request *req = cmd->request;
 
-	end_that_request_chunk(req, 1, req->data_len);
-	req->data_len = scsi_out(cmd)->resid;
-
-	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
-	req->next_rq->data_len = scsi_in(cmd)->resid;
-
-	scsi_release_buffers(cmd);
-
 	/*
 	 *FIXME: If ll_rw_blk.c is changed to also put_request(req->next_rq)
-	 *       in end_that_request_last() then this WARN_ON must be removed.
+	 *       in blk_end_request() then this WARN_ON must be removed.
 	 *       for now, upper-driver must have registered an end_io.
 	 */
 	WARN_ON(!req->end_io);
 
-	scsi_finalize_request(cmd, 1);
+	/*
+	 * blk_end_request() family take care of data completion of next_rq.
+	 *
+	 * req->data_len and req->next_rq->data_len must be set after
+	 * all data are completed, since they may be referenced during
+	 * the data completion process.
+	 * So use the callback feature of blk_end_request() here.
+	 *
+	 * NOTE: If bidi doesn't reuse the data_len field for upper-layer's
+	 *       reference (e.g. adds new members for it to struct request),
+	 *       we can use the standard blk_end_request() interface here.
+	 */
+	if (blk_end_request_callback(req, 1, req->data_len,
+				     scsi_end_bidi_request_cb))
+		/* req has not been completed */
+		BUG();
+
+	scsi_release_buffers(cmd);
+	scsi_next_command(cmd);
 }
 
 /*
Index: 2.6.24-rc3-mm2/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc3-mm2.orig/block/ll_rw_blk.c
+++ 2.6.24-rc3-mm2/block/ll_rw_blk.c
@@ -3817,6 +3817,12 @@ int blk_end_request(struct request *rq, 
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		if (__end_that_request_first(rq, uptodate, nr_bytes))
 			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, uptodate,
+					     blk_rq_bytes(rq->next_rq)))
+			return 1;
 	}
 
 	add_disk_randomness(rq->rq_disk);
@@ -3840,6 +3846,12 @@ int __blk_end_request(struct request *rq
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		if (__end_that_request_first(rq, uptodate, nr_bytes))
 			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, uptodate,
+					     blk_rq_bytes(rq->next_rq)))
+			return 1;
 	}
 
 	add_disk_randomness(rq->rq_disk);
@@ -3884,6 +3896,12 @@ int blk_end_request_callback(struct requ
 	if (blk_fs_request(rq) || blk_pc_request(rq)) {
 		if (__end_that_request_first(rq, uptodate, nr_bytes))
 			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, uptodate,
+					     blk_rq_bytes(rq->next_rq)))
+			return 1;
 	}
 
 	/* Special feature for tricky drivers */
