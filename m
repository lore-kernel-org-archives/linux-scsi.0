Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41F93451D7
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705626; cv=none; b=XDsHEabKb5Ti06WzekqLGCBWgzovECIiqCEEav73g5ClMAWWh7PCXjJ2rB7nf+0FvnbepUhkdvGfTwtVj5ybHNuVwyo4FlL0EWqanZ2ZmlW2DuqESX7kNZOaYD5eed8dxjdYMGP+gTXGhwVqT1jGcI1PHV2iQHT/78gLmvEOYAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705626; c=relaxed/simple;
	bh=o6HUZ0vsKlr36JUVf55MpSe40f88GtRTuipwm+8RSPA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HmG/AHFuqCUWeAR9xpoLs+8PNd2y3LuDzJwKlO4w46oOHFF4RhojTSr+OJo1sply0pZ0BgEUITXOMsB2jE69ly9s1L1c8klqbBhSh7Q4TfsF4+NRZ1a75ZyBzIApnwYmxlL7SuTphDrR5ycfSYgVJKt5xYpJldzx9DNUb/K1rcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSfbmvwD; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSfbmvwD"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so3499906a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 08:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769705623; x=1770310423; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o6HUZ0vsKlr36JUVf55MpSe40f88GtRTuipwm+8RSPA=;
        b=GSfbmvwD2CbDBTLqQG48yWYZT/CZe1TJOEU37E2zwn4uDTKIi9VnIj3cBwcGLkWk9c
         9rekFho/oIkGP7rV88bdh69fDZeabgNCtR5H81jkzTqL1UFDg1aI1IdMFaOyuXLQlMgA
         DQCte+9Xfrv0hbdSlnNLaXophV3IGsrMzNDMvuFQhx5jebHjjwMjalIkxc1UrJ8to+9/
         9qXLd3XK+77D/jRmwRS9LRkDx47HvKDMpx4rJeblA9U3tKD1GXdDoKDf7XWhuEKQGFOb
         +DyzGL3oFwk7YLPKkN2ZP4PsZK0zG7kVtHZKYmHl+l06l1WAELtvykCTLCg84hy1GESI
         mUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769705623; x=1770310423;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o6HUZ0vsKlr36JUVf55MpSe40f88GtRTuipwm+8RSPA=;
        b=KCZMuaXxxxX1yEqdHD0sy+mvAz+NEGaJ/c3jln0akRfpIfZuJG85iEXmmx9QCeNj8V
         FWL65fUZ96Cb+OBTEP/phpx0Jm/iMVgyWT0rozNQi1oqANV8BhqMFp+P1gdpURUN16gS
         kQ7b58PDfLGKjB0ISSs3ocX/Ps0RpvWeBoQFaNPW1AW/Mu4a2zXmYhl+tAbGZnFVS13e
         A3u10jcLM8IhqW5j17S10BtevRyjHZANVOypKU1fBNeiBJTg9VhPNVas/NpUOa51wbIf
         1P0vM27n9/juEgW7XjnA7etbS4SinuMkQo7bmpNis4lAFUbie5C4snTXYQnEhQ+mO6fW
         hx6A==
X-Gm-Message-State: AOJu0Yw0DzsVSBQeRzVZLjeTXDxoCe97IuiAYDl6a58nAyYPbrp4zRoh
	Vm/YGipGmt4RXvCoo1ucVum+T0Y0FFk05DAvbA6ojX8HqttzAh05kPS8
X-Gm-Gg: AZuq6aLXFEegjwvoifOj7UTYfcl443ghSXbahK3sf/M0lKJgQI+FU4fuMX75cYMlh2p
	SsmJg0TXfM9VVZMSy5lJf+ZNRTkkeO6s0zkwz2RGk74WtX3A72YI7dbWdCj+ubIkADU3jBQSAKG
	QG14b0AOtO0WMGt8HoAu7R7MHE/+ID8q54jdynOfsBsYu/zCfErv9OuMjG/nuYpPtwd/mlaX0Ia
	VfbSJSLzmFBbB005brls6lzWH76IHgFt4QC0JzLO8rwA+2aLLnyEy6Kd99uRzBrroIlQVJOHUUE
	3wvDU2zc91bEElCsOI+KE9N0l6+tqdL6WuswhuSGUAt+2BJSBdfmVbKZktg0UyPIzrg3j2c5Qj3
	6KcPrgawqDoLPAydq8DV4agi/OyjmRs44ufgc8w5pg+oMBY2kdYtSlfMXdXZcVqHy+XQoeGSGa5
	PQKrugr2+DCNBaYw==
X-Received: by 2002:a17:907:da2:b0:b84:3fab:4251 with SMTP id a640c23a62f3a-b8ddf86f5f8mr262260266b.15.1769705622989;
        Thu, 29 Jan 2026 08:53:42 -0800 (PST)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2ed6f8sm280177966b.65.2026.01.29.08.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 08:53:42 -0800 (PST)
Message-ID: <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS
 2.2
From: Bean Huo <huobean@gmail.com>
To: Alexey Charkov <alchark@flipper.net>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche <bvanassche@acm.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, Can Guo
 <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Thu, 29 Jan 2026 17:53:41 +0100
In-Reply-To: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDExOjM4ICswNDAwLCBBbGV4ZXkgQ2hhcmtvdiB3cm90ZToK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhiYS0+ZGV2
X2luZm8ucnBtYl9yZWdpb25fc2l6ZVswXSA9Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ2V0X3VuYWxpZ25lZF9iZTY0KGRl
c2NfYnVmCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCsKPiBSUE1CX1VOSVRfREVTQ19QQVJBTV9M
T0dJQ0FMX0JMS19DT1VOVCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA8PAo+IGRlc2NfYnVmW1JQTUJfVU5JVF9ERVNDX1BB
UkFNX0xPR0lDQUxfQkxLX1NJWkVdCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPj4gMTc7IC8qIGNvbnZlcnQgdG8gMTI4IGtC
eXRlcyB1bml0cyAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDCoMKg
wqDCoMKgwqDCoH0KCkhpIEFsZXhleSwgCgp0aGFua3MgZm9yIHlvdXIgZml4LCBJIGRpZG4ndCBu
b3RpY2UgdGhlcmUgaXMgVUZTIDIueCBvbiB0aGUgbWFya2V0IHdoaWNoIHdpbGwKdXNlIFVGUyBP
UC1URUUgUlBNQiBmcmFtZXdvcmsuCgoKaGVyZSBpcyBwb3RlbnRpYWwgdTggT3ZlcmZsb3csIHNp
bmNlIGZvciB0aGUgVUZTMy54KywgaXQgaXMgdTggaW4gdW5pdApkZXNjcmlwdG9yLCBidXQgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCgpUaGUg
Y2FsY3VsYXRpb24gY2FuIG92ZXJmbG93IGZvciBsYXJnZXIgUlBNQiByZWdpb25zICg+MzJNQik6
ICAgICAgICAgICAgICAgICAgCiAgLSBBIHU4IGNhbiBvbmx5IHJlcHJlc2VudCB1cCB0byAyNTUg
w5cgMTI4S0IgPSB+MzJNQiAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgLSBUaGUgc2hpZnQg
cmVzdWx0IGlzIGFzc2lnbmVkIGRpcmVjdGx5IHdpdGhvdXQgYm91bmRzIGNoZWNraW5nCgoKS2lu
ZCByZWdhcmRzLApCZWFuICAgICAgICAgICAgICAgICAK

