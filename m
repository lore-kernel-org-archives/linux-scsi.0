From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/4] blk-mq: introduce BLK_MQ_F_SCHED_USE_HW_TAG
Date: Sat, 6 May 2017 07:33:56 +0800
Message-ID: <20170505233348.GA8326@ming.t460p>
References: <20170428151539.25514-1-ming.lei@redhat.com>
 <20170428151539.25514-2-ming.lei@redhat.com>
 <20170503164631.GA10775@vader>
 <CACVXFVNXeq6S9GZZ=DnY7iSziyBav0XXvY0kRnUCuddqVe-MgA@mail.gmail.com>
 <20170503214029.GA27440@vader>
 <CACVXFVMLuGioTLCJt3AF6NBkpb=7T48mEm0b1q-ATJs2PFYjYg@mail.gmail.com>
 <b7f4f8cf-30d1-8995-4256-c96184522992@fb.com>
 <20170504025150.GA16218@ming.t460p>
 <0a927231-c04e-72aa-a756-4f2ae896ce53@fb.com>
 <20170505225409.GA3773@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170505225409.GA3773@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Omar Sandoval <osandov@osandov.com>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Omar Sandoval <osandov@fb.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 06, 2017 at 06:54:09AM +0800, Ming Lei wrote:
> On Thu, May 04, 2017 at 08:06:15AM -0600, Jens Axboe wrote:
> > On 05/03/2017 08:51 PM, Ming Lei wrote:
> > > On Wed, May 03, 2017 at 08:13:03PM -0600, Jens Axboe wrote:
> > >> On 05/03/2017 08:01 PM, Ming Lei wrote:
> > >>> On Thu, May 4, 2017 at 5:40 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > >>>> On Thu, May 04, 2017 at 04:13:51AM +0800, Ming Lei wrote:
> > >>>>> On Thu, May 4, 2017 at 12:46 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > >>>>>> On Fri, Apr 28, 2017 at 11:15:36PM +0800, Ming Lei wrote:
> > >>>>>>> When blk-mq I/O scheduler is used, we need two tags for
> > >>>>>>> submitting one request. One is called scheduler tag for
> > >>>>>>> allocating request and scheduling I/O, another one is called
> > >>>>>>> driver tag, which is used for dispatching IO to hardware/driver.
> > >>>>>>> This way introduces one extra per-queue allocation for both tags
> > >>>>>>> and request pool, and may not be as efficient as case of none
> > >>>>>>> scheduler.
> > >>>>>>>
> > >>>>>>> Also currently we put a default per-hctx limit on schedulable
> > >>>>>>> requests, and this limit may be a bottleneck for some devices,
> > >>>>>>> especialy when these devices have a quite big tag space.
> > >>>>>>>
> > >>>>>>> This patch introduces BLK_MQ_F_SCHED_USE_HW_TAG so that we can
> > >>>>>>> allow to use hardware/driver tags directly for IO scheduling if
> > >>>>>>> devices's hardware tag space is big enough. Then we can avoid
> > >>>>>>> the extra resource allocation and make IO submission more
> > >>>>>>> efficient.
> > >>>>>>>
> > >>>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > >>>>>>> ---
> > >>>>>>>  block/blk-mq-sched.c   | 10 +++++++++-
> > >>>>>>>  block/blk-mq.c         | 35 +++++++++++++++++++++++++++++------
> > >>>>>>>  include/linux/blk-mq.h |  1 +
> > >>>>>>>  3 files changed, 39 insertions(+), 7 deletions(-)
> > >>>>>>
> > >>>>>> One more note on this: if we're using the hardware tags directly, then
> > >>>>>> we are no longer limited to q->nr_requests requests in-flight. Instead,
> > >>>>>> we're limited to the hw queue depth. We probably want to maintain the
> > >>>>>> original behavior,
> > >>>>>
> > >>>>> That need further investigation, and generally scheduler should be happy with
> > >>>>> more requests which can be scheduled.
> > >>>>>
> > >>>>> We can make it as one follow-up.
> > >>>>
> > >>>> If we say nr_requests is 256, then we should honor that. So either
> > >>>> update nr_requests to reflect the actual depth we're using or resize the
> > >>>> hardware tags.
> > >>>
> > >>> Firstly nr_requests is set as 256 from blk-mq inside instead of user
> > >>> space, it won't be a big deal to violate that.
> > >>
> > >> The legacy scheduling layer used 2*128 by default, that's why I used the
> > >> "magic" 256 internally. FWIW, I agree with Omar here. If it's set to
> > >> 256, we must honor that. Users will tweak this value down to trade peak
> > >> performance for latency, it's important that it does what it advertises.
> > > 
> > > In case of scheduling with hw tags, we share tags between scheduler and
> > > dispatching, if we resize(only decrease actually) the tags, dispatching
> > > space(hw tags) is decreased too. That means the actual usable device tag
> > > space need to be decreased much.
> > 
> > I think the solution here is to handle it differently. Previous, we had
> > requests and tags independent. That meant that we could have an
> > independent set of requests for scheduling, then assign tags as we need
> > to dispatch them to hardware. This is how the old schedulers worked, and
> > with the scheduler tags, this is how the new blk-mq scheduling works as
> > well.
> > 
> > Once you start treating them as one space again, we run into this issue.
> > I can think of two solutions:
> > 
> > 1) Keep our current split, so we can schedule independently of hardware
> >    tags.
> 
> Actually hw tag depends on scheduler tag as I explained, so both aren't
> independently, and even they looks split.
> 
> Also I am not sure how we do that if we need to support scheduling with
> hw tag, could you explain it a bit?
> 
> > 
> > 2) Throttle the queue depth independently. If the user asks for a depth
> >    of, eg, 32, retain a larger set of requests but limit the queue depth
> >    on the device side fo 32.
> 
> If I understand correctly, we can support scheduling with hw tag by this
> patchset plus setting q->nr_requests as size of hw tag space. Otherwise
> it isn't easy to throttle the queue depth independently because hw tag
> actually depends on scheduler tag.
> 
> The 3rd one is to follow Omar's suggestion, by resizing the queue depth
> as q->nr_requests simply.
> 
> > 
> > This is much easier to support with split hardware and scheduler tags...
> > 
> > >>> Secondly, when there is enough tags available, it might hurt
> > >>> performance if we don't use them all.
> > >>
> > >> That's mostly bogus. Crazy large tag depths have only one use case -
> > >> synthetic peak performance benchmarks from manufacturers. We don't want
> > >> to allow really deep queues. Nothing good comes from that, just a lot of
> > >> pain and latency issues.
> > > 
> > > Given device provides so high queue depth, it might be reasonable to just
> > > allow to use them up. For example of NVMe, once mq scheduler is enabled,
> > > the actual size of device tag space is just 256 at default, even though
> > > the hardware provides very big tag space(>= 10K).
> > 
> > Correct.
> > 
> > > The problem is that lifetime of sched tag is same with request's
> > > lifetime(from submission to completion), and it covers lifetime of
> > > device tag.  In theory sched tag should have been freed just after
> > > the rq is dispatched to driver. Unfortunately we can't do that because
> > > request is allocated from sched tag set.
> > 
> > Yep
> 
> Request copying like what your first post of mq scheduler patch did
> may fix this issue, and in that way we can make both two tag space
> independent, but with extra cost. What do you think about this approach?

