From: Thanos Kyritsis <djart@hellug.gr>
Subject: PROBLEM: PX-116A and SCSI emulation in 2.4.21 and 2.4.22 (The scsi wants to send us more data than expected - discarding data)
Date: Sun, 7 Sep 2003 19:01:21 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030907160121.GA28293@igloo.linux.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.linux.gr ([62.1.205.36]:48904 "EHLO igloo.linux.gr")
	by vger.kernel.org with ESMTP id S263344AbTIGP5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2003 11:57:41 -0400
Received: from igloo.linux.gr (IDENT:1002@localhost [127.0.0.1])
	by igloo.linux.gr (8.12.9/8.12.9/Debian-5) with ESMTP id h87G1bX0028478
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2003 19:02:02 +0300
Received: (from djart@localhost)
	by igloo.linux.gr (8.12.9/8.12.9/Debian-5) id h87G1LQ5028461
	for linux-scsi@vger.kernel.org; Sun, 7 Sep 2003 19:01:21 +0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Good day,

I just installed a Plextor PX-116A DVD-ROM on my Linux system (trying=20
both kernel versions 2.4.21 and 2.4.22) and I am experiencing problems=20
trying to set up scsi emulation for it.
The mobo's chipset is a VIA Apollo pro 133A (Southbridge: vt82c596b)

The Plextor PX-116A when running as ide-scsi with **DMA on** cannot=20
mount disks (cds or dvds), cannot play dvd-movies and cannot readcd a=20
data-cd.
When I disable the DMA, everything works ok.

When I set it up as ide-cd, everything works ok no matter if the DMA is=
=20
on or off.
The drive is currently running at UDMA2 mode (ATA33).

I replaced my old Delta 52X CD-ROM drive with this Plextor DVD-ROM=20
drive. The old Delta CD-ROM had no problem as ide-scsi with DMA on.
(I want to say in other words that I wouldn't expect this to be a=20
hardware problem).

I've pasted below the command output and kernel messages from the=20
following commands:

cdrecord -scanbus
mount=20
readcd=20
mplayer -dvd 1

Then, I'll paste output from:
ver_linux
/proc/cpuinfo
/proc/modules
/proc/ioports
/proc/iomem
lspci -vvv
/proc/scsi/scsi

cdrecord -scanbus doesn't produce any weird kernel messages. All the=20
other commands produce something like this:

ide-scsi: The scsi wants to send us more data than expected - discardin=
g=20
data
ide-scsi: [[ 28 0 0 0 0 0 0 0 2 0 0 0 ]
]

One last thing: I don't know if it's helpful, but I've read in the=20
cdfreaks.com forums that internally this Plextor DVD-ROM drive is=20
actually a Pioneer 120 DVD-ROM. Though, I cannot confirm this piece of=20
information.

Any kind of enlightment on this matter or help would be welcome :)
TIA

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
djart@blackmajesty:~$ cdrecord -scanbus
Cdrecord 2.0 (i686-pc-linux-gnu) Copyright (C) 1995-2002 J=CF=86rg Schi=
lling
Linux sg driver version: 3.1.25
Using libscg version 'schily-0.7'
scsibus0:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,0,0 =C2=A0 =C2=A0 0) 'PLEXTOR ' 'CD-R =C2=
=A0 PX-W1210A' '1.10'
Removable=20
CD-ROM
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,1,0 =C2=A0 =C2=A0 1) 'PLEXTOR ' 'DVD-ROM =
PX-116A ' '1.00'
Removable=20
CD-ROM
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,2,0 =C2=A0 =C2=A0 2) *
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,3,0 =C2=A0 =C2=A0 3) *
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,4,0 =C2=A0 =C2=A0 4) *
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,5,0 =C2=A0 =C2=A0 5) *
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,6,0 =C2=A0 =C2=A0 6) *
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,7,0 =C2=A0 =C2=A0 7) *

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:~$ mount /cdrom/
mount: I could not determine the filesystem type, and none was specifie=
d

Kernel says:

