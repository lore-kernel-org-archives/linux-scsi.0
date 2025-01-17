Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E901FE453
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737110831; cv=none; b=VVB6A7nmrTz7etTf3J2hG3gelUrYX4eLO4hsb7BJVuzIiZzkq3fbVWm1GdkOei5ze7vIDXsJh381ySdUZY/jOLw9QaTuYA67nfbdVL5Aa6AJkAp0tPo/a72IACLQfvYjdhjn3o+HESkYMCw72afOR39BMRTz6NtJi9FSHArGbTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737110831; c=relaxed/simple;
	bh=aAWmhIUeOOlZxwS8MPwtNkT56SWl4jfli2zZb6RZDQk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C4FpFYcF56i0o/7MRZO6Dg7mNG/+AXBuKIQLvcNC0G3osIwXvt7vsLWarjl7FNUPpKkalCBGcJyrJNs+eveSgcgNo1y1IhlH65vW1ITa3A/9u5D3x8dP6hNtMyzgu72Kvn9uOmxULyAdbY/kqHc8oe7XVDhkzp/ioWPEm/TGylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=frvuPMVU; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frvuPMVU"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so2951229a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 02:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737110828; x=1737715628; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAWmhIUeOOlZxwS8MPwtNkT56SWl4jfli2zZb6RZDQk=;
        b=frvuPMVUQr2WEm3A+HKRZPbiTYLDWarcGYodI2A5RgD8BrQr2ZDkcKdDLFHO2xgQFo
         k+KNmVp0PASfSy81p4q2cSS/JuQ28nzl5s2QkS4Hnd9QO0oqp+4isV/qip8DIXsJ1fV4
         6Bm+zfMvPLr1tY84bUxpE73wCf96/BLZ2nRVTxG+GM87dt2SDKoI9cKOhyaEPv2Jhj7v
         MiTcWAbJofPvxN0Iwp7BxsdFSF4WhoSwmP/1GL0t0PxHe0HHlr9BXuKGLNM6w+RsqV+O
         xdgMXORkHQjzkr1BLhkkNnyhwt5qUnljumirCKZ5iYWD+gN1D1HEYaTcHqNc8MoL6dlp
         eqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737110828; x=1737715628;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aAWmhIUeOOlZxwS8MPwtNkT56SWl4jfli2zZb6RZDQk=;
        b=KDDJjUOhYCWJkMPPBZboO50dxAk5Hv3DRaUXnKMLE2nwbqL5uXXUSy6rfgL5kVEO62
         uamGorK5NCLxLPSDJYTHL2ma1HzboFyXYL+axENRe64wV2h0o4b6Ly2WUpZTHDL79HOB
         iTNFpiBcyDQu22auodIkrf4sZNC+4JIBiw+pTqaSY8k7h1nNftWg5Y/7u/hLnZxmJtEn
         YlV5eiaLqVFnO7SH8jLj45hEwtWY7FhmHKwTJ2YdEwmXYtxBAqo2ecvxn1FM+2q1AIT9
         0hpnd+1zattvEtODNmrpOsoQJqx4Hl8GvLmsaidAbnSTjLsrQTbPanqGze/nzPzQdOOq
         seWA==
X-Forwarded-Encrypted: i=1; AJvYcCVRS+Q+0m4IiYzos3g69YNlJo1FMXddA50g3mR3mcGigIqz1+uDNuuurY0iZlZk4b4jEoMLaVrHZMfs@vger.kernel.org
X-Gm-Message-State: AOJu0Yyowhhdl813N+EhnjQaPgRc8qAmAmOYRHHPI2CsQi0JVTcJEpyN
	a13y+8TSPq2CxugnVGwpKygjwgNRlIkLxjZ6qL0iXHThX01rHmBV
X-Gm-Gg: ASbGncuK4abM2bv/Zz04/qtB3vA913XvmcyCd44F9w3q/eQdxvnduyJQHEJqq4bhT6a
	IFE0K0xUB4lPYP5EMIHS+wwlyZEwgPI7S/ZstIKIAfFqysJPLJQOvYeDNmlQOrVbZQA9u6JA/77
	aHT9EcFyg1XoBsLgMiqa2YX/+km0WfAvTjV0f395JQ3qeHbR1OPw7R6wdN8qFj2EcuevQKDhjGV
	9fbloUx8ngoCBZJ5HRaMlH/3w1t7wwZtib4L/txz+idc5dzaKOBg6iugWI=
