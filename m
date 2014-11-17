From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V1] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 17 Nov 2014 12:05:01 +0100
Message-ID: <5469D65D.1000709@redhat.com>
References: <1416023234-28003-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaKQLFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 06:05:16 -0500
In-Reply-To: <1416023234-28003-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org



On 15/11/2014 04:47, Ming Lei wrote:
> Since virtio_scsi has supported multi virtqueue already,
> it is natural to map the virtque to hw-queue of blk-mq.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> V1:
> 	- support non-mq too
> 
>  drivers/scsi/virtio_scsi.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b83846f..d3af70e 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -561,6 +561,15 @@ static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
>  	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
>  }
>  
> +static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
> +						  struct scsi_cmnd *sc)
> +{
> +	u32 tag = blk_mq_unique_tag(sc->request);
> +	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
> +
> +	return &vscsi->req_vqs[hwq];
> +}
> +
>  static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>  					       struct virtio_scsi_target_state *tgt)
>  {
> @@ -604,7 +613,12 @@ static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
>  	struct virtio_scsi *vscsi = shost_priv(sh);
>  	struct virtio_scsi_target_state *tgt =
>  				scsi_target(sc->device)->hostdata;
> -	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq(vscsi, tgt);
> +	struct virtio_scsi_vq *req_vq;
> +
> +	if (shost_use_blk_mq(sh))
> +		req_vq = virtscsi_pick_vq_mq(vscsi, sc);
> +	else
> +		req_vq = virtscsi_pick_vq(vscsi, tgt);
>  
>  	return virtscsi_queuecommand(vscsi, req_vq, sc);
>  }
> @@ -983,6 +997,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	shost->max_id = num_targets;
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
> +	shost->nr_hw_queues = num_queues;
>  
>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
>  		host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
