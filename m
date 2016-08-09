From: Piotr Szymaniak <szarpaj@grubelek.pl>
Subject: Re: aacraid / Adaptec 3805 - AAC: Host adapter dead -1
Date: Tue, 9 Aug 2016 21:38:39 +0200
Message-ID: <20160809193839.GB3226@pontus.sran>
References: <20160801094224.GW3226@pontus.sran>
 <20160804151524.GA3226@pontus.sran>
 <423FD6710FB8FB4F8728F93591889F9A15FA63B8@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6sj9mcRtP+pTWLOo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moh3-ve3.go2.pl ([193.17.41.87]:57969 "EHLO moh3-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbcHITiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2016 15:38:46 -0400
Received: from moh3-ve3.go2.pl (unknown [10.0.0.158])
	by moh3-ve3.go2.pl (Postfix) with ESMTP id 770BEB5A036
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2016 21:38:43 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
	by moh3-ve3.go2.pl (Postfix) with SMTP
	for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2016 21:38:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A15FA63B8@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Carroll <david.carroll@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vfio-users@redhat.com" <vfio-users@redhat.com>, "aacraid@adaptec.com" <aacraid@adaptec.com>


--6sj9mcRtP+pTWLOo
Content-Type: multipart/mixed; boundary="7gLe/sNPhR777EPF"
Content-Disposition: inline


--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 08, 2016 at 06:02:19PM +0000, David Carroll wrote:
> > On Mon, Aug 01, 2016 at 11:42:24AM +0200, Piotr Szymaniak wrote:
> > > Hi,
> >=20
> > (Sorry, for almost-topposting. Leaving below for reference.)
> >=20
> > As a followup to this thread - looking for answers here and there
> > I've added intel_iommu=3Digfx_off (found at some thread with some
> > other hardware mentioning Sandy Bridge) and it seems to work - just
> > transfered 300 gigabytes of data to a testing array. On the other
> > hand it still fills logs with those over and over every 10 seconds:
> > AAC: Host adapter dead -1
> >=20
> > I'm using Intel i5-2400 with Intel DQ67SW motherboard.
> >=20
> > I've also tried various Live Linux 64-bit distros: 1/2. Arch Bang
> > (4.6.4-1-ARCH) and Ubuntu 16.04.1 (4.4.0-31-generic #50-Ubuntu) -
> > prints errors every 10 seconds (afair didnt test if it works as I
> > expected it doesnt) 3. Ubuntu 14.04 (4.4.0-15-generic #31-Ubuntu) -
> > doesnt print errors, works
> >=20
>=20
> Hi Piotr,
>=20
> You had indicated that a kernel using Alex Williamson's patch allowed
> you to use the system correctly. Is that true?

Hi David,

I had to review my findings as I was a bit lost after trying so many
different settings and Live distros. With intel_iommu=3Digfx_off on
vanilla 4.7.0 kernel:
- it works (Gentoo Linux) with Alex patch
- it doesnt work (Gentoo Linux) without Alex patch

Both working and not working dmesg attached.


> You also indicated that Ubuntu 14.04 worked, while 16.04 did not. Is
> that true?

Ubuntu 14.04 (and speaking here about Ubuntu I mean running amd64 image
=66rom usb stick - not sure, but I think it is 14.04.4 as it was latest
available week+ ago) it doesnt print "AAC: Host adapter dead -1" and it
works.

Ubuntu 16.04 (as above, it is 16.04.1) every 10 seconds prints about
"dead adapter", but works. When I've added intel_iommu=3Don on boot it
doesnt work (similar DMAR errors as posted in dmesg without Alex patch).

(both Ubuntus are amd64)


> Looking at the aacraid driver shipped with the Ubuntu flavors seems to
> be the same version of the driver. Do either of those kernel's have
> Alex's patch applied for the 3805?

I just used Live images so, sadly, I just dont know.


> At this point, assuming the above statements are true, I would believe
> that you would get the best results when using a kernel with Alex's
> patches applied.

Yeah, but I would love to get rid of those messages printed every ~10
seconds or at least know why they're there if adapter seems to work
fine? If Ubuntu 14.04 and 16.04 share the same driver why one of them
prints those messages and the other doesnt?


Best regards,
Piotr Szymaniak.



>=20
> Thanks, -Dave
>=20
> > Further help appreciated.
> >=20
> > linux-scsi@v.k.o please CC me as I'm not subscribed, thanks.
> >=20
> >=20
> > Best regards,
> > Piotr Szymaniak.
> >=20
> >=20
> >=20
> > > I have some issues with Adaptec 3805 and found that it could be
> > > related to iommu as described here [1]. I've tried various (iommu=3Dpt
> > > etc.) but nothing seems to change the behaviour of the controller.
> > > Also tried the patch [2] from Alex Williamson on top of 4.6.5.
> > > Controller seems to work fine (random r/w) for some hours under Windo=
ws 7
> > or (on the same machine) with Clonezilla.
> > >
> > > Every 10 seconds my dmesg fills with:
> > > AAC: Host adapter dead -1
> > >
> > > Not sure about the state now (as I tried rebuilding kernel with some
> > > more PCI related options, various iommu lines in grub etc), but I
> > > could read the array (dd if=3Dcontroller of=3D/dev/null), but not wri=
te.
> > > With dd write, trying to make fs or partition or whatever it ended wi=
th
> > messages similar to this:
> > > DMAR: DRHD: handling fault status reg 3
> > > DMAR: DMAR:[DMA Write] Request device [03:01.0] fault addr ffbb5000
> > > DMAR:[fault reason 02] Present bit in context entry is clear
>=20

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-alex-4.7"
Content-Transfer-Encoding: quoted-printable

[    0.409490] pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.409491] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.409493] pci_bus 0000:06: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    0.409494] pci_bus 0000:06: resource 4 [io  0x0000-0x03af window]
[    0.409495] pci_bus 0000:06: resource 5 [io  0x03e0-0x0cf7 window]
[    0.409496] pci_bus 0000:06: resource 6 [io  0x03b0-0x03df window]
[    0.409497] pci_bus 0000:06: resource 7 [io  0x0d00-0xffff window]
[    0.409499] pci_bus 0000:06: resource 8 [mem 0x000a0000-0x000bffff windo=
w]
[    0.409500] pci_bus 0000:06: resource 9 [mem 0x000c0000-0x000dffff windo=
w]
[    0.409501] pci_bus 0000:06: resource 10 [mem 0xbfa00000-0xffffffff wind=
ow]
[    0.430673] NET: Registered protocol family 2
[    0.449709] TCP established hash table entries: 262144 (order: 9, 209715=
2 bytes)
[    0.450059] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.450196] TCP: Hash tables configured (established 262144 bind 65536)
[    0.450234] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.450321] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.467674] NET: Registered protocol family 1
[    0.473678] RPC: Registered named UNIX socket transport module.
[    0.473709] RPC: Registered udp transport module.
[    0.473737] RPC: Registered tcp transport module.
[    0.473771] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.473811] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; di=
sabling
[    0.473859] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    0.819902] PCI: CLS 64 bytes, default 64
[    0.824701] DMAR: Host address width 36
[    0.824729] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.824766] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e602=
62 ecap f0101a
[    0.824815] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.824839] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c90080206602=
62 ecap f0105a
[    0.824876] DMAR: RMRR base: 0x000000bcbac000 end: 0x000000bcbbafff
[    0.824900] DMAR: RMRR base: 0x000000bd800000 end: 0x000000bf9fffff
[    0.824929] DMAR: No ATSR found
[    0.825193] DMAR: dmar0: Using Queued invalidation
[    0.825223] DMAR: dmar1: Using Queued invalidation
[    0.825473] DMAR: Setting RMRR:
[    0.825523] DMAR: Setting identity map for device 0000:00:02.0 [0xbd8000=
00 - 0xbf9fffff]
[    0.825755] DMAR: Setting identity map for device 0000:00:1a.0 [0xbcbac0=
00 - 0xbcbbafff]
[    0.825822] DMAR: Setting identity map for device 0000:00:1d.0 [0xbcbac0=
00 - 0xbcbbafff]
[    0.825867] DMAR: Prepare 0-16MiB unity mapping for LPC
[    0.826572] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - 0x=
ffffff]
[    0.826903] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.826981] iommu: Adding device 0000:00:00.0 to group 0
[    0.827017] iommu: Adding device 0000:00:01.0 to group 1
[    0.827047] iommu: Adding device 0000:00:02.0 to group 2
[    0.827082] iommu: Adding device 0000:00:16.0 to group 3
[    0.827110] iommu: Adding device 0000:00:16.2 to group 3
[    0.827138] iommu: Adding device 0000:00:16.3 to group 3
[    0.827166] iommu: Adding device 0000:00:19.0 to group 4
[    0.827195] iommu: Adding device 0000:00:1a.0 to group 5
[    0.827223] iommu: Adding device 0000:00:1b.0 to group 6
[    0.827252] iommu: Adding device 0000:00:1c.0 to group 7
[    0.827280] iommu: Adding device 0000:00:1c.6 to group 8
[    0.827309] iommu: Adding device 0000:00:1d.0 to group 9
[    0.827337] iommu: Adding device 0000:00:1e.0 to group 10
[    0.827372] iommu: Adding device 0000:00:1f.0 to group 11
[    0.827401] iommu: Adding device 0000:00:1f.2 to group 11
[    0.827430] iommu: Adding device 0000:00:1f.3 to group 11
[    0.827455] iommu: Adding device 0000:01:00.0 to group 1
[    0.827480] iommu: Adding device 0000:01:00.1 to group 1
[    0.827514] iommu: Adding device 0000:02:00.0 to group 12
[    0.827543] iommu: Adding device 0000:02:00.2 to group 12
[    0.827568] iommu: Adding device 0000:03:0e.0 to group 12
[    0.827596] iommu: Adding device 0000:05:00.0 to group 13
[    0.827621] iommu: Adding device 0000:06:00.0 to group 10
[    0.827646] iommu: Adding device 0000:06:00.1 to group 10
[    0.828766] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840=
 ms ovfl timer
