Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6681B3925;
	Tue, 29 Jul 2025 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753818587; cv=none; b=jLgINZG49z0OFeBapws7KfQUowlrwJ9XouMSf1U+/tJ9XA5W2cvohsuOT5KkTg50jlKfJvj1stlYFzCa6PehOlLzjpBBbSuw3sJ2uhpPd43weLkr9o0L2gGTqaqBQ/e0Ks/EwNgBUXaGcSSni2Eu5g1bisSlXSv3vbO2Xy5rPEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753818587; c=relaxed/simple;
	bh=H+dbHDPIf2KcliiSjv9Kdbk9W7jeZvpyIRsXOLZIJUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAZo9qPozbkVxCfFNO6IOEpXPuLtcTCsmVY7hDNYVxaYe+cco1d0XgXMDOAztfhNftJ8MYzRJNJ/z9aiTyvYMZ4g5v7g82CCdQDccH+BWYZYOwwHcI71apVzJjOepHcZMuZhtuikp/Ps91fzfdkQojbDcffqs8qXC1hke3xwI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpyg8GGC; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpyg8GGC"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b7746135acso3012693f8f.2;
        Tue, 29 Jul 2025 12:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753818584; x=1754423384; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H+dbHDPIf2KcliiSjv9Kdbk9W7jeZvpyIRsXOLZIJUg=;
        b=mpyg8GGCkLrKyjDBYaJ0eyB4dDf4TcOa71gLnCIUrFiH79LNAPaEFIpX0KeL5w3yU/
         plZghxhS530DUeoVA8E4ctGdysg3pvSlT61Wazcn1G8V1ErzVdmmI9s8j2KRbpdtiAPy
         +ToMK4zUmf0ho5PPZLnvNiXNN8N35C68DBc/3QlFcE+IHHvS849xXc1A25O3l4P474vk
         +yf1EGPG4LHEJMLtDTdnnYrA3bHGJfrTMTMGN3N+CxWWhF60utJKaYkZ1WEzMhMZY/cN
         VAeU+sYsKexgE3TtELT7mTDYaNa/ZfqkBUCT06Jl7oETTlHXXZd6R2kVDTc2LOr0+Zwu
         zjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753818584; x=1754423384;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H+dbHDPIf2KcliiSjv9Kdbk9W7jeZvpyIRsXOLZIJUg=;
        b=Y0KZ9SSrFPWk52SFTxbPZVHamCsWTemwm96OkacwCmEtlfCB/f2PvNJ/P5sT6XCq3+
         5jzyEko12xY9LZNEhheZkqvApYo0OOgG9opvOrDr3VKdnSpFE+olC60v3WTXNImDfdwK
         F1NrSdLbHvwIhXWteKw01AsiKd4rA09tAb7P022mL2e4tByBgKok4Y5QU1e19hMUjUMw
         iKTILYdQHlBylSN8hULg36ruX4rCa0ZAj9IoNVGQfKRkA6IfWEIyxKDGSDROrOGVY9YQ
         38dGFzevmhUM+hHrZ4WoeSDriRjN40Rej+RxwykWuPn6f15kv5fSDw9K6P4Rr2SZvaJU
         HKRw==
X-Forwarded-Encrypted: i=1; AJvYcCU1bLXhhUaPO9xXkKc5gGQrUTadYPh1obZgxel2VwAnqH9ViXhgi1l2bfJagAKspWZ1llC2HeROYyZzyw==@vger.kernel.org, AJvYcCUySUvHU9I5pW/jyBrKpVCmgi+bi7LkPec/Q0MUF82hHkdl9VKqmD9tKJ/LjwX1R/zMx6zuDrTVDp06o4M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/qcSwvx3mA8Kx4DRVeCyYI2CPLvEBryhEjUgvvUqCiS6vGIk2
	rZGmSwiDpip02k38gRIKT9OHOVcCw4ssWrNYZQsxLjvlqxvF7bnMSefq
