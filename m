From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [PATCH 2.6.24] bugfix for an overflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 11:49:41 -0800
Message-ID: <20080131194941.GR14375@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com> <20080131180051.GA22341@kroah.com> <47A22369.80906@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="THYEXwetZJOK3OLY"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <47A22369.80906-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--THYEXwetZJOK3OLY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

No.  No no no.

The ISD200 code was written by the ISD200 developers.  I really don't want
to go mucking about changing what commands actually get send to the ISD200
parts.  We have no idea if the will reliably accept a 36-byte INQUIRY.

Just because it happens to work for a couple of people doesn't mean it
works in the general case.  Without guidance from In-System, this is a bad
idea.

The way to deal with this is to do this via bounce buffering.  The two
commands affected (INQUIRY and MODE_SENSE) are low-performance items.
Discarding data from the end of them is also perfectly legal per spec.

Also, the entire idea of a negative resid makes my head hurt.  That sort of
change is in the category of "likely to break something else" which only
expects positive resid values.

Matt

On Thu, Jan 31, 2008 at 09:37:13PM +0200, Boaz Harrosh wrote:
> Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> rote:
> > As this is a regression and hits 2.6.24, can you send the final version
> > of this patch to the stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org address so we can get it into the
> > 2.6.24.y tree?
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
> Mark - This is for you on top of vanila v2.6.24 kernel from Linus.
>=20
> ---
>=20
>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>   volunteer 96 bytes of INQUIRY. This caused an overflow condition in
>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>   usb_stor_access_xfer_buf() to properly handle overflow/underflow condit=
ions.
>   Then usb_stor_set_xfer_buf() should report this condition as a negative
>   resid. Should we also set cmnd->status in the overflow condition?
>=20
>   Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
>   the upper layer asked for.
>=20
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/usb/storage/isd200.c   |    7 +++++--
>  drivers/usb/storage/protocol.c |   13 +++++++++----
>  2 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
> index 49ba6c0..8186e93 100644
> --- a/drivers/usb/storage/isd200.c
> +++ b/drivers/usb/storage/isd200.c
> @@ -1238,6 +1238,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb=
, struct us_data *us,
>  	unsigned long lba;
>  	unsigned long blockCount;
>  	unsigned char senseData[8] =3D { 0, 0, 0, 0, 0, 0, 0, 0 };
> +	unsigned xfer_len;
> =20
>  	memset(ataCdb, 0, sizeof(union ata_cdb));
> =20
> @@ -1247,8 +1248,9 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb=
, struct us_data *us,
>  		US_DEBUGP("   ATA OUT - INQUIRY\n");
> =20
>  		/* copy InquiryData */
> +		xfer_len =3D min(sizeof(info->InquiryData), scsi_bufflen(srb));
>  		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
> -				sizeof(info->InquiryData), srb);
> +					xfer_len, srb);
>  		srb->result =3D SAM_STAT_GOOD;
>  		sendToTransport =3D 0;
>  		break;
> @@ -1257,7 +1259,8 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb=
, struct us_data *us,
>  		US_DEBUGP("   ATA OUT - SCSIOP_MODE_SENSE\n");
> =20
>  		/* Initialize the return buffer */
> -		usb_stor_set_xfer_buf(senseData, sizeof(senseData), srb);
> +		xfer_len =3D min(sizeof(senseData), scsi_bufflen(srb));
> +		usb_stor_set_xfer_buf(senseData, xfer_len, srb);
> =20
>  		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
>  		{
> diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protoco=
l.c
> index 889622b..038a284 100644
> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -194,7 +194,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *=
buffer,
>  		 * and the starting offset within the page, and update
>  		 * the *offset and *index values for the next loop. */
>  		cnt =3D 0;
> -		while (cnt < buflen) {
> +		while (cnt < buflen && sg) {
>  			struct page *page =3D sg_page(sg) +
>  					((sg->offset + *offset) >> PAGE_SHIFT);
>  			unsigned int poff =3D
> @@ -248,9 +248,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>  {
>  	unsigned int offset =3D 0;
>  	struct scatterlist *sg =3D NULL;
> +	unsigned count;
> =20
> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
> +	count =3D usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>  			TO_XFER_BUF);
> -	if (buflen < srb->request_bufflen)
> -		srb->resid =3D srb->request_bufflen - buflen;
> +
> +	/* Check for overflow */
> +	if (buflen > scsi_bufflen(srb))
> +		count =3D buflen;
> +
> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
>  }
> --=20
> 1.5.3.3
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

M:  No, Windows doesn't have any nag screens.
C:  Then what are those blue and white screens I get every day?
					-- Mike and Cobb
User Friendly, 1/4/1999

--THYEXwetZJOK3OLY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHoiZVHL9iwnUZqnkRAliXAKCyurTA2gSsEdMjYzYSp9pAbUytjQCeJEEi
py8RicSNF7XbKsfMw1/YDsE=
=twRF
-----END PGP SIGNATURE-----

--THYEXwetZJOK3OLY--
