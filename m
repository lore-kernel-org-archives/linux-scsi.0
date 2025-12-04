Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578733032E
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764866269; cv=none; b=S4RPwAgU2BjRTvXuSRVJP3pOFi1n9MG6HMAK9bD6J/TBE/lI9CAoru3CD4irXhMTpI7CN2RIVb+DqpnEzj6JX4i/Ilxo59FZzh6UItWQG5EpoB53ILH0NXgSBQpxQSDZSzV7+qUCpe0nmaMc4sHO3lRVCCl1oWoKb7MUPiFt3I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764866269; c=relaxed/simple;
	bh=MUpqyhkBIvnGCLRrJmlVv9gZVnrylmJxJSo9wzW/hIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FD1U6h3a6Ir99QwLHfX+nJtY0BR3WUNp97gNxabq5O71o4i0VR8rCgVnjA9NkRFYfSkLQeXlBZ0zTLKUfHs9yVP6voXEvWEqwevLF4rQBVBe4+2eJ0M11L6C4KEYGBdvNLKDOCeLddampI2oJ8IBwGIzCo4kl2JcRF9CPlmUBSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J9UwGmzg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PbBJv8t6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J9UwGmzg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PbBJv8t6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J9UwGmzg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PbBJv8t6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J9UwGmzg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PbBJv8t6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 11D4F5BDA2;
	Thu,  4 Dec 2025 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764866256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGQt7F5v2YCcB2NadPYK29to35dyJstTVQW1IoKCCxM=;
	b=J9UwGmzgxhwHSIzTPqHG3ZTJylMi5z2481Me86+iQSeUR+VCAFAai/HkrmTiJMLFGTfMAq
	s3Qz0QDUe2Lx0DXW2h3OHr7jBgZ4+Q9VfwfhcrAaG3GTMng/DDyTsW8mqOJTKywvoNeScv
	s0+/MohtVSCbxF17+c37obQwZG7kjg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764866256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGQt7F5v2YCcB2NadPYK29to35dyJstTVQW1IoKCCxM=;
	b=PbBJv8t6Z7ML1F/VzDm+eT1LjObZSe3zE9WeNe9UNS3TA6hMCDzWraEAJ9I+cS7Ywz8nEW
	WyGMJZeeR+xI8XAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J9UwGmzg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PbBJv8t6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764866256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGQt7F5v2YCcB2NadPYK29to35dyJstTVQW1IoKCCxM=;
	b=J9UwGmzgxhwHSIzTPqHG3ZTJylMi5z2481Me86+iQSeUR+VCAFAai/HkrmTiJMLFGTfMAq
	s3Qz0QDUe2Lx0DXW2h3OHr7jBgZ4+Q9VfwfhcrAaG3GTMng/DDyTsW8mqOJTKywvoNeScv
	s0+/MohtVSCbxF17+c37obQwZG7kjg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764866256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGQt7F5v2YCcB2NadPYK29to35dyJstTVQW1IoKCCxM=;
	b=PbBJv8t6Z7ML1F/VzDm+eT1LjObZSe3zE9WeNe9UNS3TA6hMCDzWraEAJ9I+cS7Ywz8nEW
	WyGMJZeeR+xI8XAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6CC83EA63;
	Thu,  4 Dec 2025 16:37:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6hMwMs+4MWlhXgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 04 Dec 2025 16:37:35 +0000
