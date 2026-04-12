Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A62BEC2B;
	Sun, 12 Apr 2026 07:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775979496; cv=none; b=X05egRKiINjKJ2lK9NWIwSF8Y0QqIwiBECurfMmyvpIllO4OuR+BlcZIh6ElShDMt1oCnOh/sOALPJwp4R8xrVTPWNO7lQy6aqpW7np1RqhbDC2vMgCVi7gh/C6YHF91Y+TONJkPjm8eUV8ERTb1MyjXtGfXNqQZEqNlrYeyETg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775979496; c=relaxed/simple;
	bh=iwmuy2WqzbumP0E/e9Olfsw1ymNLZs3vSpJoDHgPcpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XpJGd8985+M+B/bGo89z4v60+0oH+pHOR1OVRBhqs8Emsd4f+Ve9wKaev0Sqiw1cPyId2EsK59VzUkJH8yTjR2RL9FphY0GANEJtIfSKx2gP4TEEn3BggpRSgHUYN0BQ1l1RG/cqxu2iKV0b2Rg/e3CsDXmAgoZOUlBcyxKHCGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gCEOMSy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gCEOMSy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A588C19424;
	Sun, 12 Apr 2026 07:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775979496;
	bh=iwmuy2WqzbumP0E/e9Olfsw1ymNLZs3vSpJoDHgPcpI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gCEOMSy6EGFsMx5WkKNV9UT0hdAPNJVM5FvDBCmqlbZrgDhCwCC0IajGxDNJzlSEz
	 TdehB/GboIeFO91fwxewOQHrrzOULxLbeGcBqde33vla7c84MC1q0pFdvgwV7jfbvH
	 BS9nPS5yNCZnihlJCdMAHqvrnbk7mwm/WOoScP9K6g/D0l37FYjleWeSfVdgStXpGc
	 6BRXHxgGa7qb10HdzsX2UJRM49L36VxvggeFjjMeea6LVJzOIsLXFQwGC790N3e60N
	 nJ+vmOqPaOFVKiMEk/0vc2lxnCpRThXEAwyKGyL1LCzGWTwvG3S3wpa/eqSBa8eUSb
	 KXpfNP7JE+s4w==
Message-ID: <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
Date: Sun, 12 Apr 2026 09:38:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI
 devices
To: Phil Pemberton <philpem@philpem.me.uk>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-3-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260409210559.155864-3-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/26 23:05, Phil Pemberton wrote:
> libata has never supported multi-LUN ATAPI devices like the Panasonic
> and NEC PD/CD combo drives due to three limitations:
> 
>   - shost->max_lun is hardcoded to 1 in ata_scsi_add_hosts(), which
>     stops the SCSI layer from probing any LUN other than 0.
> 
>   - __ata_scsi_find_dev() rejects all commands where scsidev->lun != 0,
>     returning NULL which causes DID_BAD_TARGET.
> 
>   - The SCSI-2 CDB LUN field (byte 1, bits 7:5) is never set. Older
>     multi-LUN ATAPI devices rely on this field to route commands to the
>     correct LUN, as transport-layer LUN addressing (per SPC-3+) is not
>     available over the ATA PACKET interface.
> 
> To fix all three, this change:
> 
>   - Raises max_lun from 1 to 8 (matching the SCSI host default).
>     Sequential LUN scanning stops at the first non-responding LUN, so
>     single-LUN devices are unaffected.

If the only case that we can encounter with libata are these special ATAPI
devices with 2 LUNs, I would limit the maximum to 2.

>   - In __ata_scsi_find_dev(), allow non-zero LUNs for ATAPI devices by
>     routing them to the same ata_device as LUN 0.
> 
>   - In atapi_xlat(), encode the target LUN into CDB byte 1 bits 7:5
>     before passing the command packet to the device.
> 
> These changes are prerequisites for probing additional LUNs during
> host scanning, which is done in a subsequent patch.
> 
> Additionally, fix two related issues exposed by multi-LUN scanning:
> 
>   - ata_scsi_dev_config() previously assigned dev->sdev = sdev for every
>     LUN configured.  With multiple LUNs sharing one ata_device, this
>     caused dev->sdev to be overwritten by each non-LUN-0 sdev.  Restrict
>     the assignment to LUN 0 so that dev->sdev always tracks the
>     canonical scsi_device for the underlying ATA device.

