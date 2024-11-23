Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30CA44C76
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2024 05:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732338147; cv=none; b=TUCQFlyY0RcwPRgee3viHgH4d+FGpZy6Y4eNvNGqxdwygcBZi1m1yvfpfignEb+xlZe1F43Vo06sJLKIcjbvI0/555JOyGHM6ztkKOhBgWSLUzPb8VpN0S5Quhw+FxyO3p0RsEvDHHOfDli5XbkrIIU7ok+YzwwUhslvtvVkHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732338147; c=relaxed/simple;
	bh=zjOPzxhTRbw2j6+fIjCCFGQDW5uDtavAIV+YKEFNIEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZTznZ40GRU+wOGuIpIkZfrmpq/H9t30nFO0nrNWVAtuUSesRIvEUfBF3SG6L/EqRosuhmuO0X2ee+brc+Q5fKmYCnAUyAW8Jv/LlEQiLosQm/fRi3GNKzHIvbd2ZAlkPBx1LfD6A+fWm2agY+wbPfufB1AdLxFNGNsJcVw56Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UGvj+ce3; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UGvj+ce3"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ea499f264fso2054605a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2024 21:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732338145; x=1732942945; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rhmp9T6hqY6qCxGgLf1l2rSHY8/g/1isCQt/alj6RtU=;
        b=UGvj+ce3u2G/ZUeF3lDlRjyzIcu1ha0OFG20YonXsfVLDlY81+JSf1u9IiMfHGwM24
         ZuWBbQ0TKHR+E3QyfLUvhv6LksCHEsIw23yDT36QgnsPPyMublPfhe711xU3xLxRjfvg
         ZZW588d6wEZFYsQqSbNZbQqj2pajZcPAnSX9mTgjkQ65XovX+FNwwsISLNPZNji7KZXl
         RVWJtmY5g8WRGa7USmbSaPZEXd9eKkMCTkbHnU2IhMmqMfigswwPeN2oj8ZhJkMKqA8T
         N/9BwiffIzdOPsz79O/4Xwpr5utyDPs8fpLCO2XGitvSdbe8eAGqjo/AeNpIYGn+i8O0
         maLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732338145; x=1732942945;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rhmp9T6hqY6qCxGgLf1l2rSHY8/g/1isCQt/alj6RtU=;
        b=CVywE8PckbXpHubsQ5XNc69HU7CBHbXRZCf9grpcH9/NMum5P1u2ttARHlAaMTzPIa
         eOQxB+nAh//8yzD5BDwEQFtsez16VfvBoUKrYPn2FaXnIZbB9jCp+S23HcuA3ym0AO2Q
         Hpj7lenYeWZj/V3mRMPDI6xtUKdsuXXKmvu1uHRFNRtF9iCOPuIovpqPNxlaiwKAhIZl
         w3as5QTDvI8ilspeXCXoqSPk3iHhdDZJ89z4IfabhxwnDgyRddZpsEogrYg86ZSyczcU
         Xnr7Lyry5yPc59MZDouDiQ/LhFamTT2+ML3a5PyuDW0ub3R3YOTtGAA6EQkkmGo6oPuK
         kyHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVocfpMzi4a5e6xiovaBtjJXRwGL6ZQX2d9AVgq5g7wHd9Kv46Axx2/EgrNRbmGMJaI9fKHsDvnilKT@vger.kernel.org
X-Gm-Message-State: AOJu0YyEPb+UY34OQrObbVoH8cSflS0/WaCGxe7KjCGm3PjPQz8D3dXf
	2Lh8pc8DTxF4EMVezTS6jgztGGmHdTohPtLXaFO4JxswPZ2dmCCL1g//AMilzA==
X-Gm-Gg: ASbGncuwAX3xc7Cvx59VLyRzz/SqZoLFklkI0H8yJsMett5oAg8DHB/VYs5dnP82pcg
	RdUFVClfnk8w0d9+0dz0n2Dyo/8M1zC6SRSmfSSE4chgc+qDM0aak/Hnf0N/+XyN9ge+S6k3Oq3
	sgHGyRnHQngwjqKt9zt6G/sQeNA+itocjo6PfHSAFp099YQf47SOq1E49pmwFWcSJEqCJZ9xdH+
	7NlDCRif9n1ISwU10IvscqHh8yLOWJyaTv2iRjAzoNxiVJdWJEZ4pUk66NCyMjh8A==
X-Google-Smtp-Source: AGHT+IGIoWjGItw7UGvc6ZH+fcq+M/D5fvZSF+vOrGMx1rf1QqGn6GShTrNo2FSHGH5NSI8p5dBK1g==
X-Received: by 2002:a17:90b:3d92:b0:2ea:5fed:4a32 with SMTP id 98e67ed59e1d1-2eb0cb9b800mr9292369a91.11.1732338145195;
        Fri, 22 Nov 2024 21:02:25 -0800 (PST)
Received: from thinkpad ([2409:40f2:101e:13d7:85cf:a1c4:6490:6f75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eaca647808sm3437052a91.1.2024.11.22.21.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 21:02:24 -0800 (PST)
Date: Sat, 23 Nov 2024 10:32:13 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 5/7] scsi: ufs: core: Export ufshcd_dme_reset() and
 ufshcd_dme_enable()
Message-ID: <20241123050213.kq5u7qaoeenzddfg@thinkpad>
References: <1731048987-229149-1-git-send-email-shawn.lin@rock-chips.com>
 <1731048987-229149-6-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1731048987-229149-6-git-send-email-shawn.lin@rock-chips.com>

On Fri, Nov 08, 2024 at 02:56:24PM +0800, Shawn Lin wrote:
> These two APIs will be used by host driver if they need a different

s/host/glue drivers

> HCE process.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
> 
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/ufs/core/ufshcd.c | 6 ++++--
>  include/ufs/ufshcd.h      | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 24a32e2..9d1d56d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4039,7 +4039,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   *
>   * Return: 0 on success, non-zero value on failure.
>   */
> -static int ufshcd_dme_reset(struct ufs_hba *hba)
> +int ufshcd_dme_reset(struct ufs_hba *hba)
>  {
>  	struct uic_command uic_cmd = {
>  		.command = UIC_CMD_DME_RESET,
> @@ -4053,6 +4053,7 @@ static int ufshcd_dme_reset(struct ufs_hba *hba)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_dme_reset);
>  
>  int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
>  			       int agreed_gear,
> @@ -4078,7 +4079,7 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_configure_adapt);
>   *
>   * Return: 0 on success, non-zero value on failure.
>   */
> -static int ufshcd_dme_enable(struct ufs_hba *hba)
> +int ufshcd_dme_enable(struct ufs_hba *hba)
>  {
>  	struct uic_command uic_cmd = {
>  		.command = UIC_CMD_DME_ENABLE,
> @@ -4092,6 +4093,7 @@ static int ufshcd_dme_enable(struct ufs_hba *hba)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_dme_enable);
>  
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>  {
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 3f68ae3e4..b9733dc 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1360,6 +1360,8 @@ extern int ufshcd_system_thaw(struct device *dev);
>  extern int ufshcd_system_restore(struct device *dev);
>  #endif
>  
> +extern int ufshcd_dme_reset(struct ufs_hba *hba);
> +extern int ufshcd_dme_enable(struct ufs_hba *hba);
>  extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
>  				      int agreed_gear,
>  				      int adapt_val);
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
