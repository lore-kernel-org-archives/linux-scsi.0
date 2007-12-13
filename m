From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 01/30] blk_end_request: add new request
 completion interface (take 4)
Date: Wed, 12 Dec 2007 20:32:32 -0500 (EST)
Message-ID: <20071212.203232.48534866.k-ueda@ct.jp.nec.com>
References: <20071211.174030.10291764.k-ueda@ct.jp.nec.com>
	<1197464017.4203.21.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1197464017.4203.21.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi James, Jens,

On Wed, 12 Dec 2007 07:53:36 -0500, James Bottomley wrote:
> On Tue, 2007-12-11 at 17:40 -0500, Kiyoshi Ueda wrote:
> > This patch adds 2 new interfaces for request completion:
> >   o blk_end_request()   : called without queue lock
> >   o __blk_end_request() : called with queue lock held
> > 
> > blk_end_request takes 'error' as an argument instead of 'uptodate',
> > which current end_that_request_* take.
> > The meanings of values are below and the value is used when bio is
> > completed.
> >     0 : success
> >   < 0 : error
> > 
> > Some device drivers call some generic functions below between
> > end_that_request_{first/chunk} and end_that_request_last().
> >   o add_disk_randomness()
> >   o blk_queue_end_tag()
> >   o blkdev_dequeue_request()
> 
> If we can roll the whole thing together, that would be nice.  However,
> the way you're doing it with this patch, we now have an asymmetrical
> interface:  The request routine must explicitly start the tag, but now
> doesn't have to end it.
> 
> We really need symmetry.  Either go back to start tag/end tag, or absorb
> the whole lot into the block infrastructure.
> 
> The original reason for the explicit start/end is that there are some
> requests on a tagged device that aren't able to be tagged by the block
> layer (some devices reserve tag numbers for specific meanings).
> However, I don't think there's any driver that actually implemented this
> feature.

As far as I investigated in 2.6.24-rc5, only scsi uses the blk_queue_tag
and no files in drivers/scsi reserving tag_index in Scsi_Host->bqt.
So I would like to take the "absorbing start tag in the block layer" way.

The patch below is on top of the blk_end_request patch-set.
Is it acceptable?

Thanks,
Kiyoshi Ueda



Subject: [PATCH 31/31] blk_end_request: merge start_tag to block layer


This patch merges blk_queue_start_tag() into blkdev_dequeue_request().

blk_queue_start_tag() and blk_queue_end_tag() are a pair of
interfaces for starting/ending request tagging.
Since with the new blk_end_request interfaces, blk_queue_end_tag()
is done implicitly in the block layer, blk_queue_start_tag() should
be done in the block layer, too, for keeping the interface symmetric.

Originally, the start/end tag was not done by the block layer so that
drivers can choose tag numbers for their specific meanings.
But no driver uses the feature.
Scsi is the only user of the block layer tagging and it uses
the generic blk_queue_start/end_tag.
So moving the start/end tag to the block layer is not an issue now.


Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c       |    2 +-
 drivers/scsi/scsi_lib.c |    3 +--
 include/linux/blkdev.h  |   11 ++++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

Index: 2.6.24-rc5/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc5.orig/block/ll_rw_blk.c
+++ 2.6.24-rc5/block/ll_rw_blk.c
@@ -1115,7 +1115,7 @@ int blk_queue_start_tag(struct request_q
 	rq->cmd_flags |= REQ_QUEUED;
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
-	blkdev_dequeue_request(rq);
+	elv_dequeue_request(q, rq);
 	list_add(&rq->queuelist, &q->tag_busy_list);
 	bqt->busy++;
 	return 0;
Index: 2.6.24-rc5/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.24-rc5.orig/drivers/scsi/scsi_lib.c
+++ 2.6.24-rc5/drivers/scsi/scsi_lib.c
@@ -1530,8 +1530,7 @@ static void scsi_request_fn(struct reque
 		/*
 		 * Remove the request from the request list.
 		 */
-		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
-			blkdev_dequeue_request(req);
+		blkdev_dequeue_request(req);
 		sdev->device_busy++;
 
 		spin_unlock(q->queue_lock);
Index: 2.6.24-rc5/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc5.orig/include/linux/blkdev.h
+++ 2.6.24-rc5/include/linux/blkdev.h
@@ -747,11 +747,6 @@ extern void blk_complete_request(struct 
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
-static inline void blkdev_dequeue_request(struct request *req)
-{
-	elv_dequeue_request(req->q, req);
-}
-
 /*
  * Access functions for manipulating queue properties
  */
@@ -814,6 +809,12 @@ static inline struct request *blk_map_qu
 	return bqt->tag_index[tag];
 }
 
+static inline void blkdev_dequeue_request(struct request *req)
+{
+	if (!(blk_queue_tagged(req->q) && !blk_queue_start_tag(req->q, req)))
+		elv_dequeue_request(req->q, req);
+}
+
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
 #define MAX_PHYS_SEGMENTS 128
