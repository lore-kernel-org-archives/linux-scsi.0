From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Thu, 1 May 2003 15:52:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030501155225.7df14e51.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Thu__1_May_2003_15:52:25_-0700_0938bcb0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:899 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262731AbTEAWm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2003 18:42:29 -0400
In-Reply-To: <3EB11AD3.2070503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

This is a multi-part message in MIME format.

--Multipart_Thu__1_May_2003_15:52:25_-0700_0938bcb0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 May 2003 23:02:11 +1000 Douglas Gilbert <dougg@torque.net> wrote:

| Alan Cox said last week that the ide-scsi driver was
| 500th on his list to fix for 2.6 . To help him, if
| he hasn't already fixed it, this patch includes:
| 
|    - instrument driver with 2 parameters (as examples)
|        - ide-scsi.debug + ide-scsi.suppress_reset
|          [kernel load time]
|        - debug + suppress_reset [module load time]
|        - debug + suppress_reset [sysfs: read/write
|          in /sys/bus/ide/drivers/ide-scsi directory]
|    - downgrade (simple) tag queuing to no tag queuing
|      [set some other things to more conservative values]
|    - add scsi_host::release() method
|    - make provision for 16 byte SCSI commands
|    - cleanup printk()s
| 
| Many people (on the linux kernel list) have reported problems
| with this driver and ATAPI burners. I only have an ATAPI
| reader and can't get it to fail. If someone has a repeatable
| failure perhaps they could set "debug=3" and send the relevant
| part of /var/log/messages to this list or me.

Hi Doug,

I have ATAPI CD-ROM as hdc and CD-RW as hdd.  I boot with
"hdd=icd-scsi ide-scsi.debug=3".  Is that right/OK so far?
If not, what should it be?

Anyway, it never gets thru the boot sequence (with or without this
patch).  It hangs with these last messages:

scsi2 : SCSI host adapter emulation for IDE ATAPI devices
ide-scsi: abort called for cmd serial #32
hdd: lost interrupt
ide-scsi: CoD != 0 in idescsi_pc_intr
hdd: DMA disabled
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }


I let it sit like this for > 5 minutes before rebooting.
Complete boot log is attached.

--
~Randy

--Multipart_Thu__1_May_2003_15:52:25_-0700_0938bcb0
Content-Type: text/plain;
 name="capture.txt"
Content-Disposition: attachment;
 filename="capture.txt"
Content-Transfer-Encoding: 7bit

Restarting system.
Linux version 2.5.68 (rddunlap@gargoyle.pdx.osdl.net) (gcc version 3.2 (Mandrake Linux 9.0 3.2-1mdk)) #6 SMP Thu May 1 15:00:41 PDT 2003
Video mode to be used for restore is f05
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f52a0
hm, page 000f5000 reserved twice.
hm, page 000f6000 reserved twice.
hm, page 000f1000 reserved twice.
hm, page 000f2000 reserved twice.
On node 0 totalpages: 262128
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 32752 pages, LIFO batch:7
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
Processor #0 15:1 APIC version 17
Processor #1 15:0 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
IBM machine detected. Enabling interrupts during APM calls.
IBM machine detected. Disabling SMBus accesses.
Building zonelist for node : 0
Kernel command line: auto BOOT_IMAGE=lin2568isc ro root=304 devfs=nomount hdd=ide-scsi ide-scsi.debug=3 console=tty0 console=ttyS0,38400n8 debug
ide_setup: hdd=ide-scsi
ide_setup: ide-scsi.debug=3 -- BAD OPTION
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 1685.990 MHz processor.
Console: colour VGA+ 80x30
Calibrating delay loop... 3317.76 BogoMIPS
Memory: 1032804k/1048512k available (2828k kernel code, 14804k reserved, 1024k data, 144k init, 131008k highmem)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
-> /dev
-> /dev/console
-> /root
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU:     After generic, caps: 3febfbff 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU#0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#0: Thermal monitoring enabled
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
CPU0: Intel(R) Xeon(TM) CPU 1.70GHz stepping 02
per-CPU timeslice cutoff: 731.64 usecs.
task migration cache decay timeout: 1 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/1 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 3358.72 BogoMIPS
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 256K
CPU: Hyper-Threading is disabled
CPU:     After generic, caps: 3febfbff 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU#1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 1700MHz stepping 0a
Total of 2 processors activated (6676.48 BogoMIPS).
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-5, 2-10, 2-11, 2-12, 2-18, 2-21, 2-23 not connected.
..TIMER: vector=0x31 pin1=2 pin2=0
number of MP IRQ sources: 20.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00178020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0020
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 001 01  0    0    0   0   0    1    1    39
 02 001 01  0    0    0   0   0    1    1    31
 03 001 01  0    0    0   0   0    1    1    41
 04 001 01  0    0    0   0   0    1    1    49
 05 000 00  1    0    0   0   0    0    0    00
 06 001 01  0    0    0   0   0    1    1    51
 07 001 01  0    0    0   0   0    1    1    59
 08 001 01  0    0    0   0   0    1    1    61
 09 001 01  0    0    0   0   0    1    1    69
 0a 000 00  1    0    0   0   0    0    0    00
 0b 000 00  1    0    0   0   0    0    0    00
 0c 000 00  1    0    0   0   0    0    0    00
 0d 001 01  0    0    0   0   0    1    1    71
 0e 001 01  0    0    0   0   0    1    1    79
 0f 001 01  0    0    0   0   0    1    1    81
 10 001 01  1    1    0   1   0    1    1    89
 11 001 01  1    1    0   1   0    1    1    91
 12 000 00  1    0    0   0   0    0    0    00
 13 001 01  1    1    0   1   0    1    1    99
 14 001 01  1    1    0   1   0    1    1    A1
 15 000 00  1    0    0   0   0    0    0    00
 16 001 01  1    1    0   1   0    1    1    A9
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ16 -> 0:16
IRQ17 -> 0:17
IRQ19 -> 0:19
IRQ20 -> 0:20
IRQ22 -> 0:22
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 1684.0875 MHz.
..... host bus clock speed is 99.0110 MHz.
checking TSC synchronization across 2 CPUs: passed.
Starting migration thread for cpu 0
Bringing up 1
CPU 1 IS NOW UP!
Starting migration thread for cpu 1
CPUS done 4
mtrr: v2.0 (20020519)
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
PCI: PCI BIOS revision 2.10 entry at 0xfb110, last bus=4
PCI: Using configuration type 1
BIO: pool of 256 setup, 14Kb (56 bytes/bio)
biovec pool[0]:   1 bvecs: 256 entries (12 bytes)
biovec pool[1]:   4 bvecs: 256 entries (48 bytes)
biovec pool[2]:  16 bvecs: 256 entries (192 bytes)
biovec pool[3]:  64 bvecs: 256 entries (768 bytes)
biovec pool[4]: 128 bvecs: 256 entries (1536 bytes)
biovec pool[5]: 256 bvecs: 256 entries (3072 bytes)
Linux Plug and Play Support v0.96 (c) Adam Belay
block request queues:
 128 requests per read queue
 128 requests per write queue
 8 requests per batch
 enter congestion at 15
 exit congestion at 17
