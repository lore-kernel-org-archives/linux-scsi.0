Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3923B27F4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989767; cv=none; b=NTtA6NJ2vGGZsznVMpRStVzKi5P27GDUWOvnmeejJYm8xABZTMMbwIypDcPMSaz6meSDHLZXQpapeFIWhAA91HPvaRJrBufsRVJFs2Eb8P4jHxFjlNi37d4hl/lvuudqyr1AUkkv2RFRL9yf4ICq+dCe7FoiviV2LeIJa72cgdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989767; c=relaxed/simple;
	bh=3OZC7CqO/BvcpZOUiLpIlS/WD1BrBpDwIov5x4ib9gg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJD+yrK8Dj4DzsRU4sJxzLb/qDQI8hZw+uMsJHoY9v/pFiBYh7WcjHw06BUwO8fJz2INTN9hv5ArxLKY5esSTDxW1Qx1n8/6JHkGwTv5Ydanr1V5kAK3nLBpFHREOILp0NBAsUUF4ZevKku7Kx0WUK9TH+/a0K427wZZ3abrji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YAVbXWJ6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rRrt7cf6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YAVbXWJ6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rRrt7cf6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YAVbXWJ6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rRrt7cf6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YAVbXWJ6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rRrt7cf6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46F74759E4;
	Tue,  9 Jun 2026 07:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dHS9Yc7K1GT5DY3X9pkrnK5PaegvYjjxCVRXXMQfBU=;
	b=YAVbXWJ62dWqTFlx/59GLgzSBNkR08eR82qOvZIZFWpjsohobs8WPKFvsCpywNSWRApMev
	ySAkNhskO+DS1p//fGNn2RY2QGYibXa0ZPyETy46HW33LqSQj7JmMkeBVoQqy7zYbFTDNZ
	t++7Magicl1lPELUDW2ztQrJNOve+Yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dHS9Yc7K1GT5DY3X9pkrnK5PaegvYjjxCVRXXMQfBU=;
	b=rRrt7cf6HcXhBJVPfBON9E/JVE6jCTWuHf5s8o2LKmLl5Ljl/Mq+hp3lKTVyvHw+M+lCmx
	/kgtrG/B6WrIvgBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YAVbXWJ6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rRrt7cf6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780989763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dHS9Yc7K1GT5DY3X9pkrnK5PaegvYjjxCVRXXMQfBU=;
	b=YAVbXWJ62dWqTFlx/59GLgzSBNkR08eR82qOvZIZFWpjsohobs8WPKFvsCpywNSWRApMev
	ySAkNhskO+DS1p//fGNn2RY2QGYibXa0ZPyETy46HW33LqSQj7JmMkeBVoQqy7zYbFTDNZ
	t++7Magicl1lPELUDW2ztQrJNOve+Yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780989763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dHS9Yc7K1GT5DY3X9pkrnK5PaegvYjjxCVRXXMQfBU=;
	b=rRrt7cf6HcXhBJVPfBON9E/JVE6jCTWuHf5s8o2LKmLl5Ljl/Mq+hp3lKTVyvHw+M+lCmx
	/kgtrG/B6WrIvgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD429779A7;
	Tue,  9 Jun 2026 07:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tfLfL0K/J2opGQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 09 Jun 2026 07:22:42 +0000
