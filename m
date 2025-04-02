Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB781F9F7A;
	Wed,  2 Apr 2025 08:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743583873; cv=none; b=jgPm/V8SL/uOpP5hwv6OmcQ6hEb1J3qL/gu11EshQmyjpskXh8bibJVWipiDbSapdmXmgAGFQ5LR1oC49MpkzGgNehmEe0/i0wkRA24Pi8R1t1Za5OgmETkH4tNaTh3WpkJX5dULtsWlavXbYOHLIHrrOMG0eUIJ+3TY3Bp31Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743583873; c=relaxed/simple;
	bh=2C014mxROCRDtsO04srHF5zNmW+l8l4FbGKJiZ0rRnc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yj4U5bgXf+V+cVUhYY38Mh6HuK+a5LGO6U7Kv5r2WDhP5pqFvOSOKZYgUCzVoE1A6zbL7Qw41dpfUEdyJUlmbzuCAiucmmn9TGueyAeNxIVQXXI7tDmqNK6WgKqW4ZRT4Q2BaJdu3IfxrBxL/qqlPke8Dwusq/aKRJkm1dt+D7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmrlQJaq; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmrlQJaq"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab771575040so122909466b.1;
        Wed, 02 Apr 2025 01:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743583868; x=1744188668; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2C014mxROCRDtsO04srHF5zNmW+l8l4FbGKJiZ0rRnc=;
        b=MmrlQJaqzjSP9GFbGwJ/JCFsdIC7nP+RwhPqBL3wWP+uQpHtSVijDvnQ0bIk+bU5vl
         8Olv9uxiXiSXDjBWssY5T/hDjR/n3zu2wrRtqDmu3TQQliGtQ1n+6Tun23tw+lzBrOnD
         kpQjH53cok2d1Mh6yL3TeTer0nBbgSY41FXkSHrzJV0mKPr3RbNxbnyTdxf0ilM3A3hD
         7olD4MXpk806iUt0pQgedHui1As2QA/ZSg0TGNNAOTkS19j3TE9pG98o2aFQ/ertZC7z
         atsjAjshwKnUOw+BvfFhagG8O4A3eyu3u2VM5fMFOmsKhIXFWol0BINTuJ36oRIiZD8x
         xpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743583868; x=1744188668;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2C014mxROCRDtsO04srHF5zNmW+l8l4FbGKJiZ0rRnc=;
        b=mAYcOtSU3Mx6yRk1HZ95D4Wd//PROkEPz1dvAJk9eiRIW6uYNk3avBu0JadP+33rAc
         1zfpMKqBeFd22rjPaD5L0ZN7+CUdC8zvavjFfvK7lHE5fyo5dP5d7a0KHh1DAJKIpNO+
         fkH7oiio1VyAP5RvDhJFI7XpjY1hJh8gm9FpPwq3+bK5pF160V2wYDlj3vCAkE8Q//wd
         bi+/QLgAEHo1E3hnJAmaWIf8QKqsrOCcYFICz1wyN3X/Or2Tv51A0IqqjCWn6/T7lPnz
         vLNAeDSxGJOOUcXEWwW8BLvRNhdsOkgIv/UiaTR/9smceh9eXK9tOxaP+GrjBEARZx5d
         F5yw==
X-Forwarded-Encrypted: i=1; AJvYcCX+ql72Jfe5AQwEEma6w4xsaI0XqUSLY0LtkzBzeRlZGwTc/Wbt60MKepbCics2YV2+nfV45+NoGvot5A==@vger.kernel.org, AJvYcCX4z6hqXlWzjo384DETA8MlLZgNdVyxVRBuVhjtILhrLb7jNABaOZuDO6AUJNaUlk/pfvP78MT5cwBb0J4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx8SUZIQgs3AJ2sXUoiuU1eTakct2l9Ie8qs3AX0GK7sW1gRu/
	bUhXuoArulbOUdmbxhXlFPdGJs5ua/DtCVY3G68vsq6M5zLZRYiS
