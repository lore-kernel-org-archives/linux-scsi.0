From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock (take 2)
Date: Thu, 8 May 2003 16:40:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508164049.A26710@beaverton.ibm.com>
References: <20030506175918.A22717@beaverton.ibm.com> <3EBA915C.5020505@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:34992 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262219AbTEHXcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 19:32:08 -0400
Content-Disposition: inline
In-Reply-To: <3EBA915C.5020505@rogers.com>; from tluben@rogers.com on Thu, May 08, 2003 at 01:18:20PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, May 08, 2003 at 01:18:20PM -0400, Luben Tuikov wrote:
> In this patch you're not really just changing the list_lock
> to dev_lock, but you're messing with the allocation code.

The main intent of the patch is for the main line scsi code path (via
scsi_prep_fn and scsi_end_request) to use only one lock where we use two
locks today. There is no change in the allocation algorithm (unlike the
_separate_ patch to have a spare or more appropriately named cached cmd
per device, but I can repost the latest incarnation if anyone really wants
to see it).

> The allocation code was intended to be called from
> anywhere, call from any context, scsi_get/put_command() to
> get/put a command.  It really is THAT simple.  Please leave it
> alone.

The functions can still can be called from anywhere and with any context
with the patch.

The patch assumes that callers from outside scsi core are not the norm,
this is currently true for all (four) users of get/put from outside scsi
core, and all of those could use something better than scsi_get_command.
The aha can use the scmd supplied by the eh; cpq can do nearly the same
but is still referencing scsi_do_cmd(); gdth could use a different and
better method other than allocating a command used to just find a matching
target.

It is not clear what is best for all code that _should_ be using
scsi_get/put_command - such as on stack allocations or like what we now
have in the aic driver (ahc_linux_dv_target).

[The aic does its own allocation of both a scsi_device and a scsi_cmnd,
but it cannot use the mainline scsi_request_fn and so cannot use the
scsi_allocate_request and friends, as it calls its own queue command when
host->host_self_blocked set.]

> >  
> > -static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
> > -					    int gfp_mask)
> > +static struct scsi_cmnd *scsi_alloc_cmd(struct Scsi_Host *shost,
> > +					       int gfp_mask)
> 
> Please lay off of this already.
> 
> The choice of PUT and GET is intentional.  Just leave
> this code alone.

The use of the names put/get in the kernel code is ambigous - some gets
always allocate, some never allocate.

I don't see why you object to the simple name of a static function - I'm
just trying to avoid another level of naming for scsi_get_command. It is
clear what the function does.

> > +/*
> > + * Function:	__scsi_get_command()
> > + *
> > + * Purpose:	Allocate and setup a scsi command block. This function is
> > + * 		extern but not exported outside of scsi.
> > + *
> > + * Arguments:	dev	- parent scsi device
> > + *		gfp_mask- allocator flags
> > + *
> > + * Locks:	Called with sdev_lock held.
> 
> I don't like this in principle.
> 
> Spinlocks, especially IRQ ones, are supposed to take the absolute
> possible minimum amount of code-area.  And here you're grabbing the
> lock elsewhere (in your new version of scsi_get_cmnd()) and then
> call this fn.

Try posting the above suggestion to lkml and see what response you get, or
perhaps read this epic thread:

http://marc.theaimsgroup.com/?t=104587116200002&r=1&w=2

Spin locks should do what makes most sense - if a lock is rarely used and
almost never contended, it makes little sense to go for lower level
locking granularity. If the cost of holding a lock is cheaper than
releasing and reaquiring it, granularity should not be increased, nor
should a new lock be used.

In scsi_get_command there is currently no contention for dev->list_lock
for SCSI block IO, since we already hold the dev->sdev_lock, so it makes
no sense to have a separate lock. This is our main line code path.

The main user of scsi_put_command for block IO is scsi_end_request, today
it gets and releases sdev_lock, and then gets the list_lock. With the
patch, it gets only the sdev_lock. Again, one less lock for each IO
request.

> While the current AND BETTER code preserved the above rule.  It is
> nice, succinct and straight to the point.  Let's leave it like this,
> please.

> There is *no reason* to span boundaries for IRQ locks for such
> a simple and straightforward thing as the cmnd allocator.
> Unless of course...

Again - the current code when called from scsi_prep_fn holds a lock across
the call, the patch improves calls from scsi_prep_fn by removing the use
of the sdev->list_lock. Not only do we execute less code, but we hold
sdev_lock for a shorter time.

> > +struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int gfp_mask)
> > +{
> > +	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev->host, gfp_mask);
> >  
> > +	scsi_init_cmd(dev, cmd);
> >  	return cmd;
> >  }				
> 
> What is the advantage here?  What if scsi_alloc_cmd() fails?
> Then scsi_init_cmd() oopses because you removed the checks...

On failure it returns NULL since scsi_init_cmd checks for cmd ==
NULL. scsi_init_cmd just consolidates common code.

> Please lay off of this code already.
> 
> Plus, you're making the nesting level TOO deep for something
> as trivial as an allocator.

The nesting level is no deeper for calls from scsi_prep_fn than it is
today. Stack usage is minimal.

> > -	spin_unlock_irqrestore(&shost->free_list_lock, flags);
> > +	spin_unlock(&shost->free_list_lock);
> >  
> >  	if (likely(cmd != NULL))
> >  		kmem_cache_free(shost->cmd_pool->slab, cmd);
> >  }
> 
> You see, here you're assuming that the sdev_lock is held
> with IRQ... just like you're assuming in your code
> that the request queue lock is the same as the sdev lock...

It assumes the lock is held with irq, as that is exactly what is happening.

If we want to keep locking minimal, and not have an extraneous unlock/lock
in the scsi_request_fn, we have to code knowing that queue_lock is the
same as sdev_lock. This is our current model, I am not advocating that it
change given the current blk request function interface where we are
called with a lock held.

-- Patrick Mansfield
