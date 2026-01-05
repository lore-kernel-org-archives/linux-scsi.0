Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE305337BB2
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767616301; cv=none; b=KVIdn/umiZV4fdCsS16s2ht8Jv+MG4o6rwQIJVI6p9fXmyrgfRg3FNDQirALoedUn2LmyYyHqL2J94ck9MUFxrLSR+Ez3dOXVWs1GHbVcfftb7i4IqOtIJWUvrDhyN+hn+8U4PBSetSB5OlXWXAM8TtqUZIIV5Vs/EFE0uBI6Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767616301; c=relaxed/simple;
	bh=rGEEZ95V6+M/i1YF/1tZgxeKtoKHGflfCQr5UDqK1Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcXWXw+vg4wlRAH9azgfqEuqLH0b/8ovbNyOYnKfva6j+cLTpncsxl21g/orKRV2f4XdOoATwTbTBt904/heVwfleAbZiVsbET4DiD2PMq7L2vXfkesRpdCsfOTI5SCrqkNM+s36qZFpmG3OBWHCpooqu3oGHs+hruSOg2hRTYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bc2M7VaH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bc2M7VaH"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so70260115e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 04:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767616296; x=1768221096; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rGEEZ95V6+M/i1YF/1tZgxeKtoKHGflfCQr5UDqK1Uo=;
        b=Bc2M7VaHTeMf8wEQqn0C6EIevjCLKvAWWF2Y3TdYWfVtO+du3fUBFLs85l3a6cPojM
         et+IETR7XJ2Y/X2PYXHVp6SzFIV3VWGXpDYwcLLo+pBtzbMjOaGWI4Ffqqo+l67/3Xq7
         Q4x+cKNrZZlxfGOxEpWsK0dQEP6RbjgYGMqdBmLXM5kmInofmLuIxylfqeWybUlqL7pg
         yWEOU3q5j40hzETvf1YBRgnGbC5NdOZS3rlo0/XOauKU4RF8Q9YT9hUeUKkz5c1omfMS
         7NY1RAYCWa1qYyryKbXTuwBed6/7UNyH50F9oFCikU7TnJtY+wZXFMSKoqzvuFZIkhps
         hCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616296; x=1768221096;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGEEZ95V6+M/i1YF/1tZgxeKtoKHGflfCQr5UDqK1Uo=;
        b=OJBeDlyAbQ8ofu2CcslowpcJxeeLquMhRbciZvqLdffHr3RkJlE3lUGzDA99NVdERC
         8bIAvLY6Ej2C7gnM7sOrODeZMJhA3a7t0CVSVdXHe9M+8AdFmvedoe6RB5kZHLxKaMbq
         TjnA9KqdfAybYUkLHAmOGUDlUl7Klagq+DT35yX0QcwYQsPAzbm1qxaiF2UlZmlPRVgz
         HwDykmZjKoZBJ1cE4k16MqK4E8DV2Rdwr0B6NeOq2FV6wroVtvGThJdND47H2xlRhzwD
         lNU/ZL6m0XR652flGxSpNn0e0h0pcgYphKhfL6fGAgp3nKXz1IG4wy8XxAcJzTN20v7V
         JjJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU38Md9zjicyZRcXFiAjQuhRA0ZmyhCKrCFYrnAATREJyfCmYUFs4ypToXNsuHeEgqHOuX4xYp7jp4P@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5WWD28d5yZ7PfzvytYK/D2JC83trz5J8iqt/CiQmrC8XgDMbe
	TwPMSZhNwhInzYPxALoWFsgaj1sQmkuAPQj+e6J36engM87AJ18JxYm0JBabG7pfZj4=
X-Gm-Gg: AY/fxX48EMDrkBjiRua/g+iDNb7QpMsgJ7YIEMl5F1JC/igu4AFcWaKuX1YUDUvBdCA
	U4+wPv0QbVEkDLvkEH6BoiNj3mr/B99jYcjiKcU1BGGT1GvgQbxHB0zGf8klSXhnlccqF3N1QPd
	WmBa82IpZHv6gAyu/8//opkQQ9dQL2CWvK0ZXDSgy8RMXFt86O6KK+wc8KXFPwTIDTAiY77kWQP
	obUNC+1nHx89MyB2N14gXFcVJYYRkivD6q+IntI+sx4NsbiZP3UtUMD0suwe6qn1g/PrzB+WGhl
	KwuGtV8SIUjpaA9ZFkyWhf4sg77sqGRpuVrCCxjCU+XC19nE2atWUNIsX9CO68+j69ALT/2blcj
	BV+35Z0BCUZ0T7JEP7wychpI5+ko5QHGH7FeWU6+vyg3Edky4lAJDNC3A0z+iaeBmBKaMfsh1P7
	M/rWlgv9sQRTegzDNUShnxZk7jjOoz5N2VUCj8QmflLVZ5FktKyC+Mgi+OeNb5Vfrw1TTPxN9M3
	HBVwCkTUNuF4AT63g6alfQm/aTujE5vUe8mhuU=
