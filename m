Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CAC401496
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536444; cv=none; b=jaThs/IwDrOVIu3hVFn6pm/+0h/ZDWOhq+eSXieJ2UQr+mhy5kAAimZ8zDKGg7LY5H/wnS6tpUBsUYUDf8XBWaWcg1SEHXxRMYZUPdI+NA/qiNfnlkO0chxY1EhountrsRhKX9AfrARKWJbPcrKkmLopt5DgaK2eQbhtBbEVRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536444; c=relaxed/simple;
	bh=baXP0rsce8RxgN3E4KwK75xIeIhqJL8ydG3/ruWWQ8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KCxVjSqiRVMMUOD6RnHn51LCFjjMVqTds+d1PU04QyIedPvjiCRjS5/bdI4Wm4i1haRfpJdYUxLnp6mkRUKYJVdVCeYUf6hEbcmJaUxY4tJaJdn2W9L0TWHXFgj6wLnVQfCyZI/zcATOaAjtlAGNp3hUzSxhi7zIVYhkbzDizqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dmXxw4Vq; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dmXxw4Vq"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-beb2a97cc9aso660239566b.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781536441; x=1782141241; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=baXP0rsce8RxgN3E4KwK75xIeIhqJL8ydG3/ruWWQ8Y=;
        b=dmXxw4VqX9rJy0Nhflkh1cPoaQJM3DIc7nUadqCoZsY8iPyJ+0sp3Y4XTCLdKUL1n5
         PXsIc7sLksWgV6qPVOICCu5lKwf4VZchzqcV9/RDhRbVn/qBsbCcU084RA5yfrIeMslP
         3Nf4lJZZSC6fOW/vnzC/7m1PS5ryUI4qgGJwhisLjONpzoQQtDczbj8lrAlxOuOHsFpf
         U567u8i2qR3LXYq3Wefpd5YNM7Kr0U3shm/zjicIiwgz5UlDMMtUsKoJNL2nMuICXn6l
         yaK2BBhtQ7omMTsqQV0EVSGpzNd23iuXTSACVfrfelKkd89Xoqe/2reCiRLCzWwIo9z9
         WpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781536441; x=1782141241;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=baXP0rsce8RxgN3E4KwK75xIeIhqJL8ydG3/ruWWQ8Y=;
        b=bQQ9VvdfoAJSqjpluxACVNY45ZJl8Nb+aX++kNXtCDw0qmqHjMqH7yPLtZ88f6gdv1
         Py6dk3Pov3P96oWT6hvgM3Zz6BefR3y0qUI4qbQBruLjfcb6qjY+Vym4ZmtLoiFL9U8I
         FDqBVUgtuHyvf6Pj9ye6he/jhWUWEMsiaUGELrRvxcbJ3GuhyQIcE0kQPpBrWW7k/cBJ
         +e1DLKtts2m/NckJdjYd6NHXuF0uogRY7vgP4M3wSTmfvhsNu28OJjjQTQCq0Aku89Fe
         NF7mUc3/e0bapWovyn4fm+qDBXhpXvvrt+qsxCZoktTESiZ+brlK6F8bsqz4jHtfRZDT
         r2cw==
X-Forwarded-Encrypted: i=1; AFNElJ/5EbcTX+2xi6mF0Ga/no7aSGHTApNp/CGWVsi/EznrMdMvuzPTQrdSERnVydRVyL2dudgAy6nxUHJ1@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9/f4mFTSlNQNmDdlhHLflusws4Wsk4do/jPO0RJH21gCgpyOo
	hx8njMo7ijaA1qzTvuChP6NVI/Bau2ZLqJ7FiCqvDrvXSWyHNtD+Td61WZH4caW6k2k=
