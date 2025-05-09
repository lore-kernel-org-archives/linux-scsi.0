Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A065021CFFA
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 02:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746758341; cv=none; b=cjgfTy8+nJn9ktutCj9gBsrYMUElNU7dqwGHvpOxQCk9gYdkwkNyyYO2hyEW1pcD58BC1nFdVfsrqEM8KLCnQJNHZzHTfKXsx8+Am/QJ+wdAN4o70+t5UhpzHS+YDm+CQR7RqRmmlWpqwFtzvMlSIGqJtn7ASx2d+9M6ga/YNbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746758341; c=relaxed/simple;
	bh=28PZmBikyRVNyCi0jwd3K0EN2ow7EOcExcnFNtFnjWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvKkQdgYAe5eMaA32FdpV39ZoaexPfnuNA/5f8rV3ESjD1NLrCDnkCe8se7Yb3RiMIRjXsS80UDAyEnLxndKJARBEuK43Ar89n3hn4v+aem1xbD3vUtwKeQHwsXtKkswKz9s0HOaSGAoOXB3ZpM8wBuN4ItSImPTRdOD+itNALQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OSr4FiUZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSr4FiUZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746758338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TkvenbFeOwsyfczev8OuSFlkPWG7VB0ZMe+2MNlZ4xo=;
	b=OSr4FiUZFvuEjsMJ6sU502fi6hFiTzfoabKFKnucQDdSAUs0OHNdIhDVPEMhUmiJB1UWRS
	YoqA6/ZnnDqIOaqprbzK0gsg/qnQgTbyBA3r8BuT1JMpMonIQZJ8ZPoBMLUDTR0iAhzEBV
	aiefpYzv4smu5bCA+Htz94e36m00/wo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-JaUCkq6tPSyrfVCKyj_z8A-1; Thu,
 08 May 2025 22:38:54 -0400
X-MC-Unique: JaUCkq6tPSyrfVCKyj_z8A-1
X-Mimecast-MFC-AGG-ID: JaUCkq6tPSyrfVCKyj_z8A_1746758332
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A983519560A1;
	Fri,  9 May 2025 02:38:51 +0000 (UTC)
Received: from fedora (unknown [10.72.116.120])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCE0319560AD;
	Fri,  9 May 2025 02:38:37 +0000 (UTC)
Date: Fri, 9 May 2025 10:38:32 +0800
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
Subject: Re: [PATCH v6 8/9] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <aB1qqNDEnHMlpMH_@fedora>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-8-9a53a870ca1f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-isolcpus-io-queues-v6-8-9a53a870ca1f@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Apr 24, 2025 at 08:19:47PM +0200, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled all hardware queues should run on
> the housekeeping CPUs only. Thus ignore the affinity mask provided by
> the driver. Also we can't use blk_mq_map_queues because it will map all
> CPUs to first hctx unless, the CPU is the same as the hctx has the
> affinity set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  block/blk-mq-cpumap.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 6e6b3e989a5676186b5a31296a1b94b7602f1542..2d678d1db2b5196fc2b2ce5678fdb0cb6bad26e0 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -22,8 +22,8 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
>  {
>  	unsigned int num;
>  
> -	if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
> -		mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);

Here both two can be considered for figuring out nr_hw_queues:

	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
		mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
	else if (housekeeping_enabled(HK_TYPE_MANAGED_IRQ))
		mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);

>  
>  	num = cpumask_weight(mask);
>  	return min_not_zero(num, max_queues);
> @@ -61,11 +61,73 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
>  
> +/*
> + * blk_mq_map_hk_queues - Create housekeeping CPU to hardware queue mapping
> + * @qmap:	CPU to hardware queue map
> + *
> + * Create a housekeeping CPU to hardware queue mapping in @qmap. If the
> + * isolcpus feature is enabled and blk_mq_map_hk_queues returns true,
> + * @qmap contains a valid configuration honoring the io_queue
> + * configuration. If the isolcpus feature is disabled this function
> + * returns false.
> + */
> +static bool blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
> +{
> +	struct cpumask *hk_masks;
> +	cpumask_var_t isol_mask;
> +	unsigned int queue, cpu, nr_masks;
> +
> +	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
> +		return false;

It could be more readable to move the above check to the caller.


Thanks, 
Ming

