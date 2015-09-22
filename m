From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 03/23] scsi_dh_alua: improved logging
Date: Tue, 22 Sep 2015 14:30:54 -0400
Message-ID: <1442946654.4132.5.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-4-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490AbbIVSa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:30:56 -0400
In-Reply-To: <1440679281-13234-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Issue different logging messages if ALUA is not supported
> or the TPGS setting is invalid.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f15b977..a20c8bf 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -310,12 +310,18 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>  		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
>  			    ALUA_DH_NAME);
>  		break;
> -	default:
> -		h->tpgs = TPGS_MODE_NONE;
> +	case TPGS_MODE_NONE:
>  		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
>  			    ALUA_DH_NAME);
>  		err = SCSI_DH_DEV_UNSUPP;
>  		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: unsupported TPGS setting %d\n",
> +			    ALUA_DH_NAME, h->tpgs);
> +		h->tpgs = TPGS_MODE_NONE;
> +		err = SCSI_DH_DEV_UNSUPP;
> +		break;
>  	}
>  
>  	return err;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


