Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17605224AF7
	for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2024 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600085; cv=none; b=VSbFtwbBJ5RXTCIbbvKMb9iGPhOQFnn1FY4GeVBQq17/6mQJ033iQYdsCIopKhVODZp8kytl2xPjakXU4PY1CB1d4kWeil9OhyZIwEteJlvSdR8WV+65MTJmYnhDPokkQOuphqUaTpiUhOgNzqrqchJv29T3J7si09JGcS3iS1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600085; c=relaxed/simple;
	bh=vw2hzac5lL8mrRYV31CrsMRjIydqDJo1GEH5qJ/dFdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItMO+seJ3kYwaasrejYSs/xiNe8MTSKhRTF2Ez1BlzrtsQX3iasPTPHZPo8BVGjR1MzdfhILRKa2au2IsA1CWxJ4Z59yFb2WXAMdUhRnkg73rzn7gU8DLvJ5wsE1aSKqIWpWpGAr6IwQd6RJeOk3EG+JWzxgQDJRgYnTjPhyFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMBuo6fL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMBuo6fL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734600083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pDD0mLx6ehr9v2wmDPxS8oF7AlYywFCAdUDEKZVcQAc=;
	b=VMBuo6fLDAxY0z6uIB7xmcAE2RrrHekA2liyw/Zk4MZTWNxMNhVY1sR81GH++CMoXBHAq6
	WYowNxI6a4Q286KZENx1MxX2l4ugWpOTSghfb3jT6Dsm5ZedpEOOo/QG+QJ16pu6yYjwOX
	oOdF1xtKV8CaGOMXvROstAcIVYb2H4A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-KJhKDg6wOXu9264xicIKRw-1; Thu,
 19 Dec 2024 04:21:19 -0500
X-MC-Unique: KJhKDg6wOXu9264xicIKRw-1
X-Mimecast-MFC-AGG-ID: KJhKDg6wOXu9264xicIKRw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C5ED1956053;
	Thu, 19 Dec 2024 09:21:15 +0000 (UTC)
Received: from fedora (unknown [10.72.116.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA62019560A2;
	Thu, 19 Dec 2024 09:20:50 +0000 (UTC)
Date: Thu, 19 Dec 2024 17:20:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 8/9] blk-mq: use hk cpus only when
 isolcpus=managed_irq is enabled
Message-ID: <Z2PlbL0XYTQ_LxTw@fedora>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-8-5d355fbb1e14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217-isolcpus-io-queues-v4-8-5d355fbb1e14@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Dec 17, 2024 at 07:29:42PM +0100, Daniel Wagner wrote:
> When isolcpus=managed_irq is enabled all hardware queues should run on
> the housekeeping CPUs only. Thus ignore the affinity mask provided by
> the driver. Also we can't use blk_mq_map_queues because it will map all
> CPUs to first hctx unless, the CPU is the same as the hctx has the
> affinity set to, e.g. 8 CPUs with isolcpus=managed_irq,2-3,6-7 config
> 
>   queue mapping for /dev/nvme0n1
>         hctx0: default 2 3 4 6 7
>         hctx1: default 5
>         hctx2: default 0
>         hctx3: default 1
> 
>   PCI name is 00:05.0: nvme0n1
>         irq 57 affinity 0-1 effective 1 is_managed:0 nvme0q0
>         irq 58 affinity 4 effective 4 is_managed:1 nvme0q1
>         irq 59 affinity 5 effective 5 is_managed:1 nvme0q2
>         irq 60 affinity 0 effective 0 is_managed:1 nvme0q3
>         irq 61 affinity 1 effective 1 is_managed:1 nvme0q4
> 
> where as with blk_mq_hk_map_queues we get
> 
>   queue mapping for /dev/nvme0n1
>         hctx0: default 2 4
>         hctx1: default 3 5
>         hctx2: default 0 6
>         hctx3: default 1 7
> 
>   PCI name is 00:05.0: nvme0n1
>         irq 56 affinity 0-1 effective 1 is_managed:0 nvme0q0
>         irq 61 affinity 4 effective 4 is_managed:1 nvme0q1
>         irq 62 affinity 5 effective 5 is_managed:1 nvme0q2
>         irq 63 affinity 0 effective 0 is_managed:1 nvme0q3
>         irq 64 affinity 1 effective 1 is_managed:1 nvme0q4
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq-cpumap.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index b3a863c2db3231624685ab54a1810b22af4111f4..38016bf1be8af14ef368e68d3fd12416858e3da6 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -61,11 +61,74 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
>  
> +/*
> + * blk_mq_map_hk_queues - Create housekeeping CPU to hardware queue mapping
> + * @qmap:	CPU to hardware queue map
> + *
> + * Create a housekeeping CPU to hardware queue mapping in @qmap. If the
> + * isolcpus feature is enabled and blk_mq_map_hk_queues returns true,
> + * @qmap contains a valid configuration honoring the managed_irq
> + * configuration. If the isolcpus feature is disabled this function
> + * returns false.
> + */
> +static bool blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
> +{
> +	struct cpumask *hk_masks;
> +	cpumask_var_t isol_mask;
> +	unsigned int queue, cpu, nr_masks;
> +
> +	if (!housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
> +		return false;
> +
> +	/* map housekeeping cpus to matching hardware context */
> +	nr_masks = qmap->nr_queues;
> +	hk_masks = group_cpus_evenly(&nr_masks);
> +	if (!hk_masks)
> +		goto fallback;
> +
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		for_each_cpu(cpu, &hk_masks[queue % nr_masks])
> +			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +	}
> +
> +	kfree(hk_masks);
> +
> +	/* map isolcpus to hardware context */
> +	if (!alloc_cpumask_var(&isol_mask, GFP_KERNEL))
> +		goto fallback;
> +
> +	queue = 0;
> +	cpumask_andnot(isol_mask,
> +		       cpu_possible_mask,
> +		       housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
> +
> +	for_each_cpu(cpu, isol_mask) {
> +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +		queue = (queue + 1) % qmap->nr_queues;
> +	}

Looks the IO hang issue in V3 isn't addressed yet, is it?

https://lore.kernel.org/linux-block/ZrtX4pzqwVUEgIPS@fedora/


Thanks,
Ming

