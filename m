From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri, 16 Oct 2015 13:24:46 +0200
Message-ID: <1444994686.19542.35.camel@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
	 <1444833036.2220.38.camel@HansenPartnership.com>
	 <1444833547.19542.21.camel@suse.de>
	 <1444837556.2220.43.camel@HansenPartnership.com>
	 <20151014181803.GA12497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151014181803.GA12497@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-10-14 at 11:18 -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2015 at 08:45:56AM -0700, James Bottomley wrote:
> > OK, so I really need you to separate the problems.  Fixing the bug

[..]

> 
> Johannes, can you test the patch below?

I've tested your patch and it doesn't show the lockup anymore, so far
so good. But it seems as if I have a problem in my test setup, because
I can't reproduce the bug on vanilla 4.3-rc5 either. I will ask the
original reporter if it is possible to test your patch on their side.

Appart from that it looks good to me (and much simpler than my changes)
.

> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389f..d3b34d8 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1158,31 +1158,23 @@ static void __scsi_remove_target(struct
> scsi_target *starget)
>  void scsi_remove_target(struct device *dev)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(dev->parent);
> -	struct scsi_target *starget, *last = NULL;
> +	struct scsi_target *starget;
>  	unsigned long flags;
>  
> -	/* remove targets being careful to lookup next entry before
> -	 * deleting the last
> -	 */
> +restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(starget, &shost->__targets, siblings) {
>  		if (starget->state == STARGET_DEL)
>  			continue;
>  		if (starget->dev.parent == dev || &starget->dev ==
> dev) {
> -			/* assuming new targets arrive at the end */
>  			kref_get(&starget->reap_ref);
>  			spin_unlock_irqrestore(shost->host_lock,
> flags);
> -			if (last)
> -				scsi_target_reap(last);
> -			last = starget;
>  			__scsi_remove_target(starget);
> -			spin_lock_irqsave(shost->host_lock, flags);
> +			scsi_target_reap(starget);
> +			goto restart;
>  		}
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> -
> -	if (last)
> -		scsi_target_reap(last);
>  }
>  EXPORT_SYMBOL(scsi_remove_target);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
