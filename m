From: Halim Issa <yallaone@gmail.com>
Subject: Trouble with LSI Logic / Symbios Logic 53c1030 on Linux 2.6.20.4
Date: Thu, 29 Mar 2007 16:23:37 +0200
Message-ID: <200703291623.37560.yallaone@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:22966 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXC2OXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 10:23:40 -0400
Received: by nf-out-0910.google.com with SMTP id o25so211442nfa
        for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 07:23:39 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello List,

Running vanilla kernel 2.6.20.4 (unmodified from kernel.org) on an IBM =
x335=20
Server with LSI Logic 53c1030 and two SCSI disks in RAID-1, we have som=
e=20
serious performance issues that we suspect are present due to driver=20
problems.

The performance is as follows:

[189] root@spirou:/tmp#dd if=3D/dev/sda7 of=3D/dev/null bs=3D64k count=3D=
100
100+0 records in
100+0 records out
6553600 bytes (6.6 MB) copied, 1.50139 s, 4.4 MB/s
[190] root@spirou:/tmp#dd if=3D/dev/sda7 of=3D/dev/null bs=3D64k count=3D=
1000
1000+0 records in
1000+0 records out
65536000 bytes (66 MB) copied, 18.0209 s, 3.6 MB/s
[191] root@spirou:/tmp#dd if=3D/dev/sda7 of=3D/dev/null bs=3D64k count=3D=
10000
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 179.74 s, 3.6 MB/s

I've also tried copying between real files (ie non-/dev-files)

[496] root@spirou:/root#dd if=3Dtestfile.out of=3Dtest.yalla bs=3D64k c=
ount=3D1000
1000+0 records in
1000+0 records out
65536000 bytes (66 MB) copied, 12.5143 s, 5.2 MB/s

Needless to say, getting between three and five meg throughput on such =
a
system clearly means something is wrong, and the most likely culprit is=
 the=20
operator (myself), but so far I have found no indications anywhere on h=
ow to=20
proceed, and hence this email..

The card according to lspci -v :

01:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-=
X
=46usion-
MPT Dual Ultra320 SCSI (rev 07)
=A0 =A0 Subsystem: IBM Unknown device 026d
=A0 =A0 Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 16
=A0 =A0 I/O ports at 2300 [size=3D256]
=A0 =A0 Memory at fbff0000 (64-bit, non-prefetchable) [size=3D64K]
=A0 =A0 Memory at fbfe0000 (64-bit, non-prefetchable) [size=3D64K]
=A0 =A0 [virtual] Expansion ROM at 88100000 [disabled] [size=3D1M]
=A0 =A0 Capabilities: [50] Power Management version 2
=A0 =A0 Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable-
=A0 =A0 Capabilities: [68] PCI-X non-bridge device

The kernel config is at : http://pastebin.ca/411667
the dmesg output is at : http://pastebin.ca/411670

Is this a common problem on these controllers?
Perhaps needless to say, I'm rather new to this and am trying to gain=20
experience in this field as quickly as possible. Any hints to bugfixes,=
=20
patches or configuration hints would be most greatly appreciated!

Thanks in advance for any insight - it will be warmly appreciated!

 -h
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
