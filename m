From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi midlayer: fix sdev reuse after free
Date: Tue, 27 Jun 2006 11:03:31 -0500
Message-ID: <1151424211.3340.35.camel@mulgrave.il.steeleye.com>
References: <1151348028.5883.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6342 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932493AbWF0QDh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 12:03:37 -0400
In-Reply-To: <1151348028.5883.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-06-26 at 14:53 -0400, James Smart wrote:
>  void __scsi_remove_device(struct scsi_device *sdev)
>  {
>  	struct device *dev = &sdev->sdev_gendev;
> +	unsigned long flags;
>  
>  	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>  		return;
>  
> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	list_del(&sdev->siblings);
> +	list_del(&sdev->same_target_siblings);
> +	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>  	class_device_unregister(&sdev->sdev_classdev);
>  	transport_remove_device(dev);
>  	device_del(dev);

Not quite ... we cannot physically remove the device from the list until
after device_del has been called otherwise we could get namespace reuse
before it is really free (that's quite a small race window in this case,
but it does exist).

James


