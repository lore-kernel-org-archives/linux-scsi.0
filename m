Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA36527FD49;
	Thu, 19 Mar 2026 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918374; cv=none; b=kK1ch+NnATpRSZjk5sviYJzB/pCDn9baAyeScLm8WqnwA3yPOERTMr149Og5ZoLXN0UgK4qu3oypjqlwj/PPe4FOJo5B1msmtbQQkuuHsvn8XBKVF/dUDGwcnGbX+QYim1/E2ltGSb+sTVYRwwCH8pV96CF3SKtHmRqco3t91z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918374; c=relaxed/simple;
	bh=HtOLA8NR+v9NMav1R6I8Ldubjqi2Fb/1QOf8g53m3XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kk2g3HS9ivIKSudCeZd8YGfD/9lN5hGX3tIpdjgaqBCE+HBWQpZMNN+GzJhm9Iol4Jv1O66DwYHunK8+T+tua5SNu3CABQ4J5Nu6DzGvKsxbWtSqPh2AazlQIjd4vLoT1H/Lo2Rjj1u2que83JN4q89kRboQPGj6NhDodDJ5Loc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYIOxc6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYIOxc6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF25C19424;
	Thu, 19 Mar 2026 11:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918374;
	bh=HtOLA8NR+v9NMav1R6I8Ldubjqi2Fb/1QOf8g53m3XA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYIOxc6wuiHE1KLRNEIwUIHqRwXsElreuD2+B/6jZqyN4aIdu++mi/L+ZFP6YNh+y
	 pv+9HlQoSNWZvemE++l3/lT/zSOQ6Bjs+z+TIZoqLHOKA2ThjWNFHlbdE2i/d8NqxP
	 OafAVmojZqm13lZf5wvFbnu6sW6rMpQvN4ByIusAhKnp6STr84kaBFllVhy2h7AhRL
	 tm1/xs3SAa1biSxootVlvvXZhBab/8Li/SwuTUuFXbUQx9CLxKmn4yRcM6vQHeKKQP
	 RyXvw7BxjLLaaSX6u+wTFEDg9v2n7laBP6u4p1xHO9Px9fx994oVeOEU4mq5xXY5rZ
	 3nEO3+uI7S4Pw==
Message-ID: <1f370bc0-e547-478b-b60c-8a5c77e7eb2f@kernel.org>
Date: Thu, 19 Mar 2026 20:06:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: sas: skip opt_sectors when DMA reports no real
 optimization hint
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
 linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, ahuang12@lenovo.com,
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de,
 iommu@lists.linux.dev, ionut_n2001@yahoo.com, john.g.garry@oracle.com,
 kbusch@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, m.szyprowski@samsung.com,
 martin.petersen@oracle.com, robin.murphy@arm.com, sagi@grimberg.me,
 stable@vger.kernel.org, sunlightlinux@gmail.com
References: <20260319083954.21056-1-ionut.nechita@windriver.com>
 <20260319083954.21056-2-ionut.nechita@windriver.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260319083954.21056-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/19/26 17:39, Ionut Nechita (Wind River) wrote:
> From: Ionut Nechita <ionut.nechita@windriver.com>
> 
> sas_host_setup() unconditionally sets shost->opt_sectors from
> dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
> mode and no DMA ops provide an opt_mapping_size callback,
> dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
> which equals dma_max_mapping_size() — a hard upper bound, not an
> optimization hint.

Please reduce the distribution list. This is now a scsi patch. Nothing to do
with iommu or nvme.

> 
> On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
> and intel_iommu=off the following values are observed:
> 
>   dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
>   shost->max_sectors      = 32767
>   opt_sectors             = min(32767, huge >> 9) = 32767
>   optimal_io_size         = 32767 << 9 = 16776704
>                           → round_down(16776704, 4096) = 16773120
> 
> The SAS disk (SAMSUNG MZILT800HBHQ0D3) do not report an
> Optimal Transfer Length in VPD page B0,so sdkp->opt_xfer_blocks remains 0.
> sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
> propagating the bogus value into the block device's optimal_io_size
> (visible as OPT-IO = 16773120 in lsblk --topology).
> 
> mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:
> 
>   swidth = 16773120 / 4096 = 4095
>   sunit  = 8192 / 4096     = 2
> 
> Since 4095 % 2 != 0, XFS rejects the geometry:
> 
>   SB stripe unit sanity check failed
> 
> This makes it impossible to create XFS filesystems (e.g. for
> /var/lib/docker) during system bootstrap.
> 
> Fix this by introducing a sas_dma_opt_sectors() helper that only returns
> a non-zero opt_sectors when dma_opt_mapping_size() is strictly less than
> dma_max_mapping_size(), indicating a genuine DMA optimization constraint
> from an IOMMU or DMA ops backend.  The helper also rounds the value down
> to a power of two so that filesystem geometry calculations always produce
> clean results.  When the two DMA values are equal, no backend provided a
> real hint, so opt_sectors stays at 0 ("no preference").
> 
> A WARN_ONCE guards against dma_opt_mapping_size() returning a value
> larger than dma_max_mapping_size(), which would indicate a driver bug.
> The return value uses min_t(unsigned int, ...) to avoid any potential
> overflow when shifting the size_t opt value down to sectors.
> 
> Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
> ---
>  drivers/scsi/scsi_transport_sas.c | 40 +++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 12124f9d5ccd0..696627b6fe2c3 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -27,6 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/jiffies.h>
>  #include <linux/err.h>
> +#include <linux/log2.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/blkdev.h>
> @@ -222,6 +223,38 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>   * SAS host attributes
>   */
>  
> +/**
> + * sas_dma_opt_sectors - derive opt_sectors from DMA optimal mapping size
> + * @dma_dev: device to query DMA parameters for
> + * @max_sectors: upper bound from the host adapter
> + *
> + * When the DMA layer reports a genuine optimization constraint (i.e.
> + * dma_opt_mapping_size() < dma_max_mapping_size()), convert it to a
> + * sector count, round it down to a power of two so that filesystem
> + * geometry calculations stay sane, and cap it at @max_sectors.
> + *
> + * When the two values are equal no backend provided a real hint and
> + * the function returns 0 ("no preference").
> + */
> +static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
> +					unsigned int max_sectors)
> +{
> +	size_t opt = dma_opt_mapping_size(dma_dev);
> +	size_t max = dma_max_mapping_size(dma_dev);
> +
> +	if (WARN_ONCE(opt > max,
> +		      "dma_opt_mapping_size (%zu) > dma_max_mapping_size (%zu)\n",
> +		      opt, max))
> +		return 0;
> +
> +	if (opt == max)
> +		return 0;
> +
> +	opt = rounddown_pow_of_two(opt);
> +
> +	return min_t(unsigned int, opt >> SECTOR_SHIFT, max_sectors);
> +}
> +
>  static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  			  struct device *cdev)
>  {
> @@ -239,10 +272,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
>  			   shost->host_no);
>  
> -	if (dma_dev->dma_mask) {
> -		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> -	}
> +	if (dma_dev->dma_mask)
> +		shost->opt_sectors =
> +			sas_dma_opt_sectors(dma_dev, shost->max_sectors);
>  
>  	return 0;
>  }


-- 
Damien Le Moal
Western Digital Research
