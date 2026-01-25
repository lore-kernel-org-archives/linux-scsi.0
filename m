Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629211632C8
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 00:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769300384; cv=none; b=lq2+z6rWdZQEArwMeNT7Y+7cJmuCoaFsPi7TxibSjxUKbCmHcaZfPwv6osLCus4/9ZkR5nNdaWxLFzfsK22DeCHa8vHqgMU4OTInWRMeRshLaKWAKthwFczs27SpIA48f2rzsQ1zMtl9BJKdIU1TIRcDaG2EGCHg2LxInzPCWxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769300384; c=relaxed/simple;
	bh=/901gVdagbHjXCXWm9JXn98OQn5brnsv2hws2AjPWe4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tc6unL7gciPXbI4ltCjuGndchcTPqHZ3bsNIO8D84Cxiuu4QyWvNa1jo+FzvDcY/jPmuC86Iu//9dfOTPpKpsoPXXySgVW9xfsmsDh/qEbDKE33g589js1dQsn0cX4nz9/0ox/j1WJVnzc7BdMMfAulrjIadKo1jrIVM7BRiVfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=QSx0LhnH; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="QSx0LhnH"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 68AA2240027
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 01:19:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1769300375; bh=nxLHPQeCYgUJXUz8HOnbMnfMc0jzS3dyxzGKeyf7QoY=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=QSx0LhnHl6Xfci60AxrYu2YZco3nA0j3BD5TQWB7Cb0eM9zjlgvoQEBIZ01m1Bwed
	 2SGVz6jEq2UAezIG5NYaY+0zvHkazLw/Tu5ZhdUaJQ5syt1oZDo3xx2eNtTmiBn/Bf
	 1Ns34er8Xw62T6jiFcLqCaxUIOc0GVYGCv8VEWPOT/vYSOHSKGQ04aRRUHKE9mWUol
	 quRzs4JLaRGHT08Y7O3ngQZoLm6CGi6mstreOlen7oGFwfhzGnZ3e7Ize68oHoRz6x
	 xhOeagv9eXWDj+iKPwF6uImW0Wcm7zTGvI1zNgl1sVskn00B3tamV6pU3zBGr3enm2
	 2vTvnmeAZxKjw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dzC390sbtz9rxF;
	Sun, 25 Jan 2026 01:19:33 +0100 (CET)
Message-ID: <0e1013200b07befe94b959b6c0335a05dd7d502a.camel@posteo.de>
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
From: Markus Probst <markus.probst@posteo.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, Rob Herring
	 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley	
 <conor+dt@kernel.org>, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 John Garry	 <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, 	linux-leds@vger.kernel.org,
 devicetree@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-ide@vger.kernel.org, 	linux-scsi@vger.kernel.org
