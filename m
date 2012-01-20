From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: use find_first_zero_bit
Date: Fri, 20 Jan 2012 09:41:36 -0600
Message-ID: <20120120154136.GH21002@beardog.cce.hp.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com> <1327072528-8479-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:34319 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2ATPlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2012 10:41:39 -0500
Content-Disposition: inline
In-Reply-To: <1327072528-8479-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, iss_storagedev@hp.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Sat, Jan 21, 2012 at 12:15:27AM +0900, Akinobu Mita wrote:
> Use find_first_zero_bit to find the first cleared bit in a memory region.
> 
> This also includes the following minor changes.
> - Use bitmap_zero
> - Reduce unnecessary atomic bitops usage

Ack.

This isn't performance sensitive code though, hpsa_find_target_lun()
only gets called during device discovery when a multi-lun device
like a tape drive with an auto changer is encountered.

I tried it out and it doesn't conflict with any of the patches
I sent up yesterday, and it works with a tape drive/autochanger.

-- steve
 
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> Cc: iss_storagedev@hp.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/hpsa.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 7d14443..7f79ed8 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -577,21 +577,19 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
>  	int i, found = 0;
>  	DECLARE_BITMAP(lun_taken, HPSA_MAX_DEVICES);
>  
> -	memset(&lun_taken[0], 0, HPSA_MAX_DEVICES >> 3);
> +	bitmap_zero(lun_taken, HPSA_MAX_DEVICES);
>  
>  	for (i = 0; i < h->ndevices; i++) {
>  		if (h->dev[i]->bus == bus && h->dev[i]->target != -1)
> -			set_bit(h->dev[i]->target, lun_taken);
> +			__set_bit(h->dev[i]->target, lun_taken);
>  	}
>  
> -	for (i = 0; i < HPSA_MAX_DEVICES; i++) {
> -		if (!test_bit(i, lun_taken)) {
> -			/* *bus = 1; */
> -			*target = i;
> -			*lun = 0;
> -			found = 1;
> -			break;
> -		}
> +	i = find_first_zero_bit(lun_taken, HPSA_MAX_DEVICES);
> +	if (i < HPSA_MAX_DEVICES) {
> +		/* *bus = 1; */
> +		*target = i;
> +		*lun = 0;
> +		found = 1;
>  	}
>  	return !found;
>  }
> -- 
> 1.7.4.4
