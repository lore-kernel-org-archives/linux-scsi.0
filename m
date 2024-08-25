Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854403987D
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724563109; cv=none; b=HEWDI4HYCcpXF21/ZGtX9+rfBDyojPcUkbxF5+Lq2vKNKx0ovTt7eVWyR6AddSc58ewZsfQrp7ZljO9wu3RawNR5N5wP7OFkYgkG4r45Ik6UUi0S/1O/M71OhobhvggaZMZ2J1atQWrtluvDQDU40Rf+VtTN2rC/c/8dScw1qSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724563109; c=relaxed/simple;
	bh=/BbOfR86OsZQbX75U+SsSXNuKFDGLNmGEeEYmuhq7qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTiWAExoynKtlEa4TrZqhSXVRguGlkoibOETX1IueDRvD9K2OApm7rhCGmAzKyCfgIh0CKkSxk4dFREYp8l6gqTWojd/0X8Fwz9A2jRmOAHC6vhVwWsFfhQ3NUTZeXeatNs2alqZeVQMt772Y1OkWEnsh5VPNmv1NLXRaMsHhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sLBoVMZd; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sLBoVMZd"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d41b082ab8so2242140a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724563107; x=1725167907; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ONlzPplWVfpsV/ZNceN+ocCF7bpNq72Xjdwm5/i43As=;
        b=sLBoVMZdDVUBfB2byE2JPRt1lecX/TM0x1SwuyUHEmH2ktm/fyQ7SSS3A9bAfwrrm7
         WMdG2mhbydrqLdwUtZNg3KmM3DQ5t3fTMZFJhCp54gQBmo41uf2R/IaDCyQlGQo0wAEp
         UlkhvYW4NEE1mwuMT8qG12oxId92OcjHfebCUuas13AjPNUR5XRgVW4wdKgQNS7d03+a
         ItxNaMb1xUPt9OqsYtc543v5nNrxxQ71gHSKrYafPY+9kytHF1W6GO0EIRKQ26G+2HrW
         p/Xx6Y8nYyInG7G8z9REecLbe2mpwAGi8igjY1+R822M7A9VhQNspzFQHYCHwX4b2w9s
         46bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724563107; x=1725167907;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONlzPplWVfpsV/ZNceN+ocCF7bpNq72Xjdwm5/i43As=;
        b=QcV0fORIswThPoIx9m4alTuej1f9iSuFYqA+t4KIK+cu3yIxpbRVhjcr48L909xIvd
         DigatCSiKAUBRhXVJJJZecJ0lnCqg5RfJAkq/FBKdZf4Lv79fIc/c/dWqWuiLtmP18Ho
         CuDeTqJCYuxO/mNMl1tP3Ky3kF0mvrhc8OzjbK7X+jOuBYY3cA61dyZ6UTP1Hb3oCQd7
         ab6Biwtvrdqy9dOuBhzmYjxKk7eor0DZULHPGBqhBjfygguSczE5QYU0r8pYjBM3E8CI
         oVK3O0xzoCgSjxe/rk4p0huThR3y+z4tm6daRje8Qsn5YyuBPnmvyS1NrJvuPnZP02rf
         Ng8w==
X-Forwarded-Encrypted: i=1; AJvYcCXvcHicl0n6MQ+Oe8gYMomm9UKlMbioFLdkl58yjjZFc/vpDQxlhtgnxsXfSwi1wVcLN1Rrm2D4/1qM@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1J2U1njXw/zfnYLjeJhajbXg7r3wrRPbIiY/qoq/9r821gz6s
	SvZVNXiL5L7bgzOC6b+gLjFYICJbV5fdJgrW5PFx4e9UMkWi1AGHxrR9WQHEqA==
X-Google-Smtp-Source: AGHT+IEO6PKog5WeeSG3fJ1eM/S1v4elMm8o0ppWDXi6LpW0spI9EGQJ6R7/yHomcUDAGPfPHYpdbw==
X-Received: by 2002:a17:90b:4c06:b0:2bd:7e38:798e with SMTP id 98e67ed59e1d1-2d646d384b3mr5557255a91.28.1724563106750;
        Sat, 24 Aug 2024 22:18:26 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d613af0f80sm7008039a91.39.2024.08.24.22.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:18:26 -0700 (PDT)
Date: Sun, 25 Aug 2024 10:48:21 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH v2 4/9] ufs: core: Call ufshcd_add_scsi_host() later
Message-ID: <20240825051821.4oh5fawxuqckklhp@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-5-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-5-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:05PM -0700, Bart Van Assche wrote:
> Call ufshcd_add_scsi_host() after host controller initialization has
> completed. This is possible because no code between the old and new
> ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index dcc417d7e19c..b513ef46d848 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10585,10 +10585,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  		hba->is_irq_enabled = true;
>  	}
>  
> -	err = ufshcd_add_scsi_host(hba);
> -	if (err)
> -		goto out_disable;
> -
>  	/* Reset the attached device */
>  	ufshcd_device_reset(hba);
>  
> @@ -10600,7 +10596,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  		dev_err(hba->dev, "Host controller enable failed\n");
>  		ufshcd_print_evt_hist(hba);
>  		ufshcd_print_host_state(hba);
> -		goto free_tmf_queue;
> +		goto out_disable;
>  	}
>  
>  	/*
> @@ -10635,6 +10631,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	 */
>  	ufshcd_set_ufs_dev_active(hba);
>  
> +	err = ufshcd_add_scsi_host(hba);
> +	if (err)
> +		goto out_disable;
> +
>  	async_schedule(ufshcd_async_scan, hba);
>  	ufs_sysfs_add_nodes(hba->dev);
>  
> @@ -10642,12 +10642,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	ufshcd_pm_qos_init(hba);
>  	return 0;
>  
> -free_tmf_queue:
> -	blk_mq_destroy_queue(hba->tmf_queue);
> -	blk_put_queue(hba->tmf_queue);
> -	blk_mq_free_tag_set(&hba->tmf_tag_set);
> -	if (hba->scsi_host_added)
> -		scsi_remove_host(hba->host);
>  out_disable:
>  	hba->is_irq_enabled = false;
>  	ufshcd_hba_exit(hba);

-- 
மணிவண்ணன் சதாசிவம்
