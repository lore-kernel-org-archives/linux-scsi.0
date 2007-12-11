From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 02/30] blk_end_request: add/export functions to
 get request size (take 4)
Date: Tue, 11 Dec 2007 17:41:17 -0500 (EST)
Message-ID: <20071211.174117.32341968.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds/exports functions to get the size of request in bytes.
They are useful because blk_end_request interfaces take bytes
as a completed I/O size instead of sectors.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   25 ++++++++++++++++++++++---
 include/linux/blkdev.h |    8 ++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -739,6 +739,14 @@ extern void end_dequeued_request(struct 
 extern void blk_complete_request(struct request *);
 
 /*
+ * blk_end_request() takes bytes instead of sectors as a complete size.
+ * blk_rq_bytes() returns bytes left to complete in the entire request.
+ * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
+ */
+extern unsigned int blk_rq_bytes(struct request *rq);
+extern unsigned int blk_rq_cur_bytes(struct request *rq);
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3701,13 +3701,32 @@ static inline void __end_request(struct 
 	}
 }
 
-static unsigned int rq_byte_size(struct request *rq)
+/**
+ * blk_rq_bytes - Returns bytes left to complete in the entire request
+ **/
+unsigned int blk_rq_bytes(struct request *rq)
 {
 	if (blk_fs_request(rq))
 		return rq->hard_nr_sectors << 9;
 
 	return rq->data_len;
 }
+EXPORT_SYMBOL_GPL(blk_rq_bytes);
+
+/**
+ * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
+ **/
+unsigned int blk_rq_cur_bytes(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return rq->current_nr_sectors << 9;
+
+	if (rq->bio)
+		return rq->bio->bi_size;
+
+	return rq->data_len;
+}
+EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
 
 /**
  * end_queued_request - end all I/O on a queued request
@@ -3722,7 +3741,7 @@ static unsigned int rq_byte_size(struct 
  **/
 void end_queued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, rq_byte_size(rq), 1);
+	__end_request(rq, uptodate, blk_rq_bytes(rq), 1);
 }
 EXPORT_SYMBOL(end_queued_request);
 
@@ -3739,7 +3758,7 @@ EXPORT_SYMBOL(end_queued_request);
  **/
 void end_dequeued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, rq_byte_size(rq), 0);
+	__end_request(rq, uptodate, blk_rq_bytes(rq), 0);
 }
 EXPORT_SYMBOL(end_dequeued_request);
 
