From: Florian Lohoff <flo@rfc822.org>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Sun, 29 Feb 2004 17:40:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229164048.GA1084@paradigm.rfc822.org>
References: <20040116165559.GB2686@beaverton.ibm.com> <Pine.LNX.4.44L0.0401161551300.843-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noose.gt.owl.de ([62.52.19.4]:18699 "EHLO noose.gt.owl.de")
	by vger.kernel.org with ESMTP id S262078AbUB2Qxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 11:53:52 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0401161551300.843-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Motzkau <a.motzkau@web.de>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
better late than never - Yes - this fixes the no sense problem for
me. Patch still applied to 2.6.3 without offset and fixes the problem.=20

Mainline please !

Flo

On Fri, Jan 16, 2004 at 03:53:18PM -0500, Alan Stern wrote:
>=20
> Florian and Alexander, does this patch fix your problem?  Mike, how does=
=20
> it look to you?
>=20
> Alan Stern
>=20
>=20
> =3D=3D=3D=3D=3D sd.c 1.59 vs edited =3D=3D=3D=3D=3D
> --- 1.59/drivers/scsi/sd.c	Fri Oct 24 14:53:37 2003
> +++ edited/drivers/scsi/sd.c	Fri Jan 16 15:49:48 2004
> @@ -730,6 +730,14 @@
>  			 * hard error.
>  			 */
>  			print_sense("sd", SCpnt);
> +			/* FALLS THROUGH */
> +
> +		case NO_SENSE:
> +			/*
> +			 * The low-level driver got the sense data but
> +			 * everything was all right.  Don't treat this
> +			 * an an error.
> +			 */
>  			SCpnt->result =3D 0;
>  			SCpnt->sense_buffer[0] =3D 0x0;
>  			good_sectors =3D this_count;

--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAQhYPUaz2rXW+gJcRApP5AKDO7nFJyQoPf4JKasWWxg1WyImNTwCglVVS
qlOWi2jAI4dyfA4o9cEa5jQ=
=7/6y
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
