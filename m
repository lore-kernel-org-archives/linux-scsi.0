From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] SCSI: fix target allocation outside of scan_mutex
Date: Fri, 12 Mar 2010 15:45:57 -0600
Message-ID: <1268430358.2802.360.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1002191453560.1506-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab0CLXYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 18:24:35 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002191453560.1506-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2010-02-19 at 15:21 -0500, Alan Stern wrote:
> On Fri, 19 Feb 2010, James Bottomley wrote:
> 
> > On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> > > This patch (as1337) fixes a bug in __scsi_add_device().  It calls
> > > scsi_alloc_target() outside the protection of the host's scan_mutex,
> > > meaning that it might find an incompletely-initialized target or it
> > > might create a duplicate target.
> > 
> > I don't think this is correct.  scsi_alloc_target should be completely
> > atomic on the host lock, if you look.  It allocates the proposed target,
> > takes the lock and searches the host target list ... if it finds
> > something it drops the lock, destroys the proposed target allocations
> > and returns what it found.  If it finds nothing, it adds the proposed
> > target to the list drops the lock and returns it.  There's some
> > complexity around finding dying targets, but nothing that I think needs
> > to be mediated by the scan mutex.
> 
> You're right that a duplicate target wouldn't get created.  Still,
> there really is a bug.  Suppose two different threads call
> scsi_alloc_target() for the same target ID at about the same time.  The
> first thread won't find an existing target on the list, so it will
> allocate and initialize a new target structure.  However, it releases
> the host lock before calling the host template's target_alloc method.
> 
> Meanwhile, the second thread will find the new target structure on the 
> list and will therefore feel free to start using it.  If the timing 
> works out, it could start using the new target before the first thread 
> calls target_alloc.

So currently, that can't happen because of the scan mutex.

> Perhaps you would say a better solution to this race is to move the
> target_alloc call into the spinlocked region.  Fine.  But there would
> still be a problem.  The whole purpose of the scan_mutex is to prevent
> threads from adding new devices below a host that's in the process of
> removal.  Since __scsi_add_device() doesn't use the scan_mutex, there's
> nothing to prevent it from doing exactly that.
> 
> In fact, there's yet another race.  This is between scsi_alloc_target()
> and scsi_target_reap().  Because scsi_alloc_target() doesn't check
> whether reap_ref is 0 before incrementing it, we could have something
> like this:
> 
> 	Thread 0			Thread 1
> 	--------			--------
> 	call scsi_target_reap()
> 	lock host_lock
> 	--starget->reap_ref goes to 0
> 	unlock host_lock
> 					call scsi_target_alloc()
> 					lock host_lock
> 					find found_target = starget
> 					found_target->reap_ref++
> 					unlock host_lock
> 					found_target->state != STARGET_DEL,
> 						so begin using it
> 	starget->state = STARGET_DEL
> 	remove starget

Well, not really ... your race depends on us managing to execute the
first five statements in thread 1 before we set starget->state in thread
0 ... given the massive number of operations in thread 1 and the fact
that setting the state is a single op in thread 0, that's not really
feasible.

> To prevent this while relying only on the host lock,
> scsi_alloc_target() should check the value of reap_ref before
> incrementing it.  It also wouldn't hurt to make scsi_alloc_target()  
> check the target state and scsi_target_reap() set the state all under 
> the protection of the host lock.

That would be a complex way of fixing it ... a much simpler one would be
to move the setting of STARGET_DEL in thread 0 under the host lock.

James