X-Gm-Gg: Acq92OHcBHN12pAnu4ueZ8atwENZfsUOpqkjlxqPVKoyeHkOtpNuXbm4WtlX5BlRs2O
	vQvMX/qK5fFN/9w/Ik5QdNV6IxxycjjHUe7sXj4Zl0dUBwJ5va7DFBnBWYdUvlapanC+VageWU2
	p9xJmzfUMCky4Lb9JtY4vDEKvte5C50X5eB91fk5htmawLOcZJjkcIxFDl4Z366drbVMaRDeeEF
	TZKneL5lHTnKoUqqqQUNfPU2AiI8Az3r/Cnzfn8sKYB5uX4MpiJZuewxv7VWV1ghN2+pbuc+q8H
	vXClT3cbAHB3+J/dz6m/FMfoRex/BYL7JRa2d5v6y5h4X5sjdct/0ch3pp+7svFDfrM2oyd+9by
	+6Zb8UpAR4c+aiGKnkSjYlTb+MjRfZa1GTDNwoE3n8n3gOnMwMHS4VyvftHWa1yDbOCLkBCeM5h
	X+/LI/Ao9ybEr8BBp2UsAIeJZk3OJO8gq4QMNQf2JHE0A7XIygI91CrCO01CZIFqqNwS/oKL6xU
	IBkw9jjwUy6v/fcaaRnZmo11s55Na1hH79Q24YmW/Spsnh70Tp01w==
X-Received: by 2002:a17:906:8a49:b0:bfe:ed25:c563 with SMTP id a640c23a62f3a-bfeed25c992mr358963766b.52.1781536441214;
        Mon, 15 Jun 2026 08:14:01 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb5318d8dsm476577766b.26.2026.06.15.08.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 08:14:00 -0700 (PDT)
Message-ID: <dbc707b0-accd-49a0-96b8-7be2f19dac2f@suse.com>
Date: Mon, 15 Jun 2026 17:14:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xen/scsiback: free unsubmitted command instead of
 double-putting it
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
 <20260611123046.2323342-2-michael.bommarito@gmail.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20260611123046.2323342-2-michael.bommarito@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Jf4ySejmD5HzM4B60G7A8ifN"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Jf4ySejmD5HzM4B60G7A8ifN
Content-Type: multipart/mixed; boundary="------------gFy1erWC8z42liK4wRBk1f9H";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <dbc707b0-accd-49a0-96b8-7be2f19dac2f@suse.com>
Subject: Re: [PATCH 1/2] xen/scsiback: free unsubmitted command instead of
 double-putting it
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
 <20260611123046.2323342-2-michael.bommarito@gmail.com>
In-Reply-To: <20260611123046.2323342-2-michael.bommarito@gmail.com>

--------------gFy1erWC8z42liK4wRBk1f9H
Content-Type: multipart/mixed; boundary="------------d3RfpG0bv0bddNhBytEpBYqL"

