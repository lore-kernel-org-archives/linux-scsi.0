Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735123803D3
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 06:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296427; cv=none; b=ZRNlADrsvdf8EDLx98px0MOZmE/DFe/j3OcCJjvPK35WeJPdw9//kk+J/ibhCJQcAiCQAUMPJVkp1wXYHqUx4oy7R3fCPRfEHO/OKr1O5zq00OPx2rZD45YvQyZubIjupEJL7rQGfewfw40kztBZhMw4ei8vE6pVH28JVCTv0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296427; c=relaxed/simple;
	bh=dl6ItvaNiXKH4L/CtwMu4g54XD1Z2Dg2IOxcxUb4/9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYzbdXaUlFR10ju+UED8ALHjk8NgyBlxW1Ms7JrVRU5q4BmUXRdcriGOaOwWW33lJkW6bw9iugGid4xTS3zvU7lBDjcynTnQM6kWAknZNuV6BQASINUlh/c4xESZtDK4nGRrnFZguC2coLXD/SXzkBQq4vk1+7sLk1FZmtmUVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jZ5pA90B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6M/gtdXX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uSpdKDr9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x8Fzj/Zx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jZ5pA90B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6M/gtdXX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uSpdKDr9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x8Fzj/Zx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65427675E1;
	Mon,  1 Jun 2026 06:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQaM+cJQgTiGQ8zWxCGkjcIVVqzE6XvMxa/Y8fojrak=;
	b=jZ5pA90BGS8dLr+bVN2Y7tO84AYfGbPZkb66VYyWD5p7VckFMIan6IPPEdRJvnumv5zfXi
	FeJkeVKNgQQnF8a/M7t9zr9o2oVSjdjaQitMfItHQl6BuAK9Z6+QOzMq7w0Zj1Kr/IaDKT
	baC0pvSSb9EEVEzsNhHZ53bKFElILc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQaM+cJQgTiGQ8zWxCGkjcIVVqzE6XvMxa/Y8fojrak=;
	b=6M/gtdXXkSC039ADEPWCYgc9RhoxgwQZ5w2nG4zEVUkXXv3h89+GfacBedvSDmoMG6dZ6W
	fKQZRPS55dE7e9Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780296421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQaM+cJQgTiGQ8zWxCGkjcIVVqzE6XvMxa/Y8fojrak=;
	b=uSpdKDr9QPHf8d2+gzkqlXr/Z3AvgSygRKAJJWaWHHlmTxdZuC3B+GUpEea5HmvEGUy2qk
	KQkzRrzm0IrV9SlKQQg732zLlgb8218kvMUQ8E2hXtq741wQ78UMWRsT2dhz3Fk8CJg/0s
	0A65ymmkDaaKvn40MGkXh+7Nhbmu0ng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780296421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQaM+cJQgTiGQ8zWxCGkjcIVVqzE6XvMxa/Y8fojrak=;
	b=x8Fzj/ZxWZRcJR1PUa1bBWLh5Teg4VCGcWJeTfO9Yix7coo6e1CRM8dO5fbTT/PYMXSafg
	kX8cn+2WT/gz4dDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CB05779A7;
	Mon,  1 Jun 2026 06:47:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 17FyCeUqHWoLLAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jun 2026 06:47:01 +0000
Message-ID: <db5f3bc0-863f-43f6-abf4-eb91637d295a@suse.de>
Date: Mon, 1 Jun 2026 08:47:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] scsi: core: Refactor scsi_add_lun() to use
 scsi_update_inquiry_data()
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, Krishna Kant <krishna.kant@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
 <20260530002019.47109-4-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260530002019.47109-4-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,purestorage.com:email,suse.de:email,suse.de:mid]

