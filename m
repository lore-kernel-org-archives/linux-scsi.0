From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock (take 2)
Date: Thu, 08 May 2003 23:10:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBB1C3D.1090203@rogers.com>
References: <20030506175918.A22717@beaverton.ibm.com> <3EBA915C.5020505@rogers.com> <20030508164049.A26710@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:13125
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262279AbTEIC6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 22:58:21 -0400
In-Reply-To: <20030508164049.A26710@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Patrick Mansfield wrote:
> 
> The main intent of the patch is for the main line scsi code path (via
> scsi_prep_fn and scsi_end_request) to use only one lock where we use two
> locks today.

I got this -- I just don't know how doable it is.
I'd much rather see locks just lock access to objects, rather
than code.

> There is no change in the allocation algorithm (unlike the
> _separate_ patch to have a spare or more appropriately named cached cmd
> per device, but I can repost the latest incarnation if anyone really wants
> to see it).

No.  Your patch changed the allocation code.  Removed some
checks, renamed a function or two, etc.

>>>+/*
>>>+ * Function:	__scsi_get_command()
>>>+ *
>>>+ * Purpose:	Allocate and setup a scsi command block. This function is
>>>+ * 		extern but not exported outside of scsi.
>>>+ *
>>>+ * Arguments:	dev	- parent scsi device
>>>+ *		gfp_mask- allocator flags
>>>+ *
>>>+ * Locks:	Called with sdev_lock held.
>>
>>I don't like this in principle.
>>
>>Spinlocks, especially IRQ ones, are supposed to take the absolute
>>possible minimum amount of code-area.  And here you're grabbing the
>>lock elsewhere (in your new version of scsi_get_cmnd()) and then
>>call this fn.
> 
> 
> Try posting the above suggestion to lkml and see what response you get, or
> perhaps read this epic thread:
> 
> http://marc.theaimsgroup.com/?t=104587116200002&r=1&w=2

See the word ``principle'' up there, which I used.

The thing is that principles can be _proven_ formally, and special
cases are just that, special cases, out of the norm.

The thing is, if you've got too many special cases, you get spaghetti
code, unmaintanable and cumbersome.

> Spin locks should do what makes most sense - if a lock is rarely used and

No!

A principle should be applied when using spinlocks!  Else you get
deadlocks or unmaintanable code.  The dinosoaur book explains
this nicely (it was my OS course book in university).

> almost never contended, it makes little sense to go for lower level
> locking granularity.

Think IRQ.

> If the cost of holding a lock is cheaper than
> releasing and reaquiring it, granularity should not be increased, nor
> should a new lock be used.

The longer you hold the lock, the more the contention for it;
the less you hold the lock, the more cost for reaquiring it if
need be -- so there's a trade off.

> In scsi_get_command there is currently no contention for dev->list_lock
> for SCSI block IO, since we already hold the dev->sdev_lock, so it makes
> no sense to have a separate lock. This is our main line code path.

Yes, I understand this, and I would like to say that I have absolutely
no opinion on this infrastructure.  I'm not quite fond of it...

Yes, I understand the point of the request queue lock + sdev lock +
the fact that you want to integrate this with the allocator so to
use one lock, etc, etc, etc, but I draw blank -- we'll just wait
and see what perspires -- I hope something elegant eventually.

I think that one cannot _pretend_ that the request_q lock is NOT
the sdev_lock and code as if they are different.  It just doesn't work.

A decision will have to be made if they are to be different, or not ever.
I think this will consolidate things a lot.

I think that the questions are: what _object_ is lock X protecting?
and: will just one lock do? (for the infrastrucure which one wants
to design, or which infrastructure the problem warrants).

Maybe sdev_lock is too general?  Maybe a separate lock for
the request_q will improve the infrastructure? (see bottom of message)

> The main user of scsi_put_command for block IO is scsi_end_request, today
> it gets and releases sdev_lock, and then gets the list_lock. With the
> patch, it gets only the sdev_lock. Again, one less lock for each IO
> request.

Oh, yes, I get that.  This isn't the problem though.

> It assumes the lock is held with irq, as that is exactly what is happening.

Rhetorical: can you always guarantee it?
 
> If we want to keep locking minimal, and not have an extraneous unlock/lock
> in the scsi_request_fn, we have to code knowing that queue_lock is the
> same as sdev_lock.

This is the pickle...

> This is our current model, I am not advocating that it
> change given the current blk request function interface where we are
> called with a lock held.

How about separate request_q lock and sdev_lock?

This way SCSI Core will not have to be aware of the request_q lock,
unless it calls the block routines.

This also makes the block implementation and its injection fn,
scsi_request_fn, modular, so that if the block impementation
changes, we get minimal hit on SCSI Core's implementation.

This also will make it possible for SCSI Core to obtain the 
sdev_lock separately from the request_q lock, say for other
purposes.

I also think that sdev_lock is too general... it's used in
few places (only 1 functional) and I can see that hch has
slated that usage for improvement.

-- 
Luben



