Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFDB17083F
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720012249; cv=none; b=aMbjrHjgHtvqQXoBlFNRoMzsG3Qtlt5nVwCvapcAscHZA1NlBvWZMkq/gPkZk3Ci4PBy+L1K/tsKepGsKSA7hMdUPsNYeyoUM0Yxymd1L5vu6bUHDHj+VX/+qC3KKwplupEO5PMwUvDKarrEfQGwan2WIZE7bJtNYFuf/fSxAPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720012249; c=relaxed/simple;
	bh=IB8d0IS7nybE6MCeO4BGnAFeO/zMgobmDIWJ28rF8/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUJenRyyeiRdDNDkvl5SYxI4mcgfech5c7O10WW6jRWniAIKzrOELdKBDf315c98cPLfWDk4L27qW/WOd/jrUB/48QpN6ecg2ohEJC9xj6G8ej7nFg6UTgxvaL/Odx/GT77zOxodCCkic7vbt174uAJ/ZerkqmA/VVhkMB7tnGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o19CRFcY; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o19CRFcY"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-707040e3017so3863665a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 06:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720012247; x=1720617047; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hKg2NZlXCZz2tTZ6V2QapFEjCJVukP76/YmvYqXP7z8=;
        b=o19CRFcY+/5Oof8BBRXqnQfPAVidrZ+8fI5beRrr/+zt3+N4zuRZ7QWJeb61axjmf0
         eEFFpC6jSlG+MxaQoG+m4IfF8s7/3PfG/yQj17/xPEM+7Ps/zfsX8WWgSZWYtVRM6SH7
         YCpxJ9Nf3cXmdYtgOGKtmQc11QxOTl1xYqsCI8G9KpPumOGGfU6q8UbfzbU4X8eo/b3/
         MZJC2OlaeUwXLKEFLUwt3YY+XmskufgO2MSLbuAgI+POG9XlpFwamEbBu7uty0Len9+b
         8eIyuduaze2dGds9McclQVvLFXlRvcBfAxJ+y8Es2xhN0zgzP29QiyQ9zW4tV7yKwsTL
         AO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720012247; x=1720617047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hKg2NZlXCZz2tTZ6V2QapFEjCJVukP76/YmvYqXP7z8=;
        b=Dg5UsHWbUqci7c9EdI9qc9g9HEE36LJo5luQMr/cmg9lPISwgE1R+7IwXOVnIRkM6g
         zK/bzcc1E0fLebzyP+jCrJ4FjHBgBQXNHiEu449NBzfYUAA4AyNIPbE9qCKM06T4GhPP
         xC9MoylzEgTVbgYuwFmvRKj5qXX0wUMFDsN2sop5e5dpIbFpYZQJ/NXuLpZakxqqYsom
         VARtsgdFXai/rPqz1VtsE1H+vlP1JDTkhCyD2t1up7xP6YV8c6EYOPwN4GU26lidlmao
         zlvTxpvfjnOkL6wL3Pcw0w7owBb1uPbAaVIXiaxlRyqGAFMRyhCjcQ7uqBG7GUtgFWAU
         0tAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx7X5acT5kJiMMGbfb0wvslcz8eg/64WLgJ7BVXREGwT+fuzQegXjm4pAff933OThDzHNEOqTLXUHJnlFGL8VvAn3+plAIOfoUug==
X-Gm-Message-State: AOJu0YwzoXSa0l48B3t+WEPi8Hi7BmIPOk474lfrQd9x9NXJXawnOmvc
	Bh9c1C4jrnSFZN3SxToDGmuvtZrjVKKb/VABUq4pMJbp6GDtaCnHAKbCI6pVew==
X-Google-Smtp-Source: AGHT+IH4mhk3JBeXjvEIGN0/5LJl/LwCkCRLpvmShRYapyPcxNmEhjPrqd56gPZkop/yvidsQycrcA==
X-Received: by 2002:a05:6a21:3285:b0:1b4:6f79:e146 with SMTP id adf61e73a8af0-1bef611aa28mr16456155637.17.1720012246189;
        Wed, 03 Jul 2024 06:10:46 -0700 (PDT)
Received: from thinkpad ([220.158.156.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce17c26sm10773552a91.6.2024.07.03.06.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 06:10:45 -0700 (PDT)
Date: Wed, 3 Jul 2024 18:40:41 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v4 7/9] scsi: ufs: Move the ufshcd_mcq_enable() call
Message-ID: <20240703131041.GD3498@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-8-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702204020.2489324-8-bvanassche@acm.org>

On Tue, Jul 02, 2024 at 01:39:15PM -0700, Bart Van Assche wrote:
> Move the ufshcd_mcq_enable() call and also the hba->mcq_enabled = true
> assignment from inside ufshcd_config_mcq() to the callers of this function.
> No functionality is changed by this patch.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

For the code,

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

But neither the subject, nor the commit message explains _why_ this change is
needed.

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4c138f42a802..b3444f9ce130 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8702,9 +8702,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>  	ufshcd_mcq_make_queues_operational(hba);
>  	ufshcd_mcq_config_mac(hba, hba->nutrs);
>  
> -	ufshcd_mcq_enable(hba);
> -	hba->mcq_enabled = true;
> -
>  	dev_info(hba->dev, "MCQ configured, nr_queues=%d, io_queues=%d, read_queue=%d, poll_queues=%d, queue_depth=%d\n",
>  		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],
>  		 hba->nr_queues[HCTX_TYPE_READ], hba->nr_queues[HCTX_TYPE_POLL],
> @@ -8732,8 +8729,10 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  	ufshcd_set_link_active(hba);
>  
>  	/* Reconfigure MCQ upon reset */
> -	if (hba->mcq_enabled && !init_dev_params)
> +	if (hba->mcq_enabled && !init_dev_params) {
>  		ufshcd_config_mcq(hba);
> +		ufshcd_mcq_enable(hba);
> +	}
>  
>  	/* Verify device initialization by sending NOP OUT UPIU */
>  	ret = ufshcd_verify_dev_init(hba);
> @@ -8757,6 +8756,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  			ret = ufshcd_alloc_mcq(hba);
>  			if (!ret) {
>  				ufshcd_config_mcq(hba);
> +				ufshcd_mcq_enable(hba);
> +				hba->mcq_enabled = true;
>  			} else {
>  				/* Continue with SDB mode */
>  				use_mcq_mode = false;
> @@ -8772,6 +8773,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  		} else if (is_mcq_supported(hba)) {
>  			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
>  			ufshcd_config_mcq(hba);
> +			ufshcd_mcq_enable(hba);
> +			hba->mcq_enabled = true;
>  		}
>  	}
>  

-- 
மணிவண்ணன் சதாசிவம்
