Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68E26CE3C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753714146; cv=none; b=Wk8b/Zoll0QaHiCSdToPMSEfVeZyUjuxdQ7YD2VMbR3l+Q62sXSk6sIk1yfrKsVoX60/uf3qslUOsn9Wm9SumFJ6YLjuKumjfUQlBxH0J9h2hTA3CP/C4nsIuojBMu0oAwSmJ4CFtlVPsebO8RSD5ZP4R26PZ7P12XxCpksTOVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753714146; c=relaxed/simple;
	bh=oroXOouyEXMQYoTbrRLMPLPdWadAqBE7KEfDIgwRoe8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tOaf4syqPPWlI4l1H174KN+ay5bgAy8Y0OFAdX7VPiGHBfSZeBZBaaqr/Tn9cOrX/4SZVhlpEQD8XeW8MxE8F8tUhsxFpcUpvQW7ixFElX03AYgnqIuSMlX+6PHOhGV0BZ317WIGclNMKikPeGfV2KqGtSsxdqqWAv9ljLmm9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m6nSHzhN; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m6nSHzhN"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b77b8750acso1519474f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 07:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753714143; x=1754318943; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oroXOouyEXMQYoTbrRLMPLPdWadAqBE7KEfDIgwRoe8=;
        b=m6nSHzhN0xons/abHVvsThnODNbrB77ViaMLU3k/rBGbvZ5f+rabcf97RYElbAynVK
         ePw5OIPcEyg6QA4Vzpev7yoF00YsDPZlh63O7ikgUbb94hZBg/U021SqAFdtHlilC/pk
         15IhdWcn41IT8cPW+cPq6iA27x+BS/zjNvovS641yHB3lsMjnR0AWc9tDX+2TDx047DQ
         NLU6E6nEYGcKvUL8jHM4wCE48qtTt3qyDTpY7CJAxcxSQey6z6EAbfH2cGBIBnbAX8LS
         ySHqa38SCdn7G84LaxSwqNsqXboho64pER2LzDjRLC1m79k6FlYZ81KFO9ROA+sKLHIh
         vzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753714143; x=1754318943;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oroXOouyEXMQYoTbrRLMPLPdWadAqBE7KEfDIgwRoe8=;
        b=Mjc6bKwzbruwTm36Q24G1RPDBitixKXuRLCXsAkFylw3AXPQ7ddKei2eU21BoA7li+
         Zzq9pzuDAWLTMyDLzC7CmfSKdL3ibWYV8rFi7xbSB7rna6Zsw1S8RNwJw/R4DQ6g4urJ
         B+eaMkTD5Z3z3KMSQxnHbN9aang/T+q5xGrwWog19JNeyyIoN8wDOBfPjNTAbYcPR5Rr
         srWV5UkvxLkF+fomIH0+U8pLGLBxvpL+0JxeLVhUcKgpV4NgVlAXR+Hp7tpx5eIBfo7y
         Qzw+a9ZXX1y8Y3GqHFdIX+xwZqErNtZ9/7w/obM658UIH0rhwBC7/6sIJstHds7sD0Ci
         cY9g==
X-Forwarded-Encrypted: i=1; AJvYcCWzgfs463djUQsIsnCHOfvJZJv/UZkE+Zw8Km3pDslA/ymV1vXUiJQevawenZsj8eeLBz9UpYzuXUOb@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9hSQKg9gWTSUzsM58x6865KV9Gzrd+Bo3Fzj0JCA+ntG2d7JP
	DDCVYE1Z67FhmzS95/jCmImt2CeE4xeh0eZacJVS/Nvrw64uEnbdXc+vCTY7cYYs3yI=
