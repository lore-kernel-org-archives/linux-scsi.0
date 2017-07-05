From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH] virtio_scsi: always read VPD pages for multiqueue too
Date: Wed, 5 Jul 2017 16:43:55 +0800
Message-ID: <20170705084355.GD29382@lemon.lan>
References: <1499243456-29978-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499243456-29978-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, stefanha@redhat.com, stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
List-Id: linux-scsi@vger.kernel.org

On Wed, 07/05 10:30, Paolo Bonzini wrote:
> Multi-queue virtio-scsi uses a different scsi_host_template struct.
> Add the .device_alloc field there, too.
> 
> Fixes: 25d1d50e23275e141e3a3fe06c25a99f4c4bf4e0
> Cc: stable@vger.kernel.org
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f8dbfeee6c63..ad1e7f1aba4c 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -826,6 +826,7 @@ static int virtscsi_map_queues(struct Scsi_Host *shost)
>  	.change_queue_depth = virtscsi_change_queue_depth,
>  	.eh_abort_handler = virtscsi_abort,
>  	.eh_device_reset_handler = virtscsi_device_reset,
> +	.slave_alloc = virtscsi_device_alloc,
>  
>  	.can_queue = 1024,
>  	.dma_boundary = UINT_MAX,
> -- 
> 1.8.3.1
> 

Reviewed-by: Fam Zheng <famz@redhat.com>
