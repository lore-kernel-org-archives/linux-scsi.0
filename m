Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66663288A2;
	Tue, 20 May 2025 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747756918; cv=none; b=MvX61gGwOJMEGfn+8/pkjnWJhP6F3BALFyt+zo6kO4PekvixvXHsGBotyqUhrIV67DR+dT3kwiZPDk6q9EQeMEPtEzqyB8ag/qfTh+kp9hNrdOPGzZYNqQ7r2Giyy7dxl9lLdviLz3v6ZSQvolxPRSAEyJQiSjV1fwkWxQvQefI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747756918; c=relaxed/simple;
	bh=NLHQu01znICve73PRKiUqGXlEoXbgUBhtxBnnuUPUyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OQ7BIepi3NewaVZer9ijAZsMexvSdCQ4aPPv+SSLWFA5zU8GVt+mGoQG39D4QdPnY3LG9O39hspeov8ncGp8mxKcbzzDxoFHOahbveh1GUAnObfcjowKIoTaqgiXrsq6EIhotlOlJbaxUwVkafOYfBkjNIIg81vchrA9Ky8Hifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFOPh8+4; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFOPh8+4"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5f3f04b5dbcso8312168a12.1;
        Tue, 20 May 2025 09:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747756915; x=1748361715; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NLHQu01znICve73PRKiUqGXlEoXbgUBhtxBnnuUPUyM=;
        b=UFOPh8+4PsYKS1VT5Ye+pBUtIfcH4QTl8NGvhBIUUyHCnsiEZb2FJlg6sCbTljG8Oi
         RWsHPNbBBVuItqTXW82P1TfiXaGspLPcxOit9uA0pj5UWgtZr9/n/hHi68M7it03aZ15
         Wj3hWQJ4w1KxjCSl1HJ6cEg1jA4s160NtL55iq9eFwhI5BhwEd6SisVSChYwizpeMUEO
         ljo+/rEK39givfZmR1sQ7uDxNoR1+WDKxR8E6Nn83POB/wbCSkuVMLcgaG2DtuZrhANu
         bTIZBLuSa2q+z69e2A3iiC385MDaL0EqTfQ1uIE/6iFttw1BG8fEKzqHfxpZCicoT1sZ
         3nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747756915; x=1748361715;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NLHQu01znICve73PRKiUqGXlEoXbgUBhtxBnnuUPUyM=;
        b=rUJC/MCy8INS+29ZGpOnmPRoURsoBTGbIugIRgEjy+bhi2iC5F1jggPsXAxfqaxMwK
         gZ/WgGAt86E522Aclap/BmJUvs/ApbyXOMITXHne5ef0G0SzZvoYTNlXcSYdS5DjyG7Q
         2wR9KYJOP3CSSPW5Y8sJ7BQiSyfEXz3WucKlN/O3F/Wvo062oTlx5qg2NmwjJMeWPDiO
         7oh0Tj22FbmL+DlESCzOCGxb3srfLV2cNT78jLa58O3etQVHospglmcNLLWfYDyaY95H
         KD+EILaB52SHYY2l66kfE3VDX+s47uzE9NTz8TQkfzvMx9F9K65+ygFLvQvTAW5qmvtu
         FhqA==
X-Forwarded-Encrypted: i=1; AJvYcCV/7UYCz+s1zFdmYRhAUqDu0tUASrQ7df36+RvRM9xAyTqX/Sjb3FHS5G63YXc5FO46mq8+ddf5ipCAuK0=@vger.kernel.org, AJvYcCXmfLWFw4JPgDaMaXmbFxFqHHCXJMGUWZgWItNud9zIV2z7nuiO0QBDRDPsPT8me+QYaj4APoVdJ1AtBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbLFRo124KZrF+ssXbXQt14uKYIPuYnDxDl1zghgFbz32Ay2XY
	nEFlAqU8QkH8z0Fu+9MDGdvBbP046+9fTPKv8l1USsHc6EOm70uGOfEh
X-Gm-Gg: ASbGncsUCrdm4hywVSYe41ByLN6UCjznrprCqgAhOEcoyWmfUVTCTjPualrVFwfWdqN
	z0Sea/V3vaT/I9QXBXaKa/0EoV6a4lhMxEkDYhmxJKv8rz1g2KL5BQDT3TUU1e+jPxj6leYd42a
	fYw5CATjVvylKXR/EKBLxB/95/AkSygI2fbyRQ+UBLJFpt/Z6WeJ8PjWv0WEXEbGIGTCxeVlcRW
	8pcEmYjmMZ5eQ02XGWC0YHKkb4j30vI8+bmt4dP/ndyxLzbrtG3nQ15R09rYOusT2wPSjDfAAtK
	CSwB9LAML+QN0perTOhCtx2bCpgpKmdk9r995ubRfSW14xUXqpRKXQ==
