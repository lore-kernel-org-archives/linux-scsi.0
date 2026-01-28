Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A9B20DD52;
	Wed, 28 Jan 2026 11:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598269; cv=none; b=Sn5sCPb+5X87SetNhdUD5cA8tMVOgbiwgTyq2WQBLwyhFTq2BZZXWL4natrNpkJ/8rRrbVO2I/R/bPWCDTHIEi0lbGkTRw6T8/kR9dd8904RI6lIOdguxqSXkZshprGYZQ3e+wSZ6GWjx+GBh090WrBpfxz/9fHzl46dD4lPAxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598269; c=relaxed/simple;
	bh=7/uozxFIxOmCH7mbpkX5r5jLjm4gescIxl6O5bSGMoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CaRgCB8DHzVIhb/hK48+OrplVOvzNTBDutzE2eTbj3iVgFtLJz/7mz3poerCQg9ySaMdC7HWX5Of3UMcMiw/y9O8kT8JJbXm6GTobvO6K+7KfH9hOMDquHzjdAoCLP8OQufYsb+jn8gi9fQMf9xPCkhBEI4ZDjnkDgxAlpOTtJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtV4GQUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtV4GQUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9542EC4CEF1;
	Wed, 28 Jan 2026 11:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598269;
	bh=7/uozxFIxOmCH7mbpkX5r5jLjm4gescIxl6O5bSGMoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtV4GQUs7l23olpknFcXx1EkC9GAC5i2rZoYJT1mzmyM2w+6+zOURu+OGtDGJNLe6
	 mtJwMYS4UVX7pg/FECkf9e4QlS1FdMLJWiSG8zSI9wdybnoxv1EtO+yq13qqwAMQgB
	 RX+ZxtGjrL3dslyd3mimFLvbfdQh9eNpYVRXkJ5twX9ASGA/xhSNsojCYmf9Nc4l67
	 VzE7cPYVKq9/dpecPtdK5g49Elf/JRl61iOxwTB+aBfNtJ/OEb4jpzf60/pzYD8bYN
	 wU7ZqgbiXpyQQgocdOJ9+8ld0l1FS76IsUXP9MWzNuXYfeAHUeu1oVO1n6tGDvuEoc
	 CI9t7mM8cOWDg==
Date: Wed, 28 Jan 2026 12:04:26 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <20260128-daft-seriema-of-promotion-c50eb5@quoll>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>

On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
>  	struct qcom_ice *engine;
> +	struct dev_pm_opp *opp;
> +	int err;
> +	unsigned long rate;
>  
>  	if (!qcom_scm_is_available())
>  		return ERR_PTR(-EPROBE_DEFER);
> @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  	if (IS_ERR(engine->core_clk))
>  		return ERR_CAST(engine->core_clk);
>  
> +	/* Register the OPP table only when ICE is described as a standalone

This is not netdev...

> +	 * device node. Older platforms place ICE inside the storage controller
> +	 * node, so they don't need an OPP table here, as they are handled in
> +	 * storage controller.
> +	 */
> +	if (of_device_is_compatible(dev->of_node, "qcom,inline-crypto-engine")) {

Just add additional argument to qcom_ice_create().

> +		/* OPP table is optional */
> +		err = devm_pm_opp_of_add_table(dev);
> +		if (err && err != -ENODEV) {
> +			dev_err(dev, "Invalid OPP table in Device tree\n");
> +			return ERR_PTR(err);
> +		}
> +		engine->has_opp = (err == 0);
> +
> +		if (!engine->has_opp)
> +			dev_info(dev, "ICE OPP table is not registered\n");
> +	}

Best regards,
Krzysztof

