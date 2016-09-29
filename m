From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Thu, 29 Sep 2016 07:46:57 +0200
Message-ID: <afae74e6-6bb6-aa3f-01c4-6c0b5558772d@suse.de>
References: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751568AbcI2Fq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 01:46:59 -0400
In-Reply-To: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/29/2016 01:45 AM, Bart Van Assche wrote:
> The code at the end of alua_rtpg_work() is as follows:
> 
> 	scsi_device_put(sdev);
> 	kref_put(&pg->kref, release_port_group);
> 
> Make sure that all code that queues the work item associated
> with alua_rtpg_work() holds both references.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 752b5c9..f7099e2 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -889,6 +889,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
>  		/* Do not queue if the worker is already running */
>  		if (!(pg->flags & ALUA_PG_RUNNING)) {
>  			kref_get(&pg->kref);
> +			scsi_device_get(sdev);
>  			start_queue = 1;
>  		}
>  	}
> 
Nack.

The scsi device reference tracks ->rtpg_sdev, not the queue item.
So we only need to take the scsi device reference if we're assigning a
new value to ->rtpg_sdev, which we are not.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
