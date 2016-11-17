From: Jack Suter <jack@suter.io>
Subject: Re: "hpsa: Change SAS transport devices to bus 0." commit breaks
 hpacucli on old controller firmware
Date: Thu, 17 Nov 2016 16:37:11 -0500
Message-ID: <1479418631.1187589.791460729.30FE0480@webmail.messagingengine.com>
References: <1477592113.812104.769415169.23FCE36A@webmail.messagingengine.com>
 <b73337d1-fd89-9310-5998-f62388028ef5@microsemi.com>
 <0dda89dd-ba20-6fbb-d4dd-1bb6601a4108@gmail.com>
 <f6b163ab-29ca-a9f2-6eef-2d6aec03fd02@suse.de>
 <1479414138.1169824.791372345.7E83C0B5@webmail.messagingengine.com>
 <4993A297653ECB4581FA5C3C31323D193B0BC887@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4993A297653ECB4581FA5C3C31323D193B0BC887@avsrvexchmbx1.microsemi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, Hannes Reinecke <hare@suse.de>, brace77070@gmail.com
Cc: iss_storagedev@hp.com, "esc.storagedev" <esc.storagedev@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

It appears on bus 3 for both hpsa and the sas transport for me. I can
test the patch on a few controllers with newer firmware too if you'd
like.

# lsscsi
[0:1:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sda=20
[0:1:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdb=20
[0:1:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdc=20
[0:1:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdd=20
[0:1:0:4]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde=20
[0:1:0:5]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf=20
[0:1:0:6]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg=20
[0:1:0:7]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh=20
[0:1:0:8]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdi=20
[0:1:0:9]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdj=20
[0:1:0:10]   disk    HP       LOGICAL VOLUME   1.66  /dev/sdk=20
[0:1:0:11]   disk    HP       LOGICAL VOLUME   1.66  /dev/sdl=20
[0:3:0:0]    storage HP       P410             1.66  -=20=20=20=20=20=20=20=
=20

# dmesg | grep hpsa
[    0.934677] hpsa 0000:06:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    0.935207] hpsa 0000:06:00.0: MSI-X capable controller
[    0.935585] hpsa 0000:06:00.0: Logical aborts not supported
[    0.935846] hpsa 0000:06:00.0: HP SSD Smart Path aborts not supported
[    0.957530] scsi host0: hpsa
[    1.154856] hpsa 0000:06:00.0: scsi 0:0:0:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.155328] hpsa 0000:06:00.0: scsi 0:0:1:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.155788] hpsa 0000:06:00.0: scsi 0:0:2:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.156247] hpsa 0000:06:00.0: scsi 0:0:3:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.156706] hpsa 0000:06:00.0: scsi 0:0:4:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.157167] hpsa 0000:06:00.0: scsi 0:0:5:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.157632] hpsa 0000:06:00.0: scsi 0:0:6:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.158105] hpsa 0000:06:00.0: scsi 0:0:7:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.158572] hpsa 0000:06:00.0: scsi 0:0:8:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.159033] hpsa 0000:06:00.0: scsi 0:0:9:0: masked Direct-Access=20=20=
=20=20
ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.159490] hpsa 0000:06:00.0: scsi 0:0:10:0: masked Direct-Access=20=20=
=20
 ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.159949] hpsa 0000:06:00.0: scsi 0:0:11:0: masked Direct-Access=20=20=
=20
 ATA      WDC WD2002FAEX-0 PHYS DRV SSDSmartPathCap- En- Exp=3D0
[    1.160409] hpsa 0000:06:00.0: scsi 0:0:12:0: masked Enclosure=20=20=20=
=20=20=20=20
 HP       DL18xG6BP        enclosure SSDSmartPathCap- En- Exp=3D0
[    1.160879] hpsa 0000:06:00.0: scsi 0:0:13:0: masked Enclosure=20=20=20=
=20=20=20=20
 PMCSIERA  SRC 8x6G        enclosure SSDSmartPathCap- En- Exp=3D0
