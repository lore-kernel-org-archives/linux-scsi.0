Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C4C86341
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842852; cv=pass; b=AV5gqJkA3KJevDy9TnQfD0y/fD14cpC8bpWVU7f+0MjkiDgxVppmVtDu3jZ63coNS9VQWoi8YmCXWWa0xTI/R2JQT4mYMIwZlk91wXLuysXD52Y0ZFhEoKVaH8+NM8LX92ViXllzH7XOhEuiAHr0MLheYTyKEf8ZxQs9y1aMKxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842852; c=relaxed/simple;
	bh=W3Ab3yphKMxYz1/8CqZ7FpqnITfODGN1+Yw8aaRTaYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VxJ54jbCH/p08L7lnA7c5nqd3K+fd7YM79GDACm+DFUIm7C97ZcZ1ASMj7vB24/25j/v8vAF3cDA5e5MH9YQuGJtQ98+q85Xp/X15Cw2gdegXJxDB4rLjfQrpv4V+nRL3EQ09i0EA/rqJ43r/nb+qLA6/+3WUszqscCw6KmQsuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N/v3ToNJ; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N/v3ToNJ"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a5f91ae397so10984a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 08:00:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787842849; cv=none;
        d=google.com; s=arc-20260327;
        b=IS92Kbqrs0tE2OcGmarUjWZH7bDnQL0mvapaPHRwSsiHJuCzoePKkfYQQvR1tTdLol
         lqgSnciztYRuIi7pXCSIvlOUgiQ6oLhv6UXL+VbL7havTHDu5H2I/Yh/OexLk81I/AxS
         usPENPERZUcMr9THPyKQrXGZOhILZnz7cF1Stu1D4B5nWLyfQJGAhRsqpAsdksGdOonV
         NB0DAEyKNCfKwR8LoJnc4X/TKF8D01Ux5AcPGWTu9m0boDjWV9cGW22ggohXcA39tdQ7
         B3F2UQDabxlwDdR7/RuxKw0DNvUHXb+zTfIeI+6wRZ3vExgIG19AZcU7caRRFhn2CBNM
         ZUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9lxairpgLiXIXVMdCgp5oBtZGa2taxpEkryecJUmNAE=;
        fh=VWUI7TGkASfZ6QKTCvsGFJIE8LvZRxySPYx2+K6f3R8=;
        b=dUhts08nTH6RGdkmiXHbl7oGWMH8IL9rkvDXDPoOrzpcBPD35v1j3dHCU3tx7TXZ0w
         p8zp26IO0p4d3nSCKJGM/7FELSMsDzs9nnGMgG/JM9PmWG6/XtGBvecFn4ldLuZ72Dol
         4kPYOYCJX6wa6e5/iuaB2MFj0wTtHKLXsyxi/t0R+2DCNQpzhfwkqAoENVh+iOi+q6BP
         2Ih3+0dxGqtZt2vsX/SMJfBRjDTJUjFTl7jecLwaJUe5Sl/14o//CD3x5e4YNAid91Dg
         ydOk+Hk8nC9MtR8i2L5uAGCqzHzAe66th86O9CjXsvlYGZxF7UAxHRLO3Jz1vI/dqvaT
         t5CQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787842849; x=1788447649; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lxairpgLiXIXVMdCgp5oBtZGa2taxpEkryecJUmNAE=;
        b=N/v3ToNJU3GaR1Gi/EN5NS7dDb73uL8y7wKjgFBc5AfT+3MmPd9Vkvsiti1/s5Laf1
         /QO7JEa2Bc3O0CHFUNcfdEF5X9l92+MvtAF0dv9156l2X1WXhayO5kapSEZIBPbBUcWS
         +CW03OsKd9r5TbbZmGklkWtgwbGgvMnPa9f76mSMyjuh7aOGD+aF0kotH+/nfrz//SZ/
         PpKJbbBd91H+J163qMoRdu8T30MLyvxGnBx46lm40/k2y9HhFHlaDTMgw+Scgx09hngb
         3QG6AxShQuK7CtdS1zx54v0sJtKbCzopJOD7W0BOZMHk2yx5ybEtQefDARNzg+VotiIA
         U3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842849; x=1788447649;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9lxairpgLiXIXVMdCgp5oBtZGa2taxpEkryecJUmNAE=;
        b=c+VcPehalw9sgWLDoRy5KF45XqknkOz4hdfyqBLBQiFDYDHgvXTRDOjkOUfYoWuIk8
         RgwPxuQHDMznkCpB3ACqMG/rcx4hlF63wAdCUFyJ7JN/kLqYkDglMpEL5T7QKSW/SXXa
         Zb+mjrAc9EcU+OgPbx2m1vsBxKrjvIrZZO1FZWAR+Agd6uzHjb2ClQgI/JzXebjJSqc/
         8VC6+/+qn/YseZQhWn2dl2RUKuOh+bahoc262kMgCFfo6uZagrS+MLOgUow7H1v3hHS2
         1PbUIWOqagtiD1WA4ckT9MNKL0RgR2xBGjpZhhVILZtHD1MqG/LJcdroFCKXY/UMFm9W
         yOPA==
