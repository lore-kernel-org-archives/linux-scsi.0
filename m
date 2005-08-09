From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 9 Aug 2005 10:23:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508091014030.4643-100000@iolanthe.rowland.org>
References: <42F7E678.3010400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:19673 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964782AbVHIOXH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 10:23:07 -0400
In-Reply-To: <42F7E678.3010400@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 9 Aug 2005, Stefan Richter wrote:

> Alan Stern wrote:
> > On Mon, 8 Aug 2005, Stefan Richter wrote:
> >>But after all high-level drivers were detached (and that should
> >>have happend right before scsi_remove_host returns) I don't see why  
> >>the host's ref count might not be down to zero.
> > 
> > There might still be outstanding references: processes holding files 
> > open, that sort of thing.
> 
> But as long as files are open etc., scsi high-level drivers are
> 'in use', cannot be detached, and scsi_remove_host does not return.
> 
> Or that's what I assumed so far.

No, that's not right.  scsi_remove_host _can_ return while the high-level
drivers are still in use -- just think about what happens when you unplug
a USB storage device without unmounting it first.  I'm not sure what you 
mean about "detach"ing high-level SCSI drivers.  The high-level drivers 
are notified about the device removal; they drop their references and 
return.  They can still submit commands if they want, but all such 
submissions will fail in the SCSI core.

What can't happen is that the LLD's module can't be unloaded from memory.  
That's prevented by the open files holding a reference to the module.

Alan Stern