[    0.828803] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
[    0.828826] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.828848] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
[    0.852848] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.852888] audit: initializing netlink subsys (disabled)
[    0.852916] audit: type=3D2000 audit(1470735632.840:1): initialized
[    0.853164] workingset: timestamp_bits=3D60 max_order=3D23 bucket_order=
=3D0
[    0.853198] zbud: loaded
[    0.963713] NILFS version 2 loaded
[    0.974722] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.974773] io scheduler noop registered
[    0.974806] io scheduler deadline registered
[    0.978718] io scheduler cfq registered (default)
[    0.979150] pcieport 0000:00:01.0: Signaling PME through PCIe PME interr=
upt
[    0.979176] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.979200] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.979226] pcie_pme 0000:00:01.0:pcie001: service driver pcie_pme loaded
[    0.979251] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interr=
upt
[    0.979276] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.979300] pci 0000:03:0e.0: Signaling PME through PCIe PME interrupt
[    0.979324] pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    0.979351] pcie_pme 0000:00:1c.0:pcie001: service driver pcie_pme loaded
[    0.979376] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interr=
upt
[    0.979401] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.979428] pcie_pme 0000:00:1c.6:pcie001: service driver pcie_pme loaded
[    0.979483] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    0.979526] ACPI: Power Button [PWRB]
[    0.979573] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.979616] ACPI: Power Button [PWRF]
[    0.979803] Monitor-Mwait will be used to enter C-2 state
[    0.979811] Monitor-Mwait will be used to enter C-3 state
[    0.980556] Linux agpgart interface v0.103
[    0.980600] [drm] Initialized drm 1.1.0 20060810
[    0.987137] [drm] DMAR active, disabling use of stolen memory
[    0.987162] [drm] Memory usable by graphics device =3D 2048M
[    0.987184] [drm] VT-d active for gfx access
[    0.987205] [drm] Disabling PPGTT because VT-d is on
[    0.987227] [drm] Replacing VGA console driver
[    0.987747] Console: switching to colour dummy device 80x25
[    0.993786] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.993793] [drm] Driver supports precise vblank timestamp query.
[    0.995906] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
[    0.999041] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on mi=
nor 0
[    1.000197] loop: module loaded
[    1.005643] ahci 0000:00:1f.2: version 3.0
[    1.015852] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3f impl SATA mode
[    1.015865] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum=
 part ems sxs apst=20
[    1.026206] scsi host0: ahci
[    1.026330] scsi host1: ahci
[    1.026442] scsi host2: ahci
[    1.026525] scsi host3: ahci
[    1.026609] scsi host4: ahci
[    1.026689] scsi host5: ahci
[    1.026757] ata1: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2510=
0 irq 31
[    1.026763] ata2: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2518=
0 irq 31
[    1.026769] ata3: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2520=
0 irq 31
[    1.026775] ata4: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2528=
0 irq 31
[    1.026780] ata5: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2530=
0 irq 31
[    1.026786] ata6: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2538=
0 irq 31
[    1.026824] tun: Universal TUN/TAP device driver, 1.6
[    1.026827] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.026872] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.026875] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.026989] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) se=
t to dynamic conservative mode
[    1.127982] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): registered=
 PHC clock
