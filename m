Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F07D276050
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764226953; cv=none; b=C1PUNmBiHfwOL+6SAuptIKQm7Nn3SdLwa9ItBI9phHXdlsi1KYmZwvOlqhVT5sB0uj6HvLqQAOqtw6uQItmhWroiLlM5eoQ1ZrbWv8SvrHlarTUhKrnZLhCUZ7qQ3IzCunbtlL/VBxTo6VvtOIfoG/Gug1cBkBPBYccnYJFqVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764226953; c=relaxed/simple;
	bh=ndShU3PvKioFbG17aBoY489sHzU89qEcPutYWJCq0JI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QjA9+2adc1hGixm5ileanoHs5UJfEa+CxNKwdL2jQJM9CEhTUu2Erd+vkd5QQtkilRIl0uPnD5nSp+eR1uD+OmV2a+vGE7IBL9+oZvtVPFWVSunf1OI+ez0MVQ3WZ2/HMdufl6NCZIm43IGtgqSL/rSS0/Dtlp26/DxSSXuOpMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NzPfVyj2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1jL2r0fd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NzPfVyj2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1jL2r0fd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NzPfVyj2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1jL2r0fd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NzPfVyj2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1jL2r0fd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3B3222C33;
	Thu, 27 Nov 2025 07:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764226948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8Nbit1EMMLZ3ow7dnTuT1uhbqNHJbPA4hh4qESRAyE=;
	b=NzPfVyj2rE+bLlq8Tw2xriTPSOYQhZ17QVHGFV+S9rTUVCLCStINtO2xjuai1VmwEmllrz
	94eIev7pMh06CLDab2V8vJV2udIYdLdKEhNcVXjf8psVx3GX3VIz6tEouTIre1G4gS9Tt+
	ucsxoP1n/YqyPKGhWhplVLjpOjflT1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764226948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8Nbit1EMMLZ3ow7dnTuT1uhbqNHJbPA4hh4qESRAyE=;
	b=1jL2r0fdcjpm6dOy7h5U0r7+b/8C5h9WvfOMXBNbbZcGMkq7/Yw6H24yMTbX0EfeF60qfp
	OfU+ppmxH/bZaEAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NzPfVyj2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1jL2r0fd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764226948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8Nbit1EMMLZ3ow7dnTuT1uhbqNHJbPA4hh4qESRAyE=;
	b=NzPfVyj2rE+bLlq8Tw2xriTPSOYQhZ17QVHGFV+S9rTUVCLCStINtO2xjuai1VmwEmllrz
	94eIev7pMh06CLDab2V8vJV2udIYdLdKEhNcVXjf8psVx3GX3VIz6tEouTIre1G4gS9Tt+
	ucsxoP1n/YqyPKGhWhplVLjpOjflT1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764226948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8Nbit1EMMLZ3ow7dnTuT1uhbqNHJbPA4hh4qESRAyE=;
	b=1jL2r0fdcjpm6dOy7h5U0r7+b/8C5h9WvfOMXBNbbZcGMkq7/Yw6H24yMTbX0EfeF60qfp
	OfU+ppmxH/bZaEAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B64B63EA63;
	Thu, 27 Nov 2025 07:02:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E4fjIYP3J2leVgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 07:02:27 +0000
Message-ID: <c678bfcb-4872-4f3f-8aeb-3956c2e7a1c8@suse.de>
Date: Thu, 27 Nov 2025 08:02:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] nvme: reject invalid pr_read_keys() num_keys values
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Mike Christie <michael.christie@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251126163600.583036-1-stefanha@redhat.com>
 <20251126163600.583036-3-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251126163600.583036-3-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B3B3222C33
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 11/26/25 17:35, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> Reservation Report command has a u32 maximum length. Reject num_keys
> values that are too large to fit.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/nvme/host/pr.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> index ca6a74607b139..476a0518a11ca 100644
> --- a/drivers/nvme/host/pr.c
> +++ b/drivers/nvme/host/pr.c
> @@ -233,6 +233,11 @@ static int nvme_pr_read_keys(struct block_device *bdev,
>   	int ret, i;
>   	bool eds;
>   
> +	/* Check that keys fit into u32 rse_len */
> +	if (num_keys > -(u32)offsetof(typeof(*rse), regctl_eds) /
> +	               sizeof(rse->regctl_eds[0]))
> +		return -EINVAL;
> +
>   	/*
>   	 * Assume we are using 128-bit host IDs and allocate a buffer large
>   	 * enough to get enough keys to fill the return keys buffer.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
