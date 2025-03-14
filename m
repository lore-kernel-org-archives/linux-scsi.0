Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730DC204693
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741972616; cv=none; b=HIYaFlPEyx6xg7nwj6tvdy/OMzo2JXOwd4vLI03wHDc/sQDauUOdm1dB4uU3Zo3DGVvYGJTW6uMLteDX+S38JvCk2UYMvzhL+EXavFHpX2/eqACuaWOk7l6P5a4ZtLgDy98HYCgmRpBpLziBYmig/AZ2Ix+1mi1I/cEEmGr2TIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741972616; c=relaxed/simple;
	bh=MCmgIQx9pPLqWzAwKDi73Ci/x2pgTim3gRZat5AGGm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1pzgtYLuajhIu4CPmFMv2QD1bev1WlPq5wrYSecQ620eEg+FSZ4UQdvj2QHEYW4hKwznt+IyKU+B2huKgvixYCZEChBNGHfP8XpTdsUjCG+ATOeBG4mo4Rg7TSw/uUns3RZG5nCkIDBj+/henPkQ4+qFHx5U3hVRxiVzsu/p1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KSXOOM8Y; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSXOOM8Y"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-223f4c06e9fso43879105ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 10:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741972613; x=1742577413; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDdp6JPsZHB45CMyh1swLsd39KS9lz9tRFCDBXIEVj8=;
        b=KSXOOM8Y769JXyxgsQjCdR7R3wDPATpkgTtAdj56BMbLmC1vJizqMZI77b+6DNUkW5
         dJ0hn7cmq83oDb4Z8cgaigxXfm8gVQG0ulxZ3jNdDu1AXG+1BxqrfB16FSLNb7Vj+n41
         A7r7qXgeGR+GERkXNlru0BBST+pos2BNhQplHchjwxysoRfi1gi32fDWRkXEd2UWkNjC
         rhlz2Ln2gV0GPIov9T64c6Wmbv6XNGL5NKsWzDjRKnmsQyeSbMikgvDmLWO1Zvu1o0Zz
         1XMeot+6LTMmCBZMtZtKTispN3RVXFBFrNPw2WqLrFzmYeWhOzTaoh2dIkP3U4NIdmTP
         44fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741972613; x=1742577413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDdp6JPsZHB45CMyh1swLsd39KS9lz9tRFCDBXIEVj8=;
        b=gPfoCu6OofKGAgmoDqMKszx47y165zwqBmiSBU9jv12zjd2asBHeoispJNjSLnN2rh
         uUyErF/j7hsoMdbBbfIqNrg6fb6ihEZH9npS1IeM4gTn0q7F9u/a5Q/ABlSdSImoqMt7
         sHj6FHXskI8TP9ECfbvEMGMUaeKgjd8WJEDx0ExThWHUia26Fgb/dZH64gFXFmHzu1rt
         kF2yaz2CqyeI7QxF+Eh/AVxMmU0uPJYBUmKr9F/VleLUdZvUhZZDShhflGcJ4qVgmwek
         wU4+QTnC7N9sVwl9qHoUwm8YFLkN+fmexqI9k/xyrmYCqNeUFp2qh1D6DjpHsByGFyg7
         L9fA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ6UfVXrUb2GQyDqgBV0kqU/qW857ccZE/XwU1RRFc7FTWsGoFiQepOSrNS6gxvyPjFdEkUAw+HG65@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1T+WZ0g4BMO/IrLyGI7a1ojO4qY86HkvkLIZtDxn3WOywEiRm
	zvbJHtZEbMCnZ+ijnbpkvbkdhAqkzPF1XMCCeJkkHugRGO/1YoQi2JCVzWuiLg==
X-Gm-Gg: ASbGncuImqfFYguMt39+nZQkF4WgB3Y+ylKrzYwDWlhi6nDfULxVFtf2DrwyYSc7qu6
	h2umCBmuQmqkzLWuTga+vAbCZ3VDGlp3PxrPbN3TX7ChOPFTBY+pl3zTw/F9vCno/KEEmIIA0ji
	4VhN6B+AVOpkIT+IFv13mrHUMmQdWOLDHIgtku5g+lKVeUCiTKRCstrXTYzFK3SYjp4DwA5D1AK
	f9TuYkvvv48TZCmlUdcze43NZM2FrKkrowVZZkD3ijlIN7ERg4va++x2+9etygFlfrVP4VKstdE
	8dcONz1KBmP/jNea1OFV2VL3qn7kk+ocZtVtkORPA3JBFQrzUY4vwSThYRI85trsOKjYMm0DFq3
	5fzJ4IKBLizKeD6A=
X-Google-Smtp-Source: AGHT+IESV7lf4zH31HRl2I8byc8Hhj6aLdJrikr6gIoStXmwWR0DzwK8g18nrHPo3RniArFYGonCrg==
X-Received: by 2002:a17:903:40c5:b0:21f:7078:4074 with SMTP id d9443c01a7336-225c6617ddfmr87561165ad.7.1741972613410;
        Fri, 14 Mar 2025 10:16:53 -0700 (PDT)
Received: from google.com (198.103.247.35.bc.googleusercontent.com. [35.247.103.198])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68a84besm31146555ad.79.2025.03.14.10.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:16:53 -0700 (PDT)
Date: Fri, 14 Mar 2025 10:16:49 -0700
From: William McVicker <willmcvicker@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Griffin <peter.griffin@linaro.org>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] Add dma-coherent for gs101 UFS dt node
Message-ID: <Z9RkgY3gnx6Xp0nc@google.com>
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
 <0d7a8cad-adfc-4cac-bcc6-65d1f9c86b43@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7a8cad-adfc-4cac-bcc6-65d1f9c86b43@acm.org>

On 03/14/2025, Bart Van Assche wrote:
> On 3/14/25 8:38 AM, Peter Griffin wrote:
> > ufs-exynos driver enables the shareability option for gs101 which
> > means the descriptors need to be allocated as cacheable.
> 
> Shouldn't that code be modified such that the shareability option is
> only set if the dma-coherent property is present in the device tree?

That's what we do downstream and would fix any issues when booting with an
older DT that doesn't have the `dma-coherent` property set. So I agree that
would be a worthy fix (which I did verify fixes the stability issues).

Regards,
Will

> 
> Thanks,
> 
> Bart.
