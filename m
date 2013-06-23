From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Sun, 23 Jun 2013 08:29:53 -1000
Message-ID: <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
References: <20130620201713.GV8211@linux.intel.com>
	<20130623100920.GA19021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:61163 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3FWS3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 14:29:55 -0400
In-Reply-To: <20130623100920.GA19021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>

On Sun, Jun 23, 2013 at 12:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> The spinning approach you add has the disadvantage of actively wasting CPU
> time, which could be used to run other tasks. In general it's much better
> to make sure the completion IRQs are rate-limited and just schedule. This
> (combined with a metric ton of fine details) is what the networking code
> does in essence, and they have no trouble reaching very high throughput.

It's not about throughput - it's about latency. Don't ever confuse the
two, they have almost nothing in common. Networking very very seldom
has the kind of "submit and wait for immediate result" issues that
disk reads do.

That said, I dislike the patch intensely. I do not think it's at all a
good idea to look at "need_resched" to say "I can spin now". You're
still wasting CPU cycles.

So Willy, please do *not* mix this up with the scheduler, or at least
not "need_resched". Instead, maybe we should introduce a notion of "if
we are switching to the idle thread, let's see if we can try to do
some IO synchronously".

You could try to do that either *in* the idle thread (which would take
the context switch overhead - maybe negating some of the advantages),
or alternatively hook into the scheduler idle logic before actually
doing the switch.

But anything that starts polling when there are other runnable
processes to be done sounds really debatable. Even if it's "only" 5us
or so. There's a lot of real work that could be done in 5us.

                       Linus