Aug 26 18:22:21 blackmajesty kernel: Attached scsi CD-ROM sr0 at scsi0,=
=20
channel 0, id 0, lun 0
Aug 26 18:22:21 blackmajesty kernel: Attached scsi CD-ROM sr1 at scsi0,=
=20
channel 0, id 1, lun 0
Aug 26 18:22:21 blackmajesty kernel: sr0: scsi3-mmc drive: 32x/32x=20
writer cd/rw xa/form2 cdda tray
Aug 26 18:22:21 blackmajesty kernel: sr1: scsi3-mmc drive: 40x/48x cd/r=
w=20
xa/form2 cdda tray
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 0 0 0 2 0 =
0=20
0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 4096 got 8192=20
limit 4096
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 2 0 0 8 0 =
0=20
0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 16384 got 32768=
=20
limit 16384
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 a 0 0 e 0 =
0=20
0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 28672 got 57344=
=20
limit 28672
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 18 0 0 1a =
0=20
0 0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 53248 got 10649=
6=20
limit 53248
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 0 0 0 1 0 =
0=20
0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 2048 got 4096=20
limit 2048
Aug 26 18:22:22 blackmajesty kernel: FAT: bogus logical sector size 0
Aug 26 18:22:22 blackmajesty kernel: VFS: Can't find a valid FAT=20
filesystem on dev 0b:01.
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 0 0 0 1 0 =
0=20
0 ]
Aug 26 18:22:22 blackmajesty kernel: ]
Aug 26 18:22:22 blackmajesty kernel: ide-scsi: expected 2048 got 4096=20
limit 2048
Aug 26 18:22:22 blackmajesty kernel: FAT: bogus logical sector size 0
Aug 26 18:22:22 blackmajesty kernel: VFS: Can't find a valid FAT=20
filesystem on dev 0b:01.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Oh, when running readcd, it just halts on sector 256 and waits there=20
until I hit Ctr-C and let the scsi command timeout. Sector 256 is not a=
=20
standard. Running the command again may make the drive stop reading at=20
some other sector (i.e 1152).

djart@blackmajesty:~$ readcd dev=3D0,1,0 f=3Dtest1.iso -v
scsidev: '0,1,0'
scsibus: 0 target: 1 lun: 0
Linux sg driver version: 3.1.25
Read =C2=A0speed: =C2=A07040 kB/s (CD =C2=A040x, DVD =C2=A05x).
Write speed: =C2=A0 =C2=A0 0 kB/s (CD =C2=A0 0x, DVD =C2=A00x).
Capacity: 355473 Blocks =3D 710946 kBytes =3D 694 MBytes =3D 728 prMB
Sectorsize: 2048 Bytes
Copy from SCSI (0,1,0) disk to file 'test1.iso'
end: =C2=A0 =C2=A0355473
addr: =C2=A0 =C2=A0 =C2=A0256 cnt: 128

Kernel says:

Aug 26 18:32:22 blackmajesty kernel: ide-scsi: expected 262144 got=20
325632 limit 262144
Aug 26 18:32:22 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:32:22 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 4 80 0 0 80 =
0=20
0 0 ]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:~$ mplayer -dvd 1
[snip mplayer specific stuff ....]

Playing DVD title 1
Reading disc structure, please wait...
libdvdread: Can't open file VIDEO_TS.IFO.
Can't open VMG info!

Kernel says:

Aug 26 18:29:47 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 0 0 0 2 0 =
0=20
0 ]
Aug 26 18:29:47 blackmajesty kernel: ]
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: expected 4096 got 8192=20
limit 4096
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 0 10 0 0 4 0=
=20
0 0 ]
Aug 26 18:29:47 blackmajesty kernel: ]
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: expected 8192 got 16384=20
limit 8192
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: The scsi wants to send u=
s=20
more data than expected - discarding data
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: [[ 28 0 0 0 1 0 0 0 4 0 =
0=20
0 ]
Aug 26 18:29:47 blackmajesty kernel: ]
Aug 26 18:29:47 blackmajesty kernel: ide-scsi: expected 8192 got 16384=20
limit 8192

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:/usr/src/linux/scripts$ sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux blackmajesty 2.4.22 #1 Wed Aug 27 02:33:26 EEST 2003 i686 unknown=
=20
unknown GNU/Linux

