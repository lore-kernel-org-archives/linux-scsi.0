From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression] kthread:makekthread_create()killable)
Date: Fri, 21 Mar 2014 12:32:17 -0700
Message-ID: <CA+55aFx8=AszAeeJnSXnOsJKUhx3JjGJko1XiOKYWWRWiUE+SQ@mail.gmail.com>
References: <20140317142246.GA27453@redhat.com>
	<201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
	<20140318171620.GA10636@redhat.com>
	<201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp>
	<5329C22A.5070206@canonical.com>
	<20140319175253.GB11923@redhat.com>
	<20140319182910.GA14511@redhat.com>
	<20140319194232.GA6207@redhat.com>
	<532B1B67.5050104@canonical.com>
	<20140320192307.GA11883@redhat.com>
	<20140321183443.GA3891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140321183443.GA3891@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, James Bottomley <JBottomley@parallels.com>, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 21, 2014 at 11:34 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes, it seems that it actually needs > 30 secs. It spends most of the time
> (30.13286 seconds) in [..]

So how about taking a completely different approach:

 - just say that waiting for devices in the module init sequence for
over 30 seconds is really really wrong.

 - make the damn mptsas driver just register the controller from the
init sequence, and then do device discovery asynchronously.

The ATA layer does this correctly: it synchronously finds each host,
but then it does

        /* perform each probe asynchronously */
        for (i = 0; i < host->n_ports; i++) {
                struct ata_port *ap = host->ports[i];
                async_schedule(async_port_probe, ap);
        }

and I really think SCSI drivers should do the same if they have this
kind of "ports can take forever to probe" behavior.

What would be the equivalent magic to do this for SCSI? Could we just
make something like scsi_probe_and_add_lun() just always do this, the
same way ata_host_register() does it?

                   Linus
