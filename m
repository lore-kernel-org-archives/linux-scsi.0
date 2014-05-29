From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH v2, repost] hpsa: remove unneeded loop
Date: Thu, 29 May 2014 09:51:28 -0500
Message-ID: <20140529145128.GO6970@beardog.cce.hp.com>
References: <53873DEB.1080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:30173 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbaE2OwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 10:52:19 -0400
Content-Disposition: inline
In-Reply-To: <53873DEB.1080504@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com

On Thu, May 29, 2014 at 04:02:19PM +0200, Tomas Henzl wrote:
> Originally this was first patch in a series, but while the  other patches
> were accepted, this one was forgotten.
> The code below is adapted for the latest sources.
> 
> The cmd_pool_bits is protected everywhere with a spinlock,
> we don't need the test_and_set_bit, set_bit is enough and the loop
> can be removed too.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 9a6e4a2..c8267f3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -4680,15 +4680,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&h->lock, flags);
> -	do {
> -		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> -		if (i == h->nr_cmds) {
> -			spin_unlock_irqrestore(&h->lock, flags);
> -			return NULL;
> -		}
> -	} while (test_and_set_bit
> -		 (i & (BITS_PER_LONG - 1),
> -		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
> +	i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> +	if (i == h->nr_cmds) {
> +		spin_unlock_irqrestore(&h->lock, flags);
> +		return NULL;
> +	}
> +	set_bit(i & (BITS_PER_LONG - 1), h->cmd_pool_bits + (i / BITS_PER_LONG));
>  	spin_unlock_irqrestore(&h->lock, flags);
>  
>  	c = h->cmd_pool + i;
> -- 
> 1.8.3.1
> 

I don't quite remember, but I think it was forgotten because I became
more interested in removing all the locks from the main i/o path of hpsa
for performance reasons (I have had a rather large patch series in the
works for quite a while now to do that, maybe it will be ready for 3.17,
we'll see.) So this looks ok, but if things go according to plan it won't
be relevant for very long.

-- steve

