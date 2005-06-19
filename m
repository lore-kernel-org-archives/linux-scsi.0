From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, scsi-block-2.6] ll_rw_blk.c kerneldoc fixups
Date: Sun, 19 Jun 2005 11:32:11 +0200
Message-ID: <20050619093211.GC16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3498 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262073AbVFSJcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 05:32:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Index: linux-2.6/drivers/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/ll_rw_blk.c	2005-06-18 17:49:09.000000000 +0200
+++ linux-2.6/drivers/block/ll_rw_blk.c	2005-06-18 17:55:28.000000000 +0200
@@ -2090,7 +2090,7 @@
 /**
  * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
- * @rw:		READ or WRITE data
+ * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
  *
@@ -2098,14 +2098,14 @@
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
  *    a kernel bounce buffer is used.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
- *    still in process context.
+ *    A matching blk_rq_unmap_user_iov() must be issued at the end of io,
+ *    while still in process context.
  *
  *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
  *    before being submitted to the device, as pages mapped may be out of
  *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
+ *    original bio must be passed back in to blk_rq_unmap_user_iov() for
+ *    proper unmapping.
  */
 int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
 		    unsigned int len)
@@ -2194,13 +2194,12 @@
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
- * blk_rq_unmap_user - unmap a request with user data
- * @rq:		request to be unmapped
- * @bio:	bio for the request
+ * blk_rq_unmap_user - unmap a bio with user data
+ * @bio:	bio to be unmapped
  * @ulen:	length of user buffer
  *
  * Description:
- *    Unmap a request previously mapped by blk_rq_map_user().
+ *    Unmap a bio previously mapped by blk_rq_map_user().
  */
 int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
 {
@@ -2221,9 +2220,10 @@
 /**
  * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
- * @rw:		READ or WRITE data
+ * @rw:		request to fill
  * @kbuf:	the kernel buffer
  * @len:	length of user data
+ * @gfp_mask:	memory allocation flags
  */
 int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
 		    unsigned int len, unsigned int gfp_mask)
@@ -2252,6 +2252,18 @@
 
 EXPORT_SYMBOL(blk_rq_map_kern);
 
+/**
+ * blk_execute_rq - insert a request into queue for execution
+ * @q:		queue to insert the request in
+ * @bd_disk:	matching gendisk
+ * @rq:		request to insert
+ * @at_head:    insert request at head or tail of queue
+ * @done:	I/O completion handler
+ *
+ * Description:
+ *    Insert a fully prepared request at the back of the io scheduler queue
+ *    for execution.  Don't wait for completion.
+ */
 void blk_execute_rq_nowait(request_queue_t *q, struct gendisk *bd_disk,
 			   struct request *rq, int at_head,
 			   void (*done)(struct request *))
@@ -2274,7 +2286,7 @@
  *
  * Description:
  *    Insert a fully prepared request at the back of the io scheduler queue
- *    for execution.
+ *    for execution and wait for completion.
  */
 int blk_execute_rq(request_queue_t *q, struct gendisk *bd_disk,
 		   struct request *rq, int at_head)
