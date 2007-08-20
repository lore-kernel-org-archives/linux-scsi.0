From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Errors on USB-storage device are ignored.
Date: Sun, 19 Aug 2007 23:09:46 -0700
Message-ID: <20070820060946.GE9867@one-eyed-alien.net>
References: <20070816145817.GA24105@bitwizard.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0910694019=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070816145817.GA24105@bitwizard.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: usb-storage@lists.one-eyed-alien.net, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--===============0910694019==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Off the cuff, this really looks like something for the SCSI layer.  I'll
bet there are SCSI devices that do something similar...

And, I'm generally reluctant to modify the data to/from a device unless
usb-storage *really* has to in order to make it work....

Matt

On Thu, Aug 16, 2007 at 04:58:17PM +0200, Rogier Wolff wrote:
>=20
> Hi,
>=20
> I have an usb-storage enclosure that houses a normal desktop=20
> harddrive. I have been wondering why disks in that enclosure=20
> seemed to be  having less errors than when connected to a=20
> normal IDE connector.=20
>=20
> The reason is: USB-storage is ignoring a hint that something is
> wrong. Probably my enclosure is also not completely following specs,=20
> but Linux is ignoring the hint as well....=20
>=20
> On hitting a bad block, the disk reports error. The USB converter
> then reports "auto-sense-required", and this is carried out. However
> at this point, my USB enclosure returns all-zeroes. This is
> considered non-fatal by the kernel.=20
>=20
> I'm guessing not many people are testing these things with=20
> bad drives. So, I don't know wether or not other USB converters
> handle this situation more gracefully.=20
>=20
> As a patch, I've decided to set the sense key to "vendor specific"
> (9), and then no "additional sense" (0:0), if, and only if the device
> didn't return any valid sense info.=20
>=20
> The rest of the kernel then correctly interprets the situation
> as an IO error.=20
>=20
> 	Roger Wolff.=20
>=20
> --- linux-2.6.20.3.clean/drivers/usb/storage/transport.c	2007-03-13 19:27=
:08.000000000 +0100
> +++ linux-2.6.20.3.kostunrix/drivers/usb/storage/transport.c	2007-08-16 1=
6:47:00.000000000 +0200
> @@ -629,6 +629,14 @@
> =20
>  		/* let's clean up right away */
>  		memcpy(srb->sense_buffer, us->sensebuf, US_SENSE_SIZE);
> +		if (((srb->sense_buffer[2]&0xf) =3D=3D 0) &&
> +		    (srb->sense_buffer[12] =3D=3D 0) &&
> +		    (srb->sense_buffer[13] =3D=3D 0)) {
> +			/* Hmmmmm. The device requested sense, but then
> +			   declined to give us more info.... -- REW */=20
> +			srb->sense_buffer[2] |=3D 0x09; /* Vendor specific */
> +		}
> +
>  		srb->resid =3D old_resid;
>  		srb->request_buffer =3D old_request_buffer;
>  		srb->request_bufflen =3D old_request_bufflen;
>=20
>=20
>=20
> --=20
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement=
.=20
> Does it sit on the couch all day? Is it unemployed? Please be specific!=
=20
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGyTAqHL9iwnUZqnkRAiQPAJwOrQb1rktPYaUokmAKgLrUq1g/LQCgjM/T
l3VrJ3sAg5EJ+da+5lA7mGQ=
=DPdm
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--


--===============0910694019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
--===============0910694019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============0910694019==--
