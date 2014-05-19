From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] virtio_scsi: use cmd_size
Date: Mon, 19 May 2014 10:44:40 -0700
Message-ID: <1400521480.10964.3.camel@haakon3.risingtidesystems.com>
References: <1398955911-20688-1-git-send-email-hch@lst.de>
	 <1398955911-20688-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41016 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaESRos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 13:44:48 -0400
In-Reply-To: <1398955911-20688-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Thu, 2014-05-01 at 16:51 +0200, Christoph Hellwig wrote:
> Taken almost entirely from Nicholas Bellinger's scsi-mq conversion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

>  drivers/scsi/virtio_scsi.c |   25 +++++++------------------
>  include/scsi/scsi_cmnd.h   |    9 +++++++++
>  2 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 16bfd50..5ec4a73 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -204,7 +204,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  			set_driver_byte(sc, DRIVER_SENSE);
>  	}
>  
> -	mempool_free(cmd, virtscsi_cmd_pool);
>  	sc->scsi_done(sc);
>  
>  	atomic_dec(&tgt->reqs);
> @@ -279,8 +278,6 @@ static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
>  
>  	if (cmd->comp)
>  		complete_all(cmd->comp);
> -	else
> -		mempool_free(cmd, virtscsi_cmd_pool);
>  }
>  
>  static void virtscsi_ctrl_done(struct virtqueue *vq)
> @@ -496,10 +493,9 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  				 struct virtio_scsi_vq *req_vq,
>  				 struct scsi_cmnd *sc)
>  {
> -	struct virtio_scsi_cmd *cmd;
> -	int ret;
> -
>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> +	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
> +
>  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
>  
>  	/* TODO: check feature bit and fail if unsupported?  */
> @@ -508,11 +504,6 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
>  
> -	ret = SCSI_MLQUEUE_HOST_BUSY;
> -	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
> -	if (!cmd)
> -		goto out;
> -
>  	memset(cmd, 0, sizeof(*cmd));
>  	cmd->sc = sc;
>  	cmd->req.cmd = (struct virtio_scsi_cmd_req){
> @@ -531,13 +522,9 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  
>  	if (virtscsi_kick_cmd(req_vq, cmd,
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
> -			      GFP_ATOMIC) == 0)
> -		ret = 0;
> -	else
> -		mempool_free(cmd, virtscsi_cmd_pool);
> -
> -out:
> -	return ret;
> +			      GFP_ATOMIC) != 0)
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +	return 0;
>  }
>  
>  static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> @@ -683,6 +670,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
>  	.name = "Virtio SCSI HBA",
>  	.proc_name = "virtio_scsi",
>  	.this_id = -1,
> +	.cmd_size = sizeof(struct virtio_scsi_cmd),
>  	.queuecommand = virtscsi_queuecommand_single,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
> @@ -699,6 +687,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
>  	.name = "Virtio SCSI HBA",
>  	.proc_name = "virtio_scsi",
>  	.this_id = -1,
> +	.cmd_size = sizeof(struct virtio_scsi_cmd),
>  	.queuecommand = virtscsi_queuecommand_multi,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index dd7c998..e016e2a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -133,6 +133,15 @@ struct scsi_cmnd {
>  	unsigned char tag;	/* SCSI-II queued command tag */
>  };
>  
> +/*
> + * Return the driver private allocation behind the command.
> + * Only works if cmd_size is set in the host template.
> + */
> +static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
> +{
> +	return cmd + 1;
> +}
> +
>  /* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
>  static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>  {


