From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: [PATCH] fix command retries in spi_transport class
Date: Mon, 02 May 2005 21:04:23 -0500
Message-ID: <4276DC27.9030403@cybsft.com>
References: <1114991896.4788.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020308050102080408000208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay00.pair.com ([209.68.1.20]:26637 "HELO relay.pair.com")
	by vger.kernel.org with SMTP id S261296AbVECCE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2005 22:04:27 -0400
In-Reply-To: <1114991896.4788.44.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020308050102080408000208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> This will likely fix the adaptec domain validation problem.  However,
> it's not a true fix if the mid-layer is losing commands, it just makes
> it far less likely to get into that situation.
> 
> The premise is that domain validation is likely to trigger errors which
> it wants to know about, so the only time it should be retrying them is
> when it gets a unit attention (likely as the result of a previous bus or
> device reset).  Ironically, the previous coding retried three times in
> all cases except those of unit attention.  The attached fixes this to do
> the right thing.
> 
> James
> 

James,

I captured the attached boot log with the scsi transport patch you sent 
me. Changes a little but still hangs.


-- 
    kr

--------------020308050102080408000208
Content-Type: text/plain;
 name="minicom6.cap"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="minicom6.cap"

Linux version 2.6.12-rc3 (kr@porky.cybersoft.int) (gcc version 3.4.3 20050227 (Red Hat 3.4.3-22.fc3)) #8 SMP Mon May 2 09:22:59 CDT 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ff9e000 (usable)
 BIOS-e820: 000000001ff9e000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
511MB LOWMEM available.
found SMP MP-table at 000fe710
DMI 2.3 present.
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: WS 620       APIC at: 0xFEE00000
I/O APIC #2 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 20000000 (gap: 20000000:dec00000)
Built 1 zonelists
Kernel command line: ro root=LABEL=/ console=ttyS0,38400 console=tty0 nmi_watchdog=1 scsi_logging_level=0xffff
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 32768 bytes)
Detected 931.119 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 514224k/523896k available (2074k kernel code, 9116k reserved, 1124k data, 228k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel Pentium III (Coppermine) stepping 06
Booting processor 1/1 eip 2000
Initializing CPU#1
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Coppermine) stepping 06
Total of 2 processors activated (3698.68 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=0
testing NMI watchdog ... CPU#1: NMI appears to be stuck!
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
checking if image is initramfs... it is
Freeing initrd memory: 304k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfc03e, last bus=4
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2410] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:1f.2[D] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1f.3[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:04:04.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:04:05.0[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:04:05.1[B] -> IRQ 18
PCI->APIC IRQ transform: 0000:04:0a.0[A] -> IRQ 18
PCI: Failed to allocate mem resource #0:1000@0 for 0000:03:00.0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
nvidiafb: nVidia device/chipset 10DE0103
nvidiafb: nVidia Corporation NV10GL [Quadro]
nvidiafb: HW is currently programmed for CRT
nvidiafb: Using CRT on CRTC 0
nvidiafb: MTRR set to ON
nvidiafb: PCI nVidia NV10 framebuffer (64MB @ 0xE8000000)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH: IDE controller at PCI slot 0000:00:1f.1
ICH: chipset revision 2
ICH: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: SAMSUNG CD-R/RW SW-248F, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: Lite-On LTN483S 48x Max, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

  Vendor: QUANTUM   Model: ATLAS10K2-TY092L  Rev: DA40
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
 target0:0:0: Beginning Domain Validation
(scsi0:A:0): 6.600MB/s transfers (16bit)
(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
 target0:0:0: Ending Domain Validation
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

  Vendor: SEAGATE   Model: SX118273LC        Rev: 6679
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
(scsi1:A:0): 6.600MB/s transfers (16bit)
(scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x6a) SCSIRATE(0x80)
(scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x83) SCSIRATE(0x80)
(scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x83) SCSIRATE(0x80)
(scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x1a6) SCSIRATE(0x80)
(scsi1:A:0:0): parity error detected in Command phase. SEQADDR(0x1a6) SCSIRATE(0x80)
 target1:0:0: Wide Transfers Fail
(scsi1:A:0): 3.300MB/s transfers

--------------020308050102080408000208--
