From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Fri, 2 May 2003 09:55:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030502095536.76dba4dd.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<3EB22F09.7060906@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Fri__2_May_2003_09:55:36_-0700_092cdcb8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:26266 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263012AbTEBQpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2003 12:45:43 -0400
In-Reply-To: <3EB22F09.7060906@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

This is a multi-part message in MIME format.

--Multipart_Fri__2_May_2003_09:55:36_-0700_092cdcb8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 02 May 2003 18:40:41 +1000 Douglas Gilbert <dougg@torque.net> wrote:

| Douglas Gilbert wrote:
| > <snip/>
| >   - instrument driver with 2 parameters (as examples)
| >       - ide-scsi.debug + ide-scsi.suppress_reset
| >         [kernel load time]
| >       - debug + suppress_reset [module load time]
| >       - debug + suppress_reset [sysfs: read/write
| >         in /sys/bus/ide/drivers/ide-scsi directory]
| >   - downgrade (simple) tag queuing to no tag queuing
| >     [set some other things to more conservative values]
| >   - add scsi_host::release() method
| >   - make provision for 16 byte SCSI commands
| >   - cleanup printk()s
|  > <snip/>
| 
| As Randy has found the setting of kernel boot time parameters
| doesn't work. The problem seems to be that the ide subsystem
| asserts ownership over all parameters that start with "ide".
| I was unable to bend moduleparam.h to accept a leading underscore
| so I went back to the old "__setup" method: the kernel boot time
| parameters are now:
|    - _ide_scsi_debug + _ide_scsi_suppress_reset