[    1.224919] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:=
22:4d:54:74:d1
[    1.224925] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connecti=
on
[    1.224977] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0=
FF
[    1.225019] VFIO - User Level meta-driver version: 0.3
[    1.225108] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dnone
[    1.235739] vfio_pci: add [1002:9460[ffff:ffff]] class 0x000000/00000000
[    1.246738] vfio_pci: add [1002:aa30[ffff:ffff]] class 0x000000/00000000
[    1.257728] vfio_pci: add [8086:1c26[ffff:ffff]] class 0x000000/00000000
[    1.257732] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.257735] ehci-pci: EHCI PCI platform driver
[    1.257802] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.257809] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    1.257826] ehci-pci 0000:00:1a.0: debug port 2
[    1.261734] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.261743] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfbe27000
[    1.267733] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.267841] hub 1-0:1.0: USB hub found
[    1.267847] hub 1-0:1.0: 3 ports detected
[    1.267942] ehci-platform: EHCI generic platform driver
[    1.267953] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.267959] ohci-pci: OHCI PCI platform driver
[    1.267969] ohci-platform: OHCI generic platform driver
[    1.267978] uhci_hcd: USB Universal Host Controller Interface driver
[    1.268032] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.268038] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 2
[    1.268254] xhci_hcd 0000:05:00.0: hcc params 0x014042cb hci version 0x9=
6 quirks 0x00000004
[    1.268476] hub 2-0:1.0: USB hub found
[    1.268486] hub 2-0:1.0: 2 ports detected
[    1.268547] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.268551] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 3
[    1.271632] usb usb3: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    1.271708] hub 3-0:1.0: USB hub found
[    1.271719] hub 3-0:1.0: 2 ports detected
[    1.271805] usbcore: registered new interface driver cdc_acm
[    1.271808] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.271826] usbcore: registered new interface driver usb-storage
[    1.271843] usbcore: registered new interface driver usbserial
[    1.271851] usbcore: registered new interface driver ftdi_sio
[    1.271859] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    1.271918] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.274897] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.274902] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.274986] mousedev: PS/2 mouse device common for all mice
[    1.275103] rtc_cmos 00:02: RTC can wake from S4
[    1.275226] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.275255] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    1.275265] md: raid0 personality registered for level 0
[    1.275267] md: raid1 personality registered for level 1
[    1.278754] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised:=
 dm-devel@redhat.com
[    1.278769] hidraw: raw HID events driver (C) Jiri Kosina
[    1.286686] fbcon: inteldrmfb (fb0) is primary device
[    1.305279] Netfilter messages via NETLINK v0.30.
[    1.305285] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    1.305285] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    1.305325] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.305341] NET: Registered protocol family 17
[    1.305344] NET: Registered protocol family 37
[    1.305500] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.305506] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.305512] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.305518] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.305538] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.305542] AVX version of gcm_enc/dec engaged.
[    1.305543] AES CTR mode by8 optimization enabled
[    1.305942] registered taskstats version 1
[    1.305952] zswap: loaded using pool lzo/zbud
[    1.330058] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330078] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330098] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330144] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330188] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330669] ata1.00: ATA-8: KINGSTON SNV425S264GB, C091126a, max UDMA/100
[    1.330672] ata1.00: 125045424 sectors, multi 16: LBA48=20
[    1.331220] ata1.00: configured for UDMA/100
[    1.331285] ata3.00: ATA-8: ST3500418AS, CC49, max UDMA/133
[    1.331286] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.331346] ata5.00: NCQ Send/Recv Log not supported
[    1.331347] ata5.00: ATA-9: SAMSUNG MZMTD128HAFV-000, DXT41K0Q, max UDMA=
/133
[    1.331347] ata5.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    1.331667] ata6.00: HPA detected: current 976771055, native 976773168
[    1.331672] ata6.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    1.331673] ata6.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.331752] ata5.00: NCQ Send/Recv Log not supported
[    1.331860] ata5.00: configured for UDMA/133
[    1.332401] ata2.00: ATA-8: WDC WD7500BPKT-75PK4T0, 01.01A01, max UDMA/1=
33
[    1.332402] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.332582] ata3.00: configured for UDMA/133
[    1.333647] ata6.00: configured for UDMA/133
[    1.334588] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.335125] ata2.00: configured for UDMA/133
[    1.336995] ata4.00: ATA-8: WDC WD7500BPKT-22PK4T0, 01.01A01, max UDMA/1=
33
[    1.336997] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.340260] ata4.00: configured for UDMA/133
[    1.388914] Btrfs loaded, crc32c=3Dcrc32c-generic
[    1.388914] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    1.388915] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    1.388915] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
[    1.388916] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
[    1.388916] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
[    1.389593] Key type encrypted registered
[    1.390140] rtc_cmos 00:02: setting system clock to 2016-08-09 09:40:34 =
UTC (1470735634)
[    1.390189] ALSA device list:
[    1.390190]   #0: SB Live! 5.1 (rev.10, serial:0x80641102) at 0xd000, ir=
q 16
[    1.569754] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.644562] Console: switching to colour frame buffer device 240x67
[    1.663425] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.667912] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SNV425S 12=
6a PQ: 0 ANSI: 5
[    1.682920] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 G=
B/59.6 GiB)
[    1.682929] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.683004] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-7 1A=
01 PQ: 0 ANSI: 5
[    1.684482] hub 1-1:1.0: USB hub found
[    1.684561] hub 1-1:1.0: 6 ports detected
[    1.688553] sd 0:0:0:0: [sda] Write Protect is off
[    1.689678] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.689686] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.693361]  sda: sda1 sda2 sda3 sda4
[    1.694726] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.694838] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 G=
B/699 GiB)
[    1.694839] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.694848] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.694850] sd 1:0:0:0: [sdb] Write Protect is off
[    1.694851] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.694857] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.694928] scsi 2:0:0:0: Direct-Access     ATA      ST3500418AS      CC=
49 PQ: 0 ANSI: 5
[    1.710924] sd 2:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/466 GiB)
[    1.710935] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.711007] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-2 1A=
01 PQ: 0 ANSI: 5
[    1.714479] sd 2:0:0:0: [sdc] Write Protect is off
[    1.715685] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.715693] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.721891] sd 3:0:0:0: [sdd] 1465149168 512-byte logical blocks: (750 G=
B/699 GiB)
[    1.721926] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.722030] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG MZMTD128 1K=
0Q PQ: 0 ANSI: 5
[    1.725245]  sdc: sdc1 sdc2 sdc3 sdc4
[    1.725496] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.728045] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    1.729288] sd 3:0:0:0: [sdd] Write Protect is off
[    1.730526] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.730532] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.741909] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    1.741916] sd 4:0:0:0: [sde] 250069680 512-byte logical blocks: (128 GB=
/119 GiB)
[    1.741932] sd 4:0:0:0: [sde] Write Protect is off
[    1.741933] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.741939] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.747155] scsi 5:0:0:0: Direct-Access     ATA      ST3500320AS      SD=
1A PQ: 0 ANSI: 5
[    1.748767]  sde: sde1
[    1.750159] sd 4:0:0:0: [sde] Attached SCSI removable disk
[    1.759881] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    1.759895] sd 5:0:0:0: [sdf] 976771055 512-byte logical blocks: (500 GB=
/466 GiB)
[    1.759909] sd 5:0:0:0: [sdf] Write Protect is off
[    1.759910] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.759916] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.767958]  sdf: sdf1 sdf2 sdf3 sdf4
[    1.769504] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[    1.849790] tsc: Refined TSC clocksource calibration: 3092.975 MHz
[    1.851154] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2c9=
55bbc01b, max_idle_ns: 440795312352 ns
[    1.958801] usb 1-1.5: new high-speed USB device number 3 using ehci-pci
[    2.045517] hub 1-1.5:1.0: USB hub found
[    2.047031] hub 1-1.5:1.0: 4 ports detected
[    2.072793]  sdb: sdb1
[    2.074333] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.121817] usb 1-1.6: new low-speed USB device number 4 using ehci-pci
[    2.127049]  sdd: sdd1
[    2.128570] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.129975] md: Waiting for all devices to be available before autodetect
[    2.131322] md: If you don't use raid, use raid=3Dnoautodetect
[    2.132857] md: Autodetecting RAID arrays.
[    2.157893] md: invalid raid superblock magic on sdc3
[    2.159279] md: sdc3 does not have a valid v0.90 superblock, not importi=
ng!
[    2.209367] md: invalid raid superblock magic on sdf3
[    2.210768] md: sdf3 does not have a valid v0.90 superblock, not importi=
ng!
[    2.234421] md: Scanned 8 and added 6 devices.
[    2.235847] md: autorun ...
[    2.237248] md: considering sdf4 ...
[    2.238642] md:  adding sdf4 ...
[    2.240027] md: sdf2 has different UUID to sdf4
[    2.241408] md: sdf1 has different UUID to sdf4
[    2.242771] md:  adding sdc4 ...
[    2.244127] md: sdc2 has different UUID to sdf4
[    2.245476] md: sdc1 has different UUID to sdf4
[    2.247052] md: created md124
[    2.248359] md: bind<sdc4>
[    2.249659] md: bind<sdf4>
[    2.250959] md: running: <sdf4><sdc4>
[    2.252473] md/raid1:md124: active with 2 out of 2 mirrors
[    2.253788] md124: detected capacity change from 0 to 464588374016
[    2.255102] md: considering sdf2 ...
[    2.256395] md:  adding sdf2 ...
[    2.257674] md: sdf1 has different UUID to sdf2
[    2.258953] md:  adding sdc2 ...
[    2.260215] md: sdc1 has different UUID to sdf2
[    2.261609] md: created md1
[    2.262883] md: bind<sdc2>
[    2.264147] md: bind<sdf2>
[    2.265390] md: running: <sdf2><sdc2>
[    2.266727] md/raid1:md1: active with 2 out of 2 mirrors
[    2.267975] md1: detected capacity change from 0 to 34365112320
[    2.269202] md: considering sdf1 ...
[    2.270405] md:  adding sdf1 ...
[    2.271604] md:  adding sdc1 ...
[    2.272784] md: created md0
[    2.273952] md: bind<sdc1>
[    2.275110] md: bind<sdf1>
[    2.276250] md: running: <sdf1><sdc1>
[    2.277619] md/raid1:md0: active with 2 out of 2 mirrors
[    2.278783] md0: detected capacity change from 0 to 65667072
[    2.279939] md: ... autorun DONE.
[    2.282199] NILFS: Can't find nilfs on dev sda4.
[    2.284098] BTRFS: device label RUT devid 1 transid 58464 /dev/root
[    2.286050] BTRFS info (device sda4): disk space caching is enabled
[    2.287188] BTRFS info (device sda4): has skinny extents
[    2.314978] BTRFS info (device sda4): detected SSD devices, enabling SSD=
 mode
