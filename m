From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Tue, 01 May 2007 21:22:39 +0300
Message-ID: <4637856F.5090404@panasas.com>
References: <46225E18.7070404@panasas.com> <462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp> <4634BE6B.3000808@panasas.com> <1177872588.3688.79.camel@mulgrave.il.steeleye.com> <20070430111157.GI21015@kernel.dk> <4635D89D.4000500@panasas.com> <20070430115917.GK21015@kernel.dk> <463602AA.2090908@torque.net> <20070430145105.GO21015@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030309030308000306040601"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070430145105.GO21015@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, Benny Halevy <bhalevy@panasas.com>, FUJITA Tomonori <tomof@acm.org>, akpm@osdl.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030309030308000306040601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Mon, Apr 30 2007, Douglas Gilbert wrote:
>> Jens Axboe wrote:
>>> On Mon, Apr 30 2007, Benny Halevy wrote:
>>>> Jens Axboe wrote:
>>>>> On Sun, Apr 29 2007, James Bottomley wrote:
>>>>>> I'm still not really convinced about this approach.  The primary job of
>>>>>> the block layer is to manage and merge READ and WRITE requests.  It
>>>>>> serves a beautiful secondary function of queueing for arbitrary requests
>>>>>> it doesn't understand (REQ_TYPE_BLOCK_PC or REQ_TYPE_SPECIAL ... or
>>>>>> indeed any non REQ_TYPE_FS).
>>>>>>
>>>>>> bidirectional requests fall into the latter category (there's nothing
>>>>>> really we can do to merge them ... they're just transported by the block
>>>>>> layer).  The only unusual feature is that they carry two bios.  I think
>>>>>> the drivers that actually support bidirectional will be a rarity, so it
>>>>>> might even be advisable to add it to the queue capability (refuse
>>>>>> bidirectional requests at the top rather than perturbing all the drivers
>>>>>> to process them).
>>>>>>
>>>>>> So, what about REQ_TYPE_BIDIRECTIONAL rather than REQ_BIDI?  That will
>>>>>> remove it from the standard path and put it on the special command type
>>>>>> path where we can process it specially.  Additionally, if you take this
>>>>>> approach, you can probably simply chain the second bio through
>>>>>> req->special as an additional request in the stream.  The only thing
>>>>>> that would then need modification would be the dequeue of the block
>>>>>> driver (it would have to dequeue both requests and prepare them) and
>>>>>> that needs to be done only for drivers handling bidirectional requests.
>>>>> I agree, I'm really not crazy about shuffling the entire request setup
>>>>> around just for something as exotic as bidirection commands. How about
>>>>> just keeping it simple - have a second request linked off the first one
>>>>> for the second data phase? So keep it completely seperate, not just
>>>>> overload ->special for 2nd bio list.
>>>>>
>>>>> So basically just add a struct request pointer, so you can do rq =
>>>>> rq->next_rq or something for the next data phase. I bet this would be a
>>>>> LOT less invasive as well, and we can get by with a few helpers to
>>>>> support it.
>>>>>
>>>>> And it should definitely be a request type.
>>>>>
>>>> I'm a bit confused since what you both suggest is very similar to what we've
>>>> proposed back in October 2006 and the impression we got was that it will be
>>>> better to support bidirectional block requests natively (yet to be honest,
>>>> James, you wanted a linked request all along).
>>> It still has to be implemented natively at the block layer, just
>>> differently like described above. So instead of messing all over the
>>> block layer adding rq_uni() stuff, just add that struct request pointer
>>> to the request structure for the 2nd data phase. You can relatively easy
>>> then modify the block layer helpers to support mapping and setup of such
>>> requests.
>>>
>>>> Before we go on that route again, how do you see the support for bidi
>>>> at the scsi mid-layer done?  Again, we prefer to support that officially
>>>> using two struct scsi_cmnd_buff instances in struct scsi_cmnd and not as
>>>> a one-off feature, using special-purpose state and logic (e.g. a linked
>>>> struct scsi_cmd for the bidi_read sg list).
>>> The SCSI part is up to James, that can be done as either inside a single
>>> scsi command, or as linked scsi commands as well. I don't care too much
>>> about that bit, just the block layer parts :-). And the proposed block
>>> layer design can be used both ways by the scsi layer.
>> Linked SCSI commands have been obsolete since SPC-4 rev 6
>> (18 July 2006) after proposal 06-259r1 was accepted. That
>> proposal starts: "The reasons for linked commands have been
>> overtaken by time and events." I haven't see anyone mourning
>> their demise on the t10 reflector.
> 
> This has nothing to do with linked commands as defined in the SCSI spec.
> 
>> Mapping two requests to one bidi SCSI command might make error
>> handling more of a challenge.
> 
> Then go the other way, a command for each. Not a big deal.
> 

Hi Jens, James,

Thanks for your response!

Please consider the attached proposal. It is a complete block-level bidi
implementation that is, I hope, a middle ground which will keep everyone
happy (including Christoph). It is both quite small and not invasive,
yet has a full bidi API that is easy to use and maintain.

The patches take into account Douglas concern as well as Jens's and James.
1. Flags and "direction" are kept the same as before. I have only shifted them
   around a bit so they can work with bidi semantics as well. It is more of
   a necessary cleanup of weak code. (Patches 1 && 2). Thanks for the offer of
   a use of a new REQ_TYPE_XXX, but, as you can see below, it is not needed and
   bidi can safely be handled by the REQ_TYPE_BLOCK_PC paths.
2. C language has, what are called, nameless struct and union. I have used it
   to enable the same bidi approach as before but in a way that is absolutely
   backward code compatible. So the huge patch#3 has Just disappeared. The BIDI
   API is then implemented, considering the first and second adjustments, in a much
   similar way as before.

I have tested these patches with IBM OSD driver with bidi-enabled SCSI-ml and iSCSI.
All OSD and iSCSI tests pass. The overall adjustments are minor. Since I have basically
used the old core bidi code I can say with confidence that I have not lost the stability
gained by the testers/developers that are using bidi already.

I would like to summarize on why a second request hanging on the first request is less than
optimal solution.
1. A full request is not needed. Only the io members are needed.
2. A request is an expensive resource in the kernel. (Allocation, queuing, locking ...)
   which is a waste if you need to use bidi.
3. Error handling is a mess. Both in the building and in the recovery of io requests. Especially
   considering the double layering of SCSI-ml. (With struct scsi_cmnd already hanging on req->special)
