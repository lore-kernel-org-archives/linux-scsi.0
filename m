From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 14:51:51 -0500
Message-ID: <47E01D57.2000201@sgi.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com> <47DFF834.8010307@sgi.com> <47E008AF.7010100@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42968 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754536AbYCSTgB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:36:01 -0400
In-Reply-To: <47E008AF.7010100@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Boaz Harrosh wrote:
> On Tue, Mar 18 2008 at 19:13 +0200, Michael Reed <mdr@sgi.com> wrote:
>> Boaz Harrosh wrote:
>>> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>>>> Michael Reed wrote:
>>>>> Boaz Harrosh wrote:
>>>>> <snip>
>>>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>>>> untested.
>>>>>>> I can try this out and see what happens.
>>>>>>>
>>>>>>>
>>>>>> Will not compile here is a cleaner one
>>>>> Still in my queue.  Hopefully I'll get to poke at this today.
>>>> Patch compiles cleanly and appears to have no effect on the misc.
>>>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>>>
>>>> Mike
>>>>
>>>>> Mike
>>>>>
>>> <patch snipped>
>>>
>>> If you remove the original fix to sg.c
>>> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
>>>
>>> and apply this patch, does it solve your original infinite loop?
>> By removing a fix in scsi_req_map_sg and forcing sg_start_req() to always
>> call sg_build_indirect() (and not applying my fix to sg.c) I'm able to
>> reproduce the problem without crashing the system.
>>
>> With your patch applied to 2.6.25-rc4-git3 I get this....  (The mptscsih_qcmd
>> output is evidence that the condition was generated which would have caused
>> the infinite loop.)
>>
>>

< snip backtrace >

>>
>> Mike
>>
> 
> I don't understand is that a NULL dereference due to my patch? did you manage to find
> what is the line of code that dereferences the NULL pointer.

I'm going to say "yes", it's due to your patch.  It's happened twice in
a row.

Disabling inline functions gets me a better backtrace.  And dumping
the dmesg buffer I see the BUG in scsi_end_blk_request().

        BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));

I guess this is what I would expect to happen.

	blk_end_bidi_request ->
	  blk_end_io ->
	    __end_that_request_first
	
__end_that_request_first returns "1" indicating that the
request wasn't completely finished.

I guess it could be argued that this really is a bug and that the
buffer length and bi_size should always be the same.  Would
the same thing happen if a command returned a residual or
an i/o error?



