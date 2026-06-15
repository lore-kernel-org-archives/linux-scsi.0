Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAA4401A10
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536492; cv=none; b=AvC7dC7JR6nOEnsQuuJRJ4VlMFfPsltkgZCKiPeJi/JNC5domzcMYCxHqI+gibtajBBVY2D1LzLLpDE20b26Y+douttkro3xFHgPaSLWYp3P/6Ht7CrMAKX6dHBs3a5xE9aq6oFTreTDoAJtq5Dwmb4cmInGcVd2cvkIsa5kiUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536492; c=relaxed/simple;
	bh=B3sS3PLpEox/I90orKXtXi+fuwEPT4sqQMjXEhQJhEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0RI32FsHfotiAcWeGnIV1tQxI0JyKKjj538IJAFFOL+O+gqTYlASzpr3L+bDikUrWjnWPzKxiQFCerKqPoNgbf78AKvrB7FCyglg2CkGdKpwywPzocAyyAZqPcYzzCx6OyNU886hT8xlnqtGGFEBx0zXl+1M/MrVkOlZ2yhngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HrTXfAhD; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HrTXfAhD"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6913160c9ddso6458679a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781536489; x=1782141289; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B3sS3PLpEox/I90orKXtXi+fuwEPT4sqQMjXEhQJhEA=;
        b=HrTXfAhDWjMGxswvU+8Hknzc0b+9X77PI62iuDAkcqYM3dzsPc6eUBv/luksP69eVf
         YF+e6hlDUXnCxWzqocQdcW5Ma4+a5o4Mh9gddhgYMrdneLgZzDKGi6dsueq8p7iw50co
         uaHB/TNthxu6aACzzBRTXgGiX22HlbAUZKLCpx8H2kKN/T5Q3kQTf0+s1usoU9qQZRaC
         +FiUXDjpcrVhraMZkSvvJQqPEUQzt34HoJUpt4YrLLHibFxTA5sUOLLQuUY94PQhud39
         n1fWluh1IV7tsbOonyNf9HcnCgaURbXJgi9nNhbFv+UTy6Bbtx5w+ZTUBpB0dV4w7Vri
         sQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781536489; x=1782141289;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B3sS3PLpEox/I90orKXtXi+fuwEPT4sqQMjXEhQJhEA=;
        b=GFF+857pKZ5g01Vnw40hduLUwG/ZvODRYHj2Ufn7PKhUkO9jdHiPcnxqj2BuI1yBWN
         Vo+a8LDO81pz+hPp69a5UEpMHyf1fof9j32Q8T4BBOuNbT/tkqghNsatDw2QtIkIteyg
         0bjtwCWPLcnVkLaVpFsKe1EkShWJXK8KDqYHvSFUAPln/4pZASKUV/LB4cbmEN7jz8hs
         YY4Z2jexWaZ1gUxtwIuqXHvuE+iHFDJPylYNdCjHn2QWI4p2OWA0suMQmywGCFyoL19i
         Gg0oeC1neUYID31blXvzXx1sIRY9FKVofYo/qTTZxLuYIGpKr8cFShEtY6/KD6N8qOaH
         TilA==
X-Forwarded-Encrypted: i=1; AFNElJ9q0DBdjfGKDhTMP9ie+YGpREIyJgFNqqHq211cmE0Zf5RnDO6RyDpLdbpkNnglZfrHtAXHclgt9SYI@vger.kernel.org
X-Gm-Message-State: AOJu0YxInsUSC0k+IHU8FEyFGB8GrnKBRKtVWqxsnQd4sYVgO5MihKNW
	vWTVMc7Fx1UUkR/HSRRsqMpyomdwxORukIhLQQdc9dbvwpnPeR6P92lyW7d3XiEUtSc=
