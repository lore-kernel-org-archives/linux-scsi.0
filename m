From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 22 Jun 2005 11:12:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506221052170.6128-100000@iolanthe.rowland.org>
References: <42B96947.4040208@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:15810 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261533AbVFVPMI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 11:12:08 -0400
In-Reply-To: <42B96947.4040208@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 22 Jun 2005, Luben Tuikov wrote:

> For the success of the state machine, states must be discrete.
> scsi_remove_host() cannot mean "reasonably soon".  If it _has_ to mean
> that, then _add_ another state.
> 
> If one wants to consolidate the hot-unplugging with notified unplug,
> one might as well aim for the supercase "hot-unplug".  Its implementation
> would surely satisfy notified unplug.

Certainly.  In the UNPLUG_NOTIFY state, only commands like SYNCHRONIZE 
CACHE should be allowed.

> The lower layers should make sure that if the device is gone, that is
> they _know_ about the event, an error is returned.
> 
> So that the treatment of flush-cache is no different than already queued
> commands.

For the unplug case you are right.  For the notify case it's a little 
tricky because of the interaction with command cancellation (if commands 
need to be cancelled) and the need to allow the cache flush without 
allowing other commands.

> So in effect, you (usb-storage) know about a condition (say device is gone)
> you should act on it right in queuecommand() and not accept the command,
> as opposed to hoping for the midlayer to turn around and preempt those commands.
> 
> 	Luben
> P.S. USB is perfect, since you're notified on unplug.

Yes.  But in fact usb-storage has a small loophole.  Before calling
scsi_remove_host, we set a flag that causes the queuecommand routine to
reject all new commands and any currently-executing command to fail-fast.  
However there is a small window between the time a command is accepted and
the time it starts to execute (because execution takes place in a
separate kernel thread).  If a command has been accepted and has not
started to execute, then usb-storage doesn't cancel it.  We've been
relying on the midlayer to cancel it for us.

There's no reason usb-storage can't cancel the command before calling
scsi_remove_host.  I tried out a patch to do just that, and it worked
fine.  (Waiting until after scsi_remove_host to cancel the command doesn't
work, for the obvious reason that the midlayer may have already cancelled
it.)  I'll submit the patch; it should solve this particular problem for
usb-storage.  I don't know how any other hot-unpluggable LLDDs will handle
cancellation during unplug.

Alan Stern

