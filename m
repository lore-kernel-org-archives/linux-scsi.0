From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: make 'state' device attribute pollable
Date: Wed, 9 Aug 2017 17:59:15 +0200
Message-ID: <20170809155915.GA3141@lst.de>
References: <1502284158-50201-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54202 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752338AbdHIP7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 11:59:16 -0400
Content-Disposition: inline
In-Reply-To: <1502284158-50201-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Aug 09, 2017 at 03:09:18PM +0200, Hannes Reinecke wrote:
> While the 'state' attribute can (and will) change occasionally,
> calling 'poll()' or 'select()' on it fails as sysfs is never
> notified that the state has changed.
> With this patch calling 'poll()' or 'select()' will work
> properly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c           | 7 +++++--
>  drivers/scsi/scsi_transport_srp.c | 5 ++++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 41c19c7..2101cfd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2654,6 +2654,7 @@ void scsi_exit_queue(void)
>  
>  	}
>  	sdev->sdev_state = state;
> +	sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
>  	return 0;
>  
>   illegal:
> @@ -3074,14 +3075,16 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
>  	 * offlined states and goose the device queue if successful.
>  	 */
>  	if ((sdev->sdev_state == SDEV_BLOCK) ||
> -	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
> +	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE)) {
>  		sdev->sdev_state = new_state;
> -	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
> +		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
> +	} else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
>  		if (new_state == SDEV_TRANSPORT_OFFLINE ||
>  		    new_state == SDEV_OFFLINE)
>  			sdev->sdev_state = new_state;
>  		else
>  			sdev->sdev_state = SDEV_CREATED;
> +		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
>  	} else if (sdev->sdev_state != SDEV_CANCEL &&
>  		 sdev->sdev_state != SDEV_OFFLINE)
>  		return -EINVAL;

This would be a lot more readable using switch statements:

	switch (sdev->sdev_state) {
	case SDEV_BLOCK:
	case SDEV_TRANSPORT_OFFLINE:
		sdev->sdev_state = new_state;
		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
		break;
	case SDEV_CREATED_BLOCK:
  		switch (new_state) {
		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_OFFLINE:
  			sdev->sdev_state = new_state;
			break;
		default:
  			sdev->sdev_state = SDEV_CREATED;
			break;
		}
		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
		break;
	case SDEV_CANCEL:
	case SDEV_OFFLINE:
		break;
	default:
 		return -EINVAL;
	}

Otherwise it looks fine to me.
