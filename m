From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suggestion for aiding debugging of host removal
Date: Thu, 11 Dec 2003 10:14:51 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312111012510.1227-100000@ida.rowland.org>
References: <20031211074827.GA3076@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3588 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265113AbTLKPOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 10:14:55 -0500
In-Reply-To: <20031211074827.GA3076@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 10 Dec 2003, Mike Anderson wrote:

> > > Would it help flush out such illegal accesses if at some appropriate point 
> > > shost->hostt was set to NULL, maybe near the end of scsi_remove_host()?
> 
> If we wanted to set this to something to catch illegal access it might
> be good to set hostt to a fake hostt that did a WARN_ON so that it would
> not take the system down.
> 
> > 
> > In fact that's a bug in the current scsi_host lifetime handling - before
> > the driver can leave it's upper layer ->remove function we need to wait
> > to the host refcount to become zero, similar to what free_netdev does.
> > 
> > I'll see whether I can come up with a fix.
> 
> Unless I missing something I do not see any interlock / wait in free_netdev
> (in looking at test11).
> 
> Currently the host refcount will not go to zero until the scsi_host_put
> is made from the LLDD post the return of the scsi_remove_host call.
> While it is valid to sleep in the remove call and we could reorder the
> scsi_host_put, I thought the previous goal was to not have an unbounded
> time in scsi_remove_host. I thought we where trying to allow the host to
> cleanup fast and if user space wanted to take time we would allow that
> to happen, but just not send any commands to the LLDD.

Remember that it's not enough to avoid sending any commands to the LLDD.  
You must avoid accessing the host template at all, since it may no longer 
be present in memory.  Putting in a fake entry would be a good way to 
insure that never happens.

Alan Stern

