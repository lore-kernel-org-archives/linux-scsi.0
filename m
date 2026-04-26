Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD3426A08A;
	Sun, 26 Apr 2026 23:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246188; cv=none; b=Ka5dOp8sb+7RC8yiuy/6Ad46nrFcqu73bjgl+Zs28OZgP87U44WhBPQt7PIKsAYUfSxG6y1t7KjhadlSAZwyKf253nwMIMXwX6IGRfY5OnNVWEke7+mZs9TvDFEjgWKrFjmKAUkvdM7c4adUg0QONVgE9l8zoxlhYcnQ9g9etjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246188; c=relaxed/simple;
	bh=VTAyJZN46pmlO+UYowyBkIP0LLnz4XwEHRG3EdYJSHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uSLLaAv3yRQz1KAAf9nrKHeGHn65QL3MmqGpKPNegQNgvf2sVIuyxLaNzfAVpRychqeXNJ91f7rhr3zvhzP6I2+tMG81qGXPXhNu5Qeuc28B+qGbjxRrpN93gXks2vH9iXEjX3S5H9DgofDBHRalds7JA9dfO8s7a3Xp+sRkHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAMDRzY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAMDRzY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AB2C2BCAF;
	Sun, 26 Apr 2026 23:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777246188;
	bh=VTAyJZN46pmlO+UYowyBkIP0LLnz4XwEHRG3EdYJSHY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qAMDRzY0bcyUbrgAdr+Y9nSlkyJxYuNXMCsZP4QEnEvUdDSam7KXyYu5dtBbSe3sY
	 qdlsMh0WNj46iEvOaafatalUpVkEbiWtWDZLsDXKxDFsKm7p98/2jsvaigsK6hKZkp
	 6xbNsNx129Fbluv9RdAS+nNBejvBg8pPG+ZXbEVknECHZEI60YfCvsKhJEKoS5D9xo
	 EnLEAVpjBKpEN+K8OWLPxwDUhjs6mcX52yqd61dn8ssJIZ2ndtygpljOjNJ7D99A8Q
	 4j/fr+4HCJk+nMAUC0lLzUTXn0MiKnrpYlz1fUVrDP6+Kj6JhrFtf8DzM6BrGzW9lS
	 KhR1iAabQGRNw==
Message-ID: <19b6da9d-5954-457c-be17-877a5c3fd9cf@kernel.org>
Date: Mon, 27 Apr 2026 08:29:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] ata: libata-scsi: route non-zero LUN commands for
 multi-LUN ATAPI
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> Two changes are required to route commands to ATAPI LUNs other than 0:
> 
> 1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
>    with a non-zero LUN, returning NULL and dropping the command on
>    the floor.  Relax both the PMP and non-PMP branches to allow
>    non-zero LUNs through when the underlying ata_device is ATAPI
>    class, since ATAPI devices can legitimately expose multiple LUNs.
> 
> 2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
>    CDB byte 1 bits 7:5 rather than relying on transport-level LUN
>    addressing.  Encode scmd->device->lun into those bits, preserving
>    the existing command-specific bits in 4:0.  This is required by
>    both the Panasonic PD/CD combos and Nakamichi CD changers.  LUNs
>    beyond 7 cannot be encoded in the 3-bit CDB field; reject them
>    with AC_ERR_INVALID.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 317883bac25f..48c7d323d6f9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2951,6 +2951,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>  	memset(qc->cdb, 0, dev->cdb_len);
>  	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>  
> +	/* SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field) */
> +	if (scmd->device->lun >= 8)

Instead of 8, please use ATAPI_MAX_LUN.
Since this should never happen, this also warrants the use of WARN_ON_ONCE()
for the if condition.

> +		return AC_ERR_INVALID;
> +	qc->cdb[1] = (qc->cdb[1] & 0x1f) | ((u8)scmd->device->lun << 5);
> +
>  	qc->complete_fn = atapi_qc_complete;
>  
>  	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
> @@ -3059,19 +3064,27 @@ static struct ata_device *ata_find_dev(struct ata_port *ap, unsigned int devno)
>  static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
>  					      const struct scsi_device *scsidev)
>  {
> +	struct ata_device *dev;
>  	int devno;
>  
>  	/* skip commands not addressed to targets we simulate */
>  	if (!sata_pmp_attached(ap)) {
> -		if (unlikely(scsidev->channel || scsidev->lun))
> +		if (unlikely(scsidev->channel))
>  			return NULL;
>  		devno = scsidev->id;
>  	} else {
> -		if (unlikely(scsidev->id || scsidev->lun))
> +		if (unlikely(scsidev->id))
>  			return NULL;
>  		devno = scsidev->channel;
>  	}
>  
> +	if (unlikely(scsidev->lun)) {
> +		dev = ata_find_dev(ap, devno);
> +		if (!dev || dev->class != ATA_DEV_ATAPI)
> +			return NULL;
> +		return dev;
> +	}

This really should come first in the function. Otherwise, you are radically
changing the function since you removed the scsidev->lun checks for the
preceding checks.

> +
>  	return ata_find_dev(ap, devno);
>  }
>  


-- 
Damien Le Moal
Western Digital Research
