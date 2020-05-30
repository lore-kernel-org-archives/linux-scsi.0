Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98D3C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EFED20678
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgE3Ja2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 05:30:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:52562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgE3Ja2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 May 2020 05:30:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 222BBAEC2;
        Sat, 30 May 2020 09:30:27 +0000 (UTC)
Subject: Re: [PATCH 1/1] scsi: scsi_forget_host() shuffle
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        bvanassche@acm.org
References: <20200529221442.8404-1-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <95b3d465-6fd5-b15d-5f04-a1b7cfbbad09@suse.de>
Date:   Sat, 30 May 2020 11:30:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529221442.8404-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/30/20 12:14 AM, Douglas Gilbert wrote:
> This patch leaves me a bit uneasy but it does cure the crash
> that occurs in this function. xarray iterators are pretty safe
> _unless_ something deletes the parent node holding the
> collection. The problem seems to be these nested loops do not
> _explicitly_ remove the starget object. That is done magically
> at the sdev level on the removal of the last sdev in a starget.
> And that is half an iteration too soon! Hence the shuffle which
> isn't a great solution. The magical starget removal is wrong IMO
> and this will burn us elsewhere, I suspect.
> 
> Thes patch is on top of Hannes Reinecke's "[PATCHv4 0/5] scsi:
> use xarray for devices and targets" patchset.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/scsi_scan.c | 47 +++++++++++++++++++++++++++++++---------
>   1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 0a344653487d..e378f03d0297 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1858,25 +1858,52 @@ void scsi_scan_host(struct Scsi_Host *shost)
>   }
>   EXPORT_SYMBOL(scsi_scan_host);
>   
> +static void scsi_forget_host_inner(struct Scsi_Host *shost,
> +				   struct scsi_target *starg,
> +				   unsigned long *flagsp)
> +{
> +	struct scsi_device *sdev;
> +	struct scsi_device *prev_sdev = NULL;
> +	unsigned long lun_id;
> +
> +	xa_for_each(&starg->__devices, lun_id, sdev) {
> +		if (sdev->sdev_state == SDEV_DEL)
> +			continue;
> +		if (!prev_sdev) {
> +			prev_sdev = sdev;
> +			continue;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, *flagsp);
> +		__scsi_remove_device(prev_sdev);
> +		spin_lock_irqsave(shost->host_lock, *flagsp);
> +		prev_sdev = sdev;
> +	}
> +	if (prev_sdev) {
> +		spin_unlock_irqrestore(shost->host_lock, *flagsp);
> +		__scsi_remove_device(prev_sdev);
> +		spin_lock_irqsave(shost->host_lock, *flagsp);
> +	}
> +}
> +
> +/* N.B. Keeping iteration one step ahead of destruction point */
>   void scsi_forget_host(struct Scsi_Host *shost)
>   {
>   	struct scsi_target *starget;
> -	struct scsi_device *sdev;
> +	struct scsi_target *prev_starget = NULL;
>   	unsigned long flags;
> -	unsigned long tid = 0;
> +	unsigned long tid;
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	xa_for_each(&shost->__targets, tid, starget) {
> -		unsigned long lun_id = 0;
> -
> -		xa_for_each(&starget->__devices, lun_id, sdev) {
> -			if (sdev->sdev_state == SDEV_DEL)
> -				continue;
> -			spin_unlock_irqrestore(shost->host_lock, flags);
> -			__scsi_remove_device(sdev);
> -			spin_lock_irqsave(shost->host_lock, flags);
> +		if (!prev_starget) {
> +			prev_starget = starget;
> +			continue;
>   		}
> +		scsi_forget_host_inner(shost, prev_starget, &flags);
> +		prev_starget = starget;
>   	}
> +	if (prev_starget)
> +		scsi_forget_host_inner(shost, prev_starget, &flags);
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>   
> 
This is probably easier:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0a344653487d..fb0b6710b138 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1868,7 +1868,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
         spin_lock_irqsave(shost->host_lock, flags);
         xa_for_each(&shost->__targets, tid, starget) {
                 unsigned long lun_id = 0;
-
+               kref_get(&starget->reap_ref);
                 xa_for_each(&starget->__devices, lun_id, sdev) {
                         if (sdev->sdev_state == SDEV_DEL)
                                 continue;
@@ -1876,6 +1876,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
                         __scsi_remove_device(sdev);
                         spin_lock_irqsave(shost->host_lock, flags);
                 }
+               scsi_target_reap(starget);
         }
         spin_unlock_irqrestore(shost->host_lock, flags);
  }

But yeah, this 'implicit target destroy' is an abomination.
Actually, I'm planning on using xa_cmpxchg when deleting elements to 
eliminate any confusion on who's responsible for removing it from the 
xarray; the current code has a design flaw in that it does the iteration 
first, and then after various layers and indirections it does the 
removal from the iteration.
What _should_ have happened is that you do an iteration which does 
implicitly removes it from the list, and _then_ go through the various 
hoops to actually remove the device.

But after the xarray series has stabilized :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
