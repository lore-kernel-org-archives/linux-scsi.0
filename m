Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB51AACC;
	Fri, 24 May 2024 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546410; cv=none; b=RaZOOYMe4wydBG/bsULA73VDOwzBP/jxwZydmQh17QxMfj5ZwBcXhvvW5T27bgrFPj8FJhnnCMFZEFP8yLCUcuZvnmKwndWBikOrT9FPGFJk7t0k25mfzD2oo/owAvxOyIh6910cVHOHq2F2OMWy3u2QqYQpWOmzfUKvlbckcvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546410; c=relaxed/simple;
	bh=PJA5g7sFV9zsJoIALgVQTWFacEo4N//Bs7qxnVlOHI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z0VVC0gKbGEPrrgvpyOpmK8hCTOtrJyPLLhVFy5rEFGBrrT/tU113Z9xtoPE3WD3luppG7vjCgBS2m0Syf8eXCkbeQefYpcaYB97YwYt0fzNYg038wSbYF7BMdLjszfeL4G3q5g4BiGdXPLxXj4hRaQZlw7wd84QUyuFWBw1wKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DDG3JhFW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7hqQgevO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DDG3JhFW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7hqQgevO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DDG3JhFW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7hqQgevO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DDG3JhFW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7hqQgevO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2CF7E2093B;
	Fri, 24 May 2024 10:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716546407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBxCtleLXxoljGLHvrvNv6ZvvbYm+0xjiwVjzXCbIUM=;
	b=DDG3JhFWQGcvAko3eGokQtegy/VxHR2vewfSKryCSW8QG+hN99FOIiS8bj16KOD7vb6Mnq
	18EqcZIwFjeqgls1UbOuLh+kexrfNfq8GK9k3ApcvnKbJIx4HYt5be+XY8rGYNP1BcJ5lq
	c3zsySdhfP44v2XmjsVonsocw5ZWEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716546407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBxCtleLXxoljGLHvrvNv6ZvvbYm+0xjiwVjzXCbIUM=;
	b=7hqQgevOrjyMW+c+fgaNfzoD+IrT73HHWWD/81prWDKI+8hq386329dUKOfaE1JJTqXB9s
	pvDrVBky80mi4qDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DDG3JhFW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7hqQgevO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716546407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBxCtleLXxoljGLHvrvNv6ZvvbYm+0xjiwVjzXCbIUM=;
	b=DDG3JhFWQGcvAko3eGokQtegy/VxHR2vewfSKryCSW8QG+hN99FOIiS8bj16KOD7vb6Mnq
	18EqcZIwFjeqgls1UbOuLh+kexrfNfq8GK9k3ApcvnKbJIx4HYt5be+XY8rGYNP1BcJ5lq
	c3zsySdhfP44v2XmjsVonsocw5ZWEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716546407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBxCtleLXxoljGLHvrvNv6ZvvbYm+0xjiwVjzXCbIUM=;
	b=7hqQgevOrjyMW+c+fgaNfzoD+IrT73HHWWD/81prWDKI+8hq386329dUKOfaE1JJTqXB9s
	pvDrVBky80mi4qDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 137D713A6B;
	Fri, 24 May 2024 10:26:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +YBdBGdrUGY2EAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 May 2024 10:26:47 +0000
Message-ID: <c61a2ccf-eade-480b-9495-86e9ae7bd6b4@suse.de>
Date: Fri, 24 May 2024 12:26:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: bsg: Pass dev to blk_mq_alloc_queue()
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 himanshu.madhani@oracle.com
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
 <20240524084829.2132555-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240524084829.2132555-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.88 / 50.00];
	BAYES_HAM(-2.38)[97.12%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2CF7E2093B
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.88

On 5/24/24 10:48, John Garry wrote:
> When calling bsg_setup_queue() -> blk_mq_alloc_queue(), we don't pass
> the dev as the queuedata, but rather manually set it afterwards. Just
> pass dev to blk_mq_alloc_queue() to have automatically set.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/bsg-lib.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index ee738d129a9f..32da4a4429ce 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -385,13 +385,12 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
>   	if (blk_mq_alloc_tag_set(set))
>   		goto out_tag_set;
>   
> -	q = blk_mq_alloc_queue(set, lim, NULL);
> +	q = blk_mq_alloc_queue(set, lim, dev);
>   	if (IS_ERR(q)) {
>   		ret = PTR_ERR(q);
>   		goto out_queue;
>   	}
>   
> -	q->queuedata = dev;
>   	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
>   
>   	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