Special casing this does not seem nice at all. Why not simply increasing the
sdev reference count when it is assigned to a LUN that is not LUN 0 ? And drop
that reference when the LUN is torn down ? That will remove any dependency on
the order in which LUNs are torn down too.

>   - ata_scsi_sdev_destroy() detached the entire ATA device whenever
>     dev->sdev was non-NULL.  When a spurious multi-LUN scan result was
>     removed, this incorrectly tore down the underlying device.  Detach
>     only when the canonical (LUN 0) sdev is being destroyed.

This should not happen with the reference count change suggested above.

This is a lot of changes for one patch. So I also suggest splitting this patch.

> 
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>  drivers/ata/libata-scsi.c | 38 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 3b65df914ebb..dc6829e60fb3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -25,6 +25,7 @@
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_transport.h>
>  #include <linux/libata.h>
>  #include <linux/hdreg.h>
> @@ -1131,7 +1132,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
>  	if (dev->flags & ATA_DFLAG_TRUSTED)
>  		sdev->security_supported = 1;
>  
> -	dev->sdev = sdev;
> +	/*
> +	 * Only LUN 0 is treated as the canonical scsi_device for the ATA
> +	 * device.  Multi-LUN ATAPI devices share a single ata_device, so
> +	 * dev->sdev must continue to track LUN 0 even when additional LUNs
> +	 * are added or removed.
> +	 */
> +	if (sdev->lun == 0)
> +		dev->sdev = sdev;
>  	return 0;
>  }
>  
> @@ -1220,7 +1228,12 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
>  
>  	spin_lock_irqsave(ap->lock, flags);
>  	dev = __ata_scsi_find_dev(ap, sdev);
> -	if (dev && dev->sdev) {
> +	/*
> +	 * Only detach when the canonical (LUN 0) scsi_device is going away.
> +	 * Removing a non-LUN-0 sdev (e.g. a spurious multi-LUN scan result)
> +	 * must not tear down the underlying ATA device.
> +	 */
> +	if (dev && dev->sdev == sdev) {
>  		/* SCSI device already in CANCEL state, no need to offline it */
>  		dev->sdev = NULL;
>  		dev->flags |= ATA_DFLAG_DETACH;
> @@ -2950,6 +2963,15 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>  	memset(qc->cdb, 0, dev->cdb_len);
>  	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>  
> +	/*
> +	 * Encode LUN in CDB byte 1 bits 7:5 for multi-LUN ATAPI devices
> +	 * that use the SCSI-2 CDB LUN convention (e.g. Panasonic PD/CD
> +	 * combo drives).
> +	 */
> +	if (scmd->device->lun)
> +		qc->cdb[1] = (qc->cdb[1] & 0x1f) |
> +			      ((scmd->device->lun & 0x7) << 5);

Splitting the line after the "=" should look nicer.

> +
>  	qc->complete_fn = atapi_qc_complete;
>  
>  	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
> @@ -3062,9 +3084,17 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
>  
>  	/* skip commands not addressed to targets we simulate */
>  	if (!sata_pmp_attached(ap)) {
> -		if (unlikely(scsidev->channel || scsidev->lun))
> +		if (unlikely(scsidev->channel))
>  			return NULL;
>  		devno = scsidev->id;
> +		/* Allow non-zero LUNs for ATAPI devices (e.g. PD/CD combos) */
> +		if (unlikely(scsidev->lun)) {
> +			struct ata_device *dev = ata_find_dev(ap, devno);
> +
> +			if (!dev || dev->class != ATA_DEV_ATAPI)
> +				return NULL;
> +			return dev;
> +		}

Hmmm... What if the multi-LUN ATAPI device is attached to a port multiplier ?

>  	} else {
>  		if (unlikely(scsidev->id || scsidev->lun))
>  			return NULL;
> @@ -4620,7 +4650,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
>  		shost->transportt = ata_scsi_transport_template;
>  		shost->unique_id = ap->print_id;
>  		shost->max_id = 16;
> -		shost->max_lun = 1;
> +		shost->max_lun = 8;
>  		shost->max_channel = 1;
>  		shost->max_cmd_len = 32;
>  


-- 
Damien Le Moal
Western Digital Research
