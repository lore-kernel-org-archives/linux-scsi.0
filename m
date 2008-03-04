From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Tue, 4 Mar 2008 15:04:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803041501060.15190-100000@iolanthe.rowland.org>
References: <47CD8D4E.3010703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52304 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752615AbYCDUEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 15:04:07 -0500
In-Reply-To: <47CD8D4E.3010703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 4 Mar 2008, Stefan Richter wrote:

> Alan Stern wrote:
> > So I need a
> > way to know whether anything is mounted on a device below a SCSI host.
> 
> Actually I have been thinking of something related for a while but 
> didn't send a patch yet.  Consider this:
> 
> [include/scsi/scsi_host.h]
> 
>   struct scsi_host_template {
> 	...
> +	int (* slave_sdev_get)(struct scsi_device *);
> +	void (* slave_sdev_put)(struct scsi_device *);
> 	...
>   }
> 
> [drivers/scsi/scsi.c]
> 
>   int scsi_device_get(struct scsi_device *sdev)
>   {
> +	int err = 0;
> +
>   	if (sdev->sdev_state == SDEV_DEL)
>   		return -ENXIO;
>   	if (!get_device(&sdev->sdev_gendev))
>   		return -ENXIO;
>   	/* We can fail this if we're doing SCSI operations
>   	 * from module exit (like cache flush) */
>   	try_module_get(sdev->host->hostt->module);
> 
> -	return 0;
> +	if (sdev->host->hostt->slave_sdev_get)
> +		err = sdev->host->hostt->slave_sdev_get(sdev);
> +	if (err) {
> +		...some ifdef'd module_put stuff...;
> +		put_device(&sdev->sdev_gendev);
> +	}
> +	return err;
> }
> 
> and equivalent additions to scsi_device_put().

That would be okay.  It does a little more than I need, but the 
difference doesn't matter.

> Example usage:
> 
> [drivers/ieee1394/sbp2.c]
> 
> +int sbp2_slave_sdev_get(struct scsi_device *sdev)
> +{
> +	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
> +
> +	if (!try_module_get(lu->hi->host->driver->owner))
> +		return -ENOMEM;
> +	return 0;
> +}
> 
> and an equivalent sbp2_slave_sdev_put().  These examples would prevent 
> unloading ohci1394 while somebody has mounted a filesystem on a device 
> driven by sbp2, or otherwise opened or referenced that device.  (At the 
> moment sbp2 unintelligently gets the host->driver->owner as long as it 
> is logged in into a device.  This is somewhat necessary because there 
> are unrelated drivers in the ieee1394 stack which when unloaded with 
> modprobe would cause ohci1394 to be unloaded too.)
> 
> You could use slave_sdev_get()/ slave_sdev_put() callbacks in 
> usb-storage to do an own bookkeeping of references there.
> 
> (Since I haven't looked at your other current work, all of the above may 
> be utterly besides the point...)

It's a good idea.  I'd be willing to use it, if you submit it.

Alan Stern

