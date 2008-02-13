From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 12:48:42 +0200
Message-ID: <47B2CB0A.7030802@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:39261 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBMKuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 05:50:19 -0500
In-Reply-To: <47B1DA2A.1060904@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>, Dave Milter <davemilter@gmail.com>

On Tue, Feb 12 2008 at 19:40 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> gdth _exit would first remove all cards then stop the timer
> and would not sync with the timer function. This caused a crash
> in gdth_timer() when module was unloaded.
> 
> del_timer_sync the timer before we delete the cards.
> 
> NOT YET TESTED
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>

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

James please put this patch in rc-fixes also. It has now been tested
by few people, and it solves a reproducible problem in the unloading
of the driver.

It was not yet confirmed by Andrew's reporter with the:
	+    if (list_empty(&gdth_instances))
	+	return;

at gdth_timer() In -mm tree. In my patch I have converted the if() to a 
BUG_ON because now it should not happen. But I figure it is not worse then 
what there is now, which is nothing.

With your recommendation I will push both patches to the stable branches
People have emailed me requesting it.

Thanks
Boaz
 
