From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.17-rc5-mm1
Date: Tue, 30 May 2006 23:57:10 +0200
Message-ID: <6bffcb0e0605301457v9ba284bk75b8b6d14384489a@mail.gmail.com>
References: <20060530022925.8a67b613.akpm@osdl.org>
	 <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com>
	 <6bffcb0e0605301157o6b7c5f66q3c9f151cbb4537d5@mail.gmail.com>
	 <20060530194259.GB22742@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:50850 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S932491AbWE3V5L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 17:57:11 -0400
Received: by wr-out-0506.google.com with SMTP id i21so771126wra
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 14:57:10 -0700 (PDT)
In-Reply-To: <20060530194259.GB22742@elte.hu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On 30/05/06, Ingo Molnar <mingo@elte.hu> wrote:
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > SCSI or libata problem.
>
> i think SCSI and libata is innocent here.
>
> > ============================
> > [ BUG: illegal lock usage! ]
> > ----------------------------
> > illegal {in-hardirq-W} -> {hardirq-on-W} usage.
>
> > 1 locks held by init/1:
> > #0:  (&base->lock#2){++..}, at: [<c0129a24>] lock_timer_base+0x29/0x55
> >
> > stack backtrace:
> > [<c0103e52>] show_trace_log_lvl+0x4b/0xf4
> > [<c01044b3>] show_trace+0xd/0x10
> > [<c010457b>] dump_stack+0x19/0x1b
> > [<c0137d63>] print_usage_bug+0x1a1/0x1ab
> > [<c0138458>] mark_lock+0x2d7/0x514
> > [<c01386dc>] mark_held_locks+0x47/0x65
> > [<c0139745>] trace_hardirqs_on+0x12b/0x16f
> > [<c02f2b61>] restore_nocheck+0x8/0xb
>
> weird. We are holding base->lock#2 [CPU#1's timer base lock], _and_ we
> execute restore_nocheck - which is a return-to-userspace thing.
>
> unfortunately the stacktrace provides no clues of how we got here.
> For such nasty cases i have a kernel tracing patch prepared, you can get
> it from:
>
>   http://redhat.com/~mingo/lockdep-patches/latency-tracing-lockdep.patch
>
> just apply it ontop of your current tree and accept all the new .config
> options as the kernel suggests them to you.

I can't boot with that patch. I even don't see "Uncompressing
Linux..." - machine reboots.
I have 2.6.17-rc5-mm1 +
genirq-cleanup-remove-irq_descp-fix.patch
lock-validator-irqtrace-support-non-x86-architectures.patch
lock-validator-special-locking-sb-s_umount-2-fix.patch
from hot fixes
+
Arjan's net/ipv4/igmp.c patch.

BTW. I got error when compiling kernel/latency.c, so I change
if (DEBUG_WARN_ON((val < PREEMPT_MASK) && !(preempt_count() & PREEMPT_MASK))))

to

if (DEBUG_WARN_ON((val < PREEMPT_MASK) && !(preempt_count() & PREEMPT_MASK)))

Here is config
http://www.stardust.webpages.pl/files/mm/2.6.17-rc5-mm1/mm-config3

Here is "Kernel Bug : The Movie" (4,3MB)
www.stardust.webpages.pl/files/crap/kbtm.avi

[snip]
>
>         Ingo
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/wiki/)
