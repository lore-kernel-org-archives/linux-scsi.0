Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B3535947
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754029991; cv=none; b=PQFt80mUnkxujZkdHwrJKwK/nH9ZqtRwZP5bCxQPEJo3lj1F2diRpC9LY0ZiERYQNHdaTEhD9whjW7esgi9neOdFB1kBiTybs2imgBhHPSGqEv1IjhPKMcTND5bvrOnAQDtPBXHXJ++Ru/Pcy6zMUFrp5wUm95+Hl2T1n6uK5WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754029991; c=relaxed/simple;
	bh=PLqSgsafLs+C5vjpyJmJfQRtlLoCXrC+Ha2iXdIt1IM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oKdEZP/pGIKGabaS3YT1XEYYn2PZpZ7dQmv56pbMAEjKQCaZNbieRzmxVdF8HkDUWaP5D5jcoUePP6FsJ+4UCvyF+VjmUtW2YOzoHDKY5MzsiAT1D1Etp9+eMUIKvfwfEgtDonEimaTHlWk9mt0f6bP1Pnxy7SsMJoSq1RhQtKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qV+U+Jfz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9Eemthzv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qV+U+Jfz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9Eemthzv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qV+U+Jfz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9Eemthzv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qV+U+Jfz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9Eemthzv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1BC3321B87;
	Fri,  1 Aug 2025 06:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTHyY6gBU6a6/sWa2vnIYXTQrT51bbibsCUmy5Zbh38=;
	b=qV+U+JfzzxUauqA/1OWgCFm3tmkm1vMqlHT4LNvg1ZSHPotn7LARbiixf+ZrXLD9kWYx12
	Fvbhcz2EhM/iOuNMDo+x5yillajuBDNBQwaQby2nK8Igva/eARGHaeLK2Gq708tjE16cr8
	nsMOPzjpVL2tHVsYLq/uMd3223WNHNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTHyY6gBU6a6/sWa2vnIYXTQrT51bbibsCUmy5Zbh38=;
	b=9Eemthzv+WG4CyBNwpMBHDJXsJ022WxOCyyVQKvgpU1jWT1KEQsTyJ7x0eEXUqp7DuYqku
	TbLFa/mkqFytxsDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qV+U+Jfz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9Eemthzv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754029988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTHyY6gBU6a6/sWa2vnIYXTQrT51bbibsCUmy5Zbh38=;
	b=qV+U+JfzzxUauqA/1OWgCFm3tmkm1vMqlHT4LNvg1ZSHPotn7LARbiixf+ZrXLD9kWYx12
	Fvbhcz2EhM/iOuNMDo+x5yillajuBDNBQwaQby2nK8Igva/eARGHaeLK2Gq708tjE16cr8
	nsMOPzjpVL2tHVsYLq/uMd3223WNHNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754029988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTHyY6gBU6a6/sWa2vnIYXTQrT51bbibsCUmy5Zbh38=;
	b=9Eemthzv+WG4CyBNwpMBHDJXsJ022WxOCyyVQKvgpU1jWT1KEQsTyJ7x0eEXUqp7DuYqku
	TbLFa/mkqFytxsDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D328B138A5;
	Fri,  1 Aug 2025 06:33:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qQCmMaNfjGirfwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 01 Aug 2025 06:33:07 +0000
Message-ID: <b76bedcc-a42f-4239-bf43-e75d66b0623e@suse.de>
Date: Fri, 1 Aug 2025 08:33:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] scsi: libsas: Make sas_get_ata_info() static
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250724000235.143460-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1BC3321B87
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/24/25 02:02, Damien Le Moal wrote:
> The function sas_get_ata_info() is used only in
> drivers/scsi/libsas/sas_ata.c. Remove its definition from
> include/scsi/sas_ata.h and make this function static.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_ata.c | 2 +-
>   include/scsi/sas_ata.h        | 6 ------
>   2 files changed, 1 insertion(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
