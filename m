Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C51514F6
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835423; cv=none; b=uuqcTW5tq5EPNDy7xXYiNCmTLyOhLY08iVCV0WuwmP5yNBlVMTp7geMnKUweUh3t2u1vHJK/UOQNiPm4+WiuCTlN5ch11yueYUgyLSB7oDYwOxewFTrq2UrZ1MaEb4PgFS314xLqbmu5wIMTFXQqrSeNT/Spi9pN+hUU7qXCCsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835423; c=relaxed/simple;
	bh=dINc/wQptmShY0mwOEHtFWIvstwWFCTzk6X6+/JBI6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRp33Git3YTevinVX/ouF1swPZJkq71TsSv29iFf5/u1bCAtwthKAkyXjM7FLIqrAmqVmFRhHG7QdpLWPJZuCI38Ejg2QXnHjOOPeAAHYpjtA0S2Doi2HyClj/BPh80KaqBjppBKDN3mDunhvhDtM6I7tM+Q0NdJNlK0qn5IWJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b3qPqget; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b3qPqget"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30e8feb1830so4355926a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747835420; x=1748440220; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/dGaJJt/HUGpCICV62UDPM8z7U1rRYbsKxH587Gzyjg=;
        b=b3qPqgetEf3GiDwfbGcdsb4hqaAY0XrK5lXwb4LPWkYhbGL2gob9EyNbBai3BDOHie
         BzxD6cqRcez38Au7gNcjK8uCvstsGHoVWZT+U/7qrLk2h7spwvM7yn6t0fuTHK/VAffK
         yurm4euX0yVSs1U0hXIfY6dBAYQUYZlF1Kq8LhKjrUxuIQ7aYCuyUOWDQtbZ6ahrHHlc
         hUwAss6CSnrKVaxKAiH6aT7xHtv+YNDmh8Qdo3rn7b7pPUPr1xTL5I5F22XiXffZBTCk
         VWG+2sbcDPo5lhO8iWB66em6oAlEHPUJahXiprR50K3IjhxY+bQ31wnD9itLgqREraHs
         d+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835420; x=1748440220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/dGaJJt/HUGpCICV62UDPM8z7U1rRYbsKxH587Gzyjg=;
        b=cQ2JxCa6ByuKuCWnlqYk4y/yuI6hLJmaddOd8hFcbsL1gq+RKZE/bZwNkKlbxXVWcm
         kUCr+XBP5fyf3EROFp5oOWbO+NLqv16H0xitSUgujvEhfQAOYNqo8gT9JavR3WZAeAf0
         RKV1HMRzLRv40aJUKeLYDKm/NxBqx/f0DrC0MEFMTs3e2O+Oh2zdwqdtbfdGgUMCXr7a
         cqZiC3AhvT23rGPCGH2lzbzYWMECQpypxvsY5RLlGa3ltLsELJ/x/8wo5gXcGHlemtRD
         MOVAax/1CQKZRBKa8yEplHY+Y+nzACVxMU9YYHWei9AmUDgWWTmVNUV5Xq8wkPvHpih3
         8BDA==
X-Forwarded-Encrypted: i=1; AJvYcCVQWPvqPbgoh+2DnRCHT6xi8qkMZzJwa+QaO3nMCxi0QFPHu2qSG93P2iKInZZlTAgSeh48tIJsOYza@vger.kernel.org
X-Gm-Message-State: AOJu0YwT7RGULA9+7ptJlEEPur0eppF2nuYZjZBUkKUVyVLezwHQpymC
	Brz4zx2i4NKgukNqYLIowFBfL/9HuGH83ueM0iVB/Zy0wfoV00Lg9GjVy+EmrFzGsw==
X-Gm-Gg: ASbGncsp+v9mPCxRA6x5qjtaPxImtfMtJjm8jVmXNc46omiR5OzssNmCqkj/CGBFvgM
	1x7wbY9Ym8g+He3CoXnOyEZbSOZ5m/5W11E2CXGinpeOrAFUqReHLdkFZrVHLH63N+lI5fUQktp
	Ddxc2k04iBEIJ+Nd26rwitY2sBcQjsnkUwRBfHHuYuLEKH4i2RxLoaHY+i08HWUAvUIjD0qkQ29
	tjvtqo1CCncTk6n1SbM7h8f4h5Ly2Kx2UH5fNaF3CUSmO4kvkzSBbAhp+C9ptPDZ3H+N6ZD37IZ
	fkzmqB+DeQWoAg0UbXfvnQU2TJCAxiJSYX86GrzCjO9RUC3hiSGjtdvEXz2B
X-Google-Smtp-Source: AGHT+IGfMgSZ1dyR31dRP9yWXfsiqsI0mIJuLiXZvdVwQ7ECl4Z67oe/m7O50OQnSlM0QTvqwXQ/Jg==
X-Received: by 2002:a17:90b:4f4e:b0:310:8d9a:eb1c with SMTP id 98e67ed59e1d1-3108d9aeb4fmr4087282a91.21.1747835420269;
        Wed, 21 May 2025 06:50:20 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b22a9sm3660292a91.6.2025.05.21.06.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:50:19 -0700 (PDT)
Date: Wed, 21 May 2025 14:50:12 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 08/11] phy: qcom-qmp-ufs: refactor qmp_ufs_power_off
Message-ID: <heork6adpw526tfljo2cpexevplpjrlgjgeyobidvzqlsubzlc@6vn6jykxpwqx>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-9-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-9-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:19PM +0530, Nitin Rawat wrote:
> In qmp_ufs_power_off, the PHY is already powered down by asserting
> QPHY_PCS_POWER_DOWN_CONTROL. Therefore, additional phy_reset and
> stopping SerDes are unnecessary. Also this approach does not
> align with the phy HW programming guide.
> 
> Thus, refactor qmp_ufs_power_off to remove the phy_reset and stop
> SerDes calls to simplify the code and ensure alignment with the PHY
> HW programming guide.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index fca47e5e8bf0..abfebf0435d8 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1827,13 +1827,6 @@ static int qmp_ufs_power_off(struct phy *phy)
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
>  	const struct qmp_phy_cfg *cfg = qmp->cfg;
>  
> -	/* PHY reset */
> -	if (!cfg->no_pcs_sw_reset)
> -		qphy_setbits(qmp->pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
> -
> -	/* stop SerDes */
> -	qphy_clrbits(qmp->pcs, cfg->regs[QPHY_START_CTRL], SERDES_START);
> -
>  	/* Put PHY into POWER DOWN state: active low */
>  	qphy_clrbits(qmp->pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
>  			SW_PWRDN);
> -- 
> 2.48.1
> 

-- 
மணிவண்ணன் சதாசிவம்
