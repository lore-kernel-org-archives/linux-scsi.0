Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807E33E16AB;
	Mon, 18 May 2026 08:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092032; cv=none; b=lwQ/mOEgRFdD7RCK9pdv0IXNTIod9oQyECVNTpu2WYNiOn9Em/+fryt/mpFUrzmSR3IoRth6AjoxhevkjOk8y8QX/GZSCM2bUmODukldHm9G4VHnca0ddgY6Q3rIJmcbtyr3f8JiX2RmiIc9v6+DVSxinQ2rOrviTYcmw2xys0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092032; c=relaxed/simple;
	bh=wC1B3By0Umb5JQF2OUdNHUZNcKKALbkugSIbGq0Vnbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OU2qBv44vIC7XusWuzGqvwgyyNSvLkG3KVQPpKhYqCciJaxmM3S/CaJEMo/3uu+S/wOtHL3H4mNG4IBrTFMvJsL1f1uNF5qbFTILWEITy5oPYl3zCmZMtDKMjXSxr8XAu1UmXyIJerJb8r27WjMknwBFNHmRtpr3T47ZVzTd6YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE2jkaEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE2jkaEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB1AC2BCC9;
	Mon, 18 May 2026 08:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779092032;
	bh=wC1B3By0Umb5JQF2OUdNHUZNcKKALbkugSIbGq0Vnbo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kE2jkaEhfYIlfeEA8kY4phwcRYWYZkGPL6iiCZvCrnJZIre7Nrg99e41c7feIQEDq
	 5axphQoblEWmOiiPxvDdPKBdJffG72LVgKg/ylaBe9zuDA5e9k/toJhnDTnU/h5fIO
	 mZg7IQRJYDcmQiXM9lQ3wbEdgGxL2no++1WEJybxoh/ot+ISD+ox0W3+zsQxTTN+ld
	 voSlQ0hLoRu38r4ryJPbaXz7n3mK9HslmWrSfnnUdcDkXZ9fMD17Tt5rHr86xUdMOj
	 /rpSFtPpTSgivJ2ZT+lexbYQX9jHsDoJsNqy0EaL7qCPXg14vTyVoqyyTf+2jwvyoO
	 yagEaianQxZMQ==
Message-ID: <7b20be32-1c62-4c08-b013-cd9a9fe1cce5@kernel.org>
Date: Mon, 18 May 2026 10:13:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-6-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512202728.299414-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/12 22:27, Phil Pemberton wrote:
> After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
> flag.  If set, bump dev->nr_luns to the host's max_lun so the LUN
> routing in atapi_xlat() accepts the probe INQUIRYs, then call
> scsi_scan_target() with SCAN_WILD_CARD to trigger the SCSI layer's
> built-in sequential LUN scan for that target only.  This probes
> LUNs 1..shost->max_lun, driven by the libata atapi_max_lun module
> parameter.
> 
> Devices without BLIST_FORCELUN (the vast majority of ATAPI devices)
> are left with only LUN 0 -- no sequential scan is triggered, so
> single-LUN devices like the iHAS124 DVD writer are completely
> unaffected.
> 
> Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
> scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
> via scsi_devinfo.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2d714efc855f..a6f5557014c7 100644
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
> @@ -4745,12 +4746,30 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
>  						 NULL);
>  			if (!IS_ERR(sdev)) {
> -				dev->sdev[0] = sdev;

Maybe reverse this condition and do a continue here. That will avoid the
additional indent level, which will make the hunk below a little more pretty.

			if (IS_ERR(sdev)) {
				dev->sdev[0] = NULL;
				continue;
			}

			/*
			 * For multi-LUN ATAPI (BLIST_FORCELUN), bump...
			 ...

> -				ata_scsi_assign_ofnode(dev, ap);
> +				/*
> +				 * For multi-LUN ATAPI (BLIST_FORCELUN), bump
> +				 * dev->nr_luns to the host max so the LUN
> +				 * routing in atapi_xlat() accepts the probe
> +				 * INQUIRYs to LUN > 0, then trigger the
> +				 * sequential scan.  pdt_1f_for_no_lun, set
> +				 * during LUN 0 configure, ensures
> +				 * non-responding LUNs are silently skipped;
> +				 * dev->sdev[] is populated by
> +				 * ata_scsi_dev_config() during the scan.
> +				 */
> +				if (dev->class == ATA_DEV_ATAPI &&
> +				    sdev->sdev_bflags & BLIST_FORCELUN) {
> +					dev->nr_luns = ap->scsi_host->max_lun;
> +					scsi_scan_target(
> +						&ap->scsi_host->shost_gendev,
> +						channel, id, SCAN_WILD_CARD,
> +						SCSI_SCAN_RESCAN);
> +				}
>  				scsi_device_put(sdev);
> -			} else {
> -				dev->sdev[0] = NULL;
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
