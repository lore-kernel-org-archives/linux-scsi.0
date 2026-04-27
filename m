Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A7330E0F2
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290793; cv=none; b=XuaGnEYm4tTtFvcF2c/aIwlWnUZ9ij5ePmvGu4e6wkXZKyiV1QBcXGzImkiurTk8HOSO5CHb6nFa4RgCqo82P/VXaC9SAXahThuffhYgoay/STAZ+0SwyhdMk0MtyHl2Nv01NjErYF1UWtGdJS5bizmKu4hZAeZxIgZzaeCVbZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290793; c=relaxed/simple;
	bh=ScNGFZhKzbxPe9SQr468eN8NcONUVzyLAtaDAVFlpls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=obaF7pWbxukNw20FukSHq1rfPbzTEhXcbAeH6HRVziNVNZZCBdKd/vwyRitLevimV1U9vc9aRpAShJ+/KcJqhzbU65LReuubQDFW3ceJ8BiOofcTyI8QlyLLguBlwUoGDs4x6gfphdUj+H0q7SefbK85EDBHOQgEIYXGIC0DaAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ub0mCXDM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JV0R4ncL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nwn2uSaM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RsMsE7Gw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ub0mCXDM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JV0R4ncL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nwn2uSaM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RsMsE7Gw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 141006A902;
	Mon, 27 Apr 2026 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJ0zmdQVFh5ysw0l1XD+Z5F9O29OXzLAU5pcnX+cgvg=;
	b=ub0mCXDMKfofFMDZMOAlBHX0NpexYl//aJPzWsoPoAYdp5+Fp5HeBbIILJF8VkWVUFzLtJ
	Xx3NT9m9RPhAMbZDeulunl2aTTMY+OIGtsJ6DXUUjZIPMLpEtWyioXiDupySnSgefow+ol
	tSOZSg4TRaeQU44WgBfJbW35gIlGpcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJ0zmdQVFh5ysw0l1XD+Z5F9O29OXzLAU5pcnX+cgvg=;
	b=JV0R4ncLGogWC3Hr0ewlUDOxHRjEv9oyWv66lttRV59fqgp4x7S/XNCw1+KdzEpfllf2HW
	57AmuSmONVR1pKDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nwn2uSaM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RsMsE7Gw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777290789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJ0zmdQVFh5ysw0l1XD+Z5F9O29OXzLAU5pcnX+cgvg=;
	b=nwn2uSaMB6gIYFXtVPtx+J0ySzo2z4T6tcoa5WSsJkvm49VyqrV+8coxNOIfmcCYtPBqtM
	m7FNDZGKLV9GjgBZaMnmdXbyLiHD8LRYBbRQYOi68ZxLD+p9VhGUhX3Tnd3hLmH+ckcJJA
	nZdagf+IIAX64X6OS+GMLQmXlWlK4vg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777290789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJ0zmdQVFh5ysw0l1XD+Z5F9O29OXzLAU5pcnX+cgvg=;
	b=RsMsE7GwGTfjju6lAox/Jl8wmCa7SqhrXOvINnpRGQ9ojmL4ogp9fc60dun7AIV4pFXYxg
	6d4q2sNk/rywJADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAA30593B0;
	Mon, 27 Apr 2026 11:53:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uODuMyRO72mRcwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 27 Apr 2026 11:53:08 +0000
Message-ID: <cf3f9e41-7549-4da7-b72c-97d5101c2cfa@suse.de>
Date: Mon, 27 Apr 2026 13:53:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] ata: libata-scsi: route non-zero LUN commands for
 multi-LUN ATAPI
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260426190920.2051289-4-philpem@philpem.me.uk>
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 141006A902
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/26/26 21:09, Phil Pemberton wrote:
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
>     both the Panasonic PD/CD combos and Nakamichi CD changers.  LUNs
>     beyond 7 cannot be encoded in the 3-bit CDB field; reject them
>     with AC_ERR_INVALID.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 317883bac25f..48c7d323d6f9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2951,6 +2951,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>   	memset(qc->cdb, 0, dev->cdb_len);
>   	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>   
> +	/* SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field) */
> +	if (scmd->device->lun >= 8)

This should be 'max_luns' of the associated scsi device, and the driver
should set the appropriate max_luns value for this specific device
(via blacklist flags etc).

Cheers,

Hannes

-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
