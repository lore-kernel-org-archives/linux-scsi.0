From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Tue, 18 Nov 2008 12:14:42 -0800
Message-ID: <49232232.10604@oracle.com>
References: <20080821091514.8f56e2d5.randy.dunlap@oracle.com>	<0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>	<20080821172653.3e3e855c.randy.dunlap@oracle.com>	<0F5B06BAB751E047AB5C87D1F77A77883511810706@GVW0547EXC.americas.hpqcorp.net>	<1219420487.3339.22.camel@localhost.localdomain>	<48AEEE0A.1010900@oracle.com>	<1219424538.3339.51.camel@localhost.localdomain>	<0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net>	<48C013D9.7060309@oracle.com>	<0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net>	<20080905092838.GS20055@kernel.dk>	<48DBF583.3050307@oracle.com> <20080925134000.9b133f8c.randy.dunlap@oracle.com> <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:37901 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYKRUPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2008 15:15:08 -0500
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>

Miller, Mike (OS Dev) wrote:
> 
>> -----Original Message-----
>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>> Sent: Thursday, September 25, 2008 3:40 PM
>> To: scsi
>> Cc: Jens Axboe; Miller, Mike (OS Dev); James Bottomley; lkml; akpm
>> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>>
>> On Thu, 25 Sep 2008 13:33:07 -0700 Randy Dunlap wrote:
>>
>>> Jens Axboe wrote:
>>>> On Thu, Sep 04 2008, Miller, Mike (OS Dev) wrote:
>>>>>>>>> 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
>>>>>>>>> 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
>>>>>>>>> 0x3bba <do_cciss_intr+1657>:    je     0x3f0e
>> <do_cciss_intr+2509>
>>>>>>>>>
>>>>>>>>> $ addr2line -e cciss.o -f  do_cciss_intr+0x627 SA5_fifo_full
>>>>>>>>>
>> /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:2
>>>>>> 06
>>>>>>>> OK ...that's confusing.  It seems to be saying that
>> ctrlr_info_t
>>>>>>>> * was NULL.  However, I can't see a way of getting into the
>>>>>> fifo_full
>>>>>>>> callback from do_cciss_intr ..
>>>>>>>> especially not with an NULL host.
>>>>>>>>
>>>>>>>> James
>>>>>>> That is weird. Even if we could get there fifo_full doesn't
>>>>>> do anything but wait for a bit.
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> This just happened again.  This time it's on 2.6.27-rc5-git3.
>>>>>>
>>>>>> ~Randy
>>>>> Thanks Randy. I think. :)
>>>>>
>>>>> I'll try to recreate in my lab.
>>>> This looks somewhat strange, mostly like 'c' is NULL and it's
>>>> oopsing in in removeQ (I don't think Randy's analysis is
>> correct in
>>>> assuming it's 'h' and it's in fifo_full). Given that 'c'
>> cannot be
>>>> NULL, it's c->prev or c->next that are NULL.

This BUG: has happened (now) 5 times today.  Higher frequency than usual for
some reason.

I enabled CCISS_DEBUG and added one printk in removeQ().  On the first call
to removeQ(), both c->next and c->prev are NULL.

Here's the kernel log output from cciss:

cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ 54
command = 147
irq = 36
board_id = 3211103c
cciss 0000:42:08.0: irq 87 for MSI/MSI-X
address 0 = fdf80000
cfg base address = 10
cfg base address index = 0
cfg offset = 400
Controller Configuration information
------------------------------------
   Signature = CISS
   Spec Number = 1
   Transport methods supported = 0x6
   Transport methods active = 0x3
   Requested transport Method = 0x0
   Coalesce Interrupt Delay = 0x0
   Coalesce Interrupt Count = 0x1
   Max outstanding commands = 0x256
   Bus Types = 0x200000
   Server Name =
   Heartbeat Counter = 0xffc


Trying to put board into Simple mode
I counter got to 1 0
Controller Configuration information
------------------------------------
   Signature = CISS
   Spec Number = 1
   Transport methods supported = 0x6
   Transport methods active = 0x3
   Requested transport Method = 0x0
   Coalesce Interrupt Delay = 0x0
   Coalesce Interrupt Count = 0x1
   Max outstanding commands = 0x256
   Bus Types = 0x200000
   Server Name =
   Heartbeat Counter = 0xffc

cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 87 using DAC
cciss: intr_pending 8
cciss: removeQ: Qptr=ffff88027e7500b8, c=ffff88007f83e000, next=ffff88007f83e000, prev=ffff88007f83e000
Sending 7f83e000 - down to controller
cciss: intr_pending 8
cciss:  Read 4 back from board
cciss: removeQ: Qptr=ffff88027e7500c0, c=ffff88007f840000, next=0000000000000000, prev=0000000000000000
BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
IP: [<ffffffffa002502b>] do_cciss_intr+0x6c8/0xb10 [cciss]
PGD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/block/ram15/dev
CPU 2
Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Not tainted 2.6.28-rc5 #1
RIP: 0010:[<ffffffffa002502b>]  [<ffffffffa002502b>] do_cciss_intr+0x6c8/0xb10 [cciss]
RSP: 0018:ffff88017fa9fee8  EFLAGS: 00010087
RAX: 0000000000000000 RBX: ffff88007f840000 RCX: 000000000000a3d9
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff8080e634
RBP: ffff88017fa9ff18 R08: 0000000000000000 R09: ffff88017e918800
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88027e740000
R13: 0000000000000000 R14: 0000000000000057 R15: 0000000000000086
FS:  00000000008558f0(0000) GS:ffff88017fc01c80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000248 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88027f660000, task ffff88027f635400)
Stack:
 0000000000000030 ffff88017ea73640 0000000000000000 0000000000000000
 0000000000000057 0000000000000000 ffff88017fa9ff48 ffffffff8026a8b9
 ffffffff8074ab00 0000000000000057 ffff88017ea73640 ffffffff8074ab58
Call Trace:
 <IRQ> <0> [<ffffffff8026a8b9>] handle_IRQ_event+0x27/0x57
 [<ffffffff8026c424>] handle_edge_irq+0xde/0x11f
 [<ffffffff8020e29b>] do_IRQ+0xfc/0x175
 [<ffffffff8020c3e6>] ret_from_intr+0x0/0xa
 <EOI> <0> [<ffffffff8023c7d2>] ? ksoftirqd+0x0/0xa6
 [<ffffffff80212575>] ? default_idle+0x2b/0x40
 [<ffffffff80212799>] ? c1e_idle+0xe5/0xec
 [<ffffffff8056a7f6>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020acd1>] ? cpu_idle+0x40/0x5e
 [<ffffffff8056284e>] ? start_secondary+0x174/0x179
Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00 01 00 75 08 49 89 84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b 93 48 02 00 00 <48> 89 90 48 02 00 00 48 8b 93 48 02 00 00 48 89 82 40 02 00 00
RIP  [<ffffffffa002502b>] do_cciss_intr+0x6c8/0xb10 [cciss]
 RSP <ffff88017fa9fee8>
CR2: 0000000000000248
Kernel panic - not syncing: Fatal exception in interrupt


Any ideas/suggestions?

Thanks,
~Randy
