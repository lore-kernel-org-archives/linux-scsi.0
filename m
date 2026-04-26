Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99EC171AF;
	Sun, 26 Apr 2026 23:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246370; cv=none; b=ONroFe7eo1teXceZPZnxGXvlk6T2qGFchhdJhxdxKNixNa7s1BQmGWYMGn7vlXgSy3mtVVZQnmaDfaqHx2chT9LuFAfAUfFe7yA5obmUholpjTL3mvRqZegdDCnD/867hMsVgQBgPVX8dcxysIptLIwlUagdXVf0q0C6X+Pldxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246370; c=relaxed/simple;
	bh=/SuOV2rHmqnpMQpslog9kFPHe7WYHjbrFMWSRXjCrqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtcKmGl8erjolAgoMp+2SNU1gzBwWitC4tD1WgvBP7tBShw6dVNXtwIV1eipABghyGx1m+e0AjZtHkCH6y8tPA/3hkU+xzlF578ymdMiE5aoZyA7XsRtLa9fBc2vSD0PFi/L5w7cvjH+LRERj+/xvlCh9fZix2nucuz+8DwA1u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJqnqsp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJqnqsp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548E5C2BCAF;
	Sun, 26 Apr 2026 23:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777246369;
	bh=/SuOV2rHmqnpMQpslog9kFPHe7WYHjbrFMWSRXjCrqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BJqnqsp9r35D+Jj0J9M4Ek63srMk97KNdWl8LbsqFHZNHzPFI1d8zmwVY6ZMTMgNs
	 3aSm6MXU+KGmJxpbEpAO7YW+OymzrHVi9q3YggjkZkHVma7XbCj2ffeFggdu4n+gWf
	 pSm6SjhRiMqW0cbJjzKugVLYVEzoyTk/JuDrp7+z3n2wzQAnsRtJEE25u/rjEiPKED
	 NjmQ1vHCuH4IMYisRhhNZoined/XcOpVet6zwGLqdlUdFTTor1t6MVhmN0eqmuz9k2
	 obcUJ8TnuLH+X1vD4qW62OIJpQlagKTVqnAAMYSRmlsBO0/b1tzcWzvmeDraQgN+US
	 6lv6cj5jCnjTw==
Message-ID: <38a4a44f-fe8e-4236-8a6e-daff8dd16f48@kernel.org>
Date: Mon, 27 Apr 2026 08:32:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] scsi: add BLIST_NO_LUN_1F blacklist flag
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-5-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-5-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
> PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
> normally adds such devices (PQ=0 means "connected"), producing
> spurious "No Device" entries.
> 
> The scsi_target field pdt_1f_for_no_lun already exists to suppress
> this, but was previously only set by the USB UFI driver.
> 
> Add BLIST_NO_LUN_1F so the flag can be set per-device from
> scsi_devinfo, and wire it up in scsi_add_lun() to set
> starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
> during LUN 0 processing, before the sequential LUN scan probes
> higher LUNs.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/scsi/scsi_scan.c    | 3 +++
>  include/scsi/scsi_devinfo.h | 6 +++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7b11bc7de0e3..d3f0540d79a2 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1070,6 +1070,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  
>  	sdev->sdev_bflags = *bflags;
>  
> +	if (*bflags & BLIST_NO_LUN_1F)

Instead of dereferencing again bflags, maybe use sdev->sdev_bflags here ?
I would also remove the blank line before this if.

With that, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +		sdev->sdev_target->pdt_1f_for_no_lun = 1;
> +
>  	if (scsi_device_is_pseudo_dev(sdev))
>  		return SCSI_SCAN_LUN_PRESENT;
>  
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index 1d79a3b536ce..6957b0705510 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -34,7 +34,8 @@
>  #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
>  /* do not ask for VPD page size first on some broken targets */
>  #define BLIST_NO_VPD_SIZE	((__force blist_flags_t)(1ULL << 13))
> -#define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
> +/* PDT 0x1f with PQ 0 means no LUN present (e.g. some ATAPI multi-LUN) */
> +#define BLIST_NO_LUN_1F		((__force blist_flags_t)(1ULL << 14))
>  #define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
>  #define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
>  /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
> @@ -77,8 +78,7 @@
>  #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>  			       (__force blist_flags_t) \
>  			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
> -#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_14 | \
> -			     __BLIST_UNUSED_15 | \
> +#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_15 | \
>  			     __BLIST_UNUSED_16 | \
>  			     __BLIST_UNUSED_24 | \
>  			     __BLIST_UNUSED_27 | \


-- 
Damien Le Moal
Western Digital Research
