From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2 v4] scsi: add __print_hex() to ftrace
Date: Thu, 01 Apr 2010 09:57:45 -0400
Message-ID: <1270130265.19685.8933.camel@gandalf.stny.rr.com>
References: <4BB4855E.7030509@jp.fujitsu.com>
	 <4BB4864A.3060406@jp.fujitsu.com>
Reply-To: rostedt@goodmis.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab0DAN5r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 09:57:47 -0400
In-Reply-To: <4BB4864A.3060406@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

On Thu, 2010-04-01 at 20:40 +0900, Kei Tokunaga wrote:
> This is the same patch from v1.
> 
> __print_hex() prints values in an array in hex (w/o '0x') (space separated)
> EX) 92 33 32 f3 ee 4d
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> 
> ---
> 
>  linux-2.6.34-rc3-trace-kei/include/linux/ftrace_event.h |    3 +++
>  linux-2.6.34-rc3-trace-kei/include/trace/ftrace.h       |    3 +++
>  linux-2.6.34-rc3-trace-kei/kernel/trace/trace_output.c  |   15 +++++++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff -puN include/linux/ftrace_event.h~add__print_hex_to_ftrace include/linux/ftrace_event.h
> --- linux-2.6.34-rc3-trace/include/linux/ftrace_event.h~add__print_hex_to_ftrace	2010-03-31 10:03:14.000000000 +0900
> +++ linux-2.6.34-rc3-trace-kei/include/linux/ftrace_event.h	2010-03-31 10:03:14.000000000 +0900
> @@ -25,6 +25,9 @@ const char *ftrace_print_flags_seq(struc
>  const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  				     const struct trace_print_flags *symbol_array);
>  
> +const char *ftrace_print_hex_seq(struct trace_seq *p,
> +				 const unsigned char *buf, int len);
> +
>  /*
>   * The trace entry - the most basic unit of tracing. This is what
>   * is printed in the end as a single line in the trace output, such as:
> diff -puN include/trace/ftrace.h~add__print_hex_to_ftrace include/trace/ftrace.h
> --- linux-2.6.34-rc3-trace/include/trace/ftrace.h~add__print_hex_to_ftrace	2010-03-31 10:03:14.000000000 +0900
> +++ linux-2.6.34-rc3-trace-kei/include/trace/ftrace.h	2010-03-31 10:03:14.000000000 +0900
> @@ -198,6 +198,9 @@
>  		ftrace_print_symbols_seq(p, value, symbols);		\
>  	})
>  
> +#undef __print_hex
> +#define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  static notrace enum print_line_t					\
> diff -puN kernel/trace/trace_output.c~add__print_hex_to_ftrace kernel/trace/trace_output.c
> --- linux-2.6.34-rc3-trace/kernel/trace/trace_output.c~add__print_hex_to_ftrace	2010-03-31 10:03:14.000000000 +0900
> +++ linux-2.6.34-rc3-trace-kei/kernel/trace/trace_output.c	2010-04-01 20:38:30.000000000 +0900
> @@ -355,6 +355,21 @@ ftrace_print_symbols_seq(struct trace_se
>  }
>  EXPORT_SYMBOL(ftrace_print_symbols_seq);
>  
> +const char *
> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> +{
> +	int i;
> +	const char *ret = p->buffer + p->len;
> +
> +	for (i = 0; i < buf_len; i++)
> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
> +
> +	trace_seq_putc(p, 0);

I would not put the putc(p, 0) into a helper function. This terminates
the buffer, and strings added to the trace_seq will go after the '\0'.

What we need is this in trace_seq.h:

static inline trace_seq_terminate(struct trace_seq *s)
{
	if (!s->full)
		s->buffer[s->len] = 0;
}

This will add a '0' to the buffer after the last string, but will not
increment length while doing it. Thus, new data added to the buffer
would still be appended correctly.

-- Steve

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ftrace_print_hex_seq);
> +
>  #ifdef CONFIG_KRETPROBES
>  static inline const char *kretprobed(const char *name)
>  {
> 
> _
> 
> 
> 


