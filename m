From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.38.3 ss boot problem and crash
Date: Sun, 17 Apr 2011 06:39:27 +0900
Message-ID: <20110416213927.GA23518@mtj.dyndns.org>
References: <web-506418104@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1DPVjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 17:39:41 -0400
Content-Disposition: inline
In-Reply-To: <web-506418104@zbackend1.aha.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: werner <w.landgraf@ru.ru>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-mmc@vger.kernel.org

Duplicate sysfs creation from mmc code.  Cc'ing linux-mmc and quoting
whole body.

On Sat, Apr 16, 2011 at 03:11:02PM -0400, werner wrote:
> The following problem, with 2.6.38.3 gives the error messages, and
> with 2.6.39-rc3-git6 let crash the laptop. With 2.6.26.2 the same
> sistem boots normally.
> (copy of dmesg, with error messages)
>=20
> W.Landgraf
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -0x007f]
> pnp 00:08: disabling [io  0x0038-0x0039 disabled] because it
> overlaps 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> pnp 00:08: disabling [io  0x003c-0x003d disabled] because it
> overlaps 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> pnp 00:08: disabling [io  0x0050-0x0053 disabled] because it
> overlaps 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> pnp 00:08: disabling [io  0x0063 disabled] because it overlaps
> 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> pnp 00:08: disabling [io  0x0065 disabled] because it overlaps
> 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> pnp 00:08: disabling [io  0x0072-0x0077 disabled] because it
> overlaps 0000:00:1f.6 BAR 1 [io  0x0000-0x007f]
> system 00:08: [io  0x01e0-0x01ef] has been reserved
> system 00:08: [io  0x0480-0x048f] has been reserved
> system 00:08: [io  0x0680-0x06ff] has been reserved
> system 00:08: [io  0xd800-0xd87f] has been reserved
> system 00:08: [io  0xd880-0xd89f] has been reserved
> system 00:08: [io  0xe000-0xe07f] has been reserved
> system 00:08: [io  0xe080-0xe0ff] has been reserved
> system 00:08: [io  0xe400-0xe47f] has been reserved
> system 00:08: [io  0xe480-0xe4ff] has been reserved
> system 00:08: [io  0xe800-0xe87f] has been reserved
> system 00:08: [io  0xe880-0xe8ff] has been reserved
> system 00:08: [io  0xec00-0xec7f] has been reserved
> system 00:08: [io  0xec80-0xecff] has been reserved
> system 00:08: [io  0xeeb0-0xeebf] has been reserved
> system 00:08: [io  0xeec0-0xeeff] has been reserved
> system 00:08: [io  0x04d0-0x04d1] has been reserved
> system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp: PnP ACPI: found 9 devices
> ACPI: ACPI bus type pnp unregistered
> PnPBIOS: Disabled by ACPI PNP
> mdacon: MDA with 8K of memory detected.
> Console: switching consoles 13-16 to MDA-2
> Switching to clocksource acpi_pm
> pci 0000:00:1e.0: BAR 15: assigned [mem 0x20000000-0x27ffffff pref]
> pci 0000:00:1d.7: BAR 0: assigned [mem 0x28000000-0x280003ff]
> pci 0000:00:1d.7: BAR 0: set to [mem 0x28000000-0x280003ff] (PCI
> address [0x28000000-0x280003ff])
> pci 0000:00:1f.5: BAR 2: assigned [mem 0x28000800-0x280009ff]
> pci 0000:00:1f.5: BAR 2: set to [mem 0x28000800-0x280009ff] (PCI
> address [0x28000800-0x280009ff])
> pci 0000:00:1f.5: BAR 0: assigned [io  0x1000-0x10ff]
> pci 0000:00:1f.5: BAR 0: set to [io  0x1000-0x10ff] (PCI address
> [0x1000-0x10ff])
> pci 0000:00:1f.5: BAR 3: assigned [mem 0x28000a00-0x28000aff]
> pci 0000:00:1f.5: BAR 3: set to [mem 0x28000a00-0x28000aff] (PCI
> address [0x28000a00-0x28000aff])
> pci 0000:00:1f.6: BAR 0: assigned [io  0x1400-0x14ff]
> pci 0000:00:1f.6: BAR 0: set to [io  0x1400-0x14ff] (PCI address
> [0x1400-0x14ff])
> pci 0000:00:1f.6: BAR 1: assigned [io  0x1800-0x187f]
> pci 0000:00:1f.6: BAR 1: set to [io  0x1800-0x187f] (PCI address
> [0x1800-0x187f])
> pci 0000:00:1f.5: BAR 1: assigned [io  0x1880-0x18bf]
> pci 0000:00:1f.5: BAR 1: set to [io  0x1880-0x18bf] (PCI address
> [0x1880-0x18bf])
> pci 0000:00:1d.0: BAR 4: assigned [io  0x18c0-0x18df]
> pci 0000:00:1d.0: BAR 4: set to [io  0x18c0-0x18df] (PCI address
> [0x18c0-0x18df])
> pci 0000:00:1d.1: BAR 4: assigned [io  0x18e0-0x18ff]
> pci 0000:00:1d.1: BAR 4: set to [io  0x18e0-0x18ff] (PCI address
> [0x18e0-0x18ff])
> pci 0000:00:1d.2: BAR 4: assigned [io  0x1c00-0x1c1f]
> pci 0000:00:1d.2: BAR 4: set to [io  0x1c00-0x1c1f] (PCI address
> [0x1c00-0x1c1f])
> pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0:   bridge window [io  disabled]
> pci 0000:00:01.0:   bridge window [mem 0xcf000000-0xcfffffff]
> pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff pref]
> pci 0000:02:09.0: BAR 0: assigned [mem 0x20000000-0x23ffffff pref]
> pci 0000:02:09.0: BAR 0: set to [mem 0x20000000-0x23ffffff pref]
> (PCI address [0x20000000-0x23ffffff])
> pci 0000:02:0b.0: BAR 15: assigned [mem 0x24000000-0x27ffffff pref]
> pci 0000:02:0b.0: BAR 16: assigned [mem 0x2c000000-0x2fffffff]
> pci 0000:02:0b.2: BAR 1: assigned [mem 0xcee00000-0xcee03fff]
> pci 0000:02:0b.2: BAR 1: set to [mem 0xcee00000-0xcee03fff] (PCI
> address [0xcee00000-0xcee03fff])
> pci 0000:02:0b.3: BAR 0: assigned [mem 0xcee04000-0xcee05fff]
> pci 0000:02:0b.3: BAR 0: set to [mem 0xcee04000-0xcee05fff] (PCI
> address [0xcee04000-0xcee05fff])
> pci 0000:02:0b.0: BAR 0: assigned [mem 0xcee06000-0xcee06fff]
> pci 0000:02:0b.0: BAR 0: set to [mem 0xcee06000-0xcee06fff] (PCI
> address [0xcee06000-0xcee06fff])
> pci 0000:02:0b.2: BAR 0: assigned [mem 0xcee07000-0xcee077ff]
> pci 0000:02:0b.2: BAR 0: set to [mem 0xcee07000-0xcee077ff] (PCI
> address [0xcee07000-0xcee077ff])
> pci 0000:02:0b.0: BAR 13: assigned [io  0xc000-0xc0ff]
> pci 0000:02:0b.0: BAR 14: assigned [io  0xc400-0xc4ff]
> pci 0000:02:0b.4: BAR 0: assigned [mem 0xcee07800-0xcee078ff]
> pci 0000:02:0b.4: BAR 0: set to [mem 0xcee07800-0xcee078ff] (PCI
> address [0xcee07800-0xcee078ff])
> pci 0000:02:0b.4: BAR 1: assigned [mem 0xcee07900-0xcee079ff]
> pci 0000:02:0b.4: BAR 1: set to [mem 0xcee07900-0xcee079ff] (PCI
> address [0xcee07900-0xcee079ff])
> pci 0000:02:0b.4: BAR 2: assigned [mem 0xcee07a00-0xcee07aff]
> pci 0000:02:0b.4: BAR 2: set to [mem 0xcee07a00-0xcee07aff] (PCI
> address [0xcee07a00-0xcee07aff])
> pci 0000:02:0b.0: CardBus bridge to [bus 03-03]
> pci 0000:02:0b.0:   bridge window [io  0xc000-0xc0ff]
> pci 0000:02:0b.0:   bridge window [io  0xc400-0xc4ff]
> pci 0000:02:0b.0:   bridge window [mem 0x24000000-0x27ffffff pref]
> pci 0000:02:0b.0:   bridge window [mem 0x2c000000-0x2fffffff]
> pci 0000:00:1e.0: PCI bridge to [bus 02-04]
> pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:1e.0:   bridge window [mem 0xcee00000-0xceefffff]
> pci 0000:00:1e.0:   bridge window [mem 0x20000000-0x27ffffff pref]
> pci 0000:00:1e.0: setting latency timer to 64
> pci 0000:02:0b.0: enabling device (0000 -> 0003)
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> pci 0000:02:0b.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) ->
> IRQ 11
> pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
> pci_bus 0000:01: resource 1 [mem 0xcf000000-0xcfffffff]
> pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff pref]
> pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
> pci_bus 0000:02: resource 1 [mem 0xcee00000-0xceefffff]
> pci_bus 0000:02: resource 2 [mem 0x20000000-0x27ffffff pref]
> pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
> pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
> pci_bus 0000:03: resource 0 [io  0xc000-0xc0ff]
> pci_bus 0000:03: resource 1 [io  0xc400-0xc4ff]
> pci_bus 0000:03: resource 2 [mem 0x24000000-0x27ffffff pref]
> pci_bus 0000:03: resource 3 [mem 0x2c000000-0x2fffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
> TCP: Hash tables configured (established 16384 bind 16384)
> TCP reno registered
> UDP hash table entries: 256 (order: 1, 8192 bytes)
> UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
> NET: Registered protocol family 1
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> pci 0000:01:00.0: Boot video device
> pci 0000:02:08.0: Firmware left e100 interrupts enabled; disabling
> PCI: CLS 32 bytes, default 64
> Simple Boot Flag at 0x7c set to 0x1
> Machine check injector initialized
> elanfreq: error: no Elan processor found!
> cpufreq-nforce2: No nForce2 chipset.
> apm: BIOS version 1.2 Flags 0x02 (Driver version 1.16ac)
> apm: overridden by ACPI.
> microcode: CPU0 sig=3D0x6d6, pf=3D0x20, revision=3D0x17
> microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> scx200: NatSemi SCx200 Driver
> audit: initializing netlink socket (disabled)
> type=3D2000 audit(1302979948.433:1): initialized
> HugeTLB registered 4 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> DLM (built Apr 15 2011 02:33:33) installed
> squashfs: version 4.0 (2009/01/31) Phillip Lougher
> Registering the id_resolver key type
> FS-Cache: Netfs 'nfs' registered for caching
> nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> FS-Cache: Netfs 'cifs' registered for caching
> NTFS driver 2.1.30 [Flags: R/W].
> EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> JFFS2 version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, Inc.
> ROMFS MTD (C) 2007 Red Hat, Inc.
> QNX4 filesystem 0.2.3 registered.
> fuse init (API version 7.16)
> JFS: nTxBlock =3D 3874, nTxLock =3D 30994
> SGI XFS with ACLs, security attributes, realtime, large block/inode
> numbers, no debug enabled
> SGI XFS Quota Management subsystem
> NILFS version 2 loaded
> BeFS version: 0.9.3
> OCFS2 1.5.0
> ocfs2: Registered cluster interface o2cb
> ocfs2: Registered cluster interface user
> OCFS2 DLMFS 1.5.0
> OCFS2 User DLM kernel interface loaded
> OCFS2 Node Manager 1.5.0
> OCFS2 DLM 1.5.0
> Btrfs loaded
> GFS2 (built Apr 15 2011 02:35:04) installed
> ceph: loaded (mds proto 32)
> msgmni has been set to 968
> async_tx: api initialized (async)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
> ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version:
> 0.1
> cpcihp_generic: not configured, disabling.
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
> Console: switching consoles 13-16 to MDA-2
> nvidiafb 0000:01:00.0: power state changed by ACPI to D0
> nvidiafb 0000:01:00.0: power state changed by ACPI to D0
> ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 10
> PCI: setting IRQ 10 as level-triggered
> nvidiafb 0000:01:00.0: PCI INT A -> Link[LNKG] -> GSI 10 (level,
> low) -> IRQ 10
> nvidiafb: Device ID: 10de0324
> nvidiafb: CRTC0 analog not found
> nvidiafb: CRTC1 analog not found
> i2c i2c-0: unable to read EDID block.
> i2c i2c-0: unable to read EDID block.
> i2c i2c-0: unable to read EDID block.
> i2c i2c-1: unable to read EDID block.
> i2c i2c-1: unable to read EDID block.
> i2c i2c-1: unable to read EDID block.
> nvidiafb: CRTC 0 is currently programmed for DFP
> nvidiafb: Using DFP on CRTC 0
> nvidiafb: Panel size is 1024 x 768
> nvidiafb: Panel is LVDS
> nvidiafb: MTRR set to ON
> fbcvt: 1024x768@60: CVT Name - .786M3-R
> fbcon: NV32 (fb0) is primary device
> nvidiafb: Flat panel dithering disabled
> Console: switching to colour frame buffer device 128x48
> nvidiafb: PCI nVidia NV32 framebuffer (64MB @ 0xA0000000)
> VIA Graphics Intergration Chipset framebuffer 2.4 initializing
> vmlfb: initializing
> Could not find Carillo Ranch MCH device.
> no IO addresses supplied
> hgafb: HGA card not detected.
> hgafb: probe of hgafb.0 failed with error -22
> uvesafb: failed to execute /sbin/v86d
> uvesafb: make sure that the v86d helper is installed and executable
> uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D-2)
> uvesafb: vbe_init() failed with -22
> uvesafb: probe of uvesafb.0 failed with error -22
> vesafb: cannot reserve video memory at 0xa0000000
> vesafb: framebuffer at 0xa0000000, mapped to 0xe5c00000, using
> 3072k, total 65536k
> vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D1
> vesafb: protected mode interface info at c000:c240
> vesafb: pmi: set display start =3D c00cc276, set palette =3D c00cc2e0
> vesafb: pmi: ports =3D 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3c=
c
> 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
> fb1: VESA VGA frame buffer device
> vga16fb: initializing
> vga16fb: mapped to 0xc00a0000
> checking generic (a0000000 4000000) vs hw (a0000 10000)
> fb2: VGA16 VGA frame buffer device
> ACPI: Deprecated procfs I/F for AC is loaded, please retry with
> CONFIG_ACPI_PROCFS_POWER cleared
> ACPI: AC Adapter [ADP1] (on-line)
> input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> ACPI: Power Button [PWRB]
> input: Lid Switch as
> /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> ACPI: Lid Switch [LID]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> ACPI: Power Button [PWRF]
> [Firmware Bug]: ACPI: No _BQC method, cannot determine initial
> brightness
> acpi device:1a: registered as cooling_device0
> input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:=
19/LNXVIDEO:00/input/input3
> ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
> ACPI: acpi_idle registered with cpuidle
> Marking TSC unstable due to TSC halts in idle
> thermal LNXTHERM:00: registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (80 C)
> ACPI: Deprecated procfs I/F for battery is loaded, please retry with
> CONFIG_ACPI_PROCFS_POWER cleared
> ACPI: Battery Slot [BAT1] (battery present)
> ERST: Table is not found!
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial 0000:00:1f.6: power state changed by ACPI to D0
> serial 0000:00:1f.6: power state changed by ACPI to D0
> serial 0000:00:1f.6: enabling device (0000 -> 0001)
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low)
> -> IRQ 11
> serial 0000:00:1f.6: PCI INT B disabled
> Non-volatile memory driver v1.3
> Toshiba System Management Mode driver v1.11 26/9/2001
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 855PM Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon defaulting to userspace modesetting.
> Floppy drive(s): fd0 is 1.44M
> floppy0: no floppy controllers found
> brd: module loaded
> loop: module loaded
> Compaq SMART2 Driver (v 2.6.0)
> HP CISS Driver (v 3.6.26)
> MM: desc_per_page =3D 128
> nbd: registered device at major 43
> usbcore: registered new interface driver ub
> drbd: initialized. Version: 8.3.9 (api:88/proto:86-95)
> drbd: built-in
> drbd: registered as block device major 147
> drbd: minor_table @ 0xdf601f80
> rbd: loaded rbd (rados block device)
> ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> tifm_7xx1 0000:02:0b.3: enabling device (0000 -> 0002)
> ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> tifm_7xx1 0000:02:0b.3: PCI INT D -> Link[LNKD] -> GSI 11 (level,
> low) -> IRQ 11
> Phantom Linux Driver, version n0.9.8, init OK
> i2c-core: driver [isl29003] using legacy suspend method
> i2c-core: driver [isl29003] using legacy resume method
> Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> c2port c2port0: C2 port uc added
> c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes
> total)
> Driver for timberdale has been successfully registered.
> i2c-core: driver [adp5520] using legacy suspend method
> i2c-core: driver [adp5520] using legacy resume method
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> PIIX_IDE 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> piix 0000:00:1f.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xbfa0-0xbfa7
>     ide1: BM-DMA at 0xbfa8-0xbfaf
> Probing IDE interface ide0...
> hda: TOSHIBA MK8032GAX, ATA DISK drive
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/100 mode selected
> Probing IDE interface ide1...
> hdc: MATSHITADVD-RAM UJ-830S, ATAPI CD/DVD-ROM drive
> hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdc: UDMA/33 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> ide_generic: please use "probe_mask=3D0x3f" module parameter for
> probing all legacy ISA IDE ports
> ide-gd driver 1.18
> hda: max request size: 512KiB
> hda: 156301488 sectors (80026 MB), CHS=3D16383/255/63
> hda: cache flushes supported
>  hda: hda1
> ide-cd driver 5.00
> ide-cd: hdc: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
> cdrom: Uniform CD-ROM driver Revision: 3.20
> Loading iSCSI transport class v2.0-870.
> rdac: device handler registered
> hp_sw: device handler registered
> emc: device handler registered
> alua: device handler registered
> fnic: Cisco FCoE HBA Driver, ver 1.4.0.145
> iscsi: registered transport (tcp)
> Loading Adaptec I2O RAID: Version 2.4 Build 5go
> Detecting Adaptec I2O RAID controllers...
> Adaptec aacraid driver 1.1-5[26400]-ms
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> scsi: <fdomain> Detection failed (no card)
> NCR53c406a: no available ports found
> sym53c416.c: Version 1.0.0-ac
> qlogicfas: no cards were found, please specify I/O address and IRQ
> using iobase=3D and irq=3D options
> QLogic Fibre Channel HBA Driver: 8.03.05-k0
> iscsi: registered transport (qla4xxx)
> QLogic iSCSI HBA Driver
> Emulex LightPulse Fibre Channel SCSI driver 8.3.20
> Copyright(c) 2004-2009 Emulex.  All rights reserved.
> Brocade BFA FC/FCOE SCSI driver - version: 2.3.2.3
> Failed initialization of WD-7000 SCSI card!
> DC390: clustering now enabled by default. If you get problems load
>        with "disable_clustering=3D1" and report to maintainers
> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> megasas: 00.00.05.29-rc1 Tue. Dec. 7 17:00:00 PDT 2010
> mpt2sas version 07.100.00.00 loaded
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> 3ware Storage Controller device driver for Linux v1.26.02.003.
> 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> ppa: Version 2.07 (for Linux 2.4.x)
> imm: Version 2.05 (for Linux 2.4.0)
> nsp32: loading...
> ipr: IBM Power RAID SCSI Device Driver version: 2.5.1 (August 10,
> 2010)
> RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
> stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4
> bits.
> libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
> Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
> iscsi: registered transport (cxgb3i)
> Broadcom NetXtreme II iSCSI Driver bnx2i v2.6.2.2 (Nov 23, 2010)
> iscsi: registered transport (bnx2i)
> iscsi: registered transport (be2iscsi)
> st: Version 20101219, fixed bufsize 32768, s/g segs 256
> osst :I: Tape driver with OnStream support version 0.99.4
> osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> SCSI Media Changer driver v0.25
> osd: LOADED open-osd 0.2.0
> Error: Driver 'pata_platform' is already registered, aborting...
> SSFDC read-only Flash Translation layer
> mtdoops: mtd device (mtddev=3Dname/number) must be supplied
> L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot
> continue
> device id =3D 2440
> device id =3D 2480
> device id =3D 24c0
> device id =3D 24d0
> device id =3D 25a1
> device id =3D 2670
> physmap-flash.0: failed to claim resource 0
> SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> NetSc520 flash device: 0x100000 at 0x200000
> Failed to ioremap_nocache
> Failed to ioremap_nocache
> scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
> SNAPGEAR: failed to ioremap() ROMCS1
> Generic platform RAM MTD, (c) 2004 Simtec Electronics
> Possible DiskOnChip with unknown ChipID 50 found at 0xfffe0000
> No recognised DiskOnChip devices found
> slram: not enough parameters.
> Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel
> Networks.
> pmc551: not detected
> ftl_cs: FTL header not found.
> Spectra MTD driver built on Apr 15 2011 @ 03:05:21
> No valid DiskOnChip devices found
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> [nandsim] warning: read_byte: unexpected data output cycle, state is
> STATE_READY return 0x0
> NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 8MiB
> 1,8V 8-bit)
> flash size: 8 MiB
> page size: 512 bytes
> OOB area size: 16 bytes
> sector size: 8 KiB
> pages number: 16384
> pages per sector: 16
> bus width: 8
> bits in sector size: 13
> bits in page size: 9
> bits in OOB size: 4
> flash size with OOB: 8448 KiB
> page address bytes: 3
> sector address bytes: 2
> options: 0x62
> Scanning device for bad blocks
> Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
> 0x000000000000-0x000000800000 : "NAND simulator partition 0"
> ftl_cs: FTL header not found.
> usbcore: registered new interface driver alauda
> onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000
> OneNAND Manufacturer: Samsung (0xec)
> OneNAND 16MB 1.8V 16-bit (0x04)
> OneNAND version =3D 0x001e
> Lock scheme is Continuous Lock
> Scanning device for bad blocks
> Creating 1 MTD partitions on "OneNAND simulator":
> 0x000000000000-0x000001000000 : "OneNAND simulator partition"
> ftl_cs: FTL header not found.
> Fixed MDIO Bus: probed
> Atheros(R) L2 Ethernet Driver - version 2.2.3
> Copyright (c) 2007 Atheros Corporation.
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
> e100 0000:02:08.0: PCI INT A -> Link[LNKE] -> GSI 11 (level, low) ->
> IRQ 11
> e100 0000:02:08.0: PME# disabled
> e100 0000:02:08.0: eth0: addr 0xceefe000, irq 11, MAC addr
> 00:0e:7b:6b:67:0c
> cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.12 (Jan 03, 2011)
> D-Link DE-620 pocket adapter not identified in the printer port
> PPP generic driver version 2.4.2
> PPP Deflate Compression module registered
> PPP BSD Compression module registered
> PPP MPPE Compression module registered
> NET: Registered protocol family 24
> SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=3D256) (6
> bit encapsulation enabled).
> CSLIP: code copyright 1989 Regents of the University of California.
> SLIP linefill/keepalive option.
> eth%d: D-Link DE-600 pocket adapter: not at I/O 0x378.
> atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
> I2O subsystem v1.325
> i2o: max drivers =3D 8
> I2O Configuration OSM v1.323
> I2O Bus Adapter OSM v1.317
> I2O Block Device OSM v1.325
> I2O SCSI Peripheral OSM v1.316
> I2O ProcFS OSM v1.316
> Fusion MPT base driver 3.04.18
> Copyright (c) 1999-2008 LSI Corporation
> Fusion MPT SPI Host driver 3.04.18
> Fusion MPT FC Host driver 3.04.18
> Fusion MPT SAS Host driver 3.04.18
> Fusion MPT misc device (ioctl) driver 3.04.18
> mptctl: Registered with Fusion MPT base driver
> mptctl: /dev/mptctl @ (major,minor=3D10,220)
> Fusion MPT LAN driver 3.04.18
> firewire_ohci 0000:02:0b.2: enabling device (0000 -> 0002)
> ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
> firewire_ohci 0000:02:0b.2: PCI INT C -> Link[LNKF] -> GSI 11
> (level, low) -> IRQ 11
> firewire_ohci: Added fw-ohci device 0000:02:0b.2, OHCI v1.10, 4 IR +
> 8 IT contexts, quirks 0x2
> yenta_cardbus 0000:02:0b.0: CardBus bridge found [1179:0001]
> yenta_cardbus 0000:02:0b.0: Using CSCINT to route CSC interrupts to
> PCI
> yenta_cardbus 0000:02:0b.0: Routing CardBus interrupts to PCI
> yenta_cardbus 0000:02:0b.0: TI: mfunc 0x01aa1b02, devctl 0x64
> yenta_cardbus 0000:02:0b.0: ISA IRQ mask 0x00f8, PCI irq 11
> yenta_cardbus 0000:02:0b.0: Socket status: 30000086
> yenta_cardbus 0000:02:0b.0: pcmcia: parent PCI bridge window: [io
> 0xc000-0xcfff]
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xcfff:
> excluding 0xc000-0xc0ff 0xc400-0xc4ff 0xcf00-0xcf3f
> yenta_cardbus 0000:02:0b.0: pcmcia: parent PCI bridge window: [mem
> 0xcee00000-0xceefffff]
> pcmcia_socket pcmcia_socket0: cs: memory probe
> 0xcee00000-0xceefffff: excluding 0xcee00000-0xcee0ffff
> 0xceef0000-0xceefffff
> yenta_cardbus 0000:02:0b.0: pcmcia: parent PCI bridge window: [mem
> 0x20000000-0x27ffffff pref]
> pcmcia_socket pcmcia_socket0: cs: memory probe
> 0x20000000-0x27ffffff: excluding 0x20000000-0x27ffffff
> Intel ISA PCIC probe: not found.
> Databook TCIC-2 PCMCIA probe: not found.
> aoe: AoE v47 initialised.
> paride: aten registered as protocol 0
> paride: bpck registered as protocol 1
> paride: comm registered as protocol 2
> paride: dstr registered as protocol 3
> paride: k951 registered as protocol 4
> paride: k971 registered as protocol 5
> paride: epat registered as protocol 6
> paride: epia registered as protocol 7
> paride: frpw registered as protocol 8
> paride: friq registered as protocol 9
> paride: fit2 registered as protocol 10
> paride: fit3 registered as protocol 11
> paride: on20 registered as protocol 12
> paride: on26 registered as protocol 13
> paride: ktti registered as protocol 14
> bpck6: BACKPACK Protocol Driver V2.0.2
> bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA
> paride: bpck6 registered as protocol 15
> pd: pd version 1.05, major 45, cluster 64, nice 0
> pda: Autoprobe failed
> pd: no valid drive found
> pcd: pcd version 1.07, major 46, nice 0
> pcd0: Autoprobe failed
> pcd: No CD-ROM drive found
> pf: pf version 1.04, major 47, cluster 64, nice 0
> pf: No ATAPI disk detected
> pt: pt version 1.04, major 96
> pt0: Autoprobe failed
> pt: No ATAPI tape drive detected
> pg: pg version 1.02, major 97
> pga: Autoprobe failed
> pg: No ATAPI device detected
> usbcore: registered new interface driver hwa-rc
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
> ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
> ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level,
> low) -> IRQ 11
> ehci_hcd 0000:00:1d.7: setting latency timer to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:1d.7: debug port 1
> ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> ehci_hcd 0000:00:1d.7: irq 11, io mem 0x28000000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
> usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.38.3 ehci_hcd
> usb usb1: SerialNumber: 0000:00:1d.7
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 6 ports detected
> 116x: driver isp116x-hcd, 03 Nov 2005
> driver isp1362-hcd, 2005-04-04
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> uhci_hcd: USB Universal Host Controller Interface driver
> uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level,
> low) -> IRQ 11
> uhci_hcd 0000:00:1d.0: setting latency timer to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.0: irq 11, io base 0x000018c0
> usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb2: Product: UHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.38.3 uhci_hcd
> usb usb2: SerialNumber: 0000:00:1d.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level,
> low) -> IRQ 11
> uhci_hcd 0000:00:1d.1: setting latency timer to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.1: irq 11, io base 0x000018e0
> usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb3: Product: UHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.38.3 uhci_hcd
> usb usb3: SerialNumber: 0000:00:1d.1
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> uhci_hcd 0000:00:1d.2: setting latency timer to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001c00
> usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
> usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
> usb usb4: Product: UHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.38.3 uhci_hcd
> usb usb4: SerialNumber: 0000:00:1d.2
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> sl811: driver sl811-hcd, 19 May 2005
> r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
> usbcore: registered new interface driver hwa-hc
> usbcore: registered new interface driver wusb-cbaf
> usbcore: registered new interface driver cdc_acm
> cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and
> ISDN adapters
> usbcore: registered new interface driver usblp
> usbcore: registered new interface driver cdc_wdm
> usbcore: registered new interface driver uas
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usbcore: registered new interface driver libusual
> usbcore: registered new interface driver ums-alauda
> usbcore: registered new interface driver ums-cypress
> usbcore: registered new interface driver ums-datafab
> usbcore: registered new interface driver ums-freecom
> usbcore: registered new interface driver ums-isd200
> usbcore: registered new interface driver ums-jumpshot
> usbcore: registered new interface driver ums-karma
> usbcore: registered new interface driver ums-onetouch
> usbcore: registered new interface driver ums-sddr09
> usbcore: registered new interface driver ums-sddr55
> usbcore: registered new interface driver ums-usbat
> i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64
> irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> parkbd: no such parport
> mousedev: PS/2 mouse device common for all mice
> i2c-core: driver [lm8323] using legacy suspend method
> i2c-core: driver [lm8323] using legacy resume method
> i2c-core: driver [max7359] using legacy suspend method
> i2c-core: driver [max7359] using legacy resume method
> usbcore: registered new interface driver appletouch
> usbcore: registered new interface driver bcm5974
> inport.c: Didn't find InPort mouse at 0x23c
> logibm.c: Didn't find Logitech busmouse at 0x23c
> i2c-core: driver [synaptics_i2c] using legacy suspend method
> i2c-core: driver [synaptics_i2c] using legacy resume method
> usbcore: registered new interface driver usb_acecad
> acecad: v3.2:USB Acecad Flair tablet driver
> usbcore: registered new interface driver aiptek
> aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux
> 2.6.x)
> aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
> input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input4
> usbcore: registered new interface driver gtco
> GTCO usb driver version: 2.00.0006
> usbcore: registered new interface driver hanwang
> usbcore: registered new interface driver kbtab
> kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
> usbcore: registered new interface driver wacom
> wacom: v1.52:USB Wacom tablet driver
> mk712: device not present
> usbcore: registered new interface driver usbtouchscreen
> i2c-core: driver [ad714x_captouch] using legacy suspend method
> i2c-core: driver [ad714x_captouch] using legacy resume method
> i2c-core: driver [adxl34x] using legacy suspend method
> i2c-core: driver [adxl34x] using legacy resume method
> apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
> usbcore: registered new interface driver ati_remote
> ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
> usbcore: registered new interface driver ati_remote2
> ati_remote2: ATI/Philips USB RF remote driver 0.3
> cm109: Keymap for Komunikate KIP1000 phone loaded
> usbcore: registered new interface driver cm109
> cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
> usbcore: registered new interface driver keyspan_remote
> input: PC Speaker as /devices/platform/pcspkr/input/input5
> usbcore: registered new interface driver powermate
> wistron_btns: System unknown
> usbcore: registered new interface driver yealink
> yealink: yld-20051230:Yealink phone driver
> i2c /dev entries driver
> lirc_dev: IR Remote Control driver registered, major 242
> IR NEC protocol handler initialized
> IR RC5(x) protocol handler initialized
> IR RC6 protocol handler initialized
> IR JVC protocol handler initialized
> IR Sony protocol handler initialized
> IR RC5 (streamzap) protocol handler initialized
> IR LIRC bridge handler initialized
> Linux video capture interface: v2.00
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> md: raid10 personality registered for level 10
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md: multipath personality registered for level -4
> md: faulty personality registered for level -5
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised:
> dm-devel@redhat.com
> device-mapper: multipath: version 1.2.0 loaded
> device-mapper: multipath round-robin: version 1.0.0 loaded
> EDAC MC: Ver: 2.1.0 Apr 15 2011
> EISA: Probing bus 0 at eisa.0
> Cannot allocate resource for EISA slot 1
> EISA: Detected 0 cards.
> cpuidle: using governor ladder
> sdhci: Secure Digital Host Controller Interface driver
> sdhci: Copyright(c) Pierre Ossman
> sdhci-pci 0000:02:0b.4: SDHCI controller found [104c:8034] (rev 0)
> sdhci-pci 0000:02:0b.4: enabling device (0000 -> 0002)
> sdhci-pci 0000:02:0b.4: PCI INT D -> Link[LNKD] -> GSI 11 (level,
> low) -> IRQ 11
> _regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy
> regulator
> Registered led device: mmc0::
> mmc0: SDHCI controller on PCI [0000:02:0b.4] using DMA
> _regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy
> regulator
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
> Hardware name: Qosmio E10
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:=
1e.0/0000:02:0b.4/microamps_requested_vmmc'
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.38.3 #1
> Call Trace:
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c103cfc7>] ? warn_slowpath_common+0x7a/0x8f
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c103d067>] ? warn_slowpath_fmt+0x33/0x35
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c111f903>] ? sysfs_add_file_mode+0x4a/0x72
>  [<c111f943>] ? sysfs_add_file+0x18/0x1c
>  [<c111f9de>] ? sysfs_create_file+0x25/0x27
>  [<c1753adb>] ? device_create_file+0x18/0x1a
>  [<c165b957>] ? _regulator_get+0x224/0x3b7
>  [<c107a02f>] ? request_threaded_irq+0xb9/0xe5
>  [<c165bb0d>] ? regulator_get+0xf/0x11
>  [<c1c39b53>] ? sdhci_add_host+0x580/0x6cb
>  [<c156d3ec>] ? pci_ioremap_bar+0x5b/0x5f
>  [<c1da4754>] ? sdhci_pci_probe+0x339/0x3e2
>  [<c156d609>] ? local_pci_probe+0x41/0x85
>  [<c156e17e>] ? pci_device_probe+0x48/0x6b
>  [<c1755c6c>] ? driver_probe_device+0x9c/0x145
>  [<c156d5a3>] ? pci_match_device+0x96/0x9c
>  [<c1dbab2a>] ? _cond_resched+0x8/0x47
>  [<c1755d5d>] ? __driver_attach+0x48/0x64
>  [<c17555ad>] ? bus_for_each_dev+0x42/0x6c
>  [<c1755af5>] ? driver_attach+0x1e/0x20
>  [<c1755d15>] ? __driver_attach+0x0/0x64
>  [<c1754fc2>] ? bus_add_driver+0xc6/0x20a
>  [<c1755fef>] ? driver_register+0x98/0xf8
>  [<c1755fef>] ? driver_register+0x98/0xf8
>  [<c165d19a>] ? tty_register_driver+0x15e/0x1e2
>  [<c156e36b>] ? __pci_register_driver+0x3d/0x96
>  [<c1dba0d5>] ? printk+0x1d/0x1f
>  [<c23255b7>] ? sdhci_drv_init+0x14/0x16
>  [<c100117e>] ? do_one_initcall+0x8c/0x142
>  [<c1079038>] ? irq_to_desc+0x8/0x1e
>  [<c23255a3>] ? sdhci_drv_init+0x0/0x16
>  [<c22c4380>] ? kernel_init+0x101/0x19a
>  [<c22c427f>] ? kernel_init+0x0/0x19a
>  [<c1003b46>] ? kernel_thread_helper+0x6/0x10
> ---[ end trace 120ecbe82d809816 ]---
> create_regulator: dummy: could not add regulator_dev requested
> microamps sysfs entry
> mmc1: no vmmc regulator found
> firewire_core: created device fw0: GUID 000039000061e892, S400
> Registered led device: mmc1::
> mmc1: SDHCI controller on PCI [0000:02:0b.4] using DMA
> _regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy
> regulator
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
> Hardware name: Qosmio E10
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:=
1e.0/0000:02:0b.4/microamps_requested_vmmc'
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W   2.6.38.3 #1
> Call Trace:
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c103cfc7>] ? warn_slowpath_common+0x7a/0x8f
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c103d067>] ? warn_slowpath_fmt+0x33/0x35
>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>  [<c111f903>] ? sysfs_add_file_mode+0x4a/0x72
>  [<c111f943>] ? sysfs_add_file+0x18/0x1c
>  [<c111f9de>] ? sysfs_create_file+0x25/0x27
>  [<c1753adb>] ? device_create_file+0x18/0x1a
>  [<c165b957>] ? _regulator_get+0x224/0x3b7
>  [<c107a02f>] ? request_threaded_irq+0xb9/0xe5
>  [<c165bb0d>] ? regulator_get+0xf/0x11
>  [<c1c39b53>] ? sdhci_add_host+0x580/0x6cb
>  [<c156d3ec>] ? pci_ioremap_bar+0x5b/0x5f
>  [<c1da4754>] ? sdhci_pci_probe+0x339/0x3e2
>  [<c156d609>] ? local_pci_probe+0x41/0x85
>  [<c156e17e>] ? pci_device_probe+0x48/0x6b
>  [<c1755c6c>] ? driver_probe_device+0x9c/0x145
>  [<c156d5a3>] ? pci_match_device+0x96/0x9c
>  [<c1dbab2a>] ? _cond_resched+0x8/0x47
>  [<c1755d5d>] ? __driver_attach+0x48/0x64
>  [<c17555ad>] ? bus_for_each_dev+0x42/0x6c
>  [<c1755af5>] ? driver_attach+0x1e/0x20
>  [<c1755d15>] ? __driver_attach+0x0/0x64
>  [<c1754fc2>] ? bus_add_driver+0xc6/0x20a
>  [<c1755fef>] ? driver_register+0x98/0xf8
>  [<c1755fef>] ? driver_register+0x98/0xf8
>  [<c165d19a>] ? tty_register_driver+0x15e/0x1e2
>  [<c156e36b>] ? __pci_register_driver+0x3d/0x96
>  [<c1dba0d5>] ? printk+0x1d/0x1f
>  [<c23255b7>] ? sdhci_drv_init+0x14/0x16
>  [<c100117e>] ? do_one_initcall+0x8c/0x142
>  [<c1079038>] ? irq_to_desc+0x8/0x1e
>  [<c23255a3>] ? sdhci_drv_init+0x0/0x16
>  [<c22c4380>] ? kernel_init+0x101/0x19a
>  [<c22c427f>] ? kernel_init+0x0/0x19a
>  [<c1003b46>] ? kernel_thread_helper+0x6/0x10
> ---[ end trace 120ecbe82d809817 ]---
> create_regulator: dummy: could not add regulator_dev requested
> microamps sysfs entry
> mmc2: no vmmc regulator found
> Registered led device: mmc2::
> mmc2: SDHCI controller on PCI [0000:02:0b.4] using DMA
> wbsd: Winbond W83L51xD SD/MMC card interface driver
> wbsd: Copyright(c) Pierre Ossman
> via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies,
> Inc.
> No iBFT detected.
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> XGIfb: Options (null)
> dell-wmi: No known WMI GUID found
> This machine doesn't have MSI-hotkeys through WMI
> Topstar Laptop ACPI extras driver loaded
> Detected Toshiba ACPI Bluetooth device - installing RFKill handler
> toshiba_bluetooth: Re-enabling Toshiba Bluetooth
> oprofile: using NMI timer interrupt.
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> NET: Registered protocol family 33
> lib80211: common routines for IEEE802.11 drivers
> lib80211_crypt: registered algorithm 'NULL'
> lib80211_crypt: registered algorithm 'WEP'
> lib80211_crypt: registered algorithm 'CCMP'
> lib80211_crypt: registered algorithm 'TKIP'
> Registering the dns_resolver key type
> libceph: loaded (mon/osd proto 15/24, osdmap 5/5 5/5)
> Using IPI No-Shortcut mode
> psmouse serio1: ID: 73 02 14
> usb 3-1: new low speed USB device using uhci_hcd and address 2
> usb 3-1: New USB device found, idVendor=3D04d9, idProduct=3D1603
> usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
0
> usb 3-1: Product: USB Keyboard
> usb 3-1: Manufacturer:
> input:   USB Keyboard as
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input6
> generic-usb 0003:04D9:1603.0001: input,hidraw0: USB HID v1.10
> Keyboard [  USB Keyboard] on usb-0000:00:1d.1-1/input0
> input:   USB Keyboard as
> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.1/input/input7
> generic-usb 0003:04D9:1603.0002: input,hidraw1: USB HID v1.10 Device
> [  USB Keyboard] on usb-0000:00:1d.1-1/input1
> usb 3-2: new low speed USB device using uhci_hcd and address 3
> usb 3-2: New USB device found, idVendor=3D05e3, idProduct=3D1205
> usb 3-2: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D=
0
> usb 3-2: Product: USB Mouse
> input: USB Mouse               as
> /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input8
> generic-usb 0003:05E3:1205.0003: input,hidraw2: USB HID v1.10 Mouse
> [USB Mouse              ] on usb-0000:00:1d.1-2/input0
> input: PS/2 Generic Mouse as
> /devices/platform/i8042/serio1/input/input9
> kAFS: Red Hat AFS client v0.1 registering.
> FS-Cache: Netfs 'afs' registered for caching
> raid6test: testing the 4-disk case...
> raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) OK
> raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) OK
> raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) OK
> raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) OK
> raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) OK
> raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) OK
> raid6test: testing the 5-disk case...
> raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) OK
> raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) OK
> raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) OK
> raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) OK
> raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) OK
> raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) OK
> raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) OK
> raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) OK
> raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) OK
> raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) OK
> raid6test: testing the 11-disk case...
> raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) OK
> raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) OK
> raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) OK
> raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) OK
> raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) OK
> raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) OK
> raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) OK
> raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) OK
> raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) OK
> raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q) OK
> raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) OK
> raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) OK
> raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) OK
> raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) OK
> raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) OK
> raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) OK
> raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) OK
> raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) OK
> raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q) OK
> raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) OK
> raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) OK
> raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) OK
> raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) OK
> raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) OK
> raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) OK
> raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) OK
> raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q) OK
> raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) OK
> raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) OK
> raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) OK
> raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) OK
> raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) OK
> raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) OK
> raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q) OK
> raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) OK
> raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) OK
> raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) OK
> raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) OK
> raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) OK
> raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q) OK
> raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) OK
> raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) OK
> raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) OK
> raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) OK
> raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q) OK
> raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) OK
> raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) OK
> raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) OK
> raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q) OK
> raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) OK
> raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) OK
> raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q) OK
> raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) OK
> raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q) OK
> raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q) OK
> raid6test: testing the 12-disk case...
> raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) OK
> raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) OK
> raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) OK
> raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) OK
> raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) OK
> raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) OK
> raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) OK
> raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) OK
> raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) OK
> raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P) OK
> raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q) OK
> raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) OK
> raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) OK
> raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) OK
> raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) OK
> raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) OK
> raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) OK
> raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) OK
> raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) OK
> raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P) OK
> raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q) OK
> raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) OK
> raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) OK
> raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) OK
> raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) OK
> raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) OK
> raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) OK
> raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) OK
> raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P) OK
> raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q) OK
> raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) OK
> raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) OK
> raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) OK
> raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) OK
> raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) OK
> raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) OK
> raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P) OK
> raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q) OK
> raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) OK
> raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) OK
> raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) OK
> raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) OK
> raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) OK
> raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P) OK
> raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q) OK
> raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) OK
> raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) OK
> raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) OK
> raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) OK
> raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P) OK
> raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q) OK
> raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) OK
> raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) OK
> raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) OK
> raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P) OK
> raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q) OK
> raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) OK
> raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) OK
> raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P) OK
> raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q) OK
> raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) OK
> raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P) OK
> raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q) OK
> raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P) OK
> raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q) OK
> raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q) OK
> raid6test: testing the 16-disk case...
> raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) OK
> raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) OK
> raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) OK
> raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) OK
> raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) OK
> raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) OK
> raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) OK
> raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) OK
> raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) OK
> raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D) OK
> raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D) OK
> raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D) OK
> raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D) OK
> raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P) OK
> raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q) OK
> raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) OK
> raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) OK
> raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) OK
> raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) OK
> raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) OK
> raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) OK
> raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) OK
> raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) OK
> raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D) OK
> raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D) OK
> raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D) OK
> raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D) OK
> raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P) OK
> raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q) OK
> raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) OK
> raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) OK
> raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) OK
> raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) OK
> raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) OK
> raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) OK
> raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) OK
> raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D) OK
> raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D) OK
> raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D) OK
> raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D) OK
> raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P) OK
> raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q) OK
> raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) OK
> raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) OK
> raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) OK
> raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) OK
> raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) OK
> raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) OK
> raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D) OK
> raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D) OK
> raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D) OK
> raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D) OK
> raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P) OK
> raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q) OK
> raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) OK
> raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) OK
> raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) OK
> raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) OK
> raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) OK
> raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D) OK
> raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D) OK
> raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D) OK
> raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D) OK
> raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P) OK
> raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q) OK
> raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) OK
> raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) OK
> raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) OK
> raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) OK
> raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D) OK
> raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D) OK
> raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D) OK
> raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D) OK
> raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P) OK
> raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q) OK
> raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) OK
> raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) OK
> raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) OK
> raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D) OK
> raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D) OK
> raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D) OK
> raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D) OK
> raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P) OK
> raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q) OK
> raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) OK
> raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) OK
> raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D) OK
> raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D) OK
> raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D) OK
> raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D) OK
> raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P) OK
> raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q) OK
> raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) OK
> raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D) OK
> raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D) OK
> raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D) OK
> raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D) OK
> raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P) OK
> raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q) OK
> raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D) OK
> raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D) OK
> raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D) OK
> raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D) OK
> raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P) OK
> raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q) OK
> raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D) OK
> raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D) OK
> raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D) OK
> raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P) OK
> raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q) OK
> raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D) OK
> raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D) OK
> raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P) OK
> raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q) OK
> raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D) OK
> raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P) OK
> raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q) OK
> raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P) OK
> raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q) OK
> raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q) OK
> raid6test:
> raid6test: complete (257 tests, 0 failures)
> BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=3Dnoautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> EXT3-fs: barriers not enabled
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (hda1): mounted filesystem with ordered data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 3:1.
> devtmpfs: mounted
> Freeing unused kernel memory: 916k freed
> firewire_net: firewire0: IPv4 over FireWire on device
> 000039000061e892
> firewire_core: refreshed device fw0
> udevd (3479): /proc/3479/oom_adj is deprecated, please use
> /proc/3479/oom_score_adj instead.
> intel_rng: FWH not detected
> iTCO_vendor_support: vendor-support=3D0
> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
> iTCO_wdt: Found a ICH4-M TCO device (Version=3D1, TCOBASE=3D0xd860)
> iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
> input: Toshiba input device as /devices/virtual/input/input10
> toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
> toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
> Registered led device: toshiba::illumination
> usb 4-2: new full speed USB device using uhci_hcd and address 2
> Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
> Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
> Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
> rtc_cmos 00:07: RTC can wake from S4
> rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 11 (level,
> low) -> IRQ 11
> Intel ICH 0000:00:1f.5: setting latency timer to 64
> rtc0: alarms up to one year, 114 bytes nvram
> usb 4-2: New USB device found, idVendor=3D0930, idProduct=3D0505
> usb 4-2: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D=
0
> ivtv: Start initialization, version 1.4.2
> ivtv0: Initializing card 0
> ivtv0: Unknown card: vendor/device: [4444:0016]
> ivtv0:               subsystem vendor/device: [1179:0001]
> ivtv0:               cx23416 based
> ivtv0: Defaulting to Hauppauge WinTV PVR-150 card
> ivtv0: Please mail the vendor/device and subsystem vendor/device IDs
> and what kind of
> ivtv0: card you have to the ivtv-devel mailinglist
> (www.ivtvdriver.org)
> ivtv0: Prefix your subject line with [UNKNOWN IVTV CARD].
> cfg80211: Calling CRDA to update world regulatory domain
> ivtv 0000:02:09.0: enabling device (0000 -> 0002)
> ivtv 0000:02:09.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, low) ->
> IRQ 11
> intel8x0_measure_ac97_clock: measured 50539 usecs (2436 samples)
> intel8x0: clocking to 48000
> tveeprom 3-0050: Huh, no eeprom present (err=3D-6)?
> tveeprom 3-0050: Encountered bad packet header [c8]. Corrupt or not
> a Hauppauge eeprom.
> ivtv0: Invalid EEPROM
> libipw: 802.11 data/management/control stack, git-1.1.13
> libipw: Copyright (C) 2004-2005 Intel Corporation
> <jketreno@linux.intel.com>
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcff:
> excluding 0xcf8-0xcff
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0x800-0x80f: clean.
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:
> excluding 0x3f0-0x3f7 0x480-0x48f 0x4d0-0x4d7
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:
> excluding 0x170-0x177 0x1e0-0x1f7 0x320-0x327 0x350-0x357
> 0x370-0x377
> pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
> excluding 0xc0000-0xcffff 0xe0000-0xfffff
> pcmcia_socket pcmcia_socket0: cs: memory probe
> 0x60000000-0x60ffffff: clean.
> pcmcia_socket pcmcia_socket0: cs: memory probe
> 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
> ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> ipw2200: Copyright(c) 2003-2006 Intel Corporation
> cx25840 3-0044: Unable to detect h/w, assuming cx23887
> cx25840 3-0044: cx23887 A/V decoder found @ 0x88 (ivtv i2c driver
> #0)
> i2c-core: driver [tuner] using legacy suspend method
> i2c-core: driver [tuner] using legacy resume method
> Bluetooth: Core ver 2.15
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: Generic Bluetooth USB driver ver 0.6
> usbcore: registered new interface driver btusb
> Chip ID is not zero. It is not a TEA5767
> tuner 3-0060: chip found @ 0xc0 (ivtv i2c driver #0)
> wm8775 3-001b: chip found @ 0x36 (ivtv i2c driver #0)
> wm8775 3-001b: I2C: cannot write 000 to register R23
> wm8775 3-001b: I2C: cannot write 000 to register R7
> wm8775 3-001b: I2C: cannot write 021 to register R11
> wm8775 3-001b: I2C: cannot write 102 to register R12
> wm8775 3-001b: I2C: cannot write 000 to register R13
> wm8775 3-001b: I2C: cannot write 1d4 to register R14
> wm8775 3-001b: I2C: cannot write 1d4 to register R15
> wm8775 3-001b: I2C: cannot write 1bf to register R16
> wm8775 3-001b: I2C: cannot write 185 to register R17
> wm8775 3-001b: I2C: cannot write 0a2 to register R18
> wm8775 3-001b: I2C: cannot write 005 to register R19
> wm8775 3-001b: I2C: cannot write 07a to register R20
> wm8775 3-001b: I2C: cannot write 102 to register R21
> ivtv0: Registered device video0 for encoder MPG (4096 kB)
> ivtv0: Registered device video32 for encoder YUV (2048 kB)
> ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
> ivtv0: Registered device video24 for encoder PCM (320 kB)
> ivtv0: Registered device radio0 for encoder radio
> ivtv0: Initialized card: Hauppauge WinTV PVR-150
> ipw2200 0000:02:05.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low)
> -> IRQ 11
> ivtv: End initialization
> ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
> ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a
> channels)
> EXT3-fs (hda1): using internal journal
> lp: driver loaded but no devices found
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (v1.0.0)
> usbcore: registered new interface driver snd-usb-audio
> Broadcom 43xx driver loaded [ Features: PMNLS, Firmware-ID: FW13 ]
> Broadcom 43xx-legacy driver loaded [ Features: PLID, Firmware-ID:
> FW10 ]
> rt2860sta: module is from the staging directory, the quality is
> unknown, you have been warned.
> ---
> Professional hosting for everyone - http://www.host.ru
>=20

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