X-Google-Smtp-Source: AGHT+IHyQCwN+N8keILzdY8urJ4nceUZZMCFLVcZ2JJ//X1ZPm39zCCDWnYiM9DBHR4AHkitjLt/Mg==
X-Received: by 2002:a17:907:db02:b0:ad5:27b6:7fd1 with SMTP id a640c23a62f3a-ad52d48da04mr1704960866b.17.1747756914001;
        Tue, 20 May 2025 09:01:54 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4ca654sm740504266b.158.2025.05.20.09.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 09:01:52 -0700 (PDT)
Message-ID: <32c36b58dcdbb09403fa9dccff28b6bee76882e0.camel@gmail.com>
Subject: Re: [PATCH v5] ufs: core: Add HID support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com,  bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 matthias.bgg@gmail.com,  angelogioacchino.delregno@collabora.com,
 peter.wang@mediatek.com,  manivannan.sadhasivam@linaro.org,
 quic_nguyenb@quicinc.com, luhongfei@vivo.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>
Date: Tue, 20 May 2025 18:01:50 +0200
In-Reply-To: <20250520094054.313-1-tanghuan@vivo.com>
References: <20250520094054.313-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDE3OjQwICswODAwLCBIdWFuIFRhbmcgd3JvdGU6Cj4gQEAg
LTg3LDYgKzg3LDI2IEBAIHN0YXRpYyBjb25zdCBjaGFyICp1ZnNfd2JfcmVzaXplX3N0YXR1c190
b19zdHJpbmcoZW51bSB3Yl9yZXNpemVfc3RhdHVzIHN0YXR1cykKPiDCoMKgwqDCoMKgwqDCoMKg
fQo+IMKgfQo+IMKgCj4gK3N0YXRpYyBjb25zdCBjaGFyICp1ZnNfaGlkX3N0YXRlX3RvX3N0cmlu
ZyhlbnVtIHVmc19oaWRfc3RhdGUgc3RhdGUpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBzd2l0Y2gg
KHN0YXRlKSB7Cj4gK8KgwqDCoMKgwqDCoMKgY2FzZSBISURfSURMRToKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJpZGxlIjsKPiArwqDCoMKgwqDCoMKgwqBjYXNlIEFO
QUxZU0lTX0lOX1BST0dSRVNTOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gImFuYWx5c2lzX2luX3Byb2dyZXNzIjsKPiArwqDCoMKgwqDCoMKgwqBjYXNlIERFRlJBR19S
RVFVSVJFRDoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuICJkZWZyYWdf
cmVxdWlyZWQiOwo+ICvCoMKgwqDCoMKgwqDCoGNhc2UgREVGUkFHX0lOX1BST0dSRVNTOgo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gImRlZnJhZ19pbl9wcm9ncmVzcyI7
Cj4gK8KgwqDCoMKgwqDCoMKgY2FzZSBERUZSQUdfQ09NUExFVEVEOgo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gImRlZnJhZ19jb21wbGV0ZWQiOwo+ICvCoMKgwqDCoMKg
wqDCoGNhc2UgREVGUkFHX05PVF9SRVFVSVJFRDoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuICJkZWZyYWdfbm90X3JlcXVpcmVkIjsKPiArwqDCoMKgwqDCoMKgwqBkZWZh
dWx0Ogo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gInVua25vd24iOwo+
ICvCoMKgwqDCoMKgwqDCoH0KPiArfQoKVGhlIGVudW0gdWZzX2hpZF9zdGF0ZSB2YWx1ZXMgYXJl
IGNvbnRpZ3VvdXMgYW5kIHN0YXJ0IGZyb20gMCwgbWF5YmUgY2hhbmdlIHN3aXRjaC1zdGF0ZSB0
byA6CgojZGVmaW5lIE5VTV9VRlNfSElEX1NUQVRFUyA2CnN0YXRpYyBjb25zdCBjaGFyICp1ZnNf
aGlkX3N0YXRlc1tOVU1fVUZTX0hJRF9TVEFURVNdID0gewogICAgImlkbGUiLAogICAgImFuYWx5
c2lzX2luX3Byb2dyZXNzIiwKICAgICJkZWZyYWdfcmVxdWlyZWQiLAogICAgImRlZnJhZ19pbl9w
cm9ncmVzcyIsCiAgICAiZGVmcmFnX2NvbXBsZXRlZCIsCiAgICAiZGVmcmFnX25vdF9yZXF1aXJl
ZCIKfTsKCnN0YXRpYyBjb25zdCBjaGFyICp1ZnNfaGlkX3N0YXRlX3RvX3N0cmluZyhlbnVtIHVm
c19oaWRfc3RhdGUgc3RhdGUpIHsKICAgIGlmICgodW5zaWduZWQgaW50KXN0YXRlIDwgTlVNX1VG
U19ISURfU1RBVEVTKQogICAgICAgIHJldHVybiB1ZnNfaGlkX3N0YXRlc1tzdGF0ZV07CiAgICBy
ZXR1cm4gInVua25vd24iOwp9Cgo=

