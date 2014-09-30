From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 28/38] Externalize string buffer for printk
Date: Tue, 30 Sep 2014 20:52:40 +0200
Message-ID: <542AFBF8.1070004@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de> <1411991947-130166-29-git-send-email-hare@suse.de> <20140930163931.GG2707@dhcp128.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140930163931.GG2707@dhcp128.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.cz>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/30/2014 06:39 PM, Petr Mladek wrote:
> On Mon 29-09-14 13:58:57, Hannes Reinecke wrote:
>> This patch splits off the actual logging from vprintk_emit()
>> into printk_emit_string(), with vprintk_emit() just being a
>> simple wrapper for formatting the message into a
>> static buffer.
>>
>> With that the caller can pass in a local buffer for
>> printk_emit_string() without increasing the overall stack size.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: LKML <linux-kernel@vger.kernel.org>
>
> Adding Andrew into CC here as well.
>
> There is one potential problem, see below.
>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   include/linux/printk.h |  5 +++++
>>   kernel/printk/printk.c | 36 ++++++++++++++++++++++++------------
>>   2 files changed, 29 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/printk.h b/include/linux/printk.h
>> index d78125f..9639900 100644
>> --- a/include/linux/printk.h
>> +++ b/include/linux/printk.h
>> @@ -130,6 +130,11 @@ int vprintk_emit(int facility, int level,
>>   		 const char *dict, size_t dictlen,
>>   		 const char *fmt, va_list args);
>>
>> +asmlinkage
>> +int printk_emit_string(int facility, int level,
>> +		       const char *dict, size_t dictlen,
>> +		       char *textbuf, size_t text_len);
>> +
>>   asmlinkage __printf(1, 0)
>>   int vprintk(const char *fmt, va_list args);
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index d13675e..303a1fe 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -1618,22 +1618,11 @@ asmlinkage int vprintk_emit(int facility, in=
t level,
>>   			    const char *dict, size_t dictlen,
>>   			    const char *fmt, va_list args)
>>   {
>> -	static int recursion_bug;
>>   	static char textbuf[LOG_LINE_MAX];
>>
>>   	char *text =3D textbuf;
>>   	size_t text_len =3D 0;
>> -	enum log_flags lflags =3D 0;
>> -	unsigned long flags;
>> -	int this_cpu;
>> -	int printed_len =3D 0;
>> -	bool in_sched =3D false;
>> -	/* cpu currently holding logbuf_lock in this function */
>> -	static volatile unsigned int logbuf_cpu =3D UINT_MAX;
>>
>>   	if (level =3D=3D SCHED_MESSAGE_LOGLEVEL) {
>> -		level =3D -1;
>> -		in_sched =3D true;
>> -
>>   		/*
>>   		 * The printf needs to come first; we need the syslog
>>   		 * prefix which might be passed-in as a parameter.
>> @@ -1644,6 +1633,24 @@ asmlinkage int vprintk_emit(int facility, int=
 level,
>>
>>   	text_len +=3D vscnprintf(text + text_len,
>>   			       sizeof(textbuf) - text_len, fmt, args);
>> +	return printk_emit_string(facility, level, dict, dictlen,
>> +				  textbuf, text_len);
>> +}
>> +EXPORT_SYMBOL(vprintk_emit);
>> +
>> +asmlinkage int printk_emit_string(int facility, int level,
>> +				  const char *dict, size_t dictlen,
>> +				  char *textbuf, size_t text_len)
>> +{
>> +	static int recursion_bug;
>> +	char *text =3D textbuf;
>> +	enum log_flags lflags =3D 0;
>> +	unsigned long flags;
>> +	int this_cpu;
>> +	int printed_len =3D 0;
>> +	bool in_sched =3D false;
>> +	/* cpu currently holding logbuf_lock in this function */
>> +	static volatile unsigned int logbuf_cpu =3D UINT_MAX;
>
> We should make sure that text_len is lower or equal LOG_LINE_MAX.
>
> I am afraid that printk() code is not able to process longer
> lines. For example, syslog_print() does:
>
>         text =3D kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
>
> Then it calls msg_print_text() that works with entire messages. So,
> any longer message would freeze syslog_print() because it would newer
> fit into the buffer.
>
Ah. Okay, I haven't thought about this. But yes, you are right.

> I guess that there are more locations like this.
>
> Maybe, we should make LOG_LINE_MAX public, so it could be used on the
> other location either to allocate the buffer or to check the size.
>
Well, for starters we should be truncating the buffer to LOG_LINE_MAX i=
n=20
printk_emit_string().
And document that it will only handle messages up to that length.

I'll be posting an updated patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
