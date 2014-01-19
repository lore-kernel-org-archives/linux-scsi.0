From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target fixes for v3.13
Date: Sun, 19 Jan 2014 02:43:50 -0800
Message-ID: <1390128230.5567.754.camel@haakon3.risingtidesystems.com>
References: <1389917384.5567.718.camel@haakon3.risingtidesystems.com>
	 <CA+55aFzQG9FxSX7C0GitLJfzAvxJN-Pzo1vKoHWfFOkhJWb=AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzQG9FxSX7C0GitLJfzAvxJN-Pzo1vKoHWfFOkhJWb=AQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-01-17 at 17:29 -0800, Linus Torvalds wrote:
> On Thu, Jan 16, 2014 at 4:09 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > This change allows the percpu_ida tag allocator to optionally use
> > interruptible sleep that iscsi-target expects, while still leaving the
> > functionality + interface for existing percpu_ida consumers unchanged.
> 
> I'm not pulling this. Passing in TASK_RUNNING to prepare_to_wait() is
> insane (because if it ever were to actually wait, that would be a
> bug), and afaik this would be the first time anybody ever does that.
> 
> Yes, yes, it may "work", but I'm not pulling that kind of hack just
> before a release.
> 
> Quite frankly, it looks like you want to have a tristate argument ("no
> wait", "wait interruptibly", "wait uninterruptibly") to that
> percpu_ida_alloc() function. Fine. But dammit, using this kind of
> hackery, and then having two *different* calling conventions (one
> mis-using the gfp_t for legacy reasons, and one now using the task
> state flags in odd ways) is just not acceptable.
> 
> Now, neither of those two is perfect, but I can see why you want to
> use the task state ones to say which kind of interruptible you want..
> But I really don't like suddenly having a
> prepare_to_wait(TASK_RUNNING) caller without any discussion, and I
> *really* don't like having two completely different models for this
> hack.
> 
> So quite frankly, I'd much prefer:
> 
>  - talk to the scheduler people, and make them aware of the fact that
> you are going to pass in TASK_RUNNING to prepare_to_wait(). It works
> with the code as-is, as long as you don't actually then wait.
> 
>  - Don't do that wrapper function with a totally different calling
> convention logic. Instead, just change all the callers explicitly.
> From a quick look, you really only have a couple of cases:
> 
>   (a) target/iscsi, which wants the new ternary argument
> 
>   (b) vhost/scsi.c, which uses GFP_ATOMIC and can be changed to TASK_RUNNABLE
> 
>   (c) block/blk-mq-tag.c, which already hates the current insane
> thing, and uses __GFP_WAIT and (gfp & ~__GFP_WAIT) and other hacks,
> and is obviously *very* aware of the internal hackery in the current
> percpu_ida_alloc() argument. So I'm getting the feeling that that
> whole thing might actually be *happier* with the TASK_xyz flags.
> 

Sure.

> 
> So I really think this needs cleanup, and that hacky "passing in
> TASK_RUNNING to prepare_to_wait()" needs to be made official. And yes,
> that implies that it's too late to try to push this through for 3.13,
> this goes into the next merge window and can be backported.
> 
> Added the appropriate people to the Cc..
> 

Just sent out a series as requested for review with CC's for Ingo +
Peter.

Jens, please review the blk-mq changes.

Thanks!

--nab
