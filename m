Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A0E336897
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 06:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296735; cv=none; b=EzofRHEqaTex0VQUS6lkQgy6Qw7sQtBuv1xFgYHmBasNJO9REo89ROdzag1/8m2sndw5uL8oUMaVO96an+3q0/j1oyw2AT3Kw1lvGYRYg3/Do6wHsM2AMRdW3L0O0CEx63zpo+30eFJHh9c8z6QqzfFzplPv91XcWexf5XWKWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296735; c=relaxed/simple;
	bh=WKKpfLKLlPruDoFG0lw5HjSu6IPPsconppPTz5bxByY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UotaUXQXOwbgraI8D48eCdSpzclpkFI9Agd1UKz7Z6mk4Fg9cIMh3B8+58J25oIfmaYce9HqfYrHVRBql98P9bz3rbwJj9mXu2Y9Q+Gs5gtw7UC3sEisnH155VVhV/jGqiqRfjgXrgpDs2juMoj42XVC0YG6VNM+Wbejp+++Jak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k4ujPrRQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6Jj4s9Nc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=k4ujPrRQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6Jj4s9Nc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k4ujPrRQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6Jj4s9Nc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k4ujPrRQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6Jj4s9Nc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ADD94675E1;
	Mon,  1 Jun 2026 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTsoDSWZETdUfGbvMMV6awD1uPNWcq4wZobDGu3E5oE=;
	b=k4ujPrRQkMWtemdFMe333IjjRKYgkdDXjXUw/rMJ6t9xQgbe2XVpddCaxvYSb0qGt7a5NI
	eC7uf4vWt0FXK8VpLYwHFsV/p1dITVVrwitTi2si9tsYdV7woFxaej9lRbZVF3TeTT4rF/
	O2JvqmdDsjh8DZ3nZUtL/lU/bBZQ8l4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTsoDSWZETdUfGbvMMV6awD1uPNWcq4wZobDGu3E5oE=;
	b=6Jj4s9NcekuPjrjS5wIKVBzNEncVROw9JqCQBGk+ZtK5oGZJfm8bJXQAditNdCWK8vaerN
	+oQLUglGXEKf/VCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k4ujPrRQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Jj4s9Nc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTsoDSWZETdUfGbvMMV6awD1uPNWcq4wZobDGu3E5oE=;
	b=k4ujPrRQkMWtemdFMe333IjjRKYgkdDXjXUw/rMJ6t9xQgbe2XVpddCaxvYSb0qGt7a5NI
	eC7uf4vWt0FXK8VpLYwHFsV/p1dITVVrwitTi2si9tsYdV7woFxaej9lRbZVF3TeTT4rF/
	O2JvqmdDsjh8DZ3nZUtL/lU/bBZQ8l4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTsoDSWZETdUfGbvMMV6awD1uPNWcq4wZobDGu3E5oE=;
	b=6Jj4s9NcekuPjrjS5wIKVBzNEncVROw9JqCQBGk+ZtK5oGZJfm8bJXQAditNdCWK8vaerN
	+oQLUglGXEKf/VCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79300779A7;
	Mon,  1 Jun 2026 06:52:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yp8fHBwsHWodMQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jun 2026 06:52:12 +0000
