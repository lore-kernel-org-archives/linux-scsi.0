Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E903E2760
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935445; cv=none; b=DZ7NqVDJxtEQ1VJ4TGqfykPscRcJm7CjM+rw6Ajv9/FarEib8GaqPPJKWtpuVej8XadEg1WSrgtih1XUnPenyZ0aCMD1yVxm08zeaoOYMKkNrhMJvR4Jow8WJqqck1T/FttEVLjxQWFHt08UvMNmpsrXZhauqnHCqTW4ib7qnXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935445; c=relaxed/simple;
	bh=ahwfZGyzKe4aZ7jWE4Xry58wLQlyG/3rKDnag05KjFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P+H2tD+mMVrjZHbK0jbghCW8ivNBYXT09yBjiGoKzzrKtesecS1izSJyPHaH1yVRf9/G4wujXTHT+SX/+xde89jEILj+RpPvPcIxzY+7QimDXZ9F/csrm5cf6tySQR0styuSx+ANz+CRQVwkypdanAmYHhjnH2SLrv0qsPLnPME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bodarBv9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qe7HnLlX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bodarBv9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qe7HnLlX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bodarBv9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qe7HnLlX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bodarBv9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qe7HnLlX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6A8A1777DE;
	Mon, 13 Jul 2026 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnZbJI5NkvVyFwoAUVo+Zpin977ncEk0u4b77YYomEk=;
	b=bodarBv9Qww/IgPWYnLOY0zLZekWVQNbCtV2w2n1MVzdyiOHcpdnD6TE61hXMOz0oRMChM
	q2Qitor1hJeUo5u7laITl/X2qwlEeVwNmBZabIzETUCQwElw7lLp8KnziJypHN+Jy+W05/
	n6ewIkysAaMwefvOyNWCugJ+VlH6MX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnZbJI5NkvVyFwoAUVo+Zpin977ncEk0u4b77YYomEk=;
	b=Qe7HnLlXQv8f9LvUYlUfZmcTDrMtgVjMSo+bUNYdaaAiSdmZl7xb/E7PvKE19IQNhVpZNP
	HrkXBN/oDiAm4sDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bodarBv9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qe7HnLlX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnZbJI5NkvVyFwoAUVo+Zpin977ncEk0u4b77YYomEk=;
	b=bodarBv9Qww/IgPWYnLOY0zLZekWVQNbCtV2w2n1MVzdyiOHcpdnD6TE61hXMOz0oRMChM
	q2Qitor1hJeUo5u7laITl/X2qwlEeVwNmBZabIzETUCQwElw7lLp8KnziJypHN+Jy+W05/
	n6ewIkysAaMwefvOyNWCugJ+VlH6MX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnZbJI5NkvVyFwoAUVo+Zpin977ncEk0u4b77YYomEk=;
	b=Qe7HnLlXQv8f9LvUYlUfZmcTDrMtgVjMSo+bUNYdaaAiSdmZl7xb/E7PvKE19IQNhVpZNP
	HrkXBN/oDiAm4sDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A345779AE;
	Mon, 13 Jul 2026 09:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CiCbFcmxVGphAQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jul 2026 09:37:13 +0000
