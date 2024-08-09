Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F49198837
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723217076; cv=none; b=Q4+s5bgCI98KryCNgyWXiUTlylig4nUsdn9VRlRcm0679HOa71iF7YcjytQV/+WdgzQxp0jSAWkUIVZMFJAlbasXP4RI8Xk10NJ0bnqgu8t2C0m+pxJW/Eo0lLqReTdvGVFDDrYfkCA83fNYpLla+ANVCZO/7YuQZ/Ik1s7v4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723217076; c=relaxed/simple;
	bh=g2iDrSBzxfQonyXIKogSC1gkM1FpY3qwgPMDIgnkaXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXgARnizw8pGTeR3z39Y1dde59cg9EIQpWTj9qVrxdS/MTbu55E8dOun2gjGqLXuUhAmmlRx2ZW69YLZ5Spej26Wc3clklepC/cOEJ4iRjXOPGFbvOc6fKmtGMn/qNreLijD0+nOos/Z5bwiQL754w4NHbGoO49ZwvF9CP/MKOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CySNPi2m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CySNPi2m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723217074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0M5zXAWQyeF4Jzk4EMsV0bzXAk2k6LTOOLJMOg7+eQ=;
	b=CySNPi2mdT0dcHIroXEP6kx1zywEZrpG/Gpj1xQeCju8pXbWzJ2/f+wUxEkOuhDxCNgG7M
	Ov/LjSzJ1sraFukHGMqUC6/ZraIrNSpiWsNCslCTUFpSvi2XIKYmNjwNDe1MdrfT8U4yes
	UWOmHxxgPdI/H9DMds7YeZbHkibMDsM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-185-uBgThbOOPc2IUzmiZF41Lw-1; Fri,
 09 Aug 2024 11:24:29 -0400
X-MC-Unique: uBgThbOOPc2IUzmiZF41Lw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50FBF1944CC9;
	Fri,  9 Aug 2024 15:24:24 +0000 (UTC)
Received: from fedora (unknown [10.72.116.16])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D74043000199;
	Fri,  9 Aug 2024 15:24:04 +0000 (UTC)
Date: Fri, 9 Aug 2024 23:23:58 +0800
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
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <ZrY0jp7S0Xnk9VUw@fedora>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
> +	free_cpumask_var(isol_mask);
> +
> +	return true;
> +
> +fallback:
> +	/* map all cpus to hardware context ignoring any affinity */
> +	queue = 0;
> +	for_each_possible_cpu(cpu) {
> +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +		queue = (queue + 1) % qmap->nr_queues;
> +	}
> +	return true;
> +}
> +
>  void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>  {
>  	const struct cpumask *masks;
>  	unsigned int queue, cpu;
>  
> +	if (blk_mq_hk_map_queues(qmap))
> +		return;
> +
>  	masks = group_cpus_evenly(qmap->nr_queues);
>  	if (!masks) {
>  		for_each_possible_cpu(cpu)
> @@ -118,6 +171,9 @@ void blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap,
>  	const struct cpumask *mask;
>  	unsigned int queue, cpu;
>  
> +	if (blk_mq_hk_map_queues(qmap))
> +		return;
> +
>  	for (queue = 0; queue < qmap->nr_queues; queue++) {
>  		mask = get_queue_affinity(dev_data, dev_off, queue);
>  		if (!mask)

From above implementation, "isolcpus=io_queue" is actually just one
optimization on "isolcpus=managed_irq", and there isn't essential
difference between the two.

And I'd suggest to optimize 'isolcpus=managed_irq' directly, such as:

- reduce nr_queues or numgrps for group_cpus_evenly() according to
house-keeping cpu mask

- spread house-keeping & isolate cpu mask evenly on each queue, and
you can use the existed two-stage spread for doing that


thanks,
Ming