X-Google-Smtp-Source: AGHT+IHJDiGO8drg4ZYGBJATctq186ma6rRJXaQSAy6VxKSZoMpGLRpPMYzlryZa8WpSL6qb/H592g==
X-Received: by 2002:a05:600c:4447:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-47d194c6a2fmr565280845e9.0.1767616295958;
        Mon, 05 Jan 2026 04:31:35 -0800 (PST)
Received: from ?IPV6:2003:e5:8704:4800:66fd:131f:60bd:bc29? (p200300e58704480066fd131f60bdbc29.dip0.t-ipconnect.de. [2003:e5:8704:4800:66fd:131f:60bd:bc29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d1451f8sm154396385e9.5.2026.01.05.04.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 04:31:35 -0800 (PST)
Message-ID: <2cd0de6b-ebae-4542-ad84-a17ed9216d6b@suse.com>
Date: Mon, 5 Jan 2026 13:31:34 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xen/scsiback: fix potential memory leak in
 scsiback_remove()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
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
In-Reply-To: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BS4zf6rh8bgUAo5jqfw7uNk3"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BS4zf6rh8bgUAo5jqfw7uNk3
Content-Type: multipart/mixed; boundary="------------H7JcU5Hbi0Kcr1SADMo0ZUXx";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <2cd0de6b-ebae-4542-ad84-a17ed9216d6b@suse.com>
Subject: Re: [PATCH] xen/scsiback: fix potential memory leak in
 scsiback_remove()
References: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
In-Reply-To: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>

--------------H7JcU5Hbi0Kcr1SADMo0ZUXx
Content-Type: multipart/mixed; boundary="------------l5ApHduutsz64gc659VBCGlV"

--------------l5ApHduutsz64gc659VBCGlV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjMuMTIuMjUgMDc6MzAsIEFiZHVuIE5paGFhbCB3cm90ZToNCj4gTWVtb3J5IGFsbG9j
YXRlZCBmb3Igc3RydWN0IHZzY3NpYmxrX2luZm8gaW4gc2NzaWJhY2tfcHJvYmUoKSBpcyBu
b3QNCj4gZnJlZWQgaW4gc2NzaWJhY2tfcmVtb3ZlKCkgbGVhZGluZyB0byBwb3RlbnRpYWwg
bWVtb3J5IGxlYWtzIG9uIHJlbW92ZSwNCj4gYXMgd2VsbCBhcyBpbiB0aGUgc2NzaWJhY2tf
cHJvYmUoKSBlcnJvciBwYXRocy4gRml4IHRoYXQgYnkgZnJlZWluZyBpdA0KPiBpbiBzY3Np
YmFja19yZW1vdmUoKS4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IEZp
eGVzOiBkOWQ2NjBmNmU1NjIgKCJ4ZW4tc2NzaWJhY2s6IEFkZCBYZW4gUFYgU0NTSSBiYWNr
ZW5kIGRyaXZlciIpDQo+IFNpZ25lZC1vZmYtYnk6IEFiZHVuIE5paGFhbCA8bmloYWFsQGNz
ZS5paXRtLmFjLmluPg0KDQpSZXZpZXdlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==
--------------l5ApHduutsz64gc659VBCGlV
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------l5ApHduutsz64gc659VBCGlV--

--------------H7JcU5Hbi0Kcr1SADMo0ZUXx--

--------------BS4zf6rh8bgUAo5jqfw7uNk3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmlbrycFAwAAAAAACgkQsN6d1ii/Ey9H
DAgAhGPjvJZwV2cHYpUA7DWYbrEKPyZEXbXSobLe/5xeNkImsRKuAYOknAvdjKIS2SnjtIlTEDzh
ecl75SWRWKXWOQLa6Gy5QsUnS7urIsfrlfWo1kW1QGqR3xvwF6JBVeBwZeQBCvu7C8sj+yWaA717
ROCffzJ34eGVcZzDEiqrSEyqa4YF19m+cecLr25LXeGgT/8MK48JdilsG+zO8u7HbVfHurcXc4ci
lQ92gBM90GWxWOkAjKEAjp/RfYVYj+lFsnLw037dWKU9YhnrItnIASiD2DuPc3WM5F27KttqNZUQ
PzDwgd8FjoXeXh3HWg9pMJt1q5WFR/qxDlZyr5xr3g==
=3fbZ
-----END PGP SIGNATURE-----

--------------BS4zf6rh8bgUAo5jqfw7uNk3--
