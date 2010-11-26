From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH (trivial) 1/2] SCSI: improve two error messages
Date: Fri, 26 Nov 2010 15:45:18 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011261544480.981@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1011151559190.1370-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0KZOpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 09:45:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.1011151559190.1370-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 15 Nov 2010, Alan Stern wrote:

> This trivial patch (as1338) makes two uninformative error messages in
> scsi_sysfs_add_sdev() more explicit.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-2.6/drivers/scsi/scsi_sysfs.c
> @@ -890,13 +890,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>  	device_enable_async_suspend(&sdev->sdev_gendev);
>  	error = device_add(&sdev->sdev_gendev);
>  	if (error) {
> -		printk(KERN_INFO "error 1\n");
> +		sdev_printk(KERN_INFO, sdev,
> +				"failed to add device: %d\n", error);
>  		return error;
>  	}
>  	device_enable_async_suspend(&sdev->sdev_dev);
>  	error = device_add(&sdev->sdev_dev);
>  	if (error) {
> -		printk(KERN_INFO "error 2\n");
> +		sdev_printk(KERN_INFO, sdev,
> +				"failed to add class device: %d\n", error);
>  		device_del(&sdev->sdev_gendev);
>  		return error;
>  	}

This doesn't seem to be present in linux-next as of today, so I have 
merged it to trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
