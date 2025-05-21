Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2DF137750
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835397; cv=none; b=jBoYljcdRdt0VW0G0IGWs++TKcNsgqWtTivJX8PLlKmYOuU3gV38zEiVlKNNU1hW+cQE+FCbq/W78KWbysDeDnpuNAMwt1MPcVBQclvYaI37bEimUcDKM06LcJz7HmWmfofBcqpaPBYjTp1EPIa9/9k7blpZ1LNjD7f1BwRNaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835397; c=relaxed/simple;
	bh=kjwWvwzUqZtyo/Cdb1R1/OawiBZ7nsUXUV3vo6Njmxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZ4nAZ0nmji1YS2xBR+EdCkGqzwo0WhEPD5UYx+QmIsR115hZzh7hVv9XvYBtlmFdHRvAuyLUFSPC736SBS0s7EkWtYvcY7HxUdu6WJbucNFxEgdcW1hjry/8VqhEgneQJyE6eV/0KcuuXjtCtZTr81XZW05+ozj505nLO2c6tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eChM12cT; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eChM12cT"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f8b47c5482so82541186d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747835394; x=1748440194; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IKQQl9efsnE2dSsd0cBEgyRG4tNPIDJoQhNLTJui0Rc=;
        b=eChM12cTxyWnQTZY0wISCsgRIjhJZoX/N13PUja6fcY9b3hgwSGtkvV8o+xybo6RL6
         8naWQpYj3kk/n7ZN3D3rWgh8gaZVpwlWGfo2CjOp5Gwq5ErtbfNnS6s8YHjIKdstXRHj
         qAtqnEAG5w7kPIM9N6xNQHDozJHHwEPcwBCb+ksLam/PouLwahPgdnArNQzRBy6Vu0O1
         EBw/a52ZpuqxcHIVZWH1V8YqtG4EHDzkUAOXvWmPRcAHLfk6zdHOw49zVOgn4XOBtzId
         gXAa7R29AzDCO21COfRfT+H6XkFDNAAV5WCPTctELRrOUQUyp+/1gAdAu1d/nvcA827O
         MD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835394; x=1748440194;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKQQl9efsnE2dSsd0cBEgyRG4tNPIDJoQhNLTJui0Rc=;
        b=RnlR6p713xu3TLyTrN0UEg/uWuFwXcLg8EGdDmC6PZ0MeK5GIP6VFneQJlxd/ZCKxu
         2FBFG89zN6rAUkQMPIR2InDTBwtQtSIbTYUequSQwFPmloayhxPxYVFDdhAcLlojpGcW
         qP+E3buCD0qNaI5RniVNetymujK2OVeLzoZR3ktmSiqNBINHwItqFTzQzy0c1fFQUrXA
         p/D3wMsNNwX6dY4JL9BXwaKYNSqm/NQaDzZonG359TACFU9EsewGtqU8aUGWjIzr9pEv
         NoMqS/4aLDCLG+mgjmfo4z4IMmTG0TzooRAwze6CaZQS03Uapfea+OLzwlwIDC09L+mb
         Gi0A==
X-Forwarded-Encrypted: i=1; AJvYcCUjxHfEKMxbeA3mjFJBKcZ25Rp2d4ov8mlJy8hzJVRbx1lNbn/2Pcauew3XVLPSNkz/MmJlcNiVpTSZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxeQxuO3ncuHuCm4UWXHd02nAXe0tp6LU+LqO8A6Di/Y75S6E9B
	hNs269RLJRin4Lijy8bRG5IyB/6qCWJBJ/J6EmKYa03mbofHCj2B4mYn3ONkQNqQ/8DluiMqKZ6
	MVtk=
X-Gm-Gg: ASbGncsEaTF+X6+X6+DDnSQtFxSN578pDfpJ28U68IH35Kma/lTKZLBdsRD1sapBxqf
	ikokbHkKmVkbca6prRssrK9Ze+fxbYzgRF1jBLzcfGudh4TPmVwUliaVDWBY0X/cASnrTVHRxwq
	Ancqv/OHxuPskLftZs+6WZ/D3ocow1Mcd2B9DcvFRnET9qLitjbBdgN6sljhB10yHbSwUq07jcc
	TL/qlsGaRJUAvwJxqPm3i7tLsPMfYPwVV91OuxjgDA4J+0kPnaeUmdQDCimxFEbQiMsCcPdsBVV
	L1BvkOtumMiDXFlgPYfZNXRh/CzPw/eo6IdxPx48tyLfJ2LKvfeu2rpScbyo8Rm1OOSYl/g=
X-Google-Smtp-Source: AGHT+IEduz9vjVMry3jT75IhTo2z8t5UN2ZLgjoAK3uVpOEwnFvqtCA0jcoE2LOGYXlGmBq0wdD1pg==
X-Received: by 2002:a05:6a20:728e:b0:1f5:7df9:f13c with SMTP id adf61e73a8af0-2170ce3aa79mr30392070637.41.1747835380880;
        Wed, 21 May 2025 06:49:40 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb082c66sm9710821a12.60.2025.05.21.06.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:49:40 -0700 (PDT)
Date: Wed, 21 May 2025 14:49:31 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 07/11] phy: qcom-qmp-ufs: Remove qmp_ufs_exit() and
 Inline qmp_ufs_com_exit()
Message-ID: <untqxy76skl53c55bdjz5usk4seuypjqbxkfub2qeqz42mewqr@r4cutmkvy235>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-8-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-8-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:18PM +0530, Nitin Rawat wrote:
> qmp_ufs_exit() is a wrapper function. It only calls qmp_ufs_com_exit().
> Remove it to simplify the ufs phy driver.
> 

Okay, so you are doing it now...

> Additonally partial Inline(dropping the reset assert) qmp_ufs_com_exit
> into qmp_ufs_power_off function to avoid unnecessary function call.
> 

Why are you dropping the reset_assert()?

> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index a5974a1fb5bb..fca47e5e8bf0 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1758,19 +1758,6 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
>  		qmp_ufs_init_all(qmp, &cfg->tbls_hs_b);
>  }
>  
> -static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> -{
> -	const struct qmp_phy_cfg *cfg = qmp->cfg;
> -
> -	reset_control_assert(qmp->ufs_reset);
> -
> -	clk_bulk_disable_unprepare(qmp->num_clks, qmp->clks);
> -
> -	regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> -
> -	return 0;
> -}
> -
>  static int qmp_ufs_power_on(struct phy *phy)
>  {
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> @@ -1851,7 +1838,11 @@ static int qmp_ufs_power_off(struct phy *phy)
>  	qphy_clrbits(qmp->pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
>  			SW_PWRDN);
>  
> -	qmp_ufs_com_exit(qmp);
> +	/* Turn off all the phy clocks */

You should drop this and below comment. They add no value.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
