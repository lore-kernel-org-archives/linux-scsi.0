From: Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 28/38] Externalize string buffer for printk
Date: Tue, 30 Sep 2014 18:39:32 +0200
Message-ID: <20140930163931.GG2707@dhcp128.suse.cz>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-29-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411991947-130166-29-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 29-09-14 13:58:57, Hannes Reinecke wrote:
> This patch splits off the actual logging from vprintk_emit()
> into printk_emit_string(), with vprintk_emit() just being a
> simple wrapper for formatting the message into a
> static buffer.
> 
> With that the caller can pass in a local buffer for
> printk_emit_string() without increasing the overall stack size.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: LKML <linux-kernel@vger.kernel.org>

Adding Andrew into CC here as well.

There is one potential problem, see below.

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/linux/printk.h |  5 +++++
>  kernel/printk/printk.c | 36 ++++++++++++++++++++++++------------
>  2 files changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index d78125f..9639900 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -130,6 +130,11 @@ int vprintk_emit(int facility, int level,
>  		 const char *dict, size_t dictlen,
>  		 const char *fmt, va_list args);
>  
> +asmlinkage
> +int printk_emit_string(int facility, int level,
> +		       const char *dict, size_t dictlen,
> +		       char *textbuf, size_t text_len);
> +
>  asmlinkage __printf(1, 0)
>  int vprintk(const char *fmt, va_list args);
>  
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index d13675e..303a1fe 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1618,22 +1618,11 @@ asmlinkage int vprintk_emit(int facility, int level,
>  			    const char *dict, size_t dictlen,
>  			    const char *fmt, va_list args)
>  {
> -	static int recursion_bug;
>  	static char textbuf[LOG_LINE_MAX];
>
>  	char *text = textbuf;
>  	size_t text_len = 0;
> -	enum log_flags lflags = 0;
> -	unsigned long flags;
> -	int this_cpu;
> -	int printed_len = 0;
> -	bool in_sched = false;
> -	/* cpu currently holding logbuf_lock in this function */
> -	static volatile unsigned int logbuf_cpu = UINT_MAX;
>  
>  	if (level == SCHED_MESSAGE_LOGLEVEL) {
> -		level = -1;
> -		in_sched = true;
> -
>  		/*
>  		 * The printf needs to come first; we need the syslog
>  		 * prefix which might be passed-in as a parameter.
> @@ -1644,6 +1633,24 @@ asmlinkage int vprintk_emit(int facility, int level,
>  
>  	text_len += vscnprintf(text + text_len,
>  			       sizeof(textbuf) - text_len, fmt, args);
> +	return printk_emit_string(facility, level, dict, dictlen,
> +				  textbuf, text_len);
> +}
> +EXPORT_SYMBOL(vprintk_emit);
> +
> +asmlinkage int printk_emit_string(int facility, int level,
> +				  const char *dict, size_t dictlen,
> +				  char *textbuf, size_t text_len)
> +{
> +	static int recursion_bug;
> +	char *text = textbuf;
> +	enum log_flags lflags = 0;
> +	unsigned long flags;
> +	int this_cpu;
> +	int printed_len = 0;
> +	bool in_sched = false;
> +	/* cpu currently holding logbuf_lock in this function */
> +	static volatile unsigned int logbuf_cpu = UINT_MAX;

We should make sure that text_len is lower or equal LOG_LINE_MAX.

I am afraid that printk() code is not able to process longer
lines. For example, syslog_print() does:

       text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);

Then it calls msg_print_text() that works with entire messages. So,
any longer message would freeze syslog_print() because it would newer
fit into the buffer.

I guess that there are more locations like this.

Maybe, we should make LOG_LINE_MAX public, so it could be used on the
other location either to allocate the buffer or to check the size.

Best Regards,
Petr
  
>  	boot_delay_msec(level);
>  	printk_delay();
> @@ -1652,6 +1659,11 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	local_irq_save(flags);
>  	this_cpu = smp_processor_id();
>  
> +	if (level == SCHED_MESSAGE_LOGLEVEL) {
> +		level = -1;
> +		in_sched = true;
> +	}
> +
>  	/*
>  	 * Ouch, printk recursed into itself!
>  	 */
> @@ -1789,7 +1801,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  
>  	return printed_len;
>  }
> -EXPORT_SYMBOL(vprintk_emit);
> +EXPORT_SYMBOL(printk_emit_string);
>  
>  asmlinkage int vprintk(const char *fmt, va_list args)
>  {
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
