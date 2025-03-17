Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E075789D
	for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 07:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742198263; cv=none; b=i1CMBuWWy73FXdW7wKD9YTGD5w+GVsslsviTQgrD846AKkgPLUqlFbNO17RVFyA2Qa/sf55K6O+tisWahhZNv2KxXLpC9woAeFdRG8qBr1nlO9BXZKlBq3HXiPh44SITXFWpOJfZn/RLMiSFVU0gulIPc3Oa4GvbYPRgU65yMgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742198263; c=relaxed/simple;
	bh=PP5ZjBbMb4rni+tuZHNcnT/n1v2QA3RZnXHRssAeFG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f8AzuLxnWzzDtI2BvOGWSJQp6c5sdZGItd885tVcmEEDkk/5pUR05CCEgeAe1uvMjhkqkeEl5QW5DSKVtyKqBDfaZRdp/ad0b+CIKdQijSlAZY6dN3Gk5sHC7B0zAPh+nf8h8XtpK/B8iiPk0jc/vyzlAGbarQcefj5zp3/FSoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lq7GFlPE; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lq7GFlPE"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-72a145521d6so2968575a34.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 00:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742198260; x=1742803060; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PP5ZjBbMb4rni+tuZHNcnT/n1v2QA3RZnXHRssAeFG0=;
        b=Lq7GFlPE4OX23sxWifNP1Qiol6895OF7ONRrAE1CAJpzuXwG/HPlPoSScQQb3B8L6F
         Gt7PGsZXbJ/oUYRzNfBCx+6GvszxlxDad7gNBRVvoH0+XJ4RD6rkJJ/Nx/VF9RkSmKfQ
         c/PWIqsk/e1Sh7iqT93Z4Edfr2RV506rMPtu8Q990iuqdQFuE0t2PnJZEp8eBw2umcof
         nlODuquZOCbnWd2LIm0JrnEK1cXIyGml0oDPeTqO5ZN6OMCpizksot7lvAclrE9XORVf
         2bWB4qPr0DyrZHczVcmhYKrFXCzJIl6KSKYzq8PgWOBGWW9MicfPvlERaLtXxSVfB/dr
         Jt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742198260; x=1742803060;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PP5ZjBbMb4rni+tuZHNcnT/n1v2QA3RZnXHRssAeFG0=;
        b=VM/IhkZ1C7TbGWEgw+tZjCOCKR+nrR4fdRqjTXnZECKTrqG+NktsF3wIFchsDQqCNC
         QZTbJaWcSzfsgcMiA4NEtuqv61giSYzYQ3sgkKh80TobTz+/DTR38NyhAMqQrQnxLH69
         MFPMj+SXL/csYcEuu4M9LDFea5fnP+TLYqlvWaa8U/1s/lPcTohA+E7SnpFS+3tXg3Rx
         ERlSQrA6GgbPrHjXGt6kNRxcUBWn44dBPXmCeeItyIH8bHbq3GWWZbh6TFjhpENOMVoX
         +j4C/Wmwh70ujDTGeggJxC9465rA1dKcciUfs0aZrXOdjuJChRcv6wkOB8H7cSxNrcYa
         HnHw==
X-Forwarded-Encrypted: i=1; AJvYcCVJe/NO29DOJAIM5xvb06upms+HbcQ7ACi+WUHa9gQjGlSYVuBkTmJIgrt4ypvoIzgJswUEuigpyxs2@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6S82YY9lBc4/GCmaRYMEdVsPttHFrEF0H7cBmL3BkabXwo8i4
	jOI+HmkpS+7cRD8AFki2x218vIVNKskRwKK34+VfbHWAW7tgLGAu7SAGi/t0r/xlda1KyjP0jnd
	zLNsa8F1FCoipHo2pTV0b4g0k7KWNN4DM0xx6hw==
X-Gm-Gg: ASbGnctG1/FDGy3EPqyKWUHsss8jp1xK+xZJnNsCsMsu22sCOV6eZYw4tZP10Mh840w
	xj00m6ya9z1CXKfoDO7CdIoisKZWPa5mY/hcvUAmdK6dmBW3VG8EGX8BwsJKA2UkQ06I3s7VWzv
	UXWvEKLb07nkalYu4s6M01KZV7e2dk
X-Google-Smtp-Source: AGHT+IFXhiV5/jjRM3lIL1BjJLxFk/oc1h/PBdMxRCXg6fQlEslHNKm2pE2ASn+LBLRiqcHrD7Lf49zKnfDqLjjJWKY=
X-Received: by 2002:a05:6830:441f:b0:72b:782a:56d7 with SMTP id
 46e09a7af769-72bbc5222a2mr5673623a34.23.1742198260554; Mon, 17 Mar 2025
 00:57:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org> <0d7a8cad-adfc-4cac-bcc6-65d1f9c86b43@acm.org>
In-Reply-To: <0d7a8cad-adfc-4cac-bcc6-65d1f9c86b43@acm.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 17 Mar 2025 07:57:30 +0000
X-Gm-Features: AQ5f1JrHrLaWNOaDw_CRYMU3X3v2oxo4LzPuW31oNjLmnPoqXZ9Expwo9ns7s28
Message-ID: <CADrjBPrU1Prw9NmWrVQff+X6VTY4PXEr_BH2Z0DuAr=uiaOsGQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add dma-coherent for gs101 UFS dt node
To: Bart Van Assche <bvanassche@acm.org>
Cc: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	kernel-team@android.com, willmcvicker@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for the review.

On Fri, 14 Mar 2025 at 16:01, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 3/14/25 8:38 AM, Peter Griffin wrote:
> > ufs-exynos driver enables the shareability option for gs101 which
> > means the descriptors need to be allocated as cacheable.
>
> Shouldn't that code be modified such that the shareability option is
> only set if the dma-coherent property is present in the device tree?

Yes, I plan to add an extra patch that does what you describe into the
v2 of the UFS fixes series [1] likely later today.

I sent this out separately for Krzysztof's Exynos DT tree in the hope
he will pick it up in the next -rc as this patch fixes how the driver
is configured today, and is also still the configuration we want once
the driver changes land. I should have made that a bit clearer in the
cover letter :)

Thanks,

Peter

[1] https://lore.kernel.org/linux-scsi/20250226220414.343659-1-peter.griffin@linaro.org/
