From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 26/38] seq_buf: Move the seq_buf code to lib/
Date: Mon, 29 Sep 2014 10:04:38 -0400
Message-ID: <20140929100438.36abd4ef@gandalf.local.home>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
	<1411991947-130166-27-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37819 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753313AbaI2OFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 10:05:49 -0400
In-Reply-To: <1411991947-130166-27-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Mon, 29 Sep 2014 13:58:55 +0200
Hannes Reinecke <hare@suse.de> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The seq_buf functions are rather useful outside of tracing. Instead
> of having it be dependent on CONFIG_TRACING, move the code into lib/
> and allow other users to have access to it even when tracing is not
> configured.
> 
> The seq_buf utility is similar to the seq_file utility, but instead of
> writing sending data back up to userland, it writes it into a buffer
> defined at seq_buf_init(). This allows us to send a descriptor around
> that writes printf() formatted strings into it that can be retrieved
> later.
> 
> It is currently used by the tracing facility for such things like trace
> events to convert its binary saved data in the ring buffer into an
> ASCII human readable context to be displayed in /sys/kernel/debug/trace.
> 
> It can also be used for doing NMI prints safely from NMI context into
> the seq_buf and retrieved later and dumped to printk() safely. Doing
> printk() from an NMI context is dangerous because an NMI can preempt
> a current printk() and deadlock on it.
> 
> Link: http://lkml.kernel.org/p/20140619213952.058255809@goodmis.org

I don't know where this is going, but I'm currently rewriting this
code. Please don't add it yet to the kernel yet. I'm working on getting
seq_buf and seq_file to be more inlined with each other. A much better
sell if we can remove code with this change.

-- Steve

