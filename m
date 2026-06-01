Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5A4349AEA
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296260; cv=none; b=HpkSAbV7iHP/7FIlwsBnvKOYrObZ5I6GxlMKTCdInh6v0VQnCTnKYOkQgpfQtDYangqrDY+MJL0vQm+VszSIU+n/NpC1HbxH64qxbTkJYt8a93q8xuwlvimEe4Z2A7ShL6yPqMBuBed2l6Os5l5HHkW4t6pJl+c3pxqMfwM7FSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296260; c=relaxed/simple;
	bh=qbUSsfNNfdIyo+uByP+pCoI1wDW0GLcjuA4ycKes1eA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3TpjPxEw78kGy7/Z1FGyP7mifJQWmgDn7XPi5aVrctdLAcZ+HERv780dDxrzRUonlYqWCbl5i8JSErZuC/EcGAkyV7BrZZkR+jE+ZreLY9HitEvga8gKLgyyzFxkaYezJUFK90A7x8qLcmOORbNZmTiq916xgDawGfH3c4w6DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rPpz0yhk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5m/B9xTX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rPpz0yhk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5m/B9xTX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rPpz0yhk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5m/B9xTX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rPpz0yhk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5m/B9xTX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3FE94676FA;
	Mon,  1 Jun 2026 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMum77aJBXcoW6+8Zg4l5xtNwtf5LoMev6VFua7nYEw=;
	b=rPpz0yhkTq+4Ug5XNLNV7MqwR74i/ZQubzDVaFfd9i45XCruOF9QQZxiIIN5fLEkKacXJP
	zapF6oekvCJJaa5dxXnsuYG6FBn0kmPw/FhgfTZtvppwjxzUl+dmR4RBHA3hQ46kOYEtPJ
	pzKhShDsONwKIYzR4MRUXVFTvlTpYyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMum77aJBXcoW6+8Zg4l5xtNwtf5LoMev6VFua7nYEw=;
	b=5m/B9xTXCnXmPF8DRvLdkHKHUbukHv4Dhkmo35kNzViO1mSJPgY6LqlZhZbboNO3LQa5u8
	1iFM86dHqC9jPCBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rPpz0yhk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5m/B9xTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMum77aJBXcoW6+8Zg4l5xtNwtf5LoMev6VFua7nYEw=;
	b=rPpz0yhkTq+4Ug5XNLNV7MqwR74i/ZQubzDVaFfd9i45XCruOF9QQZxiIIN5fLEkKacXJP
	zapF6oekvCJJaa5dxXnsuYG6FBn0kmPw/FhgfTZtvppwjxzUl+dmR4RBHA3hQ46kOYEtPJ
	pzKhShDsONwKIYzR4MRUXVFTvlTpYyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMum77aJBXcoW6+8Zg4l5xtNwtf5LoMev6VFua7nYEw=;
	b=5m/B9xTXCnXmPF8DRvLdkHKHUbukHv4Dhkmo35kNzViO1mSJPgY6LqlZhZbboNO3LQa5u8
	1iFM86dHqC9jPCBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0327B779A7;
	Mon,  1 Jun 2026 06:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MupVOkAqHWokKQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jun 2026 06:44:16 +0000
