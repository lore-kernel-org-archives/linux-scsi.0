Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5F48122E
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778677869; cv=none; b=P6h/n7CP5gU+fjTx/Nj5IoBWnNtAMbaaJO/SYdKvdQx8xFGf6G/sOmxycPnHkYMot4aos7HkE8dkrtQxGinRDW0hmTr7Q3iVQakX8oDxoK2vHrTMpCuCrGJDdl8fWbCiPHnilx0jvCrBedvfs8XN/O+v8WUSvpHlKC4Cj+IqHiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778677869; c=relaxed/simple;
	bh=iZuk2cbXdF5yNp0JjwOt/inc5AoiMon7mdNW4wnxhtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KVHY7oIYdlygqbZes3UmL+Hv1y5z399GAYMMuQioFC3OoFO3PUfbWtP+NSluh5ciXLDz7FNvJbhgdd5BySdhLr/9iREHRfI7tc1R+IO35q/tsOmxcKhlJ3rmPeKbf3ktsDExVg3j16Es35gWh1y/56aB14b400hLEAOlvzYmyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IwRL64nJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P6VZlRbe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IwRL64nJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P6VZlRbe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IwRL64nJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P6VZlRbe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IwRL64nJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P6VZlRbe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75B50765FF;
	Wed, 13 May 2026 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778677865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A97pTnzSzL8ECfSKGfcTdH0sUYzTeYqNr7yuxxDxZg=;
	b=IwRL64nJqMV8bQPLp0QCh0zePJoLQOyzxFEUkp4pxCFt6EgH6ejcEzgo7Pdu0zNb6xg0dj
	sVVhx2C7YTMNWRHePU8LqIOh2ukBKe7J6vGwG8d8kmMq1qlBOUoD5uA4zW69tiQH3H4Ij/
	d56BB5CW+zxZECBf5055NgMrBcwkHCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778677865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A97pTnzSzL8ECfSKGfcTdH0sUYzTeYqNr7yuxxDxZg=;
	b=P6VZlRbewCIwXI+jA6mum+KknGp/cBod3/lgZmbW4VnHU/9Q+eECyc6XyvBabqshENuuav
	6+rOxDD/L9W51LCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwRL64nJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P6VZlRbe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778677865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A97pTnzSzL8ECfSKGfcTdH0sUYzTeYqNr7yuxxDxZg=;
	b=IwRL64nJqMV8bQPLp0QCh0zePJoLQOyzxFEUkp4pxCFt6EgH6ejcEzgo7Pdu0zNb6xg0dj
	sVVhx2C7YTMNWRHePU8LqIOh2ukBKe7J6vGwG8d8kmMq1qlBOUoD5uA4zW69tiQH3H4Ij/
	d56BB5CW+zxZECBf5055NgMrBcwkHCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778677865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A97pTnzSzL8ECfSKGfcTdH0sUYzTeYqNr7yuxxDxZg=;
	b=P6VZlRbewCIwXI+jA6mum+KknGp/cBod3/lgZmbW4VnHU/9Q+eECyc6XyvBabqshENuuav
	6+rOxDD/L9W51LCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E453593A9;
	Wed, 13 May 2026 13:11:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sBlUFml4BGpMTAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 13 May 2026 13:11:05 +0000
Message-ID: <b79bb2d1-2968-45cf-8db2-976fb499743b@suse.de>
Date: Wed, 13 May 2026 15:11:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] ata: libata-scsi: route non-zero LUN commands for
 multi-LUN ATAPI
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-4-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260512202728.299414-4-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid]
X-Rspamd-Queue-Id: 75B50765FF
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/12/26 22:27, Phil Pemberton wrote:
> Two changes are required to route commands to ATAPI LUNs other than 0:
> 
> 1. __ata_scsi_find_dev():  The existing code rejects any scsi_device
>     with a non-zero LUN, returning NULL and dropping the command on
>     the floor.  Hoist a non-zero LUN early-exit ahead of the original
>     channel/id checks: when scsidev->lun is non-zero, allow it through
>     only if the underlying ata_device is ATAPI class.  The original
>     LUN-0 path is left structurally unchanged.
> 
> 2. atapi_xlat():  Older ATAPI devices (SCSI-2 era) expect the LUN in
>     CDB byte 1 bits 7:5 rather than relying on transport-level LUN
>     addressing.  Encode scmd->device->lun into those bits, preserving
>     the existing command-specific bits in 4:0.  This is required by
>     both the Panasonic PD/CD combos and Nakamichi CD changers.
> 
>     The SCSI layer caps the LUN at shost->max_lun, so a value beyond
>     the device's nr_luns should never reach this point; guard with
>     WARN_ON_ONCE() and return AC_ERR_INVALID if it does, since the
>     3-bit CDB field cannot represent it.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/ata/libata-scsi.c | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7c3d31dc49a1..2d714efc855f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2953,6 +2953,15 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
>   	memset(qc->cdb, 0, dev->cdb_len);
>   	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
>   
> +	/*
> +	 * SCSI-2 CDB LUN encoding: bits 7:5 of byte 1 (3-bit field).
> +	 * The SCSI layer caps the LUN at shost->max_lun (<= ATAPI_MAX_LUN),
> +	 * so this should never trip; warn and reject if it does.
> +	 */
> +	if (WARN_ON_ONCE(scmd->device->lun >= dev->nr_luns))
> +		return AC_ERR_INVALID;

cf my comment to the previous patch.
I'd prefer to have 'scmd->device->host->max_lun' as the upper limit.
And we should check the that value does not exceed ATAPI_MAX_LUN.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
