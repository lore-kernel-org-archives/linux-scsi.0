Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F89281531
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753364315; cv=none; b=iCbmN+jxr51zU01I83y1+lzSK1DsxsQSaKdu2uwDmr+oavcF1tX5vgK/KMM9WEitpM32P+08T/FJ+OXr788EmDicWp6+oYBv80kv0NQZK5LZT3bmRpj7BSsl5yqtKjN6Zq7pxhnN4JDYz3pDOU1NoQ3tnkc5NSNE4UOqCXyHkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753364315; c=relaxed/simple;
	bh=IbVnVuUXikFBJJ9Ko98F0sau5TC35CHjqvTzNtUUNGk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X3tVigsLfjVfSd/tpEfs6oBLcx/ChESUkCju2Cirt7GDf3ywTVsSfv9GjwvJRTTiESBF2f6oFTmKGi02geRB5oJFzOquNzmwJWPmJNWweZyitqYMV1i0mFK6S5uKoJQTJCClCgBTPowDFYBk7QuyGRm3OWPjhIxU+o9Dnh0W9C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+sozftc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+sozftc"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45618ddd62fso10713615e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 06:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753364312; x=1753969112; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IbVnVuUXikFBJJ9Ko98F0sau5TC35CHjqvTzNtUUNGk=;
        b=q+sozftcdPDo3Rgjq2URBuvYArk0JTw/ZPhw+XSpGKXn4o8ATX2alAnwdnXaJ1M8Ou
         KpqsTfm1qJtptZx1vVE60x/w6Vk7+1GOljmtnoWGuAOsQIVrZgbTPa8ihoJsNEWP6coF
         5zH/s/NvaJA/nzejqNpweaMZzDHkEZfw2lJFHwoL5wg3zifYXJEV1q6AZbRGRGSvcyp8
         e+Gy7eCzbWYca3Zs7pXUGwOoIiRkd/lZ6RBIKMdu2Y9b9rYf2O6mmruC/h3m7l0B/tDc
         0BtYqOn1oRnhxb1tUAffPdiXyHIxCivoxNBoJpi7TXWrpLFpU9wVHv5O8Dp2h9tDbwKw
         ghrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753364312; x=1753969112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IbVnVuUXikFBJJ9Ko98F0sau5TC35CHjqvTzNtUUNGk=;
        b=MaE3b3J5sbUT3ZmiREK6bwRGAgPRV1eVgQzevIsF1lzTOCL57PddquoeWzuwd31M4g
         OkzW4lCqSZvWI1kwXfm26EofRTEyJX/ZeabyDYxrDRtiIQfiyQ+5m4ArvWzT+OYbyr1J
         kUyQ+SoLRqRjBVAr4k56dIbsYNtARRVzrWYhUmduhC88tFlc+ZQU5/YKtT3oABHKuspW
         sBJ21JlJExYzamDkBpDBSD53rJ+vwVa2Il5OqeUyADBmMhp4q8WeeF+0zSBi08++w6N2
         WivlZsMdXOGTcnFIt33VbuKsr1gLSx6qFNErzqhNN6V7H2eys8ZqnqsOAEFSAFm1UYU3
         35Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWzsWUjns5G4BODZnqTAmI73Ny4cSiGSxBS6nLaQjOmoEDR5+sQkd6jgFH11crqKccWEI2W5drAzjui@vger.kernel.org
X-Gm-Message-State: AOJu0YyOYYZM7RvwNbgA6hGuGm+MI2QggofaGHLijSYPUkkuKwczkx1E
	ryMB2g2rLqZkMLzxqf9D6HTvQmTyF5t0XlTnmP0ORQ9cGCdMFXkWyrUmG5zjd74KfkQ=
X-Gm-Gg: ASbGncsBzPAgwYYoyNhVReYlmRuCS54Zg4I6ltAMpUmSGg5wi/kbMlvONckPwx94c8s
	Lmcu90fdWSA0zYYwu8SKnUd8rGAUS1IotoK477h9TrxmP863XmYBjViGWVORHiijQ0l+9V5uKfw
	I+e/YUTPdUKL3k0eaYfQP4wU/Skd58n0d83fgj4rmTsZnx0hZE/e9TyKUrQZcR1t2dFXicg+66Y
	/YBMeQDuWh0wRGe2YvqFKFbHlZl2pmX0P95mOy3YNMZb59MVccuNbsO7wVCa9ySX5GWlJ4YNGKg
	dSb+Kx8/uRF0/+PFfZZd71O92PQZ/BpxpIVotGa+czGdTunWYp2bqWnX3chnSnmACwPZ4/y/mKm
	2cy7z6FPptKnH1PTn7ZuNI8Qfiw==