Message-ID: <e932280f-db6d-482b-9109-6a4ff6c6c208@suse.de>
Date: Thu, 4 Dec 2025 17:37:35 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: add re-probe logic into SCSI rescan
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>
References: <20251203231943.18359-1-brian@purestorage.com>
 <20251203231943.18359-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251203231943.18359-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 11D4F5BDA2
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 12/4/25 00:19, Brian Bunker wrote:
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
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi.c        | 159 +++++++++++++++++++++++
>   drivers/scsi/scsi_scan.c   | 253 +++++++++++++++++++++++++------------
>   drivers/scsi/scsi_sysfs.c  |  70 +++++++++-
>   include/scsi/scsi.h        | 171 +++++++++++++++++++++++++
>   include/scsi/scsi_device.h |   2 +
>   5 files changed, 566 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9a0f467264b3..60ffe26039eb 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -61,6 +61,7 @@
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
> +#include <scsi/scsi_devinfo.h>
>   #include <scsi/scsi_driver.h>
>   #include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> @@ -544,6 +545,164 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
> + * data for a SCSI device. This is used during both initial device setup and
> + * when reprobing a device to get fresh INQUIRY information. The old inquiry
> + * buffer is freed and replaced with the new data under the protection of
> + * inquiry_mutex.
> + *
> + * Blacklist flags (BLIST_ISROM, BLIST_NOTQ) are respected when updating
> + * device properties.
> + *
> + * Returns:
> + *   0 on success
> + *   1 if device type or peripheral qualifier changed (caller should call device_reprobe())
> + *  -ENOMEM on allocation failure
> + *  -EINVAL if inquiry data is too short
> + */
> +int scsi_update_inquiry_data(struct scsi_device *sdev,
> +			      unsigned char *inq_result, size_t inq_len)
> +{
> +	unsigned char *new_inquiry;
> +	unsigned char old_type;
> +	unsigned char old_periph_qual;
> +
> +	/*
> +	 * Ensure we have at least the minimum standard INQUIRY data (36 bytes)
> +	 * to safely access device type, vendor, model, rev, and capability flags.
> +	 */
> +	if (inq_len < SCSI_INQ_STD_LEN) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "INQUIRY data too short (%zu bytes), need at least %d\n",
> +			    inq_len, SCSI_INQ_STD_LEN);
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate new inquiry buffer */
> +	new_inquiry = kmemdup(inq_result, max_t(size_t, inq_len, SCSI_INQ_STD_LEN),
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
> +	sdev->vendor = scsi_inq_vendor(sdev->inquiry);
> +	sdev->model = scsi_inq_product(sdev->inquiry);
> +	sdev->rev = scsi_inq_revision(sdev->inquiry);
> +	sdev->inq_periph_qual = scsi_inq_periph_qual(inq_result[0]);
> +
> +	/*
> +	 * Check if this is an ATA device (SATA emulation layer).
> +	 * ATA devices need allow_restart set to work around SATL power
> +	 * management specifications.
> +	 */
> +	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
> +		sdev->is_ata = 1;
> +		sdev->allow_restart = 1;
> +	} else
> +		sdev->is_ata = 0;
> +
> +	/*
> +	 * Update device type from INQUIRY byte 0.
> +	 * BLIST_ISROM is a quirk for devices that report wrong type but should
> +	 * be treated as (removable) CD-ROM. Override to TYPE_ROM as exception.
> +	 */
> +	if (sdev->sdev_bflags & BLIST_ISROM)
> +		sdev->type = TYPE_ROM;
> +	else
> +		sdev->type = scsi_inq_device_type(inq_result[0], sdev->lun);
> +
> +	/*
> +	 * Update removable flag from INQUIRY byte 1.
> +	 * BLIST_ISROM devices are always removable (exception/quirk).
> +	 */
> +	if (sdev->sdev_bflags & BLIST_ISROM)
> +		sdev->removable = 1;
> +	else
> +		sdev->removable = scsi_inq_removable(inq_result[1]);
> +
> +	/*
> +	 * Set lockable to match removable. Devices with removable media
> +	 * can typically have their media locked/unlocked via the
> +	 * ALLOW_MEDIUM_REMOVAL command.
> +	 */
> +	sdev->lockable = sdev->removable;
> +
> +	/* Update capability flags from INQUIRY byte 7 */
> +	sdev->soft_reset = (scsi_inq_sftre(inq_result[7]) &&
> +			    (scsi_inq_resp_data_fmt(inq_result[3]) == 2)) ? 1 : 0;
> +
> +	/*
> +	 * Update protocol support flags.
> +	 * Only update ppr if we have enough INQUIRY data (>56 bytes) to check
> +	 * byte 56, or if scsi_level indicates SCSI-3+ support. If we don't have
> +	 * enough data, leave ppr unchanged to avoid incorrectly clearing it
> +	 * during rescan with short INQUIRY.
> +	 */
> +	if (sdev->scsi_level >= SCSI_3 || inq_len > 56)
> +		sdev->ppr = (sdev->scsi_level >= SCSI_3 ||
> +			     (inq_len > 56 && inq_result[56] & 0x04)) ? 1 : 0;
> +	sdev->wdtr = scsi_inq_wbus16(inq_result[7]);
> +	sdev->sdtr = scsi_inq_sync(inq_result[7]);
> +
> +	/*
> +	 * Update tagged queuing support from INQUIRY byte 7.
> +	 * BLIST_NOTQ is an exception to force tagged queuing off.
> +	 */
> +	if (sdev->sdev_bflags & BLIST_NOTQ)
> +		sdev->tagged_supported = 0;
> +	else
> +		sdev->tagged_supported = ((sdev->scsi_level >= SCSI_2) &&
> +					  scsi_inq_cmdque(inq_result[7])) ? 1 : 0;
> +	sdev->simple_tags = sdev->tagged_supported;
> +
> +	mutex_unlock(&sdev->inquiry_mutex);
> +
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
> +	 *
> +	 * During initial setup, old values may not be meaningful (type is -1,
> +	 * periph_qual is 0), but callers handle this appropriately.
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
> index 3c6e089e80c3..102394910ab1 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -898,49 +898,38 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
> -
> -	sdev->vendor = (char *) (sdev->inquiry + 8);
> -	sdev->model = (char *) (sdev->inquiry + 16);
> -	sdev->rev = (char *) (sdev->inquiry + 32);
> -
> -	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
> -	if (sdev->is_ata) {
> -		/*
> -		 * sata emulation layer device.  This is a hack to work around
> -		 * the SATL power management specifications which state that
> -		 * when the SATL detects the device has gone into standby
> -		 * mode, it shall respond with NOT READY.
> -		 */
> -		sdev->allow_restart = 1;
> -	}
> +	sdev->sdev_bflags = *bflags;
>   
> -	if (*bflags & BLIST_ISROM) {
> -		sdev->type = TYPE_ROM;
> -		sdev->removable = 1;
> -	} else {
> -		sdev->type = (inq_result[0] & 0x1f);
> -		sdev->removable = (inq_result[1] & 0x80) >> 7;
> +	if (!sdev->inquiry) {
> +		int ret = scsi_update_inquiry_data(sdev, inq_result,
> +						   sdev->inquiry_len);
> +		if (ret < 0)
> +			return SCSI_SCAN_NO_RESPONSE;
>   
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
> +		/* Type or PQ change during initial setup is unexpected but not fatal */
> +		if (ret > 0) {
> +			sdev_printk(KERN_NOTICE, sdev,
> +				"device type or PQ changed during initial setup\n");
>   		}
> +	}
>   
> +	/* Sanity check that inquiry data was set up */
> +	if (!sdev->inquiry) {
> +		sdev_printk(KERN_ERR, sdev, "inquiry data not set\n");
> +		return SCSI_SCAN_NO_RESPONSE;
>   	}
>   
> +	/*
> +	 * scsi_update_inquiry_data() has already set type, removable, lockable,
> +	 * inq_periph_qual, soft_reset, ppr, wdtr, sdtr, tagged_supported,
> +	 * simple_tags, is_ata, and allow_restart from INQUIRY data. Handle
> +	 * special cases that need the raw inq_result or additional logic.
> +	 */
> +
>   	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
>   		/* RBC and MMC devices can return SCSI-3 compliance and yet
>   		 * still not support REPORT LUNS, so make them act as
> @@ -950,46 +939,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
> @@ -1184,6 +1139,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	blist_flags_t bflags;
>   	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	bool is_reprobe = false;
>   
>   	/*
>   	 * The rescan flag is used as an optimization, the first scan of a
> @@ -1191,7 +1147,19 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
> @@ -1206,11 +1174,24 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
> @@ -1219,6 +1200,54 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
> @@ -1705,6 +1734,10 @@ EXPORT_SYMBOL(scsi_resume_device);
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
> @@ -1721,19 +1754,75 @@ int scsi_rescan_device(struct scsi_device *sdev)
>   		goto unlock;
>   	}
>   
> +	/*
> +	 * Rescan standard INQUIRY data to detect changes in device
> +	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
> +	 */
> +	inq_result = kmalloc(result_len, GFP_KERNEL);

I would wager that a failure here is a critical issue, and we should
_not_ continue as if nothing had happened...

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

All very convoluted.
Why can't call 'scsi_rescan_device()' in scsi_add_lun() above where
we also have a 'rescan' section?

It really is a mess of having several 'reprobe' functions, I'd rather
consolidate that into one.

And I really would love to have a blktest testcase for this.
SCSI scanning is one of the most fundamental things in the
entire SCSI stack, so if we break this we're well and truly hosed...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
