From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Thu, 22 Mar 2018 06:40:24 -0300
Message-ID: <20180322094024.GD4229@kernel.org>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322093745.GC4229@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Em Thu, Mar 22, 2018 at 06:37:45AM -0300, Arnaldo Carvalho de Melo escreveu:
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

We'd get rid of these:

[acme@jouet patches-4.11.12-rt15]$ grep "^+[[:space:]]\+.*NONRT" *.patch
dm-make-rt-aware.patch:+		BUG_ON_NONRT(!irqs_disabled());
fs-block-rt-support.patch:+	WARN_ON_NONRT(!irqs_disabled());
i915-bogus-warning-from-i915-when-running-on-PREEMPT.patch:+	WARN_ON_NONRT(!in_interrupt());
iommu-amd--Use-WARN_ON_NORT.patch:+	WARN_ON_NONRT(!irqs_disabled());
iommu-amd--Use-WARN_ON_NORT.patch:+	WARN_ON_NONRT(!irqs_disabled());
irqwork-push_most_work_into_softirq_context.patch:+	BUG_ON_NONRT(!irqs_disabled());
net-wireless-warn-nort.patch:+	WARN_ON_ONCE_NONRT(softirq_count() == 0);
posix-timers-thread-posix-cpu-timers-on-rt.patch:+	WARN_ON_ONCE_NONRT(!irqs_disabled());
posix-timers-thread-posix-cpu-timers-on-rt.patch:+	WARN_ON_ONCE_NONRT(!irqs_disabled());
posix-timers-thread-posix-cpu-timers-on-rt.patch:+	WARN_ON_ONCE_NONRT(!irqs_disabled());
workqueue-use-locallock.patch:+	WARN_ON_ONCE_NONRT(!irqs_disabled());
[acme@jouet patches-4.11.12-rt15]$

- Arnaldo
