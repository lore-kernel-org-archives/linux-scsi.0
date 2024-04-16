Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5EA12883A
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 11:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713267059; cv=none; b=s4JFSo6z37IDyyjolS8pz2efaArUyKrh+m3aozzaFj+x3wNy9tTI+nChQCbcaBkxma0Xu0KSpyj0ha3rKc0o2TBUuqWNKv1IIZrR4neFCh+eS+xQEnwpq63n01Sh7vS1k3qj2A8g8MwZfIt17BDXNDo9Za9cnuzqCJuQ/It2CB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713267059; c=relaxed/simple;
	bh=BhYQpL5bGevV2GbZmVaHlpnX2k1YiBVKJ9EsE9n0Jyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S5qViyW5OlphyPkiAHbhEq5UA58GZfoM+EuIwPFGw4G5h1+iK+wbMe2vYZE/392wdwdKlp1Bekil9emck29BEmaY4teuIGN7NT29Pb6wMhCJEWrCRiTP0Ntn4IeN2lT44jE4ctufzcVgGg2cFHKeMEsNoY/8/uutpRA6mV3GPWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oypMd3+p; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oypMd3+p"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5ac5376c4b2so2662091eaf.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 04:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713267057; x=1713871857; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C99IZrp/03ZNQcNBczYUdY5va9+oRjMXPShyuShNODA=;
        b=oypMd3+pV0Vtey9rUb5SwLMcQpTtQgbSt7kM0kyc7JzklKiRsNcIBeo0zGIoAzypEQ
         3Kt/iCiWKQe4XaR2xMxwibJZTA+Z5YjUQhx2OP67Jo7IQ0U7EVH+7IOAhirM7oR5loWb
         zElg4BW7qS3m30r98jwzyo0Er2aN9eekWTqfiOuWoiaMFJeoPvw+nYii4Q2dLVnjemZ5
         zSrZ/YlH+FqJ9A0goXuQSETW2swhR+7YUgrTPL9wgZqhSxLO4f7gwTT5vTvSo0tdBrE+
         hdeatjuLwImvFVZWyf8+js7BBILYofLE1+0z+wH/8XHZtSceE/CvxX1J/BRXDSNyxIfT
         uqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713267057; x=1713871857;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C99IZrp/03ZNQcNBczYUdY5va9+oRjMXPShyuShNODA=;
        b=WdTEcDUTpreQZ/HT4PGk3vYQiidXql8+pJx8P9yrrSPczIGilKNTHAv5uAIljbTNyz
         E7WfVLDO1nOc3dsb3VNidlLQe/mDXGVidKCjeZt9ak8jCY8J87/GiMV/YPqQQDqV7jFj
         stJaVu3RhCB17f3BJaSGwxb9MqgOkSi/8pBkzIkvxg0a+yCDC7hu8jygg4sHwSp5iCcI
         +fkf5rjxmkjxlHJ/3nGmr4c5I452B5V+JyVAJz3Tf+t3182/iOZLrT3RoyV1vKGFf3eQ
         CqAXCLit1No14zysuwQBv4yGpP6/pKgpxwoJWzUr09kSsexA0airlgsxwcHWh9mSsH5u
         1RWw==
X-Forwarded-Encrypted: i=1; AJvYcCWe5iSVqvqXWm5FkTedW6GdUaYcAqSOPXAE6PreaLNkg5V04lTrp5Eo/L6ulcAy9OKO/+qsAbIx2N+Kdo0OKnsLEFzDO5FxbagJcA==
X-Gm-Message-State: AOJu0YxZ84vi2p9CX7QHWyWucciJooJ2x2F1rFs6C2FQ9pga4OzNum9G
	ZuDZCgJ4tk9KJgzPhph4GsCVgAH3POQwJDtu+YPJO2FC11uRUPzRf7UX869/c7pCDTe4jf1syye
	iImdah5y6WQ/9OAJg/uM6FKpqZHIoufZiUtax9Q==
X-Google-Smtp-Source: AGHT+IHHl5CehcMHiAGofB/MGumUwf+S69MfIMUrqcYu9S1e+tFfuYa+Ox55juYnjaCvhTxe0MHk6mCUuL3AOdxNCzc=
X-Received: by 2002:a05:6820:250b:b0:5ac:5c78:390e with SMTP id
 cr11-20020a056820250b00b005ac5c78390emr10859247oob.2.1713267056734; Tue, 16
 Apr 2024 04:30:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-4-peter.griffin@linaro.org> <a82e9859-b74e-44e8-a256-317b8c3fe6b7@kernel.org>
In-Reply-To: <a82e9859-b74e-44e8-a256-317b8c3fe6b7@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 16 Apr 2024 12:30:45 +0100
Message-ID: <CADrjBPouYqYJo8m4_=oCXEi+2208+Gt_Gn13Y3-9V587HOzc8A@mail.gmail.com>
Subject: Re: [PATCH 03/17] dt-bindings: ufs: exynos-ufs: Add gs101 compatible
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, kishon@kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	s.nawrocki@samsung.com, cw00.choi@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, chanho61.park@samsung.com, ebiggers@kernel.org, 
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org, 
	andre.draszik@linaro.org, saravanak@google.com, willmcvicker@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

Thanks for the review.

On Fri, 5 Apr 2024 at 08:49, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 04/04/2024 14:25, Peter Griffin wrote:
> > Add dedicated google,gs101-ufs compatible for Google Tensor gs101
> > SoC.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  .../bindings/ufs/samsung,exynos-ufs.yaml      | 51 +++++++++++++++----
> >  1 file changed, 42 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > index b2b509b3944d..898da6c0e94f 100644
> > --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > @@ -12,12 +12,10 @@ maintainers:
> >  description: |
> >    Each Samsung UFS host controller instance should have its own node.
> >
> > -allOf:
> > -  - $ref: ufs-common.yaml
> > -
> >  properties:
> >    compatible:
> >      enum:
> > +      - google,gs101-ufs
> >        - samsung,exynos7-ufs
> >        - samsung,exynosautov9-ufs
> >        - samsung,exynosautov9-ufs-vh
> > @@ -38,14 +36,12 @@ properties:
> >        - const: ufsp
> >
> >    clocks:
> > -    items:
> > -      - description: ufs link core clock
> > -      - description: unipro main clock
> > +    minItems: 2
> > +    maxItems: 5
>
> Keep here minItems and:
>
> +            - description: ufs link core clock
> +            - description: unipro main clock
> +            - description: fmp clock
> +            - description: ufs aclk clock
> +            - description: ufs pclk clock
>
> >
> >    clock-names:
> > -    items:
> > -      - const: core_clk
> > -      - const: sclk_unipro_main
> > +    minItems: 2
> > +    maxItems: 5
>
> Similarly here
>
> >
> >    phys:
> >      maxItems: 1
> > @@ -72,6 +68,43 @@ required:
> >    - clocks
> >    - clock-names
> >
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: google,gs101-ufs
> > +
> > +    then:
> > +      properties:
> > +        clocks:
>
> Enough is:
> minItems: 5
>
> > +          items:
>
> and drop the items since they are defined in top-level.
>
> Your original code is correct, but with my approach we keep the list
> synced between variants, at least part of the list. If another variant
> appears, then maybe it will go back to your approach, but maybe we can
> still have the same clocks and their order.

Will update like you suggest in v2.

Thanks,

Peter
