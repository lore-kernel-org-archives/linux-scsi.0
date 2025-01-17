Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822161FC7F0
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 11:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737113273; cv=none; b=ei29LDftyjA1RujrukRlOcXBsTT1+y2nEF3nn0RRgvs0uFC1yb/tLAUZBnVMx2TqZosY1H6R0ZlK3xWn0sD8EgR4w4T8Kl+56ROVfzkkHOSU+bjmVHRJ49oGuvSQbpVHTKHy660Uc+tqxvbWbwAPRrMYlFqtukqLPtbbJnjVLhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737113273; c=relaxed/simple;
	bh=WyThD8FrVBJCKDybx9LaT3OiS2rtnaogPPFxd7+ndtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haJp5ABlYhpIVMCu1wchRoJ9gOxmL9iZ12VQK+Kr7tbhbKXBdDWJLO2kNBSHDyogdCR4A1ftzy5C7giyyoxzbq77oaTkBZIEKcF+1tfLc7R3TIdyWvBze8r1euzebiEU0AZVbLKvfCmaucKONl8lPJhg3VnLiyKvcfO/nhwE7fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yW3iFQLE; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yW3iFQLE"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e5787c3fcf8so3601034276.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 03:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737113270; x=1737718070; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RxfEkKlYRP7ukIrs1MaCPw8T+wP3qoi186DEfWEac0E=;
        b=yW3iFQLE+aCthxXOqRuxgYtGjPFBBIx1L5OScZVVdblhd7JHw/lmYR9VVn5SK4Z2xl
         XYnwJ+FFCiQFujF+n5qjGd57NcyHSVlZOFg5Rh/FcNfpVQpHynbkmAJmXgrFOkyg/uEs
         MnuX4jwtDiaz4NDTn7oJ4KpWtljuOGTihcf1DODcrR62vMtTe7mVGJPM6O5TjWqBTZLi
         kwUbFK5AoXxf1a8JpSDtMVcwUrMLyRKbWoPAbxvX/pNFRtRoT3nJHJtekBwu1JTuXxj+
         z09ELZLHDBg5qr3GdJe3sv2UZKg1TtdJ5Pm9bkJq+AAYXQtnJRYEXzPatdwU33AeJWfl
         HDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737113270; x=1737718070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxfEkKlYRP7ukIrs1MaCPw8T+wP3qoi186DEfWEac0E=;
        b=MVn5IfjZFFtLOIuzJuSjfQUpvyOhl8jO554W+IEsvuXbs1i1HP/geXSxB9Xla2r1Xh
         BIefyI5O+GMk3x5Q/odLod5eugBnwDekvXy6ledvPocHk8FlSxJqalvkbJqjFLh1VnPf
         +hD3bnn22V03UT4iuctEFGBnTSeXfiePsSbvVBYkWPqUK1O1R5eUY7CxpN148RA3DiD8
         uCdZ5D3TpzD0Y1tKUykSFyjQYvn0AzcD774d3RKkDeRwvp8VS/a26fT5JUFEim3e1hGX
         X9u6V620FGVAoR605bJh+EV2s9Zz9BqH1Cxk1ZsqBXoPCkdTdyoA80ApdxSeu9YBqoWI
         xodQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIeG3ePbpg3DNycgFEJQke0Gu3Xu78GpaTC0NiHvajDD9c3NEvbPgR3Ed8LG+n2K8PGQpV4Wr/5wk9@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa3wlDGEVN7p1EKlMJyih/zcP4zTn1/Nns2OHPyWQQM07jj5/U
	ULTY0B2qn8xvzelb3r44d+02pd7AJt1ugNWlljiXhw1kNvIWQuWdLyAX/m6WdzdsQ8B5GWc5w1A
	v3HkD1Pnq13Q789gVunPukThJfAJcyzTkY0oMSw==
X-Gm-Gg: ASbGncu9aXzljEWoGoIh2ENYTggvzYNnT4FvM2eC/15lzLsNO/L3Mfk1oCbLf6gpihS
	kFKiupIPYALl+L/I6Xzw6qRQFG9faxV8VuLcdezM=
X-Google-Smtp-Source: AGHT+IEusORJsnLAB7uFHDjBIfrb4yJchecR7K5y4IVMIjvxS62ubvLYuQH1myauXkx8D3tFzPYY0Wl0i5Jr+dSW0ss=
X-Received: by 2002:a05:690c:6d88:b0:6f6:c9c6:9547 with SMTP id
 00721157ae682-6f6eb93f836mr13306007b3.33.1737113270604; Fri, 17 Jan 2025
 03:27:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
In-Reply-To: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 17 Jan 2025 12:27:14 +0100
X-Gm-Features: AbW1kvaav0qfOpmqvSp4jWBVis9VJqr0HfdaWWKr4JZ4uCU_pLkRAxHIiYm35ms
Message-ID: <CAPDyKFrV6OASHxtS-yKxBvhRpjkN2POFdL5EiWHyj+geZ8ufCw@mail.gmail.com>
Subject: Re: [PATCH 0/4] soc: qcom: ice: fix dev reference leaked through of_qcom_ice_get
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Abel Vesa <abel.vesa@linaro.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Eric Biggers <ebiggers@google.com>, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	andre.draszik@linaro.org, peter.griffin@linaro.org, willmcvicker@google.com, 
	kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 Jan 2025 at 15:49, Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>
> Hi!
>
> I was recently pointed to this driver for an example on how consumers
> can get a pointer to the supplier's driver data and I noticed a leak.
>
> Callers of of_qcom_ice_get() leak the device reference taken by
> of_find_device_by_node(). Introduce devm variant for of_qcom_ice_get()
> to spare consumers of an extra call to put the dev reference.
>
> This set touches mmc and scsi subsystems. Since the fix is trivial for
> them, I'd suggest taking everything through the SoC tree with Acked-by
> tags if people consider this useful. Thanks!

Sure!

>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

Kind regards
Uffe

> ---
> Tudor Ambarus (4):
>       soc: qcom: ice: introduce devm_of_qcom_ice_get
>       mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get
>       scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
>       soc: qcom: ice: make of_qcom_ice_get() static
>
>  drivers/mmc/host/sdhci-msm.c |  2 +-
>  drivers/soc/qcom/ice.c       | 37 +++++++++++++++++++++++++++++++++++--
>  drivers/ufs/host/ufs-qcom.c  |  2 +-
>  include/soc/qcom/ice.h       |  3 ++-
>  4 files changed, 39 insertions(+), 5 deletions(-)
> ---
> base-commit: b323d8e7bc03d27dec646bfdccb7d1a92411f189
> change-id: 20250110-qcom-ice-fix-dev-leak-bbff59a964fb
>
> Best regards,
> --
> Tudor Ambarus <tudor.ambarus@linaro.org>
>
