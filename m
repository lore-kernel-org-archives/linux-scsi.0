From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] ll_rw_blk.c kerneldoc fixups
Date: Mon, 20 Jun 2005 14:24:27 +0200
Message-ID: <20050620122425.GH15021@suse.de>
References: <20050619093211.GC16872@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:21677 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261225AbVFTMXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:23:07 -0400
Content-Disposition: inline
In-Reply-To: <20050619093211.GC16872@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 19 2005, Christoph Hellwig wrote:

I've committed a modified patch based on this. There was a typo in the
blk_execute_rq_nowait() kerneldoc update as well, you duplicated the
name from blk_execute_rq().

It's committed to the rq-map branch of the linux-2.6-block.git tree.

(http://kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary)

-- 
Jens Axboe


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rq-map-7.diff"

diff-tree 73747aed04d3b3fb694961d025f81863b99c6898 (from 994ca9a19616f0d4161a9e825f0835925d522426)
tree d7cae2a3da1e15dc8c87b0ffbf2608eb8c999cc9
parent 994ca9a19616f0d4161a9e825f0835925d522426
author Christoph Hellwig  <hch@lst.de> 1119270061 +0200
committer Jens Axboe <axboe@suse.de> 1119270061 +0200

    [PATCH] ll_rw_blk.c kerneldoc updates
    
    The recent mapping changes didn't update the kerneldoc appropriately.
    
    Original from Christoph Hellwig <hch@lst.de>
    
    Signed-off-by: Jens Axboe <axboe@suse.de>

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2090,7 +2090,7 @@ EXPORT_SYMBOL(blk_insert_request);
 /**
  * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
- * @rw:		READ or WRITE data
+ * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
  *
@@ -2194,12 +2194,11 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
  * blk_rq_unmap_user - unmap a request with user data
- * @rq:		request to be unmapped
- * @bio:	bio for the request
+ * @bio:	bio to be unmapped
  * @ulen:	length of user buffer
  *
  * Description:
- *    Unmap a request previously mapped by blk_rq_map_user().
+ *    Unmap a bio previously mapped by blk_rq_map_user().
  */
 int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
 {
@@ -2220,9 +2219,10 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
 /**
  * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
  * @q:		request queue where request should be inserted
- * @rw:		READ or WRITE data
+ * @rq:		request to fill
  * @kbuf:	the kernel buffer
  * @len:	length of user data
+ * @gfp_mask:	memory allocation flags
  */
 int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
 		    unsigned int len, unsigned int gfp_mask)
@@ -2251,6 +2251,18 @@ int blk_rq_map_kern(request_queue_t *q, 
 
 EXPORT_SYMBOL(blk_rq_map_kern);
 
+/**
+ * blk_execute_rq_nowait - insert a request into queue for execution
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
@@ -2273,7 +2285,7 @@ void blk_execute_rq_nowait(request_queue
  *
  * Description:
  *    Insert a fully prepared request at the back of the io scheduler queue
- *    for execution.
+ *    for execution and wait for completion.
  */
 int blk_execute_rq(request_queue_t *q, struct gendisk *bd_disk,
 		   struct request *rq, int at_head)

--LQksG6bCIzRHxTLp--
