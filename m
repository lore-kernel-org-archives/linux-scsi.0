Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1492E1DDF5;
	Tue,  6 Aug 2024 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722950810; cv=none; b=Z+fEkWp/nbL+SlGa1Evz2Unj28WhE3y5TL8TgSu6LIadtWieRTEAtzOzTQOp7JYcs7nc6EtLUZqWLMef5H69alFGe7WIV6BAAXld0Y2Rj6AS/LbdAVsLqwranXbY0c1jTohEuvXlVutYkaatQK7iL9CyZtqE/CkR4Y/P1m2ncNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722950810; c=relaxed/simple;
	bh=8UivSrRf4oDqeu6a9FiqQpiD886IiszpM9wVoHBy+qE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KerD4vYHsKZiC+E67Ojolegbp+ZmwrxzPV4j+zbJe+7oNO1fKfSU2i0RadXm92GFJ75xHfHWu6M7f/LAnxvEQQ9Gi9gFDIa4dkdaNLylqSIIkggEMho/veUGNLkPAQ3gimgTMGBC8fDcjAlttAOQ3CaMk17gprC6s+5Acb0A2p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 83FD868D09; Tue,  6 Aug 2024 15:26:45 +0200 (CEST)
Date: Tue, 6 Aug 2024 15:26:45 +0200
From: Christoph Hellwig <hch@lst.de>
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
	"brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 03/15] blk-mq: introduce blk_mq_dev_map_queues
Message-ID: <20240806132645.GC13883@lst.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de> <20240806-isolcpus-io-queues-v3-3-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-isolcpus-io-queues-v3-3-da0eecfeaf8b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 06, 2024 at 02:06:35PM +0200, Daniel Wagner wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> blk_mq_pci_map_queues and blk_mq_virtio_map_queues will create a CPU to
> hardware queue mapping based on affinity information. These two
> function share code which only differs on how the affinity information
> is retrieved. Also there is the hisi_sas which open codes the same loop.
> 
> Thus introduce a new helper function for creating these mappings which
> takes an callback function for fetching the affinity mask. Also
> introduce common helper function for PCI and virtio devices to retrieve
> affinity masks.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> [dwagner: - removed fallback mapping
>           - added affintity helpers
> 	  - updated commit message]
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  block/blk-mq-cpumap.c         | 35 +++++++++++++++++++++++++++++++++++
>  block/blk-mq-pci.c            | 18 ++++++++++++++++++
>  block/blk-mq-virtio.c         | 19 +++++++++++++++++++
>  include/linux/blk-mq-pci.h    |  2 ++
>  include/linux/blk-mq-virtio.h |  3 +++
>  include/linux/blk-mq.h        |  5 +++++
>  6 files changed, 82 insertions(+)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 9638b25fd521..7037a2dc485f 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -54,3 +54,38 @@ int blk_mq_hw_queue_to_node(struct blk_mq_queue_map *qmap, unsigned int index)
>  
>  	return NUMA_NO_NODE;
>  }
> +
> +/**
> + * blk_mq_dev_map_queues - Create CPU to hardware queue mapping
> + * @qmap:	CPU to hardware queue map.
> + * @dev_off:	Offset to use for the device.
> + * @dev_data:	Device data passed to get_queue_affinity().
> + * @get_queue_affinity:	Callback to retrieve queue affinity.
> + *
> + * Create a CPU to hardware queue mapping in @qmap. For each queue
> + * @get_queue_affinity will be called to retrieve the affinity for given
> + * queue.
> + */
> +void blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap,
> +			   void *dev_data, int dev_off,
> +			   get_queue_affinty_fn *get_queue_affinity)
> +{
> +	const struct cpumask *mask;
> +	unsigned int queue, cpu;
> +
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		mask = get_queue_affinity(dev_data, dev_off, queue);
> +		if (!mask)
> +			goto fallback;
> +
> +		for_each_cpu(cpu, mask)
> +			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +	}
> +
> +	return;
> +
> +fallback:
> +	WARN_ON_ONCE(qmap->nr_queues > 1);
> +	blk_mq_clear_mq_map(qmap);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_dev_map_queues);
> diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
> index d47b5c73c9eb..71a73238aeb2 100644
> --- a/block/blk-mq-pci.c
> +++ b/block/blk-mq-pci.c
> @@ -44,3 +44,21 @@ void blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
>  	blk_mq_clear_mq_map(qmap);
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_pci_map_queues);
> +
> +/**
> + * blk_mq_pci_get_queue_affinity - get affinity mask queue mapping for PCI device
> + * @dev_data:	Pointer to struct pci_dev.
> + * @offset:	Offset to use for the pci irq vector
> + * @queue:	Queue index
> + *
> + * This function returns for a queue the affinity mask for a PCI device.
> + * It is usually used as callback for blk_mq_dev_map_queues().
> + */
> +const struct cpumask *blk_mq_pci_get_queue_affinity(void *dev_data, int offset,
> +						    int queue)
> +{
> +	struct pci_dev *pdev = dev_data;
> +
> +	return pci_irq_get_affinity(pdev, offset + queue);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_pci_get_queue_affinity);
> diff --git a/block/blk-mq-virtio.c b/block/blk-mq-virtio.c
> index 68d0945c0b08..d3d33f8d69ce 100644
> --- a/block/blk-mq-virtio.c
> +++ b/block/blk-mq-virtio.c
> @@ -44,3 +44,22 @@ void blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
>  	blk_mq_map_queues(qmap);
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_virtio_map_queues);
> +
> +/**
> + * blk_mq_virtio_get_queue_affinity - get affinity mask queue mapping for virtio device

Please avoid the overly long line here.

> +const struct cpumask *blk_mq_virtio_get_queue_affinity(void *dev_data,
> +						       int offset,
> +						       int queue)
> +{

And maybe use sane formatting here:

const struct cpumask *blk_mq_virtio_get_queue_affinity(void *dev_data,
		int offset, int queue)

/me also wonders why the parameters aren't unsigned, but that's history..

