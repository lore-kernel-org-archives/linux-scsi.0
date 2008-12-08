From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Mon, 8 Dec 2008 10:10:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812081003280.2476-100000@iolanthe.rowland.org>
References: <20081204233942.GA4950@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56207 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752657AbYLHPKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 10:10:42 -0500
In-Reply-To: <20081204233942.GA4950@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 4 Dec 2008, Mike Anderson wrote:

> > > The current behaviour is to retry the error until the command timeout
> > > expires, which, I think is what was needed by the annoying arrays that
> > > have retryable hardware errors.
> > > 
> 
> Yes there are some arrays that need this behavior. The two users: 
> usb disks and the devinfo entries with BLIST_RETRY_HWERROR appear to have
> two different expected behaviors.

This leads me to question why hardware errors aren't always retried as 
a matter of course?

Of course, in most cases it makes sense to retry only a few times.  
(In other words, don't do five retries per second for 60 seconds!)  
Tape arrays needing indefinite retries appear to be out of the
ordinary.


> > For example, does it really make sense for scsi_softirq_done
> > to multiply cmd->allowed by rq->timeout?  After all, if a command
> > aborts with a timeout instead of failing outright, what point is there
> > in retrying it?  The proper approach would have been to use a longer 
> > timeout initially.
> > 
> 
> The wait_for is used for more than retries of timeouts.

What else is it used for?  In my copy of scsi_softirq_done() it appears
in just one place, and that is a test to see whether the command should
fail with a timeout error.

> I had thought it might be a good idea to expose the wait_for value and
> then users could control the wait_for behavior if needed by using a udev
> rule to set it near the IO timeout value if so required.

Why should the wait_for value be any different from the regular I/O 
timeout?  Isn't it in fact a timeout value?

Alan Stern

