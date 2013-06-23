From: Ingo Molnar <mingo@kernel.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Sun, 23 Jun 2013 12:09:20 +0200
Message-ID: <20130623100920.GA19021@gmail.com>
References: <20130620201713.GV8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:56313 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FWKJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 06:09:25 -0400
Content-Disposition: inline
In-Reply-To: <20130620201713.GV8211@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>


* Matthew Wilcox <willy@linux.intel.com> wrote:

> 
> A paper at FAST2012
> (http://static.usenix.org/events/fast12/tech/full_papers/Yang.pdf) pointed
> out the performance overhead of taking interrupts for low-latency block
> I/Os.  The solution the author investigated was to spin waiting for each
> I/O to complete.  This is inefficient as Linux submits many I/Os which
> are not latency-sensitive, and even when we do submit latency-sensitive
> I/Os (eg swap-in), we frequently submit several I/Os before waiting.
> 
> This RFC takes a different approach, only spinning when we would
> otherwise sleep.  To implement this, I add an 'io_poll' function pointer
> to backing_dev_info.  I include a sample implementation for the NVMe
> driver.  Next, I add an io_wait() function which will call io_poll()
> if it is set.  It falls back to calling io_schedule() if anything goes
> wrong with io_poll() or the task exceeds its timeslice.  Finally, all
> that is left is to judiciously replace calls to io_schedule() with
> calls to io_wait().  I think I've covered the main contenders with
> sleep_on_page(), sleep_on_buffer() and the DIO path.
> 
> I've measured the performance benefits of this with a Chatham NVMe
> prototype device and a simple
> # dd if=/dev/nvme0n1 of=/dev/null iflag=direct bs=512 count=1000000
> The latency of each I/O reduces by about 2.5us (from around 8.0us to
> around 5.5us).  This matches up quite well with the performance numbers
> shown in the FAST2012 paper (which used a similar device).

Nice speedup!

> Is backing_dev_info the right place for this function pointer?
> Have I made any bad assumptions about the correct way to retrieve
> the backing_dev_info from (eg) a struct page, buffer_head or kiocb?
> Should I pass a 'state' into io_wait() instead of retrieving it from
> 'current'?  Is kernel/sched/core.c the right place for io_wait()?
> Should it be bdi_wait() instead?  Should it be marked with __sched?
> Where should I add documentation for the io_poll() function pointer?
> 
> NB: The NVMe driver piece of this is for illustrative purposes only and
> should not be applied.  I've rearranged the diff so that the interesting
> pieces appear first.


-EMISSINGDIFFSTAT

> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c388155..97f8fde 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -68,6 +68,7 @@ struct backing_dev_info {
>  	unsigned int capabilities; /* Device capabilities */
>  	congested_fn *congested_fn; /* Function pointer if device is md/dm */
>  	void *congested_data;	/* Pointer to aux data for congested func */
> +	int (*io_poll)(struct backing_dev_info *);
>  
>  	char *name;
>  
> @@ -126,6 +127,8 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
>  void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
>  void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
>  
> +void io_wait(struct backing_dev_info *bdi);
> +
>  extern spinlock_t bdi_lock;
>  extern struct list_head bdi_list;
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..4840065 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4527,6 +4527,36 @@ long __sched io_schedule_timeout(long timeout)
>  	return ret;
>  }
>  
> +/*
> + * Wait for an I/O to complete against this backing_dev_info.  If the
> + * task exhausts its timeslice polling for completions, call io_schedule()
> + * anyway.  If a signal comes pending, return so the task can handle it.
> + * If the io_poll returns an error, give up and call io_schedule(), but
> + * swallow the error.  We may miss an I/O completion (eg if the interrupt
> + * handler gets to it first).  Guard against this possibility by returning
> + * if we've been set back to TASK_RUNNING.
> + */
> +void io_wait(struct backing_dev_info *bdi)
> +{
> +	if (bdi && bdi->io_poll) {
> +		long state = current->state;
> +		while (!need_resched()) {
> +			int ret = bdi->io_poll(bdi);
> +			if ((ret > 0) || signal_pending_state(state, current)) {
> +				set_current_state(TASK_RUNNING);
> +				return;
> +			}
> +			if (current->state == TASK_RUNNING)
> +				return;
> +			if (ret < 0)
> +				break;
> +			cpu_relax();
> +		}
> +	}
> +
> +	io_schedule();
> +}

I'm wondering why this makes such a performance difference.

If an IO driver is implemented properly then it will batch up requests for 
the controller, and gets IRQ-notified on a (sub-)batch of buffers 
completed.

If there's any spinning done then it should be NAPI-alike polling: a 
single "is stuff completed" polling pass per new block of work submitted, 
to opportunistically interleave completion with submission work.

I don't see where active spinning brings would improve performance 
compared to a NAPI-alike technique. Your numbers obviously show a speedup 
we'd like to have, I'm just wondering whether the same speedup (or even 
more) could be implemented via:

 - smart batching that rate-limits completion IRQs in essence
 + NAPI-alike polling

... which would almost never result in IRQ driven completion when we are 
close to CPU-bound and while not yet saturating the IO controller's 
capacity.

The spinning approach you add has the disadvantage of actively wasting CPU 
time, which could be used to run other tasks. In general it's much better 
to make sure the completion IRQs are rate-limited and just schedule. This 
(combined with a metric ton of fine details) is what the networking code 
does in essence, and they have no trouble reaching very high throughput.

Thanks,

	Ingo
