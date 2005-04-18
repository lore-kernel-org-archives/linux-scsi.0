From: folkert@vanheusden.com
Subject: Re: [ANNOUNCE] sdparm 0.90
Date: Mon, 18 Apr 2005 21:50:11 +0200
Message-ID: <20050418195009.GU30729@vanheusden.com>
References: <4263B56B.2010905@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z+AhoeLdLI498vdY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from keetweej.xs4all.nl ([213.84.46.114]:22727 "EHLO
	keetweej.vanheusden.com") by vger.kernel.org with ESMTP
	id S262184AbVDRTuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 15:50:12 -0400
Content-Disposition: inline
In-Reply-To: <4263B56B.2010905@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org


--z+AhoeLdLI498vdY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

keetweej:/usr/src# sdparm  -a /dev/sda
SG_IO (inquiry) error: Invalid argument
SCSI INQUIRY command failed on /dev/sda
keetweej:/usr/src# sdparm   /dev/sda
SG_IO (inquiry) error: Invalid argument
SCSI INQUIRY command failed on /dev/sda

Feb 21 12:58:10 keetweej kernel: SCSI subsystem driver Revision: 1.00
Feb 21 12:58:10 keetweej kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI =
HBA DRIVER, Rev 6.2.36
Feb 21 12:58:10 keetweej kernel:         <Adaptec aic7880 Ultra SCSI adapte=
r>
Feb 21 12:58:10 keetweej kernel:         aic7880: Ultra Wide Channel A, SCS=
I Id=3D7, 16/253 SCBs
Feb 21 12:58:10 keetweej kernel:
Feb 21 12:58:10 keetweej kernel:   Vendor: RICOH     Model: MP6200S        =
   Rev: 2.20
Feb 21 12:58:10 keetweej kernel:   Type:   CD-ROM                          =
   ANSI SCSI revision: 02
Feb 21 12:58:10 keetweej kernel: (scsi0:A:6): 5.813MB/s transfers (5.813MHz=
, offset 15)
Feb 21 12:58:10 keetweej kernel:   Vendor: IBM       Model: DCAS-34330     =
   Rev: S65A
Feb 21 12:58:10 keetweej kernel:   Type:   Direct-Access                   =
   ANSI SCSI revision: 02
Feb 21 12:58:10 keetweej kernel: scsi0:A:6:0: Tagged Queuing enabled.  Dept=
h 32
Feb 21 12:58:10 keetweej kernel: Attached scsi disk sda at scsi0, channel 0=
, id 6, lun 0
Feb 21 12:58:10 keetweej kernel: SCSI device sda: 8467200 512-byte hdwr sec=
tors (4335 MB)
Feb 21 12:58:10 keetweej kernel:  /dev/scsi/host0/bus0/target6/lun0: p1 p2

0000:00:06.0 SCSI storage controller: Adaptec AIC-7880U
keetweej:/var/log# lspci -n | grep 0000:00:06.0
0000:00:06.0 0100: 9004:8078


On Mon, Apr 18, 2005 at 11:26:03PM +1000, Douglas Gilbert wrote:
> sdparm is a new command line utility designed to get and set
> SCSI disk parameters (cf hdparm for ATA disks). More generally
> it gets and sets mode page information on SCSI devices or devices
> that use a SCSI command set (e.g. CD/DVD drives (any transport)
> and SCSI tape drives).
>=20
> The elements within mode pages are addressed via acronyms
> (e.g. "WCE" for "write cache enable" in the caching mode
> page). There is also numeric addressing of the form:
> <start_byte>:<start_bit>:<num_bits>
> This symbolic or numeric addressing should be more
> convenient for changing parameters than the techniques used
> by scsiinfo, sginfo and sg_wr_mode.
>=20
> A GUI wrapping sdparm would be a useful extension.
> It could show the mode page as found in the standard or
> the vendor's product manual with attributes such as
> "changeable" represented by colour or shading.
>=20
> I hope to add VPD pages in the future. sdparm shares some
> code with sg3_utils but is currently independent; they may
> share a library (libsgutils) in the future.
>=20
> A tarball, rpms and a "deb" can be found on
> http://www.torque.net/sg .
> Currently, the most complete documentation is in the
> man page.
>=20
>=20
> Examples (taken from the man page):
> To list the common (mode) parameters of a disk:
>=20
>     sdparm /dev/sda
>=20
> To see all parameters for the caching control mode page:
>=20
>     sdparm --page=3Dca /dev/sda
>=20
> To get the WCE values (current changeable default and
> saved) in hex:
>=20
>     sdparm -g WCE -H /dev/sda
>   0x01 0x00 0x01 0x01
>=20
> To get the WCE current value in hex:
>=20
>     sdparm -g WCE=3D1 -H /dev/sda
>   0x01
>=20
> To set the "write cache enable" bit in the current page:
>=20
>     sdparm --set=3DWCE /dev/sda
>=20
> To set the "write cache enable" bit in the current and
> saved page:
>=20
>     sdparm --set=3DWCE --save /dev/sda
>=20
> To set the "write cache enable" and clear "read cache
> disable":
>=20
>     sdparm --set=3DWCE --clear=3DRCD --save /dev/sda
>=20
> The previous example can also by written as:
>=20
>     sdparm -s WCE=3D1,RCD=3D0 -S /dev/sda
>=20
> To re-establish the manufacturer?s defaults in the
> current and saved caching control mode page:
>=20
>     sdparm --page=3Dca --defaults -save /dev/sda
>=20
> If an ATAPI cd/dvd player is at /dev/hdc then its common
> (mode) parameters could be listed with:
>=20
>           sdparm /dev/hdc
>=20
>=20
> Comments, suggestions and patches welcome.
>=20
>=20
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Folkert van Heusden

Auto te koop, zie: http://www.vanheusden.com/daihatsu.php
Op zoek naar een IT of Finance baan? Mail me voor de mogelijkheden.
--------------------------------------------------------------------
 UNIX admin? Then give MultiTail (http://vanheusden.com/multitail/)=20
 a try, it brings monitoring logfiles to a different level! See    =20
 http://vanheusden.com/multitail/features.html for a feature-list. =20
--------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE
Get your PGP/GPG key signed at www.biglumber.com!

--z+AhoeLdLI498vdY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iIMEARECAEMFAkJkD3E8Gmh0dHA6Ly93d3cudmFuaGV1c2Rlbi5jb20vZGF0YS1z
aWduaW5nLXdpdGgtcGdwLXBvbGljeS5odG1sAAoJEDAZDowfKNiuUd0AoJ+lSk7l
Ofd7LXiZ9deYJOyVil32AJ98RfC2UkDoJqoj2/f5ErvbMyVkkQ==
=uP59
-----END PGP SIGNATURE-----

--z+AhoeLdLI498vdY--
