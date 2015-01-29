From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Date: Thu, 29 Jan 2015 10:16:16 +0100
Message-ID: <87wq46aqvz.fsf@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	<alpine.LNX.2.00.1501291636140.7510@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1501291636140.7510@nippy.intranet> (Finn Thain's
	message of "Thu, 29 Jan 2015 17:56:37 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 29 2015, Finn Thain <fthain@telegraphics.com.au> wrote:

> I have one reservation about this patch series.
>
> For example, the changes,
>
> -	seq_printf(m, "%s", p);
> +	seq_puts(m, p);
>
> These calls are not equivalent because the bounds check is not the same. 
> seq_puts will fail when m->count + strlen(p) == m->size.
>

So will seq_printf:

int seq_vprintf(struct seq_file *m, const char *f, va_list args)
{
	int len;

	if (m->count < m->size) {
		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
		if (m->count + len < m->size) {
			m->count += len;
			return 0;
		}
	}
	seq_set_overflow(m);
	return -1;
}

The return value from vsnprintf("%s", p) is by definition the length of
the string p. Yes, vsnprintf may write some of the bytes from the
string to the buffer, but those are effectively discarded if they don't
all fit, since m->count is not updated.

> There's a similar situation with the changes,
>
> -	seq_puts(m, "x");
> +	seq_putc(m, 'x');

It's true that this may cause 'x' to be printed which it might not have
been before. I think this is a bug in seq_puts - it should use <= for
its bounds check. OTOH, seq_printf probably needs to continue using <,
because if the return value is == m->size-m->count, vsnprintf will have
truncated the output, overwriting the last byte with a '\0'.

> Have you considered what the implications might be? Are there any?

I must admit I hadn't thought that deeply about it before, but now it
seems that my patches can only end up utilizing m->buf a bit better
(well, 8 bits, to be precise). If I understand the whole seq_*
interface, overflow will just cause a larger buffer to be allocated and
all the print functions to be called again.

Steven, you've been doing some cleanup in this area, among other things
trying to make all the seq_* functions return void. Could you fill me in
on the status of that?

Rasmus
