Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46543132C36
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712069136; cv=none; b=LbD3lTCfmFapieimXnjzwts/AhoxYlkzgKvg/Sw6rWnMJbavy5aPSkw4wvaT6+lK5IjqjYeotOWr2tCN9eAvXawuOKgj1rCvCqR9bIxTeyZckACumF43ffjpnXabg1OWvQmkJAB1umpLaIwQoeR2cAkczEGv66tCs61XCgkLoTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712069136; c=relaxed/simple;
	bh=dQyII7vmQHRtc0XgOTiHPMjkmRblHUUbSglUykBczkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iLs1hdgkRg1GCQL4S3QAcAmfljeqgRHsebQJeAIPT0a/af1ALGQhfv11DL9KivXhi/DyobVCnU//eh7V0WmzQQCwmWAVtGu2VIOqEIodTZwsliiHvsUhgI6LhyXIPOAsJ6z0P4rWwEDq72sKsHXxG7VdNtYg85719EOAbp03mpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wQXjJLca; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wQXjJLca"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4d42d18c683so1325126e0c.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Apr 2024 07:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712069133; x=1712673933; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b3+dZ1fpYzh0cVc/i51+AzoQt474NVYKn1M7saZ5Kp0=;
        b=wQXjJLca0zDbzHxwNe1xofa+xPoemEFGD5kxOFB/zPsBoFzmOD4/SmpaFDEQueKDgF
         yEhlCXQUZcqHF1MG0YmziaZpi3dM4+QP7pSEGzEtd7tzJS5qc+jOSX7CPpfRYi/XvdHR
         CmfCIQqQunpVYv1dc1z1xioxmHaZUo3bunUf5bdmQkX5begFnifg/+c3R3Y95Li63BgI
         kbxm+GWgbT8dRVvKEYYSQ6Yrv0MwYb1tRD0Z3EWWSfbuIM9HSQmxP9NySQ/HYsMHzpCf
         OY5A3BYPyYgyeukj17WkGp6tapMmgIx05wkeHJxtaNE/vh6cEEzU0HS8pMEH8UF6txCC
         3vtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712069133; x=1712673933;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3+dZ1fpYzh0cVc/i51+AzoQt474NVYKn1M7saZ5Kp0=;
        b=kYa0EW2ciplHQHL9D+1KcLArB0UmnyBWRO39nN2mUn70f3CSUg2czvPa+QrsBEdXIF
         Zyik6i2otX2EjFrYfqEG8f/RMI7L2umLIrqCRRZjPoXS1hl92X/rfd632bDN2AxtyZSA
         hVTs+b9kUAYgKteyIh5YFkLydF6495oa1cI0qAprM6CI4i7j3E5qh3bw1DtYE6QRoFuB
         gl9nQxSZkN1LEtMPIhMRQMvH0l7UGLGpgYCpC4qMW1vfO12LXa52SpFMUlop3edjSW49
         UY8eMFoB9nwdVn2S1f9yyNsy41IBiTJuayjW7uggPFdD6XO/+TAcfRce22u/PakPOSSh
         z52A==
X-Forwarded-Encrypted: i=1; AJvYcCU3/xS5pnVsPm8iLoCY2zupBCIMsf2w7LL433dyDzEYlj+/egtLDMmn3oycEWBUJxe+edaN0HhgDRTzvmKZP5tyVYFVspN8k+0aAg==
X-Gm-Message-State: AOJu0YwZ7B8kJEEx9Tipgn9Gbt+d82gAmfaZx70vx9zs9UfVB0T2S1Zc
	zgOc5+UOsS5H28rvPHXDYco0WUO2ENAnVEa8bKjqzY/qdbUjsg+TTdvtKSs9ExfDFKroF+mD831
	7JKl1aPLykitPpEpCtEjJJUsdFXeFgEmC1fZmmA==
X-Google-Smtp-Source: AGHT+IE1jgEZcgPnB/hD8dZF0oJ3NImwHK9mE9wkjXMjSPzUxoTXJ6/YZxwewKzVuNrajM6LQ0QOegrYmBEtmBqomwI=
X-Received: by 2002:a1f:d5c4:0:b0:4d1:4e40:bd6f with SMTP id
 m187-20020a1fd5c4000000b004d14e40bd6fmr9290884vkg.10.1712069132468; Tue, 02
 Apr 2024 07:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401-ufs-icc-fix-v1-1-3bac41bdfa7a@linaro.org>