On 5/30/26 02:20, Brian Bunker wrote:
> Refactor scsi_add_lun() to use the new scsi_update_inquiry_data()
> function instead of inline INQUIRY parsing code. This consolidates
> INQUIRY data handling in one place and ensures consistent behavior
> between initial device setup and device rescan operations.
> 
> The following fields are now set by scsi_update_inquiry_data():
> - inquiry buffer, vendor, model, rev pointers
> - type, removable, lockable
> - inq_periph_qual
> - soft_reset, ppr, wdtr, sdtr
> - tagged_supported, simple_tags
> - is_ata, allow_restart
> 
> Also update scsi_probe_lun() to compute scsi_level into a local
> variable rather than writing directly to sdev->scsi_level.
> scsi_update_inquiry_data() is now the authoritative setter of
> sdev->scsi_level under inquiry_mutex; scsi_probe_lun() needs the
> level early for lun_in_cdb and sdev_target->scsi_level before
> scsi_update_inquiry_data() is called.
> 
> scsi_add_lun() is only ever called for freshly allocated sdev instances
> where sdev->inquiry is NULL, so the redundant !sdev->inquiry guard is
> dropped along with the now-unreachable sanity check that followed it.
> 
> This patch maintains identical behavior to the previous code.
> scsi_add_lun() continues to handle the remaining BLIST flags and
> device-specific setup that doesn't come directly from INQUIRY data.
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 123 ++++++++-------------------------------
>   1 file changed, 25 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7e60e3a4bca6..62409217ff23 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -650,6 +650,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
>   	int response_len = 0;
>   	int pass, count, result, resid;
> +	char scsi_level;
>   	struct scsi_failure failure_defs[] = {
>   		/*
>   		 * not-ready to ready transition [asc/ascq=0x28/0x0] or
> @@ -839,23 +840,26 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	 */
>   
>   	/*
> -	 * The scanning code needs to know the scsi_level, even if no
> -	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
> -	 * non-zero LUNs can be scanned.
> +	 * The scanning code needs to know the scsi_level before
> +	 * scsi_update_inquiry_data() is called, both to set the target
> +	 * scsi_level and to determine lun_in_cdb. Use a local variable
> +	 * here; sdev->scsi_level is set later under inquiry_mutex in
> +	 * scsi_update_inquiry_data() to avoid races with concurrent sysfs
> +	 * readers.
>   	 */
> -	sdev->scsi_level = inq_result[2] & 0x0f;
> -	if (sdev->scsi_level >= 2 ||
> -	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
> -		sdev->scsi_level++;
> -	sdev->sdev_target->scsi_level = sdev->scsi_level;
> +	scsi_level = inq_result[2] & 0x0f;
> +	if (scsi_level >= 2 ||
> +	    (scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
> +		scsi_level++;
> +	sdev->sdev_target->scsi_level = scsi_level;
>   
>   	/*
>   	 * If SCSI-2 or lower, and if the transport requires it,
>   	 * store the LUN value in CDB[1].
>   	 */
>   	sdev->lun_in_cdb = 0;
> -	if (sdev->scsi_level <= SCSI_2 &&
> -	    sdev->scsi_level != SCSI_UNKNOWN &&
> +	if (scsi_level <= SCSI_2 &&
> +	    scsi_level != SCSI_UNKNOWN &&
>   	    !sdev->host->no_scsi2_lun_in_cdb)
>   		sdev->lun_in_cdb = 1;
>   
> @@ -884,17 +888,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	struct queue_limits lim;
>   	int ret;
>   
> -	/*
> -	 * XXX do not save the inquiry, since it can change underneath us,
> -	 * save just vendor/model/rev.
> -	 *
> -	 * Rather than save it and have an ioctl that retrieves the saved
> -	 * value, have an ioctl that executes the same INQUIRY code used
> -	 * in scsi_probe_lun, let user level programs doing INQUIRY
> -	 * scanning run at their own risk, or supply a user level program
> -	 * that can correctly scan.
> -	 */
> -
>   	/*
>   	 * Copy at least 36 bytes of INQUIRY data, so that we don't
>   	 * dereference unallocated memory when accessing the Vendor,
> @@ -903,54 +896,22 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
> +	sdev->sdev_bflags = *bflags;
> +
> +	if (scsi_update_inquiry_data(sdev, inq_result, sdev->inquiry_len) < 0)
>   		return SCSI_SCAN_NO_RESPONSE;
>   
You are missing the 'max_t()' thingie, so there's a chance we might 
underflow the inquiry data.

> -	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
> -	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
>   	/*
> -	 * memcpy() instead of strscpy() because strscpy() would read past
> -	 * the end of sdev->inquiry if its length is exactly 36 bytes.
> +	 * scsi_update_inquiry_data() has already set type, removable, lockable,
> +	 * inq_periph_qual, scsi_level, inquiry_len, soft_reset, ppr, wdtr, sdtr,
> +	 * tagged_supported, simple_tags, is_ata, and allow_restart from INQUIRY
> +	 * data. Handle special cases that need the raw inq_result or additional
> +	 * logic.
>   	 */
> -	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
> -	       INQUIRY_REVISION_LEN);
> -	sdev->rev[INQUIRY_REVISION_LEN] = '\0';
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
> -
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
>   
>   	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
>   		/* RBC and MMC devices can return SCSI-3 compliance and yet
> @@ -961,46 +922,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

But otherwise looks good.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
