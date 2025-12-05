Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0714748F;
	Fri,  5 Dec 2025 08:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764923269; cv=none; b=YNLh1HMrKg6r8UqDXkic6wjA8ANelA+kfP+nWYqD9gcqM8cdf0BVlDQZRB78ZMdrGs2ZoOb0A1xf1ysQP4kowbDph4HDI4B5T0WIcvVIolXG8InandP4XJD+50Wow0PQ/3TKpiXLVqSRwcT9OXfMj+tcREVvrQ/q8M3XV531uVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764923269; c=relaxed/simple;
	bh=IZ2XV1fuJ0dsX1cUeZ0IY7kEM2PD4j8YgIWcMGoGpSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYMsORdh32PcEZRMc2xXzcy33VvuEXXHtLbN61ICnUBdka9+aQCEoYh0OO65oFMf0bzSGlEY8HxQx+DispZRSyhdrajPp9lglcsvsMT9jv/F9id0XLcZvekYyDie06CApgWEnTP1x5RWo9EzeFjgMY9e1zfQil38xNtdD25q0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2UbgPSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2UbgPSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37E7C19422;
	Fri,  5 Dec 2025 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764923268;
	bh=IZ2XV1fuJ0dsX1cUeZ0IY7kEM2PD4j8YgIWcMGoGpSI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E2UbgPSoEDus38EnLmwpDvPQcWy6deAQZcs4tUXbaP6zkY/mKRSWtyHiIed2HlHzz
	 BTzuVTzymagiRWOG9GQgEFkqUn7c9PjjRjj+L9jn4ltgE9XGmulFh+pe+riti8BghK
	 Qo7EgmzX7hHwCp0cOmn4R7XAZ8pnx0EnbmOTPdtDyznrkZ+TKPYpKZj+F9EXqYHIWA
	 677Ab2x3/+MokK9XoxFG7aI2im4Rf50kxDjhgd+7t6VSNmXNK/1omedw0QQneHzeyn
	 Kb/ISaUYNkkwbe1qvk8JSrjCQsrMb/RaNImXt4Nd2Ts1DxZv34ZBYi5TkqE9vx4KOb
	 vFIBQRPuAlaGA==
Message-ID: <fbaefe65-3400-48a7-903a-708fa1ffcf00@kernel.org>
Date: Fri, 5 Dec 2025 17:27:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Add error handling in the
 sas_register_phys()
To: Chaohai Chen <wdhh6@aliyun.com>, john.g.garry@oracle.com,
 yanaijie@huawei.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251205080252.1020028-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251205080252.1020028-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/25 17:02, Chaohai Chen wrote:
> If an error is triggered in the loop process, we need to roll back
> the resources that have already been requested.
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
>  drivers/scsi/libsas/sas_phy.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
> index 635835c28ecd..455118c7e889 100644
> --- a/drivers/scsi/libsas/sas_phy.c
> +++ b/drivers/scsi/libsas/sas_phy.c
> @@ -116,6 +116,7 @@ static void sas_phye_shutdown(struct work_struct *work)
>  int sas_register_phys(struct sas_ha_struct *sas_ha)
>  {
>  	int i;
> +	int ret = 0;

"= 0" assignment does not seem to be needed here.

>  
>  	/* Now register the phys. */
>  	for (i = 0; i < sas_ha->num_phys; i++) {
> @@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
>  		phy->frame_rcvd_size = 0;
>  
>  		phy->phy = sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
> -		if (!phy->phy)
> -			return -ENOMEM;
> +		if (!phy->phy) {
> +			ret = -ENOMEM;
> +			goto fail;

Please call the label using a descriptive name. E.g. "goto delete_phy;"

> +		}
>  
>  		phy->phy->identify.initiator_port_protocols =
>  			phy->iproto;
> @@ -146,10 +149,22 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
>  		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
>  		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
>  
> -		sas_phy_add(phy->phy);
> +		ret = sas_phy_add(phy->phy);
> +		if (ret) {
> +			sas_phy_free(phy->phy);
> +			goto fail;
> +		}
>  	}
>  
>  	return 0;
> +fail:
> +	for (i--; i >= 0; i--) {
> +		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
> +
> +		sas_phy_delete(phy->phy);
> +		sas_phy_free(phy);
> +	}
> +	return ret;
>  }
>  
>  const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {


-- 
Damien Le Moal
Western Digital Research
