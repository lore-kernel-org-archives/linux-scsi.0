From: "Douglas A. Tutty" <dtutty@vianet.ca>
Subject: cache settings as requested by [owner@bugs.debian.org: Bug#530557
	closed by Moritz Muehlenhoff <jmm@inutil.org> (Re:
	linux-image-2.6.26-2-686: segfault when cat or view files under
	/proc/megaraid/hba0 to check status)]
Date: Thu, 15 Jul 2010 09:35:08 -0400
Message-ID: <20100715133508.GA6502@blitz.hooton>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.vianet.ca ([209.91.128.19]:46109 "EHLO smtp2.vianet.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267Ab0GONpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2010 09:45:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org

Hello,

Moritz, lower down in the email, suggests that I send the cache settings
for the card to you.  Its an HP NetRaid-1Si, in an HP NetServer LPr,
P-II-450.

I went through the settings accessed via Ctrl-M at boot and wrote down
what I could, FYI, for what its worth.

The 2.6.26 kernel doesn't hang when I look for the LD state (e.g.
Optimal).  On boot, it still says that asking for cache data failed.

Thanks,

Doug.

---


Adapter:
	PowerFail Safeguard = ENABLED
	Read Modify Write mode = OFF
	Cache Flush every 4 seconds
	Emulation: MASS STORAGE
	Auto Rebuild ENABLED
	Cluster DISABLED

LD0:
	Raid = 1
	Size = 21000 MB
	Stripe Size = 64 KB
	Write Policy = WRTHRU
	Read Policy = ADAPTIVE
	Cache Policy = CACHED IO
	Virtual Sizing = DISABLED
	Stripes = 2
	Status OPTIMAL	

LD1:
	Raid = 0
	Size = 27462 MB
	Stripe Size =  64 KB
	Write Policy = WRTHRU
	Read Policy = ADAPTIVE
	Cache Policy = CACHED IO
	Virtual Sizing = DISABLED
	Stripes = 2
	State OPTIMAL

Physical drives: CH0,ID0 and ID1 (both drives are the same):
	
	34731 MB, HP, 36.4GB C 80-D 94 N, SCSI-2

Channel 0: Ultra-2.


	

----- Forwarded message from Debian Bug Tracking System <owner@bugs.debian.org> -----

From: Debian Bug Tracking System <owner@bugs.debian.org>
To: "Douglas A. Tutty" <dtutty@vianet.ca>
Subject: Bug#530557 closed by Moritz Muehlenhoff <jmm@inutil.org> (Re:
	linux-image-2.6.26-2-686: segfault when cat or view files under
	/proc/megaraid/hba0 to check status)
Reply-To: 530557@bugs.debian.org
Date: Wed, 14 Jul 2010 17:06:13 +0000

This is an automatic notification regarding your Bug report
which was filed against the linux-image-2.6.26-2-686 package:

#530557: linux-image-2.6.26-2-686: segfault when cat or view files under /proc/megaraid/hba0 to check status

It has been closed by Moritz Muehlenhoff <jmm@inutil.org>.

Their explanation is attached below along with your original report.
If this explanation is unsatisfactory and you have not received a
better one in a separate message then please contact Moritz Muehlenhoff <jmm@inutil.org> by
replying to this email.


-- 
530557: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=530557
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

Date: Wed, 14 Jul 2010 18:56:18 +0200
From: Moritz Muehlenhoff <jmm@inutil.org>
To: 530557-done@bugs.debian.org
Subject: Re: linux-image-2.6.26-2-686: segfault when cat or view files
	under /proc/megaraid/hba0 to check status

Version: 2.6.32-1

On Tue, Jul 13, 2010 at 07:55:14PM -0400, Douglas A. Tutty wrote:
> It seems to work OK.

Thanks for the feedback. Closing this bug, then.

> I got the linux-image .deb and dpkg -i'd it but it also needed
> linux-base, so I got that too.  dpkg -i'd it, but it needed
> libuuid-perl.  That exists in Etch so aptitude was able to fix things by
> installing that from etch.
> 
> I then rebooted and tested catting the files under /proc/megaraid.
> 
> I'll attach the dmesg and the contents of those files.  Note that the
> driver still can't get the cache data and assumnes write-through.  This
> is a good assumption (since I have that set on the raid card), but it is
> only an assumption.  If the card had a battery-backup, I may have the
> cache set differently.

As for the cache settings: It would probably be best if you could
report these directly to the maintainers:

Neela Syam Kolli <megaraidlinux@lsi.com>
linux-scsi@vger.kernel.org

Cheers,
        Moritz


Date: Mon, 25 May 2009 14:12:37 -0400
From: "Douglas A. Tutty" <dtutty@vianet.ca>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: linux-image-2.6.26-2-686: segfault when cat or view files under
	/proc/megaraid/hba0 to check status

Package: linux-image-2.6.26-2-686
Version: 2.6.26-15lenny2
Severity: normal



-- Package-specific info:
** Version:
Linux version 2.6.26-2-686 (Debian 2.6.26-15lenny2) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Mon May 11 19:00:59 UTC 2009

** Command line:
root=LABEL=root ro 

** Not tainted

