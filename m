From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi midlayer: fix sdev reuse after free
Date: Wed, 19 Jul 2006 10:12:36 -0400
Message-ID: <44BE3DD4.3030605@emulex.com>
References: <1151348028.5883.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:13031 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S964846AbWGSOMi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jul 2006 10:12:38 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k6JECbpq008135
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2006 07:12:37 -0700 (PDT)
In-Reply-To: <1151348028.5883.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

FYI - NACK this patch. It passed testing on small systems, but didn't fare
well at all on larger more parallel systems.  Still working on a patch for
this.

-- james s

James Smart wrote:
> The conversion to execute_in_process_context() highlighted a use-after-free
> race condition. Although the sdev was torn down, it remained in the linked
> lists looked at by scan, and allowed scan to reuse the sdev.
> 
> This patch removes the sdev from the lists at the point it tears down the
> sdev.
> 
> -- james s
> 
> Signed-off-by: James Smart <james.smart@emulex.com>
> 
> diff -upNr a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> --- a/drivers/scsi/scsi_sysfs.c	2006-06-14 11:37:09.000000000 -0400
> +++ b/drivers/scsi/scsi_sysfs.c	2006-06-26 14:48:31.000000000 -0400
> @@ -231,8 +231,6 @@ static void scsi_device_dev_release_user
>  
>  	spin_lock_irqsave(sdev->host->host_lock, flags);
>  	starget->reap_ref++;
> -	list_del(&sdev->siblings);
> -	list_del(&sdev->same_target_siblings);
>  	list_del(&sdev->starved_entry);
>  	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>  
> @@ -735,10 +733,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
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
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