X-Gm-Gg: ASbGncuO9bPnQx483u8ufFhA2XlI+Phmo0N2ed0LeEBdDJOVufO+x2aYGKFU8/Rz4CF
	B1iFC/kTg5Vykx2pzkvesSHPGUlu8aSBD3gBUxjKIoi3/RAbiIPd4aR1lAGrFzPcapXHQzlON+l
	RY7CjtIUiFRfT46c3roBBifrbDuM2VMyY6zNM+0VyFzs8gZg9QFM3xcJB0OzIFPyZs40GV1J0Kk
	rIpo2O7MdiSZqa6kZpp5lI/PEYqWRj453a/URztqZFnde4dDjYoh19aSrCLlV9HqarwoWR9sZA/
	HGatLoUn9jblZaHDOCzw7Mclev4N5WfXRnj8S2CVFeWHAb7fKOpoMAMSZjdFXIw3Gzx10gr5nTg
	oOjdZuyQqYboK17ex2qWUJo83AZl5
X-Google-Smtp-Source: AGHT+IFEGUmolEghmkJCvpJKOH02h0kF70Sd7xkB7lrvd3yNTAu1jOtRldmwy+N6MWom8zCNOPWT7w==
X-Received: by 2002:a5d:5f44:0:b0:3a8:38b4:1d55 with SMTP id ffacd0b85a97d-3b794ff1718mr689807f8f.28.1753818583346;
        Tue, 29 Jul 2025 12:49:43 -0700 (PDT)
Received: from [192.168.1.201] ([87.254.0.133])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b782b2bca5sm10945038f8f.70.2025.07.29.12.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 12:49:42 -0700 (PDT)
Message-ID: <64ec6c5e-5eb3-4db8-9540-7679ac694c11@gmail.com>
Date: Tue, 29 Jul 2025 20:49:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static
 const
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
 <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>
Content-Language: en-US
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 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
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
In-Reply-To: <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lhYBXaDOQHKMbUOSf5L0iOV3"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lhYBXaDOQHKMbUOSf5L0iOV3
Content-Type: multipart/mixed; boundary="------------3jEM91eYIyqgzD0eTtM6gp2j";
 protected-headers="v1"
From: "Colin King (gmail)" <colin.i.king@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <64ec6c5e-5eb3-4db8-9540-7679ac694c11@gmail.com>
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static
 const
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
 <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>
In-Reply-To: <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>

--------------3jEM91eYIyqgzD0eTtM6gp2j
Content-Type: multipart/mixed; boundary="------------yAZnIaS17TGrm9EZIQVN0jVW"

