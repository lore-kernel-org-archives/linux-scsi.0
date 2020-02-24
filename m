Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376CDC3567B
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 08:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0522320714
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 08:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBXIUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 03:20:22 -0500
Received: from hosting.gsystem.sk ([212.5.213.30]:60650 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXIUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 03:20:22 -0500
Received: from [192.168.1.3] (ns.gsystem.sk [62.176.172.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 6026A7A00BF;
        Mon, 24 Feb 2020 09:20:20 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     Bart Van Assche <bvanassche@acm.org>
Subject: Re: NULL pointer dereference in qla24xx_abort_command, kernel 4.19.98 (Debian)
Date:   Mon, 24 Feb 2020 09:20:17 +0100
User-Agent: KMail/1.9.10
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202002231929.01662.linux@zary.sk> <202002232057.16101.linux@zary.sk> <336cb7b1-5e40-5830-3c1c-4389257081ea@acm.org>
In-Reply-To: <336cb7b1-5e40-5830-3c1c-4389257081ea@acm.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202002240920.17691.linux@zary.sk>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Monday 24 February 2020, Bart Van Assche wrote:
> On 2020-02-23 11:57, Ondrej Zary wrote:
> > On Sunday 23 February 2020 20:26:39 Bart Van Assche wrote:
> >> On 2020-02-23 10:29, Ondrej Zary wrote:
> >>> a couple of days after upgrading a server from Debian 9 (kernel
> >>> 4.9.210-1) to 10 (kernel 4.19.98), qla2xxx crashed, along with mysql.
> >>>
> >>> There is an EMC CX3 array connected through the fibre-channel adapter.
> >>> No errors are present in EMC event log.
> >>>
> >>> This server was running without any problems since Debian 4.
> >>> Is this a known bug?
> >>
> >> Please report issues encountered with Debian kernels in the Debian bug
> >> tracker. If you want the upstream community to assist please retest with
> >> an upstream kernel.
> >
> > Debian kernel does not have any patches related to qla2xxx driver:
> > https://salsa.debian.org/kernel-team/linux/raw/debian/4.19.98-1/debian/pa
> >tches/series
> >
> > It crashed after running for 11 days. Not a quick&easy test.
>
> It would help a lot if the crash address would be translated into a
> source code line number. Something like the following commands should do
> the trick:
> $ gdb drivers/scsi/qla2xxx/qla2xxx.ko
> (gdb) list *(qla24xx_async_abort_cmd+0x1b)

Looks like it's in some inlined function.

/usr/src/linux-source-4.19# gdb /lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
GNU gdb (Debian 8.2.1-2+b3) 8.2.1
...
Reading symbols from /lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko...Reading symbols 
from /usr/lib/debug//lib/modules/4.19.0-8-amd64/kernel/drivers/scsi/qla2xxx/qla2xxx.ko...done.
done.

(gdb) list *(qla24xx_async_abort_cmd+0x1b)
0xf88b is in qla24xx_async_abort_cmd (./arch/x86/include/asm/atomic.h:97).
92       *
93       * Atomically increments @v by 1.
94       */
95      static __always_inline void arch_atomic_inc(atomic_t *v)
96      {
97              asm volatile(LOCK_PREFIX "incl %0"
98                           : "+m" (v->counter) :: "memory");
99      }
100     #define arch_atomic_inc arch_atomic_inc
101

(gdb) list *(qla24xx_abort_command+0x218)
0x22238 is in qla24xx_abort_command (./drivers/scsi/qla2xxx/qla_mbx.c:3084).
3079
3080            if (vha->flags.qpairs_available && sp->qpair)
3081                    req = sp->qpair->req;
3082
3083            if (ql2xasynctmfenable)
3084                    return qla24xx_async_abort_command(sp);
3085
3086            spin_lock_irqsave(&ha->hardware_lock, flags);
3087            for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
3088                    if (req->outstanding_cmds[handle] == sp)

(gdb) list *(qla2xxx_eh_abort+0x117)
0x15e7 is in qla2xxx_eh_abort (./drivers/scsi/qla2xxx/qla_os.c:1314).
1309            /* Get a reference to the sp and drop the lock.*/
1310            sp_get(sp);
1311
1312            spin_unlock_irqrestore(&ha->hardware_lock, flags);
1313            rval = ha->isp_ops->abort_command(sp);
1314            if (rval) {
1315                    if (rval == QLA_FUNCTION_PARAMETER_ERROR)
1316                            ret = SUCCESS;
1317                    else
1318                            ret = FAILED;

(gdb) disassemble qla24xx_async_abort_cmd
Dump of assembler code for function qla24xx_async_abort_cmd:
   0x000000000000f870 <+0>:     callq  0xf875 <qla24xx_async_abort_cmd+5>
   0x000000000000f875 <+5>:     push   %r15
   0x000000000000f877 <+7>:     push   %r14
   0x000000000000f879 <+9>:     push   %r13
   0x000000000000f87b <+11>:    push   %r12
   0x000000000000f87d <+13>:    push   %rbp
   0x000000000000f87e <+14>:    push   %rbx
   0x000000000000f87f <+15>:    mov    0x28(%rdi),%r13
   0x000000000000f883 <+19>:    mov    0x20(%rdi),%r15
   0x000000000000f887 <+23>:    mov    0x48(%rdi),%r14
   0x000000000000f88b <+27>:    lock incl 0x4(%r14)
   0x000000000000f890 <+32>:    mfence
   0x000000000000f893 <+35>:    testb  $0x4,0x24(%r14)
   0x000000000000f898 <+40>:    je     0xf8b1 <qla24xx_async_abort_cmd+65>
   0x000000000000f89a <+42>:    lock decl 0x4(%r14)
   0x000000000000f89f <+47>:    mov    $0x102,%ebp
   0x000000000000f8a4 <+52>:    pop    %rbx
   0x000000000000f8a5 <+53>:    mov    %ebp,%eax
   0x000000000000f8a7 <+55>:    pop    %rbp
   0x000000000000f8a8 <+56>:    pop    %r12
   0x000000000000f8aa <+58>:    pop    %r13
   0x000000000000f8ac <+60>:    pop    %r14
   0x000000000000f8ae <+62>:    pop    %r15
   0x000000000000f8b0 <+64>:    retq
   0x000000000000f8b1 <+65>:    mov    %rdi,%rbp
   0x000000000000f8b4 <+68>:    mov    0x30(%r14),%rdi
   0x000000000000f8b8 <+72>:    mov    %esi,%r12d
   0x000000000000f8bb <+75>:    mov    $0x6000c0,%esi
   0x000000000000f8c0 <+80>:    callq  0xf8c5 <qla24xx_async_abort_cmd+85>
   0x000000000000f8c5 <+85>:    mov    %rax,%rbx
   0x000000000000f8c8 <+88>:    test   %rax,%rax
   0x000000000000f8cb <+91>:    je     0xf89a <qla24xx_async_abort_cmd+42>
   0x000000000000f8cd <+93>:    lea    0x8(%rax),%rdi
   0x000000000000f8d1 <+97>:    mov    %rax,%rcx
   0x000000000000f8d4 <+100>:   movq   $0x0,(%rax)
   0x000000000000f8db <+107>:   mov    $0xc,%edx
   0x000000000000f8e0 <+112>:   movq   $0x0,0x180(%rax)
   0x000000000000f8eb <+123>:   and    $0xfffffffffffffff8,%rdi
   0x000000000000f8ef <+127>:   xor    %eax,%eax
   0x000000000000f8f1 <+129>:   sub    %rdi,%rcx
   0x000000000000f8f4 <+132>:   add    $0x188,%ecx
   0x000000000000f8fa <+138>:   shr    $0x3,%ecx
   0x000000000000f8fd <+141>:   rep stos %rax,%es:(%rdi)
   0x000000000000f900 <+144>:   mov    %r15,0x20(%rbx)
   0x000000000000f904 <+148>:   movl   $0x1,0x40(%rbx)
   0x000000000000f90b <+155>:   mov    0x18(%r14),%rax
   0x000000000000f90f <+159>:   mov    %dx,0x36(%rbx)
   0x000000000000f913 <+163>:   movq   $0x0,0x38(%rbx)
   0x000000000000f91b <+171>:   mov    %rax,0x28(%rbx)
   0x000000000000f91f <+175>:   lea    0x50(%rbx),%rax
   0x000000000000f923 <+179>:   mov    %rax,0x50(%rbx)
   0x000000000000f927 <+183>:   mov    %rax,0x58(%rbx)
   0x000000000000f92b <+187>:   mov    0x48(%rbp),%rax
   0x000000000000f92f <+191>:   mov    %rax,0x48(%rbx)
   0x000000000000f933 <+195>:   test   %r12b,%r12b
   0x000000000000f936 <+198>:   je     0xf941 <qla24xx_async_abort_cmd+209>
   0x000000000000f938 <+200>:   mov    $0x40,%eax
   0x000000000000f93d <+205>:   mov    %ax,0x34(%rbx)
   0x000000000000f941 <+209>:   lea    0xa0(%rbx),%rdi
   0x000000000000f948 <+216>:   mov    $0x0,%rdx
   0x000000000000f94f <+223>:   mov    $0x0,%rsi
   0x000000000000f956 <+230>:   movq   $0x0,0x170(%rbx)
   0x000000000000f961 <+241>:   lea    0x148(%rbx),%r14
   0x000000000000f968 <+248>:   movl   $0x0,0x98(%rbx)
   0x000000000000f972 <+258>:   callq  0xf977 <qla24xx_async_abort_cmd+263>
   0x000000000000f977 <+263>:   xor    %r8d,%r8d
   0x000000000000f97a <+266>:   xor    %ecx,%ecx
   0x000000000000f97c <+268>:   xor    %edx,%edx
   0x000000000000f97e <+270>:   mov    $0x0,%rsi
   0x000000000000f985 <+277>:   mov    %r14,%rdi
   0x000000000000f988 <+280>:   callq  0xf98d <qla24xx_async_abort_cmd+285>
   0x000000000000f98d <+285>:   mov    0x0(%rip),%rax        # 0xf994 <qla24xx_async_abort_cmd+292>
   0x000000000000f994 <+292>:   lea    0x78(%rbx),%rdi
   0x000000000000f998 <+296>:   mov    $0x0,%rdx
   0x000000000000f99f <+303>:   mov    $0x0,%rsi
   0x000000000000f9a6 <+310>:   movl   $0x0,0x70(%rbx)
   0x000000000000f9ad <+317>:   add    $0x2904,%rax
   0x000000000000f9b3 <+323>:   movq   $0x0,0x180(%rbx)
   0x000000000000f9be <+334>:   mov    %rax,0x158(%rbx)
   0x000000000000f9c5 <+341>:   callq  0xf9ca <qla24xx_async_abort_cmd+346>
   0x000000000000f9ca <+346>:   mov    0x28(%rbx),%rax
   0x000000000000f9ce <+350>:   mov    0x448(%rax),%rax
   0x000000000000f9d5 <+357>:   testb  $0x2,0x15a(%rax)
   0x000000000000f9dc <+364>:   jne    0xfa80 <qla24xx_async_abort_cmd+528>
   0x000000000000f9e2 <+370>:   mov    %r14,%rdi
   0x000000000000f9e5 <+373>:   callq  0xf9ea <qla24xx_async_abort_cmd+378>
   0x000000000000f9ea <+378>:   mov    0x30(%rbp),%r8d
   0x000000000000f9ee <+382>:   mov    0x48(%rbp),%rax
   0x000000000000f9f2 <+386>:   mov    %r13,%rsi
   0x000000000000f9f5 <+389>:   movzwl 0x36(%rbp),%r9d
   0x000000000000f9fa <+394>:   mov    $0x507c,%edx
   0x000000000000f9ff <+399>:   mov    $0x2000000,%edi
   0x000000000000fa04 <+404>:   mov    $0x0,%rcx
   0x000000000000fa0b <+411>:   mov    %r8d,0x90(%rbx)
   0x000000000000fa12 <+418>:   mov    0x48(%rax),%rax
   0x000000000000fa16 <+422>:   movzwl 0x40(%rax),%eax
   0x000000000000fa1a <+426>:   movq   $0x0,0x178(%rbx)
   0x000000000000fa25 <+437>:   mov    %ax,0x96(%rbx)
   0x000000000000fa2c <+444>:   callq  0xfa31 <qla24xx_async_abort_cmd+449>
   0x000000000000fa31 <+449>:   mov    %rbx,%rdi
   0x000000000000fa34 <+452>:   callq  0xfa39 <qla24xx_async_abort_cmd+457>
   0x000000000000fa39 <+457>:   mov    %eax,%ebp
   0x000000000000fa3b <+459>:   test   %eax,%eax
   0x000000000000fa3d <+461>:   jne    0xfa64 <qla24xx_async_abort_cmd+500>
   0x000000000000fa3f <+463>:   test   %r12b,%r12b
   0x000000000000fa42 <+466>:   je     0xf8a4 <qla24xx_async_abort_cmd+52>
   0x000000000000fa48 <+472>:   lea    0x98(%rbx),%rdi
   0x000000000000fa4f <+479>:   callq  0xfa54 <qla24xx_async_abort_cmd+484>
   0x000000000000fa54 <+484>:   cmpw   $0x0,0x94(%rbx)
   0x000000000000fa5c <+492>:   mov    $0x102,%eax
   0x000000000000fa61 <+497>:   cmovne %eax,%ebp
   0x000000000000fa64 <+500>:   mov    0x180(%rbx),%rax
   0x000000000000fa6b <+507>:   mov    %rbx,%rdi
   0x000000000000fa6e <+510>:   callq  0xfa73 <qla24xx_async_abort_cmd+515>
   0x000000000000fa73 <+515>:   mov    %ebp,%eax
   0x000000000000fa75 <+517>:   pop    %rbx
   0x000000000000fa76 <+518>:   pop    %rbp
   0x000000000000fa77 <+519>:   pop    %r12
   0x000000000000fa79 <+521>:   pop    %r13
   0x000000000000fa7b <+523>:   pop    %r14
   0x000000000000fa7d <+525>:   pop    %r15
   0x000000000000fa7f <+527>:   retq
   0x000000000000fa80 <+528>:   cmpw   $0xa,0x36(%rbx)
   0x000000000000fa85 <+533>:   jne    0xf9e2 <qla24xx_async_abort_cmd+370>
   0x000000000000fa8b <+539>:   lea    0xe8(%rbx),%rdi
   0x000000000000fa92 <+546>:   mov    $0x0,%rdx
   0x000000000000fa99 <+553>:   mov    $0x0,%rsi
   0x000000000000faa0 <+560>:   movl   $0x0,0xe0(%rbx)
   0x000000000000faaa <+570>:   callq  0xfaaf <qla24xx_async_abort_cmd+575>
   0x000000000000faaf <+575>:   jmpq   0xf9e2 <qla24xx_async_abort_cmd+370>
End of assembler dump.


-- 
Ondrej Zary
