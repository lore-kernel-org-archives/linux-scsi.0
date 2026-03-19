Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D12DC783;
	Thu, 19 Mar 2026 03:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773890852; cv=none; b=k2LN1CGB3KQM4i2FO/B5JX5S72mdxDN6/ux7F/VTU/O/MVabG4mS9K/ComB8JjrChAre8sAxZIUIHsD6VOqrjjYqqcmbNLOnOcCfEN6IgTz9Z1lIdowgQMONBbNXsubALuMFrcoNpzHygNtTQvtyU9piKFFjDs7V5B+vvlBwCDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773890852; c=relaxed/simple;
	bh=sRx/e6yBG83MxWAyEYb9aM48iMeWBalueRmbRh5WjdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqTZLKsBDQlqpqrKy0GdAwTPFIYNJ0rYC1lMdt8R879X913l0r5aEqBdlTBCShMnT5o++EpN0yxnvFiWvJCcThRUDjfO6GNq5LPWJUXVH3tuIoSM7CzaJEOnAScQXwXlf5E9EncapC2MB6lwC+mR1utrBc5MkJim5joUrZOyYn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4EpimIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4EpimIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E9C19421;
	Thu, 19 Mar 2026 03:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773890851;
	bh=sRx/e6yBG83MxWAyEYb9aM48iMeWBalueRmbRh5WjdE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S4EpimIq4LnMdEYbgP3izMuEMgLIMR+ETM5Wh6j+kDP02xLrAerV6MhJv4MFj6I39
	 2kgyZxsn0gmWzn+37imwh+VQKkBZroYX5QftmsDHGTm82JmGes8UN+q1FxaBQE8zIu
	 +lvwv5WWph4ovhxC7IDfRa+sSueronJlgWg8mnBgTPLyoxsVRrk76YkdCySYXjzA2Z
	 /AVHRIqQL9S5KJtbyCTIVLh6chRQLaZKvql7I98jZV4tlzl6N77Qf9/irBdDap/Vmp
	 4NZr0fg25um4rTaxxbYDL1cHYrMpLl7kl2hZlK3yAzSbt9ATcyZiO9K0v8oOD+Ol/+
	 A9zLnT3Fn+F8w==
Message-ID: <1adabe3e-4497-4e71-b6a0-f3b81df322eb@kernel.org>
Date: Thu, 19 Mar 2026 12:27:27 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sas: skip opt_sectors when DMA reports no real
 optimization hint
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
 john.g.garry@oracle.com, kbusch@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 m.szyprowski@samsung.com, robin.murphy@arm.com, sagi@grimberg.me,
 stable@vger.kernel.org, sunlightlinux@gmail.com
References: <20260318200532.51232-1-ionut.nechita@windriver.com>
 <20260318200532.51232-2-ionut.nechita@windriver.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260318200532.51232-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/26 05:05, Ionut Nechita (Wind River) wrote:
> +static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
> +					unsigned int max_sectors)
> +{
> +	size_t opt = dma_opt_mapping_size(dma_dev);
> +	unsigned int opt_sectors;
> +
> +	if (opt >= dma_max_mapping_size(dma_dev))
> +		return 0;

I really do not understand this one. How can the optimal DMA mapping size be
larger than the maximum possible DMA size ?
If that happens, it is a driver bug, we should WARN_ONCE and return
dma_max_mapping_size(), no ?

> +
> +	opt = rounddown_pow_of_two(opt);
> +	opt_sectors = opt >> SECTOR_SHIFT;

if opt is super large, can this overflow the 32-bits opt_sectors ?

> +
> +	return min(opt_sectors, max_sectors);
> +}
> +
>  static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  			  struct device *cdev)
>  {
> @@ -239,10 +268,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
>  			   shost->host_no);
>  
> -	if (dma_dev->dma_mask) {
> -		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> -	}
> +	if (dma_dev->dma_mask)
> +		shost->opt_sectors = sas_dma_opt_sectors(dma_dev,
> +							 shost->max_sectors);

Splitting the line after the "=" would make this look nicer:

	if (dma_dev->dma_mask)
		shost->opt_sectors =
			sas_dma_opt_sectors(dma_dev, shost->max_sectors);

>  
>  	return 0;
>  }


-- 
Damien Le Moal
Western Digital Research
