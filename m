Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBFF1D0DEE;
	Sun, 12 Apr 2026 07:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775978331; cv=none; b=tVeXt/+G1zMkfSgWzXvAjgQLzie2P0CCHpCutKHAXzDoVUMD096FWeLKusGzH4eMdxO+RpqLPrWrt4VK+oFxvoz2cmITbC4UX8BWBV/Vo7/aG8vhfb+YdifrFEsGD0JVt9OTOR8GsvfKFe5pLV0QqUSxQpRD62f2KocGVixo4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775978331; c=relaxed/simple;
	bh=M2q6fVN26ughkEGfu20rE5cnyO5lzYFas6acWBvvtds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9VM7QSVZNkoQgstgfu18JsPkzCYfyJjOIAnrr9IbjweB0ALzEdp4Ta0xCKxbQjj8DImmtdIBoW4BPibIG0eCmctCaDE6dCsUzkLL3zSR8Yhc43XYWvJ2ylr3KVW4b7NjSldamNYfUdKr2yztDz1uwdlODytSmpBot82xyFFsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m10z6pAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m10z6pAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD04C2BCB1;
	Sun, 12 Apr 2026 07:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775978331;
	bh=M2q6fVN26ughkEGfu20rE5cnyO5lzYFas6acWBvvtds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m10z6pAIDKUMcDbcp5f4XhPXIRl7mPw33d5PTtWLXcfB4CQJWt6KkRoBn93u3L1pN
	 9SXswhN6HFY+wNxKD3fYjBdS2U72KXQJu9kpX0dXiVg6mBiCScRynZHAM2AqJCtKj+
	 spbHZCuKuuHAHSpTt/rMT6aOTmnSImQovYQBL6zf7kCkH2lV21+JUphA42rLp1jEr1
	 xxOQwP0dSsEBFN3mms0QjSaOBnDVCPWZAaXKiG4IS3wiQenKBQOysFuQ504WUGO7yZ
	 9ElHeT8+iCOzu0mpH4Mbo2SDWs2bZJXYQSRWAaw2UBwZNleB+lIPA3R3eXDYRSJvCY
	 Yhfguv4VsEbCA==
Message-ID: <52c6b77a-bb2b-423d-98b7-cb1bbf606bfb@kernel.org>
Date: Sun, 12 Apr 2026 09:18:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mpt3sas: Limit NVMe request size to 2 MiB
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
 stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>,
 Keith Busch <kbusch@kernel.org>
References: <20260411080006.50010-1-ranjan.kumar@broadcom.com>
 <20260411080006.50010-2-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260411080006.50010-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/26 10:00, Ranjan Kumar wrote:
> Some firmware reports NVMe maximum transfer sizes that follow the drive
> capability. When those values are very large, the block layer may build
> I/O that this driver cannot handle, which can cause a kernel oops.
> 
> When an NVMe device is set up, cap how large a single transfer may be
> to the smaller of the firmware-reported limit and roughly two mebibytes
> with a small margin. If no valid limit is reported, apply the same
> upper bound.

What margin ? I do not see any...

> 
> Cc: stable@vger.kernel.org
> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6ff788557294..fca9d6722fc8 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -54,6 +54,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/raid_class.h>
>  #include <linux/unaligned.h>
> +#include <linux/sizes.h>
>  
>  #include "mpt3sas_base.h"
>  
> @@ -2737,9 +2738,17 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>  				"connector name( %s)\n", ds,
>  				pcie_device->enclosure_level,
>  				pcie_device->connector_name);
> -

Spurious whiteline change. The white line is nice before the big block below.

> +		/*
> +		 * Firmware may report large NVMe MDTS values on some ASICs.

What ASICs ? The SSD controller or the HBA controller ? Also, does the HBA
firmware change the MDTS ? Or does it report the SSD reported MDTS as is ? If it
is the former, then an explanation would be nice. If it is the latter, instead
of "Firmware may report" I suggest "The NVMe device controller may report"

> +		 * Limit max_hw_sectors to the smaller of the reported MDTS
> +		 * and 2 MiB to avoid issuing I/O the driver cannot handle.

Without any explanations, 2MiB appears to be a "magic" value here. There is a
clear explanation for it with the 4K device page size that can fit 512 PRP
entries each pointing to one 4K page. So let's state that.

> +		 */
>  		if (pcie_device->nvme_mdts)
> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> +			lim->max_hw_sectors = min_t(u32,
> +					pcie_device->nvme_mdts / 512,
> +					(SZ_2M / 512));
> +		else
> +			lim->max_hw_sectors = (SZ_2M / 512);

		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
		if (pcie_device->nvme_mdts)
			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
					pcie_device->nvme_mdts >> SECTOR_SHIFT);

is I think a bit nicer.		

>  
>  		pcie_device_put(pcie_device);
>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);


-- 
Damien Le Moal
Western Digital Research
