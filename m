From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/3] hpsa: remove unneeded loop
Date: Mon, 26 Aug 2013 12:57:38 +0200
Message-ID: <521B34A2.9020003@redhat.com>
References: <51FA5E7A.9050000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3HZK6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 06:58:50 -0400
In-Reply-To: <51FA5E7A.9050000@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com

Hi James,

I've gotten mail that you have accepted patches 2/3 and 3/3 from this series.
This one has been accepted by Steve also, so please consider taking also this 1/3.

Thanks, Tomas



On 08/01/2013 03:11 PM, Tomas Henzl wrote:

> From: Tomas Henzl <thenzl@redhat.com>
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
> index 796482b..d7df01e 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2662,15 +2662,12 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
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
>  	h->nr_allocs++;
>  	spin_unlock_irqrestore(&h->lock, flags);
>  