X-Gm-Message-State: AFuF++mK5otVBe48WTj7c5Grmqn0ZRPKCtC9+T13BSga0wcGPNaW8GPK
	qwOI6nS0XXjGHkZFqc6ZPtB0L7WPWxDVnm2yg9p3NKvrQyFABi7JTwM0f031OSCM1NFc6Hao87q
	JbrZKVu/oE4EFk0l42bvwgDOXsDdsG7whcMl6YH3a
X-Gm-Gg: AR+sD11xfaAdbqoqlT8NmXi/B1y/+2b91whxOZpZyIIWQD6XJpgJAYlWH9YqDnpvcoQ
	ChGbJdEmySGfPDCLE2mYa/lf+A1ofIcq7m4ErdWpzCeiQN6wmr3UqzY+I1sdd6blRTyXuvPCB7n
	JxPxZXuQqXkfOXxHLDvnhWS7Vy1uO3hhtwi/SW50m/1T9OnVe8ArLDSvOg1w+Y6fe46YQMSx39p
	hd1SdHip8U1OTCe/yp4JWJJKiXrr1mNtmrKPflLEKajj3zB0nJRJltRYy4p/MZA5RskBx7uYraD
	alDudTxH1dG6KvbmEEuyuSHtG3o98/JGm1ro2iAxjaFvWQ==
X-Received: by 2002:a05:6402:611:b0:67b:7d05:60b8 with SMTP id
 4fb4d7f45d1cf-6a5f5647937mr53711a12.10.1787842848394; Thu, 27 Aug 2026
 08:00:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com> <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
In-Reply-To: <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Thu, 27 Aug 2026 23:00:07 +0800
X-Gm-Features: AcwNN1UTquEpZeWJV5own34vt8ybBkfXz7pYThlv5e4VIyfdz2_DSFDAfqeUnxs
Message-ID: <CAE14pddHBP6HMihTePR+-Pqhu2DKjVgRA9++5Epod6TOCLagFw@mail.gmail.com>
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
To: Larisa Grigore <larisa.grigore@oss.nxp.com>, NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, 
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com, 
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, imx@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 26, 2026 at 03:40:41PM +0200, Larisa Grigore wrote:
> [...]
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index c2dafb583cf5..034ee988924a 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -563,6 +564,84 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
>
> +/**
> + * ufshcd_check_hibern8 - Check if all TX lanes entered Hibern8 state
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + * @timeout_ms: timeout in milliseconds for all lanes
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +                      unsigned int timeout_ms)

Hi Larisa,

Thanks for the great cleanup!

Would you consider moving this helper to drivers/ufs/core/ufshcd.c and
renaming it to ufshcd_dme_check_tx_hibern8()?

Since ufshcd-pltfrm.c primarily handles platform device glue and DT parsing,
polling M-PHY states via DME commands would fit more naturally in the UFS
core. This also keeps layering clean and allows non-platform controllers to
reuse it.

Additionally, the ufshcd_dme_ prefix would align nicely with existing DME
conventions in ufshcd.c while avoiding potential confusion with
ufshcd_is_link_hibern8().

Thank you,
Stanley