SCSI subsystem initialized
drivers/usb/core/usb.c: registered new driver usbfs
drivers/usb/core/usb.c: registered new driver hub
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Transparent bridge - Intel Corp. 82801BA/CA/DB PCI Br
PCI: Using IRQ router PIIX [8086/2440] at 00:1f.0
PCI->APIC IRQ transform: (B0,I31,P3) -> 19
PCI->APIC IRQ transform: (B0,I31,P1) -> 17
PCI->APIC IRQ transform: (B0,I31,P1) -> 17
PCI->APIC IRQ transform: (B1,I0,P0) -> 22
PCI->APIC IRQ transform: (B3,I1,P0) -> 20
PCI->APIC IRQ transform: (B3,I1,P1) -> 20
PCI->APIC IRQ transform: (B4,I4,P0) -> 16
Initializing RT netlink socket
Starting balanced_irq
Enabling SEP on CPU 1
Enabling SEP on CPU 0
highmem bounce pool size: 64 pages
Journalled Block Device driver loaded
udf: registering filesystem
pty: 256 Unix98 ptys configured
request_module: failed /sbin/modprobe -- parport_lowlevel. error = -16
lp: driver loaded but no devices found
Non-volatile memory driver v1.2
i810 TCO timer init: failed to reset NO_REBOOT flag, reboot disabled by hardware
Software Watchdog Timer: 0.06, soft_margin: 60 sec, nowayout: 0
Linux agpgart interface v0.100 (c) Dave Jones
agpgart: Detected Intel i860 chipset
agpgart: Maximum main memory to use for agp memory: 941M
agpgart: AGP aperture is 64M @ 0xe8000000
Serial: 8250/16550 driver $Revision: 1.90 $ IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport0: PC-style at 0x378 (0x778) [PCSPP(,...)]
parport0: irq 7 detected
lp0: using parport0 (polling).
lp0: console ready
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: loaded (max 8 devices)
eepro100.c:v1.09j-t 9/29/99 Donald Becker http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
eth0: OEM i82557/i82558 10/100 Ethernet, 00:02:55:1A:35:D4, IRQ 16.
  Board assembly a32040-002, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x3258698e).
Linux video capture interface: v1.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH2: IDE controller at PCI slot 00:1f.1
ICH2: chipset revision 4
ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
hda: IC35L040AVER07-0, ATA DISK drive
hdb: IC35L020AVER07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: LTN486S, ATAPI CD/DVD-ROM drive
hdd: SONY CD-RW CRX140E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: host protected area => 1
hda: 78156288 sectors (40016 MB) w/1916KiB Cache, CHS=77536/16/63, UDMA(100)
 hda: hda1 hda2 hda3 hda4
hdb: host protected area => 1
hdb: 39876480 sectors (20417 MB) w/1916KiB Cache, CHS=39560/16/63, UDMA(100)
 hdb: hdb1
hdc: ATAPI 48X CD-ROM drive, 120kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.12
end_request: I/O error, dev hdc, sector 0
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.31
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
  Vendor: IBM       Model: IC35L036UWD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.31
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

scsi2 : SCSI host adapter emulation for IDE ATAPI devices
ide-scsi: abort called for cmd serial #32
hdd: lost interrupt
ide-scsi: CoD != 0 in idescsi_pc_intr
hdd: DMA disabled
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }

--Multipart_Thu__1_May_2003_15:52:25_-0700_0938bcb0--
