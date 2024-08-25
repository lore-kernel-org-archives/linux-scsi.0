Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3F32119
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724564186; cv=none; b=i4hmwLGwX+Id3NwNEfk52cY7K2ZzrtetDbLv+tSwR5oFH8LgMlX9q1L8oagI/FlezSvLZIIsLWmOvnS6Nq2iEdgcvlBFToSJM2oYT4vK9n1oSnArZ/W4eezuch900fnje6jdIp9IZYmyR/2yGmLuxUGu9TLxYQugLQPqrsWLpRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724564186; c=relaxed/simple;
	bh=G30DilSxVLWnPOC3cpJY0zRmh3Js3vOA7dWGxYYnt7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpDJOaxGtqRdLDIGmD/QLY9d3FWCunNMNIBlKe9YHeSyuQEz7VbWBGcHarZpW0wKYLtBKGWoE+CZGrfQDfDuLVdLtLv4YFdX23TgV8+fiBmghqRgdHdAQ0gmOWqERNA+qgyDEmlMWzvV4qDdzei/3gQ6KOimEg0UxM6ga+pworU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LGs3Ggz7; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LGs3Ggz7"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71431524f33so2806497b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724564184; x=1725168984; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=72c4ynybbU+ATc4PXUnifzQXSHkHLFjkuvpRpJywZlk=;
        b=LGs3Ggz71CmQMRrz8NtwOACFuVm5fNg6m0IzvHTXQWVZE+etzMl6stBKKXoBj7mlRk
         pxwbHGEDuSH6PCRc3NwIVi87BKpzR9EK6zokdpXEP+Nq928R2LN/clgs/BI2oRgpb+7z
         pyZ+CM6DdjUSV6y+z5/iWVh8AUh/pk0EYVNyLonqwFKSfIfTCZARRoRQ9XTfT8vxlQxc
         RFnft/exMpBbINKdB6IB+t6gNFr9BuJzXlYPsDo77W+4gUkxe/89gfZnM1RTO1jn30zo
         v8NWPCZd5CuMIWZ4benkJU6ZeED9G6PUbZyYEYKkmehPCtNidLcmn9WKyNcsPYUFP2mZ
         fndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724564184; x=1725168984;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=72c4ynybbU+ATc4PXUnifzQXSHkHLFjkuvpRpJywZlk=;
        b=EgpVFGJHEsfafMfbPy9K+VRY6WIsvA4n66wUBXG92psadAB2XjWckc/RQDduZJiTwD
         CsN3LwIzijIMXUI/9wPBDGYTYjIr3VLKRPYftdpn0gp4QoUFUgbcUrek/lt7UOltZ9cL
         v4w+I8H7fkN1W8xtRx3PrOAPEaLq+t/LfkzxwZ2Gy0p2K4nNqXQDL/uYBOrdNeUn/30f
         ZpJA6+cTmnQYgbfqdJtD5SRETpE1/bySChhPb94fJuvuZjpcACrAWlHHff9/w6UKsFPQ
         uE9i0hdy68fnrpFX881GP63e2yBq5848hVARzc5OFTQWe7EKBgkCx/g4jO3BKEDk21qo
         9KgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRG3VyRwd5Ti1+EhHjmwNOUqZRrfbn9B85wQMRBI2+grsSxBCzAmRFN/8HTUfQ0kmnsQD6tpKRHMIL@vger.kernel.org
X-Gm-Message-State: AOJu0YzQHiou2CrOmyl8ZoZVBUx/Qtd/2ntbrv0evASqla2WyNZtB8gi
	XXzlq5IKFOkY7KLNRcRr3MNiYYKcpiGwlBV6IGXFvu+oN1m9y7no83b1+vlz9g==
X-Google-Smtp-Source: AGHT+IHxJR+htZ7JZWvP3WN/jP35QICUbvrKv9pYVfGIE09nbc7vMvNTNV7qq5Cwx8AVSqF99ef8ZA==
X-Received: by 2002:a05:6a21:1191:b0:1c4:7929:a593 with SMTP id adf61e73a8af0-1cc89d7ddb2mr9446656637.23.1724564184245;
        Sat, 24 Aug 2024 22:36:24 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dbf63sm49620675ad.176.2024.08.24.22.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:36:23 -0700 (PDT)
Date: Sun, 25 Aug 2024 11:06:18 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 7/9] ufs: core: Expand the ufshcd_device_init(hba,
 true) call
Message-ID: <20240825053618.fujf7df23tbxzm6p@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-8-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-8-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:08PM -0700, Bart Van Assche wrote:
> Expand the ufshcd_device_init(hba, true) call and remove all code that
> depends on init_dev_params == false.
> 

Again, no justification is provided on why the expansion is necessary.

- Mani

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0fdf19889191..6a3873991d2a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10629,8 +10629,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	 */
>  	ufshcd_set_ufs_dev_active(hba);
>  
> -	/* Initialize hba, detect and initialize UFS device */
> -	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	err = ufshcd_activate_link(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/* Verify device initialization by sending NOP OUT UPIU. */
> +	err = ufshcd_verify_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/* Initiate UFS initialization and waiting for completion. */
> +	err = ufshcd_complete_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/*
> +	 * Initialize UFS device parameters used by driver, these
> +	 * parameters are associated with UFS descriptors.
> +	 */
> +	err = ufshcd_device_params_init(hba);
> +	if (err)
> +		goto out_disable;
> +	if (is_mcq_supported(hba)) {
> +		ufshcd_mcq_enable(hba);
> +		err = ufshcd_alloc_mcq(hba);
> +		if (!err) {
> +			ufshcd_config_mcq(hba);
> +		} else {
> +			/* Continue with SDB mode */
> +			ufshcd_mcq_disable(hba);
> +			use_mcq_mode = false;
> +			dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
> +				err);
> +		}
> +		err = scsi_add_host(host, hba->dev);
> +		if (err) {
> +			dev_err(hba->dev, "scsi_add_host failed\n");
> +			goto out_disable;
> +		}
> +		hba->scsi_host_added = true;
> +	}
> +
> +	err = ufshcd_post_device_init(hba);
>  	if (err)
>  		goto out_disable;
>  

-- 
மணிவண்ணன் சதாசிவம்
