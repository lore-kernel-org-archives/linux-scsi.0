From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi_lib: rework
        scsi_internal_device_unblock_nowait()
Date: Thu, 10 Aug 2017 11:27:46 +0200
Message-ID: <20170810092746.GC24539@lst.de>
References: <1502348731-63534-1-git-send-email-hare@suse.de> <1502348731-63534-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58923 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdHJJ1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 05:27:47 -0400
Content-Disposition: inline
In-Reply-To: <1502348731-63534-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Aug 10, 2017 at 09:05:30AM +0200, Hannes Reinecke wrote:
> Rework scsi_internal_device_unblock_nowait() into using a
> switch statement.
> No functional changes.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1ae531b..035aa4c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3074,19 +3074,25 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
>  	 * Try to transition the scsi device to SDEV_RUNNING or one of the
>  	 * offlined states and goose the device queue if successful.
>  	 */
> -	if ((sdev->sdev_state == SDEV_BLOCK) ||
> -	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
> +	switch (sdev->sdev_state) {
> +	case SDEV_BLOCK:
> +	case SDEV_TRANSPORT_OFFLINE:
>  		sdev->sdev_state = new_state;
> -	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
> +		break;
> +	case SDEV_CREATED_BLOCK:
>  		if (new_state == SDEV_TRANSPORT_OFFLINE ||
>  		    new_state == SDEV_OFFLINE)
>  			sdev->sdev_state = new_state;
>  		else
>  			sdev->sdev_state = SDEV_CREATED;
> -	} else if (sdev->sdev_state != SDEV_CANCEL &&
> -		 sdev->sdev_state != SDEV_OFFLINE)
> +		break;
> +	case SDEV_TRANSPORT_OFFLINE:
> +	case SDEV_CANCEL:
> +	case SDEV_OFFLINE:
> +		break;
> +	default:
>  		return -EINVAL;

This changes ok by default to reject by default and instead lists
the ok states.  Which probably is the right thing to do for future
proofing against new states, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
