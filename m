From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Mon, 27 Oct 2003 18:32:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028023235.GE1151@beaverton.ibm.com>
References: <20031027155713.GA28140@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:13980 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263824AbTJ1C2m
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 21:28:42 -0500
Content-Disposition: inline
In-Reply-To: <20031027155713.GA28140@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

I applied your patch to test9 and ran a few cycles of adds and removes
using scsi_debug.

A few comments below.

Christoph Hellwig [hch@lst.de] wrote:
> @@ -1232,14 +1233,25 @@
>  
>  void scsi_forget_host(struct Scsi_Host *shost)
>  {
> -	struct list_head *le, *lh;
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev, *tmp;
> +	unsigned long flags;
>  
> -	list_for_each_safe(le, lh, &shost->my_devices) {
> -		sdev = list_entry(le, struct scsi_device, siblings);
> -		
> +	/*
> +	 * Ok, this look a bit strange.  We always look for the first device
> +	 * on the list as scsi_remove_device removes them from it - thus we
> +	 * also have to release the lock.
> +	 * We don't need to get another reference to the device before
> +	 * releasing the lock as we already own the reference from
> +	 * scsi_register_device that's release in scsi_remove_device.  And
> +	 * after that we don't look at sdev anymore.
> +	 */
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  		scsi_remove_device(sdev);
> +		spin_lock_irqsave(shost->host_lock, flags);
>  	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>  
>  /*

Do we still have issues with other callers of scsi_remove_device?

> @@ -403,22 +396,11 @@
>   **/
>  void scsi_remove_device(struct scsi_device *sdev)
>  {
> -	struct class *class = class_get(&sdev_class);
> -
>  	class_device_unregister(&sdev->sdev_classdev);
> -
> -	if (class) {
> -		down_write(&class->subsys.rwsem);
> -		set_bit(SDEV_DEL, &sdev->sdev_state);
> -		if (sdev->host->hostt->slave_destroy)
> -			sdev->host->hostt->slave_destroy(sdev);
> -		device_del(&sdev->sdev_gendev);
> -		up_write(&class->subsys.rwsem);
> -	}
> -
> +	if (sdev->host->hostt->slave_destroy)
> +		sdev->host->hostt->slave_destroy(sdev);
> +	device_del(&sdev->sdev_gendev);
>  	put_device(&sdev->sdev_gendev);
> -
> -	class_put(&sdev_class);
>  }
>  

Don't we still want to set SDEV_DEL to keep callers to scsi_device_get
from do more gets.

-andmike
--
Michael Anderson
andmike@us.ibm.com