Or something like the following(I am on a trip now, and it is totally
un-tested)?

---

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8f72f16b498a..ce6bb849a395 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -855,6 +855,17 @@ static inline unsigned int queued_to_index(unsigned int queued)
 	return min(BLK_MQ_MAX_DISPATCH_ORDER - 1, ilog2(queued) + 1);
 }
 
+static void blk_mq_replace_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	int sched_tag = rq->internal_tag;
+	struct request *rq_for_replacement = hctx->tags->static_rqs[rq->tag];
+
+	hctx->sched_tags->static_rqs[rq->internal_tag] = rq_for_replacement;
+
+	blk_mq_put_tag(hctx, hctx->sched_tags, rq->mq_ctx, rq->internal_tag);
+	rq->internal_tag = -1;
+}
+
 bool blk_mq_get_driver_tag(struct request *rq, struct blk_mq_hw_ctx **hctx,
 			   bool wait)
 {
@@ -878,7 +889,9 @@ bool blk_mq_get_driver_tag(struct request *rq, struct blk_mq_hw_ctx **hctx,
 			rq->rq_flags |= RQF_MQ_INFLIGHT;
 			atomic_inc(&data.hctx->nr_active);
 		}
 		data.hctx->tags->rqs[rq->tag] = rq;
+		blk_mq_replace_rq(data.hctx, rq);
 	}
 
 done:
@@ -887,38 +900,6 @@ bool blk_mq_get_driver_tag(struct request *rq, struct blk_mq_hw_ctx **hctx,
 	return rq->tag != -1;
 }
 
-static void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
-				    struct request *rq)
-{
-	blk_mq_put_tag(hctx, hctx->tags, rq->mq_ctx, rq->tag);
-	rq->tag = -1;
-
-	if (rq->rq_flags & RQF_MQ_INFLIGHT) {
-		rq->rq_flags &= ~RQF_MQ_INFLIGHT;
-		atomic_dec(&hctx->nr_active);
-	}
-}
-
-static void blk_mq_put_driver_tag_hctx(struct blk_mq_hw_ctx *hctx,
-				       struct request *rq)
-{
-	if (rq->tag == -1 || rq->internal_tag == -1)
-		return;
-
-	__blk_mq_put_driver_tag(hctx, rq);
-}
-
-static void blk_mq_put_driver_tag(struct request *rq)
-{
-	struct blk_mq_hw_ctx *hctx;
-
-	if (rq->tag == -1 || rq->internal_tag == -1)
-		return;
-
-	hctx = blk_mq_map_queue(rq->q, rq->mq_ctx->cpu);
-	__blk_mq_put_driver_tag(hctx, rq);
-}
-
 /*
  * If we fail getting a driver tag because all the driver tags are already
  * assigned and on the dispatch list, BUT the first entry does not have a
@@ -1041,7 +1022,6 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 			queued++;
 			break;
 		case BLK_MQ_RQ_QUEUE_BUSY:
-			blk_mq_put_driver_tag_hctx(hctx, rq);
 			list_add(&rq->queuelist, list);
 			__blk_mq_requeue_request(rq);
 			break;
@@ -1069,7 +1049,6 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 		 * tag for the next request already, free it again.
 		 */
 		rq = list_first_entry(list, struct request, queuelist);
-		blk_mq_put_driver_tag(rq);
 
 		spin_lock(&hctx->lock);
 		list_splice_init(list, &hctx->dispatch);

Thanks,
Ming
