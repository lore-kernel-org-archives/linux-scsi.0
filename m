From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
Subject: Re: General protection fault with use_blk_mq=1.
Date: Wed, 28 Mar 2018 20:13:08 -0700
Message-ID: <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jYhx2pfQ5AYdp8dKnU3XZ0LRR8oyJH6VJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jYhx2pfQ5AYdp8dKnU3XZ0LRR8oyJH6VJ
Content-Type: multipart/mixed; boundary="Qpjn4B0IU1D87juBCWkeHXN0q9fTJ2NrG";
 protected-headers="v1"
From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
To: Jens Axboe <axboe@kernel.dk>,
 "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
Message-ID: <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
Subject: Re: General protection fault with use_blk_mq=1.
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
In-Reply-To: <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>

--Qpjn4B0IU1D87juBCWkeHXN0q9fTJ2NrG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03/28/2018 06:02 PM, Jens Axboe wrote:
> On 3/28/18 5:03 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>> I am not subscribed to any of the lists on the To list here, please CC=

>> me on any replies.
>>
>> I am encountering a fairly consistent crash anywhere from 15 minutes t=
o
>> 12 hours after boot with scsi_mod.use_blk_mq=3D1 dm_mod.use_blk_mq=3D1=
>=20
>> The crash looks like:
>>

>>
>> Looking through the code, I'd guess that this is dying inside
>> blkg_rwstat_add, which calls percpu_counter_add_batch, which is what R=
IP
>> is pointing at.
>=20
> Leaving the whole thing here for Paolo - it's crashing off insertion of=

> a request coming out of SG_IO. Don't think we've seen this BFQ failure
> case before.
>=20
> You can mitigate this by switching the scsi-mq devices to mq-deadline
> instead.
>=20

I'm thinking that I should also be able to mitigate it by disabling
CONFIG_DEBUG_BLK_CGROUP.

That should remove that entire chunk of code.

Of course, that won't help if this is actually a symptom of a bigger
problem.

Regards,
Zephaniah E. Loss-Cutler-Hull.


--Qpjn4B0IU1D87juBCWkeHXN0q9fTJ2NrG--

--jYhx2pfQ5AYdp8dKnU3XZ0LRR8oyJH6VJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJavFnTAAoJEJMemkxvB+Y84YYQAK9zwn4t73WvBeROE0ox8WYW
fXj2xtMHTxIBwS/jbveYhzEHGAoSm2OpUNhVSJUjLTyEWl6aXlbniyFP7ddjaxq+
ygE5kKPPsykI/HmAdztcgJJb3YfSqJec91768mvUA24h8SaDXG+yIxfpiVNQYPnh
NqEr/m2j9KKnopx/0K7cEllyK7IqHcKZb5+FQoJC/jHT29eUeowNvhT6fg08C1iZ
z+z85B981OCdFqSnc/2wQfJQvrCrN84PagVUydhieZF+MSwL3+BvjCv0o5kuknyc
jwy2q8Gu36b/Y3dq/Ei2mRZGRfHLDYMqPC1oj/vajYnCxi8LiK6z89iei/+cKVVm
zw/k04QBBih8GP7ZI/7sHOIC60qS2oxP4Ipm3hJle6H2d2Say5jtlXoOAzAbR5kN
94bVZwCjyX11Q62fXBlCKvc2HLFtv9vZYltc6R2MfBQQued3ya9dT4CSmZ5roZe/
epHEuTmYMG4JAcvJlOcaR83m/03UglZ6AP1mFnbc3p2U45ZneVAkHJyzsR0Qgzn4
FgJ2zkuTlmfcDNSjLGp0Zxvfv8VMoV5dRSUbXByE3W3neiXr92BTbiWxgBVqabw6
Yd1f5Hv/94HlqxdFs6VA6uUe8Y+hHdZPUaZsV+LPi69nGe4WagKDQ2yQrz5/031T
tMsnmiWLLSDSOvN4H5cT
=Rjz6
-----END PGP SIGNATURE-----

--jYhx2pfQ5AYdp8dKnU3XZ0LRR8oyJH6VJ--
