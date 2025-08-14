Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F8237704
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755137166; cv=none; b=IvgHpEsHtVKJWXNcGymY94su1eoFntHEG2+X5PUFKPHZzjkpCATfPIWBciVhFs8DZ+uqW7SR7dAELGK1/k5oScCrkMkWwWGvjKIi1O05Iy3fw9IxuA4K1Ee1/ha7s0N21YPtHpmeYZqbuNEhWbBV1RKZY76miDFvI0CcBMU2HfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755137166; c=relaxed/simple;
	bh=SqYfdoiNVwzLIQF9tmCb269l+hvCVV6ZmiWR1b/6OvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThviF4hOU1uBQpsTuKLDoJg/IZehSUJVDZpv42e21lLKvN0bPkUlnvHBojy7WRjFmrdcNaA4m4JmDWjajmPIYluxdQxu9PPu3ZdhnGKcW6aYvJyebrQ9yLoUtVcV3vEmFpNZ+TND4gfyUqZoYZ7Wnl/d7AVRPNNmp6bWB2UMIR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm4iqzeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm4iqzeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA58DC4CEEB;
	Thu, 14 Aug 2025 02:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755137165;
	bh=SqYfdoiNVwzLIQF9tmCb269l+hvCVV6ZmiWR1b/6OvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qm4iqzeYpTPXzlDWuo/IBWAcpuCZbLXpxT7XFmkYunqyTCh3yHh+MJ4rinMiUvOuk
	 dJsq+ZFxQJWejdUgp/YrQUOuwL+0MdaU7A3cFlR75MT4EUDr+9iejTcPLYuvUD+oTQ
	 /PO37NkVkA+hBl1HKLsk+mWhHSe1oTk4s3UqmiCuvKBEILfLqBwsRmpT/0r1T6w91V
	 fLG31azaR7DT+fqpCz+IZzf9XM75ufQXQdIxvyuAzkWkdfbu+2FjJAKhrcm7J6l11Y
	 e4K7JiievS/4jakq3NhPLjchTH2/ywrjHhulnRiAqj3wWpuwr80zXTmVLWn+5yzBjw
	 3DmM4pHnDUoug==
Message-ID: <6552eaa2-4ab2-4283-b9d3-8e5512f6769f@kernel.org>
Date: Thu, 14 Aug 2025 11:03:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] scsi: pm80xx: Add helper function to get the local
 phy id
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>,
 linux-scsi@vger.kernel.org
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-10-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250813114107.916919-10-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/25 8:41 PM, Niklas Cassel wrote:
> Avoid duplicated code by adding a helper to get the local phy id.
> 
> No functional changes intended.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

[...]

> +u32 pm80xx_get_local_phy_id(struct domain_device *dev)
> +{
> +	struct pm8001_device *pm8001_dev = dev->lldd_dev;
> +	struct domain_device *parent_dev = dev->parent;
> +
> +	if (parent_dev && dev_is_expander(parent_dev->dev_type))
> +		return parent_dev->ex_dev.ex_phy->phy_id;
> +	else
> +		return pm8001_dev->attached_phy;

Nit: no need for else after a return.
Also, maybe reverse the condition to have this a tad faster for direct attach
devices ?

	if (!parent_dev || !dev_is_expander(parent_dev->dev_type))
		return pm8001_dev->attached_phy;

	return parent_dev->ex_dev.ex_phy->phy_id;

Other than this, this looks good !

-- 
Damien Le Moal
Western Digital Research
