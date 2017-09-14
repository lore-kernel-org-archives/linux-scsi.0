From: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Subject: Re: system hung up when offlining CPUs
Date: Thu, 14 Sep 2017 12:28:11 -0400
Message-ID: <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <20170809124213.0d9518bb@why.wild-wind.fr.eu.org>
 <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com>
 <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
 <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
 <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709131529400.1874@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, yasu.isimatu@gmail.com
List-Id: linux-scsi@vger.kernel.org



On 09/13/2017 09:33 AM, Thomas Gleixner wrote:
> On Wed, 13 Sep 2017, Kashyap Desai wrote:
>>> On 09/12/2017 08:15 PM, YASUAKI ISHIMATSU wrote:
>>>> + linux-scsi and maintainers of megasas
> 
>>>>> In my server, IRQ#66-89 are sent to CPU#24-29. And if I offline
>>>>> CPU#24-29, I/O does not work, showing the following messages.
> 
> ....
> 
>>> This indeed looks like a problem.
>>> We're going to great lengths to submit and complete I/O on the same CPU,
>>> so
>>> if the CPU is offlined while I/O is in flight we won't be getting a
>>> completion for
>>> this particular I/O.
>>> However, the megasas driver should be able to cope with this situation;
>>> after
>>> all, the firmware maintains completions queues, so it would be dead easy
>>> to
>>> look at _other_ completions queues, too, if a timeout occurs.
>> In case of IO timeout, megaraid_sas driver is checking other queues as well.
>> That is why IO was completed in this case and further IOs were resumed.
>>
>> Driver complete commands as below code executed from
>> megasas_wait_for_outstanding_fusion().
>>     for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
>>         complete_cmd_fusion(instance, MSIxIndex);
>>
>> Because of above code executed in driver, we see only one print as below in
>> this logs.
>> megaraid_sas 0000:02:00.0: [ 0]waiting for 2 commands to complete for scsi0
>>
>> As per below link CPU hotplug will take care- "All interrupts targeted to
>> this CPU are migrated to a new CPU"
>> https://www.kernel.org/doc/html/v4.11/core-api/cpu_hotplug.html
>>
>> BTW - We are also able reproduce this issue locally.  Reason for IO timeout
>> is -" IO is completed, but corresponding interrupt did not arrived on Online
>> CPU. Either missed due to CPU is in transient state of being OFFLINED. I am
>> not sure which component should take care this."
>>
>> Question - "what happens once __cpu_disable is called and some of the queued
>> interrupt has affinity to that particular CPU ?"
>> I assume ideally those pending/queued Interrupt should be migrated to
>> remaining online CPUs. It should not be unhandled if we want to avoid such
>> IO timeout.
> 
> Can you please provide the following information, before and after
> offlining the last CPU in the affinity set:
> 
> # cat /proc/irq/$IRQNUM/smp_affinity_list
> # cat /proc/irq/$IRQNUM/effective_affinity
> # cat /sys/kernel/debug/irq/irqs/$IRQNUM
> 
> The last one requires: CONFIG_GENERIC_IRQ_DEBUGFS=y

Here are one irq's info of megasas:

- Before offline CPU
/proc/irq/70/smp_affinity_list
24-29

/proc/irq/70/effective_affinity
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,3f000000

/sys/kernel/debug/irq/irqs/70
handler:  handle_edge_irq
status:   0x00004000
istate:   0x00000000
ddepth:   0
wdepth:   0
dstate:   0x00609200
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_MOVE_PCNTXT
            IRQD_AFFINITY_SET
            IRQD_AFFINITY_MANAGED
node:     1
affinity: 24-29
effectiv: 24-29
pending:
domain:  INTEL-IR-MSI-0-2
 hwirq:   0x100018
 chip:    IR-PCI-MSI
  flags:   0x10
             IRQCHIP_SKIP_SET_WAKE
 parent:
    domain:  INTEL-IR-0
     hwirq:   0x400000
     chip:    INTEL-IR
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x46
         chip:    APIC
          flags:   0x0

- After offline CPU#24-29
/proc/irq/70/smp_affinity_list
29

/proc/irq/70/effective_affinity
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,20000000

/sys/kernel/debug/irq/irqs/70
handler:  handle_edge_irq
status:   0x00004000
istate:   0x00000000
ddepth:   1
wdepth:   0
dstate:   0x00a39000
            IRQD_IRQ_DISABLED
            IRQD_IRQ_MASKED
            IRQD_MOVE_PCNTXT
            IRQD_AFFINITY_SET
            IRQD_AFFINITY_MANAGED
            IRQD_MANAGED_SHUTDOWN
node:     1
affinity: 29
effectiv: 29
pending:
domain:  INTEL-IR-MSI-0-2
 hwirq:   0x100018
 chip:    IR-PCI-MSI
  flags:   0x10
             IRQCHIP_SKIP_SET_WAKE
 parent:
    domain:  INTEL-IR-0
     hwirq:   0x400000
     chip:    INTEL-IR
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x46
         chip:    APIC
          flags:   0x0

Thanks,
Yasuaki Ishimatsu

> 
> Thanks,
> 
> 	tglx
> 