[    2.321816] usb 1-1.5.1: new full-speed USB device number 5 using ehci-p=
ci
[    2.324827] VFS: Mounted root (btrfs filesystem) on device 0:14.
[    2.326679] Freeing unused kernel memory: 880K (ffffffff81c80000 - fffff=
fff81d5c000)
[    2.327815] Write protecting the kernel read-only data: 12288k
[    2.329216] Freeing unused kernel memory: 268K (ffff8800017bd000 - ffff8=
80001800000)
[    2.332847] Freeing unused kernel memory: 1504K (ffff880001a88000 - ffff=
880001c00000)
[    2.770417] random: systemd-udevd urandom read with 18 bits of entropy a=
vailable
[    2.816223] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.821428] e1000e 0000:00:19.0 eno1: renamed from eth0
[    2.828940] Adaptec aacraid driver 1.2-1[41066]-ms
[    2.833422] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:046D:C31C.0001/input/input5
[    2.834884] aacraid 0000:03:0e.0: Changed firmware to INTX mode
[    2.836816] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.861804] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq =3D 17, base_baud =3D=
 115200) is a 16550A
[    2.861844] clocksource: Switched to clocksource tsc
[    2.863573] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    2.883904] hid-generic 0003:046D:C31C.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input0
[    2.890297] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:046D:C31C.0002/input/input6
[    2.940911] hid-generic 0003:046D:C31C.0002: input,hidraw1: USB HID v1.1=
0 Device [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input1
[    2.944192] input: Telink 2.4G Mouse as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/0003:248A:8366.0003/input/input7
[    2.949580] BTRFS: device label RUT devid 1 transid 177468 /dev/sda2
[    2.956799] md: bind<sdc3>
[    2.986496] md: bind<sdf3>
[    2.988783] md/raid0:md2: md_size is 4235264 sectors.
[    2.988785] md: RAID0 configuration for md2 - 1 zone
[    2.988786] md: zone0=3D[sdc3/sdf3]
[    2.988789]       zone-offset=3D         0KB, device-offset=3D         0=
KB, size=3D   2117632KB
[    2.988796] md2: detected capacity change from 0 to 2168455168
[    2.994994] hid-generic 0003:248A:8366.0003: input,hidraw2: USB HID v1.1=
1 Mouse [Telink 2.4G Mouse] on usb-0000:00:1a.0-1.5.1/input0
[    2.995014] usbcore: registered new interface driver usbhid
[    2.995016] usbhid: USB HID core driver
[    3.020381] BTRFS: device label STORAZ devid 1 transid 2997 /dev/sdb1
[    3.021171] BTRFS: device label STORAZ devid 2 transid 2997 /dev/sdd1
[    3.039181] AAC0: kernel 5.2-0[17342] Aug  4 2010
[    3.039184] AAC0: monitor 5.2-0[17342]
[    3.039186] AAC0: bios 5.2-0[17342]
[    3.039189] AAC0: serial 7C36110C3E2
[    3.039190] AAC0: Non-DASD support enabled.
[    3.039192] AAC0: 64bit support enabled.
[    3.039194] AAC0: 64 Bit DAC enabled
[    3.046330] scsi host6: aacraid
[    3.046702] scsi 6:0:0:0: Direct-Access     Adaptec  test             V1=
=2E0 PQ: 0 ANSI: 2
[    3.061048] scsi 6:1:4:0: Direct-Access     APPLE    HDD              D7=
0F PQ: 0 ANSI: 5
[    3.088744] scsi 6:1:5:0: Direct-Access     ST975042 3AS              SD=
M1 PQ: 0 ANSI: 5
[    3.205457] sd 6:0:0:0: [sdg] 2927624192 512-byte logical blocks: (1.50 =
TB/1.36 TiB)
[    3.205464] sd 6:0:0:0: [sdg] Write Protect is off
[    3.205467] sd 6:0:0:0: [sdg] Mode Sense: 12 00 10 08
[    3.205475] sd 6:0:0:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[    3.205494] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.205613] scsi 6:1:4:0: Attached scsi generic sg7 type 0
[    3.205720] scsi 6:1:5:0: Attached scsi generic sg8 type 0
[    3.546739] sd 6:0:0:0: [sdg] Attached SCSI removable disk
[    3.720516] BTRFS: device fsid 125f10d2-fbad-46ed-a521-ad44a94b038a devi=
d 1 transid 690 /dev/sdg
[    4.038945] AAC: Host adapter dead -1
[    4.777959] Adding 2117628k swap on /dev/md2.  Priority:1 extents:1 acro=
ss:2117628k FS
[    4.779455] Adding 2097148k swap on /dev/sda3.  Priority:5 extents:1 acr=
oss:2097148k SSFS
[    4.890022] AAC: Host adapter dead -1
[    4.929117] EXT4-fs (md124): mounted filesystem with ordered data mode. =
Opts: (null)
[    4.976454] BTRFS info (device sdd1): use lzo compression
[    4.976459] BTRFS info (device sdd1): disk space caching is enabled
[    4.976461] BTRFS info (device sdd1): has skinny extents
[    5.383037] AAC: Host adapter dead -1
[    6.672006] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.672848] microcode: CPU0 updated to revision 0x29, date =3D 2013-06-12
[    6.673152] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.673560] microcode: CPU1 updated to revision 0x29, date =3D 2013-06-12
[    6.673853] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.674262] microcode: CPU2 updated to revision 0x29, date =3D 2013-06-12
[    6.674554] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.674963] microcode: CPU3 updated to revision 0x29, date =3D 2013-06-12
[    7.744198] NET: Registered protocol family 10
[    7.744600] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[   10.623514] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: Rx/Tx
[   10.623551] IPv6: ADDRCONF(NETDEV_CHANGE): eno1: link becomes ready
[   12.665816] random: nonblocking pool is initialized
[   15.383740] AAC: Host adapter dead -1
[   25.384456] AAC: Host adapter dead -1

