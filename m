From: Jens Axboe <axboe@kernel.dk>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Date: Mon, 24 Jun 2013 09:17:18 +0200
Message-ID: <20130624071718.GS9422@kernel.dk>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 23 2013, Linus Torvalds wrote:
>  nothing in common. Networking very very seldom
> has the kind of "submit and wait for immediate result" issues that
> disk reads do.
> 
> That said, I dislike the patch intensely. I do not think it's at all a
> good idea to look at "need_resched" to say "I can spin now". You're
> still wasting CPU cycles.
> 
> So Willy, please do *not* mix this up with the scheduler, or at least
> not "need_resched". Instead, maybe we should introduce a notion of "if
> we are switching to the idle thread, let's see if we can try to do
> some IO synchronously".
> 
> You could try to do that either *in* the idle thread (which would take
> the context switch overhead - maybe negating some of the advantages),
> or alternatively hook into the scheduler idle logic before actually
> doing the switch.

It can't happen in the idle thread. If you need to take the context
switch, then you've negated pretty much all of the gain of the polled
approach.

> But anything that starts polling when there are other runnable
> processes to be done sounds really debatable. Even if it's "only" 5us
> or so. There's a lot of real work that could be done in 5us.

IMHO that depends mostly on whether the app wants to give up those 5us
of work time just spinning on the completion of important IO. You
obviously can't steal the time of others.

-- 
Jens Axboe
