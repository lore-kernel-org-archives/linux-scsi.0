From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 20 Jun 2008 17:09:34 -0500
Message-ID: <1213999774.3443.49.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0806201731300.2133-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45095 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbYFTWJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 18:09:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806201731300.2133-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2008-06-20 at 17:46 -0400, Alan Stern wrote:
> On Fri, 20 Jun 2008, James Bottomley wrote:
> 
> > > Not having received any comments on that earlier patch, I wrote a new
> > > version.  Actually it's a pair of patches, and they have to be applied
> > > in order.  They don't look as ugly as the old one and they have a
> > > decent chance of being accepted.
> > 
> > Actually, just looking at this, what you're really trying to do is
> > enforce an underrun detection, which is a concept built in to the
> > command structure but not necessarily well implemented by all drivers.
> > 
> > However, I had a tick on this one to go back and look at it.
> > 
> > Your initial contention was that the garbage value was "left over data"
> > in the sense command.  However, I don't see how we're getting this into
> > the buffer; scsi_mode_sense() clears the buffer up to the length it's
> > expecting before it executes the request.  How is this getting garbage
> > data if nothing's returned ... surely it should still be all zeros?
> 
> It's not true that nothing's returned.  The device returns N bytes of
> garbage data (I forget just now what N was) and sets the residue equal
> to N -- meaning that none of the data was meaningful.
> 
> USB mass-storage is perhaps a little strange for people accustomed to 
> regular SCSI.  Quoting from the relevant spec:
> 
> 	For Data-In the device shall report in the dCSWDataResidue the 
> 	difference between the amount of data expected as stated in the
> 	dCBWDataTransferLength and the actual amount of relevant data
> 	sent by the device.
> 
> The key word here is "relevant".  The device is allowed to send 
> non-relevant data and then tell the host to ignore it.  Later on the 
> spec says:
> 
>     If the device intends to send less data than the host indicated, then: 
> 	The device shall send the intended data.
> 	    The device may send fill data to pad up to a total of dCBWDataTransferLength.
> 	    If the device actually transfers less data than the host indicated, then:
> 		The device may end the transfer with a short packet.
> 		The device shall STALL the Bulk-In pipe.
> 	The device shall set bCSWStatus to 00h or 01h.
> 	The device shall set dCSWDataResidue to the difference between dCBWDataTransferLength
> 	    and the actual amount of relevant data sent.
> 
> In this case the fill data is getting treated as real data.  Does this
> clarify the situation?

Yes, thanks.  It's a bit nasty from a security point of view, since the
leaking data apparently belonged to a different command.  Wouldn't a
better fix (and a more secure one) be to clear from the end of the valid
data to the end of the buffer?

James


