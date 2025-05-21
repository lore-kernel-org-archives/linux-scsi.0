Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8C17F4F6
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835859; cv=none; b=N7Z2Lyz85Qbi8zqSLMa/GxYN+Sz2nWvcm/8essCFEZ3RXs9L8/gXbM8OW/mxQapmab/LmiYlr0xISoL+wmTy1zUO1HaPxxVVz9jikreAsHFbu7x6087sVpSfjV6M/+Bft+CNCp0nldGLqXYvy4oybpTlkogtAP3l1AESvLf3fHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835859; c=relaxed/simple;
	bh=Gv0HXV2263oNPGZof5l9I3MBc9ogn1UNaQ90T56vuFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsXokYrvGjcWtwNRuy//YebZQpnVaoCbj3vJN8dPnWQkgpjTi+bk6HYYWFL2WYjqWW7v6S3kgnVOrPUEKXXBHnGUu6AkvJBvORKLu0vOPNrsqsNOlfkBTCGdzJv7QC8BYghH3SGIWY5XDYc82Nfx3n6RAARps45zeKENJci6Bt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t5JTTVBQ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t5JTTVBQ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b26f5cd984cso5081991a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747835857; x=1748440657; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4V2npzngN7XE+T5CnS00fIFW0qBnhbmPIQOpJiEFacY=;
        b=t5JTTVBQMT0VpqzR/U2iZhhV8L4TgzKFm+d8O69FsxqdW+YxNJBb/4RIeB24cE17lc
         Wm4WSqrw9ig1mYgAUOkEYFFm5mw6/cBKWWNswPiZk/9zw+Onle8c7vtIkqS+kOTPmdNd
         av/XR4lb9TSjutk5/63u7E7+wSVMC9koXKpEJYdW3+JbP+0OWxPfAyy4an9eAvPKMrxr
         ESukKAhSIZqEcetXZpV+NR6n/hUBn48k12vHN/JMlG3LCth6gQTzK2uXm9gh7g90O0nw
         UEkUv46c+Cz5ovCcvhgc7WWqEpPM0NqazvORMAK2zHqzFufQDssVJ8Am1lUtvtxmeeH4
         asMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835857; x=1748440657;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4V2npzngN7XE+T5CnS00fIFW0qBnhbmPIQOpJiEFacY=;
        b=kCVsN9Jc7vzcIQtOhoIyWIgEYhO+sdCPX+Em04PVybCCt2Ca4xiwAqzVs94h8HLNrs
         YpZwEVjH6uKae7HXNBUsYaShnriXdwyf9c4UIBWxdhN22mIWG6Mc4Izwp5pdQjqDD9Uc
         jYoNnV/PoSDTW8nYAZpFI41Kcr66Q+QXuZIw7IpqnyrwN/27xLzPaUBfbjCYXrNE2IUt
         3yf3W/Ki+/sesHw4uMG1cSx6+86sfU+kUuudoxyIyEFNd4/n8fztJ+WdDgcuMT2B3yGg
         OI8ThvAsd52bVIQuuZ+D2XgmW4v8+KcpOKPdSlMgR5EVBPlqxabzF7UNWQE0DXvUpzgp
         R4ig==
X-Forwarded-Encrypted: i=1; AJvYcCVFg0MF4NWcTRHLodN2oJu3xFmMTHLchHU5zUcutvbl2dXQT4e1f/v1QYD8y+Vk/Hhox0DIsPWY37sa@vger.kernel.org
X-Gm-Message-State: AOJu0YyFVbPpZz4l8BTf09+vXSa7wkoEYn6mfXPdiGNsb7hM2NLfKKnt
	shi6F10jO1SuFvD6e5AHi5l99WYuElIiy7QN5R7Q93urjfh+LS3Zab426C7PAO/7sw==
X-Gm-Gg: ASbGncvTEpjcxm2RPljxWQaEnrznBlkCBPqgqPh+dRu42LSk9YGCf0xb0i/nJfFqMHq
	9yhbU3GNg78cMiL2g3IdpX+wCu9VdulccPHf+eG7IaRXtpsdcMTZ6tQiLoL+VmFesb7pazTSnxY
	zm/3GOwpkGaKHp3VdUdWQl8pNA+KJAEmZYqNvwuF47/Ot2SmtbCJrmO9wZVDKpjInd3sjYos3OH
	sERF51vjS+HSZKYtyiylyiM3Rh346rRaJx0fEHfkT553Byywx4I1C84Vs1GTPb37fN/aLSbuuJW
	rNyFarGV66v/KzSSU7gS7+4CzQzF1tHGw7/QRpk2uBO33Ehf7oxUurxlxDMV
X-Google-Smtp-Source: AGHT+IHRB6a4p+x/fLfJd+xB4iokXTvEugUEwgXrmK670XBatNkGHNJpzX5R1He9NQDvMhn300VvPg==
X-Received: by 2002:a17:90b:56cc:b0:30e:3338:8c0e with SMTP id 98e67ed59e1d1-30e7d5a8b5amr30665302a91.27.1747835857527;
        Wed, 21 May 2025 06:57:37 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b22b5sm3663633a91.5.2025.05.21.06.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:57:37 -0700 (PDT)
Date: Wed, 21 May 2025 14:57:31 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 09/11] scsi: ufs: qcom : Refactor phy_power_on/off
 calls
Message-ID: <knlhbl3mwo3b7xc4rjp4y7yka2nwythumjacmvn236v72ykddo@r3cp2w4uomol>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-10-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-10-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:20PM +0530, Nitin Rawat wrote:
> Commit 3f6d1767b1a0 ("phy: ufs-qcom: Refactor all init steps into
> phy_poweron") removes the phy_power_on/off from ufs_qcom_setup_clocks

s/removes/moved

> to suspend/resume func.
> 
> To have a better power saving, remove the phy_power_on/off calls from
> resume/suspend path and put them back to ufs_qcom_setup_clocks, so that
> PHY regulators & clks can be turned on/off along with UFS's clocks.
> 
> Since phy phy_power_on is separated out from phy calibrate, make
> separate calls to phy_power_on and phy_calibrate calls from ufs qcom
> driver.
> 

This patch is not calling phy_calibrate().

> Co-developed-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 61 ++++++++++++++++++-------------------
>  1 file changed, 29 insertions(+), 32 deletions(-)
> 

[...]

>  static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>  				 enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct phy *phy = host->generic_phy;
> +	int err;
>  
>  	/*
>  	 * In case ufs_qcom_init() is not yet done, simply ignore.
> @@ -1157,10 +1141,22 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
>  				/* disable device ref_clk */
>  				ufs_qcom_dev_ref_clk_ctrl(host, false);
>  			}
> +
> +			err = phy_power_off(phy);
> +			if (err) {
> +				dev_err(hba->dev, "phy power off failed, ret=%d\n", err);
> +				return err;
> +			}
>  		}
>  		break;
>  	case POST_CHANGE:
>  		if (on) {
> +			err = phy_power_on(phy);
> +			if (err) {
> +				dev_err(hba->dev, "phy power on failed, ret = %d\n", err);
> +				return err;
> +			}
> +
>  			/* enable the device ref clock for HS mode*/
>  			if (ufshcd_is_hs_mode(&hba->pwr_info))
>  				ufs_qcom_dev_ref_clk_ctrl(host, true);
> @@ -1343,9 +1339,10 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  static void ufs_qcom_exit(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct phy *phy = host->generic_phy;
>  
>  	ufs_qcom_disable_lane_clks(host);
> -	phy_power_off(host->generic_phy);
> +	phy_power_off(phy);

This change is not at all needed.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
