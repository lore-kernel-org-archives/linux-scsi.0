From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [v3.13][v3.14][Regression] kthread:makekthread_create()killable
Date: Wed, 19 Mar 2014 18:52:53 +0100
Message-ID: <20140319175253.GB11923@redhat.com>
References: <20140316162512.GA9467@redhat.com> <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp> <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp> <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5329C22A.5070206@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/19, Joseph Salisbury wrote:
>
> On 03/19/2014 07:49 AM, Tetsuo Handa wrote:

Hmm. Apparently I missed this email from Tetsuo. I'll reply here.

> > Oleg Nesterov wrote:
> >
> >> And btw, it is not clear to me if in this case device initialization really
> >> needs more than 30 seconds... My understanding is probably wrong, so please
> >> correct me. But it seems that before your "make kthread_create() killable"
> >>
> >> 	- probe hangs
> >>
> >> 	- SIGKILL wakes it up
> >>
> >> 	- so I assume that the probe was interrupted and didn't finish
> >> 	  correctly ???
> >>
> >> 	- initialization continues, does scsi_host_alloc(), etc, and
> >> 	  everything works fine even if probe was interrupted?
> >>
> > I confirmed that device initialization really took more than 30 seconds
> > ( comments #51 and #52 ).

Thanks. However I still think this needs more investigation. May be I'll
write another email, but given that maintainers do not care...

> >> So perhaps that probe should not hang and this should be fixed too ?
> >> Do you know where exactly it hangs? And where it is woken up by SIGKILL ?
> >> Or I totally misunderstood ?
> > The probe did not hang.

It doesn't hang forever. Otherwise see above.

> > SIGKILL affected only wait_for_completion_killable()
> > in kthread_create_on_node() called by mptsas_probe() via scsi_host_alloc().

This wad already clear,

> > Thus, the probe was interrupted because kthread_run() returned an error.

No, #51 / #52 can't prove this. I think that kthread_run() or even
scsi_host_alloc() was called with fatal_signal_pending(). What did the probe
task do before? This is not clear. But again, see above.

> >> Ah, I see, you mean that kmalloc() can do this every time. No, this should
> >> not happen or we have another problem.
> > Then, what happens if somebody does
> >
> >   while (1)
> >       kill(pid, SIGKILL);
> >
> > where pid is the process calling kthread_run() from the "for (;;)" loop in
> > scsi_host_alloc()?

Nothing good. So what?

Tetsuo, how many time I should repeat that I only tried to suggest the
temporary dirty hack to close the regression ? ;)

And once again, I agree with any change in scsi_host_alloc/etc, I suggested
this (pseudo) code for example.

> >> Dear maintainers, we need your help.
> >>
> > Right. We found that we can fix this problem by updating systemd-udevd to
> > support longer timeout ( comment #53 ). Joseph, would you consult systemd
> > maintainers?
>
> Thanks everyone for reviewing this bug.  Message sent to systemd mailing
> list:
> http://lists.freedesktop.org/archives/systemd-devel/2014-March/018006.html

OK, good, thanks.

But please do not forget that the kernel crashes. Whatever else we do, this
should be fixed anyway. And this should be fixed in driver.

Oleg.
