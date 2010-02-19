From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] SCSI: fix target allocation outside of scan_mutex
Date: Fri, 19 Feb 2010 15:21:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002191453560.1506-100000@iolanthe.rowland.org>
References: <1266597295.2822.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46956 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751775Ab0BSUVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 15:21:12 -0500
In-Reply-To: <1266597295.2822.50.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 19 Feb 2010, James Bottomley wrote:

> On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> > This patch (as1337) fixes a bug in __scsi_add_device().  It calls
> > scsi_alloc_target() outside the protection of the host's scan_mutex,
> > meaning that it might find an incompletely-initialized target or it
> > might create a duplicate target.
> 
> I don't think this is correct.  scsi_alloc_target should be completely
> atomic on the host lock, if you look.  It allocates the proposed target,
> takes the lock and searches the host target list ... if it finds
> something it drops the lock, destroys the proposed target allocations
> and returns what it found.  If it finds nothing, it adds the proposed
> target to the list drops the lock and returns it.  There's some
> complexity around finding dying targets, but nothing that I think needs
> to be mediated by the scan mutex.

You're right that a duplicate target wouldn't get created.  Still,
there really is a bug.  Suppose two different threads call
scsi_alloc_target() for the same target ID at about the same time.  The
first thread won't find an existing target on the list, so it will
allocate and initialize a new target structure.  However, it releases
the host lock before calling the host template's target_alloc method.

Meanwhile, the second thread will find the new target structure on the 
list and will therefore feel free to start using it.  If the timing 
works out, it could start using the new target before the first thread 
calls target_alloc.

Perhaps you would say a better solution to this race is to move the
target_alloc call into the spinlocked region.  Fine.  But there would
still be a problem.  The whole purpose of the scan_mutex is to prevent
threads from adding new devices below a host that's in the process of
removal.  Since __scsi_add_device() doesn't use the scan_mutex, there's
nothing to prevent it from doing exactly that.

In fact, there's yet another race.  This is between scsi_alloc_target()
and scsi_target_reap().  Because scsi_alloc_target() doesn't check
whether reap_ref is 0 before incrementing it, we could have something
like this:

	Thread 0			Thread 1
	--------			--------
	call scsi_target_reap()
	lock host_lock
	--starget->reap_ref goes to 0
	unlock host_lock
					call scsi_target_alloc()
					lock host_lock
					find found_target = starget
					found_target->reap_ref++
					unlock host_lock
					found_target->state != STARGET_DEL,
						so begin using it
	starget->state = STARGET_DEL
	remove starget

To prevent this while relying only on the host lock,
scsi_alloc_target() should check the value of reap_ref before
incrementing it.  It also wouldn't hurt to make scsi_alloc_target()  
check the target state and scsi_target_reap() set the state all under 
the protection of the host lock.

Alan Stern

