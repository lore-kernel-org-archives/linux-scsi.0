From: "Caspar Smit" <c.smit@truebit.nl>
Subject: ATA / mvsas issue.
Date: Wed, 31 Mar 2010 15:03:03 +0200 (CEST)
Message-ID: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100331150303_68758"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:45847 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab0CaNIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 09:08:18 -0400
Received: from ns1.emsolutions.nl (www-data@localhost.localdomain [127.0.0.1])
	by ns1.emsolutions.nl (8.13.8/8.13.8/Debian-3) with ESMTP id o2VD33ko022760
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2010 15:03:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

------=_20100331150303_68758
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi all,

Today I installed 16 fresh Western Digital WD5000BEVT (2,5") drives in one
of our test servers.

I created a software raid5 with a hotspare on these 16 disks.

I noticed that the detection of the disks during boottime was very very slow.
Creating the md superblocks went very very slow.

After that all seemed fine (speed of the raid5 init was normal).

I noticed many of these messages in the syslog (also attached):

Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-112'
Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-128'

This seems to correspond to the slow detection of the disks.

Is this an ATA problem, or a problem in the mvsas driver?

I use the mvsas driver from 2.6.32 with the latest patch from Srinivas.

Kind regards,
Caspar Smit
------=_20100331150303_68758
Content-Type: text/plain; name="syslog.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="syslog.txt"

Mar 31 14:34:12 test kernel: [    2.291587] mvsas 0000:04:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
Mar 31 14:34:12 test kernel: [    2.291662] mvsas 0000:04:00.0: setting latency timer to 64
Mar 31 14:34:12 test kernel: [    2.293329] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
Mar 31 14:34:12 test kernel: [    8.075221] scsi2 : mvsas
Mar 31 14:34:12 test kernel: [    8.075735] mvsas 0000:0c:00.0: mvsas: driver version 0.8.2
Mar 31 14:34:12 test kernel: [    8.075819] mvsas 0000:0c:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
Mar 31 14:34:12 test kernel: [    8.075895] mvsas 0000:0c:00.0: setting latency timer to 64
Mar 31 14:34:12 test kernel: [    8.078089] mvsas 0000:0c:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
Mar 31 14:34:12 test kernel: [   11.652526] ata3.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   11.652600] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   11.685544] ata3.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   11.685690] scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   13.855222] scsi3 : mvsas
Mar 31 14:34:12 test kernel: [   13.855729] mvsas 0000:0e:00.0: mvsas: driver version 0.8.2
Mar 31 14:34:12 test kernel: [   13.855814] mvsas 0000:0e:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
Mar 31 14:34:12 test kernel: [   13.855890] mvsas 0000:0e:00.0: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   13.858013] mvsas 0000:0e:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
Mar 31 14:34:12 test kernel: [   15.483640] ata4.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   15.483714] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   15.517461] ata4.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   15.517572] scsi 2:0:1:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   17.726157] ata5.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   17.726231] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   17.759974] ata5.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   17.760081] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   18.976010] scsi4 : mvsas
Mar 31 14:34:12 test kernel: [   18.976661] drivers/scsi/mvsas/mv_sas.c 1258:set wide port phy map 1
Mar 31 14:34:12 test kernel: [   18.986623] drivers/scsi/mvsas/mv_sas.c 1258:set wide port phy map 2
Mar 31 14:34:12 test kernel: [   19.007597] scsi 4:0:0:0: Direct-Access     SEAGATE  ST9300603SS      0006 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   19.008546] scsi 4:0:1:0: Direct-Access     SEAGATE  ST9300603SS      0004 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   19.165750] async_tx: api initialized (async)
Mar 31 14:34:12 test kernel: [   19.166421] xor: automatically using best checksumming function: generic_sse
Mar 31 14:34:12 test kernel: [   19.183997]    generic_sse:  7668.000 MB/sec
Mar 31 14:34:12 test kernel: [   19.184065] xor: using function: generic_sse (7668.000 MB/sec)
Mar 31 14:34:12 test kernel: [   19.196033] ata6.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   19.196111] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   19.230337] ata6.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   19.230465] scsi 2:0:2:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   19.252018] raid6: int64x1   1667 MB/s
Mar 31 14:34:12 test kernel: [   19.320009] raid6: int64x2   2235 MB/s
Mar 31 14:34:12 test kernel: [   19.388025] raid6: int64x4   1820 MB/s
Mar 31 14:34:12 test kernel: [   19.456005] raid6: int64x8   1479 MB/s
Mar 31 14:34:12 test kernel: [   19.524007] raid6: sse2x1    3228 MB/s
Mar 31 14:34:12 test kernel: [   19.592006] raid6: sse2x2    5374 MB/s
Mar 31 14:34:12 test kernel: [   19.660003] raid6: sse2x4    6153 MB/s
Mar 31 14:34:12 test kernel: [   19.660070] raid6: using algorithm sse2x4 (6153 MB/s)
Mar 31 14:34:12 test kernel: [   19.668498] md: raid6 personality registered for level 6
Mar 31 14:34:12 test kernel: [   19.668568] md: raid5 personality registered for level 5
Mar 31 14:34:12 test kernel: [   19.668637] md: raid4 personality registered for level 4
Mar 31 14:34:12 test kernel: [   19.673058] md: md0 stopped.
Mar 31 14:34:12 test kernel: [   19.695801] device-mapper: uevent: version 1.0.3
Mar 31 14:34:12 test kernel: [   19.695983] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Mar 31 14:34:12 test kernel: [   19.709984] PM: Starting manual resume from disk
Mar 31 14:34:12 test kernel: [   19.710054] PM: Resume from partition 8:5
Mar 31 14:34:12 test kernel: [   19.710056] PM: Checking hibernation image.
Mar 31 14:34:12 test kernel: [   19.710611] PM: Error -22 checking image file
Mar 31 14:34:12 test kernel: [   19.710613] PM: Resume from disk failed.
Mar 31 14:34:12 test kernel: [   19.714540] kjournald starting.  Commit interval 5 seconds
Mar 31 14:34:12 test kernel: [   19.714618] EXT3-fs: mounted filesystem with ordered data mode.
Mar 31 14:34:12 test kernel: [   19.945417] udevd version 125 started
Mar 31 14:34:12 test kernel: [   20.123940] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0C:00/input/input2
Mar 31 14:34:12 test kernel: [   20.124041] ACPI: Power Button [PWRB]
Mar 31 14:34:12 test kernel: [   20.124156] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Mar 31 14:34:12 test kernel: [   20.124244] ACPI: Power Button [PWRF]
Mar 31 14:34:12 test kernel: [   20.136262] processor LNXCPU:00: registered as cooling_device0
Mar 31 14:34:12 test kernel: [   20.140714] processor LNXCPU:01: registered as cooling_device1
Mar 31 14:34:12 test kernel: [   20.141616] processor LNXCPU:02: registered as cooling_device2
Mar 31 14:34:12 test kernel: [   20.145725] processor LNXCPU:03: registered as cooling_device3
Mar 31 14:34:12 test kernel: [   20.218289] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Mar 31 14:34:12 test kernel: [   20.226291] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Mar 31 14:34:12 test kernel: [   20.393954] input: PC Speaker as /devices/platform/pcspkr/input/input4
Mar 31 14:34:12 test kernel: [   20.520751] EDAC MC: Ver: 2.1.0 Mar 15 2010
Mar 31 14:34:12 test kernel: [   20.549568] EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
Mar 31 14:34:12 test kernel: [   20.549677] EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
Mar 31 14:34:12 test kernel: [   20.651101] ioatdma: Intel(R) QuickData Technology Driver 4.00
Mar 31 14:34:12 test kernel: [   20.651386]   alloc irq_desc for 33 on node -1
Mar 31 14:34:12 test kernel: [   20.651389]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.651399] ioatdma 0000:00:0f.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
Mar 31 14:34:12 test kernel: [   20.651551] ioatdma 0000:00:0f.0: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.651603]   alloc irq_desc for 82 on node -1
Mar 31 14:34:12 test kernel: [   20.651605]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.651611] ioatdma 0000:00:0f.0: irq 82 for MSI/MSI-X
Mar 31 14:34:12 test kernel: [   20.651613]   alloc irq_desc for 83 on node -1
Mar 31 14:34:12 test kernel: [   20.651615]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.651619] ioatdma 0000:00:0f.0: irq 83 for MSI/MSI-X
Mar 31 14:34:12 test kernel: [   20.651621]   alloc irq_desc for 84 on node -1
Mar 31 14:34:12 test kernel: [   20.651622]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.651626] ioatdma 0000:00:0f.0: irq 84 for MSI/MSI-X
Mar 31 14:34:12 test kernel: [   20.651628]   alloc irq_desc for 85 on node -1
Mar 31 14:34:12 test kernel: [   20.651629]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.651633] ioatdma 0000:00:0f.0: irq 85 for MSI/MSI-X
Mar 31 14:34:12 test kernel: [   20.663218] igb 0000:0f:00.0: DCA enabled
Mar 31 14:34:12 test kernel: [   20.663313] igb 0000:0f:00.1: DCA enabled
Mar 31 14:34:12 test kernel: [   20.663431]   alloc irq_desc for 18 on node -1
Mar 31 14:34:12 test kernel: [   20.663434]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.663442] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar 31 14:34:12 test kernel: [   20.672367] usbcore: registered new interface driver usbfs
Mar 31 14:34:12 test kernel: [   20.672464] usbcore: registered new interface driver hub
Mar 31 14:34:12 test kernel: [   20.684058] usbcore: registered new device driver usb
Mar 31 14:34:12 test kernel: [   20.697034] intel_rng: FWH not detected
Mar 31 14:34:12 test kernel: [   20.702549] Error: Driver 'pcspkr' is already registered, aborting...
Mar 31 14:34:12 test kernel: [   20.775273] uhci_hcd: USB Universal Host Controller Interface driver
Mar 31 14:34:12 test kernel: [   20.775412]   alloc irq_desc for 20 on node -1
Mar 31 14:34:12 test kernel: [   20.775414]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.775423] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Mar 31 14:34:12 test kernel: [   20.775503] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.775507] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.775602] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Mar 31 14:34:12 test kernel: [   20.775726] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
Mar 31 14:34:12 test kernel: [   20.775844] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Mar 31 14:34:12 test kernel: [   20.775917] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 31 14:34:12 test kernel: [   20.776004] usb usb1: Product: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.776073] usb usb1: Manufacturer: Linux 2.6.32-bpo.3-amd64 uhci_hcd
Mar 31 14:34:12 test kernel: [   20.776145] usb usb1: SerialNumber: 0000:00:1d.0
Mar 31 14:34:12 test kernel: [   20.776305] usb usb1: configuration #1 chosen from 1 choice
Mar 31 14:34:12 test kernel: [   20.776406] hub 1-0:1.0: USB hub found
Mar 31 14:34:12 test kernel: [   20.776478] hub 1-0:1.0: 2 ports detected
Mar 31 14:34:12 test kernel: [   20.776595]   alloc irq_desc for 21 on node -1
Mar 31 14:34:12 test kernel: [   20.776597]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.776601] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Mar 31 14:34:12 test kernel: [   20.776679] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.776682] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.776761] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Mar 31 14:34:12 test kernel: [   20.776876] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
Mar 31 14:34:12 test kernel: [   20.776983] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Mar 31 14:34:12 test kernel: [   20.777088] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 31 14:34:12 test kernel: [   20.777176] usb usb2: Product: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.777245] usb usb2: Manufacturer: Linux 2.6.32-bpo.3-amd64 uhci_hcd
Mar 31 14:34:12 test kernel: [   20.777317] usb usb2: SerialNumber: 0000:00:1d.1
Mar 31 14:34:12 test kernel: [   20.780695] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Mar 31 14:34:12 test kernel: [   20.780768] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Mar 31 14:34:12 test kernel: [   20.781176] usb usb2: configuration #1 chosen from 1 choice
Mar 31 14:34:12 test kernel: [   20.781276] hub 2-0:1.0: USB hub found
Mar 31 14:34:12 test kernel: [   20.781348] hub 2-0:1.0: 2 ports detected
Mar 31 14:34:12 test kernel: [   20.781465]   alloc irq_desc for 23 on node -1
Mar 31 14:34:12 test kernel: [   20.781467]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.781472] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
Mar 31 14:34:12 test kernel: [   20.781615] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.781618] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.781697] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
Mar 31 14:34:12 test kernel: [   20.781811] ehci_hcd 0000:00:1d.7: debug port 1
Mar 31 14:34:12 test kernel: [   20.785774] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Mar 31 14:34:12 test kernel: [   20.785797] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8b04000
Mar 31 14:34:12 test kernel: [   20.801523] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Mar 31 14:34:12 test kernel: [   20.801618] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
Mar 31 14:34:12 test kernel: [   20.801691] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 31 14:34:12 test kernel: [   20.801778] usb usb3: Product: EHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.801847] usb usb3: Manufacturer: Linux 2.6.32-bpo.3-amd64 ehci_hcd
Mar 31 14:34:12 test kernel: [   20.801919] usb usb3: SerialNumber: 0000:00:1d.7
Mar 31 14:34:12 test kernel: [   20.802058] usb usb3: configuration #1 chosen from 1 choice
Mar 31 14:34:12 test kernel: [   20.802159] hub 3-0:1.0: USB hub found
Mar 31 14:34:12 test kernel: [   20.802231] hub 3-0:1.0: 8 ports detected
Mar 31 14:34:12 test kernel: [   20.802368]   alloc irq_desc for 22 on node -1
Mar 31 14:34:12 test kernel: [   20.802371]   alloc kstat_irqs on node -1
Mar 31 14:34:12 test kernel: [   20.802378] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Mar 31 14:34:12 test kernel: [   20.808884] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.808887] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.808967] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Mar 31 14:34:12 test kernel: [   20.809091] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
Mar 31 14:34:12 test kernel: [   20.809196] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Mar 31 14:34:12 test kernel: [   20.809269] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 31 14:34:12 test kernel: [   20.809359] usb usb4: Product: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.809430] usb usb4: Manufacturer: Linux 2.6.32-bpo.3-amd64 uhci_hcd
Mar 31 14:34:12 test kernel: [   20.809502] usb usb4: SerialNumber: 0000:00:1d.2
Mar 31 14:34:12 test kernel: [   20.809638] usb usb4: configuration #1 chosen from 1 choice
Mar 31 14:34:12 test kernel: [   20.809735] hub 4-0:1.0: USB hub found
Mar 31 14:34:12 test kernel: [   20.809807] hub 4-0:1.0: 2 ports detected
Mar 31 14:34:12 test kernel: [   20.809939] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
Mar 31 14:34:12 test kernel: [   20.810017] uhci_hcd 0000:00:1d.3: setting latency timer to 64
Mar 31 14:34:12 test kernel: [   20.810020] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.810096] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Mar 31 14:34:12 test kernel: [   20.810207] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
Mar 31 14:34:12 test kernel: [   20.810308] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Mar 31 14:34:12 test kernel: [   20.810381] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 31 14:34:12 test kernel: [   20.810470] usb usb5: Product: UHCI Host Controller
Mar 31 14:34:12 test kernel: [   20.810542] usb usb5: Manufacturer: Linux 2.6.32-bpo.3-amd64 uhci_hcd
Mar 31 14:34:12 test kernel: [   20.810614] usb usb5: SerialNumber: 0000:00:1d.3
Mar 31 14:34:12 test kernel: [   20.810748] usb usb5: configuration #1 chosen from 1 choice
Mar 31 14:34:12 test kernel: [   20.810847] hub 5-0:1.0: USB hub found
Mar 31 14:34:12 test kernel: [   20.810924] hub 5-0:1.0: 2 ports detected
Mar 31 14:34:12 test kernel: [   21.443488] ata7.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   21.443566] ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   21.477719] ata7.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   21.477863] scsi 3:0:1:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   22.857434] Adding 4096564k swap on /dev/sda5.  Priority:-1 extents:1 across:4096564k SS
Mar 31 14:34:12 test kernel: [   22.897465] EXT3 FS on sda1, internal journal
Mar 31 14:34:12 test kernel: [   23.206494] ata8.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   23.206592] ata8.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   23.240727] ata8.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   23.240878] scsi 2:0:3:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   23.913420] netconsole: local port 6665
Mar 31 14:34:12 test kernel: [   23.913492] netconsole: local IP 192.168.0.12
Mar 31 14:34:12 test kernel: [   23.913560] netconsole: interface eth0
Mar 31 14:34:12 test kernel: [   23.913626] netconsole: remote port 6666
Mar 31 14:34:12 test kernel: [   23.913694] netconsole: remote IP 192.168.0.10
Mar 31 14:34:12 test kernel: [   23.913762] netconsole: remote ethernet address 00:30:48:88:36:c6
Mar 31 14:34:12 test kernel: [   23.913835] netconsole: device eth0 not up yet, forcing it
Mar 31 14:34:12 test kernel: [   23.925556] ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar 31 14:34:12 test kernel: [   23.928483] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Mar 31 14:34:12 test kernel: [   23.929329] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Mar 31 14:34:12 test kernel: [   23.933005] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
Mar 31 14:34:12 test kernel: [   25.213025] ata9.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   25.213101] ata9.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   25.247420] ata9.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   25.247562] scsi 3:0:2:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   26.932067] ata10.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   26.932144] ata10.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   26.965486] ata10.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   26.965617] scsi 2:0:4:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   28.027130] console [netcon0] enabled
Mar 31 14:34:12 test kernel: [   28.027199] netconsole: network logging started
Mar 31 14:34:12 test kernel: [   28.040037] loop: module loaded
Mar 31 14:34:12 test kernel: [   28.231223] w83627hf: Found W83627HF chip at 0x290
Mar 31 14:34:12 test kernel: [   29.096059] ata11.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   29.096154] ata11.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   29.130152] ata11.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   29.130283] scsi 3:0:3:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   30.605784] ata12.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   30.605863] ata12.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   30.640174] ata12.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   30.640297] scsi 2:0:5:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test kernel: [   32.822666] ata13.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:12 test kernel: [   32.822754] ata13.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:12 test kernel: [   32.857033] ata13.00: configured for UDMA/133
Mar 31 14:34:12 test kernel: [   32.857177] scsi 3:0:4:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:12 test mysqld_safe: Starting mysqld daemon with databases from /var/lib/mysql
Mar 31 14:34:12 test mysqld: 100331 14:34:12 [Note] Plugin 'FEDERATED' is disabled.
Mar 31 14:34:12 test mysqld: 100331 14:34:12  InnoDB: Started; log sequence number 0 43675
Mar 31 14:34:12 test mysqld: 100331 14:34:12 [Note] Event Scheduler: Loaded 0 events
Mar 31 14:34:12 test mysqld: 100331 14:34:12 [Note] /usr/sbin/mysqld: ready for connections.
Mar 31 14:34:12 test mysqld: Version: '5.1.44-3~bpo50+1'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  (Debian)
Mar 31 14:34:13 test kernel: [   34.480005] eth0: no IPv6 routers present
Mar 31 14:34:13 test /etc/mysql/debian-start[3430]: Upgrading MySQL tables if necessary.
Mar 31 14:34:13 test /etc/mysql/debian-start[3435]: /usr/bin/mysql_upgrade: the '--basedir' option is always ignored
Mar 31 14:34:13 test /etc/mysql/debian-start[3435]: Looking for 'mysql' as: /usr/bin/mysql
Mar 31 14:34:13 test /etc/mysql/debian-start[3435]: Looking for 'mysqlcheck' as: /usr/bin/mysqlcheck
Mar 31 14:34:13 test /etc/mysql/debian-start[3435]: This installation of MySQL is already upgraded to 5.1.44, use --force if you still need to run mysql_upgrade
Mar 31 14:34:13 test /etc/mysql/debian-start[3445]: Checking for insecure root accounts.
Mar 31 14:34:13 test /etc/mysql/debian-start[3456]: WARNING: mysql.user contains 2 root accounts without password!
Mar 31 14:34:13 test /etc/mysql/debian-start[3457]: Triggering myisam-recover for all MyISAM tables
Mar 31 14:34:13 test kernel: [   34.563044] RPC: Registered udp transport module.
Mar 31 14:34:13 test kernel: [   34.563126] RPC: Registered tcp transport module.
Mar 31 14:34:13 test kernel: [   34.563197] RPC: Registered tcp NFSv4.1 backchannel transport module.
Mar 31 14:34:13 test kernel: [   34.588100] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Mar 31 14:34:13 test kernel: [   34.614150] svc: failed to register lockdv1 RPC service (errno 97).
Mar 31 14:34:13 test kernel: [   34.614801] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Mar 31 14:34:13 test kernel: [   34.622656] NFSD: starting 90-second grace period
Mar 31 14:34:13 test kernel: [   34.776740] ata14.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:13 test kernel: [   34.776845] ata14.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:13 test smbd[3545]: [2010/03/31 14:34:13,  0] printing/print_cups.c:103(cups_connect) 
Mar 31 14:34:13 test smbd[3545]:   Unable to connect to CUPS server localhost:631 - Connection refused 
Mar 31 14:34:13 test smbd[3547]: [2010/03/31 14:34:13,  0] printing/print_cups.c:103(cups_connect) 
Mar 31 14:34:13 test smbd[3547]:   Unable to connect to CUPS server localhost:631 - Connection refused 
Mar 31 14:34:13 test kernel: [   34.811001] ata14.00: configured for UDMA/133
Mar 31 14:34:13 test kernel: [   34.811134] scsi 2:0:6:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:13 test smbd[3549]: [2010/03/31 14:34:13,  0] smbd/server.c:457(smbd_open_one_socket) 
Mar 31 14:34:13 test smbd[3549]:   smbd_open_once_socket: open_socket_in: Address already in use 
Mar 31 14:34:13 test smbd[3549]: [2010/03/31 14:34:13,  0] smbd/server.c:457(smbd_open_one_socket) 
Mar 31 14:34:13 test smbd[3549]:   smbd_open_once_socket: open_socket_in: Address already in use 
Mar 31 14:34:13 test smartd[3563]: smartd 5.40 2010-02-03 r3060 [x86_64-unknown-linux-gnu] (local build) Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net  
Mar 31 14:34:13 test smartd[3563]: Opened configuration file /etc/smartd.conf 
Mar 31 14:34:13 test smartd[3563]: Drive: DEVICESCAN, implied '-a' Directive on line 22 of file /etc/smartd.conf 
Mar 31 14:34:13 test smartd[3563]: Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning devices 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda, type changed from 'scsi' to 'sat' 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], opened 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], found in smartd database. 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], can't monitor Current Pending Sector count - no Attribute 197 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], can't monitor Offline Uncorrectable Sector count - no Attribute 198 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], appears to lack SMART Self-Test log; disabling -l selftest (override with -T permissive Directive) 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], appears to lack SMART Error log; disabling -l error (override with -T permissive Directive) 
Mar 31 14:34:13 test smartd[3563]: Device: /dev/sda [SAT], is SMART capable. Adding to "monitor" list. 
Mar 31 14:34:13 test smartd[3563]: Monitoring 1 ATA and 0 SCSI devices 
Mar 31 14:34:13 test smartd[3568]: smartd has fork()ed into background mode. New PID=3568. 
Mar 31 14:34:13 test smartd[3568]: file /var/run/smartd.pid written containing PID 3568 
Mar 31 14:34:14 test rsyncd[3616]: rsyncd version 3.0.7 starting, listening on port 873 
Mar 31 14:34:15 test snmpd[3596]: NET-SNMP version 5.4.1 
Mar 31 14:34:15 test kernel: [   36.519035] ata15.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:15 test kernel: [   36.519135] ata15.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:15 test kernel: [   36.553359] ata15.00: configured for UDMA/133
Mar 31 14:34:15 test kernel: [   36.553490] scsi 3:0:5:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:15 test /usr/sbin/cron[3640]: (CRON) INFO (pidfile fd = 3)
Mar 31 14:34:15 test /usr/sbin/cron[3641]: (CRON) STARTUP (fork ok)
Mar 31 14:34:15 test /usr/sbin/cron[3641]: (CRON) INFO (Running @reboot jobs)
Mar 31 14:34:15 test kernel: [   36.989032] iSCSI Enterprise Target Software - version 1.4.19
Mar 31 14:34:15 test kernel: [   36.989193] iscsi_trgt: Registered io type fileio
Mar 31 14:34:15 test kernel: [   36.989288] iscsi_trgt: Registered io type blockio
Mar 31 14:34:15 test kernel: [   36.989359] iscsi_trgt: Registered io type nullio
Mar 31 14:34:17 test kernel: [   38.608014] ata16.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:17 test kernel: [   38.608100] ata16.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:17 test kernel: [   38.642452] ata16.00: configured for UDMA/133
Mar 31 14:34:17 test kernel: [   38.642578] scsi 2:0:7:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:17 test kernel: [   38.643810] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.643942] sd 2:0:0:0: [sdb] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.644024] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.644105] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.644327]  sdb:
Mar 31 14:34:17 test kernel: [   38.644439] sd 2:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.644628] sd 2:0:1:0: [sdc] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.644704] sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.644727] sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.644928]  sdc:
Mar 31 14:34:17 test kernel: [   38.645038] sd 2:0:2:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.645225] sd 2:0:2:0: [sdd] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.645295] sd 2:0:2:0: [sdd] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.645317] sd 2:0:2:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.645515]  sdd:
Mar 31 14:34:17 test kernel: [   38.645624] sd 2:0:3:0: [sde] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.645815] sd 2:0:3:0: [sde] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.645886] sd 2:0:3:0: [sde] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.645908] sd 2:0:3:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.646108]  sde:
Mar 31 14:34:17 test kernel: [   38.646217] sd 2:0:4:0: [sdf] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.646405] sd 2:0:4:0: [sdf] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.646476] sd 2:0:4:0: [sdf] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.646498] sd 2:0:4:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.646698]  sdf:
Mar 31 14:34:17 test kernel: [   38.646805] sd 2:0:5:0: [sdg] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.646990] sd 2:0:5:0: [sdg] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.647061] sd 2:0:5:0: [sdg] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.647083] sd 2:0:5:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.647278]  sdg:
Mar 31 14:34:17 test kernel: [   38.647380] sd 2:0:6:0: [sdh] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.647568] sd 2:0:6:0: [sdh] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.647639] sd 2:0:6:0: [sdh] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.647666] sd 2:0:6:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.647858]  sdh:
Mar 31 14:34:17 test kernel: [   38.647950] sd 2:0:7:0: [sdi] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:17 test kernel: [   38.649107] sd 2:0:7:0: [sdi] Write Protect is off
Mar 31 14:34:17 test kernel: [   38.649178] sd 2:0:7:0: [sdi] Mode Sense: 00 3a 00 00
Mar 31 14:34:17 test kernel: [   38.649199] sd 2:0:7:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:17 test kernel: [   38.649398]  sdi: unknown partition table
Mar 31 14:34:17 test kernel: [   38.656710] sd 2:0:7:0: [sdi] Attached SCSI disk
Mar 31 14:34:17 test kernel: [   38.691990]  unknown partition table
Mar 31 14:34:17 test kernel: [   38.692286] sd 2:0:6:0: [sdh] Attached SCSI disk
Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-112' 
Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-128' 
Mar 31 14:34:18 test kernel: [   40.016739] ata17.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:18 test kernel: [   40.016825] ata17.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:18 test kernel: [   40.051091] ata17.00: configured for UDMA/133
Mar 31 14:34:18 test kernel: [   40.051223] scsi 3:0:6:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:19 test kernel: [   40.215241]  unknown partition table
Mar 31 14:34:19 test kernel: [   40.215503] sd 2:0:4:0: [sdf] Attached SCSI disk
Mar 31 14:34:19 test ata_id[3800]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-80' 
Mar 31 14:34:19 test ata_id[3814]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-96' 
Mar 31 14:34:19 test kernel: [   40.284985]  unknown partition table
Mar 31 14:34:19 test kernel: [   40.285218] sd 2:0:5:0: [sdg] Attached SCSI disk
Mar 31 14:34:19 test kernel: [   40.297641]  unknown partition table
Mar 31 14:34:19 test kernel: [   40.297874] sd 2:0:2:0: [sdd] Attached SCSI disk
Mar 31 14:34:19 test ata_id[3824]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-48' 
Mar 31 14:34:19 test ata_id[3848]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-64' 
Mar 31 14:34:19 test kernel: [   40.553079]  unknown partition table
Mar 31 14:34:19 test kernel: [   40.553357] sd 2:0:3:0: [sde] Attached SCSI disk
Mar 31 14:34:21 test kernel: [   42.308805]  unknown partition table
Mar 31 14:34:21 test kernel: [   42.309064] sd 2:0:0:0: [sdb] Attached SCSI disk
Mar 31 14:34:21 test ata_id[3874]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-32' 
Mar 31 14:34:21 test kernel: [   42.348732]  unknown partition table
Mar 31 14:34:21 test kernel: [   42.348965] sd 2:0:1:0: [sdc] Attached SCSI disk
Mar 31 14:34:22 test kernel: [   43.709177] ata18.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
Mar 31 14:34:22 test kernel: [   43.709263] ata18.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Mar 31 14:34:22 test kernel: [   43.743429] ata18.00: configured for UDMA/133
Mar 31 14:34:22 test kernel: [   43.743560] scsi 3:0:7:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
Mar 31 14:34:22 test kernel: [   43.744990] sd 3:0:0:0: [sdj] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.745131] sd 3:0:0:0: [sdj] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.745203] sd 3:0:0:0: [sdj] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.745225] sd 3:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.745437]  sdj:
Mar 31 14:34:22 test kernel: [   43.745552] sd 3:0:1:0: [sdk] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.745739] sd 3:0:1:0: [sdk] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.745810] sd 3:0:1:0: [sdk] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.745831] sd 3:0:1:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.746029]  sdk:
Mar 31 14:34:22 test kernel: [   43.746139] sd 3:0:2:0: [sdl] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.746326] sd 3:0:2:0: [sdl] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.746397] sd 3:0:2:0: [sdl] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.746417] sd 3:0:2:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.746612]  sdl:
Mar 31 14:34:22 test kernel: [   43.746717] sd 3:0:3:0: [sdm] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.746902] sd 3:0:3:0: [sdm] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.746973] sd 3:0:3:0: [sdm] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.746994] sd 3:0:3:0: [sdm] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.747202]  sdm:
Mar 31 14:34:22 test kernel: [   43.747308] sd 3:0:4:0: [sdn] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.747496] sd 3:0:4:0: [sdn] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.747567] sd 3:0:4:0: [sdn] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.747588] sd 3:0:4:0: [sdn] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.747788]  sdn:
Mar 31 14:34:22 test kernel: [   43.747891] sd 3:0:5:0: [sdo] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.748096] sd 3:0:5:0: [sdo] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.748173] sd 3:0:5:0: [sdo] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.748194] sd 3:0:5:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.748391]  sdo:
Mar 31 14:34:22 test kernel: [   43.748495] sd 3:0:6:0: [sdp] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.748680] sd 3:0:6:0: [sdp] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.748751] sd 3:0:6:0: [sdp] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.748771] sd 3:0:6:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.748964]  sdp:
Mar 31 14:34:22 test kernel: [   43.749068] sd 3:0:7:0: [sdq] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar 31 14:34:22 test kernel: [   43.756312] sd 3:0:7:0: [sdq] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.756384] sd 3:0:7:0: [sdq] Mode Sense: 00 3a 00 00
Mar 31 14:34:22 test kernel: [   43.756406] sd 3:0:7:0: [sdq] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 31 14:34:22 test kernel: [   43.756616]  sdq:
Mar 31 14:34:22 test kernel: [   43.756791] sd 4:0:0:0: [sdr] 585937500 512-byte logical blocks: (300 GB/279 GiB)
Mar 31 14:34:22 test kernel: [   43.757528] sd 4:0:1:0: [sds] 585937500 512-byte logical blocks: (300 GB/279 GiB)
Mar 31 14:34:22 test kernel: [   43.758238] sd 4:0:0:0: [sdr] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.758316] sd 4:0:0:0: [sdr] Mode Sense: bb 00 10 08
Mar 31 14:34:22 test kernel: [   43.758895] sd 4:0:1:0: [sds] Write Protect is off
Mar 31 14:34:22 test kernel: [   43.758969] sd 4:0:1:0: [sds] Mode Sense: bb 00 10 08
Mar 31 14:34:22 test kernel: [   43.759536] sd 4:0:0:0: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 31 14:34:22 test kernel: [   43.760406] sd 4:0:1:0: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 31 14:34:22 test kernel: [   43.762768]  sdr:
Mar 31 14:34:22 test kernel: [   43.763470]  sds: unknown partition table
Mar 31 14:34:22 test kernel: [   43.769036] sd 3:0:7:0: [sdq] Attached SCSI disk
Mar 31 14:34:22 test kernel: [   43.779310]  unknown partition table
Mar 31 14:34:22 test kernel: [   43.779402]  unknown partition table
Mar 31 14:34:22 test kernel: [   43.782542] sd 4:0:0:0: [sdr] Attached SCSI disk
Mar 31 14:34:22 test kernel: [   43.782670] sd 4:0:1:0: [sds] Attached SCSI disk
Mar 31 14:34:22 test kernel: [   43.787659]  unknown partition table
Mar 31 14:34:22 test kernel: [   43.787868] sd 3:0:6:0: [sdp] Attached SCSI disk
Mar 31 14:34:22 test ata_id[3972]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-240' 
Mar 31 14:34:22 test ata_id[3998]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-65-0' 
Mar 31 14:34:24 test ata_id[4039]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-224' 
Mar 31 14:34:24 test kernel: [   45.256504]  unknown partition table
Mar 31 14:34:24 test kernel: [   45.256797] sd 3:0:5:0: [sdo] Attached SCSI disk
Mar 31 14:34:24 test kernel: [   45.323116]  unknown partition table
Mar 31 14:34:24 test kernel: [   45.323356] sd 3:0:2:0: [sdl] Attached SCSI disk
Mar 31 14:34:24 test ata_id[4053]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-176' 
Mar 31 14:34:24 test ata_id[4069]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-192' 
Mar 31 14:34:24 test kernel: [   45.380509]  unknown partition table
Mar 31 14:34:24 test kernel: [   45.380755] sd 3:0:3:0: [sdm] Attached SCSI disk
Mar 31 14:34:24 test kernel: [   45.503057]  unknown partition table
Mar 31 14:34:24 test kernel: [   45.503305] sd 3:0:4:0: [sdn] Attached SCSI disk
Mar 31 14:34:24 test ata_id[4087]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-208' 
Mar 31 14:34:26 test kernel: [   47.542972]  unknown partition table
Mar 31 14:34:26 test kernel: [   47.543237] sd 3:0:1:0: [sdk] Attached SCSI disk
Mar 31 14:34:26 test ata_id[4103]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-160' 
Mar 31 14:34:26 test kernel: [   47.602771]  unknown partition table
Mar 31 14:34:26 test kernel: [   47.603007] sd 3:0:0:0: [sdj] Attached SCSI disk
Mar 31 14:35:01 test /USR/SBIN/CRON[4138]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:35:01 test /USR/SBIN/CRON[4139]: (root) CMD ([ -x /usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" ; [ "$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1 $SA1_OPTIONS 1 1 ; })
Mar 31 14:36:01 test /USR/SBIN/CRON[4248]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:37:01 test /USR/SBIN/CRON[4261]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:38:01 test /USR/SBIN/CRON[4287]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:39:01 test /USR/SBIN/CRON[4307]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:40:01 test /USR/SBIN/CRON[5227]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:40:26 test kernel: [  407.238173] md: bind<sdb>
Mar 31 14:40:29 test kernel: [  410.903983] md: bind<sdc>
Mar 31 14:40:33 test kernel: [  414.715249] md: bind<sdd>
Mar 31 14:40:37 test kernel: [  418.695204] md: bind<sde>
Mar 31 14:40:41 test kernel: [  422.317381] md: bind<sdf>
Mar 31 14:40:45 test kernel: [  426.094069] md: bind<sdg>
Mar 31 14:40:48 test kernel: [  429.863752] md: bind<sdh>
Mar 31 14:40:52 test kernel: [  433.655351] md: bind<sdi>
Mar 31 14:40:56 test kernel: [  437.433736] md: bind<sdj>
Mar 31 14:41:00 test kernel: [  441.104704] md: bind<sdk>
Mar 31 14:41:01 test /USR/SBIN/CRON[5246]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:41:03 test kernel: [  444.852438] md: bind<sdl>
Mar 31 14:41:07 test kernel: [  448.533076] md: bind<sdm>
Mar 31 14:41:11 test kernel: [  452.217321] md: bind<sdn>
Mar 31 14:41:15 test kernel: [  456.194441] md: bind<sdo>
Mar 31 14:41:18 test kernel: [  459.725240] md: bind<sdp>
Mar 31 14:41:22 test kernel: [  463.284026] md: bind<sdq>
Mar 31 14:41:22 test kernel: [  463.327778] raid5: md0 is not clean -- starting background reconstruction
Mar 31 14:41:22 test kernel: [  463.327871] raid5: device sdp operational as raid disk 14
Mar 31 14:41:22 test kernel: [  463.327941] raid5: device sdo operational as raid disk 13
Mar 31 14:41:22 test kernel: [  463.328018] raid5: device sdn operational as raid disk 12
Mar 31 14:41:22 test kernel: [  463.328090] raid5: device sdm operational as raid disk 11
Mar 31 14:41:22 test kernel: [  463.328164] raid5: device sdl operational as raid disk 10
Mar 31 14:41:22 test kernel: [  463.328235] raid5: device sdk operational as raid disk 9
Mar 31 14:41:22 test kernel: [  463.328305] raid5: device sdj operational as raid disk 8
Mar 31 14:41:22 test kernel: [  463.328375] raid5: device sdi operational as raid disk 7
Mar 31 14:41:22 test kernel: [  463.328446] raid5: device sdh operational as raid disk 6
Mar 31 14:41:22 test kernel: [  463.328516] raid5: device sdg operational as raid disk 5
Mar 31 14:41:22 test kernel: [  463.328587] raid5: device sdf operational as raid disk 4
Mar 31 14:41:22 test kernel: [  463.328661] raid5: device sde operational as raid disk 3
Mar 31 14:41:22 test kernel: [  463.328731] raid5: device sdd operational as raid disk 2
Mar 31 14:41:22 test kernel: [  463.328801] raid5: device sdc operational as raid disk 1
Mar 31 14:41:22 test kernel: [  463.328872] raid5: device sdb operational as raid disk 0
Mar 31 14:41:22 test kernel: [  463.330113] raid5: allocated 15854kB for md0
Mar 31 14:41:22 test kernel: [  463.330206] 14: w=1 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330278] 13: w=2 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330349] 12: w=3 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330420] 11: w=4 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330496] 10: w=5 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330567] 9: w=6 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330638] 8: w=7 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330708] 7: w=8 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330779] 6: w=9 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330851] 5: w=10 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330922] 4: w=11 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.330993] 3: w=12 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.331064] 2: w=13 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.331136] 1: w=14 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.331207] 0: w=15 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
Mar 31 14:41:22 test kernel: [  463.331278] raid5: raid level 5 set md0 active with 15 out of 15 devices, algorithm 2
Mar 31 14:41:22 test kernel: [  463.331367] RAID5 conf printout:
Mar 31 14:41:22 test kernel: [  463.331437]  --- rd:15 wd:15
Mar 31 14:41:22 test kernel: [  463.331503]  disk 0, o:1, dev:sdb
Mar 31 14:41:22 test kernel: [  463.331570]  disk 1, o:1, dev:sdc
Mar 31 14:41:22 test kernel: [  463.331636]  disk 2, o:1, dev:sdd
Mar 31 14:41:22 test kernel: [  463.331703]  disk 3, o:1, dev:sde
Mar 31 14:41:22 test kernel: [  463.331770]  disk 4, o:1, dev:sdf
Mar 31 14:41:22 test kernel: [  463.331837]  disk 5, o:1, dev:sdg
Mar 31 14:41:22 test kernel: [  463.331904]  disk 6, o:1, dev:sdh
Mar 31 14:41:22 test kernel: [  463.331971]  disk 7, o:1, dev:sdi
Mar 31 14:41:22 test kernel: [  463.332052]  disk 8, o:1, dev:sdj
Mar 31 14:41:22 test kernel: [  463.332120]  disk 9, o:1, dev:sdk
Mar 31 14:41:22 test kernel: [  463.332187]  disk 10, o:1, dev:sdl
Mar 31 14:41:22 test kernel: [  463.332254]  disk 11, o:1, dev:sdm
Mar 31 14:41:22 test kernel: [  463.332322]  disk 12, o:1, dev:sdn
Mar 31 14:41:22 test kernel: [  463.332389]  disk 13, o:1, dev:sdo
Mar 31 14:41:22 test kernel: [  463.332459]  disk 14, o:1, dev:sdp
Mar 31 14:41:22 test kernel: [  463.332574] md0: detected capacity change from 0 to 7001507889152
Mar 31 14:41:25 test kernel: [  463.332880]  md0: unknown partition table
Mar 31 14:41:25 test kernel: [  466.918068] md: md0 switched to read-write mode.
Mar 31 14:41:25 test kernel: [  466.918688] md: resync of RAID array md0
Mar 31 14:41:25 test kernel: [  466.918759] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Mar 31 14:41:25 test kernel: [  466.918838] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
Mar 31 14:41:25 test kernel: [  466.918945] md: using 128k window, over a total of 488386432 blocks.
Mar 31 14:41:30 test sSMTP[5323]: Sent mail for root@supernas.nl (221 2.0.0 ns1.emsolutions.nl closing connection) uid=0 username=root outbytes=845
Mar 31 14:41:30 test mdadm[3607]: NewArray event detected on md device /dev/md0
Mar 31 14:42:01 test /USR/SBIN/CRON[5335]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:43:01 test /USR/SBIN/CRON[5385]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:44:01 test /USR/SBIN/CRON[5484]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:45:01 test /USR/SBIN/CRON[5616]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:45:01 test /USR/SBIN/CRON[5615]: (root) CMD ([ -x /usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" ; [ "$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1 $SA1_OPTIONS 1 1 ; })
Mar 31 14:46:01 test /USR/SBIN/CRON[5744]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:47:01 test /USR/SBIN/CRON[5877]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:48:01 test /USR/SBIN/CRON[6006]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:49:02 test /USR/SBIN/CRON[6134]: (root) CMD (/etc/webmin/system-status/systeminfo.pl)
Mar 31 14:49:02 test /USR/SBIN/CRON[6135]: (root) CMD (/etc/webmin/status/monitor.pl)
Mar 31 14:49:04 test kernel: [  925.591713] ------------[ cut here ]------------
Mar 31 14:49:04 test kernel: [  925.591804] WARNING: at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/ata/libata-core.c:5186 ata_qc_issue+0x10a/0x347 [libata]()
Mar 31 14:49:04 test kernel: [  925.591878] Hardware name: X7DWU
Mar 31 14:49:04 test kernel: [  925.591931] Modules linked in: iscsi_trgt crc32c nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp w83627hf w83793 hwmon_vid loop netconsole configfs container ehci_hcd uhci_hcd snd_pcm snd_timer evdev rng_core i5k_amb i2c_i801 ioatdma i2c_core usbcore snd soundcore snd_page_alloc nls_base i5400_edac edac_core pcspkr shpchp pci_hotplug processor button dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx thermal fan thermal_sys mvsas libsas scsi_transport_sas sata_mv e1000e igb dca ext3 jbd mbcache sd_mod crc_t10dif ata_piix libata scsi_mod
Mar 31 14:49:04 test kernel: [  925.595379] Pid: 6170, comm: smartctl Not tainted 2.6.32-bpo.3-amd64 #1
Mar 31 14:49:04 test kernel: [  925.595439] Call Trace:
Mar 31 14:49:04 test kernel: [  925.595498]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
Mar 31 14:49:04 test kernel: [  925.595562]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
Mar 31 14:49:04 test kernel: [  925.595626]  [<ffffffff8104dbdc>] ? warn_slowpath_common+0x77/0xa3
Mar 31 14:49:04 test kernel: [  925.595690]  [<ffffffffa0038471>] ? ata_scsi_pass_thru+0x0/0x238 [libata]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa0034129>] ? ata_qc_issue+0x10a/0x347 [libata]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa0038471>] ? ata_scsi_pass_thru+0x0/0x238 [libata]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa00008a5>] ? scsi_done+0x0/0xc [scsi_mod]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa003966a>] ? __ata_scsi_queuecmd+0x185/0x1dc [libata]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa00008a5>] ? scsi_done+0x0/0xc [scsi_mod]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa010ad48>] ? sas_queuecommand+0x93/0x283 [libsas]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa0000b77>] ? scsi_dispatch_cmd+0x1c0/0x23c [scsi_mod]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa000620c>] ? scsi_request_fn+0x3a5/0x506 [scsi_mod]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81177bcc>] ? __blk_run_queue+0x35/0x66
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8116f940>] ? elv_insert+0xad/0x260
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117afa0>] ? blk_execute_rq_nowait+0x5d/0x89
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117b061>] ? blk_execute_rq+0x95/0xd0
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff811770a3>] ? __freed_request+0x26/0x82
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81177122>] ? freed_request+0x23/0x41
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81055ee6>] ? capable+0x22/0x41
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117e1ed>] ? sg_io+0x280/0x3b5
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117e821>] ? scsi_cmd_ioctl+0x217/0x3f2
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8103a537>] ? activate_task+0x20/0x26
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8104a178>] ? try_to_wake_up+0x249/0x259
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810114ce>] ? common_interrupt+0xe/0x13
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81150c21>] ? cap_file_permission+0x0/0x3
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81051f29>] ? current_fs_time+0x1e/0x24
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffffa0079a7e>] ? sd_ioctl+0x9d/0xcb [sd_mod]
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117c215>] ? __blkdev_driver_ioctl+0x69/0x7e
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8117ca10>] ? blkdev_ioctl+0x7e6/0x836
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810c97a2>] ? __do_fault+0x38c/0x3c3
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810ed1da>] ? do_sync_write+0xce/0x113
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8110fcf2>] ? block_ioctl+0x38/0x3c
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810f8f02>] ? vfs_ioctl+0x21/0x6c
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810f9450>] ? do_vfs_ioctl+0x48d/0x4cb
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff8103288f>] ? do_page_fault+0x266/0x282
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff810f94df>] ? sys_ioctl+0x51/0x70
Mar 31 14:49:04 test kernel: [  925.595692]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
Mar 31 14:49:04 test kernel: [  925.595692] ---[ end trace 96d81ffd0a33e7d3 ]---
------=_20100331150303_68758--

