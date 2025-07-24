Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971728CF49
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753357470; cv=none; b=D3beq8BjXvLazjDvU50XglZzglYkfqXoOBPUKV2N0vP+PisDqTEco0RUvwvAUg36xcyFrQFuulHpr6Q/7GbAPmO+bTBur/RQBku6W3b6+AJiJ2PzZ7RAqfCKEp/yTfoP+Kqy6N7oREiIC+8vAFjiru08LUfMZMvX8S6WlXhDU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753357470; c=relaxed/simple;
	bh=JnepbmCMXMOKgOEjU5Ks3FoX+A1NpJSJ7B19hImN1eU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LZMGXXt5vgqu2XsoQrz9ELNjD36ndbP4Dkf+449mmt5OGhhyU7u5+s1Gshj+bS1G27OY90lAUfkvwZY8GBRa8Iu+Kw3sjBOD3lHikUtddUYWc7N5glXvhJq/YiDmQxcWHG97ztSHNcDCopK+ea2ql58E5vfWr+ACXf6O/NxoDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DzmCgYpq; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DzmCgYpq"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a6e8b1fa37so722126f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 04:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753357467; x=1753962267; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JnepbmCMXMOKgOEjU5Ks3FoX+A1NpJSJ7B19hImN1eU=;
        b=DzmCgYpq9jpAapxDuBtIWdv1cmMIs3LmyQjVUApJvhbONDpG1et9RSNJVjo4SZAv1a
         /KGDeAQvRv8uLKfQ/lXSvSxL3RoWYv0dUtt+GA4G3jnMva8b03w5INfrw//dCUqxtD6e
         PR8eiEGXfKqBPJ0LC17wqZe8mhOMrWvxWqDFiSDOwWy/Gaw8N8DD6v5LKjt1yDahPF2O
         CbIztWf7zAMR12BGb+RI1XmjrqeCY9HEHgAZEC1WvX2NiY72ML8wTN8pfi2QPZ/r/l/T
         9up/C5NfG8t5Hi63x+Hbkez2NF1LeTIxJrZP7td+/IYB8eXMoK9zFeaDczE1cB5olk9f
         y6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753357467; x=1753962267;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnepbmCMXMOKgOEjU5Ks3FoX+A1NpJSJ7B19hImN1eU=;
        b=BfiCW7ztAl0zp+T5iChbNqnC7KTuxi3jECKouKkNUwaiDo2fHCpLym0vm+M84eiV6Y
         GOgg+lQYM4CLl7mqul9Rl5J51OJHdZLVmbqHwBImFbRwSzGfuKODeB/AKQSv0R5p9O49
         Tbaw/A6s+ss3Y9/NTSBzIA+vzwzMsGpBA1RteRMG83XSSR0TB7engkHOq7cxTjPiGh9d
         R9/89vUHkb6Vug5oQaXrK6jbxt/zNPUxvK/WM7A28dCd7LiGAf/CSHwNC3h461L5QQoT
         sN3623yP7uur0taflultHYnRsLSyJZA855mcpI6cJIjaisTp2eAgzJnbXR0v7nj74RMG
         NlZg==
X-Forwarded-Encrypted: i=1; AJvYcCUIin1FBbhlYYV7tqSY02eLPg3F7tA1lr7xhuap20Pw6RnpKeznUfx3sZoWkKrJmNgfTOk0W6l8mdOp@vger.kernel.org
X-Gm-Message-State: AOJu0YwTXBROmR9dhCe08dRHsEz9yr16D82fZHTD62cnHOHCO1S/Hczr
	6GV0FqdvzoP5S4Io8u7ZD+RLX/hLmfiGBwZsAVxeiXwk9Ym2vJaVyOLnrpJO5yD/fvQ=
X-Gm-Gg: ASbGncvTFrv3cbykZO9qnuQU2dqN9xK4UAa8AqMjhb4KYYQ7rvvlNLvqpOzOqbf7YUQ
	obYyzApSwoVreC3jByLSb76vQQztVWqFEm04NwLnt8yX74iND/VuR8RCIhgB7iwvcsNqq/be1FZ
	bCsgshqmVDtLGViLTUl984OLC27zX6UkFCNzTy0lPv3IexyvTroeX7MuhjBTbHq835eJHDPfhbo
	qs4RkgBFgE558dlHf6b1UTpmWvC1qZLzfs/7rVi1cnrVEPPCOY7NO5d+ZgP0UE9F5ZlevgpsQkg
	sAMIaz55vrBjerNHjyDxvGxXF0BWu1NGfoWS36Foaa2CTFI5hvKl88i0bFAuBUGHWzxps/jPO9m
	qEhxm6X7f+6N2KpDmBeQYjMfVlw==
