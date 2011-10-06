From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Thu, 06 Oct 2011 18:07:27 -0400
Message-ID: <4E8E269F.4020901@redhat.com>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475Ab1JFWHc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 18:07:32 -0400
In-Reply-To: <1313182877-31377-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

  On 08/12/2011 05:01 PM, Rob Evers wrote:
> replace numeric messages with string error messages when blk_execute_rq
> fails.  Also add printing of sense info.
>
> Mike Christie suggested adding printing of sense info here
>
> Signed-off-by: Rob Evers<revers@redhat.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c |   27 ++++++++++++++++++---------
>   1 files changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 6fec9fe..58fdf64 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -24,6 +24,7 @@
>   #include<scsi/scsi.h>
>   #include<scsi/scsi_eh.h>
>   #include<scsi/scsi_dh.h>
> +#include<scsi/scsi_dbg.h>
>
>   #define ALUA_DH_NAME "alua"
>   #define ALUA_DH_VER "1.3"
> @@ -153,9 +154,12 @@ static int submit_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
>
>   	err = blk_execute_rq(rq->q, NULL, rq, 1);
>   	if (err == -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: std inquiry failed with %x\n",
> -			    ALUA_DH_NAME, rq->errors);
> +		sdev_printk(KERN_INFO, sdev, "%s: std inquiry failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_show_result(rq->errors);
> +		if (driver_byte(rq->errors)&&  DRIVER_SENSE)
> +			__scsi_print_sense("alua std_inquiry", rq->sense,
> +					   rq->sense_len);
>   		h->senselen = rq->sense_len;
>   		err = SCSI_DH_IO;
>   	}
> @@ -190,9 +194,12 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
>
>   	err = blk_execute_rq(rq->q, NULL, rq, 1);
>   	if (err == -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: evpd inquiry failed with %x\n",
> -			    ALUA_DH_NAME, rq->errors);
> +		sdev_printk(KERN_INFO, sdev, "%s: evpd inquiry failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_show_result(rq->errors);
> +		if (driver_byte(rq->errors)&&  DRIVER_SENSE)
> +			__scsi_print_sense("alua vpd_inquiry", rq->sense,
> +					   rq->sense_len);
>   		h->senselen = rq->sense_len;
>   		err = SCSI_DH_IO;
>   	}
> @@ -229,9 +236,11 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
>
>   	err = blk_execute_rq(rq->q, NULL, rq, 1);
>   	if (err == -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: rtpg failed with %x\n",
> -			    ALUA_DH_NAME, rq->errors);
> +		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed\n", ALUA_DH_NAME);
> +		scsi_show_result(rq->errors);
> +		if (driver_byte(rq->errors)&&  DRIVER_SENSE)
> +			__scsi_print_sense("alua submit_rtpg", rq->sense,
> +					   rq->sense_len);
>   		h->senselen = rq->sense_len;
>   		err = SCSI_DH_IO;
>   	}

Hannes,

Did you get a chance to take a look at this patch?

Thanks, Rob
