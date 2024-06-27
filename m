Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203D422EE4;
	Thu, 27 Jun 2024 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470231; cv=none; b=XoJZNjUi/dAComtnf/YhbVUrIFHlUIL+CkrbBjAmtWCy90++TEjUz+Wq2Ablffb0SoBRDQVqKUv50dc+6awUJfCScXactjiYPk4WLRZ7cPiNl6XhNo0vt50F/vLUkxvjcoDxNEn2mtziBtSSw++Nf0evGnYbbtrCxQUl6JkqC5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470231; c=relaxed/simple;
	bh=5PFMoJyUm4AdSht0UV3yJR01uZe0P/5ybY08Lc3saeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4hrRqPXdev+rSeaI/zyP+nigAXqy/x3b8iygeQLPGRSV5X8i2YZykuojCVAh9sAgZLNH1LH4djNZCQmSZCRxTIXurm7cBUrh7pYPTW8cB4wCHFUspxnqrP7K64PJ2HS6UVEXIDECTylDrRy/LrhJTL29Fk9ZxjeHk1Fkn47/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dyIWPm9c; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FGLijG/M; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dyIWPm9c; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FGLijG/M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dyIWPm9c";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FGLijG/M";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dyIWPm9c";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FGLijG/M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3FC041FBA6;
	Thu, 27 Jun 2024 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KjQF6Mazgqnj06fEqnLIzziPW4vafASKoHbNdLiEBY=;
	b=dyIWPm9c4mkKfpc3HVKXBkCQsepIOomcHRo/oU0Qq+w36doRNlc6kbGaf1F+hSfQLBI/Bh
	IZEh6RzCYgAMTA89BHdD5KijQgbZ9O1Hx9TnEiuWrn4t3x0vJ5F/4XMS8zrWHE4lc5z+f3
	P0aIuaLl4XJUsBWTn8oOaP1qIDAlnFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KjQF6Mazgqnj06fEqnLIzziPW4vafASKoHbNdLiEBY=;
	b=FGLijG/MoJX9gmaCfhxHb4V3AMWuTjDfr6fi57/2yEQFQs2AInOuUexCzwmfxYZTRZvm77
	D0Nf7csVNlbM22BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dyIWPm9c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FGLijG/M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KjQF6Mazgqnj06fEqnLIzziPW4vafASKoHbNdLiEBY=;
	b=dyIWPm9c4mkKfpc3HVKXBkCQsepIOomcHRo/oU0Qq+w36doRNlc6kbGaf1F+hSfQLBI/Bh
	IZEh6RzCYgAMTA89BHdD5KijQgbZ9O1Hx9TnEiuWrn4t3x0vJ5F/4XMS8zrWHE4lc5z+f3
	P0aIuaLl4XJUsBWTn8oOaP1qIDAlnFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KjQF6Mazgqnj06fEqnLIzziPW4vafASKoHbNdLiEBY=;
	b=FGLijG/MoJX9gmaCfhxHb4V3AMWuTjDfr6fi57/2yEQFQs2AInOuUexCzwmfxYZTRZvm77
	D0Nf7csVNlbM22BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81BFD137DF;
	Thu, 27 Jun 2024 06:37:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gH/ZHJMIfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:37:07 +0000
Message-ID: <96aa5136-6f16-4793-a7f3-3c2e9f3c0b13@suse.de>
Date: Thu, 27 Jun 2024 08:37:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] ata: libata-sata: Remove superfluous assignment
 in ata_sas_port_alloc()
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-23-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-23-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FC041FBA6
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/26/24 20:00, Niklas Cassel wrote:
> ata_sas_port_alloc() calls ata_port_alloc() which already assigns ap->lock
> so there is no need to ata_sas_port_alloc() to assign it again.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-sata.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index e7991595bfe5..1a36a5d1d7bc 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1228,7 +1228,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>   		return NULL;
>   
>   	ap->port_no = 0;
> -	ap->lock = &host->lock;
>   	ap->pio_mask = port_info->pio_mask;
>   	ap->mwdma_mask = port_info->mwdma_mask;
>   	ap->udma_mask = port_info->udma_mask;

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

