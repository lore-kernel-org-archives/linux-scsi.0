Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A22BD11
	for <linux-scsi@vger.kernel.org>; Fri,  8 May 2026 22:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778277911; cv=pass; b=BoySF99IOQ7vuco4jw2xH3qOfRMPhtR1cdCeTl8Imo1D8Qn7QpGUEdd/1NuBWBkDD9Zy+hO3ZiVetknU65PEFD2iyjft8jSOT/TQ/9MYQ7UEcJLZMjkRUfrhXuPKVIac219/9Q/RrIGKpwBYh9Nj9CQehwNOujDWbUQgUselAJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778277911; c=relaxed/simple;
	bh=sFhOkypFgUFtrwO3/lD2eVgWx0KBMQErr2EqNiq9JBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrKriMjXKzDWvr8DiSjrLctKWeD5wTT1SuQGkamV5YqM7FlA4uZ/b9LFfhg/GJkDvs4MX/3mrrYFdYQ9aFH305feuJwjHCd/h/2Qb6+/jpp26lBsLSjpIZoH8o9OvyA0Wxq/tF0NYz6uPo9SR2ZBIbl5rIZOBhXO3Dw4TMY6QBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Te0YCfX3; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Te0YCfX3"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so3578335a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2026 15:05:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778277908; cv=none;
        d=google.com; s=arc-20240605;
        b=WN9mrtW9J6Knyd3DZS8ykgQnHYOgk+jWg+w8crfAayGddAWZSs60NJ18KDonnx0U68
         lr4gxNHkGVQbqW7CeHJG8/SbKEiPGKcRHqPITpOgRQZTSaz8238hnbmjYaMR7u1NzOhf
         CVIsGgIkfKcZ+KRW3RqbMXFomlXONnCI7vGCWclAO9U91BAZz2QEYWBBQXkN/6syT3iU
         O9oPkGc4J4jEoQP41A0VwePdel1PUmd7La0c5U52Ht6kDvMIOSMb6tD6wu12rHV7Jrch
         bcg5CBSrufUdUy325CjXwr0jCVbwxeezrrY2sdXCklaLfqFJ7PX4wgA2ZEyW1aUcGgH3
         L9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9axHN34RSuU5CsT1lGt5XlZGT/hvy0PsddNDcz/MesI=;
        fh=+/aBdto3lehD+PRGv+0xLsiZq0HVOR5ThARCdcyKObQ=;
        b=PBwY2agEHg+1SlSTVhXg3LK8IviQiwKZKqxjRnvcxlxM4ukzzPE5+4pMEanRbTP85K
         N1NQbBjYEu+r4IH5l2V3JvlVPHugd8PO7IbAWy+rCslsNnQ0to7WPVj7xKEeoT11PnE7
         7u9li0WG6ujCgmAckfobKWZNBWOMGjUUVnYLW4IKW2XiyfF/+VcDC3Fmdf45H+cpj7Ig
         RIuPBaQIpfZd85Mwie8Eby3NC2QCxJsFYGRNjZlWlwA7U/3EsbwMbwCQ7z56Ztcywbx7
         gNK+A4IkKjPaWLPscb6d3pnK05HPtU2gH4o4p5FdMX2scdHp01du5nY9e67wKyx/ZyXw
         AeSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778277908; x=1778882708; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9axHN34RSuU5CsT1lGt5XlZGT/hvy0PsddNDcz/MesI=;
        b=Te0YCfX3YWorWj7GscIhG16r7LxH79T+UiD+AsvoWWXWPL+85VG+pjrqtb4Zx/zmNe
         0URm0AEsB/WVu2Vlqs8x39bIGdvfwqWk7ucNGgQ4V23RAHvW6Qa6ILyb8RPVJTiFuvD3
         ik75Hs7UmbZ8TsN48VnjL3/lciUzIp7ZtXulibrc9RwlpwDB1mDyGVdAVvt/Rfc+Ynxs
         rKPE5zO2Qewb3jZ7x9pT2Ced7pF6WffFTdpHp6xuTkPhShZLGzxK6Gl/P0/Np13/kjul
         isFDjs7cGPKlNBa5AVhr0bN897SwuMU2WJGUcNOW2mcDIctbHF2NnC6PzOIIQxKV0XKH
         ZcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778277908; x=1778882708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9axHN34RSuU5CsT1lGt5XlZGT/hvy0PsddNDcz/MesI=;
        b=gMSLo2UpIZCk//i2xTitUNsDf0rMTnAQ0++6nsbDTV0TcEv6D0HDeTEUwJotQKec25
         kJmIh9oXvJl4hBL7KLFDVTQvQ4vsAE5PJU56XgysGnJY/TUeLRknhwcJozDPhjKVh+IX
         ZDiIDkIDWPDmvgf5v5eWkHIH/uqib0FZlIh1vlk/JCtCNx8Sl/fnJz7zBR9/aiTMTYPn
         sYgWLVVwgNKHilvy3VyO0AStwxNJ6na4BGmN4evsPcG64XGodqZa4AqkNjP6/8NXWCpx
         T2armhZKSa80T44OpCbVxQluHc9JQpfbH+h5SjqPfmeW7EwiNkRmFAovme8GkA2PqqFf
         HGfQ==
