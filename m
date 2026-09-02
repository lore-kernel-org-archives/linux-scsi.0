Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB634A9D53;
	Wed,  2 Sep 2026 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364977; cv=none; b=LIlCeM1LLx1d8FPcz7OEWv7JEM/GMO4q0sstQ/siWFlv7I0c0TOEU5N6s4TSzmRc4/Zur/29znAVDHi1VybyXTKB5+VXVJUIBIcLOPkHXEQEqFDuVIyg6Qejmd/yyzoCCtpAhce5tSwNb35IaIogiVUwlLLgM9GTzi3CudNBc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364977; c=relaxed/simple;
	bh=7iVzUh0zioODOodF1Rwg5C53OEgf62D43rRzgxYzaVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj47JkdM6fDwnEQ1CKIMsyUhMGmVw4qohv5Z+FCZ7kJOD3UDSL68J3ltk7naqdGEC4bvlWLrhCuGlTd7naQ62Uv7zFS31G/nAddUrBPjkC8yrFMWkxm+fcB73IdAlbCXIEtwEgtcfd8n4WeAQXBYULIcjDfk54gm6LVJPHNRgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su9T4Gt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su9T4Gt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200631F000E9;
	Wed,  2 Sep 2026 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364976;
	bh=Nj28vaLOO0uawDNiRwYo07ewHwXj6jAmi5zGzF7SIm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Su9T4Gt5de6jopHYj5MlbmKVG2PNn22UD+JE+rYOec4VQkAT3DcFR+OjcB5FBd4L5
	 jvGcJKxZtz3IfpOYmAQcXMV/IPfngz5DGQFCEpfRT1zLwxnwEEsV/TvBhHhjwaMkyF
	 1Jew/OMO8u79i20JUVw91WGmcTcMqUX07ToU6UpmelQrQNpLtFae05Q8LXWfkJ1XVe
	 jl7Avw/RMPJle5WOSQMA9wv+azptP3SNP/6VHkGEIGv/up4zK+ndeGJGdr8zwHxW1t
	 LfKiw0sAjfX9ZMnXO405dkrCCheRPNWnkqU1k0vWb3rsAOAk1K02/8X7t2RaN7pI8m
	 1bIuo5eJ3aQ9w==
Date: Wed, 2 Sep 2026 18:02:43 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org, 
	andersson@kernel.org, konradybcio@kernel.org, James.Bottomley@hansenpartnership.com, 
	mkp@kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Ziqi Chen <ziqi.chen@oss.qualcomm.com>
Subject: Re: [PATCH V1 1/2] scsi: ufs: ufs-qcom: Add specified gear support
 for multi gear scaling
Message-ID: <stik7u2o6ydje6ws7cyrltmdw4wz6iyximnxeyegw2f562b2bv@4m2sueuuzisb>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>

On Sat, Aug 29, 2026 at 01:13:54PM +0530, Nitin Rawat wrote:
> From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
> 
> The UFS clock frequency and gear speed do not necessarily have a strict
> one-to-one correspondence on all platforms. Introduce a device tree
> based configuration interface that allows specifying the HS gear
> speed for each supported operating frequency via the "opp-level"
> property in the OPP table. When this property is not configured, the
> driver falls back to the default frequency-to-gear mapping table.
> 
> Signed-off-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 0f2e083b04fd..aa2ac2cd2b69 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2460,8 +2460,9 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
>  	bool found = false;
> 
>  	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
> -	if (IS_ERR(opp)) {
> -		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
> +	if (IS_ERR_OR_NULL(opp)) {
> +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
> +			__func__, freq);

Don't bring back the '__func__' marking please...

>  		return 0;
>  	}
> 
> @@ -2489,12 +2490,32 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
> 
>  static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
>  {
> -	u32 gear = UFS_HS_DONT_CHANGE;
> +	struct dev_pm_opp *opp;
>  	unsigned long unipro_freq;
> +	u32 gear = UFS_HS_DONT_CHANGE;

Nit: Preserve reverse Xmas order.

> 
>  	if (!hba->use_pm_opp)
>  		return gear;
> 
> +	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
> +	if (IS_ERR_OR_NULL(opp)) {
> +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
> +			__func__, freq);

Drop '__func__' here and below.

> +		return gear;
> +	}
> +
> +	/* Get HS gear speed from 'opp-level' */
> +	gear = dev_pm_opp_get_level(opp);
> +	dev_pm_opp_put(opp);
> +
> +	/*
> +	 * Greater than max gear means that there is no specified gear configured in DT
> +	 * or the specified gear is invalid.
> +	 */
> +	if (gear <= hba->max_pwr_info.info.gear_rx)
> +		return gear;

Sashiko pointed out a valid concern with this check, please take a look.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
