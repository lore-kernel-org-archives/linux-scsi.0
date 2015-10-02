From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri, 2 Oct 2015 05:49:03 -0700
Message-ID: <20151002124903.GA11987@infradead.org>
References: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
>  		if (starget->state == STARGET_DEL)
>  			continue;
>  		if (starget->dev.parent == dev || &starget->dev == dev) {
>  			/* assuming new targets arrive at the end */

Now that the last variable is gone this comments isn't needed.

>  			kref_get(&starget->reap_ref);
>  			spin_unlock_irqrestore(shost->host_lock, flags);
> -			if (last)
> -				scsi_target_reap(last);
> -			last = starget;
> +
>  			__scsi_remove_target(starget);
> +			list_move_tail(&starget->siblings, &reap_list);
>  			spin_lock_irqsave(shost->host_lock, flags);
>  		}

What makes the list_move save after dropping host_lock?  I think this
needs to be changed to not drop the host_lock and change
__scsi_remove_target to expect host_lock held to be safe. 
