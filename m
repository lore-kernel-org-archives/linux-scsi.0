From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 04/23] scsi_dh_alua: use standard logging functions
Date: Tue, 22 Sep 2015 14:32:10 -0400
Message-ID: <1442946730.4132.6.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-5-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806AbbIVScM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:32:12 -0400
In-Reply-To: <1440679281-13234-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Use standard logging functions instead of hand-crafted ones.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 34 +++++++++++++-----------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index a20c8bf..7b43ee3 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -23,6 +23,7 @@
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dh.h>
>  
> @@ -194,22 +195,16 @@ static void stpg_endio(struct request *req, int error)
>  		goto done;
>  	}
>  
> -	if (req->sense_len > 0) {
> -		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> -					   &sense_hdr);
> -		if (!err) {
> -			err = SCSI_DH_IO;
> -			goto done;
> -		}
> +	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +				 &sense_hdr)) {
>  		err = alua_check_sense(h->sdev, &sense_hdr);
>  		if (err == ADD_TO_MLQUEUE) {
>  			err = SCSI_DH_RETRY;
>  			goto done;
>  		}
> -		sdev_printk(KERN_INFO, h->sdev,
> -			    "%s: stpg sense code: %02x/%02x/%02x\n",
> -			    ALUA_DH_NAME, sense_hdr.sense_key,
> -			    sense_hdr.asc, sense_hdr.ascq);
> +		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME, &sense_hdr);
>  		err = SCSI_DH_IO;
>  	} else if (error)
>  		err = SCSI_DH_IO;
> @@ -530,16 +525,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		}
>  
>  		err = alua_check_sense(sdev, &sense_hdr);
> -		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
> +		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
> +			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
> +				    ALUA_DH_NAME);
> +			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>  			goto retry;
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: rtpg sense code %02x/%02x/%02x\n",
> -			    ALUA_DH_NAME, sense_hdr.sense_key,
> -			    sense_hdr.asc, sense_hdr.ascq);
> -		err = SCSI_DH_IO;
> +		}
> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> +		return SCSI_DH_IO;
>  	}
> -	if (err != SCSI_DH_OK)
> -		return err;
>  
>  	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
>  		(h->buff[2] << 8) + h->buff[3] + 4;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


