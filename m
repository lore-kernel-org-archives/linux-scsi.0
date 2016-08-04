From: Piotr Szymaniak <szarpaj@grubelek.pl>
Subject: Re: aacraid / Adaptec 3805 - AAC: Host adapter dead -1
Date: Thu, 4 Aug 2016 17:15:24 +0200
Message-ID: <20160804151524.GA3226@pontus.sran>
References: <20160801094224.GW3226@pontus.sran>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ztcJpsdPpsnnlAp8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moh1-ve3.go2.pl ([193.17.41.134]:34474 "EHLO moh1-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785AbcHDPca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 11:32:30 -0400
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
	by moh1-ve3.go2.pl (Postfix) with ESMTP id 38542A53429
	for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2016 17:15:32 +0200 (CEST)
Received: from unknown (unknown [10.0.0.142])
	by moh1-ve3.go2.pl (Postfix) with SMTP
	for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2016 17:15:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160801094224.GW3226@pontus.sran>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vfio-users@redhat.com
Cc: aacraid@adaptec.com


--ztcJpsdPpsnnlAp8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 01, 2016 at 11:42:24AM +0200, Piotr Szymaniak wrote:
> Hi,

(Sorry, for almost-topposting. Leaving below for reference.)

As a followup to this thread - looking for answers here and there I've
added intel_iommu=3Digfx_off (found at some thread with some other
hardware mentioning Sandy Bridge) and it seems to work - just transfered
300 gigabytes of data to a testing array. On the other hand it still
fills logs with those over and over every 10 seconds:
AAC: Host adapter dead -1

I'm using Intel i5-2400 with Intel DQ67SW motherboard.

I've also tried various Live Linux 64-bit distros:
1/2. Arch Bang (4.6.4-1-ARCH) and Ubuntu 16.04.1 (4.4.0-31-generic
#50-Ubuntu) - prints errors every 10 seconds (afair didnt test if it
works as I expected it doesnt)
3. Ubuntu 14.04 (4.4.0-15-generic #31-Ubuntu) - doesnt print errors,
works

Further help appreciated.

linux-scsi@v.k.o please CC me as I'm not subscribed, thanks.


Best regards,
Piotr Szymaniak.



> I have some issues with Adaptec 3805 and found that it could be related to
> iommu as described here [1]. I've tried various (iommu=3Dpt etc.) but not=
hing
> seems to change the behaviour of the controller. Also tried the patch [2]=
 from
> Alex Williamson on top of 4.6.5. Controller seems to work fine (random r/=
w) for
> some hours under Windows 7 or (on the same machine) with Clonezilla.
>=20
> Every 10 seconds my dmesg fills with:
> AAC: Host adapter dead -1
>=20
> Not sure about the state now (as I tried rebuilding kernel with some more=
 PCI
> related options, various iommu lines in grub etc), but I could read the a=
rray
> (dd if=3Dcontroller of=3D/dev/null), but not write. With dd write, trying=
 to make
> fs or partition or whatever it ended with messages similar to this:
> DMAR: DRHD: handling fault status reg 3
> DMAR: DMAR:[DMA Write] Request device [03:01.0] fault addr ffbb5000
> DMAR:[fault reason 02] Present bit in context entry is clear
>=20
> So I'm looking for your help. :)
>=20
> I'm using Gentoo Linux with vanilla kernel 4.6.5/4.7.0.
>=20
> grub:
> kernel /boot/vmlinuz root=3D*cut* enable_mtrr_cleanup intel_iommu=3Don rw
> vfio-pci.ids=3D1002:9460,1002:aa30,8086:1c26
> vfio_iommu_type1.allow_unsafe_interrupts=3D1
>=20
> (vfio-pci.ids are GPU, GPU audio and USB for passthru to Windows VM)
>=20
> dmesg attached
>=20
> ~ # lspci -nnvs 03:0e.0
> 03:0e.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285]
>         Subsystem: Adaptec 3805 [9005:02bc]
>         Flags: bus master, stepping, 66MHz, medium devsel, latency 32, IR=
Q 18
>         Memory at fb800000 (64-bit, non-prefetchable) [size=3D2M]
>         Expansion ROM at fba00000 [disabled] [size=3D256K]
>         Capabilities: [c0] Power Management version 2
>         Capabilities: [d0] MSI: Enable- Count=3D1/2 Maskable- 64bit+
>         Capabilities: [e0] PCI-X non-bridge device
>         Kernel driver in use: aacraid
>=20
>=20
> linux-scsi@vger.kernel.org please CC me as I'm not subscribed, thanks.
>=20
> Best regards,
> Piotr Szymaniak.
>=20
>=20
> [1] https://www.redhat.com/archives/vfio-users/2016-July/msg00046.html
> [2] https://www.redhat.com/archives/vfio-users/2016-July/msg00063.html

> [    0.404887] pci 0000:02:00.0:   bridge window [mem 0xfb800000-0xfbafff=
ff]
> [    0.404923] pci 0000:02:00.2: PCI bridge to [bus 04]
> [    0.404964] pci 0000:00:1c.0: PCI bridge to [bus 02-04]
> [    0.404991] pci 0000:00:1c.0:   bridge window [mem 0xfb800000-0xfbafff=
ff]
> [    0.405026] pci 0000:00:1c.6: PCI bridge to [bus 05]
> [    0.405052] pci 0000:00:1c.6:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
> [    0.405086] pci 0000:00:1e.0: PCI bridge to [bus 06]
> [    0.405110] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
> [    0.405139] pci 0000:00:1e.0:   bridge window [mem 0xfbb00000-0xfbbfff=
ff]
> [    0.405173] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
> [    0.405174] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
> [    0.405175] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
> [    0.405176] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
> [    0.405178] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff win=
dow]
> [    0.405179] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff win=
dow]
> [    0.405180] pci_bus 0000:00: resource 10 [mem 0xbfa00000-0xffffffff wi=
ndow]
> [    0.405181] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> [    0.405183] pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbdfffff]
> [    0.405184] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64b=
it pref]
> [    0.405185] pci_bus 0000:02: resource 1 [mem 0xfb800000-0xfbafffff]
> [    0.405186] pci_bus 0000:03: resource 1 [mem 0xfb800000-0xfbafffff]
> [    0.405188] pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
> [    0.405189] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
> [    0.405190] pci_bus 0000:06: resource 1 [mem 0xfbb00000-0xfbbfffff]
> [    0.405191] pci_bus 0000:06: resource 4 [io  0x0000-0x03af window]
> [    0.405192] pci_bus 0000:06: resource 5 [io  0x03e0-0x0cf7 window]
> [    0.405193] pci_bus 0000:06: resource 6 [io  0x03b0-0x03df window]
> [    0.405194] pci_bus 0000:06: resource 7 [io  0x0d00-0xffff window]
> [    0.405196] pci_bus 0000:06: resource 8 [mem 0x000a0000-0x000bffff win=
dow]
> [    0.405197] pci_bus 0000:06: resource 9 [mem 0x000c0000-0x000dffff win=
dow]
> [    0.405198] pci_bus 0000:06: resource 10 [mem 0xbfa00000-0xffffffff wi=
ndow]
> [    0.425395] NET: Registered protocol family 2
> [    0.443428] TCP established hash table entries: 262144 (order: 9, 2097=
152 bytes)
> [    0.443779] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
> [    0.443917] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.443955] UDP hash table entries: 16384 (order: 7, 524288 bytes)
> [    0.444046] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
> [    0.461394] NET: Registered protocol family 1
> [    0.467397] RPC: Registered named UNIX socket transport module.
> [    0.467430] RPC: Registered udp transport module.
> [    0.467458] RPC: Registered tcp transport module.
> [    0.467492] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.467526] pmd_set_huge: Cannot satisfy [mem 0xfb400000-0xfb600000] w=
ith a huge-page mapping due to MTRR override.
> [    0.467572] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; =
disabling
> [    0.467619] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0=
x000c0000-0x000dffff]
> [    0.814600] PCI: CLS 64 bytes, default 64
> [    0.819398] DMAR: Host address width 36
> [    0.819427] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.819464] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e6=
0262 ecap f0101a
> [    0.819512] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.819536] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c900802066=
0262 ecap f0105a
> [    0.819573] DMAR: RMRR base: 0x000000bcbac000 end: 0x000000bcbbafff
> [    0.819596] DMAR: RMRR base: 0x000000bd800000 end: 0x000000bf9fffff
> [    0.819625] DMAR: No ATSR found
> [    0.819886] DMAR: dmar0: Using Queued invalidation
> [    0.819916] DMAR: dmar1: Using Queued invalidation
> [    0.820165] DMAR: Setting RMRR:
> [    0.820215] DMAR: Setting identity map for device 0000:00:02.0 [0xbd80=
0000 - 0xbf9fffff]
> [    0.820447] DMAR: Setting identity map for device 0000:00:1a.0 [0xbcba=
c000 - 0xbcbbafff]
> [    0.820513] DMAR: Setting identity map for device 0000:00:1d.0 [0xbcba=
c000 - 0xbcbbafff]
> [    0.820558] DMAR: Prepare 0-16MiB unity mapping for LPC
> [    0.820603] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - =
0xffffff]
> [    0.820847] DMAR: Intel(R) Virtualization Technology for Directed I/O
> [    0.820922] iommu: Adding device 0000:00:00.0 to group 0
> [    0.820962] iommu: Adding device 0000:00:01.0 to group 1
> [    0.820990] iommu: Adding device 0000:00:02.0 to group 2
> [    0.821025] iommu: Adding device 0000:00:16.0 to group 3
> [    0.821052] iommu: Adding device 0000:00:16.2 to group 3
> [    0.821080] iommu: Adding device 0000:00:16.3 to group 3
> [    0.821108] iommu: Adding device 0000:00:19.0 to group 4
> [    0.821136] iommu: Adding device 0000:00:1a.0 to group 5
> [    0.821842] iommu: Adding device 0000:00:1b.0 to group 6
> [    0.821871] iommu: Adding device 0000:00:1c.0 to group 7
> [    0.821899] iommu: Adding device 0000:00:1c.6 to group 8
> [    0.821928] iommu: Adding device 0000:00:1d.0 to group 9
> [    0.821957] iommu: Adding device 0000:00:1e.0 to group 10
> [    0.821992] iommu: Adding device 0000:00:1f.0 to group 11
> [    0.822021] iommu: Adding device 0000:00:1f.2 to group 11
> [    0.822049] iommu: Adding device 0000:00:1f.3 to group 11
> [    0.822074] iommu: Adding device 0000:01:00.0 to group 1
> [    0.822099] iommu: Adding device 0000:01:00.1 to group 1
> [    0.822132] iommu: Adding device 0000:02:00.0 to group 12
> [    0.822161] iommu: Adding device 0000:02:00.2 to group 12
> [    0.822185] iommu: Adding device 0000:03:0e.0 to group 12
> [    0.822214] iommu: Adding device 0000:05:00.0 to group 13
> [    0.822239] iommu: Adding device 0000:06:00.0 to group 10
> [    0.822264] iommu: Adding device 0000:06:00.1 to group 10
> [    0.823425] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 1638=
40 ms ovfl timer
> [    0.823461] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
> [    0.823484] RAPL PMU: hw unit of domain package 2^-16 Joules
> [    0.823506] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
> [    0.846544] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    0.846587] audit: initializing netlink subsys (disabled)
> [    0.846617] audit: type=3D2000 audit(1470037650.837:1): initialized
> [    0.846866] workingset: timestamp_bits=3D60 max_order=3D23 bucket_orde=
r=3D0
> [    0.846899] zbud: loaded
> [    0.959402] NILFS version 2 loaded
> [    0.970417] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 250)
> [    0.970469] io scheduler noop registered
> [    0.970500] io scheduler deadline registered
> [    0.974400] io scheduler cfq registered (default)
> [    0.974767] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
> [    0.974809] ACPI: Power Button [PWRB]
> [    0.974857] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
> [    0.974898] ACPI: Power Button [PWRF]
> [    0.975058] Monitor-Mwait will be used to enter C-2 state
> [    0.975061] Monitor-Mwait will be used to enter C-3 state
> [    0.975817] Linux agpgart interface v0.103
> [    0.975863] [drm] Initialized drm 1.1.0 20060810
> [    0.980818] [drm] DMAR active, disabling use of stolen memory
> [    0.980842] [drm] Memory usable by graphics device =3D 2048M
> [    0.980865] [drm] VT-d active for gfx access
> [    0.980885] [drm] Disabling PPGTT because VT-d is on
> [    0.980907] [drm] Replacing VGA console driver
> [    0.981415] Console: switching to colour dummy device 80x25
> [    0.987472] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    0.987480] [drm] Driver supports precise vblank timestamp query.
> [    0.989667] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
> [    0.993003] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on =
minor 0
> [    0.994285] loop: module loaded
> [    0.999606] Adaptec aacraid driver 1.2-1[41066]-ms
> [    0.999812] aacraid 0000:03:0e.0: Changed firmware to INTX mode
> [    1.203668] AAC0: kernel 5.2-0[17342] Aug  4 2010
> [    1.203672] AAC0: monitor 5.2-0[17342]
> [    1.203675] AAC0: bios 5.2-0[17342]
> [    1.203678] AAC0: serial 7C36110C3E2
> [    1.203680] AAC0: Non-DASD support enabled.
> [    1.203682] AAC0: 64bit support enabled.
> [    1.203685] AAC0: 64 Bit DAC enabled
> [    1.210846] scsi host0: aacraid
> [    1.211129] ahci 0000:00:1f.2: version 3.0
> [    1.221344] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps =
0x3f impl SATA mode
> [    1.221351] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio sl=
um part ems sxs apst=20
> [    1.231776] scsi host1: ahci
> [    1.231871] scsi host2: ahci
> [    1.231953] scsi host3: ahci
> [    1.232047] scsi host4: ahci
> [    1.232132] scsi host5: ahci
> [    1.232216] scsi host6: ahci
> [    1.232266] ata1: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
100 irq 28
> [    1.232272] ata2: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
180 irq 28
> [    1.232277] ata3: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
200 irq 28
> [    1.232284] ata4: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
280 irq 28
> [    1.232289] ata5: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
300 irq 28
> [    1.232295] ata6: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe25=
380 irq 28
> [    1.232341] tun: Universal TUN/TAP device driver, 1.6
> [    1.232343] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    1.232383] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    1.232386] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    1.232533] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
> [    1.281141] fbcon: inteldrmfb (fb0) is primary device
> [    1.333233] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): register=
ed PHC clock
> [    1.434814] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 0=
0:22:4d:54:74:d1
> [    1.434815] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connec=
tion
> [    1.434867] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF=
-0FF
> [    1.434984] VFIO - User Level meta-driver version: 0.3
> [    1.435269] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecode=
s=3Dio+mem,decodes=3Dio+mem:owns=3Dnone
> [    1.445444] vfio_pci: add [1002:9460[ffff:ffff]] class 0x000000/000000=
00
> [    1.456438] vfio_pci: add [1002:aa30[ffff:ffff]] class 0x000000/000000=
00
> [    1.467446] vfio_pci: add [8086:1c26[ffff:ffff]] class 0x000000/000000=
00
> [    1.467448] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.467448] ehci-pci: EHCI PCI platform driver
> [    1.467563] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    1.467569] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
> [    1.467582] ehci-pci 0000:00:1a.0: debug port 2
> [    1.471483] ehci-pci 0000:00:1a.0: cache line size of 64 is not suppor=
ted
> [    1.471492] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfbe27000
> [    1.477445] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    1.477625] hub 1-0:1.0: USB hub found
> [    1.477631] hub 1-0:1.0: 3 ports detected
> [    1.477722] ehci-platform: EHCI generic platform driver
> [    1.477730] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.477733] ohci-pci: OHCI PCI platform driver
> [    1.477740] ohci-platform: OHCI generic platform driver
> [    1.477745] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.477800] xhci_hcd 0000:05:00.0: xHCI Host Controller
> [    1.477803] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bu=
s number 2
> [    1.478009] xhci_hcd 0000:05:00.0: hcc params 0x014042cb hci version 0=
x96 quirks 0x00000004
> [    1.478289] hub 2-0:1.0: USB hub found
> [    1.478300] hub 2-0:1.0: 2 ports detected
> [    1.478365] xhci_hcd 0000:05:00.0: xHCI Host Controller
> [    1.478367] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bu=
s number 3
> [    1.481397] usb usb3: We don't know the algorithms for LPM for this ho=
st, disabling LPM.
> [    1.481538] hub 3-0:1.0: USB hub found
> [    1.481549] hub 3-0:1.0: 2 ports detected
> [    1.481632] usbcore: registered new interface driver cdc_acm
> [    1.481633] cdc_acm: USB Abstract Control Model driver for USB modems =
and ISDN adapters
> [    1.481647] usbcore: registered new interface driver usb-storage
> [    1.481659] usbcore: registered new interface driver usbserial
> [    1.481665] usbcore: registered new interface driver ftdi_sio
> [    1.481669] usbserial: USB Serial support registered for FTDI USB Seri=
al Device
> [    1.481709] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
> [    1.484924] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.484928] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.485055] mousedev: PS/2 mouse device common for all mice
> [    1.485230] rtc_cmos 00:02: RTC can wake from S4
> [    1.485355] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    1.485384] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
> [    1.485390] md: raid0 personality registered for level 0
> [    1.485390] md: raid1 personality registered for level 1
> [    1.491555] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialise=
d: dm-devel@redhat.com
> [    1.491566] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.517875] Netfilter messages via NETLINK v0.30.
> [    1.517881] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
> [    1.517882] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfil=
ter.org>
> [    1.517919] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.517935] NET: Registered protocol family 17
> [    1.517939] NET: Registered protocol family 37
> [    1.518093] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    1.518098] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    1.518101] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    1.518108] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    1.518127] microcode: Microcode Update Driver: v2.01 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
> [    1.518133] AVX version of gcm_enc/dec engaged.
> [    1.518133] AES CTR mode by8 optimization enabled
> [    1.518533] registered taskstats version 1
> [    1.518544] zswap: loaded using pool lzo/zbud
> [    1.535008] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.535078] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.535096] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.535532] ata1.00: ATA-8: KINGSTON SNV425S264GB, C091126a, max UDMA/=
100
> [    1.535534] ata1.00: 125045424 sectors, multi 16: LBA48=20
> [    1.535925] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.536031] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.536046] ata1.00: configured for UDMA/100
> [    1.536147] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.536164] ata3.00: ATA-8: ST3500418AS, CC49, max UDMA/133
> [    1.536166] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
> [    1.537241] ata5.00: NCQ Send/Recv Log not supported
> [    1.537242] ata5.00: ATA-9: SAMSUNG MZMTD128HAFV-000, DXT41K0Q, max UD=
MA/133
> [    1.537243] ata5.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
> [    1.537340] ata2.00: ATA-8: WDC WD7500BPKT-75PK4T0, 01.01A01, max UDMA=
/133
> [    1.537341] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31=
/32), AA
> [    1.537485] ata6.00: HPA detected: current 976771055, native 976773168
> [    1.537488] ata6.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
> [    1.537489] ata6.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
> [    1.537528] ata3.00: configured for UDMA/133
> [    1.537656] ata5.00: NCQ Send/Recv Log not supported
> [    1.537727] ata5.00: configured for UDMA/133
> [    1.539084] ata4.00: ATA-8: WDC WD7500BPKT-22PK4T0, 01.01A01, max UDMA=
/133
> [    1.539086] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31=
/32), AA
> [    1.539457] ata6.00: configured for UDMA/133
> [    1.539971] ata2.00: configured for UDMA/133
> [    1.541613] ata4.00: configured for UDMA/133
> [    1.598430] Btrfs loaded, crc32c=3Dcrc32c-generic
> [    1.598430] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
> [    1.598431] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
> [    1.598431] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
> [    1.598431] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
> [    1.598432] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
> [    1.598626] Key type encrypted registered
> [    1.599106] rtc_cmos 00:02: setting system clock to 2016-08-01 07:47:3=
2 UTC (1470037652)
> [    1.599154] ALSA device list:
> [    1.599154]   #0: SB Live! 5.1 (rev.10, serial:0x80641102) at 0xd000, =
irq 16
> [    1.630687] Console: switching to colour frame buffer device 240x67
> [    1.713978] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    1.718547] scsi 1:0:0:0: Direct-Access     ATA      KINGSTON SNV425S =
126a PQ: 0 ANSI: 5
> [    1.730563] sd 1:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0=
 GB/59.6 GiB)