X-Google-Smtp-Source: AGHT+IFTJQA9Boc7JWTCl6LSd+k2ItcXOgwaQYa0NFEIhnO4z236I53hOupq7tKoQvq6tlGKFF+E+A==
X-Received: by 2002:a05:600c:190e:b0:456:1e5a:8880 with SMTP id 5b1f17b1804b1-45868c9cf1bmr63195165e9.13.1753364312430;
        Thu, 24 Jul 2025 06:38:32 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705678c1sm20842055e9.25.2025.07.24.06.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:38:32 -0700 (PDT)
Message-ID: <766fa03c4a9a2667c8c279be932945affb798af0.camel@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: move some irq handling back to hardirq
 (with time limit)
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Neil Armstrong <neil.armstrong@linaro.org>, Alim Akhtar	
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche	 <bvanassche@acm.org>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>
Cc: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam	 <mani@kernel.org>, kernel-team@android.com,
 linux-arm-msm@vger.kernel.org, 	linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 24 Jul 2025 14:38:30 +0100
In-Reply-To: <53bfd619-4066-4dcb-b3f0-d04177e05355@linaro.org>
References: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
	 <f2b85e49152b80a63b20aa5ad67dfbee1190e356.camel@linaro.org>
	 <53bfd619-4066-4dcb-b3f0-d04177e05355@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.56.1-1+build2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDEzOjU0ICswMjAwLCBOZWlsIEFybXN0cm9uZyB3cm90ZToK
