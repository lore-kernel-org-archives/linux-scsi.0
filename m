Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF660463B9E
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116317; cv=none; b=cZGSAw4oFvKFqIdhhdCpp0Fuj0IsuLLab0kyHODejtJONArUIfBTXKcistn2pdtx31bGv8CzZdIN0A/w9r6kgpZ7GjjV0z7zIpiQW/3corQi9qrw0hUjMoHY2eJDiOsjfz3wHBcjDkJrW4meMsjSGiso4JulFIIpBTHMDPWNcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116317; c=relaxed/simple;
	bh=h5QtskLdwN0aOposRJmsMlXcFaOCxlrGFlXawJuLUoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BLfJ2V7F26LiSWmc72P26/6j741yR01oRhmUcO30e/BD1gNGkg1vnabuDR1tPF/lszQcdVYgK/EaQT1/MkZ1Or3V0za5/MMFoOxhggWRKd0XbMnGV7cbAz1l/DtJLodltt537Kfh+l2lPj0WgbxB7mUPQjJISOpS9QEJeFJWor4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e5292fdso237058e0c.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 01:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789116308; x=1789721108;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dFqCzfESKQLEVO0Bv6rt70nL97v3lPj6zjiKBmAFaxk=;
        b=A8m9Fl05CYVpvAuDrZNyjMQLicZMmozCuyQ9ocvXTVQt4aO3lePlxz3fBpxHlP92UB
         CXbX/zW+rvt5oUuBE98iY+A/kFyIDYxvmajVldIGVwezqKgLv1f4QVUZbr0UTctLpwa7
         lbIUkVdLWnmPkjKnzD50j9OuWTodK9hyb2lU7rZpKiLDwu1fohqeg+hRcWghaUiA5+Bo
         pnZem0RsjMo1C1E4HjuXHCMdZfkctfSbirYP6KsPDDm8TMnA2aqGD4WkoWkwZ0sJjhQb
         dkJNvWRQnpSm8PSUd5LFu5MuKup5SyCh+5IV5vtTTiAZIfoLKim+Abf6XOmsgE5W04wk
         TbrA==
X-Forwarded-Encrypted: i=1; AKwUvBwtxSkfOFBDhvDOa6N/acJtfz+S4L9TksB5aVZedJKKyXWf65Un7TaXatVOfnCOQR60906L6AWvTT+p@vger.kernel.org
X-Gm-Message-State: AFuF++kPGXOGu7NKmvgsOVZT4Lb2vWATf6qp/25X3M0P+B5WTAkN+r9V
	I0wJAd2qGsGjttC3mCOvGzv0XarBQJlX1djUu8M67g4rtQcaCLVoV7o3GB13kDCD
X-Gm-Gg: AYBFou0EI9YUg7BBMmQnKpRbwRSLW6uzW4BaziTEYPZFT6uFsX+CmoL6fUHqI119x0k
	xCv+n03PWYYg7ryoWFGPqC+/PckwdHk6Xr7w7g0sjTpTJ+1hC97cgYQoLnZaryvanA98IU74QGe
	BK6B1JzNETFdtWaIU75WVtYSkO++2UiWxD+1i8k9Mh58QgWA5EeVc/SgACYqvJLHVST+5RvFZcI
	TDgVE6oroUrOF9yDUH2CNWvwk80+jym+nkoyNhb5X0BHMQACOIf2uzJFxSaU+p747a6n5Ih/PCb
	shHF9Qi/D02wLudVkI9T9klBC9fMsRiEyAXpULnU4obev8C1y3upzomm0ca9zhaTFjDN0nUt5HL
	3Op+9hHog/k+dSoXvmhBsc6tUR4Lb4R9sNlviRs2l+vqIzrtlBVx1kJm7sPm0LNebJNiH1oq2QK
	Jt7ADXy5h5lrB0GsIAHlcUuIyYgZXqWU76e0JxdNmONtQE1pTfYWp5oFfgWrqts/2tQATj/Kf9Q
	VVCH3c+eQhiUyLQ5CkKuLwl/Z8A7vpPE9fe
