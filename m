From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: please fix FUSION
 (Was:[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
Date: Sun, 23 Mar 2014 07:29:10 -0700
Message-ID: <1395584950.2200.9.camel@dabdike.int.hansenpartnership.com>
References: <20140321183443.GA3891@redhat.com>
	  <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
	  <20140322192511.GA14811@redhat.com>
	  <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
	  <alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
	 <201403230857.IGH51500.FOHtQMFVOFOLJS@I-love.SAKURA.ne.jp>
	  <alpine.DEB.2.02.1403230856500.18573@ionos.tec.linutronix.de>
	 <1395584368.2200.3.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.02.1403231524100.18573@ionos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1403231524100.18573@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, oleg@redhat.com, joseph.salisbury@canonical.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-03-23 at 15:28 +0100, Thomas Gleixner wrote:
> On Sun, 23 Mar 2014, James Bottomley wrote:
> > On Sun, 2014-03-23 at 09:04 +0100, Thomas Gleixner wrote:
> > > On Sun, 23 Mar 2014, Tetsuo Handa wrote:
> > > 
> > > > Thomas Gleixner wrote:
> > > > > But then systemd/udev mutters:
> > > > > 
> > > > >    "You migh be able to work around the timeout with udev rules and
> > > > >     OPTIONS+="event_timeout=120", but that code was maybe never used
> > > > >     or tested, so it might not work correctly." [1]
> > > > > 
> > > > > AFAICT from the ubuntu bug system [2] nobody bothered even to try that.
> > > > > 
> > > > > And if the udev/systemd event_timeout option is broken it's way better
> > > > > to fix that one instead of hacking random heuristics into the kernel.
> > > > 
> > > > I haven't tried the event_timeout= option but I think it will not work.
> > > > The timeout is hard coded as shown below and there will be no chance for taking
> > > > the event_timeout= option into account.
> > > > 
> > > > ---------- systemd-204/src/udev/udevd.c start ----------
> > > > (...snipped...)
> > > >                         /* check for hanging events */
> > > >                         udev_list_node_foreach(loop, &worker_list) {
> > > >                                 struct worker *worker = node_to_worker(loop);
> > > > 
> > > >                                 if (worker->state != WORKER_RUNNING)
> > > >                                         continue;
> > > > 
> > > >                                 if ((now(CLOCK_MONOTONIC) - worker->event_start_usec) > 30 * 1000 * 1000) {
> > > 
> > > And because systemd has an immutable hardcoded random timeout we add
> > > another hardcoded random timeout into kthread_create() to work around
> > > that.
> > > 
> > > How broken is that?
> > > 
> > > And it seems other people have solved it:
> > > 
> > >     http://www.redhat.com/archives/lvm-devel/2013-September/msg00036.html
> > 
> > I agree with Thomas.  A hardcoded timeout is a systemd bug.  However,
> > could I get confirmation, while you can use this bug to do it, that the
> > patch back in this thread actually fixes the crash when scsi_alloc_host
> > fails, that's the serious SCSI bug, in my view?
> 
> Which patch, the one to kthread_create() or the one to SCSI?

The one to SCSI ... I'm only really interested in the oops when
scsi_host_alloc fails.

James
