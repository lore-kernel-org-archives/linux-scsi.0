From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Suggestion for aiding debugging of host removal
Date: Wed, 10 Dec 2003 23:48:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031211074827.GA3076@beaverton.ibm.com>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0312100947550.775-100000@ida.rowland.org> <20031210151456.A2927@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:39635 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264240AbTLKHpC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 02:45:02 -0500
Content-Disposition: inline
In-Reply-To: <20031210151456.A2927@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Wed, Dec 10, 2003 at 10:02:22AM -0500, Alan Stern wrote:
> > Mike:
> > 
> > I've got a question about host removal.  Once scsi_remove_host() has
> > returned, the host driver's module is free to unload from memory (assuming
> > the module's reference count is 0, which it normally is).  Hence it is a
> > mistake to access the host template in any way after that time.

Normally it would not be zero on the return from scsi_remove_host. It
would not go to zero until scsi_host_put is called. If the scsi_host_put
is the last ref then prior to the returning of the scsi_host_put
scsi_host_dev_release would have been called. If it is not then there
must of been a open on a device outstanding (which would keep a rmmod
from being called, but would allow hotplug and unexpectged disconnects).
When the device ref count drops this will cause the module count to drop
and allow the module to be removed. We may want to reorder our
scsi_device_put calls to module_put and put_device, but I do not know if
that would prevent any races.

> > 
> > But it looks like scsi_host_dev_release() can be called after
> > scsi_remove_host() has returned, and it uses shost->hostt.  There may be 
> > other uses as well.
> > 
> > Would it help flush out such illegal accesses if at some appropriate point 
> > shost->hostt was set to NULL, maybe near the end of scsi_remove_host()?

If we wanted to set this to something to catch illegal access it might
be good to set hostt to a fake hostt that did a WARN_ON so that it would
not take the system down.

> 
> In fact that's a bug in the current scsi_host lifetime handling - before
> the driver can leave it's upper layer ->remove function we need to wait
> to the host refcount to become zero, similar to what free_netdev does.
> 
> I'll see whether I can come up with a fix.

Unless I missing something I do not see any interlock / wait in free_netdev
(in looking at test11).

Currently the host refcount will not go to zero until the scsi_host_put
is made from the LLDD post the return of the scsi_remove_host call.
While it is valid to sleep in the remove call and we could reorder the
scsi_host_put, I thought the previous goal was to not have an unbounded
time in scsi_remove_host. I thought we where trying to allow the host to
cleanup fast and if user space wanted to take time we would allow that
to happen, but just not send any commands to the LLDD.

-andmike
--
Michael Anderson
andmike@us.ibm.com

