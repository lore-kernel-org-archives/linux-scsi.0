From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 23:17:21 -0400
Message-ID: <20100730031721.GA31762@redhat.com>
References: <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729024334.GA21736@redhat.com>
 <20100729084225.GA30446@lst.de>
 <20100729200217.GD28704@redhat.com>
 <20100729200655.GB17767@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100729200655.GB17767@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 29, 2010 at 10:06:55PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 29, 2010 at 04:02:17PM -0400, Vivek Goyal wrote:
> > Looks like you still want to go with option 2 where you will scan the file
> > system code for requirement of DRAIN semantics and everything is fine then for
> > devices no supporting volatile caches, you will mark request queue as NONE.
> 
> The filesystem can't simply change the request queue settings. A request
> queue is often shared by multiple filesystems that can have very
> different requirements.
> 
> > This solves the problem on devices with WCE=0 but what about devices with
> > WCE=1. If file systems anyway don't require DRAIN semantics, then we
> > should not require it on devices with WCE=1 also?
> 
> Yes.
> 
> > If yes, then why not go with another variant of barriers which don't
> > perform DRAIN and just do PREFLUSH + FUA (or post flush for devices not
> > supporting FUA).
> 
> I've been trying to prototype it, but it's in fact rather hard to
> get this right.  Tejun has done a really good job at the current
> barrier implementation and coming up with something just half as
> clever for the relaxed barriers has been driving me mad.
> 
> > And then file systems can slowly move to using this non
> > draining barrier usage wherever appropriate.
> 
> Actually supporting different kind of barriers at the same time
> is even harder.  We'll need two different state machines for them,
> including the actual state in the request_queue.  And then make
> sure when different filesystems on the same queue use different
> types work well together.  If at all possible switching the semantics
> on a flag day would make life a lot simpler.

Hi Christoph,

I was looking at barrier code and was trying to think that how hard it is
to support a new barrier type which does not implement DRAIN but only
does PREFLUSH + FUA for devices with WCE=1.

To me it looked like as if everything is there and it is just a matter
of skipping elevator draining and request queue draining.

Can you please have a look at attached patch. This is not a complete patch
but just a part of it if we were to implement another barrier type, say
FLUSHBARRIER. Do you think this will work or I am blissfuly unaware of 
complexity here and oversimplifying the things.

Thanks
Vivek

---
 block/blk-barrier.c    |   14 +++++++++++++-
 block/elevator.c       |    3 ++-
 include/linux/blkdev.h |    5 ++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-06-19 09:54:32.000000000 -0400
+++ linux-2.6/include/linux/blkdev.h	2010-07-29 22:36:52.000000000 -0400
@@ -97,6 +97,7 @@ enum rq_flag_bits {
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
 	__REQ_HARDBARRIER,	/* may not be passed by drive either */
+	__REQ_FLUSHBARRIER,	/* only flush barrier. no drains required  */
 	__REQ_FUA,		/* forced unit access */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
@@ -126,6 +127,7 @@ enum rq_flag_bits {
 #define REQ_SORTED	(1 << __REQ_SORTED)
 #define REQ_SOFTBARRIER	(1 << __REQ_SOFTBARRIER)
 #define REQ_HARDBARRIER	(1 << __REQ_HARDBARRIER)
+#define REQ_FLUSHBARRIER	(1 << __REQ_FLUSHBARRIER)
 #define REQ_FUA		(1 << __REQ_FUA)
 #define REQ_NOMERGE	(1 << __REQ_NOMERGE)
 #define REQ_STARTED	(1 << __REQ_STARTED)
@@ -626,6 +628,7 @@ enum {
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
+#define blk_flush_barrier_rq(rq)	((rq)->cmd_flags & REQ_FLUSHBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_discard_rq(rq)	((rq)->cmd_flags & REQ_DISCARD)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
@@ -681,7 +684,7 @@ static inline void blk_clear_queue_full(
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
+	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER | REQ_FLUSHBARRIER)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (blk_discard_rq(rq) || blk_fs_request((rq))))
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2010-06-19 09:54:29.000000000 -0400
+++ linux-2.6/block/blk-barrier.c	2010-07-29 23:02:05.000000000 -0400
@@ -219,7 +219,8 @@ static inline bool start_ordered(struct 
 	} else
 		skip |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q))
+	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q)
+	    && !blk_flush_barrier_rq(rq))
 		rq = NULL;
 	else
 		skip |= QUEUE_ORDSEQ_DRAIN;
@@ -241,6 +242,17 @@ bool blk_do_ordered(struct request_queue
 	if (!q->ordseq) {
 		if (!is_barrier)
 			return true;
+		/*
+		 * For flush only barriers, nothing has to be done if there is
+		 * no caching happening on the deice. The barrier request is
+		 * still has to be written to disk but it can written as
+		 * normal rq.
+		 */
+
+		if (blk_flush_barrier_rq(rq)
+		    && (q->ordered & QUEUE_ORDERED_BY_DRAIN
+		        || q->ordered & QUEUE_ORDERED_BY_TAG))
+			return true;
 
 		if (q->next_ordered != QUEUE_ORDERED_NONE)
 			return start_ordered(q, rqp);
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2010-06-19 09:54:29.000000000 -0400
+++ linux-2.6/block/elevator.c	2010-07-29 23:06:21.000000000 -0400
@@ -628,7 +628,8 @@ void elv_insert(struct request_queue *q,
 
 	case ELEVATOR_INSERT_BACK:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
-		elv_drain_elevator(q);
+		if (!blk_flush_barrier_rq(rq))
+			elv_drain_elevator(q);
 		list_add_tail(&rq->queuelist, &q->queue_head);
 		/*
 		 * We kick the queue here for the following reasons.
