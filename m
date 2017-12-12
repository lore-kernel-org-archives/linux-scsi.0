From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] NCR5380: Fix a possible sleep-in-atomic bug in
 NCR5380_poll_politely2
Date: Tue, 12 Dec 2017 14:38:57 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1712121429331.3@nippy.intranet>
References: <1513047037-18102-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513047037-18102-1-git-send-email-baijiaju1990@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Dec 2017, Jia-Ju Bai wrote:

> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> The kernel module may sleep under a spinlock.

The spinlock is always taken in irq mode, and the 
schedule_timeout_uninterruptible() is conditional on !irqs_disabled().

> The function call paths are:
> NCR5380_select (acquire the spinlock)
>   NCR5380_reselect
>     NCR5380_poll_politely
>       NCR5380_poll_politely2
>         schedule_timeout_uninterruptible --> may sleep
> 
> NCR5380_abort (acquire the spinlock)
>   do_abort
>     NCR5380_poll_politely
>       NCR5380_poll_politely2
>         schedule_timeout_uninterruptible --> may sleep
> 

Well, it's expected to sleep here, hence the "sleep for 1ms" comment.

(I notice that you left the comment unchanged in your "fix", was that an 
oversight?)

> To fix it, schedule_timeout_uninterruptible is replaced with mdelay.
> 
> This bug is found by my static analysis tool(DSAC) and checked by my 
> code review.
> 
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

NAK.

> ---
>  drivers/scsi/NCR5380.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 90ea0f5..4176aca 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -202,7 +202,7 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>  

Here's a little more context:

        if (irqs_disabled() || in_interrupt())
                return -ETIMEDOUT;

>  	/* Repeatedly sleep for 1 ms until deadline */
>  	while (time_is_after_jiffies(deadline)) {
> -		schedule_timeout_uninterruptible(1);
> +		mdelay(1);
>  		if ((NCR5380_read(reg1) & bit1) == val1)
>  			return 0;
>  		if ((NCR5380_read(reg2) & bit2) == val2)
> 

-- 