X-Google-Smtp-Source: AGHT+IHHzvXzUFlNBb5h1ZHcG1dDHEvJBu3nzAIsss/1oIrA8PaZ8Ieylg72nANxkTo5v76E9RRCoQ==
X-Received: by 2002:a05:6000:144e:b0:3a5:2875:f985 with SMTP id ffacd0b85a97d-3b768f16625mr5443325f8f.59.1753357467045;
        Thu, 24 Jul 2025 04:44:27 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcb8ce2sm1871186f8f.68.2025.07.24.04.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 04:44:26 -0700 (PDT)
Message-ID: <f2b85e49152b80a63b20aa5ad67dfbee1190e356.camel@linaro.org>
Subject: Re: [PATCH] scsi: ufs: core: move some irq handling back to hardirq
 (with time limit)
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,  Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Neil Armstrong <neil.armstrong@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam	 <mani@kernel.org>, kernel-team@android.com,
 linux-arm-msm@vger.kernel.org, 	linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 24 Jul 2025 12:44:25 +0100
In-Reply-To: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
References: <20250724-ufshcd-hardirq-v1-1-6398a52f8f02@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.56.1-1+build2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDEwOjU0ICswMTAwLCBBbmRyw6kgRHJhc3ppayB3cm90ZToK
PiBmaW8gcmVzdWx0cyBvbiBQaXhlbCA2Ogo+IMKgIHJlYWQgLyAxIGpvYsKgwqDCoMKgIG9yaWdp
bmFswqDCoMKgIGFmdGVywqDCoMKgIHRoaXMgY29tbWl0Cj4gwqDCoMKgIG1pbiBJT1BTwqDCoMKg
wqDCoMKgwqAgNCw2NTMuNjDCoMKgIDIsNzA0LjQwwqDCoMKgIDMsOTAyLjgwCj4gwqDCoMKgIG1h
eCBJT1BTwqDCoMKgwqDCoMKgwqAgNiwxNTEuODDCoMKgIDQsODQ3LjYwwqDCoMKgIDYsMTAzLjQw
Cj4gwqDCoMKgIGF2ZyBJT1BTwqDCoMKgwqDCoMKgwqAgNSw0ODguODLCoMKgIDQsMjI2LjYxwqDC
oMKgIDUsMzE0Ljg5Cj4gwqDCoMKgIGNwdSAlIHVzcsKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuODXC
oMKgwqDCoMKgwqAgMS43MsKgwqDCoMKgwqDCoMKgIDEuOTcKPiDCoMKgwqAgY3B1ICUgc3lzwqDC
oMKgwqDCoMKgwqDCoMKgIDMyLjQ2wqDCoMKgwqDCoCAyOC44OMKgwqDCoMKgwqDCoCAzMy4yOQo+
IMKgwqDCoCBidyBNQi9zwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyMS40NsKgwqDCoMKgwqAgMTYu
NTDCoMKgwqDCoMKgwqAgMjAuNzYKPiAKPiDCoCByZWFkIC8gOCBqb2JzwqDCoMKgIG9yaWdpbmFs
wqDCoMKgIGFmdGVywqDCoMKgIHRoaXMgY29tbWl0Cj4gwqDCoMKgIG1pbiBJT1BTwqDCoMKgwqDC
oMKgIDE4LDIwNy44MMKgIDExLDMyMy4wMMKgwqAgMTcsOTExLjgwCj4gwqDCoMKgIG1heCBJT1BT
wqDCoMKgwqDCoMKgIDI1LDUzNS44MMKgIDE0LDQ3Ny40MMKgwqAgMjQsMzczLjYwCj4gwqDCoMKg
IGF2ZyBJT1BTwqDCoMKgwqDCoMKgIDIyLDUyOS45M8KgIDEzLDMyNS41OcKgwqAgMjEsODY4Ljg1
Cj4gwqDCoMKgIGNwdSAlIHVzcsKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuNzDCoMKgwqDCoMKgwqAg
MS40McKgwqDCoMKgwqDCoMKgIDEuNjcKPiDCoMKgwqAgY3B1ICUgc3lzwqDCoMKgwqDCoMKgwqDC
oMKgIDI3Ljg5wqDCoMKgwqDCoCAyMS44NcKgwqDCoMKgwqDCoCAyNy4yMwo+IMKgwqDCoCBidyBN
Qi9zwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA4OC4xMMKgwqDCoMKgwqAgNTIuMTDCoMKgwqDCoMKg
wqAgODQuNDgKPiAKPiDCoCB3cml0ZSAvIDEgam9iwqDCoMKgIG9yaWdpbmFswqDCoMKgIGFmdGVy
wqDCoMKgIHRoaXMgY29tbWl0Cj4gwqDCoMKgIG1pbiBJT1BTwqDCoMKgwqDCoMKgwqAgNiw1MjQu
MjDCoMKgIDMsMTM2LjAwwqDCoMKgIDUsOTg4LjQwCj4gwqDCoMKgIG1heCBJT1BTwqDCoMKgwqDC
oMKgwqAgNywzMDMuNjDCoMKgIDUsMTQ0LjQwwqDCoMKgIDcsMjMyLjQwCj4gwqDCoMKgIGF2ZyBJ
T1BTwqDCoMKgwqDCoMKgwqAgNywxNjkuODDCoMKgIDQsNjA4LjI5wqDCoMKgIDcsMDE0LjY2Cj4g
wqDCoMKgIGNwdSAlIHVzcsKgwqDCoMKgwqDCoMKgwqDCoMKgIDIuMjnCoMKgwqDCoMKgwqAgMi4z
NMKgwqDCoMKgwqDCoMKgIDIuMjMKPiDCoMKgwqAgY3B1ICUgc3lzwqDCoMKgwqDCoMKgwqDCoMKg
IDQxLjkxwqDCoMKgwqDCoCAzOS4zNMKgwqDCoMKgwqDCoCA0Mi40OAo+IMKgwqDCoCBidyBNQi9z
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyOC4wMsKgwqDCoMKgwqAgMTguMDDCoMKgwqDCoMKgwqAg
MjcuNDIKPiAKPiDCoCB3cml0ZSAvIDggam9ic8KgwqAgb3JpZ2luYWzCoMKgwqAgYWZ0ZXLCoMKg
wqAgdGhpcyBjb21taXQKPiDCoMKgwqAgbWluIElPUFPCoMKgwqDCoMKgwqAgMTIsNjg1LjQwwqAg
MTMsNzgzLjAwwqDCoCAxMiw2MjIuNDAKPiDCoMKgwqAgbWF4IElPUFPCoMKgwqDCoMKgwqAgMzAs
ODE0LjIwwqAgMjIsMTIyLjAwwqDCoCAyOSw2MzYuMDAKPiDCoMKgwqAgYXZnIElPUFPCoMKgwqDC
oMKgwqAgMjEsNTM5LjA0wqAgMTgsNTUyLjYzwqDCoCAyMSwxMzQuNjUKPiDCoMKgwqAgY3B1ICUg
dXNywqDCoMKgwqDCoMKgwqDCoMKgwqAgMi4wOMKgwqDCoMKgwqDCoCAxLjYxwqDCoMKgwqDCoMKg
wqAgMi4wNwo+IMKgwqDCoCBjcHUgJSBzeXPCoMKgwqDCoMKgwqDCoMKgwqAgMzAuODbCoMKgwqDC
oMKgIDIzLjg4wqDCoMKgwqDCoMKgIDMwLjY0Cj4gwqDCoMKgIGJ3IE1CL3PCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIDg0LjE4wqDCoMKgwqDCoCA3Mi41NMKgwqDCoMKgwqDCoCA4Mi42MgoKR2l2ZW4g
dGhlIHNldmVyZSBwZXJmb3JtYW5jZSBkcm9wIGludHJvZHVjZWQgYnkgdGhlIGN1bHByaXQKY29t
bWl0LCBpdCBtaWdodCBtYWtlIHNlbnNlIHRvIGluc3RlYWQganVzdCByZXZlcnQgaXQgZm9yCjYu
MTYgbm93LCB3aGlsZSB0aGlzIHBhdGNoIGhlcmUgY2FuIG1hdHVyZSBhbmQgYmUgcHJvcGVybHkK
cmV2aWV3ZWQuIEF0IGxlYXN0IHRoZW4gNi4xNiB3aWxsIG5vdCBoYXZlIGFueSBwZXJmb3JtYW5j
ZQpyZWdyZXNzaW9uIG9mIHN1Y2ggYSBzY2FsZS4KCkNoZWVycywKQW5kcmUnCg==

