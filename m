From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 17:23:00 -0500
Message-ID: <1123539780.8235.13.camel@mulgrave>
References: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1920 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932287AbVHHWXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 18:23:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 2005-08-08 at 16:41 -0400, Alan Stern wrote:
> > > Would you agree to a patch adding such a kref?
> > 
> > Well, not really.  The host template usually exists as a variable in the
> > module, so its lifetime is tied to the lifetime of the module.  Adding a
> > kref wouldn't help because it will still be freed when the module is
> > removed.  If there's a case where the template is being freed
> > prematurely because the module is being removed, then we have the module
> > refcounting wrong somewhere.  Have you run across such a case?
> 
> I tried to provoke such a case, but failed.  Evidently I've been barking
> up the wrong tree.  Normally the SCSI core doesn't call the LLD unless
> some process has opened a device file for something on that host.  This
> will automatically do try_module_get on the LLD, making it impossible for
> the LLD to be removed from memory.
> 
> I'm not certain this reasoning is 100% reliable, though -- does it cover
> _every_ case where the core calls the LLD?  Maybe something like this 
> little patch would be a good idea:

Yes, I was considering something similar, since all the last put of a
driver does is send the completion that driver_unregister() should be
waiting for

> +	struct device_driver	*parent_driver;

I don't think we need this.  The underlying device has to be the parent
of shost_gendev, so you can get the parent driver as

shost_gendev.parent->driver

> +	if (shost->parent_driver)
> +		put_driver(shost->parent_driver);

And just before this would be the place to do the final release of all
the resources the HBA is holding.

James