X-Forwarded-Encrypted: i=1; AFNElJ85jfd9QMgUczf1b8lB+Z6vew79f2vxkwHqsu6ggfe29maGMiXfBXAY5WgYpNWVV0rxsMmVTvZ1r8rm@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw/kFcpACR0JDMyeCmC91peZ/GM5bPwxFaZb8SiXhMlCaHDmw8
	fsfIv/lVCrfci3FY0f+DeusyhTkRV35Zb2mcl3hgjECVGwX30B5fmYxJ0pUkRIpWRL0g20kDyB9
	hIc8agJ80X4kjmMB7x1nqPNz/Tork+aFNjCQLK8uOTQ==
X-Gm-Gg: Acq92OH3zFSsZxPPXSl8VwozewTvWsN5xHy2gYEc0BY/Al/ruVr0aN8VKSARLIKcrtB
	Nv5RAgo8N1bd6Ev1HSUnJRsEMbjUNCHOmH4uygZDt474DHVhHg3DDSFDr7KVYehplDFXY2VCBu+
	csiE+TN6T0KQMJpmT8dNsMqT16rTYeb8XOB9tWlItEI5b31fYRCGlC7zrVxdJiKxJ7SJMbSXAEd
	sk+E1TvaPTF2Y+2vA8bwUkijv26jamYare9UWAkJT3SY/HQ5K+ChASLBYvIeSOdrVHy0bsB3+2R
	Q+RqP86GT0cqDzygmX/ktR2BXkPS3oNyJJEL60dSG0rbvqouZGm6
X-Received: by 2002:a05:6402:440f:b0:679:4b89:d348 with SMTP id
 4fb4d7f45d1cf-67d648b2341mr7555694a12.24.1778277907636; Fri, 08 May 2026
 15:05:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b@epcas5p1.samsung.com>
 <20260417121452.827054-1-alim.akhtar@samsung.com> <20260417121452.827054-3-alim.akhtar@samsung.com>
In-Reply-To: <20260417121452.827054-3-alim.akhtar@samsung.com>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 8 May 2026 23:04:56 +0100
X-Gm-Features: AVHnY4JcC94zWVXrCoUpySC3LgZfp20jXlP-UHsUMtZ7sbT2HpSsWnqgH1G_b7s
Message-ID: <CADrjBPrD1o40K8_seeaQHzqiZRYMVVteMOPozpTVz+q0zGr3sg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dt-bindings: ufs: exynos: add ExynosAutov920
 compatible string
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org, 
	martin.petersen@oracle.com, krzk+dt@kernel.org, sowon.na@samsung.com, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Apr 2026 at 12:58, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>
> From: Sowon Na <sowon.na@samsung.com>
>
> Add samsung,exynosautov920-ufs compatible for ExynosAutov920 SoC.
>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Sowon Na <sowon.na@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>

>  Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> index a7eb7ad85a94..710ce493f3b6 100644
> --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -19,6 +19,7 @@ properties:
>        - samsung,exynos7-ufs
>        - samsung,exynosautov9-ufs
>        - samsung,exynosautov9-ufs-vh
> +      - samsung,exynosautov920-ufs
>        - tesla,fsd-ufs
>
>    reg:
> --
> 2.34.1
>
