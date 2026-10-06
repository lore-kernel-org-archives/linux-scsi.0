Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9F43F4C5
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294971; cv=none; b=AnIaHtNSyEN3aPgg6z1UTYBvIzQEStOoLhOBFkdH4XLZJDzmGyJT+YIl5djzoZwESZmBxnbblqTW9sdFMG7nypDk9kE1X2TJk3i560CglHcONPS6WvJA1m9x5XsKoyH3Z9O4JiVwINXKMAIFyA/bFaH6mvtYRIHYrDD5ovjviqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294971; c=relaxed/simple;
	bh=/Dhuh/wtI0yX/Les8bDjamHrz/rhROiQMQkvk8Zx65o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N1tzgaDAHDSD6wROyOvy2tpHnX6FjT4LqyRtEXffHjFlobz3JCUrSG2i6nlmK5nqeS5HtEZU0HpcrYHfRr0zXTLx4BKOf20NU7UDCqSLaWXAfd34Ivv30Mt0ClG/h9MtnxtGgRuDOvZw5o/YkqiaU14j2cq2/7dR9sZ+VFMWb/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gDOgNTbV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gDOgNTbV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so8155385e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 06:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791294967; x=1791899767; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/Dhuh/wtI0yX/Les8bDjamHrz/rhROiQMQkvk8Zx65o=;
        b=gDOgNTbVxzxJR0Asl3ay6a5Kf8rfl9ha0LABhQZaEHgid/0Hjp/mt911TErgMnV7MW
         Y45hd+3g9/ziRwZC2X2PadKiFj7iJY1rxtn8IjUAR7Bah25lf55s1tOuNl1SfbJmayB5
         YgkTwdHrYCpWrRrBBByG29qiAptb6HpDE3NvxoctqwRtmSHIHhdqdwRsH78oKejodLm6
         6binDxw0QJpvhwS7BdQeHfO5EppkUMp3msx3kSYf+a0yJOEoMEBFZdChFZLZZ4gPvwLE
         4+MToniGd6HF/BPTv+SolJ5cpYM9L9x4jJZQpNu5H1r3jsJ+8vT0eVqGsUIUh9MCZcal
         t9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791294967; x=1791899767;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Dhuh/wtI0yX/Les8bDjamHrz/rhROiQMQkvk8Zx65o=;
        b=rthdeftVcIbVcYiG9t/57B9YJzIqM8aCPAwSe6Mxi8afij+sQjiixDTdFEnFqON8pP
         WiBl+dO1t/AAK3mqrva/PzsX3dNpXqBH7gXTGBRfBBqiI01OYmkvgMjGvVAKjv4VUedX
         27DO1BLVxTPX/dlJ+9VBAVDhdcqsHzYKMCu9OZ2FNsE3dN92w4cBc0w3qSBAWcALlJvg
         w0ckK5wUW/WrcvfKvOesnDtKFcLI1CxRHGFopdgWqgCvOhF9j7gE4QZANcFDYqYp7SZp
         sTQHE/IcbbSyfYIZwUuOH0s7EHXmimC8rSgwhNKxD35U/toxAtqRHGRrbjYn0OBiTdY6
         Qmdw==
X-Forwarded-Encrypted: i=1; AKwUvBwOg6s2hizAAtugToqU0CEaINS197RlKhK7bUtU7zWLcFwLK4NPpB/JpYeJigAeD/O/zfRcHQOydQBl@vger.kernel.org
X-Gm-Message-State: AFuF++l1MZI479hwWQY4UutGOW/iik82HGHLl9r2Jm2i1c0/06JDqZ6M
	c1Lft8bj0TYMDwitdzEv3RMG9sj/7Soae3h+5vYhxrpfIuoysgP3rS7ud9XTMgjAXVBm+0ZxFzw
	54FU1PDQ=
