From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Thu, 1 Sep 2016 16:01:20 +0530
Message-ID: <CAK=zhgq__41_y6pgQc5-Rg+RyUUqB80qS=mJ6cYqaQbtf=5N5g@mail.gmail.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com> <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 19, 2016 at 9:26 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 08/19/2016 04:44 AM, Sreekanth Reddy wrote:
>>
>> [  +0.000439] __blk_mq_run_hw_queue() finished after 10058 ms
>> [ ... ]
>> [  +0.000005]  [<ffffffff810c392b>] ? finish_task_switch+0x6b/0x200
>> [  +0.000006]  [<ffffffff8176dabc>] __schedule+0x36c/0x950
>> [  +0.000002]  [<ffffffff8176e0d7>] schedule+0x37/0x80
>> [  +0.000006]  [<ffffffff81116a1c>] futex_wait_queue_me+0xbc/0x120
>> [  +0.000004]  [<ffffffff81116da9>] futex_wait+0x119/0x270
>> [  +0.000004]  [<ffffffff81116800>] ? futex_wake+0x90/0x180
>> [  +0.000003]  [<ffffffff81118d6b>] do_futex+0x12b/0xb00
>> [  +0.000005]  [<ffffffff810d348e>] ? set_next_entity+0x23e/0x440
>> [  +0.000007]  [<ffffffff810136f1>] ? __switch_to+0x261/0x4b0
>> [  +0.000004]  [<ffffffff811197c1>] SyS_futex+0x81/0x180
>> [  +0.000002]  [<ffffffff8176e0d7>] ? schedule+0x37/0x80
>> [  +0.000004]  [<ffffffff817721ae>] entry_SYSCALL_64_fastpath+0x12/0x71
>
>
> Hello Sreekanth,
>
> If a "soft lockup" is reported that often means that kernel code is
> iterating too long in a loop without giving up the CPU. Inserting a
> cond_resched() call in such loops usually resolves these soft lockup
> complaints. However, your latest e-mail shows that the soft lockup complaint
> was reported on other code than __blk_mq_run_hw_queue(). I'm afraid this
> means that the CPU on which the soft lockup was reported is hammered so hard
> with interrupts that hardly any time remains for the scheduler to run code
> on that CPU. You will have to follow Robert Elliott's advice and reduce the
> time that is spent per CPU in interrupt context.
>

Sorry for delay in response as I was on Vacation.

Bart,

I reduced the ISR workload by one third in-order to reduce the time
that is spent per CPU in interrupt context, even then I am observing
softlockups.

As I mentioned before only same single CPU in the set of CPUs(enabled
in affinity_hint) is busy with handling the interrupts from
corresponding IRQx. I have done below experiment in driver to limit
these softlockups/hardlockups. But I am not sure whether it is
reasonable to do this in driver,

Experiment:
If the CPUx is continuously busy with handling the remote CPUs
(enabled in the corresponding IRQ's affinity_hint) IO works by 1/4th
of the HBA queue depth in the same ISR context then enable a flag
called 'change_smp_affinity' for this IRQ. Also created a thread with
will poll for this flag for every IRQ's (enabled by driver) for every
second. If this thread see that this flag is enabled for any IRQ then
it will write next CPU number from the CPUs enabled in the IRQ's
affinity_hint to the IRQ's smp_affinity procfs attribute using
'call_usermodehelper()' API.

This to make sure that interrupts are not processed by same single CPU
all the time and to make the other CPUs to handle the interrupts if
the current CPU is continuously busy with handling the other CPUs IO
interrupts.

For example consider a system which has 8 logical CPUs and one MSIx
vector enabled (called IRQ 120) in driver, HBA queue depth as 8K.
then IRQ's procfs attributes will be
IRQ# 120, affinity_hint=0xff, smp_affinity=0x00

After starting heavy IOs, we will observe that only CPU0 will be busy
with handling the interrupts. This experiment driver will change the
smp_affinity to next CPU number i.e. 0x01 (using cmd 'echo 0x01 >
/proc/irq/120/smp_affinity', driver issue's this cmd using
call_usermodehelper() API) if it observes that CPU0 is continuously
processing more than 2K of IOs replies of other CPUs i.e from CPU1 to
CPU7.

Whether doing this kind of stuff in driver is ok?

Thanks,
Sreekanth

> Bart.
