From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 22 Jun 2005 11:46:33 -0400
Message-ID: <42B987D9.3060201@adaptec.com>
References: <Pine.LNX.4.44L0.0506221052170.6128-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:1938 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261557AbVFVPqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 11:46:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506221052170.6128-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 06/22/05 11:12, Alan Stern wrote:
> 
> For the unplug case you are right.  For the notify case it's a little 
> tricky because of the interaction with command cancellation (if commands 
> need to be cancelled) and the need to allow the cache flush without 
> allowing other commands.

The notify event can "travel" right behind flush-cache and "close doors"
behind.  (since it travels from the application client to the device)

> Yes.  But in fact usb-storage has a small loophole.  Before calling
> scsi_remove_host, we set a flag that causes the queuecommand routine to
> reject all new commands and any currently-executing command to fail-fast.  
> However there is a small window between the time a command is accepted and
> the time it starts to execute (because execution takes place in a
> separate kernel thread).  If a command has been accepted and has not
> started to execute, then usb-storage doesn't cancel it.  We've been
> relying on the midlayer to cancel it for us.

Sounds like a race to me.  You should always be able to
identify/find a command at any point after it has been submitted
by queuecommand().

> There's no reason usb-storage can't cancel the command before calling
> scsi_remove_host.  I tried out a patch to do just that, and it worked
> fine.  (Waiting until after scsi_remove_host to cancel the command doesn't
> work, for the obvious reason that the midlayer may have already cancelled
> it.)  I'll submit the patch; it should solve this particular problem for

Yes indeed: the proper order is:
	* lock the front door,
	* empty all rooms,
	* call scsi_remove_host().

This is on _hot-unplug_ since the event came from the SDS.
In the event of a notified unplug, the event would be known to
SCSI Core _before_ it is known to the LLDD, so SCSI Core would
lock the "fence gate", send flush-cache (which would seem as any
other command to you), then wait for that to return (which would
mean no other commands are pending, since this was the last command
to be sent after locking the "fence gate") and then it would
call scsi_remove_host() or whatever appropriate.

> usb-storage.  I don't know how any other hot-unpluggable LLDDs will handle
> cancellation during unplug.

In case the LLDD is implemented properly, just doing nothing should suffice. ;-)

	Luben


