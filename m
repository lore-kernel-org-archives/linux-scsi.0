Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AE7484;
	Thu, 27 Jun 2024 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470358; cv=none; b=nq5XygS8X5ShuN0lVml49cOy0sJP2zXClmOEhxSQ5RSiouKsEyFVzwQlxtguC9tVlllo4081+Lp9kBaPLhEzfyEgIy3i1q5A+qYS9XjT56/tY5g6HUEyOXHmQEKVjWzcIUtA3LSndS7wUiZ0LnZm50KPUWYEK6JVZVM4NRwRd4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470358; c=relaxed/simple;
	bh=Htck884nV+SnkRT48r5pLMGilT4lVKCGx00mi5Wbsng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZ953GGSdl+WBp+ApAy+LosfdG6+95pE+PTIAVIUSgyGd6/h/O3Sl9P80H/T/BWpwh2HEH7VUmuzEN+IfVduPWp9gN1zdnLUgg3vHx/1GvbhcJsoaGpyhc9Qn98QgUOxBLGdPIqZAr9GS5Ki1zKByWxgy2ZLeP/f5HfEFTL8k9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nAWxGHt9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ux+UgKjO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ilkMYbPJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X8HCKQbc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nAWxGHt9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ux+UgKjO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ilkMYbPJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X8HCKQbc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 24F0F21979;
	Thu, 27 Jun 2024 06:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q08NVCSxcKcdlCSY3zIgH0F2Vr4R7qspL0G4mOgfUxo=;
	b=nAWxGHt9grf+4Q8MWqle0WXB8Q3RZhuYW5yAHWqsneZypsSrGlcgrkHOM9MlWNpKMTnnn5
	Xug5ei22qP9VlLqjJEoo1gL4TalelR4VobM7OQGb5ofXRWL3YYTOYMwMrRIj1/me8JHa/E
	iI1NT3gZDkFtdxvDwJKkFt/QJ5OLFzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q08NVCSxcKcdlCSY3zIgH0F2Vr4R7qspL0G4mOgfUxo=;
	b=ux+UgKjO71N4ByJl6ws0CBReIC6l3ez+zLJv4kBsr0B5Pox8ZISyiiGK2QF9b5ZelcNQ80
	M6hMDWgjhH5s/2Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ilkMYbPJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X8HCKQbc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q08NVCSxcKcdlCSY3zIgH0F2Vr4R7qspL0G4mOgfUxo=;
	b=ilkMYbPJdZUrpOnWBiFu1RYLutoHhrbGJQ6ow0efPImYd4NWi1mdIJITjhwuFmmpsbGwFk
	emqCbKj86aSA6Lg7Rvzr5SY51eS1y5Y+7v1w/K/lLVIo3L/FkyGo+K4mW3lGgZkq0jmZ3Z
	hfIrjXWkgdgH3bLNLwnyiKewbgVs8dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q08NVCSxcKcdlCSY3zIgH0F2Vr4R7qspL0G4mOgfUxo=;
	b=X8HCKQbcmrFoCIsglKsLy9FrtR1WvSAEYjB/Unxsy9al7h0kGiOn0Xqm7/B32UBnmxgapq
	YRBezh1ekBkF5SDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37EDC137DF;
	Thu, 27 Jun 2024 06:39:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GLvRBREJfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:39:13 +0000
Message-ID: <83aa5f4a-6066-425e-aab4-03b19c1f54e6@suse.de>
Date: Thu, 27 Jun 2024 08:39:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port
 print_ids
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-26-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-26-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 24F0F21979
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Spam-Level: 

On 6/26/24 20:00, Niklas Cassel wrote:
> Currently, the ata_port print_ids are increased indefinitely, even when
> there are lower ids available.
> 
> E.g. on first boot you will have ata1-ata6 assigned.
> After a rmmod + modprobe, you will instead have ata7-ata12 assigned.
> 
> Move to use the ida_alloc() API, such that print_ids will get reused.
> This means that even after a rmmod + modprobe, the ports will be assigned
> print_ids ata1-ata6.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