> [    1.730637] sd 1:0:0:0: Attached scsi generic sg0 type 0
> [    1.730794] scsi 2:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-7 =
1A01 PQ: 0 ANSI: 5
> [    1.734217] sd 1:0:0:0: [sda] Write Protect is off
> [    1.735443] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.735451] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.740005]  sda: sda1 sda2 sda3 sda4
> [    1.741490] sd 1:0:0:0: [sda] Attached SCSI disk
> [    1.744541] sd 2:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750=
 GB/699 GiB)
> [    1.744552] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [    1.744657] scsi 3:0:0:0: Direct-Access     ATA      ST3500418AS      =
CC49 PQ: 0 ANSI: 5
> [    1.748289] sd 2:0:0:0: [sdb] 4096-byte physical blocks
> [    1.749545] sd 2:0:0:0: [sdb] Write Protect is off
> [    1.750782] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.750789] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.756528] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 =
GB/466 GiB)
> [    1.756609] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [    1.756840] scsi 4:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-2 =
1A01 PQ: 0 ANSI: 5
> [    1.760299] sd 3:0:0:0: [sdc] Write Protect is off
> [    1.761573] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.761579] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.768542] sd 4:0:0:0: [sdd] 1465149168 512-byte logical blocks: (750=
 GB/699 GiB)
