From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] p00001_scsi_tcq_queue_lock
Date: Mon, 09 Aug 2004 09:14:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411786DF.2040009@us.ibm.com>
References: <410FD03E.6040305@us.ibm.com> <1091815154.2421.15.camel@mulgrave> <4117846B.7030302@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070705020705070100040101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:63465 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266611AbUHIOPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 10:15:04 -0400
In-Reply-To: <4117846B.7030302@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070705020705070100040101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Oops. I guess this was the actual patch I sent.

Brian King wrote:
> James Bottomley wrote:
> 
>> On Tue, 2004-08-03 at 10:49, Brian King wrote:
>>
>>> Add locking to scsi_activate_tcq and scsi_deactivate_tcq to fix a race
>>> condition that can occur when disabling tcqing with commands in flight.
>>
>>
>>
>> It's possible to do it like this.  However, we should really quiesce the
>> SCSI device before disabling tcq.  It is not legal in the scsi spec to
>> have both tagged and untagged commands outstanding.  Most drives do the
>> right thing and return BUSY to an untagged request if they have tags in
>> flight.  
> 
> 
> Ok. I agree that we do not want both tagged and untagged requests going 
> to the device. In the case of the ipr driver, the adapter microcode 
> handles this for me. If there are tagged requests outstanding to a 
> device and an untagged request is sent, the tagged requests must first 
> finish, then the untagged request is sent to the device with no other 
> requests outstanding.
> 
>> Also, we have to wait until all tags return before freeing the
>> block layer tag structures...and there's always the devices that do
>> strange things in this situation...
> 
> 
> I sent the following patch to Jens last week as well and he applied it. 
> This fixes the free problem you mention.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------070705020705070100040101
Content-Type: text/plain;
 name="blk_queue_free_tags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_queue_free_tags.patch"


Currently blk_queue_free_tags cannot be called with ops outstanding. The
scsi_tcq API defined to LLD scsi drivers allows for scsi_deactivate_tcq
to be called (which calls blk_queue_free_tags) with ops outstanding. Change
blk_queue_free_tags to no longer free the tags, but rather just disable
tagged queuing and also modify blk_queue_init_tags to handle re-enabling
tagged queuing after it has been disabled.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc2-bjking1/drivers/block/ll_rw_blk.c |   35 +++++++++++++++++-----
 1 files changed, 28 insertions(+), 7 deletions(-)

diff -puN drivers/block/ll_rw_blk.c~blk_queue_free_tags drivers/block/ll_rw_blk.c
--- linux-2.6.8-rc2/drivers/block/ll_rw_blk.c~blk_queue_free_tags	2004-08-03 10:53:50.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/drivers/block/ll_rw_blk.c	2004-08-03 11:05:06.000000000 -0500
@@ -482,15 +482,14 @@ struct request *blk_queue_find_tag(reque
 EXPORT_SYMBOL(blk_queue_find_tag);
 
 /**
- * blk_queue_free_tags - release tag maintenance info
+ * _blk_queue_free_tags - release tag maintenance info
  * @q:  the request queue for the device
  *
  *  Notes:
  *    blk_cleanup_queue() will take care of calling this function, if tagging
- *    has been used. So there's usually no need to call this directly, unless
- *    tagging is just being disabled but the queue remains in function.
+ *    has been used. So there's no need to call this directly.
  **/
-void blk_queue_free_tags(request_queue_t *q)
+static void _blk_queue_free_tags(request_queue_t *q)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
 
@@ -514,6 +513,19 @@ void blk_queue_free_tags(request_queue_t
 	q->queue_flags &= ~(1 << QUEUE_FLAG_QUEUED);
 }
 
+/**
+ * blk_queue_free_tags - release tag maintenance info
+ * @q:  the request queue for the device
+ *
+ *  Notes:
+ *	This is used to disabled tagged queuing to a device, yet leave
+ *	queue in function.
+ **/
+void blk_queue_free_tags(request_queue_t *q)
+{
+	clear_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+}
+
 EXPORT_SYMBOL(blk_queue_free_tags);
 
 static int
@@ -564,13 +576,22 @@ fail:
 int blk_queue_init_tags(request_queue_t *q, int depth,
 			struct blk_queue_tag *tags)
 {
-	if (!tags) {
+	int rc;
+
+	BUG_ON(tags && q->queue_tags && tags != q->queue_tags);
+
+	if (!tags && !q->queue_tags) {
 		tags = kmalloc(sizeof(struct blk_queue_tag), GFP_ATOMIC);
 		if (!tags)
 			goto fail;
 
 		if (init_tag_map(q, tags, depth))
 			goto fail;
+	} else if (q->queue_tags) {
+		if ((rc = blk_queue_resize_tags(q, depth)))
+			return rc;
+		set_bit(QUEUE_FLAG_QUEUED, &q->queue_flags);
+		return 0;
 	} else
 		atomic_inc(&tags->refcnt);
 
@@ -1333,8 +1354,8 @@ void blk_cleanup_queue(request_queue_t *
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
-	if (blk_queue_tagged(q))
-		blk_queue_free_tags(q);
+	if (q->queue_tags)
+		_blk_queue_free_tags(q);
 
 	kmem_cache_free(requestq_cachep, q);
 }
_

--------------070705020705070100040101--

