From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
Date: Mon, 8 Jul 2019 17:47:54 +0800
Message-ID: <CACVXFVPE7vX1pEPH0G_C_eZW8eztdTEg8Xr=8+D=9-eVeMNZ_g@mail.gmail.com>
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-3-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-3-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM General <kvm@vger.kernel.org>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 30, 2019 at 7:28 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Adding the command and kicking the virtqueue so far was done one after
> another.  Make the kick optional, so that we can take into account SCMD_LAST.
> We also need a commit_rqs callback to kick the device if blk-mq aborts
> the submission before the last request is reached.
>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 8af01777d09c..918c811cea95 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -375,14 +375,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
>         virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
>  };
>
> -/**
> - * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
> - * @vq         : the struct virtqueue we're talking about
> - * @cmd                : command structure
> - * @req_size   : size of the request buffer
> - * @resp_size  : size of the response buffer
> - */
> -static int virtscsi_add_cmd(struct virtqueue *vq,
> +static int __virtscsi_add_cmd(struct virtqueue *vq,
>                             struct virtio_scsi_cmd *cmd,
>                             size_t req_size, size_t resp_size)
>  {
> @@ -427,17 +420,39 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
>         return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, GFP_ATOMIC);
>  }
>
> -static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
> +static void virtscsi_kick_vq(struct virtio_scsi_vq *vq)
> +{
> +       bool needs_kick;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&vq->vq_lock, flags);
> +       needs_kick = virtqueue_kick_prepare(vq->vq);
> +       spin_unlock_irqrestore(&vq->vq_lock, flags);
> +
> +       if (needs_kick)
> +               virtqueue_notify(vq->vq);
> +}
> +
> +/**
> + * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue, optionally kick it
> + * @vq         : the struct virtqueue we're talking about
> + * @cmd                : command structure
> + * @req_size   : size of the request buffer
> + * @resp_size  : size of the response buffer
> + * @kick       : whether to kick the virtqueue immediately
> + */
> +static int virtscsi_add_cmd(struct virtio_scsi_vq *vq,
>                              struct virtio_scsi_cmd *cmd,
> -                            size_t req_size, size_t resp_size)
> +                            size_t req_size, size_t resp_size,
> +                            bool kick)
>  {
>         unsigned long flags;
>         int err;
>         bool needs_kick = false;
>
>         spin_lock_irqsave(&vq->vq_lock, flags);
> -       err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
> -       if (!err)
> +       err = __virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size);
> +       if (!err && kick)
>                 needs_kick = virtqueue_kick_prepare(vq->vq);
>
>         spin_unlock_irqrestore(&vq->vq_lock, flags);
> @@ -502,6 +517,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>         struct virtio_scsi *vscsi = shost_priv(shost);
>         struct virtio_scsi_vq *req_vq = virtscsi_pick_vq_mq(vscsi, sc);
>         struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
> +       bool kick;
>         unsigned long flags;
>         int req_size;
>         int ret;
> @@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>                 req_size = sizeof(cmd->req.cmd);
>         }
>
> -       ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> +       kick = (sc->flags & SCMD_LAST) != 0;
> +       ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);
>         if (ret == -EIO) {
>                 cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
>                 spin_lock_irqsave(&req_vq->vq_lock, flags);
> @@ -549,8 +566,8 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>         int ret = FAILED;
>
>         cmd->comp = &comp;
> -       if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
> -                             sizeof cmd->req.tmf, sizeof cmd->resp.tmf) < 0)
> +       if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
> +                             sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
>                 goto out;
>
>         wait_for_completion(&comp);
> @@ -664,6 +681,13 @@ static int virtscsi_map_queues(struct Scsi_Host *shost)
>         return blk_mq_virtio_map_queues(qmap, vscsi->vdev, 2);
>  }
>
> +static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
> +{
> +       struct virtio_scsi *vscsi = shost_priv(shost);
> +
> +       virtscsi_kick_vq(&vscsi->req_vqs[hwq]);
> +}
> +
>  /*
>   * The host guarantees to respond to each command, although I/O
>   * latencies might be higher than on bare metal.  Reset the timer
> @@ -681,6 +705,7 @@ static struct scsi_host_template virtscsi_host_template = {
>         .this_id = -1,
>         .cmd_size = sizeof(struct virtio_scsi_cmd),
>         .queuecommand = virtscsi_queuecommand,
> +       .commit_rqs = virtscsi_commit_rqs,
>         .change_queue_depth = virtscsi_change_queue_depth,
>         .eh_abort_handler = virtscsi_abort,
>         .eh_device_reset_handler = virtscsi_device_reset,
> --
> 2.21.0
>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming Lei
