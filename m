From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Date: Fri, 06 May 2011 12:32:05 +0800
Message-ID: <1304656325.3828.22.camel@sli10-conroe>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
	 <20110505020417.817084678@sli10-conroe.sh.intel.com>
	 <20110505083853.GC30950@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110505083853.GC30950@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jaxboe@fusionio.com" <jaxboe@fusionio.com>, "hch@infradead.org" <hch@infradead.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "djwong@us.ibm.com" <djwong@us.ibm.com>, "sshtylyov@mvista.com" <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ricwheeler@gmail.com" <ricwheeler@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-05 at 16:38 +0800, Tejun Heo wrote:
> (cc'ing James, Ric, Christoph and lscsi.  Hi! Please jump to the
> bottom of the message.)
> 
> Hello,
> 
> On Thu, May 05, 2011 at 09:59:34AM +0800, shaohua.li@intel.com wrote:
> > In some drives, flush requests are non-queueable. When flush request is running,
> > normal read/write requests can't run. If block layer dispatches such request,
> > driver can't handle it and requeue it.
> > Tejun suggested we can hold the queue when flush is running. This can avoid
> > unnecessary requeue.
> > Also this can improve performance. For example, we have request flush1, write1,
> > flush 2. flush1 is dispatched, then queue is hold, write1 isn't inserted to
> > queue. After flush1 is finished, flush2 will be dispatched. Since disk cache
> > is already clean, flush2 will be finished very soon, so looks like flush2 is
> > folded to flush1.
> > In my test, the queue holding completely solves a regression introduced by
> > commit 53d63e6b0dfb95882ec0219ba6bbd50cde423794:
> >     block: make the flush insertion use the tail of the dispatch list
> > 
> >     It's not a preempt type request, in fact we have to insert it
> >     behind requests that do specify INSERT_FRONT.
> > which causes about 20% regression running a sysbench fileio
> > workload.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
Thanks. I updated changelogs.

> And two more things that I think are worth investigating.
> 
> - I wonder whether this would be useful for even devices which can
>   queue flushes (ie. native SCSI ones).  There definitely are some
>   benefits to queueing flushes in terms of hiding command dispatching
>   overhead and if the device is smart/deep enough parallelly
>   processing non-conflicting operations (ie. reads and flushing later
>   writes together if the head sweeps that way).
> 
>   That said, flushes are mostly mutually exclusive w.r.t. writes and
>   even with queueable flushes, we might benefit more by holding
>   further writes until flush finishes.  Under light sync workload,
>   this doesn't matter anyway.  Under heavy, the benefit of queueing
>   the later writes together can be easily outweighted by some of
>   flushes becoming noops.
> 
>   Unfortunately (or rather, fortunately), I don't have any access to
>   such fancy devices so it would be great if the upscale storage guys
>   can tinker with it a bit and see how it fares.  If it goes well, we
>   can also make things more advanced by implementing back-to-back
>   noop'ing in block layer and allowing issue of reads parallelly with
>   flushes, if the benefits they bring justify the added complexity.
> 
> - This is much more minor but if block layer already knows flushes are
>   non-queueable, it might be a good idea to hold dispatching of
>   flushes if other requests are already in progress.  It will only
>   save dispatch/requeue overhead which might not matter at all, so
>   this has pretty good chance of not being worth of the added
>   complexity tho.
I did some experiment to hold flush too, but no obvious performance
difference. It doesn't make more flush requests merge. Avoiding
unnecessary requeue is a gain for fast devices, but my test doesn't
show.


Subject: block: hold queue if flush is running for non-queueable flush drive

Commit 53d63e6b0dfb9(block: make the flush insertion use the tail of
the dispatch list) causes about 20% regression running a sysbench fileio
workload. Let's consider the following scenario:
- flush1 is dispatched with write1 in the elevator.
- Driver dispatches write1 and requeues it.
- flush2 is issued and appended to dispatch queue after the requeued write1. 
  As write1 has been requeued flush2 can't be put in front of it.
