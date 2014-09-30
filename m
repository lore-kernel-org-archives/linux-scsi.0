From: Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 27/38] Rearrange buffer formatting in printk()
Date: Tue, 30 Sep 2014 18:16:20 +0200
Message-ID: <20140930161619.GF2707@dhcp128.suse.cz>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-28-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411991947-130166-28-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 29-09-14 13:58:56, Hannes Reinecke wrote:
> Move buffer formatting to the start of the function as it
> doesn't require to be done under any locks.
> No functional change, required by the next patch.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: LKML <linux-kernel@vger.kernel.org>

printk stuff is maintained by Andrew in mm tree, so adding him into CC.

> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

I do not see any obvious problem. Just note that
[sched_delayed] has already been removed in -mm tree. You might
want to base this patch on top of the commit 460d73c35ffa17979422290
("printk: git rid of [sched_delayed] message for printk_deferred")
from linux-next.

Best Regards,
Petr

> ---
>  kernel/printk/printk.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 1ce7706..d13675e 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1633,8 +1633,18 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	if (level == SCHED_MESSAGE_LOGLEVEL) {
>  		level = -1;
>  		in_sched = true;
> +
> +		/*
> +		 * The printf needs to come first; we need the syslog
> +		 * prefix which might be passed-in as a parameter.
> +		 */
> +		text_len = scnprintf(text, sizeof(textbuf),
> +				     KERN_WARNING "[sched_delayed] ");
>  	}
>  
> +	text_len += vscnprintf(text + text_len,
> +			       sizeof(textbuf) - text_len, fmt, args);
> +
>  	boot_delay_msec(level);
>  	printk_delay();
>  
> @@ -1676,17 +1686,6 @@ asmlinkage int vprintk_emit(int facility, int level,
>  					 strlen(recursion_msg));
>  	}
>  
> -	/*
> -	 * The printf needs to come first; we need the syslog
> -	 * prefix which might be passed-in as a parameter.
> -	 */
> -	if (in_sched)
> -		text_len = scnprintf(text, sizeof(textbuf),
> -				     KERN_WARNING "[sched_delayed] ");
> -
> -	text_len += vscnprintf(text + text_len,
> -			       sizeof(textbuf) - text_len, fmt, args);
> -
>  	/* mark and strip a trailing newline */
>  	if (text_len && text[text_len-1] == '\n') {
>  		text_len--;
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
