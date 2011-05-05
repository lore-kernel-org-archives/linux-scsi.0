From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Date: Thu, 5 May 2011 10:38:53 +0200
Message-ID: <20110505083853.GC30950@htj.dyndns.org>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.817084678@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110505020417.817084678@sli10-conroe.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jaxboe@fusionio.com, hch@infradead.org, jgarzik@pobox.com, djwong@us.ibm.com, sshtylyov@mvista.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, ricwheeler@gmail.com
List-Id: linux-scsi@vger.kernel.org

(cc'ing James, Ric, Christoph and lscsi.  Hi! Please jump to the
bottom of the message.)

Hello,

On Thu, May 05, 2011 at 09:59:34AM +0800, shaohua.li@intel.com wrote:
> In some drives, flush requests are non-queueable. When flush request is running,
> normal read/write requests can't run. If block layer dispatches such request,
> driver can't handle it and requeue it.
> Tejun suggested we can hold the queue when flush is running. This can avoid
> unnecessary requeue.
> Also this can improve performance. For example, we have request flush1, write1,
> flush 2. flush1 is dispatched, then queue is hold, write1 isn't inserted to
> queue. After flush1 is finished, flush2 will be dispatched. Since disk cache
> is already clean, flush2 will be finished very soon, so looks like flush2 is
> folded to flush1.
> In my test, the queue holding completely solves a regression introduced by
> commit 53d63e6b0dfb95882ec0219ba6bbd50cde423794:
>     block: make the flush insertion use the tail of the dispatch list
> 
>     It's not a preempt type request, in fact we have to insert it
>     behind requests that do specify INSERT_FRONT.
> which causes about 20% regression running a sysbench fileio
> workload.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

But, I think the description and comments can use some refinements.
First of all, new lines won't steal your first born.  Don't be too
afraid of them both in the patch description and comments.

For the patch description, I want to recomment explaining the
regression case first - explain why the regression happened and then
show how this patch solves the issue.  Also, more conventional way to
refer to a commit is 53d63e6b0d (block: make the flush insertion use
the tail of the dispatch list).

>  	/*
> -	 * Moving a request silently to empty queue_head may stall the
> -	 * queue.  Kick the queue in those cases.  This function is called
> -	 * from request completion path and calling directly into
> -	 * request_fn may confuse the driver.  Always use kblockd.
> +	 * Kick the queue to avoid stall for two cases:
> +	 * 1. Moving a request silently to empty queue_head may stall the
> +	 * queue.
> +	 * 2. When flush request is running in non-queueable queue, the
> +	 * queue is hold. Restart the queue after flush request is finished
> +	 * to avoid stall.
> +	 * This function is called from request completion path and calling
> +	 * directly into request_fn may confuse the driver.  Always use
> +	 * kblockd.
>  	 */

Yeap, pretty good but let's add a bit more whitespaces and apply
slight adjustments.

	/*
	 * After flush sequencing, the following two cases may lead to
	 * queue stall.
	 *
	 * 1. Moving a request silently to empty queue_head.
	 *
	 * 2. If flush request was non-queueable, request dispatching may
	 *    have been blocked while flush was in progress.
	 *
	 * Make sure queue processing is restarted by kicking the queue.
	 * As this function is called from request completion path,
	 * calling directly into request_fn may confuse the driver.  Always
	 * use kblockd.
	 */

> +		/*
> +		 * Flush request is running and flush request isn't queueable
> +		 * in the drive, we can hold the queue till flush request is
> +		 * finished. Even we don't do this, driver can't dispatch next
> +		 * requests and will requeue them. And this can improve
> +		 * throughput too. For example, we have request flush1, write1,
> +		 * flush 2. flush1 is dispatched, then queue is hold, write1
> +		 * isn't inserted to queue. After flush1 is finished, flush2
> +		 * will be dispatched. Since disk cache is already clean,
> +		 * flush2 will be finished very soon, so looks like flush2 is
> +		 * folded to flush1.
> +		 * Since the queue is hold, a flag is set to indicate the queue
> +		 * should be restarted later. Please see flush_end_io() for
> +		 * details.
> +		 */

Similarly, I'd like to suggest something like the following.

		/*
		 * Hold dispatching of regular requests if non-queueable
		 * flush is in progress; otherwise, the low level driver
		 * would keep dispatching IO requests just to requeue them
		 * until the flush finishes, which not only adds
		 * dispatching / requeueing overhead but may also
		 * significantly affect throughput when multiple flushes
		 * are issued back-to-back.  Please consider the following
		 * scenario.
		 *
		 * - flush1 is dispatched with write1 in the elevator.
		 *
		 * - Driver dispatches write1 and requeues it.
		 *
		 * - flush2 is issued and appended to dispatch queue after
		 *   the requeued write1.  As write1 has been requeued
		 *   flush2 can't be put in front of it.
		 *
		 * - When flush1 finishes, the driver has to process write1
		 *   before flush2 even though there's no fundamental
		 *   reason flush2 can't be processed first and, when two
		 *   flushes are issued back-to-back without intervening
		 *   writes, the second one essentially becomes noop.
		 *
		 * This phenomena becomes quite visible under heavy
		 * concurrent fsync workload and holding the queue while
		 * flush is in progress leads to significant throughput
		 * gain.
		 */

And two more things that I think are worth investigating.

- I wonder whether this would be useful for even devices which can
  queue flushes (ie. native SCSI ones).  There definitely are some
  benefits to queueing flushes in terms of hiding command dispatching
  overhead and if the device is smart/deep enough parallelly
  processing non-conflicting operations (ie. reads and flushing later
  writes together if the head sweeps that way).

  That said, flushes are mostly mutually exclusive w.r.t. writes and
  even with queueable flushes, we might benefit more by holding
  further writes until flush finishes.  Under light sync workload,
  this doesn't matter anyway.  Under heavy, the benefit of queueing
  the later writes together can be easily outweighted by some of
  flushes becoming noops.

  Unfortunately (or rather, fortunately), I don't have any access to
  such fancy devices so it would be great if the upscale storage guys
  can tinker with it a bit and see how it fares.  If it goes well, we
  can also make things more advanced by implementing back-to-back
  noop'ing in block layer and allowing issue of reads parallelly with
  flushes, if the benefits they bring justify the added complexity.

- This is much more minor but if block layer already knows flushes are
  non-queueable, it might be a good idea to hold dispatching of
  flushes if other requests are already in progress.  It will only
  save dispatch/requeue overhead which might not matter at all, so
  this has pretty good chance of not being worth of the added
  complexity tho.

So, is anyone from the upscale storage world interested?

Thanks.

-- 
tejun
