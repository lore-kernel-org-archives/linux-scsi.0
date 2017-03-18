From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi_dh_alua: Warn if the first argument of
 alua_rtpg_queue() is NULL
Date: Sat, 18 Mar 2017 12:19:44 +0100
Message-ID: <901eca9c-db14-754d-d77f-4f1665fac8d7@suse.de>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
 <20170318000203.7469-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdCRLdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Mar 2017 07:33:41 -0400
In-Reply-To: <20170318000203.7469-4-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>

On 03/18/2017 01:02 AM, Bart Van Assche wrote:
> Callers must provide a valid port group to alua_rtpg_queue().
> Issue a kernel warning if that is not the case.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index b6849d3ecefe..c01b47e5b55a 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -876,7 +876,7 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>  	unsigned long flags;
>  	struct workqueue_struct *alua_wq = kaluad_wq;
>  
> -	if (!pg || scsi_device_get(sdev))
> +	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
>  		return false;
>  
>  	spin_lock_irqsave(&pg->lock, flags);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
