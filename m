From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Requested changes for the SCSI error handler
Date: 01 Jun 2004 15:46:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086122775.2061.87.camel@mulgrave>
References: <Pine.LNX.4.44L0.0406011617260.1167-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:179 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265089AbUFAUqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 16:46:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406011617260.1167-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-06-01 at 15:29, Alan Stern wrote:
> You mean, in the hostt->eh_{bus|host}_reset_handler() routines?  That
> would be fine with me.  Isn't it true that we don't even have to block the
> host, since this all executes in the error-handler thread?

Actually yes.  The block would only have to be implemented in the
asynchronous report path.

> In addition, the settle-time delays would have to be removed from the
> error handler -- which means adding it to all the low-level drivers.  Is 
> that doable?

Well, for 2.6, I think that a simple flag indicating that the driver
will implement it's own timeout should suffice rather than altering
every LLD...

> > > 	In scsi_eh_ready_devs(), it would be good if some of the resets
> > > 	could be skipped sometimes.  For example, if the low-level
> > > 	driver has just done its own bus-device reset (and called
> > > 	scsi_report_device_reset) then there's no point in doing 
> > > 	scsi_eh_bus_device_reset().  The same is true for bus resets.
> > > 	It just adds additional timeout delays to an already-lengthy
> > > 	recovery process.
> > 
> > Well, tidying up the reports could be done.  Really we should treat them
> > as error conditions: mark all the in-progress commands for the devices
> > and probe with a TUR before resuming.
> 
> In practice the LLD-initiated resets are likely to accompany command 
> failures or errors anyway.  But this doesn't answer my question: Can the 
> error-handler's redundant resets be skipped?

Well, no.  The reason is that the report interfaces are reporting
asynchronous events (that the HBA may notice some while after they
actually occurred).  Even if the host reports a device reset, it is very
possible that a command went to the device *after* that event occurred,
so we'd still have to reset the device again to kill that command.

James


