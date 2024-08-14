Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C47111A1
	for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2024 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723656177; cv=none; b=dF8xxsvJjfS+Vqawl+lujEEB1PQD+O8G9J/g0/lO7361ZEp5tZBmTcVUbDtX5MdMA5Cxo817DqTkJf7szf9e3aPFfC4cIF2RlSUuAjAbDk9f35CMHJC3d/v8lG/g6VFJ+V6kMR1oRQW2dDhSDFbhGD4CiUglSHOxEKASCcPeJIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723656177; c=relaxed/simple;
	bh=f1RmKlqVd2mEVwfc2Sh+M2IKkmy1k3LlwnHEvoWTbqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y5swqQ9Nk9MwUS8kbADuQ36gYYLwpDYcRqS4+CtSDyHz7B68ZPiHxxvzGeHbbiM7SnBVVeEakwe04vRkd5PZsG2mOepueSKrg0KJaqzQ+jGxKGPjaSqCFflZgBnn3ONHKnxA2Zx8yq2TbctZt0zBtS95YdmOciP3BXk9bbwj4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D2snk5Th; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D2snk5Th"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-82175064454so15074241.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2024 10:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723656175; x=1724260975; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1orJ6nO6ZqFwQLaPKdFYgCrAZEOYItqQBupC7tbBRhE=;
        b=D2snk5ThFVcd65AiKML2/U2T0VeLLX97SXy7BLD3PC1rKRlOjehSp18iJgG+5snpli
         BP52rAfUtmHiHcwnDSPsnO5LrDsGpj995mrMssn4/ztd66/YGAv898sy3UKwpCl/SeNJ
         nV9rhj8y/t8jmPyXXjs/e3e6XMFmxNU2ztRVKr4CgVDCYAWe3y7R3WcvFjhlcwCGPI2z
         pudjwMoK5gMF7lWNsNMHDVwfXUIjfnSSgWcqslaA/gU7ulcJGyz122hLnN+EkfVhcChC
         wT29XSSUycG1KrNG6VOqfFTvt2OMreE1pCbnn78o6JMPMRRjWTBH2Zll76F+Iw1lxxuA
         vODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723656175; x=1724260975;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1orJ6nO6ZqFwQLaPKdFYgCrAZEOYItqQBupC7tbBRhE=;
        b=Jbjya1DTYtbXgLQJzkJ0cF+bCn8oQa1pL1i8QcoIB/4TyQD1yx1HXB4/bx5Kjk7qLf
         hUgPTrgfF1P6iy4kwE00dUwZxTdGUUL1ctaM2xOGg40P2dNZ/52wFPMlsnHDgYqjan6A
         69uzAfS+Cp6zkv+c/UIKxzf5lPRe4fJJ00E8o7/BZC9cz9AvjxRG4+4a4scEooVAoQFB
         9PYPRbCPK3myqdi5TJvmucxcCj1XOw6Z/tecowj4AHCXfvFFuAI5+usHbfYovxHrNBO0
         tq084aiN9IyAeM2ZZjWBxp1F/B1ctTxNkzRjT0xXHM4VFlm8eaWmBuJw3S4fgTyGUaKA
         7Nvg==
X-Forwarded-Encrypted: i=1; AJvYcCVN4sS/rfoAuBd0DaVyqW8XVZwTJ9wDo4grL8COsQIzb9jk4HhWNHk1VlKe0oYbfrXUsGmiztdLCVK4a3voBrLKaUt+KkV2yFnwZQ==
X-Gm-Message-State: AOJu0YzcNekPUzXo54uE0za1M8OS3ggiuWKo5l2S1fu4vJ69NsP6jxC1
	0p8zQw1WyQCDbxMaUyFyYgKZtJwBWjF6Abl+xacQ0rGOiC9JJ6ZqNKCUnMdM2rv6jD2D1vvGrx5
	l+2tub2sEManLm2UcnzI8+qhB5NVTn1p/F5iHDA==
X-Google-Smtp-Source: AGHT+IG3b3VoA49ASMXUxYJgavmQR8JbYzZCSLToVi6Teklw6eT/Mpr/6/Fk5ShHKZ00PpJjOdB9b0Ong6gjAsG5qt8=
X-Received: by 2002:a05:6122:3c89:b0:4f5:f65:26be with SMTP id
 71dfb90a1353d-4fad17773b8mr5087403e0c.0.1723656174948; Wed, 14 Aug 2024
 10:22:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814-ufs-bug-fix-v1-0-5eb49d5f7571@linaro.org>
In-Reply-To: <20240814-ufs-bug-fix-v1-0-5eb49d5f7571@linaro.org>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Wed, 14 Aug 2024 22:52:19 +0530
Message-ID: <CAMi1Hd04z56++7cj+w4=fyi2ov42OO6mAnDbkw5CehJw+fJ8ww@mail.gmail.com>
Subject: Re: [PATCH 0/3] ufs: qcom: Fix probe failure on SM8550 SoC due to
 broken SDBS field
To: manivannan.sadhasivam@linaro.org
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Kyoungrul Kim <k831.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Aug 2024 at 22:45, Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.linaro.org@kernel.org> wrote:
>
> Hi,
>
> This series fixes the probe failure on the Qcom SM8550 SoC due to the broken
> SDBS field in the host controller capabilities register.
>
> Please consider this series for v6.11 as it fixes a regression.

Thank you Mani. This series fixes the UFS regression reported on
SM8550-HDK with v6.11-rc2.

Tested-by: Amit Pundir <amit.pundir@linaro.org>

>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
> Manivannan Sadhasivam (3):
>       ufs: core: Rename LSDB to SDBS to reflect the UFSHCI 4.0 spec
>       ufs: core: Add a quirk for handling broken SDBS field in controller capabilities register
>       ufs: qcom: Add UFSHCD_QUIRK_BROKEN_SDBS_CAP for SM8550 SoC
>
>  drivers/ufs/core/ufshcd.c   | 9 +++++----
>  drivers/ufs/host/ufs-qcom.c | 6 +++++-
>  include/ufs/ufshcd.h        | 9 ++++++++-
>  include/ufs/ufshci.h        | 2 +-
>  4 files changed, 19 insertions(+), 7 deletions(-)
> ---
> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
> change-id: 20240814-ufs-bug-fix-4427fb01b860
>
> Best regards,
> --
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>
>
>