--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-clean-4.7"
Content-Transfer-Encoding: quoted-printable

[    0.823130] iommu: Adding device 0000:00:16.3 to group 3
[    0.823160] iommu: Adding device 0000:00:19.0 to group 4
[    0.823188] iommu: Adding device 0000:00:1a.0 to group 5
[    0.823216] iommu: Adding device 0000:00:1b.0 to group 6
[    0.823245] iommu: Adding device 0000:00:1c.0 to group 7
[    0.823273] iommu: Adding device 0000:00:1c.6 to group 8
[    0.823302] iommu: Adding device 0000:00:1d.0 to group 9
[    0.823330] iommu: Adding device 0000:00:1e.0 to group 10
[    0.823365] iommu: Adding device 0000:00:1f.0 to group 11
[    0.823393] iommu: Adding device 0000:00:1f.2 to group 11
[    0.823422] iommu: Adding device 0000:00:1f.3 to group 11
[    0.823447] iommu: Adding device 0000:01:00.0 to group 1
[    0.823472] iommu: Adding device 0000:01:00.1 to group 1
[    0.823506] iommu: Adding device 0000:02:00.0 to group 12
[    0.823535] iommu: Adding device 0000:02:00.2 to group 12
[    0.823560] iommu: Adding device 0000:03:0e.0 to group 12
[    0.823589] iommu: Adding device 0000:05:00.0 to group 13
[    0.823614] iommu: Adding device 0000:06:00.0 to group 10
[    0.823638] iommu: Adding device 0000:06:00.1 to group 10
[    0.824761] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840=
 ms ovfl timer
[    0.824798] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
[    0.824821] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.824843] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
[    0.848847] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.848888] audit: initializing netlink subsys (disabled)
[    0.848919] audit: type=3D2000 audit(1470735782.836:1): initialized
[    0.849163] workingset: timestamp_bits=3D60 max_order=3D23 bucket_order=
=3D0
[    0.849196] zbud: loaded
[    0.959708] NILFS version 2 loaded
[    0.971723] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.971775] io scheduler noop registered
[    0.971808] io scheduler deadline registered
[    0.975709] io scheduler cfq registered (default)
[    0.976151] pcieport 0000:00:01.0: Signaling PME through PCIe PME interr=
upt
[    0.976176] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.976201] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.976226] pcie_pme 0000:00:01.0:pcie001: service driver pcie_pme loaded
[    0.976251] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interr=
upt
[    0.976276] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.976300] pci 0000:03:0e.0: Signaling PME through PCIe PME interrupt
[    0.976325] pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    0.976352] pcie_pme 0000:00:1c.0:pcie001: service driver pcie_pme loaded
[    0.976377] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interr=
upt
[    0.976402] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.976429] pcie_pme 0000:00:1c.6:pcie001: service driver pcie_pme loaded
[    0.976484] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    0.976527] ACPI: Power Button [PWRB]
[    0.976574] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.976618] ACPI: Power Button [PWRF]
[    0.976790] Monitor-Mwait will be used to enter C-2 state
[    0.976797] Monitor-Mwait will be used to enter C-3 state
[    0.977572] Linux agpgart interface v0.103
[    0.977615] [drm] Initialized drm 1.1.0 20060810
[    0.982136] [drm] DMAR active, disabling use of stolen memory
[    0.982161] [drm] Memory usable by graphics device =3D 2048M
[    0.982183] [drm] VT-d active for gfx access
[    0.982204] [drm] Disabling PPGTT because VT-d is on
[    0.982226] [drm] Replacing VGA console driver
[    0.982752] Console: switching to colour dummy device 80x25
[    0.988773] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.988781] [drm] Driver supports precise vblank timestamp query.
[    0.990895] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dnone:owns=3Dio+mem
[    0.994031] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on mi=
nor 0
[    0.995230] loop: module loaded
[    0.999495] ahci 0000:00:1f.2: version 3.0
[    1.009694] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3f impl SATA mode
[    1.009714] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum=
 part ems sxs apst=20
[    1.023256] scsi host0: ahci
[    1.023379] scsi host1: ahci
[    1.023471] scsi host2: ahci
[    1.023546] scsi host3: ahci
[    1.023623] scsi host4: ahci
[    1.023721] scsi host5: ahci
[    1.023769] ata1: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2510=
0 irq 31
[    1.023774] ata2: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2518=
0 irq 31
[    1.023780] ata3: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2520=
0 irq 31
[    1.023785] ata4: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2528=
0 irq 31
[    1.023791] ata5: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2530=
0 irq 31
[    1.023796] ata6: SATA max UDMA/133 abar m2048@0xfbe25000 port 0xfbe2538=
0 irq 31
[    1.023834] tun: Universal TUN/TAP device driver, 1.6
[    1.023837] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.023873] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.023876] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.023993] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) se=
t to dynamic conservative mode
[    1.125056] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): registered=
 PHC clock