<4>mptscsih_qcmd: cmd e00000708c2f6700 / 18, dd 2, sg_count 1, sglist e000007000080d00, bufflen 255, bi_size 512
<4>kernel BUG at drivers/scsi/scsi_lib.c:809!          (I have other changes in this file.)
<4>swapper[0]: bugcheck! 0 [1]
<4>Modules linked in: ipv6 mptfc mptspi sg mptsas mptscsih mptbase qla1280
<4>
<4>Pid: 0, CPU 10, comm:              swapper
<4>psr : 0000101008026038 ifs : 8000000000000208 ip  : [<a00000010057aaf0>]    Not tainted (2.6.25-rc4-git3)
<4>ip is at scsi_end_blk_request+0x150/0x1e0
<4>unat: 0000000000000000 pfs : 0000000000000208 rsc : 0000000000000003
<4>rnat: 0bad0bad0bae2965 bsps: a0000001000956c0 pr  : 0bad0bad0bae9965
<4>ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
<4>csd : 0000000000000000 ssd : 0000000000000000
<4>b0  : a00000010057aaf0 b6  : a00000010009d740 b7  : a00000010009daa0
<4>f6  : 1003e000000000000b080 f7  : 1003e0a7c5ac471b47843
<4>f8  : 1003e00000000a066a81a f9  : 1003e00000007fbf88741
<4>f10 : 1003e00aef7b933e6649a f11 : 1003e0000000000000005
<4>r1  : a000000100f4e010 r2  : ffffffffffff9400 r3  : a000000100ce9348
<4>r8  : 000000000000002e r9  : a000000100ce9348 r10 : a000000100db9030
<4>r11 : e000027082200d54 r12 : e000027082207b90 r13 : e000027082200000
<4>r14 : 0000000000004000 r15 : a000000100ce9348 r16 : a000000100ce9330
<4>r17 : e0000270a8437e18 r18 : 0000000000000000 r19 : 0000000000000000
<4>r20 : 0000000000000000 r21 : e000027082200d50 r22 : 0000000000000000
<4>r23 : 0000000000000001 r24 : 0000000000000000 r25 : 0000000000000000
<4>r26 : 0000000000000002 r27 : 0000000000004000 r28 : 0000000000004000
<4>r29 : e000027082200d54 r30 : a000000100d44ef8 r31 : a000000100d44e98
<4>
<4>Call Trace:
<4> [<a000000100012e60>] show_stack+0x40/0xa0
<4>                                sp=e000027082207760 bsp=e000027082201170
<4> [<a000000100013710>] show_regs+0x850/0x8a0
<4>                                sp=e000027082207930 bsp=e000027082201118
<4> [<a0000001000351d0>] die+0x1b0/0x2e0
<4>                                sp=e000027082207930 bsp=e0000270822010d0
<4> [<a000000100035350>] die_if_kernel+0x50/0x80
<4>                                sp=e000027082207930 bsp=e0000270822010a0
<4> [<a000000100036350>] ia64_bad_break+0x230/0x520
<4>                                sp=e000027082207930 bsp=e000027082201078
<4> [<a00000010000a320>] ia64_leave_kernel+0x0/0x270
<4>                                sp=e0000270822079c0 bsp=e000027082201078
<4> [<a00000010057aaf0>] scsi_end_blk_request+0x150/0x1e0
<4>                                sp=e000027082207b90 bsp=e000027082201038
<4> [<a00000010057af60>] scsi_io_completion+0x1c0/0x780
<4>                                sp=e000027082207b90 bsp=e000027082200fd8
<4> [<a00000010056ba90>] scsi_finish_command+0x1d0/0x200
<4>                                sp=e000027082207ba0 bsp=e000027082200fa8
<4> [<a00000010057b8f0>] scsi_softirq_done+0x270/0x2a0
<4>                                sp=e000027082207ba0 bsp=e000027082200f78
<4> [<a0000001003c6480>] blk_done_softirq+0x140/0x1a0
<4>                                sp=e000027082207bb0 bsp=e000027082200f60
<4> [<a0000001000be170>] __do_softirq+0xf0/0x240
<4>                                sp=e000027082207bc0 bsp=e000027082200ee8
<4> [<a0000001000be330>] do_softirq+0x70/0xc0
<4>                                sp=e000027082207bc0 bsp=e000027082200e88
<4> [<a0000001000be620>] irq_exit+0x80/0xa0
<4>                                sp=e000027082207bc0 bsp=e000027082200e70
<4> [<a00000010000f530>] ia64_handle_irq+0x2f0/0x320
<4>                                sp=e000027082207bc0 bsp=e000027082200e40
<4> [<a00000010000a320>] ia64_leave_kernel+0x0/0x270
<4>                                sp=e000027082207bc0 bsp=e000027082200e40
<4> [<a000000100012cd0>] default_idle+0x110/0x180
<4>                                sp=e000027082207d90 bsp=e000027082200e00
<4> [<a0000001000127e0>] cpu_idle+0x1e0/0x300
<4>                                sp=e000027082207e30 bsp=e000027082200db8
<4> [<a0000001009fc4a0>] start_secondary+0x80/0xa0
<4>                                sp=e000027082207e30 bsp=e000027082200da0
<4> [<a00000010079d060>] __kprobes_text_end+0x340/0x370
<4>                                sp=e000027082207e30 bsp=e000027082200da0


Mike



> 
> Thanks
> Boaz
