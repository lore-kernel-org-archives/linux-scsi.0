From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error
 handling finished
Date: Mon, 24 Jun 2013 15:27:46 -0700
Message-ID: <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>
	 <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>
	 <51C8A668.3060700@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35445 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab3FXW1s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jun 2013 18:27:48 -0400
In-Reply-To: <51C8A668.3060700@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On Mon, 2013-06-24 at 15:04 -0500, Mike Christie wrote:
> On 06/24/2013 02:19 PM, James Bottomley wrote:
> > On Wed, 2013-06-12 at 14:55 +0200, Bart Van Assche wrote:
> >> A SCSI LLD may start cleaning up host resources as soon as
> >> scsi_remove_host() returns. These host resources may be needed by
> >> the LLD in an implementation of one of the eh_* functions. So if
> >> one of the eh_* functions is in progress when scsi_remove_host()
> >> is invoked, wait until the eh_* function has finished. Also, do
> >> not invoke any of the eh_* functions after scsi_remove_host() has
> >> started.
> > 
> > We already have state guards for this, don't we?  That's the
> > SHOST_*_RECOVERY ones.  When eh functions are active, the host
> > transitions to a recovery state, so the wait could just wait on that
> > state rather than implement an open coded counting semaphore.
> > 
> 
> That seems better. For the sg_reset_provider case we just would have to
> also wait on the tmf_in_progress bit.

The simplest way is may just be to move the kthread_stop() from release
to remove.  That synchronously waits for the outstanding error handling
to complete and the eh thread to stop.  Perhaps the eh thread should
also wait for tmf in progress before it dies?

> I think I used all my credits messing up reviewing this patchset.

Hey, you're one of my best reviewers and this doesn't change that.

For a variety of reasons this patch set is incredibly hard to review:
Almost every patch touches pieces in the mid layer where you have to be
sure in minute detail you know what's going on (and what should be going
on), so usually it's a couple of hours with the source code just making
sure you do know this.  Plus it's code where the underlying usage model
has evolved over the years meaning the original guarantees might have
been violated silently somewhere and the ramifications spread out like
tentacles everywhere.  Finally, it's not clear from the change logs why
the changes are actually being made: for instance sentence one of this
change log says "A SCSI LLD may start cleaning up host resources as soon
as scsi_remove_host() returns." which causes my sanity checker to go off
immediately because in a refcounted model, like we use for dev, target
and host, nothing essential is supposed to be freed until the last put
which may or may not happen in the remove function.

> > However, what's the reasoning behind wanting to do this?  In theory all
> > necessary resources for the eh thread should only be freed in the
> > release callback.  That means they aren't freed until all error recovery
> > completes.
> 
> I think it makes it easier to handle cleanup of driver resources
> needed
> for aborts/resets for some drivers. If after host removal, the scsi eh
> can call into the driver after scsi_remove_host is called then we have
> to set some internal bits to fail future eh callback calls and handle
> waiting on or flushing running eh operations. If we know that after
> scsi_host_remove is called the eh callbacks will not be running and
> will
> not be called we can just free the driver resources.
> 
> For iscsi and I think drivers that do scsi_remove_target it would be
> helpful to have something similar at the target level.

I'm wary of this because it combines two models: a definite state model
(where we move from state to state waiting for the completions) with an
event driven one (in theory the current one); such combinations rarely
lead to good things because you get a mixture of actions causing state
transitions some of which are waited for and some of which have an async
transition and that ends up confusing the heck out of everybody no
matter how carefully documented.  Can you give me some use cases of what
you're trying to achieve?  Could it be as simple as an event that fires
on release?

James


