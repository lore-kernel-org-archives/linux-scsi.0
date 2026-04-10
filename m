Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CEC17A305;
	Fri, 10 Apr 2026 04:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775794286; cv=none; b=Rken19M+pFYavgMpGl1WPq4Nu2CQwo9ztPNtXvgcZu0ZrsWm7SslKf28NIj2/VhCG8zg1kRPUyLXmIBYF6N/adqvKB38yZsEJ4VPS/10jvChT5CI8Swl4PgxXT4UykzBXVZpyExF755K52BnZDEG+V3PBsQiLyNvmQRpf4PPFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775794286; c=relaxed/simple;
	bh=Qd/ywiFU9cRxI8M0dPCWFKVaalapG3CitltszcMmn3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8bFnIK8sm2/oUGTbDKQgvVfuDdss8meBrTqNICqjcaA7/GGwOjmG6v9QKnFptHU1D39JDEkzI6eu2/GucRB2uWguWxsHvq+ECQT9mYCey0bSoFmAGukdbSxkhpWRhBOV0sOpCvX2UdXziC2sgMHdhVYw5RfNWU+s6wox6LTdOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsfhrjIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsfhrjIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E74C19421;
	Fri, 10 Apr 2026 04:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775794285;
	bh=Qd/ywiFU9cRxI8M0dPCWFKVaalapG3CitltszcMmn3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AsfhrjIhSeUrqM8njDxuDY//OsFcDRrT0GusxqQypXcZzujTpIXb4G7L/xxU0kRPE
	 LxosffhfKxmZmfk1Ht/sVsZ4kLd/H+gXaSYNJtn93e1vRB1Z9x0s1+jJv/tJDIpLaW
	 fUVvlFje2Fo40RMFp4psNncRl4ORryRfpjY3d6a1kt6XwgPq0jJLiv/ITCwIr/EFrt
	 aKkYamrHdZ26jfbcDXLBJlQnH/TEAciVp1mB28TzHW8s2KHplbDnPyrqb2hME+Hw0I
	 YO7eT7jOBU2StL78w6prA1eORnbZpEVaeowh7fC/Vc/JNAYRMBA1TP78B5Oa1ZCDZL
	 +iy94uFsgpRxA==
Message-ID: <eec3bbd3-5503-423b-bb3e-22657026d573@kernel.org>
Date: Fri, 10 Apr 2026 06:11:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mpt3sas: Limit NVMe request size to 2 MiB
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
 stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>,
 Keith Busch <kbusch@kernel.org>
References: <20260409184217.32992-1-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260409184217.32992-1-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/09 20:42, Ranjan Kumar wrote:
> Some firmware reports NVMe maximum transfer sizes that follow the drive
> capability. When those values are very large, the block layer may build
> I/O that this driver cannot handle, which can cause a kernel oops.
> 
> When an NVMe device is set up, cap how large a single transfer may be
> to the smaller of the firmware-reported limit and roughly two mebibytes
> with a small margin. If no valid limit is reported, apply the same
> upper bound.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
> Suggested-by: Keith Busch <kbusch@kernel.org> 
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6ff788557294..b6abc83d8121 100644
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
> @@ -2738,8 +2739,17 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>  				pcie_device->enclosure_level,
>  				pcie_device->connector_name);
>  
> +		/*
> +		 * Firmware may report NVMe MDTS from the drive; values above
> +		 * what the driver can handle can cause a kernel oops. Cap queue
> +		 * I/O in sectors to min(MDTS, 2 MiB - 4096 B).
> +		 */

This comment has some grammar issues and is really hard to parse/understand.

>  		if (pcie_device->nvme_mdts)
> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> +			lim->max_hw_sectors = min_t(u32,
> +					pcie_device->nvme_mdts / 512,
> +					(SZ_2M / 512) - 8);
> +		else
> +			lim->max_hw_sectors = (SZ_2M / 512) - 8;

I am very confused here: SZ_2MB assumes that you have an SSD with a minimum page
size of 4K, which can fit 4K / 8 = 512 PRP entries, each referencing 4K (one
page), so a maximum of 2MiB. However, if I am not mistaken, there is nothing in
nvme specs that forces the MPS field to be 0 (which leads to a page size of 4K).
So this seems incorrect to me, even though that will probably work for the vast
majority of SSDs out there, some exotic ones will not be correctly supported.

Keith ? Am I missing something here ?

Or do we simply do not care about SSDs with a minimum page size > 4K having
their maximum command size truncated ?

>  
>  		pcie_device_put(pcie_device);
>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);


-- 
Damien Le Moal
Western Digital Research
