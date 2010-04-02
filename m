From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 v4] scsi: add __print_hex() to ftrace
Date: Fri, 02 Apr 2010 10:40:53 +0800
Message-ID: <4BB55935.9040100@cn.fujitsu.com>
References: <4BB4855E.7030509@jp.fujitsu.com>	 <4BB4864A.3060406@jp.fujitsu.com> <1270130265.19685.8933.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0DBCjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2010 22:39:42 -0400
In-Reply-To: <1270130265.19685.8933.camel@gandalf.stny.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rostedt@goodmis.org
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

>> +const char *
>> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>> +{
>> +	int i;
>> +	const char *ret = p->buffer + p->len;
>> +
>> +	for (i = 0; i < buf_len; i++)
>> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
>> +
>> +	trace_seq_putc(p, 0);
> 
> I would not put the putc(p, 0) into a helper function. This terminates
> the buffer, and strings added to the trace_seq will go after the '\0'.
> 

This is exactly what ftrace_print_flags_seq() and ftrace_print_symbols_seq()
do, and exactly what we want.

An example:

TP_printk("%s,%s", __print_flags(...), __print_flags(...));

We need 2 seperated strings, while trace_seq_terminate() will make it
a single string.

> What we need is this in trace_seq.h:
> 
> static inline trace_seq_terminate(struct trace_seq *s)
> {
> 	if (!s->full)
> 		s->buffer[s->len] = 0;
> }
> 
> This will add a '0' to the buffer after the last string, but will not
> increment length while doing it. Thus, new data added to the buffer
> would still be appended correctly.
> 
> -- Steve
> 
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(ftrace_print_hex_seq);
