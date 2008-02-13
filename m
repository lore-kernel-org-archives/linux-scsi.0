From: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 08:06:42 +0100
Message-ID: <47B29702.7050503@allied-internet.ag>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server077.de-nserver.de ([62.27.12.245]:42180 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYBMHOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 02:14:11 -0500
In-Reply-To: <47B1DA2A.1060904@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>

Hello!

I've tested this patch now - and it works fine. Now rmmod, halt and 
reboot also works.

Stefan Priebe


Boaz Harrosh schrieb:
> gdth _exit would first remove all cards then stop the timer
> and would not sync with the timer function. This caused a crash
> in gdth_timer() when module was unloaded.
> 
> del_timer_sync the timer before we delete the cards.
> 
> NOT YET TESTED
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/gdth.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 8eb78be..103280e 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -3793,6 +3793,8 @@ static void gdth_timeout(ulong data)
>      gdth_ha_str *ha;
>      ulong flags;
>  
> +    BUG_ON(list_empty(&gdth_instances));
> +
>      ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
> @@ -5146,8 +5148,6 @@ static void gdth_remove_one(gdth_ha_str *ha)
>  		ha->sdev = NULL;
>  	}
>  
> -	gdth_flush(ha);
> -
>  	if (shp->irq)
>  		free_irq(shp->irq,ha);
>  
> @@ -5245,14 +5245,15 @@ static void __exit gdth_exit(void)
>  {
>  	gdth_ha_str *ha;
>  
> -	list_for_each_entry(ha, &gdth_instances, list)
> -		gdth_remove_one(ha);
> +	unregister_chrdev(major,"gdth");
> +	unregister_reboot_notifier(&gdth_notifier);
>  
>  #ifdef GDTH_STATISTICS
> -	del_timer(&gdth_timer);
> +	del_timer_sync(&gdth_timer);
>  #endif
> -	unregister_chrdev(major,"gdth");
> -	unregister_reboot_notifier(&gdth_notifier);
> +
> +	list_for_each_entry(ha, &gdth_instances, list)
> +		gdth_remove_one(ha);
>  }
>  
>  module_init(gdth_init);
