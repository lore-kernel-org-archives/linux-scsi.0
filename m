Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D571EB9E1
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767815301; cv=none; b=p8z/NBBBCYfZCZCYA4GEUBgog3MRSoQEHMq28qB214p3XjMqqhzvOkLFbCLyTl3chsEjm8YRMcaASDL63cSL4YmTRJiwvSuVia5rSlt5GAKxchf5zqiDMv3wfo9vbFy4rHwsPipTKD2hflDlv0hYYkrDgYHhukyiioLweDx1+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767815301; c=relaxed/simple;
	bh=Lc2T1gdxupIb0389vEGtq7pPhjXyCJ3fX+przIH5LjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OS+pvlo/mOVDd+PJGRrZO6xB/JFbIRLjR49T7WV5u0MThtXY+f/UySKeXPCxGxuLCbca0nY5u51+Xos0hufy9ZAf2Y9zX3ou1ihnlfz/xgVE7sS/jwgohd9PUt2VWU1roDO5ZLO9Ke5OP6rgAnGOXz6WyXfzJjjAeHggeXeFstw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pHHEkQE7; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pHHEkQE7"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so494822366b.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 11:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767815288; x=1768420088; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/K6KAgx2Put0DT9sjsubOZBw59h5KUnRoaOh5hbz8NI=;
        b=pHHEkQE74Oa/GB9+qYVDeUbr2d76YtBWK0tJsy6ZjwttFDpdSGo8CkGx6MLIovKZ6q
         ewcG+0JU+/jmfSHt0lqmNpb1GIvdWmJJF88E7yRKRW450FopEpBGqQ5KHRbOeHVrNdfj
         8DJpZzpQjwO8TUhxAe2sSWehtSJ2pWlSq2ELV5TwfJB0D2XJvKO+1ETQErv2NEvmnuHu
         tyzyTAAdzoA4h8ta5eXu9Na9BDvoj5n6csPsQbfuVVLEvetDkaLn578BcfMG0ivlfiyz
         2od8aKMZUXEXtHG/FOIW0LpBwDYMf371rOGfHC1DHonID6KcpL77/YV2427C2rn7jxgF
         qBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767815288; x=1768420088;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/K6KAgx2Put0DT9sjsubOZBw59h5KUnRoaOh5hbz8NI=;
        b=Igdib8tKHdQqIPgH+gjLtJysNKUBjybCiMt8h3A2xaQ5SOhH3nKHyQ0Jx45Pebz0e4
         sorfM5IphdSbvNWIddANPhixGZgDxaBZkOGVF7ODMgL/Gb1kDPZaE6/vtVZZoeiHiORE
         LrkyauS5swaDjaGFWSf17SvlbrLcLfslfEnyKYvQ3hpCegZG0+GGXhB4DVzkEtAeoeaT
         b9TiUTJe18QvJxagBEw78g3NSU8lXE10Gcano+D6EVHFJF/zqIut84xXTbPBSdRFzdOz
         zBhQVb0WG2GEtAamqEd1t6ZpOmsxoQNrKChENX1F856aSRa8DwH/gcVr5Iv3GGusbLXA
         92yA==
X-Forwarded-Encrypted: i=1; AJvYcCX7F+6uv0l5hGmcPFfbvMddGP/HPr/P3LwFm2zJeHLu7NXnQj9YtLOY0FGGeL2eVKWxUvYF/Av2XBeW@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8oJEW9mUosUrC4A2VxgPkTnb8sORwHAbfvjwnfYvcKneJQp6I
	LGe3l4zfOkHqXpGs0GSd9U3dIFXrfOW8vT6xm0YQs9MQYMPBhvcWU39fwMmvth7qB+ZeM1oGJFg
	2E1v9GnxX4uSyO1Ea7Dlgi/kCgvBAtzL78QQI6c+sCw==
X-Gm-Gg: AY/fxX5yDewsvbJc91U5A7rZtzp56qWYoRIydxo+mzh/mI3BPM+E5XQ0M5M823XAeRQ
	yMJ5UXGdkNSXxQMGyjEuFHgL4T3/k0u/B/vHrb+xeU9LAyrgWwGTK5ZJR1ccMywJCWUi5WnZIht
	/I4DkaNW60rCp47CO3oxnh7sO93WCB9phTUq6RNZwJqQ23qDYO7pWDf56p+RjpO7IT4aI6hWYMl
	m73yMq3L97xjk9uj+X//xya3OfOavwJ2erT8hUnpKnxV5Ih/O3tmEEBaSpCRWW1TLwf2q3D
X-Google-Smtp-Source: AGHT+IFS8rYL/AwaODNRa7WfZUsg/Y0giyG2o55Sn1z5plGBNfdHP68B1+vhS5dmZFmSvNPRKxpxiwnrMPyF8mdrh24=
X-Received: by 2002:a17:907:6d10:b0:b83:246c:d125 with SMTP id
 a640c23a62f3a-b8444f4afa7mr340640866b.41.1767815288230; Wed, 07 Jan 2026
 11:48:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107-ufs-exynos-phy_notify_pmstate-v2-1-2b823a25208b@linaro.org>
 <7c3c2687-12c8-452d-86d7-78b3168a8f01@acm.org>
In-Reply-To: <7c3c2687-12c8-452d-86d7-78b3168a8f01@acm.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 7 Jan 2026 19:47:56 +0000
X-Gm-Features: AQt7F2p6LRb1LMUUf4aCL3KFPPbvN25P8eOfMmuUIQfOW1bNMu_kGMWDfFVqouI
Message-ID: <CADrjBPrAr2QKej+aVQQua=DKEWNdkdLtPV_7L95Hj7L+kTv-Hg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: exynos: call phy_notify_state() from
 hibern8 callbacks
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	andre.draszik@linaro.org, willmcvicker@google.com, tudor.ambarus@linaro.org, 
	jyescas@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for your review feedback.

On Wed, 7 Jan 2026 at 16:57, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 1/7/26 5:51 AM, Peter Griffin wrote:
> > +     union phy_notify phystate = {
> > +             .ufs_state = PHY_UFS_HIBERN8_EXIT
> > +     };
>
> Should this be declared 'static const'?

Yes, good point, I can update that.

>
> > +             phy_notify_state(ufs->phy, phystate);
>
> Can you please ask the maintainer of include/linux/phy/phy.h why
> phy_notify is a union since it only has a single member? From that
> header file:
>
> union phy_notify {
>         enum phy_ufs_state ufs_state;
> };

Originally in v1 it was proposed as an enum. Some feedback from Mani
was to have it as an 'int state' and let drivers pass their own link
state values to support multiple peripherals. Vinod (phy maintainer)
wanted to lock it down to stop any API abuse (see
https://lore.kernel.org/all/aICKM-ebp9SMAkZ_@vaman/). So we ended up
on a union with peripheral specific values (of which currently UFS is
the only member, but the expectation is more will be added for other
peripheral types).
>
> > +     union phy_notify phystate = {
> > +             .ufs_state = PHY_UFS_HIBERN8_ENTER
> > +     };
>
> Same question here: should this be declared 'static const'?

Will update to 'static const'.

Thanks,

Peter