> [    1.768557] sd 4:0:0:0: Attached scsi generic sg3 type 0
> [    1.768640] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG MZMTD128 =
1K0Q PQ: 0 ANSI: 5
> [    1.772503] sd 4:0:0:0: [sdd] 4096-byte physical blocks
> [    1.773848] sd 4:0:0:0: [sdd] Write Protect is off
> [    1.775164] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [    1.775169] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.779421] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    1.782533] sd 5:0:0:0: [sde] 250069680 512-byte logical blocks: (128 =
GB/119 GiB)
> [    1.782558] sd 5:0:0:0: Attached scsi generic sg4 type 0
> [    1.782667] scsi 6:0:0:0: Direct-Access     ATA      ST3500320AS      =
SD1A PQ: 0 ANSI: 5
> [    1.782809]  sdc: sdc1 sdc2 sdc3 sdc4
> [    1.783097] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    1.789403] sd 5:0:0:0: [sde] Write Protect is off
> [    1.790784] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [    1.790792] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.795518] sd 6:0:0:0: [sdf] 976771055 512-byte logical blocks: (500 =
GB/466 GiB)
> [    1.795528] sd 6:0:0:0: Attached scsi generic sg5 type 0
> [    1.796249]  sde: sde1
> [    1.796349] sd 5:0:0:0: [sde] Attached SCSI removable disk
> [    1.801138] sd 6:0:0:0: [sdf] Write Protect is off
> [    1.802533] sd 6:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [    1.802539] sd 6:0:0:0: [sdf] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
> [    1.811867]  sdf: sdf1 sdf2 sdf3 sdf4
> [    1.813571] sd 6:0:0:0: [sdf] Attached SCSI removable disk
> [    1.843418] tsc: Refined TSC clocksource calibration: 3092.973 MHz
> [    1.844867] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2=
c95594edb3, max_idle_ns: 440795220223 ns
> [    1.895343] hub 1-1:1.0: USB hub found
> [    1.897027] hub 1-1:1.0: 6 ports detected
> [    2.123348]  sdb: sdb1
> [    2.124918] sd 2:0:0:0: [sdb] Attached SCSI disk
> [    2.174450] usb 1-1.5: new high-speed USB device number 3 using ehci-p=
ci
> [    2.178183]  sdd: sdd1
> [    2.179797] sd 4:0:0:0: [sdd] Attached SCSI disk
> [    2.181272] md: Waiting for all devices to be available before autodet=
ect
> [    2.182728] md: If you don't use raid, use raid=3Dnoautodetect
> [    2.184311] md: Autodetecting RAID arrays.
> [    2.203450] AAC: Host adapter dead -1
> [    2.207022] md: invalid raid superblock magic on sdc3
> [    2.208518] md: sdc3 does not have a valid v0.90 superblock, not impor=
ting!
> [    2.251598] hub 1-1.5:1.0: USB hub found
> [    2.253070] md: invalid raid superblock magic on sdf3
> [    2.253071] md: sdf3 does not have a valid v0.90 superblock, not impor=
ting!
> [    2.256207] hub 1-1.5:1.0: 4 ports detected
> [    2.269772] md: Scanned 8 and added 6 devices.
> [    2.271324] md: autorun ...
> [    2.272824] md: considering sdf4 ...
> [    2.274318] md:  adding sdf4 ...
> [    2.275797] md: sdf2 has different UUID to sdf4
> [    2.277272] md: sdf1 has different UUID to sdf4
> [    2.278732] md:  adding sdc4 ...
> [    2.280178] md: sdc2 has different UUID to sdf4
> [    2.281618] md: sdc1 has different UUID to sdf4
> [    2.283144] md: created md124
> [    2.284553] md: bind<sdc4>
> [    2.285949] md: bind<sdf4>
> [    2.287331] md: running: <sdf4><sdc4>
> [    2.288856] md/raid1:md124: active with 2 out of 2 mirrors
> [    2.290236] md124: detected capacity change from 0 to 464588374016
> [    2.291603] md: considering sdf2 ...
> [    2.292955] md:  adding sdf2 ...
> [    2.294294] md: sdf1 has different UUID to sdf2
> [    2.295620] md:  adding sdc2 ...
> [    2.296948] md: sdc1 has different UUID to sdf2
> [    2.298369] md: created md1
> [    2.299689] md: bind<sdc2>
> [    2.300991] md: bind<sdf2>
> [    2.302273] md: running: <sdf2><sdc2>
> [    2.303732] md/raid1:md1: active with 2 out of 2 mirrors
> [    2.305014] md1: detected capacity change from 0 to 34365112320
> [    2.306282] md: considering sdf1 ...
> [    2.307535] md:  adding sdf1 ...
> [    2.308772] md:  adding sdc1 ...
> [    2.309989] md: created md0
> [    2.311203] md: bind<sdc1>
> [    2.312410] md: bind<sdf1>
> [    2.313641] md: running: <sdf1><sdc1>
> [    2.315109] md/raid1:md0: active with 2 out of 2 mirrors
> [    2.316304] md0: detected capacity change from 0 to 65667072
> [    2.317478] md: ... autorun DONE.
> [    2.319890] NILFS: Can't find nilfs on dev sda4.
> [    2.321985] BTRFS: device label RUT devid 1 transid 54387 /dev/root
> [    2.323982] BTRFS info (device sda4): disk space caching is enabled
> [    2.325178] BTRFS info (device sda4): has skinny extents
> [    2.339424] usb 1-1.6: new low-speed USB device number 4 using ehci-pci
> [    2.352779] BTRFS info (device sda4): detected SSD devices, enabling S=
SD mode
> [    2.362434] VFS: Mounted root (btrfs filesystem) on device 0:14.
> [    2.364343] Freeing unused kernel memory: 880K (ffffffff81c81000 - fff=
fffff81d5d000)
> [    2.365521] Write protecting the kernel read-only data: 12288k
> [    2.366938] Freeing unused kernel memory: 228K (ffff8800017c7000 - fff=
f880001800000)
> [    2.370605] Freeing unused kernel memory: 1500K (ffff880001a89000 - ff=
ff880001c00000)
> [    2.532437] usb 1-1.5.1: new full-speed USB device number 5 using ehci=
-pci
> [    2.819844] random: systemd-udevd urandom read with 31 bits of entropy=
 available
