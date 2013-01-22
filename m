From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 11:05:35 +0000
Message-ID: <1358852735.2387.34.camel@dabdike.int.hansenpartnership.com>
References: <jmunm9$90r$2@speranza.aioe.org>
	 <201204301814.21525.Martin@lichtvoll.de>
	 <CAGZeNoc82T0jS=Sg3d2umqi6PjAWjOKjqK2RbuK+QfAzN3Pmww@mail.gmail.com>
	 <201205010044.24643.Martin@lichtvoll.de>
	 <CAGZeNoeSEtTMK22+JcsG7xRRrbsQwgJV5iLgWenrX=rvLr-ZXQ@mail.gmail.com>
	 <CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g@mail.gmail.com>
	 <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

[SCSI and USB lists added, message quoted in entirety]
On Sat, 2013-01-19 at 21:40 +0000, Ellwood Blues wrote:
> Hi.
>=20
> I've had this problem for so long that today after compiling kernel
> 3.7.3 and not getting any improvements I decided to let you know that
> some of us still only able to use our GPT 3TB hard disks only on
> Windows.
>=20
> On linux only hdparm and gdisk see 3TB but also see some kind of
> corruption on the alternate GPT which is not true because on windows
> works flawlessly.
>=20
> I hope you won't take too long to make it work because this is the
> only reason I still loging in on windows, before buying this disk I
> didn't log in on windows at all.
>=20
> I don't need the EFI drivers to work because the BIOS is not ready fo=
r
> that, I only would like to read and write on the disk which is alread=
y
> half full and cannot do any new experiments trying to fix it with
> gdisk.
>=20
> I only need the kernel GPT drivers to work out.

The taxonomy is that the device isn't addressable over 2TB.  That smell=
s
very like a non large block problem.  More on this below.

> Cheers.
>=20
>=20
>=20
>=20
> ---------- Forwarded message ----------
> From: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: 2012/6/22
> Subject: Fwd: 2TB USB hard drive for backing up
> To: 678568-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
>=20
>=20
> ---------- Forwarded message ----------
> From: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: 2012/5/3
> Subject: Re: 2TB USB hard drive for backing up
> To: debian-user-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org
>=20
>=20
> 2012/4/30 Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>:
> > Am Montag, 30. April 2012 schrieb Ellwood Blues:
> >> 2012/4/30 Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>:
> >> > Am Montag, 30. April 2012 schrieb Chris Bannister:
> >> >> On Sun, Apr 29, 2012 at 08:27:03PM +0200, Martin Steigerwald wr=
ote:
> >> >> > Hmmm, I=B4d avoid those with 4 KB hardware sectors that lie t=
o the
> >> >> > OS they have 512 byte sectors. Although I think even those sh=
ould
> >> >> > work. But with 512 byte sectors you have a 2 TB limit when yo=
u
> >> >> > use MBR partitioning.
> >> >> >
> >> >> > 3 TB disks with 4 KB sectors both hardware (physical) and sof=
tware
> >> >> > (logical) should just work, provided the Linux is new enough.
> >> >> >
> >> >> > On Squeeze use -cu as additional options (see manpage).
> >> >>
> >> >> Sorry for jumping in here, but I can't figure out (from your po=
st)
> >> >> which command requires the additional options: -cu. Which manpa=
ge?
> >> >
> >> > fdisk. Sorry if I didn=B4t mention it anywhere in my post.
> >>
> >> Thanks, I've tried everything but not success. The problem is that=
 the
> >> disk is already half full and aligned with WD tools. I am just wai=
ting
> >> for linux to be able to read it and write it as efficiently as Win=
dows
> >> does it, at the moment I am not able to read it, which is very
> >> frustrating.
> >
> > I would like to see some information from the disk, like
> >
> > - relevant stuff from hdparm -I /dev/yourdisk (feel free to skip se=
rial
> > number if you do not want to post it here)
> > - fdisk -cul /dev/yourdisk
> > - tail -fn0 /var/log/syslog / dmesg when the kernel detects the dis=
k
> >
> > for starters.
> >
> > You need to use GPT if the disk reports 512 byte sectors to the OS.=
 Thats