Date: Sun, 25 Jan 2026 00:19:34 +0000
In-Reply-To: <aXVT8AzgHbr8tbsT@ucw.cz>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
	 <aXVT8AzgHbr8tbsT@ucw.cz>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=mQINBGiDvXgBEADAXUceKafpl46S35UmDh2wRvvx+UfZbcTjeQOlSwKP7YVJ4JOZrVs93
 qReNLkOWguIqPBxR9blQ4nyYrqSCV+MMw/3ifyXIm6Pw2YRUDg+WTEOjTixRCoWDgUj1nOsvJ9tVA
 m76Ww+/pAnepVRafMID0rqEfD9oGv1YrfpeFJhyE2zUw3SyyNLIKWD6QeLRhKQRbSnsXhGLFBXCqt
 9k5JARhgQof9zvztcCVlT5KVvuyfC4H+HzeGmu9201BVyihJwKdcKPq+n/aY5FUVxNTgtI9f8wIbm
 fAjaoT1pjXSp+dszakA98fhONM98pOq723o/1ZGMZukyXFfsDGtA3BB79HoopHKujLGWAGskzClwT
 jRQxBqxh/U/lL1pc+0xPWikTNCmtziCOvv0KA0arDOMQlyFvImzX6oGVgE4ksKQYbMZ3Ikw6L1Rv1
 J+FvN0aNwOKgL2ztBRYscUGcQvA0Zo1fGCAn/BLEJvQYShWKeKqjyncVGoXFsz2AcuFKe1pwETSsN
 6OZncjy32e4ktgs07cWBfx0v62b8md36jau+B6RVnnodaA8++oXl3FRwiEW8XfXWIjy4umIv93tb8
 8ekYsfOfWkTSewZYXGoqe4RtK80ulMHb/dh2FZQIFyRdN4HOmB4FYO5sEYFr9YjHLmDkrUgNodJCX
 CeMe4BO4iaxUQARAQABtCdNYXJrdXMgUHJvYnN0IDxtYXJrdXMucHJvYnN0QHBvc3Rlby5kZT6JAl
 QEEwEIAD4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AWIQSCdBjE9KxY53IwxHM0dh/4561
 D0gUCaIZ9HQIZAQAKCRA0dh/4561D0pKmD/92zsCfbD+SrvBpNWtbit7J9wFBNr9qSFFm2n/65qen
 NNWKDrCzDsjRbALMHSO8nigMWzjofbVjj8Nf7SDcdapRjrMCnidS0DuW3pZBo6W0sZqV/fLx+AzgQ
 7PAr6jtBbUoKW/GCGHLLtb6Hv+zjL17KGVO0DdQeoHEXMa48mJh8rS7VlUzVtpbxsWbb1wRZJTD88
 ALDOLTWGqMbCTFDKFfGcqBLdUT13vx706Q29wrDiogmQhLGYKc6fQzpHhCLNhHTl8ZVLuKVY3wTT+
 f9TzW1BDzFTAe3ZXsKhrzF+ud7vr6ff9p1Zl+Nujz94EDYHi/5Yrtp//+N/ZjDGDmqZOEA86/Gybu
 6XE/v4S85ls0cAe37WTqsMCJjVRMP52r7Y1AuOONJDe3sIsDge++XFhwfGPbZwBnwd4gEVcdrKhnO
 ntuP9TvBMFWeTvtLqlWJUt7n8f/ELCcGoO5acai1iZ59GC81GLl2izObOLNjyv3G6hia/w50Mw9MU
 dAdZQ2MxM6k+x4L5XeysdcR/2AydVLtu2LGFOrKyEe0M9XmlE6OvziWXvVVwomvTN3LaNUmaINhr7
 pHTFwDiZCSWKnwnvD2+jA1trKq1xKUQY1uGW9XgSj98pKyixHWoeEpydr+alSTB43c3m0351/9rYT
 TTi4KSk73wtapPKtaoIR3rOFHLQXbWFya3VzLnByb2JzdEBwb3N0ZW8uZGWJAlEEEwEIADsWIQSCd
 BjE9KxY53IwxHM0dh/4561D0gUCaIO9eAIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCR
 A0dh/4561D0oHZEACEmk5Ng9+OXoVxJJ+c9slBI2lYxyBO84qkWjoJ/0GpwoHk1IpyL+i+kF1Bb7y
 Hx9Tiz8ENYX7xIPTZzS8hXs1ksuo76FQUyD6onA/69xZIrYZ0NSA5HUo62qzzMSZL7od5e12R6OPR
 lR0PIuc4ecOGCEq3BLRPfZSYrL54tiase8HubXsvb6EBQ8jPI8ZUlr96ZqFEwrQZF/3ihyV6LILLk
 geExgwlTzo5Wv3piOXPTITBuzuFhBJqEnT25q2j8OumGQ+ri8oVeAzx24g1kc11pwpR0sowfa5MvZ
 WrrBcaIL7uJfR/ig7FyGnTQ1nS3btf3p0v8A3fc4eUu/K2No3l2huJp3+LHhCmpmeykOhSB63Mj3s
 3Q87LD0HE0HBkTEMwp+sD97ZRpO67H5shzJRanUaDTb/mREfzpJmRT1uuec0X2zItL7a6itgMJvYI
 KG29aJLX3fTzzVzFGPgzVZYEdhu4y53p0qEGrrC1JtKR6DRPE1hb/OdWOkjmJ75+PPLD9U5IuRd6y
 sHJWsEBR1F0wkMPkEofWsvMYJzWXx/rvTWO8N4D6HigTgBXAXNgbc3IHpHlkvKoBJptv6DRVRtIrz
 0G0cfBY0Sm7he4N2IYDWWdGnPBZ3rlLSdj5EiBU2YWgIgtLrb8ZNJ3ZlhYluGnBJDGRqy2jC9s1jY
 66sLA9rQZMHhJTzMyIDwweGlvMzJAcG9zdGVvLmV1PokCbQQTAQgAVxYhBIJ0GMT0rFjncjDEczR2
 H/jnrUPSBQJpa71VGxSAAAAAAAQADm1hbnUyLDIuNSsxLjExLDIsMgIbAwULCQgHAgIiAgYVCgkIC
 wIEFgIDAQIeBwIXgAAKCRA0dh/4561D0gKJD/9uOQKYlsDoQX65Gd0LiMT0C+5vXgr3VI0PHDOwcv
 51fJ3A1vNyPZRFPGrz8+mDEXUQOF/INfnz5Tu1QHwf+iYcWcTGAN/FHgVR6ET6VBNU2hJaKhu+Ggo
 kjYyJTOvyX+3yNRUfSny0GjTjIPuPTErjqmHF+BtjXslpgwqnNMznf3lRIuUjRORupos6p3k1DndE
 5vzUTmXSvMyXyOD2KhBl/kL76k0bHYyAQytZPag12pltrtFbA/r2phDGN2si8PooDT99bSTJjaM45
 MTAAHbHKJfvgfK41bNFD5mMtpWpL195XRtS0Nrxdg3PaYBxN5gtTG0RyZfpYRlkdEhm+jj/8RxuSG
 i/qdhRdbiI7K2IELWeQVHSNDi9JabR/UzlR4NSnhfAjRIVlRM+eFbUl8XwxwVrAkojF5IraH2qRvg
 VCmuFsHUW07FUlrDrzpjXsD73cKppoFGDCdDR0BHJepXbFLS9+AqkT+guRJlnCTg2p+TQtnbwPgKp
 Vj98JixovCl99zRYTsL2bRNU5+q8iET65VMJ1ydyNanvLd5vI/NqDkXhlXLsGmdaDTtu4R21PkToX
 dQNGrZ91M9nlIBKw8Y7c7xZ4098qX2b8JX/CxD+gC1r4C8vuA3GkhFLx+KlkON7LyiJPkrePp6Qky
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-9xWzoZBG+Cr8tCg2F4Ue"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt


