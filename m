From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 08:31:48 -0800
Message-ID: <1511973108.3222.10.camel@linux.vnet.ibm.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932234AbdK2Qb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 11:31:57 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vATGVQrC139112
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 11:31:57 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ehvcvv06w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 11:31:56 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 29 Nov 2017 09:31:55 -0700
In-Reply-To: <20171129030556.47833-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Zhaohongjiang <zhaohongjiang@huawei.com>, Miao Xie <miaoxie@huawei.com>

On Wed, 2017-11-29 at 11:05 +0800, Jason Yan wrote:
> In commit fbce4d97fd43 ("scsi: fixup kernel warning during rmmod()"),
> we
> removed scsi_device_get() and directly called get_device() to
> increase
> the refcount of the device. But actullay scsi_device_get() will fail
> in
> three cases:
> 1. the scsi device is in SDEV_DEL or SDEV_CANCEL state
> 2. get_device() fail
> 3. the module is not alive
> 
> The intended purpose was to remove the check of the module alive.
> Unfortunately the check of the device state was droped too. And this
> introduced a race condition like this:
> 
>       CPU0                                           CPU1
> __scsi_remove_target()
>   ->iterate shost->__devices
>   ->scsi_remove_device()
>   ->put_device()
>       someone still hold a refcount
>                                                    sd_release()
>                                                       -
> >scsi_disk_put()
>                                                       ->put_device()
> last put and trigger the device release
> 
>   ->goto restart
>   ->iterate shost->__devices and got the same device
>   ->get_device() while refcount is 0

This analysis fails here: get_device() on something with refcount 0
returns NULL.  That triggers the if clause to ignore this device.

We may have a more complex way of triggering a dual put race as the
trace implies, but I don't think this is it.

[...]
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 50e7d7e..d398894 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1398,6 +1398,15 @@ void scsi_remove_device(struct scsi_device
> *sdev)
>  }
>  EXPORT_SYMBOL(scsi_remove_device);
>  
> +static int scsi_device_get_not_deleted(struct scsi_device *sdev)
> +{
> +	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state ==
> SDEV_CANCEL)
> +		return -ENXIO;
> +	if (!get_device(&sdev->sdev_gendev))
> +		return -ENXIO;
> +	return 0;
> +}

This is pretty much scsi_device_get() without the try_module get, so
they should probably be combined.

James

>  static void __scsi_remove_target(struct scsi_target *starget)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> @@ -1415,7 +1424,7 @@ static void __scsi_remove_target(struct
> scsi_target *starget)
>  		 */
>  		if (sdev->channel != starget->channel ||
>  		    sdev->id != starget->id ||
> -		    !get_device(&sdev->sdev_gendev))
> +		    scsi_device_get_not_deleted(sdev))
>  			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		scsi_remove_device(sdev);
