From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 22 Jun 2005 09:36:07 -0400
Message-ID: <42B96947.4040208@adaptec.com>
References: <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6873 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261283AbVFVNgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 09:36:17 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 06/21/05 16:33, Alan Stern wrote:
> On Tue, 21 Jun 2005, Christoph Hellwig wrote:
> 
> 
>>On Tue, Jun 21, 2005 at 04:04:06PM -0400, Alan Stern wrote:
>>
>>>This objection runs up against an issue we discussed some time ago.  
>>>Should the intended meaning of scsi_remove_host be simply that the kernel
>>>needs to stop using the HBA reasonably soon?  In that case you are right.  
>>>Or should the intended meaning be that the HBA is actually gone
>>>(hot-unplugged) and all further attempts to use it will fail?  In that

For the success of the state machine, states must be discrete.
scsi_remove_host() cannot mean "reasonably soon".  If it _has_ to mean
that, then _add_ another state.

If one wants to consolidate the hot-unplugging with notified unplug,
one might as well aim for the supercase "hot-unplug".  Its implementation
would surely satisfy notified unplug.

>>>case it doesn't matter.  The best ways to resolve this issue may be to
>>>have a separate scsi_host_gone routine or to add an extra argument to
>>>scsi_remove_host.
>>
>>It must mean both because we don't know whether a hot unplug happened or
>>not.  The ->remove callbacks don't tell us.
> 
> 
> I would describe it differently: Since you don't know whether a hot-unplug 
> occurred, you might as well assume it did not.  There's no harm in this, 
> because if the HBA really was unplugged then it doesn't matter what you 
> do; everything will fail.

Conclusion is right, premise is not.  Assume that there was hot-unplug.
It is the supercase which absolves notified unplug.

(Hot unplug of targets is a bit different in that both the hw and the
LLDD knows of the event and some things need not be waited to time out...)

> But those sd flush-cache commands are a problem.  Presumably you want to 
> send them _after_ all the outstanding commands have finished or been 
> cancelled.  What's the right way to allow those commands while rejecting 
> all others?

I don't know.  But to be honest, I'd imagine sending flush-cache as soon
as possible without waiting for anything to cancel or timeout or return.
That is, you want to have the best chance.

The lower layers should make sure that if the device is gone, that is
they _know_ about the event, an error is returned.

So that the treatment of flush-cache is no different than already queued
commands.

So in effect, you (usb-storage) know about a condition (say device is gone)
you should act on it right in queuecommand() and not accept the command,
as opposed to hoping for the midlayer to turn around and preempt those commands.

	Luben
P.S. USB is perfect, since you're notified on unplug.


