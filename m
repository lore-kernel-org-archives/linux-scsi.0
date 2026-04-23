Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7253B3E1D1D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 11:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776942494; cv=none; b=fMDyTmQz9mwQeK4sq6NUBAWmtapWl6Z115SaNb+qgbz90bim1zjwv8tP8QHa/eAdvFzrvWDUlgAzOc8jiieM24auoZjz8wAaDB7M8YvvLYeu5aBksr5OIsf2NUpbT+1s+bSB22rTyqfcGSGLBn65rFD36gH7vSTcDH9vT3JKXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776942494; c=relaxed/simple;
	bh=7Nd/85205MU33y4gQaBoHPc4+R8wM1YP1F+r6MlOl1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozx4Hyil2rSKjuTIZ5ROojfHxgM7ZDe1SK3oF6Jm54QPRlru+L9CUlYpylbnGaUrW9EZasyBIG3CEUXFGpjB6aFemCP6AJ5dO2JXQ2sDL+daGRZfh3ruGdZoVPAxpIoohQDdjXKUkFclYp+T7z4Q3eDvzdw/GNrVWcK657FcVGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ygal4x+A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7uCZd9oW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v3+p71bI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xg2y6jQv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ygal4x+A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7uCZd9oW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v3+p71bI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xg2y6jQv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 548796A86B;
	Thu, 23 Apr 2026 11:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9gwWuVYIlpv2rl9h9WV9Y5Q1bjYDdxoyAocOuxAhD0=;
	b=ygal4x+ADTtH3+9G7DTQFzrdG2ZVu11hQT8Lk2BRT6kR+gJNbzSdsIEnm20HfY7bBKPRmZ
	kyxzz8v44NCvvYjdaoBTEJOdpDjuXA0hUwqcALeWgghQm7SuO0Qm1yu7Tb1IhWtdLNUKCt
	AOwssXXbaF9/gICMKt1dOXoWHsyqvao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942491;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9gwWuVYIlpv2rl9h9WV9Y5Q1bjYDdxoyAocOuxAhD0=;
	b=7uCZd9oW23RvFY6Z5T1mrfyh8JhdTmIW7tUb4Y9fHKfYog71T1W8sfv68BKIvahgwf4eAs
	HhXEy/Zb5lAKjcAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v3+p71bI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xg2y6jQv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776942488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9gwWuVYIlpv2rl9h9WV9Y5Q1bjYDdxoyAocOuxAhD0=;
	b=v3+p71bIfrRQ8q7hZIkUfYuxasjTCqnrJzyrCfuntHwev7dKGKHICfj2+tMA4aGsyctuc7
	83/sLJ+ySvyg+xacypSAOemhKTtD8fYvDEWZRNIW7WAwWGXOsMg1bETuavh+CLrf/kBEg7
	4+tl71mrZ40+3wxDMPgLLgRwwy+WZC0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776942488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9gwWuVYIlpv2rl9h9WV9Y5Q1bjYDdxoyAocOuxAhD0=;
	b=Xg2y6jQv5aQg5kNZBx6xy9SbrILFxJN/5fqVsJubNc82XjgNu1jzKWQYUD2QOR9w9a19FJ
	iXMP2Ti77AddOEDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D526593B1;
	Thu, 23 Apr 2026 11:08:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bk+NDpj96WlJGgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 11:08:08 +0000
Message-ID: <a32d15ae-2303-427c-9d06-d7d1df235ed0@suse.de>
Date: Thu, 23 Apr 2026 13:08:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] ata: libata-scsi: route non-zero LUN commands for
 multi-LUN ATAPI
To: Phil Pemberton <philpem@philpem.me.uk>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
 <20260420122321.4161027-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260420122321.4161027-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 548796A86B
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/20/26 14:23, Phil Pemberton wrote:
> Two changes are required to route commands to ATAPI LUNs other than 0:
> 
> 1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
>     with a non-zero LUN, returning NULL and dropping the command on
>     the floor.  Relax both the PMP and non-PMP branches to allow
>     non-zero LUNs through when the underlying ata_device is ATAPI
>     class, since ATAPI devices can legitimately expose multiple LUNs.
> 
> 2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
>     CDB byte 1 bits 7:5 rather than relying on transport-level LUN
>     addressing.  Encode scmd->device->lun into those bits, preserving
>     the existing command-specific bits in 4:0.  This is required by
>     both the Panasonic PD/CD combos and Nakamichi CD changers.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 317883bac25f..4e88ae7d94c3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2951,6 +2951,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>   	memset(qc->cdb, 0, dev->cdb_len);
>   	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>   
> +	/* SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 */
> +	if (scmd->device->lun < 8)
> +		qc->cdb[1] = (qc->cdb[1] & 0x1f) |
> +			      ((u8)scmd->device->lun << 5);
> +

Hmm. And what happens when scmd->device->lun is _greater_ than 7?
We surely should abort that command, shouldn't we?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