> > no problem, when its just a data disk. Try gdisk on the disk.
>=20
> Sorry for the delay. Her you have what you've asked attached as files
> and as text on the message:
>=20
>=20
> /dev/sdf:
>=20
> ATA device, with non-removable media
>        Model Number:       WDC WD30EZRX-00MMMB0
>        Serial Number:      WD-WCAWZxxxxxxx
>        Firmware Revision:  80.00A80
>        Transport:          Serial, SATA 1.0a, SATA II Extensions, SAT=
A Rev
> 2.5, SATA Rev 2.6, SATA Rev 3.0
> Standards:
>        Supported: 8 7 6 5
>        Likely used: 8
> Configuration:
>        Logical         max     current
>        cylinders       16383   16383
>        heads           16      16
>        sectors/track   63      63
>        --
>        CHS current addressable sectors:   16514064
>        LBA    user addressable sectors:  268435455
>        LBA48  user addressable sectors: 5860533168
>        Logical  Sector size:                   512 bytes
>        Physical Sector size:                  4096 bytes
>        Logical Sector-0 offset:                  0 bytes
>        device size with M =3D 1024*1024:     2861588 MBytes
>        device size with M =3D 1000*1000:     3000592 MBytes (3000 GB)
>        cache/buffer size  =3D unknown
> Capabilities:
>        LBA, IORDY(can be disabled)
>        Queue depth: 32
>        Standby timer values: spec'd by Standard, with device specific=
 minimum
>        R/W multiple sector transfer: Max =3D 16  Current =3D 0
>        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *ud=
ma6
>             Cycle time: min=3D120ns recommended=3D120ns
>        PIO: pio0 pio1 pio2 pio3 pio4
>             Cycle time: no flow control=3D120ns  IORDY flow control=3D=
120ns
> Commands/features:
>        Enabled Supported:
>           *    SMART feature set
>                Security Mode feature set
>           *    Power Management feature set
>           *    Write cache
>           *    Look-ahead
>           *    Host Protected Area feature set
>           *    WRITE_BUFFER command
>           *    READ_BUFFER command
>           *    NOP cmd
>           *    DOWNLOAD_MICROCODE
>                Power-Up In Standby feature set
>           *    SET_FEATURES required to spinup after power up
>                SET_MAX security extension
>           *    48-bit Address feature set
>           *    Device Configuration Overlay feature set
>           *    Mandatory FLUSH_CACHE
>           *    FLUSH_CACHE_EXT
>           *    SMART error logging
>           *    SMART self-test
>           *    General Purpose Logging feature set
>           *    64-bit World wide name
>           *    {READ,WRITE}_DMA_EXT_GPL commands
>           *    Segmented DOWNLOAD_MICROCODE
>           *    Gen1 signaling speed (1.5Gb/s)
>           *    Gen2 signaling speed (3.0Gb/s)
>           *    Gen3 signaling speed (6.0Gb/s)
>           *    Native Command Queueing (NCQ)
>           *    Host-initiated interface power management
>           *    Phy event counters
>           *    NCQ priority information
>                DMA Setup Auto-Activate optimization
>           *    Software settings preservation
>           *    SMART Command Transport (SCT) feature set
>           *    SCT LBA Segment Access (AC2)
>           *    SCT Features Control (AC4)
>           *    SCT Data Tables (AC5)
>                unknown 206[12] (vendor specific)
>                unknown 206[13] (vendor specific)
> Security:
>        Master password revision code =3D 65534
>                supported
>        not     enabled
>        not     locked
>        not     frozen
>        not     expired: security count
>                supported: enhanced erase
>        more than 508min for SECURITY ERASE UNIT. more than 508min for
> ENHANCED SECURITY ERASE UNIT.
> Logical Unit WWN Device Identifier: 50014ee25b5ed142
>        NAA             : 5
>        IEEE OUI        : 0014ee
>        Unique ID       : 25b5ed142
> Checksum: correct
>=20
>=20
>=20
>=20
>=20
>=20
> May  3 18:18:50 relampago3 kernel: [ 3931.976021] usb 1-4: new
> high-speed USB device number 4 using ehci_hcd
> May  3 18:18:50 relampago3 kernel: [ 3932.108900] usb 1-4: New USB
> device found, idVendor=3D152d, idProduct=3D2329
> May  3 18:18:50 relampago3 kernel: [ 3932.108907] usb 1-4: New USB
> device strings: Mfr=3D1, Product=3D2, SerialNumber=3D5
> May  3 18:18:50 relampago3 kernel: [ 3932.108911] usb 1-4: Product:
> USB to ATA/ATAPI Bridge
> May  3 18:18:50 relampago3 kernel: [ 3932.108914] usb 1-4: Manufactur=
er: JMicron
> May  3 18:18:50 relampago3 kernel: [ 3932.108917] usb 1-4:
> SerialNumber: 152D20329000
> May  3 18:18:50 relampago3 kernel: [ 3932.110324] usb-storage 1-4:1.0=
:
> Quirks match for vid 152d pid 2329: 8020