Message-ID: <fb133176-358a-4908-85b0-a75edad582af@suse.de>
Date: Tue, 9 Jun 2026 09:22:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] ata: libata-scsi: convert dev->sdev to per-LUN
 array
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
 <20260608213443.2296614-3-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260608213443.2296614-3-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[philpem.me.uk:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 46F74759E4
X-Spam-Score: -4.51

On 6/8/26 23:34, Phil Pemberton wrote:
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
>    - ata_scsi_dev_config:  assign sdev to dev->sdev[sdev->lun]
>    - ata_scsi_sdev_destroy: clear dev->sdev[sdev->lun]; only trigger
>      ATA-level detach when LUN 0 is destroyed, since removing a higher
>      LUN should not tear down the underlying ATA device
>    - ata_port_detach:  iterate dev->nr_luns slots (high->low)
>    - ata_scsi_offline_dev:  iterate dev->nr_luns slots
>    - ata_scsi_remove_dev:  snapshot and remove all LUN slots, then
>      scsi_remove_device each one outside the lock
>    - ata_scsi_media_change_notify:  send event to all populated LUNs
>    - ata_scsi_dev_rescan:  resume and rescan each populated LUN
>    - ACPI, ZPODD, ofnode, door-lock:  use ata_dev_scsi_device(dev, 0)
> 
> For single-LUN devices (the vast majority) only dev->sdev[0] is ever
> populated and dev->nr_luns stays at 1, so existing call paths see no
> change in behaviour.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-acpi.c  |   6 +-
>   drivers/ata/libata-core.c  |  11 ++-
>   drivers/ata/libata-scsi.c  | 151 +++++++++++++++++++------------------
>   drivers/ata/libata-zpodd.c |   6 +-
>   include/linux/libata.h     |  11 ++-
>   5 files changed, 103 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 4433f626246b..8af35d0b1053 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -153,8 +153,10 @@ static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
>   	char *envp[] = { event_string, NULL };
>   
>   	if (dev) {
> -		if (dev->sdev)
> -			kobj = &dev->sdev->sdev_gendev.kobj;
> +		struct scsi_device *sdev = ata_dev_scsi_device(dev, 0);
> +
> +		if (sdev)
> +			kobj = &sdev->sdev_gendev.kobj;
>   	} else
>   		kobj = &ap->dev->kobj;
>   
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 4408b1fb48c7..1cb159d9dbc7 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5564,6 +5564,7 @@ void ata_dev_init(struct ata_device *dev)
>   	dev->pio_mask = UINT_MAX;
>   	dev->mwdma_mask = UINT_MAX;
>   	dev->udma_mask = UINT_MAX;
> +	dev->nr_luns = 1;
>   }
>   
>   /**
> @@ -6275,11 +6276,15 @@ static void ata_port_detach(struct ata_port *ap)
>   	/* Remove scsi devices */
>   	ata_for_each_link(link, ap, HOST_FIRST) {
>   		ata_for_each_dev(dev, link, ALL) {
> -			if (dev->sdev) {
> +			int lun;
> +
> +			for (lun = dev->nr_luns - 1; lun >= 0; lun--) {
> +				if (!dev->sdev[lun])
> +					continue;
>   				spin_unlock_irqrestore(ap->lock, flags);
> -				scsi_remove_device(dev->sdev);
> +				scsi_remove_device(dev->sdev[lun]);
>   				spin_lock_irqsave(ap->lock, flags);
> -				dev->sdev = NULL;
> +				dev->sdev[lun] = NULL;

As pointed out by sashiko, this is racy.
Please move 'dev->sdev[lun] = NULL' before unlock, and hold
'sdev' in a temporary variable.

Maybe even make this a separate patch, then this patch can be kept
as just the interface change.

>   			}
>   		}
>   	}
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 32c6a0e497cf..7c3d31dc49a1 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1131,7 +1131,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
>   	if (dev->flags & ATA_DFLAG_TRUSTED)
>   		sdev->security_supported = 1;
>   
> -	dev->sdev = sdev;
> +	dev->sdev[sdev->lun] = sdev;
>   	return 0;
>   }
>   
> @@ -1202,10 +1202,10 @@ EXPORT_SYMBOL_GPL(ata_scsi_sdev_configure);
>    *
>    *	@sdev is about to be destroyed for hot/warm unplugging.  If
>    *	this unplugging was initiated by libata as indicated by NULL
> - *	dev->sdev, this function doesn't have to do anything.
> + *	dev->sdev[], this function doesn't have to do anything.
>    *	Otherwise, SCSI layer initiated warm-unplug is in progress.
> - *	Clear dev->sdev, schedule the device for ATA detach and invoke
> - *	EH.
> + *	Clear the per-LUN slot; when the last LUN (LUN 0) is destroyed,
> + *	schedule ATA-level detach via EH.
>    *
>    *	LOCKING:
>    *	Defined by SCSI layer.  We don't really care.
> @@ -1220,11 +1220,12 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
>   
>   	spin_lock_irqsave(ap->lock, flags);
>   	dev = __ata_scsi_find_dev(ap, sdev);
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
>   	}
>   	spin_unlock_irqrestore(ap->lock, flags);
>   
> @@ -2911,10 +2912,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
>   		 * avoid this infinite loop.
>   		 *
>   		 * This may happen before SCSI scan is complete.  Make
> -		 * sure qc->dev->sdev isn't NULL before dereferencing.
> +		 * sure the LUN-0 sdev isn't NULL before dereferencing.
>   		 */
> -		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
> -			qc->dev->sdev->locked = 0;
> +		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL) {
> +			struct scsi_device *sdev =
> +				ata_dev_scsi_device(qc->dev, 0);
> +
> +			if (sdev)
> +				sdev->locked = 0;
> +		}
>   
>   		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
>   		return;
> @@ -4658,7 +4664,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
>   #ifdef CONFIG_OF
>   static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_port *ap)
>   {
> -	struct scsi_device *sdev = dev->sdev;
> +	struct scsi_device *sdev = ata_dev_scsi_device(dev, 0);
>   	struct device *d = ap->host->dev;
>   	struct device_node *np = d->of_node;
>   	struct device_node *child;
> @@ -4696,7 +4702,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   			struct scsi_device *sdev;
>   			int channel = 0, id = 0;
>   
> -			if (dev->sdev)
> +			if (dev->sdev[0])
>   				continue;
>   
>   			if (ata_is_host_link(link))
> @@ -4707,11 +4713,11 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
>   						 NULL);
>   			if (!IS_ERR(sdev)) {
> -				dev->sdev = sdev;
> +				dev->sdev[0] = sdev;
>   				ata_scsi_assign_ofnode(dev, ap);
>   				scsi_device_put(sdev);
>   			} else {
> -				dev->sdev = NULL;
> +				dev->sdev[0] = NULL;
>   			}
>   		}
>   	}
> @@ -4722,7 +4728,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   	 */
>   	ata_for_each_link(link, ap, EDGE) {
>   		ata_for_each_dev(dev, link, ENABLED) {
> -			if (!dev->sdev)
> +			if (!dev->sdev[0])
>   				goto exit_loop;
>   		}
>   	}
> @@ -4763,7 +4769,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>    *
>    *	This function is called from ata_eh_detach_dev() and is responsible for
>    *	taking the SCSI device attached to @dev offline.  This function is
> - *	called with host lock which protects dev->sdev against clearing.
> + *	called with host lock which protects dev->sdev[] against clearing.
>    *
>    *	LOCKING:
>    *	spin_lock_irqsave(host lock)
> @@ -4773,11 +4779,16 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>    */
>   bool ata_scsi_offline_dev(struct ata_device *dev)
>   {
> -	if (dev->sdev) {
> -		scsi_device_set_state(dev->sdev, SDEV_OFFLINE);
> -		return true;
> +	bool found = false;
> +	int lun;
> +
> +	for (lun = dev->nr_luns - 1; lun >= 0; lun--) {
> +		if (dev->sdev[lun]) {
> +			scsi_device_set_state(dev->sdev[lun], SDEV_OFFLINE);
> +			found = true;
> +		}
>   	}
> -	return false;
> +	return found;
>   }
>   
>   /**
> @@ -4793,49 +4804,38 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
>   static void ata_scsi_remove_dev(struct ata_device *dev)
>   {
>   	struct ata_port *ap = dev->link->ap;
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdevs[ATAPI_MAX_LUN] = {};
>   	unsigned long flags;
> +	int lun;
>   
> -	/* Alas, we need to grab scan_mutex to ensure SCSI device
> -	 * state doesn't change underneath us and thus
> -	 * scsi_device_get() always succeeds.  The mutex locking can
> -	 * be removed if there is __scsi_device_get() interface which
> -	 * increments reference counts regardless of device state.
> -	 */
>   	mutex_lock(&ap->scsi_host->scan_mutex);
>   	spin_lock_irqsave(ap->lock, flags);
>   
> -	/* clearing dev->sdev is protected by host lock */
> -	sdev = dev->sdev;
> -	dev->sdev = NULL;
> +	for (lun = dev->nr_luns - 1; lun >= 0; lun--) {
> +		struct scsi_device *sdev = dev->sdev[lun];
> +
> +		dev->sdev[lun] = NULL;
> +		if (!sdev)
> +			continue;
>   
> -	if (sdev) {
> -		/* If user initiated unplug races with us, sdev can go
> -		 * away underneath us after the host lock and
> -		 * scan_mutex are released.  Hold onto it.
> -		 */
>   		if (scsi_device_get(sdev) == 0) {
> -			/* The following ensures the attached sdev is
> -			 * offline on return from ata_scsi_offline_dev()
> -			 * regardless it wins or loses the race
> -			 * against this function.
> -			 */
>   			scsi_device_set_state(sdev, SDEV_OFFLINE);
> +			sdevs[lun] = sdev;
>   		} else {
>   			WARN_ON(1);
> -			sdev = NULL;
>   		}
>   	}
>   
>   	spin_unlock_irqrestore(ap->lock, flags);
>   	mutex_unlock(&ap->scsi_host->scan_mutex);
>   
> -	if (sdev) {
> +	for (lun = dev->nr_luns - 1; lun >= 0; lun--) {
> +		if (!sdevs[lun])
> +			continue;
>   		ata_dev_info(dev, "detaching (SCSI %s)\n",
> -			     dev_name(&sdev->sdev_gendev));
> -
> -		scsi_remove_device(sdev);
> -		scsi_device_put(sdev);
> +			     dev_name(&sdevs[lun]->sdev_gendev));
> +		scsi_remove_device(sdevs[lun]);
> +		scsi_device_put(sdevs[lun]);
 >   	}>   }
>   
Wouldn't it be simpler to have another mutex under 'dev' to protect
'dev->sdev[]' ?
That would get us out of this mess, and we could do away with the
temporary adev array.

> @@ -4872,9 +4872,12 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
>    */
>   void ata_scsi_media_change_notify(struct ata_device *dev)
>   {
> -	if (dev->sdev)
> -		sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
> -				     GFP_ATOMIC);
> +	int lun;
> +
> +	for (lun = 0; lun < dev->nr_luns; lun++)
> +		if (dev->sdev[lun])
> +			sdev_evt_send_simple(dev->sdev[lun],
> +					     SDEV_EVT_MEDIA_CHANGE, GFP_ATOMIC);
>   }

