Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3AB441D
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2024 01:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723859593; cv=none; b=OBDijmFc9At4eKWRPgccNMkxU2p+tjfuNB8F2qR4VnHmCixbYBZ85Dn7TW+eOehIeu6K35tqhG5FKzLewItoCxx3FKkZp2R8StFn+asCmv2lJmak6KyivLW9H+QOab+keKyCcC3m242aMdQhNnyUz23El7Z1h0zN8Jrs7GgBVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723859593; c=relaxed/simple;
	bh=w9u89A0ss1wrcRJENRuVYKhDIFvqmPBARq8wsqExckY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RqczMQUIdPDHCqCV2wTYb2OwsbuVwZsMm6LbfJix3SE8puVaqBQwxjX8rarcf1pS1vd096MkFnCeFKEJSypnv37qs6EtE1XFPDTp+hupi5lbmmqSxVdsfMZd4AUq7FLjOmHnelg5BePbAiFMbfgx5vR7483J3Rp948aFpvWKIXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mOiN2uBK; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mOiN2uBK"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d3b4238c58so2008602a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 18:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723859591; x=1724464391; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i/POR6BaNRZbc0fX/v/+NI5mqv85udaFy7IitKHUNsY=;
        b=mOiN2uBKXIq00laNnkCgafSIt01nAY6KXGMv9yWp3Xx9Z2X/tKh5Q5SdxJaf3vFWSW
         cK8KvYEQRIlhFUKdSh7RI+LvBBN3ouvDl9W3Nc7LJuH7eW29FMIsYxKNGD+sU2wUfkJw
         ccgl526EXDVnoqiw1eMegZtpBqnLDN3ulo0waLPU+mR/GyzQnt75FerwHKeJMuxIKSuF
         yJyzcASBQiOM7jIehYN7Yv86r0aswxNwxEeyidTgKEYnenvjSEf1+rqiTAmo2voQXu9p
         qr6kdENmRYtSvW/46P524XhBTz2skt+2dg2Hf7JhuzNL31JWu7oif8hREVgrzPu66pMG
         9L5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723859591; x=1724464391;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/POR6BaNRZbc0fX/v/+NI5mqv85udaFy7IitKHUNsY=;
        b=ujuvLei1AtKJfBaVA9nOvvTeK00L2zmSF8JQnWkb+vN/x18YYYRgZNngBCGLzzboPJ
         8FNW8yHJ++/u4s/7o8va4Z1GRGRsL/DzfPEoZ6x8IIaaxSjLphwKzmcMW3eV8wATbvHJ
         c1KtEtJMaZ9T/IOtvSaFwBBfrg7Phdl9VyFXeK9utP9U37XJCgtfmZP9nFqPPk/xekqu
         aaRKDkpLWesrgfcM0qJl4bP0M5uJGiam3tW5/PdFqu+JffYIf687+jbmSs662Lj0M49n
         jpBySRskT20+3saAFa0lHjsaR5kK+KYG/DweXEespytAU8JztM1EsXh0HDnHywEI8ljs
         opXw==
X-Forwarded-Encrypted: i=1; AJvYcCXLUH/Uu0ke1VhMz9hoPxaqXxhHbGLx6+LHfmnXgLdpj12ywM6rXwrXkteIOfbZdK0znNoDQpvueSb/ci2ZLElXd48vVyE/VPoNKQ==
X-Gm-Message-State: AOJu0YxzVi1LUmIho/1Izw7E4xdarv4rdkObzaSJyjes1dLn7776o4Uh
	Nv0WY7H7ALE0XfzWtBJvSW2QmkJd5uk3tmWmLvbGw2yFEQRmup1WnYmkXE9ijQ==
X-Google-Smtp-Source: AGHT+IEto5h53GA+2xIPfktVGXr4sO/taJj8NuTr7gLxjmf4sLBLsJ6k+VijMJHiijZnZTNCjTPMag==
X-Received: by 2002:a05:6a21:1706:b0:1c0:f6d5:be9a with SMTP id adf61e73a8af0-1c905047731mr6056129637.36.1723859591037;
        Fri, 16 Aug 2024 18:53:11 -0700 (PDT)
Received: from thinkpad ([220.158.156.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127ae0e8c4sm3212791b3a.81.2024.08.16.18.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 18:53:10 -0700 (PDT)
Date: Sat, 17 Aug 2024 07:23:04 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 17/18] scsi: ufs: Simplify alloc*_workqueue()
 invocation
Message-ID: <20240817015304.xuuypoonilsuqab6@thinkpad>
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-18-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240816215605.36240-18-bvanassche@acm.org>

On Fri, Aug 16, 2024 at 02:55:40PM -0700, Bart Van Assche wrote:
> Let alloc*_workqueue() format the workqueue name instead of calling
> snprintf() explicitly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 22d5e27485c5..ee68e911741c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1785,8 +1785,6 @@ static void ufshcd_remove_clk_scaling_sysfs(struct ufs_hba *hba)
>  
>  static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
>  {
> -	char wq_name[sizeof("ufs_clkscaling_00")];
> -
>  	if (!ufshcd_is_clkscaling_supported(hba))
>  		return;
>  
> @@ -1798,10 +1796,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
>  	INIT_WORK(&hba->clk_scaling.resume_work,
>  		  ufshcd_clk_scaling_resume_work);
>  
> -	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
> -		 hba->host->host_no);
> -	hba->clk_scaling.workq =
> -		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, wq_name);
> +	hba->clk_scaling.workq = alloc_ordered_workqueue(
> +		"ufs_clkscaling_%d", WQ_MEM_RECLAIM, hba->host->host_no);
>  
>  	hba->clk_scaling.is_initialized = true;
>  }
> @@ -2125,8 +2121,6 @@ static void ufshcd_remove_clk_gating_sysfs(struct ufs_hba *hba)
>  
>  static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>  {
> -	char wq_name[sizeof("ufs_clk_gating_00")];
> -
>  	if (!ufshcd_is_clkgating_allowed(hba))
>  		return;
>  
> @@ -2136,10 +2130,9 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
>  	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
>  	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
>  
> -	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
> -		 hba->host->host_no);
> -	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
> -					WQ_MEM_RECLAIM | WQ_HIGHPRI);
> +	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
> +		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
> +		hba->host->host_no);
>  
>  	ufshcd_init_clk_gating_sysfs(hba);
>  
> @@ -10392,7 +10385,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	int err;
>  	struct Scsi_Host *host = hba->host;
>  	struct device *dev = hba->dev;
> -	char eh_wq_name[sizeof("ufs_eh_wq_00")];
>  
>  	/*
>  	 * dev_set_drvdata() must be called before any callbacks are registered
> @@ -10459,9 +10451,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	hba->max_pwr_info.is_valid = false;
>  
>  	/* Initialize work queues */
> -	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
> -		 hba->host->host_no);
> -	hba->eh_wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, eh_wq_name);
> +	hba->eh_wq = alloc_ordered_workqueue("ufs_eh_wq_%d", WQ_MEM_RECLAIM,
> +					     hba->host->host_no);
>  	if (!hba->eh_wq) {
>  		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
>  			__func__);

-- 
மணிவண்ணன் சதாசிவம்