[    1.219022] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:=
22:4d:54:74:d1
[    1.219028] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connecti=
on
[    1.219080] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0=
FF
[    1.219123] VFIO - User Level meta-driver version: 0.3
[    1.219219] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dnone
[    1.229721] vfio_pci: add [1002:9460[ffff:ffff]] class 0x000000/00000000
[    1.240735] vfio_pci: add [1002:aa30[ffff:ffff]] class 0x000000/00000000
[    1.251723] vfio_pci: add [8086:1c26[ffff:ffff]] class 0x000000/00000000
[    1.251726] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.251729] ehci-pci: EHCI PCI platform driver
[    1.251798] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.251805] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    1.251821] ehci-pci 0000:00:1a.0: debug port 2
[    1.255729] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.255737] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfbe27000
[    1.261723] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.261820] hub 1-0:1.0: USB hub found
[    1.261827] hub 1-0:1.0: 3 ports detected
[    1.261910] ehci-platform: EHCI generic platform driver
[    1.261920] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.261925] ohci-pci: OHCI PCI platform driver
[    1.261934] ohci-platform: OHCI generic platform driver
[    1.261942] uhci_hcd: USB Universal Host Controller Interface driver
[    1.261998] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.262004] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 2
[    1.262213] xhci_hcd 0000:05:00.0: hcc params 0x014042cb hci version 0x9=
6 quirks 0x00000004
[    1.262421] hub 2-0:1.0: USB hub found
[    1.262432] hub 2-0:1.0: 2 ports detected
[    1.262494] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.262498] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 3
[    1.265596] usb usb3: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    1.265670] hub 3-0:1.0: USB hub found
[    1.265679] hub 3-0:1.0: 2 ports detected
[    1.265771] usbcore: registered new interface driver cdc_acm
[    1.265774] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.265793] usbcore: registered new interface driver usb-storage
[    1.265809] usbcore: registered new interface driver usbserial
[    1.265816] usbcore: registered new interface driver ftdi_sio
[    1.265825] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    1.265867] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.269069] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.269074] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.269145] mousedev: PS/2 mouse device common for all mice
[    1.269256] rtc_cmos 00:02: RTC can wake from S4
[    1.269379] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.269409] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    1.269419] md: raid0 personality registered for level 0
[    1.269421] md: raid1 personality registered for level 1
[    1.274825] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised:=
 dm-devel@redhat.com
[    1.274842] hidraw: raw HID events driver (C) Jiri Kosina
[    1.279540] fbcon: inteldrmfb (fb0) is primary device
[    1.301355] Netfilter messages via NETLINK v0.30.
[    1.301361] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    1.301362] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[    1.301403] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.301420] NET: Registered protocol family 17
[    1.301423] NET: Registered protocol family 37
[    1.301580] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.301584] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.301590] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.301596] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    1.301615] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.301620] AVX version of gcm_enc/dec engaged.
[    1.301620] AES CTR mode by8 optimization enabled
[    1.302028] registered taskstats version 1
[    1.302038] zswap: loaded using pool lzo/zbud
[    1.327034] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.327163] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.327179] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.327208] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.328214] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.328233] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.328345] ata5.00: NCQ Send/Recv Log not supported
[    1.328347] ata5.00: ATA-9: SAMSUNG MZMTD128HAFV-000, DXT41K0Q, max UDMA=
/133
[    1.328349] ata5.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    1.328426] ata3.00: ATA-8: ST3500418AS, CC49, max UDMA/133
[    1.328428] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.328639] ata1.00: ATA-8: KINGSTON SNV425S264GB, C091126a, max UDMA/100
[    1.328648] ata1.00: 125045424 sectors, multi 16: LBA48=20
[    1.328826] ata5.00: NCQ Send/Recv Log not supported
[    1.328900] ata5.00: configured for UDMA/133
[    1.329072] ata1.00: configured for UDMA/100
[    1.329308] ata4.00: ATA-8: WDC WD7500BPKT-22PK4T0, 01.01A01, max UDMA/1=
33
[    1.329309] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.329773] ata3.00: configured for UDMA/133
[    1.330613] ata2.00: ATA-8: WDC WD7500BPKT-75PK4T0, 01.01A01, max UDMA/1=
33
[    1.330615] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.332422] ata4.00: configured for UDMA/133
[    1.334140] ata2.00: configured for UDMA/133
[    1.357176] ata6.00: HPA detected: current 976771055, native 976773168
[    1.357180] ata6.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    1.357182] ata6.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.359172] ata6.00: configured for UDMA/133
[    1.385875] Btrfs loaded, crc32c=3Dcrc32c-generic
[    1.385876] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    1.385876] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    1.385877] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
[    1.385877] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
[    1.385878] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
[    1.386555] Key type encrypted registered
[    1.387119] rtc_cmos 00:02: setting system clock to 2016-08-09 09:43:04 =
UTC (1470735784)
[    1.387168] ALSA device list:
[    1.387169]   #0: SB Live! 5.1 (rev.10, serial:0x80641102) at 0xd000, ir=
q 16
[    1.563750] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.634456] Console: switching to colour frame buffer device 240x67
[    1.653309] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.657982] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SNV425S 12=
6a PQ: 0 ANSI: 5
[    1.669917] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 G=
B/59.6 GiB)
[    1.669923] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.670002] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-7 1A=
01 PQ: 0 ANSI: 5
[    1.673299] sd 0:0:0:0: [sda] Write Protect is off
[    1.674422] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.674430] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.678073]  sda: sda1 sda2 sda3 sda4
[    1.679663] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.679703] hub 1-1:1.0: USB hub found
[    1.679832] hub 1-1:1.0: 6 ports detected
[    1.680949] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 G=
B/699 GiB)
[    1.680950] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.680962] sd 1:0:0:0: [sdb] Write Protect is off
[    1.680963] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.680969] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.681054] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.681133] scsi 2:0:0:0: Direct-Access     ATA      ST3500418AS      CC=
49 PQ: 0 ANSI: 5
[    1.698884] sd 2:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/466 GiB)
[    1.698899] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.699005] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-2 1A=
01 PQ: 0 ANSI: 5
[    1.702424] sd 2:0:0:0: [sdc] Write Protect is off
[    1.703626] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.703633] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.709887] sd 3:0:0:0: [sdd] 1465149168 512-byte logical blocks: (750 G=
B/699 GiB)
[    1.709907] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.709981] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG MZMTD128 1K=
0Q PQ: 0 ANSI: 5
[    1.713555] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    1.714769]  sdc: sdc1 sdc2 sdc3 sdc4
[    1.714931] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.717248] sd 3:0:0:0: [sdd] Write Protect is off
[    1.718483] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.718489] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.733882] sd 4:0:0:0: [sde] 250069680 512-byte logical blocks: (128 GB=
/119 GiB)
[    1.733897] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    1.733972] scsi 5:0:0:0: Direct-Access     ATA      ST3500320AS      SD=
1A PQ: 0 ANSI: 5
[    1.737775] sd 4:0:0:0: [sde] Write Protect is off
[    1.739088] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.739096] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.743926]  sde: sde1
[    1.745385] sd 4:0:0:0: [sde] Attached SCSI removable disk
[    1.749896] sd 5:0:0:0: [sdf] 976771055 512-byte logical blocks: (500 GB=
/466 GiB)
[    1.749901] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    1.752578] sd 5:0:0:0: [sdf] Write Protect is off
[    1.753901] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.753908] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.777412]  sdf: sdf1 sdf2 sdf3 sdf4
[    1.779217] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[    1.846776] tsc: Refined TSC clocksource calibration: 3092.973 MHz
[    1.848154] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2c9=
5594edb3, max_idle_ns: 440795220223 ns
[    1.953793] usb 1-1.5: new high-speed USB device number 3 using ehci-pci
[    2.040881] hub 1-1.5:1.0: USB hub found
[    2.042356] hub 1-1.5:1.0: 4 ports detected
[    2.073934]  sdb: sdb1
[    2.075470] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.106803] usb 1-1.6: new low-speed USB device number 4 using ehci-pci
[    2.115268]  sdd: sdd1
[    2.116773] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.118206] md: Waiting for all devices to be available before autodetect
[    2.119605] md: If you don't use raid, use raid=3Dnoautodetect
[    2.121105] md: Autodetecting RAID arrays.
[    2.147380] md: invalid raid superblock magic on sdc3
[    2.148784] md: sdc3 does not have a valid v0.90 superblock, not importi=
ng!
[    2.193840] md: invalid raid superblock magic on sdf3
[    2.195268] md: sdf3 does not have a valid v0.90 superblock, not importi=
ng!
[    2.218796] md: Scanned 8 and added 6 devices.
[    2.220278] md: autorun ...
[    2.221694] md: considering sdf4 ...
[    2.223103] md:  adding sdf4 ...
[    2.224502] md: sdf2 has different UUID to sdf4
[    2.225891] md: sdf1 has different UUID to sdf4
[    2.227266] md:  adding sdc4 ...
[    2.228636] md: sdc2 has different UUID to sdf4
[    2.229994] md: sdc1 has different UUID to sdf4
[    2.231456] md: created md124
[    2.232795] md: bind<sdc4>
[    2.234121] md: bind<sdf4>
[    2.235428] md: running: <sdf4><sdc4>
[    2.236922] md/raid1:md124: active with 2 out of 2 mirrors
[    2.238231] md124: detected capacity change from 0 to 464588374016
[    2.239534] md: considering sdf2 ...
[    2.240833] md:  adding sdf2 ...
[    2.242128] md: sdf1 has different UUID to sdf2
[    2.243416] md:  adding sdc2 ...
[    2.244689] md: sdc1 has different UUID to sdf2
[    2.246072] md: created md1
[    2.247355] md: bind<sdc2>
[    2.248622] md: bind<sdf2>
[    2.249871] md: running: <sdf2><sdc2>
[    2.251277] md/raid1:md1: active with 2 out of 2 mirrors
[    2.252533] md1: detected capacity change from 0 to 34365112320
[    2.253769] md: considering sdf1 ...
[    2.254993] md:  adding sdf1 ...
[    2.256198] md:  adding sdc1 ...
[    2.257397] md: created md0
[    2.258582] md: bind<sdc1>
[    2.259750] md: bind<sdf1>
[    2.260897] md: running: <sdf1><sdc1>
[    2.262249] md/raid1:md0: active with 2 out of 2 mirrors
[    2.263422] md0: detected capacity change from 0 to 65667072
[    2.264584] md: ... autorun DONE.
[    2.266832] NILFS: Can't find nilfs on dev sda4.
[    2.268730] BTRFS: device label RUT devid 1 transid 58468 /dev/root
[    2.270619] BTRFS info (device sda4): disk space caching is enabled
[    2.271803] BTRFS info (device sda4): has skinny extents
[    2.301242] BTRFS info (device sda4): detected SSD devices, enabling SSD=
 mode
