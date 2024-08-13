Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066DA19B3E1
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723553801; cv=none; b=dPoFoOFgnhhdAYnsrb0u15orBud8qZzk2b4eFCs1IA4vXAbzBW7Ym/bQXAUNvAxlkKBevZ1tQTP8yMs9NF1bda/fltdxJ4e2TSZicBwXNP1UdypjAiR89qEuL7eEvytfFfxt4GDGeNjC64lKzAfRYP9x4EpycRUxWWbSIIhsbMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723553801; c=relaxed/simple;
	bh=dtfdG2/tny22RWPYnguJl5VfCgrZVLKuqTdshHOe1L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYu2yUE3rFbPjNF4ePw4wpD/1NgF4xd2RaGO5WO5fHtw381n99ciFgO3li6KxHrCVkYEoGyWXd/VxSrdt6l8/bFOWzh38OreC6TwIqUj2SLdi9F+g0miCdk7YRxiYlgVN4zGczkSfUet3ki4NGe16ae+PoUCyCm5eCjlZnfWacw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X8atI2Eq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8atI2Eq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723553798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fdMETTEImRyAVHiJjuMBFrMxCEIjWPptnF/f3Mcubwk=;
	b=X8atI2EqCscvVXLmkjzqEmUBCsMQk1Wh8bdSDfjPYJg0p/WWi7hUesUx8yHQyXzK+V0wB5
	XkJwCM6RxK0Rk56NRuNyj7lrQPNqTY+xzZOLm8hRIqId2zGs2Oi06nxxLucsuy2Tj4qDZk
	8dVc5ROCTshTbjHXCeRHmVV+eVGMEFw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-aWKwkjLwMuy558NDq8AgRg-1; Tue,
 13 Aug 2024 08:56:32 -0400
X-MC-Unique: aWKwkjLwMuy558NDq8AgRg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B21C91954B13;
	Tue, 13 Aug 2024 12:56:27 +0000 (UTC)
Received: from fedora (unknown [10.72.116.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDEF119560AA;
	Tue, 13 Aug 2024 12:56:08 +0000 (UTC)
Date: Tue, 13 Aug 2024 20:56:02 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Jonathan Corbet <corbet@lwn.net>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com,
	linux-doc@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <ZrtX4pzqwVUEgIPS@fedora>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Aug 06, 2024 at 02:06:47PM +0200, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled all hardware queues should run on the
> housekeeping CPUs only. Thus ignore the affinity mask provided by the
> driver. Also we can't use blk_mq_map_queues because it will map all CPUs
> to first hctx unless, the CPU is the same as the hctx has the affinity
> set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config
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
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  block/blk-mq-cpumap.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index c1277763aeeb..7e026c2ffa02 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -60,11 +60,64 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
>  
> +static bool blk_mq_hk_map_queues(struct blk_mq_queue_map *qmap)
> +{
> +	struct cpumask *hk_masks;
> +	cpumask_var_t isol_mask;
> +
> +	unsigned int queue, cpu;
> +
> +	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		return false;
> +
> +	/* map housekeeping cpus to matching hardware context */
> +	hk_masks = group_cpus_evenly(qmap->nr_queues);
> +	if (!hk_masks)
> +		goto fallback;
> +
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		for_each_cpu(cpu, &hk_masks[queue])
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
> +		       housekeeping_cpumask(HK_TYPE_IO_QUEUE));
> +
> +	for_each_cpu(cpu, isol_mask) {
> +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +		queue = (queue + 1) % qmap->nr_queues;
> +	}
> +

With patch 14 and the above change, managed irq's affinity becomes not
matched with blk-mq mapping any more.

If the last CPU in managed irq's affinity becomes offline, blk-mq
mapping may have other isolated CPUs, so IOs in this hctx won't be
drained from blk_mq_hctx_notify_offline() in case of CPU offline,
but genirq still shutdowns this manage irq.

So IO hang risk is introduced here, it should be the reason of your
hang observation.


Thanks, 
Ming

