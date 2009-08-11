From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/7 ver 2] Fix various bugs in the target code
Date: Tue, 11 Aug 2009 12:57:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111154580.2562-100000@iolanthe.rowland.org>
References: <1250005716.4301.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52782 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754943AbZHKQ5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 12:57:42 -0400
In-Reply-To: <1250005716.4301.39.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 11 Aug 2009, James Bottomley wrote:

> On Tue, 2009-08-11 at 11:32 -0400, Alan Stern wrote:
> > This patch (as1276b) fixes two bugs in the SCSI target code and
> > explains an obscure requirement:
> > 
> > 	If we have to wait for an old target to disappear, instead of
> > 	calling flush_scheduled_work() the patch calls
> > 	schedule_timeout_uninterruptible(1).  After all, whatever is
> > 	pinning the old target might not have anything to do with a
> > 	workqueue.  Besides, flush_scheduled_work() is prone to
> > 	deadlocks and should never be used by drivers.
> 
> No for reasons already stated.

I disagreed with those reasons and posted an argument to demonstrate
why they were incorrect.  You haven't responded to that argument.

Would it be better if flush_scheduled_work() was replaced by schedule() 
rather than by schedule_timeout_uninterruptible(1)?

Bear in mind that originally this delay was needed so that target
removal could progress from scsi_target_reap(), where the state is
changed to STARGET_DEL, to scsi_target_reap_usercontext(), where the
target is removed from the host's list.  But patch 1/7 merged those two
routines, so there's no longer any point in waiting for the workqueue
to flush.


> > 	__scsi_add_device() called scsi_alloc_target() outside the
> > 	protection of the host's scan_mutex, meaning that it might
> > 	find an incompletely-initialized target or it might create
> > 	a duplicate target.
> 
> It's not a bug .. it works.

That's often the case with races.  They don't seem like bugs and they 
work -- until you hit the timing just right and they fail.

>  I'd actually like to kill the scan mutex
> because it seems to be the source of quite a few async problems.

I haven't seen any reports of such problems recently.  When they did 
occur, they were caused by incorrect integration of Arjan's async work, 
which has since been repaired.

>  I
> certainly don't want to extend its tentacles into target allocation.

Its tentacles are _already_ extended into target allocation.  Look at 
scsi_scan_target() and scsi_get_host_dev() and you'll see.

Besides, the scan mutex was added for good reasons.  It protects 
against:

	two threads trying simultaneously to probe and add the same 
	device;

	a thread trying to add a target or device after the host has
	left the SHOST_RUNNING state;

	a thread trying to use or remove a target or device before 
	the thread adding it has fully initialized it;

and probably other things I can't think of at the moment.  How do you 
propose to prevent all these things from happening without using a 
mutex?


> > 	In scsi_sysfs_add_sdev(), the call to
> > 	transport_configure_device() for the target appears wrong,
> > 	since it will be called each time a device is added to the
> > 	target.  But this is unavoidable for SPI, so a comment is
> > 	added to explain the situation.
> 
> There's no rule requiring configure to be called once, so no explanation
> is really necessary.  I also suspect the SPI case isn't unique.

That's true, but people commonly expect that things need to be
configured only once (i.e., that configuring is idempotent).  By the
same token, there's no rule requiring subroutines to do something
useful, but people expect it anyway.

The current code violates the principle of least surprise.  IMO that 
warrants a comment.  If you'd like to change the comment so that it 
doesn't refer specifically to SPI, please feel free.

Alan Stern