Gnu C =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03.2=
=2E3
Gnu make =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3.80
util-linux =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.11z
mount =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02.1=
1z
modutils =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.4.22
e2fsprogs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.33
jfsutils =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.1.2
reiserfsprogs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03.6.8
pcmcia-cs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03.2.4
quota-tools =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03.08.
PPP =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
2.4.1
Linux C Library =C2=A0 =C2=A0 =C2=A0 =C2=A02.3.1
Dynamic linker (ldd) =C2=A0 2.3.1
Linux C++ Library =C2=A0 =C2=A0 =C2=A05.0.3
Procps =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.0.13
Net-tools =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.60
Kbd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1.08
Sh-utils =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5.0
Modules Loaded =C2=A0 =C2=A0 =C2=A0 =C2=A0 i2c-algo-bit w83781d i2c-pro=
c i2c-viapro
i2c-core=20
nvidia ipt_LOG iptable_filter ip_tables ide-scsi scsi_mod 8139too mii=20
crc32 emu10k1 sound ac97_codec soundcore acm usb-uhci usbcore=20
ppp_deflate zlib_deflate ppp_async ppp_generic slhc agpgart lp=20
parport_pc parport apm nls_cp437 nls_iso8859-7 nls_cp737
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:/proc$ cat cpuinfo
processor =C2=A0 =C2=A0 =C2=A0 : 0
vendor_id =C2=A0 =C2=A0 =C2=A0 : GenuineIntel
cpu family =C2=A0 =C2=A0 =C2=A0: 6
model =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 8
model name =C2=A0 =C2=A0 =C2=A0: Pentium III (Coppermine)
stepping =C2=A0 =C2=A0 =C2=A0 =C2=A0: 6
cpu MHz =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 755.291
cache size =C2=A0 =C2=A0 =C2=A0: 256 KB
fdiv_bug =C2=A0 =C2=A0 =C2=A0 =C2=A0: no
hlt_bug =C2=A0 =C2=A0 =C2=A0 =C2=A0 : no
f00f_bug =C2=A0 =C2=A0 =C2=A0 =C2=A0: no
coma_bug =C2=A0 =C2=A0 =C2=A0 =C2=A0: no
fpu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : yes
fpu_exception =C2=A0 : yes
cpuid level =C2=A0 =C2=A0 : 2
wp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: yes
flags =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : fpu vme de pse tsc msr pae m=
ce cx8 sep mtrr pge
mca=20
cmov pat pse36 mmx fxsr sse
bogomips =C2=A0 =C2=A0 =C2=A0 =C2=A0: 1507.32

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
djart@blackmajesty:/proc$ cat modules
i2c-algo-bit =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08424 =C2=A0 0
w83781d =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A020656 =C2=
=A0 0
i2c-proc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A07280 =C2=
=A0 0 [w83781d]
i2c-viapro =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04048 =C2=A0 =
0 (unused)
i2c-core =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 15144 =C2=A0 =
0 [i2c-algo-bit w83781d i2c-proc=20
i2c-viapro]
nvidia =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1628448 =C2=A01=
1 (autoclean)
ipt_LOG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3384 =C2=
=A0 4 (autoclean)
iptable_filter =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01740 =C2=A0 1 (autocle=
an)
ip_tables =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A012512 =C2=A0 =
2 [ipt_LOG iptable_filter]
ide-scsi =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 10352 =C2=A0 =
0
scsi_mod =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 58580 =C2=A0 =
1 [ide-scsi]
8139too =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A015080 =C2=
=A0 1
mii =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 2496 =C2=A0 0 [8139too]
crc32 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 28=
80 =C2=A0 0 [8139too]
emu10k1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A062728 =C2=
=A0 1
sound =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0582=
92 =C2=A0 0 [emu10k1]
ac97_codec =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 13608 =C2=A0 0 [em=
u10k1]
soundcore =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3588 =C2=A0 =
7 [emu10k1 sound]
acm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 6272 =C2=A0 0
usb-uhci =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 23468 =C2=A0 =
0 (unused)
usbcore =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A062624 =C2=
=A0 0 [acm usb-uhci]
ppp_deflate =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3512 =C2=A0 0
zlib_deflate =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 18520 =C2=A0 0 [ppp_def=
late]
ppp_async =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7712 =C2=A0 =
0
ppp_generic =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A016092 =C2=A0 0 [pp=
p_deflate ppp_async]
slhc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A05200 =C2=A0 0 [ppp_generic]
agpgart =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A014032 =C2=
=A0 3
lp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A06912 =C2=A0 0
parport_pc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 15972 =C2=A0 1
parport =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A025536 =C2=
=A0 1 [lp parport_pc]
apm =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
10184 =C2=A0 2
nls_cp437 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 4348 =C2=A0 =
1 (autoclean)
nls_iso8859-7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3612 =C2=A0 2 (autocle=
an)
nls_cp737 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3836 =C2=A0 =
1 (autoclean)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:/proc$ cat ioports
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial(auto)
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vesafb
03f6-03f6 : ide0
03f8-03ff : serial(auto)
0cf8-0cff : PCI conf1
b400-b4ff : Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
=C2=A0 b400-b4ff : 8139too
b800-b807 : Creative Labs SB Live! MIDI/Game Port
d000-d01f : Creative Labs SB Live! EMU10k1
=C2=A0 d000-d01f : EMU10K1
d400-d41f : VIA Technologies, Inc. USB
=C2=A0 d400-d41f : usb-uhci
d800-d80f : VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C=20
PIPC Bus Master IDE
=C2=A0 d800-d807 : ide0
=C2=A0 d808-d80f : ide1
e800-e807 : viapro-smbus
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

