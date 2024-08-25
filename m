Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534EF2F3E
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724562644; cv=none; b=sB8IyYv7ovwhWlNmumKH46sRzEnxgePc2lqVCyR+DaNlx+sP4zHVi/YkdC1SWWuceHqShZ/daFFV86ir2oodW3FPLX+eJBHAwraMsWH+Z97Yg7TfJVsKsLneAzEeRTd9+BHe9SIVFWFjgoiRqzGGtLuZk1WeTejDghM1HL/6TPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724562644; c=relaxed/simple;
	bh=Yt8qD5z1zrWX9jv9Jsj3yGbFqnR2sAhXTrAeHQiriBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ritIr2Wvahy8wPtVzsh5DDP+2QbTe1NedWWL6DOB4o5wbMnn/rt7/gIXf+jUW0p5Pl/fESLS3wauAnf/+yfnzpwahBQw7Z7v05I84rDrL692AZR4Dn+Zs0SV2wYGdKVuoekaUld8MPGpcQBEeOeJMyeA5xVUoY1/SEP69rUYTn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O2Y7E2Zn; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O2Y7E2Zn"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7141feed424so2765612b3a.2
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724562641; x=1725167441; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JTduRfDhbZPgX82G8kGlESryWqDJZ8ne4T7B0OtcVWE=;
        b=O2Y7E2ZnD7GLbLJpbq/0s+hBpJ1BVVa3NxsPuuqw5/QjPZoZFXfR96McEsmwaZN1ZK
         j3mTqd3WE2dG/P//2WILGufj/4w7KeACs8OmpxYAmOY5L4xiWxj2EZWap1XXU7pJkP4R
         CZWIJyBqpVbnJtHI60D1qjjpQUj7SIkMq43b3e8aqDJPVw0gV6+p/KHtfKIVuI4NQ035
         OZmcpQ/8sT4AMH/pS2viJj0NH7XljIOvGfCl5yp4dpkd1aoo5MVvu+kqRhCqtHb3GLtI
         7gpOa313BKcsacg4vXIxrbbGfcZlBg0gxPIQM3hK3k3s4m7YEOW4kF8lRTsyKN+3EFtS
         9bbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724562641; x=1725167441;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTduRfDhbZPgX82G8kGlESryWqDJZ8ne4T7B0OtcVWE=;
        b=UvrdtVxjdnUAMnyUoPkiQsIxUVFBYmbglrnGFCPtJDnbrF/BeZRwvr4I4+qRHB+cHq
         ZgmbV9if0aWe6eDsOvyjS5dvlanU0N8+bzulcMmjo0Tljoh+xZIHtC2pHDfc6IKdKiUV
         cCAnQEwCR9fKpJi3EImubuLqu1pWvzn2dg+KpUD7h3O+xSeQutry1LcxWPikK2zCNAo7
         m90HmCZsKO7YJwg9h7an9ifyrtXK02sfqOi3f6+MfBe+i7NAuJ1QTUW4R3BrK98WSqfN
         Vcw2eRJwZc1ZUkCeTUUxD2XVeQ4IFkLHH/LnVvz6SE7d4SUObatwmcMLE/jFr4s0y+OL
         3txg==
X-Forwarded-Encrypted: i=1; AJvYcCWISoHjZ3uxZx70IYyp03fNRCPMdBo9lkhdn3RjmLKnBvVEMAdmdpT66HEVWsMKjnafQraI2jOlS1fb@vger.kernel.org
X-Gm-Message-State: AOJu0YwGXMRL3c1uvkxK9Hg5t32e0nBdATzDLKEKtEHbV0xM5EL9ZsU1
	0tlFcpqgYoWqonVVm7PVwoHo11VVBiUKNUkkY/f2UgeKEnZ28P0TPZunVoQClw==
X-Google-Smtp-Source: AGHT+IFj6kKQnubZ4OzxPBxXJuuJRUMwXFKW0lNrhImD1e3CvgmR81Wz3la2D/3gAi3iGEi9wSlRPQ==
X-Received: by 2002:a05:6a00:a17:b0:714:21cb:8486 with SMTP id d2e1a72fcca58-71445cd5eb7mr7256055b3a.3.1724562641543;
        Sat, 24 Aug 2024 22:10:41 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434339ad2sm5146244b3a.209.2024.08.24.22.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:10:41 -0700 (PDT)
