Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2562741DA
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754062393; cv=none; b=GEKG0gjs+UXs10IHuJo0P8kg/r/gZo1MF9nkHgegfZek1Ot+PYn5KPRPdyOzIU3SyNwpDkgeB1NXeodu8rOZEWoKj8Ud8lDpbhJeaOPp76qED0qMesnsAz39Qlpz/ILrIrx2XhG9O4Tkyz0UaWiOzDeJ+OhOktldawJi92A0EAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754062393; c=relaxed/simple;
	bh=G8XzIPRtm4xk5lge123mz0p0xgKBk3goA4ZlLuaJzb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxG2UTAE4msohqeT0jSYpD88nmH+IVUbscxsGEdIcib0HYKx9eHvzqnJCQpfEI48ykFKiQHAUoemV/jt8eOX2JxXWVGA3+PGqRyFkbr/9m3jgA8FcKwTOqPnoujdfb+OJ1rJF5tu43TH3BCZxtuejAKuhgBCeYeg/IcgH7b6x/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e6GskBDL; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e6GskBDL"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b783ea502eso1663258f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2025 08:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754062389; x=1754667189; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KMuhTiNgWdKprDSY7tl08r3yTLD5z9VbtaB9UQkibdQ=;
        b=e6GskBDLWvI5xgp6IaOORg6iAFkwfJENMf8NQF6p3+G21pz+LDmuf0nIgUmD+9x4PY
         sdRkmzzCnjyaLdsy98YzIdDN3gC39yXwdVyZlussTug7JGg/ugP1lwyX5ZAKSnJ6km0X
         3KNgRMVPoOozd3ORBWQVYV+5qYCnKmUH0KRuii3wH+mNmguUe8KPfzk8PpvrpUn+V8vE
         MoeCYQmr7NTeY9lazQ0WauhwgwmPi3mNvMTELfow+3+5QM7cOEjHnvTmNz5aBni/no0m
         gLAUMBJxqr6XAHmYsH9MH/LIbaek8F0HijKEcGcBkOQPfVbvDH24U4odqozY2nJGFkMb
         dZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062389; x=1754667189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMuhTiNgWdKprDSY7tl08r3yTLD5z9VbtaB9UQkibdQ=;
        b=vha+kaOi29Vdlalt8I9WFEUNclJxnuRIudQ6Av0L/+f0HA+dMNEt/LSbDqeaWj4PvP
         cXP18ONF8ZJQONdMYy9zxTHOdqrUnvQkfNIAeDLGfShTfCtnLy9FKH4N+lHiaq6amJr0
         lX7Ab3D0Crj5eXcfH7O6EPa/k6bvjStOFtLo6e0lBmQxWaPpaAVMriWOs+r992NdDzeY
         ULUbSI9Tu3QMGB2xZ42MEINvyhged1O4VilYA0q7ufaj/Ava8LHOrSIVTKpDWerIfBo7
         SBXhu+PGj9yVPrK7M11BdiwQiXf2V0MNcVGD6x6R2kvto2J8Bw2B42W/fRnUiqoCIhsV
         9njg==
X-Forwarded-Encrypted: i=1; AJvYcCVg8oBnE5vW9pr+qz3A7tkQeoIBSKfI43Abf6/qmETPWjWVBpjDTExF4YoKX4DFGYQ+/9UtNUf3WV7Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4wO65Q+wWXVuKzqZaT6mJFqYckx/XcEUwfZZ5CACVBwRpjUTR
	YMRVqiG7dAV4NefDQc1vanZ8VaMQw3dHbB1IBYdU92fhnGRHiRdCtd0bC8Qhd3sh7Bk=
X-Gm-Gg: ASbGnctEtg/bapY0+v82HPPKci1vFhzAsqoFKIZ6cRXCMtj7+b2nF2mVJme4Q6FbJMt
	49x4J7IqEdrp6k1fH2k3j87sUzCSPJu1W/uiw3R40e75Tez5XsB4ysRJFzbmcB50fBPTYXobrVm
	gLzUQ5S3dcNuLVHMIyp1Pg3tEKdSHg484+ga3tBGe+5YcSjSr0ABtoOnjn7YREjMio+3S5YofW0
	IhmhoEZZj2/lbJFyglG4gJ17HmtCpdoJKBYvEvg4sBOodzizWMAHi6Om2ctq7g+2zjzGm2OMeRl
	VHWJ2RplwOjGTbkkd71JN09H63y7HoDu6HuPr+KXdbb0IQw9BzsHTIhKYaraupiujBZtJw4W1p8
	wn6AYmC+wWt4XhEqL+bWGlVyqFv4=
X-Google-Smtp-Source: AGHT+IF9pkrPJ7jZbeEE0PxlWTyARsA424FL3piKfJ4GOT1hGtsLhG5zjtxmcgLX2NPTV/vFIv7f9w==
X-Received: by 2002:a05:6000:2c0b:b0:3b7:9703:d98b with SMTP id ffacd0b85a97d-3b8d95aaff0mr48794f8f.28.1754062388815;
        Fri, 01 Aug 2025 08:33:08 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4696c8sm6121767f8f.55.2025.08.01.08.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 08:33:08 -0700 (PDT)
Date: Fri, 1 Aug 2025 18:33:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Konrad Dybcio <konradybcio@kernel.org>, kernel-janitors@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH] scsi: ufs: qcom: Drop dead compile guard
Message-ID: <d7093377-a34e-4488-97c6-3d2ffcd13620@suswa.mountain>
References: <20250724-topic-ufs_compile_check-v1-1-5ba9e99dbd52@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-topic-ufs_compile_check-v1-1-5ba9e99dbd52@oss.qualcomm.com>

This patch removes some dead ifdeffed code because the KConfig has a
select which ensures that CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is set.
Konrad was wondering if there are any tools to detect this sort of
thing.  I don't think so.  I think the only thing we detect are
non-existant configs.  But let me add a few more people to the CC who
might know.

regards,
dan carpenter

On Thu, Jul 24, 2025 at 02:23:52PM +0200, Konrad Dybcio wrote:
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> SCSI_UFSHCD already selects DEVFREQ_GOV_SIMPLE_ONDEMAND, drop the
> check.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---
> Is this something that could be discovered by our existing static
> checkers?
> ---
>  drivers/ufs/host/ufs-qcom.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 4bbe4de1679b908c85e6a3d4035fc9dcafcc0d1a..76fc70503a62eb2e747b2d4cd18cc05b6f5526c7 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1898,7 +1898,6 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
>  	return 0;
>  }
>  
> -#if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
>  static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
>  					struct devfreq_dev_profile *p,
>  					struct devfreq_simple_ondemand_data *d)
> @@ -1910,13 +1909,6 @@ static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
>  
>  	hba->clk_scaling.suspend_on_no_request = true;
>  }
> -#else
> -static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
> -		struct devfreq_dev_profile *p,
> -		struct devfreq_simple_ondemand_data *data)
> -{
> -}
> -#endif
>  
>  /* Resources */
>  static const struct ufshcd_res_info ufs_res_info[RES_MAX] = {
> 
> ---
> base-commit: a933d3dc1968fcfb0ab72879ec304b1971ed1b9a
> change-id: 20250724-topic-ufs_compile_check-3378996f4221
> 
> Best regards,
> -- 
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
