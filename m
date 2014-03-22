From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: please fix FUSION (Was:
 [v3.13][v3.14][Regression]kthread:makekthread_create()killable)
Date: Sat, 22 Mar 2014 23:01:50 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
References: <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
 <20140322192511.GA14811@redhat.com> <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joseph.salisbury@canonical.com, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 22 Mar 2014, Thomas Gleixner wrote:
> On Sat, 22 Mar 2014, Oleg Nesterov wrote:
> > Personally I dislike this change. In fact I think it is ugly. But this
> > is only my opinion.
> 
> It's not only ugly, it's activly wrong. It's as wrong as 786235ee
> itself. And 786235ee needs to be reverted and the revert must go into
> 3.13.stable as well. I'll send a revert request in separate mail.

Sorry. I misread the combo of both patches. 786235ee is correct. We
definitely don't want to revert it. 

But I still think, that changing this to butt ugly heuristics with an
arbitrary chosen timeout is not the proper solution to "fix" a driver
problem and to work around a systemd policy which mandates that
modprobe must return in 30 seconds.

But then systemd/udev mutters:

   "You migh be able to work around the timeout with udev rules and
    OPTIONS+="event_timeout=120", but that code was maybe never used
    or tested, so it might not work correctly." [1]

AFAICT from the ubuntu bug system [2] nobody bothered even to try that.

And if the udev/systemd event_timeout option is broken it's way better
to fix that one instead of hacking random heuristics into the kernel.

Thanks,

	tglx

[1] http://lists.freedesktop.org/archives/systemd-devel/2014-March/018007.html
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705
