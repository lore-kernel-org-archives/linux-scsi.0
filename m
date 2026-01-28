Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE4E23AB87;
	Wed, 28 Jan 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769608755; cv=none; b=XZ6TwDEwcpricMlbeKyy81qPEBeJkf7tNe0vD4UEvQHNaT4+DXFpcGASq1P/d3yaj5DNTKEJTtStZ1IvNGKOYRLMDhS/8FkVYv72z/ZdfhovpCKJ6Rl/PRZVST5yhJ2svzWMUNsOEhm0sVmKwQIwXb0aaalQl713tnaYxKN38mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769608755; c=relaxed/simple;
	bh=BbkwA4sLYf9MXn9IFE0aVRoeQkyUQkWRGCVQC9g+yeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bH7aX70KgkEAh31lE/9FsCtBRphHCKEGY6Xo6I/qXSHUJyleI7LMRb6vam8P8fsmxPa8cND16/HxPEALHm6bEpJt95elIQVQbD/v+1XUufop9Ds1GaNe9KdYMV8D4/NgYUJnbsL51qQPxiYiPW9p05UwXJ0bP71BypKw+UQFkio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4/Vj3HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4/Vj3HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A9C116C6;
	Wed, 28 Jan 2026 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608755;
	bh=BbkwA4sLYf9MXn9IFE0aVRoeQkyUQkWRGCVQC9g+yeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q4/Vj3HFip2DLLPD+uiq8A/Gfvr3DBQpZMUEXM55RdjSTHWrONp6/t6AR+T3kgv1U
	 96saqUCQJSvsa68LJP6hc2Jsybsm55ktDCAdxpzCf5vjsYLrAqHXH8eU3oAaHx093D
	 gI9tUBcb7FWp1UXiM45l6kjjv92AJdXKN46a2tFDXgpgWtSaapYWxK0zkWpkboPZ8M
	 yC+Vcpc84JyoAUvKylxtSelFA8VwhaAtNJvGyaqbrHlX2eNgHQYskcObWYeRtzPwFu
	 GbpheYZ224Qd4aCJL8F7YbCHfIP4swbItg01e2kpTumxRnf/INL10yFmIJcVQ0SYud
	 f+mGFd9Sw5S6g==
Date: Wed, 28 Jan 2026 19:29:06 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Neeraj Soni <neeraj.soni@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Message-ID: <yvvdockkj47mvoqtxjd4dgysejpkqvoo2vqsnpw2chr46ugtx3@3cgasvkd62kz>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-3-260141e8fce6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-3-260141e8fce6@oss.qualcomm.com>

On Wed, Jan 28, 2026 at 02:16:42PM +0530, Abhinaba Rakshit wrote:
> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> UFS controller clock scaling. This ensures that the ICE operates at
> an appropriate frequency when the UFS clocks are scaled up or down,
> improving performance and maintaining stability for crypto operations.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8d119b3223cbdaa3297d2beabced0962a1a847d5..00cb9cde760380e7e4213095b9c66657a23b13ee 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
>  	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
>  }
>  
> +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> +				  bool scale_up, unsigned int flags)
> +{
> +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> +		return qcom_ice_scale_clk(host->ice, target_freq, scale_up, flags);
> +
> +	return 0;
> +}
> +
>  static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
>  	.keyslot_program	= ufs_qcom_ice_keyslot_program,
>  	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> @@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
>  {
>  }
>  
> +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> +				  bool scale_up, unsigned int flags)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
> @@ -1646,6 +1661,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
>  		else
>  			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
>  
> +		if (!err)
> +			err = ufs_qcom_ice_scale_clk(host, target_freq, scale_up, 0);
>  
>  		if (err) {
>  			ufshcd_uic_hibern8_exit(hba);
> 
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
