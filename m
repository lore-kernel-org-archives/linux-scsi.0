From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2/4] scsi: add transport host byte errors
Date: Thu, 15 Mar 2007 12:33:01 -0400
Message-ID: <45F9753D.5040900@emulex.com>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu> <45F9482B.4050100@emulex.com> <45F95DA8.6070108@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59816 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030459AbXCOQdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2007 12:33:14 -0400
In-Reply-To: <45F95DA8.6070108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org


So my position changes a little now that you pointed out that you
release the request queue when fastfail kicks in.

Mike Christie wrote:
> Do we want to fail IO that was sitting in the queue _and_ all new
> incoming IO or just what was sitting in the queue?

I believe all i/o - so that the upper layer sees everything occurring
on each state change and can choose accordingly.

> 
> The patches I sent, unplug the queues when failfast timer expires so
> that is where the chk ready test for failfast comes in. When failfast
> fires, the queue will be unplugged and we will hit the failfast test and
> anything coming through will be failed.
> 
> Alternatively:
> 
> 1. What about making the transport check ready test standard and adding
> a transportt->check_ready callout which gets called before
> scsi_dispatch_cmd calls the queuecommand?

I like the idea, as I hated having to add this snippet to each driver.
The other place we had to use it was in slave_alloc(), so doing the same
thing there would be great.

> 2. Another option could be do add some code which does it a layer higher
> at the scsi device level. The function would set the scsi_device state
> to some value that would indicate the device is not ready and wants to
> fail IO, then it would unplug the queue. The scsi_prep_fn would then
> check for that state and fail IO. Or we could just set the state to an
> existing value like offline and we would not have to modify and existing
> state checks.
 >
 > 3. Or we could go one layer higher than that and add and set some block
 > layer bits. Unblock the queue and before the scsi_prep_fn is called the
 > block layer would check the state bit and fail IO.
 >

Yep, and likely a better decision long term (though more work) as it's
storage transport agnostic. The "other layer" guys can answer better on
this one. I would think we still have to keep the chkready()s as there will
always be race conditions.

> 4. Those would work if we want to fail IO that was queued and new
> incoming IO. If we want to just fail IO that was queued, and queue IO
> new incoming IO, then the block layer could offer a function which grabs
> the queue lock, dequeued what was there and then fail each IO. scsi-ml
> would then call that function as a helper. SCSI-ml again would not see
> the IO here.

True - but this is a new and different abort routine from the one today
that expects to kick in on timeout. We purposely stopped the eh handler
from aborting a command while you had connectivity lost. So, it would be
a bad idea to go down this path.

-- james s