--------------d3RfpG0bv0bddNhBytEpBYqL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEuMDYuMjYgMTQ6MzAsIE1pY2hhZWwgQm9tbWFyaXRvIHdyb3RlOg0KPiBzY3NpYmFj
a19nZXRfcGVuZF9yZXEoKSBvYnRhaW5zIGEgY29tbWFuZCB0YWcgYW5kIHJldHVybnMgYQ0K
PiB2c2NzaWJrX3BlbmQgd2hvc2UgZW1iZWRkZWQgc2VfY21kIGhhcyBvbmx5IGJlZW4gbWVt
c2V0IHRvIDAsIHNvDQo+IGl0cyBjbWRfa3JlZiBpcyAwOyB0aGUgc2VfY21kIGlzIGluaXRp
YWxpc2VkIChrcmVmX2luaXQoKSB2aWENCj4gdGFyZ2V0X2luaXRfY21kKCkpIG9ubHkgbGF0
ZXIsIGluIHNjc2liYWNrX2NtZF9leGVjKCksIG9uIHRoZQ0KPiBzdWNjZXNzZnVsIFZTQ1NJ
SUZfQUNUX1NDU0lfQ0RCIHBhdGguIFRoZSB0d28gZXJyb3IgcGF0aHMgaW4NCj4gc2NzaWJh
Y2tfZG9fY21kX2ZuKCkgdGFrZW4gYmVmb3JlIHRoZSBjb21tYW5kIGlzIHN1Ym1pdHRlZCAt
LSBhDQo+IGZhaWxlZCBzY3NpYmFja19nbnR0YWJfZGF0YV9tYXAoKSBhbmQgYW4gdW5rbm93
biByaW5nX3JlcS5hY3QgLS0NCj4gY2FsbCB0cmFuc3BvcnRfZ2VuZXJpY19mcmVlX2NtZCgm
cGVuZGluZ19yZXEtPnNlX2NtZCwgMCksIHdoaWNoDQo+IGtyZWZfcHV0KClzIGEgcmVmY291
bnQgb2YgMC4gVGhhdCB1bmRlcmZsb3dzIGl0ICgicmVmY291bnRfdDoNCj4gdW5kZXJmbG93
OyB1c2UtYWZ0ZXItZnJlZSIpIGFuZCwgYXMgdGhlIHJlbGVhc2UgZnVuY3Rpb24gaXMgbm90
DQo+IHJ1biwgbGVha3MgdGhlIGNvbW1hbmQgdGFnLg0KPiANCj4gSW1wYWN0OiBhIHB2U0NT
SSBndWVzdCBjYW4gbGVhayBldmVyeSBjb21tYW5kIHRhZyBvZiBhIExVTidzDQo+IHNlc3Np
b24sIHN0b3BwaW5nIHRoZSBMVU4sIGJ5IHN1Ym1pdHRpbmcgcmVxdWVzdHMgd2l0aCBhIGJh
ZA0KPiBncmFudCByZWZlcmVuY2Ugb3IgYW4gdW5rbm93biByZXF1ZXN0IHR5cGU7IHVuZGVy
IHBhbmljX29uX3dhcm4NCj4gdGhlIHJlZmNvdW50IHVuZGVyZmxvdyBwYW5pY3MgdGhlIGhv
c3QuDQo+IA0KPiBBZGQgYSBoZWxwZXIgdGhhdCBqdXN0IHJldHVybnMgdGhlIHRhZyB3aXRo
IHRhcmdldF9mcmVlX3RhZygpIGFuZA0KPiBzZW5kcyB0aGUgZXJyb3IgcmVzcG9uc2UuIEl0
IGZyZWVzIHRoZSB0YWcgd2hpbGUgdGhlIHYycCByZWZlcmVuY2UNCj4gc3RpbGwgcGlucyB0
aGUgc2Vzc2lvbiwgYW5kIHNuYXBzaG90cyB0aGUgcmVzcG9uc2UgZmllbGRzDQo+IGJlZm9y
ZWhhbmQgYmVjYXVzZSBmcmVlaW5nIHRoZSB0YWcgY2FuIGxldCBhbm90aGVyIHJpbmcgcmV1
c2UgdGhlDQo+IHBlbmRpbmdfcmVxIHNsb3QuDQo+IA0KPiBGaXhlczogMmRiY2RmMzNkYmY2
ICgieGVuLXNjc2liYWNrOiBDb252ZXJ0IHRvIHBlcmNwdV9pZGEgdGFnIGFsbG9jYXRpb24i
KQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBBc3Npc3RlZC1ieTogQ2xhdWRl
OmNsYXVkZS1vcHVzLTQtOA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIEJvbW1hcml0byA8
bWljaGFlbC5ib21tYXJpdG9AZ21haWwuY29tPg0KDQpSZXZpZXdlZC1ieTogSnVlcmdlbiBH
cm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==
--------------d3RfpG0bv0bddNhBytEpBYqL
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------d3RfpG0bv0bddNhBytEpBYqL--

--------------gFy1erWC8z42liK4wRBk1f9H--

--------------Jf4ySejmD5HzM4B60G7A8ifN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmowFrgFAwAAAAAACgkQsN6d1ii/Ey+O
PAf/Qg12ML1MvaFXxcUkr/ZYb8gAt35wBMav4rH0yQXzWpF6WOyOrncQ6S5bzDOMyJffd+JlDsq9
rvwh2VU3bzxlNzz8tzLk2CHOJ53bUyB/IfBkGmZN9hJ7zMPoUwEVyUxwkWp79JB1HDXWzIoBKpzs
b6MGp3Sg/BwANrz4tKbbWJ+m/GrTOaJNAUb2rJb3XZ7SjcTTWnWPpE2g4ZI4djCbYIUsAXCJXX64
HYkLfTrMWF9LbTjN8tkGy+kUVseyYRvG46nz2VCThoRHi9GZIkPZCHL79Tz1LnrWZ9xiBTMiZvfP
leBsJB6fUa1Zc2v70+ANSnk7DB3hxjzsFc/LdcGFpQ==
=3jap
-----END PGP SIGNATURE-----

--------------Jf4ySejmD5HzM4B60G7A8ifN--
