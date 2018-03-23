From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Fri, 23 Mar 2018 09:37:40 -0700
Message-ID: <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
References: <20180321153854.GB24312@kernel.org> <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org> <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521822325.2535.5.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 23, 2018 at 9:25 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> Have you considered to delete the WARN_ON_ONCE(!irqs_disabled()) statement?
> I think that check duplicates functionality that already exists in lockdep
> since lockdep is already able to detect spinlock use inconsistencies.

Please just delete both lines.

There is exactly two callers of that static function, and both of them do

        spin_lock_irq(&cmd->t_state_lock);

right above the call.

It's not like this is some function that is exported to random users,
and we should check that the calling convention is right.

So honestly, even lockdep annotations look like you don't need them.

This looks like "it may have been useful during coding to document
things, but it's not useful long-term".

Sure, the annotation is not wrong, but even if you go "verification is
good", you should ask yourself whether there are maybe better places
that would catch more relevant problems, than putting verification
into some static function with two trivially correct callers wrt this
verification?

              Linus
