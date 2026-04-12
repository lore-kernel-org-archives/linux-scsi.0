Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E92642AA9;
	Sun, 12 Apr 2026 07:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775979671; cv=none; b=fSpin9cQJc5sSo+OJBrd3qQBEf7NJybpyyRSKX5wc5x3ej8HM6iXmpyU4COCXnhF8I1z0ZMKzG5TbPcJNTkC21GJnPsSdilv02jLsjpCD0MQuqZ0CqTdAzy74YQmTdPlg7JCM4FW4pXm2wmTvhcwXc5Ut0b2LwM9ameugtZjpbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775979671; c=relaxed/simple;
	bh=t+fxPRduy+kLlBrpzBK0AZzm4tYLYBcjiNRxQEXXe94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHZJpBvYtng13HMkpnF03wwNaPdBCRz+lhe5VPoha19mRtuNJjti/FQaBRuuZziZDJRBvY/MaBK1WLJ6H72d6Vr4G4nJTaC6bZSx2yA0eiGVA+cVS1nYv51PUcl4if42c1r7frf9U5S2HaSNqDBNICKp+y+5nJqCUyifk7EfgPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BI9rAeLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BI9rAeLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3ECC19424;
	Sun, 12 Apr 2026 07:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775979671;
	bh=t+fxPRduy+kLlBrpzBK0AZzm4tYLYBcjiNRxQEXXe94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BI9rAeLY2FdRh42ALHbBG+mcxSQe8VZ6F1KV7CJ2MnhmKdcRU7wDWT8PGKd4DFYkj
	 OkTWdzwm+ZjF2KX2WNYetttKY5KNmNU7fVql50PZ+h4w2P2WRV+6ZXxoyp5dBnoHEy
	 R1rlxT0zgxwh6GUC4dKTgar0tJm7MFq3z8gSSMwpSWbBUMLjhBYx6PSTN02clomA5k
	 UEkwZZx/IXq2sIQPjhkBzfla1YZW3LYEKobbSP/UKu3r+S4rktR/S+XmxFI77K00SD
	 GIEpE/uvyjIDu3//NJvtMZltfhme7MeEvAZgVldIvVQoacsFCjZJM+2UO/K1ugQ/FR
	 xMmYUnIHUP25Q==
Message-ID: <2eee9241-8910-431a-9305-b5919937c826@kernel.org>
Date: Sun, 12 Apr 2026 09:41:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ata: libata-scsi: probe additional LUNs for multi-LUN
 ATAPI devices
To: Phil Pemberton <philpem@philpem.me.uk>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260409210559.155864-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/26 23:05, Phil Pemberton wrote:
> Some ATAPI devices (e.g. the Panasonic PD/CD combo drives) implement
> multiple logical units. For instance the aforementioned PD/CD has a CD
> drive on LUN 0 and the rewritable Phase-change Dual (PD) block device on
> LUN 1.
> 
> ata_scsi_scan_host() previously only scanned LUN 0 via
> __scsi_add_device(). With the multi-LUN work now in place, extend this
> scan to probe for additional LUNs on devices which have BLIST_FORCELUN
> set in the SCSI device info table.
> 
> Scanning stops when __scsi_add_device() fails, or the device reports
> device type 0x1f (unknown or no device type). The PD drive returns this
> for unimplemented LUNs.
> 
> The aforementioned BLIST_FORCELUN guard prevents non-multilun devices
> from being affected.
> 
> Tested with a Panasonic LF-1195C PD/CD with Compaq firmware, which now
> correctly enumerates as a CD drive (sr) and PD optical drive (sd).
> 
> Also tested with a LITE-ON iHAS124 DVD drive, which has a single LUN and
> ignores the LUN parameter in the CDB. As a result, without the
> BLIST_FORCELUN guard, this drive would pop up as eight separate devices.
> 
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index dc6829e60fb3..0a7ce44118fe 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4732,6 +4732,35 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  			if (!IS_ERR(sdev)) {
>  				dev->sdev = sdev;
>  				ata_scsi_assign_ofnode(dev, ap);
> +				/*
> +				 * Multi-LUN ATAPI devices (e.g. PD/CD combo
> +				 * drives) are flagged BLIST_FORCELUN in
> +				 * scsi_devinfo.  Probe additional LUNs when
> +				 * the flag is set.
> +				 */
> +				if (dev->class == ATA_DEV_ATAPI &&
> +				    (sdev->sdev_bflags & BLIST_FORCELUN)) {
> +					u64 lun;
> +
> +					for (lun = 1; lun < ap->scsi_host->max_lun;
> +					     lun++) {
> +						struct scsi_device *extra;
> +
> +						extra = __scsi_add_device(
> +							ap->scsi_host,
> +							channel, id, lun,
> +							NULL);
> +						if (IS_ERR(extra))
> +							break;
> +						/* PDT 0x1f: no device type */
> +						if (extra->type == 0x1f) {
> +							scsi_remove_device(extra);
> +							scsi_device_put(extra);
> +							break;
> +						}
> +						scsi_device_put(extra);
> +					}
> +				}

It would be a lot nicer and more readable to have this hunk as a helper
function, e.g.: ata_scsi_scan_atapi_luns().

>  				scsi_device_put(sdev);
>  			} else {
>  				dev->sdev = NULL;


-- 
Damien Le Moal
Western Digital Research
