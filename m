From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 30 Nov 2007 14:42:50 -0800
Message-ID: <20071130144250.e89335f3.akpm@linux-foundation.org>
References: <20071126134819.8FE56DBA2@gherkin.frus.com>
	<47508EE9.9030304@orcon.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758194AbXK3Wn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 17:43:28 -0500
In-Reply-To: <47508EE9.9030304@orcon.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cree <mcree@orcon.net.nz>
Cc: rct@gherkin.frus.com, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

On Sat, 01 Dec 2007 11:30:01 +1300
Michael Cree <mcree@orcon.net.nz> wrote:

> Bob Tracy wrote:
> > Andrew Morton wrote:
> >> Could be something change in sysfs.  Please double-check the config
> >> options, make sure that something important didn't get disabled.
> >>
> >  Here's
> > hoping someone else is seeing this or can replicate it in the meantime.
> 
> Snap.
> 
> 2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is 
> populated no partitions of the scsi sub-system are seen.  Looks like ide 
> sub-system similarly affected.

Rafael, I assume you have this regression in the list?

> Managed to get boot log.  Follows below (with output of various /proc info).
> 
> Cheerz
> Michael.
> 
> 
> Linux version 2.6.24-rc3 (mjc@alpha) (gcc version 4.1.3 20071019 
> (prerelease) (Debian 4.1.2-17)) #1 Mon Nov 26 19:28:58 NZDT 2007
> Booting on Tsunami variation Monet using machine vector Monet from SRM
> Major Options: EV67 LEGACY_START VERBOSE_MCHECK
> Command line: ro root=/dev/sda3 console=ttyS0
> memcluster 0, usage 1, start        0, end      215
> memcluster 1, usage 0, start      215, end   131062
> memcluster 2, usage 1, start   131062, end   131072
> freeing pages 215:384
> freeing pages 930:131062
> reserving pages 930:932
> 4096K Bcache detected; load hit latency 21 cycles, load miss latency 127 
> cycles
> Console graphics on hose 0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130167
> Kernel command line: ro root=/dev/sda3 console=ttyS0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Using epoch = 2000
> Turning on RTC interrupts.
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
> Memory: 1030896k/1048496k available (2786k kernel code, 15216k reserved, 
> 370k data, 168k init)
> Mount-cache hash table entries: 512
> net_namespace: 120 bytes
> NET: Registered protocol family 16
> PCI: Bridge: 0001:01:08.0
>    IO window: 8000-8fff
>    MEM window: 09000000-090fffff
>    PREFETCH window: disabled.
> SMC37c669 Super I/O Controller found @ 0x3f0
> Linux Plug and Play Support v0.97 (c) Adam Belay
> SCSI subsystem initialized
> NET: Registered protocol family 2
> IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
> TCP established hash table entries: 32768 (order: 6, 524288 bytes)
> TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
> TCP: Hash tables configured (established 32768 bind 32768)
> TCP reno registered
> srm_env: version 0.0.6 loaded successfully
> io scheduler noop registered
> io scheduler cfq registered (default)
> tridentfb: Trident framebuffer 0.7.8-NEWAPI initializing
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> rtc: SRM (post-2000) epoch (2000) detected
> Real Time Clock Driver v1.12ac
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> Floppy drive(s): fd0 is 2.88M
> FDC 0 is a post-1991 82077
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> CY82C693: IDE controller (0x1080:0xc693 rev 0x00) at  PCI slot 0000:00:07.1
> CY82C693: not 100% native mode: will probe irqs later
> CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)
>      ide0: BM-DMA at 0x8400-0x8407, BIOS settings: hda:pio, hdb:pio
> CY82C693: port 0x01f0 already claimed by ide0
> ALI15X3: IDE controller (0x10b9:0x5228 rev 0xc6) at  PCI slot 0001:02:09.1
> ALI15X3: 100% native mode on irq 28
>      ide1: BM-DMA at 0x200008410-0x200008417, BIOS settings: hdc:DMA, 
> hdd:DMA
>      ide2: BM-DMA at 0x200008418-0x20000841f, BIOS settings: hde:pio, 
> hdf:pio
> hdf: LITE-ON DVDRW SOHW-1653S, ATAPI CD/DVD-ROM drive
> hde: ST3200822A, ATA DISK drive
> ide2 at 0x200008438-0x20000843f,0x20000844e on irq 28
> hde: max request size: 512KiB
> hde: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, 
> UDMA(100)
> hde: cache flushes supported
>   hde: hde1
> qla1280: QLA1040 found on PCI bus 1, dev 6
> scsi(0:0): Resetting SCSI BUS
> scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
>         Firmware version:  7.65.06, Driver version 3.26
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> scsi 0:0:1:0: Direct-Access     SEAGATE  ST336706LW       0109 PQ: 0 ANSI: 3
> scsi(0:0:1:0): Sync: period 10, offset 12, Wide
> input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> atkbd.c: keyboard reset failed on isa0060/serio1
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> scsi: waiting for bus probes to complete ...
> sd 0:0:1:0: [sda] 71687370 512-byte hardware sectors (36704 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:1:0: [sda] 71687370 512-byte hardware sectors (36704 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
>   sda: sda1 sda2 sda3 sda4 sda5
> sd 0:0:1:0: [sda] Attached SCSI disk
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 168k freed
> Mount failed for selinuxfs on /selinux:  No such file or directory
>   INIT: version 2.86 booting
> Starting the hotplug events dispatcher: udevd.
> Synthesizing the initial hotplug events...done.
> Waiting for /dev to be fully populated...scsi_id[321]: scsi_id: unable 
> to access '/block'
> end_request: I/O error, dev fd0, sector 0
> scsi_id[371]: scsi_id: unable to access '/block'
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> Linux Tulip driver version 1.1.15 (Feb 27, 2007)
> tulip0:  EEPROM default media type Autosense.
> tulip0:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY 
> (2) block.
> tulip0:  Index #1 - Media 10base2 (#1) described by a 21142 Serial PHY 
> (2) block.
> tulip0:  Index #2 - Media AUI (#2) described by a 21142 Serial PHY (2) 
> block.
> tulip0:  Index #3 - Media 10baseT-FDX (#4) described by a 21142 Serial 
> PHY (2) block.
> tulip0:  Index #4 - Media 100baseTx (#3) described by a 21143 SYM PHY 
> (4) block.
> tulip0:  Index #5 - Media 100baseTx-FDX (#5) described by a 21143 SYM 
> PHY (4) block.
> eth0: Digital DS21142/43 Tulip rev 65 at Port 0x200009400, 
> 08:00:2b:87:4c:b0, IRQ 45.
> Linux video capture interface: v2.00
> scsi_id[402]: scsi_id: unable to access '/block'

I guess this is where things go bad.

scsi_id is part of udev.  Perhaps some sysfs nodes aren't being created
correctly.

Random guess: what is your setting of CONFIG_SCSI_SCAN_ASYNC and what
happens if you invert it?


> input: PC Speaker as /devices/platform/pcspkr/input/input1
> scsi_id[422]: scsi_id: unable to access '/block'
> sata_uli 0001:02:09.0: version 1.3
> scsi1 : sata_uli
> scsi2 : sata_uli
> ata1: SATA max UDMA/133 cmd 0x200008420 ctl 0x200008440 bmdma 
> 0x200008400 irq 28
> ata2: SATA max UDMA/133 cmd 0x200008428 ctl 0x200008444 bmdma 
> 0x200008408 irq 28
> usbcore: registered new device driver usb
> hdf: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
> Uniform CD-ROM driver Revision: 3.20
> scsi_id[469]: scsi_id: unable to access '/block'
> ata1: SATA link down (SStatus 0 SControl 300)
> ohci_hcd 0000:00:07.3: OHCI Host Controller
> ohci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 1
> ohci_hcd 0000:00:07.3: irq 10, io mem 0x09050000
> scsi_id[490]: scsi_id: unable toivtv:  Start initialization, version 1.1.0
>   access '/block'
> scsi_id[510]: scsi_id: unable to access '/block'
> scsi_id[532]: scsi_id: unable to access '/block'
> scsi_id[552]: scsi_id: unable to access '/block'
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> scsi_id[600]: scsi_id: unable to access '/block'
> ivtv0: Initializing card #0
> ivtv0: Autodetected Hauppauge card (cx23415 based)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
> ...