> [    2.846895] clocksource: Switched to clocksource tsc
> [    2.867009] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    2.870480] e1000e 0000:00:19.0 eno1: renamed from eth0
> [    2.887588] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
> [    2.889780] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    2.891138] input: Logitech USB Keyboard as /devices/pci0000:00/0000:0=
0:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:046D:C31C.0001/input/input5
> [    2.912371] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq =3D 17, base_baud =
=3D 115200) is a 16550A
> [    2.941479] hid-generic 0003:046D:C31C.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input0
> [    2.947706] input: Logitech USB Keyboard as /devices/pci0000:00/0000:0=
0:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:046D:C31C.0002/input/input6
> [    2.998608] hid-generic 0003:046D:C31C.0002: input,hidraw1: USB HID v1=
=2E10 Device [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input1
> [    3.001963] input: Telink 2.4G Mouse as /devices/pci0000:00/0000:00:1a=
=2E0/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/0003:248A:8366.0003/input/input7
> [    3.005051] BTRFS: device label RUT devid 1 transid 177468 /dev/sda2
> [    3.011705] md: bind<sdf3>
> [    3.013792] md: bind<sdc3>
> [    3.017028] md/raid0:md2: md_size is 4235264 sectors.
> [    3.017031] md: RAID0 configuration for md2 - 1 zone
> [    3.017032] md: zone0=3D[sdc3/sdf3]
> [    3.017035]       zone-offset=3D         0KB, device-offset=3D        =
 0KB, size=3D   2117632KB
> [    3.017046] md2: detected capacity change from 0 to 2168455168
> [    3.052588] hid-generic 0003:248A:8366.0003: input,hidraw2: USB HID v1=
=2E11 Mouse [Telink 2.4G Mouse] on usb-0000:00:1a.0-1.5.1/input0
> [    3.052606] usbcore: registered new interface driver usbhid
> [    3.052607] usbhid: USB HID core driver
> [    3.070835] BTRFS: device label STORAZ devid 1 transid 2876 /dev/sdb1
> [    3.080198] BTRFS: device label STORAZ devid 2 transid 2876 /dev/sdd1
> [    3.098429] AAC: Host adapter dead -1
> [    4.893589] Adding 2117628k swap on /dev/md2.  Priority:1 extents:1 ac=
ross:2117628k FS
> [    4.895065] Adding 2097148k swap on /dev/sda3.  Priority:5 extents:1 a=
cross:2097148k SSFS
> [    4.973960] EXT4-fs (md124): mounted filesystem with ordered data mode=
=2E Opts: (null)
> [    5.012151] BTRFS info (device sdd1): use lzo compression
> [    5.012156] BTRFS info (device sdd1): disk space caching is enabled
> [    5.012158] BTRFS info (device sdd1): has skinny extents
> [    6.607468] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    6.608154] microcode: CPU0 updated to revision 0x29, date =3D 2013-06=
-12
> [    6.608420] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    6.608833] microcode: CPU1 updated to revision 0x29, date =3D 2013-06=
-12
> [    6.609130] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    6.609538] microcode: CPU2 updated to revision 0x29, date =3D 2013-06=
-12
> [    6.609831] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
> [    6.610240] microcode: CPU3 updated to revision 0x29, date =3D 2013-06=
-12
> [    7.661464] NET: Registered protocol family 10
> [    7.661866] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
> [    9.970839] random: nonblocking pool is initialized
> [   10.700517] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Co=
ntrol: Rx/Tx
> [   10.700568] IPv6: ADDRCONF(NETDEV_CHANGE): eno1: link becomes ready
> [   13.098488] AAC: Host adapter dead -1
> [   13.491516] AAC: Host adapter dead -1
> [   23.491563] AAC: Host adapter dead -1
> [   33.491651] AAC: Host adapter dead -1
> [   43.491711] AAC: Host adapter dead -1
> [   53.491777] AAC: Host adapter dead -1
> [   63.491839] AAC: Host adapter dead -1
> [   73.491882] AAC: Host adapter dead -1
> [   83.491969] AAC: Host adapter dead -1