X-Gm-Gg: ASbGncttdAgPLnE9gzJjAzwxSxkH4ROexRcQtpzdp2CgFBq0razhbg1oY7XSLJ6Ay4d
	gw3N9qvTrrgGpXSqK1Y86S8blEUTP5lB17aP1z8LSAfMIwRwxSAR2fSReICgm6tY3J7bUPw07TH
	JnErVMoFpg7ktIbjKfP2PtFo7p+wjscgpj7R3QIb4jnqjUNevj0rIgE6iilGaAt3uF6ZMnrhZ9S
	TvrVm+DeXMu+9dSR63XvgYEfVbAI48XQflosWu5XaNHJtoHAn4LzwZYBSjc2mc8wLwMhfgdLZh1
	CwUSUb93i9C1UETGOlVTCiadzdFscHIJ+0avRIX3Y5iRHV0lSovQB7twSXm1hVYQAU0CvBBHhAL
	IxNK7ourXfFBfTr8rFyc7GJO10A==
X-Google-Smtp-Source: AGHT+IHWf8xJO++7SQQNR7YMIGl99CTvsqEGJMidGEJBKdJCbzSX1/wzjH3YIznfuSenCXc4S09u0g==
X-Received: by 2002:a05:6000:230f:b0:3a4:f7ae:77c9 with SMTP id ffacd0b85a97d-3b7765e6271mr8343867f8f.5.1753714142772;
        Mon, 28 Jul 2025 07:49:02 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b78ba0b8e1sm1280683f8f.40.2025.07.28.07.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:49:02 -0700 (PDT)
Message-ID: <76af97e49cb7f36c8dc6edc62c84e72d6bb4669c.camel@linaro.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: move some irq handling back to
 hardirq (with time limit)
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Neil Armstrong <neil.armstrong@linaro.org>, Alim Akhtar	
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche	 <bvanassche@acm.org>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>
Cc: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam	 <mani@kernel.org>, kernel-team@android.com,
 linux-arm-msm@vger.kernel.org, 	linux-samsung-soc@vger.kernel.org,
 linux-scsi@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Mon, 28 Jul 2025 15:49:01 +0100
In-Reply-To: <a008c613-58d6-4368-ae2f-55db4ac82a02@linaro.org>
References: <20250725-ufshcd-hardirq-v2-0-884c11e0b0df@linaro.org>
	 <20250725-ufshcd-hardirq-v2-2-884c11e0b0df@linaro.org>
	 <a008c613-58d6-4368-ae2f-55db4ac82a02@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.56.1-1+build2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI1LTA3LTI4IGF0IDE2OjQzICswMjAwLCBOZWlsIEFybXN0cm9uZyB3cm90ZToK
