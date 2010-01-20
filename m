From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] scsi: add __print_hex() to ftrace
Date: Tue, 19 Jan 2010 22:56:13 -0800
Message-ID: <1263970573.18117.96.camel@Joe-Laptop.home>
References: <4B56A60F.6060207@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753975Ab0ATG4R@vger.kernel.org>
In-Reply-To: <4B56A60F.6060207@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-01-20 at 15:43 +0900, Kei Tokunaga wrote:
> diff -puN kernel/trace/trace_output.c~ftrace_print_hex kernel/trace/trace_output.c
> --- linux-2.6.33-rc4-trace/kernel/trace/trace_output.c~ftrace_print_hex	2010-01-14 19:55:45.000000000 +0900
> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/trace_output.c	2010-01-14 20:02:49.000000000 +0900
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

hex_dump_to_buffer?