[    1.161347] hpsa 0000:06:00.0: scsi 0:1:0:0: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.161807] hpsa 0000:06:00.0: scsi 0:1:0:1: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.162265] hpsa 0000:06:00.0: scsi 0:1:0:2: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.162724] hpsa 0000:06:00.0: scsi 0:1:0:3: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.163187] hpsa 0000:06:00.0: scsi 0:1:0:4: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.163654] hpsa 0000:06:00.0: scsi 0:1:0:5: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.164124] hpsa 0000:06:00.0: scsi 0:1:0:6: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.164581] hpsa 0000:06:00.0: scsi 0:1:0:7: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.165034] hpsa 0000:06:00.0: scsi 0:1:0:8: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.165487] hpsa 0000:06:00.0: scsi 0:1:0:9: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.165948] hpsa 0000:06:00.0: scsi 0:1:0:10: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.166410] hpsa 0000:06:00.0: scsi 0:1:0:11: added Direct-Access=20=20=
=20=20
HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[    1.166882] hpsa 0000:06:00.0: scsi 0:3:0:0: added RAID=20=20=20=20=20=
=20=20=20=20=20=20=20=20
HP       P410             controller SSDSmartPathCap- En- Exp=3D1


Cheers,

Jack Suter


On Thu, Nov 17, 2016, at 16:26, Don Brace wrote:
> > -----Original Message-----
> > From: Jack Suter [mailto:jack@suter.io]
> > Sent: Thursday, November 17, 2016 2:22 PM
> > To: Hannes Reinecke; brace77070@gmail.com
> > Cc: iss_storagedev@hp.com; esc.storagedev; linux-scsi@vger.kernel.org;
> > linux-kernel@vger.kernel.org; martin.petersen@oracle.com; Scott Teel;
> > Kevin Barnett; thenzl@redhat.com
> > Subject: Re: "hpsa: Change SAS transport devices to bus 0." commit brea=
ks
> > hpacucli on old controller firmware
> >=20
> > EXTERNAL EMAIL
> >=20
> >=20
> > Thanks from me as well for the patch. I've tested it on the problematic
> > controller and it appears to be working. The hpsa driver isn't throwing
> > any errors and hpacucli works as expected.
> >=20
> > Cheers,
> >=20
> > Jack Suter
>=20
> Can you attach the output of lsscsi and post the output of dmesg | grep
> added?
>=20
> I see this:
>=20
> [515253.466101] hpsa 0000:06:00.0:             added scsi 25:3:0:0: RAID=
=20
>             HP       H240             controller SSDSmartPathCap- En-
> Exp=3D1 qd=3D1024
>  [515256.083888] hpsa 0000:0c:00.0:             added scsi 26:3:0:0: RAID
>               HP       H241             controller SSDSmartPathCap- En-
>  Exp=3D1 qd=3D1024
>=20
> [25:0:0:0]   storage HP       H240             4.02  -=20=20=20=20=20=20=
=20=20
> [25:0:1:0]   disk    ATA      MO0100EBTJT      HPG2  /dev/sdy=20
> [25:0:2:0]   disk    ATA      MM0500GBKAK      HPGC  /dev/sdz=20
> [25:0:3:0]   disk    ATA      MK0200GCTYV      HPG4  /dev/sdaa
> [25:0:4:0]   disk    HP       EG0300FBDSP      HPD6  /dev/sdab
> [25:0:5:0]   enclosu HP       H240             4.02  -=20=20=20=20=20=20=
=20=20
> [26:0:0:0]   storage HP       H241             4.02  -=20=20=20=20=20=20=
=20=20
>=20
> So hpsa claims to put the controller on bus 3, but the sas transport puts
> it on bus 0 for me.
>=20
> Just want to be sure.
>=20
> Thanks,
> Don Brace
> ESC - Smart Storage
> Microsemi Corporation
>=20
>=20
>=20
> >=20
> > On Thu, Nov 17, 2016, at 06:17, Hannes Reinecke wrote:
> > > On 11/16/2016 05:09 PM, brace77070@gmail.com wrote:
> > > > On 10/31/2016 02:06 PM, Don Brace wrote:
> > > >> On 10/27/2016 01:15 PM, Jack Suter wrote:
> > > >>> Hi there,
> > > >>>
> > > >>> Commit "hpsa: Change SAS transport devices to bus 0."
> > > >>> (09371d623c9c3dc6ed7f53ec8ab01d25f0c6c697) breaks the hpacucli
> > utility
> > > >>> for some HP Smart Array controllers with old firmware.
> > > >>>
> > > >>> Specifically, I have a P410 connected to an HP DL180 G6 running
> > firmware
> > > >>> version 1.66. Yes, the firmware is old, but it works. On the 4.4 =
series
> > > >>> kernels and earlier, hpacucli works with no trouble. On 4.5 and l=
ater,
> > > >>> the hpsa driver reports errors  in the kernel log, and hpacucli r=
eports
> > > >>> "Error: No controllers detected."
> > > >>>
> > > >>> Oct 27 15:50:30 hostname kernel: [   32.189495] hpsa 0000:06:00.0=
: scsi
> > > >>> 0:0:0:0: added RAID              HP       P410 controller
> > > >>> SSDSmartPathCap- En- Exp=3D1
> > > >>> Oct 27 15:50:30 hostname kernel: [   32.190054] hpsa 0000:06:00.0:
> > > >>> addition failed -19, device not added.
> > > >>>
> > > >>> Reverting the above commit resolves both the hpsa errors and the
> > > >>> hpacucli error when tested with kernel 4.7.9.
> > > >>>
> > > >>> In addition to this troublesome server, I have a handful of serve=
rs with
> > > >>> P410 controllers and firmware versions ranging from 3.52 to 6.60.=
 All of
