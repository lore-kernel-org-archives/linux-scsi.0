Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B919188A0E
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836309; cv=none; b=HPor6IfYWNLHQ/w7NxM+fUZtWzNpqZbhQf++bNgRig0wo3KYhDZYF25O/b2MGnEOwA3uFEXafPDCwEhNKAFnt+GyE8DlYMoeK7ptN4/rryMRuamjYJ9+m27pFVmFcyCSt1J20IeFuQBOw2UTy7PZdm4XBrL6SevI8xSMvG+0dH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836309; c=relaxed/simple;
	bh=puxAM9AwUJp9W1jBndlWS+mZl9YN0rRXHwqPJ5st7no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQGdCCl8pt+9IbQtg3Wg8bg2h9CCTcxdFEwSuWGA3+UVt2yhMuHMRBY2K3BLQa6N22Z5EE6MYAM+TSTUvpW/0vUlhGv5yiJt+vqXmgQpntNDCL05yo/VFcTu6VQnQSxRG3yScOA+eJlLGtinOb7geJwzyspuX5SmwMFpSjCaXz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xBCc0l8X; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xBCc0l8X"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30ea559c18aso5401522a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 07:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747836307; x=1748441107; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oUWooNZYiRwIGE0ZkFwzsulXCDj0quWAKViua2SU9iQ=;
        b=xBCc0l8XvPFUNTkCSRJ+rJRdSJ0cqfoJc2iZWYSzEAehFHX1nji/w65JA20L3hg7K8
         tzZh1xs9i+zQ+2D780F/E53CGHgFKP1QJaSk3Szmgl2/axF+kciOFyMRfw4n5bGTmU6D
         dtX2hk9wkyE5Z3lhfYQo39OiEHrB9WejX0VsDjem0cBM5CZf9oC9rrk/LrftjzyokB10
         CvE/3pfuJBXUQn8XX6a0ziTd6JtLrPV1TUtRegjgP+L3j8nyfw6Fxdl6+tNAGG7P+JRw
         Gct+sE7Y/+NC3zyfuWCYsWRhy9BtAhxXu5L+0hi/bJ1fpLsjvc945MnajnvvQlC21vJd
         mmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836307; x=1748441107;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUWooNZYiRwIGE0ZkFwzsulXCDj0quWAKViua2SU9iQ=;
        b=dXTEhYuVAbAQK62biZjOF2RJC/BfgU9CvMHb5FruljW/dKF5RzP/hx4BXeMwmE3XX4
         pGR5vi2/zClQs+Br3oMZk0RRiqXHhRBJKQHByzGgoOdpvQjdwSUiVdraxz6EONB2pso7
         qdIxomDqdyTEYzkG6l9SXbDNTKDbX6+dxscc8sByO309UO3jCxoBaOr+cbP2E8tn5xVe
         N3CSZf13HgiwLgBRcPVup1Qg5OfitidxPWHBT/BpSXprmQO+VOKBsWPen5wWm69HCkGo
         4+Maj+uEKE//KaYyCMZPUWvgKgXkUgoWUDunU6/0vlUZEIW8FWnS0rdT+c/jqUF8xaU4
         444A==
X-Forwarded-Encrypted: i=1; AJvYcCX6jLh0a2vo6TIn/Lxyd3lmYdgJNOJE1X8kyghFlC5lRU8dMBtV8GNNBlmCCO7BoEqNHNFP5j+2ikWp@vger.kernel.org
X-Gm-Message-State: AOJu0Yzng+v9BgTsqXeoxPXGJR5mFOjg21KX7SbC0X+RkQgpzdpwy3PN
	eiNNBc7VfS7ycg9uMVsvuuyKw7s+TT4UHa5kT0fX75dmIES5un3QNw1Eqr/Tv+VEhQ==
X-Gm-Gg: ASbGncv+eITC0oNBCAIyPfLGI5MmbGoa8bwCxgPSeESs/RLtClZqm8xCV88FIuHJQqk
	fbTRIpA0QWp5HFDM0awM23YVOpcYS79X/sxeKPuxUSqg67zzkhbO73wDjHonkkTkFx9i16isv6s
	3FxIs0kVeVy67noascVIOuk1zZWWc+MSUQxYtHsJlWvSccDCc2AFPv8NKtXd63KDPqdIxNpFs3N
	M5FwbMdcyQqyK4yrLr3ZP4/WFnAYAVbaLLvUd2px0uUMdjIO4W6kynoUydedJgA92NgVDka3rQ/
	sPJCRo1I+nteJuA80yhOutrRMTgjWEHnesvxyQvUvtdDO2eD+HYau5Kcjx6q
X-Google-Smtp-Source: AGHT+IGF1UnNuTClUj3F4HuLJBTg4YIotq8v2Lv2C3f9MvdLIN/G13XG5gdSvc29YxyEeac8afv8yw==
X-Received: by 2002:a17:90b:4f4c:b0:2fa:137f:5c61 with SMTP id 98e67ed59e1d1-30e7d51faa1mr36743016a91.12.1747836307303;
        Wed, 21 May 2025 07:05:07 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-310a67c5703sm1028239a91.2.2025.05.21.07.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:05:06 -0700 (PDT)
Date: Wed, 21 May 2025 15:05:00 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 11/11] scsi: ufs: qcom: Prevent calling phy_exit
 before phy_init
Message-ID: <xxkv25y4m2lr6746fddzlxmgmgqazdqh2pjfzymuatkmrthsnw@6i52rpntjl34>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-12-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-12-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:22PM +0530, Nitin Rawat wrote:
> Prevent calling phy_exit before phy_init to avoid abnormal power
> count and the following warning during boot up.
> 
> [5.146763] phy phy-1d80000.phy.0: phy_power_on was called before phy_init
> 
> Fixes: 7bac65687510 ("scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()")
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

You should move this fix to the start of the series so that it can be applied
separately if needed and also to be backported cleanly.

> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 583db910efd4..bd7f65500db7 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -540,7 +540,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  
>  	if (phy->power_count) {
>  		ufs_qcom_phy_power_off(hba);
> -		phy_exit(phy);
>  	}

You don't need braces now.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
