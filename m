Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C88D299943
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255239; cv=none; b=ODmKCzJjc8zuZc9/OqTZSRjezpuQhDGMagb9V2NmaLftyNFRLhgNzlJhcYMyi/NXQdqOwAEhJNHi7RleOIlbqnDYOZC0ltzOuhwDow12CxgHfLtMHAmwED8w7Mce3FXOgdrNCh7sr2gdNI5ufaD/1TZtqVRVgQk67l8qIAsmft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255239; c=relaxed/simple;
	bh=pfpiYF2ffHKzxei05viCctCKJKBMehz5S6WvHus/DSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3P9ZCKOEFyVUmN8GqrZIRkF4wNndI2vRzfynInHy59piZDm0iTGdC5Dp+8CiAGsgStLIQKMeD9Pixi4HAzgcpFlYp3lSXvk2puCJM/zlNvmQYTcHkjE0dwzM1VTEm4gT66Vgyd/VnMbXaQlTEEM7R9SHLDD1O+ez/DtcRWfAmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nwe48G0z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kHaOfydV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oh8gJ1Ja; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6burtWar; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nwe48G0z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kHaOfydV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oh8gJ1Ja";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6burtWar"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA7605BCCF;
	Thu, 27 Nov 2025 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764255235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6el5eG4ep9v7g+ocR3JT9/5GoM2i4Nxd0ORiyKufQE=;
	b=Nwe48G0zXTX8lQ4ueRl6NwKtyMiMRyKHbFiVxkeqFw1gEWKFgIfmb4NpkZg+HJ6a2wbpQD
	6EEnGaDmNdtTspD+/7EVpJTz7pNjL1uypTKS5omdkXLwWg7A3ulzDWSVK+DMAg6j51rb/+
	5Ufm/r0SVRnJZUT57vAU0Uv1gwMtn+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764255235;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6el5eG4ep9v7g+ocR3JT9/5GoM2i4Nxd0ORiyKufQE=;
	b=kHaOfydVPlaOV5MBwZ2Z9in+PoqVT41bIEwKHZeUAMW7WX0zA1lwXBZVOd3fbCBtS0pdAF
	azsf6SsVEB7jD4Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oh8gJ1Ja;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6burtWar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764255233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6el5eG4ep9v7g+ocR3JT9/5GoM2i4Nxd0ORiyKufQE=;
	b=oh8gJ1Ja76OZwM956KMj41YE0ZHvTk0FiVisBRuMNTHVWZfGidhqIVKzABakG3V0MY9Z7E
	lWik0pkHob1TxYpno//SEXzjz35Gf1v9JiH0uH8FmaGfT2YW+sRCgfV9MWqKVvzdjx0ZSg
	ZOzpU83WiNRv2qxBIWNfLKnpWqIu1Ik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764255233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6el5eG4ep9v7g+ocR3JT9/5GoM2i4Nxd0ORiyKufQE=;
	b=6burtWarG8qVibZ4ISQipFbl9lXYfPBuuKxBNzsndKMV8/Jo/APix4t8vqqXgTsUFGLBcf
	Ab1nEQfdSosKWaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFBFC3EA63;
	Thu, 27 Nov 2025 14:53:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7lEVKQFmKGnHJAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 14:53:53 +0000
Message-ID: <8b7bb4ab-6b27-4768-a238-2349f8517687@suse.de>
Date: Thu, 27 Nov 2025 15:53:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: add re-probe logic into SCSI rescan
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>
References: <20251113201819.76650-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251113201819.76650-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,purestorage.com:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CA7605BCCF

On 11/13/25 21:18, Brian Bunker wrote:
> SCSI rescanning will skip updating inquiry data if a device
> has already been created. This means that if a target changes the
> inquiry data of a device whether or not a unit attention is posted
> that will not ever be changed on a device.
> 
> This is a particular problem for handling the ALUA unavailable state
> which requires setting the peripheral qualifier on a LUN. This
> toggling of that value makes it impossible without this functionality
> to properly handle that state.
> 
> Additionally this fixes the updating of inquiry data when a unit
> attention of inquiry data has changed is returned from the target.
> 