djart@blackmajesty:/proc$ cat iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-23ffbfff : System RAM
=C2=A0 00100000-0025b417 : Kernel code
=C2=A0 0025b418-002d1c63 : Kernel data
23ffc000-23ffefff : ACPI Tables
23fff000-23ffffff : ACPI Non-volatile Storage
d5000000-d50000ff : Realtek Semiconductor Co., Ltd.=20
RTL-8139/8139C/8139C+
=C2=A0 d5000000-d50000ff : 8139too
d5800000-d58fffff : Sigma Designs, Inc. REALmagic Hollywood Plus DVD=20
Decoder
d6000000-d6ffffff : PCI Bus #01
=C2=A0 d6000000-d6ffffff : nVidia Corporation NV15DDR [GeForce2 Ti]
d7000000-d7000fff : Brooktree Corporation Bt848 Video Capture
d7f00000-e3ffffff : PCI Bus #01
=C2=A0 d8000000-dfffffff : nVidia Corporation NV15DDR [GeForce2 Ti]
=C2=A0 =C2=A0 d8000000-d85fffff : vesafb
e4000000-e7ffffff : VIA Technologies, Inc. VT82C693A/694x [Apollo=20
PRO133x]
ffff0000-ffffffff : reserved

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

root@blackmajesty:~# lspci -vvv
00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo=20
PRO133x] (rev c4)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: Asustek Computer, Inc.: Unknown =
device 8017
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O- Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort+ >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: Memory at e4000000 (32-bit, prefe=
tchable)
[size=3D64M]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [a0] AGP version 2.0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: RQ=3D32=
 Iso- ArqSz=3D0 Cal=3D0 SBA+ ITACoh-
GART64-=20
HTrans- 64bit- FW- AGP3- Rate=3Dx1,x2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Command: RQ=3D1=
 ArqSz=3D0 Cal=3D0 SBA- AGP+ GART64-
64bit- FW-=20
Rate=3Dx2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [c0] Power Management version=
 2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo=20
MVP3/Pro133x AGP] (prog-if 00 [Normal decode])
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort+ >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Bus: primary=3D00, secondary=3D01, subordin=
ate=3D01, sec-latency=3D0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I/O behind bridge: 0000e000-0000dfff
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Memory behind bridge: d6000000-d6ffffff
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Prefetchable memory behind bridge: d7f00000=
-e3ffffff
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort=
- >Reset-
=46astB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [80] Power Management version=
 2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1+ D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:04.0 ISA bridge: VIA Technologies, Inc. VT82C596 ISA [Mobile South]=20
(rev 23)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: Asustek Computer, Inc.: Unknown =
device 8017
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping+ SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap- 66Mhz- UDF- FastB2B- ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 0