X-Gm-Gg: AYBFou2hlq47CjxYUniqLNBrxNYRD3bKX/nl8gK38aRdfCTHzcPWx57IaMydlWlEUZx
	VXE0HlWQeDO8G50q9eMCIzRIr+TJkf8xrSRg9vAN249rvQSe4Tb4Hsy/ZjAclL5JZAzs722eu+A
	cD2pzAxUyCw9siPLUjAuyPnAovnQAherLjz8mwHww74Q9Jt9optZbW5PjUlmpXCVyNcqJBPebzs
	Bm6j6j8q0AJQ6s2gckF4mF+iCYFkgAZIC9jp3RiBagLkGYr1hrR7dd9zD9Rr2OejIpiFsyUZeK3
	LiBCDAFDV+vjlT1xbiP68HdPaOkoMiCU+zM1n7R4B0TPiTVfcmHpsNID9D9sKvtYtj9/I3ZD19B
	9WnMCCnT3y8mBlC/PZK0pYXiseUXi9gOUOcwwm2NSbihhybPV6d/weGc8ehHZOjr91CpkrNBwpb
	5uXAFFiezIxhV+h7AVMMsSyjLqvu8s1mMRiAgsy2z8XyvqAGDWPEQ6gwPmr6CSAcc9A+G89c2FP
	XgUDamrp5s5AfrA1eBcXjSTxnMaQE5KXCu/8N45WrLWisd9WReXNqXrGMGS0lCp+dkNxF8UrAmo
	/l2COaFkWh5H74XHOZHocvp4
X-Received: by 2002:a05:600c:5492:b0:4a1:6d35:779a with SMTP id 5b1f17b1804b1-4a17b4f297bmr27971755e9.3.1791294967343;
        Tue, 06 Oct 2026 06:56:07 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17a0fc2e4sm68582055e9.3.2026.10.06.06.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 06:56:07 -0700 (PDT)
Message-ID: <f073f438-7335-4d9f-9bba-c6df5ee1fa40@suse.com>
Date: Tue, 6 Oct 2026 15:56:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xen/scsifront: check for a NULL shadow entry on a backend
 response
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
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
In-Reply-To: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nnH7S5YuLqUH0yIqtmqXntAT"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nnH7S5YuLqUH0yIqtmqXntAT
Content-Type: multipart/mixed; boundary="------------0I6v6BijZSEvEjvGrfeccWKG";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Message-ID: <f073f438-7335-4d9f-9bba-c6df5ee1fa40@suse.com>
Subject: Re: [PATCH] xen/scsifront: check for a NULL shadow entry on a backend
 response
References: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
In-Reply-To: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>

--------------0I6v6BijZSEvEjvGrfeccWKG
Content-Type: multipart/mixed; boundary="------------HscB0pQhO6alWtKX55NS0MMB"

