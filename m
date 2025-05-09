Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9FD78F40
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 01:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746754218; cv=none; b=UlJWtziqy7U832RYTIzG8FPP/zuo2Vk+JwF5G3htRIMYKpMLEBT/Ce5qfk9fWTj7b7bZX+Q81LeQEaFyvWiMEkzfdEKsMfYLg2qkVLHdySK0oBhgzaqnuFjZrHd2AUpDEc0pw4RXM0/BS9HaX6VK2qdDdbw0JjiN9bQI0iKDSj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746754218; c=relaxed/simple;
	bh=/qbfzc8/AS/igr2+ccTAmTclHpAKBi+VPfU1OA167hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4zlK/L/rW8Z7LqIgLtpGT2LzqdhoMumvcmXm9C8XofnvSq9CuprG1iZfVB0I5jZpTVhDEzKrm0GfT2v+jIo+dg0g0ovqG7yjnO56Zyb+2Sk0Sw9YwjL2rwdT4PENX2AxLXsvBFWdEK5Z3q8/0aBn02XSyfmSKmKDTIFuyfje9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfKPiIbb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfKPiIbb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746754215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cMx2+KSa5+OqN7vVFvRFQnhnHcLAVcYaLjsZze86Tmg=;
	b=cfKPiIbbOuVxpVFqgOvR4fD9Z+1Zlpsy8sCEbD4HpxmwNwQtVlFy1FXv0UbSRyDWOXSikI
	bP662fFg/cq+G8Jf9lbiBu/mmpjKOhwTUDL3TscdLGIFgIwNo/g7L1Ha6Rku633Udq+npt
	C0EHUq3a2EXvM0YbRUZJeGM7rSWjFEU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-EaCFTf9fM4K98gUIpMorrw-1; Thu,
 08 May 2025 21:30:11 -0400
X-MC-Unique: EaCFTf9fM4K98gUIpMorrw-1
X-Mimecast-MFC-AGG-ID: EaCFTf9fM4K98gUIpMorrw_1746754209
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9F4219560AF;
	Fri,  9 May 2025 01:30:07 +0000 (UTC)
Received: from fedora (unknown [10.72.116.120])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03478180049D;
	Fri,  9 May 2025 01:29:53 +0000 (UTC)
Date: Fri, 9 May 2025 09:29:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, storagedev@microchip.com,
	virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 1/9] lib/group_cpus: let group_cpu_evenly return
 number initialized masks
