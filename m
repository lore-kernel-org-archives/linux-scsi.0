Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB7E1E04BD;
	Tue,  7 Jan 2025 07:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736236328; cv=none; b=Zyh01CflRTAUwJGpRfpuw4sVeEG/T0G3IeT0hIvmZFQaogDoeohUNIHWdHU3Q4NaS2RxuzGQ44UOQ5PNXZvINf4Az3Hcerim8BFepXRkQGx56k2uWMQMZj5E7N/W82tK0QlDsKQlp5iPblyzP1WQZ+a2AJYw67YG0q7BYGM/myM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736236328; c=relaxed/simple;
	bh=JfYaEInJSpmq0SGY6Ukw0A5RAm/wciQENH2/SPvgjYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gaxrgYa+MJF48RyHp6SF7Gb7LlMhdRPzELVz0wDrTB7ADP+gkm1qdmgQQmNy5hzjg/gKC7o2YZMNuc2s2kQEJCyV6VCmEK0Q9KcOjYqjyVulO40a38d2sOt3MnnDX6ifl4uThfLUNf50TFHMTtLrl0S3EZvHGD6LO5GTkotEPd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FI5ljDTa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UT/1Hhr+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FI5ljDTa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UT/1Hhr+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FI5ljDTa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UT/1Hhr+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FI5ljDTa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UT/1Hhr+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 81F0621169;
	Tue,  7 Jan 2025 07:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736236320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma7lupYQRgt/8w+mxCotePjXTbtf5xdjlK6gQrSLO7Y=;
	b=FI5ljDTa4GtQpy6KDU9HM4Nrbti6tciIpE84OSvjuX2EvzGySz5TtXTbajtMnO7f2vKC90
	Nb+k8Qm8x2U7bZhf4BXfp/VACxWuIYncKJToNz6fT5UWPt/4hOJBmwdYB7tnJb/bsFNou/
	GmpejyOY3XjP2vJYJJEXqA5JV+LSgN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736236320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma7lupYQRgt/8w+mxCotePjXTbtf5xdjlK6gQrSLO7Y=;
	b=UT/1Hhr+Qtp4+7hk1PCVwpbgFW4bMem1xs8sXHc4k/NRMz5L6p+M/PhMr1aKWEJu8eTrFL
	zvtZTZSxFWSmLLAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FI5ljDTa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="UT/1Hhr+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736236320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma7lupYQRgt/8w+mxCotePjXTbtf5xdjlK6gQrSLO7Y=;
	b=FI5ljDTa4GtQpy6KDU9HM4Nrbti6tciIpE84OSvjuX2EvzGySz5TtXTbajtMnO7f2vKC90
	Nb+k8Qm8x2U7bZhf4BXfp/VACxWuIYncKJToNz6fT5UWPt/4hOJBmwdYB7tnJb/bsFNou/
	GmpejyOY3XjP2vJYJJEXqA5JV+LSgN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736236320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma7lupYQRgt/8w+mxCotePjXTbtf5xdjlK6gQrSLO7Y=;
	b=UT/1Hhr+Qtp4+7hk1PCVwpbgFW4bMem1xs8sXHc4k/NRMz5L6p+M/PhMr1aKWEJu8eTrFL
	zvtZTZSxFWSmLLAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DC3713A6A;
	Tue,  7 Jan 2025 07:51:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qc+mAB/dfGdtMAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 07 Jan 2025 07:51:59 +0000
Message-ID: <1a2fe8aa-d3e1-4e36-8cd5-27141c1d7178@suse.de>
Date: Tue, 7 Jan 2025 08:51:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] lib/group_cpus: let group_cpu_evenly return number
 of groups
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Kashyap Desai
 <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider
 <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Sridhar Balaraman <sbalaraman@parallelwireless.com>,
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-1-5d355fbb1e14@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241217-isolcpus-io-queues-v4-1-5d355fbb1e14@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81F0621169
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,suse.com,kernel.org,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,broadcom.com,microchip.com,lists.linux.dev];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_TWELVE(0.00)[38];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLeuu8pmbomyos8bjut4e19yoq)];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/17/24 19:29, Daniel Wagner wrote:
> group_cpu_evenly might allocated less groups then the requested:
> 
> group_cpu_evenly
>    __group_cpus_evenly
>      alloc_nodes_groups
>        # allocated total groups may be less than numgrps when
>        # active total CPU number is less then numgrps
> 
> In this case, the caller will do an out of bound access because the
> caller assumes the masks returned has numgrps.
> 
> Return the number of groups created so the caller can limit the access
> range accordingly.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq-cpumap.c        |  7 ++++---
>   drivers/virtio/virtio_vdpa.c |  2 +-
>   fs/fuse/virtio_fs.c          |  7 ++++---
>   include/linux/group_cpus.h   |  2 +-
>   kernel/irq/affinity.c        |  2 +-
>   lib/group_cpus.c             | 23 +++++++++++++----------
>   6 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index ad8d6a363f24ae11968b42f7bcfd6a719a0499b7..85c0a7073bd8bff5d34aad1729d45d89da4c4bd1 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -19,9 +19,10 @@
>   void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>   {
>   	const struct cpumask *masks;
> -	unsigned int queue, cpu;
> +	unsigned int queue, cpu, nr_masks;
>   
> -	masks = group_cpus_evenly(qmap->nr_queues);
> +	nr_masks = qmap->nr_queues;
> +	masks = group_cpus_evenly(&nr_masks);

Hmph. I am a big fan of separating input and output paramenters;
most ABI definitions will be doing that anyway.
Makes it also really hard to track whether the output parameters
had been set at all. Care to split it up?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

