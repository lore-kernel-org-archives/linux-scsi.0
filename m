From: Doug Ledford <dledford@redhat.com>
Subject: Re: Linux 2.6.18-rc6
Date: Sun, 17 Sep 2006 14:20:37 -0400
Message-ID: <1158517237.17671.77.camel@fc6.xsintricity.com>
References: <Pine.LNX.4.64.0609031939100.27779@g5.osdl.org>
	 <20060905122656.GA3650@aepfle.de>
	 <1157490066.3463.73.camel@mulgrave.il.steeleye.com>
	 <20060906110147.GA12101@aepfle.de>
	 <1157551480.3469.8.camel@mulgrave.il.steeleye.com>
	 <20060907091517.GA21728@aepfle.de>
	 <1157637874.3462.8.camel@mulgrave.il.steeleye.com>
	 <1158378424.2661.150.camel@fc6.xsintricity.com>
	 <20060917053815.GA10918@aepfle.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y3/Nzo1eUZqO/PyoqrhJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59528 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932163AbWIQSU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Sep 2006 14:20:59 -0400
In-Reply-To: <20060917053815.GA10918@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


--=-Y3/Nzo1eUZqO/PyoqrhJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2006-09-17 at 07:38 +0200, Olaf Hering wrote:
> On Fri, Sep 15, Doug Ledford wrote:
>=20
> > On Thu, 2006-09-07 at 09:04 -0500, James Bottomley wrote:
> > > On Thu, 2006-09-07 at 11:15 +0200, Olaf Hering wrote:
> > > > This does not work: ahc_linux_get_signalling: f 56f6
> > > >=20
> > > > echo $(( 0x56f6 & 0x00002 )) gives 2, and the ahc_inb is called.
> > >=20
> > > Erm, there's something else going on then:  An ultra 2 card has to ha=
ve
> > > this register.  It's used to signal mode changes in
> > > ahc_handle_scsiint().  The piece of code in there will trigger and re=
ad
> > > this register for any ultra 2 + controller every time there's an erro=
r
> > > (just to see if the bus mode changed).
> >=20
> > Sorry for my belated response, but this usually happens when you access
> > an aic chipset too soon after a chip reset.  Try putting a delay before
> > whatever access is causing this to see if it make s difference.  Common
> > problems include after a chip reset, touching any register will cause
> > the card to reset, etc.
>=20
> As pointed out in private mail, this patch fixes the machine check for
> me. Thanks Doug.

Hehehe, everyone ignore my last email, I hadn't seen this one ;-)
You're welcome.

> Maybe the AHC_ULTRA2 feature check is needed as well for other cards.
>=20
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> Index: linux-2.6.18-rc7/drivers/scsi/aic7xxx/aic7xxx_osm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.18-rc7.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ linux-2.6.18-rc7/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -2539,7 +2539,14 @@ static void ahc_linux_set_iu(struct scsi
>  static void ahc_linux_get_signalling(struct Scsi_Host *shost)
>  {
>  	struct ahc_softc *ahc =3D *(struct ahc_softc **)shost->hostdata;
> -	u8 mode =3D ahc_inb(ahc, SBLKCTL);
> +	unsigned long flags;
> +	u8 mode;
> +
> +	ahc_lock(ahc, &flags);
> +	ahc_pause(ahc);
> +	mode =3D ahc_inb(ahc, SBLKCTL);
> +	ahc_unpause(ahc);
> +	ahc_unlock(ahc, &flags);
> =20
>  	if (mode & ENAB40)
>  		spi_signalling(shost) =3D SPI_SIGNAL_LVD;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Y3/Nzo1eUZqO/PyoqrhJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFDZH1g6WylM+/8ZQRAmgyAJ9Jggw+8m+foH4ValhBFSwGuai/EgCfUamT
83u1zs/oE5qtHzUfwN6b1E8=
=sudm
-----END PGP SIGNATURE-----

--=-Y3/Nzo1eUZqO/PyoqrhJ--

