From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock (take 2)
Date: Fri, 09 May 2003 13:46:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBBE962.8090203@rogers.com>
References: <20030506175918.A22717@beaverton.ibm.com> <3EBA915C.5020505@rogers.com> <20030508164049.A26710@beaverton.ibm.com> <3EBB1C3D.1090203@rogers.com> <20030508215924.A28525@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:33038
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263358AbTEIRdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 13:33:44 -0400
In-Reply-To: <20030508215924.A28525@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Patrick Mansfield wrote:
> 
> IMO I'm reducing the special case: use one lock to protect all of the
> scsi_device data.

I'm not sure how well this will play in the future.
With refcounts is there a need to lock *all* of the scsi_device
struct?  In this regard I think that the sdev lock is too general.

> Yes, but if we are already holding the lock and already blocking IRQ's
> getting another lock increases the hold time and the time IRQ's are
> blocked.

Yes, locally.  But if this approach makes you break the
infrastructure which you're striving to get, another lock
would make sense from design point of view.

Then also remember that spinlocks are supposed to be held for
the minimum amount of time -- so I'd rather see another
spinlock _and_ a better infrastructure design, rather than
one lock and a messy code structure.

> If we had a request function that took one req, and was called with no
> lock held the above would be fine (similiar in that we should not hold
> host_lock when we call the LLDD queuecommand in scsi_dispatch_cmd). I
> think it is best for now to match the current interface (infrastructure)
> and have only one lock so we do not release and acquire another lock in
> scsi_request_fn.
> 
> But, it would be interesting to further split the lock and see what happens.

I just think that it's not that great an idea to share
locks across subsystems.  Just as long as we stick to the rule
of holding _a_ sdev_lock for the smallest amount of time elsewhere
in SCSI Core, then obtaining it in scsi_request_fn while the
request_q lock (separate) is being held is not that big of a deal.

I.e. let the request_q lock lock the request_q, and sdev_lock
(possibly to be broken up) lock the device struct members
(or whatever is left/needed).  But I'd much rather see the use
of atomics (where possible) and bit ops.

> Not sure what you mean in the above - IMO we should use it to protect
> scsi_device data (not including sdev->siblings). If this is to general and
> we see contention, then it can be modified.

I'm thinking of properly setting up struct scsi_target { ... }, this will
eliminate sdev->siblings and will properly reflect SAM-3.

Furthermore, SANs will notify the LLDD when a device (target) appears
on the fabric, and then it's up to SCSI Core to obtain the devices (LUs)
of the target, via REPORT LUNS.

Is this worth it? (at this point)
 
> There are scsi_device fields (set in scsi_scan.c) that are invariant after
> scanning that don't need to be locked - like single_lun, borken, etc.
> online is not one of them.

... the more reason to un-generalize sdev_lock, use atomics (where possible)
and bit ops.

-- 
Luben