In general this is not a bad idea; we're doing a similar thing for
the VPD pages already, so it seems to be okay in general.

But some comments further below:

> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi.c        | 120 ++++++++++++++++++
>   drivers/scsi/scsi_scan.c   | 246 +++++++++++++++++++++++++------------
>   include/scsi/scsi_device.h |   2 +
>   3 files changed, 292 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9a0f467264b3..c03ba25793f8 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -544,6 +544,126 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>   	kfree(vpd_buf);
>   }
>   
> +/**
> + * scsi_update_inquiry_data - Update standard INQUIRY data for a SCSI device
> + * @sdev: The device to update
> + * @inq_result: Buffer containing new INQUIRY data
> + * @inq_len: Length of inquiry data
> + *
> + * Updates the standard INQUIRY data (vendor, model, rev, peripheral qualifier,
> + * device type, removable media flag) and capability flags derived from INQUIRY
> + * data for an existing SCSI device. This is used when reprobing a device to get
> + * fresh INQUIRY information. The old inquiry buffer is freed and replaced with
> + * the new data under the protection of inquiry_mutex.
> + *
> + * Blacklist flags (BLIST_ISROM, BLIST_NOT_LOCKABLE, BLIST_NOTQ) are respected
> + * when updating device properties.
> + *
> + * Returns:
> + *   0 on success
> + *   1 if device type or peripheral qualifier changed (caller should call device_reprobe())
> + *  -ENOMEM on allocation failure
> + */
> +int scsi_update_inquiry_data(struct scsi_device *sdev,
> +			      unsigned char *inq_result, size_t inq_len)
> +{
> +	unsigned char *new_inquiry;
> +	unsigned char old_type;
> +	unsigned char old_periph_qual;
> +
> +	/* Allocate new inquiry buffer */
> +	new_inquiry = kmemdup(inq_result, max_t(size_t, inq_len, 36),
> +			      GFP_KERNEL);
> +	if (!new_inquiry)
> +		return -ENOMEM;
> +
> +	/* Update inquiry data under mutex protection */
> +	mutex_lock(&sdev->inquiry_mutex);
> +
> +	/* Save old values to detect changes that require reprobe */
> +	old_type = sdev->type;
> +	old_periph_qual = sdev->inq_periph_qual;
> +
> +	kfree(sdev->inquiry);
> +	sdev->inquiry = new_inquiry;
> +	sdev->vendor = (char *)(sdev->inquiry + 8);
> +	sdev->model = (char *)(sdev->inquiry + 16);
> +	sdev->rev = (char *)(sdev->inquiry + 32);
> +	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;

I really hate these.
Can't we replace them with accessor functions and drop the pointers?

> +
> +	/*
> +	 * Update device type and removable media flag from INQUIRY bytes 0-1.
> +	 * This is the single source of truth for setting these fields from
> +	 * INQUIRY data, used by both initial probe (scsi_add_lun) and reprobe
> +	 * (scsi_rescan_device, scsi_probe_and_add_lun).
> +	 */
> +	if (!(sdev->sdev_bflags & BLIST_ISROM)) {
> +		sdev->type = inq_result[0] & 0x1f;
> +		sdev->removable = (inq_result[1] & 0x80) >> 7;

Similar here.
We should use accessor functions and drop the structure entries.

> +
> +		/*
> +		 * some devices may respond with wrong type for
> +		 * well-known logical units. Force well-known type
> +		 * to enumerate them correctly.
> +		 */
> +		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
> +				    __func__, sdev->type, (unsigned int)sdev->lun);
> +			sdev->type = TYPE_WLUN;

And the accessors can take this into account, too.

> +		}
> +
> +		/* lockable defaults to removable, unless blacklist overrides */
> +		sdev->lockable = sdev->removable;
> +		if (sdev->sdev_bflags & BLIST_NOT_LOCKABLE)
> +			sdev->lockable = 0;
> +	}
> +
> +	/* Update capability flags from INQUIRY byte 7 */
> +	sdev->soft_reset = ((inq_result[7] & 1) && ((inq_result[3] & 7) == 2)) ? 1 : 0;
> +
> +	/* Update protocol support flags */
> +	sdev->ppr = (sdev->scsi_level >= SCSI_3 ||
> +		     (inq_len > 56 && inq_result[56] & 0x04)) ? 1 : 0;
> +	sdev->wdtr = (inq_result[7] & 0x60) ? 1 : 0;
> +	sdev->sdtr = (inq_result[7] & 0x10) ? 1 : 0;
> +
> +	/* Update tagged queuing support */
> +	sdev->tagged_supported = ((sdev->scsi_level >= SCSI_2) &&
> +				  (inq_result[7] & 2) &&
> +				  !(sdev->sdev_bflags & BLIST_NOTQ)) ? 1 : 0;
> +	sdev->simple_tags = sdev->tagged_supported;
> +
> +	mutex_unlock(&sdev->inquiry_mutex);
> +

