Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD23346AE8
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 06:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158936; cv=none; b=uRo0E1wKE1KSLtTZh8Is7GPezpQE453B665dImRHHld4mAT1N7uix0QQ9hIku6Kh5oEadJwiJ5mC5MCUJCFwd9rzyoSbFBBiztiJgNIsQInm07+oM0ajEzCeAeWgIwNT+KXqAT2lbb6raqswUfmF3tJrqzTw4M0wN65f8mhZsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158936; c=relaxed/simple;
	bh=OfSFJnsiWpPNdzVOwRUzv6mJVNHRdZFxxejcPMVgGsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TRjb4b0Yq6224neOUZ26AIcLBU5NtdhBSsuzb+SgiVAWRrFbQ1ginvYv1hTca8++Cd1UyERdM5DjeTgjkmqRW4xVsV4AL8wlDMNQzZXWqMcGBo4h1MnhMCxQi9NxxtsasbPfOe+2BcQ7uzW5tZnrwQVdrnm3paCOs3Jp2a8RYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q/5s1/KJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SCyGubdH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uEAucPak; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=N8uM98vE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q/5s1/KJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SCyGubdH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uEAucPak";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="N8uM98vE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C84956AF23;
	Thu, 11 Jun 2026 06:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781158933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaPVAJKQE+WamK90I3PEnWONi9ufq8nA3zt2PV9zgE0=;
	b=q/5s1/KJT3Rp1JX1LhI6CYkPcyqMXm8UuGGpqMN5fuA4yWOZ9gE1y9uz2EqiQQkv45I7YO
	M/wml8pcLVjTGbmMEVqGQS+27DDAvTP257qzVB/j251KrjJRPPTvvRwUVKciZ4/t2NGGrl
	eYLle68RqLfeQH1blxxusCCFpyZMM2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781158933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaPVAJKQE+WamK90I3PEnWONi9ufq8nA3zt2PV9zgE0=;
	b=SCyGubdH8HzdG0iQ+9DflpBd5gGnmxjjw6Rd7eTYGYlF3c50Arwjd7o4zjl36g+FvuT4dj
	6Sf+Ec5VpVJoYhDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781158931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaPVAJKQE+WamK90I3PEnWONi9ufq8nA3zt2PV9zgE0=;
	b=uEAucPak39hEi4haK/A/nLMETNdwDXjmd+7CvZhN0e4LbY0QYP23/VMbLqqgcVvhG8s9vr
	WwPr8lC+an8zkKNbujSu+L/RPmMpZU89kRAaUNucZvitRY1m1ymDd7yw0hpqlvy5w7JzkP
	Te/wvyWgC/OHMMbUjLCglHhxz8NaeA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781158931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaPVAJKQE+WamK90I3PEnWONi9ufq8nA3zt2PV9zgE0=;
	b=N8uM98vEwDMWKcnfbJOJnE0aM8+pOKnh9MJFa3s34e/LVUfJR5vIZ6DzwCmYmnauONtBU4
	ZPQFth9RqxaMzsCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F646779A7;
	Thu, 11 Jun 2026 06:22:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5GMxHRNUKmoIcAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 11 Jun 2026 06:22:11 +0000
Message-ID: <da054cb5-2899-44f0-91b3-967f12feaa38@suse.de>
Date: Thu, 11 Jun 2026 08:22:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN
 ATAPI device quirk
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260611024356.2769320-1-philpem@philpem.me.uk>
 <20260611024356.2769320-7-philpem@philpem.me.uk>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260611024356.2769320-7-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[philpem.me.uk:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 6/11/26 04:43, Phil Pemberton wrote:
> The Compaq PD-1 (and equivalent Panasonic LF-1195C) is a combination
> PD/CD-ROM drive that exposes two LUNs: LUN 0 is the CD-ROM and LUN 1
> is the PD (Phase-change rewritable) drive.
> 
> Add a scsi_devinfo entry with BLIST_FORCELUN to enable multi-LUN
> scanning, BLIST_SINGLELUN to prevent issuing LUN-aware commands
> simultaneously, and BLIST_NO_LUN_1F to suppress spurious "No Device"
> entries for unpopulated LUNs (which respond with PQ=0/PDT=0x1f).
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
> ---
>   drivers/scsi/scsi_devinfo.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 68a992494b12..bfc2cbd43897 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -150,6 +150,8 @@ static struct {
>   	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
> +	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
> +				 BLIST_NO_LUN_1F},
>   	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
>   	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>   	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
