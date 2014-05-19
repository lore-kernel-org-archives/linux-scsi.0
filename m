From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] kref: warn on uninitialized kref
Date: Mon, 19 May 2014 10:19:46 +0200
Message-ID: <20140519081946.GV30445@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1405170650440.15837@file01.intranet.prod.int.rdu2.redhat.com>
 <20140517110454.GA1939@mguzik.redhat.com>
 <alpine.LRH.2.02.1405170836070.15837@file01.intranet.prod.int.rdu2.redhat.com>
 <53776918.7040402@acm.org>
 <alpine.LRH.2.02.1405171646290.32012@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fEHFiqIAmqToArad"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1405171646290.32012@file01.intranet.prod.int.rdu2.redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Mateusz Guzik <mguzik@redhat.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--fEHFiqIAmqToArad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 05:14:13PM -0400, Mikulas Patocka wrote:
> BTW. if we talk about performance - what about replacing:
>=20
> 	if (atomic_dec_and_test(&variable)) {
> 		... release(object);
> 	}
>=20
> with this:
>=20
> 	if (atomic_read(&variable) =3D=3D 1 || atomic_dec_and_test(&variable)) {
> 		barrier();
> 		... release(object);
> 	}

That would completely wreck kref_get_unless_zero().

--fEHFiqIAmqToArad
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTeb6aAAoJEHZH4aRLwOS6Z0QP/AxHPm3MZt4YbCIJwCec1/sm
Ic4raIPYUragV+ouXNAoW6S2QVvNqbAEol+v/9zBOGzwBoQpJIn8OBnMlBzKR49m
hQIqGw0fNUM2bxdT6buu40i9aI/7QxddPPUazqYyE1QLpoHzevAOT6lfMX+NdYoh
ta33B1QxP+f1K6xMvZI7TNAhAAf5WIh5ro5ULWdRCml5ZtwMeh+fWSS0LUV8KVce
aLXnmm5pQ4VQko0fGKdPb2uPSmwKtbbEcjT3/TlD4yEXLs0VP42Mj9dGkDSeBfYY
Ad/F3sP2/JL2HAjYo/fkS8LgpcObyik8A4mpxaLg1vnOkun7kYU5rW8t9llKCF0l
uuexC1aMZwFXR9iVB8/vqmjNwWpjMQzCuJNLzGx1xv0gFBlsXXK1tH+mZkcalsLU
qyBfwnUbeKJkI28/TVBEVD/fpdAobAaZOkflVXkSlyO2AsbsBmcMFWJpDuDfKnkv
96+0DU4PSrc2m1KF0uzdsV5I81xsww1If8SLzMRkW8cijlGNZ+2mVlckBIw25HBH
TNY+KJqFB+1xOd5vC+rz1nJpcdAS54S2zRsx1ogYsM1kKlAj/8VtWsq4STEnY2Fu
f/ABayAJ2P5X2Z/3hC/TT9gWlsWveytfLdifsCb5HaJeVA4eztQBLw8jphk3jmUA
gXVBx6XMhtZF7afIOFK3
=0XiE
-----END PGP SIGNATURE-----

--fEHFiqIAmqToArad--
