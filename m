Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972D197543
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480239; cv=none; b=cPvPpN6uAYbOeJtI8qfzWIUaOZtBKT94+03Nx15oVV/YRBSCBOnfVEiGJk9DdejWmFuBBq2fcAsdLeOYXF2CdjV/KD1cfzxAEnGw6hgwbt1WEEeH6LISkigb8l41mw2Jo9rsyZWd/rmLtrIoCJiez7JhXyTksho1SDJ3XRkEHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480239; c=relaxed/simple;
	bh=hCS7BTVujCtp4m6ljZNLdynbztIjz790mAoDFaqAogs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+GMLOYdA3Q4snJoV9RvYDJ933Ad9i6wTey1QQBUWyAPhtli+icYZ9sw/EUn3RfckNMQLxkuGrMn+CQCVfH3yRjPoAu0RE5KZW71bU6lWsOos9YVxev90tVTu1A13HmKE8ctrhzuAyaxphoHXNWMJ9BG5UXlfXe5vd5uHNnfd8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jd9GIFDH; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jd9GIFDH"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e28fc33fd8eso905484276.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 06:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728480236; x=1729085036; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eKg7bGv/gDwJ8Dj8f1rz2qShUBIy5wA6pg80JRqhvBw=;
        b=jd9GIFDHrIh9UNCbtZ6Hyz7OhPAYjdrg5W+G5SnJbMCud9AyjG9RQPm/WkWVNYcKZu
         91La/RRVirAMuFoReGdRujb7qLKZqcUZbfxukcOHXh7mnFg1neAeJJ2xmAv8KFg5tn7c
         JuuiPqaqCyPUMm6xzW2f7C1Bed5Ws+PeE8knEhuVxCXJ/QrcXCA2fwtzqbkAu8V1farB
         qU1k9TKvzS6Y8cnaTImDebEnFfgmbVYW08xoE7UUNyRRz9fD3pZ/+N70KtYAlr1CUxZy
         3S12fkRXlgQ2D7EwZBf1Xhw9GSixYf2JIdoiqK5R2ChEI+3Ds+7Vr6bxHSklH/16CyE8
         7Iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728480236; x=1729085036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKg7bGv/gDwJ8Dj8f1rz2qShUBIy5wA6pg80JRqhvBw=;
        b=ozMyP8WAjyST9WqdnkYZTUp8l0YVG+QhSFLGVca5R76bFwL45HL47sDohPBrICxfSM
         nIhJDTs5PKjzmgjztzBHMPj3MtnytRTJKTdxphKUkMOIXiq1K1V+OStTdfIX7PztzaF1
         XP8WA4zM3jyYk/FNUVUc6mwVGPdOkxSOh9y2x2V9GAoZuht3HZ5a69dCCMtQMJls4DwF
         n/WNcVZfwYaWsaZ6PcM1pQvwfldGzB9G8C/JCFCJKq4sb4nNKT7h6YcbDay9hyq07HCF
         RMAMPt9Pin5CzZMfWKAbtKnf1X6kDwWac+3B7wjiRzAHE20AWcB19vrCfVieminn4MuG
         +Z8A==
X-Forwarded-Encrypted: i=1; AJvYcCVH9URrvFVYYcBG0y2xuO9vER8wX0chQFN/HZB4zgt1JXNGRHzDxvjaCYocVuV8SuC6bx3bXSnDMg5S@vger.kernel.org
X-Gm-Message-State: AOJu0Yxey8QGNsweNYAr9iRbK4foHFFh1J+TdovbDJsOcGjTEGEyz7df
	gaL3g8V4jpH3I1DPebEOkiQiK1R1kCoMZ8Vga9F1W+fdeCZVahScvC6IKCCLA9x6+W3PNrdnRDd
	MIlrBdAIEfT4Zru2/Vz2tJS6XKBVsU5cd/FX7IQ==
X-Google-Smtp-Source: AGHT+IHdjIJEGNBc42+O7+FXjnfNDEy5mnh1GgAZbWvtts8h8pDmYrsy1bp7WIFON/JsxIYQBTwc7aUIRRTMf2jauEU=
X-Received: by 2002:a05:6902:2b8d:b0:e28:f7c9:49e6 with SMTP id
 3f1490d57ef6-e28fe41eae1mr2537348276.8.1728480236424; Wed, 09 Oct 2024
 06:23:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1728368130-37213-1-git-send-email-shawn.lin@rock-chips.com> <1728368130-37213-5-git-send-email-shawn.lin@rock-chips.com>
In-Reply-To: <1728368130-37213-5-git-send-email-shawn.lin@rock-chips.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 9 Oct 2024 15:23:20 +0200
Message-ID: <CAPDyKFprgKOBGnnvJUvVxXUTPEHGJMXXQa_HssXxEt01aBRoVA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] soc: rockchip: power-domain: Add
 GENPD_FLAG_RPM_ALWAYS_ON support
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Oct 2024 at 08:16, Shawn Lin <shawn.lin@rock-chips.com> wrote:
>
> If low level driver claims to keep its own power domain always on,
> let pd driver respect the flag of GENPD_FLAG_RPM_ALWAYS_ON.
>
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
>
> Changes in v3: None
> Changes in v2: None
>
>  drivers/pmdomain/rockchip/pm-domains.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/pmdomain/rockchip/pm-domains.c b/drivers/pmdomain/rockchip/pm-domains.c
> index cb0f938..b2bb458 100644
> --- a/drivers/pmdomain/rockchip/pm-domains.c
> +++ b/drivers/pmdomain/rockchip/pm-domains.c
> @@ -621,6 +621,9 @@ static int rockchip_pd_power_off(struct generic_pm_domain *domain)
>  {
>         struct rockchip_pm_domain *pd = to_rockchip_pd(domain);
>
> +       if (pd->genpd.flags & GENPD_FLAG_RPM_ALWAYS_ON)
> +               return 0;

During system suspend, genpd may try to power off the PM domains that
have the GENPD_FLAG_RPM_ALWAYS_ON being set.

It seems like you need to prevent the PM domains from being power off
during system suspend too, right? In that case, why not use
GENPD_FLAG_ALWAYS_ON instead?

Or maybe the use case is different, let's continue to discuss patch5 first.

> +
>         return rockchip_pd_power(pd, false);
>  }
>
> --
> 2.7.4
>

Kind regards
Uffe
