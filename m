From: scameron@beardog.cce.hp.com
Subject: Re: [patch] [SCSI] hpsa: precedence bug in hpsa_wait_for_mode_change_ack()
Date: Mon, 7 Feb 2011 11:11:48 -0600
Message-ID: <20110207171148.GT9565@beardog.cce.hp.com>
References: <20110207165957.GG4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43740 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1BGRLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 12:11:50 -0500
Content-Disposition: inline
In-Reply-To: <20110207165957.GG4384@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, Feb 07, 2011 at 07:59:58PM +0300, Dan Carpenter wrote:
> '!' has higher precedence than '&'.  CFGTBL_ChangeReq is 0x1 so the
> original code is equivelent to if (!doorbell_value) {...
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 959eeb2..f46f92a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3591,7 +3591,7 @@ static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
>  		spin_lock_irqsave(&h->lock, flags);
>  		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
>  		spin_unlock_irqrestore(&h->lock, flags);
> -		if (!doorbell_value & CFGTBL_ChangeReq)
> +		if (!(doorbell_value & CFGTBL_ChangeReq))
>  			break;
>  		/* delay and try again */
>  		usleep_range(10000, 20000);

Thanks.  This looks correct.

-- steve

