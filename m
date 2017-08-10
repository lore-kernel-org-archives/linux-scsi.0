From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/2] virtio: virtio_scsi: Set can_queue to the length
	of the virtqueue.
Date: Thu, 10 Aug 2017 18:58:02 +0200
Message-ID: <ff8e2e94-366c-a52d-af80-eadbca6a6a39@redhat.com>
References: <20170810165652.21515-1-rjones@redhat.com>
	<20170810165652.21515-3-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170810165652.21515-3-rjones@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Richard W.M. Jones" <rjones@redhat.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 18:56, Richard W.M. Jones wrote:
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
> 
> Thanks Paolo Bonzini, Christoph Hellwig.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 9be211d68b15..7c28e8d4955a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -818,7 +818,6 @@ static struct scsi_host_template virtscsi_host_template_single = {
>  	.eh_timed_out = virtscsi_eh_timed_out,
>  	.slave_alloc = virtscsi_device_alloc,
>  
> -	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
>  	.use_clustering = ENABLE_CLUSTERING,
>  	.target_alloc = virtscsi_target_alloc,
> @@ -839,7 +838,6 @@ static struct scsi_host_template virtscsi_host_template_multi = {
>  	.eh_timed_out = virtscsi_eh_timed_out,
>  	.slave_alloc = virtscsi_device_alloc,
>  
> -	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
>  	.use_clustering = ENABLE_CLUSTERING,
>  	.target_alloc = virtscsi_target_alloc,
> @@ -972,6 +970,8 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto virtscsi_init_failed;
>  
> +	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
> +
>  	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
>  	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
>  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