I'll confirm that those work.  I.e., I saw values 3 and 1 in
/sys/bus/ide/drivers/ide-scsi/*.

| Module load time and sysfs parameters remain the same.
| 
| A new patch against lk 2.5.68 is attached.

Used that patch instead of v1 of it.  Got an oops in ide-scsi.

Message log attached.

--
~Randy

--Multipart_Fri__2_May_2003_09:55:36_-0700_092cdcb8
Content-Type: text/plain;
 name="capture-isc-oops.txt"
Content-Disposition: attachment;
 filename="capture-isc-oops.txt"
Content-Transfer-Encoding: 7bit

Restarting system.
Linux version 2.5.68 (rddunlap@gargoyle.pdx.osdl.net) (gcc version 3.2 (Mandrake Linux 9.0 3.2-1mdk)) #8 SMP Fri May 2 09:15:05 PDT 2003
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
Kernel command line: auto BOOT_IMAGE=lin2568isc ro root=304 devfs=nomount hdd=ide-scsi _ide_scsi_debug=3 _ide_scsi_suppress_reset=1 console=tty0 console=ttyS0,38400n8 debug
ide_setup: hdd=ide-scsi
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 1685.214 MHz processor.
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
per-CPU timeslice cutoff: 731.20 usecs.
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
..... CPU clock speed is 1684.0989 MHz.
..... host bus clock speed is 99.0116 MHz.
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
Linux Plug and Play Support v0.96 (c) Adam Belay
block request queues:
 128 requests per read queue
 128 requests per write queue
 8 requests per batch
 enter congestion at 15
 exit congestion at 17
SCSI subsystem initialized
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
Non-volatile memory driver v1.2
i810 TCO timer init: failed to reset NO_REBOOT flag, reboot disabled by hardware
Software Watchdog Timer: 0.06, soft_margin: 60 sec, nowayout: 0
Serial: 8250/16550 driver $Revision: 1.90 $ IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
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
ide-scsi: hdd: que 32, cmd = [ 12 0 0 0 24 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 36 bytes transferred
ide-scsi: hdd: suc 32, rst = [ 5 80 2 32 5b 0 0 0 53 4f 4e 59 20 20 20 20 ]
ide-scsi: hdd: que 33, cmd = [ 12 0 0 0 60 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 96 bytes transferred
ide-scsi: hdd: suc 33, rst = [ 5 80 2 32 5b 0 0 0 53 4f 4e 59 20 20 20 20 ]
  Vendor: SONY      Model: CD-RW  CRX140E    Rev: 1.0n
  Type:   CD-ROM                             ANSI SCSI revision: 02
SCSI device sda: 71687340 512-byte hdwr sectors (36704 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
ide-scsi: hdd: que 39, cmd = [ 1a 0 2a 0 80 0 ]
ide-scsi: hdd: que 39, tsl = [ 5a 0 2a 0 0 0 0 0 84 0 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 39, rst = [ 20 70 0 0 2a 18 7 7 71 63 29 23 16 d 1 0 ]
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Attached scsi CD-ROM sr0 at scsi2, channel 0, id 0, lun 0
mice: PS/2 mouse device common for all mice
input: PC Speaker
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
i2c /dev entries driver module version 2.7.0 (20021208)
i2c-i801 version 2.7.0 (20021208)
i2c-piix4 version 2.7.0 (20021208)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 144k freed

Setting clock  (utc): Fri May  2 09:26:52 PDT 2003 [  OK  ]
Setting hostname gargoyle.pdx.osdl.net:  [  OK  ]
Checking root filesystem
/dev/hda4: clean, 225983/3637248 files, 946621/7263388 blocks
[  OK  ]
Checking filesystems
/dev/hda1: clean, 226/126976 files, 245301/506016 blocks
/dev/hda3: clean, 15623/652800 files, 834432/1305281 blocks
[  OK  ]

INIT: Entering runlevel: 3
Entering non-interactive startup

SysRq : Changing Loglevel
Loglevel set to 7
SysRq : Changing Loglevel
Loglevel set to 7
SysRq : Changing Loglevel
Loglevel set to 9
ide-scsi: hdd: que 43, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 43
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 43, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 44, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 44
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 44, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 45, cmd = [ 12 0 0 0 24 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 36 bytes transferred
ide-scsi: hdd: suc 45, rst = [ 5 80 0 31 5b 0 0 0 53 4f 4e 59 20 20 20 20 ]
ide-scsi: hdd: que 46, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 46
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 46, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 47, cmd = [ 5a 0 3f 0 0 0 0 0 8 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 8 bytes transferred
ide-scsi: hdd: suc 47, rst = [ 0 96 70 0 0 0 0 0 ]
ide-scsi: hdd: que 48, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 48
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 48, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 49, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 2 bytes transferred
ide-scsi: hdd: suc 49, rst = [ 0 20 ]
ide-scsi: hdd: que 50, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 50
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 50, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 51, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 51, rst = [ 0 20 70 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 52, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 52
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 52, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
ide-scsi: hdd: que 53, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 53, rst = [ 0 20 70 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 54, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 54
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 54, rst = [ 70 0 2 0 0 0 0 12 0 0 0 0 3a 0 0 0 ]
Mandrake Linux release 9.0 (dolphin) for i586
Kernel 2.5.68 on a Dual-processor i686 / l

gargoyle.pdx.osdl.net login: ide-scsi: hdd: que 55, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: check condition for 55
ide-scsi: hdd: queue cmd = [ 3 0 0 0 40 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 26 bytes transferred
ide-scsi: hdd: wrap up check 55, rst = [ 70 0 6 0 0 0 0 12 0 0 0 0 28 0 0 0 ]
ide-scsi: hdd: que 56, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 56
ide-scsi: hdd: que 57, cmd = [ 12 0 0 0 24 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 36 bytes transferred
ide-scsi: hdd: suc 57, rst = [ 5 80 0 31 5b 0 0 0 53 4f 4e 59 20 20 20 20 ]
ide-scsi: hdd: que 58, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 58
ide-scsi: hdd: que 59, cmd = [ 5a 0 3f 0 0 0 0 0 8 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 8 bytes transferred
ide-scsi: hdd: suc 59, rst = [ 0 96 11 0 0 0 0 0 ]
ide-scsi: hdd: que 60, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 60
ide-scsi: hdd: que 61, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 2 bytes transferred
ide-scsi: hdd: suc 61, rst = [ 0 20 ]
ide-scsi: hdd: que 62, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 62
ide-scsi: hdd: que 63, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 63, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 64, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 64
ide-scsi: hdd: que 65, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 65, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 66, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 66
ide-scsi: hdd: que 67, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 67
ide-scsi: hdd: que 68, cmd = [ 5a 0 3f 0 0 0 0 0 8 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 8 bytes transferred
ide-scsi: hdd: suc 68, rst = [ 0 96 11 0 0 0 0 0 ]
ide-scsi: hdd: que 69, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 69
ide-scsi: hdd: que 70, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 2 bytes transferred
ide-scsi: hdd: suc 70, rst = [ 0 20 ]
ide-scsi: hdd: que 71, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 71
ide-scsi: hdd: que 72, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 72, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 73, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 73
ide-scsi: hdd: que 74, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 74, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 75, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 75
ide-scsi: hdd: que 76, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 76
ide-scsi: hdd: que 77, cmd = [ 5a 0 3f 0 0 0 0 0 8 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 8 bytes transferred
ide-scsi: hdd: suc 77, rst = [ 0 96 11 0 0 0 0 0 ]
ide-scsi: hdd: que 78, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 78
ide-scsi: hdd: que 79, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 2 bytes transferred
ide-scsi: hdd: suc 79, rst = [ 0 20 ]
ide-scsi: hdd: que 80, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 80
ide-scsi: hdd: que 81, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 81, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 82, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 82
ide-scsi: hdd: que 83, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 83, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 84, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 84
ide-scsi: hdd: que 85, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 2 bytes transferred
ide-scsi: hdd: suc 85, rst = [ 0 20 ]
ide-scsi: hdd: que 86, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 86
ide-scsi: hdd: que 87, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 87, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 88, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 88
ide-scsi: hdd: que 89, cmd = [ 5a 0 2a 0 0 0 0 0 22 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 34 bytes transferred
ide-scsi: hdd: suc 89, rst = [ 0 20 11 0 0 0 0 0 2a 18 7 7 71 63 29 23 ]
ide-scsi: hdd: que 90, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 90
ide-scsi: hdd: que 91, cmd = [ 5a 0 2a 0 0 0 0 0 2 0 ]

Mandrake Linux release 9.0 (dolphin) for i586
Kernel 2.5.68 on a Dual-processor i686 / l

gargoyle.pdx.osdl.net login: hdd: lost interrupt
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: hdd: DMA complete
ide-scsi: CoD != 0 in idescsi_pc_intr
hdd: DMA disabled
ide-scsi: abort ignored
ide-scsi: device reset ignored
ide-scsi: hdd: que 91, cmd = [ 0 0 0 0 0 0 ]
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
ide-scsi: hdd: I/O error for 91
ide-scsi: Reached idescsi_pc_intr interrupt handler
Packet command completed, 0 bytes transferred
ide-scsi: hdd: suc 1802201963
Unable to handle kernel paging request at virtual address 6b6b6b8b
 printing eip:
c02d8c52
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c02d8c52>]    Not tainted
EFLAGS: 00010286
EIP is at idescsi_end_request+0xee/0x2dc
eax: 6b6b6b6b   ebx: 00000001   ecx: 00000001   edx: c04332c0
esi: f72bf3c0   edi: c0521aa8   ebp: c04c5eb0   esp: c04c5e80
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c04c4000 task=c0430580)
Stack: c03d92ab c0521aa8 6b6b6b6b c04332c0 f72bf3c0 f7d5729c f7dd3cc0 00000031 
       f70b007b 00000000 f72bf3c0 c0521aa8 c04c5eec c02d8ef2 c0521aa8 00000001 
       00000000 f70b6044 0000001d 00000086 c0293df4 00000000 f7d5729c f7dd3cc0 
Call Trace:
 [<c02d8ef2>] idescsi_pc_intr+0xb2/0x320
 [<c0293df4>] ide_timer_expiry+0x1bc/0x2b8
 [<c029410a>] ide_intr+0x16e/0x27a
 [<c02d8e40>] idescsi_pc_intr+0x0/0x320
 [<c0293c38>] ide_timer_expiry+0x0/0x2b8
 [<c010b508>] handle_IRQ_event+0x3c/0xfe
 [<c010b889>] do_IRQ+0x101/0x1d6
 [<c011a8a2>] schedule+0x21a/0x560
 [<c010710e>] default_idle+0x0/0x2e
 [<c0109f88>] common_interrupt+0x18/0x20
 [<c010710e>] default_idle+0x0/0x2e
 [<c011007b>] get_cmos_time+0x215/0x23c
 [<c0107138>] default_idle+0x2a/0x2e
 [<c01071b1>] cpu_idle+0x3b/0x44
 [<c0105000>] rest_init+0x0/0x7c
 [<c04c6843>] start_kernel+0x193/0x19a
 [<c04c6422>] unknown_bootoption+0x0/0xf6

Code: 8b 78 20 9c 8f 45 e0 fa 8b 5f 34 81 7b 04 ad 4e ad de 74 1c 
 <0>Kernel panic: Fatal exception in interrupt
In interrupt handler - not syncing

--Multipart_Fri__2_May_2003_09:55:36_-0700_092cdcb8--
