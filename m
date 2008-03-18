From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 20:23:43 +0200
Message-ID: <47E008AF.7010100@panasas.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com> <47DFF834.8010307@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8491 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632AbYCSTxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:53:44 -0400
In-Reply-To: <47DFF834.8010307@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 18 2008 at 19:13 +0200, Michael Reed <mdr@sgi.com> wrote:
> 
> Boaz Harrosh wrote:
>> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>>> Michael Reed wrote:
>>>> Boaz Harrosh wrote:
>>>> <snip>
>>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>>> untested.
>>>>>> I can try this out and see what happens.
>>>>>>
>>>>>>
>>>>> Will not compile here is a cleaner one
>>>> Still in my queue.  Hopefully I'll get to poke at this today.
>>> Patch compiles cleanly and appears to have no effect on the misc.
>>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>>
>>> Mike
>>>
>>>> Mike
>>>>
>> <patch sniped>
>>
>> If you remove the original fix to sg.c
>> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
>>
>> and apply this patch, does it solve your original infinite loop?
> 
> By removing a fix in scsi_req_map_sg and forcing sg_start_req() to always
> call sg_build_indirect() (and not applying my fix to sg.c) I'm able to
> reproduce the problem without crashing the system.
> 
> With your patch applied to 2.6.25-rc4-git3 I get this....  (The mptscsih_qcmd
> output is evidence that the condition was generated which would have caused
> the infinite loop.)
> 
> 
> mptscsih_qcmd: cmd e0000070845e0f00 / 18, dd 2, sg_count 1, sglist e00000709a785600, bufflen 255, bi_size 512
> mptscsih_qcmd: cmd e0000070845e1500 / 18, dd 2, sg_count 1, sglist e00000709a785500, bufflen 255, bi_size 512
> Pid: 0, CPU 10, comm:              swapper
> psr : 0000101008026038 ifs : 800000000000058f ip  : [<a000000100554a00>]    Not tainted (2.6.25-rc4-git3)
> ip is at scsi_io_completion+0x2e0/0x900
> unat: 0000000000000000 pfs : 000000000000058f rsc : 0000000000000003
> rnat: 0bad0bad0baea565 bsps: a000000100094fe0 pr  : 0bad0bad0bae9965
> ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
> csd : 0000000000000000 ssd : 0000000000000000
> b0  : a000000100554a00 b6  : a000000100090aa0 b7  : a0000001000a2640
> f6  : 1003e000000000000b080 f7  : 1003e0000000000000000
> f8  : 1003e00000000a066a81a f9  : 1003e000000080dc98009
> f10 : 1003e0bd8b82c4612e8ea f11 : 1003e0000000000000005
> r1  : a000000100eee010 r2  : ffffffffffff9400 r3  : a000000100c89348
> r8  : 000000000000002e r9  : a000000100c89348 r10 : a000000100d58f30
> r11 : e000007082368d54 r12 : e00000708236fb90 r13 : e000007082368000
> r14 : 0000000000004000 r15 : a000000100c89348 r16 : a000000100c89330
> r17 : e0000170bd607e18 r18 : 0000000000004000 r19 : 0000000000000000
> r20 : 0000000000004000 r21 : e000007082368d50 r22 : 0000000000000000
> r23 : 0000000000000001 r24 : 0000000000000000 r25 : 0000000000000000
> r26 : 0000000000000002 r27 : 0000000000000000 r28 : 000000000000000a
> r29 : e000007082368d54 r30 : a000000100ce4ef8 r31 : a000000100ce4e98
> 
> Call Trace:
>  [<a0000001000128a0>] show_stack+0x40/0xa0
>                                 sp=e00000708236f760 bsp=e000007082369178
>  [<a0000001000131b0>] show_regs+0x850/0x8a0
>                                 sp=e00000708236f930 bsp=e000007082369120
>  [<a000000100033d10>] die+0x1b0/0x2e0
>                                 sp=e00000708236f930 bsp=e0000070823690d8
>  [<a000000100033e90>] die_if_kernel+0x50/0x80
>                                 sp=e00000708236f930 bsp=e0000070823690a8
>  [<a0000001000355f0>] ia64_bad_break+0x230/0x520
>                                 sp=e00000708236f930 bsp=e000007082369080
>  [<a00000010000a260>] ia64_leave_kernel+0x0/0x270
>                                 sp=e00000708236f9c0 bsp=e000007082369080
>  [<a000000100554a00>] scsi_io_completion+0x2e0/0x900
>                                 sp=e00000708236fb90 bsp=e000007082369008
>  [<a000000100546570>] scsi_finish_command+0x1d0/0x200
>                                 sp=e00000708236fba0 bsp=e000007082368fd0
> 
> Entering kdb (current=0xe000007082368000, pid 0) on processor 10 Oops: <NULL>
> due to oops @ 0xa000000100554a00
>  psr: 0x0000101008026038   ifs: 0x800000000000058f    ip: 0xa000000100554a00
> unat: 0x0000000000000000   pfs: 0x000000000000058f   rsc: 0x0000000000000003
> rnat: 0x0bad0bad0baea565  bsps: 0xa000000100094fe0    pr: 0x0bad0bad0bae9965
> ldrs: 0x0000000000000000   ccv: 0x0000000000000000  fpsr: 0x0009804c0270033f
>   b0: 0xa000000100554a00    b6: 0xa000000100090aa0    b7: 0xa0000001000a2640
>   r1: 0xa000000100eee010    r2: 0xffffffffffff9400    r3: 0xa000000100c89348
>   r8: 0x000000000000002e    r9: 0xa000000100c89348   r10: 0xa000000100d58f30
>  r11: 0xe000007082368d54   r12: 0xe00000708236fb90   r13: 0xe000007082368000
>  r14: 0x0000000000004000   r15: 0xa000000100c89348   r16: 0xa000000100c89330
>  r17: 0xe0000170bd607e18   r18: 0x0000000000004000   r19: 0x0000000000000000
>  r20: 0x0000000000004000   r21: 0xe000007082368d50   r22: 0x0000000000000000
>  r23: 0x0000000000000001   r24: 0x0000000000000000   r25: 0x0000000000000000
>  r26: 0x0000000000000002   r27: 0x0000000000000000   r28: 0x000000000000000a
>  r29: 0xe000007082368d54   r30: 0xa000000100ce4ef8   r31: 0xa000000100ce4e98
> &regs = e00000708236f9d0
> 
> [10]kdb> bt
> Stack traceback for pid 0
> 0xe000007082368000        0        1  1   10   R  0xe0000070823683b0 *swapper
> 0xa000000100554a00 scsi_io_completion+0x2e0
>         args (0xe0000070845e0600, 0xff, 0x0, 0xe0000070845ddf38, 0x0, 0x0, 0xe000027085dfd368, 0xff, 0xa000000100546570)
> 0xa000000100546570 scsi_finish_command+0x1d0
>         args (0xe0000070845e0600, 0xe000027085de5140, 0xe000027085de7800, 0xa0000001005556b0, 0x30a, 0xa000000100eee010)
> 0xa0000001005556b0 scsi_softirq_done+0x270
>         args (0xe0000070845e0600, 0x2002, 0x0, 0xa0000001003aba60, 0x184, 0xe0000070845e0718)
> 0xa0000001003aba60 blk_done_softirq+0x140
>         args (0xa0000001000b60b0, 0x790, 0xa000000100eee010)
> 0xa0000001000b60b0 __do_softirq+0xf0
>         args (0xe0000270822784d0, 0xe000027082278480, 0xffffffff, 0xe000027085e0d880, 0xa00000010010af80, 0x40b, 0xa000000100eee010, 0xa00000010010aba0, 0x1)
> 0xa0000001000b6270 do_softirq+0x70
>         args (0xa000000100bb8708, 0x0, 0xa00000010000ff70, 0x30a, 0xa000000100eee010, 0x218, 0xa000000100d0aac8, 0xa00000010010b040, 0x1008022038)
> 0xa0000001000b6560 irq_exit+0x80
>         args (0xa00000010000fff0, 0x30a, 0x0)
> 0xa00000010000fff0 ia64_handle_irq+0x2f0
>         args (0xf, 0x0, 0x0, 0xa00000010000a260, 0x2, 0xa000000100eee010)
> 0xa00000010000a260 ia64_leave_kernel
>         args (0xf, 0x0)
> 0xa000000100013550 default_idle+0x110
>         args (0xe00000708236fdc0, 0xa0000001000125e0, 0x40c, 0x10)
> 0xa0000001000125e0 cpu_idle+0x1e0
>         args (0xa000000100940330, 0xa000000100d0aa48, 0xa, 0xa000000100dc69e8, 0xa0000001009a3b50, 0x40b, 0xa000000100eee010, 0xbad0bad0badaa65)
> 0xa0000001009a3b50 start_secondary+0x4d0
>         args (0x20000500, 0x6e65470020000504, 0x400, 0xffffffff00, 0x3ff, 0xa000000100769fa0, 0x0, 0x3)
> 0xa000000100769fa0 __kprobes_text_end+0x340
> 
> Mike
> 

I don't understand is that a NULL dereference do to my patch? did you manage to find
what is the line of code that dereferences the NULL pointer.

Thanks
Boaz
