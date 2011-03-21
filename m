From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Mon, 21 Mar 2011 15:02:54 -0500
Message-ID: <1300737774.10634.37.camel@mulgrave.site>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab1CUUDB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 16:03:01 -0400
In-Reply-To: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Mon, 2011-03-21 at 15:57 -0400, Mike Snitzer wrote:
> From: Eddie Williams <eddie.williams@steeleye.com>
> 
> Do not sdev_printk() a scsi_device that was, or is being, deleted.
> 
> If multiple failures occur (e.g. FC switch with multiple paths fails),
> and both the active path and next path is failed in the process, the
> scsi_device associated with the next path can be accessed after it was
> deleted.

This treats the symptom, not the cause, doesn't it?  Why do we have a
reference to an ungot instance of an sdev here ... and should it have
had a reference taken on it?

James


> Signed-off-by: Eddie Williams <eddie.williams@steeleye.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_emc.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 48441f6..670f059 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -537,14 +537,14 @@ static int clariion_activate(struct scsi_device *sdev,
>  
>  	result = clariion_send_inquiry(sdev, csdev);
>  	if (result != SCSI_DH_OK)
> -		goto done;
> +		goto out;
>  
>  	if (csdev->lun_state == CLARIION_LUN_OWNED)
>  		goto done;
>  
>  	result = send_trespass_cmd(sdev, csdev);
>  	if (result != SCSI_DH_OK)
> -		goto done;
> +		goto out;
>  	sdev_printk(KERN_INFO, sdev,"%s: %s trespass command sent\n",
>  		    CLARIION_NAME,
>  		    csdev->flags&CLARIION_SHORT_TRESPASS?"short":"long" );
> @@ -552,7 +552,7 @@ static int clariion_activate(struct scsi_device *sdev,
>  	/* Update status */
>  	result = clariion_send_inquiry(sdev, csdev);
>  	if (result != SCSI_DH_OK)
> -		goto done;
> +		goto out;
>  
>  done:
>  	sdev_printk(KERN_INFO, sdev,
> @@ -561,10 +561,12 @@ done:
>  		    csdev->port, lun_state[csdev->lun_state],
>  		    csdev->default_sp + 'A');
>  
> +out:
>  	if (fn)
>  		fn(data, result);
>  	return 0;
>  }
> +
>  /*
>   * params - parameters in the following format
>   *      "no_of_params\0param1\0param2\0param3\0...\0"


