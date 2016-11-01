From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Tue, 1 Nov 2016 17:59:00 +0100
Message-ID: <04dca258-7dfe-aaae-0fef-ce46cef14f70@suse.de>
References: <bf51a27f-d99f-4a43-867b-0b683ec1784d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbcKAQ7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 12:59:07 -0400
In-Reply-To: <bf51a27f-d99f-4a43-867b-0b683ec1784d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: tang.junhui@zte.com.cn, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/01/2016 03:19 PM, Bart Van Assche wrote:
> The code at the end of alua_rtpg_work() is as follows:
>
> 	scsi_device_put(sdev);
> 	kref_put(&pg->kref, release_port_group);
>
> In other words, alua_rtpg_queue() must hold an sdev reference and
> a pg reference before queueing rtpg work. If no rtpg work is queued
> no additional references should be held when alua_rtpg_queue()
> returns. If no rtpg work is queued, ensure that alua_rtpg_queue()
> only gives up the sdev reference if that reference was obtained by
> the same alua_rtpg_queue() call.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Tang Junhui <tang.junhui@zte.com.cn>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f375167..7bb2068 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -891,6 +891,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  		/* Do not queue if the worker is already running */
>  		if (!(pg->flags & ALUA_PG_RUNNING)) {
>  			kref_get(&pg->kref);
> +			sdev = NULL;
>  			start_queue = 1;
>  		}
>  	}
> @@ -902,7 +903,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  	if (start_queue &&
>  	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
>  				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
> -		scsi_device_put(sdev);
> +		if (sdev)
> +			scsi_device_put(sdev);
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  }
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
