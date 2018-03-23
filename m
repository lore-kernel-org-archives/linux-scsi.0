From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Fri, 23 Mar 2018 16:55:13 +0100
Message-ID: <20180323155513.dwbgvblenlji33as@linutronix.de>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322093745.GC4229@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?utf-8?Q?R=2E_Gon=C3=A7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-03-22 06:37:45 [-0300], Arnaldo Carvalho de Melo wrote:
> Em Wed, Mar 21, 2018 at 11:43:58AM -0700, Linus Torvalds escreveu:
> > [ Adding PeterZ to participants due to query about lockdep_assert() ]
> > 
> > On Wed, Mar 21, 2018 at 8:38 AM, Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > >
> > >         assert_spin_locked(&cmd->t_state_lock);
> > > -       WARN_ON_ONCE(!irqs_disabled());
> > > +       WARN_ON_ONCE_NONRT(!irqs_disabled());
> > 
> > Ugh.
> > 
> > Can't we just replace both of those with a lockdep annotation?
> 
> Huh, even better, when that feature gets finished (tglx said it was
> being developed, not there yet tho) it'll allow further reduction of the
> PREEMPT_RT_FULL patchkit.

I am going take this into -RT tree for now until we have different
solution. I will try to be kind and do the same change in
__transport_wait_for_tasks().
Arnaldo, please do "[PATCH RT]" while sending patches. Then the bots
don't complain if it applies but does not compile on !RT kernel (or so
I've been told).

Technically speaking the code wants to ensure that the lock is held and
the interrupts are disabled because the lock is always taken with
disabled interrupts. This kind of check could be done with
	lockdep_assert_held(&cmd->t_state_lock);

but would require lockdep to be switched on. Nicholas, would you mind
such a change?

> - Arnaldo

Sebastian
