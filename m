Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57F0299943
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935222; cv=none; b=JAwXw5gjZSi9V+tk/V2lzoBtXOYOMmMRufkeBFRaqUes3KIxpb0oHDuoaKwEBsOg1qHAbhU7/MbOi3JsYHrsWPMM9tF9hojR/wTuYL+/fuSMh34KAGfLMW6fXD6Hax603MEfhKw5C/fjSOmmcGe//OdIK/JXckLFBwa2XitGu/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935222; c=relaxed/simple;
	bh=9+wDXMqr25uMOrBK4n1+1iA9zowc1OBUuaJWCtzHgtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sCXUhYl9UtpIBe3l87p04GBr6MjN8fK5RO303aqhqpR9PnezpeuKVEMI9g4BueG+a6EDj6/8Kn5l1dsvs8rpT7+/TsCTJaTkPcCSDnZIfHSYMqs/4vcZZkdVUfInOyoU9aGdVU6aKCEcerlGqB3Hcp6uXDHABTmTZ+ALSveDqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bhkZaTDs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6/WP/goD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bhkZaTDs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6/WP/goD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bhkZaTDs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6/WP/goD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bhkZaTDs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6/WP/goD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 045DD777D3;
	Mon, 13 Jul 2026 09:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qJZYyvpeemiRBkekNlgWjlIChkmzeD8tHk7+9+TZSQ=;
	b=bhkZaTDsl235UNCIVkM2kdOZaz1nrcmuDeTbf0qFDXgyqwtylV2u3g/HTzI7HwyddkEFH+
	uxdckOnJHAlkryPePdYDLn5cAAyhCWymtkbcNvqoy5x+9L/5zzUvDxJo4Mwk/eakHNpxHv
	kL4ZKV7Bb9XYdJVllsjl4z9PR/ZaPFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qJZYyvpeemiRBkekNlgWjlIChkmzeD8tHk7+9+TZSQ=;
	b=6/WP/goD1ZDLbyXUlIV2BR2ib5z/Y0YHLBZyTMVjtBaToLR55MFG1/+jk3qyIjewvnGR3d
	DJKXgXQdgiERl0DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bhkZaTDs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6/WP/goD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783935219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qJZYyvpeemiRBkekNlgWjlIChkmzeD8tHk7+9+TZSQ=;
	b=bhkZaTDsl235UNCIVkM2kdOZaz1nrcmuDeTbf0qFDXgyqwtylV2u3g/HTzI7HwyddkEFH+
	uxdckOnJHAlkryPePdYDLn5cAAyhCWymtkbcNvqoy5x+9L/5zzUvDxJo4Mwk/eakHNpxHv
	kL4ZKV7Bb9XYdJVllsjl4z9PR/ZaPFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783935219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qJZYyvpeemiRBkekNlgWjlIChkmzeD8tHk7+9+TZSQ=;
	b=6/WP/goD1ZDLbyXUlIV2BR2ib5z/Y0YHLBZyTMVjtBaToLR55MFG1/+jk3qyIjewvnGR3d
	DJKXgXQdgiERl0DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7C2E779AE;
	Mon, 13 Jul 2026 09:33:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6NwvOPKwVGo7fAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jul 2026 09:33:38 +0000
Message-ID: <0092e37e-f1ea-40b4-bdee-88c7434c1441@suse.de>
Date: Mon, 13 Jul 2026 11:33:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/9] ata: libata-scsi: improve ata_get_xlat_func
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260706065610.3559692-5-dlemoal@kernel.org>
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
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 045DD777D3
X-Spam-Score: -4.51

On 7/6/26 8:56 AM, Damien Le Moal wrote:
> ata_get_xlat_func() is given only the opcode of a SCSI command to
> determine the ATA command to translate to. This makes it impossible to
> translate SCSI commands such as SERVICE ACTION IN which need a service
> action field to fully specify the command.
> 
> In preparation for supporting the translation of the SERVICE ACTION IN
> command with service actions different from the SAI_READ_CAPACITY_16 (READ
> CAPACITY 16), change ata_get_xlat_func() to take a pointer to a SCSI
> command CDB so that all fields of the SCSI command to translate can be
> easily inspected.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
