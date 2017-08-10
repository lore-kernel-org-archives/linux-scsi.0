From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Thu, 10 Aug 2017 16:30:54 +0200
Message-ID: <367767f5-b3b2-6905-759d-d97196e7f140@redhat.com>
References: <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de> <20170805155103.GE20914@redhat.com>
 <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
 <20170807122701.GH20914@redhat.com>
 <ffc29e81-ff6b-7132-2e90-86b5632098fb@redhat.com>
 <20170809160111.GC3141@lst.de>
 <3b96a6c9-c5af-c50d-ba02-59863d1ee5f2@redhat.com>
 <20170810122232.GY20914@redhat.com>
 <63c286cb-4720-33a7-5fcd-e7591cd6dd2c@redhat.com>
 <20170810141634.GA20914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170810141634.GA20914@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 16:16, Richard W.M. Jones wrote:
> On Thu, Aug 10, 2017 at 02:53:58PM +0200, Paolo Bonzini wrote:
>> can_queue and cmd_per_lun are different.  can_queue should be set to the
>> value of vq->vring.num where vq is the command virtqueue (the first one
>> is okay if there's >1).
>>
>> If you want to change it, you'll have to do so in QEMU.
> 
> Here are a couple more patches I came up with, the first to Linux,
> the second to qemu.
> 
> There are a few problems ...
> 
> (1) Setting virtqueue_size to < 128 causes a BUG_ON failure in
> virtio_ring.c:virtqueue_add at:
> 
>     BUG_ON(total_sg > vq->vring.num);

That bug is bogus.  You can change it to

	WARN_ON_ONCE(total_sg > vq->vring.num && !vq->indirect);

and move it in the "else" here:

        if (vq->indirect && total_sg > 1 && vq->vq.num_free)
                desc = alloc_indirect(_vq, total_sg, gfp);
        else
                desc = NULL;

You just get a -ENOSPC after the WARN, so no need to crash the kernel!

> (2) Can/should the ctrl, event and cmd queue sizes be set to the same
> values?  Or should ctrl & event be left at 128?

It's okay if they're all the same.

> (3) It seems like it might be a problem that virtqueue_size is not
> passed through the virtio_scsi_conf struct (which is ABI between the
> kernel and qemu AFAICT and so not easily modifiable).  However I think
> this is not a problem because virtqueue size is stored in the
> Virtqueue Descriptor table, which is how the kernel gets the value.
> Is that right?

Yes.

Paolo

> Rich.
> 
> 
> --- kernel patch ---
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 9be211d68b15..d6b4ff634c0d 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -972,6 +972,8 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto virtscsi_init_failed;
>  
> +	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
> +
>  	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
>  	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
>  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
> 
> 
> --- qemu patch ---
> 
> diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
> index eb639442d1..aadd99aad1 100644
> --- a/hw/scsi/virtio-scsi.c
> +++ b/hw/scsi/virtio-scsi.c
> @@ -867,10 +867,10 @@ void virtio_scsi_common_realize(DeviceState *dev,
>      s->sense_size = VIRTIO_SCSI_SENSE_DEFAULT_SIZE;
>      s->cdb_size = VIRTIO_SCSI_CDB_DEFAULT_SIZE;
>  
> -    s->ctrl_vq = virtio_add_queue(vdev, VIRTIO_SCSI_VQ_SIZE, ctrl);
> -    s->event_vq = virtio_add_queue(vdev, VIRTIO_SCSI_VQ_SIZE, evt);
> +    s->ctrl_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, ctrl);
> +    s->event_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, evt);
>      for (i = 0; i < s->conf.num_queues; i++) {
> -        s->cmd_vqs[i] = virtio_add_queue(vdev, VIRTIO_SCSI_VQ_SIZE, cmd);
> +        s->cmd_vqs[i] = virtio_add_queue(vdev, s->conf.virtqueue_size, cmd);
>      }
>  }
>  
> @@ -917,6 +917,7 @@ static void virtio_scsi_device_unrealize(DeviceState *dev, Error **errp)
>  
>  static Property virtio_scsi_properties[] = {
>      DEFINE_PROP_UINT32("num_queues", VirtIOSCSI, parent_obj.conf.num_queues, 1),
> +    DEFINE_PROP_UINT32("virtqueue_size", VirtIOSCSI, parent_obj.conf.virtqueue_size, 128),
>      DEFINE_PROP_UINT32("max_sectors", VirtIOSCSI, parent_obj.conf.max_sectors,
>                                                    0xFFFF),
>      DEFINE_PROP_UINT32("cmd_per_lun", VirtIOSCSI, parent_obj.conf.cmd_per_lun,
> diff --git a/include/hw/virtio/virtio-scsi.h b/include/hw/virtio/virtio-scsi.h
> index de6ae5a9f6..e30a92d3e7 100644
> --- a/include/hw/virtio/virtio-scsi.h
> +++ b/include/hw/virtio/virtio-scsi.h
> @@ -48,6 +48,7 @@ typedef struct virtio_scsi_config VirtIOSCSIConfig;
>  
>  struct VirtIOSCSIConf {
>      uint32_t num_queues;
> +    uint32_t virtqueue_size;
>      uint32_t max_sectors;
>      uint32_t cmd_per_lun;
>  #ifdef CONFIG_VHOST_SCSI
> 
> 
