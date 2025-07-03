Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7952A28D8F5
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751523541; cv=none; b=X07p1Wzlc5UneMhJzqY1oeoPnq+FYzGJn9YF2vePM1+D69I1Dz3ww80H2AX5DBNrdI4ZPcGTAtk8VgQrvfgz4pnOq16vok2lC6EeAAdjFiLRbZb4S3j0H1l+/vAjHYQ1zv+IodpY4rEmKNmH8b01Ul/x6oeSQeyPtKZ6sHFbpbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751523541; c=relaxed/simple;
	bh=IuSe0+IF6k6hjIa925nr5aocivWfI9xJ/qQAJST0PBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=opaLuGhILRKA/eq1O6F7RbrFrg6Et5g+JmMMpjC6+xblzu3fUxGBtTT64M6rioCCn0Dz19OE1m5OrvsnNKWWq+fCB8y9I1MP+UN+feHGL6FTyNXU6mqdqlnTVz2OmcoG91L3FuyzBw8Y5gwILFnXoUBFhIBlxVT4uEUUWNTfC9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ngz79uYZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rQpKV1LN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ngz79uYZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rQpKV1LN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ngz79uYZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rQpKV1LN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ngz79uYZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rQpKV1LN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E0CE21191;
	Thu,  3 Jul 2025 06:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751523532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVQJP7K1t29zHa2r0HLkS0OKCgM09HDXXHqWgIEtN7Y=;
	b=Ngz79uYZJvypcya60eO+P/eNuXb2eLxhes1l3+MtucZ6LAIvZ/mnWKs1SllR6CpEmeggUt
	ESr9GThS2WlmtI7J76jCZZ95XXHQUX8+z3sqZRawiy70zDd5F3PPMmGd1OsvRQp6eRVn4N
	kE3/g6XAw6ah9nzVbWB7kPC/+VLPMns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751523532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVQJP7K1t29zHa2r0HLkS0OKCgM09HDXXHqWgIEtN7Y=;
	b=rQpKV1LNj8tlfdKU7ItEYWjCTowFNr3xPad5FEeNvEcGrJDpF9YKS64idblUnAOPs0eUip
	7j5FWDlY938gEGDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ngz79uYZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQpKV1LN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751523532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVQJP7K1t29zHa2r0HLkS0OKCgM09HDXXHqWgIEtN7Y=;
	b=Ngz79uYZJvypcya60eO+P/eNuXb2eLxhes1l3+MtucZ6LAIvZ/mnWKs1SllR6CpEmeggUt
	ESr9GThS2WlmtI7J76jCZZ95XXHQUX8+z3sqZRawiy70zDd5F3PPMmGd1OsvRQp6eRVn4N
	kE3/g6XAw6ah9nzVbWB7kPC/+VLPMns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751523532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVQJP7K1t29zHa2r0HLkS0OKCgM09HDXXHqWgIEtN7Y=;
	b=rQpKV1LNj8tlfdKU7ItEYWjCTowFNr3xPad5FEeNvEcGrJDpF9YKS64idblUnAOPs0eUip
	7j5FWDlY938gEGDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B5951368E;
	Thu,  3 Jul 2025 06:18:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AvWRB8sgZmj+RQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:18:51 +0000
Message-ID: <db0cbbe2-792c-4263-8be9-14b76eb0f7e6@suse.de>
Date: Thu, 3 Jul 2025 08:18:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/10] lib/group_cpus: Add group_masks_cpus_evenly()
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
 <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1E0CE21191
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:33, Daniel Wagner wrote:
> group_mask_cpus_evenly() allows the caller to pass in a CPU mask that
> should be evenly distributed. This new function is a more generic
> version of the existing group_cpus_evenly(), which always distributes
> all present CPUs into groups.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   include/linux/group_cpus.h |  3 +++
>   lib/group_cpus.c           | 64 +++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
> index 9d4e5ab6c314b31c09fda82c3f6ac18f77e9de36..d4604dce1316a08400e982039006331f34c18ee8 100644
> --- a/include/linux/group_cpus.h
> +++ b/include/linux/group_cpus.h
> @@ -10,5 +10,8 @@
>   #include <linux/cpu.h>
>   
>   struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks);
>   
>   #endif
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index 6d08ac05f371bf880571507d935d9eb501616a84..00c9b7a10c8acd29239fe20d2a30fdae22ef74a5 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -8,6 +8,7 @@
>   #include <linux/cpu.h>
>   #include <linux/sort.h>
>   #include <linux/group_cpus.h>
> +#include <linux/sched/isolation.h>
>   
>   #ifdef CONFIG_SMP
>   
> @@ -425,6 +426,59 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   	*nummasks = min(nr_present + nr_others, numgrps);
>   	return masks;
>   }
> +EXPORT_SYMBOL_GPL(group_cpus_evenly);
> +
> +/**
> + * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
> + * @numgrps: number of groups
> + * @cpu_mask: CPU to consider for the grouping
> + * @nummasks: number of initialized cpusmasks
> + *
> + * Return: cpumask array if successful, NULL otherwise. And each element
> + * includes CPUs assigned to this group.
> + *
> + * Try to put close CPUs from viewpoint of CPU and NUMA locality into
> + * same group. Allocate present CPUs on these groups evenly.
> + */

Description could be improved. Point is that you do not do any
calculation here, you just call __group_cpus_evenly() with
a different mask.

> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks)
> +{
> +	cpumask_var_t *node_to_cpumask;
> +	cpumask_var_t nmsk;
> +	int ret = -ENOMEM;
> +	struct cpumask *masks = NULL;
> +
> +	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
> +		return NULL;
> +
> +	node_to_cpumask = alloc_node_to_cpumask();
> +	if (!node_to_cpumask)
> +		goto fail_nmsk;
> +
> +	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
> +	if (!masks)
> +		goto fail_node_to_cpumask;
> +
> +	build_node_to_cpumask(node_to_cpumask);
> +
> +	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, cpu_mask, nmsk,
> +				  masks);
> +
> +fail_node_to_cpumask:
> +	free_node_to_cpumask(node_to_cpumask);
> +
> +fail_nmsk:
> +	free_cpumask_var(nmsk);
> +	if (ret < 0) {
> +		kfree(masks);
> +		return NULL;
> +	}
> +	*nummasks = ret;
> +	return masks;
> +}
> +EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
> +
>   #else /* CONFIG_SMP */
>   struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   {
> @@ -442,5 +496,13 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   	*nummasks = 1;
>   	return masks;
>   }
> -#endif /* CONFIG_SMP */
>   EXPORT_SYMBOL_GPL(group_cpus_evenly);
> +
> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks)
> +{
> +	return group_cpus_evenly(numgrps, nummasks);
> +}
> +EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
> +#endif /* CONFIG_SMP */
> 

Otherwise:
Reviewed-by: Hannes Reinecke <hare@suse.de.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