> 
> Acked-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/Makefile  |   1 -
>  kernel/trace/seq_buf.c | 348 -------------------------------------------------
>  lib/Makefile           |   2 +-
>  lib/seq_buf.c          | 348 +++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/trace_seq.c        | 303 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 652 insertions(+), 350 deletions(-)
>  delete mode 100644 kernel/trace/seq_buf.c
>  create mode 100644 lib/seq_buf.c
>  create mode 100644 lib/trace_seq.c
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index edc98c7..67d6369 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -29,7 +29,6 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
>  obj-$(CONFIG_TRACING) += trace.o
>  obj-$(CONFIG_TRACING) += trace_output.o
>  obj-$(CONFIG_TRACING) += trace_seq.o
> -obj-$(CONFIG_TRACING) += seq_buf.o
>  obj-$(CONFIG_TRACING) += trace_stat.o
>  obj-$(CONFIG_TRACING) += trace_printk.o
>  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> deleted file mode 100644
> index 5c3c65b..0000000
> --- a/kernel/trace/seq_buf.c
> +++ /dev/null
> @@ -1,348 +0,0 @@
> -/*
> - * seq_buf.c
> - *
> - * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> - *
> - * The seq_buf is a handy tool that allows you to pass a descriptor around
> - * to a buffer that other functions can write to. It is similar to the
> - * seq_file functionality but has some differences.
> - *
> - * To use it, the seq_buf must be initialized with seq_buf_init().
> - * This will set up the counters within the descriptor. You can call
> - * seq_buf_init() more than once to reset the seq_buf to start
> - * from scratch.
> - *
> - */
> -#include <linux/uaccess.h>
> -#include <linux/seq_file.h>
> -#include <linux/seq_buf.h>
> -
> -/* How much buffer is left on the seq_buf? */
> -#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> -
> -/* How much buffer is written? */
> -#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
> -
> -static inline void seq_buf_check_len(struct seq_buf *s)
> -{
> -	if (unlikely(s->len > (s->size - 1))) {
> -		s->len = s->size - 1;
> -		s->overflow = 1;
> -	}
> -}
> -
> -/**
> - * seq_buf_print_seq - move the contents of seq_buf into a seq_file
> - * @m: the seq_file descriptor that is the destination
> - * @s: the seq_buf descriptor that is the source.
> - *
> - * Returns zero on success, non zero otherwise
> - */
> -int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
> -{
> -	unsigned int len = SEQ_BUF_USED(s);
> -
> -	return seq_write(m, s->buffer, len);
> -}
> -
> -/**
> - * seq_buf_printf - sequence printing of trace information
> - * @s: seq_buf descriptor
> - * @fmt: printf format string
> - *
> - * Writes a printf() format into the sequence buffer.
> - *
> - * Returns number of bytes written.
> - */
> -int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
> -{
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	va_list ap;
> -	int ret;
> -
> -	WARN_ON((int)len < 0);
> -	va_start(ap, fmt);
> -	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> -	va_end(ap);
> -
> -	s->len += ret;
> -
> -	seq_buf_check_len(s);
> -
> -	return ret;
> -}
> -
> -/**
> - * seq_buf_bitmask - write a bitmask array in its ASCII representation
> - * @s:		seq_buf descriptor
> - * @maskp:	points to an array of unsigned longs that represent a bitmask
> - * @nmaskbits:	The number of bits that are valid in @maskp
> - *
> - * Writes a ASCII representation of a bitmask string into @s.
> - *
> - * Returns the number of bytes written.
> - */
> -int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> -		    int nmaskbits)
> -{
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	int ret;
> -
> -	WARN_ON((int)len < 0);
> -	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> -	s->len += ret;
> -	seq_buf_check_len(s);
> -
> -	return ret;
> -}
> -
> -/**
> - * seq_buf_vprintf - write vprintf style into the sequence buffer
> - * @s: seq_buf descriptor
> - * @fmt: printf format string
> - *
> - * Write a vprintf() style into the sequence buffer.
> - *
> - * Returns the number of bytes written.
> - */
> -int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
> -{
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	int ret;
> -
> -	if (WARN_ON((int)len < 0))
> -		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
> -	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> -	s->len += ret;
> -	seq_buf_check_len(s);
> -
> -	return len;
> -}
> -
> -/**
> - * seq_buf_bprintf - Write the printf string from binary arguments
> - * @s: seq_buf descriptor
> - * @fmt: The format string for the @binary arguments
> - * @binary: The binary arguments for @fmt.
> - *
> - * When recording in a fast path, a printf may be recorded with just
> - * saving the format and the arguments as they were passed to the
> - * function, instead of wasting cycles converting the arguments into
> - * ASCII characters. Instead, the arguments are saved in a 32 bit
> - * word array that is defined by the format string constraints.
> - *
> - * This function will take the format and the binary array and finish
> - * the conversion into the ASCII string within the buffer.
> - *
> - * Returns number of bytes written.
> - */
> -int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
> -{
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	int ret;
> -
> -	if (WARN_ON((int)len < 0))
> -		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
> -	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> -	s->len += ret;
> -	seq_buf_check_len(s);
> -
> -	return len;
> -}
> -
> -/**
> - * seq_buf_puts - sequence printing of simple string
> - * @s: seq_buf descriptor
> - * @str: simple string to record
> - *
> - * Copy a simple string into the sequence buffer.
> - *
> - * Returns number of bytes written.
> - */
> -int seq_buf_puts(struct seq_buf *s, const char *str)
> -{
> -	unsigned int len = strlen(str);
> -
> -	if (len > SEQ_BUF_LEFT(s)) {
> -		s->overflow = 1;
> -		len = SEQ_BUF_LEFT(s);
> -	}
> -
> -	memcpy(s->buffer + s->len, str, len);
> -	s->len += len;
> -	WARN_ON(s->len > (s->size - 1));
> -
> -	return len;
> -}
> -
> -/**
> - * seq_buf_putc - sequence printing of simple character
> - * @s: seq_buf descriptor
> - * @c: simple character to record
> - *
> - * Copy a single character into the sequence buffer.
> - *
> - * Returns 1 if the character was written, 0 otherwise.
> - */
> -int seq_buf_putc(struct seq_buf *s, unsigned char c)
> -{
> -	if (SEQ_BUF_LEFT(s) < 1) {
> -		s->overflow = 1;
> -		return 0;
> -	}
> -
> -	s->buffer[s->len++] = c;
> -	WARN_ON(s->len > (s->size - 1));
> -
> -	return 1;
> -}
> -
> -/**
> - * seq_buf_putmem - write raw data into the sequenc buffer
> - * @s: seq_buf descriptor
> - * @mem: The raw memory to copy into the buffer
> - * @len: The length of the raw memory to copy (in bytes)
> - *
> - * There may be cases where raw memory needs to be written into the
> - * buffer and a strcpy() would not work. Using this function allows
> - * for such cases.
> - *
> - * Returns the number of bytes written in the buffer.
> - */
> -int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
> -{
> -	if (len > SEQ_BUF_LEFT(s)) {
> -		s->overflow = 1;
> -		len = SEQ_BUF_LEFT(s);
> -	}
> -
> -	memcpy(s->buffer + s->len, mem, len);
> -	s->len += len;
> -	WARN_ON(s->len > (s->size - 1));
> -
> -	return len;
> -}
> -
> -#define MAX_MEMHEX_BYTES	8U
> -#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> -
> -/**
> - * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
> - * @s: seq_buf descriptor
> - * @mem: The raw memory to write its hex ASCII representation of
> - * @len: The length of the raw memory to copy (in bytes)
> - *
> - * This is similar to seq_buf_putmem() except instead of just copying the
> - * raw memory into the buffer it writes its ASCII representation of it
> - * in hex characters.
> - *
> - * Returns how much it wrote to the buffer.
> - */
> -int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> -		       unsigned int len)
> -{
> -	unsigned char hex[HEX_CHARS];
> -	const unsigned char *data = mem;
> -	unsigned int start_len;
> -	int i, j;
> -	int cnt = 0;
> -
> -	while (len) {
> -		start_len = min(len, HEX_CHARS - 1);
> -#ifdef __BIG_ENDIAN
> -		for (i = 0, j = 0; i < start_len; i++) {
> -#else
> -		for (i = start_len-1, j = 0; i >= 0; i--) {
> -#endif
> -			hex[j++] = hex_asc_hi(data[i]);
> -			hex[j++] = hex_asc_lo(data[i]);
> -		}
> -		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> -			break;
> -
> -		/* j increments twice per loop */
> -		len -= j / 2;
> -		hex[j++] = ' ';
> -
> -		cnt += seq_buf_putmem(s, hex, j);
> -	}
> -	return cnt;
> -}
> -
> -/**
> - * seq_buf_path - copy a path into the sequence buffer
> - * @s: seq_buf descriptor
> - * @path: path to write into the sequence buffer.
> - *
> - * Write a path name into the sequence buffer.
> - *
> - * Returns the number of bytes written into the buffer.
> - */
> -int seq_buf_path(struct seq_buf *s, const struct path *path)
> -{
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	unsigned char *p;
> -	unsigned int start = s->len;
> -
> -	WARN_ON((int)len < 0);
> -	p = d_path(path, s->buffer + s->len, len);
> -	if (!IS_ERR(p)) {
> -		p = mangle_path(s->buffer + s->len, p, "\n");
> -		if (p) {
> -			s->len = p - s->buffer;
> -	WARN_ON(s->len > (s->size - 1));
> -			return s->len - start;
> -		}
> -	} else {
> -		s->buffer[s->len++] = '?';
> -	WARN_ON(s->len > (s->size - 1));
> -		return s->len - start;
> -	}
> -
> -	s->overflow = 1;
> -	return 0;
> -}
> -
> -/**
> - * seq_buf_to_user - copy the squence buffer to user space
> - * @s: seq_buf descriptor
> - * @ubuf: The userspace memory location to copy to
> - * @cnt: The amount to copy
> - *
> - * Copies the sequence buffer into the userspace memory pointed to
> - * by @ubuf. It starts from the last read position (@s->readpos)
> - * and writes up to @cnt characters or till it reaches the end of
> - * the content in the buffer (@s->len), which ever comes first.
> - *
> - * On success, it returns a positive number of the number of bytes
> - * it copied.
> - *
> - * On failure it returns -EBUSY if all of the content in the
> - * sequence has been already read, which includes nothing in the
> - * sequenc (@s->len == @s->readpos).
> - *
> - * Returns -EFAULT if the copy to userspace fails.
> - */
> -int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
> -{
> -	int len;
> -	int ret;
> -
> -	if (!cnt)
> -		return 0;
> -
> -	if (s->len <= s->readpos)
> -		return -EBUSY;
> -
> -	len = s->len - s->readpos;
> -	if (cnt > len)
> -		cnt = len;
> -	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> -	if (ret == cnt)
> -		return -EFAULT;
> -
> -	cnt -= ret;
> -
> -	s->readpos += cnt;
> -	return cnt;
> -}
> diff --git a/lib/Makefile b/lib/Makefile
> index d6b4bc4..b2b0572 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> -	 earlycpio.o
> +	 earlycpio.o seq_buf.o
>  
>  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> new file mode 100644
> index 0000000..5c3c65b
> --- /dev/null
> +++ b/lib/seq_buf.c
> @@ -0,0 +1,348 @@
> +/*
> + * seq_buf.c
> + *
> + * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + * The seq_buf is a handy tool that allows you to pass a descriptor around
> + * to a buffer that other functions can write to. It is similar to the
> + * seq_file functionality but has some differences.
> + *
> + * To use it, the seq_buf must be initialized with seq_buf_init().
> + * This will set up the counters within the descriptor. You can call
> + * seq_buf_init() more than once to reset the seq_buf to start
> + * from scratch.
> + *
> + */
> +#include <linux/uaccess.h>
> +#include <linux/seq_file.h>
> +#include <linux/seq_buf.h>
> +
> +/* How much buffer is left on the seq_buf? */
> +#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> +
> +/* How much buffer is written? */
> +#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
> +
> +static inline void seq_buf_check_len(struct seq_buf *s)
> +{
> +	if (unlikely(s->len > (s->size - 1))) {
> +		s->len = s->size - 1;
> +		s->overflow = 1;
> +	}
> +}
> +
> +/**
> + * seq_buf_print_seq - move the contents of seq_buf into a seq_file
> + * @m: the seq_file descriptor that is the destination
> + * @s: the seq_buf descriptor that is the source.
> + *
> + * Returns zero on success, non zero otherwise
> + */
> +int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
> +{
> +	unsigned int len = SEQ_BUF_USED(s);
> +
> +	return seq_write(m, s->buffer, len);
> +}
> +
> +/**
> + * seq_buf_printf - sequence printing of trace information
> + * @s: seq_buf descriptor
> + * @fmt: printf format string
> + *
> + * Writes a printf() format into the sequence buffer.
> + *
> + * Returns number of bytes written.
> + */
> +int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	va_list ap;
> +	int ret;
> +
> +	WARN_ON((int)len < 0);
> +	va_start(ap, fmt);
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> +	va_end(ap);
> +
> +	s->len += ret;
> +
> +	seq_buf_check_len(s);
> +
> +	return ret;
> +}
> +
> +/**
> + * seq_buf_bitmask - write a bitmask array in its ASCII representation
> + * @s:		seq_buf descriptor
> + * @maskp:	points to an array of unsigned longs that represent a bitmask
> + * @nmaskbits:	The number of bits that are valid in @maskp
> + *
> + * Writes a ASCII representation of a bitmask string into @s.
> + *
> + * Returns the number of bytes written.
> + */
> +int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> +		    int nmaskbits)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	int ret;
> +
> +	WARN_ON((int)len < 0);
> +	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> +	s->len += ret;
> +	seq_buf_check_len(s);
> +
> +	return ret;
> +}
> +
> +/**
> + * seq_buf_vprintf - write vprintf style into the sequence buffer
> + * @s: seq_buf descriptor
> + * @fmt: printf format string
> + *
> + * Write a vprintf() style into the sequence buffer.
> + *
> + * Returns the number of bytes written.
> + */
> +int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	int ret;
> +
> +	if (WARN_ON((int)len < 0))
> +		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> +	s->len += ret;
> +	seq_buf_check_len(s);
> +
> +	return len;
> +}
> +
> +/**
> + * seq_buf_bprintf - Write the printf string from binary arguments
> + * @s: seq_buf descriptor
> + * @fmt: The format string for the @binary arguments
> + * @binary: The binary arguments for @fmt.
> + *
> + * When recording in a fast path, a printf may be recorded with just
> + * saving the format and the arguments as they were passed to the
> + * function, instead of wasting cycles converting the arguments into
> + * ASCII characters. Instead, the arguments are saved in a 32 bit
> + * word array that is defined by the format string constraints.
> + *
> + * This function will take the format and the binary array and finish
> + * the conversion into the ASCII string within the buffer.
> + *
> + * Returns number of bytes written.
> + */
> +int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	int ret;
> +
> +	if (WARN_ON((int)len < 0))
> +		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
> +	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> +	s->len += ret;
> +	seq_buf_check_len(s);
> +
> +	return len;
> +}
> +
> +/**
> + * seq_buf_puts - sequence printing of simple string
> + * @s: seq_buf descriptor
> + * @str: simple string to record
> + *
> + * Copy a simple string into the sequence buffer.
> + *
> + * Returns number of bytes written.
> + */
> +int seq_buf_puts(struct seq_buf *s, const char *str)
> +{
> +	unsigned int len = strlen(str);
> +
> +	if (len > SEQ_BUF_LEFT(s)) {
> +		s->overflow = 1;
> +		len = SEQ_BUF_LEFT(s);
> +	}
> +
> +	memcpy(s->buffer + s->len, str, len);
> +	s->len += len;
> +	WARN_ON(s->len > (s->size - 1));
> +
> +	return len;
> +}
> +
> +/**
> + * seq_buf_putc - sequence printing of simple character
> + * @s: seq_buf descriptor
> + * @c: simple character to record
> + *
> + * Copy a single character into the sequence buffer.
> + *
> + * Returns 1 if the character was written, 0 otherwise.
> + */
> +int seq_buf_putc(struct seq_buf *s, unsigned char c)
> +{
> +	if (SEQ_BUF_LEFT(s) < 1) {
> +		s->overflow = 1;
> +		return 0;
> +	}
> +
> +	s->buffer[s->len++] = c;
> +	WARN_ON(s->len > (s->size - 1));
> +
> +	return 1;
> +}
> +
> +/**
> + * seq_buf_putmem - write raw data into the sequenc buffer
> + * @s: seq_buf descriptor
> + * @mem: The raw memory to copy into the buffer
> + * @len: The length of the raw memory to copy (in bytes)
> + *
> + * There may be cases where raw memory needs to be written into the
> + * buffer and a strcpy() would not work. Using this function allows
> + * for such cases.
> + *
> + * Returns the number of bytes written in the buffer.
> + */
> +int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
> +{
> +	if (len > SEQ_BUF_LEFT(s)) {
> +		s->overflow = 1;
> +		len = SEQ_BUF_LEFT(s);
> +	}
> +
> +	memcpy(s->buffer + s->len, mem, len);
> +	s->len += len;
> +	WARN_ON(s->len > (s->size - 1));
> +
> +	return len;
> +}
> +
> +#define MAX_MEMHEX_BYTES	8U
> +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> +
> +/**
> + * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
> + * @s: seq_buf descriptor
> + * @mem: The raw memory to write its hex ASCII representation of
> + * @len: The length of the raw memory to copy (in bytes)
> + *
> + * This is similar to seq_buf_putmem() except instead of just copying the
> + * raw memory into the buffer it writes its ASCII representation of it
> + * in hex characters.
> + *
> + * Returns how much it wrote to the buffer.
> + */
> +int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> +		       unsigned int len)
> +{
> +	unsigned char hex[HEX_CHARS];
> +	const unsigned char *data = mem;
> +	unsigned int start_len;
> +	int i, j;
> +	int cnt = 0;
> +
> +	while (len) {
> +		start_len = min(len, HEX_CHARS - 1);
> +#ifdef __BIG_ENDIAN
> +		for (i = 0, j = 0; i < start_len; i++) {
> +#else
> +		for (i = start_len-1, j = 0; i >= 0; i--) {
> +#endif
> +			hex[j++] = hex_asc_hi(data[i]);
> +			hex[j++] = hex_asc_lo(data[i]);
> +		}
> +		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> +			break;
> +
> +		/* j increments twice per loop */
> +		len -= j / 2;
> +		hex[j++] = ' ';
> +
> +		cnt += seq_buf_putmem(s, hex, j);
> +	}
> +	return cnt;
> +}
> +
> +/**
> + * seq_buf_path - copy a path into the sequence buffer
> + * @s: seq_buf descriptor
> + * @path: path to write into the sequence buffer.
> + *
> + * Write a path name into the sequence buffer.
> + *
> + * Returns the number of bytes written into the buffer.
> + */
> +int seq_buf_path(struct seq_buf *s, const struct path *path)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	unsigned char *p;
> +	unsigned int start = s->len;
> +
> +	WARN_ON((int)len < 0);
> +	p = d_path(path, s->buffer + s->len, len);
> +	if (!IS_ERR(p)) {
> +		p = mangle_path(s->buffer + s->len, p, "\n");
> +		if (p) {
> +			s->len = p - s->buffer;
> +	WARN_ON(s->len > (s->size - 1));
> +			return s->len - start;
> +		}
> +	} else {
> +		s->buffer[s->len++] = '?';
> +	WARN_ON(s->len > (s->size - 1));
> +		return s->len - start;
> +	}
> +
> +	s->overflow = 1;
> +	return 0;
> +}
> +
> +/**
> + * seq_buf_to_user - copy the squence buffer to user space
> + * @s: seq_buf descriptor
> + * @ubuf: The userspace memory location to copy to
> + * @cnt: The amount to copy
> + *
> + * Copies the sequence buffer into the userspace memory pointed to
> + * by @ubuf. It starts from the last read position (@s->readpos)
> + * and writes up to @cnt characters or till it reaches the end of
> + * the content in the buffer (@s->len), which ever comes first.
> + *
> + * On success, it returns a positive number of the number of bytes
> + * it copied.
> + *
> + * On failure it returns -EBUSY if all of the content in the
> + * sequence has been already read, which includes nothing in the
> + * sequenc (@s->len == @s->readpos).
> + *
> + * Returns -EFAULT if the copy to userspace fails.
> + */
> +int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
> +{
> +	int len;
> +	int ret;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (s->len <= s->readpos)
> +		return -EBUSY;
> +
> +	len = s->len - s->readpos;
> +	if (cnt > len)
> +		cnt = len;
> +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> +	if (ret == cnt)
> +		return -EFAULT;
> +
> +	cnt -= ret;
> +
> +	s->readpos += cnt;
> +	return cnt;
> +}
> diff --git a/lib/trace_seq.c b/lib/trace_seq.c
> new file mode 100644
> index 0000000..5ba99c6c
> --- /dev/null
> +++ b/lib/trace_seq.c
> @@ -0,0 +1,303 @@
> +/*
> + * trace_seq.c
> + *
> + * Copyright (C) 2008-2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +#include <linux/uaccess.h>
> +#include <linux/seq_file.h>
> +#include <linux/trace_seq.h>
> +
> +int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> +{
> +	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
> +	int ret;
> +
> +	ret = seq_write(m, s->buffer, len);
> +
> +	/*
> +	 * Only reset this buffer if we successfully wrote to the
> +	 * seq_file buffer.
> +	 */
> +	if (!ret)
> +		trace_seq_init(s);
> +
> +	return ret;
> +}
> +
> +/**
> + * trace_seq_printf - sequence printing of trace information
> + * @s: trace sequence descriptor
> + * @fmt: printf format string
> + *
> + * It returns 0 if the trace oversizes the buffer's free
> + * space, 1 otherwise.
> + *
> + * The tracer may use either sequence operations or its own
> + * copy to user routines. To simplify formating of a trace
> + * trace_seq_printf is used to store strings into a special
> + * buffer (@s). Then the output may be either used by
> + * the sequencer or pulled into another buffer.
> + */
> +int
> +trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	va_list ap;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	va_start(ap, fmt);
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> +	va_end(ap);
> +
> +	/* If we can't write it all, don't bother writing anything */
> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_printf);
> +
> +/**
> + * trace_seq_bitmask - put a list of longs as a bitmask print output
> + * @s:		trace sequence descriptor
> + * @maskp:	points to an array of unsigned longs that represent a bitmask
> + * @nmaskbits:	The number of bits that are valid in @maskp
> + *
> + * It returns 0 if the trace oversizes the buffer's free
> + * space, 1 otherwise.
> + *
> + * Writes a ASCII representation of a bitmask string into @s.
> + */
> +int
> +trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> +		  int nmaskbits)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> +	s->len += ret;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_bitmask);
> +
> +/**
> + * trace_seq_vprintf - sequence printing of trace information
> + * @s: trace sequence descriptor
> + * @fmt: printf format string
> + *
> + * The tracer may use either sequence operations or its own
> + * copy to user routines. To simplify formating of a trace
> + * trace_seq_printf is used to store strings into a special
> + * buffer (@s). Then the output may be either used by
> + * the sequencer or pulled into another buffer.
> + */
> +int
> +trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> +
> +	/* If we can't write it all, don't bother writing anything */
> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return len;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_vprintf);
> +
> +int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> +
> +	/* If we can't write it all, don't bother writing anything */
> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return len;
> +}
> +
> +/**
> + * trace_seq_puts - trace sequence printing of simple string
> + * @s: trace sequence descriptor
> + * @str: simple string to record
> + *
> + * The tracer may use either the sequence operations or its own
> + * copy to user routines. This function records a simple string
> + * into a special buffer (@s) for later retrieval by a sequencer
> + * or other mechanism.
> + */
> +int trace_seq_puts(struct trace_seq *s, const char *str)
> +{
> +	int len = strlen(str);
> +
> +	if (s->full)
> +		return 0;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	memcpy(s->buffer + s->len, str, len);
> +	s->len += len;
> +
> +	return len;
> +}
> +
> +int trace_seq_putc(struct trace_seq *s, unsigned char c)
> +{
> +	if (s->full)
> +		return 0;
> +
> +	if (s->len >= (PAGE_SIZE - 1)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->buffer[s->len++] = c;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(trace_seq_putc);
> +
> +int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
> +{
> +	if (s->full)
> +		return 0;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	memcpy(s->buffer + s->len, mem, len);
> +	s->len += len;
> +
> +	return len;
> +}
> +
> +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> +
> +int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
> +{
> +	unsigned char hex[HEX_CHARS];
> +	const unsigned char *data = mem;
> +	int i, j;
> +
> +	if (s->full)
> +		return 0;
> +
> +#ifdef __BIG_ENDIAN
> +	for (i = 0, j = 0; i < len; i++) {
> +#else
> +	for (i = len-1, j = 0; i >= 0; i--) {
> +#endif
> +		hex[j++] = hex_asc_hi(data[i]);
> +		hex[j++] = hex_asc_lo(data[i]);
> +	}
> +	hex[j++] = ' ';
> +
> +	return trace_seq_putmem(s, hex, j);
> +}
> +
> +void *trace_seq_reserve(struct trace_seq *s, size_t len)
> +{
> +	void *ret;
> +
> +	if (s->full)
> +		return NULL;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return NULL;
> +	}
> +
> +	ret = s->buffer + s->len;
> +	s->len += len;
> +
> +	return ret;
> +}
> +
> +int trace_seq_path(struct trace_seq *s, const struct path *path)
> +{
> +	unsigned char *p;
> +
> +	if (s->full)
> +		return 0;
> +
> +	if (s->len >= (PAGE_SIZE - 1)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
> +	if (!IS_ERR(p)) {
> +		p = mangle_path(s->buffer + s->len, p, "\n");
> +		if (p) {
> +			s->len = p - s->buffer;
> +			return 1;
> +		}
> +	} else {
> +		s->buffer[s->len++] = '?';
> +		return 1;
> +	}
> +
> +	s->full = 1;
> +	return 0;
> +}
> +
> +ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
> +{
> +	int len;
> +	int ret;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (s->len <= s->readpos)
> +		return -EBUSY;
> +
> +	len = s->len - s->readpos;
> +	if (cnt > len)
> +		cnt = len;
> +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> +	if (ret == cnt)
> +		return -EFAULT;
> +
> +	cnt -= ret;
> +
> +	s->readpos += cnt;
> +	return cnt;
> +}

