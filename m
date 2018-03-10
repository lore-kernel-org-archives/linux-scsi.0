From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] scsi: resolve COMMAND_SIZE at compile time
Date: Sat, 10 Mar 2018 14:29:30 +0100
Message-ID: <20180310142930.0692200b@heffalump.sk2.org>
References: <20180309232933.14e39858@heffalump.sk2.org>
	<20180309223355.21222-1-steve@sk2.org>
	<1520635631.2907.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/3N3tICVyMiJ8mX7TlQQ=.7+"; protocol="application/pgp-signature"
Return-path: <kernel-hardening-return-12374-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1520635631.2907.16.camel@wdc.com>
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/3N3tICVyMiJ8mX7TlQQ=.7+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Fri, 9 Mar 2018 22:47:12 +0000, Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:
> On Fri, 2018-03-09 at 23:33 +0100, Stephen Kitt wrote:
> > +/*
> > + * SCSI command sizes are as follows, in bytes, for fixed size command=
s,
> > per
> > + * group: 6, 10, 10, 12, 16, 12, 10, 10. The top three bits of an opco=
de
> > + * determine its group.
> > + * The size table is encoded into a 32-bit value by subtracting each
> > value
> > + * from 16, resulting in a value of 1715488362
> > + * (6 << 28 + 6 << 24 + 4 << 20 + 0 << 16 + 4 << 12 + 6 << 8 + 6 << 4 +
> > 10).
> > + * Command group 3 is reserved and should never be used.
> > + */
> > +#define COMMAND_SIZE(opcode) \
> > +	(16 - (15 & (1715488362 >> (4 * (((opcode) >> 5) & 7))))) =20
>=20
> To me this seems hard to read and hard to verify. Could this have been
> written as a combination of ternary expressions, e.g. using a gcc stateme=
nt
> expression to ensure that opcode is evaluated once?

That=E2=80=99s what I=E2=80=99d tried initially, e.g.

#define COMMAND_SIZE(opcode) ({ \
int index =3D ((opcode) >> 5) & 7; \
index =3D=3D 0 ? 6 : (index =3D=3D 4 ? 16 : index =3D=3D 3 || index =3D=3D =
5 ? 12 : 10); \
})

But gcc still reckons that results in a VLA, defeating the initial purpose =
of
the exercise.

Does it help if I make the magic value construction clearer?

#define SCSI_COMMAND_SIZE_TBL (	\
	   (16 -  6)		\
	+ ((16 - 10) <<  4)	\
	+ ((16 - 10) <<  8)	\
	+ ((16 - 12) << 12)	\
	+ ((16 - 16) << 16)	\
	+ ((16 - 12) << 20)	\
	+ ((16 - 10) << 24)	\
	+ ((16 - 10) << 28))

#define COMMAND_SIZE(opcode)						\
  (16 - (15 & (SCSI_COMMAND_SIZE_TBL >> (4 * (((opcode) >> 5) & 7)))))

Regards,

Stephen

--Sig_/3N3tICVyMiJ8mX7TlQQ=.7+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqj3boACgkQgNMC9Yht
g5xKfA/+N51ED2mvt0PbJzGC415SSH48pWK+9c0efNme5li4Tqs8Hm2Y4EcBTWcq
h9EuQPL0Cd0p/Zd8pXzihlqlX1i0FevsKf/IpD7icJbaVrQxYZTQhIhDV3dUocqC
dW+BqTB4hL/iS6pTm+LEd0+e7i0D8T7noLEI5Z7y6WB9R1NLmfa5RnVBeD40pHRW
Khqz1Az8TieXASGur1GvaAtCBE5CQt5pUahOw5KAHodl57tsGHzW/6Hz5J+f2GOI
duKM1KEZ0vP5Yz/NGhHDoL278smJmhwCMr4T/VC7xlaTyRQCexME55hWQiTti3C9
v1LfWK5/Is04bUslqjQOL0CkuhXz9+Ql6SW9dcR8OPUbQRz0IyEvVKNLxc7YFqsM
m4TBJpfW9BrYc/w9u5VgXto6EY6t1bFr+CjdV3svfQWi+fhvKgZl5F/ed4MkBY8y
6P2cbsmh3Y8bWCJuM9tJD3E+e5WKclI2OpzzzmaA31ky5tDt250CCGcn7TpJHd5M
L6Rgt9Evdw2MpEKuDSzJFn9zYy3aI99Zs/S58Sg9AxKAcbw+qcLAfF9yJpxz1chb
xLE8YowvlvKMRK6DMjnO3skhvc5RNVFjes8+qfPoVY8oPuha/ygcMn9GPX3aNr0v
EWHercIjwlhZz9NrApIN1Lm9+ok/SDLVTsy4bah6XAuz97QQEH4=
=RlLD
-----END PGP SIGNATURE-----

--Sig_/3N3tICVyMiJ8mX7TlQQ=.7+--