Message-ID: <1cb02d52-ac32-496e-bf40-50e8dae8c8e5@suse.de>
Date: Mon, 1 Jun 2026 08:52:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] scsi: core: Add device reprobe support to
 scsi_rescan_device()
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, Krishna Kant <krishna.kant@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
 <20260530002019.47109-5-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260530002019.47109-5-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ADD94675E1
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/30/26 02:20, Brian Bunker wrote:
> Update INQUIRY data on rescan and call device_reprobe() if PQ or type
> changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 125 +++++++++++++++++++++++++++++++++++----
>   1 file changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 62409217ff23..89513f341d84 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1094,6 +1094,86 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
>   }
>   #endif
>   
> +/**
> + * __scsi_reprobe_inquiry - Update INQUIRY data and reprobe device if needed
> + * @sdev: The SCSI device to reprobe
> + * @inq_result: Buffer containing fresh INQUIRY data
> + * @inq_len: Length of INQUIRY data
> + * @need_reprobe: Pointer to store whether device_reprobe() is needed
> + *
> + * Updates the device's INQUIRY data, attaches VPD pages, checks CDL support,
> + * and determines if the device needs to be reprobed due to type or peripheral
> + * qualifier changes. If no reprobe is needed, calls driver rescan functions.
> + *
> + * This function does NOT take device_lock - caller must hold it.
> + *
> + * Returns:
> + *   SCSI_INQ_UNCHANGED on success (no reprobe needed)
> + *   SCSI_INQ_REPROBE_NEEDED if type or PQ changed (reprobe needed)
> + *  -ENOMEM on allocation failure
> + *  -EINVAL if INQUIRY data is too short
> + */
> +static int __scsi_reprobe_inquiry(struct scsi_device *sdev,
> +				  unsigned char *inq_result,
> +				  size_t inq_len,
> +				  bool *need_reprobe)
> +{
> +	struct device *dev = &sdev->sdev_gendev;
> +	int ret;
> +
> +	/* Update INQUIRY data */
> +	ret = scsi_update_inquiry_data(sdev, inq_result, inq_len);
> +	if (ret < 0) {
> +		sdev_printk(KERN_ERR, sdev,
> +			    "failed to update inquiry data: %d\n", ret);
> +		return ret;
> +	}
> +
> +	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +		"updated inquiry data (type %d, PQ %d)\n",
> +		sdev->type, sdev->inq_periph_qual));
> +
> +	/* Update VPD pages and CDL support */
> +	scsi_attach_vpd(sdev);
> +	scsi_cdl_check(sdev);
> +
> +	/*
> +	 * If peripheral qualifier or device type changed, caller should
> +	 * reprobe to update driver attachment. scsi_update_inquiry_data()
> +	 * returns 1 when either changes.
> +	 *
> +	 * The scsi_bus_match() function only matches devices with PQ == 0,
> +	 * so PQ changes cause driver attach/detach.
> +	 *
> +	 * Device type changes require reprobe to match the correct upper-layer
> +	 * driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
> +	 */
> +	if (ret == SCSI_INQ_REPROBE_NEEDED) {
> +		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +			"type or PQ changed, reprobe needed\n"));
> +		*need_reprobe = true;
> +		return ret;
> +	}
> +
> +	/*
> +	 * PQ and type unchanged, call driver's rescan functions to update
> +	 * device properties (capacity, etc.)
> +	 */
> +	if (sdev->handler && sdev->handler->rescan)
> +		sdev->handler->rescan(sdev);
> +
> +	if (dev->driver && try_module_get(dev->driver->owner)) {
> +		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +		if (drv->rescan)
> +			drv->rescan(dev);
> +		module_put(dev->driver->owner);
> +	}
> +
> +	*need_reprobe = false;
> +	return ret;
> +}
> +
>   /**
>    * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
>    * @starget:	pointer to target device structure
> @@ -1653,7 +1733,11 @@ EXPORT_SYMBOL(scsi_resume_device);
>   int scsi_rescan_device(struct scsi_device *sdev)
>   {
>   	struct device *dev = &sdev->sdev_gendev;
> +	unsigned char *inq_result;
> +	blist_flags_t bflags;
> +	int result_len = 256;
>   	int ret = 0;
> +	bool need_reprobe = false;
>   
>   	device_lock(dev);
>   
> @@ -1669,18 +1753,37 @@ int scsi_rescan_device(struct scsi_device *sdev)
>   		goto unlock;
>   	}
>   
> -	scsi_attach_vpd(sdev);
> -	scsi_cdl_check(sdev);
> -
> -	if (sdev->handler && sdev->handler->rescan)
> -		sdev->handler->rescan(sdev);
> -
> -	if (dev->driver && try_module_get(dev->driver->owner)) {
> -		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +	/*
> +	 * Rescan standard INQUIRY data to detect changes in device
> +	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
> +	 */
> +	inq_result = kmalloc(result_len, GFP_KERNEL);
> +	if (inq_result) {
> +		if (scsi_probe_lun(sdev, inq_result, result_len,
> +				   &bflags) == 0) {
> +			/* Successfully got fresh INQUIRY data, reprobe if needed */
> +			ret = __scsi_reprobe_inquiry(sdev, inq_result,
> +						     sdev->inquiry_len,
> +						     &need_reprobe);
> +			if (ret < 0) {
> +				/* Critical failure, bail out */
> +				kfree(inq_result);
> +				goto unlock;
> +			}
> +		}
> +		kfree(inq_result);
> +	}
>   
> -		if (drv->rescan)
> -			drv->rescan(dev);
> -		module_put(dev->driver->owner);
> +	/*
> +	 * If type or PQ changed, reprobe to update driver attachment.
> +	 * Must unlock device before calling device_reprobe() to avoid deadlock.
> +	 */
> +	if (need_reprobe) {
> +		device_unlock(dev);
> +		if (device_reprobe(dev) < 0)
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "device reprobe failed\n");
Huh? And that's it?
Shouldn't we take additional action like disabling the device or something?

Also, this unlocking and re-locking always feels weird.
There must be a reason on why the device must be locked, so consequently
the device might be in a different state when you re-lock it again.
Don't we need to check after re-locking that the device state has not
been modified?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
