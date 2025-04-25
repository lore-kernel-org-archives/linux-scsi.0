Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1840222D4D9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745562493; cv=none; b=NmWV3NfEyq8esdI30KNskmc3ccHga6tM7JxmE3HgmHvpfOvJhNHSbc+djXrV+2S8wIpMrXbLM8rSgRVX4b9pqUrQTw8DrVsv/HJaYfCQWznqcLFP/IgUo917jTLPjiz+Mh4/vGEsB0Rnuc57LI7QeC3C3eGgwYNwOGVJkdOUKcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745562493; c=relaxed/simple;
	bh=ivnq6L1IKWBSM0aCW+zg+WwA1ZO4erKesmzGd+EWzAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BRJEKvqKfNpCyFF6M/8Nay4x55gqPUMGXmMP3p61uYUU1Rx0A+YAdYm0OyhddHibVqwOjbsIoBYXMf1HO6YP7keEhfrQ3dz+iaCuCrqLyHLkqlNXooZFwtVd2N1851dwl9ftDu0B4wgksaOOLgsCCltc/PRnkRmpDLhrydSthO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H24HpbVV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QeNvCIrP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SBiXPjg+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wEMju/Ec; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H24HpbVV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QeNvCIrP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SBiXPjg+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wEMju/Ec"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E5D2E2116B;
	Fri, 25 Apr 2025 06:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745562488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ5pfGtOchW7Cl7zu73pnkjWN4FJ7641FF+SsdrWcx8=;
	b=H24HpbVVjbaJX3pkTShcCRMyXPPGXUdz6aWuvfnvObB1oGVLu4+VIlfYl805J/b79qFBsc
	uM5YXgV6Mudx+4e3kHundCiz5tyXheK2u5Fcbf3+5xqaiiMIDufKT3Ut6eI50pmDX7g9U2
	vM0kTsPYTpEwhfsC2TX0u033OWF0S5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745562488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ5pfGtOchW7Cl7zu73pnkjWN4FJ7641FF+SsdrWcx8=;
	b=QeNvCIrPbmQBQ7CvAsQepNQDMv/I9c5HUhSkOsCPWOtCAf5aoSZf96eghEzlUWV6bAV0QG
	Mac9w3Qr4XwDsFAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SBiXPjg+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="wEMju/Ec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745562487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ5pfGtOchW7Cl7zu73pnkjWN4FJ7641FF+SsdrWcx8=;
	b=SBiXPjg++3T0FTKOeD1JDlXPVBc5NakmoJpmYyptSZhScXmgfKMrRGufrk99k/RAGqf29U
	fM+LKryUDUDosXMJeeaBrP8ozqparbzoKFGTTJh36/liC4zYebwJXfn9bXB/frcxXPG+/F
	Re6FB1pqdZYA4IJaf/KxNxt4y4M5fJU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745562487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ5pfGtOchW7Cl7zu73pnkjWN4FJ7641FF+SsdrWcx8=;
	b=wEMju/EcrJ6aLjLJv3BijVYywGFN3aWSl5I/y66wDR/KgTI6qWCQNzjEGjp+TWpIjXfwhI
	yMjKxycjSqkpbCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CDC313A80;
	Fri, 25 Apr 2025 06:28:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lrXQBHcrC2gMXwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 25 Apr 2025 06:28:07 +0000
Message-ID: <0b2eff6c-29ff-450b-96a2-2cad4f0f47db@suse.de>
Date: Fri, 25 Apr 2025 08:28:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] blk-mq: prevent offlining hk CPU with associated
 online isolated CPUs
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-9-9a53a870ca1f@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250424-isolcpus-io-queues-v6-9-9a53a870ca1f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5D2E2116B
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 4/24/25 20:19, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
> given hctx would go offline, there would be no CPU left which handles
> the IOs. To prevent IO stalls, prevent offlining housekeeping CPUs which
> are still severing isolated CPUs..
             serving

> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c2697db591091200cdb9f6e082e472b829701e4c..aff17673b773583dfb2b01cb2f5f010c456bd834 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3627,6 +3627,48 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
>   	return data.has_rq;
>   }
>   
> +static bool blk_mq_hctx_check_isolcpus_online(struct blk_mq_hw_ctx *hctx, unsigned int cpu)
> +{
> +	const struct cpumask *hk_mask;
> +	int i;
> +
> +	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		return true;
> +
> +	hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +
> +	for (i = 0; i < hctx->nr_ctx; i++) {
> +		struct blk_mq_ctx *ctx = hctx->ctxs[i];
> +
> +		if (ctx->cpu == cpu)
> +			continue;
> +
> +		/*
> +		 * Check if this context has at least one online
> +		 * housekeeping CPU in this case the hardware context is
> +		 * usable.
> +		 */
> +		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
> +		    cpu_online(ctx->cpu))
> +			break;
> +
> +		/*
> +		 * The context doesn't have any online housekeeping CPUs
> +		 * but there might be an online isolated CPU mapped to
> +		 * it.
> +		 */
> +		if (cpu_is_offline(ctx->cpu))
> +			continue;
> +
> +		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
> +			hctx->queue->disk->disk_name,
> +			hctx->queue_num, ctx->cpu);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>   static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
>   		unsigned int this_cpu)
>   {
> @@ -3647,7 +3689,7 @@ static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
>   
>   		/* this hctx has at least one online CPU */
>   		if (this_cpu != cpu)
> -			return true;
> +			return blk_mq_hctx_check_isolcpus_online(hctx, this_cpu);
>   	}
>   
>   	return false;
> @@ -3659,7 +3701,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
>   			struct blk_mq_hw_ctx, cpuhp_online);
>   
>   	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
> -		return 0;
> +		return -EINVAL;
>   
>   	/*
>   	 * Prevent new request from being allocated on the current hctx.
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