** Kernel log:
[   14.408196] uhci_hcd 0000:00:04.2: irq 19, io base 0x00001000
[   14.408196] usb usb1: configuration #1 chosen from 1 choice
[   14.408196] hub 1-0:1.0: USB hub found
[   14.408317] hub 1-0:1.0: 2 ports detected
[   14.506826] input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
[   14.513359] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   14.513445] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.513535] usb usb1: Product: UHCI Host Controller
[   14.513602] usb usb1: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[   14.513673] usb usb1: SerialNumber: 0000:00:04.2
[   14.513939] hub 1-0:1.0: over-current change on port 1
[   14.516001] piix4_smbus 0000:00:04.3: Found 0000:00:04.3 device
[   14.516103] piix4_smbus 0000:00:04.3: Host SMBus controller not enabled!
[   14.516499] ACPI: PCI Interrupt 0000:00:08.0[B] -> GSI 17 (level, low) -> IRQ 17
[   14.516674] ohci_hcd 0000:00:08.0: OHCI Host Controller
[   14.516727] ohci_hcd 0000:00:08.0: new USB bus registered, assigned bus number 2
[   14.516727] ohci_hcd 0000:00:08.0: irq 17, io mem 0xfa000000
[   14.571129] usb usb2: configuration #1 chosen from 1 choice
[   14.571396] hub 2-0:1.0: USB hub found
[   14.571510] hub 2-0:1.0: 2 ports detected
[   14.618933] hub 1-0:1.0: over-current change on port 2
[   14.675440] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   14.675534] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.675619] usb usb2: Product: OHCI Host Controller
[   14.675687] usb usb2: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.675757] usb usb2: SerialNumber: 0000:00:08.0
[   14.676056] ACPI: PCI Interrupt 0000:00:08.1[C] -> GSI 18 (level, low) -> IRQ 18
[   14.676235] ohci_hcd 0000:00:08.1: OHCI Host Controller
[   14.676434] ohci_hcd 0000:00:08.1: new USB bus registered, assigned bus number 3
[   14.676600] ohci_hcd 0000:00:08.1: irq 18, io mem 0xfa001000
[   14.733259] usb usb3: configuration #1 chosen from 1 choice
[   14.733521] hub 3-0:1.0: USB hub found
[   14.733633] hub 3-0:1.0: 2 ports detected
[   14.835435] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   14.835529] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.835615] usb usb3: Product: OHCI Host Controller
[   14.835682] usb usb3: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.835752] usb usb3: SerialNumber: 0000:00:08.1
[   14.836047] ACPI: PCI Interrupt 0000:00:08.2[D] -> GSI 19 (level, low) -> IRQ 19
[   14.836225] ohci_hcd 0000:00:08.2: OHCI Host Controller
[   14.836428] ohci_hcd 0000:00:08.2: new USB bus registered, assigned bus number 4
[   14.836569] ohci_hcd 0000:00:08.2: irq 19, io mem 0xfa002000
[   14.894253] usb usb4: configuration #1 chosen from 1 choice
[   14.894507] hub 4-0:1.0: USB hub found
[   14.894616] hub 4-0:1.0: 2 ports detected
[   14.997216] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   14.997311] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.997396] usb usb4: Product: OHCI Host Controller
[   14.997463] usb usb4: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.997533] usb usb4: SerialNumber: 0000:00:08.2
[   14.997846] ACPI: PCI Interrupt 0000:00:08.3[A] -> GSI 16 (level, low) -> IRQ 16
[   14.998024] ehci_hcd 0000:00:08.3: EHCI Host Controller
[   14.998243] ehci_hcd 0000:00:08.3: new USB bus registered, assigned bus number 5
[   15.020707] ehci_hcd 0000:00:08.3: debug port 1
[   15.020867] ehci_hcd 0000:00:08.3: irq 16, io mem 0xfa004000
[   15.032699] ehci_hcd 0000:00:08.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   15.033159] usb usb5: configuration #1 chosen from 1 choice
[   15.033394] hub 5-0:1.0: USB hub found
[   15.033506] hub 5-0:1.0: 6 ports detected
[   15.139858] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[   15.139954] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.140040] usb usb5: Product: EHCI Host Controller
[   15.140108] usb usb5: Manufacturer: Linux 2.6.26-2-686 ehci_hcd
[   15.140179] usb usb5: SerialNumber: 0000:00:08.3
[   15.203159] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 18 (level, low) -> IRQ 18
[   15.359382] sym0: <895> rev 0x1 at pci 0000:01:04.0 irq 18
[   15.418834] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   15.418925] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.643112] sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
[   16.643112] sym0: open drain IRQ line driver, using on-chip SRAM
[   16.643112] sym0: using LOAD/STORE-based firmware.
[   16.649736] sym0: SCSI BUS has been reset.
[   16.649736] sym0: SCSI BUS mode change from SE to SE.
[   16.649854] scsi1 : sym-2.2.3
[   16.652109] sym0: SCSI BUS has been reset.
[   16.713893] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   16.740564] e100: eth0: e100_probe: addr 0xfa500000, irq 19, MAC addr 00:a0:c9:dd:5f:e2
[   16.886767] No dock devices found.
[   17.184887] libata version 3.00 loaded.
[   17.828090] hda: ATAPI 23X CD-ROM drive, 256kB Cache
[   17.828368] Uniform CD-ROM driver Revision: 3.20
[   19.529571] loop: module loaded
[   19.655412] lp0: using parport0 (interrupt-driven).
[   20.010730] device-mapper: uevent: version 1.0.3
[   20.013195] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   21.200914] padlock: VIA PadLock not detected.
[   21.905276] padlock: VIA PadLock Hash Engine not detected.
[   53.468717] Adding 489972k swap on /dev/mapper/sda2_crypt.  Priority:-1 extents:1 across:489972k
[   56.448890] ip_tables: (C) 2000-2006 Netfilter Core Team
[   57.319859] Netfilter messages via NETLINK v0.30.
[   57.507428] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   59.736235] ctnetlink v0.93: registering with nfnetlink.
[   61.034679] ClusterIP Version 0.8 loaded successfully
[   98.519059] NET: Registered protocol family 10
[   98.520615] lo: Disabled Privacy Extensions
[   98.524463] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  106.619999] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[  281.823652] PPP generic driver version 2.4.2
[  316.182094] PPP BSD Compression module registered
[  316.508906] PPP Deflate Compression module registered

