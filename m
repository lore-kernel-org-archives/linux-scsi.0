From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2 6/8] scsi: virtio_scsi: fix IO hang by irq vector
 automatic affinity
Date: Mon, 5 Feb 2018 16:56:06 +0100
Message-ID: <21e7fc0c-1823-5744-6ba7-b6e95c1b9792@redhat.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753072AbeBEP4S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 10:56:18 -0500
In-Reply-To: <20180205152035.15016-7-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Laurence Oberman <loberman@redhat.com>

On 05/02/2018 16:20, Ming Lei wrote:
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> For example, on a 8cores VM, 4~7 are not-present/offline, 4 queues of
> virtio-scsi, the irq affinity assigned can become the following shape:
> 
> 	irq 36, cpu list 0-7
> 	irq 37, cpu list 0-7
> 	irq 38, cpu list 0-7
> 	irq 39, cpu list 0-1
> 	irq 40, cpu list 4,6
> 	irq 41, cpu list 2-3
> 	irq 42, cpu list 5,7
> 
> Then IO hang is triggered in case of non-SCSI_MQ.
> 
> Given storage IO is always C/S model, there isn't such issue with SCSI_MQ(blk-mq),
> because no IO can be submitted to one hw queue if the hw queue hasn't online
> CPUs.
> 
> Fix this issue by forcing to use blk_mq.
> 
> BTW, I have been used virtio-scsi(scsi_mq) for several years, and it has
> been quite stable, so it shouldn't cause extra risk.

I think that's ok now that we have I/O schedulers for blk-mq.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 59 +++-------------------------------------------
>  1 file changed, 3 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 7c28e8d4955a..54e3a0f6844c 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -91,9 +91,6 @@ struct virtio_scsi_vq {
>  struct virtio_scsi_target_state {
>  	seqcount_t tgt_seq;
>  
> -	/* Count of outstanding requests. */
> -	atomic_t reqs;
> -
>  	/* Currently active virtqueue for requests sent to this target. */
>  	struct virtio_scsi_vq *req_vq;
>  };
> @@ -152,8 +149,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  	struct virtio_scsi_cmd *cmd = buf;
>  	struct scsi_cmnd *sc = cmd->sc;
>  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> -	struct virtio_scsi_target_state *tgt =
> -				scsi_target(sc->device)->hostdata;
>  
>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p response %u status %#02x sense_len %u\n",
> @@ -210,8 +205,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  	}
>  
>  	sc->scsi_done(sc);
> -
> -	atomic_dec(&tgt->reqs);
>  }
>  
>  static void virtscsi_vq_done(struct virtio_scsi *vscsi,
> @@ -580,10 +573,7 @@ static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
>  					struct scsi_cmnd *sc)
>  {
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> -	struct virtio_scsi_target_state *tgt =
> -				scsi_target(sc->device)->hostdata;
>  
> -	atomic_inc(&tgt->reqs);
>  	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
>  }
>  
> @@ -596,55 +586,11 @@ static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
>  	return &vscsi->req_vqs[hwq];
>  }
>  
> -static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
> -					       struct virtio_scsi_target_state *tgt)
> -{
> -	struct virtio_scsi_vq *vq;
> -	unsigned long flags;
> -	u32 queue_num;
> -
> -	local_irq_save(flags);
> -	if (atomic_inc_return(&tgt->reqs) > 1) {
> -		unsigned long seq;
> -
> -		do {
> -			seq = read_seqcount_begin(&tgt->tgt_seq);
> -			vq = tgt->req_vq;
> -		} while (read_seqcount_retry(&tgt->tgt_seq, seq));
> -	} else {
> -		/* no writes can be concurrent because of atomic_t */
> -		write_seqcount_begin(&tgt->tgt_seq);
> -
> -		/* keep previous req_vq if a reader just arrived */
> -		if (unlikely(atomic_read(&tgt->reqs) > 1)) {
> -			vq = tgt->req_vq;
> -			goto unlock;
> -		}
> -
> -		queue_num = smp_processor_id();
> -		while (unlikely(queue_num >= vscsi->num_queues))
> -			queue_num -= vscsi->num_queues;
> -		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
> - unlock:
> -		write_seqcount_end(&tgt->tgt_seq);
> -	}
> -	local_irq_restore(flags);
> -
> -	return vq;
> -}
> -
>  static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
>  				       struct scsi_cmnd *sc)
>  {
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> -	struct virtio_scsi_target_state *tgt =
> -				scsi_target(sc->device)->hostdata;
> -	struct virtio_scsi_vq *req_vq;
> -
> -	if (shost_use_blk_mq(sh))
> -		req_vq = virtscsi_pick_vq_mq(vscsi, sc);
> -	else
> -		req_vq = virtscsi_pick_vq(vscsi, tgt);
> +	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq_mq(vscsi, sc);
>  
>  	return virtscsi_queuecommand(vscsi, req_vq, sc);
>  }
> @@ -775,7 +721,6 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
>  		return -ENOMEM;
>  
>  	seqcount_init(&tgt->tgt_seq);
> -	atomic_set(&tgt->reqs, 0);
>  	tgt->req_vq = &vscsi->req_vqs[0];
>  
>  	starget->hostdata = tgt;
> @@ -823,6 +768,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
>  	.target_alloc = virtscsi_target_alloc,
>  	.target_destroy = virtscsi_target_destroy,
>  	.track_queue_depth = 1,
> +	.force_blk_mq = 1,
>  };
>  
>  static struct scsi_host_template virtscsi_host_template_multi = {
> @@ -844,6 +790,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
>  	.target_destroy = virtscsi_target_destroy,
>  	.map_queues = virtscsi_map_queues,
>  	.track_queue_depth = 1,
> +	.force_blk_mq = 1,
>  };
>  
>  #define virtscsi_config_get(vdev, fld) \
> 
