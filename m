From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 02 Mar 2009 14:33:23 -0600
Message-ID: <49AC4293.4030902@cs.wisc.edu>
References: <20090227230927.GA21377@roadking.ldev.net> <20090302153246A.fujita.tomonori@lab.ntt.co.jp> <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com> <49AC237A.7060005@cs.wisc.edu> <20090302183649.GB11787@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070803020508070306060606"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34404 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZCBUeZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2009 15:34:25 -0500
In-Reply-To: <20090302183649.GB11787@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Grant Grundler <grundler@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mike.miller@hp.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

This is a multi-part message in MIME format.
--------------070803020508070306060606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Mon, Mar 02 2009, Mike Christie wrote:
>> Grant Grundler wrote:
>>> On Sun, Mar 1, 2009 at 10:32 PM, FUJITA Tomonori
>>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> ...
>>>>> +/*
>>>>> + * For operations that cannot sleep, a command block is allocated at init,
>>>>> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
>>>>> + * which ones are free or in use.  Lock must be held when calling this.
>>>>> + * cmd_free() is the complement.
>>>>> + */
>>>>> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
>>>>> +{
>>>>> +     struct CommandList_struct *c;
>>>>> +     int i;
>>>>> +     union u64bit temp64;
>>>>> +     dma_addr_t cmd_dma_handle, err_dma_handle;
>>>>> +
>>>>> +     do {
>>>>> +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>>>>> +             if (i == h->nr_cmds)
>>>>> +                     return NULL;
>>>>> +     } while (test_and_set_bit
>>>>> +              (i & (BITS_PER_LONG - 1),
>>>>> +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
>>>> Using bitmap to manage free commands looks too complicated a bit to
>>>> me. Can we just use lists for command management?
>>> Bit maps are generally more efficient than lists since we touch less data.
>>> For both search and moving elements from free<->busy lists. This probably
>>> won't matter if we are talking less than 10K IOPS. And willy demonstrated
>>> other layers have pretty high overhead (block, libata and SCSI midlayer)
>>> at high transaction rates.
>>>
>> If it was just needing this for the queuecommand path it would be  
>> simple. For the queuecommand path we could just use the scsi host  
>> tagging code for the index. You do not need a lock in the queuecommand  
>> path for getting a index and command, and you do not need to duplicate  
>> the tag/index allocation code in the block/scsi code
>>
>> A problem with the host tagging is what to do if you need a tag/index  
>> for a internal command. In the slow path like the device reset and cache  
>> flush case you could use a list or preallocated command or whatever  
>> other drivers are using that makes you happy.
>>
>> Or for the reset/shutdown/internal path could we come up with a  
>> extension to the existing API. Maybe just add some wrapper around some  
>> of blk_queue_start_tag that takes a the bqt (the bqt would come from the  
>> host wide one) and allocates the tag (need a something similar for the  
>> release side).
> 
> This is precisely what I did for libata, here is is interleaved with
> some other stuff:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=f557570ec6042370333b6b9c33bbbae175120a89
> 
> It needs a little more polish and so on, but the concept is identical to
> what you describe for this case. And I agree, it's much better to use
> the same index instead of generating/maintaining seperate bitmaps for
> this type of thing.
> 

In that patch where does the tag come from? Is it from libata?

What if we wanted and/or needed the bqt to give us a tag value and we 
need it for the lookup? It looks like for hpsa we could kill its 
find_first_zero_bit code and use and use the code in blk_queue_start_tag.

iscsi also needs the unique tag and then it needs the 
blk_map_queue_find_tag functionality too. iscsi needs the lookup and tag 
for host/transport level commands that do not have a scsi 
command/request. The tag value has to be unique accross the 
host/transport (acutally just the transport, but ignore that for now to 
make it simple and because for software iscsi we do a host per transport 
connection). Do you think something like the attached patch would be ok 
(it is only compile tested)?

--------------070803020508070306060606
Content-Type: text/plain;
 name="make-tagging-more-generic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="make-tagging-more-generic.patch"

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3c518e3..0614faf 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -106,7 +106,7 @@ EXPORT_SYMBOL(blk_queue_free_tags);
 static int
 init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
 {
-	struct request **tag_index;
+	void **tag_index;
 	unsigned long *tag_map;
 	int nr_ulongs;
 
@@ -116,7 +116,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
 		       __func__, depth);
 	}
 
-	tag_index = kzalloc(depth * sizeof(struct request *), GFP_ATOMIC);
+	tag_index = kzalloc(depth * sizeof(void *), GFP_ATOMIC);
 	if (!tag_index)
 		goto fail;
 
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(blk_queue_init_tags);
 int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	struct request **tag_index;
+	void **tag_index;
 	unsigned long *tag_map;
 	int max_depth, nr_ulongs;
 
@@ -254,7 +254,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	if (init_tag_map(q, bqt, new_depth))
 		return -ENOMEM;
 
-	memcpy(bqt->tag_index, tag_index, max_depth * sizeof(struct request *));
+	memcpy(bqt->tag_index, tag_index, max_depth * sizeof(void *));
 	nr_ulongs = ALIGN(max_depth, BITS_PER_LONG) / BITS_PER_LONG;
 	memcpy(bqt->tag_map, tag_map, nr_ulongs * sizeof(unsigned long));
 
@@ -265,24 +265,12 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 EXPORT_SYMBOL(blk_queue_resize_tags);
 
 /**
- * blk_queue_end_tag - end tag operations for a request
- * @q:  the request queue for the device
- * @rq: the request that has completed
- *
- *  Description:
- *    Typically called when end_that_request_first() returns %0, meaning
- *    all transfers have been done for a request. It's important to call
- *    this function before end_that_request_last(), as that will put the
- *    request back on the free list thus corrupting the internal tag list.
- *
- *  Notes:
- *   queue lock must be held.
+ * blk_map_end_tag - end tag operation
+ * @bqt: block queue tag
+ * @tag: tag to clear
  **/
-void blk_queue_end_tag(struct request_queue *q, struct request *rq)
+void blk_map_end_tag(struct blk_queue_tag *bqt, int tag)
 {
-	struct blk_queue_tag *bqt = q->queue_tags;
-	int tag = rq->tag;
-
 	BUG_ON(tag == -1);
 
 	if (unlikely(tag >= bqt->real_max_depth))
@@ -292,10 +280,6 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 		 */
 		return;
 
-	list_del_init(&rq->queuelist);
-	rq->cmd_flags &= ~REQ_QUEUED;
-	rq->tag = -1;
-
 	if (unlikely(bqt->tag_index[tag] == NULL))
 		printk(KERN_ERR "%s: tag %d is missing\n",
 		       __func__, tag);
@@ -313,9 +297,65 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 	 */
 	clear_bit_unlock(tag, bqt->tag_map);
 }
+EXPORT_SYMBOL(blk_map_end_tag);
+
+/**
+ * blk_queue_end_tag - end tag operations for a request
+ * @q:  the request queue for the device
+ * @rq: the request that has completed
+ *
+ *  Description:
+ *    Typically called when end_that_request_first() returns %0, meaning
+ *    all transfers have been done for a request. It's important to call
+ *    this function before end_that_request_last(), as that will put the
+ *    request back on the free list thus corrupting the internal tag list.
+ *
+ *  Notes:
+ *   queue lock must be held.
+ **/
+void blk_queue_end_tag(struct request_queue *q, struct request *rq)
+{
+	blk_map_end_tag(q->queue_tags, rq->tag);
+
+	list_del_init(&rq->queuelist);
+	rq->cmd_flags &= ~REQ_QUEUED;
+	rq->tag = -1;
+}
 EXPORT_SYMBOL(blk_queue_end_tag);
 
 /**
+ * blk_map_start_tag - find a free tag
+ * @bqt: block queue tag
+ * @object: object to store in bqt tag_index at index returned by tag
+ * @offset: offset into bqt tag map
+ **/
+int blk_map_start_tag(struct blk_queue_tag *bqt, void *object, unsigned offset)
+{
+	unsigned max_depth;
+	int tag;
+
+	/*
+	 * Protect against shared tag maps, as we may not have exclusive
+	 * access to the tag map.
+	 */
+	max_depth = bqt->max_depth;
+	do {
+		tag = find_next_zero_bit(bqt->tag_map, max_depth, offset);
+		if (tag >= max_depth)
+			return -1;
+
+	} while (test_and_set_bit_lock(tag, bqt->tag_map));
+	/*
+	 * We need lock ordering semantics given by test_and_set_bit_lock.
+	 * See blk_map_end_tag for details.
+	 */
+
+	bqt->tag_index[tag] = object;
+	return tag;
+}
+EXPORT_SYMBOL(blk_map_start_tag);
+
+/**
  * blk_queue_start_tag - find a free tag and assign it
  * @q:  the request queue for the device
  * @rq:  the block request that needs tagging
@@ -347,10 +387,8 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 		BUG();
 	}
 
+
 	/*
-	 * Protect against shared tag maps, as we may not have exclusive
-	 * access to the tag map.
-	 *
 	 * We reserve a few tags just for sync IO, since we don't want
 	 * to starve sync IO on behalf of flooding async IO.
 	 */
@@ -360,20 +398,12 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	else
 		offset = max_depth >> 2;
 
-	do {
-		tag = find_next_zero_bit(bqt->tag_map, max_depth, offset);
-		if (tag >= max_depth)
-			return 1;
-
-	} while (test_and_set_bit_lock(tag, bqt->tag_map));
-	/*
-	 * We need lock ordering semantics given by test_and_set_bit_lock.
-	 * See blk_queue_end_tag for details.
-	 */
+	tag = blk_map_start_tag(bqt, rq, offset);
+	if (tag < 0)
+		return 1;
 
 	rq->cmd_flags |= REQ_QUEUED;
 	rq->tag = tag;
-	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
 	list_add(&rq->queuelist, &q->tag_busy_list);
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..d748261 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -290,7 +290,7 @@ enum blk_queue_state {
 };
 
 struct blk_queue_tag {
-	struct request **tag_index;	/* map of busy tags */
+	void **tag_index;		/* map of busy tags */
 	unsigned long *tag_map;		/* bit map of free/busy tags */
 	int busy;			/* current depth */
 	int max_depth;			/* what we will send to device */
@@ -904,6 +904,8 @@ extern int blk_queue_resize_tags(struct request_queue *, int);
 extern void blk_queue_invalidate_tags(struct request_queue *);
 extern struct blk_queue_tag *blk_init_tags(int);
 extern void blk_free_tags(struct blk_queue_tag *);
+extern int blk_map_start_tag(struct blk_queue_tag *, void *, unsigned);
+extern void blk_map_end_tag(struct blk_queue_tag *, int);
 
 static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 						int tag)

--------------070803020508070306060606--