Message-ID: <f08a3641-3ff9-4a80-bd20-adc52d802de7@suse.de>
Date: Mon, 1 Jun 2026 08:44:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] scsi: core: Add scsi_update_inquiry_data() for
 updating INQUIRY data
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, Krishna Kant <krishna.kant@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
 <20260530002019.47109-3-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260530002019.47109-3-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3FE94676FA
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/30/26 02:20, Brian Bunker wrote:
> Add a new function scsi_update_inquiry_data() that can safely update all
> INQUIRY-derived fields for an existing SCSI device:
> 
> - Vendor, model, revision strings
> - Peripheral qualifier and device type
> - Capability flags (removable, lockable, tagged queuing support, etc.)
> - ATA device detection and allow_restart setting
> 
> The function:
> - Takes the inquiry_mutex to protect against concurrent sysfs reads
> - Respects BLIST_ISROM and BLIST_NOTQ blacklist flags
> - Returns 1 if device type or peripheral qualifier changed, indicating
>    the caller should call device_reprobe() to re-match drivers
> - Returns 0 on success with no changes requiring reprobe
> - Returns negative errno on failure
> 
> This is the core infrastructure needed for updating INQUIRY data during
> device rescan operations, which is required for proper ALUA unavailable
> state handling.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi.c        | 191 +++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h |  13 +++
>   2 files changed, 204 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 76cdad063f7b..94b07225b56e 100644
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
> @@ -549,6 +550,196 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
> + *   SCSI_INQ_UNCHANGED on success
> + *   SCSI_INQ_REPROBE_NEEDED if type or PQ changed (caller should reprobe)
> + *  -ENOMEM on allocation failure
> + *  -EINVAL if inquiry data is too short
> + */
> +int scsi_update_inquiry_data(struct scsi_device *sdev,
> +			     unsigned char *inq_result, size_t inq_len)
> +{
> +	unsigned char *new_inquiry;
> +	unsigned char old_type;
> +	unsigned char old_periph_qual;
> +	bool had_prior_inquiry;
> +	bool reprobe;
> +
> +	/*
> +	 * Ensure we have at least the minimum standard INQUIRY data (36 bytes)
> +	 * to safely access device type, vendor, model, rev, and capability flags.
> +	 */
> +	if (inq_len < 36) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "INQUIRY data too short (%zu bytes), need at least 36\n",
> +			    inq_len);
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate new inquiry buffer */
> +	new_inquiry = kmemdup(inq_result, inq_len, GFP_KERNEL);
> +	if (!new_inquiry)
> +		return -ENOMEM;
> +
> +	/* Update inquiry data under mutex protection */
> +	mutex_lock(&sdev->inquiry_mutex);
> +
> +	/*
> +	 * Save old values to detect changes that require reprobe.
> +	 * Only meaningful if we had prior inquiry data; during initial
> +	 * setup sdev->inquiry is NULL and the old values are just
> +	 * zero-initialized defaults.
> +	 */
> +	had_prior_inquiry = (sdev->inquiry != NULL);
> +	old_type = sdev->type;
> +	old_periph_qual = sdev->inq_periph_qual;
> +
> +	kfree(sdev->inquiry);
> +	sdev->inquiry = new_inquiry;
> +	sdev->inquiry_len = inq_len;
> +	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
> +	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
> +	/*
> +	 * memcpy() instead of strscpy() because strscpy() would read past
> +	 * the end of sdev->inquiry if its length is exactly 36 bytes.
> +	 */
> +	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
> +	       INQUIRY_REVISION_LEN);
> +	sdev->rev[INQUIRY_REVISION_LEN] = '\0';
> +	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
> +
> +	/*
> +	 * Compute scsi_level from INQUIRY bytes 2 and 3. This must be
> +	 * updated under inquiry_mutex alongside the other INQUIRY-derived
> +	 * fields so sysfs readers always see a consistent snapshot.
> +	 */
> +	sdev->scsi_level = inq_result[2] & 0x0f;
> +	if (sdev->scsi_level >= 2 ||
> +	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
> +		sdev->scsi_level++;
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
> +	if (sdev->sdev_bflags & BLIST_ISROM) {
> +		sdev->type = TYPE_ROM;
> +		sdev->removable = 1;
> +	} else {
> +		sdev->type = inq_result[0] & 0x1f;
> +		sdev->removable = (inq_result[1] & 0x80) >> 7;
> +
> +		/*
> +		 * Some devices may respond with wrong type for well-known
> +		 * logical units. Force well-known type to enumerate them
> +		 * correctly.
> +		 */
> +		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
> +				__func__, sdev->type,
> +				(unsigned int)sdev->lun);
> +			sdev->type = TYPE_WLUN;
> +		}
> +	}
> +
> +	/*
> +	 * Set lockable to match removable. Devices with removable media
> +	 * can typically have their media locked/unlocked via the
> +	 * ALLOW_MEDIUM_REMOVAL command.
> +	 */
> +	sdev->lockable = sdev->removable;
> +
> +	/* Update capability flags from INQUIRY byte 7 */
> +	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
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
> +	sdev->wdtr = !!(inq_result[7] & 0x60);
> +	sdev->sdtr = !!(inq_result[7] & 0x10);
> +
> +	/*
> +	 * Update tagged queuing support from INQUIRY byte 7.
> +	 * BLIST_NOTQ is an exception to force tagged queuing off.
> +	 */
> +	if (sdev->sdev_bflags & BLIST_NOTQ)
> +		sdev->tagged_supported = 0;
> +	else
> +		sdev->tagged_supported = (sdev->scsi_level >= SCSI_2) &&
> +					  (inq_result[7] & 2);
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
> +	 */
> +	reprobe = false;
> +	if (had_prior_inquiry) {
> +		if (old_type != sdev->type) {
> +			sdev_printk(KERN_NOTICE, sdev,
> +				    "device type changed from %d to %d\n",
> +				    old_type, sdev->type);
> +			reprobe = true;
> +		}
> +		if (old_periph_qual != sdev->inq_periph_qual) {
> +			sdev_printk(KERN_NOTICE, sdev,
> +				    "peripheral qualifier changed from %d to %d\n",
> +				    old_periph_qual, sdev->inq_periph_qual);
> +			reprobe = true;
> +		}

Hmm. Wouldn't it be simpler to do a memcmp() on the standard inquiry
data? Surely we should reprobe if the model and/or vendor name changed, no?

Otherwise looks good.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
