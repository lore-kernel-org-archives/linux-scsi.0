From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Tue, 6 Sep 2016 11:06:42 -0400
Message-ID: <20160906150642.GA22651@hmsreliant.think-freely.org>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
 <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
 <CAK=zhgq__41_y6pgQc5-Rg+RyUUqB80qS=mJ6cYqaQbtf=5N5g@mail.gmail.com>
 <3eab5081-dff4-c7a5-f089-18877bbd6346@sandisk.com>
 <CAK=zhgrLL22stCfwKdpJkN=PkxPVxL=K9RgpP1USEbg_xx5TEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgrLL22stCfwKdpJkN=PkxPVxL=K9RgpP1USEbg_xx5TEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 06, 2016 at 04:52:37PM +0530, Sreekanth Reddy wrote:
> On Fri, Sep 2, 2016 at 4:34 AM, Bart Van Assche
> <bart.vanassche@sandisk.com> wrote:
> > On 09/01/2016 03:31 AM, Sreekanth Reddy wrote:
> >>
> >> I reduced the ISR workload by one third in-order to reduce the time
> >> that is spent per CPU in interrupt context, even then I am observing
> >> softlockups.
> >>
> >> As I mentioned before only same single CPU in the set of CPUs(enabled
> >> in affinity_hint) is busy with handling the interrupts from
> >> corresponding IRQx. I have done below experiment in driver to limit
> >> these softlockups/hardlockups. But I am not sure whether it is
> >> reasonable to do this in driver,
> >>
> >> Experiment:
> >> If the CPUx is continuously busy with handling the remote CPUs
> >> (enabled in the corresponding IRQ's affinity_hint) IO works by 1/4th
> >> of the HBA queue depth in the same ISR context then enable a flag
> >> called 'change_smp_affinity' for this IRQ. Also created a thread with
> >> will poll for this flag for every IRQ's (enabled by driver) for every
> >> second. If this thread see that this flag is enabled for any IRQ then
> >> it will write next CPU number from the CPUs enabled in the IRQ's
> >> affinity_hint to the IRQ's smp_affinity procfs attribute using
> >> 'call_usermodehelper()' API.
> >>
> >> This to make sure that interrupts are not processed by same single CPU
> >> all the time and to make the other CPUs to handle the interrupts if
> >> the current CPU is continuously busy with handling the other CPUs IO
> >> interrupts.
> >>
> >> For example consider a system which has 8 logical CPUs and one MSIx
> >> vector enabled (called IRQ 120) in driver, HBA queue depth as 8K.
> >> then IRQ's procfs attributes will be
> >> IRQ# 120, affinity_hint=0xff, smp_affinity=0x00
> >>
> >> After starting heavy IOs, we will observe that only CPU0 will be busy
> >> with handling the interrupts. This experiment driver will change the
> >> smp_affinity to next CPU number i.e. 0x01 (using cmd 'echo 0x01 >
> >> /proc/irq/120/smp_affinity', driver issue's this cmd using
> >> call_usermodehelper() API) if it observes that CPU0 is continuously
> >> processing more than 2K of IOs replies of other CPUs i.e from CPU1 to
> >> CPU7.
> >>
> >> Whether doing this kind of stuff in driver is ok?
> >
> >
> > Hello Sreekanth,
> >
> > To me this sounds like something that should be implemented in the I/O
> > chipset on the motherboard. If you have a look at the Intel Software
> > Developer Manuals then you will see that logical destination mode supports
> > round-robin interrupt delivery. However, the Linux kernel selects physical
> > destination mode on systems with more than eight logical CPUs (see also
> > arch/x86/kernel/apic/apic_flat_64.c).
> >
> > I'm not sure the maintainers of the interrupt subsystem would welcome code
> > that emulates round-robin interrupt delivery. So your best option is
> > probably to minimize the amount of work that is done in interrupt context
> > and to move as much work as possible out of interrupt context in such a way
> > that it can be spread over multiple CPU cores, e.g. by using
> > queue_work_on().
> >
> > Bart.
> 
> Bart,
> 
> Thanks a lot for providing lot of inputs and valuable information on this issue.
> 
> Today I got one more observation. i.e. I am not observing any lockups
> if I use 1.0.4-6 versioned irqbalance.
> Since this versioned irqbalance is able to shift the load to other CPU
> when one CPU is heavily loaded.
> 

This isn't happening because irqbalance is no longer able to shift load between
cpus, its happening because of commit 996ee2cf7a4d10454de68ac4978adb5cf22850f8.
irqs with higher interrupt volumes sould be balanced to a specific cpu core,
rather than to a cache domain to maximize cpu-local cache hit rates.  Prior to
that change we balanced to a cache domain and your workload didn't have to
serialize multiple interrupts to a single core.  My suggestion to you is to use
the --policyscript option to make your storage irqs get balanced to the cache
level, rather than the core level.  That should return the behavior to what you
want.

Neil

> while running heavy IOs, for first few seconds here is my driver irq's
> attributes,
> --------------------------------------------------------------------------------------------------------------------
> ioc number = 0
> number of core processors = 24
> msix vector count = 2
> number of cores per msix vector = 16
> 
> 
>     msix index = 0, irq number =  50, smp_affinity = 000040
> affinity_hint = 000fff
>     msix index = 1, irq number =  51, smp_affinity = 001000
> affinity_hint = fff000
> 
> We have set affinity for 2 msix vectors and 24 core processors
> ----------------------------------------------------------------------------------------------------------------------
> 
> After few seconds it observed that CPU12 is heavily loaded for IRQ 51
> and it changed the smp_affinity to CPU21
> --------------------------------------------------------------------------------------------------------------------
> ioc number = 0
> number of core processors = 24
> msix vector count = 2
> number of cores per msix vector = 16
> 
> 
>     msix index = 0, irq number =  50, smp_affinity = 000040
> affinity_hint = 000fff
>     msix index = 1, irq number =  51, smp_affinity = 200000
> affinity_hint = fff000
> 
> We have set affinity for 2 msix vectors and 24 core processors
> ---------------------------------------------------------------------------------------------------------------------
> 
> Where as irqblanance versioned 1.0.9 is not able to shift the load to
> the other CPUs enabled in the affinity_hint (even when subset policy
> is enabled) and so I was observing the softlocks/hardlockups.
> 
> Here I have attached irqbalance logs with debug enabled for both versions.
> 
> Thanks,
> Sreekanth