[    2.310814] VFS: Mounted root (btrfs filesystem) on device 0:14.
[    2.312670] Freeing unused kernel memory: 880K (ffffffff81c80000 - fffff=
fff81d5c000)
[    2.313796] Write protecting the kernel read-only data: 12288k
[    2.315192] Freeing unused kernel memory: 268K (ffff8800017bd000 - ffff8=
80001800000)
[    2.318838] Freeing unused kernel memory: 1504K (ffff880001a88000 - ffff=
880001c00000)
[    2.320818] usb 1-1.5.1: new full-speed USB device number 5 using ehci-p=
ci
[    2.772057] random: systemd-udevd urandom read with 18 bits of entropy a=
vailable
[    2.820318] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.824627] e1000e 0000:00:19.0 eno1: renamed from eth0
[    2.840929] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.844224] Adaptec aacraid driver 1.2-1[41066]-ms
[    2.844521] aacraid 0000:03:0e.0: Changed firmware to INTX mode
[    2.847171] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:046D:C31C.0001/input/input5
[    2.868052] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq =3D 17, base_baud =3D=
 115200) is a 16550A
[    2.868068] clocksource: Switched to clocksource tsc
[    2.870121] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    2.897900] hid-generic 0003:046D:C31C.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input0
[    2.903668] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:046D:C31C.0002/input/input6
[    2.953954] hid-generic 0003:046D:C31C.0002: input,hidraw1: USB HID v1.1=
0 Device [Logitech USB Keyboard] on usb-0000:00:1a.0-1.6/input1
[    2.957454] input: Telink 2.4G Mouse as /devices/pci0000:00/0000:00:1a.0=
/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/0003:248A:8366.0003/input/input7
[    2.982774] BTRFS: device label RUT devid 1 transid 177468 /dev/sda2
[    3.007273] md: bind<sdf3>
[    3.008176] hid-generic 0003:248A:8366.0003: input,hidraw2: USB HID v1.1=
1 Mouse [Telink 2.4G Mouse] on usb-0000:00:1a.0-1.5.1/input0
[    3.008194] usbcore: registered new interface driver usbhid
[    3.008195] usbhid: USB HID core driver
[    3.008837] md: bind<sdc3>
[    3.010979] md/raid0:md2: md_size is 4235264 sectors.
[    3.010981] md: RAID0 configuration for md2 - 1 zone
[    3.010982] md: zone0=3D[sdc3/sdf3]
[    3.010985]       zone-offset=3D         0KB, device-offset=3D         0=
KB, size=3D   2117632KB
[    3.010993] md2: detected capacity change from 0 to 2168455168
[    3.046806] BTRFS: device label STORAZ devid 1 transid 2998 /dev/sdb1
[    3.059025] BTRFS: device label STORAZ devid 2 transid 2998 /dev/sdd1
[    3.065309] AAC0: kernel 5.2-0[17342] Aug  4 2010
[    3.065313] AAC0: monitor 5.2-0[17342]
[    3.065315] AAC0: bios 5.2-0[17342]
[    3.065317] AAC0: serial 7C36110C3E2
[    3.065319] AAC0: Non-DASD support enabled.
[    3.065320] AAC0: 64bit support enabled.
[    3.065323] AAC0: 64 Bit DAC enabled
[    3.072520] scsi host6: aacraid
[    3.072929] scsi 6:0:0:0: Direct-Access     Adaptec  test             V1=
=2E0 PQ: 0 ANSI: 2
[    3.101510] DMAR: DRHD: handling fault status reg 2
[    3.101516] DMAR: [DMA Write] Request device [03:01.0] fault addr ffbfb0=
00 [fault reason 02] Present bit in context entry is clear
[    3.101576] scsi host6: scsi scan: INQUIRY result too short (5), using 36
[    3.101580] scsi 6:1:4:0: Direct-Access                                 =
   PQ: 0 ANSI: 0
[    3.103411] DMAR: DRHD: handling fault status reg 2
[    3.103415] DMAR: [DMA Write] Request device [03:01.0] fault addr ffbf90=
00 [fault reason 02] Present bit in context entry is clear
[    3.103481] scsi 6:1:5:0: Direct-Access                                 =
   PQ: 0 ANSI: 0
