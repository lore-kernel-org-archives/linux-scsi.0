From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: fix missing kref_put() in alua_rtpg_work()
Date: Fri, 28 Oct 2016 10:27:34 +0200
Message-ID: <28a15456-5431-14bb-26e7-3efa5e68847e@suse.de>
References: <1477641247-9632-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58655 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754146AbcJ1I1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 04:27:43 -0400
In-Reply-To: <1477641247-9632-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

On 10/28/2016 09:54 AM, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> Reference count of pg leaks in alua_rtpg_work() since kref_put()
> is not called to decrease the reference count of pg when the
> condition pg->rtpg_sdev==NULL satisfied (actually it is easy to
> satisfy), it would cause memory of pg leakage.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 241829e..f375167 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -793,6 +793,7 @@ static void alua_rtpg_work(struct work_struct *work)
>  		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
>  		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
>  		spin_unlock_irqrestore(&pg->lock, flags);
> +		kref_put(&pg->kref, release_port_group);
>  		return;
>  	}
>  	if (pg->flags & ALUA_SYNC_STPG)
> 
Correct.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
