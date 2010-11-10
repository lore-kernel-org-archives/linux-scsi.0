From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [PATCH] fix the poll method of bsg file operations in Block
 layer SCSI generic driver
Date: Wed, 10 Nov 2010 11:48:53 -0300
Message-ID: <1289400533.2208.6.camel@cowboy>
References: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-11-10 at 21:58 +0800, Hillf Danton wrote:
> Though it looks like a typo, the check for POLLOUT is computed incorrectly.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/block/bsg.c	2010-11-10 21:40:30.000000000 +0800
> @@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
>  	if (!list_empty(&bd->done_list))
>  		mask |= POLLIN | POLLRDNORM;
>  	if (bd->queued_cmds >= bd->max_queue)
> +		;
> +	else
>  		mask |= POLLOUT;
>  	spin_unlock_irq(&bd->lock);

How about something more like this:

diff --git a/block/bsg.c b/block/bsg.c
index f20d6a7..2663db3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -870,7 +870,7 @@ static unsigned int bsg_poll(struct file *file,
poll_table *wait)
        spin_lock_irq(&bd->lock);
        if (!list_empty(&bd->done_list))
                mask |= POLLIN | POLLRDNORM;
-       if (bd->queued_cmds >= bd->max_queue)
+       if (bd->queued_cmds < bd->max_queue)
                mask |= POLLOUT;
        spin_unlock_irq(&bd->lock);


Thanks,
Davidlohr



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
