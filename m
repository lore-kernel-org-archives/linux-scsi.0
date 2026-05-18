Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B9B3176EF;
	Mon, 18 May 2026 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779091245; cv=none; b=jJl05mhIBj7eU8I/lpWQ5JjodAaooKNrBe9jhg+5pnCJW9H8vPKplgD1Es2ovXMl1wgMYiWTwhzsG8cBaVvVdlCUVFMht1+ziz0bKAxUMhdis4UTMh+qE+zJJqdR4XYEHB4xxM/e7QYR9/7Ry2IJcBnMsjCLXN/Hli+tdNxMCQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779091245; c=relaxed/simple;
	bh=luUswWfmNxIcICGPvSonveVZjioHy9cdOR122bmBU6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbX5Vmu5tren0oDBJVULU+w/bkxbhqEmn2MXYbAuZ6pJRYrdVykbFfV2fLlraKS6PFEDBOu5TA6finL45aHGeusaTRpMUVvLRT5Dt+xp5LZsvPsBSYnzWFzeK+jUwyvIT8OTHQajjJgeGmRK99AUCGm8luC1PcO+jTP1A7jfGKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz4tT03W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz4tT03W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10DFC2BCB7;
	Mon, 18 May 2026 08:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779091245;
	bh=luUswWfmNxIcICGPvSonveVZjioHy9cdOR122bmBU6E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Pz4tT03WXOBNHiZpQxgOoDte2J0RSCvlMkOkv4EkE7G0G1Tp4ZT+y47Eq9ePlQTKR
	 yUv+npH0k6hPaXdJJl7e9EESsE2boQNi353zaCVgFH5fluzASWrJwsisfQPAPPJJen
	 tUJ69IwQl+SfQVwxNshiHpM1BBlmFBXqoIUyeik5dvbGJfzUsod/oa/amWK9HFgszZ
	 I2NphjF47Q/tBePPJdrS8LbylU+sqchQJKunh4tWz+VtSZ8EeEqAT/ikcRCJqkoCdL
	 KnITUmDCuvvLvkhCEMNE6FeB4MwmmE5B0wHKTt8jBH7EjzJ7lY/6C99zxWkiOo9cl5
	 /vASKqQ/Sc01g==
Message-ID: <946b7f67-0bd9-42aa-977a-e9f1933ce072@kernel.org>
Date: Mon, 18 May 2026 10:00:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] ata: libata-scsi: convert dev->sdev to per-LUN
 array
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-3-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512202728.299414-3-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/12 22:27, Phil Pemberton wrote:
> Multi-LUN ATAPI devices (PD/CD combos, CD changers) share a single
> ata_device but expose multiple scsi_devices.  The previous single
> dev->sdev pointer could only track one LUN, making all other LUNs
> invisible to code that operates on sdevs: port detach, suspend/resume,
> ACPI uevent, ZPODD, media change notification, and EH teardown.
> 
> Replace the scalar struct scsi_device *sdev with a fixed-size array
> dev->sdev[ATAPI_MAX_LUN] indexed by LUN number, where ATAPI_MAX_LUN
> is 8 (the SCSI-2 ceiling, LUN values 0..7).  Add a companion field
> dev->nr_luns recording the number of valid entries -- defaults to 1
> during ata_dev_init() and is bumped during multi-LUN probe -- so the
> common single-LUN case iterates one slot, not eight.
> 
> Add an inline helper ata_dev_scsi_device(dev, lun) that returns
> dev->sdev[lun] guarded by a WARN_ON_ONCE(lun >= dev->nr_luns) bounds
> check.  Use it for the hardcoded LUN-0 references in libata-acpi
> (uevent kobj), libata-zpodd (disk events, wake notify), and the
> door-lock and OF-node paths in libata-scsi.
> 
> Key changes per call site:
>   - ata_scsi_dev_config:  assign sdev to dev->sdev[sdev->lun]
>   - ata_scsi_sdev_destroy: clear dev->sdev[sdev->lun]; only trigger
>     ATA-level detach when LUN 0 is destroyed, since removing a higher
>     LUN should not tear down the underlying ATA device
>   - ata_port_detach:  iterate dev->nr_luns slots (high->low)
>   - ata_scsi_offline_dev:  iterate dev->nr_luns slots
>   - ata_scsi_remove_dev:  snapshot and remove all LUN slots, then
>     scsi_remove_device each one outside the lock
>   - ata_scsi_media_change_notify:  send event to all populated LUNs
>   - ata_scsi_dev_rescan:  resume and rescan each populated LUN
>   - ACPI, ZPODD, ofnode, door-lock:  use ata_dev_scsi_device(dev, 0)
> 
> For single-LUN devices (the vast majority) only dev->sdev[0] is ever
> populated and dev->nr_luns stays at 1, so existing call paths see no
> change in behaviour.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>

[...]

> @@ -153,8 +153,10 @@ static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
>  	char *envp[] = { event_string, NULL };
>  
>  	if (dev) {
> -		if (dev->sdev)
> -			kobj = &dev->sdev->sdev_gendev.kobj;
> +		struct scsi_device *sdev = ata_dev_scsi_device(dev, 0);
> +
> +		if (sdev)
> +			kobj = &sdev->sdev_gendev.kobj;
>  	} else
>  		kobj = &ap->dev->kobj;

While at it, please add the curly brackets to the else please :)

