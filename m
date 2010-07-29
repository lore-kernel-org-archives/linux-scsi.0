From: Shyam Iyer <shyam_iyer@dell.com>
Subject: Re: [dm-devel] [PATCH 2/6] scsi_dh : increment the refcounts while
 calling activate
Date: Thu, 29 Jul 2010 00:46:51 -0400
Message-ID: <4C5107BB.8020201@dell.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:13511 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0G2ErD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 00:47:03 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Stankey, Robert" <Robert.Stankey@lsi.com>

On 07/28/2010 06:59 PM, Moger, Babu wrote:
> Hold the refcounts for device and scsi_dh_data while calling handler's activate. This will make sure that devices and scsi_dh_data are not removed while activate is still in progress. Make sure to call put_device and kref_put in the handler after activate is complete.
>
> Signed-off-by: Babu Moger<babu.moger@lsi.com>
> ---
> --- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c.orig	2010-07-23 05:40:11.000000000 -0500
> +++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c	2010-07-23 05:48:53.000000000 -0500
> @@ -228,7 +228,8 @@ store_dh_state(struct device *dev, struc
>   			 * Activate a device handler
>   			 */
>   			if (scsi_dh->activate)
> -				err = scsi_dh->activate(sdev, NULL, NULL);
> +				err = scsi_dh_activate(sdev->request_queue,
> +							NULL, NULL);
>   			else
>   				err = 0;
>   		}
> @@ -431,6 +432,8 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device
>    *         do not hold the lock in the caller which may be needed in fn.
>    * @data - data passed to the function fn upon completion.
>    *
> + * NOTE  - Remember to call put_device and kref_put in the handler after
> + *         calling the callback function. Otherwise things could become messy.
>    */
>   int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>   {
> @@ -450,9 +453,12 @@ int scsi_dh_activate(struct request_queu
>   	if (err)
>   		return err;
>
> -	if (scsi_dh->activate)
> +	if (scsi_dh->activate) {
> +		kref_get(&sdev->scsi_dh_data->kref);
>   		err = scsi_dh->activate(sdev, fn, data);
>    
Why not kref_put here instead of in the device handler.. It is easier to 
associate the ref counts..

Also, you are removing the put_device here and adding them to the device 
handler which can be avoided ..
> -	put_device(&sdev->sdev_gendev);
> +	} else
> +		put_device(&sdev->sdev_gendev);
> +
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(scsi_dh_activate);
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>    

-Shyam Iyer