--------------yAZnIaS17TGrm9EZIQVN0jVW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjkvMDcvMjAyNSAxODo0NSwgQ2hyaXN0b3BoZSBKQUlMTEVUIHdyb3RlOg0KPiBMZSAy
OS8wNy8yMDI1IMOgIDA4OjQ5LCBDb2xpbiBJYW4gS2luZyBhIMOpY3JpdMKgOg0KPj4gRG9u
J3QgcG9wdWxhdGUgdGhlIHJlYWQtb25seSBhcnJheXMgb24gdGhlIHN0YWNrIGF0IHJ1biB0
aW1lLCBpbnN0ZWFkDQo+PiBtYWtlIHRoZW0gc3RhdGljIGNvbnN0LiBBbHNvIHJlZHVjZXMg
b3ZlcmFsbCBzaXplLg0KPj4NCj4+IGJlZm9yZToNCj4+IMKgwqDCoCB0ZXh0wqDCoMKgwqDC
oMKgIGRhdGHCoMKgwqDCoMKgwqDCoCBic3PCoMKgwqDCoMKgwqDCoCBkZWPCoMKgwqDCoMKg
wqDCoCBoZXjCoMKgwqAgZmlsZW5hbWUNCj4+IMKgIDM2NzQzOcKgwqDCoMKgwqAgODk1ODLC
oMKgwqDCoMKgwqAgNTk1MsKgwqDCoMKgIDQ2Mjk3M8KgwqDCoMKgwqAgNzEwN2TCoMKgwqAg
ZHJpdmVycy9zY3NpLyANCj4+IHNjc2lfZGVidWcubw0KPj4NCj4+IGFmdGVyOg0KPj4gwqDC
oMKgIHRleHTCoMKgwqDCoMKgwqAgZGF0YcKgwqDCoMKgwqDCoMKgIGJzc8KgwqDCoMKgwqDC
oMKgIGRlY8KgwqDCoMKgwqDCoMKgIGhleMKgwqDCoCBmaWxlbmFtZQ0KPj4gwqAgMzY1ODQ3
wqDCoMKgwqDCoCA5MDcwMsKgwqDCoMKgwqDCoCA1OTUywqDCoMKgwqAgNDYyNTAxwqDCoMKg
wqDCoCA3MGVhNcKgwqDCoCBkcml2ZXJzL3Njc2kvIA0KPj4gc2NzaV9kZWJ1Zy5vDQo+IA0K
PiBIaSwNCj4gDQo+IG91dCBvZiBjdXJpb3NpdHksIGFueSBpZGVhIHdoeSAnZGF0YScgaW5j
cmVhc2U/DQoNCkJlY2F1c2UgdGhlIGFycmF5cyBhcmUgYmVpbmcgc3RvcmVkIGluIHRoZSBk
YXRhIHNlY3Rpb24gcmF0aGVyIHRoYW4gb24gDQp0aGUgc3RhY2suDQoNCj4gDQo+IEFsbCBt
eSBjb25zdGlmaWNhdGlvbiBwYXRjaGVzIGxlYWQgdG8gZGF0YSByZWR1Y3Rpb24uDQo+IA0K
Pj4NCj4+IChnY2MgMTQuMi4wLCB4ODYtNjQpDQo+IA0KPiAoc2FtZSBraW5kIG9mIGJlaGF2
aW9yIHdpdGggMTUuMS4xKQ0KPiANCj4gDQo+IENKDQoNCg==
--------------yAZnIaS17TGrm9EZIQVN0jVW
Content-Type: application/pgp-keys; name="OpenPGP_0x68C287DFC6A80226.asc"
Content-Disposition: attachment; filename="OpenPGP_0x68C287DFC6A80226.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazc
ICSjX06efanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZO
xbBCTvTitYOy3bjs+LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2N
oaSEC8Ae8LSSyCMecd22d9PnLR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyB
P9GP65oPev39SmfAx9R92SYJygCy0pPvBMWKvEZS/7bpetPNx6l2xu9UvwoeEbpz
UvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3otydNTWkP6Wh3Q85m+AlifgKZud
jZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2muj83IeFQ1FZ65QAi
CdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08yLGPLTf5w
yAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaBy
VUv/NsyJFQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQAB
zSdDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEI
ADsCGwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoff
xqgCJgUCY8GcawIZAQAKCRBowoffxqgCJtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp
+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02v85C6mNv8BDTKev6Qcq3BYw0
iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GOMdMc1uRUGTxTgTFA
AsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oho7kgj6rK
p/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8npp
GVEcuvrbH3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xt
KHvcHRT7Uxaa+SDwUDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7i
CLQHaryu6FO6DNDv09RbPBjIiC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9D
DV6jPmfR96FydjxcmI1cgZVgPomSxv2JB1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ
6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8ehRIcVSXDRcMFr3ZuqMTXcL6
8YbDmv5OGS95O1Gs4c0iQ29saW4gS2luZyA8Y29saW4ua2luZ0B1YnVudHUuY29t
PsLBdwQTAQgAIQUCTwq47wIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBo
woffxqgCJo1bD/4gPIQ0Muy5TGHqTQ/bSiQ9oWjS5rAQvsrsVwcm2Ka7Uo8LzG8e
grZrYieJxn3Qc22b98TiT6/5+sMa3XxhxBZ9FvALve175NPOz+2pQsAV88tR5NWk
5YSzhrpzi7+klkWEVAB71hKFZcT0qNlDSeg9NXfbXOyCVNPDJQJfrtOPEuutuRuU
hrXziaRchqmlhmszKZGHWybmPWnDQEAJdRs2Twwsi68WgScqapqd1vq2+5vWqzUT
JcoHrxVOnlBq0e0IlbrpkxnmxhfQ+tx/Sw9BP9RITgOEFh6tf7uwly6/aqNWMgFL
WACArNMMkWyOsFj8ouSMjk4lglT96ksVeCUfKqvCYRhMMUuXxAe+q/lxsXC+6qok
Jlcd25I5U+hZ52pz3A+0bDDgIDXKXn7VbKooJxTwN1x2g3nsOLffXn/sCsIoslO4
6nbr0rfGpi1YqeXcTdU2Cqlj2riBy9xNgCiCrqrGfX7VCdzVwpQHyNxBzzGG6JOm
9OJ2UlpgbbSh6/GJFReW+I62mzC5VaAoPgxmH38g0mA8MvRT7yVpLep331F3Inmq
4nkpRxLd39dgj6ejjkfMhWVpSEmCnQ/Tw81z/ZCWExFp6+3Q933hGSvifTecKQlO
x736wORwjjCYH/A3H7HK4/R9kKfL2xKzD+42ejmGqQjleTGUulue8JRtpM1AQ29s
aW4gSWFuIEtpbmcgKEludGVsIENvbGluIElhbiBLaW5nIGtleSkgPGNvbGluLmtp
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
=3DQKm6
-----END PGP PUBLIC KEY BLOCK-----

