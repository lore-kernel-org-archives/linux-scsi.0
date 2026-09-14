Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F0E469850
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789395143; cv=none; b=GjOQ8gMkJVn2xBWHq3XVk37kFX7GHPo9nozUKA/Ou62F5IcWf+M4FwQFM2dx0HSdmqP/DHu2UZfxTmeDw4j9o43UGno53KpOTAKg+EnyE1TNsdXcvjBVVViqDKkP12962KLpT8aASkJVHykh97k9pep/kBo7hydpyo4AyyG5HRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789395143; c=relaxed/simple;
	bh=8ceMByd673naR3PwEiJsfobu32L4XCtKVcpdbpqYa5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdHN5LevoKXL7A5oDL+OMX4TYDjqijQMo71AMS3QJ/gwJ4oIJoenQ3Guix4rSrHpncS8ySK4DrQtZMkWvSI79q0uwElfRQzz9HsA+pBi+z14cjenvICL0r1+vKK0I+V7S4YTUtHfhvRNDwX1OpnL0nisgraf/DVLSvsECZrja7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5c83fbd23a5so3002778e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789395133; x=1789999933;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/0GO/2vfF/XubgIzu8oiJogl7L+f/XkIHsO6TluNVPc=;
        b=llkcdjQGDdR/YNxDvIl3uwxYiMWLgvitYNy9fR2AovFREaorJJpPENObk5i2QDxOeA
         yiTqqeY/28sG/tslmYC7GLZq3vmjJqJjygstkQsBkKoPv9AjnjKV9NvXYWFKUlPaqakK
         lF3ou2LngN6tf0raj/VThetwr+DFap5+KpS9qG+4FBydZBHHU/BHPCtS9FA3OyIMrTku
         /+FmR6+FuvRHL/ePFRRDXcgQi0HW0DMq91kVfU2oO9Kq04qRt2Sf3higFWdI4NOJOoqf
         THZgo9uEa9tMNU9Qqth5skTEcFd7x9N3b0KXWAyPr29yLii3ieObyPzx4pmXx1/hij1z
         HKww==
X-Forwarded-Encrypted: i=1; AKwUvBzaXrM7Byu6+6pwlqpA7Rh2o17CU6GFXqgb2DRk0UvNyNpgB4SoBc4l/lT25EH3iqFNCdNtr98CUCjD@vger.kernel.org
X-Gm-Message-State: AFuF++ld1DWMj952o48lyA7avxCEjU6hTgujuHoDtIG8xQExQJTRCd0E
	/0p2KHWRq8ZZY4vuvth5nolAvRQxuiVE9qN6wVxguFxMUBS3RN+Smu6CyzCXjkgX
X-Gm-Gg: AYBFou2obEpI08tWxAez4GhCc/cz2O0g2V6svLHPaLFPelZqQOit64CV8eTaZsfHrO2
	yeIjCm0bNmEYtlEIdEeS5WiWIcKt+ng3+OiYHiF9VtiQKUbFR9TqCumxw3QSs9UzhfeZoVpxA2X
	SaRHifmFuT2zKOV7JM36mwEJ/MNWk0kiCjKlJmeR0bqh4rS2QyvVA+BoS0UnfqlEgWXGN0GduSR
	Nmq/a0uD/RrR+yrxhVzC5ZsS0clh2yrfvkqOWXRSJ+0EgQdYK2V1sMJniR01NUroVbw3xHuAqmg
	/IXdUhNyE3fBLgw+YxST4sXB5Zf5NXd8/2bDPEoLAwhs3WrDgrysSxMrID8SzgoQQPpL3oo3065
	YW1oWNKm8YcEJxEQbd32c/9lw4cWcL6Qy4QnT8ROKd8Dsqa4xVSm7lc57dkW4Oh1Z7hbGRBQNla
	yWyK5uityWiitu2B7alep3JDarW4zdBP4+xZkRK8af373jIh8RWS7PmQK6h6LwhKsA6p5nvjtLb
	N6u4219jOHsPdrDM8ChBQfa40cRa+UetjTFF7qRJQ6j4CcFSaY=
