Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63237144
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410500; cv=none; b=Z/z70jlh7qnqozvJ8Amfwsdn306NRXeg5pp5jS34MqoYBD0EDsJWSkFJIahw73FRO/A1Vyjwr7LP7WS+fRxV7a3Cj1bfqUc8ncc0q/3fv/LiMMv3NyPfj+NJKwqtrZVNwln6n/jb27v4I6JG6rqT3dHTOQScx6crdB3nEqv/5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410500; c=relaxed/simple;
	bh=omruiQm6a5bc66MUXbQR9m5P3TmPXwromhV72gtRPA8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T8X9K6LFXJP05l1HvYAU1PH8X+VJqMDU9tIGaXnTsCKy749cRlvYCU0wJKMGlwSZ3U+hu6Hq8EUYFQ9XpD0NQjAb0zh/zVYkQdyVoY4DANPRJIVKgFUr1mVsxKFRRW3JKBrlFEwJl0V4T+pN6+nO3lMsVt2bZLH+E3VA0botRd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPbz2+gJ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPbz2+gJ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5bed0a2ae0fso2318523a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 03:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724410498; x=1725015298; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=omruiQm6a5bc66MUXbQR9m5P3TmPXwromhV72gtRPA8=;
        b=iPbz2+gJQqPv5x7gnMdzB74+udK5Lz+aAKJhVQokvS1P0vmauS9WKL2eCkCKwOCb5S
         1a8yzSguZUU4Kc0RxL9HIm/WjVHtEUZAtmLg5hfWVHWZAlvpdSqMd7K35pEn/zn8pZFA
         uSylsBcWx3+rnR5wDBkmiwt+ss8/ZgXeicBNCHGSVJVggHJs2flkOyZ1FBLY0YSRU5hw
         hpQHjrjuvMC7Gv7ojAvUTBMwI6dXDF+h+Zf7esiNsAH7pnt49Xq8GLXYooyb+JhxbVBE
         /ZtNEmarRtxKZQQwKgjgHJDf0XK0iVRk2Df5v9FjTVy8lftwptJbp/S9nvdgw/9fkKiF
         EFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724410498; x=1725015298;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omruiQm6a5bc66MUXbQR9m5P3TmPXwromhV72gtRPA8=;
        b=RUY4cRihD66aJpQoL6Gf0/TWibN4eUprOKcLaMlvNz9NjoQp4UsvlpfgUqAnqTUU81
         lITHonII6PO5OK0N4vFHll1CuHWWbMJ/L8li6IoAcGgaufdcxTaQTHqujOeI8Ibrz5DP
         x6y9JLLjY0xQSGH0MPptx7M3UJkzWOuFKnscQbaahXMlSEWv1Z/MG0RUfvJON4Z8W/gY
         ic+zQEldqlwRdhtJuPHR2AfE/aWHOon2D2R2SfQNl9EheHqni8Nx7mklNrcRX+Ge0EAb
         /1l2dFE/gObO9y/eNDo3nlTy5l4TLVnEU84tli6uupgB4Ch69Xw1lblj387DPJ44UuMW
         sX3g==
X-Gm-Message-State: AOJu0Yw6ytuN9c/k2m1F0uOEYpsKkj5yiwJUq8I9c7etUR7A0ztlj5nb
	o4/AlRyiqEzvSSIhcdq8u/ceBiaxVE2VNkVTL2ayUoxbM45cRocr
X-Google-Smtp-Source: AGHT+IGymMQJHR0jLDqcL5AWE+iaajVGADhtsGvJJ+LdcOXmiPyu36a4Rl8ILOA0TlMTk63lrbWTBA==
X-Received: by 2002:a17:906:f58b:b0:a7d:e956:ad51 with SMTP id a640c23a62f3a-a86a52b899amr128447066b.21.1724410497265;
        Fri, 23 Aug 2024 03:54:57 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4360c0sm242595666b.108.2024.08.23.03.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 03:54:56 -0700 (PDT)
Message-ID: <8a81431a90c9c0c5bb0c90deba825284bff55d83.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, quic_cang@quicinc.com
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>, Alim
 Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>, Maramaina Naresh
 <quic_mnaresh@quicinc.com>
Date: Fri, 23 Aug 2024 12:54:55 +0200
In-Reply-To: <4964ac76-abdd-4cdc-b8d0-3484b3286449@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
	 <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
	 <bb2a1649ef94637f236dece7255d497f7fe03f19.camel@gmail.com>
	 <4964ac76-abdd-4cdc-b8d0-3484b3286449@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-22 at 10:51 -0700, Bart Van Assche wrote:
> On 8/22/24 7:17 AM, Bean Huo wrote:
> > Do you mean re-enabling UIC complete interrupt will cause the
> > problem?
>=20
> That's correct. ufshcd_uic_hibern8_enter() calls
> ufshcd_uic_pwr_ctrl()
> indirectly. For the test setup that is on my desk, the code in
> ufshcd_uic_pwr_ctrl() that re-enables the UIC completion interrupt
> causes the UFS host controller to exit hibernation.
>=20
> Thanks,
>=20
> Bart.


Do you think this is only true in your case or for a specific UFS
controller vendor? and this doesnnot mean that all UFS controller
vendors have this problem? Maybe MTK has confirmed this.

Kind regards,
Bean
