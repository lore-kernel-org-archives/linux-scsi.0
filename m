From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: adding flag for 192 byte mode sense
Date: Tue, 16 Mar 2004 10:02:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316180238.GA19787@one-eyed-alien.net>
References: <20040313174651.A3054@beaverton.ibm.com> <Pine.LNX.4.44L0.0403161214510.815-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:64903 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261852AbUCPSCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 13:02:48 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0403161214510.815-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 16, 2004 at 12:25:03PM -0500, Alan Stern wrote:
> +
> +	/* We can't put these settings in slave_alloc() because that gets
> +	 * called before the device type is known.  Consequently these
> +	 * settings can't be overridden via the scsi devinfo mechanism. */
> +	if (sdev->type =3D=3D TYPE_DISK) {
> +
> +		/* Disk-type devices use MODE SENSE(6) if the protocol
> +		 * (SubClass) is Transparent SCSI */
> +		if (us->subclass =3D=3D US_SC_SCSI)
> +			sdev->use_10_for_ms =3D 0;
> +	} else {
> +
> +		/* Non-disk-type devices don't need to blacklist MS page x08
> +		 * or to force 192 byte transfer lengths for MODE SENSE */
> +		sdev->skip_ms_page_8 =3D 0;
> +		sdev->use_192_bytes_for_3f =3D 0;
> +	}
> =20

Do we know what non-disk type devices use for MODE_SENSE?  That would
(primarily) be CD-ROMs, I think...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAV0E+IjReC7bSPZARAj2BAJ9+R4nuvAQq+2yLqKESpP2dYQMlXgCgtnCv
wF1wfYWC0/EHQ7WMrwr//Vk=
=w3IK
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