X-Received: by 2002:a05:6122:3406:b0:5bf:8955:a8ce with SMTP id 71dfb90a1353d-5c84606f533mr2223309e0c.1.1789116308075;
        Fri, 11 Sep 2026 01:45:08 -0700 (PDT)
Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com. [74.125.227.12])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c8470add08sm1967830e0c.3.2026.09.11.01.45.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 01:45:08 -0700 (PDT)
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-791a9878aa9so201890137.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 01:45:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5omKuqdochBQns9L43ce83i6i0ZE6wf0cddzc58vG77XNkeoa0Rg8nnYLYyHZTf9Qx6jF8UTwaMl4@vger.kernel.org
X-Received: by 2002:a05:6102:2907:b0:789:3f43:645b with SMTP id
 ada2fe7eead31-792a83eee14mr1339655137.2.1789116307687; Fri, 11 Sep 2026
 01:45:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911073058.253000-1-den@valinux.co.jp>
In-Reply-To: <20260911073058.253000-1-den@valinux.co.jp>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 11 Sep 2026 10:44:56 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
X-Gm-Features: AcwNN1U9x2Dw0_q7aq6BSLyw8iIHJUaRM391u6KpE8PvZrGWtybbNLMNuLVxPdU
Message-ID: <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
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

Hi Den-san,

CC ufs

Thanks for your patch!

On Fri, 11 Sept 2026 at 09:31, Koichiro Den <den@valinux.co.jp> wrote:
> Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
> during link"), the following error is observed on R-Car S4:
>
> ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
> ufshcd-renesas e6860000.ufs: link startup failed -67
> ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
> ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67

This is very unfortunate...

> R-Car S4 has one UFS lane per direction, as described in section 152.1
> of its hardware manual. Without lanes-per-direction, the UFS platform
> driver defaults to two lanes.
>
> Previously, the core used PA_CONNECTEDRXDATALANES and
> PA_CONNECTEDTXDATALANES to configure the link without checking them
> against lanes-per-direction, so the missing property did not prevent
> initialization.
>
> Explicitly set lanes-per-direction to 1, now that the validation is in
> place.

Given this breaks backwards compatibility with existing DTBs, I think
this new check should be relaxed iff the DT property "lanes-per-direction" is
not present. Are any other platforms affected?
Possible solutions I see are:
  1. Skip the check completely, like commit 06a34d9c1f47b923 ("scsi:
     ufs: core: Skip link param validation when lanes_per_direction is
     unset") does for ufshcd-pci?
  2. Correct hba->lanes_per_direction based on the actual values of
     PA_CONNECTED[RT]XDATALANES?

Alternatively, ufshcd_init_lanes_per_dir() could override
hba->lanes_per_direction to one if "lanes-per-direction" is missing
and the device is compatible with renesas,r8a779f0-ufs.  Or perhaps
hba->lanes_per_direction could be preset in ufs-renesas.c, and not
overwritten by UFSHCD_DEFAULT_LANES_PER_DIRECTION when non-zero?

> Fixes: 5235d551779d ("arm64: dts: renesas: r8a779f0: Add UFS node")
> Cc: stable@vger.kernel.org # 7.2+
> Signed-off-by: Koichiro Den <den@valinux.co.jp>

> --- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> @@ -901,6 +901,7 @@ ufs: ufs@e6860000 {
>                         clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
>                         clock-names = "fck", "ref_clk";
>                         freq-table-hz = <200000000 200000000>, <38400000 38400000>;
> +                       lanes-per-direction = <1>;
>                         power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
>                         resets = <&cpg 1514>;
>                         status = "disabled";
>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Works fine on S4SK, so
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Will queue in renesas-fixes for v7.3.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
