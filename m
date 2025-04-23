Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206B0265619
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 05:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745387771; cv=none; b=ea2yb9TOrwHhuXISua+2tTJ+bEJMz3R0Liw7e+C7rk8SA6rg4d4CPyHah3nrk6MrV/Z+r0z04G4aJ5kMCX+z10hgESjy+co+ixY4T2UxDBXucgxZLLMKrNwam43R5gG8WXk7PkmnPQ3h6CS+K06jo//COjuJKOhVgQSTGOyQ7g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745387771; c=relaxed/simple;
	bh=CwsjHLp40WMCn2pllL1JWToDP1Nfsaq7vVa1z+87gLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RybAA4rvwc0HOKhCipdAXWrVbiThfaPNn/5S+BTStiy4rOVaKMJ3lN6Q46ro0Id8FumNsjX/1/umnwWUI02HBst4eAR1F4SYaz2pRtgtsV0ERZCWnsGorltpkmkaHcUeR3khp6B9nnnHlLrvIpXgQS0FNqyI2CPhPXMTSJa9p7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qDG12nR+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r1oSZ/O9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2WOuir4O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZVj95zZs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qDG12nR+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r1oSZ/O9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2WOuir4O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZVj95zZs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A53B2117C;
	Wed, 23 Apr 2025 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745387766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgqjYWUdsyZaGGyXyBVY+TCf8yP0QS0ScuyA35xcb80=;
	b=qDG12nR+6bdYHkl9gx45xv4LlUJZfYiaJu5njsaBfl8frzWad6/LFkcPhsgynLBV9nY8Aq
	+qva2tt9saP2d9POwB3I8gkH33xXYc0AcjHrureE68O92PZaBLnAnfRj+0cV1c5tBkuM2Q
	P6ATHbLy+fCSDWizz/BBAWzjRVfua3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745387766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgqjYWUdsyZaGGyXyBVY+TCf8yP0QS0ScuyA35xcb80=;
	b=r1oSZ/O9XKojbC9HI02gIsauxSN3F7d8hxMLlzZu5QUHNdhQx/e9vmBOmieSdN2fSdeMtg
	AgyIqDo6fYTcJNAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2WOuir4O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZVj95zZs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745387765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgqjYWUdsyZaGGyXyBVY+TCf8yP0QS0ScuyA35xcb80=;
	b=2WOuir4OiJDloO4o60gG1mDZ7gPcsF65GTWDFKk2h5wiPj0ga8ChX/DLtmXEeKv6pkzWEy
	6BjhF2+KqEAlPZiYTJnUO2As7w6CcdLNXKujhxnhDvROOd0cXCBXChirtimA/OIbJKqnrU
	SZeybphMxy8iVqlLu0+TeYwZsGdkSiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745387765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgqjYWUdsyZaGGyXyBVY+TCf8yP0QS0ScuyA35xcb80=;
	b=ZVj95zZsMTr2LL58xgtYb7pzQ6yJ1P+ErfXOuUAwGKcEggC+HG3KrICDG2T7KPtGDF4B5R
	NBszMi99hNhqk/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1C9A13691;
	Wed, 23 Apr 2025 05:56:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CqtDKfSACGgnSQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 23 Apr 2025 05:56:04 +0000
Message-ID: <a615ed0a-3e9d-49fb-9773-6a19fe4934af@suse.de>
Date: Wed, 23 Apr 2025 07:56:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: myrb: Fix spelling mistake "statux" ->
 "status"
To: Colin Ian King <colin.i.king@gmail.com>, Hannes Reinecke
 <hare@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250422170347.66792-1-colin.i.king@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250422170347.66792-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A53B2117C
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,HansenPartnership.com,oracle.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On 4/22/25 19:03, Colin Ian King wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/scsi/myrb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index dc4bd422b601..486db5b2f05d 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -891,7 +891,7 @@ static bool myrb_enable_mmio(struct myrb_hba *cb, mbox_mmio_init_t mmio_init_fn)
>   		status = mmio_init_fn(pdev, base, &mbox);
>   		if (status != MYRB_STATUS_SUCCESS) {
>   			dev_err(&pdev->dev,
> -				"Failed to enable mailbox, statux %02X\n",
> +				"Failed to enable mailbox, status %02X\n",
>   				status);
>   			return false;
>   		}
Tsk. I should've known better.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
