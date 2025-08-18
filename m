Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E1322743
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523764; cv=none; b=L+TSg3q5Eg+kIQBOBA41etHoGoW+YI8HxrBAMLbKnIaJ8zc/sglYCiSAaphZDQWI0yxko8UE5uiJlLdZTD4KIgbq7774hAwQLrJd6vKblepdMjEIpPVfbSW9ln/3qrdQHkZqYzADXboby/N4/MRM0g/9Wu72bIKhETU2n8N6Xso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523764; c=relaxed/simple;
	bh=fWobZYMjF5PRl2WHObt6pi2o4pa6lp38WF1h6JoYWEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=en5IvrZBVvYEswdJqlyCPp1Zlhm+V6bkVGOTxZXmH+2ITAZQpjKdJU7tyBDFB89VoaiXIDVD/VVBH1dZA9Ki94XizW2Zh1KDraXEEg7IDdzm0KUICNf2yUDXO5RRJMwTdNdg7jGjTz/CTpV6IM3VHNr5ZBHzrLV2fdYaPQagEUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lT22cuDJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vtUv49CD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lT22cuDJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vtUv49CD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lT22cuDJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vtUv49CD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lT22cuDJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vtUv49CD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 472351F457;
	Mon, 18 Aug 2025 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755523761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZq/1w5y+1y3LrqmZluT7wtKVAI/6FEzBhppJGy8Q24=;
	b=lT22cuDJjtajDjJEK0bfm9V/ovB+DBnbpt8ep3Cku9rfnnlTGlDpqJ96hBO2JMHB5e0rbV
	D9+S/M5HPLO/dk5KTExFh7Qb03ZpXz5ffXwpHrJnOMIDcqI+PvaR0SZhSjW5AbVFam/rXi
	nDCqzGQNpmJQI+Sd2m04YfEbuEGmIjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755523761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZq/1w5y+1y3LrqmZluT7wtKVAI/6FEzBhppJGy8Q24=;
	b=vtUv49CDJVTx5X6UBdmPv6HGFSe99XjFWZvcH3Cer5+dRTRst0GWmVgKtanKXDfjwQAGht
	TPWaMG4QSDjGStCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755523761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZq/1w5y+1y3LrqmZluT7wtKVAI/6FEzBhppJGy8Q24=;
	b=lT22cuDJjtajDjJEK0bfm9V/ovB+DBnbpt8ep3Cku9rfnnlTGlDpqJ96hBO2JMHB5e0rbV
	D9+S/M5HPLO/dk5KTExFh7Qb03ZpXz5ffXwpHrJnOMIDcqI+PvaR0SZhSjW5AbVFam/rXi
	nDCqzGQNpmJQI+Sd2m04YfEbuEGmIjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755523761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZq/1w5y+1y3LrqmZluT7wtKVAI/6FEzBhppJGy8Q24=;
	b=vtUv49CDJVTx5X6UBdmPv6HGFSe99XjFWZvcH3Cer5+dRTRst0GWmVgKtanKXDfjwQAGht
	TPWaMG4QSDjGStCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E97DF13A55;
	Mon, 18 Aug 2025 13:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TlpMLbAqo2jICAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 13:29:20 +0000
Message-ID: <04ed2475-6ad5-4fe8-bf40-d3e33cfb3c6f@suse.de>
Date: Mon, 18 Aug 2025 15:29:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250811173634.514041-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/11/25 19:34, Bart Van Assche wrote:
> If a SCSI driver must use reserved commands to discover the supported
> queue depth then the queue depth must be initialized to a small value and
> must be changed after the queue depth has been queried. Support such SCSI
> drivers by introducing the function scsi_host_update_can_queue().
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi.c      | 45 ++++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_host.h |  2 ++
>   2 files changed, 47 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a290c3aa7b88..3d3603b74d9f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -198,6 +198,51 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>   	scsi_io_completion(cmd, good_bytes);
>   }
>   
> +/**
> + * scsi_host_update_can_queue - Modify @host->can_queue
> + * @host:	SCSI host pointer
> + * @can_queue:	New value for @host->can_queue.
> + *
> + * @host->__devices must be empty except for the pseudo SCSI device and I/O
> + * must have been quiesced before this function is called.
> + */
> +int scsi_host_update_can_queue(struct Scsi_Host *host, int can_queue)
> +{
> +	struct blk_mq_tag_set prev_set;
> +	bool realloc_pseudo_sdev = false;
> +	struct scsi_device *sdev;
> +	int prev_can_queue, ret;
> +
> +	scoped_guard(spinlock_irq, host->host_lock)
> +		list_for_each_entry(sdev, &host->__devices, siblings)
> +			if (WARN_ON_ONCE(sdev != host->pseudo_sdev))
> +				return -EINVAL;
> +
> +	if (host->pseudo_sdev) {
> +		realloc_pseudo_sdev = true;
> +		__scsi_remove_device(host->pseudo_sdev);
> +		host->pseudo_sdev = NULL;
> +	}
> +
> +	prev_can_queue = host->can_queue;
> +	prev_set = host->tag_set;
> +	host->can_queue = can_queue;
> +	ret = scsi_mq_setup_tags(host);
> +	if (ret) {
> +		host->can_queue = prev_can_queue;
> +		return ret;
> +	}
> +	blk_mq_free_tag_set(&prev_set);
> +
> +	if (realloc_pseudo_sdev) {
> +		host->pseudo_sdev = scsi_get_pseudo_dev(host);
> +		if (!host->pseudo_sdev)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(scsi_host_update_can_queue);
>   
Reallocate the SCSI host device? Really?

We do have  blk_mq_update_nr_requests(), why can't you use that?
I would really go with the idea from John; the minimal number of
commands which can be allocated is trivially '1'.
And the number of reserved tags typically should be known a priori,
too. So you can start off with a tagset having just one 'normal'
tag (and a pre-defined number of reserved tags).
And then after querying you should be able to call 
'blk_mq_update_nr_requests()', and we should be good here...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
