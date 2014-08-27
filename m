From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Wed, 27 Aug 2014 10:45:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408271040300.1460-100000@iolanthe.rowland.org>
References: <1409121931.27702.8.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53133 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934808AbaH0Opx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2014 10:45:53 -0400
In-Reply-To: <1409121931.27702.8.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 27 Aug 2014, Oliver Neukum wrote:

> > I don't think we want to add another SCSI flag to say that READ
> > CAPACITY(10) is unreliable.
> 
> Why not? It would only be friendly to tell the upper layer
> of a malfunction if we know about it.

To what end?  What will the upper layer do with this information?

> > Given the difficulty of determining the true capacity, I see two
> > alternatives.  We could set the capacity to a ridiculously large value
> > (like 1 billion TB), or we could leave the capacity set to the low
> > value and disable the "block within bounds" checks.  Neither of these
> > is attractive and they both have issues of their own -- although the 
> > second is close to what Windows does.
> 
> That seems to be the most attractive solution to me.

I'm skeptical that you can convince the SCSI and block-layer developers 
about this.  Maybe they'll accept it if it is applied only to USB 
transports...

> > (For example, udev often tries to read the last sectors of a new drive, 
> > looking for a GPT or RAID signature.  That won't work if the capacity 
> > is set to some random value.)
> 
> Yes, but clipping has its own dangers. Suppose you use the medium
> without a partition table.

What would Windows do?  In the absence of a partition table, it would 
believe the value from READ CAPACITY, right?  Isn't that the same as 
clipping?

Alan Stern

