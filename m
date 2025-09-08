Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FE231A30
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 06:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757312024; cv=none; b=kpB98sJa4enxArUwnGH25IAVepLAwhcu9YbodAl+llQg6URLRKi9lTYs9ek0NQ5joAz9flb+LIbrtwPFdHEGGZoA5ytgjOBwvyXBReCttwiYLfMeZL1fliBOSpqRTmKpWiOB3Z2JVHYnfa2NGEQzHh/X8MNYMykwhJMSTufACoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757312024; c=relaxed/simple;
	bh=dAVByW/7B0JlmJlVR8C4qKZfWLB55rzoeK2/yrc6z+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttuwTwOL1aBh7ehPdY5UKgAdj/FlqMziVxPauLyJRDxokWw1KB5LW4/ix2zK7wcs415GY4YY3um66FQDzJDqNt9vGKEyfv0HHnc8uGpzJHsm6nmemmIufukvtcenPRHLG8+d5lm17x4yO3ony4Hu138QP4GnTIssrKEVgB0Sd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XD0y1DwT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r+nGIYqq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XD0y1DwT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r+nGIYqq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XD0y1DwT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r+nGIYqq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XD0y1DwT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r+nGIYqq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49F3324C9D;
	Mon,  8 Sep 2025 06:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757312013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEoMtcQvGwhax729Zongu1IhTIqdJOoWWIiF043lEJc=;
	b=XD0y1DwTvQdlkbP6CBPvsgqvG3tA9pdQMRXgMqGCl88Maot127fL/mCX36iTLMgg5nPgLE
	ls8ux61yD3RE/RAbGVF26x0lRx+lBk8qT+8bCU1GuhjF5tJ0pI9w5Ng/bY1F/nLYQI2R+C
	GakdlNkGSsi3/+ELI9U/pPY5skol2ZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757312013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEoMtcQvGwhax729Zongu1IhTIqdJOoWWIiF043lEJc=;
	b=r+nGIYqqOBjJ9ZiNx3I3VPPtkumZmf6KyehMHr3GUFVaA6ddkHQO97Jo0XsyGT8Um1r5TQ
	nwYVOI26lU009IDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757312013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEoMtcQvGwhax729Zongu1IhTIqdJOoWWIiF043lEJc=;
	b=XD0y1DwTvQdlkbP6CBPvsgqvG3tA9pdQMRXgMqGCl88Maot127fL/mCX36iTLMgg5nPgLE
	ls8ux61yD3RE/RAbGVF26x0lRx+lBk8qT+8bCU1GuhjF5tJ0pI9w5Ng/bY1F/nLYQI2R+C
	GakdlNkGSsi3/+ELI9U/pPY5skol2ZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757312013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEoMtcQvGwhax729Zongu1IhTIqdJOoWWIiF043lEJc=;
	b=r+nGIYqqOBjJ9ZiNx3I3VPPtkumZmf6KyehMHr3GUFVaA6ddkHQO97Jo0XsyGT8Um1r5TQ
	nwYVOI26lU009IDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7098113946;
	Mon,  8 Sep 2025 06:13:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vC5jGQx0vmgULgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Sep 2025 06:13:32 +0000
Message-ID: <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
Date: Mon, 8 Sep 2025 08:13:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
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
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
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
	RCPT_COUNT_TWELVE(0.00)[25];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 9/5/25 16:59, Daniel Wagner wrote:
