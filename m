From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] scsi_remove_target: fix softlockup regression on hot remove
Date: Wed, 29 Aug 2012 09:40:12 +0800
Message-ID: <8B83483643A64D46ABC5AB0484E70B1C@usish.com.cn>
References: <20120829000257.25796.41641.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45356 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2H2BkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 21:40:15 -0400
In-Reply-To: <20120829000257.25796.41641.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <djbw@fb.com>, JBottomley@parallels.com
Cc: 'John Drescher' <drescherjm@gmail.com>, linux-scsi@vger.kernel.org

Hi Dan,

This fix should go into stable tree too, as I know several stable tree
already include commit 3b661a9. Maybe James can add stable cc.

Best regards!

Jack
> John reports:
>  BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
>  [..]
>  Call Trace:
>   [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
>   [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
>   [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
>   [<ffffffff81421e35>] sas_port_delete+0x25/0x160
>   [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270
> 
> ...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan
race".
> 
> Don't restart lookup of more stargets in the multi-target case, just
> arrange to traverse the list once, on the assumption that new targets
> are always added at the end.  There is no guarantee that the target will
> change state in scsi_target_reap() so we can end up spinning if we
> restart.
> 
> LKML-Reference:
> <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
> Reported-by: John Drescher <drescherjm@gmail.com>
> Tested-by: John Drescher <drescherjm@gmail.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
>  drivers/scsi/scsi_sysfs.c |   30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 093d4f6..ce5224c 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1031,33 +1031,31 @@ static void __scsi_remove_target(struct
scsi_target
> *starget)
>  void scsi_remove_target(struct device *dev)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(dev->parent);
> -	struct scsi_target *starget, *found;
> +	struct scsi_target *starget, *last = NULL;
>  	unsigned long flags;
> 
> - restart:
> -	found = NULL;
> +	/* remove targets being careful to lookup next entry before
> +	 * deleting the last
> +	 */
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(starget, &shost->__targets, siblings) {
>  		if (starget->state == STARGET_DEL)
>  			continue;
>  		if (starget->dev.parent == dev || &starget->dev == dev) {
> -			found = starget;
> -			found->reap_ref++;
> -			break;
> +			/* assuming new targets arrive at the end */
> +			starget->reap_ref++;
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			if (last)
> +				scsi_target_reap(last);
> +			last = starget;
> +			__scsi_remove_target(starget);
> +			spin_lock_irqsave(shost->host_lock, flags);
>  		}
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> -	if (found) {
> -		__scsi_remove_target(found);
> -		scsi_target_reap(found);
> -		/* in the case where @dev has multiple starget children,
> -		 * continue removing.
> -		 *
> -		 * FIXME: does such a case exist?
> -		 */
> -		goto restart;
> -	}
> +	if (last)
> +		scsi_target_reap(last);
>  }
>  EXPORT_SYMBOL(scsi_remove_target);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

