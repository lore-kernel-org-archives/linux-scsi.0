Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41D12C525
	for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 13:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708091730; cv=none; b=oFAJ/GHoGtJJnUU4mOtzH3jsHfoHy6dJ6Gs2nuDWsqBmxEbmGK2SzGRz1Wv4Ft4mraG/vw0SJy6JWGWkzqzDFMVgE9bs0Rozdmko47RyK+uEx9uTwa+tMc1GaiZ1oKxsSQd54GIfqrbT2h4B6F99T3chumek+i5fu/eYipWypLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708091730; c=relaxed/simple;
	bh=/mmB228C/BQ7s2uCVtfW3Iw03rGkUt4iO7SoUQ3CO14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mp0KBQBq2lYJuRbjMuZioxdehgKsAZg9YxL1/80XIbGeEtoHae1preEgYdmiD/C1yy3Q+QHpyxvGk5gt0Jf4lvZHx55BPRZ1hi+v3QqtKfgfyCrhj9gvLTrxHWrh/QhPTVqvHPSMYNZ4mQ6/kJspC/7Lw9O2AkY8PLFYBFUFBKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KMb2w7Vv; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KMb2w7Vv"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e0a37751cbso1854555b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 05:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708091728; x=1708696528; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bI4Ce7Y+3/vThHJnrphpGJSZUsrKr18V/3gqTitmj3k=;
        b=KMb2w7VvfHy9uJGSCtwR7cKMjaC/XnldpWPtUnVsDC7mjx3yw3LA080p98CPQw/+1Y
         dSPqAmTCKAb9iCSwJlyG+E6ouJTL55gmBMIRq3GgY2UaJ86FiUKvGeHghPWbgCwOSXrG
         Md+EP8mPhRdY/YsS1cGStuExDLPfQ/S0R+KQbvcdm9iMiLQ9b2/ULMzvzRE0eWgJw6D+
         WM6B+VFjr4PMUxSKH5axAEcodHDV9yYCfUrD+sURtU+L91njKfU09jyOF6Q+gln4Jqk7
         zC2apHriOND5d08UpwMvIb2zPmtL+yZ8ZbgypcvQtNgIOKdA2Why1iASp2p4zjXPb1p7
         0sig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708091728; x=1708696528;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bI4Ce7Y+3/vThHJnrphpGJSZUsrKr18V/3gqTitmj3k=;
        b=NHY4opsa0CiBgZU3RpDrImG1M+h63c1GCgYSmnncOW4VZGjF+mXsxOn68GJQeW8tIV
         TFr0EJhedBZpF+SCpdCpLiKtVJlPuVHZRMfcIL+Hmx2C676opaGFysg1Xv8Z+SnoQlaV
         0yafBSOCHFwVtJbg9BEHNHE+cHBPmizVV88YMxiVMYJMuT8skC9p52j0ve+1QFTgC4n4
         ymp1eCtqhqCGbdxxmuhr/lMxWibum7N+o6MNnnO62e3F+JYBWrZjJLgFG0vtPry3S0B3
         a2KTUItoHd2oiYEK4PXMktCBkMOJUSzZnE1FCS3ipWilW+2UYGjdfDeUfwARiDUexZdY
         6xug==
X-Forwarded-Encrypted: i=1; AJvYcCXzE5HluMZKf6WTe3oxFuRAv+kPtoec8RPnHcSgKCjkmPRLTZvMBtT0EbRMPij4Sw5JO7b8MzNnQpQJGlNYoAd3tfrmffk4EmXNcQ==
X-Gm-Message-State: AOJu0YxPaCDXpKIWDfWn3cOO7GhVCx4Da1zZd6P//h91A5ADzJhA0UGo
	7Bn4uZqcCbBrEvUDJFxw8JqJ36MM2mj15wya67yfy0VFetyPnizmnwm/KQ46+w==
X-Google-Smtp-Source: AGHT+IG5X9pFHNpEVClMkRvB4oUBk5uuCFFhE0K0bOxMjLfz7CmeR6OBbOeQW+aMCqoelUXN6nRq/A==
X-Received: by 2002:a05:6a00:2d81:b0:6e0:9da7:8cfd with SMTP id fb1-20020a056a002d8100b006e09da78cfdmr6229080pfb.5.1708091728322;
        Fri, 16 Feb 2024 05:55:28 -0800 (PST)
Received: from thinkpad ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id r17-20020aa78b91000000b006e08d628e2asm3181579pfd.19.2024.02.16.05.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 05:55:28 -0800 (PST)
Date: Fri, 16 Feb 2024 19:25:22 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] arm64: dts: qcom: msm8996: specify UFS core_clk
 frequencies
Message-ID: <20240216135522.GK2559@thinkpad>
References: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
 <20240213-msm8996-fix-ufs-v2-3-650758c26458@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213-msm8996-fix-ufs-v2-3-650758c26458@linaro.org>

On Tue, Feb 13, 2024 at 01:22:19PM +0200, Dmitry Baryshkov wrote:
> Follow the example of other platforms and specify core_clk frequencies
> in the frequency table in addition to the core_clk_src frequencies. The
> driver should be setting the leaf frequency instead of some interim
> clock freq.
> 
> Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> index 80d83e01bb4d..401c6cce9fec 100644
> --- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> @@ -2072,7 +2072,7 @@ ufshc: ufshc@624000 {
>  				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
>  			freq-table-hz =
>  				<100000000 200000000>,
> -				<0 0>,
> +				<100000000 200000000>,
>  				<0 0>,
>  				<0 0>,
>  				<0 0>,
> 
> -- 
> 2.39.2
> 

-- 
மணிவண்ணன் சதாசிவம்
