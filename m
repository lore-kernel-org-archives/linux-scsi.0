From: Kurt Garloff <garloff@suse.de>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Fri, 24 May 2002 19:17:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020524191733.N28936@gum01m.etpnet.phys.tue.nl>
References: <3CEA83AE.1DCAB7BC@cri74.org> <3CEB4D6D.92C207EE@cri74.org> <20020522100339.A268@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OmL7C/BU0IhhC9Of"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020522100339.A268@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>


--OmL7C/BU0IhhC9Of
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Wed, May 22, 2002 at 10:03:39AM -0700, Patrick Mansfield wrote:
> On Wed, May 22, 2002 at 09:49:01AM +0200, Fabien Salvi wrote:
> > Fabien Salvi wrote:
>=20
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sda at scsi0, chann=
el
> > > 0, id 0, lun 0
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdb at scsi0, chann=
el
> > > 0, id 0, lun 1
[...]
> > > May 17 16:19:36 node01 kernel: Attached scsi disk sdh at scsi0, chann=
el
> > > 0, id 0, lun 7
> > > May 17 16:19:36 node01 kernel: Attached scsi CD-ROM sr0 at scsi2,
> > > channel 0, id 5, lun 0
[...]
> > > Like you can see, it founds 8 disks !
[...]
> > I've tried in the 2.4 kernel to increase the max_scsi_luns because I
> > thought lk may find as disks as many luns I have, but it's not the case
> > : it don't find more than 8 disks (maybe this is reassuring...).
> >=20
> > So here is the problem : the lk 2.4 finds more disks than I have !
>=20
> The 2.4 kernel won't scan past LUN 7 for SCSI-2 devices - you can try
> modifying the code and set the max to 31 in scsi_scan.c.

If you have a FC device (or whatever device that supports LUNs > 7) that
reports as SCSI-2, you can flag it with BLIST_LARGELUN in scsi_scan.c
to get it treated as SCSI-3.
(New in 2.4.18)

> The device is probably setting the peripheral-qualifier (PQ) such that the
> scan continues but the device is marked offline, this is just annoying
> if do not have a lot of them. In scsi_scan.c:
>=20
>         /* Use the peripheral qualifier field to determine online/offline=
 */
>         if (((scsi_result[0] >> 5) & 7) =3D=3D 1)   SDpnt->online =3D FAL=
SE;
>         else SDpnt->online =3D TRUE;

Those fields should not be set by the device, IMHO.
Or has their meaning changed for SCSI-3 devs? Then the appropriate check
should be added to the code.


But actually the problem is different: Too many LUNs where detected :-(

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--OmL7C/BU0IhhC9Of
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE87nWtxmLh6hyYd04RAoQ6AKCUyonn/ufMWxqgWH3y5NSgucpLqgCgi6Y9
u701VnzcNplt+5BaELzXqNg=
=l3uz
-----END PGP SIGNATURE-----

--OmL7C/BU0IhhC9Of--