--------------HscB0pQhO6alWtKX55NS0MMB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDUuMTAuMjYgMTQ6MzUsIFllaHllb25nIExlZSB3cm90ZToNCj4gc2NzaWZyb250X2Rv
X3Jlc3BvbnNlKCkgdmFsaWRhdGVzIHRoZSBycWlkIGluIGEgYmFja2VuZCByZXNwb25zZSBh
Z2FpbnN0DQo+IFZTQ1NJSUZfTUFYX1JFUVMgYmVmb3JlIHVzaW5nIGl0IHRvIGluZGV4IGlu
Zm8tPnNoYWRvd1tdLCBidXQgdGhlbg0KPiBkZXJlZmVyZW5jZXMgdGhlIGVudHJ5IHRvIHRl
c3QgLT5pbmZsaWdodCB3aXRob3V0IGNoZWNraW5nIHRoYXQgdGhlIHNsb3QNCj4gaXMgcG9w
dWxhdGVkLiAgU2hhZG93IHNsb3RzIGFyZSBOVUxMIGJlZm9yZSBhIGNvbW1hbmQgaXMgc3Vi
bWl0dGVkICh0aGUNCj4gaG9zdCBwcml2YXRlIGFyZWEgaXMgemVyb2VkIGF0IGFsbG9jYXRp
b24pIGFuZCBhcmUgcmVzZXQgdG8gTlVMTCBpbg0KPiBfc2NzaWZyb250X3B1dF9ycWlkKCkg
b25jZSBhIHJlcXVlc3QgY29tcGxldGVzLCBzbyBhbiBpbi1yYW5nZSBycWlkIHRoYXQNCj4g
ZG9lcyBub3QgY29ycmVzcG9uZCB0byBhbiBvdXRzdGFuZGluZyByZXF1ZXN0IG1ha2VzIHRo
ZSBmcm9udGVuZA0KPiBkZXJlZmVyZW5jZSBhIE5VTEwgcG9pbnRlci4NCj4gDQo+IEEgbWFs
aWNpb3VzIG9yIGJ1Z2d5IGJhY2tlbmQgY2FuIHRodXMgY3Jhc2ggdGhlIGd1ZXN0IGJ5IHJl
dHVybmluZyBhDQo+IHJlc3BvbnNlIHdob3NlIHJxaWQgaXMgaW4gcmFuZ2UgYnV0IG5vdCBp
biBmbGlnaHQgLS0gZm9yIGV4YW1wbGUgYQ0KPiBzcHVyaW91cyByZXNwb25zZSBiZWZvcmUg
YW55IGNvbW1hbmQgaGFzIGJlZW4gaXNzdWVkLCBvciBhIGR1cGxpY2F0ZSBvZg0KPiBvbmUg
YWxyZWFkeSBjb21wbGV0ZWQuICBUaGUgcmluZyBoYXMgb25seSBWU0NTSUlGX01BWF9SRVFT
ICgxNikgc2xvdHMsIHNvDQo+IGJlZm9yZSB0aGUgZmlyc3QgY29tbWFuZCBldmVyeSBpbi1y
YW5nZSBycWlkIHNlbGVjdHMgYSBOVUxMIHNsb3QuDQo+IA0KPiBSZWplY3QgYSByZXNwb25z
ZSB3aG9zZSBzaGFkb3cgc2xvdCBpcyBub3QgcG9wdWxhdGVkLg0KPiANCj4gRml4ZXM6IDZk
MWMyZjQ4ZjNmYyAoInhlbi9zY3NpZnJvbnQ6IGhhcmRlbiBkcml2ZXIgYWdhaW5zdCBtYWxp
Y2lvdXMgYmFja2VuZCIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25l
ZC1vZmYtYnk6IFllaHllb25nIExlZSA8eWhsZWVAaXNzbGFiLmtvcmVhLmFjLmtyPg0KDQpS
ZXZpZXdlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJn
ZW4NCg==
--------------HscB0pQhO6alWtKX55NS0MMB
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------HscB0pQhO6alWtKX55NS0MMB--

--------------0I6v6BijZSEvEjvGrfeccWKG--

--------------nnH7S5YuLqUH0yIqtmqXntAT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmrE/fYFAwAAAAAACgkQsN6d1ii/Ey8M
DQgAn67Our2fo1bMCOV5O+3w37AmRu4L3TTxvToURAAHydJz7TJ3hqBD5FlZhLmX6LdxqaLWYwMO
MS3mwgAUtulFRhkwVDuMs63dXLlRNgw0m9426pAPQ3lMva/tjoFsdST2KP0LXwIFspRvsX4dCVHy
DlCGLpEeC40ybm7reCHJJBQshsVra+9Jxyer73TGy0vJgVs6qnrjQ1VnzbufezWmAK3Ovzy3Tj3v
egMCT2rqTVWsBqXH+2GdbtR+XttYuxwnsYTnDSw5XMMAKECUC9ULqx+K3/Gexxl0lZFNCp9gG8vu
xUl/Xqi6SXmtsnr03S4XoWbeHAnhlFgFiBiPkKcNlg==
=UJPI
-----END PGP SIGNATURE-----

--------------nnH7S5YuLqUH0yIqtmqXntAT--
