Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C79248895
	for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742223331; cv=none; b=spWcgVNHKzyI+Hjezi/JRU4TX1T46cckHuiRqwEfKgtfmypIupvHGZANDL41Zg8uWEgvjlcPA+xhLd3i09KwGeHFLOT6QFUSa7Hl9pE9Ue6OtEzveUdCYg1ES071jVu5vvzWozhDsIbIrz+gmjRhDbcxnLkD984QQsNwUREZ5l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742223331; c=relaxed/simple;
	bh=17UdANjAVTcelMOQ4DNlejZ2Ce9FcJpH2K+ozwWVPTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIny8hZj3E0Kru549vaf/IyGUyra3eivLnrz17sYydUY/332KkB8JawqzmkNMQtZKy7gLSPdM84HN9hcwczbeiPgB1IB8rj/Nmsi3QCosLxV7kmNlz6QFBciOQ7RG0aCcb0/h9Jrld5X6PGMnfaGQ/pYR1+usAulx14jxPuTyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kKvuc1Dr; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kKvuc1Dr"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3f417de5e25so1675289b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742223327; x=1742828127; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jNzh4wPsc/2+sERlQmcDT54HRK5zRLKBArFjwQQ8DQ=;
        b=kKvuc1DryQCbSVaBGLaDhiimzifPA1/+vWy5Oidkrz6z37iZQfnZhJR5IksOTb6bL7
         toTwPj10SzvDwgmRUHhOlYXCJkfenGjgr61NjdUH4Fft6zEhNIRV4U0NmYNzmA6eptYP
         ZkbtLa+0hyJEqzZqMM6dhXqfO3CH7gtQqx0lzVhIugTZc7jW+5z/r73CXfNwnmrmOitH
         dykwAqTiUn6wv1eBlpWafYpH+qeiSlfouu+rQpdIFP4DFC5sXI+k0BhJ+RS3O2LjlhxK
         oUZGPAL900MWZiRBKBGSFKDeHp1lfq1aHNNvtU7hhj9pSyXVhgHNlj5VMQRUe7UHY0Do
         0ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742223327; x=1742828127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jNzh4wPsc/2+sERlQmcDT54HRK5zRLKBArFjwQQ8DQ=;
        b=OH9z/HmxIO64BNy7f7d2y3HEoqux048Hn7CSMSY2Mxmm+QuYOeSVbeQ4Efaesli9me
         gSMnt0X0UBThC4/MYqDiPZXD+aEvDWNzX9B39GusRnsHSnCymsuv1CGtUQMCbNkpUj8N
         CQ490jggmVXf6BsDKHJ5LLfyRGQRoMLs1NEYJvIIUbUbE2dQgyCoFVzBMk1kklQsEVQ5
         GoK7bIN4lSwRyzii14euL1+7eENvFgZjCRoi55hUO9MUM2BjgSjuhD/lcmz92TwSUDUp
         snlhIANQzdygJFufMHzh4Tj7yVhII3IzZrYQEqSdf31c4bEgmqFokJ6vITMxg9LVoAQj
         3+DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUB1U5aBBJ8tZ9iWeZvZZT8nTrTUjUo7RsdqQtzMwG3Xqhh3Nb0NFS2q2ruzhK6WMEbyi8jctjx8/F@vger.kernel.org
X-Gm-Message-State: AOJu0YyRgjkXhB4cwIo16F9BdJqUe5weFAdZGyw2+tBBbZvgS4xd+KmK
	tSmx29JZJo1fpXQol3di9Jwic+UcI5uMU1elTVEDaBnjKhWJKO4Y6QLR42++DlNVaUBwYXHkd4m
	p6++puVgWSNPRir2RsEdgrTo73MxxjN0sh3Dk6w==
X-Gm-Gg: ASbGncu1DqTnSMrCz4eglNXp7THBXaImjKZWr6TsKIXyQc2cAJsL5pSg1x4hShna5pe
	k4pk9l6Ly31ZgKy0ZHiIzNLIOXSiPara10pdmv33eD+Z4qHrNlfa49xvDjpgSlU/o8N4vYHk63c
	ydxaU5qy7souGnR4t+oWiiaP+wB5+jPxoM6v0Vy3U=
X-Google-Smtp-Source: AGHT+IG7IjY16t5eI+Uq4mhx6crav2fOJBQfWeSG630jb10M49QIM1vSar09EM0x1tUf2BaE+e0vaoly2VXwdW756V0=
X-Received: by 2002:a05:6808:999:b0:3fa:c549:cfee with SMTP id
 5614622812f47-3fdee27903emr4770583b6e.6.1742223327241; Mon, 17 Mar 2025
 07:55:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
 <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org> <931e5e0b07d598912712b091d99a636b796fe19f.camel@linaro.org>
In-Reply-To: <931e5e0b07d598912712b091d99a636b796fe19f.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 17 Mar 2025 14:55:15 +0000
X-Gm-Features: AQ5f1Jq4uxqhD4QuKFFVh-mTPnz4ZIKWFOQ5G2m93FuUYrfiK5B9xukpdzF4pCI
Message-ID: <CADrjBPoESd7D4H80prCtFXTGaWOg-HV_ovNdwZ4G7Y8n-hFdsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: dt-bindings: exynos: add dma-coherent
 property for gs101
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	kernel-team@android.com, willmcvicker@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andr=C3=A9

On Fri, 14 Mar 2025 at 15:59, Andr=C3=A9 Draszik <andre.draszik@linaro.org>=
 wrote:
>
> Hi Pete,
>
> On Fri, 2025-03-14 at 15:38 +0000, Peter Griffin wrote:
> > dma-coherent property is required for gs101 as ufs-exynos enables
> > sharability.
> >
> > Fixes: 438e23b61cd4 ("scsi: ufs: dt-bindings: exynos: Add gs101 compati=
ble")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.y=
aml b/Documentation/devicetree/bindings/ufs/samsung,exynos-
> > ufs.yaml
> > index 720879820f6616a30cae2db3d4d2d22e847666c4..5dbb7f6a8c354b82685c521=
e70655e106f702a8d 100644
> > --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > @@ -96,6 +96,8 @@ allOf:
> >          clock-names:
> >            minItems: 6
> >
> > +        dma-coherent: true
> > +
>
> This is allowed globally already in this file. Did you meant to make it '=
required'?

I hadn't noticed it was already handled further up in the yaml. In
which case this patch can be dropped entirely.

Thanks,

Peter
