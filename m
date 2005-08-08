From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 18:40:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508081836490.4470-100000@iolanthe.rowland.org>
References: <1123539780.8235.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:22193 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932310AbVHHWkG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 18:40:06 -0400
In-Reply-To: <1123539780.8235.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 8 Aug 2005, James Bottomley wrote:

> Yes, I was considering something similar, since all the last put of a
> driver does is send the completion that driver_unregister() should be
> waiting for

That's exactly how I came to think of it.

> 
> > +	struct device_driver	*parent_driver;
> 
> I don't think we need this.  The underlying device has to be the parent
> of shost_gendev, so you can get the parent driver as
> 
> shost_gendev.parent->driver

The driver may have completely unbound from the parent device by the time
shost_gendev is released, so .parent->driver may already be NULL.

> > +	if (shost->parent_driver)
> > +		put_driver(shost->parent_driver);
> 
> And just before this would be the place to do the final release of all
> the resources the HBA is holding.

Right.

Alan Stern

