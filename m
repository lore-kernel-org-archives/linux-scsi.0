Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03D2DAFCE
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176149; cv=none; b=iT/CZi32UX7PlcEkHz6PhH9amedf4ERCvnmFvsLvAfJYzTIe3kpwwkdM/oHWKU+5s/TVdFLb4oxfa+plrO8ej1If7f+jtVaSmRGHGjfduivVvbiAuZ4q/C1L+i+9oc9eo95jfg/Sbh/l6aqYm/8anMKy32wFUb2JFoQjnRNdR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176149; c=relaxed/simple;
	bh=6yQpiSo0+rgmT/RnJIkn8LyzRl3XRGHtT6XWn0Ypfec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qaeT4b2Hgv3RESLY0qNyFGwOkYxMU66Z8I8krkZWY3iiOMWiHwCQ9R3DzoCz+RWydCjiJnL5B78l3fPXcEeLUsGNj2Y5LvNyEJlHxfqCvraKjfez8vqhtx20oXqQ+TSiHDHOmkUDAVvLYY/qpvLzOmVUv/zm1fkxNjfQB5b7YO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=owBWUb6P; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="owBWUb6P"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so2998439f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753176145; x=1753780945; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6yQpiSo0+rgmT/RnJIkn8LyzRl3XRGHtT6XWn0Ypfec=;
        b=owBWUb6P3jQkk0NqHo6BRopLuf4z7b+ZsxaHcie1JbGAQXOh1mjnowEfGxmDQEKC/H
         K+9U8xlMtqzLf0gDL+VIkfUcyz9tdAeze5jBpo/8mockt6xfZa/fY/f5t3o0vH11CD9J
         wo9ZLX5hia1sRXXmM12E6Cmyl4+4ALsH/lHKyuLtaxl7GpVT2HmnLAS6cABb6MC3ZXw9
         83sXbFItvn0dcvzHHpI7X9ImO1HYHhlscohthUdOiXZM0LTHG638JmQzIB66aLiSzwtz
         u2AEo2JxRR8Icmue9aeKWEE1HtkgwjPDlr0iQn8Us7bB87NikI1QT/KytOr4AId4Q4Ha
         xTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176145; x=1753780945;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6yQpiSo0+rgmT/RnJIkn8LyzRl3XRGHtT6XWn0Ypfec=;
        b=EnL+Xds1TBlHVwgiMrqGUbwVFA3yACu68YhhWf5FnT3viyjfDn1uE602eJGTsUkMkL
         S8+FAcnv4iH7GVRbJpYqfSYplgLwE07rbvc9B+kJoCvniXSQEefhrGuMUazjIEIMQaRE
         NfRG4YSAGO5Y3UCCljEWQgAMwLn6iBehzM9cczGyTzxH2pOzdjYfDtnUJ0S9VTPyWH9R
         FaGK4gafUlyCnS4d3Xp1PKxFEdL5WGOSNFZXa4aY3TFCbqnyeGwNnPdok9g7rTEEXRxq
         6Oo7z1m2aIUDefFWzaObJUpn1pHu6uYKs+7GoPknSJb5nUpp9W8hDTIVia1Ks5kgydkC
         BkLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2ctnlLfUPpxvEQt9pJTeBxDqId2TUgMAmjv2s9w7ff//jNok2E/B0jg75n1Xn0+xk9pvrKpg0u2+Y@vger.kernel.org
X-Gm-Message-State: AOJu0YwdxT3G2SUaGUA7K+umvuB3fjnuR+JO7UHrktrsZxCm772LHuRt
	LFFVkhfWnDltSGZlHxZg7xEBJZaW/RPz8nNKpz/RwGKIBjtRd+9B7+19X418s4KimHs=
X-Gm-Gg: ASbGncsBfR3+iaQupRSJUXuvoJ40zt1u2J+eiMtzJfOmml3WWyHV+AU9pq5FglrGYQq
	iwp1DfPzRmbNlmDSo9GHrmgNaZ/qTaM9i7k7mBz2DOpeDdMbaxkgzJFw9Czc4gflgnfL332UY5X
	YIQTQ9rnrWfqZeDPMFp0dlJrpVQwkmwPWMxY0/0D9YG8Fly+i4UFuoHbgJhCdiwL41DRr2YyHrk
	YjgCl51rw4Whbv8dCFQfBAeMU/l4Ba38AmDTh1N4Q/ZsMc0vX+rKvuUqGk+JrWrjJB4rnslxyuT
	SUBDVIEl/6xgGzdmhJwksHsWxAArGXNbP6jz5XlhBjlOU/f3ceMzXGg/Fcs8BOOQGZuBoFqBbwG
	zVF+OdrOR4TCMsQbxCyXZnCF4lw==
X-Google-Smtp-Source: AGHT+IFa0Cq8XCk1eei600ygP39rkbICfNwYJWpNDRsRQfPQ/EhYt57nAduutsvBoNK7GvU0uukHNQ==
X-Received: by 2002:a05:6000:2903:b0:3a5:2cb5:6429 with SMTP id ffacd0b85a97d-3b61b222600mr13228880f8f.43.1753176145551;
        Tue, 22 Jul 2025 02:22:25 -0700 (PDT)
Received: from [10.1.1.59] ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e8018a4sm186401235e9.9.2025.07.22.02.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 02:22:25 -0700 (PDT)
Message-ID: <f6573ba6fcb43f0c41239be728905fa2e936961e.camel@linaro.org>
Subject: Re: [PATCH RFT v3 3/3] ufs: core: delegate the interrupt service
 routine to a threaded irq handler
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>, Neil Armstrong	
 <neil.armstrong@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman	 <avri.altman@wdc.com>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Griffin
	 <peter.griffin@linaro.org>, Will McVicker <willmcvicker@google.com>, 
	kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Tue, 22 Jul 2025 10:22:23 +0100
In-Reply-To: <68631d36-6bb2-4389-99c1-288a63c82779@acm.org>
References: 
	<20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
	 <20250407-topic-ufs-use-threaded-irq-v3-3-08bee980f71e@linaro.org>
	 <1e06161bf49a3a88c4ea2e7a406815be56114c4f.camel@linaro.org>
	 <68631d36-6bb2-4389-99c1-288a63c82779@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-07-21 at 08:28 -0700, Bart Van Assche wrote:
> On 7/21/25 5:04 AM, Andr=C3=A9 Draszik wrote:
> > I don't know much about UFS at this stage, but could the code simply
> > check for the controller version and revert to original behaviour
> > if < v4? Any thoughts on such a change?
>=20
> I'm not sure that's the best possible solution. A more elegant solution
> could be to remove the "if (!hba->mcq_enabled || !hba->mcq_esi_enabled)"
> check, to restrict the number of commands completed by=20
> ufshcd_transfer_req_compl() and only to return IRQ_WAKE_THREAD if more
> commands are pending than a certain threshold.

Thanks Bart. I'll try that instead,

Cheers,
Andre'
