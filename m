From: "Mr. Berkley Shands" <bshands@exegy.com>
Subject: marvell 8 port sata 2.6.14-rc1 problems MV88SX6081
Date: Wed, 14 Sep 2005 13:10:33 -0500
Message-ID: <43286799.9040809@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66.64.135.114.nw.nuvox.net ([66.64.135.114]:48463 "EHLO
	service.eng.exegy.net") by vger.kernel.org with ESMTP
	id S932732AbVINSLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 14:11:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: russb@emc.com
Cc: linux-scsi@vger.kernel.org

I have been using the hptmv6 sata module provided by highpoint-tech for 
their
rocketraid-2220 sata controller. works fine on 2.6.9 and 2.6.10, runs 
slow as a dog under 2.6.13.
So seeing "native" support in 2.6.14-rc1 I thought I could use some 
abuse :-)

I have a sun 2100Z motherboard, Centos 4.1 x86_64 and an existing farm of
sata controllers/drives.
/AMD/fedora-2.6.14-rc1> lspci
00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:07.5 Multimedia audio controller: Advanced Micro Devices [AMD] 
AMD-8111 AC97 Audio (rev 03)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:02.0 Class 0106: Silicon Image, Inc. SiI 3512 [SATALink/SATARaid] 
Serial ATA Controller (rev 01)
01:03.0 USB Controller: NEC Corporation USB (rev 43)
01:03.1 USB Controller: NEC Corporation USB (rev 43)
01:03.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
02:01.0 SCSI storage controller: Marvell Technology Group Ltd. 
MV88SX6081 8-port SATA II PCI-X Controller (rev 07)
03:01.0 SCSI storage controller: Marvell Technology Group Ltd. 
MV88SX6081 8-port SATA II PCI-X Controller (rev 07)
03:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X 
Gigabit Ethernet (rev 02)
08:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-8151 System 
Controller (rev 14)
08:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8151 AGP Bridge 
(rev 14)
08:03.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
08:03.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
08:04.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
08:04.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
09:00.0 VGA compatible controller: nVidia Corporation NV18GL [Quadro4 
NVS AGP 8x] (rev c1)
0e:01.0 SCSI storage controller: Marvell Technology Group Ltd. 
MV88SX6081 8-port SATA II PCI-X Controller (rev 07)
13:03.0 Co-processor: Xilinx Corporation: Unknown device 1000 (rev 01)
13:04.0 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
13:04.1 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
On /sbin/modprobe sata_mv, I get
Sep 14 12:55:00 exegysatademo01 syslogd 1.4.1: restart.
Sep 14 12:55:02 exegysatademo01 crond(pam_unix)[4280]: session opened 
for user root by (uid=0)
Sep 14 12:55:02 exegysatademo01 crond(pam_unix)[4280]: session closed 
for user root
Sep 14 12:55:10 exegysatademo01 kernel: ENTER for PCI Bus:Slot.Func=2:1.0
Sep 14 12:55:10 exegysatademo01 kernel: ACPI: PCI Interrupt 
0000:02:01.0[A] -> GSI 26 (level, low) -> IRQ 233
Sep 14 12:55:10 exegysatademo01 kernel: ENTER
Sep 14 12:55:10 exegysatademo01 kernel: EXIT, rc = 0
Sep 14 12:55:10 exegysatademo01 kernel: EDMA cfg=0x0000291f EDMA IRQ err 
cause/mask=0x00000000/0xffffffff
Sep 14 12:55:10 exegysatademo01 last message repeated 7 times
Sep 14 12:55:10 exegysatademo01 kernel: HC0: HC config=0x000100ff HC IRQ 
cause=0x00000000
Sep 14 12:55:10 exegysatademo01 kernel: HC1: HC config=0x000100ff HC IRQ 
cause=0x00000000
Sep 14 12:55:10 exegysatademo01 kernel: HC MAIN IRQ 
cause/mask=0x00000000/0x0087ffff PCI int cause/mask=0x00000000/0x00557fee
Sep 14 12:55:10 exegysatademo01 kernel: PCI config space:
Sep 14 12:55:10 exegysatademo01 kernel: 608111ab 02b00157 01000007 00004010
Sep 14 12:55:10 exegysatademo01 kernel: e0200004 00000000 00003001 e0300004
Sep 14 12:55:10 exegysatademo01 kernel: 00000000 00000000 00000000 11ab11ab
Sep 14 12:55:10 exegysatademo01 kernel: 00000000 00000040 00000000 0000010a
Sep 14 12:55:10 exegysatademo01 kernel: ata3: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000922120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata4: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000924120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata5: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000926120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata6: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000928120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata7: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000932120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata8: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000934120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata9: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000936120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ata10: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000938120 bmdma 0x0 irq 233
Sep 14 12:55:10 exegysatademo01 kernel: ENTER, port 0, mmio 
0xffffc20000922000
Sep 14 12:55:10 exegysatademo01 kernel: Done.  Now calling 
__sata_phy_reset()
Sep 14 12:55:10 exegysatademo01 kernel: EXIT
Sep 14 12:55:10 exegysatademo01 kernel: ata3: dev 0 ATA, max UDMA/133, 
390721968 sectors: lba48

and then the module hangs. Bummer. Where to go from here?
(at least it does something, the mpt fusion driver just gives up :-)

The same hang happens with a short backport to 2.6.13. The module hangs 
on the first "drive" (there
are 8 2-drive raid0's defined). No entry in /dev/sd* is created yet by 
udev. Any pointers, and I'll happily cause havoc
on my lab machines.

berkley
bshands@exegy.com or berkley@cse.wustl.edu

 