X-Gm-Gg: ASbGncsp5H3RQgdFq9X9XsaOJVVRWETdH29usHxO85WOlCCmWh9X9dut4Xf7Xvu87p+
	LUBvnmMi0xD+Ot5Je4sErTQFPjy1hrTcyx1hbz9Cqjh/+uMPRMHjevxogErTDer7r9zj8rwMsQr
	uLmL4A9blRkVHPqo9pCPV6Sbdf+JgsZh3eTZFuI+nXwIaSMr4ALwssuAJHI6Xoj0b9szI7AteTP
	GXs6VRvOeB1Imp1Pt0Cv/3ppjI9jEur5wBAAOIQac4av4J84eR9XMH0kjVmhI53Xwu6axGdJUe2
	fKnn2Hafqh6gBdGpowgXKyFaoFvcD4SjLyojyH8lQauzkT4=
X-Google-Smtp-Source: AGHT+IF2peLlZz8CtWJ7CfbJ8NEYEHGPninGbEcHAIlNnUR3fipLckbBovlkHaOZmUGNuky8TbYuJA==
X-Received: by 2002:a17:907:3f29:b0:ac3:ef17:f6f0 with SMTP id a640c23a62f3a-ac7a5a670ebmr96209966b.5.1743583868302;
        Wed, 02 Apr 2025 01:51:08 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7192e7d36sm881646466b.77.2025.04.02.01.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 01:51:07 -0700 (PDT)
Message-ID: <1a7a6e077f3750b0385388187cd52010eef4a085.camel@gmail.com>
Subject: Re: [PATCH v8] ufs: core: Add WB buffer resize support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com,  bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 beanhuo@micron.com, luhongfei@vivo.com,  quic_cang@quicinc.com,
 keosung.park@samsung.com, viro@zeniv.linux.org.uk, 
 quic_mnaresh@quicinc.com, peter.wang@mediatek.com, 
 manivannan.sadhasivam@linaro.org, quic_nguyenb@quicinc.com,
 linux@weissschuh.net,  ebiggers@google.com, minwoo.im@samsung.com,
 linux-kernel@vger.kernel.org,  linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com
Date: Wed, 02 Apr 2025 10:51:01 +0200
In-Reply-To: <20250402075710.224-1-tanghuan@vivo.com>
References: <20250402075710.224-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDE1OjU3ICswODAwLCBIdWFuIFRhbmcgd3JvdGU6Cj4gwqAK
PiAraW50IHVmc2hjZF93Yl9zZXRfcmVzaXplX2VuKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHUzMiBl
bl9tb2RlKQoKCnlvdSBtdXN0IGVuc3VyZSB0aGUgbW9kZSBlbl9tb2RlIGlzIHdpdGhpbiB2YWxp
ZCByYW5nZSAoMC0yKSwgd2h5IG5vdAp1c2UgZW51bT8KCgo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKg
aW50IHJldDsKPiArwqDCoMKgwqDCoMKgwqB1OCBpbmRleDsKPiArCj4gK8KgwqDCoMKgwqDCoMKg
aW5kZXggPSB1ZnNoY2Rfd2JfZ2V0X3F1ZXJ5X2luZGV4KGhiYSk7Cj4gK8KgwqDCoMKgwqDCoMKg
cmV0ID0gdWZzaGNkX3F1ZXJ5X2F0dHJfcmV0cnkoaGJhLAo+IFVQSVVfUVVFUllfT1BDT0RFX1dS
SVRFX0FUVFIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgUVVFUllfQVRUUl9JRE5fV0JfQlVGX1JFU0laRV9FTiwKPiBpbmRl
eCwgMCwgJmVuX21vZGUpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGRldl9lcnIoaGJhLT5kZXYsICIlczogRW5hYmxlIFdCIGJ1ZiBy
ZXNpemUgb3BlcmF0aW9uCj4gZmFpbGVkICVkXG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19mdW5jX18sIHJldCk7Cj4gKwo+ICvCoMKgwqDCoMKg
wqDCoHJldHVybiByZXQ7Cj4gK30KCg==

