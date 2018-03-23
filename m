From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Fri, 23 Mar 2018 17:33:31 +0100
Message-ID: <20180323163331.ajxula7nj5bmqiwh@linutronix.de>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521822325.2535.5.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-03-23 16:25:25 [+0000], Bart Van Assche wrote:
> On Fri, 2018-03-23 at 16:55 +0100, Sebastian Andrzej Siewior wrote:
> > I am going take this into -RT tree for now until we have different
> > solution.
> 
> Have you considered to delete the WARN_ON_ONCE(!irqs_disabled()) statement?
> I think that check duplicates functionality that already exists in lockdep
> since lockdep is already able to detect spinlock use inconsistencies.

correct. That is why I suggested to use lockdep_assert_held() instead of
this IRQ-check + the spin_lock_assert().
The only downside is that this code (as of now) works with lockdep
disabled. On the other hand, lockdep_assert_held() gives you a splat
instead of a BUG() statement like spin_lock_assert() does so I clearly
promote lockdep here :)

> Bart.

Sebastian
