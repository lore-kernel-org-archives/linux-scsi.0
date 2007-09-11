From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 02/27] blk_end_request: add blk_rq_size()
	functions (take 2)
Date: Tue, 11 Sep 2007 14:56:25 -0400 (EDT)
Message-ID: <20070911.145625.110018211.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds functions to get the size of request in bytes.
They are useful because blk_end_request() takes bytes
as a completed I/O size instead of sectors.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/blkdev.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

diff -rupN 01-blkendreq-interface/include/linux/blkdev.h 02-rq-size-macro/include/linux/blkdev.h
--- 01-blkendreq-interface/include/linux/blkdev.h	2007-09-10 17:42:56.000000000 -0400
+++ 02-rq-size-macro/include/linux/blkdev.h	2007-09-10 17:44:43.000000000 -0400
@@ -737,6 +737,30 @@ extern void end_queued_request(struct re
 extern void blk_complete_request(struct request *);
 
 /*
+ * blk_end_request() takes bytes instead of sectors as a complete size.
+ * blk_rq_size() returns the entire size left to complete in the request.
+ * blk_rq_cur_size() returns the size left to complete in the current segment.
+ */
+static inline int blk_rq_size(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return rq->hard_nr_sectors << 9;
+
+	return rq->data_len;
+}
+
+static inline int blk_rq_cur_size(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return rq->current_nr_sectors << 9;
+
+	if (rq->bio)
+		return rq->bio->bi_size;
+
+	return rq->data_len;
+}
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
