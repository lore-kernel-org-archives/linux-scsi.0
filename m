From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 09:35:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114093503.B19467@one-eyed-alien.net>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:23825 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264561AbTKNRfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:35:47 -0500
Content-Disposition: inline
In-Reply-To: <20031114092644.A2794@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 14, 2003 at 09:26:44AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm strongly attempted to agree with you guys.... blacklisting looks like
the way to go.

I'm concerned about the names, tho.... BLIST_MS_SKIP_PAGE_08 sounds more
general than it is -- as I understand it, this flag will only affect sd.c,
tho it looks much more general.

I think I'd rather tweak the structure in slave_configure, where it will be
easier to add more logic if people decide we need it in the future.

Matt

On Fri, Nov 14, 2003 at 09:26:44AM -0800, Patrick Mansfield wrote:
> On Fri, Nov 14, 2003 at 09:52:24AM -0600, James Bottomley wrote:
> > Since Patrick has already provided the mechanics for this, I suggest we
> > do this by setting the skip_ms_page_3f and skip_ms_page_8 globally in
> > the usb-storage slave configure routines.
> >=20
> > If there are known good devices, it would probably be best to add them
> > to the USB special devices list to have these flags reset for the
> > capabilities.
> >=20
> > The nice thing about this approach is that I don't have to do anything
> > in SCSI, and the control of the USB black/white list is entirely in the
> > USB subsystem.
> >=20
> > Does this sound like a plan?
>=20
> It would be best to just use the BLIST flags setting in the host .flags,
> the following simple patch (only compile tested!) will not send any MODE
> SENSE to sd devices (SCSI direct access inquiry type 0, or optical
> memory/optical disks inquiry type 7).
>=20
> It also allows the setting to be overwritten for specific vendor + model
> via the scsi_devinfo/dev_flags code - so users or distributions can white
> list devices without modifying the kernel (devinfo settings have priority
> over shost->flags, see scsi_devinfo.c).
>=20
> I did not give the flags very good names, for clarity:
>=20
> BLIST_MS_SKIP_PAGE_08 means for sd assume write through cache.
>=20
> BLIST_MS_SKIP_PAGE_3F means for sd assume writable media.
>=20
> And we don't need any special code in a slave_configure or elsewhere to
> check if it is a direct access device.
>=20
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/usb/storage/scsiglue.c =
usb-ms-flags/drivers/usb/storage/scsiglue.c
> --- bl-25/drivers/usb/storage/scsiglue.c	Mon Oct 27 14:28:18 2003
> +++ usb-ms-flags/drivers/usb/storage/scsiglue.c	Fri Nov 14 09:15:20 2003
> @@ -322,7 +322,8 @@ struct scsi_host_template usb_stor_host_
>  	.emulated =3D			TRUE,
> =20
>  	/* modify scsi_device bits on probe */
> -	.flags =3D (BLIST_MS_SKIP_PAGE_08 | BLIST_USE_10_BYTE_MS),
> +	.flags =3D (BLIST_MS_SKIP_PAGE_08 | BLIST_MS_SKIP_PAGE_3F |
> +		  BLIST_USE_10_BYTE_MS),
> =20
>  	/* module management */
>  	.module =3D			THIS_MODULE

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tRJHIjReC7bSPZARAgrOAJ9Q9ROfxgqyfCLcY/iPRleChrXGEQCfQ3Nz
OnjLneCWkzYB+XDlM9DTAc4=
=FofR
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