** Loaded modules:
Module                  Size  Used by
ppp_deflate             4224  0 
zlib_deflate           17656  1 ppp_deflate
zlib_inflate           14144  1 ppp_deflate
bsd_comp                4864  0 
ppp_async               7488  1 
crc_ccitt               2080  1 ppp_async
ppp_generic            20028  7 ppp_deflate,bsd_comp,ppp_async
slhc                    5376  1 ppp_generic
ipv6                  235364  20 
iptable_raw             2176  0 
xt_comment              1664  0 
xt_policy               2848  0 
ipt_ULOG                6820  0 
ipt_TTL                 1856  0 
ipt_ttl                 1600  0 
ipt_REJECT              2784  4 
ipt_REDIRECT            1760  0 
ipt_recent              6908  0 
ipt_NETMAP              1760  0 
ipt_MASQUERADE          2592  1 
ipt_LOG                 5028  13 
ipt_ECN                 2336  0 
ipt_ecn                 1888  0 
ipt_CLUSTERIP           5956  0 
ipt_ah                  1664  0 
ipt_addrtype            2304  0 
nf_nat_tftp             1568  0 
nf_nat_snmp_basic       8296  0 
nf_nat_sip              5440  0 
nf_nat_pptp             2880  0 
nf_nat_proto_gre        2212  1 nf_nat_pptp
nf_nat_irc              2080  0 
nf_nat_h323             5728  0 
nf_nat_ftp              2528  0 
nf_nat_amanda           1824  0 
ts_kmp                  1824  5 
nf_conntrack_amanda     3808  1 nf_nat_amanda
nf_conntrack_tftp       4180  1 nf_nat_tftp
nf_conntrack_sip       16092  1 nf_nat_sip
nf_conntrack_proto_sctp     6600  0 
nf_conntrack_pptp       5476  1 nf_nat_pptp
nf_conntrack_proto_gre     4416  1 nf_conntrack_pptp
nf_conntrack_netlink    14176  0 
nf_conntrack_netbios_ns     2368  0 
nf_conntrack_irc        5124  1 nf_nat_irc
nf_conntrack_h323      44712  1 nf_nat_h323
nf_conntrack_ftp        6852  1 nf_nat_ftp
xt_tcpmss               1984  0 
xt_pkttype              1728  4 
xt_physdev              2352  0 
xt_owner                2560  0 
xt_NFQUEUE              1792  0 
xt_NFLOG                1824  0 
xt_multiport            2816  4 
xt_MARK                 2304  0 
xt_mark                 1952  0 
xt_mac                  1728  0 
xt_limit                2180  0 
xt_length               1760  0 
xt_iprange              2272  0 
xt_helper               2112  0 
xt_hashlimit            9360  0 
xt_DSCP                 2944  0 
xt_dscp                 2368  0 
xt_dccp                 2696  0 
xt_conntrack            3488  3 
xt_CONNMARK             2944  0 
xt_connmark             2368  0 
xt_CLASSIFY             1696  0 
xt_tcpudp               2816  75 
xt_state                2016  20 
iptable_nat             4680  1 
nf_nat                 15544  13 ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_netlink,iptable_nat
nf_conntrack_ipv4      12268  26 iptable_nat,nf_nat
nf_conntrack           55540  29 ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
iptable_mangle          2688  1 
nfnetlink               3928  1 nf_conntrack_netlink
iptable_filter          2624  1 
ip_tables              10160  4 iptable_raw,iptable_nat,iptable_mangle,iptable_filter
x_tables               13284  42 xt_comment,xt_policy,ipt_ULOG,ipt_TTL,ipt_ttl,ipt_REJECT,ipt_REDIRECT,ipt_recent,ipt_NETMAP,ipt_MASQUERADE,ipt_LOG,ipt_ECN,ipt_ecn,ipt_CLUSTERIP,ipt_ah,ipt_addrtype,xt_tcpmss,xt_pkttype,xt_physdev,xt_owner,xt_NFQUEUE,xt_NFLOG,xt_multiport,xt_MARK,xt_mark,xt_mac,xt_limit,xt_length,xt_iprange,xt_helper,xt_hashlimit,xt_DSCP,xt_dscp,xt_dccp,xt_conntrack,xt_CONNMARK,xt_connmark,xt_CLASSIFY,xt_tcpudp,xt_state,iptable_nat,ip_tables
sha256_generic         11360  0 
aes_i586                7744  8 
aes_generic            29256  1 aes_i586
cbc                     3264  4 
dm_crypt               11172  1 
crypto_blkcipher       15236  6 cbc,dm_crypt
dm_mod                 46184  9 dm_crypt
lp                      8164  0 
loop                   12748  0 
ide_cd_mod             27652  0 
cdrom                  30176  1 ide_cd_mod
ata_generic             4676  0 
libata                140416  1 ata_generic
dock                    8304  1 libata
ide_pci_generic         3908  0 [permanent]
e100                   28908  0 
sym53c8xx              62936  0 
mii                     4896  1 e100
scsi_transport_spi     19840  1 sym53c8xx
container               3456  0 
snd_pcm_oss            32832  0 
snd_mixer_oss          12320  1 snd_pcm_oss
snd_pcm                62596  1 snd_pcm_oss
psmouse                32336  0 
parport_pc             22500  1 
parport                30988  2 lp,parport_pc
snd_timer              17800  1 snd_pcm
snd                    45604  4 snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
ehci_hcd               28396  0 
ohci_hcd               18500  0 
soundcore               6368  1 snd
i2c_piix4               7216  0 
serio_raw               4740  0 
uhci_hcd               18672  0 
snd_page_alloc          7816  1 snd_pcm
piix                    6568  0 [permanent]
i2c_core               19828  1 i2c_piix4
shpchp                 25528  0 
usbcore               118224  4 ehci_hcd,ohci_hcd,uhci_hcd
ide_core               96136  3 ide_cd_mod,ide_pci_generic,piix
pci_hotplug            23460  1 shpchp
floppy                 47748  0 
pcspkr                  2432  0 
evdev                   8000  0 
jfs                   148812  6 
nls_base                6820  1 jfs
sd_mod                 22200  9 
thermal                15228  0 
processor              32544  1 thermal
fan                     4164  0 
thermal_sys            10856  3 thermal,processor,fan
megaraid               31240  7 
scsi_mod              129324  5 libata,sym53c8xx,scsi_transport_spi,sd_mod,megaraid

