From: Graham Knap <graham.knap@rogers.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 20 Nov 2005 21:21:58 -0500 (EST)
Message-ID: <20051121022158.82709.qmail@web88012.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-925707055-1132539718=:82705"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web88012.mail.re2.yahoo.com ([206.190.37.231]:56999 "HELO
	web88012.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S932184AbVKUCV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 21:21:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Horms <horms@debian.org>, James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, 338089@bugs.debian.org
Cc: linux-scsi@vger.kernel.org

--0-925707055-1132539718=:82705
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Hi guys,

This week I recreated the Debian kernel per Horms' instructions. I then
applied James' source patch, and recompiled.

> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -816,8 +816,10 @@ spi_dv_device_internal(struct scsi_devic
>  	 * do the SPI pattern write tests */
>  
>  	len = 0;
> +#if 0
>  	if (scsi_device_dt(sdev))
>  		len = spi_dv_device_get_echo_buffer(sdev, buffer);
> +#endif
>  
>   retry:

Sure enough, the kernel now boots. I'll attach the "dmesg" output here.

Do you guys have a "final" patch in mind?

Let me know if there are other tests you'd like me to run. Now that I
know how to do this, I should be able to turn around test results
fairly quickly.

-- graham
--0-925707055-1132539718=:82705
Content-Type: text/plain; name="bootlog-2.6.14-p.txt"
Content-Description: 849303854-bootlog-2.6.14-p.txt
Content-Disposition: inline; filename="bootlog-2.6.14-p.txt"

Linux version 2.6.14-p () (root@testbox) (gcc version 4.0.3 20051111 (prerelease) (Debian 4.0.2-4)) #1 Fri Nov 18 22:01:49 EST 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000017ffd000 (usable)
 BIOS-e820: 0000000017ffd000 - 0000000017fff000 (ACPI data)
 BIOS-e820: 0000000017fff000 - 0000000018000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
383MB LOWMEM available.
On node 0 totalpages: 98301
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 94205 pages, LIFO batch:31
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.0 present.
ACPI: RSDP (v000 ASUS                                  ) @ 0x000f7dd0
ACPI: RSDT (v001 ASUS   P2L-B    0x58582e31 ASUS 0x31303030) @ 0x17ffd000
ACPI: FADT (v001 ASUS   P2L-B    0x58582e31 ASUS 0x31303030) @ 0x17ffd080
ACPI: BOOT (v001 ASUS   P2L-B    0x58582e31 ASUS 0x31303030) @ 0x17ffd040
ACPI: DSDT (v001   ASUS P2L-B    0x00001000 MSFT 0x01000001) @ 0x00000000
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 20000000 (gap: 18000000:e7ff0000)
Built 1 zonelists
Kernel command line: root=/dev/sda3 ro
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01302000)
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 32768 bytes)
Detected 501.146 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 385200k/393204k available (1803k kernel code, 7400k reserved, 512k data, 180k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1002.80 BogoMIPS (lpj=501404)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 128K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
mtrr: v2.0 (20020519)
CPU: Intel Celeron (Mendocino) stepping 05
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
ACPI: setting ELCR to 0200 (from 0a00)
checking if image is initramfs... it is
softlockup thread 0 started up.
Freeing initrd memory: 1144k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf06d0, last bus=1
PCI: Using configuration type 1
ACPI: Subsystem revision 20050902
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region e400-e43f claimed by PIIX4 ACPI
PCI quirk: region e800-e81f claimed by PIIX4 SMB
PIIX4 devres B PIO at 0290-0297
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: ioport range 0xe400-0xe43f could not be reserved
pnp: 00:01: ioport range 0xe800-0xe80f has been reserved
pnp: 00:01: ioport range 0x294-0x297 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: d6000000-d7dfffff
  PREFETCH window: d7f00000-e3ffffff
Simple Boot Flag at 0x46 set to 0x1
audit: initializing netlink socket (disabled)
audit(1132520898.064:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
pnp: SB audio device quirk - increasing port range
isapnp: Card 'Creative SB16 PnP'
isapnp: 1 Plug & Play card detected total
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 4, 65536 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI Shortcut mode
ACPI wakeup devices: 
PCI0 UAR1 UAR2 PS2M USB0 
ACPI: (supports S0 S1 S4 S5)
Freeing unused kernel memory: 180k freed
input: AT Translated Set 2 keyboard on isa0060/serio0
mice: PS/2 mouse device common for all mice
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2940 Ultra SCSI adapter>
        aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs

  Vendor: IBM       Model: DDYS-T09170N      Rev: S80D
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 8
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous.
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
 target0:0:0: Ending Domain Validation
SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 >
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda3: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 199559
EXT3-fs: sda3: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 1
Adding 257004k swap on /dev/sda1.  Priority:-1 extents:1 across:257004k
EXT3 FS on sda3, internal journal
Real Time Clock Driver v1.12
Generic RTC Driver v1.07
md: md driver 0.90.2 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 3.39
Linux agpgart interface v0.101 (c) Dave Jones
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905C Tornado at 0xb800. Vers LK1.1.19
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
usbcore: registered new driver usbfs
usbcore: registered new driver hub
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 9, io base 0x0000d400
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
agpgart: Detected an Intel 440LX Chipset.
agpgart: AGP aperture is 64M @ 0xe4000000
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
piix4_smbus 0000:00:04.3: Found 0000:00:04.3 device
input: PC Speaker
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
input: ImExPS/2 Logitech Wheel Mouse on isa0060/serio1
ts: Compaq touchscreen protocol output
pnp: Device 01:01.03 activated.
gameport: NS558 PnP Gameport is pnp01:01.03/gameport0, io 0x200, speed 784kHz
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
NET: Registered protocol family 17
NET: Registered protocol family 10
Disabled Privacy Extensions on device c03148a0(lo)
IPv6 over IPv4 tunneling driver
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
NVRM: loading NVIDIA Linux x86 NVIDIA Kernel Module  1.0-7174  Tue Mar 22 06:44:39 PST 2005
agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 2x mode
agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 2x mode
eth0: no IPv6 routers present

--0-925707055-1132539718=:82705--
