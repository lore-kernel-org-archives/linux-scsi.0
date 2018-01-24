From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Use scsi-mq if it has been enabled
Date: Wed, 24 Jan 2018 01:29:00 -0500
Message-ID: <a569924a-259f-41dc-72a4-e03229a3c844@interlog.com>
References: <20180124003958.3945-1-bart.vanassche@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39054 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbeAXG3M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 01:29:12 -0500
In-Reply-To: <20180124003958.3945-1-bart.vanassche@wdc.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>

On 2018-01-23 07:39 PM, Bart Van Assche wrote:
> Since we want to remove the single queue code from the SCSI core
> at the appropriate time and since scsi-mq performs better than
> scsi-sq even when using only a single hardware queue, use scsi-mq
> if it has been enabled.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>

Acked: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a5986dae9020..40df3eea72c8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5782,7 +5782,7 @@ static int sdebug_driver_probe(struct device * dev)
>   	}
>   	/* Decide whether to tell scsi subsystem that we want mq */
>   	/* Following should give the same answer for each host */
> -	sdebug_mq_active = shost_use_blk_mq(hpnt) && (submit_queues > 1);
> +	sdebug_mq_active = shost_use_blk_mq(hpnt);
>   	if (sdebug_mq_active)
>   		hpnt->nr_hw_queues = submit_queues;
>   
> 
