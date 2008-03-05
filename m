From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 5 Mar 2008 13:04:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803051259070.5634-100000@iolanthe.rowland.org>
References: <47CD8D4E.3010703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42549 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754586AbYCESEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 13:04:44 -0500
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

On second thought, I'm not so sure this would work the way I want.  
scsi_device_get() ends up being called for all sorts of extra things 
unrelated to device opens.  For instance, scsi_probe_and_add_lun() 
calls it whenever a new LUN is discovered.

Would it be acceptable to add a similar pair of callbacks to the host
template, invoked by the upper-level driver's open and release
routines?

Alan Stern

