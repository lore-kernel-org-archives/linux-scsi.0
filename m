Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8FC2AD3C
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935165; cv=none; b=ofQGgup1ydotGqnoArV7JQ6zK2LmrfXFRkueT8R34EzYswzUbtEJjpd5S6fggnO3aCSOf2+RquEGL5wxkKincIXyYM/MRO3t5p1gKqi0LLbNW1nOl4Q8U2u7SzxDIYQoVRGXnQgOb+2Fki/OB9C7IKJtAmCxgfkex81fklheWnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935165; c=relaxed/simple;
	bh=tOHavUFYNa1aLCIsw+Pjfp/5UUmeBBpfGC9mTKFApfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VVBn6GUXbB1qu8zp/ZjS9K7ZVdPPVZytWGVNCvfR8njskITwJRXI0/PWUnjyzt7dR+pac/K+pBNHTpXvW1gazLRjVGlGBUjuJSdRyPUm2FaXrayEQiVbor6Z8Bdu50tVPsXEuDN7SfzdTCx5HH8Ce29dvbFecD3L4m4DoP5frTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JrExoPXU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CyHfxU32; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JrExoPXU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CyHfxU32; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JrExoPXU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CyHfxU32";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JrExoPXU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CyHfxU32"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A60675974;
	Mon, 13 Jul 2026 09:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AG0FG5lpOC0KCoi4VPR7OPzRBHQ2mU25NhpYzHMNc30=;
	b=JrExoPXUQy5ACRC0MO/3jzDHAaf+UrEjeMuqZdiTH3Vkwm8riECMYXQMjXkWpyZ3I7aM2K
	CI8tZc0vwviRsYZmSHo0i5OcrFIqLPXpfWQFNob8s+usGmoKGBIochO6LDqHF07DeHcbWo
	yuzBBylI/190zCHIlVKnUheXUr8R+WI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AG0FG5lpOC0KCoi4VPR7OPzRBHQ2mU25NhpYzHMNc30=;
	b=CyHfxU329hXXcSiobAbZjuvsz4w6prgFfzhUPU9D5A0uUL7s1evrS+tKjU1yKHDBcKxTbZ
	bdjVzAZqBxcY6FBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JrExoPXU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CyHfxU32
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AG0FG5lpOC0KCoi4VPR7OPzRBHQ2mU25NhpYzHMNc30=;
	b=JrExoPXUQy5ACRC0MO/3jzDHAaf+UrEjeMuqZdiTH3Vkwm8riECMYXQMjXkWpyZ3I7aM2K
	CI8tZc0vwviRsYZmSHo0i5OcrFIqLPXpfWQFNob8s+usGmoKGBIochO6LDqHF07DeHcbWo
	yuzBBylI/190zCHIlVKnUheXUr8R+WI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AG0FG5lpOC0KCoi4VPR7OPzRBHQ2mU25NhpYzHMNc30=;
	b=CyHfxU329hXXcSiobAbZjuvsz4w6prgFfzhUPU9D5A0uUL7s1evrS+tKjU1yKHDBcKxTbZ
	bdjVzAZqBxcY6FBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55029779AE;
	Mon, 13 Jul 2026 09:32:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y27GE7qwVGoIewAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jul 2026 09:32:42 +0000
