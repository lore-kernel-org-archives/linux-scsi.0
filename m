Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD1197A7D;
	Sun, 26 Apr 2026 23:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246587; cv=none; b=mS89UpiQbhXltEUpsXA97gJXKKNkEyikWnJlAm2/tuPkiGWJYPp4aN9UfBui+C3NnnVEASQH0fTwvsqM2/oTXa773OfYgojYPB7EiylMZJV1DtKS98BOaNzBn9oFS/Dxt5EDNPi63iR27KjJv72Gq9Q2TEsv91sj5DNoVcb9QDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246587; c=relaxed/simple;
	bh=GKnFhzMFp4+uM9HsmIbQkPLpZ9LXxC2RVfT0Dexphc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTmRV/N775j0SJfmVULJxyFlzVD5SupwjBuKu8VYwphkhPBm4v6gE2CVdAgfKe6W5rZTkOzDqFdV/K9ojTQaDuK/iCtAWvp7Ufz6z/LI6gf9iKENnw2qCoKH1rL26BlGQQ2GmRqU205DBxarsWu59AIJ/KQPwT40/zThvyYI6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcmohLur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcmohLur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B4FC2BCAF;
	Sun, 26 Apr 2026 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777246587;
	bh=GKnFhzMFp4+uM9HsmIbQkPLpZ9LXxC2RVfT0Dexphc4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BcmohLurbJTZkIjseOJr7jyabXKLvDyFg/y+VgSyFkHoTMZSaPi4cTz2BDQsKQcCt
	 MNdHyaAQjjo5UCXAThElU8B+v1EYKzfXB0vRMF9bnA5DW6fqYeIEUhTXKzowmY4tTa
	 U17Gr3G8O4xT4i/5N34TBtFZOBKPeM9Ik8HYjHSfLVgha6WohlQ0IG+ouUS8TMUv8S
	 dk/mufPHWfCOG8odj83tP6Uq4Eo6e1K1mryPcA370cVwqgFlX/x6i1uyu3rz6smmkY
	 Fzu0iVSb08ZhweUU83TM7CO3SVnJNrDZMF6CuU+PN5UlV7sWnYmkYPacR/Phh64SAu
	 0yW5hYEa1Djlg==
Message-ID: <cdd57593-e43f-455e-bd30-f3f89c10b135@kernel.org>
Date: Mon, 27 Apr 2026 08:36:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-6-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
> flag.  If set, call scsi_scan_target() with SCAN_WILD_CARD to trigger
> the SCSI layer's built-in sequential LUN scan for that target only.
> This probes LUNs 1..shost->max_lun, driven by the atapi_max_lun module
> parameter from patch 1/6.  Devices without BLIST_FORCELUN (the vast

Please remove the mention of patch 1/6. Once the patches are applied, that will
not mean anything.

> majority of ATAPI devices) are left with only LUN 0 -- no sequential
> scan is triggered, so single-LUN devices like the iHAS124 DVD writer
> are completely unaffected.
> 
> Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
> scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
> via scsi_devinfo (see patch 4/6).

Same thing here.

> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 48c7d323d6f9..fc719e3d7d60 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -26,6 +26,7 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_devinfo.h>
>  #include <linux/libata.h>
>  #include <linux/hdreg.h>
>  #include <linux/uaccess.h>
> @@ -4700,7 +4701,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   repeat:
>  	ata_for_each_link(link, ap, EDGE) {
>  		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev;
>  			int channel = 0, id = 0;
>  
>  			if (dev->sdev[0])
> @@ -4711,15 +4711,34 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  			else
>  				channel = link->pmp;
>  
> -			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
> -						 NULL);
> -			if (!IS_ERR(sdev)) {
> -				dev->sdev[0] = sdev;
> -				ata_scsi_assign_ofnode(dev, ap);
> -				scsi_device_put(sdev);
> -			} else {
> -				dev->sdev[0] = NULL;
> +			{
> +				struct scsi_device *sdev;

This is not pretty... Please leave the declaration of sdev where it was and
remove this curly bracket. That will save one level of identation and make the
code cleaner.

> +
> +				sdev = __scsi_add_device(ap->scsi_host,
> +							 channel, id, 0, NULL);
> +				if (!IS_ERR(sdev)) {
> +					/*
> +					 * For multi-LUN ATAPI (BLIST_FORCELUN),
> +					 * trigger the sequential LUN scan.
> +					 * pdt_1f_for_no_lun (set during LUN 0
> +					 * configure) ensures non-responding LUNs
> +					 * are silently skipped.  dev->sdev[] is
> +					 * populated by ata_scsi_dev_config()
> +					 * during the scan callbacks.
> +					 */
> +					if (dev->class == ATA_DEV_ATAPI &&
> +					    sdev->sdev_bflags & BLIST_FORCELUN)
> +						scsi_scan_target(
> +							&ap->scsi_host->shost_gendev,
> +							channel, id,
> +							SCAN_WILD_CARD,
> +							SCSI_SCAN_RESCAN);
> +					scsi_device_put(sdev);
> +				}
>  			}
> +
> +			if (dev->sdev[0])
> +				ata_scsi_assign_ofnode(dev, ap);
>  		}
>  	}
>  


-- 
Damien Le Moal
Western Digital Research
