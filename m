Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFCF12BF3F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708092508; cv=none; b=lGjWwaNy0OxrmbEhxDNVjiw5XiURu/EZh/02pXc+NiS7sr4S+/4RTSP5C4+eMlpWjKcAXYP9f9ltQ7VzFYiRn3BoVe70W0kNg63W9AHWqK/dnh42Pf7HP4MY/GNnfN4esp4e5aFCu34NgrLBK5mx08UamgdgkZsBGrPbdXFF4PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708092508; c=relaxed/simple;
	bh=VWBsKuNrGY4MHfVRFud0fpjtMJD9nw9ddeYFNhkmHOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENHQxFXkdSaa5HwdEclBADaiWPt/NNsAoMWmGIAVwhHiTQCBxoOrvHW9DBE0qNUmNKmafDBLj0z5786zn82+/2UYB29VSH+lDENmwO9HLWSmdOxDPLl6uRSfoUa6w5lq2mv2l/wo4CpA+S3seVKsfeLMbry0d42eBh8jgnMlhdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JEJxSQkD; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JEJxSQkD"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dba6b9b060so5192995ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 06:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708092504; x=1708697304; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hDNGahqQJk0+PITO4aJ9GSNZ6MTNzgQKhJKA5SQZKi8=;
        b=JEJxSQkDlBSxDwr2A8IeMR85T+g8S+1tDUy1Cfi6B1n1uwMyXmUDPZVF363lc/8gFI
         OslOa/0P+EORrnKMizcJXnAhGbtxJXZnTKcM76Z8wEAlMW0VE7twP5CCp1n89bENMO4T
         d1LYqv0oWvSogkJ/HTe8SKyDChlQkMLzwOgAR3WVLGurUSFuM9wwY2SnNVhhsrkT8MLp
         +XiC7bxox//Im/muCdXrCO00Z+QLw1Nhg6IfVyEtZASLE3AL3jjAPuEBYK5QemohBx2L
         ChwP9L6AFosAh1jCm+U769bytLrJZ16v3YF6u8MWKB0K9CxsKsMPgvEBuhYhCkJAHWZ6
         TUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708092504; x=1708697304;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDNGahqQJk0+PITO4aJ9GSNZ6MTNzgQKhJKA5SQZKi8=;
        b=uAFXkdO8cLQxRm4QrhTGXNHOhODIH2cIf3iFMbdazWoeatBxHU7272eDcw0GGzqikX
         1G/iKwHqrbfW31x6oor273c8n6cI8u7vp75IzUxbHPmoWo0CSUs2sGYtKvwKnkqXtN+E
         NVphpavAAZLeQYfiZPjC8fsAF3Y6BO92fKsYvPGPUzu40mGbl2oCJs98t7pfvGDPWyBQ
         QCjZ8W9pzPIcSv4U869UCL3wOW4TbShMmp6sO24wXtqU302FLA8N1KWA+vdaagwKEmrM
         P/YSI5VNSqNDz8NqM6wzuLIb34X34B1gvBnRAX8CqPNDTwJFr7oEO2808zUlPWglX/bk
         ubdw==
X-Forwarded-Encrypted: i=1; AJvYcCWuEc0GKElAg8a2Ip13x9Nnvht2XjrXZ7scpU4jYgxJmhz9wWVZjHf/fZHe32yZYqKhiOiD4rvsTPm0cCZP9w0utfk4f2/oq/Gzqw==
X-Gm-Message-State: AOJu0Yzf4olD4RTDiTYA6cmtzCSTUXnP/h5gUgT8XVkQcdcEocgKl9cK
	PqTI2LGN/ckhTu0sSdl4812aTl3Su+ZCrrmKxu2mdHgXJ09jMwY5uEhLQCVKHw==
X-Google-Smtp-Source: AGHT+IEJ67yKNp9ZCPVkUP0bhXP3swDJdkIjJCRgMu0wYsy757xU1RvqSe3sdhXohwWYryr7nTgkZQ==
X-Received: by 2002:a17:902:7c8c:b0:1db:47bb:671b with SMTP id y12-20020a1709027c8c00b001db47bb671bmr9327518pll.19.1708092504602;
        Fri, 16 Feb 2024 06:08:24 -0800 (PST)
Received: from thinkpad ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id jl21-20020a170903135500b001d8e41b3f95sm3036484plb.51.2024.02.16.06.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 06:08:24 -0800 (PST)
Date: Fri, 16 Feb 2024 19:38:18 +0530
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
Subject: Re: [PATCH v2 6/6] arm64: dts: qcom: msm8996: drop source clock
 entries from the UFS node
Message-ID: <20240216140818.GN2559@thinkpad>
References: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
 <20240213-msm8996-fix-ufs-v2-6-650758c26458@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213-msm8996-fix-ufs-v2-6-650758c26458@linaro.org>

On Tue, Feb 13, 2024 at 01:22:22PM +0200, Dmitry Baryshkov wrote:
> There is no need to mention and/or to touch in any way the intermediate
> (source) clocks. Drop them from MSM8996 UFSHCD schema, making it follow
> the example lead by all other platforms.
> 

Okay, here you are dropping the "core_clk_unipro_src" anyway. So my earlier
comment can be ignored.

> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/msm8996.dtsi | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> index ce94e2af6bc5..f18d80a97bbf 100644
> --- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> @@ -2047,24 +2047,20 @@ ufshc: ufshc@624000 {
>  			power-domains = <&gcc UFS_GDSC>;
>  
>  			clock-names =
> -				"core_clk_src",
>  				"core_clk",
>  				"bus_clk",
>  				"bus_aggr_clk",
>  				"iface_clk",
> -				"core_clk_unipro_src",
>  				"core_clk_unipro",
>  				"core_clk_ice",
>  				"ref_clk",
>  				"tx_lane0_sync_clk",
>  				"rx_lane0_sync_clk";
>  			clocks =
> -				<&gcc UFS_AXI_CLK_SRC>,
>  				<&gcc GCC_UFS_AXI_CLK>,
>  				<&gcc GCC_SYS_NOC_UFS_AXI_CLK>,
>  				<&gcc GCC_AGGRE2_UFS_AXI_CLK>,
>  				<&gcc GCC_UFS_AHB_CLK>,
> -				<&gcc UFS_ICE_CORE_CLK_SRC>,
>  				<&gcc GCC_UFS_UNIPRO_CORE_CLK>,
>  				<&gcc GCC_UFS_ICE_CORE_CLK>,
>  				<&rpmcc RPM_SMD_LN_BB_CLK>,
> @@ -2072,8 +2068,6 @@ ufshc: ufshc@624000 {
>  				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
>  			freq-table-hz =
>  				<100000000 200000000>,
> -				<100000000 200000000>,
> -				<0 0>,
>  				<0 0>,
>  				<0 0>,
>  				<0 0>,
> 
> -- 
> 2.39.2
> 

-- 
மணிவண்ணன் சதாசிவம்
