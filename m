Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35B263C9F;
	Mon, 18 May 2026 08:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779091395; cv=none; b=ZHtod7rQF/rvXc0TwSGctC42SpRT9ur2JJS9shTtTTjdSeIo6pKJdF34+vyGM8WWxoaDFObC3bS70qChYRlGJkxAdOZcgMxbuOgEX2udq6ud1fxPwQ23C8zVjcd6TRrEQ702Ls3V26ylJ44Q2sxPY7y4zMD5TtvdWWBgPGgkxLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779091395; c=relaxed/simple;
	bh=gMLWtvHTMOdykVME+/F3v6D6OFh7xuPQ6supBVGSUsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSDIDus0Ukx2HYf3NnEPvHUXm7P8hUE1dBdkLKxeqdoLFOZKu6Hqemaj5uheklDBPKHhXBZUIaTUkkHEFiirKArv1RGzhDnFSgjl+nhGP3fTwGslANGkdfjIWkauDIeQD2oZ+kcyn9J4YCKq0IzE2ESYBqONPnszQYW0K5l3oco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwjAie1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwjAie1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86492C2BCC9;
	Mon, 18 May 2026 08:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779091395;
	bh=gMLWtvHTMOdykVME+/F3v6D6OFh7xuPQ6supBVGSUsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OwjAie1wIZVEIJ3hfT9voZ6SticMmzqEI4bUj42Dhhtzb14ahf8HCyBzJqUm+vOwQ
	 JXKIDIsQRDDeLjXooWGh73XM3ZHbJ4qm+J8FbvyiZ61/+fpqnGWjV4yvbzG3IUEka3
	 /7TU1W71dci7p8/WrDLuru5Y5FJjqw2Ry3Hsvn0kFujjmqj607YsLAynesAluMFtN5
	 V9QOtxaZdZ8TKxwQM4dEIoLkwBlk4dEQG0R4Nvmct7AEy+nVBEdfpn3vFSfws9fokh
	 E/sLZCfgDjRYSy8FDwJpT8ljJSh0kfujBiEXhP9+fdygn57o9Wp4KbtEOBcY8fITFi
	 9P7+wMy8/4n8A==
Message-ID: <57dbd60e-72ab-4140-bec8-05f36fea1ac7@kernel.org>
Date: Mon, 18 May 2026 10:03:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] ata: libata-scsi: route non-zero LUN commands for
 multi-LUN ATAPI
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512202728.299414-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/12 22:27, Phil Pemberton wrote:
> Two changes are required to route commands to ATAPI LUNs other than 0:
> 
> 1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
>    with a non-zero LUN, returning NULL and dropping the command on
>    the floor.  Hoist a non-zero LUN early-exit ahead of the original
>    channel/id checks: when scsidev->lun is non-zero, allow it through
>    only if the underlying ata_device is ATAPI class.  The original
>    LUN-0 path is left structurally unchanged.
> 
> 2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
>    CDB byte 1 bits 7:5 rather than relying on transport-level LUN
>    addressing.  Encode scmd->device->lun into those bits, preserving
>    the existing command-specific bits in 4:0.  This is required by
>    both the Panasonic PD/CD combos and Nakamichi CD changers.
> 
>    The SCSI layer caps the LUN at shost->max_lun, so a value beyond
>    the device's nr_luns should never reach this point; guard with
>    WARN_ON_ONCE() and return AC_ERR_INVALID if it does, since the
>    3-bit CDB field cannot represent it.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7c3d31dc49a1..2d714efc855f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2953,6 +2953,15 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>  	memset(qc->cdb, 0, dev->cdb_len);
>  	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>  
> +	/*
> +	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
> +	 * The SCSI layer caps the LUN at shost->max_lun (<= ATAPI_MAX_LUN),
> +	 * so this should never trip; warn and reject if it does.
> +	 */
> +	if (WARN_ON_ONCE(scmd->device->lun >= dev->nr_luns))
> +		return AC_ERR_INVALID;
> +	qc->cdb[1] = (qc->cdb[1] & 0x1f) | ((u8)scmd->device->lun << 5);

Let's change this as follows:

	qc->cdb[1] = qc->cdb[1] & 0x1f;
	if (unlikely(scmd->device->lun)) {
		if (WARN_ON_ONCE(scmd->device->lun >= dev->nr_luns))
			return AC_ERR_INVALID;
		qc->cdb[1] |= (u8)scmd->device->lun << 5;
	}




-- 
Damien Le Moal
Western Digital Research
