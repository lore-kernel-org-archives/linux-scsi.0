Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DB2292B42
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525889; cv=none; b=bsLk3utpaYBdFekodNk9QTbJvhGtw0epvT2oUT4RsAgnw98C7e/uBZSY1MPRf1HEwSbjZoFcTDQUGNsbjg4/G2WB+euNqTthqJU4YlUp5G2fRKwcCby57lz8Wu0g/a80UgQgqUeVDZHdlkvmnfqHsCXRUGecRHXgDMeF98H+48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525889; c=relaxed/simple;
	bh=MiFb7oNrkcZmadEbXGPfi400/7byvb7i53fdpey0wwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2/flKHzziSMuU8Dxo8RF15Gqk7PQ286l0TWLwK5pmizj0QooP9wdCClEfKug6MzeG+PYZwb2MoT5+BAPqYjM3fD3DQXTe4sIVet18VIgapmUZItkm4/BCg7TfuHiZxuuOQHBcb/L+2Vs20P2cJs03YtWGanLtwcOfWEUGab3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m4nW6xnh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xQZD9tRr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TE3zkJ7I; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+FWzNcWR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m4nW6xnh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xQZD9tRr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TE3zkJ7I";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+FWzNcWR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF72521185;
	Thu,  3 Jul 2025 06:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUbc++Fz1+vt/VzybyWwNssiulZcT0uY8D6xoHGrF7M=;
	b=m4nW6xnh53fJ7amnbj5N7ei1QAA7tuEBVoq1NumXAmJURYixd8kq+afkHNlLuHWvwPKXNL
	p6yorRiT7AbFURQLO5ijI9H1TXUpH9SmGlX97i/4LMnnxtGS76Rar3udcrDtyEymTGO3be
	sd9fA3jGa376sp3HbSrxH2lfDbrpVQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUbc++Fz1+vt/VzybyWwNssiulZcT0uY8D6xoHGrF7M=;
	b=xQZD9tRrGUcNoFKjfBtNUnjNR9WredQqikK7BWN/izCyP9tpC6x63bWW4/S9oUJzqiZiTg
	xl5SH17jAIB8WcBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TE3zkJ7I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+FWzNcWR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUbc++Fz1+vt/VzybyWwNssiulZcT0uY8D6xoHGrF7M=;
	b=TE3zkJ7IT/2CM5bxHvNjIlOyubeA+9WNLI0KnIaOcXKQ4CeFoh225wiciIpSMVP4MpB8CN
	HSc+jUGBA9LOtxiWfZBwl5KpKrPpD55ibbt0aD6FMmzMwTW+1NUStZK/xCdraI3ULyvEW5
	JcIQntrGWV/A0kBicjAW84yFseaKOp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUbc++Fz1+vt/VzybyWwNssiulZcT0uY8D6xoHGrF7M=;
	b=+FWzNcWRZW+AeBPGJLerU6Z2alqBIlY9hNLWX15wjXwl95DUqXtsBl9sQnNwWZ+P1xbVeQ
	hGTSzwgVoEQVpWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2226413721;
	Thu,  3 Jul 2025 06:58:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tNzgBvspZmg0UQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:58:03 +0000
