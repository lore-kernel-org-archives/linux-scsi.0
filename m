From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2 v4] scsi: add __print_hex() to ftrace
Date: Thu, 01 Apr 2010 22:50:03 -0400
Message-ID: <1270176603.19685.9721.camel@gandalf.stny.rr.com>
References: <4BB4855E.7030509@jp.fujitsu.com>
	 <4BB4864A.3060406@jp.fujitsu.com>
	 <1270130265.19685.8933.camel@gandalf.stny.rr.com>
	 <4BB55935.9040100@cn.fujitsu.com>
Reply-To: rostedt@goodmis.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab0DBCuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 22:50:06 -0400
In-Reply-To: <4BB55935.9040100@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

On Fri, 2010-04-02 at 10:40 +0800, Li Zefan wrote:
> >> +const char *
> >> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> >> +{
> >> +	int i;
> >> +	const char *ret = p->buffer + p->len;
> >> +
> >> +	for (i = 0; i < buf_len; i++)
> >> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
> >> +
> >> +	trace_seq_putc(p, 0);
> > 
> > I would not put the putc(p, 0) into a helper function. This terminates
> > the buffer, and strings added to the trace_seq will go after the '\0'.
> > 
> 
> This is exactly what ftrace_print_flags_seq() and ftrace_print_symbols_seq()
> do, and exactly what we want.
> 
> An example:
> 
> TP_printk("%s,%s", __print_flags(...), __print_flags(...));
> 
> We need 2 seperated strings, while trace_seq_terminate() will make it
> a single string.

You're right! But I still don't like it ;-)

I probably should have had that in the __print_flags() macro instead of
the function. Oh well. These are only helper functions for the
__print*() variants anyway.

OK, you can have my Acked-by: Steven Rostedt <rostedt@goodmis.org> for
this.

-- Steve