X-Google-Smtp-Source: AGHT+IGC4HnkjIM8O2+eG0dEZgOvQbbnW+vmZw8/TCm4kxff/humFhkm73n2bGCfXDvcQ5ZsPDqw2Q==
X-Received: by 2002:a17:907:1c8b:b0:ab3:83c2:755a with SMTP id a640c23a62f3a-ab38b402651mr186153766b.49.1737110827793;
        Fri, 17 Jan 2025 02:47:07 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384d2d69fsm148475566b.79.2025.01.17.02.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 02:47:07 -0800 (PST)
Message-ID: <478fd574de9b6059061ea9112aea2c1542c61b59.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix error return with query response
From: Bean Huo <huobean@gmail.com>
To: Seunghui Lee <sh043.lee@samsung.com>, linux-scsi@vger.kernel.org
Date: Fri, 17 Jan 2025 11:47:06 +0100
In-Reply-To: <20250117071600.19369-1-sh043.lee@samsung.com>
References: 
	<CGME20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5@epcas1p4.samsung.com>
	 <20250117071600.19369-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTAxLTE3IGF0IDE2OjE2ICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6Cj4g
VGhlcmUgaXMgY3VycmVudGx5IG5vIG1lY2hhbmlzbSB0byByZXR1cm4gZXJyb3IgZnJvbSBxdWVy
eSByZXNwb25zZXMuCj4gUmV0dXJuIHRoZSBlcnJvciBhbmQgcHJpbnQgdGhlIGNvcnJlc3BvbmRp
bmcgZXJyb3IgbWVzc2FnZSB3aXRoIGl0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IFNldW5naHVpIExl
ZSA8c2gwNDMubGVlQHNhbXN1bmcuY29tPgo+IC0tLQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNo
Y2QuYyB8IDcgKysrKysrLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IGluZGV4IDljMjZlODc2NzUxNS4uNmIyN2VhMWE3
YTFiIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiArKysgYi9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4gQEAgLTMxMTgsOCArMzExOCwxMyBAQCB1ZnNoY2RfZGV2
X2NtZF9jb21wbGV0aW9uKHN0cnVjdCB1ZnNfaGJhICpoYmEsCj4gc3RydWN0IHVmc2hjZF9scmIg
KmxyYnApCj4gwqDCoMKgwqDCoMKgwqDCoGNhc2UgVVBJVV9UUkFOU0FDVElPTl9RVUVSWV9SU1A6
IHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU4IHJlc3BvbnNlID0gbHJicC0+
dWNkX3JzcF9wdHItPmhlYWRlci5yZXNwb25zZTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiAocmVzcG9uc2UgPT0gMCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKHJlc3BvbnNlID09IDApIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSB1ZnNoY2RfY29weV9xdWVyeV9yZXNwb25zZShoYmEs
IGxyYnApOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9IGVsc2Ugewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyID0gLUVJTlZBTDsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl9lcnIo
aGJhLT5kZXYsICIlczogdW5leHBlY3RlZCByZXNwb25zZQo+ICV4XG4iLAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBfX2Z1bmNfXywgcmVzcCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+IMKgwqDCoMKg
wqDCoMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDCoGNhc2UgVVBJVV9UUkFOU0FDVElPTl9SRUpFQ1Rf
VVBJVToKCgoKVGhlcmUgaXMgYSBjb25mdXNpbmcgbWl4IG9mIFVQSVUgdHJhbnNhY3Rpb24gY29k
ZSBhbmQgcmVzcG9uc2UgaW4gVVBJVQpoZXJlLCBJIHRoaW5rIHlvdSB3YW50IHRvIHByaW50ICJy
ZXNwb25zZSIgaW5zdGVhZCBvZiB0cmFuc2FjdGlvbiBjb2RlLgoKZGV2X2VycihoYmEtPmRldiwg
IiVzOiBVbmV4cGVjdGVkIHJlc3BvbnNlIGluIFF1ZXJ5IFJTUDogJXhcbiIsCl9fZnVuY19fLCBy
ZXNwb25zZSk7CgoKCg==

