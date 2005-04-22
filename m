From: Klaus Steinberger <Klaus.Steinberger@physik.uni-muenchen.de>
Subject: Kernel OOPS with aacraid driver
Date: Fri, 22 Apr 2005 07:49:56 +0200
Message-ID: <200504220749.56416.Klaus.Steinberger@physik.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:8322 "EHLO
	mail.physik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S261974AbVDVFwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 01:52:53 -0400
Received: from localhost (unknown [127.0.0.1])
	by mail.physik.uni-muenchen.de (Postfix) with ESMTP id B08D520063
	for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2005 07:52:52 +0200 (CEST)
Received: from mail.physik.uni-muenchen.de ([127.0.0.1])
 by localhost (mail.physik.uni-muenchen.de [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 09127-02-3 for <linux-scsi@vger.kernel.org>;
 Fri, 22 Apr 2005 07:52:50 +0200 (CEST)
Received: from [192.168.1.10] (b6.lmu.vpn.lrz-muenchen.de [141.84.30.6])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.physik.uni-muenchen.de (Postfix) with ESMTP id BC16220053
	for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2005 07:52:50 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

since Kernel Version 2.6.10 I get kernel OOPS when I try to use the Adaptec 
Raidtools (ASMBE as well as the CLI tool: aacli). I reported this to Fedora 
Bugzilla as the following bug ( 148761 )

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=148761

They told me to report that to upstream.

Apr 21 10:53:33 www adaptec-smbe: arcpd startup succeeded
Apr 21 10:53:36 www adaptec-smbe: anotifyd startup succeeded
Apr 21 10:53:36 www kernel: Unable to handle kernel NULL pointer dereference 
at
virtual address 00000034
Apr 21 10:53:36 www kernel:  printing eip:
Apr 21 10:53:36 www kernel: c03227a0
Apr 21 10:53:36 www kernel: *pde = 359b2001
Apr 21 10:53:36 www kernel: Oops: 0000 [#2]
Apr 21 10:53:36 www kernel: SMP
Apr 21 10:53:36 www kernel: Modules linked in: md5 ipv6 iptable_filter 
ip_tables
tg3 floppy sg microcode ohci_hcd video button battery ac ext3 jbd dm_mod 
aacraid
aic79xx sd_modscsi_mod
Apr 21 10:53:36 www kernel: CPU:    3
Apr 21 10:53:36 www kernel: EIP:    0060:[<c03227a0>]    Not tainted VLI
Apr 21 10:53:36 www kernel: EFLAGS: 00010086   (2.6.11-1.14_FC2.rootsmp)
Apr 21 10:53:36 www kernel: EIP is at _spin_lock_irqsave+0x10/0x60
Apr 21 10:53:36 www kernel: eax: 00000030   ebx: 00000286   ecx: bffff080   
edx:
bffff080
Apr 21 10:53:36 www kernel: esi: 00000030   edi: 00000030   ebp: bffff080   
esp:
f5ecff14
Apr 21 10:53:36 www kernel: ds: 007b   es: 007b   ss: 0068
Apr 21 10:53:36 www kernel: Process aacsnmpd (pid: 3091, threadinfo=f5ecf000
task=f5a01020)
Apr 21 10:53:36 www kernel: Stack: 00000000 0000fe01 00042008 00000000 
f886ac4a
00042008 00000000 00000000
Apr 21 10:53:36 www kernel:        f8869b80 42676a06 00000000 42676a06 
00000000
42676a06 00042008 bffff080
Apr 21 10:53:36 www kernel:        00000000 bffff080 f886a560 f8871d80 
f54da880
ffffffe7 c017580a bffff080
Apr 21 10:53:36 www kernel: Call Trace:
Apr 21 10:53:36 www kernel:  [<f886ac4a>] fib_alloc+0x1a/0x70 [aacraid]
Apr 21 10:53:36 www kernel:  [<f8869b80>] ioctl_send_fib+0x10/0x110 [aacraid]
Apr 21 10:53:36 www kernel:  [<f886a560>] aac_do_ioctl+0x60/0xcf [aacraid]
Apr 21 10:53:36 www kernel:  [<c017580a>] do_ioctl+0x6a/0x90
Apr 21 10:53:36 www kernel:  [<c0175a7e>] vfs_ioctl+0x5e/0x1d0
Apr 21 10:53:36 www kernel:  [<c0175c4b>] sys_ioctl+0x5b/0x90
Apr 21 10:53:36 www kernel:  [<c0104203>] syscall_call+0x7/0xb
Apr 21 10:53:36 www kernel: Code: af de 75 0c f0 83 28 01 79 05 e8 9c e4 ff ff
c3 0f 0b d7 00 78 a7 33 c0 eb ea 90 83 ec 10 89 74 24 0c 89 c6 89 5c 24 08 9c 
5b
fa <81> 78 04 ad4e ad de 75 26 f0 fe 0e 79 13 f7 c3 00 02 00 00 74

The only workaround I currently have is to use the driver from Adaptec.

Sincerly,
Klaus Steinberger

-- 
Klaus Steinberger         Maier-Leibnitz Labor
Phone: (+49 89)289 14287  Am Coulombwall 6, D-85748 Garching, Germany
FAX:   (+49 89)289 14280  EMail: Klaus.Steinberger@Physik.Uni-Muenchen.DE
URL: http://www.physik.uni-muenchen.de/~k2/

In a world without Walls and Fences, who needs Windows and Gates
