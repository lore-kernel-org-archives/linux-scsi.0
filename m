From: Anthony Ewell <amewell@verizon.net>
Subject: Re: slow after upgrade to CentOS 5 (RHEL5)
Date: Wed, 31 Oct 2007 12:12:52 -0700
Message-ID: <4728D3B4.7040002@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms040pub.verizon.net ([206.46.252.40]:36228 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbXJaTNH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 15:13:07 -0400
Received: from rn1.rent-a-nerd.local ([71.243.201.138])
 by vms040.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0JQS004AFIPHEFK6@vms040.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Wed, 31 Oct 2007 14:12:56 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bo.yang@lsi.com, James Bottomley <James.Bottomley@SteelEye.com>, "Patro, Sumant" <Sumant.Patro@lsi.com>, Mark Harvey <mark_harvey@symantec.com>

James Bottomley wrote:
 > Please don't drop the cc lists.  There are others who probably have more
 > informed opinions than I do who won't get to comment if they don't see
 > it.
 >
 > On Sun, 2007-10-28 at 17:36 -0700, Anthony Ewell wrote:
 >> James Bottomley wrote:
 >>> On Sat, 2007-10-27 at 13:21 -0700, Anthony Ewell wrote:
 >>>> James Bottomley wrote:
 >>>>> On Wed, 2007-10-24 at 18:04 -0700, Anthony Ewell wrote:
 >>>>>> Hi All,
 >>>>>>
 >>>>>>     If you all would not mind a post from the general
 >>>>>> public Linux user, after doing a complete disk wipe
 >>>>>> of CentOS 4 and installing CentOS5, my system is preceived
 >>>>>> to be 3 times slower.
 >>>>>>
 >>>>>>      To troubleshooting this, I made a post on CentOS's
 >>>>>> bugzilla:  http://bugs.centos.org/view.php?id=2382
 >>>>>>
 >>>>>>      Would some of the experts on this group mind
 >>>>>> looking at the bug to evaluate the possibility
 >>>>>> that it is being caused by the underlying scsi
 >>>>>> driver?   The post contains a dmesg from "Computer C".
 >>>>>> (Yes, I am getting a bit desperate.)
 >>>>> There's still too little information in the bug report to tell 
much of
 >>>>> anything.  The dmesg doesn't indicate any anomaly with the megaraid
 >>>>> (although the LSI people might be able to tell better).  However, it
 >>>>> also doesn't contain a trace of the tape drive.
 >>>>>
 >>>>> Best guess would be a slow down in the megaraid driver.  Can you try
 >>>>> doing a speed test on it?  (hdparm -t should suffice).
 >>>>>
 >>>>> James
 >>>> Hi James,
 >>>>
 >>>> The other guy reporting the problem
 >>>>
 >>>> 
http://www.centos.org/modules/newbb/viewtopic.php?topic_id=10659&start=0#forumpost34209
 >>>> is not using a MegaRAID card.  He is using 3ware9508 Raid Controllers.
 >>>> He is also using a different processor (amd vs xeon) and a different
 >>>> chipset (Intel Greenwood vs nVidia)
 >>>>
 >>>> I also spoke to Neela Kolli (Mega RAID maintainer) and he said he'd
 >>>> never heard of the problem.  Here are some tests (including dhparm)
 >>>> that I sent to Neela (he never wrote back).
 >>>>
 >>>> I have also checked with Stellen over at the "dump"
 >>>> list and he has not seen the problem (yet).
 >>>>
 >>>> The problem occurs when backing up to a two different types
 >>>> of tape drives and to an eSata drive.
 >>>>
 >>>> When I am running a "dump" on computer C, gnome-system-monitor
 >>>> shows my two cores running at only about 10 to 20% and
 >>>> switching back and forth (one at 0% the other at 20% for
 >>>> about 5 seconds, then switching positions)
 >>>>
 >>>> On Computer C (Cent OS 5), when typing in Word Pro (a windows word 
processor) in Parallels, I can watch myself type.  Computer B
 >>>> (CentOS 4.4, now 4.5) has the same version of Parallels
 >>>> installed on it (Parallels-2.2.2112-lin.i386) that computer C
 >>>> (CentOS 5) has. The perceived speed difference is about a factor
 >>>> of three (you can not watch yourself type).
 >>>>
 >>>> All the "Low Level" test I run seem to come out the same between
 >>>> Cent OS 4.4 and 5.  Very frustrating!  It is almost like some
 >>>> system monitor component is looking at everything and
 >>>> slowing things down.  If this was Windows, I'd go straight
 >>>> to the Anti Virus as the culprit.  (Does SE Linux do such
 >>>> things?)
 >>>>
 >>>> Are there any performance tests I can run for you?
 >>>>
 >>>> Thank you for letting me ramble, this problem is
 >>>> really frustrating.  I am afraid to any additional CentOS5
 >>>> server out there and CentOS 4.x is so terribly out of
 >>>> date.
 >>>>
 >>>> -T
 >>>>
 >>>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 >>>> Tests I sent to Neela:
 >>>>
 >>>> CentOS 5 (2.6.18-8.1.8.el5, Sata150-4):
 >>>>
 >>>> #grep -i bogomips /var/log/dmesg
 >>>> Calibrating delay using timer specific routine.. 4001.91 BogoMIPS 
(lpj=2000959)
 >>>> Calibrating delay using timer specific routine.. 3999.58 BogoMIPS 
(lpj=1999791)
 >>>> Total of 2 processors activated (8001.50 BogoMIPS).
 >>>>
 >>>>
 >>>> #/sbin/hdparm -t /dev/sda
 >>>> /dev/sda:
 >>>>   Timing buffered disk reads:  236 MB in  3.01 seconds =  78.53 MB/sec
 >>>>
 >>>>
 >>>> #/sbin/hdparm -t /dev/sdb
 >>>> /dev/sdb:
 >>>>   Timing buffered disk reads:  182 MB in  3.01 seconds =  60.37 MB/sec
 >>>>
 >>>>
 >>>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 >>>> CentOS 4.4 (linux rescue 2.6.9-42.EL, IDE):
 >>>>
 >>>> #cat /proc/cpuinfo
 >>>> bogomips    : 4002.92
 >>>>
 >>>> #/sbin/hdparm -t /dev/sda
 >>>> /dev/sda:
 >>>>   Timing buffered disk reads:  216 MB in  3.01 seconds =  71.87 MB/sec
 >>>>
 >>>> #/sbin/hdparm -t /dev/sdb
 >>>> /dev/sdb:
 >>>>   Timing buffered disk reads:  184 MB in  3.01 seconds =  61.18 MB/sec
 >>> That pretty much shows, if anything, that transfer speed improved
 >>> from .9 to .18.
 >>>
 >>>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 >>>> CentOS 5 (2.6.18-8.1.3.el5, Sata300-4):
 >>>> #grep -i bogomips /var/log/dmesg
 >>>> Calibrating delay using timer specific routine.. 4001.92 BogoMIPS 
(lpj=2000960)
 >>>> Calibrating delay using timer specific routine.. 3999.58 BogoMIPS 
(lpj=1999794)
 >>>> Total of 2 processors activated (8001.50 BogoMIPS).
 >>>>
 >>>> #/sbin/hdparm -t /dev/sda
 >>>> /dev/sda:
 >>>>   Timing buffered disk reads:  214 MB in  3.02 seconds =  70.86 MB/sec
 >>>>
 >>>>
 >>>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 >>>> CentOS 5  (2.6.18-10.1.3.el5, Sata300-4):
 >>>>
 >>>> eSata:  dump -0a -z -f /dev/nul winxp.hdd
 >>>>    DUMP: Volume 1 took 0:04:04
 >>>>    DUMP: Volume 1 transfer rate: 4247 kB/s
 >>>>    DUMP: Volume 1 1567020kB uncompressed, 1036385kB compressed, 
1.513:1
 >>>>
 >>>> eSata:  dump -0a -f /dev/nul winxp.hdd  (no compression)
 >>>>    DUMP: Volume 1 1036420 blocks (1012.13MB)
 >>>>    DUMP: Volume 1 took 0:02:09
 >>>>    DUMP: Volume 1 transfer rate: 8034 kB/s
 >>>>
 >>>>
 >>>> 150-4:  dump -0a -z -f /dev/nul winxp.hdd
 >>>>    DUMP: Volume 1 took 0:04:05
 >>>>    DUMP: Volume 1 transfer rate: 4230 kB/s
 >>>>    DUMP: Volume 1 1573150kB uncompressed, 1036383kB compressed, 
1.518:1
 >>>>
 >>>> 150-4:  dump -0a -f /dev/nul winxp.hdd  (no compression)
 >>>>    DUMP: Volume 1 1036420 blocks (1012.13MB)
 >>>>    DUMP: Volume 1 took 0:02:05
 >>>>    DUMP: Volume 1 transfer rate: 8291 kB/s
 >>> I think this is beginning to point to problems with dump.  What are the
 >>> corresponding figures for dump under 2.6.9 (or are the two sets of
 >>> figures centos5 followed by centos4)?
 >>>
 >>> James
 >>>
 >> Computer C:
 >> backup drive: eSATA
 >> hard drive: RAID SATA-150-4
 >>
 >> CentOS 4.4, 1:05 hours, approx 52 GB backup file 13,333 kBytes/sec
 >> CentOS 5.0, 3:16 hours, approx 43 GB backup file 3,656 kBytes/sec
 >> Note: 3.6 times slower
 >>
 >> Hi James,
 >>
 >>      The above shows the dump speed difference between CentOS 4.4 and
 >> CentOS 5.
 >>
 >>      I suspected dump at first, until I noticed everything else
 >> was about 3 times slower too, such as Parallels, etc.  Open
 >> Office 2.3 (linux version) opens about 3 times slower.
 >>
 >>      Are there any tests you know of to shake out who is
 >> slowing the works down?
 >
 > Yes, could you do backup write tests without dump in the process (as in
 > just do a straight dd from /dev/zero to the devices in centos 4 and 5).
 > If there's no difference in that, it's some scheduling or filesystem
 > issue with dump, I'd expect.
 >
 >>      When I get a chance, I am going to run a dump from my
 >> CentOS 5 install DVD in rescue mode (linux rescue).  This
 >> to make sure no high level driver is slowing things
 >> down.  I will let you know what shows up.
 >
 > James


Hi All,

First off I fear that I may be sending people
up the wrong tree by giving "dump" data as my
evidence of the computer being slow.  I am using
dump data only because I can get reals numbers.
This gets me around having to use weasel
words like "perceived".  EVERYTHING is slow.

Also, the other individual reporting the slow down
is not using an LSI card.  He is using two 3ware9508
Raid Controllers.


Did some test from my install CD/DVD's in "rescue mode" on
Computer C.  I used the same backup script (dump) that
I use in normal boot mode.  I stopped the backup
after dump gave the first estimate of time:

    "dump" CentOS5 install DVD in rescue mode:
         transfer rate 4422 KB/s, estimated  finish 4:10

    "dump" CentOS4.4 (2.6.9-42.EL) install CD in rescue mode:
         transfer rate 8468 KB/s, estimated  finish 2:09

I also got a "dmesg" from computer B, as requested by Sumant.
Computer B: VXA-3, CentOS 4.5 , SATA-150-4

-T

[fresh boot] "dmesg" from Computer B (CentOS 4.5):

Linux version 2.6.9-55.0.2.ELsmp (mockbuild@builder4.centos.org) (gcc 
version 3.4.6 20060404 (Red Hat 3.4.6-8)) #1 SMP Tue Jun 26 14:30:58 EDT 
2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007ff60000 (usable)
  BIOS-e820: 000000007ff60000 - 000000007ff69000 (ACPI data)
  BIOS-e820: 000000007ff69000 - 000000007ff80000 (ACPI NVS)
  BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f59c0
Using x86 segment limits to approximate NX protection
On node 0 totalpages: 524128
   DMA zone: 4096 pages, LIFO batch:1
   Normal zone: 225280 pages, LIFO batch:16
   HighMem zone: 294752 pages, LIFO batch:16
DMI present.
Using APIC driver default
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f5990
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x7ff63c30
ACPI: FADT (v001 INTEL  TUMWATER 0x06040000 PTL  0x00000003) @ 0x7ff68e64
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0x7ff68ed8
ACPI: MCFG (v001 PTLTD    MCFG   0x06040000  LTP 0x00000000) @ 0x7ff68f4c
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x7ff68f88
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @ 0x7ff68fb0
ACPI: SSDT (v001  PmRef    CpuPm 0x00003000 INTL 0x20050228) @ 0x7ff63c6c
ACPI: DSDT (v001  Intel BLAKFORD 0x06040000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Enabling APIC mode:  Flat.  Using 0 I/O APICs
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Built 1 zonelists
Kernel command line: ro root=LABEL=/ quiet vga=785
mapped APIC to ffffd000 (fee00000)
Initializing CPU#0
CPU 0 irqstacks, hard=c03f1000 soft=c03d1000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 2000.691 MHz processor.
Using pmtmr for high-res timesource
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2072764k/2096512k available (1883k kernel code, 22760k reserved, 
761k data, 188k init, 1179008k highmem)
Calibrating delay using timer specific routine.. 4003.10 BogoMIPS 
(lpj=2001553)
Security Scaffold v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
There is already a security framework initialized, register_security failed.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000
CPU: After vendor identify, caps:  bfebfbff 20000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU0: Physical Processor ID: 0
CPU0: Processor Core ID: 0
CPU0: Initial APIC ID: 0
CPU: After all inits, caps:        bfebf3ff 20000000 00000000 00000140
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
per-CPU timeslice cutoff: 11701.39 usecs.
task migration cache decay timeout: 11 msecs.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c03f2000 soft=c03d2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3999.57 BogoMIPS 
(lpj=1999789)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000
CPU: After vendor identify, caps:  bfebfbff 20000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU1: Physical Processor ID: 0
CPU1: Processor Core ID: 1
CPU1: Initial APIC ID: 1
CPU: After all inits, caps:        bfebf3ff 20000000 00000000 00000140
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Xeon(R) CPU            5130  @ 2.00GHz stepping 06
Total of 2 processors activated (8002.68 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
zapping low mappings.
checking if image is initramfs... it is
Freeing initrd memory: 782k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd777, last bus=7
PCI: Using MMCONFIG
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040816
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.2
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMF3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 14 15) *9
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
ACPI: PCI Interrupt 0000:00:00.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 177
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 17 (level, low) -> IRQ 177
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 185
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 17 (level, low) -> IRQ 177
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 185
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 185
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:04:00.1[B] -> GSI 19 (level, low) -> IRQ 185
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 24 (level, low) -> IRQ 201
ACPI: PCI Interrupt 0000:07:01.0[A] -> GSI 18 (level, low) -> IRQ 193
ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:07:04.0[A] -> GSI 17 (level, low) -> IRQ 177
Simple Boot Flag at 0x38 set to 0x80
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1193770670.497:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key F6D125003A6A5D77
- User ID: CentOS (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, size 1200k
vesafb: mode is 640x480x16, linelength=1280, pages=24
vesafb: protected mode interface info at c000:53f0
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 80x30
fb0: VESA VGA frame buffer device
ACPI: Processor [CPU0] (supports C1, 8 throttling states)
ACPI: Processor [CPU1] (supports C1, 8 throttling states)
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 68 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
divert: not allocating divert_blk for non-ethernet device lo
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
Probing IDE interface ide2...
Probing IDE interface ide3...
Probing IDE interface ide4...
Probing IDE interface ide5...
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
input: ImPS/2 Generic Wheel Mouse on isa0060/serio1
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 262144 (order: 9, 3145728 bytes)
TCP: Hash tables configured (established 262144 bind 262144)
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI wakeup devices:
BPD0 BPD2 BMF3 PEX0 USB1 USB2 USB3 USB4 EUSB PCIB KBC0 MSE0 COM1 COM2
ACPI: (supports S0 S1 S4 S5)
Freeing unused kernel memory: 188k freed
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:07:04.0[A] -> GSI 17 (level, low) -> IRQ 177
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
         <Adaptec 19160B Ultra160 SCSI adapter>
         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
         <Adaptec 19160B Ultra160 SCSI adapter>
         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi1:A:11): 160.000MB/s transfers (80.000MHz DT, offset 126, 16bit)
   Vendor: EXABYTE   Model: VXA-3             Rev: 310E
   Type:   Sequential-Access                  ANSI SCSI revision: 03
megaraid cmm: 2.20.2.6rh (Release Date: Tue Jan 16 12:35:06 PST 2007)
megaraid: 2.20.4.6-rh2 (Release Date: Wed Jun 28 12:27:22 EST 2006)
megaraid: probe new device 0x1000:0x1960:0x1000:0x4523: bus 5:slot 1:func 0
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 24 (level, low) -> IRQ 201
megaraid: fw version:[713R] bios version:[G121]
scsi2 : LSI Logic MegaRAID driver
scsi[2]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[2]: scanning scsi channel 1 [virtual] for logical drives
   Vendor: MegaRAID  Model: LD 0 RAID1  286G  Rev: 713R
   Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 586104832 512-byte hdwr sectors (300086 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 586104832 512-byte hdwr sectors (300086 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
  sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi2, channel 1, id 0, lun 0
libata version 2.00 loaded.
ata_piix 0000:00:1f.2: version 2.00ac7
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 185
ata: 0x1F0 IDE port busy
ata: conflict with ide0
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: DUMMY
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1898 irq 15
scsi3 : ata_piix
scsi4 : ata_piix
ATA: abnormal status 0x7F on port 0x177
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
security:  3 users, 4 roles, 355 types, 26 bools
security:  55 classes, 22610 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), not configured for labeling
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses 
genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
st: Version 20040403, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi1, channel 0, id 11, lun 0
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA 
1048575
Attached scsi generic sg0 at scsi1, channel 0, id 11, lun 0,  type 1
Attached scsi generic sg1 at scsi2, channel 1, id 0, lun 0,  type 0
st0: Block limits 4 - 245760 bytes.
inserting floppy driver for 2.6.9-55.0.2.ELsmp
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Intel(R) PRO/1000 Network Driver - version 7.2.7-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 193
PCI: Setting latency timer of device 0000:04:00.0 to 64
e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:30:48:88:a3:24
divert: allocating divert_blk for eth0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:00.1[B] -> GSI 19 (level, low) -> IRQ 185
PCI: Setting latency timer of device 0000:04:00.1 to 64
e1000: 0000:04:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:30:48:88:a3:25
divert: allocating divert_blk for eth1
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
hw_random: RNG not detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 17 (level, low) -> IRQ 177
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: irq 177, pci mem f887e400
SELinux: initialized (dev usbdevfs, type usbdevfs), uses genfs_contexts
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: USB 2.0 enabled, EHCI 1.00, driver 2004-May-10
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v2.2
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 17 (level, low) -> IRQ 177
uhci_hcd 0000:00:1d.0: UHCI Host Controller
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: irq 177, io base 00001800
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 185
uhci_hcd 0000:00:1d.1: UHCI Host Controller
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: irq 185, io base 00001820
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 193
uhci_hcd 0000:00:1d.2: UHCI Host Controller
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: irq 193, io base 00001840
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 169
uhci_hcd 0000:00:1d.3: UHCI Host Controller
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: irq 169, io base 00001860
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
usb 1-5: new high speed USB device using address 2
Initializing USB Mass Storage driver...
scsi5 : SCSI emulation for USB Mass Storage devices
   Vendor: VBTM      Model: Store 'n' Go Pro  Rev: 5.02
   Type:   Direct-Access                      ANSI SCSI revision: 02
sdb: Unit Not Ready, sense:
Current : sense key Unit Attention
Additional sense: Not ready to ready change, medium may have changed
SCSI device sdb: 2052607 512-byte hdwr sectors (1051 MB)
sdb: Write Protect is off
sdb: Mode Sense: 45 00 00 08
sdb: assuming drive cache: write through
SCSI device sdb: 2052607 512-byte hdwr sectors (1051 MB)
sdb: Write Protect is off
sdb: Mode Sense: 45 00 00 08
sdb: assuming drive cache: write through
  sdb: sdb1
Attached scsi removable disk sdb at scsi5, channel 0, id 0, lun 0
Attached scsi generic sg2 at scsi5, channel 0, id 0, lun 0,  type 0
USB Mass Storage device found at 2
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
ACPI: Power Button (FF) [PWRF]
EXT3 FS on sda1, internal journal
device-mapper: 4.5.5-ioctl (2006-12-01) initialised: dm-devel@redhat.com
device-mapper: dm-multipath version 1.0.5 loaded
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda2, type ext3), uses xattr
SELinux: initialized (dev sda3, type vfat), uses genfs_contexts
Adding 4096564k swap on /dev/sda4.  Priority:-1 extents:1
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses 
genfs_contexts
IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
microcode: No new microdata for cpu 1
microcode: No new microdata for cpu 0
IA-32 Microcode Update Driver v1.14 unregistered
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
ip_tables: (C) 2000-2002 Netfilter core team
ip_conntrack version 2.1 (8192 buckets, 65536 max) - 340 bytes per conntrack
MSI INIT SUCCESS
e1000: eth0: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
e1000: eth0: e1000_watchdog_task: 10/100 speed: disabling TSO
e1000: eth1: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
e1000: eth1: e1000_watchdog_task: 10/100 speed: disabling TSO
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
i2c /dev entries driver
hypervisor: module license 'unspecified' taints kernel.
[ 3939] Device /dev/hypervisor registered with 10.62
[ 3939] parallels Hypervisor 2.2-2112 initialized.
vm_main: no version for "appIncCounter" found: kernel tainted.
[ 3970] Device /dev/vm-main registered with 10.61
[ 3970] Parallels Workstation 2.2-2112 Main module initialized.
divert: allocating divert_blk for vnic0
device vnic0 entered promiscuous mode
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
lp0: using parport0 (polling).
lp0: console ready
NET: Registered protocol family 10
Disabled Privacy Extensions on device c0346240(lo)
IPv6 over IPv4 tunneling driver
divert: not allocating divert_blk for non-ethernet device sit0
eth0: no IPv6 routers present
vnic0: no IPv6 routers present
eth1: no IPv6 routers present
mtrr: 0xd0000000,0x1000000 overlaps existing 0xd0000000,0x100000
device eth0 entered promiscuous mode
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0



