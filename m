Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A1F9DF
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724562995; cv=none; b=t705CA0LZS0Dp9QhZploYquydF1nf427+tfaH40+LNux5yrsR6DRxa0HDlYTUbTbkPlX3xT9s4k8kSCWFCPzyxhd2J16mpyj3s9VUub42iWSAuFxoxJJphtHfpCRx8H4wUebqC9cd1raTYZ3fxzTmqssjpYwhtbWH6ZKd+qP5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724562995; c=relaxed/simple;
	bh=7IblEZQTvYsRWfXDb8sXSwxXpiyjHld+44XTCkASkBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bA3wzYbCA43DGEcU/DSwyN5yIOSTWsSrqaZZwUDFgoSquuU98+UwU0T3ByG7RboGcRMcCNFF/2BdSkzmkbbF+QLqAPxfPKZllYr7Z6j1x1ppuKiWWJ6YWt7gZtXVeOYCnav4LzOWKx9M9XUTKzw/+sxazBkzFa4ElcMkupAG4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZsPIzzPK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZsPIzzPK"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-201e52ca0caso22941905ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724562993; x=1725167793; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cr1yD5/NUBu0/Es3hG5cGpa5fbZApRsH0rgW1GdB/to=;
        b=ZsPIzzPK92kjmLYMEeT9DUDszicTXzdpsRb/1ZNXoXiPoUblgRtQrUR97XFQ1Ci2If
         5gOAzsASAb4dWaKwaJ6f4UTeEoEHf0uZKZMqWrQlAGZ+7jff4SiyA6ZNgBicAQ0r09NY
         /GhHUTLRQ7j9Z1x/BegfSOjC8Dbh/h00lC7jwoZMaQtREPJ6rRC0iOgAg3/8Zz8C+hr2
         4/Sk6wlT1z7Yfk2VDlJY3feJ0aKuaI2WKcr62ln3uy/nN4lkSBPy+dR7NtWZT8eFYvcq
         QNr/GCUT2PAyYB/7l5kpDO7XJVVctaHoqMkiadOz0cjHLoK8RVU7lLWcJcvFNz0LdfXj
         pHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724562993; x=1725167793;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cr1yD5/NUBu0/Es3hG5cGpa5fbZApRsH0rgW1GdB/to=;
        b=Z08Id32WrDnfVhZhy1wIb3Akz9lBpQiYuAttBoF2nEAcitTwjHiXZi81gpFPgRbnOi
         tMlld3Kox+Q6elbRfh//1vZbMggWenM5upLwWjRrWypvmVOCBDAuEuoWRSG1173imU7W
         Bhps0gxcGBtaufHiVJeoTKgTMgx3mIod5WJkZuoFWdNiym36AKuBfle5p4V1xbbVgdmh
         zCxB0tf5tuieyNJkizTkJQ0Dblo8flHYrBuZsZ65pdgYZUXJ84U4nGVE9YqhpVxQIsv3
         LosURDFNNRxTfuC2dTvj/Yvt8HG8O6cCVLpfzPIOvXSMQY2hlbPV7XW0qnYZqMx7mq4X
         Npyg==
X-Forwarded-Encrypted: i=1; AJvYcCUHko2/j8bPZXdGtEAxXW2ApZHJnnii1826x6kSrNEskgKo0WfW97PLUBeWytzcPaa0PzD2PgsD8VBv@vger.kernel.org
X-Gm-Message-State: AOJu0YxNBYNXtEOvumn1HnkBUiFWP/4ZTevSJ0/ydr6KjquI3iNRUitC
	SehpvDCEfrxk6seN+DSGkdN2qThPaAwGVAW8yti7MeURIV5bI1ia/KEMjsLPq2bFFTnp/oTc0kU
	=
X-Google-Smtp-Source: AGHT+IFvS6KmTL7Ry89CiCb/0supzXbiyy4rF4HNdY4ZTpyVJiOHhOOQo8QAoVOhm3De5irt0hjIxg==
X-Received: by 2002:a17:902:e541:b0:202:2b7:9c7f with SMTP id d9443c01a7336-2039e534e0emr73439175ad.65.1724562993525;
        Sat, 24 Aug 2024 22:16:33 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385564af2sm48833615ad.56.2024.08.24.22.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:16:33 -0700 (PDT)
Date: Sun, 25 Aug 2024 10:46:28 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 3/9] ufs: core: Introduce ufshcd_post_device_init()
Message-ID: <20240825051628.j2qj54cnhrshj3b4@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-4-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-4-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:04PM -0700, Bart Van Assche wrote:
> Prepare for introducing a second caller by moving more code from
> ufshcd_device_init() into a new function.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

One nitpick below.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

> ---
>  drivers/ufs/core/ufshcd.c | 64 ++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 04d94bf5cc2d..dcc417d7e19c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8755,6 +8755,42 @@ static int ufshcd_activate_link(struct ufs_hba *hba)
>  	return 0;
>  }
>  
> +static int ufshcd_post_device_init(struct ufs_hba *hba)
> +{
> +	int ret;
> +
> +	ufshcd_tune_unipro_params(hba);
> +
> +	/* UFS device is also active now */
> +	ufshcd_set_ufs_dev_active(hba);
> +	ufshcd_force_reset_auto_bkops(hba);
> +
> +	ufshcd_set_timestamp_attr(hba);
> +	schedule_delayed_work(&hba->ufs_rtc_update_work,
> +			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> +
> +	if (!hba->max_pwr_info.is_valid)
> +		return 0;
> +
> +	/* Gear up to HS gear. */

Maybe this comment now belongs above ufshcd_config_pwr_mode()?

- Mani

> +
> +	/*
> +	 * Set the right value to bRefClkFreq before attempting to
> +	 * switch to HS gears.
> +	 */
> +	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
> +		ufshcd_set_dev_ref_clk(hba);
> +	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
> +	if (ret) {
> +		dev_err(hba->dev,
> +			"%s: Failed setting power mode, err = %d\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  {
>  	struct Scsi_Host *host = hba->host;
> @@ -8813,33 +8849,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  		}
>  	}
>  
> -	ufshcd_tune_unipro_params(hba);
> -
> -	/* UFS device is also active now */
> -	ufshcd_set_ufs_dev_active(hba);
> -	ufshcd_force_reset_auto_bkops(hba);
> -
> -	ufshcd_set_timestamp_attr(hba);
> -	schedule_delayed_work(&hba->ufs_rtc_update_work,
> -			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> -
> -	/* Gear up to HS gear if supported */
> -	if (hba->max_pwr_info.is_valid) {
> -		/*
> -		 * Set the right value to bRefClkFreq before attempting to
> -		 * switch to HS gears.
> -		 */
> -		if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
> -			ufshcd_set_dev_ref_clk(hba);
> -		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
> -		if (ret) {
> -			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
> -					__func__, ret);
> -			return ret;
> -		}
> -	}
> -
> -	return 0;
> +	return ufshcd_post_device_init(hba);
>  }
>  
>  /**

-- 
மணிவண்ணன் சதாசிவம்