Date: Sun, 25 Aug 2024 10:40:37 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Message-ID: <20240825051037.ggp7sjiieksyiapp@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-2-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:02PM -0700, Bart Van Assche wrote:
> Move the code for adding a SCSI host and also the code for managing
> TMF tags from ufshcd_init() into a new function called
> ufshcd_add_scsi_host(). No functionality has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++++++++---------------
>  1 file changed, 53 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0dd26059f5d7..d29e469c3873 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10381,6 +10381,56 @@ static const struct blk_mq_ops ufshcd_tmf_ops = {
>  	.queue_rq = ufshcd_queue_tmf,
>  };
>  
> +static int ufshcd_add_scsi_host(struct ufs_hba *hba)
> +{
> +	int err;
> +
> +	if (!is_mcq_supported(hba)) {
> +		err = scsi_add_host(hba->host, hba->dev);
> +		if (err) {
> +			dev_err(hba->dev, "scsi_add_host failed\n");
> +			return err;
> +		}
> +		hba->scsi_host_added = true;
> +	}
> +
> +	hba->tmf_tag_set = (struct blk_mq_tag_set) {
> +		.nr_hw_queues	= 1,
> +		.queue_depth	= hba->nutmrs,
> +		.ops		= &ufshcd_tmf_ops,
> +		.flags		= BLK_MQ_F_NO_SCHED,
> +	};
> +	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
> +	if (err < 0)
> +		goto remove_scsi_host;
> +	hba->tmf_queue = blk_mq_alloc_queue(&hba->tmf_tag_set, NULL, NULL);
> +	if (IS_ERR(hba->tmf_queue)) {
> +		err = PTR_ERR(hba->tmf_queue);
> +		goto free_tmf_tag_set;
> +	}
> +	hba->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
> +				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
> +	if (!hba->tmf_rqs) {
> +		err = -ENOMEM;
> +		goto free_tmf_queue;
> +	}
> +
> +	return 0;
> +
> +free_tmf_queue:
> +	blk_mq_destroy_queue(hba->tmf_queue);
> +	blk_put_queue(hba->tmf_queue);
> +
> +free_tmf_tag_set:
> +	blk_mq_free_tag_set(&hba->tmf_tag_set);
> +
> +remove_scsi_host:
> +	if (hba->scsi_host_added)
> +		scsi_remove_host(hba->host);
> +
> +	return err;
> +}
> +
>  /**
>   * ufshcd_init - Driver initialization routine
>   * @hba: per-adapter instance
> @@ -10514,35 +10564,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  		hba->is_irq_enabled = true;
>  	}
>  
> -	if (!is_mcq_supported(hba)) {

I guess this series is based on v6.11-rc1, because starting from -rc2 we have
lsdb check here.

- Mani

> -		err = scsi_add_host(host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			goto out_disable;
> -		}
> -		hba->scsi_host_added = true;
> -	}
> -
> -	hba->tmf_tag_set = (struct blk_mq_tag_set) {
> -		.nr_hw_queues	= 1,
> -		.queue_depth	= hba->nutmrs,
> -		.ops		= &ufshcd_tmf_ops,
> -		.flags		= BLK_MQ_F_NO_SCHED,
> -	};
> -	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
> -	if (err < 0)
> -		goto out_remove_scsi_host;
> -	hba->tmf_queue = blk_mq_alloc_queue(&hba->tmf_tag_set, NULL, NULL);
> -	if (IS_ERR(hba->tmf_queue)) {
> -		err = PTR_ERR(hba->tmf_queue);
> -		goto free_tmf_tag_set;
> -	}
> -	hba->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
> -				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
> -	if (!hba->tmf_rqs) {
> -		err = -ENOMEM;
> -		goto free_tmf_queue;
> -	}
> +	err = ufshcd_add_scsi_host(hba);
> +	if (err)
> +		goto out_disable;
>  
>  	/* Reset the attached device */
>  	ufshcd_device_reset(hba);
> @@ -10600,9 +10624,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  free_tmf_queue:
>  	blk_mq_destroy_queue(hba->tmf_queue);
>  	blk_put_queue(hba->tmf_queue);
> -free_tmf_tag_set:
>  	blk_mq_free_tag_set(&hba->tmf_tag_set);
> -out_remove_scsi_host:
>  	if (hba->scsi_host_added)
>  		scsi_remove_host(hba->host);
>  out_disable:

-- 
மணிவண்ணன் சதாசிவம்
