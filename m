From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Wed, 22 May 2002 10:03:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020522100339.A268@eng2.beaverton.ibm.com>
References: <3CEA83AE.1DCAB7BC@cri74.org> <3CEB4D6D.92C207EE@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CEB4D6D.92C207EE@cri74.org>; from fabien@cri74.org on Wed, May 22, 2002 at 09:49:01AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>

On Wed, May 22, 2002 at 09:49:01AM +0200, Fabien Salvi wrote:
> Fabien Salvi wrote:

> > May 17 16:19:36 node01 kernel: Attached scsi disk sda at scsi0, cha=
nnel
> > 0, id 0, lun 0
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdb at scsi0, cha=
nnel
> > 0, id 0, lun 1
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdc at scsi0, cha=
nnel
> > 0, id 0, lun 2
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdd at scsi0, cha=
nnel
> > 0, id 0, lun 3
> > May 17 16:19:36 node01 kernel: Attached scsi disk sde at scsi0, cha=
nnel
> > 0, id 0, lun 4
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdf at scsi0, cha=
nnel
> > 0, id 0, lun 5
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdg at scsi0, cha=
nnel
> > 0, id 0, lun 6
> > May 17 16:19:36 node01 kernel: Attached scsi disk sdh at scsi0, cha=
nnel
> > 0, id 0, lun 7
> > May 17 16:19:36 node01 kernel: Attached scsi CD-ROM sr0 at scsi2,
> > channel 0, id 5, lun 0
> > May 17 16:19:36 node01 kernel: sym2:5: FAST-20 SCSI 20.0 MB/s ST (5=
0.0
> > ns, offset 16)
> > May 17 16:19:36 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/rw
> > xa/form2 cdda tray
> > May 17 16:19:36 node01 kernel: Uniform CD-ROM driver Revision: 3.12
> > May 17 16:19:36 node01 kernel: sym0:0: FAST-20 SCSI 20.0 MB/s ST (5=
0.0
> > ns, offset 16)
> > May 17 16:19:36 node01 kernel: SCSI device sda: 17776640 512-byte h=
dwr
> > sectors (9102 MB)
> > May 17 16:19:36 node01 kernel: Partition check:
> > May 17 16:19:36 node01 kernel:  sda: sda1 sda2 sda3 sda4
> > May 17 16:19:36 node01 kernel: SCSI device sdb: 17776640 512-byte h=
dwr
> > sectors (9102 MB)
> > May 17 16:19:36 node01 kernel:  sdb: sdb1
> >=20
> > Like you can see, it founds 8 disks !
> > I tried to increase max_scsi_luns to 64 to see if it will find as m=
any
> > disks as luns, but it does not go after lun7 =3D=3D> 8 disks
> >=20

> G=E9rard and Doug, thanks for your help.
>=20
> But, in fact, after re-reading my email, I've seen it's confusing
> because I didn't explain correctly the problem.
>=20
> The lk 2.2 has the good comportment : it only finds the 2 disks.
> And, that's ok, I have really only 2 disks to be seen.
>=20
> The problem is with the 2.4 kernel that finds 8 disks but it should o=
nly
> see 2 disks, because there is only 2 disks !
>=20
> The other disks are not accessible :
> $fdisk /dev/sdc
>=20
> Unable to open /dev/sdc
>=20
> It's the same from sdc to sdh...
>=20
>=20
> I've tried in the 2.4 kernel to increase the max_scsi_luns because I
> thought lk may find as disks as many luns I have, but it's not the ca=
se
> : it don't find more than 8 disks (maybe this is reassuring...).
>=20
> So here is the problem : the lk 2.4 finds more disks than I have !

The 2.4 kernel won't scan past LUN 7 for SCSI-2 devices - you can try
modifying the code and set the max to 31 in scsi_scan.c.

The device is probably setting the peripheral-qualifier (PQ) such that =
the
scan continues but the device is marked offline, this is just annoying
if do not have a lot of them. In scsi_scan.c:

        /* Use the peripheral qualifier field to determine online/offli=
ne */
        if (((scsi_result[0] >> 5) & 7) =3D=3D 1)   SDpnt->online =3D F=
ALSE;
        else SDpnt->online =3D TRUE;

The above means that sd will attach to the device, but won't try to rea=
d
capacity etc, and an open of the device will fail. Redhat kernels have
some changes to avoid this problem, there was also a PQ patch posted
some time ago (it would make sense to put it into 2.5, especially now t=
hat
the inquiry data is retained, and avoid setting online to FALSE).

There is also some odd case (AFAIR when initializing sd after the adapt=
er has
been loaded and scanned the devices) where the online gets reset to TRU=
E
and causes sd.c to fail trying to read the non-existent LUN.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
