From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 14:04:09 -0400
Message-ID: <42F79E99.9000809@adaptec.com>
References: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48343 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932166AbVHHSEN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 14:04:13 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/07/05 10:59, Alan Stern wrote:
> Mike:
> 
> What sort of synchronization is there between scsi_remove_host and the 
> error-handler thread?  Offhand I can see two possible problems, depending 
> on how the LLD is written:
> 
>      1.	The error handler asks the LLD to perform a reset just as the LLD
> 	calls scsi_remove_host as part of rmmod.  scsi_remove_host 
> 	returns, the LLD's remove method returns, and the LLD is unloaded
> 	from memory while its reset routine is executing.
> 
>      2. The error handler asks the LLD to perform a reset just before the
> 	LLD calls scsi_remove_host.  The LLD's remove method can't return
> 	until the reset completes (otherwise the reset would be executing 
> 	code that is about to be unloaded, as in (1)).  But the reset
> 	can't get started until it acquires the host adapter's device 
> 	semaphore, which is owned by the rmmod thread.
> 
> (1) causes an oops and (2) causes a deadlock.  Note that (1) can be 
> avoided by making scis_remove_host wait until the error handler thread has 
> exited, but that will make (2) much more likely to happen.

Hmm, this doesn't sound good.

I'm thinking, if the LLDD knows that it's being unloaded, then it can
return the EH reset with success de facto.

> In general, there needs to be some way for the error handler to prevent
> the LLD from being unloaded.  I don't know what the best answer is.  Has
> anyone thought about this?

Two ways:
	1) Let one entity be the active one and the other the passive one,
	   always.  That is, let the LLDD send an "event" and then let the
	   Managing layer decide what to do.
	2) Tack a kobject, or kset to each struct you have and set the
	   parent pointer accordingly to how the struct objects relate
	   to each other.  So in effect, the kobj relationship would
	   represent how those objects actually relate to each other
	   in the kernel.  Advantage you get is the automatic kref.

... or something like this. ;-)

	Luben
