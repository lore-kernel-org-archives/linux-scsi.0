From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till
 2.6.24.2
Date: Sat, 1 Mar 2008 14:53:54 +0300
Message-ID: <20080301145354.ca4d4f1a.vsu@altlinux.ru>
References: <200802252005.22663.gml@inode.at>
	<1204183844.10161.57.camel@homer.simson.net>
	<200802292259.12047.gml@inode.at>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__1_Mar_2008_14_53_55_+0300_K0XlylGJd2vQNAGD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master.altlinux.org ([62.118.250.235]:2695 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYCALx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 06:53:59 -0500
In-Reply-To: <200802292259.12047.gml@inode.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerold Jury <gml@inode.at>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

--Signature=_Sat__1_Mar_2008_14_53_55_+0300_K0XlylGJd2vQNAGD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 29 Feb 2008 22:59:11 +0100 Gerold Jury wrote:

> The oldest kernel that i tried is now 2.6.18 and behaves the same as all the
> others up to 2.6.24.2.
> I did the tests on 2.6.18 in runlevel 1 with only udevd running to make sure
> no other program is sending any commands to the drive.
>
> I am suspicious about the LG hardware as well so i hooked it to the friendly
> windows pc in the neighborhood but it works quite well there.
>
> The SATA port the LG drive is connected to, was previously occupied by a
> maxtor harddrive and did it's work without troubles.
>
> Does anybody know a possible meaning of the byte sequence
> 2a 00 00 00 00 80 00 00  40 00 00 00 00 80 00 00
> in the context of scsi dvd writing

0x2a is the SCSI WRITE(10) command; the following 10 bytes look like
its arguments (bytes 2-5 - logical block address, bytes 7-8 - transfer
length in blocks); last 4 bytes seem to be another copy of the logical
block address.

> >> A simple test with a DVD RAM and dd instead of growisofs
> >>
> >> dd if=/dev/zero of=/dev/srX bs=1024k count=10
> >>
> >> and a readback afterwards
> >>
> >> dd if=/dev/srX of=imageX.bin bs=1024k count=10
> >>
> >> gives me an all zero file from the IDE drive but a file
> >> full of probably scsi commands for the SATA drive

Does this happen only with DVD-RAM?  Could you try with a DVD+RW disk
(these disks could also be written to with a simple "dd" after initial
formatting)?

> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|
> 00020010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00040000  2a 00 00 00 00 80 00 00  40 00 00 00 00 80 00 00  |*.......@.......|
> 00040010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00060000  2a 00 00 00 00 c0 00 00  02 00 00 00 00 c0 00 00  |*...............|
> 00060010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00061010  00 00 00 00 00 00 00 00  2a 00 00 00 00 c2 00 00  |........*.......|
> 00061020  40 00 00 00 00 c2 00 00  00 00 00 00 00 00 00 00  |@...............|
> 00061030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00081010  00 00 00 00 00 00 00 00  2a 00 00 00 01 02 00 00  |........*.......|
> 00081020  40 00 00 00 01 02 00 00  00 00 00 00 00 00 00 00  |@...............|
> 00081030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 000a1010  00 00 00 00 00 00 00 00  2a 00 00 00 01 42 00 00  |........*....B..|
> 000a1020  40 00 00 00 01 42 00 00  00 00 00 00 00 00 00 00  |@....B..........|
> 000a1030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 000c1010  00 00 00 00 00 00 00 00  2a 00 00 00 01 82 00 00  |........*.......|
> 000c1020  40 00 00 00 01 82 00 00  00 00 00 00 00 00 00 00  |@...............|
> 000c1030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

Definitely looks like SCSI WRITE(10) commands, and the LBA field
corresponds to the location of the broken data (assuming 2KB block
size).

> >> uname -a
> >> Linux blaubaer 2.6.24.2 #4 Sun Feb 24 21:50:21 CET 2008 x86_64 AMD
> >> Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux
> >>
> >> lspvi -v
> >>
> >> 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
> >> Controller (rev 80)
> >>         Subsystem: ASUSTeK Computer Inc. A7V600/K8V Deluxe/K8V-X/A8V
> >> Deluxe motherboard
> >>         Flags: bus master, medium devsel, latency 64, IRQ 20
> >>         I/O ports at e800 [size=8]
> >>         I/O ports at e400 [size=4]
> >>         I/O ports at e000 [size=8]
> >>         I/O ports at d800 [size=4]
> >>         I/O ports at d400 [size=16]
> >>         I/O ports at d000 [size=256]
> >>         Capabilities: [c0] Power Management version 2
> >>         Kernel driver in use: sata_via
> >>
> >> 00:0f.1 IDE interface: VIA Technologies, Inc.
> >> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if
> >> 8a [Master SecP PriP])
> >>         Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe
> >> motherboard Flags: bus master, medium devsel, latency 32, IRQ 20
> >>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
> >>         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
> >>         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
> >>         [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
> >>         I/O ports at fc00 [size=16]
> >>         Capabilities: [c0] Power Management version 2
> >>         Kernel driver in use: pata_via
> >>
> >> cat /var/log/messages
> >>
> >> Feb 25 18:20:57 blaubaer sata_via 0000:00:0f.0: version 2.3
> >> Feb 25 18:20:57 blaubaer ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20
> >> (level, low) -> IRQ 20
> >> Feb 25 18:20:57 blaubaer sata_via 0000:00:0f.0: routed to hard irq line 10
> >> Feb 25 18:20:57 blaubaer scsi3 : sata_via
> >> Feb 25 18:20:57 blaubaer scsi4 : sata_via
> >> Feb 25 18:20:57 blaubaer ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe400
> >> bmdma 0xd400 irq 20
> >> Feb 25 18:20:57 blaubaer ata5: SATA max UDMA/133 cmd 0xe000 ctl 0xd800
> >> bmdma 0xd408 irq 20
> >> Feb 25 18:20:57 blaubaer ata4: SATA link down 1.5 Gbps (SStatus 0 SControl
> >> 300)
> >> Feb 25 18:20:57 blaubaer ata5: SATA link up 1.5 Gbps (SStatus 113 SControl
> >> 300)
> >> Feb 25 18:20:57 blaubaer ata5.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00,
> >> max UDMA/100
> >> Feb 25 18:20:57 blaubaer ata5.00: configured for UDMA/100
> >> Feb 25 18:20:57 blaubaer scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM
> >> GH20NS10  EL00 PQ: 0 ANSI: 5
> >> Feb 25 18:20:57 blaubaer sr0: scsi3-mmc drive: 48x/48x writer dvd-ram
> >> cd/rw xa/form2 cdda tray
> >> Feb 25 18:20:57 blaubaer Uniform CD-ROM driver Revision: 3.20
> >> Feb 25 18:20:57 blaubaer sr 4:0:0:0: Attached scsi CD-ROM sr0
> >> Feb 25 18:20:57 blaubaer sr 4:0:0:0: Attached scsi generic sg2 type 5
> >> Feb 25 18:20:57 blaubaer pata_via 0000:00:0f.1: version 0.3.3
> >> Feb 25 18:20:57 blaubaer ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20
> >> (level, low) -> IRQ 20
> >> Feb 25 18:20:57 blaubaer scsi5 : pata_via
> >> Feb 25 18:20:57 blaubaer scsi6 : pata_via
> >> Feb 25 18:20:57 blaubaer ata6: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma
> >> 0xfc00 irq 14
> >> Feb 25 18:20:57 blaubaer ata7: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
> >> 0xfc08 irq 15
> >> Feb 25 18:20:57 blaubaer ata6.00: ATAPI: PHILIPS SPD2411P, BP01, max
> >> UDMA/66 Feb 25 18:20:57 blaubaer ata6.00: limited to UDMA/33 due to
> >> 40-wire cable Feb 25 18:20:57 blaubaer ata6.00: configured for UDMA/33
> >> Feb 25 18:20:57 blaubaer scsi 5:0:0:0: CD-ROM            PHILIPS  SPD2411P
> >> BP01 PQ: 0 ANSI: 5
> >> Feb 25 18:20:57 blaubaer sr1: scsi3-mmc drive: 48x/48x writer dvd-ram
> >> cd/rw xa/form2 cdda tray
> >> Feb 25 18:20:57 blaubaer sr 5:0:0:0: Attached scsi CD-ROM sr1
> >> Feb 25 18:20:57 blaubaer sr 5:0:0:0: Attached scsi generic sg3 type 5

--Signature=_Sat__1_Mar_2008_14_53_55_+0300_K0XlylGJd2vQNAGD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHyUPWW82GfkQfsqIRApcuAJ9j5uZv+eQvyvERosgtYDtXBjBAGgCfbood
Vjw3JYf0fKcfVVzNXMyGyLQ=
=oM6j
-----END PGP SIGNATURE-----

--Signature=_Sat__1_Mar_2008_14_53_55_+0300_K0XlylGJd2vQNAGD--