** PCI devices:
00:00.0 Host bridge [0600]: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) [8086:7192] (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 64
	Region 0: Memory at <unassigned> (32-bit, prefetchable)

00:04.0 ISA bridge [0601]: Intel Corporation 82371AB/EB/MB PIIX4 ISA [8086:7110] (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:04.1 IDE interface [0101]: Intel Corporation 82371AB/EB/MB PIIX4 IDE [8086:7111] (rev 01) (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at 1020 [size=16]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix

00:04.2 USB Controller [0c03]: Intel Corporation 82371AB/EB/MB PIIX4 USB [8086:7112] (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 1000 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:04.3 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ACPI [8086:7113] (rev 02)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin ? routed to IRQ 9
	Kernel modules: i2c-piix4

00:07.0 PCI bridge [0604]: Digital Equipment Corporation DECchip 21152 [1011:0024] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 57, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=249
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fa100000-fa2fffff
	Prefetchable memory behind bridge: 00000000fa500000-00000000fa5fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel modules: shpchp

00:08.0 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard [10b9:5237]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:08.1 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard [10b9:5237]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fa001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:08.2 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard [10b9:5237]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fa002000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:08.3 USB Controller [0c03]: ALi Corporation USB 2.0 Controller [10b9:5239] (rev 01) (prog-if 20 [EHCI])
	Subsystem: Device [2020:8888]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fa004000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:09.0 PCI bridge [0604]: Intel Corporation 80960RP (i960RP) Microprocessor/Bridge [8086:0960] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

00:09.1 RAID bus controller [0104]: Intel Corporation 80960RP (i960RP) Microprocessor [8086:1960] (rev 03)
	Subsystem: Hewlett-Packard Company NetRAID-1Si [103c:10cd]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fa010000 (32-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at 50000000 [disabled] [size=32K]
	Kernel driver in use: megaraid_legacy
	Kernel modules: megaraid

00:0d.0 VGA compatible controller [0300]: Cirrus Logic GD 5446 [1013:00b8] (rev 45) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device [103c:0001]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at fc000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at fa003000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 50008000 [disabled] [size=32K]
	Kernel modules: cirrusfb

01:03.0 Ethernet controller [0200]: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 [8086:1229] (rev 02)
	Subsystem: Hewlett-Packard Company NetServer 10/100TX [103c:10c0]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 66 (2000ns min, 14000ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fa500000 (32-bit, prefetchable) [size=4K]
	Region 1: I/O ports at 9400 [size=32]
	Region 2: Memory at fa100000 (32-bit, non-prefetchable) [size=1M]
	Kernel driver in use: e100
	Kernel modules: e100, eepro100

01:04.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53c895 [1000:000c] (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 247 (7500ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 9000 [size=256]
	Region 1: Memory at fa201000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at fa200000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: sym53c8xx
	Kernel modules: sym53c8xx




*** notes
Problem:

On up-to-date Etch, I could check the status of my raid array by viewing
or catting files under /proc/megaraid.  On Lenny (with the 1.6.26
kernel), I get a segfault the first time (per boot) but subsequent tries
result in a hung process.  The process is immortal, it cannot be killed,
not even by init on shutdown.

The raid card is a HP NetRaid 1Si.

uname -a:

Linux blitz 2.6.26-2-686 #1 SMP Mon May 11 19:00:59 UTC 2009 i686 GNU/Linux

Please see the output of the following commands:

Serial-terminal capture of the segfault.

Output of lspci -vvxxx (as recommended in the lspci man page).

Output of dmesg.

Let me know if you require any further information.

Thanks,

Doug Tutty (dtutty@vianet.ca)



*** megaraid.err
cd /proc/megatraid
root@blitz:/proc/megaraid# ls
hba0
root@blitz:/proc/megaraid# cd hba0
root@blitz:/proc/megaraid/hba0# ls
battery-status  diskdrives-ch1  mailbox           raiddrives-20-29  stat
config          diskdrives-ch2  raiddrives-0-9    raiddrives-30-39
diskdrives-ch0  diskdrives-ch3  raiddrives-10-19  rebuild-rate
root@blitz:/proc/megaraid/hba0# cat raiddrives-0-9
[  357.190272] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  357.210976] IP: [<f881b883>] :megaraid:mega_internal_command+0x77/0x128
[  357.231076] Oops: 0002 [#1] SMP 
[  357.241430] Modules linked in: ipv6 iptable_raw xt_comment xt_policy ipt_ULOG ipt_TTL ipt_ttl ipt_REJECT ipt_REDIRECT ipt_recent ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state 
 iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables sha256_generic aes_i586 aes_generic cbc dm_crypt crypto_blkcipher dm_mod lp loop ide_cd_mod cdrom ata_generic libata dock ide_pci_generic evdev e100 mii sym53c8xx scsi_transport_spi container psmouse snd_pcm_oss snd_mixer_oss parport_pc parport snd_pcm ehci_hcd uhci_hcd ohci_hcd serio_raw snd_timer snd piix i2c_piix4 soundcore i2c_core snd_page_alloc shpchp ide_core usbcore pci_hotplug floppy pcspkr jfs nls_base sd_mod thermal processor fan thermal_sys megaraid scsi_mod
[  357.607768] 
[  357.607768] Pid: 6559, comm: cat Not tainted (2.6.26-2-686 #1)
[  357.607768] EIP: 0060:[<f881b883>] EFLAGS: 00010246 CPU: 0
[  357.607768] EIP is at mega_internal_command+0x77/0x128 [megaraid]
[  357.607768] EAX: 00000000 EBX: f790b82c ECX: 00000000 EDX: f6f32800
[  357.607768] ESI: f78b8390 EDI: f790b974 EBP: f790b8b0 ESP: f7fdfe8c
[  357.607768]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  357.607768] Process cat (pid: 6559, ti=f7fde000 task=f6d2f680 task.ti=f7fde000)
[  357.607768] Stack: 00000000 f7fdfeb6 f790b34c f790b974 f6f32800 f790b34c f78b8390 f7fdfec8 
[  357.607768]        f6f32c00 f881b977 00042c4c 00000000 80000000 000037d5 00000000 f687d000 
[  357.607768]        f6f32f90 f881ba5d 00000000 f790b34c 00000000 c015b1c7 c0355c80 f7d58000 
[  357.607768] Call Trace:
[  357.607768]  [<f881b977>] mega_adapinq+0x43/0x50 [megaraid]
[  357.607768]  [<f881ba5d>] proc_rdrv+0x60/0x46b [megaraid]
[  357.607768]  [<c015b1c7>] __alloc_pages_internal+0xb5/0x34e
[  357.607768]  [<f881bece>] proc_rdrv_10+0x0/0x1f [megaraid]
[  357.607768]  [<c01a4a61>] proc_file_read+0x0/0x1ff
[  357.607768]  [<c01a4b37>] proc_file_read+0xd6/0x1ff
[  357.607768]  [<c01a4a61>] proc_file_read+0x0/0x1ff
[  357.607768]  [<c01a1362>] proc_reg_read+0x58/0x6b
[  357.607768]  [<c01a130a>] proc_reg_read+0x0/0x6b
[  357.607768]  [<c0174a52>] vfs_read+0x81/0x11e
[  357.607768]  [<c0174ea3>] sys_read+0x3c/0x63
[  357.607768]  [<c0103853>] sysenter_past_esp+0x78/0xb1
[  357.607768]  [<c02b0000>] aer_probe+0xfd/0xff
[  357.607768]  =======================
[  357.607768] Code: c0 ba d0 80 00 00 e8 f1 5f 95 c7 8b 54 24 08 89 44 24 10 89 82 64 05 00 00 8b 42 40 8b 54 24 10 89 02 8b 45 34 89 9d b8 00 00 00 <c6> 00 e1 83 4b 04 01 89 6b 5c 8b 7c 24 08 8b 74 24 04 81 c7 f0 
[  357.607768] EIP: [<f881b883>] mega_internal_command+0x77/0x128 [megaraid] SS:ESP 0068:f7fdfe8c
[  358.127238] ---[ end trace ff7a21a95d1a5409 ]---
Segmentation fault
root@blitz:/proc/megaraid/hba0# cd
root@blitz:~# 
*** dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-686 (Debian 2.6.26-15lenny2) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Mon May 11 19:00:59 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e9400 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003ffffc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffffc00 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe9400 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00f7330] 000f7330
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32496 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.1 present.
[    0.000000] ACPI: RSDP 000F72C0, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 3FFFDE8F, 0030 (r1 HP     HWPC203         1  LTP        0)
[    0.000000] ACPI: FACP 3FFFFB13, 0074 (r1 HP     HWPC203         2 PTL    1E8480)
[    0.000000] ACPI: DSDT 3FFFDEBF, 1C54 (r1     HP HWPC203         1 MSFT  100000A)
[    0.000000] ACPI: FACS 3FFFFFC0, 0040
[    0.000000] ACPI: APIC 3FFFFB87, 0052 (r1 PTLTD    APIC          1  LTP        1)
[    0.000000] ACPI: BOOT 3FFFFBD9, 0027 (r1 PTLTD  $SBFTBL$        1  LTP        1)
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ea000
[    0.000000] PM: Registered nosave memory: 00000000000ea000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260080
[    0.000000] Kernel command line: root=LABEL=root ro 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 449.234 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 1033184k/1048512k available (1769k kernel code, 14576k reserved, 752k data, 244k init, 131008k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02ba5eb - 0xc0376620   ( 752 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02ba5eb   (1769 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084744] Calibrating delay using timer specific routine.. 900.32 BogoMIPS (lpj=1800657)
[    0.085080] Security Framework initialized
[    0.085173] SELinux:  Disabled at boot.
[    0.085248] Capability LSM initialized
[    0.085396] Mount-cache hash table entries: 512
[    0.086256] Initializing cgroup subsys ns
[    0.086338] Initializing cgroup subsys cpuacct
[    0.086408] Initializing cgroup subsys devices
[    0.086578] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.086687] CPU: L2 cache: 512K
[    0.086758] Intel machine check architecture supported.
[    0.086835] Intel machine check reporting enabled on CPU#0.
[    0.086968] Checking 'hlt' instruction... OK.
[    0.105073] ACPI: Core revision 20080321
[    0.114010] ENABLING IO-APIC IRQs
[    0.114471] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.116007] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.116007] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
[    0.116007] ...trying to set up timer as Virtual Wire IRQ... works.
[    0.157727] CPU0: Intel Pentium II (Deschutes) stepping 02
[    0.160010] Booting processor 1/0 ip 6000
[    0.168010] Initializing CPU#1
[    0.168010] Calibrating delay using timer specific routine.. 898.55 BogoMIPS (lpj=1797115)
[    0.168010] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.168010] CPU: L2 cache: 512K
[    0.168010] Intel machine check architecture supported.
[    0.168010] Intel machine check reporting enabled on CPU#1.
[    0.252015] CPU1: Intel Pentium II (Deschutes) stepping 02
[    0.252015] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.256016] Brought up 2 CPUs
[    0.256016] Total of 2 processors activated (1798.88 BogoMIPS).
[    0.256016] CPU0 attaching sched-domain:
[    0.256016]  domain 0: span 0-1
[    0.256016]   groups: 0 1
[    0.256016] CPU1 attaching sched-domain:
[    0.256016]  domain 0: span 0-1
[    0.256016]   groups: 1 0
[    0.256016] net_namespace: 660 bytes
[    0.256138] Booting paravirtualized kernel on bare hardware
[    0.260016] NET: Registered protocol family 16
[    0.260016] ACPI: bus type pci registered
[    0.276017] PCI: PCI BIOS revision 2.10 entry at 0xfdb02, last bus=2
[    0.276017] PCI: Using configuration type 1 for base access
[    0.276017] Setting up standard PCI resources
[    0.288018] ACPI: EC: Look up EC in DSDT
[    0.324257] ACPI: Interpreter enabled
[    0.324257] ACPI: (supports S0)
[    0.324257] ACPI: Using IOAPIC for interrupt routing
[    0.395143] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.395143] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    0.395143] * this clock source is slow. Consider trying other clock sources
[    0.395143] pci 0000:00:04.3: quirk: region 8000-803f claimed by PIIX4 ACPI
[    0.395143] pci 0000:00:04.3: quirk: region 1040-104f claimed by PIIX4 SMB
[    0.395143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.395143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.403143] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.404202] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.405250] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
[    0.406739] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.407760] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.411607] pnp: PnP ACPI init
[    0.411607] ACPI: bus type pnp registered
[    0.531613] pnp: PnP ACPI: found 14 devices
[    0.531613] ACPI: ACPI bus type pnp unregistered
[    0.531613] PnPBIOS: Disabled by ACPI PNP
[    0.531613] PCI: Using ACPI for IRQ routing
[    0.542268] system 00:05: iomem range 0xfffd0000-0xfffeffff could not be reserved
[    0.577797] PCI: Failed to allocate mem resource #6:100000@fa600000 for 0000:01:03.0
[    0.577890] PCI: Bridge: 0000:00:07.0
[    0.577956]   IO window: 9000-9fff
[    0.578023]   MEM window: 0xfa100000-0xfa2fffff
[    0.578091]   PREFETCH window: 0x00000000fa500000-0x00000000fa5fffff
[    0.578169] PCI: Bridge: 0000:00:09.0
[    0.578230]   IO window: disabled.
[    0.578296]   MEM window: disabled.
[    0.580294]   PREFETCH window: disabled.
[    0.580565] NET: Registered protocol family 2
[    0.594586] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.596468] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.602270] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.605299] TCP: Hash tables configured (established 131072 bind 65536)
[    0.605385] TCP reno registered
[    0.610646] NET: Registered protocol family 1
[    0.611345] checking if image is initramfs... it is
[    1.077989] Switched to high resolution mode on CPU 1
[    1.081786] Switched to high resolution mode on CPU 0
[    1.553577] Freeing initrd memory: 2241k freed
[    1.557685] Simple Boot Flag at 0x35 set to 0x1
[    1.561569] audit: initializing netlink socket (disabled)
[    1.561569] type=2000 audit(1243270685.548:1): initialized
[    1.561569] highmem bounce pool size: 64 pages
[    1.561569] Total HugeTLB memory allocated, 0
[    1.561569] VFS: Disk quotas dquot_6.5.1
[    1.561569] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.561569] msgmni has been set to 1767
[    1.561569] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.561569] io scheduler noop registered
[    1.561569] io scheduler anticipatory registered
[    1.561569] io scheduler deadline registered
[    1.561569] io scheduler cfq registered (default)
[    1.561721] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.562039] pci 0000:00:0d.0: Boot video device
[    1.562067] pci 0000:01:03.0: Firmware left e100 interrupts enabled; disabling
[    1.565687] isapnp: Scanning for PnP cards...
[    1.923596] isapnp: No Plug & Play device found
[    1.943613] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.943613] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.943613] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.943613] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[    1.947600] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.947797] 00:0a: ttyS3 at I/O 0x2e8 (irq = 10) is a 16550A
[    1.947797] 00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.959624] brd: module loaded
[    1.959624] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    1.964957] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.964957] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.964957] mice: PS/2 mouse device common for all mice
[    1.967599] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.967599] rtc0: alarms up to one month, y3k
[    1.967599] cpuidle: using governor ladder
[    1.967599] cpuidle: using governor menu
[    1.967678] No iBFT detected.
[    1.967678] TCP cubic registered
[    1.967678] NET: Registered protocol family 17
[    1.967678] Using IPI No-Shortcut mode
[    1.975604] registered taskstats version 1
[    1.975604] rtc_cmos 00:02: setting system clock to 2009-05-25 16:58:06 UTC (1243270686)
[    1.975604] Freeing unused kernel memory: 244k freed
[    1.984458] input: AT Translated Set 2 keyboard as /class/input/input0
[    2.248350] SCSI subsystem initialized
[    2.257957] ACPI: PCI Interrupt 0000:00:09.1[A] -> GSI 17 (level, low) -> IRQ 17
[    2.257957] megaraid: found 0x8086:0x1960:bus 0:slot 9:func 1
[    2.257957] scsi0:Found MegaRAID controller at 0xf880e000, IRQ:17
[    2.334347] megaraid: [F :B ] detected 2 logical drives.
[    2.411786] megaraid: channel[0] is raid.
[    2.463861] scsi0 : LSI Logic MegaRAID F  254 commands 16 targs 4 chans 7 luns
[    2.465939] scsi0: scanning scsi channel 0 for logical drives.
[    2.469945] scsi 0:0:0:0: Direct-Access     MegaRAID LD0 RAID1 21000R   F  PQ: 0 ANSI: 2
[    2.469945] scsi 0:0:1:0: Direct-Access     MegaRAID LD1 RAID0 27462R   F  PQ: 0 ANSI: 2
[    2.477942] scsi0: scanning scsi channel 4 [P0] for physical devices.
[    2.591483] ACPI: ACPI0007:00 is registered as cooling_device0
[    2.591483] ACPI: ACPI0007:01 is registered as cooling_device1
[    6.509082] Driver 'sd' needs updating - please use bus_type methods
[    6.512805] sd 0:0:0:0: [sda] 43008000 512-byte hardware sectors (22020 MB)
[    6.513039] sd 0:0:0:0: [sda] Write Protect is off
[    6.513039] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[    6.513039] sd 0:0:0:0: [sda] Asking for cache data failed
[    6.513039] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.513039] sd 0:0:0:0: [sda] 43008000 512-byte hardware sectors (22020 MB)
[    6.513039] sd 0:0:0:0: [sda] Write Protect is off
[    6.513039] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[    6.513039] sd 0:0:0:0: [sda] Asking for cache data failed
[    6.513039] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    6.513039]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    6.525398] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.531386] sd 0:0:1:0: [sdb] 56242176 512-byte hardware sectors (28796 MB)
[    6.531602] sd 0:0:1:0: [sdb] Write Protect is off
[    6.531681] sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
[    6.531785] sd 0:0:1:0: [sdb] Asking for cache data failed
[    6.531866] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    6.534366] sd 0:0:1:0: [sdb] 56242176 512-byte hardware sectors (28796 MB)
[    6.534366] sd 0:0:1:0: [sdb] Write Protect is off
[    6.534366] sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
[    6.534366] sd 0:0:1:0: [sdb] Asking for cache data failed
[    6.534366] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    6.534366]  sdb: sdb1 sdb2
[    6.537946] sd 0:0:1:0: [sdb] Attached SCSI disk
[    7.218734] JFS: nTxBlock = 8094, nTxLock = 64752
[    9.155316] udevd version 125 started
[   11.789453] input: PC Speaker as /class/input/input1
[   12.197056] Floppy drive(s): fd0 is 1.44M
[   12.228644] FDC 0 is a National Semiconductor PC87306
[   12.712886] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.093900] Uniform Multi-Platform E-IDE driver
[   13.093993] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   13.216009] usbcore: registered new interface driver usbfs
[   13.216729] usbcore: registered new interface driver hub
[   13.219548] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.223651] usbcore: registered new device driver usb
[   13.288206] PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:04.1
[   13.288369] PIIX4: not 100% native mode: will probe irqs later
[   13.288458] PIIX4: IDE port disabled
[   13.288537]     ide0: BM-DMA at 0x1020-0x1027
[   13.288637] Probing IDE interface ide0...
[   13.335029] USB Universal Host Controller Interface driver v3.0
[   13.389767] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.710845] parport_pc 00:0b: reported by Plug and Play ACPI
[   13.710845] parport0: PC-style at 0x378, irq 7 [PCSPP]
[   13.971927] Error: Driver 'pcspkr' is already registered, aborting...
[   14.025787] hda: CD-ROM CDR_U240, ATAPI CD/DVD-ROM drive
[   14.403648] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   14.403847] hda: MWDMA2 mode selected
[   14.404190] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   14.408196] ACPI: PCI Interrupt 0000:00:04.2[D] -> GSI 19 (level, low) -> IRQ 19
[   14.408196] uhci_hcd 0000:00:04.2: UHCI Host Controller
[   14.408196] uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
[   14.408196] uhci_hcd 0000:00:04.2: irq 19, io base 0x00001000
[   14.408196] usb usb1: configuration #1 chosen from 1 choice
[   14.408196] hub 1-0:1.0: USB hub found
[   14.408317] hub 1-0:1.0: 2 ports detected
[   14.506826] input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
[   14.513359] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   14.513445] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.513535] usb usb1: Product: UHCI Host Controller
[   14.513602] usb usb1: Manufacturer: Linux 2.6.26-2-686 uhci_hcd
[   14.513673] usb usb1: SerialNumber: 0000:00:04.2
[   14.513939] hub 1-0:1.0: over-current change on port 1
[   14.516001] piix4_smbus 0000:00:04.3: Found 0000:00:04.3 device
[   14.516103] piix4_smbus 0000:00:04.3: Host SMBus controller not enabled!
[   14.516499] ACPI: PCI Interrupt 0000:00:08.0[B] -> GSI 17 (level, low) -> IRQ 17
[   14.516674] ohci_hcd 0000:00:08.0: OHCI Host Controller
[   14.516727] ohci_hcd 0000:00:08.0: new USB bus registered, assigned bus number 2
[   14.516727] ohci_hcd 0000:00:08.0: irq 17, io mem 0xfa000000
[   14.571129] usb usb2: configuration #1 chosen from 1 choice
[   14.571396] hub 2-0:1.0: USB hub found
[   14.571510] hub 2-0:1.0: 2 ports detected
[   14.618933] hub 1-0:1.0: over-current change on port 2
[   14.675440] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   14.675534] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.675619] usb usb2: Product: OHCI Host Controller
[   14.675687] usb usb2: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.675757] usb usb2: SerialNumber: 0000:00:08.0
[   14.676056] ACPI: PCI Interrupt 0000:00:08.1[C] -> GSI 18 (level, low) -> IRQ 18
[   14.676235] ohci_hcd 0000:00:08.1: OHCI Host Controller
[   14.676434] ohci_hcd 0000:00:08.1: new USB bus registered, assigned bus number 3
[   14.676600] ohci_hcd 0000:00:08.1: irq 18, io mem 0xfa001000
[   14.733259] usb usb3: configuration #1 chosen from 1 choice
[   14.733521] hub 3-0:1.0: USB hub found
[   14.733633] hub 3-0:1.0: 2 ports detected
[   14.835435] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   14.835529] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.835615] usb usb3: Product: OHCI Host Controller
[   14.835682] usb usb3: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.835752] usb usb3: SerialNumber: 0000:00:08.1
[   14.836047] ACPI: PCI Interrupt 0000:00:08.2[D] -> GSI 19 (level, low) -> IRQ 19
[   14.836225] ohci_hcd 0000:00:08.2: OHCI Host Controller
[   14.836428] ohci_hcd 0000:00:08.2: new USB bus registered, assigned bus number 4
[   14.836569] ohci_hcd 0000:00:08.2: irq 19, io mem 0xfa002000
[   14.894253] usb usb4: configuration #1 chosen from 1 choice
[   14.894507] hub 4-0:1.0: USB hub found
[   14.894616] hub 4-0:1.0: 2 ports detected
[   14.997216] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   14.997311] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.997396] usb usb4: Product: OHCI Host Controller
[   14.997463] usb usb4: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[   14.997533] usb usb4: SerialNumber: 0000:00:08.2
[   14.997846] ACPI: PCI Interrupt 0000:00:08.3[A] -> GSI 16 (level, low) -> IRQ 16
[   14.998024] ehci_hcd 0000:00:08.3: EHCI Host Controller
[   14.998243] ehci_hcd 0000:00:08.3: new USB bus registered, assigned bus number 5
[   15.020707] ehci_hcd 0000:00:08.3: debug port 1
[   15.020867] ehci_hcd 0000:00:08.3: irq 16, io mem 0xfa004000
[   15.032699] ehci_hcd 0000:00:08.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   15.033159] usb usb5: configuration #1 chosen from 1 choice
[   15.033394] hub 5-0:1.0: USB hub found
[   15.033506] hub 5-0:1.0: 6 ports detected
[   15.139858] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[   15.139954] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.140040] usb usb5: Product: EHCI Host Controller
[   15.140108] usb usb5: Manufacturer: Linux 2.6.26-2-686 ehci_hcd
[   15.140179] usb usb5: SerialNumber: 0000:00:08.3
[   15.203159] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 18 (level, low) -> IRQ 18
[   15.359382] sym0: <895> rev 0x1 at pci 0000:01:04.0 irq 18
[   15.418834] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   15.418925] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.643112] sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
[   16.643112] sym0: open drain IRQ line driver, using on-chip SRAM
[   16.643112] sym0: using LOAD/STORE-based firmware.
[   16.649736] sym0: SCSI BUS has been reset.
[   16.649736] sym0: SCSI BUS mode change from SE to SE.
[   16.649854] scsi1 : sym-2.2.3
[   16.652109] sym0: SCSI BUS has been reset.
[   16.713893] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   16.740564] e100: eth0: e100_probe: addr 0xfa500000, irq 19, MAC addr 00:a0:c9:dd:5f:e2
[   16.886767] No dock devices found.
[   17.184887] libata version 3.00 loaded.
[   17.828090] hda: ATAPI 23X CD-ROM drive, 256kB Cache
[   17.828368] Uniform CD-ROM driver Revision: 3.20
[   19.529571] loop: module loaded
[   19.655412] lp0: using parport0 (interrupt-driven).
[   20.010730] device-mapper: uevent: version 1.0.3
[   20.013195] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   21.200914] padlock: VIA PadLock not detected.
[   21.905276] padlock: VIA PadLock Hash Engine not detected.
[   53.468717] Adding 489972k swap on /dev/mapper/sda2_crypt.  Priority:-1 extents:1 across:489972k
[   56.448890] ip_tables: (C) 2000-2006 Netfilter Core Team
[   57.319859] Netfilter messages via NETLINK v0.30.
[   57.507428] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   59.736235] ctnetlink v0.93: registering with nfnetlink.
[   61.034679] ClusterIP Version 0.8 loaded successfully
[   98.519059] NET: Registered protocol family 10
[   98.520615] lo: Disabled Privacy Extensions
[   98.524463] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  106.619999] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[  281.823652] PPP generic driver version 2.4.2
[  316.182094] PPP BSD Compression module registered
[  316.508906] PPP Deflate Compression module registered

*** lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 64
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
00: 86 80 92 71 06 01 00 22 02 00 00 06 00 40 00 00
10: 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 8c 05 00 00 00 00 00 11 03 10 11 01 00 00 00 11
60: 10 20 30 40 50 60 70 80 00 23 00 00 00 00 00 00
70: 20 1f 0a 78 aa aa 13 01 00 ff 96 00 10 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 04 61 00 00 00 05 00 00 00 00 00 00
a0: 00 00 00 00 03 02 00 1f 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 ff ff ff ff 18 0c ff ff 7f 00 00 00
d0: 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00 00
e0: d4 b6 ff e3 91 3e 00 80 2c d3 f7 cf 9d 3e 00 00
f0: 40 01 00 00 00 f8 00 60 20 0f 00 00 00 00 00 00

00:04.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 10 71 0f 00 80 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 cd 00 e0 01
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 89 85 8f 8b 10 00 00 00 00 f2 00 00 00 00 00 00
70: 00 00 00 00 00 00 0c 0c 00 00 00 00 00 00 00 00
80: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 05 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 25 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 28 0f 00 00 00 00 00 00

00:04.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at 1020 [size=16]
	Kernel driver in use: PIIX_IDE
	Kernel modules: piix
00: 86 80 11 71 05 00 80 02 01 80 01 01 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 a3 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 28 0f 00 00 00 00 00 00