PiBPbiAyNS8wNy8yMDI1IDE2OjE2LCBBbmRyw6kgRHJhc3ppayB3cm90ZToKPiA+IENvbW1pdCAz
YzdhYzQwZDczMjIgKCJzY3NpOiB1ZnM6IGNvcmU6IERlbGVnYXRlIHRoZSBpbnRlcnJ1cHQgc2Vy
dmljZQo+ID4gcm91dGluZSB0byBhIHRocmVhZGVkIElSUSBoYW5kbGVyIikgaW50cm9kdWNlZCBh
IG1hc3NpdmUgcGVyZm9ybWFuY2UKPiA+IGRyb3AgZm9yIHZhcmlvdXMgd29yayBsb2FkcyBvbiBV
RlNIQyB2ZXJzaW9ucyA8IDQgZHVlIHRvIHRoZSBleHRyYQo+ID4gbGF0ZW5jeSBpbnRyb2R1Y2Vk
IGJ5IG1vdmluZyBhbGwgb2YgdGhlIElSUSBoYW5kbGluZyBpbnRvIGEgdGhyZWFkZWQKPiA+IGhh
bmRsZXIuIFNlZSBiZWxvdyBmb3IgYSBzdW1tYXJ5Lgo+ID4gCj4gPiBUbyByZXNvbHZlIHRoaXMg
cGVyZm9ybWFuY2UgZHJvcCwgbW92ZSBJUlEgaGFuZGxpbmcgYmFjayBpbnRvIGhhcmRpcnEKPiA+
IGNvbnRleHQsIGJ1dCBhcHBseSBhIHRpbWUgbGltaXQgd2hpY2gsIG9uY2UgZXhwaXJlZCwgd2ls
bCBjYXVzZSB0aGUKPiA+IHJlbWFpbmRlciBvZiB0aGUgd29yayB0byBiZSBkZWZlcnJlZCB0byB0
aGUgdGhyZWFkZWQgaGFuZGxlci4KPiA+IAo+ID4gQWJvdmUgY29tbWl0IGlzIHRyeWluZyB0byBh
dm9pZCB1bmR1bHkgZGVsYXkgb2Ygb3RoZXIgc3Vic3lzdGVtCj4gPiBpbnRlcnJ1cHRzIHdoaWxl
IHRoZSBVRlMgZXZlbnRzIGFyZSBiZWluZyBoYW5kbGVkLiBCeSBsaW1pdGluZyB0aGUKPiA+IGFt
b3VudCBvZiB0aW1lIHNwZW50IGluIGhhcmRpcnEgY29udGV4dCwgd2UgY2FuIHN0aWxsIGVuc3Vy
ZSB0aGF0Lgo+ID4gCj4gPiBUaGUgdGltZSBsaW1pdCBpdHNlbGYgd2FzIGNob3NlbiBiZWNhdXNl
IEkgaGF2ZSBnZW5lcmFsbHkgc2Vlbgo+ID4gaW50ZXJydXB0IGhhbmRsaW5nIHRvIGhhdmUgYmVl
biBjb21wbGV0ZWQgd2l0aGluIDIwIHVzZWNzLCB3aXRoIHRoZQo+ID4gb2NjYXNpb25hbCBzcGlr
ZXMgb2YgYSBjb3VwbGUgMTAwIHVzZWNzLgo+ID4gCj4gPiBUaGlzIGNvbW1pdHMgYnJpbmdzIFVG
UyBwZXJmb3JtYW5jZSByb3VnaGx5IGJhY2sgdG8gb3JpZ2luYWwKPiA+IHBlcmZvcm1hbmNlLCBh
bmQgc2hvdWxkIHN0aWxsIGF2b2lkIG90aGVyIHN1YnN5c3RlbSdzIHN0YXJ2YXRpb24gdGhhbmtz
Cj4gPiB0byBkZWFsaW5nIHdpdGggdGhlc2Ugc3Bpa2VzLgo+ID4gCj4gPiBmaW8gcmVzdWx0cyBm
b3IgNGsgYmxvY2sgc2l6ZSBvbiBQaXhlbCA2LCBhbGwgdmFsdWVzIGJlaW5nIHRoZSBhdmVyYWdl
Cj4gPiBvZiA1IHJ1bnMgZWFjaDoKPiA+IMKgwqAgcmVhZCAvIDEgam9iwqDCoMKgwqDCoCBvcmln
aW5hbMKgwqDCoMKgwqAgYWZ0ZXLCoCB0aGlzIGNvbW1pdAo+ID4gwqDCoMKgwqAgbWluIElPUFPC
oMKgwqDCoMKgwqDCoCA0LDY1My42MMKgwqAgMiw3MDQuNDDCoMKgwqDCoCAzLDkwMi44MAo+ID4g
wqDCoMKgwqAgbWF4IElPUFPCoMKgwqDCoMKgwqDCoCA2LDE1MS44MMKgwqAgNCw4NDcuNjDCoMKg
wqDCoCA2LDEwMy40MAo+ID4gwqDCoMKgwqAgYXZnIElPUFPCoMKgwqDCoMKgwqDCoCA1LDQ4OC44
MsKgwqAgNCwyMjYuNjHCoMKgwqDCoCA1LDMxNC44OQo+ID4gwqDCoMKgwqAgY3B1ICUgdXNywqDC
oMKgwqDCoMKgwqDCoMKgwqAgMS44NcKgwqDCoMKgwqDCoCAxLjcywqDCoMKgwqDCoMKgwqDCoCAx
Ljk3Cj4gPiDCoMKgwqDCoCBjcHUgJSBzeXPCoMKgwqDCoMKgwqDCoMKgwqAgMzIuNDbCoMKgwqDC
oMKgIDI4Ljg4wqDCoMKgwqDCoMKgwqAgMzMuMjkKPiA+IMKgwqDCoMKgIGJ3IE1CL3PCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIDIxLjQ2wqDCoMKgwqDCoCAxNi41MMKgwqDCoMKgwqDCoMKgIDIwLjc2
Cj4gPiAKPiA+IMKgwqAgcmVhZCAvIDggam9ic8KgwqDCoMKgIG9yaWdpbmFswqDCoMKgwqDCoCBh
ZnRlcsKgIHRoaXMgY29tbWl0Cj4gPiDCoMKgwqDCoCBtaW4gSU9QU8KgwqDCoMKgwqDCoCAxOCwy
MDcuODDCoCAxMSwzMjMuMDDCoMKgwqAgMTcsOTExLjgwCj4gPiDCoMKgwqDCoCBtYXggSU9QU8Kg
wqDCoMKgwqDCoCAyNSw1MzUuODDCoCAxNCw0NzcuNDDCoMKgwqAgMjQsMzczLjYwCj4gPiDCoMKg
wqDCoCBhdmcgSU9QU8KgwqDCoMKgwqDCoCAyMiw1MjkuOTPCoCAxMywzMjUuNTnCoMKgwqAgMjEs
ODY4Ljg1Cj4gPiDCoMKgwqDCoCBjcHUgJSB1c3LCoMKgwqDCoMKgwqDCoMKgwqDCoCAxLjcwwqDC
oMKgwqDCoMKgIDEuNDHCoMKgwqDCoMKgwqDCoMKgIDEuNjcKPiA+IMKgwqDCoMKgIGNwdSAlIHN5
c8KgwqDCoMKgwqDCoMKgwqDCoCAyNy44OcKgwqDCoMKgwqAgMjEuODXCoMKgwqDCoMKgwqDCoCAy
Ny4yMwo+ID4gwqDCoMKgwqAgYncgTUIvc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgODguMTDCoMKg
wqDCoMKgIDUyLjEwwqDCoMKgwqDCoMKgwqAgODQuNDgKPiA+IAo+ID4gwqDCoCB3cml0ZSAvIDEg
am9iwqDCoMKgwqAgb3JpZ2luYWzCoMKgwqDCoMKgIGFmdGVywqAgdGhpcyBjb21taXQKPiA+IMKg
wqDCoMKgIG1pbiBJT1BTwqDCoMKgwqDCoMKgwqAgNiw1MjQuMjDCoMKgIDMsMTM2LjAwwqDCoMKg
wqAgNSw5ODguNDAKPiA+IMKgwqDCoMKgIG1heCBJT1BTwqDCoMKgwqDCoMKgwqAgNywzMDMuNjDC
oMKgIDUsMTQ0LjQwwqDCoMKgwqAgNywyMzIuNDAKPiA+IMKgwqDCoMKgIGF2ZyBJT1BTwqDCoMKg
wqDCoMKgwqAgNywxNjkuODDCoMKgIDQsNjA4LjI5wqDCoMKgwqAgNywwMTQuNjYKPiA+IMKgwqDC
oMKgIGNwdSAlIHVzcsKgwqDCoMKgwqDCoMKgwqDCoMKgIDIuMjnCoMKgwqDCoMKgwqAgMi4zNMKg
wqDCoMKgwqDCoMKgwqAgMi4yMwo+ID4gwqDCoMKgwqAgY3B1ICUgc3lzwqDCoMKgwqDCoMKgwqDC
oMKgIDQxLjkxwqDCoMKgwqDCoCAzOS4zNMKgwqDCoMKgwqDCoMKgIDQyLjQ4Cj4gPiDCoMKgwqDC
oCBidyBNQi9zwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyOC4wMsKgwqDCoMKgwqAgMTguMDDCoMKg
wqDCoMKgwqDCoCAyNy40Mgo+ID4gCj4gPiDCoMKgIHdyaXRlIC8gOCBqb2JzwqDCoMKgIG9yaWdp
bmFswqDCoMKgwqDCoCBhZnRlcsKgIHRoaXMgY29tbWl0Cj4gPiDCoMKgwqDCoCBtaW4gSU9QU8Kg
wqDCoMKgwqDCoCAxMiw2ODUuNDDCoCAxMyw3ODMuMDDCoMKgwqAgMTIsNjIyLjQwCj4gPiDCoMKg
wqDCoCBtYXggSU9QU8KgwqDCoMKgwqDCoCAzMCw4MTQuMjDCoCAyMiwxMjIuMDDCoMKgwqAgMjks
NjM2LjAwCj4gPiDCoMKgwqDCoCBhdmcgSU9QU8KgwqDCoMKgwqDCoCAyMSw1MzkuMDTCoCAxOCw1
NTIuNjPCoMKgwqAgMjEsMTM0LjY1Cj4gPiDCoMKgwqDCoCBjcHUgJSB1c3LCoMKgwqDCoMKgwqDC
oMKgwqDCoCAyLjA4wqDCoMKgwqDCoMKgIDEuNjHCoMKgwqDCoMKgwqDCoMKgIDIuMDcKPiA+IMKg
wqDCoMKgIGNwdSAlIHN5c8KgwqDCoMKgwqDCoMKgwqDCoCAzMC44NsKgwqDCoMKgwqAgMjMuODjC
oMKgwqDCoMKgwqDCoCAzMC42NAo+ID4gwqDCoMKgwqAgYncgTUIvc8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgODQuMTjCoMKgwqDCoMKgIDcyLjU0wqDCoMKgwqDCoMKgwqAgODIuNjIKPiAKPiBUaGFu
a3MgZm9yIHRoaXMgdXBkYXRlZCBjaGFuZ2UsIEknbSBydW5uaW5nIHRoZSBleGFjdCBzYW1lIHJ1
biBvbiBTTTg2NTAgdG8gY2hlY2sgdGhlIGltcGFjdCwKPiBhbmQgSSdsbCByZXBvcnQgc29tZXRo
aW5nIGNvbXBhcmFibGUuCgpCdHcsIG15IGNvbXBsZXRlIGNvbW1hbmQgd2FzIChzaG91bGQgcHJv
YmFibHkgaGF2ZSBhZGRlZCB0aGF0CnRvIHRoZSBjb21taXQgbWVzc2FnZSBpbiB0aGUgZmlyc3Qg
cGxhY2UpOgoKZm9yIHJ3IGluIHJlYWQgd3JpdGUgOyBkbwogICAgZWNobyAicnc6ICR7cnd9Igog
ICAgZm9yIGpvYnMgaW4gMSA4IDsgZG8KICAgICAgICBlY2hvICJqb2JzOiAke2pvYnN9IgogICAg
ICAgIGZvciBpdCBpbiAkKHNlcSAxIDUpIDsgZG8KICAgICAgICAgICAgZmlvIC0tbmFtZT1yYW5k
JHtyd30gLS1ydz1yYW5kJHtyd30gXAogICAgICAgICAgICAgICAgLS1pb2VuZ2luZT1saWJhaW8g
LS1kaXJlY3Q9MSBcCiAgICAgICAgICAgICAgICAtLWJzPTRrIC0tbnVtam9icz0ke2pvYnN9IC0t
c2l6ZT0zMm0gXAogICAgICAgICAgICAgICAgLS1ydW50aW1lPTMwIC0tdGltZV9iYXNlZCAtLWVu
ZF9mc3luYz0xIFwKICAgICAgICAgICAgICAgIC0tZ3JvdXBfcmVwb3J0aW5nIC0tZmlsZW5hbWU9
L2ZvbyBcCiAgICAgICAgICAgIHwgZ3JlcCAtRSAnKGlvcHN8c3lzPXxSRUFEOnxXUklURTopJwog
ICAgICAgICAgICBzbGVlcCA1CiAgICAgICAgZG9uZQogICAgZG9uZQpkb25lCgpDaGVlcnMsCkFu
ZHJlJwo=