> _______________________________________________
> vfio-users mailing list
> vfio-users@redhat.com
> https://www.redhat.com/mailman/listinfo/vfio-users


--=20
 - Mysle, ze za bardzo martwisz sie o tygrysy,  ktorych tu wcale nie ma
- powiedzial. - Tygrys ma pasy, ktore pozwalaja mu sie ukryc w dzungli,
tak ze nikt go nie widzi. A przerazony czlowiek widzi tygrysy wszedzie.
  -- Stephen King, "The Dead Zone"

--ztcJpsdPpsnnlAp8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXo1wMAAoJEEMpAov1cw9lZWIQAMFGjEY7MW6BRDP85BlKRoyh
65greDNbjsSQcIaxp+9BBoglnYD+bgBuDjx+dW/Z7lkmGSkDksWoLSqz58YQt8iD
mUnmpjd8trtu2Qqq2wbvqLzdXNzcnSKca9kBka13aySp9Ula6MDTKQ4YaErrSYhe
htHWBUxRx0W2glR5eq+7HBSNTnkp1vtlhfQ+YMREOedmUOOYqX1Ib0fHMiv4J793
CqhZG2+ekaLxFe37OOFPf2W8CrsOZC75EHiDWEbehbu6JiApazRx98VQf2/sWKWZ
Fcv6Aw3mzxV2SsQ/+HAV8f+8VpEz8mDCXbXu0InacGjH5DD+XW1T/R65MZWxZVyp
WIBPIakxe7mg33pIcFJuNCBbMJsc9zhj7rsQ6MOwM76gli3IT+oPYqFzSoIYl4Th
7V6GIgMg1rNwFtqFXqv1l7I3GllXjSz1cwDX1mbd3xe1zjv5Ux9Lqgpe9FCfN4Re
b5bd9ebrpAdFdzWagmKPmIRDXHuZxsnWNCZ4DAAIDe8jnpbxWn+Aoovp7tShxZTS
MXwJvTHWFZZPunFLQXhdty9ndEMmpeCAiYPxqT6grZ6eThDma4qnqHeEiJsEPmyO
0gUUPWm7vNYA/WDK77NtNjNS2POmBTcrpR91l0rpdtlUGHJlZjjgCWEPkKGgXleb
vq9tH6UvacRGRaxho9ga
=PWtP
-----END PGP SIGNATURE-----

--ztcJpsdPpsnnlAp8--
