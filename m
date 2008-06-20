From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 20 Jun 2008 17:46:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806201731300.2133-100000@iolanthe.rowland.org>
References: <1213995364.3443.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752478AbYFTVqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2008 17:46:54 -0400
In-Reply-To: <1213995364.3443.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Jun 2008, James Bottomley wrote:

> > Not having received any comments on that earlier patch, I wrote a new
> > version.  Actually it's a pair of patches, and they have to be applied
> > in order.  They don't look as ugly as the old one and they have a
> > decent chance of being accepted.
> 
> Actually, just looking at this, what you're really trying to do is
> enforce an underrun detection, which is a concept built in to the
> command structure but not necessarily well implemented by all drivers.
> 
> However, I had a tick on this one to go back and look at it.
> 
> Your initial contention was that the garbage value was "left over data"
> in the sense command.  However, I don't see how we're getting this into
> the buffer; scsi_mode_sense() clears the buffer up to the length it's
> expecting before it executes the request.  How is this getting garbage
> data if nothing's returned ... surely it should still be all zeros?

It's not true that nothing's returned.  The device returns N bytes of
garbage data (I forget just now what N was) and sets the residue equal
to N -- meaning that none of the data was meaningful.

USB mass-storage is perhaps a little strange for people accustomed to 
regular SCSI.  Quoting from the relevant spec:

	For Data-In the device shall report in the dCSWDataResidue the 
	difference between the amount of data expected as stated in the
	dCBWDataTransferLength and the actual amount of relevant data
	sent by the device.

The key word here is "relevant".  The device is allowed to send 
non-relevant data and then tell the host to ignore it.  Later on the 
spec says:

    If the device intends to send less data than the host indicated, then: 
	The device shall send the intended data.
	    The device may send fill data to pad up to a total of dCBWDataTransferLength.
	    If the device actually transfers less data than the host indicated, then:
		The device may end the transfer with a short packet.
		The device shall STALL the Bulk-In pipe.
	The device shall set bCSWStatus to 00h or 01h.
	The device shall set dCSWDataResidue to the difference between dCBWDataTransferLength
	    and the actual amount of relevant data sent.

In this case the fill data is getting treated as real data.  Does this
clarify the situation?

Alan Stern