00:04.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 1000 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd
00: 86 80 12 71 05 00 80 02 01 00 03 0c 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 28 0f 00 00 00 00 00 10

00:04.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin ? routed to IRQ 9
	Kernel modules: i2c-piix4
00: 86 80 13 71 03 00 80 02 02 00 80 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 38 00 00 77 00 00 02 00 00 00 00
60: 40 80 20 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 41 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 28 0f 00 00 00 00 00 00

00:07.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 57, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=249
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fa100000-fa2fffff
	Prefetchable memory behind bridge: 00000000fa500000-00000000fa5fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=220mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Kernel modules: shpchp
00: 11 10 24 00 47 01 90 02 03 00 04 06 08 39 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 f9 91 91 80 02
20: 10 fa 20 fa 51 fa 51 fa 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 07 02
40: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 0c 3e 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 01 01
e0: 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:08.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: b9 10 37 52 57 01 b0 02 03 10 03 0c 08 20 80 00
10: 00 00 00 fa 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 37 52
30: 00 00 00 00 60 00 00 00 00 00 00 00 05 02 00 50
40: 00 00 1f 00 e0 02 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 02 d8 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:08.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fa001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: b9 10 37 52 57 01 b0 02 03 10 03 0c 08 20 80 00
10: 00 10 00 fa 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 37 52
30: 00 00 00 00 60 00 00 00 00 00 00 00 0f 03 00 50
40: 00 00 1f 00 e0 02 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 02 d8 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:08.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10 [OHCI])
	Subsystem: ALi Corporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fa002000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd
00: b9 10 37 52 57 01 b0 02 03 10 03 0c 08 20 80 00
10: 00 20 00 fa 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 37 52
30: 00 00 00 00 60 00 00 00 00 00 00 00 0b 04 00 50
40: 00 00 1f 00 e0 02 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 02 d8 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:08.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Device 2020:8888
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fa004000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=0090
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: b9 10 39 52 56 01 b0 02 01 20 03 0c 08 20 80 00
10: 00 40 00 fa 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 20 20 88 88
30: 00 00 00 00 50 00 00 00 00 00 00 00 09 01 00 50
40: 01 02 00 fe 00 00 10 c4 00 00 00 00 00 00 00 00
50: 01 58 02 c8 00 00 00 00 0a 00 90 20 00 00 00 00
60: 20 20 7f 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 00 00 00 00 00 08 c0 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.0 PCI bridge: Intel Corporation 80960RP (i960RP) Microprocessor/Bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp
00: 86 80 60 09 47 01 80 02 03 00 04 06 08 20 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 20 f0 00 80 22
20: f0 ff 00 00 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00
40: 18 00 1f 00 00 00 00 00 08 00 00 00 a8 2a 01 00
50: 0f 00 00 00 00 00 00 00 00 b0 00 b0 04 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:09.1 RAID bus controller: Intel Corporation 80960RP (i960RP) Microprocessor (rev 03)
	Subsystem: Hewlett-Packard Company NetRAID-1Si
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fa010000 (32-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at 50000000 [disabled] [size=32K]
	Kernel driver in use: megaraid_legacy
	Kernel modules: megaraid
00: 86 80 60 19 16 01 80 02 03 00 04 01 08 20 80 00
10: 08 00 01 fa 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 cd 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 ff ff 00 00 20 d0 08 00 00 d0 00 00 00 f0
50: 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 10 50 b8 37 00 00 00 b0 00 00 00 00
70: 00 00 00 00 00 80 ff ff 00 00 f8 fe 00 00 00 00
80: 00 00 00 00 00 00 00 00 36 01 00 00 00 00 00 00
90: 00 00 00 00 40 00 00 00 06 01 80 02 9c 11 00 0f
a0: 44 33 00 00 00 00 00 00 18 00 01 00 ac 12 00 00
b0: b0 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0d.0 VGA compatible controller: Cirrus Logic GD 5446 (rev 45) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 0001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at fc000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at fa003000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 50008000 [disabled] [size=32K]
	Kernel modules: cirrusfb
00: 13 10 b8 00 03 00 00 02 45 00 00 03 00 00 00 00
10: 08 00 00 fc 00 30 00 fa 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 01 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:03.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 02)
	Subsystem: Hewlett-Packard Company NetServer 10/100TX
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 66 (2000ns min, 14000ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fa500000 (32-bit, prefetchable) [size=4K]
	Region 1: I/O ports at 9400 [size=32]
	Region 2: Memory at fa100000 (32-bit, non-prefetchable) [size=1M]
	Kernel driver in use: e100
	Kernel modules: e100, eepro100
00: 86 80 29 12 47 01 80 02 02 00 00 02 00 42 00 00
10: 08 00 50 fa 01 94 00 00 00 00 10 fa 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 c0 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 08 38
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:04.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 247 (7500ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 9000 [size=256]
	Region 1: Memory at fa201000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at fa200000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: sym53c8xx
	Kernel modules: sym53c8xx
00: 00 10 0c 00 57 01 00 02 01 00 00 01 08 f7 00 00
10: 01 90 00 00 00 10 20 fa 00 00 20 fa 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0f 01 1e 40
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: da 00 00 07 47 00 0f 0b 00 00 00 00 80 00 00 02
90: ff 50 d8 37 00 ff ff ff 00 f0 31 11 a0 03 20 fa
a0: 00 08 24 01 00 00 00 50 b8 03 20 fa c0 03 20 fa
b0: 00 00 20 fa 78 10 cf 37 4e 6d 00 81 c0 03 40 fa
c0: 8f 15 00 00 00 00 d0 0e 0c 00 80 00 07 0c 02 80
d0: 00 20 a0 80 00 00 a0 80 00 00 a0 80 00 01 ff 40
e0: 16 90 65 25 0e be d5 b6 09 00 80 d5 fc d7 6f f4
f0: 10 00 a6 14 8f 55 13 17 0b 0a 00 b0 b8 6d 65 2d



-- System Information:
Debian Release: 5.0.1
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: i386 (i686)

Kernel: Linux 2.6.26-2-686 (SMP w/2 CPU cores)
Locale: LANG=en_CA.UTF-8, LC_CTYPE=en_CA.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages linux-image-2.6.26-2-686 depends on:
ii  debconf [debconf-2.0]         1.5.24     Debian configuration management sy
ii  initramfs-tools [linux-initra 0.92o      tools for generating an initramfs
ii  module-init-tools             3.4-1      tools for managing Linux kernel mo

Versions of packages linux-image-2.6.26-2-686 recommends:
ii  libc6-i686                    2.7-18     GNU C Library: Shared libraries [i

Versions of packages linux-image-2.6.26-2-686 suggests:
ii  grub                     0.97-47lenny2   GRand Unified Bootloader (Legacy v
ii  linux-doc-2.6.26         2.6.26-15lenny2 Linux kernel specific documentatio

-- debconf-show failed




----- End forwarded message -----
