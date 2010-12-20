From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Mon, 20 Dec 2010 11:05:07 +0100
Message-ID: <201012201105.08993.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3139406.JiAHbhY5Yt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--nextPart3139406.JiAHbhY5Yt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

top - 10:49:07 up 3 days, 14:24,  8 users,  load average: 2.31, 2.62, 2.28
Tasks: 198 total,   2 running, 194 sleeping,   0 stopped,   2 zombie
Cpu(s):  6.8%us, 93.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, =20
0.0%st
Mem:   2073660k total,  1941152k used,   132508k free,   153876k buffers
Swap:  4000180k total,   243452k used,  3756728k free,   676612k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND       =
                                       =20
  735 root      20   0     0    0    0 R 85.2  0.0 137:28.94 scsi_eh_11

I don't see anything in dmesg. Everything appears to work as normal,=20
except for the slowness. Which got a bit better upon renicing scsi_eh_11=20
to 19 (not knowing whether its really safe, but it works for now).

Interrupts appear to be within usual range as well:

martin@shambhala:~> vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----
cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id=
=20
wa
 2  0 243052  88528 154520 677228   10   28   171   374  416  195 36 20 38 =
=20
6
 3  0 243052  88512 154520 677228    0    0     0     0 1471  992 45 55  0 =
=20
0
 2  0 243052  88324 154520 677228    0    0     0     0 1181  985 49 51  0 =
=20
0
 3  0 243052  88932 154520 677228    0    0     0     0 1339 1672 46 54  0 =
=20
0
 2  0 243052  88900 154520 677228    0    0     0    44 1222 1327 50 50  0 =
=20
0
 3  0 243052  88900 154520 677228    0    0     0     0 1216 1409 48 52  0 =
=20
0

Kernel in use:

martin@shambhala:~> cat /proc/version
Linux version 2.6.37-rc6-tp42-00009-gb3444d1 (martin@shambhala) (gcc=20
version 4.4.5 (Debian 4.4.5-8) ) #6 PREEMPT Thu Dec 16 19:25:32 CET 2010

I never saw this with 2.6.36 or 2.7.37-rc3.

I am using a Delock PCMCIA eSATA adapter with Silicon Image controller=20
from time to time. Yesterday evening for example. Maybe it has to do with=20
removing it again. Well it got scsi11 for one of its port:

Dec 19 21:56:24 shambhala kernel: pcmcia_socket pcmcia_socket0: pccard:=20
CardBus card inserted into slot 0
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: [1095:3512] type 0=20
class 0x000180
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 10: [io =20
0x0000-0x0007]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 14: [io =20
0x0000-0x0003]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 18: [io =20
0x0000-0x0007]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 1c: [io =20
0x0000-0x0003]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 20: [io =20
0x0000-0x000f]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 24: [mem=20
0x00000000-0x000001ff]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: reg 30: [mem=20
0x00000000-0x0007ffff pref]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: supports D1 D2
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 6: assigned [mem=20
0xeff80000-0xefffffff pref]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 5: assigned [mem=20
0xcffffe00-0xcfffffff]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 5: set to [mem=20
0xcffffe00-0xcfffffff] (PCI address [0xcffffe00-0xcfffffff])
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 4: assigned [io =20
0x8cf0-0x8cff]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 4: set to [io =20
0x8cf0-0x8cff] (PCI address [0x8cf0-0x8cff])
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 0: assigned [io =20
0x8ce8-0x8cef]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 0: set to [io =20
0x8ce8-0x8cef] (PCI address [0x8ce8-0x8cef])
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 2: assigned [io =20
0x8ce0-0x8ce7]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 2: set to [io =20
0x8ce0-0x8ce7] (PCI address [0x8ce0-0x8ce7])
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 1: assigned [io =20
0x8cdc-0x8cdf]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 1: set to [io =20
0x8cdc-0x8cdf] (PCI address [0x8cdc-0x8cdf])
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 3: assigned [io =20
0x8cd8-0x8cdb]
Dec 19 21:56:24 shambhala kernel: pci 0000:03:00.0: BAR 3: set to [io =20
0x8cd8-0x8cdb] (PCI address [0x8cd8-0x8cdb])
Dec 19 21:56:24 shambhala kernel: sata_sil 0000:03:00.0: enabling device=20
(0000 -> 0003)
Dec 19 21:56:24 shambhala kernel: sata_sil 0000:03:00.0: PCI INT A ->=20
Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Dec 19 21:56:24 shambhala kernel: sata_sil 0000:03:00.0: Applying R_ERR on=
=20
DMA activate FIS errata fix
Dec 19 21:56:24 shambhala kernel: sata_sil 0000:03:00.0: setting latency=20
timer to 64
Dec 19 21:56:24 shambhala kernel: scsi11 : sata_sil
Dec 19 21:56:24 shambhala kernel: scsi12 : sata_sil
Dec 19 21:56:24 shambhala kernel: ata9: SATA max UDMA/100 mmio=20
m512@0xcffffe00 tf 0xcffffe80 irq 11
Dec 19 21:56:24 shambhala kernel: ata10: SATA max UDMA/100 mmio=20
m512@0xcffffe00 tf 0xcffffec0 irq 11
Dec 19 21:56:24 shambhala kernel: ata9: SATA link down (SStatus 0 SControl=
=20
310)
Dec 19 21:56:24 shambhala kernel: ata10: SATA link down (SStatus 0=20
SControl 310)
Dec 19 21:56:27 shambhala kernel: ata9: hard resetting link
Dec 19 21:56:30 shambhala kernel: ata9: SATA link up 1.5 Gbps (SStatus 113=
=20
SControl 310)
Dec 19 21:56:30 shambhala kernel: ata9.00: ATA-8: Hitachi HTS545050B9A300,=
=20
PB4OC60G, max UDMA/133
Dec 19 21:56:30 shambhala kernel: ata9.00: 976773168 sectors, multi 0:=20
LBA48 NCQ (depth 0/32)
Dec 19 21:56:30 shambhala kernel: ata9.00: configured for UDMA/100
Dec 19 21:56:30 shambhala kernel: ata9: EH complete
Dec 19 21:56:30 shambhala kernel: scsi 11:0:0:0: Direct-Access     ATA     =
=20
Hitachi HTS54505 PB4O PQ: 0 ANSI: 5
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: Attached scsi generic sg2=20
type 0
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: [sdb] 976773168 512-byte=20
logical blocks: (500 GB/465 GiB)
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: [sdb] Write Protect is off
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: [sdb] Mode Sense: 00 3a 00=20
00
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: [sdb] Write cache: enabled,=
=20
read cache: enabled, doesn't support DPO
Dec 19 21:56:30 shambhala kernel: sdb: sdb1 sdb3
Dec 19 21:56:30 shambhala kernel: sd 11:0:0:0: [sdb] Attached SCSI disk

Removal appeared to be fine:

Dec 19 23:10:34 shambhala kernel: ata9.00: disabled
Dec 19 23:10:34 shambhala kernel: sd 11:0:0:0: [sdb] Synchronizing SCSI=20
cache
Dec 19 23:10:34 shambhala kernel: sd 11:0:0:0: [sdb]  Result:=20
hostbyte=3D0x04 driverbyte=3D0x00
Dec 19 23:10:34 shambhala kernel: sd 11:0:0:0: [sdb] Stopping disk
Dec 19 23:10:34 shambhala kernel: sd 11:0:0:0: [sdb] START_STOP FAILED
Dec 19 23:10:34 shambhala kernel: sd 11:0:0:0: [sdb]  Result:=20
hostbyte=3D0x04 driverbyte=3D0x00
Dec 19 23:10:34 shambhala kernel: sata_sil 0000:03:00.0: PCI INT A=20
disabled

Any hints on what to try to get more information? I keep the ThinkPad T42=20
running for a while to wait for some hints.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3139406.JiAHbhY5Yt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk0PKlQACgkQmRvqrKWZhMd1AQCfRnZvOXqlleUKcs8POM56VgMB
WI0An1DOPYQd7nScsCdktrigrS5kvkh/
=ROyU
-----END PGP SIGNATURE-----

--nextPart3139406.JiAHbhY5Yt--
