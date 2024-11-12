Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846FC1534EC;
	Tue, 12 Nov 2024 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731398002; cv=none; b=jzjVBEvjRnosN8KBahbHcaHd42rJC8vr8R3TKWi8u9tO8vHJAnaXMelhSyf9vi/udSs/0X4OIy1M2F3BU7W561ziEhSD50VtAU9GREwVCw47WPEQW4SunIHNdI8WvO2vC0wJluUKORhR6vpPvxW4m6DcswRc2vQmgFOemo92TZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731398002; c=relaxed/simple;
	bh=w//YaLtowwTiTj2jD3v4WbwaEv02Z59trMzH+54Y4kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOOYBGqFhrzNNWOLMNw9w0fpZ9F0OdlhV4KNTJYiJow/7oqOBiWhZbqw8/8aLaTgqOntmjos1m5vuQc2WaMUEeQnrehEvKs6iao+h6J/dAVS8o0euk0k3GpnVcnbnF77EN8YKCZvzqycF1huh8sIjZ0EZlvYQjU0/oP6iFOK0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSl0hY7w; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSl0hY7w"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720c286bcd6so4664328b3a.3;
        Mon, 11 Nov 2024 23:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731398001; x=1732002801; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FZdzgcIljMlUObBvcBKwGCR4bvqsV+cW+n+UDROLFU0=;
        b=ZSl0hY7wUkEKkP4fRQw9qTQC7tj7P5TYaZ9NPNu4nVVsnRH2PLaGSPqPh2zdxm57w9
         5Gu2D9HK7dUY07VsbJjEJ/UpmCiPDAhr0keYB0+bsBIKlNPEAq/Hzyc7Lcepia6sTjSF
         GqrDfNIT3dsgh/YOkdC+es+9gePoZBSWwPXGIf1hdkTZo8zl/lIGEiURfwCZrcSd0OI/
         8NEInmmEiS7S1ymjWgP2jUk6N1F9Keqs7Zr/36alOpjcMwuN59n64oSQj4OFjgvkooaJ
         99hXMgB5F1haRDLE7BEKWT1PfskEJC6vZZ8U9rMs2TEzn30XF9pDFK3A9FKC5gtJtsQC
         SmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731398001; x=1732002801;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZdzgcIljMlUObBvcBKwGCR4bvqsV+cW+n+UDROLFU0=;
        b=X0YTH0RjfXYKiQNL6b8mYXcksDWM8FQg+qAaywCBSrt6y98YwK2s7C8ELL18lbpQcf
         EbbHXTim+7H3EyqkpP6LCVxaEGC21VfHcCDfeI4DB0n2Tmb6WKSHrZj+B3Okx8aYmtTu
         PMK0lDNnGdLfGumHCb8nIdSKRjKl9HOfa4D3LWE7kbYhu/SCEBhUgQMv7e3egqTRqE5j
         dXTuQUegcUzekCzfdtUtQhFptBMCZzXmOhx3KfsRC5i5lPnFFBTBPtKE1ANiW245VPrb
         hEtNVfSXwH1XXAayIBi5wyUrwF+eWoXMGC2aKkWMVKAVhn+uEs6T+g/YkxVdsUCGVw+1
         L3IA==
X-Forwarded-Encrypted: i=1; AJvYcCVCfIgImAmbOowNiPMMoEGoW7Zm+T8fVwW1bOnMoUKHENLqVddf5ErtHDnZjA+UkPIdFJNlp/Az1wjU+G4=@vger.kernel.org, AJvYcCVddK8T3S5LfGIcY4cywiCOu3ril6rWQ5hjOXRepQutGpWxdeIOrtAG4RuSDneMcCLlux2v/FvBohmt741x8mVt5oU=@vger.kernel.org, AJvYcCW9UyAkenc38Ddnff2wKSFsqhMtF7ANDnYu53ug7VC0HEucD2uOVdSenZEO9sJYGth8IcrITFut1yM5PQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPzAy4eW1iyTgys2Jqse1Jid3tj3qC2K2mTLOloCbn/XRrqhb7
	K8b1V5NcWtVzbS1rB/d8RzyadLwk9ZMBtgSYQn8xj2cuudBpt2QV
X-Google-Smtp-Source: AGHT+IFOyHj/UkfZuck4267vweXr7tX25rTZjP9yXmcate30Q5rUAyasg/Lb0W80EKNNt7nBcNybgw==
X-Received: by 2002:a05:6a00:23d1:b0:71e:573f:5673 with SMTP id d2e1a72fcca58-724132ce0bamr20411427b3a.15.1731398000772;
        Mon, 11 Nov 2024 23:53:20 -0800 (PST)
Received: from thinkpad ([117.213.103.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72407a56a16sm10689026b3a.182.2024.11.11.23.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 23:53:20 -0800 (PST)
Date: Tue, 12 Nov 2024 13:23:12 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, krzk@kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	andre.draszik@linaro.org, kernel-team@android.com,
	willmcvicker@google.com
Subject: Re: [PATCH 1/2] scsi: ufs: exynos: remove empty drv_init method
Message-ID: <20241112075312.v3ir4ewg4kglckpf@thinkpad>
References: <20241030102715.3312308-1-tudor.ambarus@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241030102715.3312308-1-tudor.ambarus@linaro.org>

On Wed, Oct 30, 2024 at 10:27:14AM +0000, Tudor Ambarus wrote:
> Remove empty method. When the method is not set, the call is not made,
> saving a few cycles.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/host/ufs-exynos.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 9ec318ef52bf..db89ebe48bcd 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -198,11 +198,6 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
>  	exynos_ufs_ctrl_clkstop(ufs, false);
>  }
>  
> -static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
> -{
> -	return 0;
> -}
> -
>  static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
>  {
>  	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
> @@ -2036,7 +2031,6 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
>  				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
>  				  EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB |
>  				  EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER,
> -	.drv_init		= exynos7_ufs_drv_init,
>  	.pre_link		= exynos7_ufs_pre_link,
>  	.post_link		= exynos7_ufs_post_link,
>  	.pre_pwr_change		= exynos7_ufs_pre_pwr_change,
> -- 
> 2.47.0.199.ga7371fff76-goog
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
