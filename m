From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 11:58:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311153520.4704-100000@iolanthe.rowland.org>
References: <1193843701.3411.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756060AbXJaP6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 11:58:24 -0400
In-Reply-To: <1193843701.3411.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 31 Oct 2007, James Bottomley wrote:

> On Wed, 2007-10-31 at 07:32 -0700, Greg KH wrote:
> > Hm, I seem to have missed the part in this thread where someone said
> > that it was valid to have a parent reference a child device.  That's
> > just wrong and needs to be fixed.  Is that in the scsi layer somewhere?
> > The block layer?  It sure isn't in the driver core...
> 
> This is the piece I'm still not clear on.  It's something to do with the
> gendisk.  I'd have to look in block, but I believe the queue takes a ref
> to the gendisk.
> 
> The scsi_device has a ref to the queue and the scsi_disk (in sd) has a
> ref to both the scsi_device and the gendisk.  That means, until sd is
> unbound and the scsi_disk released, there's an implied unbreakable
> reference chain.
> 
> at least, I think that's what the problem is.

No, you haven't got it right.

	Parent		Child		Grandchild
	------		-----		----------
	scsi_device	gendisk		request_queue

The odd part is that the scsi_device holds a reference to the queue.  
That creates a reference loop:

	scsi_device	holds ref to	request_queue (done explicitly)
	request_queue	holds ref to	gendisk (implicit, parent-child)
	gendisk		holds ref to	scsi_device (implicit, parent-child)

The scsi_disk adds confusion to the picture but it doesn't make things
any worse than they already are.

Alan Stern

