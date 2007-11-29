From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-rc3-git2 softlockup detected
Date: Thu, 29 Nov 2007 14:43:44 +0530
Message-ID: <474E82C8.8090207@linux.vnet.ibm.com>
References: <474D0AAC.5010005@linux.vnet.ibm.com> <20071127225328.9e3f3827.akpm@linux-foundation.org> <474D15FF.5080508@linux.vnet.ibm.com> <20071127232552.ad16e95c.akpm@linux-foundation.org> <474E5CAC.9000108@linux.vnet.ibm.com> <20071129003533.54b4b20e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33792 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbXK2JOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2007 04:14:24 -0500
In-Reply-To: <20071129003533.54b4b20e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@debian.org>

Andrew Morton wrote:
> On Thu, 29 Nov 2007 12:01:08 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Wed, 28 Nov 2007 12:47:19 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>>
>>>> Andrew Morton wrote:
>>>>> On Wed, 28 Nov 2007 11:59:00 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>>>>
>>>>>> Hi,
>>>>> (cc linux-scsi, for sym53c8xx)
>>>>>
>>>>>> Soft lockup is detected while bootup with 2.6.24-rc3-git2 on powerbox
>>>>> I assume this is a post-2.6.23 regression?
>>>>>
>>>>>> BUG: soft lockup - CPU#1 stuck for 11s! [insmod:375]
>>>>>> NIP: c00000000002f02c LR: d0000000001414fc CTR: c00000000002f018
>>>>>> REGS: c00000077cbef0b0 TRAP: 0901   Not tainted  (2.6.24-rc3-git2-autotest)
>>>>>> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24022088  XER: 00000000
>>>>>> TASK = c00000077cbd8000[375] 'insmod' THREAD: c00000077cbec000 CPU: 1
>>>>>> GPR00: d0000000001414fc c00000077cbef330 c00000000052b930 d000080080002014 
>>>>>> GPR04: d00008008000202c 0000000000000000 c00000077ca1cb00 d00000000014ce54 
>>>>>> GPR08: c00000077ca1c63c 0000000000000000 000000000000002a c00000000002f018 
>>>>>> GPR12: d000000000143610 c000000000473d00 
>>>>>> NIP [c00000000002f02c] .ioread8+0x14/0x60
>>>>>> LR [d0000000001414fc] .sym_hcb_attach+0x1188/0x1378 [sym53c8xx]
>>>>>> Call Trace:
>>>>>> [c00000077cbef330] [c00000077cbef3c0] 0xc00000077cbef3c0 (unreliable)
>>>>>> [c00000077cbef3a0] [d0000000001414fc] .sym_hcb_attach+0x1188/0x1378 [sym53c8xx]
>>>>>> [c00000077cbef470] [d0000000001395f8] .sym2_probe+0x700/0x99c [sym53c8xx]
>>>>>> [c00000077cbef710] [c0000000001bc118] .pci_device_probe+0x124/0x1b0
>>>>>> [c00000077cbef7b0] [c000000000221138] .driver_probe_device+0x144/0x20c
>>>>>> [c00000077cbef850] [c000000000221450] .__driver_attach+0xcc/0x154
>>>>>> [c00000077cbef8e0] [c00000000021ff94] .bus_for_each_dev+0x7c/0xd4
>>>>>> [c00000077cbef9a0] [c000000000220e9c] .driver_attach+0x28/0x40
>>>>>> [c00000077cbefa20] [c0000000002204d8] .bus_add_driver+0x90/0x228
>>>>>> [c00000077cbefac0] [c000000000221858] .driver_register+0x94/0xb0
>>>>>> [c00000077cbefb40] [c0000000001bc430] .__pci_register_driver+0x6c/0xcc
>>>>>> [c00000077cbefbe0] [d000000000143428] .sym2_init+0x108/0x15b0 [sym53c8xx]
>>>>>> [c00000077cbefc80] [c00000000008ce80] .sys_init_module+0x17c4/0x1958
>>>>>> [c00000077cbefe30] [c00000000000872c] syscall_exit+0x0/0x40
>>>>>> Instruction dump:
>>>>>> 60000000 786b0420 38210070 7d635b78 e8010010 7c0803a6 4e800020 7c0802a6 
>>>>>> f8010010 f821ff91 7c0004ac 89230000 <0c090000> 4c00012c 79290620 2f8900ff 
>>>>> I see no obvious lockup sites near the end of sym_hcb_attach().  Maybe it's
>>>>> being called lots of times from a higher level..  Do the traces all look
>>>>> the same?
>>>> Hi Andrew,
>>>>
>>>> I see this call trace twice and both looks similar and on another reboot
>>>> the following trace is seen twice in different cpu
>>>>
>>>> BUG: soft lockup detected on CPU#3!
>>>> Call Trace:
>>>> [C00000003FEDEDA0] [C000000000010220] .show_stack+0x68/0x1b0 (unreliable)
>>>> [C00000003FEDEE40] [C0000000000A061C] .softlockup_tick+0xf0/0x13c
>>>> [C00000003FEDEEF0] [C000000000072E2C] .run_local_timers+0x1c/0x30
>>>> [C00000003FEDEF70] [C000000000022FA0] .timer_interrupt+0xa8/0x488
>>>> [C00000003FEDF050] [C0000000000034EC] decrementer_common+0xec/0x100
>>>> --- Exception: 901 at .ioread8+0x14/0x60
>>>>     LR = .sym_hcb_attach+0x1194/0x1384 [sym53c8xx]
>>>> [C00000003FEDF340] [D0000000002B3BC0] 0xd0000000002b3bc0 (unreliable)
>>>> [C00000003FEDF3B0] [D00000000029A3C0] .sym_hcb_attach+0x1194/0x1384 [sym53c8xx]
>>>> [C00000003FEDF480] [D000000000291D30] .sym2_probe+0x75c/0x9f8 [sym53c8xx]
>>>> [C00000003FEDF710] [C0000000001B65A4] .pci_device_probe+0x13c/0x1dc
>>>> [C00000003FEDF7D0] [C000000000219A0C] .driver_probe_device+0xa0/0x15c
>>>> [C00000003FEDF870] [C000000000219C64] .__driver_attach+0xb4/0x138
>>>> [C00000003FEDF900] [C00000000021913C] .bus_for_each_dev+0x7c/0xd4
>>>> [C00000003FEDF9C0] [C0000000002198B0] .driver_attach+0x28/0x40
>>>> [C00000003FEDFA40] [C000000000218BA4] .bus_add_driver+0x98/0x18c
>>>> [C00000003FEDFAE0] [C00000000021A064] .driver_register+0xa8/0xc4
>>>> [C00000003FEDFB60] [C0000000001B68AC] .__pci_register_driver+0x5c/0xa4
>>>> [C00000003FEDFBF0] [D00000000029C204] .sym2_init+0x104/0x1550 [sym53c8xx]
>>>> [C00000003FEDFC90] [C00000000008D1F4] .sys_init_module+0x1764/0x1998
>>>> [C00000003FEDFE30] [C00000000000869C] syscall_exit+0x0/0x40
>>>>
>>> hm, odd.
>>>
>>> Can you look up sym_hcb_attach+0x1194/0x1384 in gdb?  Something like
>>>
>> Hi Andrew,
>>
>> I tried with 2.6.24-rc3-git3 and got the following trace
>>
>> BUG: soft lockup - CPU#2 stuck for 11s! [insmod:375]
>> NIP: c00000000002f02c LR: d0000000001414fc CTR: c00000000002f018
>> REGS: c00000077ca3b0b0 TRAP: 0901   Not tainted  (2.6.24-rc3-git3-autokern1)
>> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24022088  XER: 00000000
>> TASK = c00000077cc58000[375] 'insmod' THREAD: c00000077ca38000 CPU: 2
>> GPR00: d0000000001414fc c00000077ca3b330 c00000000052b880 d000080080002014 
>> GPR04: d00008008000202c 0000000000000000 c00000077c82eb00 d00000000014ce54 
>> GPR08: c00000077c82e63c 0000000000000000 000000000000002a c00000000002f018 
>> GPR12: d000000000143610 c000000000473f80 
>> NIP [c00000000002f02c] .ioread8+0x14/0x60
>> LR [d0000000001414fc] .sym_hcb_attach+0x1188/0x1378 [sym53c8xx]
>>
>> Call Trace:
>> [c00000077ca3b330] [c00000077ca3b3c0] 0xc00000077ca3b3c0 (unreliable)
>> [c00000077ca3b3a0] [d0000000001414fc] .sym_hcb_attach+0x1188/0x1378 [sym53c8xx]
>> [c00000077ca3b470] [d0000000001395f8] .sym2_probe+0x700/0x99c [sym53c8xx]
>> [c00000077ca3b710] [c0000000001bc098] .pci_device_probe+0x124/0x1b0
>> [c00000077ca3b7b0] [c0000000002210c4] .driver_probe_device+0x144/0x20c
>> [c00000077ca3b850] [c0000000002213dc] .__driver_attach+0xcc/0x154
>> [c00000077ca3b8e0] [c00000000021ff20] .bus_for_each_dev+0x7c/0xd4
>> [c00000077ca3b9a0] [c000000000220e28] .driver_attach+0x28/0x40
>> [c00000077ca3ba20] [c000000000220464] .bus_add_driver+0x90/0x228
>> [c00000077ca3bac0] [c0000000002217e4] .driver_register+0x94/0xb0
>> [c00000077ca3bb40] [c0000000001bc3b0] .__pci_register_driver+0x6c/0xcc
>> [c00000077ca3bbe0] [d000000000143428] .sym2_init+0x108/0x15b0 [sym53c8xx]
>> [c00000077ca3bc80] [c00000000008ce80] .sys_init_module+0x17c4/0x1958
>> [c00000077ca3be30] [c00000000000872c] syscall_exit+0x0/0x40
>>
>> Instruction dump:
>> 60000000 786b0420 38210070 7d635b78 e8010010 7c0803a6 4e800020 7c0802a6
>> f8010010 f821ff91 7c0004ac 89230000 <0c090000> 4c00012c 79290620 2f8900ff
>>
>> The gdb list the following for the above trace
>>
>> 0xa4fc is in sym_hcb_attach (drivers/scsi/sym53c8xx_2/sym_hipd.c:1041).
>> 1036            OUTL_DSP(np, pc);
>> 1037            /*
>> 1038             *  Wait 'til done (with timeout)
>> 1039             */
>> 1040            for (i=0; i<SYM_SNOOP_TIMEOUT; i++)
>> 1041                    if (INB(np, nc_istat) & (INTF|SIP|DIP))
>> 1042                            break;
>> 1043            if (i>=SYM_SNOOP_TIMEOUT) {
>> 1044                    printf ("CACHE TEST FAILED: timeout.\n");
>> 1045                    return (0x20);
>>
> 
> doh, I missed that.
> 
> #define SYM_SNOOP_TIMEOUT (10000000)
> 
> ten million is close enough to infinity for me to assume that we broke the
> driver and that's never going to terminate.
> 
> otoh, if that's true you should have got the "CACHE TEST FAILED: timeout"
> message.  Did you?  And does the driver actually work OK after this?

Yes, i got that message

CACHE TEST FAILED: timeout.
sym1: CACHE INCORRECTLY CONFIGURED.
sym1: giving up ...

and the file system stress passes.
 
> If it is indeed expected that a ~10 second stall in there is correct
> behaviour then all we need to do is do make that loop a bit smarter (10,000
> msleep(1)'s, for example).
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