X-Gm-Gg: Acq92OEt4ZT7wmtRSzXkTyXXNywbxWQU38ftH9jlCA8OCUuxGjAcxSaIySIDqTUZrSi
	7mWOus4XmK75nmLGCKfkA8Ttply58PYHEQUTbXGGfL46dUyOqUarjXhU6FFhuTU+R+PdYfQx8ue
	FMOxLucmduX4NXwoilttzYxNwWDT8o8RpFkgonXhgR5lkbEU8WH7Igdxa1hZdrCOjRUaUqno0p5
	vd4+16y4H2fNUTUe4yGt19sqBzcMWNAwiE8SNAWgbQUWaAp5Dk2b54l9XYpMLJvWraYcYqQg6fZ
	BUS8wwjb33jIkSTEnrX9tmDCC20q2DpdslLtkTlQP9m4zqo7+yjUiwW13uoRd56ZNb424Ls65LF
	JEnIa/EqfxQATTXH70Kg1844dlORVuLBZwVYbJF3hv4gGewd3+lfo8bxIDfBUmTRWw0QpZJ1Eh0
	Mh7AZGjNgKzQiw8KJB3qjTkc6SeosuoRHkT4VtAuRs3zeZoiZRKvpr22ybAUkGcQ6LwFfLtFXZ+
	AwyyeLgLSNMNbk6k9MszPhqRc3htRZGF4Uv3+Ke+eH+YI8GlLfuqg==
X-Received: by 2002:a05:6402:3588:b0:68f:cc95:ba5b with SMTP id 4fb4d7f45d1cf-693c6a8cf7cmr5170579a12.27.1781536489059;
        Mon, 15 Jun 2026 08:14:49 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-693c43a6d9csm3070699a12.13.2026.06.15.08.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 08:14:48 -0700 (PDT)
Message-ID: <a2c4253b-99ed-4dab-9f2b-1906f958522b@suse.com>
Date: Mon, 15 Jun 2026 17:14:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xen/scsiback: free the command tag on the TMR
 submit-failure path
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
 <20260611123046.2323342-3-michael.bommarito@gmail.com>
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
In-Reply-To: <20260611123046.2323342-3-michael.bommarito@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------30fN0dc4b3OHkvjxlNkt3JWf"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------30fN0dc4b3OHkvjxlNkt3JWf
Content-Type: multipart/mixed; boundary="------------JnwtXeAGP8AktzTMtTeWLuja";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <a2c4253b-99ed-4dab-9f2b-1906f958522b@suse.com>
Subject: Re: [PATCH 2/2] xen/scsiback: free the command tag on the TMR
 submit-failure path
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
 <20260611123046.2323342-3-michael.bommarito@gmail.com>
In-Reply-To: <20260611123046.2323342-3-michael.bommarito@gmail.com>

--------------JnwtXeAGP8AktzTMtTeWLuja
Content-Type: multipart/mixed; boundary="------------Lx4hjADfd9WcEZaF3yim000E"

