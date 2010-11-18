From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
Date: Thu, 18 Nov 2010 12:41:22 -0800
Message-ID: <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, "David S. Miller" <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 18, 2010 at 11:30 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> This is the fourth time I send this patch. For some reason it seems unable
> to get any feedback at all. I'd really appreciate a clear ACK or NACK on
> it and I'll keep resending it until it's either merged or I get a NACK
> with a reason.

The patch looks ok to me, but you've basically selected the least
interesting file possible. No wonder people can't seem to care.

Also, this is just ugly as hell, and doesn't help anything:

+       int (*eh_abort_handler)(struct scsi_cmnd *) =
+               scmd->device->host->hostt->eh_abort_handler;

since the compiler will have optimized that double access away anyway
(no writes in between). So you could have made it about a thousand
times more readable with no downside by doing

    struct scsi_host_template *hostt = scmd->device->host->hostt;

    if (!hostt->eh_abort_handler)
        return FAILED;
    return hostt->eh_abort_handler(scmd);

instead. Look ma, no long lines.

Rule of thumb: if you need more than one line for an expression or
variable definition, you're doing something wrong.

                Linus
