Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B2485644
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 12:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713269648; cv=none; b=snv3rWK/88vwZhWQOwF7wyhMdlFK1vZNeET9Ak/VY6ZHh8O4LRfW81RsXiKPM2e8UlnGzIZMTmLkJ//eex20CNsWdWG5BAhNswNZO/V0xeM2kUdXN6drCJ6nkbfhXxpE4b/k2SxGc4U/ZVQk/zpuCXynDD8RBuyz8wxfh3474WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713269648; c=relaxed/simple;
	bh=48Gr5eNn+Ssi4i2JyFoZuqgowPbwgV2AjpZpW+lUl3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJvYNZ0OH+5swrIxo15Za/72IZjUSuy7MJu8tdcKKkmEfgVl5H5gJl5HBoojhhSFEaQpG4Mh/BZeSBiUWtjTjKOan1m6LPQjOZa0L2raehXtKgCYtrXQcr0SDZgrN25iYwzGihNrx/ufsrGjnw2vYMFfo4sETxZWgRDeCsbSIn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TgTsVXOy; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TgTsVXOy"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5aa17c29ba0so2533465eaf.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713269646; x=1713874446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6x8KfkMeFuCLUkF0VuQt50edEuiXuMJGbYVUcWevqo=;
        b=TgTsVXOy1BpfAVmNZd6pMis8Xm+uhVRYhI58Qf5crvUjjKkK2v9QVI4lbTBpSMDkdc
         pg1Rakbv+OYxgl3xZ88b3I60ow/heXASw5e0dysEHExpeoiAZdCIxAVD1WtzUnAR+yCd
         meOrqtKhi0Zpen295B1WWAqNwm9L7+waTIs/ZNjlwGwlFcjjdZ9CumLzTI+59roVspIL
         L3DYE/ADhw7hpVujQQpAUOsDq3n7CN1UWKyOXcQSHuWE9ZYCyb+ZXkMYq4WRrxjJRhKW
         N4eLvb+KucEpq7wDI2B8ZD2sTNJ2TeI2n06jtbZUFVAHCyrN8OJyuw8zkSJ9IDzYIcyq
         WU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713269646; x=1713874446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6x8KfkMeFuCLUkF0VuQt50edEuiXuMJGbYVUcWevqo=;
        b=viD4Z66eZAHeQRC5uQOaXMaAHwbqJ2/7rjYr9oxBp0/tReQR62avSX1ioRDFmHTU5l
         ALRxRVyHviNMaqkNzYZoSXbtnLPH+liKFwCG0pEQmMaXj4GTpEDVZjhIN7V2Dwth44fu
         dJfBsju8siBTfyvyQbKS817eypskSwkI4iFICJ6FuTx7rH0cC3/kLA3W1L0cRtakBgFw
         mnq8N6YqC3xE31HlpWYTaZJ9HfVV5ClQ3KHk9FWyqAtQAMuVD86gZ6Eda9ovTKDbdxc0
         hg5HPbuU9Y2yCEYkf0w4xmttJU6OdmfahvcJCAgH0ZMtVUyqA9WVELerZ54hBab99vW2
         OAnA==
X-Forwarded-Encrypted: i=1; AJvYcCVnSkz5v1mCjMPaUA424zTwvNu36jcoy9C8Z9YyvppOm3Gn5AgIMKQLGl7TNaiQFAa/duUEXEJ+/nvvjIHx3MlL8uYC2PO89kM09Q==
X-Gm-Message-State: AOJu0YwOKNmMSxRHz90lR9Fhqb9OXmBVA5Ahh04dSDrt+6IOcuqkuTSK
	9T5+zCwPkPUQ+thK6Bv0Tva5FkFazpoQttvD2AWBNtSaf6RSnB3RgsKpPt9hxUPMOOlDNgpbcIf
	dXqU/O1ssQ/blId5qmuNica8tvGByxgUXkZWnBA==
X-Google-Smtp-Source: AGHT+IHjbw9BdGe0LBffamuGVcO3Fjs/dxkO1OlPwbcLBOwnYZIDIIIMJZvaH9S0UdI3wP+pcdkx10/t2jWsgTG3mgE=
X-Received: by 2002:a4a:9893:0:b0:5ac:9fc0:cc6a with SMTP id
 a19-20020a4a9893000000b005ac9fc0cc6amr6760168ooj.4.1713269645676; Tue, 16 Apr
 2024 05:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-7-peter.griffin@linaro.org> <560e9a5b236728f62be4bfd8df187071c4bffb23.camel@linaro.org>
In-Reply-To: <560e9a5b236728f62be4bfd8df187071c4bffb23.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 16 Apr 2024 13:13:54 +0100
Message-ID: <CADrjBPois-nLGkNdXRp9SF2t4xv1fr4MvSK7yT-7GA+QwkA2NA@mail.gmail.com>
Subject: Re: [PATCH 06/17] arm64: dts: exynos: gs101: Add the hsi2 sysreg node
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, kishon@kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	s.nawrocki@samsung.com, cw00.choi@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, chanho61.park@samsung.com, ebiggers@kernel.org, 
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org, 
	saravanak@google.com, willmcvicker@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andr=C3=A9,

Thanks for the review.

On Fri, 5 Apr 2024 at 08:33, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> Hi Pete,
>
> On Thu, 2024-04-04 at 13:25 +0100, Peter Griffin wrote:
> > This has some configuration bits such as sharability that
> > are required by UFS.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  arch/arm64/boot/dts/exynos/google/gs101.dtsi | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/=
boot/dts/exynos/google/gs101.dtsi
> > index 38ac4fb1397e..608369cec47b 100644
> > --- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
> > +++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
> > @@ -1265,6 +1265,12 @@ cmu_hsi2: clock-controller@14400000 {
> >                       clock-names =3D "oscclk", "bus", "pcie", "ufs_emb=
d", "mmc_card";
> >               };
> >
> > +             sysreg_hsi2: syscon@14420000 {
> > +                     compatible =3D "google,gs101-hsi2-sysreg", "sysco=
n";
> > +                     reg =3D <0x14420000 0x1000>;
>
> Should the length not be 0x10000?

The downstream kernel uses a length of 0x1000 for all the
foobar-sysreg nodes, but checking the specs it does indeed seem that
the length should be 0x10000 (and that is what we've used for all the
other sysreg nodes upstream).

Will update this in v2.

regards,

Pete
