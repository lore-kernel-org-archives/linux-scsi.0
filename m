From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 9 Aug 2005 14:49:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508091444230.6287-100000@iolanthe.rowland.org>
References: <42F8F442.1000304@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:136 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750719AbVHIStT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 14:49:19 -0400
In-Reply-To: <42F8F442.1000304@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 9 Aug 2005, Stefan Richter wrote:

> > It already is in the core.  If you're interested, read 
> > drivers/usb/core/usb.c:usb_lock_device_for_reset().
> 
> I was actually browsing the usb/storage/scsiglue.c, but only
> old code at lxr.linux.no, 2.6.11 in fact. Sorry, I see now that
> this is way too old to look at. However the scsiglue.c's
> device_reset and bus_reset in Linus' tree are still using down().

2.6.11 isn't too old.  The code hasn't really changed since then.

However, you're looking at the wrong semaphore.  (Yes, the call to

	down(&(us->dev_semaphore));

in bus_reset() would also create a deadlock, but it's not really needed
and I'm going to take it out.)  You should instead be looking at the call
to usb_lock_device_for_reset() -- notice how it uses usb_trylock_device().

Alan Stern

