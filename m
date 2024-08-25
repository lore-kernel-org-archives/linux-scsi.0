Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5A2F34
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724564341; cv=none; b=X/bZh62/hehZ29TheAGQpnDoosVo4O568pxRJ3JKp3/+fF/p6aQ2z240zbRUcRfKSf+hwOnwKyAypZasoOa+Tc8M8yPvtauKBsKwpZI9wU1zPIa1AmbAMBYrqvPTjnvVmUTsUjmF8XUj1h7vgkFnKTnXLy4UXsEClNA8O69c140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724564341; c=relaxed/simple;
	bh=inYh6i3Ls9JRBh9OwopJ2C8uzGeL25kCVBnFQYGmPaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPfZJg4w6MubWPgzXl9lAaHWmPQh36/74dpxtVGePR+I2RoCPfzfaXyT8MlNtsylCoSPtWs9IWva2RvLuGpAHi6RjgguxesAN9YQHCz1f+o7F3mS21EI0h7otDdoanN1qpT/VXARCxaSw7tsVq11Lo6p+KMssn+RVxEbuOLM1BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FwPiVJZS; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FwPiVJZS"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c1324be8easo2953146a12.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724564339; x=1725169139; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7VCUknBjGjrkTIClVwcL7rYQlED9phI1eyRpTvxPEPw=;
        b=FwPiVJZSYQ+XPAA5H0msB1OhlHlL2rISJRr3eR/R2TLbT+uUXqoYrZQHrsIS7gUgsH
         2mrNeG4X6iXDNOhsMnwmgNjcTfvoitRKSLNdvxw4DVqNKFqwbLSkxr84feckwkoTgsWG
         mcEuW2Qa9KvklSEyFZnm47UyUpvYrJEnoXqHQEH42o2eLuJCSFwubLvUOv6frpqvQ9Wa
         5jEnn8/8sjurEV6dOIN+d988qJlmywjhhzMZyCm7CVCO4S60AKxZ/bAzZ52bDPA64ij9
         +mDFlp3b01lYcJc4tqmYVMb89QmISe7uDb8Lj/AOTEu+UEAAb5XbWH7Wa97bndk7Oh8L
         g5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724564339; x=1725169139;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VCUknBjGjrkTIClVwcL7rYQlED9phI1eyRpTvxPEPw=;
        b=A+W9YVDE9yoeSNl2PQ8gmO3aabdzew2D28qJzppRDgqARAfpR0rK5nHP0biaJSlg6z
         gIkDbgnmb7u0S9kOGnjPu7yq75sz+EL3snKqFg3pWer4u+o2fxnD+pcEK7L1+zOFVGe2
         4GtMgUEe+ovsgb6N0JX/TesFaXx1lXtGbK44jfUEJa88XKZ/dIe/ZRI1zFmTeQH7A4fp
         H2aeZ5PMPtGCLMQN31Vn3te7rh3nOJVq7ocAsEkgNfNdC7qELpG7bxn72Vlu0e37xRSX
         b7B6TYhlEVi7tkex9QUWLYfIT1zppH0u1QwSKRQO+cPdjwZdnVU0fjhJs5PEnA0vkNLM
         7Ycw==
X-Forwarded-Encrypted: i=1; AJvYcCXItQYfQarJRS8vLvf0RWweT1zYvSN2wXJQajA0Quu7PudpA49vrxrYiKTCy/JcP0PrmxigmJcyPZDJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnp4oQiQtZG4JnEW8G36MKUARGwlWJoZdsp8xzfueOUdO0JVsb
	d5QzJFOs4875G322xFY0GDfizKKogk+9qLqOyUOaRNUeL778OyxwmkZcrLqU1A==
X-Google-Smtp-Source: AGHT+IFIwQ7BqdeRFoyuRIjKquUg/T/cxV69SlDLQc2Ra+WbUaiUec3kBEmoE11qCDYIf4B59/3J9Q==
X-Received: by 2002:a17:90a:2f46:b0:2cb:5fe6:8a1d with SMTP id 98e67ed59e1d1-2d60a9001damr17610772a91.9.1724564338808;
        Sat, 24 Aug 2024 22:38:58 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba26377sm9400236a91.32.2024.08.24.22.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:38:58 -0700 (PDT)
Date: Sun, 25 Aug 2024 11:08:52 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 8/9] ufs: core: Move the MCQ scsi_add_host() call
Message-ID: <20240825053852.enojwbmyfp77sypb@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-9-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-9-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:09PM -0700, Bart Van Assche wrote:
> Whether or not MCQ is used, call scsi_add_host from ufshcd_add_scsi_host().
> For MCQ this patch swaps the order of the scsi_add_host() and
> ufshcd_post_device_init() calls. This patch also prepares for moving
> both scsi_add_host() calls into ufshcd_add_scsi_host().
> 

This needs changes due to the addition of lsdb check that skips scsi_add_host().

- Mani

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++-----------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 6a3873991d2a..b9aaa3c55d17 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10404,15 +10404,27 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
>  {
>  	int err;
>  
> -	if (!is_mcq_supported(hba)) {
> -		err = scsi_add_host(hba->host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			return err;
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
>  		}
> -		hba->scsi_host_added = true;
>  	}
>  
> +	err = scsi_add_host(hba->host, hba->dev);
> +	if (err) {
> +		dev_err(hba->dev, "scsi_add_host failed\n");
> +		return err;
> +	}
> +	hba->scsi_host_added = true;
> +
>  	hba->tmf_tag_set = (struct blk_mq_tag_set) {
>  		.nr_hw_queues	= 1,
>  		.queue_depth	= hba->nutmrs,
> @@ -10650,25 +10662,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	err = ufshcd_device_params_init(hba);
>  	if (err)
>  		goto out_disable;
> -	if (is_mcq_supported(hba)) {
> -		ufshcd_mcq_enable(hba);
> -		err = ufshcd_alloc_mcq(hba);
> -		if (!err) {
> -			ufshcd_config_mcq(hba);
> -		} else {
> -			/* Continue with SDB mode */
> -			ufshcd_mcq_disable(hba);
> -			use_mcq_mode = false;
> -			dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
> -				err);
> -		}
> -		err = scsi_add_host(host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			goto out_disable;
> -		}
> -		hba->scsi_host_added = true;
> -	}
>  
>  	err = ufshcd_post_device_init(hba);
>  	if (err)

-- 
மணிவண்ணன் சதாசிவம்