PiBPbiAyNC8wNy8yMDI1IDEzOjQ0LCBBbmRyw6kgRHJhc3ppayB3cm90ZToKPiA+IE9uIFRodSwg
MjAyNS0wNy0yNCBhdCAxMDo1NCArMDEwMCwgQW5kcsOpIERyYXN6aWsgd3JvdGU6Cj4gPiA+IGZp
byByZXN1bHRzIG9uIFBpeGVsIDY6Cj4gPiA+IMKgwqAgcmVhZCAvIDEgam9iwqDCoMKgwqAgb3Jp
Z2luYWzCoMKgwqAgYWZ0ZXLCoMKgwqAgdGhpcyBjb21taXQKPiA+ID4gwqDCoMKgwqAgbWluIElP
UFPCoMKgwqDCoMKgwqDCoCA0LDY1My42MMKgwqAgMiw3MDQuNDDCoMKgwqAgMyw5MDIuODAKPiA+
ID4gwqDCoMKgwqAgbWF4IElPUFPCoMKgwqDCoMKgwqDCoCA2LDE1MS44MMKgwqAgNCw4NDcuNjDC
oMKgwqAgNiwxMDMuNDAKPiA+ID4gwqDCoMKgwqAgYXZnIElPUFPCoMKgwqDCoMKgwqDCoCA1LDQ4
OC44MsKgwqAgNCwyMjYuNjHCoMKgwqAgNSwzMTQuODkKPiA+ID4gwqDCoMKgwqAgY3B1ICUgdXNy
wqDCoMKgwqDCoMKgwqDCoMKgwqAgMS44NcKgwqDCoMKgwqDCoCAxLjcywqDCoMKgwqDCoMKgwqAg
MS45Nwo+ID4gPiDCoMKgwqDCoCBjcHUgJSBzeXPCoMKgwqDCoMKgwqDCoMKgwqAgMzIuNDbCoMKg
wqDCoMKgIDI4Ljg4wqDCoMKgwqDCoMKgIDMzLjI5Cj4gPiA+IMKgwqDCoMKgIGJ3IE1CL3PCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIDIxLjQ2wqDCoMKgwqDCoCAxNi41MMKgwqDCoMKgwqDCoCAyMC43
Ngo+ID4gPiAKPiA+ID4gwqDCoCByZWFkIC8gOCBqb2JzwqDCoMKgIG9yaWdpbmFswqDCoMKgIGFm
dGVywqDCoMKgIHRoaXMgY29tbWl0Cj4gPiA+IMKgwqDCoMKgIG1pbiBJT1BTwqDCoMKgwqDCoMKg
IDE4LDIwNy44MMKgIDExLDMyMy4wMMKgwqAgMTcsOTExLjgwCj4gPiA+IMKgwqDCoMKgIG1heCBJ
T1BTwqDCoMKgwqDCoMKgIDI1LDUzNS44MMKgIDE0LDQ3Ny40MMKgwqAgMjQsMzczLjYwCj4gPiA+
IMKgwqDCoMKgIGF2ZyBJT1BTwqDCoMKgwqDCoMKgIDIyLDUyOS45M8KgIDEzLDMyNS41OcKgwqAg
MjEsODY4Ljg1Cj4gPiA+IMKgwqDCoMKgIGNwdSAlIHVzcsKgwqDCoMKgwqDCoMKgwqDCoMKgIDEu
NzDCoMKgwqDCoMKgwqAgMS40McKgwqDCoMKgwqDCoMKgIDEuNjcKPiA+ID4gwqDCoMKgwqAgY3B1
ICUgc3lzwqDCoMKgwqDCoMKgwqDCoMKgIDI3Ljg5wqDCoMKgwqDCoCAyMS44NcKgwqDCoMKgwqDC
oCAyNy4yMwo+ID4gPiDCoMKgwqDCoCBidyBNQi9zwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA4OC4x
MMKgwqDCoMKgwqAgNTIuMTDCoMKgwqDCoMKgwqAgODQuNDgKPiA+ID4gCj4gPiA+IMKgwqAgd3Jp
dGUgLyAxIGpvYsKgwqDCoCBvcmlnaW5hbMKgwqDCoCBhZnRlcsKgwqDCoCB0aGlzIGNvbW1pdAo+
ID4gPiDCoMKgwqDCoCBtaW4gSU9QU8KgwqDCoMKgwqDCoMKgIDYsNTI0LjIwwqDCoCAzLDEzNi4w
MMKgwqDCoCA1LDk4OC40MAo+ID4gPiDCoMKgwqDCoCBtYXggSU9QU8KgwqDCoMKgwqDCoMKgIDcs
MzAzLjYwwqDCoCA1LDE0NC40MMKgwqDCoCA3LDIzMi40MAo+ID4gPiDCoMKgwqDCoCBhdmcgSU9Q
U8KgwqDCoMKgwqDCoMKgIDcsMTY5LjgwwqDCoCA0LDYwOC4yOcKgwqDCoCA3LDAxNC42Ngo+ID4g
PiDCoMKgwqDCoCBjcHUgJSB1c3LCoMKgwqDCoMKgwqDCoMKgwqDCoCAyLjI5wqDCoMKgwqDCoMKg
IDIuMzTCoMKgwqDCoMKgwqDCoCAyLjIzCj4gPiA+IMKgwqDCoMKgIGNwdSAlIHN5c8KgwqDCoMKg
wqDCoMKgwqDCoCA0MS45McKgwqDCoMKgwqAgMzkuMzTCoMKgwqDCoMKgwqAgNDIuNDgKPiA+ID4g
wqDCoMKgwqAgYncgTUIvc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMjguMDLCoMKgwqDCoMKgIDE4
LjAwwqDCoMKgwqDCoMKgIDI3LjQyCj4gPiA+IAo+ID4gPiDCoMKgIHdyaXRlIC8gOCBqb2JzwqDC
oCBvcmlnaW5hbMKgwqDCoCBhZnRlcsKgwqDCoCB0aGlzIGNvbW1pdAo+ID4gPiDCoMKgwqDCoCBt
aW4gSU9QU8KgwqDCoMKgwqDCoCAxMiw2ODUuNDDCoCAxMyw3ODMuMDDCoMKgIDEyLDYyMi40MAo+
ID4gPiDCoMKgwqDCoCBtYXggSU9QU8KgwqDCoMKgwqDCoCAzMCw4MTQuMjDCoCAyMiwxMjIuMDDC
oMKgIDI5LDYzNi4wMAo+ID4gPiDCoMKgwqDCoCBhdmcgSU9QU8KgwqDCoMKgwqDCoCAyMSw1Mzku
MDTCoCAxOCw1NTIuNjPCoMKgIDIxLDEzNC42NQo+ID4gPiDCoMKgwqDCoCBjcHUgJSB1c3LCoMKg
wqDCoMKgwqDCoMKgwqDCoCAyLjA4wqDCoMKgwqDCoMKgIDEuNjHCoMKgwqDCoMKgwqDCoCAyLjA3
Cj4gPiA+IMKgwqDCoMKgIGNwdSAlIHN5c8KgwqDCoMKgwqDCoMKgwqDCoCAzMC44NsKgwqDCoMKg
wqAgMjMuODjCoMKgwqDCoMKgwqAgMzAuNjQKPiA+ID4gwqDCoMKgwqAgYncgTUIvc8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgODQuMTjCoMKgwqDCoMKgIDcyLjU0wqDCoMKgwqDCoMKgIDgyLjYyCj4g
PiAKPiA+IEdpdmVuIHRoZSBzZXZlcmUgcGVyZm9ybWFuY2UgZHJvcCBpbnRyb2R1Y2VkIGJ5IHRo
ZSBjdWxwcml0Cj4gPiBjb21taXQsIGl0IG1pZ2h0IG1ha2Ugc2Vuc2UgdG8gaW5zdGVhZCBqdXN0
IHJldmVydCBpdCBmb3IKPiA+IDYuMTYgbm93LCB3aGlsZSB0aGlzIHBhdGNoIGhlcmUgY2FuIG1h
dHVyZSBhbmQgYmUgcHJvcGVybHkKPiA+IHJldmlld2VkLiBBdCBsZWFzdCB0aGVuIDYuMTYgd2ls
bCBub3QgaGF2ZSBhbnkgcGVyZm9ybWFuY2UKPiA+IHJlZ3Jlc3Npb24gb2Ygc3VjaCBhIHNjYWxl
Lgo+IAo+IFRoZSBvcmlnaW5hbCBjaGFuZ2Ugd2FzIGRlc2lnbmVkIHRvIHN0b3AgdGhlIGludGVy
cnVwdCBoYW5kbGVyCj4gdG8gc3RhcnZlIHRoZSBzeXN0ZW0gYW5kIGNyZWF0ZSBkaXNwbGF5IGFy
dGlmYWN0IGFuZCBjYXVzZQo+IHRpbWVvdXRzIG9uIHN5c3RlbSBjb250cm9sbGVyIHN1Ym1pc3Np
b24uIFdoaWxlIGltcGVyZmVjdCwKPiBpdCB3b3VsZCByZXF1aXJlIHNvbWUgZmluZSB0dW5pbmcg
Zm9yIHNtYWxsZXIgY29udHJvbGxlcnMKPiBsaWtlIG9uIHRoZSBQaXhlbCA2IHRoYXQgd2hlbiBs
ZXNzIHF1ZXVlcy4KCldlbGwsIHRoZSBwYXRjaCBoYXMgc29sdmVkIG9uZSBwcm9ibGVtIGJ5IGNy
ZWF0aW5nIGFub3RoZXIgcHJvYmxlbS4KSSBkb24ndCB0aGluayB0aGF0J3MgaG93IHRoaW5ncyBh
cmUgbm9ybWFsbHkgZG9uZS4gQSA0MCUgYmFuZHdpZHRoCmFuZCBJT1BTIGRyb3AgaXMgbm90IG5l
Z2xpZ2libGUuCgpBbmQgd2hpbGUgSSBhbSByZWZlcmVuY2luZyBQaXhlbCA2IGFib3ZlIGFzIGl0
J3MgdGhlIG9ubHkgZGV2aWNlCkkgaGF2ZSBhdmFpbGFibGUgdG8gdGVzdCwgSSBzdXNwZWN0IGFs
bCA8IHY0IGNvbnRyb2xsZXJzIC8gZGV2aWNlcwphcmUgYWZmZWN0ZWQgaW4gYSBzaW1pbGFyIHdh
eSwgZ2l2ZW4gdGhlIG5hdHVyZSBvZiB0aGUgY2hhbmdlLgoKCkNoZWVycywKQW5kcmUnCg==

