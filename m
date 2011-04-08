From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RESEND][2.6.39-rc PATCH] [SCSI] scsi_dh: fix reference counting
 in scsi_dh_activate error path
Date: Fri, 08 Apr 2011 17:03:00 -0500
Message-ID: <4D9F8614.7070208@cs.wisc.edu>
References: <20110408190536.GA11001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45451 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab1DHWBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 18:01:45 -0400
In-Reply-To: <20110408190536.GA11001@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 04/08/2011 02:05 PM, Mike Snitzer wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 564e6ec..0119b81 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -394,12 +394,14 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>   	unsigned long flags;
>   	struct scsi_device *sdev;
>   	struct scsi_device_handler *scsi_dh = NULL;
> +	struct device *dev = NULL;
>
>   	spin_lock_irqsave(q->queue_lock, flags);
>   	sdev = q->queuedata;
>   	if (sdev&&  sdev->scsi_dh_data)
>   		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> -	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
> +	dev = get_device(&sdev->sdev_gendev);
> +	if (!scsi_dh || !dev ||
>   	    sdev->sdev_state == SDEV_CANCEL ||
>   	    sdev->sdev_state == SDEV_DEL)
>   		err = SCSI_DH_NOSYS;
> @@ -410,12 +412,13 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>   	if (err) {
>   		if (fn)
>   			fn(data, err);
> -		return err;
> +		goto out;
>   	}
>
>   	if (scsi_dh->activate)
>   		err = scsi_dh->activate(sdev, fn, data);
> -	put_device(&sdev->sdev_gendev);
> +out:
> +	put_device(dev);
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(scsi_dh_activate);
>

Looks correct to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
