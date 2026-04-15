Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A52C31AF31;
	Wed, 15 Apr 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776275022; cv=none; b=aKrYIbtO8zKHODJ4XPiYzxOd8d8s8jyx0cxSVhX6l/19yYnHBwWK8/kyC49APwuTUZvPBjCwy/Lrf0TIhmZDjE/2AEWkkY7oDjAcxz9QrpDyryt89POG4+CCV3FRGfvMCaQhtxmtaq/UBPASy2uf78UIsRubvjd0ow1Wy38xE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776275022; c=relaxed/simple;
	bh=/3zEDoYFYX455X/Av9FJo5SyA5HyQk+/indW93haVN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hp9JLWCyCgoQxM5HkxgtswCVhVkKgqf/I4uTGkg6AIJ0rR6P96Mtwt2/gPugOmFmQ5KdeICT/s03UVToCcvTrQ+elQZ5LfgbOWsp91pmMQ2TykJTxlGZQgv0M7B+3UH2JBe8nOy6jBaWnYY560jjyJ+/RvZBKmA1vez2irReGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id E6A6487457;
	Wed, 15 Apr 2026 19:43:31 +0200 (CEST)
Message-ID: <596fba41-38be-47bb-b436-bc74b7237816@proxmox.com>
Date: Wed, 15 Apr 2026 19:43:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mpt3sas: Limit NVMe request size to 2 MiB
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
 dlemoal@kernel.org, david.laight.linux@gmail.com, stable@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, Friedrich Weber <f.weber@proxmox.com>
References: <20260414110811.85156-1-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Mira Limbeck <m.limbeck@proxmox.com>
In-Reply-To: <20260414110811.85156-1-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1776274933153

On 4/14/26 1:13 PM, Ranjan Kumar wrote:
> The HBA firmware reports NVMe MDTS values based on the underlying drive
> capability. However, because the driver allocates a fixed 4K buffer for
> the PRP list, accommodating at most 512 entries, the driver supports a
> maximum I/O transfer size of 2 MiB.
> 
> Limit max_hw_sectors to the smaller of the reported MDTS and the
> 2 MiB driver limit to prevent issuing oversized I/O that may lead
> to a kernel oops.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6ff788557294..12caffeed3a0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>  				pcie_device->enclosure_level,
>  				pcie_device->connector_name);
>  
> +		/*
> +		 * The HBA firmware passes the NVMe drive's MDTS
> +		 * (Maximum Data Transfer Size) up to the driver. However,
> +		 * the driver hardcodes a 4K buffer size for the PRP list,
> +		 * accommodating at most 512 entries. This strictly limits
> +		 * the maximum supported NVMe I/O transfer to 2 MiB.
> +		 *
> +		 * Cap max_hw_sectors to the smaller of the drive's reported
> +		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
> +		 */
> +		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
>  		if (pcie_device->nvme_mdts)
> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> +			lim->max_hw_sectors = min(lim->max_hw_sectors,
> +					pcie_device->nvme_mdts >> SECTOR_SHIFT);
>  
>  		pcie_device_put(pcie_device);
>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);

Thank you for providing this patch.

We tested it on our test machine on top of 7.0-rc7.
Without the patch, we saw the same call traces as before. With this patch applied no such call traces were logged.
So looks like it fixes the issue in our case.

I can't say much to the patch itself, but I can provide a tested-by.

Tested-by: Mira Limbeck <m.limbeck@proxmox.com>

