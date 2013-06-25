From: Jens Axboe <axboe@kernel.dk>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Tue, 25 Jun 2013 16:55:20 +0200
Message-ID: <20130625145520.GK5594@kernel.dk>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <20130624071544.GR9422@kernel.dk>
 <20130625030140.GZ8211@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130625030140.GZ8211@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 24 2013, Matthew Wilcox wrote:
> On Mon, Jun 24, 2013 at 09:15:45AM +0200, Jens Axboe wrote:
> > Willy, I think the general design is fine, hooking in via the bdi is the
> > only way to get back to the right place from where you need to sleep.
> > Some thoughts:
> > 
> > - This should be hooked in via blk-iopoll, both of them should call into
> >   the same driver hook for polling completions.
> 
> I actually started working on this, then I realised that it's actually
> a bad idea.  blk-iopoll's poll function is to poll the single I/O queue
> closest to this CPU.  The iowait poll function is to poll all queues
> that the I/O for this address_space might complete on.

blk_iopoll can be tied to "whatever". It was originally designed to be
tied to the queue, which would make it driver-wide. So there's no intent
for it to poll only a subset of the device, though if you tie it to a
completion queue (which would be most natural), then it'd only find
completions there.

I didn't look at your nvme end of the implementation - if you could
reliably map to the right completion queue, then it would have the same
mapping as iopoll on a per-completion queue basis. If you can't, then
you have to poll all of them. That doesn't seem like it would scale well
for having more than a few applications banging on a device.

> I'm reluctant to ask drivers to define two poll functions, but I'm even
> more reluctant to ask them to define one function with two purposes.
>
> > - It needs to be more intelligent in when you want to poll and when you
> >   want regular irq driven IO.
> 
> Oh yeah, absolutely.  While the example patch didn't show it, I wouldn't
> enable it for all NVMe devices; only ones with sufficiently low latency.
> There's also the ability for the driver to look at the number of
> outstanding I/Os and return an error (eg -EBUSY) to stop spinning.

There might also be read vs write differences. Say some devices complete
writes very quickly, but reads are slower. Or vice versa. And then
there's the inevitable "some IOs are slow, but usually very fast". But
that can't really be handled except giving up on the polling at some
point.

> > - With the former note, the app either needs to opt in (and hence
> >   willingly sacrifice CPU cycles of its scheduling slice) or it needs to
> >   be nicer in when it gives up and goes back to irq driven IO.
> 
> Yup.  I like the way you framed it.  If the task *wants* to spend its
> CPU cycles on polling for I/O instead of giving up the remainder of its
> time slice, then it should be able to do that.  After all, it already can;
> it can submit an I/O request via AIO, and then call io_getevents in a
> tight loop.

Exactly, that was my point. Or it can busy loop just checking the aio
ring, at which point it's really stupid to be IRQ driven at all. It'd be
much better to have the app reap the completion directly.

> So maybe the right way to do this is with a task flag?  If we go that
> route, I'd like to further develop this option to allow I/Os to be
> designated as "low latency" vs "normal".  Taking a page fault would be
> "low latency" for all tasks, not just ones that choose to spin for I/O.

Not sure, I'd have to think about it some more. It's a mix of what the
application decides to do, but also what the underlying device can do.
And there might be fs implications, etc.

-- 
Jens Axboe
