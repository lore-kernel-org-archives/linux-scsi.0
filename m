From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/7] Fix various bugs in the target code
Date: Mon, 10 Aug 2009 15:05:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101410580.3903-100000@iolanthe.rowland.org>
References: <1249919600.4089.111.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51274 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750878AbZHJTFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 15:05:07 -0400
In-Reply-To: <1249919600.4089.111.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Obviously this patch needs to be revised.  I'll redo it, taking your 
comments into account.


On Mon, 10 Aug 2009, James Bottomley wrote:

> On Mon, 2009-08-10 at 11:08 -0400, Alan Stern wrote:
> > This patch (as1276) fixes some bugs in the SCSI target code:
> > 
> > 	In scsi_alloc_target(), a newly-created target was added to
> > 	the host's list of targets before the host's target_alloc()
> > 	method was called.
> 
> So this one is the design way the target code works:  allocate and add
> first so the transport and target code have a fully usable device.

Sorry, I don't understand.  In what way is the target not fully usable 
before it is added to the host's list of targets?

I have carried out a search through the entire kernel source for
occurrences of "__targets".  The only places it occurs are in
__scsi_find_target() and scsi_alloc_target() (plus the initialization
in scsi_host_alloc() and the declaration in include/scsi/scsi_hosts.h).  
Doesn't this prove that a target is no less usable before it is added
to the list than afterward?

However, if you still this part of the patch should be removed then I
will do so, since this whole region of code is supposed to be
serialized by the host's scan_mutex.


> > 	In the same routine, if a match was found with an old target
> > 	in the DEL state then that target's reap_ref was mistakenly
> > 	incremented.  This is harmless, but it shouldn't happen.
> 
> It's required for the state != DEL case ... the reap_ref loses
> significance after the state moves to DEL, so it's by design.

Okay, it's harmless, so I'll remove this part of the patch.


> > 	If we have to wait for an old target to disappear, instead of
> > 	calling flush_scheduled_work() the patch calls
> > 	schedule_timeout_uninterruptible(1).  After all, whatever is
> > 	pinning the old target might not have anything to do with a
> > 	workqueue.  Besides, flush_scheduled_work() is prone to
> > 	deadlocks and should never be used by drivers.
> 
> I don't really buy this; it's not (yet) a documented restriction of
> flush_scheduled_work() and we have a few drivers using it.  It only
> deadlocks if you call it from a running workqueue.

Or if you call it while holding a mutex or semaphore that's needed by
one of the items on the workqueue.  Since the keventd workqueue is
likely to contain just about _anything_, you can have no idea what
mutexes the work items will require.

Since scsi_alloc_target() is called while the host's scan_mutex is
held, it cannot safely call flush_scheduled_work().

(For that matter, how do you know that scsi_alloc_target() won't be 
called from within a workqueue routine?)

Besides, what if there is nothing on the workqueue to flush?  You still
want to delay or give up the CPU briefly, so that the old target can be
deallocated.  Doesn't this mean schedule_timeout_uninterruptible(1) is
more appropriate than flush_scheduled_work() in any case?



> > 	scsi_target_reap() changed starget->state outside the
> > 	protection of the host lock.
> 
> So does everything else that manipulates the target state.

Hmm, that's true.  Didn't you mention in an earlier email that the
target state should be changed only under the protection of the host
lock?

Regardless, the important part is where "empty" gets set, and that's
already protected by the host lock.  So I'll remove this from the
patch.


> > 	__scsi_add_device() called scsi_alloc_target() outside the
> > 	protection of the host's scan_mutex, meaning that it might
> > 	find an incompletely-initialized target or it might create
> > 	a duplicate target.
> 
> scan mutex isn't used as a determinant for this.  There can be a slight
> race in initialisation, but really, it isn't important.

I'm surprised you say that.  It means you can end up trying to use a
target before the transport code has finished setting it up (if two
threads both try to register devices below the same target at the same
time).  Besides, a major part of the purpose of the scan_mutex is to
prevent the creation of new targets or devices after the host has left
the SHOST_RUNNING state.  So it definitely should cover all calls to
scsi_alloc_target().

Conversely, if as you say, this isn't important, then you shouldn't
have any real objection to moving this call into the mutex-protected
region.  So either way, there's no reason not to accept this part of 
the patch.


> > 	scsi_sysfs_add_sdev() would call transport_configure_device()
> > 	for a target each time a new device was added under that
> > 	target.  The call has been moved to scsi_target_add(), where
> > 	it will be made only once.
> 
> That, unfortunately is an SPI required feature ... we can't actually
> configure the target until we have a device because of the way SPI
> parameters work.

Okay, I'll put it back and add an explanatory comment.  After all these 
revisions the patch will be a lot shorter.  :-)

Sound good?

Alan Stern

