From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Thu, 1 Sep 2016 16:04:45 -0700
Message-ID: <3eab5081-dff4-c7a5-f089-18877bbd6346@sandisk.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
 <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
 <CAK=zhgq__41_y6pgQc5-Rg+RyUUqB80qS=mJ6cYqaQbtf=5N5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgq__41_y6pgQc5-Rg+RyUUqB80qS=mJ6cYqaQbtf=5N5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/2016 03:31 AM, Sreekanth Reddy wrote:
> I reduced the ISR workload by one third in-order to reduce the time
> that is spent per CPU in interrupt context, even then I am observing
> softlockups.
>
> As I mentioned before only same single CPU in the set of CPUs(enabled
> in affinity_hint) is busy with handling the interrupts from
> corresponding IRQx. I have done below experiment in driver to limit
> these softlockups/hardlockups. But I am not sure whether it is
> reasonable to do this in driver,
>
> Experiment:
> If the CPUx is continuously busy with handling the remote CPUs
> (enabled in the corresponding IRQ's affinity_hint) IO works by 1/4th
> of the HBA queue depth in the same ISR context then enable a flag
> called 'change_smp_affinity' for this IRQ. Also created a thread with
> will poll for this flag for every IRQ's (enabled by driver) for every
> second. If this thread see that this flag is enabled for any IRQ then
> it will write next CPU number from the CPUs enabled in the IRQ's
> affinity_hint to the IRQ's smp_affinity procfs attribute using
> 'call_usermodehelper()' API.
>
> This to make sure that interrupts are not processed by same single CPU
> all the time and to make the other CPUs to handle the interrupts if
> the current CPU is continuously busy with handling the other CPUs IO
> interrupts.
>
> For example consider a system which has 8 logical CPUs and one MSIx
> vector enabled (called IRQ 120) in driver, HBA queue depth as 8K.
> then IRQ's procfs attributes will be
> IRQ# 120, affinity_hint=0xff, smp_affinity=0x00
>
> After starting heavy IOs, we will observe that only CPU0 will be busy
> with handling the interrupts. This experiment driver will change the
> smp_affinity to next CPU number i.e. 0x01 (using cmd 'echo 0x01 >
> /proc/irq/120/smp_affinity', driver issue's this cmd using
> call_usermodehelper() API) if it observes that CPU0 is continuously
> processing more than 2K of IOs replies of other CPUs i.e from CPU1 to
> CPU7.
>
> Whether doing this kind of stuff in driver is ok?

Hello Sreekanth,

To me this sounds like something that should be implemented in the I/O 
chipset on the motherboard. If you have a look at the Intel Software 
Developer Manuals then you will see that logical destination mode 
supports round-robin interrupt delivery. However, the Linux kernel 
selects physical destination mode on systems with more than eight 
logical CPUs (see also arch/x86/kernel/apic/apic_flat_64.c).

I'm not sure the maintainers of the interrupt subsystem would welcome 
code that emulates round-robin interrupt delivery. So your best option 
is probably to minimize the amount of work that is done in interrupt 
context and to move as much work as possible out of interrupt context in 
such a way that it can be spread over multiple CPU cores, e.g. by using 
queue_work_on().

Bart.