4. Lots of other code, not at all touched by this patch, will have to change so they safely ignore the
   extra brain-dead request.
5. Bugs can always creep into ll_rw_blk.c since it is not clear from the code itself what functions
   are allowed and safe to use with the second io-only request and what functions are only allowed on
   the main request. With my approach the division of code is very clear.

Concerning what James said about bidi capability been a property of the Q of only these devices that
support it. Yes! Block level should not allow bidi access to devices that do not support it. Otherwise,
through bsg, (when it will be available), user-mode can DOS the system by sending bidi commands to legacy
devices. How should a device advertise this capability?

Please note that these patches are over 2.6.21-rc5 linux-2.6-block tree and will need to be updated
and cleaned for proper submission.

Please every one comment so we can proceed in the direction of the final solution. Pros are as
welcome as Cons   ;)

Thanks in advance
Boaz Harrosh

--------------030309030308000306040601
Content-Type: text/plain;
 name="0001-rq_direction-is_sync-and-rw-flags-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-rq_direction-is_sync-and-rw-flags-cleanup.patch"

>From 73c94d6b7e41523d44e7787617c8a1abb351326f Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Sun, 29 Apr 2007 16:11:11 +0300
Subject: [PATCH] rq_direction - is_sync and rw flags cleanup
- is_sync is it's own bool in call to elev{,ator}_may_queue{,fn}
- set some policy on when rw flag is set
   - alloc starts as read (0)
   - get_request() or __make_request() will set to write acourding to
     parameter or bio information
---
 block/as-iosched.c       |    2 +-
 block/cfq-iosched.c      |    6 +++---
 block/elevator.c         |    4 ++--
 block/ll_rw_blk.c        |   39 +++++++++++++--------------------------
 include/linux/elevator.h |    4 ++--
 5 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index ef12627..824d93e 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1285,7 +1285,7 @@ static void as_work_handler(struct work_struct *work)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static int as_may_queue(request_queue_t *q, int rw)