> Extend the capabilities of the generic CPU to hardware queue (hctx)
> mapping code, so it maps houskeeping CPUs and isolated CPUs to the
> hardware queues evenly.
> 
> A hctx is only operational when there is at least one online
> housekeeping CPU assigned (aka active_hctx). Thus, check the final
> mapping that there is no hctx which has only offline housekeeing CPU and
> online isolated CPUs.
> 
> Example mapping result:
> 
>    16 online CPUs
> 
>    isolcpus=io_queue,2-3,6-7,12-13
> 
> Queue mapping:
>          hctx0: default 0 2
>          hctx1: default 1 3
>          hctx2: default 4 6
>          hctx3: default 5 7
>          hctx4: default 8 12
>          hctx5: default 9 13
>          hctx6: default 10
>          hctx7: default 11
>          hctx8: default 14
>          hctx9: default 15
> 
> IRQ mapping:
>          irq 42 affinity 0 effective 0  nvme0q0
>          irq 43 affinity 0 effective 0  nvme0q1
>          irq 44 affinity 1 effective 1  nvme0q2
>          irq 45 affinity 4 effective 4  nvme0q3
>          irq 46 affinity 5 effective 5  nvme0q4
>          irq 47 affinity 8 effective 8  nvme0q5
>          irq 48 affinity 9 effective 9  nvme0q6
>          irq 49 affinity 10 effective 10  nvme0q7
>          irq 50 affinity 11 effective 11  nvme0q8
>          irq 51 affinity 14 effective 14  nvme0q9
>          irq 52 affinity 15 effective 15  nvme0q10
> 
> A corner case is when the number of online CPUs and present CPUs
> differ and the driver asks for less queues than online CPUs, e.g.
> 
>    8 online CPUs, 16 possible CPUs
> 
>    isolcpus=io_queue,2-3,6-7,12-13
>    virtio_blk.num_request_queues=2
> 
> Queue mapping:
>          hctx0: default 0 1 2 3 4 5 6 7 8 12 13
>          hctx1: default 9 10 11 14 15
> 
> IRQ mapping
>          irq 27 affinity 0 effective 0 virtio0-config
>          irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
>          irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1
> 
> Noteworthy is that for the normal/default configuration (!isoclpus) the
> mapping will change for systems which have non hyperthreading CPUs. The
> main assignment loop will completely rely that group_mask_cpus_evenly to
> do the right thing. The old code would distribute the CPUs linearly over
> the hardware context:
> 
> queue mapping for /dev/nvme0n1
>          hctx0: default 0 8
>          hctx1: default 1 9
>          hctx2: default 2 10
>          hctx3: default 3 11
>          hctx4: default 4 12
>          hctx5: default 5 13
>          hctx6: default 6 14
>          hctx7: default 7 15
> 
> The assign each hardware context the map generated by the
> group_mask_cpus_evenly function:
> 
> queue mapping for /dev/nvme0n1
>          hctx0: default 0 1
>          hctx1: default 2 3
>          hctx2: default 4 5
>          hctx3: default 6 7
>          hctx4: default 8 9
>          hctx5: default 10 11
>          hctx6: default 12 13
>          hctx7: default 14 15
> 
> In case of hyperthreading CPUs, the resulting map stays the same.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq-cpumap.c | 177 ++++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 158 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 8244ecf878358c0b8de84458dcd5100c2f360213..1e66882e4d5bd9f78d132f3a229a1577853f7a9f 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -17,12 +17,25 @@
>   #include "blk.h"
>   #include "blk-mq.h"
>   
> +static struct cpumask blk_hk_online_mask;
> +
>   static unsigned int blk_mq_num_queues(const struct cpumask *mask,
>   				      unsigned int max_queues)
>   {
>   	unsigned int num;
>   
> -	num = cpumask_weight(mask);
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		const struct cpumask *hk_mask;
> +		struct cpumask avail_mask;
> +
> +		hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +		cpumask_and(&avail_mask, mask, hk_mask);
> +
> +		num = cpumask_weight(&avail_mask);
> +	} else {
> +		num = cpumask_weight(mask);
> +	}
> +
>   	return min_not_zero(num, max_queues);
>   }
>   
> @@ -31,9 +44,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
>    *
>    * Returns an affinity mask that represents the queue-to-CPU mapping
>    * requested by the block layer based on possible CPUs.
> + * This helper takes isolcpus settings into account.
>    */
>   const struct cpumask *blk_mq_possible_queue_affinity(void)
>   {
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +
>   	return cpu_possible_mask;
>   }
>   EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
> @@ -46,6 +63,12 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
>    */
>   const struct cpumask *blk_mq_online_queue_affinity(void)
>   {
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		cpumask_and(&blk_hk_online_mask, cpu_online_mask,
> +			    housekeeping_cpumask(HK_TYPE_IO_QUEUE));
> +		return &blk_hk_online_mask;

Can you explain the use of 'blk_hk_online_mask'?
Why is a static variable?
To my untrained eye it's being recalculated every time one calls
this function. And only the first invocation run on an empty mask,
all subsequent ones see a populated mask.

Is that the intention?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