[    3.181214] sd 6:0:0:0: [sdg] 2927624192 512-byte logical blocks: (1.50 =
TB/1.36 TiB)
[    3.181220] sd 6:0:0:0: [sdg] Write Protect is off
[    3.181222] sd 6:0:0:0: [sdg] Mode Sense: 12 00 10 08
[    3.181229] sd 6:0:0:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[    3.181244] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.181344] scsi 6:1:4:0: Attached scsi generic sg7 type 0
[    3.181431] scsi 6:1:5:0: Attached scsi generic sg8 type 0
[    3.181698] DMAR: DRHD: handling fault status reg 3
[    3.181702] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb680=
00 [fault reason 02] Present bit in context entry is clear
[    3.181705] DMAR: DRHD: handling fault status reg 3
[    3.181707] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb680=
00 [fault reason 02] Present bit in context entry is clear
[    3.181874] sd 6:0:0:0: [sdg] Attached SCSI removable disk
[    3.207431] DMAR: DRHD: handling fault status reg 3
[    3.207437] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb5d0=
00 [fault reason 02] Present bit in context entry is clear
[    3.208439] DMAR: DRHD: handling fault status reg 3
[    3.208442] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb5e0=
00 [fault reason 02] Present bit in context entry is clear
[    3.208446] DMAR: DRHD: handling fault status reg 3
[    3.208449] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb5e0=
00 [fault reason 02] Present bit in context entry is clear
[    3.208835] DMAR: DRHD: handling fault status reg 3
[    3.208838] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb5f0=
00 [fault reason 02] Present bit in context entry is clear
[    4.064947] AAC: Host adapter dead -1
[    4.592662] Adding 2117628k swap on /dev/md2.  Priority:1 extents:1 acro=
ss:2117628k FS
[    4.594131] Adding 2097148k swap on /dev/sda3.  Priority:5 extents:1 acr=
oss:2097148k SSFS
[    4.671919] EXT4-fs (md124): mounted filesystem with ordered data mode. =
Opts: (null)
[    4.710843] BTRFS info (device sdd1): use lzo compression
[    4.710847] BTRFS info (device sdd1): disk space caching is enabled
[    4.710850] BTRFS info (device sdd1): has skinny extents
[    4.887018] AAC: Host adapter dead -1
[    5.193008] AAC: Host adapter dead -1
[    6.423625] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.424320] microcode: CPU0 updated to revision 0x29, date =3D 2013-06-12
[    6.424612] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.425020] microcode: CPU1 updated to revision 0x29, date =3D 2013-06-12
[    6.425296] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.425708] microcode: CPU2 updated to revision 0x29, date =3D 2013-06-12
[    6.426001] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x28
[    6.426410] microcode: CPU3 updated to revision 0x29, date =3D 2013-06-12
[    7.499179] NET: Registered protocol family 10
[    7.499586] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[   10.424492] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: Rx/Tx
[   10.424531] IPv6: ADDRCONF(NETDEV_CHANGE): eno1: link becomes ready
[   15.193715] AAC: Host adapter dead -1
[   20.956367] random: nonblocking pool is initialized
[   25.194416] AAC: Host adapter dead -1
[   33.255733] dmar_fault: 355 callbacks suppressed
[   33.255737] DMAR: DRHD: handling fault status reg 3
[   33.255741] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb650=
00 [fault reason 02] Present bit in context entry is clear
[   33.256744] DMAR: DRHD: handling fault status reg 3
[   33.256750] DMAR: [DMA Write] Request device [03:01.0] fault addr ffa5f0=
00 [fault reason 02] Present bit in context entry is clear
[   33.257270] DMAR: DRHD: handling fault status reg 3
[   33.257274] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb820=
00 [fault reason 02] Present bit in context entry is clear
[   33.257277] DMAR: DRHD: handling fault status reg 3
[   33.257280] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb820=
00 [fault reason 02] Present bit in context entry is clear
[   33.257656] DMAR: DRHD: handling fault status reg 3
[   33.257659] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb830=
00 [fault reason 02] Present bit in context entry is clear
[   33.257663] DMAR: DRHD: handling fault status reg 3
[   33.257665] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb830=
00 [fault reason 02] Present bit in context entry is clear
[   33.257998] DMAR: DRHD: handling fault status reg 3
[   33.258001] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb840=
00 [fault reason 02] Present bit in context entry is clear
[   33.258006] DMAR: DRHD: handling fault status reg 3
[   33.258009] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb840=
00 [fault reason 02] Present bit in context entry is clear
[   33.258426] DMAR: DRHD: handling fault status reg 3
[   33.258429] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb850=
00 [fault reason 02] Present bit in context entry is clear
[   33.258432] DMAR: DRHD: handling fault status reg 3
[   33.258435] DMAR: [DMA Write] Request device [03:01.0] fault addr ffb850=
00 [fault reason 02] Present bit in context entry is clear
[   33.321479] NILFS: Can't find nilfs on dev sdg.
[   35.195109] AAC: Host adapter dead -1
[   45.195807] AAC: Host adapter dead -1
[   55.196505] AAC: Host adapter dead -1

--7gLe/sNPhR777EPF--

--6sj9mcRtP+pTWLOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXqjE/AAoJEEMpAov1cw9lJbYQAIhjV8hiUtdJbhbkMC03qIw7
ghIuoLQo1kHabNXM3qk89+fL+ncaw0gFWB586NH+HCEgUsfeNnwNxaGDBY8Nt8cx
gcuoz/sCOjIJjUqtwZ2+VbX+G5RWpku9ErQdfEf11d3GltC+LACxzOK9Fl1TxNTc
r3cMT2/buF/3Ax/nAX90DqIQKb+/xWhenteruP7YU9JAVlcrRgs7AZjR1ukXBbHW
oufOUBlltfqBpgRkfexXeYKFVr6UNlYorkpcZL5vTeJ5GO0vT5dd0tooNKcajGqL
UB3EG5VvFGW0IMx7geae24In7X5gIvBVXPR07BJGQIgn7Balbtl+4f6S3wVvrDqV
cR68PgJJ3q9Lmwvz4W0M1RVDuE1h+6SvYp+4u2o1+sVtc1rLs6fEmwR2h5n7LNID
ZY4/sMe/FPGL3vHwO36LGsvOF2FQYE6r8ER/ji+4/hL2uZIN2LeArhTxt3qTkTFp
zMjVTSEeR1qFi1XG5mbfKWnXciwoXDV1SgOvCkFg4VXIWg+DJ3qXle08BDtOoaxu
wtu8kqo4hYRM/1UvuNeERBJ/NJBvQPxo0irbSx36qKr/A+4YbqydVITnv4CyWgKD
gbhQ5OtV/w9riq+ZmdKn966Bn96Rpc9vvfRJirH+IN8JRcIF3HRgnrZxeNgcjl/Q
kWxveRJL5UzpRdDHKM9T
=5gRk
-----END PGP SIGNATURE-----

--6sj9mcRtP+pTWLOo--
