From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Requested changes for the SCSI error handler
Date: Tue, 1 Jun 2004 16:29:10 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406011617260.1167-100000@ida.rowland.org>
References: <1086119915.1795.73.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:19204 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265206AbUFAU3N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 16:29:13 -0400
In-Reply-To: <1086119915.1795.73.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 1 Jun 2004, James Bottomley wrote:

> On Tue, 2004-06-01 at 13:50, Alan Stern wrote:
> > 
> > 	The recovery xxx_RESET_SETTLE_TIME delays in scsi_sleep() can not 
> > 	be interrupted, even if the state changes to SDEV_CANCEL or 
> > 	SHOST_CANCEL.  It would be nice if the delay could be cut short
> > 	so that scsi_remove_host() doesn't have to wait.  Lengthy pauses
> > 	during disconnect processing are bad for the USB hub driver.
> 
> Really, no.  The settle time is not transport independent, so it would
> be very difficult to implement stomething like this in the mid-layer.
> 
> What about simply doing the settle in the eh_.. routines (you block the
> host, schedule_timeout() for your settle time then unblock the host and
> return to the eh thread)?

You mean, in the hostt->eh_{bus|host}_reset_handler() routines?  That
would be fine with me.  Isn't it true that we don't even have to block the
host, since this all executes in the error-handler thread?

In addition, the settle-time delays would have to be removed from the
error handler -- which means adding it to all the low-level drivers.  Is 
that doable?


> > 	In scsi_eh_ready_devs(), it would be good if some of the resets
> > 	could be skipped sometimes.  For example, if the low-level
> > 	driver has just done its own bus-device reset (and called
> > 	scsi_report_device_reset) then there's no point in doing 
> > 	scsi_eh_bus_device_reset().  The same is true for bus resets.
> > 	It just adds additional timeout delays to an already-lengthy
> > 	recovery process.
> 
> Well, tidying up the reports could be done.  Really we should treat them
> as error conditions: mark all the in-progress commands for the devices
> and probe with a TUR before resuming.

In practice the LLD-initiated resets are likely to accompany command 
failures or errors anyway.  But this doesn't answer my question: Can the 
error-handler's redundant resets be skipped?

Alan Stern

