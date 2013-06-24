From: Ingo Molnar <mingo@kernel.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Mon, 24 Jun 2013 10:21:47 +0200
Message-ID: <20130624082147.GC21768@gmail.com>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <51C77344.2040907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51C77344.2040907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 6/23/13 3:09 AM, Ingo Molnar wrote:
> >If an IO driver is implemented properly then it will batch up requests for
> >the controller, and gets IRQ-notified on a (sub-)batch of buffers
> >completed.
> >
> >If there's any spinning done then it should be NAPI-alike polling: a
> >single "is stuff completed" polling pass per new block of work submitted,
> >to opportunistically interleave completion with submission work.
> >
> >I don't see where active spinning brings would improve performance
> >compared to a NAPI-alike technique. Your numbers obviously show a speedup
> >we'd like to have, I'm just wondering whether the same speedup (or even
> >more) could be implemented via:
> >
> >  - smart batching that rate-limits completion IRQs in essence
> >  + NAPI-alike polling
> >
> >... which would almost never result in IRQ driven completion when we are
> >close to CPU-bound and while not yet saturating the IO controller's
> >capacity.
> >
> >The spinning approach you add has the disadvantage of actively wasting CPU
> >time, which could be used to run other tasks. In general it's much better
> >to make sure the completion IRQs are rate-limited and just schedule. This
> >(combined with a metric ton of fine details) is what the networking code
> >does in essence, and they have no trouble reaching very high throughput.
> 
> Networking code has a similar proposal for low latency sockets using 
> polling: https://lwn.net/Articles/540281/

In that case it might make sense to try the generic approach I suggested 
in the previous mail, which would measure average sleep latencies of 
tasks, and would do light idle-polling instead of the more expensive 
switch-to-the-idle-task context switch plus associated RCU, nohz, etc. 
busy-CPU-tear-down and the symmetric build-up work on idle wakeup.

The IO driver would still have to take an IRQ though, preferably on the 
CPU that runs the IO task ...

Thanks,

	Ingo
