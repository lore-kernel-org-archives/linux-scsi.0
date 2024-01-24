Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5291798C
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 08:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706086101; cv=none; b=uKoVUICo1tzH0+R5qMf81RxbDzHNdKAT/BcisZH4iX7f05FordgPvArFjJHlwfuEtZMjvn4ozpGBw4zNL9bWO7Mh4LmKhsM0PW2K7k1s5jA36vRL15UvFbzdBhkVmXCImhUAFFGEoq5kM0qt+PAT5i24G3wEqz4xNjdIjjz+j10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706086101; c=relaxed/simple;
	bh=P4McOCY6FFE0rm/rfcDQp1J/v6wIBnRRgRJjY2BpMyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFGfqyI3Am5kALHtKtGdqkLBIXpOGrApT8Rt2bP+S49xMFZZgPAFAoD1t4dF/jHi7TgfTpYf1zocyOmNPkvSstmcS7xcIyHhHO37FfMuF9+2l6Nfqb3yCbFU3bQeTLE++8+JANYgDuzwTJdjwgS+WZGWvKRdjNog3Y3Ez7/YEKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S5+9laij; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S5+9laij"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-681922a61baso42529396d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 00:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706086098; x=1706690898; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/7rbypgkDb+liCSqrr02j2nhDq3VhRD+glw+4uRNOQU=;
        b=S5+9laijnaySIyQqGT6T139zRj1oB8zVUNgzALSdIOCI4EkGB63ZusNvlq7zXhmX3t
         FU9uK1YBwlb28o7c82Md1Q2Dr3Dspu/q5Pu+PZHtyLeMT1ogEV8OouSWwNsitKoGMFfH
         ZNIo/YwWtqtwJxQsIcWar5zN5nmBGj+r/CHhreGiV1x+tAGYySbFNMWkA4+6gmmTuyuG
         WEHm9HsH0R38LDIXIMj8C5teThkQdUmCkxuN71Q2tQN3Y7x7d2UppEGMeJkXlymuOxEr
         eNUzT6MOHQCNglbqWf/Kc3uTzmReykOlIP89AdC5RgVko2uUVmLfEWiPBmbaB0VoHQh7
         ogSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706086098; x=1706690898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7rbypgkDb+liCSqrr02j2nhDq3VhRD+glw+4uRNOQU=;
        b=ScGjctCJoUqHKXHI5tTTWLJTyJcbNnZtFbzMeq2ET9mUOHk79St1YvvTQEbqqDvQiT
         bpiTVo+bjyxgy0PSN1ZTwvE8Iihmawq2zbzdZPINb7ahMcSwrSWhICoXz0gIacBkqG7f
         HNYNPOUyK5ntC4x8Wi8PvEusJFnY2oafcBcssZ1WK9sp0fks3PCnxN2GbMx1GYFFd+3y
         noq8i+4ctOzvWOhlUCOkGsKRgxmN6YXypf2lX72dt9kCoI0X38pvmP6IS5IWvzAm7I8c
         spYPsZBr+QrhAGEn+qRfJAVv43UNLq07/Ml0MbQYCdu6lmDoEOeBilBNb95aBpXW/rmj
         oKNQ==
X-Gm-Message-State: AOJu0YzEekAl8Fr+8wbdgMbwH2JbowLr+0X5bA3MRWtQCh4XY7IgYqKA
	2xTvcxSkXJaz+DuBBN78m+AXHGu504iU+L88Gu2drfMmecMVOzJ7546CByCVIQ==
X-Google-Smtp-Source: AGHT+IHusNOxPSa2dt91zylAOajByNL2kdMs4WbjVHN0WOdEOyi09tzZ3xXUsx72WRXSjgX82j+03w==
X-Received: by 2002:a05:6214:e66:b0:686:ad00:3fae with SMTP id jz6-20020a0562140e6600b00686ad003faemr1202389qvb.5.1706086098610;
        Wed, 24 Jan 2024 00:48:18 -0800 (PST)
Received: from thinkpad ([117.217.189.109])
        by smtp.gmail.com with ESMTPSA id qj21-20020a056214321500b00685f8308c9bsm3882632qvb.48.2024.01.24.00.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 00:48:18 -0800 (PST)
Date: Wed, 24 Jan 2024 14:18:10 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Eric Chanudet <echanude@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: qcom: avoid re-init quirk when gears match
Message-ID: <20240124084810.GF4906@thinkpad>
References: <20240123192854.1724905-4-echanude@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240123192854.1724905-4-echanude@redhat.com>

On Tue, Jan 23, 2024 at 02:28:57PM -0500, Eric Chanudet wrote:
> On sa8775p-ride, probing the hba will go through the
> UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info
> are same during the second init.
> 
> The REINIT quirk only applies starting with controller v4. For these,
> ufs_qcom_get_hs_gear() reads the highest supported gear when setting the
> host_params. After the negotiation, if the host and device are on the
> same gear, it is the highest gear supported between the two. Skip REINIT
> to save some time.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
> 
> v1 -> v2:
> * drop test against host->hw_ver.major >= 4 and amend description as a
>   result (Andrew/Mani)
> * add comment, test device gear against host->phy_gear and reset
>   host->phy_gear only if necessary (Mani)
> * Link to v1: https://lore.kernel.org/linux-arm-msm/20240119185537.3091366-11-echanude@redhat.com/
> 
> trace_event=ufs:ufshcd_init reports the time spent in ufshcd_probe_hba
> where the re-init quirk is performed:
> Currently:
> 0.355879: ufshcd_init: 1d84000.ufs: took 103377 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> With this patch:
> 0.297676: ufshcd_init: 1d84000.ufs: took 43553 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> 
>  drivers/ufs/host/ufs-qcom.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 39eef470f8fa..f7dba7236c6e 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -738,8 +738,17 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		 * the second init can program the optimal PHY settings. This allows one to start
>  		 * the first init with either the minimum or the maximum support gear.
>  		 */
> -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> -			host->phy_gear = dev_req_params->gear_tx;
> +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +			/*
> +			 * Skip REINIT if the negotiated gear matches with the
> +			 * initial phy_gear. Otherwise, update the phy_gear to
> +			 * program the optimal gear setting during REINIT.
> +			 */
> +			if (host->phy_gear == dev_req_params->gear_tx)
> +				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
> +			else
> +				host->phy_gear = dev_req_params->gear_tx;
> +		}
>  
>  		/* enable the device ref clock before changing to HS mode */
>  		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
