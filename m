From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi_scan.c: bug fix: starget use after free issue
Date: Wed, 19 Jul 2006 10:22:30 -0400
Message-ID: <44BE4026.7050503@emulex.com>
References: <1150390560.29774.32.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:13288 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S964849AbWGSOWg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jul 2006 10:22:36 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k6JEMZYM008400
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2006 07:22:35 -0700 (PDT)
In-Reply-To: <1150390560.29774.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

FYI: This patch is NACK'd as it is superceeded by a patch proposed long
ago (2/23/06), which finally showed up in 2.6.17-rc1. See:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114072663121857&w=2

Note: this patch was corrected the reuse error w/o issue, but did not
address the reuse of the sysfs namespace. The other patch addresses
both.

-- james s

James Smart wrote:
> When reaping the starget, after all sdev's have been removed, the starget
> was queued for deletion via usercontext, but was left on the shost's
> __targets list. Another scanning thread can match the starget and use it, 
> causing reference after free problems.
> 
> This patch unlinks the starget at the same time it is scheduled for deletion.
> 
> -- james s
> 
> 
> Signed-off-by: James Smart <james.smart@emulex.com>
> 
> diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	2006-06-14 11:37:09.000000000 -0400
> +++ b/drivers/scsi/scsi_scan.c	2006-06-14 16:55:58.000000000 -0400
> @@ -415,7 +415,6 @@ static void scsi_target_reap_usercontext
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	if (shost->hostt->target_destroy)
>  		shost->hostt->target_destroy(starget);
> -	list_del_init(&starget->siblings);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	put_device(&starget->dev);
>  }
> @@ -439,6 +438,7 @@ void scsi_target_reap(struct scsi_target
>  	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
>  		BUG_ON(starget->state == STARGET_DEL);
>  		starget->state = STARGET_DEL;
> +		list_del_init(&starget->siblings);
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		execute_in_process_context(scsi_target_reap_usercontext,
>  					   starget, &starget->ew);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