00:04.1 IDE interface: VIA Technologies, Inc. VT82C586/B/686A/B PIPC Bu=
s=20
Master IDE (rev 10) (prog-if 8a [Master SecP PriP])
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping+ SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 4: I/O ports at d800 [size=3D16]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [c0] Power Management version=
 2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:04.2 USB Controller: VIA Technologies, Inc. USB (rev 11) (prog-if 00=
=20
[UHCI])
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: VIA Technologies, Inc. (Wrong ID=
) USB Controller
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV+ VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32, cache line size 08
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin D routed to IRQ 5
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 4: I/O ports at d400 [size=3D32]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [80] Power Management version=
 2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:04.3 Host bridge: VIA Technologies, Inc. VT82C596 Power Management=20
(rev 30)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O- Mem- BusMaster- SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-

00:09.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (re=
v=20
08)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: Creative Labs CT4832 SBLive! Val=
ue
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem- BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32 (500ns min, 5000ns max)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin A routed to IRQ 5
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: I/O ports at d000 [size=3D32]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [dc] Power Management version=
 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1+ D2+ AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:09.1 Input device controller: Creative Labs SB Live! MIDI/Game Port=20
(rev 08)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: Creative Labs Gameport Joystick
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem- BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: I/O ports at b800 [size=3D8]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [dc] Power Management version=
 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1+ D2+ AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:0a.0 Multimedia controller: Sigma Designs, Inc. REALmagic Hollywood=20
Plus DVD Decoder (rev 02)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O- Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin A routed to IRQ 10
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: Memory at d5800000 (32-bit, non-p=
refetchable)=20
[size=3D1M]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [40] Power Management version=
 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd.=20
RTL-8139/8139C/8139C+ (rev 10)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Subsystem: Realtek Semiconductor Co., Ltd. =
RT8139
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 32 (8000ns min, 16000ns max)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin A routed to IRQ 5
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: I/O ports at b400 [size=3D256]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 1: Memory at d5000000 (32-bit, non-p=
refetchable)=20
[size=3D256]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [50] Power Management version=
 2
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1+ D2+ AuxCurrent=3D375mA=20
PME(D0-,D1+,D2+,D3hot+,D3cold+)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-

00:0e.0 Multimedia video controller: Brooktree Corporation Bt848 Video=20
Capture (rev 12)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O- Mem+ BusMaster- SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin A routed to IRQ 10
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: Memory at d7000000 (32-bit, prefe=
tchable)
[size=3D4K]

01:00.0 VGA compatible controller: nVidia Corporation NV15DDR [GeForce2=
=20
Ti] (rev a4) (prog-if 00 [VGA])
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- Me=
mWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- D=
EVSEL=3Dmedium
>TAbort-=20
<TAbort- <MAbort- >SERR- <PERR-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Latency: 248 (1250ns min, 250ns max)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Interrupt: pin A routed to IRQ 11
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 0: Memory at d6000000 (32-bit, non-p=
refetchable)=20
[size=3D16M]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Region 1: Memory at d8000000 (32-bit, prefe=
tchable)
[size=3D128M]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Expansion ROM at d7ff0000 [disabled] [size=3D=
64K]
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [60] Power Management version=
 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Flags: PMEClk- =
DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Capabilities: [44] AGP version 2.0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Status: RQ=3D32=
 Iso- ArqSz=3D0 Cal=3D0 SBA- ITACoh-
GART64-=20
HTrans- 64bit- FW+ AGP3- Rate=3Dx1,x2,x4
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Command: RQ=3D3=
2 ArqSz=3D0 Cal=3D0 SBA- AGP+ GART64-
64bit-=20
=46W- Rate=3Dx2

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
djart@blackmajesty:/proc/scsi$ cat scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
=C2=A0 Vendor: PLEXTOR =C2=A0Model: CD-R =C2=A0 PX-W1210A Rev: 1.10
=C2=A0 Type: =C2=A0 CD-ROM =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ANSI SCSI
revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
=C2=A0 Vendor: PLEXTOR =C2=A0Model: DVD-ROM PX-116A =C2=A0Rev: 1.00
=C2=A0 Type: =C2=A0 CD-ROM =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ANSI SCSI
revision: 02

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


--=20
Kyritsis Athanasios <djart at hellug.gr>
Studying Electrical & Computer Engineering
@ Univ. of Patras, Greece
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
