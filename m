From: Gerold Jury <gml@inode.at>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Fri, 29 Feb 2008 22:59:11 +0100
Message-ID: <200802292259.12047.gml@inode.at>
References: <200802252005.22663.gml@inode.at> <1204183844.10161.57.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761681AbYB2V5Q@vger.kernel.org>
In-Reply-To: <1204183844.10161.57.camel@homer.simson.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The oldest kernel that i tried is now 2.6.18 and behaves the same as all the 
others up to 2.6.24.2.
I did the tests on 2.6.18 in runlevel 1 with only udevd running to make sure 
no other program is sending any commands to the drive.

I am suspicious about the LG hardware as well so i hooked it to the friendly 
windows pc in the neighborhood but it works quite well there.

The SATA port the LG drive is connected to, was previously occupied by a 
maxtor harddrive and did it's work without troubles.

Does anybody know a possible meaning of the byte sequence
2a 00 00 00 00 80 00 00  40 00 00 00 00 80 00 00
in the context of scsi dvd writing
 
Regards
Gerold


On Thursday 28 February 2008 08:30:44 Mike Galbraith wrote:
>On Mon, 2008-02-25 at 20:05 +0100, Gerold Jury wrote:
>> Hello,
>
>Hi,
>
>> I have two DVD drives, one connected to the SATA port (LG) the other to
>> the IDE port (PHILIPS) of a via chipset.
>> They are driven by VIA SATA support (SATA_VIA) and VIA PATA support
>> (PATA_VIA).
>>
>> When I write an iso image to the drive on the SATA port /dev/sr0 it has
>> some extra bytes on disk which make the disk unreadable.
>> Writing to the IDE drive /dev/sr1 works well.
>
>I take it kernels < 2.6.23 are known to be functional?  If so, a git
>bisect should be really easy if you're a git user _and_ the breakage is
>in drivers/ata/sata_via.c, there are only two meaningful commits
>involved.
>
>homer:..git/linux-2.6 # git bisect start -- drivers/ata/sata_via.c
>homer:..git/linux-2.6 # git bisect good v2.6.22
>homer:..git/linux-2.6 # git bisect bad v2.6.23
>Bisecting: 2 revisions left to test after this
>
>A full bisection would take quite a few more builds.
>
>(I haven't noticed anybody else reporting similar troubles, and quite a
>lot of time has passed since 2.6.22 was released.. that makes me
>suspicious of your hardware)
>
>Maybe you should post again, and add cc's to  linux-ide@vger.kernel.org
>and  linux-scsi@vger.kernel.org, perhaps someone there can give you a
>better idea.
>
>> A simple test with a DVD RAM and dd instead of growisofs
>>
>> dd if=/dev/zero of=/dev/srX bs=1024k count=10
>>
>> and a readback afterwards
>>
>> dd if=/dev/srX of=imageX.bin bs=1024k count=10
>>
>> gives me an all zero file from the IDE drive but a file
>> full of probably scsi commands for the SATA drive and looks like
>>
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
>> |................| *
>> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00 
>> |*....@..@....@..| 00020010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> 00  |................| *
>> 00040000  2a 00 00 00 00 80 00 00  40 00 00 00 00 80 00 00 
>> |*.......@.......| 00040010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> 00  |................| *
>> 00060000  2a 00 00 00 00 c0 00 00  02 00 00 00 00 c0 00 00 
>> |*...............| 00060010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
>> 00  |................| *
>> 00061010  00 00 00 00 00 00 00 00  2a 00 00 00 00 c2 00 00 
>> |........*.......| 00061020  40 00 00 00 00 c2 00 00  00 00 00 00 00 00 00
>> 00  |@...............| 00061030  00 00 00 00 00 00 00 00  00 00 00 00 00
>> 00 00 00  |................| *
>> 00081010  00 00 00 00 00 00 00 00  2a 00 00 00 01 02 00 00 
>> |........*.......| 00081020  40 00 00 00 01 02 00 00  00 00 00 00 00 00 00
>> 00  |@...............| 00081030  00 00 00 00 00 00 00 00  00 00 00 00 00
>> 00 00 00  |................| *
>> 000a1010  00 00 00 00 00 00 00 00  2a 00 00 00 01 42 00 00 
>> |........*....B..| 000a1020  40 00 00 00 01 42 00 00  00 00 00 00 00 00 00
>> 00  |@....B..........| 000a1030  00 00 00 00 00 00 00 00  00 00 00 00 00
>> 00 00 00  |................| *
>> 000c1010  00 00 00 00 00 00 00 00  2a 00 00 00 01 82 00 00 
>> |........*.......| 000c1020  40 00 00 00 01 82 00 00  00 00 00 00 00 00 00
>> 00  |@...............| 000c1030  00 00 00 00 00 00 00 00  00 00 00 00 00
>> 00 00 00  |................|
>>
>> I really need some hints to make the SATA drive usable, please.
>>
>> best Regards
>> Gerold
>>
>>
>> uname -a
>> Linux blaubaer 2.6.24.2 #4 Sun Feb 24 21:50:21 CET 2008 x86_64 AMD
>> Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux
>>
>> lspvi -v
>>
>> 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
>> Controller (rev 80)
>>         Subsystem: ASUSTeK Computer Inc. A7V600/K8V Deluxe/K8V-X/A8V
>> Deluxe motherboard
>>         Flags: bus master, medium devsel, latency 64, IRQ 20
>>         I/O ports at e800 [size=8]
>>         I/O ports at e400 [size=4]
>>         I/O ports at e000 [size=8]
>>         I/O ports at d800 [size=4]
>>         I/O ports at d400 [size=16]
>>         I/O ports at d000 [size=256]
>>         Capabilities: [c0] Power Management version 2
>>         Kernel driver in use: sata_via
>>
>> 00:0f.1 IDE interface: VIA Technologies, Inc.
>> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if
>> 8a [Master SecP PriP])
>>         Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe
>> motherboard Flags: bus master, medium devsel, latency 32, IRQ 20
>>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
>>         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
>>         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
>>         [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
>>         I/O ports at fc00 [size=16]
>>         Capabilities: [c0] Power Management version 2
>>         Kernel driver in use: pata_via
>>
>> cat /var/log/messages
>>
>> Feb 25 18:20:57 blaubaer sata_via 0000:00:0f.0: version 2.3
>> Feb 25 18:20:57 blaubaer ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20
>> (level, low) -> IRQ 20
>> Feb 25 18:20:57 blaubaer sata_via 0000:00:0f.0: routed to hard irq line 10
>> Feb 25 18:20:57 blaubaer scsi3 : sata_via
>> Feb 25 18:20:57 blaubaer scsi4 : sata_via
>> Feb 25 18:20:57 blaubaer ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe400
>> bmdma 0xd400 irq 20
>> Feb 25 18:20:57 blaubaer ata5: SATA max UDMA/133 cmd 0xe000 ctl 0xd800
>> bmdma 0xd408 irq 20
>> Feb 25 18:20:57 blaubaer ata4: SATA link down 1.5 Gbps (SStatus 0 SControl
>> 300)
>> Feb 25 18:20:57 blaubaer ata5: SATA link up 1.5 Gbps (SStatus 113 SControl
>> 300)
>> Feb 25 18:20:57 blaubaer ata5.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00,
>> max UDMA/100
>> Feb 25 18:20:57 blaubaer ata5.00: configured for UDMA/100
>> Feb 25 18:20:57 blaubaer scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM
>> GH20NS10  EL00 PQ: 0 ANSI: 5
>> Feb 25 18:20:57 blaubaer sr0: scsi3-mmc drive: 48x/48x writer dvd-ram
>> cd/rw xa/form2 cdda tray
>> Feb 25 18:20:57 blaubaer Uniform CD-ROM driver Revision: 3.20
>> Feb 25 18:20:57 blaubaer sr 4:0:0:0: Attached scsi CD-ROM sr0
>> Feb 25 18:20:57 blaubaer sr 4:0:0:0: Attached scsi generic sg2 type 5
>> Feb 25 18:20:57 blaubaer pata_via 0000:00:0f.1: version 0.3.3
>> Feb 25 18:20:57 blaubaer ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20
>> (level, low) -> IRQ 20
>> Feb 25 18:20:57 blaubaer scsi5 : pata_via
>> Feb 25 18:20:57 blaubaer scsi6 : pata_via
>> Feb 25 18:20:57 blaubaer ata6: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma
>> 0xfc00 irq 14
>> Feb 25 18:20:57 blaubaer ata7: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma
>> 0xfc08 irq 15
>> Feb 25 18:20:57 blaubaer ata6.00: ATAPI: PHILIPS SPD2411P, BP01, max
>> UDMA/66 Feb 25 18:20:57 blaubaer ata6.00: limited to UDMA/33 due to
>> 40-wire cable Feb 25 18:20:57 blaubaer ata6.00: configured for UDMA/33
>> Feb 25 18:20:57 blaubaer scsi 5:0:0:0: CD-ROM            PHILIPS  SPD2411P
>> BP01 PQ: 0 ANSI: 5
>> Feb 25 18:20:57 blaubaer sr1: scsi3-mmc drive: 48x/48x writer dvd-ram
>> cd/rw xa/form2 cdda tray
>> Feb 25 18:20:57 blaubaer sr 5:0:0:0: Attached scsi CD-ROM sr1
>> Feb 25 18:20:57 blaubaer sr 5:0:0:0: Attached scsi generic sg3 type 5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
