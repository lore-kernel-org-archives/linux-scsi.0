From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] correct module refcounting
Date: Tue, 28 Oct 2003 16:17:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029001724.GA2029@beaverton.ibm.com>
References: <1067377564.1788.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:37511 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261831AbTJ2AMp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 19:12:45 -0500
Content-Disposition: inline
In-Reply-To: <1067377564.1788.39.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> There's a race window between doing the last scsi_device_put and having
> the devices actually released where the module may be unloaded.  The fix
> is to move the module accounting into the
> scsi_allocate_sdev/scsi_free_sdev pieces of the SCSI routines.
> 
> I also think we probably want to move sdev_gendev population into
> scsi_allocate_sdev.  Note this will change how we do initial scans
> because now we'll be using the generic device release infrastructure to
> free even temporary devices.  Unless anyone has a better idea...?
> 

If we do this we will need to do a two phase init of the sdev_gendev
like we do with the host. Otherwise every device_register will cause the
sd_probe to be called.

> Finally, when this is done, we can take a device reference over both
> scsi_get_command/scsi_put_command and also within the scsi_request_fn so
> we know the device can never be released while it has outstanding
> commands or while we are running its queues.
> 

What case of IO in-flight post a upper level driver release call are you
trying to protect. Do you think these extra atomic_incs will have any
negative impact.

> James
> 
> ===== drivers/scsi/scsi_scan.c 1.110 vs edited =====
> --- 1.110/drivers/scsi/scsi_scan.c	Mon Oct 27 06:01:50 2003
> +++ edited/drivers/scsi/scsi_scan.c	Tue Oct 28 15:39:00 2003
> @@ -192,6 +192,9 @@
>  	struct scsi_device *sdev, *device;
>  	unsigned long flags;
>  
> +	if (!try_module_get(sdev->host->hostt->module))
> +		goto out;
> +
>  	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
>  	if (!sdev)
>  		goto out;

Shouldn't this chunk be after the setting of sdev. I applied your patch
and it oops on me. After I moved it I am booted, but I have not done any
adds / deletes.

-andmike
--
Michael Anderson
andmike@us.ibm.com

