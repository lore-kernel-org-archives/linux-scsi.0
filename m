From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 23:49:39 +0200
Message-ID: <42F7D373.90007@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25491 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932277AbVHHVuB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 17:50:01 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>

Alan Stern wrote:
> On Mon, 8 Aug 2005, Stefan Richter wrote:
>>Why should the LLD care if the core might want to access it after the
>>LLD made the prescribed API calls for host removal? It is the core's
>>responsibility that it never enters the host again after these API
>>calls were invoked.
> 
> Here you are wrong.  In fact the core makes no such guarantees.  It _will_
> try to enter the host (for things like telling disk drives to flush
> their caches) for as long as it retains a reference to the host structure.

Sure. But after all high-level drivers were detached (and that should
have happend right before scsi_remove_host returns) I don't see why
the host's ref count might not be down to zero.

[...]
> My USB mass-storage test device doesn't respond to TEST UNIT READY, so it
> causes a timeout and kicks the error handler into action.  This happens 
> during device scanning, just prior to reading the partition table.  The 
> error handler goes through various stages of processing, leading up to a 
> bus reset.  I disconnected the USB device just before the bus reset 
> routine was called.
> 
> Now, usb-storage implements a "SCSI bus reset" by actually performing a
> USB port reset.  The USB subsystem requires the caller to acquire a
> device-specific semaphore before doing a port reset, and the subsystem
> itself acquires this same semaphore when notifying drivers about a
> disconnection.  (The idea is that we don't want drivers trying to handle
> a disconnect and a reset on the same device at the same time.)
> 
> So here's how things end up.
> 
> 	The scanning thread owns shost->scan_mutex and is waiting
> 	for the error handler to finish.
> 
> 	The EH thread is executing usb-storage's bus_reset routine
> 	and is waiting to acquire the device semaphore.
> 
> 	USB's khubd thread owns the device semaphore and has invoked
> 	the usb-storage disconnect routine.  Among other things, this
> 	routine calls scsi_remove_host, which tries to acquire the
> 	scan_mutex.
> 
> How should this deadlock be resolved?  The current code has an extremely 
> inelegant solution, and I would like to find a better one.  Any ideas?

Can't the eh_*_reset_handler use down_*_trylock? If the semaphore was
already down, there should be a means for the reset handler to figure
out the reason so that it can back out in an appropriate way. I hope
there is a limited set of reasons...
-- 
Stefan Richter
-=====-=-=-= =--- -=---
http://arcgraph.de/sr/
