From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: resolve COMMAND_SIZE at compile time
Date: Sat, 10 Mar 2018 12:49:17 -0800
Message-ID: <1520714957.4495.5.camel@linux.vnet.ibm.com>
References: <20180309232933.14e39858@heffalump.sk2.org>
         <20180309223355.21222-1-steve@sk2.org> <1520635631.2907.16.camel@wdc.com>
         <20180310142930.0692200b@heffalump.sk2.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OM5HNyDTbZlw5Ws0bDJ4"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180310142930.0692200b@heffalump.sk2.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Kitt <steve@sk2.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-scsi@vger.kernel.org


--=-OM5HNyDTbZlw5Ws0bDJ4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2018-03-10 at 14:29 +0100, Stephen Kitt wrote:
> Hi Bart,
>=20
> On Fri, 9 Mar 2018 22:47:12 +0000, Bart Van Assche <Bart.VanAssche@wd
> c.com>
> wrote:
> >=20
> > On Fri, 2018-03-09 at 23:33 +0100, Stephen Kitt wrote:
> > >=20
> > > +/*
> > > + * SCSI command sizes are as follows, in bytes, for fixed size
> > > commands,
> > > per
> > > + * group: 6, 10, 10, 12, 16, 12, 10, 10. The top three bits of
> > > an opcode
> > > + * determine its group.
> > > + * The size table is encoded into a 32-bit value by subtracting
> > > each
> > > value
> > > + * from 16, resulting in a value of 1715488362
> > > + * (6 << 28 + 6 << 24 + 4 << 20 + 0 << 16 + 4 << 12 + 6 << 8 + 6
> > > << 4 +
> > > 10).
> > > + * Command group 3 is reserved and should never be used.
> > > + */
> > > +#define COMMAND_SIZE(opcode) \
> > > +	(16 - (15 & (1715488362 >> (4 * (((opcode) >> 5) &
> > > 7)))))=C2=A0=C2=A0
> >=20
> > To me this seems hard to read and hard to verify. Could this have
> > been
> > written as a combination of ternary expressions, e.g. using a gcc
> > statement
> > expression to ensure that opcode is evaluated once?
>=20
> That=E2=80=99s what I=E2=80=99d tried initially, e.g.
>=20
> #define COMMAND_SIZE(opcode) ({ \
> int index =3D ((opcode) >> 5) & 7; \
> index =3D=3D 0 ? 6 : (index =3D=3D 4 ? 16 : index =3D=3D 3 || index =3D=
=3D 5 ? 12 :
> 10); \
> })
>=20
> But gcc still reckons that results in a VLA, defeating the initial
> purpose of
> the exercise.
>=20
> Does it help if I make the magic value construction clearer?
>=20
> #define SCSI_COMMAND_SIZE_TBL (	\
> 	=C2=A0=C2=A0=C2=A0(16 -=C2=A0=C2=A06)		\
> 	+ ((16 - 10) <<=C2=A0=C2=A04)	\
> 	+ ((16 - 10) <<=C2=A0=C2=A08)	\
> 	+ ((16 - 12) << 12)	\
> 	+ ((16 - 16) << 16)	\
> 	+ ((16 - 12) << 20)	\
> 	+ ((16 - 10) << 24)	\
> 	+ ((16 - 10) << 28))
>=20
> #define COMMAND_SIZE(opcode)					=09
> \
> =C2=A0 (16 - (15 & (SCSI_COMMAND_SIZE_TBL >> (4 * (((opcode) >> 5) &
> 7)))))

Couldn't we do the less clever thing of making the array a static const
and moving it to a header? =C2=A0That way the compiler should be able to
work it out at compile time.

James

--=-OM5HNyDTbZlw5Ws0bDJ4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCWqREzQAKCRDnQslM7pis
hQCdAP9X+JY9S6TJJVa9NN/j9DR6ai4u+PI2CzZEfB4w3WKAagD/TC1cwqmOjCnr
2FGwySKUezmBHURe948ekZU+nbgRvQM=
=yP4n
-----END PGP SIGNATURE-----

--=-OM5HNyDTbZlw5Ws0bDJ4--