> @@ -1220,11 +1220,12 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
>  
>  	spin_lock_irqsave(ap->lock, flags);
>  	dev = __ata_scsi_find_dev(ap, sdev);
> -	if (dev && dev->sdev) {
> -		/* SCSI device already in CANCEL state, no need to offline it */
> -		dev->sdev = NULL;
> -		dev->flags |= ATA_DFLAG_DETACH;
> -		ata_port_schedule_eh(ap);
> +	if (dev && dev->sdev[sdev->lun] == sdev) {
> +		dev->sdev[sdev->lun] = NULL;
> +		if (sdev->lun == 0) {
> +			dev->flags |= ATA_DFLAG_DETACH;
> +			ata_port_schedule_eh(ap);
> +		}

Can we ever get to a state where LUN 0 is dead and being removed while LUN 1 is
still well and alive ? If yes, the above is not really correct, no ? We would
need to count the number of valid LUNs...

>  	}
>  	spin_unlock_irqrestore(ap->lock, flags);
>  
> @@ -2911,10 +2912,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
>  		 * avoid this infinite loop.
>  		 *
>  		 * This may happen before SCSI scan is complete.  Make
> -		 * sure qc->dev->sdev isn't NULL before dereferencing.
> +		 * sure the LUN-0 sdev isn't NULL before dereferencing.
>  		 */
> -		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
> -			qc->dev->sdev->locked = 0;
> +		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL) {
> +			struct scsi_device *sdev =
> +				ata_dev_scsi_device(qc->dev, 0);
> +
> +			if (sdev)
> +				sdev->locked = 0;

I do not think that sdev (or sdev[0]) can ever be NULL if we issued a qc against
it. The comment you changed was actually not matching the code at all to start with.

>  void ata_scsi_media_change_notify(struct ata_device *dev)
>  {
> -	if (dev->sdev)
> -		sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
> -				     GFP_ATOMIC);
> +	int lun;
> +
> +	for (lun = 0; lun < dev->nr_luns; lun++)
> +		if (dev->sdev[lun])
> +			sdev_evt_send_simple(dev->sdev[lun],
> +					     SDEV_EVT_MEDIA_CHANGE, GFP_ATOMIC);

Please add curly brackets around the for loop (yes, the if is a single
statement, but given that it is 2 lines of code, I prefer having curly brackets
in such case).

>  }
>  
>  /**
> @@ -5007,37 +5010,39 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>  
>  	ata_for_each_link(link, ap, EDGE) {
>  		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev = dev->sdev;
> +			int lun;
>  
> -			/*
> -			 * If the port was suspended before this was scheduled,
> -			 * bail out.
> -			 */

Please keep this comment.

>  			if (ap->pflags & ATA_PFLAG_SUSPENDED)
>  				goto unlock_ap;
>  
> -			if (!sdev)
> -				continue;
> -			if (scsi_device_get(sdev))
> -				continue;
> -
>  			do_resume = dev->flags & ATA_DFLAG_RESUMING;
>  
> -			spin_unlock_irqrestore(ap->lock, flags);
> -			if (do_resume) {
> -				ret = scsi_resume_device(sdev);
> -				if (ret == -EWOULDBLOCK) {
> -					scsi_device_put(sdev);
> -					goto unlock_scan;
> +			for (lun = 0; lun < dev->nr_luns; lun++) {
> +				struct scsi_device *sdev = dev->sdev[lun];
> +
> +				if (!sdev)
> +					continue;
> +				if (scsi_device_get(sdev))
> +					continue;
> +
> +				spin_unlock_irqrestore(ap->lock, flags);
> +				if (do_resume) {
> +					ret = scsi_resume_device(sdev);
> +					if (ret == -EWOULDBLOCK) {
> +						scsi_device_put(sdev);
> +						goto unlock_scan;
> +					}
>  				}
> -				dev->flags &= ~ATA_DFLAG_RESUMING;
> +				ret = scsi_rescan_device(sdev);
> +				scsi_device_put(sdev);
> +				spin_lock_irqsave(ap->lock, flags);
> +
> +				if (ret)
> +					goto unlock_ap;
>  			}

This does not look right to me. You are changing the order in which things are
done: do_resume is set only if we can get the sdev, but since you moved the loop
that replace the simple get after the do_resume initialization, that chnages the
order. Also, I really think you need to get all sdevs for the dev before calling
scsi_resume_device() for all of them. So split the loop into a sdev get loop,
and a resume loop, with do_resume initialized between them.

> -			ret = scsi_rescan_device(sdev);
> -			scsi_device_put(sdev);
> -			spin_lock_irqsave(ap->lock, flags);
>  
> -			if (ret)
> -				goto unlock_ap;
> +			if (do_resume)
> +				dev->flags &= ~ATA_DFLAG_RESUMING;
>  		}
>  	}

[...]

>  static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
>  {
>  	struct ata_device *ata_dev = context;
>  	struct zpodd *zpodd = ata_dev->zpodd;
> -	struct device *dev = &ata_dev->sdev->sdev_gendev;
> +	struct device *dev = &ata_dev_scsi_device(ata_dev, 0)->sdev_gendev;

I am really not a fan of this. Please add a local sdev variable:

	struct scsi_device *sdev = &ata_dev_scsi_device(ata_dev, 0);
	struct device *dev = &sdev->sdev_gendev;



-- 
Damien Le Moal
Western Digital Research
