From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: don't select CONFIG_BLK_DEV_INTEGRITY
Date: Fri, 24 Apr 2015 11:28:38 +0200
Message-ID: <553A0CC6.8000305@redhat.com>
References: <1429812639-8648-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030297AbbDXJ2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 05:28:45 -0400
In-Reply-To: <1429812639-8648-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>



On 23/04/2015 20:10, Christoph Hellwig wrote:
> T10 PI is just another optional feature, LLDDs should work without
> the infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/Kconfig       |  1 -
>  drivers/scsi/virtio_scsi.c | 11 ++++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index b021bcb..896bea6 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1743,7 +1743,6 @@ config SCSI_BFA_FC
>  config SCSI_VIRTIO
>  	tristate "virtio-scsi support"
>  	depends on VIRTIO
> -	select BLK_DEV_INTEGRITY
>  	help
>            This is the virtual HBA driver for virtio.  If the kernel will
>            be used in a virtual machine, say Y or M.
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f164f24..0f2bb5b 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -501,6 +501,7 @@ static void virtio_scsi_init_hdr(struct virtio_device *vdev,
>  	cmd->crn = 0;
>  }
>  
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
>  static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
>  				    struct virtio_scsi_cmd_req_pi *cmd_pi,
>  				    struct scsi_cmnd *sc)
> @@ -524,6 +525,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
>  						       blk_rq_sectors(rq) *
>  						       bi->tuple_size);
>  }
> +#endif
>  
>  static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  				 struct virtio_scsi_vq *req_vq,
> @@ -546,11 +548,14 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>  
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
>  	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
>  		virtio_scsi_init_hdr_pi(vscsi->vdev, &cmd->req.cmd_pi, sc);
>  		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
>  		req_size = sizeof(cmd->req.cmd_pi);
> -	} else {
> +	} else
> +#endif
> +	{

All good so far.

>  		virtio_scsi_init_hdr(vscsi->vdev, &cmd->req.cmd, sc);
>  		memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>  		req_size = sizeof(cmd->req.cmd);
> @@ -1002,6 +1007,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
>  	shost->nr_hw_queues = num_queues;
>  
> +#ifdef VIRTIO_SCSI_F_T10_PI

This symbol is always defined; it is part of the uapi/ header.

I think you wanted #ifdef CONFIG_BLK_DEV_INTEGRITY here as well.
However, you can remove this #ifdef completely.  This is because...

>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {

... this condition should always be false unless the feature is
negotiated, and the feature should not be negotiated when
CONFIG_BLK_DEV_INTEGRITY is disabled.

Maybe you can add a "WARN_ON(!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))"
depending on your taste.

>  		host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
>  			    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |

Also, if you leave the #ifdef, host_prot is now unused if
CONFIG_BLK_DEV_INTEGRITY is disabled.  If you prefer to keep the #ifdef
you should also change host_prot to a macro (e.g. VIRTIO_SCSI_HOST_PROT)
to silence the compiler warning.

> @@ -1010,6 +1016,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  		scsi_host_set_prot(shost, host_prot);
>  		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
>  	}
> +#endif
>  
>  	err = scsi_add_host(shost, &vdev->dev);
>  	if (err)
> @@ -1090,7 +1097,9 @@ static struct virtio_device_id id_table[] = {
>  static unsigned int features[] = {
>  	VIRTIO_SCSI_F_HOTPLUG,
>  	VIRTIO_SCSI_F_CHANGE,
> +#ifdef VIRTIO_SCSI_F_T10_PI

This one definitely should be #ifdef CONFIG_BLK_DEV_INTEGRITY.

Thanks,

Paolo

>  	VIRTIO_SCSI_F_T10_PI,
> +#endif
>  };
>  
>  static struct virtio_driver virtio_scsi_driver = {
> 
