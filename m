Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59065FDBC
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022672; cv=none; b=B3ut2VQUI8JlGAy61Oz/7UA9g08RznjpzUKMGxgyyLSzdINqXqlyatsfy1f0tT5tb7HTj1kbXbnlHjqco86a/17NwiQrUrBBknfukyuYGk52DWqwSXige8v0c9A8CaC3FOh8cdaikcg++RdW0zXi4xOK6EyUY1r3TGTWlsD1h5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022672; c=relaxed/simple;
	bh=PPm9boZjwBn6Xzyt0g83ZrbCoWDaQwNE36cwpign/kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wf3li3wxSMTeOyaAiY4XA8W1ja3NE4/pQ8bY1p0DjExrKkuIYU52UW+ecUFp3aew19YZ+Z6g/zGhODwicS1WvxbVGt+nBbzKPLQ4BTFmprsEJW5icnUMoCGK8SmF79zv7NtoGciIiggqMvYtNU24p6XH6O6TEqTrCRjPN3elAhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VXINKWz/; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VXINKWz/"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6dd84fe7aebso230174b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 07:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706022670; x=1706627470; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4TDMZtp4Rk/MyqeG91tpztAQaCoeOy1ImodF5oM5/C8=;
        b=VXINKWz/RqJyQsbef7Qhp0b/TaaiZaU9h32F8bwFGfE2hx378WqsEsgdYNZg5X3LJO
         n9ttFF0Bf9X9lBSRyO29FUcTtL9X6l9XA1MR2KMnPFta9wCESIMkOGyX9HlovJNP8S2I
         fKaRsVbWuF/e5WPKhJL6pyM9XhrmwzRM8n2iWBhEbuX7oDubPOSpqPtvmMDODcYqtn4H
         KfkK8imYEsvwpj7qAR97meraLk2jPWpzaGE6QUI5pBE9eaObSCU+7UCNkV46+e+EaF87
         xXKGVYnyPn1m1mzu1GP7j3KRDuESiwm+RabSJ8Iv74d8hc/p+Bz+axJF00AqRKRQS8HE
         HE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706022670; x=1706627470;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4TDMZtp4Rk/MyqeG91tpztAQaCoeOy1ImodF5oM5/C8=;
        b=pcs0i5/wSp6EH/OUobee8Lkczjf/4Qo/1+1zvUDpRJTxrxX7lKZokfWzW6p2lmiDEa
         DGmE7LE/KO2Eqw31Xbt6s0G1Wtz7oO3+s2ELCOxMFOw7uX/hVK7x1uIjtaSXNLAgG3Eu
         Juqjx9GD27n8W4rJJz9pb00M2xU+4BcAGTpJ4dnFZH2JnL7UY4EKqaA7buh71PofuKrW
         zAThlK04FEp4BkugHTvaPUzV6+NcFV5HC1GOLYgpZKPUxhUKtjyWU9Ah4qPJncLzZDVn
         z+IEh9zHX6PJyIlsz5pBkn/4Rh6cE8IgOBCbH6hWikeyBb0UTIuLpgdNVLioiaKrltKw
         vOlg==
X-Gm-Message-State: AOJu0YwbXntRnX0H8F+hd7PzQ5N0VTem1ngahlxZCYRgOQebc+rGONLk
	96S5QZq+PyTtSUJ8bY5HJss9T+HAdvWbQ4YUCYxx1nfna+aRsbV8yFB6k0dHkQ==
X-Google-Smtp-Source: AGHT+IEOKhrSQ2AAiD6B4preFnkzitZWz56/vBVAw7INI+RAQyhQg8QHxAEyl6Hrgx0FmHXbiPe34Q==
X-Received: by 2002:a62:5e06:0:b0:6d9:eb24:4c5f with SMTP id s6-20020a625e06000000b006d9eb244c5fmr2890544pfb.37.1706022670014;
        Tue, 23 Jan 2024 07:11:10 -0800 (PST)
Received: from thinkpad ([117.217.189.109])
        by smtp.gmail.com with ESMTPSA id y22-20020a62b516000000b006dbd2405882sm6021527pfe.148.2024.01.23.07.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 07:11:09 -0800 (PST)
Date: Tue, 23 Jan 2024 20:41:02 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Eric Chanudet <echanude@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: avoid re-init quirk when gears match
Message-ID: <20240123151102.GE19029@thinkpad>
References: <20240119185537.3091366-11-echanude@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240119185537.3091366-11-echanude@redhat.com>

On Fri, Jan 19, 2024 at 01:55:47PM -0500, Eric Chanudet wrote:
> On sa8775p-ride, probing the hba will go through the
> UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info
> are same during the second init.
> 
> If the host is at least v4, ufs_qcom_get_hs_gear() picked the highest
> supported gear when setting the host_params. After the negotiation, if
> the host and device are on the same gear, it is the highest gear
> supported between the two. Skip the re-init to save some time.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
> 
> "trace_event=ufs:ufshcd_init" reports the time spent where the re-init
> quirk is performed. On sa8775p-ride:
> Baseline:
>   0.355879: ufshcd_init: 1d84000.ufs: took 103377 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> With this patch:
>   0.297676: ufshcd_init: 1d84000.ufs: took 43553 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> 
>  drivers/ufs/host/ufs-qcom.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 39eef470f8fa..f9f161340e78 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -738,8 +738,12 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		 * the second init can program the optimal PHY settings. This allows one to start
>  		 * the first init with either the minimum or the maximum support gear.
>  		 */
> -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +			if (host->hw_ver.major >= 0x4 &&

You can get rid of this check as I said in the reply.

> +			    host_params->hs_tx_gear == dev_req_params->gear_tx)

How about?

			/*
			 * Skip REINIT if the negotiated gear matches with the
			 * initial phy_gear. Otherwise, update the phy_gear to
			 * program the optimal gear setting during REINIT.
			 */
			if (host->phy_gear == dev_req_params->gear_tx)
				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
			else
				host->phy_gear = dev_req_params->gear_tx;

- Mani

> +				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>  			host->phy_gear = dev_req_params->gear_tx;
> +		}
>  
>  		/* enable the device ref clock before changing to HS mode */
>  		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