Message-ID: <aB1ajDUwJy6PVGEY@fedora>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-1-9a53a870ca1f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-isolcpus-io-queues-v6-1-9a53a870ca1f@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Apr 24, 2025 at 08:19:40PM +0200, Daniel Wagner wrote:
> group_cpu_evenly might allocated less groups then the requested:
> 
> group_cpu_evenly
>   __group_cpus_evenly
>     alloc_nodes_groups
>       # allocated total groups may be less than numgrps when
>       # active total CPU number is less then numgrps
> 
> In this case, the caller will do an out of bound access because the
> caller assumes the masks returned has numgrps.
> 
> Return the number of groups created so the caller can limit the access
> range accordingly.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq-cpumap.c        |  6 +++---
>  drivers/virtio/virtio_vdpa.c |  9 +++++----
>  fs/fuse/virtio_fs.c          |  6 +++---
>  include/linux/group_cpus.h   |  3 ++-
>  kernel/irq/affinity.c        |  9 +++++----
>  lib/group_cpus.c             | 12 +++++++++---
>  6 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 444798c5374f48088b661b519f2638bda8556cf2..269161252add756897fce1b65cae5b2e6aebd647 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -19,9 +19,9 @@
>  void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>  {
>  	const struct cpumask *masks;
> -	unsigned int queue, cpu;
> +	unsigned int queue, cpu, nr_masks;
>  
> -	masks = group_cpus_evenly(qmap->nr_queues);
> +	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
>  	if (!masks) {
>  		for_each_possible_cpu(cpu)
>  			qmap->mq_map[cpu] = qmap->queue_offset;
> @@ -29,7 +29,7 @@ void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>  	}
>  
>  	for (queue = 0; queue < qmap->nr_queues; queue++) {
> -		for_each_cpu(cpu, &masks[queue])
> +		for_each_cpu(cpu, &masks[queue % nr_masks])
>  			qmap->mq_map[cpu] = qmap->queue_offset + queue;
>  	}
>  	kfree(masks);
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 1f60c9d5cb1810a6f208c24bb2ac640d537391a0..a7b297dae4890c9d6002744b90fc133bbedb7b44 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -329,20 +329,21 @@ create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
>  
>  	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
>  		unsigned int this_vecs = affd->set_size[i];
> +		unsigned int nr_masks;
>  		int j;
> -		struct cpumask *result = group_cpus_evenly(this_vecs);
> +		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
>  
>  		if (!result) {
>  			kfree(masks);
>  			return NULL;
>  		}
>  
> -		for (j = 0; j < this_vecs; j++)
> +		for (j = 0; j < nr_masks; j++)
>  			cpumask_copy(&masks[curvec + j], &result[j]);
>  		kfree(result);
>  
> -		curvec += this_vecs;
> -		usedvecs += this_vecs;
> +		curvec += nr_masks;
> +		usedvecs += nr_masks;
>  	}
>  
>  	/* Fill out vectors at the end that don't need affinity */
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 2c7b24cb67adb2cb329ed545f56f04700aca8b81..7ed43b9ea4f3f8b108f1e0d7050c27267b9941c9 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -862,7 +862,7 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
>  static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *fs)
>  {
>  	const struct cpumask *mask, *masks;
> -	unsigned int q, cpu;
> +	unsigned int q, cpu, nr_masks;
>  
>  	/* First attempt to map using existing transport layer affinities
>  	 * e.g. PCIe MSI-X
> @@ -882,7 +882,7 @@ static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *f
>  	return;
>  fallback:
>  	/* Attempt to map evenly in groups over the CPUs */
> -	masks = group_cpus_evenly(fs->num_request_queues);
> +	masks = group_cpus_evenly(fs->num_request_queues, &nr_masks);
>  	/* If even this fails we default to all CPUs use first request queue */
>  	if (!masks) {
>  		for_each_possible_cpu(cpu)
> @@ -891,7 +891,7 @@ static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *f
>  	}
>  
>  	for (q = 0; q < fs->num_request_queues; q++) {
> -		for_each_cpu(cpu, &masks[q])
> +		for_each_cpu(cpu, &masks[q % nr_masks])
>  			fs->mq_map[cpu] = q + VQ_REQUEST;
>  	}
>  	kfree(masks);
> diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
> index e42807ec61f6e8cf3787af7daa0d8686edfef0a3..bd5dada6e8606fa6cf8f7babf939e39fd7475c8d 100644
> --- a/include/linux/group_cpus.h
> +++ b/include/linux/group_cpus.h
> @@ -9,6 +9,7 @@
>  #include <linux/kernel.h>
>  #include <linux/cpu.h>
>  
> -struct cpumask *group_cpus_evenly(unsigned int numgrps);
> +struct cpumask *group_cpus_evenly(unsigned int numgrps,
> +				  unsigned int *nummasks);
>  
>  #endif
> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index 44a4eba80315cc098ecfa366ca1d88483641b12a..d2aefab5eb2b929877ced43f48b6268098484bd7 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -70,20 +70,21 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
>  	 */
>  	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
>  		unsigned int this_vecs = affd->set_size[i];
> +		unsigned int nr_masks;
>  		int j;
> -		struct cpumask *result = group_cpus_evenly(this_vecs);
> +		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
>  
>  		if (!result) {
>  			kfree(masks);
>  			return NULL;
>  		}
>  
> -		for (j = 0; j < this_vecs; j++)
> +		for (j = 0; j < nr_masks; j++)
>  			cpumask_copy(&masks[curvec + j].mask, &result[j]);
>  		kfree(result);
>  
> -		curvec += this_vecs;
> -		usedvecs += this_vecs;
> +		curvec += nr_masks;
> +		usedvecs += nr_masks;
>  	}
>  
>  	/* Fill out vectors at the end that don't need affinity */
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index ee272c4cefcc13907ce9f211f479615d2e3c9154..016c6578a07616959470b47121459a16a1bc99e5 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -332,9 +332,11 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
>  /**
>   * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
>   * @numgrps: number of groups
> + * @nummasks: number of initialized cpumasks
>   *
>   * Return: cpumask array if successful, NULL otherwise. And each element
> - * includes CPUs assigned to this group
> + * includes CPUs assigned to this group. nummasks contains the number
> + * of initialized masks which can be less than numgrps.
>   *
>   * Try to put close CPUs from viewpoint of CPU and NUMA locality into
>   * same group, and run two-stage grouping:
> @@ -344,7 +346,8 @@ static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
>   * We guarantee in the resulted grouping that all CPUs are covered, and
>   * no same CPU is assigned to multiple groups
>   */
> -struct cpumask *group_cpus_evenly(unsigned int numgrps)
> +struct cpumask *group_cpus_evenly(unsigned int numgrps,
> +				  unsigned int *nummasks)
>  {
>  	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
>  	cpumask_var_t *node_to_cpumask;
> @@ -421,10 +424,12 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
>  		kfree(masks);
>  		return NULL;
>  	}
> +	*nummasks = nr_present + nr_others;

WARN_ON(nr_present + nr_others < numgrps) can be removed now.

Other than that and with Thomas's comment addressed:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

