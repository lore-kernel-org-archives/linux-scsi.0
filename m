From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 11:11:55 -0500
Message-ID: <1193847115.3411.31.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710311153520.4704-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41080 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756435AbXJaQMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:12:43 -0400
In-Reply-To: <Pine.LNX.4.44L0.0710311153520.4704-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 11:58 -0400, Alan Stern wrote:
> On Wed, 31 Oct 2007, James Bottomley wrote:
> 
> > On Wed, 2007-10-31 at 07:32 -0700, Greg KH wrote:
> > > Hm, I seem to have missed the part in this thread where someone said
> > > that it was valid to have a parent reference a child device.  That's
> > > just wrong and needs to be fixed.  Is that in the scsi layer somewhere?
> > > The block layer?  It sure isn't in the driver core...
> > 
> > This is the piece I'm still not clear on.  It's something to do with the
> > gendisk.  I'd have to look in block, but I believe the queue takes a ref
> > to the gendisk.
> > 
> > The scsi_device has a ref to the queue and the scsi_disk (in sd) has a
> > ref to both the scsi_device and the gendisk.  That means, until sd is
> > unbound and the scsi_disk released, there's an implied unbreakable
> > reference chain.
> > 
> > at least, I think that's what the problem is.
> 
> No, you haven't got it right.
> 
> 	Parent		Child		Grandchild
> 	------		-----		----------
> 	scsi_device	gendisk		request_queue

This is what I think doesn't happen.  The scsi_device should never be
parented to the gendisk.

> 
> The odd part is that the scsi_device holds a reference to the queue.  
> That creates a reference loop:
> 
> 	scsi_device	holds ref to	request_queue (done explicitly)
> 	request_queue	holds ref to	gendisk (implicit, parent-child)

agreed.

> 	gendisk		holds ref to	scsi_device (implicit, parent-child)

Where exactly does this last part happen? the scsi_device is a mid layer
object; the mid-layer doesn't know about gendisks.

James


