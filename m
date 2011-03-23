From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Wed, 23 Mar 2011 17:58:26 -0400
Message-ID: <20110323215826.GA3433@redhat.com>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
 <1300737774.10634.37.camel@mulgrave.site>
 <20110321203829.GB12157@redhat.com>
 <1300740249.10634.43.camel@mulgrave.site>
 <20110321231657.GA12902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab1CWV6b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 17:58:31 -0400
Content-Disposition: inline
In-Reply-To: <20110321231657.GA12902@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Mon, Mar 21 2011 at  7:16pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> > It's a bug fix: of course it can.
> 
> Right, so given scsi_dh_activate()'s {get,put}_device() that wraps the
> call to scsi_dh->activate (aka clariion_activate) I'm not seeing how
> accessing sdev->sdev_gendev (via sdev_printk) could result in a panic.
> So I'll need to dig deeper (hopefully with Eddie's assistance)...

Hi James,

I checked with Eddie and the sdev_printk() panic he saw no longer occurs
when commit db422318 is in place.  But he also tested with the patch I
provided below.

I still feel this fix is needed and would like to get your feedback on
this (relative to 2.6.39):

> But now that I look at scsi_dh_activate's 'err' path, it would appear
> that we don't drop the reference (put_device) before returning 'err'.  I
> unfotunately had a role in the offending change (commit: db422318)
> getting upstream.  /me ducks
> 
> Looks to me like we need this:
> 
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: [SCSI] scsi_dh: fix reference counting in scsi_dh_activate error path
> 
> Commit db422318cbca55168cf965f655471dbf8be82433 ([SCSI] scsi_dh:
> propagate SCSI device deletion) introduced a regression where the device
> reference is not dropped prior to scsi_dh_activate's early return from
> the error path.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@kernel.org
> ---
>  drivers/scsi/device_handler/scsi_dh.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 564e6ec..0119b81 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -394,12 +394,14 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>  	unsigned long flags;
>  	struct scsi_device *sdev;
>  	struct scsi_device_handler *scsi_dh = NULL;
> +	struct device *dev = NULL;
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	sdev = q->queuedata;
>  	if (sdev && sdev->scsi_dh_data)
>  		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> -	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
> +	dev = get_device(&sdev->sdev_gendev);
> +	if (!scsi_dh || !dev ||
>  	    sdev->sdev_state == SDEV_CANCEL ||
>  	    sdev->sdev_state == SDEV_DEL)
>  		err = SCSI_DH_NOSYS;
> @@ -410,12 +412,13 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>  	if (err) {
>  		if (fn)
>  			fn(data, err);
> -		return err;
> +		goto out;
>  	}
>  
>  	if (scsi_dh->activate)
>  		err = scsi_dh->activate(sdev, fn, data);
> -	put_device(&sdev->sdev_gendev);
> +out:
> +	put_device(dev);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_activate);
> 