X-Received: by 2002:a05:6122:f07:b0:5c2:a30a:1a08 with SMTP id 71dfb90a1353d-5c97499e4dfmr2601411e0c.2.1789395133406;
        Mon, 14 Sep 2026 07:12:13 -0700 (PDT)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c84714c380sm11785960e0c.15.2026.09.14.07.12.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 07:12:13 -0700 (PDT)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5c83fbd23a5so3002770e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:12:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwnz+maQinniATTOuhBG97TDWB1YcdmvgfLVrV6P/18+ir5mvqDzQ4yZvrfYzqFuTv+Y0croPFh0MqP@vger.kernel.org
X-Received: by 2002:a05:6122:5315:b0:5c6:65e5:99a8 with SMTP id
 71dfb90a1353d-5c9749fed16mr2500859e0c.3.1789395132980; Mon, 14 Sep 2026
 07:12:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911073058.253000-1-den@valinux.co.jp> <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
In-Reply-To: <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 14 Sep 2026 16:12:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWDJac0Soob+Cf-dgwWPBpGrfCwHDN_nWTyE84pXJSoGg@mail.gmail.com>
X-Gm-Features: AcwNN1Uyp_yKSLQHdhola9oXjT2PLkCEjRN0YsdOH8kD2k3alY3_Suk4gIB3dpw
Message-ID: <CAMuHMdWDJac0Soob+Cf-dgwWPBpGrfCwHDN_nWTyE84pXJSoGg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: renesas: r8a779f0: Set UFS lane count
To: Koichiro Den <den@valinux.co.jp>
Cc: Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Marek Vasut <marek.vasut@mailbox.org>, linux-renesas-soc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Palash Kambar <palash.kambar@oss.qualcomm.com>, Bart Van Assche <bvanassche@acm.org>, 
	Shawn Lin <shawn.lin@rock-chips.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 11 Sept 2026 at 10:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, 11 Sept 2026 at 09:31, Koichiro Den <den@valinux.co.jp> wrote:
> > Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
> > during link"), the following error is observed on R-Car S4:
> >
> > ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
> > ufshcd-renesas e6860000.ufs: link startup failed -67
> > ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
> > ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67
>
> This is very unfortunate...
>
> > R-Car S4 has one UFS lane per direction, as described in section 152.1
> > of its hardware manual. Without lanes-per-direction, the UFS platform
> > driver defaults to two lanes.
> >
> > Previously, the core used PA_CONNECTEDRXDATALANES and
> > PA_CONNECTEDTXDATALANES to configure the link without checking them
> > against lanes-per-direction, so the missing property did not prevent
> > initialization.
> >
> > Explicitly set lanes-per-direction to 1, now that the validation is in
> > place.
>
> Given this breaks backwards compatibility with existing DTBs, I think
> this new check should be relaxed iff the DT property "lanes-per-direction" is
> not present. Are any other platforms affected?
> Possible solutions I see are:
>   1. Skip the check completely, like commit 06a34d9c1f47b923 ("scsi:
>      ufs: core: Skip link param validation when lanes_per_direction is
>      unset") does for ufshcd-pci?
>   2. Correct hba->lanes_per_direction based on the actual values of
>      PA_CONNECTED[RT]XDATALANES?

Both solutions would modify the core, instead of the platform-specific
driver.

> Alternatively, ufshcd_init_lanes_per_dir() could override
> hba->lanes_per_direction to one if "lanes-per-direction" is missing
> and the device is compatible with renesas,r8a779f0-ufs.  Or perhaps
> hba->lanes_per_direction could be preset in ufs-renesas.c, and not
> overwritten by UFSHCD_DEFAULT_LANES_PER_DIRECTION when non-zero?

As ufs-renesas.c does not have early access to hba, I went with
handling the quirk in ufshcd_init_lanes_per_dir() in
"[PATCH] scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction"
https://lore.kernel.org/ae0cc2bd764e6dfffce99db3d8b44a55887c508c.1789394185.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
