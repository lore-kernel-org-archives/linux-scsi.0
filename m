From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Sun, 21 Jul 2002 17:05:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020721170523.C4018@one-eyed-alien.net>
References: <20020721151523.D1909@one-eyed-alien.net> <20020721225233.GG7700@linnie.riede.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020721225233.GG7700@linnie.riede.org>; from wrlk@riede.org on Sun, Jul 21, 2002 at 06:52:33PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We're asking for an odd number of bytes in the command... this just affects
the tranfer length field.  It doesn't actually change the command sent.

Also, this is the sd.c driver -- SCSI disks.  OnStream _tape_ drives are
unaffected by this change. :)

Matt

On Sun, Jul 21, 2002 at 06:52:33PM -0400, Willem Riede wrote:
> On 2002.07.21 18:15 Matthew Dharm wrote:
> > These two BK patches fix two instances where a command is issued with an
> > incorrect transfer length.  The first is in the probing code... the sec=
tion
> > where we make the second INQUIRY request for the full INQUIRY data.  The
> > second is in sd.c where the MODE_SENSE request is issued.
> >=20
> [snip]
> > diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > --- a/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> > +++ b/drivers/scsi/sd.c	Sun Jul 21 00:55:44 2002
> > @@ -1102,7 +1102,7 @@
> >  	SRpnt->sr_data_direction =3D SCSI_DATA_READ;
> > =20
> >  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
> > -		      512, SD_TIMEOUT, MAX_RETRIES);
> > +		      255, SD_TIMEOUT, MAX_RETRIES);
> > =20
> >  	the_result =3D SRpnt->sr_result;
> > =20
> Matt,=20
>=20
> is asking for an odd number of bytes a good idea? There have been problems
> with doing so on OnStream tape drives...
>=20
> Thanks, Willem Riede.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm seen in many forms.  Now open your mouth.  It's caffeine time.
					-- Cola Man to Greg
User Friendly, 10/28/1998

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9O0xDIjReC7bSPZARAkPhAJsHxmXFcUbKn/FDFaxdI7G5wrEJmgCcDm3A
hAfSXcx9Xiie35BAHBlnw10=
=lOqE
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
