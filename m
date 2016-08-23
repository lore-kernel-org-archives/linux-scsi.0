From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: Observing Softlockup's while running heavy IOs
Date: Tue, 23 Aug 2016 15:22:16 +0530
Message-ID: <f3c5dbadde0f4a7d78c49b7ad49fc937@mail.gmail.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com> <DF4PR84MB01695445B0BE8A046742942DAB160@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DF4PR84MB01695445B0BE8A046742942DAB160@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, irqbalance@lists.infradead.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Elliott, Robert (Persistent Memory) [mailto:elliott@hpe.com]
> Sent: Saturday, August 20, 2016 2:58 AM
> To: Sreekanth Reddy
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> irqbalance@lists.infradead.org; Kashyap Desai; Sathya Prakash Veerichetty;
> Chaitra Basappa; Suganath Prabu Subramani
> Subject: RE: Observing Softlockup's while running heavy IOs
>
>
>
> > -----Original Message-----
> > From: Sreekanth Reddy [mailto:sreekanth.reddy@broadcom.com]
> > Sent: Friday, August 19, 2016 6:45 AM
> > To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> > Subject: Re: Observing Softlockup's while running heavy IOs
> >
> ...
> > Yes I am also observing that all the interrupts are routed to one CPU.
> > But still I observing softlockups (sometime hardlockups) even when I
> > set rq_affinity to 2.

How about below scenario ?  For simplicity. HBA with single MSI-x vector.
(Whenever HBA supports less MSI-x and logical CPUs are more on system, we
can see chance of these issue frequently..)

Assume we have 32 logical CPU  (4 socket, each with 8 logical CPU). CPU-0 is
not participating in IO.
Remaining CPU range from 1 to 31 is submitting IO. In such a scenario
rq_affinity=2 and irqbalance supporting *exact* smp_affinity_hint will not
help.

We may see soft/hard lockup on CPU-0.. Are we going to resolve such issue or
it is very rare to happen on field  ?


>
> That'll ensure the block layer's completion handling is done there, but
> not your
> driver's interrupt handler (which precedes the block layer completion
> handling).
>
>
> > Is their any way to route the interrupts the same CPUs which has
> > submitted the corresponding IOs?
> > or
> > Is their any way/option in the irqbalance/kernel which can route
> > interrupts to CPUs (enabled in affinity_hint) in round robin manner
> > after specific time period.
>
> Ensure your driver creates one MSIX interrupt per CPU core, uses that
> interrupt
> for all submissions from that core, and reports that it would like that
> interrupt to
> be serviced by that core in /proc/irq/nnn/affinity_hint.
>
> Even with hyperthreading, this needs to be based on the logical CPU cores,
> not
> just the physical core or the physical socket.
> You can swamp a logical CPU core as easily as a physical CPU core.
>
> Then, provide an irqbalance policy script that honors the affinity_hint
> for your
> driver, or turn off irqbalance and manually set /proc/irq/nnn/smp_affinity
> to
> match the affinity_hint.
>
> Some versions of irqbalance honor the hints; some purposely don't and need
> to
> be overridden with a policy script.
>
>
> ---
> Robert Elliott, HPE Persistent Memory
>
