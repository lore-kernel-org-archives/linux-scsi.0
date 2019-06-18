From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/8] scsi: add a host / host template field for the virt boundary
Date: Tue, 18 Jun 2019 08:35:21 +0800
Message-ID: <CACVXFVOwCeM2JzefBpKsVZrEaWpSBR0DF8qp4oKfoHm+pwLBYw@mail.gmail.com>
References: <20190617122000.22181-1-hch@lst.de> <20190617122000.22181-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-2-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma <linux-rdma@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 17, 2019 at 8:21 PM Christoph Hellwig <hch@lst.de> wrote:
>
> This allows drivers setting it up easily instead of branching out to
> block layer calls in slave_alloc, and ensures the upgraded
> max_segment_size setting gets picked up by the DMA layer.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/hosts.c     | 3 +++
>  drivers/scsi/scsi_lib.c  | 3 ++-
>  include/scsi/scsi_host.h | 3 +++
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ff0d8c6a8d0c..55522b7162d3 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -462,6 +462,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>         else
>                 shost->dma_boundary = 0xffffffff;
>
> +       if (sht->virt_boundary_mask)
> +               shost->virt_boundary_mask = sht->virt_boundary_mask;
> +
>         device_initialize(&shost->shost_gendev);
>         dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>         shost->shost_gendev.bus = &scsi_bus_type;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 65d0a10c76ad..d333bb6b1c59 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1775,7 +1775,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>         dma_set_seg_boundary(dev, shost->dma_boundary);
>
>         blk_queue_max_segment_size(q, shost->max_segment_size);
> -       dma_set_max_seg_size(dev, shost->max_segment_size);
> +       blk_queue_virt_boundary(q, shost->virt_boundary_mask);
> +       dma_set_max_seg_size(dev, queue_max_segment_size(q));

The patch looks fine, also suggest to make sure that max_segment_size
is block-size aligned, and un-aligned max segment size has caused trouble
on mmc.

Thanks,
Ming Lei
