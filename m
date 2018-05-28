From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Mon, 28 May 2018 16:35:18 +0200
Message-ID: <20180528143518.f46hyhi5r5jd3oxe@linutronix.de>
References: <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
 <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
 <20180326111359.180f1604@gandalf.local.home>
 <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
 <c9f5df1e54bb2bd8f3f0aef86a55deb11888a6a4.camel@wdc.com>
 <20180328151433.elhw6kgxdxq6fn6b@linutronix.de>
 <86c1243e-8733-c94d-d8ff-5c299b8266a6@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86c1243e-8733-c94d-d8ff-5c299b8266a6@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-03-28 08:31:38 [-0700], Bart Van Assche wrote:
> On 03/28/18 08:14, bigeasy@linutronix.de wrote:
> > On 2018-03-28 15:05:41 [+0000], Bart Van Assche wrote:
> > > The names of the two functions touched by patch 1/2 start with a double
> > > underscore. That by itself is already a hint that these should be called with
> > > a lock held (I know that this is not a universal convention in the Linux
> > > kernel). I'm fine either way - either with patch 1/2 as posted or patch 1/2
> > > with the above comment added.
> > 
> > Okay. In that case let me update 1/2.
> > But 2/2 with the comment as Steven suggested is still a no no for you?
> 
> Although I'm not enthusiast about patch 2/2, if others agree with that patch
> I'm fine with that patch being sent upstream.

I've been waiting for something to happen but nobody replied.
Bart, you were fine with 1/2 as posted but not too happy about 2/2.
Assuming we keep 1/2 as is and I remove just the
"WARN_ON_ONCE(!irqs_disabled());" from 2/2 (keeping the
assert_spin_locked()), would that improve your mood? Lockdep would still
perform full validation, yell if __transport_check_aborted_status() was
invoked without locking and also yell abut missing IRQ-save at locking
time of ->t_state_lock).

> Thanks,
> 
> Bart.

Sebastian
