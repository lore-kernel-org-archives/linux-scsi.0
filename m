From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression]
 kthread:makekthread_create()killable)
Date: Fri, 21 Mar 2014 15:56:31 -0700
Message-ID: <1395442591.2240.22.camel@dabdike.int.hansenpartnership.com>
References: <20140317142246.GA27453@redhat.com>
	 <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
	 <20140318171620.GA10636@redhat.com>
	 <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp>
	 <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com>
	 <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com>
	 <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com>
	 <20140321183443.GA3891@redhat.com>
	 <CA+55aFx8=AszAeeJnSXnOsJKUhx3JjGJko1XiOKYWWRWiUE+SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx8=AszAeeJnSXnOsJKUhx3JjGJko1XiOKYWWRWiUE+SQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Joseph Salisbury <joseph.salisbury@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-03-21 at 12:32 -0700, Linus Torvalds wrote:
> On Fri, Mar 21, 2014 at 11:34 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes, it seems that it actually needs > 30 secs. It spends most of the time
> > (30.13286 seconds) in [..]
> 
> So how about taking a completely different approach:
> 
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

Well, we do do this asynchronously.  The idea is that the add host only
initialises the actual hardware.  The port probing is supposed to be
done asynchronously (provided the async probe option is enabled in SCSI,
of course).  The way this is supposed to happen is the driver
initialises the hardware and then calls scsi_scan_host().  If the
platform is set up for async scanning, that kicks off all the async
workqueues and returns (or does it all synchronously if async scanning
isn't enabled).

It is possible fusion gets this wrong because the sas driver doesn't
really couple to SCSI's libsas, which is where it would pick up most of
the generic infrastructure for this.  Plus it depends where all the time
is being wasted.  The fusion was the last sas chipset I got the specs
for (under NDA).  It's actually table driven, so if the problem is the
controller taking ages to fill in the tables it might necessitate a
fusion specific fix.  I can see from the driver that it seems to do all
the probing itself instead of relying on probe callbacks from
scsi_scan_host(), so I know what needs to be fixed ... it's less clear
how easy this would be given how monolithic the routine looks.

James
