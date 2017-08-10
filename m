From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio: virtio_scsi: Set can_queue to the length of
 the virtqueue.
Date: Thu, 10 Aug 2017 18:46:05 +0200
Message-ID: <9d89d5ad-ed28-41a4-e3b9-ac96a93cf46a@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
 <20170810164035.19963-3-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170810164035.19963-3-rjones@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, mst@redhat.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 18:40, Richard W.M. Jones wrote:
> Since switching to blk-mq as the default in commit 5c279bd9e406
> ("scsi: default to scsi-mq"), virtio-scsi LUNs consume about 10x as
> much kernel memory.
> 
> qemu currently allocates a fixed 128 entry virtqueue.  can_queue
> currently is set to 1024.  But with indirect descriptors, each command
> in the queue takes 1 virtqueue entry, so the number of commands which
> can be queued is equal to the length of the virtqueue.
> 
> Note I intend to send a patch to qemu to allow the virtqueue size to
> be configured from the qemu command line.

You can clear .can_queue from the templates.  Otherwise looks good.

Paolo

> Thanks Paolo Bonzini, Christoph Hellwig.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 ++
>  1 file changed, 2 insertions(+)
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