--------------yAZnIaS17TGrm9EZIQVN0jVW--

--------------3jEM91eYIyqgzD0eTtM6gp2j--

--------------lhYBXaDOQHKMbUOSf5L0iOV3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEcGLapPABucZhZwDPaMKH38aoAiYFAmiJJbMFAwAAAAAACgkQaMKH38aoAiYw
eRAAlNOjiMuNlmJnY38YpnfDHY4fadzdiY0jfLguuGzTFxOQ0eZLCaPNsm2MKNz9Jpwujn3ISlbv
1xhhSQHfh6ap75oKwNGciJF9f5sqT5aNMMOdj0vDD/9ARJkxbSTctLZRxYcIHVIfWXXQXdlk9FOw
91lVRTo1DtOgjfq1aYq/zPDUmPNYe9QPCeab92jrwpg0/H7ZBw+NMw4NwTdy+Vl9ERycl+6xDho9
7eC+bjDEPgzPnX66N69ZzdD3r3RPsqqdtIO9xZUpBADQ7fpmkXrQH5Y/v1/QQE3evFrI/RkunoVw
x5QCMVbVL36rnVJK/9Qf4PUTtA80YLnIAvK6ZCfLD/9uXi9c/nJCZxKm1aThLgIk55TFGjOTTmwO
o9lTXmU8pVzaQ8fHa75kTG3vT1SzzO4cb7wxysQtIYsVIV6ZECwaOqCmA7qr8imWdKcdXDuPSS8t
fAEYWAe0kwLBI/YvSXzTlwSZ162Uj5+KNT9gQb0UTIZ3VbkxhMcb7iHtz6xTZlHiXIV0SpwmFRxd
h7PmTL1wFNc3O3UWLeyNfdK/pS17HFpLpSpsMFGrlGxnh1iCrB4LYJMrsdyJjjY6TWRPQ0vSaVhb
LlkBwu7OYoc1U9HZh916SHFtidbErPM+v4LRy8lYUXEHcqyhYMD2QvO+uDairwuT/iW8spD+s5Rg
xNY=
=A7aF
-----END PGP SIGNATURE-----

--------------lhYBXaDOQHKMbUOSf5L0iOV3--
