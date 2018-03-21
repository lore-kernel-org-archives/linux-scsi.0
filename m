From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Wed, 21 Mar 2018 11:43:58 -0700
Message-ID: <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
References: <20180321153854.GB24312@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321153854.GB24312@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Daniel Bristot de Oliveira <daniel@bristot.me>, =?UTF-8?Q?Luis_Claudio_R=2E_Gon=C3=A7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[ Adding PeterZ to participants due to query about lockdep_assert() ]

On Wed, Mar 21, 2018 at 8:38 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
>         assert_spin_locked(&cmd->t_state_lock);
> -       WARN_ON_ONCE(!irqs_disabled());
> +       WARN_ON_ONCE_NONRT(!irqs_disabled());

Ugh.

Can't we just replace both of those with a lockdep annotation?

Does "lockdep_assert_held()" already verify the irq contextr, or do we
need lockdep_assert_irqs_disabled() too?

Honestly, the old-fashioned way of doing verification of state by hand
is understandable, but it's legacy and kind of pointless when we have
much better tools these days.

I'm perfectly willing to leave old assertions in place, but if they
need fixing anyway, I'd damn well want to fix them *right* instead of
starting to just add more piles of hacks on top of the old model.

Because when the details of the locking rules depend on RT vs non-RT,
I want the checks to make sense.  And presumably lockdep is the thing
that really knows what the status of a lock is, no?

                  Linus