In-Reply-To: <20240401-ufs-icc-fix-v1-1-3bac41bdfa7a@linaro.org>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Tue, 2 Apr 2024 20:14:56 +0530
Message-ID: <CAMi1Hd2tLrP-Qm5tGSwjtYNjy6Di0PGMeW-j=scqj3jgM2RyjA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: qcom: Add missing interconnect bandwidth
 values for Gear 5
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Apr 2024 at 20:39, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> These entries are necessary to scale the interconnect bandwidth while
> operating in Gear 5.

This fixes the UFS breakage we see on SM8550-HDK.

Tested-by: Amit Pundir <amit.pundir@linaro.org>

Regards,
Amit Pundir

>
> Cc: Amit Pundir <amit.pundir@linaro.org>
> Fixes: 03ce80a1bb86 ("scsi: ufs: qcom: Add support for scaling interconnects")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/ufs/host/ufs-qcom.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8d68bd21ae73..696540ca835e 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -47,7 +47,7 @@ enum {
>         TSTBUS_MAX,
>  };
>
> -#define QCOM_UFS_MAX_GEAR 4
> +#define QCOM_UFS_MAX_GEAR 5
>  #define QCOM_UFS_MAX_LANE 2
>
>  enum {
> @@ -67,26 +67,32 @@ static const struct __ufs_qcom_bw_table {
>         [MODE_PWM][UFS_PWM_G2][UFS_LANE_1] = { 1844,            1000 },
>         [MODE_PWM][UFS_PWM_G3][UFS_LANE_1] = { 3688,            1000 },
>         [MODE_PWM][UFS_PWM_G4][UFS_LANE_1] = { 7376,            1000 },
> +       [MODE_PWM][UFS_PWM_G5][UFS_LANE_1] = { 14752,           1000 },
>         [MODE_PWM][UFS_PWM_G1][UFS_LANE_2] = { 1844,            1000 },
>         [MODE_PWM][UFS_PWM_G2][UFS_LANE_2] = { 3688,            1000 },
>         [MODE_PWM][UFS_PWM_G3][UFS_LANE_2] = { 7376,            1000 },
>         [MODE_PWM][UFS_PWM_G4][UFS_LANE_2] = { 14752,           1000 },
> +       [MODE_PWM][UFS_PWM_G5][UFS_LANE_2] = { 29504,           1000 },
>         [MODE_HS_RA][UFS_HS_G1][UFS_LANE_1] = { 127796,         1000 },
>         [MODE_HS_RA][UFS_HS_G2][UFS_LANE_1] = { 255591,         1000 },
>         [MODE_HS_RA][UFS_HS_G3][UFS_LANE_1] = { 1492582,        102400 },
>         [MODE_HS_RA][UFS_HS_G4][UFS_LANE_1] = { 2915200,        204800 },
> +       [MODE_HS_RA][UFS_HS_G5][UFS_LANE_1] = { 5836800,        409600 },
>         [MODE_HS_RA][UFS_HS_G1][UFS_LANE_2] = { 255591,         1000 },
>         [MODE_HS_RA][UFS_HS_G2][UFS_LANE_2] = { 511181,         1000 },
>         [MODE_HS_RA][UFS_HS_G3][UFS_LANE_2] = { 1492582,        204800 },
>         [MODE_HS_RA][UFS_HS_G4][UFS_LANE_2] = { 2915200,        409600 },
> +       [MODE_HS_RA][UFS_HS_G5][UFS_LANE_2] = { 5836800,        819200 },
>         [MODE_HS_RB][UFS_HS_G1][UFS_LANE_1] = { 149422,         1000 },
>         [MODE_HS_RB][UFS_HS_G2][UFS_LANE_1] = { 298189,         1000 },
>         [MODE_HS_RB][UFS_HS_G3][UFS_LANE_1] = { 1492582,        102400 },
>         [MODE_HS_RB][UFS_HS_G4][UFS_LANE_1] = { 2915200,        204800 },
> +       [MODE_HS_RB][UFS_HS_G5][UFS_LANE_1] = { 5836800,        409600 },
>         [MODE_HS_RB][UFS_HS_G1][UFS_LANE_2] = { 298189,         1000 },
>         [MODE_HS_RB][UFS_HS_G2][UFS_LANE_2] = { 596378,         1000 },
>         [MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,        204800 },
>         [MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,        409600 },
> +       [MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,        819200 },
>         [MODE_MAX][0][0]                    = { 7643136,        307200 },
>  };
>
>
> ---
> base-commit: 4cece764965020c22cff7665b18a012006359095
> change-id: 20240401-ufs-icc-fix-123c7ca1be45
>
> Best regards,
> --
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>
