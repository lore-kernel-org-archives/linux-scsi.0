Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D11E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501733; cv=none; b=MnScr4yj8Ko/S3xzsM4Ur3XyHpn/9vRHe7PyfXh9K+ND0mmup1tPqNiYvPFxZIINEv0rmxyDrMr9IhXcmWP5EWZmMhUBgkJAHegbFEVoy3cKImxE3IoOfTOu4t73Wcp0kShql+E4oh8l7sgBW7u0BnzAu0orPuK/C4rHA9YsLM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501733; c=relaxed/simple;
	bh=yElGoer8ExKtPFpvQ26RvYzORqUvK0bxpm1LhenWAKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqW2r6qvT49Lscj8k8AZ8BdUGHr1VjfMMKcD4etglFzTTDhf18YwJn13lnRNMB4laI1DjO+dP7vNvwSd5Ms8Jze9Rcnld2TLpIpF4ufcgW6/MgVmTRHlSsNTLWIkUnd1G5zs+Td4NxbZRnM+v2S4FdRzbZWpZLHkB+3xtBg1sJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gIEeads2; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gIEeads2"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-77d3f00778cso465233a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501731; x=1721106531; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QtAIbiV0BZEAFlkTany0Pa0ck8DPTdlXOrZPC4CNdXs=;
        b=gIEeads2wWNTWKL5tpnW81KvOLqDmmTTR/N/ki/u9hyuLKn7C4A8Go83TQUEE3s8NB
         marC3oZwko+9qt4TBSykve+LWTxytOZph/z7ltarSjolVd71H3XBKs8WoCcMIszkfdX1
         E5BSEjriyoaVSEMypPsrqwkH4BJaLyvg+0YyL9vyfOhbHG52muhfB3Ss01m6sQJa/51p
         /xb6y+RM3gqyJLUd5FafxS82Cx4xrY6A0r3DCzRfWq4b6DvpVsASo43vBInltqDa6Jsl
         8d+4+uBWiI2IyGD4Yh2qq+2O06M6GO6bNKpe7Mi4F0eSCdTb7rdNUGkmGAoHA4wsB0Fp
         GKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501731; x=1721106531;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QtAIbiV0BZEAFlkTany0Pa0ck8DPTdlXOrZPC4CNdXs=;
        b=bFu6yQcHYNJmFL7Ny18isX0yKn/PME+Joxgr10RyyhZm8/oUv7VbGOhCl6YlVKNaY5
         sYS9P/uZ5hNUS0mTmSzSB0sDb/Px0AP6zHrCM/RUUsop2o3tOwQDP+M8EiNj+yG1MvEl
         Lqvlfk5CZ6872JXEfS42uyACJ+wsctfPG5Eyxg8vYzgVFa8J+nNy2kFZldeDP8No12x2
         iN7K/7fUQe5YhiIyJH+zSSIFgM5CTYz+z1xpagLP+6cl4KUxu0FMxe0qU6eLS84ZFmhW
         9WaN8tDMnvLQ5HqbKoolsqhffOx4jMqkvyQ6cHimWkSWFwp7ow8tpKCHAj5YSnXdBLzk
         irtw==
X-Forwarded-Encrypted: i=1; AJvYcCWv9BrIIJXnUNCaOZwp9tTsOSAXTUsEso0sWtUNjDT5RSp16Vihw0a8eTrp3QqqD6flp80qndrZKFH2aNC3Dp9LCO2EuRLHfmzMKg==
X-Gm-Message-State: AOJu0YyN/i+1RjA9PL0zRlYAkNpy8KGyTcPBcjPDJbYTAu4X1NEJ6bN8
	0NQO87fVRPOHh4x1jtO3duRws8IUD7RrxYXIPtJCN+robU2CXCy0+ll9oyb3+w==
X-Google-Smtp-Source: AGHT+IFLqpdD23hhsA1Sccyfs4Db87CRlZWPm1M8o8QOgOCTwex5k4/zm35ogVpuvtme4n4cUou3WA==
X-Received: by 2002:a05:6a21:6d85:b0:1bd:27d4:afd1 with SMTP id adf61e73a8af0-1c29820b299mr1912282637.10.1720501731154;
        Mon, 08 Jul 2024 22:08:51 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99aabab9dsm9040174a91.57.2024.07.08.22.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:08:50 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:38:43 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 08/10] scsi: ufs: Move the ufshcd_mcq_enable() call
Message-ID: <20240709050843.GD3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-9-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-9-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:16:03PM -0700, Bart Van Assche wrote:
> Move the ufshcd_mcq_enable() call from inside ufshcd_config_mcq() to the
> callers of this function. No functionality is changed by this patch. This
> patch makes a later patch easier to read ("scsi: ufs: Make .get_hba_mac()
> optional").
> 
> Cc: Peter Wang <peter.wang@mediatek.com>
> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7647d8969001..4c2b60dec43f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8703,8 +8703,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>  	ufshcd_mcq_make_queues_operational(hba);
>  	ufshcd_mcq_config_mac(hba, hba->nutrs);
>  
> -	ufshcd_mcq_enable(hba);
> -
>  	dev_info(hba->dev, "MCQ configured, nr_queues=%d, io_queues=%d, read_queue=%d, poll_queues=%d, queue_depth=%d\n",
>  		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],
>  		 hba->nr_queues[HCTX_TYPE_READ], hba->nr_queues[HCTX_TYPE_POLL],
> @@ -8732,8 +8730,10 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
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
> @@ -8757,6 +8757,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  			ret = ufshcd_alloc_mcq(hba);
>  			if (!ret) {
>  				ufshcd_config_mcq(hba);
> +				ufshcd_mcq_enable(hba);
>  			} else {
>  				/* Continue with SDB mode */
>  				use_mcq_mode = false;
> @@ -8772,6 +8773,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  		} else if (is_mcq_supported(hba)) {
>  			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
>  			ufshcd_config_mcq(hba);
> +			ufshcd_mcq_enable(hba);
>  		}
>  	}
>  

-- 
மணிவண்ணன் சதாசிவம்