Message-ID: <97a39c16-48f3-4ef2-a396-bff1b7f256e6@suse.de>
Date: Mon, 13 Jul 2026 11:37:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/9] ata: libata-core: detect support for depopulation
 capabilities
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-6-dlemoal@kernel.org>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6A8A1777DE
X-Spam-Score: -4.51

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> Introduce the device flags ATA_DFLAG_DEPOP to indicate support by a device
> for the basic commands of the storage element depopulation feature set,
> that is, the GET PHYSICAL ELEMENT STATUS and REMOVE ELEMENT AND TRUNCATE
> commands. The device flag ATA_DFLAG_DEPOP_RESTORE flag is introduced to
> indicate support for the RESTORE ELEMENTS AND REBUILD command. Both flags
> are obtained from the command support bits of the qword at bytes 152 to
> 159 of the supported capabilities log page.
> 
> For ZAC devices, the device flag ATA_DFLAG_DEPOP_MODIFY is introduced to
> indicate support for the REMOVE ELEMENT AND MODIFY ZONES command. This
> support is indicated by the REMOVE ELEMENT AND MODIFY ZONES SUPPORTED bit
> in the qword at byte 8 to 15 of the zoned device information log page.
> 
> The function ata_dev_config_depop() is introduced to set these flags
> based on the content of the supported capabilities log and zoned device
> information log. As per the ACS specifications, NCQ autosense support is
> also mandatory if these flags are set.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 73 +++++++++++++++++++++++++++++++++++++--
>   include/linux/libata.h    | 45 +++++++++++++-----------
>   2 files changed, 96 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 5121faf9738e..d893c916df0b 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2705,6 +2705,71 @@ static void ata_dev_config_cdl(struct ata_device *dev)
>   	ata_dev_cleanup_cdl_resources(dev);
>   }
>   
> +static void ata_dev_config_depop(struct ata_device *dev)
> +{
> +	unsigned int err_mask;
> +	u64 val;
> +
> +	/* Ignore old drives. */
> +	if (ata_id_major_version(dev->id) < 11)
> +		goto not_supported;
> +
> +	/* NCQ Autosense is required. */
> +	if (!ata_identify_page_supported(dev, ATA_LOG_SUPPORTED_CAPABILITIES) ||
> +	    !ata_id_has_ncq_autosense(dev->id))
> +		goto not_supported;
> +
> +	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
> +				     ATA_LOG_SUPPORTED_CAPABILITIES,
> +				     dev->sector_buf, 1);
> +	if (err_mask)
> +		goto not_supported;
> +
> +	/* Check depopulation capabilities bits. */
> +	val = get_unaligned_le64(&dev->sector_buf[152]);
> +	if (!(val & BIT_ULL(63)))
> +		goto not_supported;
> +
> +	/*
> +	 * Support for at least the GET PHYSICAL ELEMENT STATUS and
> +	 * REMOVE ELEMENT AND TRUNCATE commands is mandated.
> +	 */
> +	if (!(val & BIT_ULL(0)) || !(val & BIT_ULL(1)))
> +		goto not_supported;
> +
> +	dev->flags |= ATA_DFLAG_DEPOP;
> +
> +	/* Check if RESTORE ELEMENTS AND REBUILD is supported. */
> +	if (val & BIT_ULL(2))
> +		dev->flags |= ATA_DFLAG_DEPOP_RESTORE;
> +
> +	/*
> +	 * For ZAC devices, check if REMOVE ELEMENT AND MODIFY ZONES is
> +	 * supported.
> +	 */
> +	if (dev->class != ATA_DEV_ZAC)
> +		return;
> +
> +	err_mask = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE,
> +				     ATA_LOG_ZONED_INFORMATION,
> +				     dev->sector_buf, 1);
> +	if (err_mask)
> +		return;
> +
> +	val = get_unaligned_le64(&dev->sector_buf[8]);
> +	if (!(val & BIT_ULL(63)))
> +		return;
> +
> +	if (val & BIT_ULL(1))
> +		dev->flags |= ATA_DFLAG_DEPOP_MODIFY;
> +
> +	return;
> +
> +not_supported:
> +	dev->flags &= ~(ATA_DFLAG_DEPOP | ATA_DFLAG_DEPOP_RESTORE |
> +			ATA_DFLAG_DEPOP_MODIFY);
> +}
> +
>   static int ata_dev_config_lba(struct ata_device *dev)
>   {
>   	const u16 *id = dev->id;
> @@ -2942,7 +3007,7 @@ static void ata_dev_print_features(struct ata_device *dev)
>   		return;
>   
>   	ata_dev_info(dev,
> -		     "Features:%s%s%s%s%s%s%s%s%s%s\n",
> +		     "Features:%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
>   		     dev->flags & ATA_DFLAG_FUA ? " FUA" : "",
>   		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
>   		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
> @@ -2952,7 +3017,10 @@ static void ata_dev_print_features(struct ata_device *dev)
>   		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
>   		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "",
>   		     dev->flags & ATA_DFLAG_CDL ? " CDL" : "",
> -		     dev->cpr_log ? " CPR" : "");
> +		     dev->cpr_log ? " CPR" : "",
> +		     dev->flags & ATA_DFLAG_DEPOP ? " Depop" : "",
> +		     dev->flags & ATA_DFLAG_DEPOP_RESTORE ? " Depop-Restore" : "",
> +		     dev->flags & ATA_DFLAG_DEPOP_MODIFY ? " Depop-Modify" : "");
>   }
>   
>   /**
> @@ -3115,6 +3183,7 @@ int ata_dev_configure(struct ata_device *dev)
>   		ata_dev_config_trusted(dev);
>   		ata_dev_config_cpr(dev);
>   		ata_dev_config_cdl(dev);
> +		ata_dev_config_depop(dev);
>   		dev->cdb_len = 32;
>   
>   		if (print_info)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 736ba8a6a77b..3703ef433bd4 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -139,30 +139,35 @@ enum {
>   	ATA_DFLAG_NCQ_SEND_RECV = (1UL << 11), /* device supports NCQ SEND and RECV */
>   	ATA_DFLAG_NCQ_PRIO	= (1UL << 12), /* device supports NCQ priority */
>   	ATA_DFLAG_CDL		= (1UL << 13), /* supports cmd duration limits */
> -	ATA_DFLAG_CFG_MASK	= (1UL << 14) - 1,
> -
> -	ATA_DFLAG_PIO		= (1UL << 14), /* device limited to PIO mode */
> -	ATA_DFLAG_NCQ_OFF	= (1UL << 15), /* device limited to non-NCQ mode */
> -	ATA_DFLAG_SLEEPING	= (1UL << 16), /* device is sleeping */
> -	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 17), /* data transfer not verified */
> -	ATA_DFLAG_NO_UNLOAD	= (1UL << 18), /* device doesn't support unload */
> -	ATA_DFLAG_UNLOCK_HPA	= (1UL << 19), /* unlock HPA */
> -	ATA_DFLAG_INIT_MASK	= (1UL << 20) - 1,
> -
> -	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 20), /* Priority cmds sent to dev */
> -	ATA_DFLAG_CDL_ENABLED	= (1UL << 21), /* cmd duration limits is enabled */
> -	ATA_DFLAG_RESUMING	= (1UL << 22),  /* Device is resuming */
> -	ATA_DFLAG_DETACH	= (1UL << 24),
> -	ATA_DFLAG_DETACHED	= (1UL << 25),
> -	ATA_DFLAG_DA		= (1UL << 26), /* device supports Device Attention */
> -	ATA_DFLAG_DEVSLP	= (1UL << 27), /* device supports Device Sleep */
> -	ATA_DFLAG_ACPI_DISABLED = (1UL << 28), /* ACPI for the device is disabled */
> -	ATA_DFLAG_D_SENSE	= (1UL << 29), /* Descriptor sense requested */
> +	ATA_DFLAG_DEPOP		= (1UL << 14), /* supports depopulation capability */
> +	ATA_DFLAG_DEPOP_RESTORE	= (1UL << 15), /* supports depopulation restoration */
> +	ATA_DFLAG_DEPOP_MODIFY	= (1UL << 16), /* supports zoned depopulation */
> +	ATA_DFLAG_CFG_MASK	= (1UL << 17) - 1,
> +
> +	ATA_DFLAG_PIO		= (1UL << 17), /* device limited to PIO mode */
> +	ATA_DFLAG_NCQ_OFF	= (1UL << 18), /* device limited to non-NCQ mode */
> +	ATA_DFLAG_SLEEPING	= (1UL << 19), /* device is sleeping */
> +	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 20), /* data transfer not verified */
> +	ATA_DFLAG_NO_UNLOAD	= (1UL << 21), /* device doesn't support unload */
> +	ATA_DFLAG_UNLOCK_HPA	= (1UL << 22), /* unlock HPA */
> +	ATA_DFLAG_INIT_MASK	= (1UL << 23) - 1,
> +
> +	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 23), /* Priority cmds sent to dev */
> +	ATA_DFLAG_CDL_ENABLED	= (1UL << 24), /* cmd duration limits is enabled */
> +	ATA_DFLAG_RESUMING	= (1UL << 25),  /* Device is resuming */
> +	ATA_DFLAG_DETACH	= (1UL << 26),
> +	ATA_DFLAG_DETACHED	= (1UL << 27),
> +	ATA_DFLAG_DA		= (1UL << 28), /* device supports Device Attention */
> +	ATA_DFLAG_DEVSLP	= (1UL << 29), /* device supports Device Sleep */
> +	ATA_DFLAG_ACPI_DISABLED = (1UL << 30), /* ACPI for the device is disabled */
> +	ATA_DFLAG_D_SENSE	= (1UL << 31), /* Descriptor sense requested */
>   
>   	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
>   				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
>   				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
> -				   ATA_DFLAG_CDL)
> +				   ATA_DFLAG_CDL | ATA_DFLAG_DEPOP | \
> +				   ATA_DFLAG_DEPOP_RESTORE |
> +				   ATA_DFLAG_DEPOP_MODIFY)
>   };
>   
>   enum {

It's a bit of a mess, but not your fault...

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
