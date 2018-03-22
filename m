From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Thu, 22 Mar 2018 10:47:01 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1803221046480.1579@nanos.tec.linutronix.de>
References: <20180321153854.GB24312@kernel.org> <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com> <20180322093745.GC4229@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322093745.GC4229@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Daniel Bristot de Oliveira <daniel@bristot.me>, =?ISO-8859-15?Q?Luis_Claudio_R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 22 Mar 2018, Arnaldo Carvalho de Melo wrote:
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

That's the evil plan :)