--------------Lx4hjADfd9WcEZaF3yim000E
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEuMDYuMjYgMTQ6MzAsIE1pY2hhZWwgQm9tbWFyaXRvIHdyb3RlOg0KPiBzY3NpYmFj
a19kZXZpY2VfYWN0aW9uKCkgb2J0YWlucyBhIGNvbW1hbmQgdGFnIGluDQo+IHNjc2liYWNr
X2dldF9wZW5kX3JlcSgpIGFuZCBzdWJtaXRzIGEgdGFzay1tYW5hZ2VtZW50IHJlcXVlc3Qg
d2l0aA0KPiB0YXJnZXRfc3VibWl0X3RtcigpLiBXaGVuIHRhcmdldF9zdWJtaXRfdG1yKCkg
ZmFpbHMgaXQgcmV0dXJucyA8IDANCj4gYW5kIHNjc2liYWNrIGp1bXBzIHRvIHRoZSBlcnI6
IGxhYmVsLCB3aGljaCBzZW5kcyBhIHJlc3BvbnNlIGJ1dA0KPiBmcmVlcyBub3RoaW5nLCBs
ZWFraW5nIHRoZSB0YWcuDQo+IA0KPiBJbXBhY3Q6IGEgcHZTQ1NJIGd1ZXN0IGNhbiBsZWFr
IHRoZSBjb21tYW5kIHRhZ3Mgb2YgYSBMVU4ncw0KPiBzZXNzaW9uLCBzdG9wcGluZyB0aGUg
TFVOLCBieSBpc3N1aW5nIFZTQ1NJSUZfQUNUX1NDU0lfQUJPUlQgb3INCj4gUkVTRVQgcmVx
dWVzdHMgd2hlbmV2ZXIgdGFyZ2V0X3N1Ym1pdF90bXIoKSBmYWlscy4NCj4gDQo+IHRyYW5z
cG9ydF9nZW5lcmljX2ZyZWVfY21kKCkgY2Fubm90IGJlIHVzZWQgaGVyZS4gQnkgdGhlIHRp
bWUNCj4gdGFyZ2V0X3N1Ym1pdF90bXIoKSByZXR1cm5zIGFuIGVycm9yIGl0IGhhcyBhbHJl
YWR5IHJ1bg0KPiBfX3RhcmdldF9pbml0X2NtZCgpIChzbyBzZV9jbWQtPmNtZF9rcmVmIGlz
IG9uZSwgbm90IHplcm8pLCBhbmQgb24NCj4gaXRzIHRhcmdldF9nZXRfc2Vzc19jbWQoKSBl
cnJvciBwYXRoIGl0IGhhcyBmcmVlZCBzZV9jbWQtPnNlX3Rtcl9yZXENCj4gdmlhIGNvcmVf
dG1yX3JlbGVhc2VfcmVxKCkgd2hpbGUgbGVhdmluZyBTQ0ZfU0NTSV9UTVJfQ0RCIHNldCBh
bmQNCj4gdGhlIHBvaW50ZXIgZGFuZ2xpbmcuIExldHRpbmcgdGhlIGNvbW1hbmQgcmVsZWFz
ZSBydW4NCj4gdGFyZ2V0X2ZyZWVfY21kX21lbSgpIHdvdWxkIHRoZW4gZG91YmxlLWZyZWUg
c2VfdG1yX3JlcS4NCj4gDQo+IFVzZSB0aGUgc2FtZSBoZWxwZXIsIHdoaWNoIHJldHVybnMg
anVzdCB0aGUgdGFnLCBvbiB0aGlzIHBhdGggdG9vLg0KPiANCj4gRml4ZXM6IDJkYmNkZjMz
ZGJmNiAoInhlbi1zY3NpYmFjazogQ29udmVydCB0byBwZXJjcHVfaWRhIHRhZyBhbGxvY2F0
aW9uIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQXNzaXN0ZWQtYnk6IENs
YXVkZTpjbGF1ZGUtb3B1cy00LTgNCj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBCb21tYXJp
dG8gPG1pY2hhZWwuYm9tbWFyaXRvQGdtYWlsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEp1ZXJn
ZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=
--------------Lx4hjADfd9WcEZaF3yim000E
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------Lx4hjADfd9WcEZaF3yim000E--

--------------JnwtXeAGP8AktzTMtTeWLuja--

--------------30fN0dc4b3OHkvjxlNkt3JWf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmowFugFAwAAAAAACgkQsN6d1ii/Ey/u
1QgAgMgugck5RFkPC7QeBaJ0LIT21B2fLVOBow5S7PSnFm6QhyL3zdSMJbufs0wxNTf286qDaqXy
7ncVw63W4hvoOY0hkJQwGEqOB3JCJ+sK1recDIoFTLP3FEHHjVaWbXnlz1IZFEidgvzlgs0s1ZLW
dF0wVrA1G5PXNixuoENucei6EiDC8lqFxFxEbBbby/1ZOi2yWjb5yycjWE5rFf8L+atKcPY24Mzg
2E8/IRPNNFdaNPm2wFxh709znikGqTzzVTB10xD1s693wAwgInz4jyDvEDDGW2WZM9Diux/WatzF
TBM0r3yfrZpWFpEHIeMUQ4mNXGRbalbyc/6zQ327Bw==
=y292
-----END PGP SIGNATURE-----

--------------30fN0dc4b3OHkvjxlNkt3JWf--