--=-9xWzoZBG+Cr8tCg2F4Ue
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-01-25 at 00:21 +0100, Pavel Machek wrote:
> Hi!
>=20
> > Extend the disk trigger
> > - to allow configuration of the blinking delays
> >   and whether the led should be kept on, on idle.
> > - to allow an individual led to be mapped to an ata port
>=20
> I have used led trigger before, and it annoyed me than "constant disk
> activity" resulted in "constant LED blinking" instead of "LED
> constantly on". I would not mind if that was fixed.
>=20
> Thanks and best regards,
> 								Pavel

This patch series adds support for changing the delay_off value in
blinking.

For having "constant disk activity" =3D> "LED constantly on" the
delay_off value has to be set to 0 ms.

Let me know if I should adjust the default of delay_off from 30 ms to 0
ms.

Thanks
- Markus Probst

--=-9xWzoZBG+Cr8tCg2F4Ue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAml1YYUbFIAAAAAABAAO
bWFudTIsMi41KzEuMTEsMiwyAAoJEDR2H/jnrUPSXtEP/2TFJ9UT1+YvqUImxtVr
jZL9Vr8Cy3XpQYatLlSjsWcA8ogFvAUhFAJIWh3Lt/0snughQSoATJ3E7vJ2h7+Y
ZKvHMvIrkgA2sPpPQv22+K3LebZ1DGSHLlX/SrO3nSwxeYulwkKj8Xp5eOPaj7oX
ChMfBpeh7VcejY08Av8dKgPpsYPtKd/3skTnYh6VOkjqkk4gUtNMaexS1qqprFZ2
KVbt2mFzNCt3V3oQvOKWX7QaGcPwNfduJ9G40e6oKztBNVT0/oY8vdFVGMmjhDMv
lUPlvrPysQwVDLqsghiWo3l7VG60JE4QnmwaPJecVCMp1SvOLAIma2GgBaYC9rL+
KYhNQlTJWUE3mELqf5eDFO1NghAIPhgikc+U2fv7wGxMpdQfElzTfJX+2p/eqzvW
YQ0UoD2HOgj+44tD2AyWVor9OtGqDhvv76eCFbZ9+WQq9E5san26nhwDxo15jVa5
QLUNrxVeawOq/tVsFjoqhI1EUdONk1G+aIuxJBNPRHCt468+sYOr3f0u4qZ1MAan
363UinspnJV+XmBrnEkhfA22I86Ln1jw6mIlfRAXmWr88uw3wZiGtxEK6v5HD3mA
WPb7ybAIqyY+2qBJfvKQtyWWIlM5ZKffLffqnlJn2BxqrRbvFiPpioPUNs/DtJF1
8KwSyTq1hlwGOG5EOliGr9Hc
=X7E1
-----END PGP SIGNATURE-----

--=-9xWzoZBG+Cr8tCg2F4Ue--
