From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Mon, 12 Jan 2004 10:38:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0f0c01c3d8ef$d7cb3cb0$060ba8c0@AldiP4>
References: <Pine.LNX.4.44.0401111307500.2644-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout11.sul.t-online.com ([194.25.134.85]:48613 "EHLO
	mailout11.sul.t-online.com") by vger.kernel.org with ESMTP
	id S265439AbUALJmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 04:42:13 -0500
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Sun, 11 Jan 2004, Kai Ruhnau wrote:
>
> > > I can load the module for aha152x from these bootdisks and it works.
> >
> > This precompiled kernel is with aha152x as a module.
>
> See below.
>
> > > But I just tried to use a self-compiled 2.4.10 from the kernel.org
> > > sources and it fails.
> > > After "scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $" I get a
> > > timeout and a NULL-pointer dereference.
> >
> > This one is with aha152x compiled in.
>
> Ok, this proves, that also 2.4.10 manages to handle your controller only
> when compiled as a module. What might help you is to compile 2.4.24 with
> aha152x as a module - also to boot either from a diskette or with an
> initramdisk. If this works, it will give us a good hint where to look
> further. Another thing would be to see if SuSE had some patches for
> aha152x. Do you have sources for SuSE 2.4.10? Would be interesting to
> compare the whole drivers/scsi directories from stock 2.4.10 and that from
> SuSE. Also, could be useful to see the decoded Oops from vanilla 2.4.10.

First of all
s/2\.4\.24/2.4.22/g
Sorry.

I try to do, what I can:

kernel 2.4.22 aha152x compiled in:
  aha152x: ABORT timed out - removed from issue queue
kernel 2.4.22 aha152x as module:
  No such device
kernel 2.4.10 aha152x compiled in:
  timeout and NULL-pointer dereference
kernel 2.4.10 aha152x as module:
  kernel Oops (NULL pointer dereference) during linuxrc

drivers/scsi/ of SuSE's 2.4.10:
  please have a look at
    http://tragetaschen.dyndns.org/kernel/drivers_scsi.tar.bz2
  original, full sources at
    ftp://ftp.suse.com/pub/suse/i386/7.3/suse/d2/kernel-source.rpm
  the drivers/scsi/ diff from vanilla-2.4.10 to SuSE-2.4.10 is at

    http://tragetaschen.dyndns.org/kernel/vanilla2suse.bz2
  (Sorry, but I only have 16k upload)

decoded Oops (I hope I did it right)
ksymoops 2.4.9 on i586 2.4.10-4GB.  Options used
     -v /usr/src/linux-2.4.10/vmlinux (specified)
     -K (specified)
     -l /proc/modules (default)
     -o /lib/modules/2.4.10/ (specified)
     -m /usr/src/linux-2.4.10/System.map (specified)

No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Unable to handle kernel NULL pointer dereference at virtual address 000000ef
c01a1eab
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<c01a1eab>]
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010082
eax: 00000000   ebx: c7f81dd0   ecx: c01a1f40   edx: 00000000
esi: 00000000   edi: c7f82078   ebp: c7f82000   esp: c7181f74
ds: 0018   es: 0018   ss: 0018
Process scsi_eh_0 (pid: 7, stackpage=c7f81000)
Stack: 00000082 00000282 c7f82000 00000000 c024f640 c01a1f53 c7f82000
c7f82078
       00000282 c7fc6c00 c019bacd c7fc6c00 00000000 c7fc6c00 c019c26c
c7fc6c00
       c7f8c160 00000000 c7f80000 c7f82000 c7f81fd4 c024f640 c019c5e9
c7f82000
Call Trace: [<c01a1f53>] [<c019bacd>] [<c019c26c>] [<c019c5e9>] [<c0105586>]
   [<c019c520>]
Code: f6 80 ef 00 00 00 10 75 66 8b 0f 31 d2 85 c9 74 3a 39 cb 74


>>EIP; c01a1eab <scsi_resize_dma_pool+3ab/470>   <=====

>>ecx; c01a1f40 <scsi_resize_dma_pool+440/470>

Trace; c01a1f53 <scsi_resize_dma_pool+453/470>
Trace; c019bacd <scsi_register+13d/380>
Trace; c019c26c <scsi_ioctl_get_pci+2c/30>
Trace; c019c5e9 <scsi_ioctl+379/3b0>
Trace; c0105586 <machine_restart+46/80>
Trace; c019c520 <scsi_ioctl+2b0/3b0>

Code;  c01a1eab <scsi_resize_dma_pool+3ab/470>
00000000 <_EIP>:
Code;  c01a1eab <scsi_resize_dma_pool+3ab/470>   <=====
   0:   f6 80 ef 00 00 00 10      testb  $0x10,0xef(%eax)   <=====
Code;  c01a1eb2 <scsi_resize_dma_pool+3b2/470>
   7:   75 66                     jne    6f <_EIP+0x6f>
Code;  c01a1eb4 <scsi_resize_dma_pool+3b4/470>
   9:   8b 0f                     mov    (%edi),%ecx
Code;  c01a1eb6 <scsi_resize_dma_pool+3b6/470>
   b:   31 d2                     xor    %edx,%edx
Code;  c01a1eb8 <scsi_resize_dma_pool+3b8/470>
   d:   85 c9                     test   %ecx,%ecx
Code;  c01a1eba <scsi_resize_dma_pool+3ba/470>
   f:   74 3a                     je     4b <_EIP+0x4b>
Code;  c01a1ebc <scsi_resize_dma_pool+3bc/470>
  11:   39 cb                     cmp    %ecx,%ebx
Code;  c01a1ebe <scsi_resize_dma_pool+3be/470>
  13:   74 00                     je     15 <_EIP+0x15>



HTH and Greetings
Kai

