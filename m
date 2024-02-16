Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECA912C809
	for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708092331; cv=none; b=IQk/ubv3rqrpL41JG/faTid1fzOH4JPnyjhOHmnyFvHa8JB3v0mEY21lRHxFSn8vfK7/FLfzsvCJn+1AxoitWLkRQCHdP4iTwopxoRplqSfIXE0twRMVKmQ2nVYFm5/1HME31Rgj6/Q4zRs8OlISYldHZyvpVXX3yDy1AN0FLSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708092331; c=relaxed/simple;
	bh=F8midk/T+omEqYMOQEp3ihmjyhJ5UadddKfjPp7cwrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnU72E5upH+Axo5oCEPn5FO0vTtzca3csPrkKfsA+lU5A5tGw4kadE0TGSAaPy1d3Jy0vAjYyPIQdH67BWumA+cP7yk7Wtk5EEvXNXrqLicqz6+1pvRIyPGzv1CoeuKRsb7oe+v+LW1Nx0CmGagluDgtYCpoXYcTUF0Z/ItCar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a2Xb97On; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a2Xb97On"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e10e50179bso1529651b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 06:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708092329; x=1708697129; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oZufnX9tFnQjoiNUPIE21T+F66j9xwWMF6VYP2fLe/4=;
        b=a2Xb97OnLh4JVfLTfeaTUWfn/bPVLRmMYsAosIsJj9HyAGnaQmdZNjw3vIyMCbaSgg
         otyX58j2hcM29jm0Yea6jzXR+YOUYuw4gnbDvj9L7V9KhNb+6gjkWc9hCn0Rk12+2NTc
         ZtrFdt+dxY9lKxiW4gLD8NGngY0A9Z1Kkhlj0oPp3LBN6xOXx8LMuck96o8XaDEs8+V0
         pLnF8jvhxhokrJQZuUlyvt5aPVLg7jwCm/nOd6+PHBCzjk5VTRlRCCNkfih/QVYWeEAu
         K1bB0aC4kRt0wCWDcXkQn002ZZoLFtI79TUI7iWO9GzV5koNeE98E69dzxGZLaNTDxkr
         1dQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708092329; x=1708697129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZufnX9tFnQjoiNUPIE21T+F66j9xwWMF6VYP2fLe/4=;
        b=a2qXXALfx+a4aGDqkpuhp4knwvUkD8pCj26muRWR06YTtZUeH/USVqfGMGLl0vf1rB
         GUc4sFzzegP0O5IPrKPYP0asvFVZkNy8CbkTv/oj4iTb5H5AnRWlx/O+Tx2fWP3yDrQ0
         MpyMDsqIZu8t0K/n8jWWYLKCH1iudUSxD9MLhL27dx4lCB4im8GhQsKe9Uu8QhSFA48K
         sElLiB3z9RfdAONOBlF+RdN6o7ss5CtrNxvskPtZ73H3WYskMNB30tuzB9AugTc0z6Bo
         9zAIqC4rLwav/iD0Ox4EVcHOKrmNMSiMzbMQ/sA6VQ4rvrJcQGJIRSHRrUEzY2Q5mqDj
         KAyg==
X-Forwarded-Encrypted: i=1; AJvYcCWvZ4ghZyspdLUr3GiNymdr5ZnOFQMIsBpwnwRiv2REFrJnHRutLgo4MkexTqm3+X0F40cqNaURcC/8Q+GfoFc9PZb3r4iRcMdSTQ==
X-Gm-Message-State: AOJu0YzeOMblzRqGFWrl99EHcH/IeFh6cSiRWaa+OAlqU1fxsqC7iOrg
	CYrKl9xtKodiyQ3lehEvKckOnQOv3RhQAC8/DbRGaxMFjaG9nC5SnYamR8vyrA==
X-Google-Smtp-Source: AGHT+IGIJLu2xD9WGLhIgNSyonAe5waClziHCq3k+o8/45VHBkgDyawGWbdNR9czUymA9dr7fOD03A==
X-Received: by 2002:a05:6a20:c6ca:b0:19e:a1a2:60f6 with SMTP id gw10-20020a056a20c6ca00b0019ea1a260f6mr6534298pzb.57.1708092329236;
        Fri, 16 Feb 2024 06:05:29 -0800 (PST)
Received: from thinkpad ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id m20-20020a63f614000000b005dab535fac2sm3279726pgh.90.2024.02.16.06.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 06:05:28 -0800 (PST)
Date: Fri, 16 Feb 2024 19:35:22 +0530
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
Subject: Re: [PATCH v2 4/6] arm64: dts: qcom: msm8996: set
 GCC_UFS_ICE_CORE_CLK freq directly
Message-ID: <20240216140522.GL2559@thinkpad>
References: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
 <20240213-msm8996-fix-ufs-v2-4-650758c26458@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213-msm8996-fix-ufs-v2-4-650758c26458@linaro.org>

On Tue, Feb 13, 2024 at 01:22:20PM +0200, Dmitry Baryshkov wrote:
> Instead of setting the frequency of the interim UFS_ICE_CORE_CLK_SRC
> clokc, set the freency of the leaf GCC_UFS_ICE_CORE_CLK clock directly.
> 

"clock", "frequency"

> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

> ---
>  arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> index 401c6cce9fec..ce94e2af6bc5 100644
> --- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> @@ -2076,9 +2076,9 @@ ufshc: ufshc@624000 {
>  				<0 0>,
>  				<0 0>,
>  				<0 0>,
> -				<150000000 300000000>,
> -				<75000000 150000000>,
>  				<0 0>,
> +				<75000000 150000000>,
> +				<150000000 300000000>,

Btw, I noticed that this platform is passing UFS_ICE_CORE_CLK_SRC as
"core_clk_unipro_src" which looks wrong.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
