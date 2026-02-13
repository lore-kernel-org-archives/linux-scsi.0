Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531993EBF33;
	Fri, 13 Feb 2026 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770944575; cv=none; b=FNNIsLfFyH3TaroHblwyF+TD2VWF2IU6RMKmhNXEc3OEURMBCNFBqiIkOQ2psHcqkqiirt3EY5F49ejnBBmM8XbTJYTqgLZhKXFVvaZI9YsW8zrMEKnOqw3hfzqgvm5A5I3SCgn4wlszvefJ/CmH2ofrlrcw2LwRDL0Ke69c2CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770944575; c=relaxed/simple;
	bh=KwbmCqQa/Q37dD8NJdF3IkFjL0StaTgXiGrl/kaJs5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPaNHGvHT7Ilopg77ovsCEDwvjKKEwWacfk1Bf8XLe8amtRJJk4GzhjxqahKnRKkbIWx4pX7YdtVABdjduzISUZUnMKz1Or5zNbGH2oQKrEJu9KSBO9uLib2n0Kd/Px/Y+nRoA1sjxffg1opo626tU9CVDLNIyAnJbltgx7Dfos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1r/4Yxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1r/4Yxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F376C4CEF7;
	Fri, 13 Feb 2026 01:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770944574;
	bh=KwbmCqQa/Q37dD8NJdF3IkFjL0StaTgXiGrl/kaJs5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k1r/4Yxz7bCefYO+ld67cg3Bg1TPvFMtLZxiDotgFV/1EE86IolC4qpNqp2Mp/RCy
	 0fy0cSCyNtjTmBWiQ77+78NduSt+GWYmjnFvDxs8CBtcLMGv7mb1DX6JgNxtFoY3L1
	 DEjgpdi899HXRRQAn5rNrxP2U/PZooLV6dVFJCgMtBCMC4Kz9Tqd3HgGZWdLHffYVH
	 hL0uj7J4B01tLYLd5n8E1DjU8C4IYDeYA9/VYamdSuBTAh9+JY81YNT9r4TzPP2hnm
	 8yN78C7o4TLtT/LEfz5L+ccWzn7XHxIMqVipKdRAHCsKkCxESD1LO0x8/qd6IeXbkl
	 fm6voAeBhpjIQ==
Date: Thu, 12 Feb 2026 17:02:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org,
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: Remove platform_driver support
 and expose as a pure library
Message-ID: <20260213010253.GA6208@quark>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>

On Tue, Feb 10, 2026 at 12:26:50PM +0530, Manivannan Sadhasivam via B4 Relay wrote:
>  drivers/soc/qcom/ice.c | 118 ++++++++++++++++++-------------------------------
>  1 file changed, 44 insertions(+), 74 deletions(-)

I don't yet know enough to be confident that this is the correct fix,
but there are a few things I noticed that look like bugs:

> +static DEFINE_MUTEX(ice_mutex);
> +struct qcom_ice *ice_handle;

ice_handle is used only in this file, so it should be static

> @@ -643,41 +645,42 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
[...]
> +	ice = qcom_ice_create(&pdev->dev, base);
> +	if (IS_ERR(ice)) {
>  		platform_device_put(pdev);
> -		ice = ERR_PTR(-EINVAL);
> +		return ice_handle;
>  	}

This error path returns NULL, where this patch seems to have been
intended to remove NULL as a possible return value.

> -static void qcom_ice_put(const struct qcom_ice *ice)
> +static void qcom_ice_put(struct kref *kref)
>  {
> -	struct platform_device *pdev = to_platform_device(ice->dev);
> -
> -	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> -		platform_device_put(pdev);
> +	platform_device_put(to_platform_device(ice_handle->dev));
> +	ice_handle = NULL;
>  }

Elsewhere ice_handle is protected by ice_mutex, but this seems to modify
it without holding the mutex.

I'm also wondering what happens if all consumer devices are removed.
platform_device_put() gets executed on the ICE platform_device for each
one, but does that actually drop the last reference and cause the
resources allocated with devm_*() to be freed?  On do they stick around
until/unless the ICE device is actually removed as well?

>  static void devm_of_qcom_ice_put(struct device *dev, void *res)
>  {
> -	qcom_ice_put(*(struct qcom_ice **)res);
> +	const struct qcom_ice *ice = *(struct qcom_ice **)res;
> +	struct platform_device *pdev = to_platform_device(ice->dev);
> +
> +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> +		kref_put(&ice_handle->refcount, qcom_ice_put);
>  }

Above probably should use the ice local variable, not ice_handle.

- Eric
