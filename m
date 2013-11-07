From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Thu, 7 Nov 2013 13:44:17 -0800
Message-ID: <20131107214417.GB31244@infradead.org>
References: <52718713.7050906@interlog.com>
 <20131031155653.GA16944@infradead.org>
 <5272AD80.90203@interlog.com>
 <20131106155044.GA9323@infradead.org>
 <527A98E0.20601@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3KGVoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 16:44:17 -0500
Content-Disposition: inline
In-Reply-To: <527A98E0.20601@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Wed, Nov 06, 2013 at 02:30:40PM -0500, Douglas Gilbert wrote:
> >during sg_open and sg_release, which are guranteed not to migrate
> >to a different process during their run time.
> 
> True. What I stated would be a problem if a mutex tried
> to do something similar to Vaughan's patch that was
> reverted just before lk 3.12.0. That held a read or write
> semaphore between a sg_open() and sg_release().
> 
> But your point begs the question why should any driver
> pay the extra cost and usability restrictions of a kernel
> mutex over a semaphore without good reason:

It allows features like spinning before going to sleep, as well
as helping with RT patches.  But this really isn't the place to
discuss this - the ship has sailed and just about any semaphore
used for basic mutal exclusion has been converted to a mutex.

Complaints about that should be directed to Linus and/or the locking
primitive maintainers.

> So what contexts can mutexes be used in?

They can be used in process context only.  Please make sure to also
run any patches changing locking behaviour with CONFIG_PROVE_LOCKING
enabled, as that will verify all this.

> Also, which one in the above list tells me that sg_open()
> cannot return to the caller with a mutex held? Given
> the special relationship guaranteed by the OS (POSIX)
> between sg_open() and sg_release() *** for the same file
> handle, if this is not allowed, why?

Because you always release it before returning.  Note that the
sparse static checker can verify that for you, if the functions
get to big, which sg_open might get close to.  Sparse is another
tool that I wish every patch author would run before submission.

Read Documentation/sparse.txt for details.

> >It always is called through the class interface remove_dev
> >method, which always is called under a lock.
> 
> This is an important piece of extra information. Does that
> mean sg_add() and sg_remove() can't wait on anything? I note
> that sg_add() calls sg_alloc() which immediately does:
>   sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);

You can sleep under mutexes just fine, although in general it
is preferable to sleep too long with mutexes held.

> Where are the preconditions from the scsi subsystem to a ULD
> stating:
>   - that sg_remove() and sg_add() are called from a non-interrupt,
>     non tasklet and non timer context?

The driver core uses sleeping calls like mutexes in all these code
pathes, so a call from these contexts will blow up immediately.

>   - invocations of sg_add() and sg_remove() are paired in a
>     similar fashion as sg_open() and sg_release()

That's how the class_interfaces work, easily verified by code
inspection.  Unfortunately these interfaces aren't really documented,
but a patch to Greg who is in Cc now will take care of that.

> By the second point I mean, for example, that sg_remove()
> cannot be called twice for the same device without a sg_add()
> between them to add (back) that device.

That is correct.

