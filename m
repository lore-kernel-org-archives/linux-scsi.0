From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] scsi: add transport host byte errors
Date: Thu, 15 Mar 2007 09:52:24 -0500
Message-ID: <45F95DA8.6070108@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu> <45F9482B.4050100@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43584 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293AbXCOOwc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 10:52:32 -0400
In-Reply-To: <45F9482B.4050100@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> michaelc@cs.wisc.edu wrote:
>> fast_io_fail_tmo
>> iscsi: session recovery_tmo
>> fc: rport fast_io_fail_tmo
>>
>> The difference is that when the timer fires, for iscsi we unblock the
>> queue and fail commands in the blocked queue. FC just fails IO running
>> in the driver/fw/hw. The IO in the blocked queue sits there until
>> dev_loss_tmo.
> 
> True - FC contacted the LLDD to terminate i/o, who has no notion of any io
> that has yet to be sent to it via queuecommand(). Blocked i/o sits until
> dev_loss_tmo, as that is when the sdev gets torn down. Perhaps a block
> layer call
> should be created, that the FC transport can call, to terminate the blocked
> queue.  Thoughts ?

Do we want to fail IO that was sitting in the queue _and_ all new
incoming IO or just what was sitting in the queue?

The patches I sent, unplug the queues when failfast timer expires so
that is where the chk ready test for failfast comes in. When failfast
fires, the queue will be unplugged and we will hit the failfast test and
anything coming through will be failed.

Alternatively:

1. What about making the transport check ready test standard and adding
a transportt->check_ready callout which gets called before
scsi_dispatch_cmd calls the queuecommand?

2. Another option could be do add some code which does it a layer higher
at the scsi device level. The function would set the scsi_device state
to some value that would indicate the device is not ready and wants to
fail IO, then it would unplug the queue. The scsi_prep_fn would then
check for that state and fail IO. Or we could just set the state to an
existing value like offline and we would not have to modify and existing
state checks.

3. Or we could go one layer higher than that and add and set some block
layer bits. Unblock the queue and before the scsi_prep_fn is called the
block layer would check the state bit and fail IO.

4. Those would work if we want to fail IO that was queued and new
incoming IO. If we want to just fail IO that was queued, and queue IO
new incoming IO, then the block layer could offer a function which grabs
the queue lock, dequeued what was there and then fail each IO. scsi-ml
would then call that function as a helper. SCSI-ml again would not see
the IO here.