> > > >>> them work with the 09371d62 commit in place, which leads me to
> > believe
> > > >>> it is just this old 1.66 firmware that is incompatible.
> > > >>>
> > > >>> While a firmware upgrade seems like the simple solution, I think =
this
> > > >>> should be considered a bug/regression due to it breaking function=
ality
> > > >>> that previously worked. It appears others may have run into this =
issue
> > > >>> too:
> > > >>> http://superuser.com/questions/1093124/coreos-hp410-raid1-device-
> > not-added-19
> > > >>>
> > > >>>
> > > >>> Some dmesg output (grep -e hpsa -e sg) is below from both a 4.4.2
> > kernel
> > > >>> (working) and 4.5.7 kernel (broken). Note the change in SCSI addr=
ess
> > > >>> from 0:3:0:0 to 0:0:0:0.
> > > >>>
> > > >>> Please let me know if you need me to do any testing to help resol=
ve
> > > >>> this.
> > > >>>
> > > >>> Jack Suter
> > > >> I discussed this with the ssacli developers and they do not look
> > > >> at the bus, but I see "device not added" messages that
> > > >> should not be there. I'll attack your issue from that
> > > >> perspective.
> > > >>
> > > >> Thanks,
> > > >> Don Brace
> > > >
> > > > The root cause is that this older firmware is not scsi revision 5 a=
nd
> > > > thus we add the
> > > > controller at the end of the list, not at the beginning.
> > > >
> > > >         if (is_scsi_rev_5(h))
> > > >                 raid_ctlr_position =3D 0;
> > > >         else
> > > >                 raid_ctlr_position =3D nphysicals + nlogicals;
> > > >
> > > > So the first logical volume gets BTL 0:0:0 and then we attempt to a=
dd in
> > > > the controller
> > > > using the same BTL values at the end of the list. Thus you get the
> > > > "device not added" messages.
> > > >
> > > > The change to bus 0 was because the SAS transport is using bus 0 and
> > > > there was a
> > > > discrepancy in what the driver was putting the controller on and wh=
at
> > > > the SAS
> > > > transport was actually using.
> > > >
> > > > I'll work on a patch to resolve this for you.
> > > >
> > > One can resolve this issue with checking the SCSI revision of the
> > > controller, and move every controller with revision '0' to bus 3.
> > > That solved the issue for me.
> > >
> > > Patch posted in a different mail.
> > >
> > > Cheers,
> > >
> > > Hannes
> > > --
> > > Dr. Hannes Reinecke                Teamlead Storage & Networking
> > > hare@suse.de                                   +49 911 74053 688
> > > SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> > > GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> > > HRB 21284 (AG N=C3=BCrnberg)
