From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Sat, 27 Jul 2002 15:07:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020727150706.A3121@one-eyed-alien.net>
References: <20020721151523.D1909@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020721151523.D1909@one-eyed-alien.net>; from mdharm-usb@one-eyed-alien.net on Sun, Jul 21, 2002 at 03:15:23PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I haven't seen these patches integrated into a kernel yet... have I just
missed them, or is there some reason they have been rejected?

Matt

On Sun, Jul 21, 2002 at 03:15:23PM -0700, Matthew Dharm wrote:
> These two BK patches fix two instances where a command is issued with an
> incorrect transfer length.  The first is in the probing code... the secti=
on
> where we make the second INQUIRY request for the full INQUIRY data.  The
> second is in sd.c where the MODE_SENSE request is issued.
>=20
> Both of these patches are requred to allow usb-storage devices to work
> properly.  As a side-effect, this should reduce problems for all 'emulated
> scsi' systems (ide-scsi, sbp2, etc).
>=20
> Is there someone in particular I should send them to?  In the USB world,
> all patches go to Greg K-H... what's the procedure here in SCSI land?
>=20
> Matt
>=20
> # This is a BitKeeper generated patch for the following project:
> # Project Name: greg k-h's linux 2.5 USB kernel tree
> # This patch format is intended for GNU patch command version 2.5 or high=
er.
> # This patch includes the following deltas:
> #	           ChangeSet	1.594   -> 1.595 =20
> #	drivers/scsi/scsi_scan.c	1.9     -> 1.10  =20
> #
> # The following is the BitKeeper ChangeSet Log
> # --------------------------------------------
> # 02/07/20	mdharm@zen.san.one-eyed-alien.net	1.595
> # Fixed one of the INQUIRY commands used for probing SCSI devices.  This
> # badly-formed command was trapped by the usb-storage driver BUG_ON() whi=
ch
> # is designed to stop command with a badly formed transfer_length field.
> # --------------------------------------------
> #
> diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	Sun Jul 21 00:55:37 2002
> +++ b/drivers/scsi/scsi_scan.c	Sun Jul 21 00:55:37 2002
> @@ -717,7 +717,7 @@
> =20
>  		scsi_wait_req (SRpnt, (void *) scsi_cmd,
>  			  (void *) scsi_result,
> -			  256, SCSI_TIMEOUT+4*HZ, 3);
> +			  scsi_cmd[4], SCSI_TIMEOUT+4*HZ, 3);
>  		/* assume successful */
>  	}
>  	SDpnt->inquiry_len =3D possible_inq_resp_len;
>=20
>=20
> # This is a BitKeeper generated patch for the following project:
> # Project Name: greg k-h's linux 2.5 USB kernel tree
> # This patch format is intended for GNU patch command version 2.5 or high=
er.
> # This patch includes the following deltas:
> #	           ChangeSet	1.595   -> 1.596 =20
> #	   drivers/scsi/sd.c	1.22    -> 1.23  =20
> #
> # The following is the BitKeeper ChangeSet Log
> # --------------------------------------------
> # 02/07/20	greg@kroah.com	1.7.2.39
> # patch-2.5.27
> # --------------------------------------------
> # 02/07/20	greg@kroah.com	1.561.1.124
> # Merge kroah.com:/home/linux/linux/linux-2.5
> # into kroah.com:/home/linux/linux/tmp/linux-2.5
> # --------------------------------------------
> # 02/07/20	mdharm@zen.san.one-eyed-alien.net	1.596
> # Modified the MODE_SENSE write-protect test in sd.c to issue a SCSI requ=
est
> # with the request_bufflen the same size as the MODE_SENSE command being
> # issued requests.
> # --------------------------------------------
> #
> diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> +++ b/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> @@ -1102,7 +1102,7 @@
>  	SRpnt->sr_data_direction =3D SCSI_DATA_READ;
> =20
>  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
> -		      512, SD_TIMEOUT, MAX_RETRIES);
> +		      255, SD_TIMEOUT, MAX_RETRIES);
> =20
>  	the_result =3D SRpnt->sr_result;
> =20
> --=20
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alie=
n.net=20
> Maintainer, Linux USB Mass Storage Driver
>=20
> C:  Like the Furby?
> DP: He gives me the creeps.  Think the SPCA will take him?
> 					-- Cobb and Dust Puppy
> User Friendly, 1/2/1999



--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I say, what are all those naked people doing?
					-- Big client to Stef
User Friendly, 12/14/1997

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9QxmKIjReC7bSPZARAqFlAKCa9M5hDN/stXzYpSsAVxPLu9dumgCeK/O9
1emjp2VTSME4IUp2u15EQxY=
=U8S/
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