I guess the iteration need to be protected somehow, either by
taking 'ap->lock' or with the dedicated mutex from the above
comments.

>   
>   /**
> @@ -5007,37 +5010,39 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>   
>   	ata_for_each_link(link, ap, EDGE) {
>   		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev = dev->sdev;
> +			int lun;
>   
> -			/*
> -			 * If the port was suspended before this was scheduled,
> -			 * bail out.
> -			 */
>   			if (ap->pflags & ATA_PFLAG_SUSPENDED)
>   				goto unlock_ap;
>   
> -			if (!sdev)
> -				continue;
> -			if (scsi_device_get(sdev))
> -				continue;
> -
>   			do_resume = dev->flags & ATA_DFLAG_RESUMING;
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
 >   				}> -				dev->flags &= ~ATA_DFLAG_RESUMING;
> +				ret = scsi_rescan_device(sdev);
> +				scsi_device_put(sdev);
> +				spin_lock_irqsave(ap->lock, flags);
> +
> +				if (ret)
> +					goto unlock_ap;
>   			}
> -			ret = scsi_rescan_device(sdev);
> -			scsi_device_put(sdev);
> -			spin_lock_irqsave(ap->lock, flags);
>   
> -			if (ret)
> -				goto unlock_ap;
> +			if (do_resume)
> +				dev->flags &= ~ATA_DFLAG_RESUMING;
>   		}
>   	}
>   
> diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
> index 414e7c63bd85..dca774d8ec05 100644
> --- a/drivers/ata/libata-zpodd.c
> +++ b/drivers/ata/libata-zpodd.c
> @@ -185,7 +185,7 @@ void zpodd_enable_run_wake(struct ata_device *dev)
>   {
>   	struct zpodd *zpodd = dev->zpodd;
>   
> -	sdev_disable_disk_events(dev->sdev);
> +	sdev_disable_disk_events(ata_dev_scsi_device(dev, 0));

I _think_  we should call this for every LUN.

>   
>   	zpodd->powered_off = true;
>   	acpi_pm_set_device_wakeup(&dev->tdev, true);
> @@ -233,14 +233,14 @@ void zpodd_post_poweron(struct ata_device *dev)
>   	zpodd->zp_sampled = false;
>   	zpodd->zp_ready = false;
>   
> -	sdev_enable_disk_events(dev->sdev);
> +	sdev_enable_disk_events(ata_dev_scsi_device(dev, 0));

Same here.

>   }
>   
>   static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
>   {
>   	struct ata_device *ata_dev = context;
>   	struct zpodd *zpodd = ata_dev->zpodd;
> -	struct device *dev = &ata_dev->sdev->sdev_gendev;
> +	struct device *dev = &ata_dev_scsi_device(ata_dev, 0)->sdev_gendev;

And here.

>   
>   	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
>   		zpodd->from_notify = true;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 3e33ee30628d..5db8a2e3f051 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -722,7 +722,8 @@ struct ata_device {
>   	unsigned int		devno;		/* 0 or 1 */
>   	u64			quirks;		/* List of broken features */
>   	unsigned long		flags;		/* ATA_DFLAG_xxx */
> -	struct scsi_device	*sdev;		/* attached SCSI device */
> +	struct scsi_device	*sdev[ATAPI_MAX_LUN];	/* per-LUN SCSI devices */
> +	unsigned int		nr_luns;	/* valid entries in sdev[] */
>   	void			*private_data;
>   #ifdef CONFIG_ATA_ACPI
>   	union acpi_object	*gtf_cache;
> @@ -1715,6 +1716,14 @@ static inline unsigned int ata_dev_absent(const struct ata_device *dev)
>   	return ata_class_absent(dev->class);
>   }
>   
> +static inline struct scsi_device *
> +ata_dev_scsi_device(struct ata_device *dev, unsigned int lun)
> +{
> +	if (WARN_ON_ONCE(lun >= dev->nr_luns))
> +		return NULL;
> +	return dev->sdev[lun];
> +}
> +
>   /*
>    * link helpers
>    */

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