This is the first problem.  I think only UAS has been tested over 2TB

> May  3 18:18:50 relampago3 kernel: [ 3932.110360] scsi7 : usb-storage=
 1-4:1.0
> May  3 18:18:50 relampago3 mtp-probe: checking bus 1, device 4:
> "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4"
> May  3 18:18:50 relampago3 mtp-probe: bus: 1, device: 4 was not an MT=
P device
> May  3 18:18:57 relampago3 hddtemp[1872]: /dev/sda: WDC WD2500JS-75NC=
B3: 34 C
> May  3 18:19:06 relampago3 kernel: [ 3948.470324] scsi 7:0:0:0:
> Direct-Access     WDC WD30 EZRX-00MMMB0          PQ: 0 ANSI: 2 CCS

But this another minor issue:  The device is reporting only as SCSI-2.
That means it can't support READ CAPACITY(16) which is required to get
devices > 2TB.  We already expect this sort of thing from USB devices,
so we should cope OK.

> May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
> 1565565872 512-byte logical blocks: (801 GB/746 GiB)

This looks like a wrap around of your actual size.  This appears to
indicate the device isn't replying correctly to READ CAPACITY.  The
conventional return from READ CAPACITY should be -1 which would trigger
us to retry with READ CAPACITY(16).

James

> May  3 18:19:06 relampago3 kernel: [ 3948.473541] sd 7:0:0:0: [sdf]
> Write Protect is off
> May  3 18:19:06 relampago3 kernel: [ 3948.473547] sd 7:0:0:0: [sdf]
> Mode Sense: 34 00 00 00
> May  3 18:19:06 relampago3 kernel: [ 3948.474287] sd 7:0:0:0: [sdf]
> Write cache: disabled, read cache: enabled, doesn't support DPO or FU=
A
> May  3 18:19:06 relampago3 kernel: [ 3948.504915] Alternate GPT is
> invalid, using primary GPT.
> May  3 18:19:06 relampago3 kernel: [ 3948.504944]  sdf:
> May  3 18:19:06 relampago3 kernel: [ 3948.507541] sd 7:0:0:0: [sdf]
> Attached SCSI disk
> May  3 18:19:06 relampago3 ata_id[3163]: HDIO_GET_IDENTITY failed for
> '/dev/sdf': Invalid argument
>=20
>=20
>=20
>=20
> fdisk: opci=F3n inv=E1lida -- c
> GNU Fdisk 1.2.4
> Copyright (C) 1998 - 2006 Free Software Foundation, Inc.
> This program is free software, covered by the GNU General Public Lice=
nse.
>=20
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>=20
> Error: The backup GPT table is corrupt, but the primary appears OK, s=
o
> that will be used.
>   o   OK
>   c   Cancel
> o
> Error: Can't have a partition outside the disk!