- When flush1 finishes, the driver has to process write1 before flush2 even
  though there's no fundamental reason flush2 can't be processed first and,
  when two flushes are issued back-to-back without intervening writes, the
  second one essentially becomes noop.
Without the commit, flush2 is inserted before write1, so the issue is hiden.
But the commit itself makes sense, because flush request isn't a preempt
request, there is no reason to add it to queue head.

The regression is exposed in a SATA device. In SATA, flush requests are
non-queueable. When flush request is running, normal read/write requests
can't run. If block layer dispatches such request, driver can't handle it
and requeue it. Tejun suggested we can hold the queue when flush is running.
This can avoid unnecessary requeue.

And also this can improve performance and solve the regression. In above
scenario, when flush1 is running, queue is hold, so write1 isn't dispatched.
flush2 will be the only request in the queue. After flush1 is finished, flush2
will be dispatched soon. Since there is no write between flush1 and flush2,
flush2 essentially becomes noop.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-flush.c      |   19 ++++++++++++++-----
 block/blk.h            |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 49 insertions(+), 6 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2011-05-05 10:33:03.000000000 +0800
+++ linux/block/blk-flush.c	2011-05-06 11:21:20.000000000 +0800
@@ -212,13 +212,22 @@ static void flush_end_io(struct request
 	}
 
 	/*
-	 * Moving a request silently to empty queue_head may stall the
-	 * queue.  Kick the queue in those cases.  This function is called
-	 * from request completion path and calling directly into
-	 * request_fn may confuse the driver.  Always use kblockd.
+	 * After flush sequencing, the following two cases may lead to
+	 * queue stall.
+	 *
+	 * 1. Moving a request silently to empty queue_head.
+	 *
+	 * 2. If flush request was non-queueable, request dispatching may
+	 *    have been blocked while flush was in progress.
+	 *
+	 * Make sure queue processing is restarted by kicking the queue.
+	 * As this function is called from request completion path,
+	 * calling directly into request_fn may confuse the driver.  Always
+	 * use kblockd.
 	 */
-	if (queued)
+	if (queued || q->flush_queue_delayed)
 		blk_run_queue_async(q);
+	q->flush_queue_delayed = 0;
 }
 
 /**
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-05-06 11:20:08.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-05-06 11:20:14.000000000 +0800
@@ -365,6 +365,7 @@ struct request_queue
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
+	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
Index: linux/block/blk.h
===================================================================
--- linux.orig/block/blk.h	2011-05-05 10:33:03.000000000 +0800
+++ linux/block/blk.h	2011-05-06 11:22:42.000000000 +0800
@@ -61,7 +61,40 @@ static inline struct request *__elv_next
 			rq = list_entry_rq(q->queue_head.next);
 			return rq;
 		}
-
+		/*
+		 * Hold dispatching of regular requests if non-queueable
+		 * flush is in progress; otherwise, the low level driver
+		 * would keep dispatching IO requests just to requeue them
+		 * until the flush finishes, which not only adds
+		 * dispatching / requeueing overhead but may also
+		 * significantly affect throughput when multiple flushes
+		 * are issued back-to-back.  Please consider the following
+		 * scenario.
+		 *
+		 * - flush1 is dispatched with write1 in the elevator.
+		 *
+		 * - Driver dispatches write1 and requeues it.
+		 *
+		 * - flush2 is issued and appended to dispatch queue after
+		 *   the requeued write1.  As write1 has been requeued
+		 *   flush2 can't be put in front of it.
+		 *
+		 * - When flush1 finishes, the driver has to process write1
+		 *   before flush2 even though there's no fundamental
+		 *   reason flush2 can't be processed first and, when two
+		 *   flushes are issued back-to-back without intervening
+		 *   writes, the second one essentially becomes noop.
+		 *
+		 * This phenomena becomes quite visible under heavy
+		 * concurrent fsync workload and holding the queue while
+		 * flush is in progress leads to significant throughput
+		 * gain.
+		 */
+		if (q->flush_pending_idx != q->flush_running_idx &&
+				!queue_flush_queueable(q)) {
+			q->flush_queue_delayed = 1;
+			return NULL;
+		}
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
