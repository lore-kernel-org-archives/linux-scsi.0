From: Olaf Hering <olh@suse.de>
Subject: oops with rmmod ide-scsi
Date: Sun, 7 Nov 2004 20:48:15 +0100
Message-ID: <20041107194815.GA28687@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:25578 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261805AbUKHJKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 04:10:32 -0500
Received: from hermes.suse.de (hermes-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id ED08FFE7D58
	for <linux-scsi@vger.kernel.org>; Mon,  8 Nov 2004 10:06:48 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


rmmod ide-scsi tends to lock the box, or just oops.
My genius cd->use patch will fix this one as well.


NIP [cb0446e0] idescsi_queue+0x100/0x400 [ide_scsi]
LR [cb044694] idescsi_queue+0xb4/0x400 [ide_scsi]
Call trace:
 [cbb2bbcc] scsi_dispatch_cmd+0x1a8/0x2a4 [scsi_mod]
 [cbb316e8] scsi_request_fn+0x260/0x47c [scsi_mod]
 [c00f91e8] blk_insert_request+0xb8/0xe0
 [cbb319d0] scsi_insert_special_req+0x38/0x4c [scsi_mod]
 [cbb32094] scsi_wait_req+0x5c/0xac [scsi_mod]
 [cb04b5b4] sr_do_ioctl+0x70/0x240 [sr_mod]
 [cb04a9d8] sr_packet+0x28/0x68 [sr_mod]
 [cb06f8c4] cdrom_get_disc_info+0x60/0xc4 [cdrom]
 [cb070320] cdrom_mrw_exit+0x1c/0x104 [cdrom]
 [cb06e9fc] unregister_cdrom+0xd0/0x104 [cdrom]
 [cb04a1ac] sr_kref_release+0x54/0x80 [sr_mod]
 [c00adbc4] kref_put+0x60/0x70
 [cb04a930] sr_remove+0x50/0xd0 [sr_mod]
 [c00f0584] device_release_driver+0x98/0x9c
 [c00f077c] bus_remove_device+0xc0/0x12c

Total memory =3D 160MB; using 512kB for hash table (at c0300000)
Linux version 2.6.10-rc1-bk16-olh (olaf@ibook) (gcc-Version 3.3.3 (SuSE=
 Linux)) #2 Sun Nov 7 20:13:23 CET 2004
=46ound UniNorth memory controller & host bridge, revision: 3
Mapped at 0xfdfc0000
=46ound a Keylargo mac-io controller, rev: 2, mapped at 0xfdf40000
PowerMac motherboard: iBook (first generation)
=46ound UniNorth PCI host bridge at 0xf0000000. Firmware bus number: 0-=
>0
=46ound UniNorth PCI host bridge at 0xf2000000. Firmware bus number: 0-=
>0
=46ound UniNorth PCI host bridge at 0xf4000000. Firmware bus number: 0-=
>0
via-pmu: Server Mode is disabled
PMU driver 2 initialized for Core99, firmware: 0c
nvram: Checking bank 0...
nvram: gen0=3D468, gen1=3D467
nvram: Active bank is: 0
nvram: OF partition at 0x210
nvram: XP partition at 0xffffffff
nvram: NR partition at 0xffffffff
On node 0 totalpages: 40960
  DMA zone: 40960 pages, LIFO batch:10
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
Built 1 zonelists
Kernel command line: nfsroot=3D1.1.1.3:/nfsroot/mac ip=3Deth0 quiet ini=
t=3D/bin/bash --login
PowerMac using OpenPIC irq controller at 0x80040000
OpenPIC Version 1.2 (4 CPUs and 64 IRQ sources) at fc6ef000
OpenPIC timer frequency is 4.161221 MHz
PID hash table entries: 1024 (order: 10, 16384 bytes)
GMT Delta read from XPRAM: 0 minutes, DST: on
time_init: decrementer frequency =3D 16.644884 MHz
Console: colour dummy device 80x25
pmac_zilog: i2c-modem detected, id: 1
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 157432k available (1536k kernel code, 940k data, 140k init, 0k =
highmem)
AGP special page: 0xc9fff000
Calibrating delay loop... 595.96 BogoMIPS (lpj=3D297984)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
checking if image is initramfs... it is
=46reeing initrd memory: 1491k freed
NET: Registered protocol family 16
PCI: Probing PCI hardware
PCI: Cannot allocate resource region 0 of device 0001:10:19.0
Registering openpic with sysfs...
Thermal assist unit using timers, shrink_timer: 2000 jiffies
Initializing Cryptographic API
PCI: Enabling device 0000:00:10.0 (0086 -> 0087)
atyfb: using auxiliary register aperture
atyfb: 3D RAGE Mobility L (Mach64 LN, AGP 2x) [0x4c4e rev 0x64]
atyfb: 4M SDRAM (2:1) (32-bit), 14.31818 MHz XTAL, 230 MHz PLL, 70 Mhz =
MCLK, 53 MHz XCLK
Registered "ati" backlight controller, level: 15/15
atyfb: monitor sense=3D0, mode 20
atyfb: setting up CRTC
atyfb: set primary CRT to 800x600 PP composite N
atyfb: CRTC_H_TOTAL_DISP: 630083
atyfb: CRTC_H_SYNC_STRT_WID: 10006a
atyfb: CRTC_V_TOTAL_DISP: 2570273
atyfb: CRTC_V_SYNC_STRT_WID: 40258
atyfb: CRTC_OFF_PITCH: 19000000
atyfb: CRTC_VLINE_CRNT_VLINE: 0
atyfb: CRTC_GEN_CNTL: b000200
atyfb: atyfb_set_par
atyfb:  Set Visible Mode to 800x600-8
atyfb:  Virtual resolution 800x5222, pixclock_in_ps 25029 (calculated 2=
5029)
atyfb:  Dot clock:           39 MHz
atyfb:  Horizontal sync:     37 kHz
atyfb:  Vertical refresh:    58 Hz
atyfb:  x  style: 39.23869 800 856 984 1056   600 601 605 628
atyfb:  fb style: 25029  72 800 56 128 23 600 1 4
debug atyfb: Mach64 non-shadow register values:
debug atyfb: 0x2000:  00630083 0010006A 02570273 00040258
debug atyfb: 0x2010:  01C00000 19000000 08000020 0B002200
debug atyfb: 0x2020:  004A054C 00B0051D 00000000 00000000
debug atyfb: 0x2030:  00000000 02200213 00000000 00000001
debug atyfb: 0x2040:  00000000 00000000 00000000 00000000
debug atyfb: 0x2050:  00000000 00000000 00000000 00000000
debug atyfb: 0x2060:  241A1417 A3E24259 00000000 00000000
debug atyfb: 0x2070:  00000000 00000000 00000000 00000000
debug atyfb: 0x2080:  00000000 00000000 00000000 00000000
debug atyfb: 0x2090:  00803003 00000000 00000100 00000000
debug atyfb: 0x20A0:  7B33A050 00000014 0003FF80 64004CF1
debug atyfb: 0x20B0:  00165A27 00010000 00010000 00000000
debug atyfb: 0x20C0:  00FF2120 80010102 00000000 00000000
debug atyfb: 0x20D0:  00000100 007F0179 00000000 00002442
debug atyfb: 0x20E0:  64004C4E 00C0001E 00000000 00000000
debug atyfb: 0x20F0:  00000000 00002592 80000000 00000000

debug atyfb: Mach64 PLL register values:
debug atyfb: 0x00:  ADD51FE4 E50382A2 8E9EAD02 801B0000
debug atyfb: 0x10:  06CF4000 5097AC10 408024FD 00000002
debug atyfb: 0x20:  06AC06AC 1424FD00 00195500 00000000
debug atyfb: 0x30:  00000000 00000000 00000000 00000000

Console: switching to colour frame buffer device 100x37
atyfb: fb0: ATY Mach64 frame buffer device on PCI
Generic RTC Driver v1.07
Macintosh non-volatile memory driver v1.1
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
ttyS0 at MMIO 0x80013020 (irq =3D 22) is a Z85c30 ESCC - Internal modem
ttyS1 at MMIO 0x80013000 (irq =3D 50) is a Z85c30 ESCC - Serial port
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 123456K size 1024 blocksize
MacIO PCI driver attached to Keylargo chipset
input: Macintosh mouse button emulation
apm_emu: APM Emulation 0.5 initialized.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
adb: starting probe task...
adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
ADB keyboard at 2, handler 1
Detected ADB keyboard, type ISO, swapping keys.
input: ADB keyboard on adb2:2.c4/input
input: ADB Powerbook buttons on adb7:7.1f/input
ADB mouse at 3, handler set to 4 (trackpad)
input: ADB mouse on adb3:3.01/input
adb: finished probe task...
ide0: Found Apple KeyLargo ATA-4 controller, bus ID 2, irq 19
Probing IDE interface ide0...
hda: FUJITSU MHH2032AT, ATA DISK drive
hda: Enabling Ultra DMA 2
elevator: using anticipatory as default io scheduler
ide0 at 0xcb004000-0xcb004007,0xcb004160 on irq 19
ide1: Found Apple KeyLargo ATA-3 controller, bus ID 0, irq 20
Probing IDE interface ide1...
hdc: MATSHITA CR-175, ATAPI CD/DVD-ROM drive
hdc: Enabling MultiWord DMA 2
ide1 at 0xcb006000-0xcb006007,0xcb006160 on irq 20
ide2: Found Apple KeyLargo ATA-3 controller, bus ID 1, irq 21
Probing IDE interface ide2...
ide2: Bus empty, interface released.
hda: max request size: 128KiB
hda: 6357456 sectors (3255 MB) w/512KiB Cache, CHS=3D6307/16/63, UDMA(3=
3)
hda: cache flushes not supported
 hda: [mac] hda1 hda2 hda3 hda4 hda5 hda6 hda7 hda8 hda9 hda10 hda11
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 2
IP: routing cache hash table of 1024 buckets, 8Kbytes
TCP: Hash tables configured (established 16384 bind 32768)
=46reeing unused kernel memory: 140k init 4k chrp 8k prep
NET: Registered protocol family 1
NET: Registered protocol family 17
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0a:27:aa:0f:20=20
PHY ID: 406212, addr: 0
eth0: Found BCM5201 PHY
eth0: Link is up at 10 Mbps, half-duplex.
eth0: Pause is disabled
nfs: server 1.1.1.3 not responding, still trying
nfs: server 1.1.1.3 OK
SCSI subsystem initialized
ide-scsi is deprecated for cd burning! Use ide-cd and give dev=3D/dev/h=
dX as device
scsi0 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: MATSHITA  Model: CD-ROM CR-175     Rev: 5AAE
  Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
Oops: kernel access of bad area, sig: 11 [#1]
NIP: CB0446E0 LR: CB044694 SP: C0D47AD0 REGS: c0d47a20 TRAP: 0300    No=
t tainted
MSR: 00001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 00000244, DSISR: 40000000
TASK =3D c9cf9190[784] 'rmmod' THREAD: c0d46000Last syscall: 129=20
GPR00: FFFDA6B9 C0D47AD0 C9CF9190 C0CBF520 C053ED1D 00000002 C0CBF529 5=
1000000=20
GPR08: 00000000 00000000 00000001 00001388 22008488 1001A18C 00000000 1=
0000000=20
GPR16: 00000000 00000000 10000000 00000000 00000800 00000002 00000238 C=
053ED14=20
GPR24: CBB2B910 C9D33160 C0279788 C053ECC0 C0CBF520 00000000 C9D33160 C=
0CBF520=20
NIP [cb0446e0] idescsi_queue+0x100/0x400 [ide_scsi]
LR [cb044694] idescsi_queue+0xb4/0x400 [ide_scsi]
Call trace:
 [cbb2bbcc] scsi_dispatch_cmd+0x1a8/0x2a4 [scsi_mod]
 [cbb316e8] scsi_request_fn+0x260/0x47c [scsi_mod]
 [c00f91e8] blk_insert_request+0xb8/0xe0
 [cbb319d0] scsi_insert_special_req+0x38/0x4c [scsi_mod]
 [cbb32094] scsi_wait_req+0x5c/0xac [scsi_mod]
 [cb04b5b4] sr_do_ioctl+0x70/0x240 [sr_mod]
 [cb04a9d8] sr_packet+0x28/0x68 [sr_mod]
 [cb06f8c4] cdrom_get_disc_info+0x60/0xc4 [cdrom]
 [cb070320] cdrom_mrw_exit+0x1c/0x104 [cdrom]
 [cb06e9fc] unregister_cdrom+0xd0/0x104 [cdrom]
 [cb04a1ac] sr_kref_release+0x54/0x80 [sr_mod]
 [c00adbc4] kref_put+0x60/0x70
 [cb04a930] sr_remove+0x50/0xd0 [sr_mod]
 [c00f0584] device_release_driver+0x98/0x9c
 [c00f077c] bus_remove_device+0xc0/0x12c
Oops: kernel access of bad area, sig: 11 [#2]
NIP: CB0446E0 LR: CB044694 SP: C0D9BED0 REGS: c0d9be20 TRAP: 0300    No=
t tainted
MSR: 00001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 00000244, DSISR: 40000000
TASK =3D c9cf9870[761] 'scsi_eh_0' THREAD: c0d9a000Last syscall: -1=20
GPR00: FFFDBA42 C0D9BED0 C9CF9870 C0CBF460 C053ED19 00000002 C0CBF465 0=
0000000=20
GPR08: C02904BC 00000000 FFFFFFFF 00001388 C02904B4 1002A450 10020000 0=
0000000=20
GPR16: CBB50000 C0D9BF90 C01E3CAC 000000FC C01BE04C CBB4E704 00000238 C=
053ED14=20
GPR24: CBB2F07C C9D330A0 C0279788 C053ECC0 C0CBF460 00000000 C9D330A0 C=
0CBF460=20
NIP [cb0446e0] idescsi_queue+0x100/0x400 [ide_scsi]
LR [cb044694] idescsi_queue+0xb4/0x400 [ide_scsi]
Call trace:
 [cbb2f590] scsi_send_eh_cmnd+0xbc/0x284 [scsi_mod]
 [cbb2f7dc] scsi_eh_tur+0x84/0xf8 [scsi_mod]
 [cbb2fca8] scsi_error_handler+0x350/0xe68 [scsi_mod]
 [c0008cf4] kernel_thread+0x44/0x60

history:
    1  mount proc
    2  mount sysfs
    3  modprobe -v ide-scsi
    4  dmesg | tail
    5  l /sys/
    6  l /sys/block/
    7  modprobe sr_mod
    8  l /sys/block/
    9  l /sys/block/sr0/
   10  lsmod
   11  l /sys/block/sr0/
   12  l /sys/block/sr0/device/
   13  scsi_id -gs /block/sr0
   14  rmmod ide-scsi
   15  dmesg > fooo
   16  l fooo=20
   17  history=20
   18  history >> fooo=20
--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
