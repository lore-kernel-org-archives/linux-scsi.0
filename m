From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock (take 2)
Date: Thu, 8 May 2003 21:59:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508215924.A28525@beaverton.ibm.com>
References: <20030506175918.A22717@beaverton.ibm.com> <3EBA915C.5020505@rogers.com> <20030508164049.A26710@beaverton.ibm.com> <3EBB1C3D.1090203@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:6651 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262294AbTEIEu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 00:50:59 -0400
Content-Disposition: inline
In-Reply-To: <3EBB1C3D.1090203@rogers.com>; from tluben@rogers.com on Thu, May 08, 2003 at 11:10:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, May 08, 2003 at 11:10:53PM -0400, Luben Tuikov wrote:

> I'd much rather see locks just lock access to objects, rather
> than code.

I totally agree with that approach - lock the data not code.

> No.  Your patch changed the allocation code.  Removed some
> checks, renamed a function or two, etc.

I mean the underlying code - we use the cache alloc, and if that fails,
we try to use the per host spare.

> The thing is, if you've got too many special cases, you get spaghetti
> code, unmaintanable and cumbersome.

IMO I'm reducing the special case: use one lock to protect all of the
scsi_device data.

> > Spin locks should do what makes most sense - if a lock is rarely used and
> 
> No!
> 
> A principle should be applied when using spinlocks!  Else you get
> deadlocks or unmaintanable code.  The dinosoaur book explains
> this nicely (it was my OS course book in university).
> 
> > almost never contended, it makes little sense to go for lower level
> > locking granularity.
> 
> Think IRQ.

Yes, but if we are already holding the lock and already blocking IRQ's
getting another lock increases the hold time and the time IRQ's are
blocked.

> I think that one cannot _pretend_ that the request_q lock is NOT
> the sdev_lock and code as if they are different.  It just doesn't work.

Yes.

> I think that the questions are: what _object_ is lock X protecting?
> and: will just one lock do? (for the infrastrucure which one wants
> to design, or which infrastructure the problem warrants).
> 
> Maybe sdev_lock is too general?  Maybe a separate lock for
> the request_q will improve the infrastructure? (see bottom of message)

> How about separate request_q lock and sdev_lock?
> 
> This way SCSI Core will not have to be aware of the request_q lock,
> unless it calls the block routines.
> 
> This also makes the block implementation and its injection fn,
> scsi_request_fn, modular, so that if the block impementation
> changes, we get minimal hit on SCSI Core's implementation.
> 
> This also will make it possible for SCSI Core to obtain the 
> sdev_lock separately from the request_q lock, say for other
> purposes.

If we had a request function that took one req, and was called with no
lock held the above would be fine (similiar in that we should not hold
host_lock when we call the LLDD queuecommand in scsi_dispatch_cmd). I
think it is best for now to match the current interface (infrastructure)
and have only one lock so we do not release and acquire another lock in
scsi_request_fn.

But, it would be interesting to further split the lock and see what happens.

> I also think that sdev_lock is too general... it's used in
> few places (only 1 functional) and I can see that hch has
> slated that usage for improvement.

Not sure what you mean in the above - IMO we should use it to protect
scsi_device data (not including sdev->siblings). If this is to general and
we see contention, then it can be modified.

There are scsi_device fields (set in scsi_scan.c) that are invariant after
scanning that don't need to be locked - like single_lun, borken, etc.
online is not one of them.

-- Patrick Mansfield
