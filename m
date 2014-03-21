From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression]
	kthread:makekthread_create()killable)
Date: Fri, 21 Mar 2014 21:31:20 +0100
Message-ID: <20140321203120.GA9397@redhat.com>
References: <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com> <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <CA+55aFx8=AszAeeJnSXnOsJKUhx3JjGJko1XiOKYWWRWiUE+SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaCUUc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2014 16:32:28 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx8=AszAeeJnSXnOsJKUhx3JjGJko1XiOKYWWRWiUE+SQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, James Bottomley <JBottomley@parallels.com>, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>

On 03/21, Linus Torvalds wrote:
>
> On Fri, Mar 21, 2014 at 11:34 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes, it seems that it actually needs > 30 secs. It spends most of the time
> > (30.13286 seconds) in [..]
>
> So how about taking a completely different approach:

Due to the lack of knowledge I can not comment (or even actually
understand) your suggestion.

But it probably falls into the "right fix" category, iow "THE FIX
FROM MAINTAINERS" the temporary sigprocmask() hack should wait for.

I can't implement this by the same reason. And of course I won't
insist that we need some really stupid (and wrong) solution until
someone who understand makes the initialization asynchronous.


>  - just say that waiting for devices in the module init sequence for
> over 30 seconds is really really wrong.
>
>  - make the damn mptsas driver just register the controller from the
> init sequence, and then do device discovery asynchronously.
>
> The ATA layer does this correctly: it synchronously finds each host,
> but then it does
>
>         /* perform each probe asynchronously */
>         for (i = 0; i < host->n_ports; i++) {
>                 struct ata_port *ap = host->ports[i];
>                 async_schedule(async_port_probe, ap);
>         }
>
> and I really think SCSI drivers should do the same if they have this
> kind of "ports can take forever to probe" behavior.
>
> What would be the equivalent magic to do this for SCSI? Could we just
> make something like scsi_probe_and_add_lun() just always do this, the
> same way ata_host_register() does it?
>
>                    Linus

