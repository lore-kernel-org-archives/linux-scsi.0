Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7A24C076;
	Mon, 23 Feb 2026 20:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878908; cv=none; b=FjLYFOjji/RL9MgFbwFjG9gSk4eZgPxDfPYIRclkV7GFR6s7AYL4kwnVb4GbMqSIZzFg+7jPqkFsB0LA1azFKZPqla2L5KebTMGlmzo23nhEFs40ZxdxVjHqp5/LfwoxmwUSn/E0bW3CYlv8cAypv4wDX23A7KAXyuWUHts62rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878908; c=relaxed/simple;
	bh=rOqSdRScNFD29t+Pk6i05NgN3EhYNGzQOGIkyT1MpKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYzKRlq0i6RTAcZWRJ/gh5guhsQAAHNwtmSD2HaDjJnQWZNrc9ffd/FSG3ng0UdV7EDmZur292ABGwXhL39XCTzvTlv65XKm2SZdVp0CyUVRgTTPeHk9CNx76+SF+ID3n1iDct48+PmblNOIufXKnYT/HuY2nh+1sJ24RccnJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTDwjTaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTDwjTaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382F5C19421;
	Mon, 23 Feb 2026 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771878907;
	bh=rOqSdRScNFD29t+Pk6i05NgN3EhYNGzQOGIkyT1MpKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YTDwjTaY1ti8LJ0EyGob64e68Sxmt9wuBPSpSfdDHG/n4Yi3vIFcdkGd97DTKZ9vz
	 7+M1I7ZjM+0uT9ucuRrloNrhMqm8bvItgf/mEetZB4HoeSe2y+UWW+Ua7R51G4lccc
	 SAVl2nZEtCfFyegsO3i7K2/vdag/R2lWNo91l0tdQIHylgpf/OTdTb8TnuPCcfhMde
	 gLdkOtLztpS3OIQ1GfBAIcHtiLd74xSRvZ3UtF531uwv1VNEt+70vQOCbx4FiFR/kL
	 HCn7f+bsmD3Pzh5tWy48AlxIln8ea0s38uN05xG057Psk/9XDIW04bLE409hldciKs
	 LQ6WF5NQlBJqQ==
Date: Mon, 23 Feb 2026 14:35:04 -0600
From: Bjorn Andersson <andersson@kernel.org>
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Konrad Dybcio <konradybcio@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] soc: qcom: ice: Fix race between qcom_ice_probe()
 and of_qcom_ice_get()
Message-ID: <h2uhrsjlvovjcj7k2ckpkgrhpuwm6biun4ueq7kyzcm4hqcsjr@y3iiqx2vo6s2>
References: <20260223-qcom-ice-fix-v3-0-6ca5846329f7@oss.qualcomm.com>
 <20260223-qcom-ice-fix-v3-1-6ca5846329f7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223-qcom-ice-fix-v3-1-6ca5846329f7@oss.qualcomm.com>

On Mon, Feb 23, 2026 at 01:32:52PM +0530, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> The current platform driver design causes probe ordering races with
> consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
> probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
> with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
> be gracefully disabled. devm_of_qcom_ice_get() doesn't know if the ICE
> driver probe has failed due to above reasons or it is waiting for the SCM
> driver.
> 
> Moreover, there is no devlink dependency between ICE and consumer drivers
> as 'qcom,ice' is not considered as a DT 'supplier'. So the consumer drivers
> have no idea of when the ICE driver is going to probe.
> 
> To address these issues, introduce a global ice_handle to store the valid
> ICE handle pointer, and set during successful ICE driver probe. On probe
> failure, set it to an error pointer and propagate the error from
> of_qcom_ice_get().
> 
> Additionally, add a global ice_mutex to synchronize qcom_ice_probe() and
> of_qcom_ice_get().
> 
> Note that this change only fixes the standalone ICE DT node bindings and
> not the ones with 'ice' range embedded in the consumer nodes, where there
> is no issue.
> 
> Cc: <stable@vger.kernel.org> # 6.4
> Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
> Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 44 +++++++++++++++++++++++++++-----------------
>  1 file changed, 27 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index b203bc685cad..3c3c189e24f9 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -113,6 +113,9 @@ struct qcom_ice {
>  	u8 hwkm_version;
>  };
>  
> +static DEFINE_MUTEX(ice_mutex);
> +static struct qcom_ice *ice_handle;

Did we get confirmation that in the UFS + SDCC case, there's only a
single ICE instance per SoC?

Regards,
Bjorn

> +
>  static bool qcom_ice_check_supported(struct qcom_ice *ice)
>  {
>  	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
> @@ -608,7 +611,6 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  static struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> -	struct qcom_ice *ice;
>  	struct resource *res;
>  	void __iomem *base;
>  	struct device_link *link;
> @@ -631,6 +633,22 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  		return qcom_ice_create(&pdev->dev, base);
>  	}
>  
> +	guard(mutex)(&ice_mutex);
> +
> +	/*
> +	 * If ice_handle is NULL, then it means the ICE driver is not probed
> +	 * yet. So return -EPROBE_DEFER to let the client try later.
> +	 */
> +	if (!ice_handle)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	/*
> +	 * If ice_handle has error code, then it means the ICE driver has probe
> +	 * failed. So return the handle for the client to digest it.
> +	 */
> +	if (IS_ERR(ice_handle))
> +		return ice_handle;
> +
>  	/*
>  	 * If the consumer node does not provider an 'ice' reg range
>  	 * (legacy DT binding), then it must at least provide a phandle
> @@ -647,24 +665,16 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  		return ERR_PTR(-EPROBE_DEFER);
>  	}
>  
> -	ice = platform_get_drvdata(pdev);
> -	if (!ice) {
> -		dev_err(dev, "Cannot get ice instance from %s\n",
> -			dev_name(&pdev->dev));
> -		platform_device_put(pdev);
> -		return ERR_PTR(-EPROBE_DEFER);
> -	}
> -
>  	link = device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_SUPPLIER);
>  	if (!link) {
>  		dev_err(&pdev->dev,
>  			"Failed to create device link to consumer %s\n",
>  			dev_name(dev));
>  		platform_device_put(pdev);
> -		ice = ERR_PTR(-EINVAL);
> +		return ERR_PTR(-EINVAL);
>  	}
>  
> -	return ice;
> +	return ice_handle;
>  }
>  
>  static void qcom_ice_put(const struct qcom_ice *ice)
> @@ -716,20 +726,20 @@ EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
>  
>  static int qcom_ice_probe(struct platform_device *pdev)
>  {
> -	struct qcom_ice *engine;
>  	void __iomem *base;
>  
> +	guard(mutex)(&ice_mutex);
> +
>  	base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(base)) {
>  		dev_warn(&pdev->dev, "ICE registers not found\n");
> +		ice_handle = base;
>  		return PTR_ERR(base);
>  	}
>  
> -	engine = qcom_ice_create(&pdev->dev, base);
> -	if (IS_ERR(engine))
> -		return PTR_ERR(engine);
> -
> -	platform_set_drvdata(pdev, engine);
> +	ice_handle = qcom_ice_create(&pdev->dev, base);
> +	if (IS_ERR(ice_handle))
> +		return PTR_ERR(ice_handle);
>  
>  	return 0;
>  }
> 
> -- 
> 2.51.0
> 
> 
