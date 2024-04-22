Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAC6147C93
	for <linux-scsi@vger.kernel.org>; Mon, 22 Apr 2024 12:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713789650; cv=none; b=tZ+CWWGj1siXBZnW21y2xexK/TBLGKTJ5QKj6sujD6kxA1n2Qqu6IbyU5bWV5Qrg5Q2XguMVVh6BqQusLRms2jCjEMVbny8361mL97IMZmgX1ZUK5DJRNb6H8vSb/wCvBbhH+AOPUO/nsHU2FX7URX7xWN30e5Ucll1dM6wq/Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713789650; c=relaxed/simple;
	bh=rHwtqOJ7hfOxjOvIBhN3DOgNQntQgRNTBmHT3TVb85g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YImfYO4scfOj6F2rHz/eUFBn/VsFK3EBcJxOQpRcvPqkdY2Ity8J347uL6q2Y1ZXKh9eIEfM48zFyQXOaSUTes4kw8Xsj4TsDAhQhjHGX2sgg9C32IxtQ97pdTw1F5ZoLeZ+u0WAWxmyKTb1gzzW5obg7Xzrc1DxNVX0PHXc44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MB2WIfh4; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MB2WIfh4"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c75075ad30so1411759b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Apr 2024 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713789648; x=1714394448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CG4hPexSWedosu3J2N32I42487kxLi51E4WCYQ7z86Q=;
        b=MB2WIfh4rnpQvPmiUpr5uUnAIHibvLzy+iAN3xVwvrhEaW0XYXtPsUEb+iP/lShDmH
         dtlFEsrvpKGphAw5yaIjDYshejPLgxIQiJYL+WWO4Pdmh2nIqbJoIl2xygXzgocgpx92
         dMH8Oypugo07UY7vrx+JMOtxIHtet4Ecl6Zr1LkMCLo29tX3ypPgmmiTAdNbR/KYB1+s
         KFVky1O5yt7228LjC2k+7AyRUv9N4AyJStrzgWziosLnrhA0Qs68qGgowC2rjSW8x+jX
         ON6rah4tqFo1KZ+8IijvfUGbY8IdSpUl227PawVTzkwib7eyPaHenxFXln/JIl4P9R/n
         O5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713789648; x=1714394448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CG4hPexSWedosu3J2N32I42487kxLi51E4WCYQ7z86Q=;
        b=YsRnTI91+5qsh2mZOr1utqIDR9HwiaG0mK/zGLYjU1Afoc/NMsaBMi0LzZDqZKLGVc
         /d19omiynF+f5/c3S2jD65U1SfZylm6lgpoA1YkhCiC19RKQWwlW9A+IUKsiArOMzAzd
         JpUAdheyAf6O/BVGSwCdYEcQS4G275z48Gv6lsSo4JJwzN12XYSkfs7pOdxrS2anWEqS
         IaOIbqFJf0hdr3CV2ymKn71UVqmSVPkDs9QTGJOFZKyPPov52Z6p8ktqN1vyZ4T6gpy1
         vzRoxEXNkACcV5aIKbZ3yte1sZIrBZfaSBfcURYAwoSbyZBhfzlK+UI0MIMnhcihDg5g
         tykQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjN/s4Lt8YukLM4xlEzyQ8Z4Rq63nN1uV/08ZEqtt7n4oXZTckcblI0k3gC1Gdt4pPmlQfvxG8Sp8HC47goELnt/6RvRJDv6B/4Q==
X-Gm-Message-State: AOJu0YxyL/MZtSldyyeGV8rRW5jIIqKl8z2tV3YZiqEzgLvUbpQOMYSB
	7apfNn0KDAWmvfnAFcuIc58n2AE0OtTah9FZUX5OqO3BxybDADIO6imThgUkUByhENcDhW9s55/
	1TPEzqSNNLGRGUINA5fEw4H3P7Ehfxgy5pV8wuA==
X-Google-Smtp-Source: AGHT+IEMfGJHMTEml1VRNaAfoa4qnzNHZkeLKuW9Vl9je272KzGmuVy0hJtkx+vfLt1IPHkVf/BJiDOJlfCqo09Adjo=
X-Received: by 2002:a05:6870:b601:b0:233:5557:c6a2 with SMTP id
 cm1-20020a056870b60100b002335557c6a2mr14543327oab.34.1713789647808; Mon, 22
 Apr 2024 05:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-10-peter.griffin@linaro.org> <95bcdc942cba564f78a6f2fe4cde892575838d5c.camel@linaro.org>
In-Reply-To: <95bcdc942cba564f78a6f2fe4cde892575838d5c.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 22 Apr 2024 13:40:36 +0100
Message-ID: <CADrjBPrnWzT6raAtuswC0AE6EEwtQ7sTUkm8SjpBh=3nibcmSQ@mail.gmail.com>
Subject: Re: [PATCH 09/17] phy: samsung-ufs: use exynos_get_pmu_regmap_by_phandle()
 to obtain PMU regmap
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

Thanks for the review feedback.

On Fri, 5 Apr 2024 at 08:04, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> On Thu, 2024-04-04 at 13:25 +0100, Peter Griffin wrote:
> > This allows us to obtain a PMU regmap that is created by the exynos-pmu
> > driver. Platforms such as gs101 require exynos-pmu created regmap to
> > issue SMC calls for PMU register accesses. Existing platforms still get
> > a MMIO regmap as before.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  drivers/phy/samsung/phy-samsung-ufs.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsun=
g/phy-samsung-ufs.c
> > index 183c88e3d1ec..c567efafc30f 100644
> > --- a/drivers/phy/samsung/phy-samsung-ufs.c
> > +++ b/drivers/phy/samsung/phy-samsung-ufs.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/phy/phy.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/regmap.h>
> > +#include <linux/soc/samsung/exynos-pmu.h>
>
> You can now drop the include of linux/mfd/syscon.h

I'll send a followup patch for this.

Thanks,

Peter