Message-ID: <9025c412-9b6f-4714-a880-e8e6084e1b4c@suse.de>
Date: Thu, 3 Jul 2025 08:58:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/10] blk-mq: use hk cpus only when isolcpus=io_queue
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
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-8-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-8-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DF72521185
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On 7/2/25 18:33, Daniel Wagner wrote:
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
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq-cpumap.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 191 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 8244ecf878358c0b8de84458dcd5100c2f360213..4cb2724a78e13216e50f0e6b1a18f19ea41a54f8 100644
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
> +	}
> +
>   	return cpu_online_mask;
>   }
>   EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
> @@ -57,7 +80,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
>    *		ignored.
>    *
>    * Calculates the number of queues to be used for a multiqueue
> - * device based on the number of possible CPUs.
> + * device based on the number of possible CPUs. This helper
> + * takes isolcpus settings into account.
>    */
>   unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
>   {
> @@ -72,7 +96,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
>    *		ignored.
>    *
>    * Calculates the number of queues to be used for a multiqueue
> - * device based on the number of online CPUs.
> + * device based on the number of online CPUs. This helper
> + * takes isolcpus settings into account.
>    */
>   unsigned int blk_mq_num_online_queues(unsigned int max_queues)
>   {
> @@ -80,11 +105,169 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
>   }
>   EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
>   
> +static bool blk_mq_hk_validate(struct blk_mq_queue_map *qmap,
> +			       const struct cpumask *active_hctx)
> +{
> +	/*
> +	 * Verify if the mapping is usable.
> +	 *
> +	 * First, mark all hctx which have at least online houskeeping
> +	 * CPU assigned.
> +	 */
> +	for (int queue = 0; queue < qmap->nr_queues; queue++) {
> +		int cpu;
> +
> +		if (cpumask_test_cpu(queue, active_hctx)) {
> +			/*
> +			 * This htcx has at least one online houskeeping
> +			 * CPU thus it is able to serve any assigned
> +			 * isolated CPU.
> +			 */
> +			continue;
> +		}
> +
> +		/*
> +		 * There is no online houskeeping CPU for this hctx, all
> +		 * good as long as all isolated CPUs are also offline.
> +		 */
> +		for_each_online_cpu(cpu) {
> +			if (qmap->mq_map[cpu] != queue)
> +				continue;
> +
> +			pr_warn("Unable to create a usable CPU-to-queue mapping with the given constraints\n");
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * blk_mq_map_hk_queues - Create housekeeping CPU to
> + *                        hardware queue mapping
> + * @qmap:	CPU to hardware queue map
> + *
> + * Create a housekeeping CPU to hardware queue mapping in @qmap. @qmap
> + * contains a valid configuration honoring the isolcpus configuration.
> + */
> +static void blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
> +{
> +	cpumask_var_t active_hctx __free(free_cpumask_var) = NULL;
> +	struct cpumask *hk_masks __free(kfree) = NULL;
> +	const struct cpumask *mask;
> +	unsigned int queue, cpu, nr_masks;
> +
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
> +	else
> +		goto fallback;
> +
> +	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
> +		goto fallback;
> +
> +	/* Map housekeeping CPUs to a hctx */
> +	hk_masks = group_mask_cpus_evenly(qmap->nr_queues, mask, &nr_masks);
> +	if (!hk_masks)
> +		goto fallback;
> +
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
> +
> +		for_each_cpu(cpu, &hk_masks[idx]) {
> +			qmap->mq_map[cpu] = idx;
> +
> +			if (cpu_online(cpu))
> +				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);

Why cpu_online? Up until this point it really didn't matter if the 
affinity mask was set to 'online' or 'possible' cpus, but here you
require CPUs to be online...

> +		}
> +	}
> +
> +	/* Map isolcpus to hardware context */
> +	queue = cpumask_first(active_hctx);
> +	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
> +		qmap->mq_map[cpu] = (qmap->queue_offset + queue) % nr_masks;
> +		queue = cpumask_next_wrap(queue, active_hctx);
> +	}

Really? Doesn't this map _all_ cpus, and not just the isolcpus?

> +
> +	if (!blk_mq_hk_validate(qmap, active_hctx))
> +		goto fallback;
> +
> +	return;
> +
> +fallback:
> +	/*
> +	 * Map all CPUs to the first hctx to ensure at least one online
> +	 * housekeeping CPU is serving it.
> +	 */
> +	for_each_possible_cpu(cpu)
> +		qmap->mq_map[cpu] = 0;

I think you need to map all hctx, no?

> +}
> +
> +/*
> + * blk_mq_map_hk_irq_queues - Create housekeeping CPU to
> + *                            hardware queue mapping
> + * @dev:	The device to map queues
> + * @qmap:	CPU to hardware queue map
> + * @offset:	Queue offset to use for the device
> + *
> + * Create a housekeeping CPU to hardware queue mapping in @qmap. @qmap
> + * contains a valid configuration honoring the isolcpus configuration.
> + */
> +static void blk_mq_map_hk_irq_queues(struct device *dev,
> +				     struct blk_mq_queue_map *qmap,
> +				     int offset)
> +{
> +	cpumask_var_t active_hctx __free(free_cpumask_var) = NULL;
> +	cpumask_var_t mask __free(free_cpumask_var) = NULL;
> +	unsigned int queue, cpu;
> +
> +	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
> +		goto fallback;
> +
> +	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> +		goto fallback;
> +
> +	/* Map housekeeping CPUs to a hctx */
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		for_each_cpu(cpu, dev->bus->irq_get_affinity(dev, offset + queue)) {
> +			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +
> +			cpumask_set_cpu(cpu, mask);
> +			if (cpu_online(cpu))
> +				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);

Now that is really curious. You pick up the interrupt affinity from the
'bus', which, I assume, is the PCI bus. And this would imply that the
bus can (or already is) programmed for this interrupt affinity.
Which would imply that this is a usable interrupt affinity from the
hardware perspective, irrespective on whether the cpu is online or not.
So why the check to cpu_online()? Can't we simply take the existing 
affinity and rely on the hardware to do the right thing?

> +		}
> +	}
> +
> +	/* Map isolcpus to hardware context */
> +	queue = cpumask_first(active_hctx);
> +	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
> +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +		queue = cpumask_next_wrap(queue, active_hctx);
> +	}
> +
> +	if (!blk_mq_hk_validate(qmap, active_hctx))
> +		goto fallback;
> +
> +	return;
> +
> +fallback:
> +	/*
> +	 * Map all CPUs to the first hctx to ensure at least one online
> +	 * housekeeping CPU is serving it.
> +	 */
> +	for_each_possible_cpu(cpu)
> +		qmap->mq_map[cpu] = 0;

Same comment as previously; don't we need to map all hctx?

> +}
> +
>   void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>   {
>   	const struct cpumask *masks;
>   	unsigned int queue, cpu, nr_masks;
>   
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		blk_mq_map_hk_queues(qmap);
> +		return;
> +	}
> +
>   	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
>   	if (!masks) {
>   		for_each_possible_cpu(cpu)
> @@ -139,6 +322,11 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
>   	if (!dev->bus->irq_get_affinity)
>   		goto fallback;
>   
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> +		blk_mq_map_hk_irq_queues(dev, qmap, offset);
> +		return;
> +	}
> +
>   	for (queue = 0; queue < qmap->nr_queues; queue++) {
>   		mask = dev->bus->irq_get_affinity(dev, queue + offset);
>   		if (!mask)
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
