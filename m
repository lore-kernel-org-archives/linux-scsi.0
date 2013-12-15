From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 16:32:18 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312151550380.32133-100000@netrider.rowland.org>
References: <1387065313.6096.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51099 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751975Ab3LOVcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2013 16:32:19 -0500
In-Reply-To: <1387065313.6096.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Sat, 14 Dec 2013, James Bottomley wrote:

> > The refcount test and state change race with scsi_alloc_target().  
> > Maybe the race won't occur in practice, but to be safe you should hold
> > shost->host_lock throughout that time interval, as the original code
> > here does.
> 
> You mean the fact that using a state model to indicate whether we should
> destroy a target without bothering to refcount isn't robust against two
> threads of execution running through a scan on the same target?

I meant that the patch you posted suffers from a race when one thread
is adding a device to a target and another thread is removing an
existing device below that target at the same time.  Suppose the
target's reap_ref count is initially equal to 1:

	Thread 0			Thread 1
	--------			--------
	In scsi_alloc_target():		In scsi_target_reap():
	lock host_lock			scsi_target_reap_ref_put():
	find existing starget		starget->reap_ref drops to 0
	incr starget->reap_ref		In scsi_target_reap_ref_release():
	unlock host_lock		device_del(&starget->dev);
	starget->state == STARGET_DEL?
	No => okay to use starget	set starget->state = STARGET_DEL

Result: We end up using starget _and_ removing it.  The only way to
avoid this race would be to guarantee that we never add and remove
devices below the same target at the same time.  In theory this is 
feasible, but I don't know if you want to do it.

This doesn't seem to be what you are talking about above.  In any case, 
it is a bug.

>  Yes, it
> could be construed as a bug, but it's a bug in the old code as well.

The old code is immune to the bug I just described, because the
existing scsi_target_reap() holds the host_lock while manipulating
starget->state.

	Case A: Thread 0 acquires the host_lock first.  Then thread 0
	increments reap_ref while holding the lock.  Later on, thread 1
	acquires the lock and decrements reap_ref, but the value 
	doesn't drop to 0 (because of the prior increment).  Thus the
	target doesn't get reaped.

	Case B: Thread 1 acquires the host_lock first.  Then thread 1
	decrements reap_ref, sees that it drop to 0, and sets the state
	to STARGET_DEL, all before releasing the lock.  Later on, 
	thread 0 acquires the lock and increments reap_ref futilely, 
	but sees that the state has already been changed to 
	STARGET_DEL.  Thus, it delays and retries instead of using 
	starget.

> > This means the kref approach won't work so easily.  You might as well
> > leave reap_ref as an ordinary int.
> 
> Actually, no, we can better fix it using krefs.  We just force
> everything through the kref put instead of special casing the not made
> visible destruction case.  We can then case the release routine to fix
> this, like below.  I suppose since this is a separate bug I'll keep it
> as a separate patch.

It looks like you misunderstood the problem; the description in my
previous email was perhaps excessively brief.  Hopefully the
explanation above is sufficiently explicit to make everything clear.  
This new, separate patch doesn't fix it.

To fix this bug while using krefs would require that you hold the
host_lock while doing the kref_put().  The release routine could set
the state to STARGET_DEL, but then you would have to use the
execute_in_usercontext mechanism to do the rest of the release work.  

That's doable, but it seems simpler to keep the code the way it is.  
In which case there's no need to change reap_ref into an atomic kref,
because it is never modified outside the scope of the host_lock.

Alan Stern