Message-ID: <bf8f0730-5669-4a57-a97d-f657cc9a5363@suse.de>
Date: Mon, 13 Jul 2026 11:32:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/9] ata: libata: improve the definition of device
 flags
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6A60675974
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> The flags field of struct ata_device has the unsigned long type. Define
> all the ATA_DFLAG_XXX flags using a 1UL bit shift to match this type, thus
> avoiding flags to become signed values (e.g. for bit 31 flag).
> 
> To avoid all other values defined in the same enum as the ATA_DFLAG_XXX
> flags to implicitly also become unsigned long values, move the device
> flags definition to a separate enum.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/linux/libata.h | 85 ++++++++++++++++++++++--------------------
>   1 file changed, 45 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 96e626d6a7ca..736ba8a6a77b 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -121,6 +121,50 @@ enum {
>   	ATA_QUIRK_NO_FUA		= BIT_ULL(__ATA_QUIRK_NO_FUA),
>   };
>   
> +/*
> + * struct ata_device flags
> + */
> +enum {
> +	ATA_DFLAG_LBA		= (1UL << 0), /* device supports LBA */
> +	ATA_DFLAG_LBA48		= (1UL << 1), /* device supports LBA48 */
> +	ATA_DFLAG_CDB_INTR	= (1UL << 2), /* device asserts INTRQ when ready for CDB */
> +	ATA_DFLAG_NCQ		= (1UL << 3), /* device supports NCQ */
> +	ATA_DFLAG_FLUSH_EXT	= (1UL << 4), /* do FLUSH_EXT instead of FLUSH */
> +	ATA_DFLAG_ACPI_PENDING	= (1UL << 5), /* ACPI resume action pending */
> +	ATA_DFLAG_ACPI_FAILED	= (1UL << 6), /* ACPI on devcfg has failed */
> +	ATA_DFLAG_AN		= (1UL << 7), /* AN configured */
> +	ATA_DFLAG_TRUSTED	= (1UL << 8), /* device supports trusted send/recv */
> +	ATA_DFLAG_FUA		= (1UL << 9), /* device supports FUA */
> +	ATA_DFLAG_DMADIR	= (1UL << 10), /* device requires DMADIR */
> +	ATA_DFLAG_NCQ_SEND_RECV = (1UL << 11), /* device supports NCQ SEND and RECV */
> +	ATA_DFLAG_NCQ_PRIO	= (1UL << 12), /* device supports NCQ priority */
> +	ATA_DFLAG_CDL		= (1UL << 13), /* supports cmd duration limits */
> +	ATA_DFLAG_CFG_MASK	= (1UL << 14) - 1,
> +
> +	ATA_DFLAG_PIO		= (1UL << 14), /* device limited to PIO mode */
> +	ATA_DFLAG_NCQ_OFF	= (1UL << 15), /* device limited to non-NCQ mode */
> +	ATA_DFLAG_SLEEPING	= (1UL << 16), /* device is sleeping */
> +	ATA_DFLAG_DUBIOUS_XFER	= (1UL << 17), /* data transfer not verified */
> +	ATA_DFLAG_NO_UNLOAD	= (1UL << 18), /* device doesn't support unload */
> +	ATA_DFLAG_UNLOCK_HPA	= (1UL << 19), /* unlock HPA */
> +	ATA_DFLAG_INIT_MASK	= (1UL << 20) - 1,
> +
> +	ATA_DFLAG_NCQ_PRIO_ENABLED = (1UL << 20), /* Priority cmds sent to dev */
> +	ATA_DFLAG_CDL_ENABLED	= (1UL << 21), /* cmd duration limits is enabled */
> +	ATA_DFLAG_RESUMING	= (1UL << 22),  /* Device is resuming */
> +	ATA_DFLAG_DETACH	= (1UL << 24),
> +	ATA_DFLAG_DETACHED	= (1UL << 25),
> +	ATA_DFLAG_DA		= (1UL << 26), /* device supports Device Attention */
> +	ATA_DFLAG_DEVSLP	= (1UL << 27), /* device supports Device Sleep */
> +	ATA_DFLAG_ACPI_DISABLED = (1UL << 28), /* ACPI for the device is disabled */
> +	ATA_DFLAG_D_SENSE	= (1UL << 29), /* Descriptor sense requested */
> +

Maybe using the 'BIT()' macro here?

> +	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
> +				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
> +				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
> +				   ATA_DFLAG_CDL)
> +};
> +
>   enum {
>   	/* various global constants */
>   	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
> @@ -146,46 +190,7 @@ enum {
>   	ATA_TFLAG_FUA		= (1 << 5), /* enable FUA */
>   	ATA_TFLAG_POLLING	= (1 << 6), /* set nIEN to 1 and use polling */
>   
> -	/* struct ata_device stuff */
> -	ATA_DFLAG_LBA		= (1 << 0), /* device supports LBA */
> -	ATA_DFLAG_LBA48		= (1 << 1), /* device supports LBA48 */
> -	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
> -	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
> -	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
> -	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
> -	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
> -	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
> -	ATA_DFLAG_TRUSTED	= (1 << 8), /* device supports trusted send/recv */
> -	ATA_DFLAG_FUA		= (1 << 9), /* device supports FUA */
> -	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
> -	ATA_DFLAG_NCQ_SEND_RECV = (1 << 11), /* device supports NCQ SEND and RECV */
> -	ATA_DFLAG_NCQ_PRIO	= (1 << 12), /* device supports NCQ priority */
> -	ATA_DFLAG_CDL		= (1 << 13), /* supports cmd duration limits */
> -	ATA_DFLAG_CFG_MASK	= (1 << 14) - 1,
> -
> -	ATA_DFLAG_PIO		= (1 << 14), /* device limited to PIO mode */
> -	ATA_DFLAG_NCQ_OFF	= (1 << 15), /* device limited to non-NCQ mode */
> -	ATA_DFLAG_SLEEPING	= (1 << 16), /* device is sleeping */
> -	ATA_DFLAG_DUBIOUS_XFER	= (1 << 17), /* data transfer not verified */
> -	ATA_DFLAG_NO_UNLOAD	= (1 << 18), /* device doesn't support unload */
> -	ATA_DFLAG_UNLOCK_HPA	= (1 << 19), /* unlock HPA */
> -	ATA_DFLAG_INIT_MASK	= (1 << 20) - 1,
> -
> -	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
> -	ATA_DFLAG_CDL_ENABLED	= (1 << 21), /* cmd duration limits is enabled */
> -	ATA_DFLAG_RESUMING	= (1 << 22),  /* Device is resuming */
> -	ATA_DFLAG_DETACH	= (1 << 24),
> -	ATA_DFLAG_DETACHED	= (1 << 25),
> -	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
> -	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
> -	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
> -	ATA_DFLAG_D_SENSE	= (1 << 29), /* Descriptor sense requested */
> -
> -	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
> -				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
> -				   ATA_DFLAG_NCQ_PRIO | ATA_DFLAG_FUA | \
> -				   ATA_DFLAG_CDL),
> -
> +	/* sturct ata_device class. */
>   	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
>   	ATA_DEV_ATA		= 1,	/* ATA device */
>   	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */

Otherwise looks okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