And we even have an inquiry mutex, so we can hide the entire inquiry
string update behind the mutex.
Clearly we'll need to modify the sysfs attribute function to take the 
mutex, too, but that should be okay as it's not the hot path anyway.

> +	/*
> +	 * If device type or peripheral qualifier changed, return a special
> +	 * code to indicate that caller should trigger device_reprobe() to
> +	 * re-match with appropriate upper-layer driver.
> +	 *
> +	 * - Type changes require different drivers (sd vs sr vs st, etc.)
> +	 * - PQ changes affect scsi_bus_match() which only matches PQ == 0
> +	 *
> +	 * Note: We check this AFTER updating all fields and releasing the
> +	 * mutex, so all INQUIRY-derived data is current regardless of whether
> +	 * reprobe is needed.
> +	 */
> +	if (old_type != sdev->type || old_periph_qual != sdev->inq_periph_qual) {
> +		if (old_type != sdev->type)
> +			sdev_printk(KERN_NOTICE, sdev,
> +				    "device type changed from %d to %d\n",
> +				    old_type, sdev->type);
> +		if (old_periph_qual != sdev->inq_periph_qual)
> +			sdev_printk(KERN_NOTICE, sdev,
> +				    "peripheral qualifier changed from %d to %d\n",
> +				    old_periph_qual, sdev->inq_periph_qual);
> +		return 1; /* Type or PQ changed - caller should reprobe */
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_update_inquiry_data);
> +
>   /**
>    * scsi_report_opcode - Find out if a given command is supported
>    * @sdev:	scsi device to query
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3c6e089e80c3..7f79b96ec992 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -898,19 +898,27 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	 * these strings are invalid, but often they contain plausible data
>   	 * nonetheless.  It doesn't matter if the device sent < 36 bytes
>   	 * total, since scsi_probe_lun() initializes inq_result with 0s.
> +	 *
> +	 * Set sdev_bflags before calling scsi_update_inquiry_data() so it
> +	 * can use the correct blacklist flags (especially BLIST_ISROM).
>   	 */
> -	sdev->inquiry = kmemdup(inq_result,
> -				max_t(size_t, sdev->inquiry_len, 36),
> -				GFP_KERNEL);
> -	if (sdev->inquiry == NULL)
> -		return SCSI_SCAN_NO_RESPONSE;
> +	sdev->sdev_bflags = *bflags;
>   
> -	sdev->vendor = (char *) (sdev->inquiry + 8);
> -	sdev->model = (char *) (sdev->inquiry + 16);
> -	sdev->rev = (char *) (sdev->inquiry + 32);
> +	if (!sdev->inquiry) {
> +		int ret = scsi_update_inquiry_data(sdev, inq_result,
> +						   sdev->inquiry_len);
> +		if (ret < 0) {
> +			return SCSI_SCAN_NO_RESPONSE;
> +		}
> +		/* Type or PQ change during initial setup is unexpected but not fatal */
> +		if (ret > 0) {
> +			sdev_printk(KERN_NOTICE, sdev,
> +				"device type or PQ changed during initial setup\n");
> +		}
> +	}
>   
> -	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
> -	if (sdev->is_ata) {
> +	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
> +		sdev->is_ata = 1;

That is a bit weird conceptually, as the conditional above checks for
'sdev->inquiry', so I would have expected a check for that within
the condition. At least some sanity check the that inquiry string
really is set. Or something.

>   		/*
>   		 * sata emulation layer device.  This is a hack to work around
>   		 * the SATL power management specifications which state that
> @@ -920,26 +928,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   		sdev->allow_restart = 1;
>   	}
>   
> -	if (*bflags & BLIST_ISROM) {
> -		sdev->type = TYPE_ROM;
> -		sdev->removable = 1;
> -	} else {
> -		sdev->type = (inq_result[0] & 0x1f);
> -		sdev->removable = (inq_result[1] & 0x80) >> 7;
> -
> -		/*
> -		 * some devices may respond with wrong type for
> -		 * well-known logical units. Force well-known type
> -		 * to enumerate them correctly.
> -		 */
> -		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
> -			sdev_printk(KERN_WARNING, sdev,
> -				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
> -				__func__, sdev->type, (unsigned int)sdev->lun);
> -			sdev->type = TYPE_WLUN;
> -		}
> -
> -	}
> +	/*
> +	 * scsi_update_inquiry_data() has already set type, removable, lockable,
> +	 * inq_periph_qual, soft_reset, ppr, wdtr, sdtr, tagged_supported, and
> +	 * simple_tags from INQUIRY data. Handle special cases that need the
> +	 * raw inq_result or additional logic.
> +	 */
>   
>   	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
>   		/* RBC and MMC devices can return SCSI-3 compliance and yet
> @@ -950,46 +944,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   			*bflags |= BLIST_NOREPORTLUN;
>   	}
>   
> -	/*
> -	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
> -	 * spec says: The device server is capable of supporting the
> -	 * specified peripheral device type on this logical unit. However,
> -	 * the physical device is not currently connected to this logical
> -	 * unit.
> -	 *
> -	 * The above is vague, as it implies that we could treat 001 and
> -	 * 011 the same. Stay compatible with previous code, and create a
> -	 * scsi_device for a PQ of 1
> -	 *
> -	 * Don't set the device offline here; rather let the upper
> -	 * level drivers eval the PQ to decide whether they should
> -	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
> -	 */
> -
> -	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
> -	sdev->lockable = sdev->removable;
> -	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
> -
> -	if (sdev->scsi_level >= SCSI_3 ||
> -			(sdev->inquiry_len > 56 && inq_result[56] & 0x04))
> -		sdev->ppr = 1;
> -	if (inq_result[7] & 0x60)
> -		sdev->wdtr = 1;
> -	if (inq_result[7] & 0x10)
> -		sdev->sdtr = 1;
> -
>   	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
>   			"ANSI: %d%s\n", scsi_device_type(sdev->type),
>   			sdev->vendor, sdev->model, sdev->rev,
>   			sdev->inq_periph_qual, inq_result[2] & 0x07,
>   			(inq_result[3] & 0x0f) == 1 ? " CCS" : "");
>   
> -	if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
> -	    !(*bflags & BLIST_NOTQ)) {
> -		sdev->tagged_supported = 1;
> -		sdev->simple_tags = 1;
> -	}
> -
>   	/*
>   	 * Some devices (Texel CD ROM drives) have handshaking problems
>   	 * when used with the Seagate controllers. borken is initialized
> @@ -1184,6 +1144,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	blist_flags_t bflags;
>   	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	bool is_reprobe = false;
>   
>   	/*
>   	 * The rescan flag is used as an optimization, the first scan of a
> @@ -1191,7 +1152,19 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	 */
>   	sdev = scsi_device_lookup_by_target(starget, lun);
>   	if (sdev) {
> -		if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
> +		if (rescan == SCSI_SCAN_INITIAL && !scsi_device_created(sdev)) {
> +			/*
> +			 * During initial scan, if device is already fully initialized
> +			 * (not in CREATED state), skip reprobing. This is an optimization
> +			 * to avoid redundant probing during boot when the same LUN is
> +			 * discovered multiple times (e.g., via REPORT_LUNS and then
> +			 * sequential scan).
> +			 *
> +			 * Note: We don't check PQ here because sdev->inq_periph_qual
> +			 * is the cached value. If the target changed PQ, we won't detect
> +			 * it without sending INQUIRY. However, during initial boot scan,
> +			 * we assume devices don't change state, so this optimization is safe.
> +			 */
>   			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>   				"scsi scan: device exists on %s\n",
>   				dev_name(&sdev->sdev_gendev)));
> @@ -1206,11 +1179,24 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   								 sdev->model);
>   			return SCSI_SCAN_LUN_PRESENT;
>   		}
> -		scsi_device_put(sdev);
> -	} else
> +		/*
> +		 * For rescan operations or devices still being created,
> +		 * always reprobe to detect peripheral qualifier or device type
> +		 * changes:
> +		 * - PQ 0 -> non-zero: detach upper layer drivers (scsi_bus_match fails)
> +		 * - PQ non-zero -> 0: attach upper layer drivers (scsi_bus_match succeeds)
> +		 * - Type change: re-match with correct driver (sd vs sr vs st, etc.)
> +		 */
> +		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +			"scsi scan: device exists (type %d, PQ %d), reprobing\n",
> +			sdev->type, sdev->inq_periph_qual));
> +		is_reprobe = true;
> +		/* Continue with existing device - keep the reference */
> +	} else {
>   		sdev = scsi_alloc_sdev(starget, lun, hostdata);
> -	if (!sdev)
> -		goto out;
> +		if (!sdev)
> +			goto out;
> +	}
>   
>   	result = kmalloc(result_len, GFP_KERNEL);
>   	if (!result)
> @@ -1219,6 +1205,54 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	if (scsi_probe_lun(sdev, result, result_len, &bflags))
>   		goto out_free_result;
>   
> +	/*
> +	 * For reprobe scenarios, update the inquiry data with fresh
> +	 * INQUIRY results. The device already exists in sysfs, so we
> +	 * don't call scsi_add_lun() which would try to add it again.
> +	 */
> +	if (is_reprobe) {
> +		int update_ret = scsi_update_inquiry_data(sdev, result, result_len);
> +		if (update_ret < 0) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				"scsi scan: failed to update inquiry data\n");
> +			res = SCSI_SCAN_NO_RESPONSE;
> +			goto out_free_result;
> +		}
> +		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +			"scsi scan: updated inquiry data (type %d, PQ %d)\n",
> +			sdev->type, sdev->inq_periph_qual));
> +
> +		/* Update VPD pages with fresh data */
> +		if (sdev->scsi_level >= SCSI_3)
> +			scsi_attach_vpd(sdev);
> +
> +		if (bflagsp)
> +			*bflagsp = bflags;
> +
> +		/*
> +		 * Trigger device reprobe if type or PQ changed.
> +		 * scsi_update_inquiry_data() returns 1 when either changes.
> +		 *
> +		 * The scsi_bus_match() function only matches devices with
> +		 * PQ == 0, so PQ changes cause driver attach/detach.
> +		 *
> +		 * Device type changes require reprobe to match the correct
> +		 * upper-layer driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
> +		 */
> +		if (update_ret > 0) {
> +			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +				"scsi scan: type or PQ changed, reprobing for drivers\n"));
> +			res = device_reprobe(&sdev->sdev_gendev);
> +			if (res < 0)
> +				sdev_printk(KERN_WARNING, sdev,
> +					"scsi scan: device reprobe failed: %d\n", res);
> +		}
> +
> +		/* Device already exists, just return success */
> +		res = SCSI_SCAN_LUN_PRESENT;
> +		goto out_free_result;
> +	}
> +
>   	if (bflagsp)
>   		*bflagsp = bflags;
>   	/*
> @@ -1705,6 +1739,10 @@ EXPORT_SYMBOL(scsi_resume_device);
>   int scsi_rescan_device(struct scsi_device *sdev)
>   {
>   	struct device *dev = &sdev->sdev_gendev;
> +	unsigned char *inq_result;
> +	blist_flags_t bflags;
> +	int result_len = 256;
> +	int inquiry_ret = 0;
>   	int ret = 0;
>   
>   	device_lock(dev);
> @@ -1721,19 +1759,75 @@ int scsi_rescan_device(struct scsi_device *sdev)
>   		goto unlock;
>   	}
>   
> +	/*
> +	 * Rescan standard INQUIRY data to detect changes in device
> +	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
> +	 */
> +	inq_result = kmalloc(result_len, GFP_KERNEL);
> +	if (inq_result) {
> +		if (scsi_probe_lun(sdev, inq_result, result_len,
> +				   &bflags) == 0) {
> +			/* Successfully got fresh INQUIRY data */
> +			inquiry_ret = scsi_update_inquiry_data(sdev, inq_result,
> +							       sdev->inquiry_len);
> +			if (inquiry_ret < 0) {
> +				sdev_printk(KERN_WARNING, sdev,
> +					"scsi rescan: failed to update inquiry data\n");
> +			} else {
> +				SCSI_LOG_SCAN_BUS(3,
> +					sdev_printk(KERN_INFO, sdev,
> +					"scsi rescan: updated inquiry data, PQ %d\n",
> +					sdev->inq_periph_qual));
> +			}
> +		}
> +		kfree(inq_result);
> +	}
> +
>   	scsi_attach_vpd(sdev);
>   	scsi_cdl_check(sdev);
>   
> -	if (sdev->handler && sdev->handler->rescan)
> -		sdev->handler->rescan(sdev);
> +	/*
> +	 * If peripheral qualifier or device type changed, reprobe to update
> +	 * driver attachment. scsi_update_inquiry_data() returns 1 when either
> +	 * changes.
> +	 *
> +	 * The scsi_bus_match() function only matches devices with PQ == 0,
> +	 * so PQ changes cause driver attach/detach.
> +	 *
> +	 * Device type changes require reprobe to match the correct upper-layer
> +	 * driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
> +	 */
> +	if (inquiry_ret > 0) {
> +		int reprobe_ret;
>   
> -	if (dev->driver && try_module_get(dev->driver->owner)) {
> -		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +			"scsi rescan: type or PQ changed, reprobing\n"));
>   
> -		if (drv->rescan)
> -			drv->rescan(dev);
> -		module_put(dev->driver->owner);
> +		device_unlock(dev);
> +		reprobe_ret = device_reprobe(dev);
> +		device_lock(dev);
> +
> +		if (reprobe_ret < 0) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				"scsi rescan: device reprobe failed: %d\n", reprobe_ret);
> +		}
> +	} else if (inquiry_ret == 0) {
> +		/*
> +		 * PQ and type unchanged, just call driver's rescan
> +		 * function to update device properties (capacity, etc.)
> +		 */
> +		if (sdev->handler && sdev->handler->rescan)
> +			sdev->handler->rescan(sdev);
> +
> +		if (dev->driver && try_module_get(dev->driver->owner)) {
> +			struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +			if (drv->rescan)
> +				drv->rescan(dev);
> +			module_put(dev->driver->owner);
> +		}
>   	}
> +	/* If inquiry_ret < 0, INQUIRY failed - skip both reprobe and rescan */
>   
>   unlock:
>   	device_unlock(dev);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 993008cdea65..831b16422f5c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -400,6 +400,8 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
>   void scsi_attach_vpd(struct scsi_device *sdev);
>   void scsi_cdl_check(struct scsi_device *sdev);
>   int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
> +int scsi_update_inquiry_data(struct scsi_device *sdev,
> +			      unsigned char *inq_result, size_t inq_len);
>   
>   extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
>   extern int __must_check scsi_device_get(struct scsi_device *);
Cheers,
Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
