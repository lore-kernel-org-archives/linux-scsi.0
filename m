From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Wed, 7 Sep 2016 09:24:43 -0400
Message-ID: <20160907132443.GA21945@hmsreliant.think-freely.org>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
 <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
 <CAK=zhgq__41_y6pgQc5-Rg+RyUUqB80qS=mJ6cYqaQbtf=5N5g@mail.gmail.com>
 <3eab5081-dff4-c7a5-f089-18877bbd6346@sandisk.com>
 <CAK=zhgrLL22stCfwKdpJkN=PkxPVxL=K9RgpP1USEbg_xx5TEg@mail.gmail.com>
 <20160906150642.GA22651@hmsreliant.think-freely.org>
 <CAK=zhgquwfpSLNHQr4nV=K3Hr4XduCFEOtgst-4kvO2SeufuiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59113 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbcIGNZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2016 09:25:02 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgquwfpSLNHQr4nV=K3Hr4XduCFEOtgst-4kvO2SeufuiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

On Wed, Sep 07, 2016 at 11:30:04AM +0530, Sreekanth Reddy wrote:
> On Tue, Sep 6, 2016 at 8:36 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Tue, Sep 06, 2016 at 04:52:37PM +0530, Sreekanth Reddy wrote:
> >> On Fri, Sep 2, 2016 at 4:34 AM, Bart Van Assche
> >> <bart.vanassche@sandisk.com> wrote:
> >> > On 09/01/2016 03:31 AM, Sreekanth Reddy wrote:
> >> >>
> >> >> I reduced the ISR workload by one third in-order to reduce the time
> >> >> that is spent per CPU in interrupt context, even then I am observing
> >> >> softlockups.
> >> >>
> >> >> As I mentioned before only same single CPU in the set of CPUs(enabled
> >> >> in affinity_hint) is busy with handling the interrupts from
> >> >> corresponding IRQx. I have done below experiment in driver to limit
> >> >> these softlockups/hardlockups. But I am not sure whether it is
> >> >> reasonable to do this in driver,
> >> >>
> >> >> Experiment:
> >> >> If the CPUx is continuously busy with handling the remote CPUs
> >> >> (enabled in the corresponding IRQ's affinity_hint) IO works by 1/4th
> >> >> of the HBA queue depth in the same ISR context then enable a flag
> >> >> called 'change_smp_affinity' for this IRQ. Also created a thread with
> >> >> will poll for this flag for every IRQ's (enabled by driver) for every
> >> >> second. If this thread see that this flag is enabled for any IRQ then
> >> >> it will write next CPU number from the CPUs enabled in the IRQ's
> >> >> affinity_hint to the IRQ's smp_affinity procfs attribute using
> >> >> 'call_usermodehelper()' API.
> >> >>
> >> >> This to make sure that interrupts are not processed by same single CPU
> >> >> all the time and to make the other CPUs to handle the interrupts if
> >> >> the current CPU is continuously busy with handling the other CPUs IO
> >> >> interrupts.
> >> >>
> >> >> For example consider a system which has 8 logical CPUs and one MSIx
> >> >> vector enabled (called IRQ 120) in driver, HBA queue depth as 8K.
> >> >> then IRQ's procfs attributes will be
> >> >> IRQ# 120, affinity_hint=0xff, smp_affinity=0x00
> >> >>
> >> >> After starting heavy IOs, we will observe that only CPU0 will be busy
> >> >> with handling the interrupts. This experiment driver will change the
> >> >> smp_affinity to next CPU number i.e. 0x01 (using cmd 'echo 0x01 >
> >> >> /proc/irq/120/smp_affinity', driver issue's this cmd using
> >> >> call_usermodehelper() API) if it observes that CPU0 is continuously
> >> >> processing more than 2K of IOs replies of other CPUs i.e from CPU1 to
> >> >> CPU7.
> >> >>
> >> >> Whether doing this kind of stuff in driver is ok?
> >> >
> >> >
> >> > Hello Sreekanth,
> >> >
> >> > To me this sounds like something that should be implemented in the I/O
> >> > chipset on the motherboard. If you have a look at the Intel Software
> >> > Developer Manuals then you will see that logical destination mode supports
> >> > round-robin interrupt delivery. However, the Linux kernel selects physical
> >> > destination mode on systems with more than eight logical CPUs (see also
> >> > arch/x86/kernel/apic/apic_flat_64.c).
> >> >
> >> > I'm not sure the maintainers of the interrupt subsystem would welcome code
> >> > that emulates round-robin interrupt delivery. So your best option is
> >> > probably to minimize the amount of work that is done in interrupt context
> >> > and to move as much work as possible out of interrupt context in such a way
> >> > that it can be spread over multiple CPU cores, e.g. by using
> >> > queue_work_on().
> >> >
> >> > Bart.
> >>
> >> Bart,
> >>
> >> Thanks a lot for providing lot of inputs and valuable information on this issue.
> >>
> >> Today I got one more observation. i.e. I am not observing any lockups
> >> if I use 1.0.4-6 versioned irqbalance.
> >> Since this versioned irqbalance is able to shift the load to other CPU
> >> when one CPU is heavily loaded.
> >>
> >
> > This isn't happening because irqbalance is no longer able to shift load between
> > cpus, its happening because of commit 996ee2cf7a4d10454de68ac4978adb5cf22850f8.
> > irqs with higher interrupt volumes sould be balanced to a specific cpu core,
> > rather than to a cache domain to maximize cpu-local cache hit rates.  Prior to
> > that change we balanced to a cache domain and your workload didn't have to
> > serialize multiple interrupts to a single core.  My suggestion to you is to use
> > the --policyscript option to make your storage irqs get balanced to the cache
> > level, rather than the core level.  That should return the behavior to what you
> > want.
> >
> > Neil
> 
> Hi Neil,
> 
> Thanks for reply.
> 
> Today I tried with setting balance_level to 'cache' for mpt3sas driver
> IRQ's using below policy script and used 1.0.9 versioned irqbalance,
> ----------------------------------------------------------------------------------------------
> #!/bin/bash
> # Header
> # Linux Shell Scripting for Irq Balance Policy select for mpt3sas driver
> #
> 
> # Command Line Args
>  #IRQ_PATH    -> PATH
>  #IRQ_NUMBER     -> IRQ Number
> declare -r IRQ_PATH=$1
> declare -r IRQ_NUMBER=$2
> 
> if [ -d /proc/irq/$IRQ_NUMBER ]; then
>         mpt3sas_irq=(`ls /proc/irq/$IRQ_NUMBER/ | grep mpt3sas | wc -l`)
>         if [ $mpt3sas_irq == 1 ]; then
>             echo "hintpolicy=subset"
>             echo "balance_level=cache"
>     fi
> fi
> -----------------------------------------------------------------------------------------------
> 
> But still I don't see any load shift happening between the CPUs and
> still observing hardlockups.
> 
> Here I have attached the irqbalance logs.
> 
> Thanks,
> Sreekanth

Hey there-
	So, looking at your logs, your script is working correctly:
Package 0:  numa_node is 0 cpu mask is 0003f03f (load 0)
        Cache domain 0:  numa_node is 0 cpu mask is 00001001  (load 0)
                CPU number 0  numa_node is 0 (load 0)
                  Interrupt 150 node_num is 0 (storage/1)
                  Interrupt 174 node_num is 0 (storage/1)
                  Interrupt 198 node_num is 0 (storage/1)
                  Interrupt 126 node_num is 0 (storage/1)
                  Interrupt 102 node_num is 0 (ethernet/1)
                  Interrupt 77 node_num is 0 (ethernet/1)
                CPU number 12  numa_node is 0 (load 0)
                  Interrupt 138 node_num is 0 (storage/1)
                  Interrupt 162 node_num is 0 (storage/1)
                  Interrupt 186 node_num is 0 (storage/1)
                  Interrupt 114 node_num is 0 (storage/1)
                  Interrupt 90 node_num is 0 (ethernet/1)
                  Interrupt 65 node_num is 0 (ethernet/1)
          Interrupt 51 node_num is -1 (storage/1)
          Interrupt 31 node_num is 0 (legacy/1)
...
Package 1:  numa_node is 0 cpu mask is 00fc0fc0 (load 0)
        Cache domain 6:  numa_node is 0 cpu mask is 00040040  (load 0)
                CPU number 6  numa_node is 0 (load 0)
                  Interrupt 149 node_num is 0 (storage/1)
                  Interrupt 173 node_num is 0 (storage/1)
                  Interrupt 197 node_num is 0 (storage/1)
                  Interrupt 125 node_num is 0 (storage/1)
                  Interrupt 101 node_num is 0 (ethernet/1)
                  Interrupt 76 node_num is 0 (ethernet/1)
                CPU number 18  numa_node is 0 (load 0)
                  Interrupt 137 node_num is 0 (storage/1)
                  Interrupt 161 node_num is 0 (storage/1)
                  Interrupt 185 node_num is 0 (storage/1)
                  Interrupt 113 node_num is 0 (storage/1)
                  Interrupt 89 node_num is 0 (ethernet/1)
                  Interrupt 64 node_num is 0 (ethernet/1)
          Interrupt 50 node_num is -1 (storage/1)


irqbalance correctly decided to balance irqs 50 and 51 to the cache level, which
is good. The only other thing I would check though is the affinity_hint those
irqs are exporting.  With an affinity hint set to subset, if the exported hint
only intersects the cache domain cpu set at one cpu, you will still only get
affinity for that one cpu.  You may want to consider changing the hintpolicy for
those interrupts to ignore, to ensure that you have affinity for two cpus.

Beyond that though, the kernel is in control of irq delivery.  Normally the
configured hardware delivery policy is to select the highest priority cpu that
isn't already servicing an interrupt (to maximize cache hit rates).  If the irq
rate is sufficiently slow however, it will always hit the same cpu, because it
isn't blocked by another interrupt.

Best
Neil

