From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix reference counting for failed SCSI devices
Date: Tue, 24 May 2005 17:57:58 -0500
Message-ID: <1116975478.7710.28.camel@mulgrave>
References: <4292F631.9090300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:24029 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261926AbVEXW6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 18:58:03 -0400
In-Reply-To: <4292F631.9090300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-05-24 at 11:38 +0200, Hannes Reinecke wrote:
> whenever the scsi-ml tries to scan non-existent devices the reference
> count in scsi_alloc_sdev() and scsi_probe_and_add_lun() is not adjusted
> properly. Every call to XXX_initialize in the driver core sets the
> reference count to 1, so for a proper deallocation an explicit XXX_put()
> has to be done.

That's true, but I don't see what the problem is if the device has never
been made visible.

> +			put_device(&starget->dev);

this would amount to a double put, since the parent put method is called
in the device release.

> +	class_device_put(&sdev->sdev_classdev);

This is unnecessary since the class device is simply occupying a private
area in the scsi_device.  As long as its never made visible to the
system, its refcount is irrelevant

>  	put_device(&sdev->sdev_gendev);
>  out:
>  	if (display_failure_msg)
> @@ -855,6 +857,8 @@ static int scsi_probe_and_add_lun(struct
>  		if (sdev->host->hostt->slave_destroy)
>  			sdev->host->hostt->slave_destroy(sdev);
>  		transport_destroy_device(&sdev->sdev_gendev);
> +		class_device_put(&sdev->sdev_classdev);
> +		put_device(sdev->sdev_gendev.parent);

same should apply here.  As long as this cascade occurs before
scsi_add_lun() (which calls scsi_sysfs_add_sdev()), which is what makes
the whole set of devices and classes visible.

James


