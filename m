From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sun, 18 Jan 2004 23:55:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <028001c3de16$30c41730$060ba8c0@AldiP4>
References: <Pine.LNX.4.44.0401162013440.6170-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout03.sul.t-online.com ([194.25.134.81]:18115 "EHLO
	mailout03.sul.t-online.com") by vger.kernel.org with ESMTP
	id S264245AbUARWzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 17:55:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> Ok, as I suspected, resourse-conflict. You have PNP, but the AHA-card is
> not PNP. So, looks like the right thing to do would be just to make the
> error in case of busy io-region more explicite. But the proper fix should
> also, of course, replace check_region with request_region. Perhaps,
> something like what's attached below. Sould you, please, test? It
> compiles:-) It should just fail nicely if request_region() fails, and work
> otherwise. It is against 2.6.0.
>
[patch]

Hi,

I integrated the patch and changed drivers/pnp/isapnp/core.c to switch
'isapnp_reset' permanently to 0 (If I don't do this, I get "No such device"
on module-load). When I load the aha152x.ko I get a kernel-oops (I'm sorry,
but the first three lines and everything before that get lost)[1].
If I compile aha152x in, I guess, it is the same oops (but I didn't copy it
yet).
But the kernel also oopses, when I use the original aha152x.c.

HTH
Greetings
Kai

[1]
ksymoops 2.4.9 on i586 2.4.22-gentoo-r2.  Options used
     -v /usr/src/linux-2.6.0-gentoo/vmlinux (specified)
     -K (specified)
     -l /proc/modules (default)
     -o /lib/modules/2.6.0-gentoo/ (specified)
     -m /usr/src/linux-2.6.0-gentoo/System.map (specified)

No modules in ksyms, skipping objects
No ksyms, skipping lsmod
EIP: 0060:[<c880f022>] Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010086
eax: c797a800 ebx: c797da00 ecx: c797bce0 edx: 0000001b
esi: c797a800 edi: c7fc6000 ebp: 00000246 esp: c7fc7f2c
ds: 007b es: 007b ss: 0068
Stack: c797bce0 00000002 c797a800 00000008 00000001 00000000 c88113d3
c797a800
       fffbdd99 00000000 c8816720 00000000 c7ffdc20 c880ebb0 c797a800
00000000
       c0129db1 00000000 c7ffdc30 c7ffdc38 c7fc6000 c7fc6000 c7fc6000
c7fc6000
Call Trace:
 [<c88113d3>] is_complete+0x2d3/0x320 [aha152x]
 [<c880ebb0>] run+0x30/0x40 [aha152x]
 [<c0129db1>] worker_thread+0x1e1/0x2d0
 [<c880eb80>] run+0x0/0x40 [aha152x]
 [<c0117d30>] default_wake_function+0x0/0x20
 [<c010aa76>] ret_from_fork+0x6/0x20
 [<c0117d30>] default_wake_function+0x0/0x20
 [<c0129bd0>] worker_thread+0x0/0x2d0
 [<c0108be5>] kernel_thread_helper+0x5/0x10
Code: 89 02 8b 41 04 8b 53 04 8b 40 3c 89 42 3c 8b 41 04 8b 53 04


>>EIP; c880f022 <_end+84d5872/3fcc4850>   <=====

>>eax; c797a800 <_end+7641050/3fcc4850>
>>ebx; c797da00 <_end+7644250/3fcc4850>
>>ecx; c797bce0 <_end+7642530/3fcc4850>
>>esi; c797a800 <_end+7641050/3fcc4850>
>>edi; c7fc6000 <_end+7c8c850/3fcc4850>
>>esp; c7fc7f2c <_end+7c8e77c/3fcc4850>

Trace; c88113d3 <_end+84d7c23/3fcc4850>
Trace; c880ebb0 <_end+84d5400/3fcc4850>
Trace; c0129db1 <worker_thread+1e1/2d0>
Trace; c880eb80 <_end+84d53d0/3fcc4850>
Trace; c0117d30 <default_wake_function+0/20>
Trace; c010aa76 <ret_from_fork+6/20>
Trace; c0117d30 <default_wake_function+0/20>
Trace; c0129bd0 <worker_thread+0/2d0>
Trace; c0108be5 <kernel_thread_helper+5/10>

Code;  c880f022 <_end+84d5872/3fcc4850>
00000000 <_EIP>:
Code;  c880f022 <_end+84d5872/3fcc4850>   <=====
   0:   89 02                     mov    %eax,(%edx)   <=====
Code;  c880f024 <_end+84d5874/3fcc4850>
   2:   8b 41 04                  mov    0x4(%ecx),%eax
Code;  c880f027 <_end+84d5877/3fcc4850>
   5:   8b 53 04                  mov    0x4(%ebx),%edx
Code;  c880f02a <_end+84d587a/3fcc4850>
   8:   8b 40 3c                  mov    0x3c(%eax),%eax
Code;  c880f02d <_end+84d587d/3fcc4850>
   b:   89 42 3c                  mov    %eax,0x3c(%edx)
Code;  c880f030 <_end+84d5880/3fcc4850>
   e:   8b 41 04                  mov    0x4(%ecx),%eax
Code;  c880f033 <_end+84d5883/3fcc4850>
  11:   8b 53 04                  mov    0x4(%ebx),%edx


