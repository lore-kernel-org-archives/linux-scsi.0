From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Thu, 23 May 2002 11:01:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CECAFD0.43C603C0@cri74.org>
References: <3CEA83AE.1DCAB7BC@cri74.org> <3CEB4D6D.92C207EE@cri74.org> <20020522100339.A268@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>

Patrick Mansfield wrote:
>=20
> On Wed, May 22, 2002 at 09:49:01AM +0200, Fabien Salvi wrote:
> > Fabien Salvi wrote:
>=20
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sda at scsi0, c=
hannel
> > > 0, id 0, lun 0
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdb at scsi0, c=
hannel
> > > 0, id 0, lun 1
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdc at scsi0, c=
hannel
> > > 0, id 0, lun 2
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdd at scsi0, c=
hannel
> > > 0, id 0, lun 3
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sde at scsi0, c=
hannel
> > > 0, id 0, lun 4
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdf at scsi0, c=
hannel
> > > 0, id 0, lun 5
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdg at scsi0, c=
hannel
> > > 0, id 0, lun 6
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdh at scsi0, c=
hannel
> > > 0, id 0, lun 7
> > > May 17 16:19:36 node01 kernel: Attached scsi CD-ROM sr0 at scsi2,
> > > channel 0, id 5, lun 0
> > > May 17 16:19:36 node01 kernel: sym2:5: FAST-20 SCSI 20.0 MB/s ST =
(50.0
> > > ns, offset 16)
> > > May 17 16:19:36 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/r=
w
> > > xa/form2 cdda tray
> > > May 17 16:19:36 node01 kernel: Uniform CD-ROM driver Revision: 3.=
12
> > > May 17 16:19:36 node01 kernel: sym0:0: FAST-20 SCSI 20.0 MB/s ST =
(50.0
> > > ns, offset 16)
> > > May 17 16:19:36 node01 kernel: SCSI device sda: 17776640 512-byte=
 hdwr
> > > sectors (9102 MB)
> > > May 17 16:19:36 node01 kernel: Partition check:
> > > May 17 16:19:36 node01 kernel:  sda: sda1 sda2 sda3 sda4
> > > May 17 16:19:36 node01 kernel: SCSI device sdb: 17776640 512-byte=
 hdwr
> > > sectors (9102 MB)
> > > May 17 16:19:36 node01 kernel:  sdb: sdb1
> > >
> > > Like you can see, it founds 8 disks !
> > > I tried to increase max_scsi_luns to 64 to see if it will find as=
 many
> > > disks as luns, but it does not go after lun7 =3D=3D> 8 disks
> > >
>=20
> > G=E9rard and Doug, thanks for your help.
> >
> > But, in fact, after re-reading my email, I've seen it's confusing
> > because I didn't explain correctly the problem.
> >
> > The lk 2.2 has the good comportment : it only finds the 2 disks.
> > And, that's ok, I have really only 2 disks to be seen.
> >
> > The problem is with the 2.4 kernel that finds 8 disks but it should=
 only
> > see 2 disks, because there is only 2 disks !
> >
> > The other disks are not accessible :
> > $fdisk /dev/sdc
> >
> > Unable to open /dev/sdc
> >
> > It's the same from sdc to sdh...
> >
> >
> > I've tried in the 2.4 kernel to increase the max_scsi_luns because =
I
> > thought lk may find as disks as many luns I have, but it's not the =
case
> > : it don't find more than 8 disks (maybe this is reassuring...).
> >
> > So here is the problem : the lk 2.4 finds more disks than I have !
>=20
> The 2.4 kernel won't scan past LUN 7 for SCSI-2 devices - you can try
> modifying the code and set the max to 31 in scsi_scan.c.
>=20
> The device is probably setting the peripheral-qualifier (PQ) such tha=
t the
> scan continues but the device is marked offline, this is just annoyin=
g
> if do not have a lot of them. In scsi_scan.c:
>=20
>         /* Use the peripheral qualifier field to determine online/off=
line */
>         if (((scsi_result[0] >> 5) & 7) =3D=3D 1)   SDpnt->online =3D=
 FALSE;
>         else SDpnt->online =3D TRUE;
>=20
> The above means that sd will attach to the device, but won't try to r=
ead
> capacity etc, and an open of the device will fail. Redhat kernels hav=
e
> some changes to avoid this problem, there was also a PQ patch posted
> some time ago (it would make sense to put it into 2.5, especially now=
 that
> the inquiry data is retained, and avoid setting online to FALSE).
>=20
> There is also some odd case (AFAIR when initializing sd after the ada=
pter has
> been loaded and scanned the devices) where the online gets reset to T=
RUE
> and causes sd.c to fail trying to read the non-existent LUN.

Thanks for your help Patrick, I think it's the solution.
Well, like I have not so many disks found, I will let them in this
state...

-------------
=46abien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