+static int as_may_queue(request_queue_t *q, int rw, int is_sync)
 {
 	int ret = ELV_MQUEUE_MAY;
 	struct as_data *ad = q->elevator->elevator_data;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b6491c0..1392ee9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -226,7 +226,7 @@ static inline pid_t cfq_queue_pid(struct task_struct *task, int rw, int is_sync)
 	/*
 	 * Use the per-process queue, for read requests and syncronous writes
 	 */
-	if (!(rw & REQ_RW) || is_sync)
+	if (!(rw == WRITE) || is_sync)
 		return task->pid;
 
 	return CFQ_KEY_ASYNC;
@@ -1787,14 +1787,14 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(request_queue_t *q, int rw)
+static int cfq_may_queue(request_queue_t *q, int rw, int is_sync)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
 	struct cfq_queue *cfqq;
 	unsigned int key;
 
-	key = cfq_queue_pid(tsk, rw, rw & REQ_RW_SYNC);
+	key = cfq_queue_pid(tsk, rw, is_sync);
 
 	/*
 	 * don't force setup of a queue from here, as a call to may_queue
diff --git a/block/elevator.c b/block/elevator.c
index 96a00c8..eae857f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -845,12 +845,12 @@ void elv_put_request(request_queue_t *q, struct request *rq)
 		e->ops->elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(request_queue_t *q, int rw)
+int elv_may_queue(request_queue_t *q, int rw, int is_sync)
 {
 	elevator_t *e = q->elevator;
 
 	if (e->ops->elevator_may_queue_fn)
-		return e->ops->elevator_may_queue_fn(q, rw);
+		return e->ops->elevator_may_queue_fn(q, rw, is_sync);
 
 	return ELV_MQUEUE_MAY;
 }
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3de0695..32daa55 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1958,18 +1958,14 @@ static inline void blk_free_request(request_queue_t *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(request_queue_t *q, int rw, int priv, gfp_t gfp_mask)
+blk_alloc_request(request_queue_t *q, int priv, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
 	if (!rq)
 		return NULL;
 
-	/*
-	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
-	 * see bio.h and blkdev.h
-	 */
-	rq->cmd_flags = rw | REQ_ALLOCED;
+	rq->cmd_flags = REQ_ALLOCED;
 
 	if (priv) {
 		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
@@ -2055,16 +2051,17 @@ static void freed_request(request_queue_t *q, int rw, int priv)
  * Returns NULL on failure, with queue_lock held.
  * Returns !NULL on success, with queue_lock *not held*.
  */
-static struct request *get_request(request_queue_t *q, int rw_flags,
-				   struct bio *bio, gfp_t gfp_mask)
+static struct request *get_request(request_queue_t *q, int rw,
+                                   struct bio *bio, gfp_t gfp_mask)
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
-	const int rw = rw_flags & 0x01;
 	int may_queue, priv;
+	int is_sync = (rw==READ) || (bio && bio_sync(bio));
+	WARN_ON(bio && (bio_data_dir(bio) != (rw==WRITE)));
 
-	may_queue = elv_may_queue(q, rw_flags);
+	may_queue = elv_may_queue(q, rw, is_sync);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
@@ -2112,7 +2109,7 @@ static struct request *get_request(request_queue_t *q, int rw_flags,
 
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, priv, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
@@ -2147,6 +2144,7 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 	
+	rq->cmd_flags |= (rw==WRITE);
 	rq_init(q, rq);
 
 	blk_add_trace_generic(q, bio, rw, BLK_TA_GETRQ);
@@ -2160,13 +2158,12 @@ out:
  *
  * Called with q->queue_lock held, and returns with it unlocked.
  */
-static struct request *get_request_wait(request_queue_t *q, int rw_flags,
+static struct request *get_request_wait(request_queue_t *q, int rw,
 					struct bio *bio)
 {
-	const int rw = rw_flags & 0x01;
 	struct request *rq;
 
-	rq = get_request(q, rw_flags, bio, GFP_NOIO);
+	rq = get_request(q, rw, bio, GFP_NOIO);
 	while (!rq) {
 		DEFINE_WAIT(wait);
 		struct request_list *rl = &q->rq;
@@ -2174,7 +2171,7 @@ static struct request *get_request_wait(request_queue_t *q, int rw_flags,
 		prepare_to_wait_exclusive(&rl->wait[rw], &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		rq = get_request(q, rw_flags, bio, GFP_NOIO);
+		rq = get_request(q, rw, bio, GFP_NOIO);
 
 		if (!rq) {
 			struct io_context *ioc;
@@ -2908,7 +2905,6 @@ static int __make_request(request_queue_t *q, struct bio *bio)
 	int el_ret, nr_sectors, barrier, err;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
-	int rw_flags;
 
 	nr_sectors = bio_sectors(bio);
 
@@ -2983,19 +2979,10 @@ static int __make_request(request_queue_t *q, struct bio *bio)
 
 get_rq:
 	/*
-	 * This sync check and mask will be re-done in init_request_from_bio(),
-	 * but we need to set it earlier to expose the sync flag to the
-	 * rq allocator and io schedulers.
-	 */
-	rw_flags = bio_data_dir(bio);
-	if (sync)
-		rw_flags |= REQ_RW_SYNC;
-
-	/*
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
-	req = get_request_wait(q, rw_flags, bio);
+	req = get_request_wait(q, bio_data_dir(bio), bio);
 
 	/*
 	 * After dropping the lock and possibly sleeping here, our request
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e88fcbc..c947f71 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -20,7 +20,7 @@ typedef void (elevator_add_req_fn) (request_queue_t *, struct request *);
 typedef int (elevator_queue_empty_fn) (request_queue_t *);
 typedef struct request *(elevator_request_list_fn) (request_queue_t *, struct request *);
 typedef void (elevator_completed_req_fn) (request_queue_t *, struct request *);
-typedef int (elevator_may_queue_fn) (request_queue_t *, int);
+typedef int (elevator_may_queue_fn) (request_queue_t *, int, int);
 
 typedef int (elevator_set_req_fn) (request_queue_t *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
@@ -111,7 +111,7 @@ extern struct request *elv_former_request(request_queue_t *, struct request *);
 extern struct request *elv_latter_request(request_queue_t *, struct request *);
 extern int elv_register_queue(request_queue_t *q);
 extern void elv_unregister_queue(request_queue_t *q);
-extern int elv_may_queue(request_queue_t *, int);
+extern int elv_may_queue(request_queue_t *, int, int);
 extern void elv_completed_request(request_queue_t *, struct request *);
 extern int elv_set_request(request_queue_t *, struct request *, gfp_t);
 extern void elv_put_request(request_queue_t *, struct request *);
-- 
1.5.0.4.402.g8035


--------------030309030308000306040601
Content-Type: text/plain;
 name="0002-rq_direction-direction-API-and-cleanups.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-rq_direction-direction-API-and-cleanups.patch"

>From 8d2b3d084da6d7ff9f7fb817b877c6e1b7759028 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Sun, 29 Apr 2007 16:18:31 +0300
Subject: [PATCH] rq_direction - direction API and cleanups
- define rq_rw_dir() to extract direction from cmd_flgs and translate to WRITE|READ
- rq_data_dir() will WARN_ON bidi before returning rq_rw_dir()
- rq_dma_dir() translate request state to a dma_data_direction enum
- change some users of rq_data dir() to rq_rw_dir() in ll_rw_blk.c elevator.c and scsi_lib.c
- simplify scsi_lib.c command prep in regard to direction.
- clean wrong use of DMA_BIDIRECTIONAL.
- BIO flags and REQ flags no longer match. Remove comments and do a proper translation
  between the 2 systems. (Please look in ll_rw_blk.c/blk_rq_bio_prep below if we need more flags)
---
 block/deadline-iosched.c     |    8 +++---
 block/elevator.c             |    5 ++-
 block/ll_rw_blk.c            |   37 +++++++++++++++++++++++---------
 drivers/scsi/scsi_error.c    |    2 +-
 drivers/scsi/scsi_lib.c      |   13 +++++------
 drivers/scsi/sg.c            |    2 -
 include/linux/blkdev.h       |   47 +++++++++++++++++++++++++++++++++++++++--
 include/linux/blktrace_api.h |    8 ++++++-
 8 files changed, 91 insertions(+), 31 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 6d673e9..e605c09 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -53,7 +53,7 @@ struct deadline_data {
 
 static void deadline_move_request(struct deadline_data *, struct request *);
 
-#define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_data_dir((rq))])
+#define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_rw_dir((rq))])
 
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
@@ -72,7 +72,7 @@ retry:
 static inline void
 deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_rw_dir(rq);
 
 	if (dd->next_rq[data_dir] == rq) {
 		struct rb_node *rbnext = rb_next(&rq->rb_node);
@@ -92,7 +92,7 @@ static void
 deadline_add_request(struct request_queue *q, struct request *rq)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_rw_dir(rq);
 
 	deadline_add_rq_rb(dd, rq);
 
@@ -197,7 +197,7 @@ deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
 static void
 deadline_move_request(struct deadline_data *dd, struct request *rq)
 {
-	const int data_dir = rq_data_dir(rq);
+	const int data_dir = rq_rw_dir(rq);
 	struct rb_node *rbnext = rb_next(&rq->rb_node);
 
 	dd->next_rq[READ] = NULL;
diff --git a/block/elevator.c b/block/elevator.c
index eae857f..18485f0 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -76,7 +76,7 @@ inline int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	/*
 	 * different data direction or already started, don't merge
 	 */
-	if (bio_data_dir(bio) != rq_data_dir(rq))
+	if (bio_data_dir(bio) != rq_rw_dir(rq))
 		return 0;
 
 	/*
@@ -733,7 +733,8 @@ struct request *elv_next_request(request_queue_t *q)
 			blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
 		}
 
-		if (!q->boundary_rq || q->boundary_rq == rq) {
+		if ((!q->boundary_rq || q->boundary_rq == rq) &&
+			!rq_is_bidi(rq)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = NULL;
 		}
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 32daa55..0c78540 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2332,7 +2332,7 @@ static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
-	reading = rq_data_dir(rq) == READ;
+	reading = rq_rw_dir(rq) == READ;
 
 	/*
 	 * if alignment requirement is satisfied, map in user pages for
@@ -2476,7 +2476,7 @@ int blk_rq_map_user_iov(request_queue_t *q, struct request *rq,
 	/* we don't allow misaligned data like bio_map_user() does.  If the
 	 * user is using sg, they're expected to know the alignment constraints
 	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, NULL, iov, iov_count, rq_data_dir(rq)== READ);
+	bio = bio_map_user_iov(q, NULL, iov, iov_count, rq_rw_dir(rq)== READ);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -2549,7 +2549,7 @@ int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (rq_data_dir(rq) == WRITE)
+	if (rq_rw_dir(rq) == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
 
 	blk_rq_bio_prep(q, rq, bio);
@@ -2660,7 +2660,7 @@ EXPORT_SYMBOL(blkdev_issue_flush);
 
 static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io)
 {
-	int rw = rq_data_dir(rq);
+	int rw = rq_rw_dir(rq);
 
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
@@ -2738,7 +2738,7 @@ void __blk_put_request(request_queue_t *q, struct request *req)
 	 * it didn't come out of our reserved rq pools
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
-		int rw = rq_data_dir(req);
+		int rw = rq_rw_dir(req);
 		int priv = req->cmd_flags & REQ_ELVPRIV;
 
 		BUG_ON(!list_empty(&req->queuelist));
@@ -2804,7 +2804,7 @@ static int attempt_merge(request_queue_t *q, struct request *req,
 	if (req->sector + req->nr_sectors != next->sector)
 		return 0;
 
-	if (rq_data_dir(req) != rq_data_dir(next)
+	if (rq_rw_dir(req) != rq_rw_dir(next)
 	    || req->rq_disk != next->rq_disk
 	    || next->special)
 		return 0;
@@ -3333,7 +3333,7 @@ static int __end_that_request_first(struct request *req, int uptodate,
 	if (!blk_pc_request(req))
 		req->errors = 0;
 
-	if (!uptodate) {
+	if (error) {
 		if (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))
 			printk("end_request: I/O error, dev %s, sector %llu\n",
 				req->rq_disk ? req->rq_disk->disk_name : "?",
@@ -3341,7 +3341,7 @@ static int __end_that_request_first(struct request *req, int uptodate,
 	}
 
 	if (blk_fs_request(req) && req->rq_disk) {
-		const int rw = rq_data_dir(req);
+		const int rw = rq_rw_dir(req);
 
 		disk_stat_add(req->rq_disk, sectors[rw], nr_bytes >> 9);
 	}
@@ -3565,7 +3565,7 @@ void end_that_request_last(struct request *req, int uptodate)
 	 */
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
-		const int rw = rq_data_dir(req);
+		const int rw = rq_rw_dir(req);
 
 		__disk_stat_inc(disk, ios[rw]);
 		__disk_stat_add(disk, ticks[rw], duration);
@@ -3593,8 +3593,23 @@ EXPORT_SYMBOL(end_request);
 
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
-	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
-	rq->cmd_flags |= (bio->bi_rw & 3);
+	if (bio_data_dir(bio))
+		rq->cmd_flags |= REQ_RW;
+	else
+		rq->cmd_flags &= ~REQ_RW;
+
+	if (bio->bi_rw & (1<<BIO_RW_SYNC))
+		rq->cmd_flags |= REQ_RW_SYNC;
+	else
+		rq->cmd_flags &= ~REQ_RW_SYNC;
+	/* FIXME: what about other flags, should we sync these too? */
+	/*
+	BIO_RW_AHEAD	==> ??
+	BIO_RW_BARRIER	==> REQ_SOFTBARRIER/REQ_HARDBARRIER
+	BIO_RW_FAILFAST	==> REQ_FAILFAST
+	BIO_RW_SYNC	==> REQ_RW_SYNC
+	BIO_RW_META	==> REQ_RW_META
+	*/
 
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
 	rq->nr_hw_segments = bio_hw_segments(q, bio);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 918bb60..c528ab1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1688,7 +1688,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	scmd->cmd_len			= 0;
 
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
+	scmd->sc_data_direction		= DMA_NONE;
 
 	init_timer(&scmd->eh_timeout);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9f7482d..1fc0471 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -259,8 +259,10 @@ static int scsi_merge_bio(struct request *rq, struct bio *bio)
 	struct request_queue *q = rq->q;
 
 	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-	if (rq_data_dir(rq) == WRITE)
+	if (rq_rw_dir(rq) == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
+	else
+		bio->bi_rw &= ~(1 << BIO_RW);
 	blk_queue_bounce(q, &bio);
 
 	if (!rq->bio)
@@ -392,6 +394,8 @@ int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 	if (!sioc)
 		return DRIVER_ERROR << 24;
 
+	WARN_ON((data_direction == DMA_NONE) && bufflen);
+	WARN_ON((data_direction != DMA_NONE) && !bufflen);
 	req = blk_get_request(sdev->request_queue, write, gfp);
 	if (!req)
 		goto free_sense;
@@ -1124,12 +1128,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
-	if (!req->data_len)
-		cmd->sc_data_direction = DMA_NONE;
-	else if (rq_data_dir(req) == WRITE)
-		cmd->sc_data_direction = DMA_TO_DEVICE;
-	else
-		cmd->sc_data_direction = DMA_FROM_DEVICE;
+	cmd->sc_data_direction = rq_dma_dir(req);
 	
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 81e3bc7..46a1f7e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -733,8 +733,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		data_dir = DMA_TO_DEVICE;
 		break;
 	case SG_DXFER_UNKNOWN:
-		data_dir = DMA_BIDIRECTIONAL;
-		break;
 	default:
 		data_dir = DMA_NONE;
 		break;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83dcd8c..c1121d2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -14,6 +14,7 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/stringify.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/scatterlist.h>
 
@@ -177,7 +178,7 @@ enum {
 };
 
 /*
- * request type modified bits. first three bits match BIO_RW* bits, important
+ * request type modified bits.
  */
 enum rq_flag_bits {
 	__REQ_RW,		/* not set, read. set, write */
@@ -545,12 +546,52 @@ enum {
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((rq)->cmd_flags & 1)
+static inline int rq_is_bidi(struct request* rq)
+{
+	/*
+	 * FIXME: It is needed below. Will be changed later in the 
+	 *        patchset to a real check, and fixme will be removed.
+	 */
+	return false;
+}
+
+static inline int rq_rw_dir(struct request* rq)
+{
+	int old_check = (rq->cmd_flags & REQ_RW) ? WRITE : READ;
+/*#ifdef 0
+	int ret = (rq->bio && bio_data_dir(rq->bio)) ? WRITE : READ;
+	WARN_ON(ret != old_check );
+#endif*/
+	return old_check;
+}
+
+static inline int rq_data_dir(struct request* rq)
+{
+	WARN_ON(rq_is_bidi(rq));
+	return rq_rw_dir(rq);
+}
+static inline enum dma_data_direction rq_dma_dir(struct request* rq)
+{
+	WARN_ON(rq_is_bidi(rq));
+	if (!rq->bio)
+		return DMA_NONE;
+	else
+		return bio_data_dir(rq->bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+}
+static inline const char* rq_dir_to_string(struct request* rq)
+{
+	if (!rq->bio)
+		return "no data command";
+	else
+		return bio_data_dir(rq->bio) ? 
+			"writing" : 
+			"reading";
+}
 
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
-#define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
+#define rq_is_sync(rq)		(rq_rw_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
 static inline int blk_queue_full(struct request_queue *q, int rw)
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3680ff9..d9665b1 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -161,7 +161,13 @@ static inline void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 				    u32 what)
 {
 	struct blk_trace *bt = q->blk_trace;
-	int rw = rq->cmd_flags & 0x03;
+	/* blktrace.c prints them according to bio flags */
+	int rw = (((rq_rw_dir(rq) == WRITE) << BIO_RW) |
+	          (((rq->cmd_flags & (REQ_SOFTBARRIER|REQ_HARDBARRIER)) != 0) <<
+	           BIO_RW_BARRIER) |
+	          (((rq->cmd_flags & REQ_FAILFAST) != 0) << BIO_RW_FAILFAST) |
+	          (((rq->cmd_flags & REQ_RW_SYNC) != 0) << BIO_RW_SYNC) |
+	          (((rq->cmd_flags & REQ_RW_META) != 0) << BIO_RW_META));
 
 	if (likely(!bt))
 		return;
-- 
1.5.0.4.402.g8035


--------------030309030308000306040601
Content-Type: text/plain;
 name="0003-block-bidi-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-block-bidi-support.patch"

>From 7aeec62fe483359289aad9286f8dda149f2ce0d4 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Tue, 1 May 2007 21:09:50 +0300
Subject: [PATCH] block bidi support
- seperate request io members into a substructure (but in a backward compatible way)
  and add a second set of members for bidi_read.
- Add some bidi helpers to work on a bidi request:
  rq_in(), rq_out(), rq_io()
  blk_rq_bio_prep_bidi()
  blk_rq_map_kern_bidi()
  blk_rq_map_sg_bidi()
- change ll_back_merge_fn to support bidi / change only user - scsi_lib.c
  (Both will be removed in a future scsi cleanup)
- Add end_that_request_block that can clean after a bidi request
---
 block/elevator.c        |    7 +--
 block/ll_rw_blk.c       |  214 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_lib.c |    2 +-
 include/linux/blkdev.h  |  152 ++++++++++++++++++++++++----------
 4 files changed, 276 insertions(+), 99 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 18485f0..90f333e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -755,14 +755,9 @@ struct request *elv_next_request(request_queue_t *q)
 			rq = NULL;
 			break;
 		} else if (ret == BLKPREP_KILL) {
-			int nr_bytes = rq->hard_nr_sectors << 9;
-
-			if (!nr_bytes)
-				nr_bytes = rq->data_len;
-
 			blkdev_dequeue_request(rq);
 			rq->cmd_flags |= REQ_QUIET;
-			end_that_request_chunk(rq, 0, nr_bytes);
+			end_that_request_block(rq, 0);
 			end_that_request_last(rq, 0);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 0c78540..7d98ba6 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -235,13 +235,19 @@ void blk_queue_make_request(request_queue_t * q, make_request_fn * mfn)
 
 EXPORT_SYMBOL(blk_queue_make_request);
 
+static void rq_init_io_part(struct request_io_part* req_io)
+{
+	req_io->data_len = 0;
+	req_io->nr_phys_segments = 0;
+	req_io->bio = req_io->biotail = NULL;
+}
+
 static void rq_init(request_queue_t *q, struct request *rq)
 {
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
 
 	rq->errors = 0;
-	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->ioprio = 0;
@@ -249,13 +255,13 @@ static void rq_init(request_queue_t *q, struct request *rq)
 	rq->ref_count = 1;
 	rq->q = q;
 	rq->special = NULL;
-	rq->data_len = 0;
 	rq->data = NULL;
-	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
+	rq_init_io_part(&rq->uni);
+	rq_init_io_part(&rq->bidi_read);
 }
 
 /**
@@ -1304,14 +1310,16 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
 }
 
 /*
- * map a request to scatterlist, return number of sg entries setup. Caller
- * must make sure sg can hold rq->nr_phys_segments entries
+ * map a request_io_part to scatterlist, return number of sg entries setup.
+ * Caller must make sure sg can hold rq_io(rq, rw)->nr_phys_segments entries
  */
-int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
+int blk_rq_map_sg_bidi(request_queue_t *q, struct request *rq,
+	struct scatterlist *sg, int rw)
 {
 	struct bio_vec *bvec, *bvprv;
 	struct bio *bio;
 	int nsegs, i, cluster;
+	struct request_io_part* req_io = rq_io(rq, rw);
 
 	nsegs = 0;
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
@@ -1320,7 +1328,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
-	rq_for_each_bio(bio, rq) {
+	for (bio = req_io->bio; bio; bio = bio->bi_next) {
 		/*
 		 * for each segment in bio
 		 */
@@ -1352,7 +1360,17 @@ new_segment:
 
 	return nsegs;
 }
+EXPORT_SYMBOL(blk_rq_map_sg_bidi);
 
+/*
+ * map a request to scatterlist, return number of sg entries setup. Caller
+ * must make sure sg can hold rq->nr_phys_segments entries
+ */
+int blk_rq_map_sg(request_queue_t *q, struct request *rq,
+                  struct scatterlist *sg)
+{
+	return blk_rq_map_sg_bidi(q, rq, sg, rq_data_dir(rq));
+}
 EXPORT_SYMBOL(blk_rq_map_sg);
 
 /*
@@ -1362,11 +1380,12 @@ EXPORT_SYMBOL(blk_rq_map_sg);
 
 static inline int ll_new_mergeable(request_queue_t *q,
 				   struct request *req,
-				   struct bio *bio)
+				   struct bio *bio,
+				   struct request_io_part* req_io)
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req_io->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1377,19 +1396,20 @@ static inline int ll_new_mergeable(request_queue_t *q,
 	 * A hw segment is just getting larger, bump just the phys
 	 * counter.
 	 */
-	req->nr_phys_segments += nr_phys_segs;
+	req_io->nr_phys_segments += nr_phys_segs;
 	return 1;
 }
 
 static inline int ll_new_hw_segment(request_queue_t *q,
 				    struct request *req,
-				    struct bio *bio)
+				    struct bio *bio,
+				    struct request_io_part* req_io)
 {
 	int nr_hw_segs = bio_hw_segments(q, bio);
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_hw_segments + nr_hw_segs > q->max_hw_segments
-	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req_io->nr_hw_segments + nr_hw_segs > q->max_hw_segments
+	    || req_io->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1400,46 +1420,48 @@ static inline int ll_new_hw_segment(request_queue_t *q,
 	 * This will form the start of a new hw segment.  Bump both
 	 * counters.
 	 */
-	req->nr_hw_segments += nr_hw_segs;
-	req->nr_phys_segments += nr_phys_segs;
+	req_io->nr_hw_segments += nr_hw_segs;
+	req_io->nr_phys_segments += nr_phys_segs;
 	return 1;
 }
 
-int ll_back_merge_fn(request_queue_t *q, struct request *req, struct bio *bio)
+int ll_back_merge_fn(request_queue_t *q, struct request *req, struct bio *bio, int rw)
 {
 	unsigned short max_sectors;
 	int len;
+	struct request_io_part* req_io = rq_io(req, rw);
 
 	if (unlikely(blk_pc_request(req)))
 		max_sectors = q->max_hw_sectors;
 	else
 		max_sectors = q->max_sectors;
 
-	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
+	if (req_io->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
 	}
-	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
-		blk_recount_segments(q, req->biotail);
+	if (unlikely(!bio_flagged(req_io->biotail, BIO_SEG_VALID)))
+		blk_recount_segments(q, req_io->biotail);
 	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
-	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio)) &&
+	len = req_io->biotail->bi_hw_back_size + bio->bi_hw_front_size;
+	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req_io->biotail),
+	                          __BVEC_START(bio)) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
+		int mergeable =  ll_new_mergeable(q, req, bio, req_io);
 
 		if (mergeable) {
-			if (req->nr_hw_segments == 1)
-				req->bio->bi_hw_front_size = len;
+			if (req_io->nr_hw_segments == 1)
+				req_io->bio->bi_hw_front_size = len;
 			if (bio->bi_hw_segments == 1)
 				bio->bi_hw_back_size = len;
 		}
 		return mergeable;
 	}
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, req, bio, req_io);
 }
 EXPORT_SYMBOL(ll_back_merge_fn);
 
@@ -1454,6 +1476,7 @@ static int ll_front_merge_fn(request_queue_t *q, struct request *req,
 	else
 		max_sectors = q->max_sectors;
 
+	WARN_ON(rq_is_bidi(req));
 
 	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
@@ -1468,7 +1491,7 @@ static int ll_front_merge_fn(request_queue_t *q, struct request *req,
 		blk_recount_segments(q, req->bio);
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(req->bio)) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
+		int mergeable =  ll_new_mergeable(q, req, bio, &req->uni);
 
 		if (mergeable) {
 			if (bio->bi_hw_segments == 1)
@@ -1479,7 +1502,7 @@ static int ll_front_merge_fn(request_queue_t *q, struct request *req,
 		return mergeable;
 	}
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, req, bio, &req->uni);
 }
 
 static int ll_merge_requests_fn(request_queue_t *q, struct request *req,
@@ -2358,7 +2381,7 @@ static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
 
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio)) {
+	else if (!ll_back_merge_fn(q, rq, bio, rq_data_dir(rq))) {
 		ret = -EINVAL;
 		goto unmap_bio;
 	} else {
@@ -2528,15 +2551,18 @@ int blk_rq_unmap_user(struct bio *bio)
 EXPORT_SYMBOL(blk_rq_unmap_user);
 
 /**
- * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_map_kern_bidi - maps kernel data to a request_io_part, for BIDI usage
  * @q:		request queue where request should be inserted
  * @rq:		request to fill
  * @kbuf:	the kernel buffer
  * @len:	length of user data
  * @gfp_mask:	memory allocation flags
+ * @rw:        if it is a bidirectional request than WRITE to prepare
+ *              the bidi_write side or READ to prepare the bidi_read
+ *              side, else it should be same as rq_data_dir(rq)
  */
-int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
-		    unsigned int len, gfp_t gfp_mask)
+int blk_rq_map_kern_bidi(request_queue_t *q, struct request *rq, void *kbuf,
+	unsigned int len, gfp_t gfp_mask, int rw)
 {
 	struct bio *bio;
 
@@ -2549,14 +2575,29 @@ int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (rq_rw_dir(rq) == WRITE)
+	if (rw == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
 
-	blk_rq_bio_prep(q, rq, bio);
+	blk_rq_bio_prep_bidi(q, rq, bio ,rw);
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
 
+EXPORT_SYMBOL(blk_rq_map_kern_bidi);
+
+/**
+ * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @kbuf:	the kernel buffer
+ * @len:	length of user data
+ * @gfp_mask:	memory allocation flags
+ */
+int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
+		    unsigned int len, gfp_t gfp_mask)
+{
+	return blk_rq_map_kern_bidi( q, rq, kbuf, len, gfp_mask, rq_data_dir(rq));
+}
 EXPORT_SYMBOL(blk_rq_map_kern);
 
 /**
@@ -2865,6 +2906,19 @@ static inline int attempt_front_merge(request_queue_t *q, struct request *rq)
 	return 0;
 }
 
+static void init_req_io_part_from_bio(struct request_queue* q,
+	struct request_io_part *req_io, struct bio *bio)
+{
+	req_io->hard_sector = req_io->sector = bio->bi_sector;
+	req_io->hard_nr_sectors = req_io->nr_sectors = bio_sectors(bio);
+	req_io->current_nr_sectors =
+		req_io->hard_cur_sectors = bio_cur_sectors(bio);
+	req_io->nr_phys_segments = bio_phys_segments(q, bio);
+	req_io->nr_hw_segments = bio_hw_segments(q, bio);
+	req_io->bio = req_io->biotail = bio;
+	req_io->data_len = bio->bi_size;
+}
+
 static void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cmd_type = REQ_TYPE_FS;
@@ -2887,14 +2941,10 @@ static void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_RW_META;
 
 	req->errors = 0;
-	req->hard_sector = req->sector = bio->bi_sector;
-	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
-	req->current_nr_sectors = req->hard_cur_sectors = bio_cur_sectors(bio);
-	req->nr_phys_segments = bio_phys_segments(req->q, bio);
-	req->nr_hw_segments = bio_hw_segments(req->q, bio);
 	req->buffer = bio_data(bio);	/* see ->buffer comment above */
-	req->bio = req->biotail = bio;
 	req->ioprio = bio_prio(bio);
+	WARN_ON(rq_is_bidi(req));
+	init_req_io_part_from_bio(req->q, &req->uni, bio);
 	req->rq_disk = bio->bi_bdev->bd_disk;
 	req->start_time = jiffies;
 }
@@ -2931,7 +2981,7 @@ static int __make_request(request_queue_t *q, struct bio *bio)
 		case ELEVATOR_BACK_MERGE:
 			BUG_ON(!rq_mergeable(req));
 
-			if (!ll_back_merge_fn(q, req, bio))
+			if (!ll_back_merge_fn(q, req, bio, rq_data_dir(req)))
 				break;
 
 			blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
@@ -3405,6 +3455,8 @@ static int __end_that_request_first(struct request *req, int uptodate,
 	if (!req->bio)
 		return 0;
 
+	WARN_ON(rq_is_bidi(req));
+
 	/*
 	 * if the request wasn't completed, update state
 	 */
@@ -3464,6 +3516,47 @@ int end_that_request_chunk(struct request *req, int uptodate, int nr_bytes)
 
 EXPORT_SYMBOL(end_that_request_chunk);
 
+static void __end_req_io_block(struct request_io_part *req_io, int error)
+{
+	struct bio *next, *bio = req_io->bio;
+	req_io->bio = NULL;
+
+	for (; bio; bio = next) {
+		next = bio->bi_next;
+		bio_endio(bio, bio->bi_size, error);
+	}
+}
+
+/**
+ * end_that_request_block - end ALL I/O on a request in one "shloop",
+ * including the bidi part.
+ * @req:      the request being processed
+ * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ *
+ * Description:
+ *     Ends ALL I/O on @req, both read/write or bidi. frees all bio resources.
+ **/
+void end_that_request_block(struct request *req, int uptodate)
+{
+	if (blk_pc_request(req)) {
+		int error = 0;
+		if (end_io_error(uptodate))
+			error = !uptodate ? -EIO : uptodate;
+		blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
+
+		__end_req_io_block(&req->uni, error);
+		if (rq_is_bidi(req))
+			__end_req_io_block(&req->bidi_read, 0);
+	} else { /* needs elevator bookeeping */
+		int nr_bytes = req->uni.hard_nr_sectors << 9;
+		if (!nr_bytes)
+			nr_bytes = req->uni.data_len;
+		end_that_request_chunk(req, uptodate, nr_bytes);
+	}
+}
+
+EXPORT_SYMBOL(end_that_request_block);
+
 /*
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
@@ -3591,8 +3684,40 @@ void end_request(struct request *req, int uptodate)
 
 EXPORT_SYMBOL(end_request);
 
+static struct request_io_part* blk_rq_choose_set_io(struct request *rq, int rw)
+{
+	if (rw == WRITE){
+		/* this is a memory leak it must not happen */
+		BUG_ON((rq_rw_dir(rq) == WRITE) && (rq->uni.bio != NULL));
+		if(rq->uni.bio != NULL)
+			rq->bidi_read = rq->uni;
+		rq->cmd_flags |= REQ_RW ;
+		return &rq->uni;
+	}
+	else {
+		BUG_ON((rq_rw_dir(rq) == READ) && (rq->uni.bio != NULL));
+		BUG_ON(rq->bidi_read.bio != NULL);
+		if(rq->uni.bio != NULL)
+			return &rq->bidi_read;
+		else {
+			rq->cmd_flags &= ~REQ_RW ;
+			return &rq->uni;
+		}
+	}
+}
+
+void blk_rq_bio_prep_bidi(request_queue_t *q, struct request *rq,
+	struct bio *bio, int rw)
+{
+	init_req_io_part_from_bio(q, blk_rq_choose_set_io(rq, rw), bio);
+	rq->buffer = NULL;
+}
+EXPORT_SYMBOL(blk_rq_bio_prep_bidi);
+
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
+	WARN_ON(rq_is_bidi(rq));
+
 	if (bio_data_dir(bio))
 		rq->cmd_flags |= REQ_RW;
 	else
@@ -3611,15 +3736,8 @@ void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 	BIO_RW_META	==> REQ_RW_META
 	*/
 
-	rq->nr_phys_segments = bio_phys_segments(q, bio);
-	rq->nr_hw_segments = bio_hw_segments(q, bio);
-	rq->current_nr_sectors = bio_cur_sectors(bio);
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
+	init_req_io_part_from_bio(q, &rq->uni, bio);
 	rq->buffer = bio_data(bio);
-	rq->data_len = bio->bi_size;
-
-	rq->bio = rq->biotail = bio;
 }
 
 EXPORT_SYMBOL(blk_rq_bio_prep);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1fc0471..5c80712 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -267,7 +267,7 @@ static int scsi_merge_bio(struct request *rq, struct bio *bio)
 
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
+	else if (!ll_back_merge_fn(q, rq, bio, rq_data_dir(rq)))
 		return -EINVAL;
 	else {
 		rq->biotail->bi_next = bio;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c1121d2..23c2891 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -224,6 +224,44 @@ enum rq_flag_bits {
 #define BLK_MAX_CDB	16
 
 /*
+ * request io members. one for uni read/write and one for bidi_read
+ * This is a bidi hack so refactoring of code is simple but the main
+ * request interface stays the same.
+ * NOTE: member names here must not be reused inside struct request
+ *       as they will conflict
+ */
+#define REQUEST_IO_PART_MEMBERS \
+	unsigned int data_len; \
+ \
+	/* Maintain bio traversal state for part by part I/O submission. \
+	 * hard_* are block layer internals, no driver should touch them! \
+	 */ \
+	sector_t sector;		/* next sector to submit */ \
+	sector_t hard_sector;		/* next sector to complete */ \
+	unsigned long nr_sectors;	/* no. of sectors left to submit */ \
+	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */ \
+	/* no. of sectors left to submit in the current segment */ \
+	unsigned int current_nr_sectors; \
+ \
+	/* no. of sectors left to complete in the current segment */ \
+	unsigned int hard_cur_sectors; \
+ \
+	struct bio *bio; \
+	struct bio *biotail; \
+ \
+	/* Number of scatter-gather DMA addr+len pairs after \
+	 * physical address coalescing is performed. \
+	 */ \
+	unsigned short nr_phys_segments; \
+ \
+	/* Number of scatter-gather addr+len pairs after \
+	 * physical and DMA remapping hardware coalescing is performed. \
+	 * This is the number of scatter-gather entries the driver \
+	 * will actually have to deal with after DMA mapping is done. \
+	 */ \
+	unsigned short nr_hw_segments;
+
+/*
  * try to put the fields that are referenced together in the same cacheline
  */
 struct request {
@@ -235,23 +273,6 @@ struct request {
 	unsigned int cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
 
-	/* Maintain bio traversal state for part by part I/O submission.
-	 * hard_* are block layer internals, no driver should touch them!
-	 */
-
-	sector_t sector;		/* next sector to submit */
-	sector_t hard_sector;		/* next sector to complete */
-	unsigned long nr_sectors;	/* no. of sectors left to submit */
-	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
-	/* no. of sectors left to submit in the current segment */
-	unsigned int current_nr_sectors;
-
-	/* no. of sectors left to complete in the current segment */
-	unsigned int hard_cur_sectors;
-
-	struct bio *bio;
-	struct bio *biotail;
-
 	struct hlist_node hash;	/* merge hash */
 	/*
 	 * The rb_node is only used inside the io scheduler, requests
@@ -273,22 +294,11 @@ struct request {
 	struct gendisk *rq_disk;
 	unsigned long start_time;
 
-	/* Number of scatter-gather DMA addr+len pairs after
-	 * physical address coalescing is performed.
-	 */
-	unsigned short nr_phys_segments;
-
-	/* Number of scatter-gather addr+len pairs after
-	 * physical and DMA remapping hardware coalescing is performed.
-	 * This is the number of scatter-gather entries the driver
-	 * will actually have to deal with after DMA mapping is done.
-	 */
-	unsigned short nr_hw_segments;
-
 	unsigned short ioprio;
 
 	void *special;
-	char *buffer;
+	char *buffer;			/* FIXME: should be Deprecated */
+	void *data;			/* FIXME: should be Deprecated */
 
 	int tag;
 	int errors;
@@ -301,9 +311,7 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int data_len;
 	unsigned int sense_len;
-	void *data;
 	void *sense;
 
 	unsigned int timeout;
@@ -314,6 +322,21 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
+
+	/* Hack for bidi: this tells the compiler to keep all these members
+	 * aligned the same as the struct request_io_part so we can access
+	 * them either directly or through the structure.
+	 */
+	
+	union {
+		struct request_io_part {
+			REQUEST_IO_PART_MEMBERS;
+		} uni;
+		struct {
+			REQUEST_IO_PART_MEMBERS;
+		};
+	};
+	struct request_io_part bidi_read;
 };
 
 /*
@@ -548,21 +571,12 @@ enum {
 
 static inline int rq_is_bidi(struct request* rq)
 {
-	/*
-	 * FIXME: It is needed below. Will be changed later in the 
-	 *        patchset to a real check, and fixme will be removed.
-	 */
-	return false;
+	return rq->bidi_read.bio != NULL;
 }
 
 static inline int rq_rw_dir(struct request* rq)
 {
-	int old_check = (rq->cmd_flags & REQ_RW) ? WRITE : READ;
-/*#ifdef 0
-	int ret = (rq->bio && bio_data_dir(rq->bio)) ? WRITE : READ;
-	WARN_ON(ret != old_check );
-#endif*/
-	return old_check;
+	return (rq->cmd_flags & REQ_RW) ? WRITE : READ;
 }
 
 static inline int rq_data_dir(struct request* rq)
@@ -582,12 +596,36 @@ static inline const char* rq_dir_to_string(struct request* rq)
 {
 	if (!rq->bio)
 		return "no data command";
+	else if (rq_is_bidi(rq))
+		return "bidirectional";
 	else
 		return bio_data_dir(rq->bio) ? 
 			"writing" : 
 			"reading";
 }
 
+static inline struct request_io_part* rq_out(struct request* req)
+{
+	return &req->uni;
+}
+
+static inline struct request_io_part* rq_in(struct request* req)
+{
+	if (rq_rw_dir(req))
+		return &req->bidi_read;
+
+	return &req->uni;
+}
+
+static inline struct request_io_part* rq_io(struct request* req, int rw)
+{
+	if (rw == READ)
+		return rq_in(req);
+
+	WARN_ON(rw != WRITE);
+	return rq_out(req);
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
@@ -684,7 +722,8 @@ extern int sg_scsi_ioctl(struct file *, struct request_queue *,
 /*
  * Temporary export, until SCSI gets fixed up.
  */
-extern int ll_back_merge_fn(request_queue_t *, struct request *, struct bio *);
+extern int ll_back_merge_fn(request_queue_t *, struct request *, struct bio *,
+	int rw);
 
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
@@ -755,6 +794,15 @@ extern void end_request(struct request *req, int uptodate);
 extern void blk_complete_request(struct request *);
 
 /*
+ * end_request_block will complete and free all bio resources held
+ * by the request in one call. User will still need to call
+ * end_that_request_last(..).
+ * It is the only one that can deal with BIDI.
+ * can be called for parial bidi allocation and cleanup.
+ */
+extern void end_that_request_block(struct request *req, int uptodate);
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
@@ -833,6 +881,22 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern void blk_rq_bio_prep(request_queue_t *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
+/* 
+ * BIDI API
+ *   build a request. for bidi requests must be called twice to map/prepare
+ *   the data-in and data-out buffers, one at a time according to
+ *   the given rw READ/WRITE param.
+ */
+extern void blk_rq_bio_prep_bidi(request_queue_t *, struct request *,
+	struct bio *, int rw);
+extern int blk_rq_map_kern_bidi(request_queue_t *, struct request *,
+	void *, unsigned int, gfp_t, int rw);
+/* retrieve the mapped pages for bidi according to
+ * the given dma_data_direction
+ */
+extern int blk_rq_map_sg_bidi(request_queue_t *, struct request *,
+	struct scatterlist *, int rw);
+
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
 #define SAFE_MAX_SECTORS 255
-- 
1.5.0.4.402.g8035


--------------030309030308000306040601--
