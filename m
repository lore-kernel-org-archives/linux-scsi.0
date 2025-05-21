Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E47262FC7
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747834008; cv=none; b=lpx2uIbC+rXH4q9BriDqleTA7i17UDO6XKh08jq+HCCCPXypu/p6r2KZKYhMGJ4VOoGKGSBllm7uD6q/vZwz92ItUNLgne183ChnLSSS7krjI/tEtWgcwhbTHmz0ywDjFtR/bPXzDjUjvZF0Ig03bPvln0cFStumzRCQe0lOQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747834008; c=relaxed/simple;
	bh=O5lp2QoEpMPS2MwUPvQkU43TbDUAVV9V0PVY3zVpypM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jt4Xi8FUcfFaplhF7HOCcVqfeIb6SanwibyPkXDD7pM6Wo2HuursDa0cANPRW6uW3r4o4HOVo8TIi+krgmmyJAQ0uE0P8nra5rMzv1H+eIP1ot8x2LJrWCdQTtTXCeyrQQvhcP7MoTRtJhPzYuR2rqdHwxjSQeeIC3voAMPN/lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N0Oyl3Wc; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N0Oyl3Wc"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b13e0471a2dso4440176a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747834005; x=1748438805; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vsAPeVY9F4Ep0Af1IsuKENhPXpnyEXq+ZRKN1+hGmWI=;
        b=N0Oyl3WctUeeMrQUOfHgkPgudP/EaGpufBqVz9NvVySvCCBe/4NAOVdiscdfhPlz+F
         X8YF+Wa1EoQGvbesgLOW5O42mSIXqshDB95vWEiJDwUZBsjw0OwY4iisW6ZKSk2Z53St
         fi/eFqA57Jc04bcgq5Pj/jayPVRoslPD4uPR3bocnMPJfOhDznwe1mL1k6hFZCHLvo4g
         yP1pzC9VMQQ1R04g8SVzh+5hOItwdcBxjIbfUxCU+r/KmvPwuRlRcIHc96NOeV/pPzV0
         9iLSpYO0/LPPK2rbb/VtcHlXTGD0F0tDvwUtpsYDJ889qudcVgP154GpunRoxGjnqwYF
         kpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747834005; x=1748438805;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vsAPeVY9F4Ep0Af1IsuKENhPXpnyEXq+ZRKN1+hGmWI=;
        b=M30QhuhFdudyHht9kcJLnbIfb1nAsbJpO8HLBaKH7dn5JOv950LYNvYc+tDESueDvY
         0w3yLwQD3EZI3lxdpgZvtnZZb+GBdqCvzaYYM227EwMuT2aXBWtb6rP+1q0sZH2JoCTk
         bgLp4JLAttpKDpLWDvFYKfI9WYEpwKqV6yajReNKBE2fiKPCXjADKKWFYmTECkLDW1dd
         OhkCdG1dTDD8FznKMykLCHYpUNkrDnlDhdsJSLiKHOq2fyLp77LxE14spWMt5Y3soUcH
         9g4Waf/B7eARCLI1tboaatHwnL+aSo/PNAmKQTMS35qMohi23SGh2uo2UTUP/EcZ1y3h
         6Dmw==
X-Forwarded-Encrypted: i=1; AJvYcCXCaliDYbKDIEQPKjRxplrUzRWHIfosrBYrjtG8iezKsUMmghLPMnqqBPqVHaIXtUA3Io5nP6BA+jHG@vger.kernel.org
X-Gm-Message-State: AOJu0YzfwnzIX54GEnpLYbGmd5mtQDg4K/ZGabDufARHxLliy7JEY5J2
	kth8WIrykHwMTiX2wKFIQSX+oyCCXx/uU1Kf3nebo1YA2YjKnOPPwG+frJkFTAKLdQ==
X-Gm-Gg: ASbGnct3/i3X2D6lNa6tYrHLyDhrBxthF83Ls6JJ9t9pmORKFJpW/ksn80m+2cTP6Ht
	8/qBak472oCtkEGA8bykkar8IOXpC5Mi8YDTBiNkG8T6hCxfrXK0jDn3fzHAEdt/roDPREZkSss
	apNLC/4trJ32qRCLwOoh/pCcuKxUXzIdeFObny/2yn6qFoJZel74HwPOiO4ecIZ8JTJesBo8ST8
	uHg+a2WlV0GM2ox+FnQ6cCB5LXyigoSWf/G0RPqfANgpI09Fcdrbxiu5ooXTB0uicF4VU6uZX76
	nsTUbL/khpCNxzFri7AvQ0PD7U38ItH5RJznqzLftXxZMzM8Ohiv23SBc69QPKRIANl38ok=
X-Google-Smtp-Source: AGHT+IFBDTatb/Wv2ODO3rVWJekx3BLDAeNfQgIP1zt45t6SjBWL/VcQDCAoRuUemYsln1KAeEC4/g==
X-Received: by 2002:a17:902:efc9:b0:231:fc6a:244a with SMTP id d9443c01a7336-231fc6a24a2mr179505555ad.2.1747834004862;
        Wed, 21 May 2025 06:26:44 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2320418f249sm74691545ad.215.2025.05.21.06.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:26:44 -0700 (PDT)
Date: Wed, 21 May 2025 14:26:37 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 04/11] phy: qcom-qmp-ufs: Refactor UFS PHY reset
Message-ID: <mwcqp3mxuheffc6x7w4w5mykqc57ovmvyrmh3ky5czjf54wnag@fxnxgsoi6y2u>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-5-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-5-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:15PM +0530, Nitin Rawat wrote:
> Refactor the UFS PHY reset handling to parse the reset logic only once
> during initialization, instead of every resume.
> 
> As part of this change, move the UFS PHY reset parsing logic from
> qmp_phy_power_on to the new qmp_ufs_phy_init function.
> 

More importantly, you are introducing the phy_ops::init callback, which
should've been mentioned.

> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 59 +++++++++++++------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index ade8e9c4b9ae..33d238cf49aa 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1800,38 +1800,11 @@ static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
>  static int qmp_ufs_power_on(struct phy *phy)
>  {
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> -	const struct qmp_phy_cfg *cfg = qmp->cfg;
>  	int ret;
>  	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
>  
> -	if (cfg->no_pcs_sw_reset) {
> -		/*
> -		 * Get UFS reset, which is delayed until now to avoid a
> -		 * circular dependency where UFS needs its PHY, but the PHY
> -		 * needs this UFS reset.
> -		 */
> -		if (!qmp->ufs_reset) {
> -			qmp->ufs_reset =
> -				devm_reset_control_get_exclusive(qmp->dev,
> -								 "ufsphy");
> -
> -			if (IS_ERR(qmp->ufs_reset)) {
> -				ret = PTR_ERR(qmp->ufs_reset);
> -				dev_err(qmp->dev,
> -					"failed to get UFS reset: %d\n",
> -					ret);
> -
> -				qmp->ufs_reset = NULL;
> -				return ret;
> -			}
> -		}
> -	}
> -
>  	ret = qmp_ufs_com_init(qmp);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> +	return ret;

This can't be:
	return qmp_ufs_com_init; ?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
